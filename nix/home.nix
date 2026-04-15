{ pkgs, lib, username, fullName, email, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux  = pkgs.stdenv.isLinux;
in
{
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "24.11";

  # ---------------------------------------------------------------------
  # Packages (equivalent to brew formulae in install-osx.sh)
  # ---------------------------------------------------------------------
  home.packages = with pkgs; [
    # Core CLI
    git ghq gh wget curl tmux
    fzf ripgrep bat eza neovim
    delta lazygit
    sqlite

    # yazi + dependencies
    yazi ffmpeg p7zip jq poppler fd zoxide resvg imagemagick

    # Runtime version manager (per-project / global runtimes)
    mise

    # Shell helper (gum) — used by the imperative scripts
    gum
  ]
  ++ lib.optionals isDarwin [
    pinentry_mac
  ]
  ++ lib.optionals isLinux [
    xclip
    wl-clipboard
  ];

  # ---------------------------------------------------------------------
  # Programs — declarative shell/tool configs.
  # NOTE: these generate files under ~/ and ~/.config/*. If perpet (or any
  #       other tool) already manages the same target, home-manager will
  #       refuse to overwrite it. Leave the corresponding block commented
  #       until you retire perpet or remove the conflicting file.
  # ---------------------------------------------------------------------
  # Disabled: perpet currently manages ~/.gitconfig (see home/.gitconfig).
  # Re-enable this block (and remove .gitconfig from perpet) if/when you
  # want home-manager to own Git config instead.
  # programs.git = {
  #   enable = true;
  #   userName  = fullName;
  #   userEmail = email;
  #   delta.enable = true;
  #   extraConfig = {
  #     init.defaultBranch = "main";
  #     merge.conflictstyle = "zdiff3";
  #     pull.rebase = true;
  #   };
  # };

  # gh has no perpet-managed counterpart, so this is safe to leave enabled.
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Shell integrations — keep disabled while perpet owns .zshrc / zeno_zsh etc.
  # programs.fzf.enable = true;
  # programs.zoxide.enable = true;
  # programs.bat.enable = true;

  # ---------------------------------------------------------------------
  # External git-based configs (nvim / tpm) — kept as git clones rather than
  # translated into programs.neovim / programs.tmux so you can iterate on
  # them outside Nix.
  # ---------------------------------------------------------------------
  home.activation.cloneNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/nvim" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/NaruseNia/nvim.git "$HOME/.config/nvim"
    fi
  '';

  home.activation.cloneTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}
