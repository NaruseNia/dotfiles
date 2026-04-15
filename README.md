# dotfiles

Dev environment configs for macOS and Linux. Three setup paths are available —
pick whichever fits your taste.

## Setup paths

| Path | OS | Package layer | Dotfile layer | Entry |
|------|----|---------------|---------------|-------|
| `install-osx.sh` | macOS | Homebrew | [perpet](https://github.com/NaruseNia/perpet) | `./install-osx.sh` |
| `install-linux.sh` | Linux | system PM or Linuxbrew | perpet | `./install-linux.sh` |
| `install-nix.sh` | macOS + Linux | Nix + home-manager (+ Homebrew casks on macOS) | home-manager (perpet optional) | `./install-nix.sh` |

Each entry point is self-contained — you don't run them together.

## Personal git identity (any path)

`home/.gitconfig` intentionally contains **no** personal identity — the
committed file only wires up includes. Drop your identity into
`~/.gitconfig.local`, which is never touched by this repo:

```ini
[user]
	name = Your Name
	email = you@example.com
	signingkey = XXXXXXXXXXXXXXXX
[gpg]
	program = gpg
[commit]
	gpgsign = true
[tag]
	gpgsign = true
```

Git silently skips missing includes, so a machine without this file still
works — git just won't know who you are until you create it.

## 1. Shell-script + Homebrew (macOS)

```sh
./install-osx.sh            # interactive section selection
./install-osx.sh -a         # run all sections non-interactively
./install-osx.sh cli casks  # run only the specified sections
./install-osx.sh -h         # list sections
```

The script bootstraps Xcode Command Line Tools, Homebrew, and `gum`, then
installs CLI tools, GUI apps (casks), language runtimes via `mise`, AI tools
(codex, claude, crmux), and applies dotfiles through perpet. It also generates
an SSH key, authenticates `gh`, uploads the key to GitHub, and sets sensible
macOS defaults.

## 2. Shell-script + system PM / Linuxbrew (Linux)

```sh
./install-linux.sh            # system package manager (apt/dnf/pacman/zypper)
./install-linux.sh -a -b      # Linuxbrew mode (Homebrew on Linux)
./install-linux.sh cli apps   # specific sections only
./install-linux.sh -h         # list sections
```

The script auto-detects `apt`, `dnf`, `pacman`, or `zypper`. With `-b` /
`--brew` it bootstraps Linuxbrew and uses Homebrew for CLI tools — giving you
the same package names as macOS. It also installs Nerd Fonts from GitHub
releases, fixes Ubuntu's `batcat`/`fdfind` binary names via symlinks, and falls
back to GitHub release binaries for `eza`, `lazygit`, and `git-delta` when they
aren't in the default repositories.

## 3. Nix (macOS + Linux)

Declarative alternative to paths 1 and 2. Manages packages, shell programs,
macOS defaults, and Homebrew casks from a single `flake.nix`.

```sh
./install-nix.sh
```

On macOS this runs `nix-darwin` + `home-manager` + `nix-homebrew`. On Linux it
runs standalone `home-manager` (system packages / GUI apps still come from your
distro).

### First-time setup

```sh
cp nix/user.example.nix nix/user.nix
# edit nix/user.nix — set username, fullName, email, hostname, system
./install-nix.sh
```

`nix/user.nix` is gitignored so your personal info never leaves your machine.

### Rebuilding later

```sh
# macOS
sudo darwin-rebuild switch --flake path:$HOME/.perpet/nix#<hostname>

# Linux
home-manager switch --flake path:$HOME/.perpet/nix#<username>@linux
```

The `path:` URL scheme is required because `nix/user.nix` is gitignored —
without it the flake evaluator would not see the file.

### Layout

```
nix/
├── flake.nix         # inputs/outputs, reads user.nix
├── user.example.nix  # template (committed)
├── user.nix          # your values (gitignored — create this)
├── home.nix          # home-manager: CLI packages, git, gh, nvim/tpm clones
└── darwin.nix        # nix-darwin: casks, macOS defaults, Touch ID sudo
```

### perpet compatibility

`nix/home.nix` keeps `programs.*` minimal (only `programs.git` and
`programs.gh`, which manage global config that doesn't overlap with typical
perpet-managed dotfiles). Richer modules like `programs.fzf` / `programs.bat`
are left commented out — enable them only when you retire perpet or verify
there's no conflict.

## Legacy / dotfiles-only

If you just want the dotfiles without the installer scripts, perpet alone still
works:

```sh
curl -fsSL https://raw.githubusercontent.com/NaruseNia/perpet/main/scripts/install.sh | sh
perpet init https://github.com/NaruseNia/dotfiles.git
perpet apply --force
```
