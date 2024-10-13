{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, stylix, fg42, deploy-rs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      nativeBuildInputs = with pkgs; [
        deploy-rs.packages.${system}.default
      ];
    in rec {
      inherit pkgs;
       nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./strix/configuration.nix
            ./strix/stylix.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pouya = import ./strix/home.nix;
              home-manager.extraSpecialArgs = { inherit fg42 system; };
            }
          ];
        };

        pouyacode = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./pouyacode/configuration.nix
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
