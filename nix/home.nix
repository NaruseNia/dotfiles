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
  # Git (include-file pattern):
  # perpet owns ~/.gitconfig and sources this file via `[include] path =
  # ~/.config/git/nix.inc`. Portable, opinionated defaults live here;
  # personal identity (name / email / signing key) stays in perpet so each
  # machine can override. Settings in perpet's .gitconfig that appear AFTER
  # the include directive take precedence over anything here.
  xdg.configFile."git/nix.inc".text = ''
    [init]
        defaultBranch = main
    [pull]
        rebase = true
    [core]
        pager = delta
    [interactive]
        diffFilter = delta --color-only
    [delta]
        navigate = true
        dark = true
    [merge]
        conflictstyle = zdiff3
  '';

  # Disabled: the user's ~/.config/gh/config.yml already exists (from a
  # prior `gh auth login`) and home-manager refuses to overwrite files
  # it did not create. Replacing it would also nuke the auth token.
  # Re-enable only on a fresh machine where gh has not been used yet.
  # programs.gh = {
  #   enable = true;
  #   settings.git_protocol = "ssh";
  # };

  # Shell integrations — keep disabled while perpet owns .zshrc / zeno_zsh etc.
  # programs.fzf.enable = true;
  # programs.zoxide.enable = true;
  # programs.bat.enable = true;

  # ---------------------------------------------------------------------
  # mise (Nix × mise hybrid)
  #
  # - mise binary is provided through home.packages above.
  # - conf.d/nix.toml declares the "baseline" global runtimes in Nix so
  #   they travel with the flake. mise layers this with the imperative
  #   ~/.config/mise/config.toml (written by `mise use -g <tool>@<ver>`),
  #   and the latter takes precedence — so pins/overrides stay possible.
  # - home.activation.miseInstall runs `mise install` after activation to
  #   materialize anything missing.
  # ---------------------------------------------------------------------
  xdg.configFile."mise/conf.d/nix.toml".text = ''
    [tools]
    node   = "latest"
    python = "latest"
    bun    = "latest"
    pnpm   = "latest"
    deno   = "latest"
    go     = "latest"
    rust   = "latest"
    zig    = "latest"
  '';

  home.activation.miseInstall = lib.hm.dag.entryAfter [ "installPackages" "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.mise}/bin/mise install --yes || true
  '';

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
