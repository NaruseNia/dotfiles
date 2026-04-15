#!/usr/bin/env bash
#
# Linux Dev Environment Setup
#
# Re-exec under bash if invoked via `sh install-linux.sh`
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail
trap 'echo "[ERROR] line $LINENO" >&2' ERR

# ---------------------------------------------------------------------------
# Pre-parse: --brew / -b (Linuxbrew mode)  — needed before bootstrap
# ---------------------------------------------------------------------------
USE_BREW=0
_args=()
for a in "$@"; do
  case "$a" in
    -b|--brew) USE_BREW=1 ;;
    *)         _args+=("$a") ;;
  esac
done
set -- "${_args[@]+"${_args[@]}"}"

# ---------------------------------------------------------------------------
# Detect package manager (always runs)
# ---------------------------------------------------------------------------
if   command -v pacman  &>/dev/null; then PM=pacman
elif command -v apt-get &>/dev/null; then PM=apt
elif command -v dnf     &>/dev/null; then PM=dnf
elif command -v zypper  &>/dev/null; then PM=zypper
else
  echo "No supported package manager found (pacman/apt/dnf/zypper)." >&2
  exit 1
fi

SUDO=""; [[ $EUID -ne 0 ]] && SUDO="sudo"

pm_update() {
  case "$PM" in
    apt)    $SUDO apt-get update ;;
    dnf)    $SUDO dnf check-update || true ;;
    pacman) $SUDO pacman -Sy --noconfirm ;;
    zypper) $SUDO zypper --non-interactive refresh ;;
  esac
}

pm_is_installed() {
  local p="$1"
  case "$PM" in
    apt)    dpkg -s "$p" &>/dev/null ;;
    dnf)    rpm -q "$p" &>/dev/null ;;
    pacman) pacman -Qi "$p" &>/dev/null ;;
    zypper) rpm -q "$p" &>/dev/null ;;
  esac
}

pm_install_raw() {
  case "$PM" in
    apt)    $SUDO apt-get install -y "$@" ;;
    dnf)    $SUDO dnf install -y "$@" ;;
    pacman) $SUDO pacman -S --noconfirm --needed "$@" ;;
    zypper) $SUDO zypper --non-interactive install "$@" ;;
  esac
}

# ---------------------------------------------------------------------------
# Bootstrap: build tools + gum
# ---------------------------------------------------------------------------
# Ensure base build tools for things like cargo/go builds and downloads.
case "$PM" in
  apt)    pm_is_installed build-essential || pm_install_raw build-essential curl ca-certificates ;;
  dnf)    $SUDO dnf groupinstall -y "Development Tools" 2>/dev/null || true; pm_install_raw curl ca-certificates ;;
  pacman) pm_is_installed base-devel || pm_install_raw base-devel curl ;;
  zypper) $SUDO zypper --non-interactive install -t pattern devel_basis || true; pm_install_raw curl ;;
esac

install_linuxbrew() {
  command -v brew &>/dev/null && return 0
  # Linuxbrew prereqs
  case "$PM" in
    apt)    pm_install_raw build-essential procps file git ;;
    dnf)    pm_install_raw procps-ng file git ;;
    pacman) pm_install_raw base-devel procps-ng file git ;;
    zypper) pm_install_raw procps file git ;;
  esac
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellcheck disable=SC2016
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

install_gum_via_pm() {
  case "$PM" in
    pacman)
      pm_install_raw gum
      ;;
    apt)
      $SUDO mkdir -p /etc/apt/keyrings
      curl -fsSL https://repo.charm.sh/apt/gpg.key | $SUDO gpg --dearmor -o /etc/apt/keyrings/charm.gpg
      echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
        | $SUDO tee /etc/apt/sources.list.d/charm.list >/dev/null
      $SUDO apt-get update
      pm_install_raw gum
      ;;
    dnf)
      echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | $SUDO tee /etc/yum.repos.d/charm.repo >/dev/null
      pm_install_raw gum
      ;;
    zypper)
      $SUDO zypper --non-interactive addrepo https://repo.charm.sh/yum/charm.repo || true
      $SUDO zypper --non-interactive --gpg-auto-import-keys refresh
      pm_install_raw gum
      ;;
  esac
}

install_gum() {
  command -v gum &>/dev/null && return 0
  if [[ "$USE_BREW" == "1" ]]; then
    install_linuxbrew
    brew install gum >/dev/null
  else
    install_gum_via_pm
  fi
}
install_gum

# Activate brew if installed (Linuxbrew default prefix)
if [[ "$USE_BREW" == "1" ]] && [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
section() { echo; gum style --bold --foreground 99 "$@"; }
info()    { gum style --foreground 244 "$@"; }
ok()      { gum style --foreground 42  "$@"; }
warn()    { gum style --foreground 214 "$@"; }
spin()    { gum spin --show-error --spinner dot --title "$1" -- "${@:2}"; }
spin_safe() {
  local title="$1"; shift
  gum spin --show-error --spinner dot --title "$title" -- "$@" || return $?
}

# Generic name → distro-specific name lookup
pkg_name() {
  # Usage: pkg_name <generic>  → prints the correct pkg name for current PM (or '-' to skip)
  local g="$1"
  case "$g:$PM" in
    # Differences only — anything not listed falls through to $g
    bat:apt)             echo bat ;;             # on older Ubuntu it's 'batcat'; accept risk
    fd:apt)              echo fd-find ;;
    fd:dnf)              echo fd-find ;;
    sqlite:apt)          echo sqlite3 ;;
    sqlite:dnf)          echo sqlite ;;
    sqlite:zypper)       echo sqlite3 ;;
    gh:apt)              echo gh ;;              # requires GitHub CLI apt repo on some versions
    gh:dnf)              echo gh ;;
    gh:pacman)           echo github-cli ;;
    sevenzip:apt)        echo p7zip-full ;;
    sevenzip:dnf)        echo p7zip ;;
    sevenzip:zypper)     echo p7zip ;;
    sevenzip:pacman)     echo p7zip ;;
    ffmpeg-full:*)       echo ffmpeg ;;
    imagemagick-full:*)  echo imagemagick ;;
    poppler:apt)         echo poppler-utils ;;
    poppler:dnf)         echo poppler-utils ;;
    poppler:zypper)      echo poppler-tools ;;
    poppler:pacman)      echo poppler ;;
    qemu:apt)            echo qemu-system-x86 ;;
    qemu:pacman)         echo qemu-full ;;
    resvg:*)             echo resvg ;;           # may not exist on some distros
    pinentry-mac:*)      echo - ;;               # skip on Linux
    gcc:apt)             echo - ;;               # already via build-essential
    gcc:pacman)          echo - ;;               # already via base-devel
    *) echo "$g" ;;
  esac
}

# Map generic names to brew formula names (most match 1:1).
brew_name() {
  case "$1" in
    sevenzip)         echo sevenzip ;;
    ffmpeg-full)      echo ffmpeg ;;
    imagemagick-full) echo imagemagick ;;
    pinentry-mac)     echo - ;;
    gcc)              echo - ;;
    xclip|wl-clipboard) echo - ;;   # no-op under brew (display server integration via host)
    *) echo "$1" ;;
  esac
}

brew_install() {
  local pkg="$1"
  [[ "$pkg" == "-" ]] && return 0
  if brew list --formula "$pkg" &>/dev/null; then
    info "✓ $pkg (already installed via brew)"
    return 0
  fi
  if spin_safe "Installing $pkg (brew)..." brew install "$pkg"; then
    ok "✓ $pkg installed (brew)"
  else
    warn "✗ $pkg failed — skipping"
  fi
  return 0
}

# Install a single-binary release from a GitHub repo tarball.
# Usage: github_bin_install <bin> <repo> <asset_regex> [archive_inner_path]
github_bin_install() {
  local bin="$1" repo="$2" regex="$3" inner="${4:-}"
  command -v "$bin" &>/dev/null && { info "✓ $bin (already on PATH)"; return 0; }
  local arch os; arch=$(uname -m); os=linux
  local tmp; tmp=$(mktemp -d)
  local url
  url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | grep -Eo "\"browser_download_url\":\s*\"[^\"]*$regex[^\"]*\"" \
        | head -1 | sed -E 's/.*"(https[^"]+)".*/\1/')
  if [[ -z "$url" ]]; then
    warn "✗ $bin: no matching release asset found in $repo (regex: $regex)"
    rm -rf "$tmp"; return 1
  fi
  if ! spin_safe "Downloading $bin from $repo..." curl -fsSL -o "$tmp/pkg" "$url"; then
    rm -rf "$tmp"; return 1
  fi
  mkdir -p "$HOME/.local/bin"
  case "$url" in
    *.tar.gz|*.tgz) tar -xzf "$tmp/pkg" -C "$tmp" ;;
    *.zip)          unzip -qo "$tmp/pkg" -d "$tmp" ;;
    *)              cp "$tmp/pkg" "$tmp/$bin"; chmod +x "$tmp/$bin" ;;
  esac
  local found
  if [[ -n "$inner" ]]; then
    found="$tmp/$inner"
  else
    found=$(find "$tmp" -type f -name "$bin" -perm -u+x 2>/dev/null | head -1)
    [[ -z "$found" ]] && found=$(find "$tmp" -type f -name "$bin" 2>/dev/null | head -1)
  fi
  if [[ -z "$found" || ! -f "$found" ]]; then
    warn "✗ $bin: binary not found in downloaded archive"
    rm -rf "$tmp"; return 1
  fi
  install -m 0755 "$found" "$HOME/.local/bin/$bin"
  ok "✓ $bin installed to ~/.local/bin (GitHub release)"
  rm -rf "$tmp"
}

pkg_install() {
  local generic="$1"

  # Linuxbrew mode
  if [[ "$USE_BREW" == "1" ]]; then
    local bn; bn=$(brew_name "$generic")
    [[ "$bn" == "-" ]] && { info "- $generic (not needed under brew)"; return 0; }
    brew_install "$bn"
    return 0
  fi

  # System package manager
  local resolved; resolved=$(pkg_name "$generic")
  [[ "$resolved" == "-" ]] && { info "- $generic (skipped on $PM)"; return 0; }
  if pm_is_installed "$resolved"; then
    info "✓ $resolved (already installed)"
    return 0
  fi
  if spin_safe "Installing $resolved..." bash -c "$(declare -f pm_install_raw); PM=$PM; SUDO='$SUDO'; pm_install_raw '$resolved'"; then
    ok "✓ $resolved installed"
    return 0
  fi

  # PM install failed — try GitHub release fallback for select tools
  case "$generic" in
    eza)       github_bin_install eza     eza-community/eza     "eza_x86_64-unknown-linux-gnu\\.tar\\.gz" ;;
    lazygit)   github_bin_install lazygit jesseduffield/lazygit "lazygit_.*_Linux_x86_64\\.tar\\.gz" ;;
    git-delta) github_bin_install delta   dandavison/delta      "delta-.*-x86_64-unknown-linux-gnu\\.tar\\.gz" ;;
    *)         warn "✗ $resolved failed — skipping" ;;
  esac
  return 0
}

remote_install() {
  local name="$1" check_cmd="$2" url="$3" shell="${4:-sh}"
  if command -v "$check_cmd" &>/dev/null; then
    info "✓ $name (already installed)"
    return 0
  fi
  if spin_safe "Installing $name..." bash -c "curl -fsSL '$url' | $shell"; then
    ok "✓ $name installed"
  else
    warn "✗ $name failed — skipping"
  fi
  return 0
}

# Cross-platform clipboard copy
clip_copy() {
  if   command -v wl-copy &>/dev/null; then wl-copy
  elif command -v xclip   &>/dev/null; then xclip -selection clipboard
  elif command -v xsel    &>/dev/null; then xsel --clipboard --input
  else cat; return 1
  fi
}

# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------
run_update() {
  section "Updating package index"
  spin "pm update..." bash -c "$(declare -f pm_update); PM=$PM; SUDO='$SUDO'; pm_update"
}

run_cli() {
  section "Installing CLI tools"
  local pkgs=(
    git ghq gcc gh wget curl tmux
    fzf ripgrep bat eza neovim
    git-delta lazygit
    pinentry-mac sqlite
    xclip wl-clipboard
    lima qemu
  )
  for p in "${pkgs[@]}"; do pkg_install "$p"; done

  # On Debian/Ubuntu, `bat` ships as `batcat` and `fd-find` as `fdfind`.
  # Create friendly symlinks under ~/.local/bin so scripts and muscle memory work.
  if [[ "$USE_BREW" != "1" && "$PM" == "apt" ]]; then
    mkdir -p "$HOME/.local/bin"
    if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
      ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
      ok "✓ bat → batcat symlink created in ~/.local/bin"
    fi
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
      ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
      ok "✓ fd → fdfind symlink created in ~/.local/bin"
    fi
  fi
}

run_yazi() {
  section "Installing yazi + deps"
  # yazi itself: Arch has `yazi` in extra; others install via cargo.
  local pkgs=(yazi ffmpeg-full sevenzip jq poppler fd zoxide resvg imagemagick-full)
  for p in "${pkgs[@]}"; do pkg_install "$p"; done
  if ! command -v yazi &>/dev/null && command -v cargo &>/dev/null; then
    warn "yazi not available via $PM — installing via cargo"
    spin_safe "cargo install yazi-fm yazi-cli..." cargo install --locked yazi-fm yazi-cli || \
      warn "✗ cargo install yazi failed — install manually later"
  fi
}

run_apps() {
  section "Installing GUI apps"

  # vivaldi
  case "$PM" in
    apt)
      if ! pm_is_installed vivaldi-stable; then
        $SUDO install -d -m 0755 /etc/apt/keyrings
        curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | \
          $SUDO gpg --dearmor -o /etc/apt/keyrings/vivaldi.gpg
        echo "deb [signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" \
          | $SUDO tee /etc/apt/sources.list.d/vivaldi.list >/dev/null
        $SUDO apt-get update
        pkg_install vivaldi-stable
      else info "✓ vivaldi (already installed)"; fi
      ;;
    dnf)    pkg_install "https://downloads.vivaldi.com/stable/vivaldi-stable.x86_64.rpm" ;;
    pacman)
      if command -v yay &>/dev/null; then
        spin_safe "Installing vivaldi via yay (AUR)..." yay -S --noconfirm vivaldi && ok "✓ vivaldi installed"
      elif command -v paru &>/dev/null; then
        spin_safe "Installing vivaldi via paru (AUR)..." paru -S --noconfirm vivaldi && ok "✓ vivaldi installed"
      else
        warn "vivaldi → AUR helper not found. Install yay/paru, then: yay -S vivaldi"
      fi
      ;;
    zypper) pkg_install "https://downloads.vivaldi.com/stable/vivaldi-stable.x86_64.rpm" ;;
  esac

  # ghostty
  case "$PM" in
    pacman) pkg_install ghostty ;;
    *)      warn "ghostty → no standard package. See https://ghostty.org/docs/install/binary" ;;
  esac

  # docker
  case "$PM" in
    apt)    pkg_install docker.io; pkg_install docker-compose-v2 ;;
    dnf)    pkg_install docker; pkg_install docker-compose ;;
    pacman) pkg_install docker; pkg_install docker-compose ;;
    zypper) pkg_install docker; pkg_install docker-compose ;;
  esac
  command -v docker &>/dev/null && $SUDO systemctl enable --now docker 2>/dev/null || true
  getent group docker &>/dev/null && $SUDO usermod -aG docker "$USER" 2>/dev/null || true

  # Nerd Font (Lilex + SymbolsOnly) — GitHub release
  local fonts_dir="$HOME/.local/share/fonts"
  mkdir -p "$fonts_dir"
  install_nerd_font() {
    local font="$1"
    if compgen -G "$fonts_dir/${font}*" >/dev/null; then
      info "✓ $font Nerd Font (already installed)"
      return 0
    fi
    local tmp; tmp=$(mktemp -d)
    if spin_safe "Fetching $font Nerd Font..." \
      curl -fsSL -o "$tmp/$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"; then
      unzip -qo "$tmp/$font.zip" -d "$fonts_dir/$font" >/dev/null || true
      ok "✓ $font Nerd Font installed"
    else
      warn "✗ $font Nerd Font fetch failed"
    fi
    rm -rf "$tmp"
  }
  pm_is_installed unzip || pkg_install unzip
  install_nerd_font Lilex
  install_nerd_font NerdFontsSymbolsOnly
  command -v fc-cache &>/dev/null && fc-cache -f "$fonts_dir" >/dev/null 2>&1 || true
}

run_mise() {
  section "Installing mise"
  remote_install "mise" "mise" "https://mise.run"
}

run_runtimes() {
  section "Installing runtimes via mise"
  command -v mise &>/dev/null || { warn "mise not installed — run 'mise' section first."; return 1; }
  local runtimes=(node python bun pnpm deno go rust zig)
  for rt in "${runtimes[@]}"; do
    if mise ls -g "$rt" 2>/dev/null | grep -q .; then
      info "✓ $rt (already installed)"
    else
      spin_safe "mise use -g $rt..." mise use -g "$rt" && ok "✓ $rt installed" || warn "✗ $rt failed"
    fi
  done
}

run_ai() {
  section "Installing AI tools"
  # codex: no official Linux cask → try npm global if node available, else skip.
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    if command -v codex &>/dev/null; then
      info "✓ codex (already installed)"
    else
      spin_safe "Installing codex via npm..." npm install -g @openai/codex && ok "✓ codex installed" \
        || warn "✗ codex failed — install manually"
    fi
  else
    warn "codex → requires node/npm (install runtimes first). Skipping."
  fi
  remote_install "claude" "claude" "https://claude.ai/install.sh" "bash"
  remote_install "crmux"  "crmux"  "https://raw.githubusercontent.com/maedana/crmux/main/install.sh"
}

run_identity() {
  section "Setting up identity & auth"

  local ssh_key="$HOME/.ssh/id_ed25519"
  if [[ -f "$ssh_key" ]]; then
    info "✓ SSH key already exists at $ssh_key"
  else
    local email
    email=$(gum input --placeholder "Email for SSH key (e.g. you@example.com)")
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$ssh_key"
    if clip_copy < "${ssh_key}.pub"; then
      ok "✓ SSH key generated (public key copied to clipboard)"
    else
      warn "No clipboard tool found — public key:"
      cat "${ssh_key}.pub"
    fi
  fi

  if gh auth status &>/dev/null; then
    info "✓ gh already authenticated"
  else
    warn "Launching interactive GitHub login (requesting admin:public_key scope)..."
    gh auth login -s admin:public_key
  fi

  if gh auth status 2>&1 | grep -q "admin:public_key"; then :; else
    warn "Refreshing gh token to add 'admin:public_key' scope..."
    gh auth refresh -h github.com -s admin:public_key
  fi

  if gh auth status &>/dev/null && [[ -f "${ssh_key}.pub" ]]; then
    local key_content
    key_content=$(awk '{print $2}' "${ssh_key}.pub")
    if gh ssh-key list 2>/dev/null | grep -q "$key_content"; then
      info "✓ SSH key already registered on GitHub"
    else
      if spin_safe "Uploading SSH key to GitHub..." gh ssh-key add "${ssh_key}.pub" -t "$(hostname)"; then
        ok "✓ SSH key uploaded to GitHub"
      else
        warn "✗ SSH key upload failed — upload manually: gh ssh-key add ${ssh_key}.pub"
      fi
    fi
  fi

  if ! git config --global --get user.name &>/dev/null; then
    local name; name=$(gum input --placeholder "Git user.name")
    git config --global user.name "$name"
  fi
  if ! git config --global --get user.email &>/dev/null; then
    local email; email=$(gum input --placeholder "Git user.email")
    git config --global user.email "$email"
  fi
  git config --global --get init.defaultBranch     >/dev/null 2>&1 || git config --global init.defaultBranch main
  git config --global --get core.pager             >/dev/null 2>&1 || git config --global core.pager delta
  git config --global --get interactive.diffFilter >/dev/null 2>&1 || git config --global interactive.diffFilter "delta --color-only"
  git config --global --get delta.navigate         >/dev/null 2>&1 || git config --global delta.navigate true
  git config --global --get merge.conflictstyle    >/dev/null 2>&1 || git config --global merge.conflictstyle zdiff3
  ok "✓ git config initialized"
}

run_dotfiles() {
  section "Installing perpet & applying dotfiles"
  remote_install "perpet" "perpet" "https://raw.githubusercontent.com/NaruseNia/perpet/main/scripts/install.sh"
  spin "perpet init..."  perpet init https://github.com/NaruseNia/dotfiles.git
  spin "perpet apply..." perpet apply --force
  ok "✓ dotfiles applied"
}

run_nvim() {
  section "Setting up Neovim"
  local dir="$HOME/.config/nvim"
  if [[ -d "$dir" ]]; then
    info "✓ nvim config already exists at $dir"
  else
    mkdir -p "$HOME/.config"
    spin "Cloning nvim config..." git clone https://github.com/NaruseNia/nvim.git "$dir"
    ok "✓ nvim config cloned"
  fi
  spin "Syncing Neovim plugins (Lazy sync)..." nvim --headless "+Lazy! sync" +qa
  ok "✓ Neovim plugins synced"
}

run_tmux() {
  section "Setting up tmux plugin manager"
  local dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$dir" ]]; then
    info "✓ tpm already installed"
  else
    spin "Cloning tpm..." git clone https://github.com/tmux-plugins/tpm "$dir"
    ok "✓ tpm installed (prefix + I inside tmux to fetch plugins)"
  fi
}

run_defaults() {
  section "Applying shell defaults"
  # Linux: much less to do. Enable services and set a couple of niceties.
  [[ -d "$HOME/Pictures" ]] || mkdir -p "$HOME/Pictures/Screenshots"
  info "✓ ~/Pictures/Screenshots ensured"
  # Make sure user is in docker group message
  if getent group docker &>/dev/null && id -nG "$USER" | grep -qw docker; then
    info "✓ $USER is in 'docker' group (re-login to take effect)"
  fi
  ok "✓ Linux defaults applied"
}

version_of() {
  local name="$1" cmd="$2" ver
  command -v "$cmd" &>/dev/null || return 0
  ver=$("$cmd" --version 2>/dev/null | head -1 || true)
  printf "  %-10s %s\n" "$name" "${ver:-(installed)}"
}

run_summary() {
  local ran=("$@")
  echo
  gum style \
    --border double --margin "1" --padding "1 3" --align center \
    --border-foreground 42 --foreground 42 --bold \
    "✓ All done"

  gum style --bold --foreground 99 "Sections executed"
  for s in "${ran[@]}"; do printf "  • %s\n" "$s"; done

  echo
  gum style --bold --foreground 99 "Installed tool versions"
  {
    version_of pm     "${PM}"
    version_of brew   brew
    version_of gum    gum
    version_of git    git
    version_of gh     gh
    version_of nvim   nvim
    version_of tmux   tmux
    version_of mise   mise
    version_of node   node
    version_of python python
    version_of bun    bun
    version_of pnpm   pnpm
    version_of deno   deno
    version_of go     go
    version_of rustc  rustc
    version_of zig    zig
    version_of perpet perpet
    version_of yazi   yazi
    version_of claude claude
    version_of crmux  crmux
    version_of docker docker
  }

  echo
  gum style --bold --foreground 99 "Key paths"
  printf "  %-14s %s\n" "pkg manager" "$PM$([[ $USE_BREW == 1 ]] && echo ' + Linuxbrew')"
  printf "  %-14s %s\n" "dotfiles"    "$HOME/.perpet"
  printf "  %-14s %s\n" "nvim"        "$HOME/.config/nvim"
  printf "  %-14s %s\n" "tpm"         "$HOME/.tmux/plugins/tpm"
  printf "  %-14s %s\n" "fonts"       "$HOME/.local/share/fonts"
  printf "  %-14s %s\n" "ssh key"     "$HOME/.ssh/id_ed25519"
  printf "  %-14s %s\n" "shell"       "$SHELL"

  echo
  gum style \
    --border rounded --margin "1" --padding "1 2" \
    --border-foreground 214 --foreground 214 \
    "Reminder: switch remotes of ~/.perpet and ~/.config/nvim to SSH if needed" \
    "  cd ~/.perpet      && git remote set-url origin git@github.com:NaruseNia/dotfiles.git" \
    "  cd ~/.config/nvim && git remote set-url origin git@github.com:NaruseNia/nvim.git" \
    "" \
    "Restart your terminal (or 'exec \$SHELL -l') to load new PATH / shell config." \
    "If you joined the 'docker' group, log out and back in for it to take effect."
}

# ---------------------------------------------------------------------------
# Section registry & CLI
# ---------------------------------------------------------------------------
SECTIONS=(update cli yazi apps mise runtimes ai identity dotfiles nvim tmux defaults)

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [section ...]

Detected package manager: $PM
Linuxbrew mode: $([[ $USE_BREW == 1 ]] && echo enabled || echo disabled)

Sections:
  update     Refresh package index
  cli        CLI tools (git, gh, fzf, ripgrep, neovim, lazygit, ...)
  yazi       yazi + dependencies
  apps       GUI apps (vivaldi, ghostty, docker, Nerd Fonts)
  mise       mise (runtime manager)
  runtimes   Runtimes via mise (node, python, bun, pnpm, deno, go, rust, zig)
  ai         AI tools (codex via npm, claude, crmux)
  identity   SSH key + gh auth + git config
  dotfiles   perpet + dotfiles
  nvim       Neovim config + Lazy sync
  tmux       tmux plugin manager (tpm)
  defaults   Linux defaults (minimal)

Options:
  -a, --all       Run all sections (non-interactive)
  -b, --brew      Use Linuxbrew (Homebrew on Linux) for CLI tool installs
  -h, --help      Show this help

Examples:
  $(basename "$0")                 # interactive selection
  $(basename "$0") -a              # run everything
  $(basename "$0") -a -b           # run everything using Linuxbrew
  $(basename "$0") cli apps ai     # run only listed sections
EOF
}

is_valid_section() {
  local s="$1"
  for x in "${SECTIONS[@]}"; do [[ "$x" == "$s" ]] && return 0; done
  return 1
}

to_run=()
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  -a|--all)  to_run=("${SECTIONS[@]}") ;;
  "")        ;;
  *)
    for arg in "$@"; do
      if is_valid_section "$arg"; then
        to_run+=("$arg")
      else
        echo "Unknown section: $arg" >&2
        usage
        exit 1
      fi
    done
    ;;
esac

gum style \
  --border double --margin "1" --padding "1 3" --align center \
  --border-foreground 212 --foreground 212 \
  "Linux Dev Environment Setup" \
  "Package manager: $PM$([[ $USE_BREW == 1 ]] && echo ' (+ Linuxbrew)')"

if [[ ${#to_run[@]} -eq 0 ]]; then
  selected=$(printf '%s\n' "${SECTIONS[@]}" | \
    gum choose --no-limit --height 15 \
      --header "Select sections to run (space=toggle, enter=confirm)" \
      --selected "$(IFS=,; echo "${SECTIONS[*]}")")
  if [[ -z "$selected" ]]; then
    info "Nothing selected. Aborted."
    exit 0
  fi
  while IFS= read -r line; do to_run+=("$line"); done <<< "$selected"
fi

for s in "${to_run[@]}"; do "run_$s"; done
run_summary "${to_run[@]}"
