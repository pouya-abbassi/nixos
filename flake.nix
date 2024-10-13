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

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, stylix, fg42, deploy-rs, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./strix/configuration.nix
          ./strix/stylix.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pouya = import ./strix/home.nix;

            home-manager.extraSpecialArgs = { inherit fg42; };
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

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
