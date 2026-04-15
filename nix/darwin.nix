{ pkgs, username, ... }:

{
  # ---------------------------------------------------------------------
  # System basics
  # ---------------------------------------------------------------------
  system.stateVersion = 5;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix-darwin now requires this explicit pointer.
  system.primaryUser = username;

  # Touch ID for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # ---------------------------------------------------------------------
  # Primary user
  # ---------------------------------------------------------------------
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # ---------------------------------------------------------------------
  # Homebrew — casks & fonts only (formulae go through home-manager).
  # Equivalent to the `casks=( ... )` array in install-osx.sh.
  # ---------------------------------------------------------------------
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup    = "zap";   # removes any cask not declared here
      upgrade    = true;
    };

    casks = [
      "ghostty"
      "betterdisplay"
      "docker-desktop"
      "vivaldi"
      "codex"
      "font-lilex-nerd-font"
      "font-symbols-only-nerd-font"
    ];

    # Leave empty — formulae are provided via home-manager (home.nix).
    brews = [ ];
  };

  # ---------------------------------------------------------------------
  # macOS defaults (replaces `defaults write ...` in install-osx.sh)
  # ---------------------------------------------------------------------
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat              = 2;
      InitialKeyRepeat       = 15;
      AppleShowAllExtensions = true;
    };
    finder = {
      AppleShowAllFiles    = true;
      FXDefaultSearchScope = "SCcf";
    };
    screencapture.location = "~/Pictures/Screenshots";
  };

  # ---------------------------------------------------------------------
  # Base shell availability (zsh is the default on modern macOS).
  # ---------------------------------------------------------------------
  programs.zsh.enable = true;
}
