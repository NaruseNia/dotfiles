{
  description = "NaruseNia dev environment — Nix alternative to install-*.sh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Homebrew (for casks + fonts not in nixpkgs)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }:
    let
      # ---------------------------------------------------------------------
      # Personal config is loaded from ./user.nix (gitignored).
      # Copy ./user.example.nix to ./user.nix and edit before first use.
      # ---------------------------------------------------------------------
      userConfig =
        if builtins.pathExists ./user.nix
        then import ./user.nix
        else throw ''
          Missing nix/user.nix.
          Copy nix/user.example.nix → nix/user.nix and fill in your details.
        '';

      inherit (userConfig) username fullName email hostname darwinSystem linuxSystem;

      specialArgs = { inherit username fullName email; };

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # ---------------------------------------------------------------------
      # macOS: nix-darwin (system) + home-manager (user) + nix-homebrew (casks)
      # Build & apply:
      #   nix run github:LnL7/nix-darwin -- switch --flake .#${hostname}
      # ---------------------------------------------------------------------
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        inherit specialArgs;
        modules = [
          ./darwin.nix

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = username;
              autoMigrate = true;
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      # ---------------------------------------------------------------------
      # Linux: standalone home-manager (system PM still manages kernel/GUI)
      # Build & apply:
      #   nix run github:nix-community/home-manager -- switch --flake .#${username}@linux
      # ---------------------------------------------------------------------
      homeConfigurations."${username}@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs linuxSystem;
        extraSpecialArgs = specialArgs;
        modules = [ ./home.nix ];
      };
    };
}
