{ pkgs, username, ... }:

{
  # ---------------------------------------------------------------------
  # System basics
  # ---------------------------------------------------------------------
  system.stateVersion = 5;
  nixpkgs.config.allowUnfree = true;

  # install-nix.sh bootstraps Nix through the Determinate Systems installer,
  # which ships its own daemon and Nix config. Telling nix-darwin to stay
  # out of `nix.*` management avoids the "Determinate detected, aborting
  # activation" error. If you ever switch to a non-Determinate Nix, set
  # nix.enable = true and uncomment the settings below.
  nix.enable = false;
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      # "none": keep anything manually-installed (taps/formulae/casks)
      # outside this file. Switch to "uninstall" or "zap" if you want
      # nix-darwin to enforce an exact list.
      cleanup    = "none";
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
