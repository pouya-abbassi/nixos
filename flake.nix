{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/b667a340730dd3d0596083aa7c949eef01367c62";
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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeage = {
      url = "github:aarongpower/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    st.url = "github:siduck/st/a7582f9";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, stylix, fg42, deploy-rs, agenix, homeage, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      nativeBuildInputs = [
        agenix.packages.${system}.default
        deploy-rs.packages.${system}.default
      ];

      fg42 = inputs.fg42.homeManagerModules.${system};
      st = inputs.st.packages."${system}".st-snazzy.override {
        patches = [ ./strix/st-snazzy.patch ];
      };
    in
    rec {
      inherit pkgs;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
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
              home-manager.extraSpecialArgs = { inherit fg42 st system; };
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
