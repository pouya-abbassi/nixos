{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    legacy.url = "github:nixos/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fg42 = {
      url = "git+https://git.sr.ht/~lxsameer/FG42";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeage = {
      url = "github:aarongpower/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, legacy, home-manager, stylix, fg42, deploy-rs, agenix, homeage, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      legacypkgs = import legacy {
        inherit system;
        config.allowUnfree = true;
      };

      nativeBuildInputs = [
        agenix.packages.${system}.default
        deploy-rs.packages.${system}.default
      ];

      fg42 = inputs.fg42.homeManagerModules.${system};
      st = pkgs.st-snazzy.overrideDerivation (oldAttrs: {
        patches = [ ./strix/st-snazzy.patch ];
      });
      hiddify = legacypkgs.hiddify-app;
    in
    rec {
      inherit pkgs;
      nixosConfigurations = {
        strix = nixpkgs.lib.nixosSystem {
          modules = [
            ./strix/configuration.nix
            ./strix/stylix.nix
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pouya.imports = [
                ./strix/home.nix
                fg42.default
                homeage.homeManagerModules.homeage
              ];
              home-manager.sharedModules = [{
                stylix.targets.hyprlock.enable = false;
              }];
              home-manager.extraSpecialArgs = { inherit fg42 st hiddify system; };
            }
          ];
        };

        pouyacode = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./pouyacode/configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pouya = import ./pouyacode/home.nix;
            }
          ];
        };
      };

      deploy.nodes.pouyacode = {
        hostname = "pouyacode.net";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pouyacode;
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit nativeBuildInputs;
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
