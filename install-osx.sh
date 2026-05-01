#!/usr/bin/env bash
#
# macOS Dev Environment Setup
#
# Re-exec under bash if invoked via `sh install-osx.sh`
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail
trap 'echo "[ERROR] line $LINENO" >&2' ERR

# ---------------------------------------------------------------------------
# Bootstrap: Xcode CLT → Homebrew → gum   (always runs)
# ---------------------------------------------------------------------------
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo "Accept the system dialog, then press Enter when it finishes."
  read -r _
  xcode-select -p &>/dev/null || { echo "Xcode CLT not detected — aborting."; exit 1; }
fi

if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ "$(uname -m)" == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v gum &>/dev/null; then
  echo "Installing gum..."
  brew install gum >/dev/null
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

# Run a command under a spinner; show captured output on failure.
# Returns the command's exit code (non-zero does NOT abort the script here).
spin_safe() {
  local title="$1"; shift
  if gum spin --show-error --spinner dot --title "$title" -- "$@"; then
    return 0
  fi
  return $?
}

brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" &>/dev/null; then
    info "✓ $pkg (already installed)"
    return 0
  fi
  if spin_safe "Installing $pkg..." brew install "$pkg"; then
    ok "✓ $pkg installed"
  else
    warn "✗ $pkg failed — skipping"
  fi
  return 0
}

cask_install() {
  local cask="$1"
  if brew list --cask "$cask" &>/dev/null; then
    info "✓ $cask (already installed)"
    return 0
  fi
  if spin_safe "Installing $cask..." brew install --cask "$cask"; then
    ok "✓ $cask installed"
  elif spin_safe "Retrying $cask with --adopt..." brew install --cask --adopt "$cask"; then
    ok "✓ $cask installed (adopted existing app)"
  else
    warn "✗ $cask failed — skipping"
  fi
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

# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------
run_update() {
  section "Updating Homebrew"
  spin "brew update..." brew update
}

run_bundle() {
  section "Installing everything via Brewfile"
  local brewfile
  brewfile="$(cd "$(dirname "$0")" && pwd)/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    warn "Brewfile not found at $brewfile — skipping"
    return 0
  fi
  if spin_safe "brew bundle..." brew bundle --file="$brewfile" --no-lock; then
    ok "✓ Brewfile applied"
  else
    warn "✗ brew bundle had errors — check output"
  fi
}

run_cli() {
  section "Installing CLI tools"
  local pkgs=(
    git ghq gcc gh wget curl tmux zellij
    fzf ripgrep bat eza neovim
    git-delta lazygit
    pinentry-mac sqlite
    lima qemu
  )
  for p in "${pkgs[@]}"; do brew_install "$p"; done
}

run_yazi() {
  section "Installing yazi + deps"
  local pkgs=(yazi ffmpeg-full sevenzip jq poppler fd zoxide resvg imagemagick-full)
  for p in "${pkgs[@]}"; do brew_install "$p"; done
  spin "Linking ffmpeg-full / imagemagick-full..." \
    brew link ffmpeg-full imagemagick-full -f --overwrite
  ok "✓ yazi deps linked"
}

run_casks() {
  section "Installing GUI apps"
  local casks=(
    ghostty
    betterdisplay
    docker-desktop
    vivaldi
    font-lilex-nerd-font
    font-symbols-only-nerd-font
  )
  for c in "${casks[@]}"; do cask_install "$c"; done
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
      spin "mise use -g $rt..." mise use -g "$rt"
      ok "✓ $rt installed"
    fi
  done
}

run_ai() {
  section "Installing AI tools"
  cask_install codex
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
    ssh-add --apple-use-keychain "$ssh_key" 2>/dev/null || ssh-add "$ssh_key"
    pbcopy < "${ssh_key}.pub"
    ok "✓ SSH key generated (public key copied to clipboard)"
  fi

  if gh auth status &>/dev/null; then
    info "✓ gh already authenticated"
  else
    warn "Launching interactive GitHub login (requesting admin:public_key scope)..."
    gh auth login -s admin:public_key
  fi

  # Ensure token has admin:public_key scope for SSH key upload
  if gh auth status 2>&1 | grep -q "admin:public_key"; then
    :
  else
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
    local name
    name=$(gum input --placeholder "Git user.name")
    git config --global user.name "$name"
  fi
  if ! git config --global --get user.email &>/dev/null; then
    local email
    email=$(gum input --placeholder "Git user.email")
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
  section "Applying macOS defaults"
  defaults write NSGlobalDomain KeyRepeat                  -int 2
  defaults write NSGlobalDomain InitialKeyRepeat           -int 15
  defaults write NSGlobalDomain AppleShowAllExtensions     -bool true
  defaults write com.apple.finder   AppleShowAllFiles      -bool true
  defaults write com.apple.finder   FXDefaultSearchScope   -string "SCcf"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.screencapture location          -string "$HOME/Pictures/Screenshots"
  mkdir -p "$HOME/Pictures/Screenshots"
  killall Finder         &>/dev/null || true
  killall SystemUIServer &>/dev/null || true
  ok "✓ macOS defaults applied (some changes need logout/restart)"
}

version_of() {
  # echo "<name> <version>" if the command exists; silent otherwise.
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
  for s in "${ran[@]}"; do
    printf "  • %s\n" "$s"
  done

  echo
  gum style --bold --foreground 99 "Installed tool versions"
  {
    version_of brew   brew
    version_of gum    gum
    version_of git    git
    version_of gh     gh
    version_of nvim   nvim
    version_of tmux   tmux
    version_of zellij zellij
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
  }

  echo
  gum style --bold --foreground 99 "Key paths"
  printf "  %-14s %s\n" "dotfiles"  "$HOME/.perpet"
  printf "  %-14s %s\n" "nvim"      "$HOME/.config/nvim"
  printf "  %-14s %s\n" "tpm"       "$HOME/.tmux/plugins/tpm"
  printf "  %-14s %s\n" "ssh key"   "$HOME/.ssh/id_ed25519"
  printf "  %-14s %s\n" "shell"     "$SHELL"

  echo
  gum style \
    --border rounded --margin "1" --padding "1 2" \
    --border-foreground 214 --foreground 214 \
    "Reminder: switch remotes of ~/.perpet and ~/.config/nvim to SSH if needed" \
    "  cd ~/.perpet      && git remote set-url origin git@github.com:NaruseNia/dotfiles.git" \
    "  cd ~/.config/nvim && git remote set-url origin git@github.com:NaruseNia/nvim.git" \
    "" \
    "Restart your terminal (or 'exec \$SHELL -l') to load new PATH / shell config."
}

# ---------------------------------------------------------------------------
# Section registry & CLI
# ---------------------------------------------------------------------------
SECTIONS=(update bundle cli yazi casks mise runtimes ai identity dotfiles nvim tmux defaults)

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [section ...]

Sections:
  update     Update Homebrew
  bundle     Install everything via Brewfile (brew bundle)
  cli        CLI tools (git, gh, fzf, ripgrep, neovim, lazygit, zellij, ...)
  yazi       yazi + dependencies
  casks      GUI apps (ghostty, vivaldi, docker-desktop, fonts, ...)
  mise       mise (runtime manager)
  runtimes   Runtimes via mise (node, python, bun, pnpm, deno, go, rust, zig)
  ai         AI tools (codex, claude, crmux)
  identity   SSH key + gh auth + git config
  dotfiles   perpet + dotfiles
  nvim       Neovim config + Lazy sync
  tmux       tmux plugin manager (tpm)
  defaults   macOS defaults

Options:
  -a, --all       Run all sections (non-interactive)
  -h, --help      Show this help

Examples:
  $(basename "$0")                 # interactive selection
  $(basename "$0") -a              # run everything
  $(basename "$0") cli casks ai    # run only listed sections
EOF
}

is_valid_section() {
  local s="$1"
  for x in "${SECTIONS[@]}"; do [[ "$x" == "$s" ]] && return 0; done
  return 1
}

# Parse args
to_run=()
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  -a|--all)  to_run=("${SECTIONS[@]}") ;;
  "")        ;;  # interactive below
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

# Header
gum style \
  --border double --margin "1" --padding "1 3" --align center \
  --border-foreground 212 --foreground 212 \
  "macOS Dev Environment Setup"

# Interactive selection if nothing specified
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

# Run
for s in "${to_run[@]}"; do "run_$s"; done
run_summary "${to_run[@]}"
