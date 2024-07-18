{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  users.users.pouya = {
    isNormalUser = true;
    description = "Pouya";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "disk" "scanner" "lp" ];
    packages = with pkgs; [
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.pouya.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = "eval \"$(direnv hook zsh)\"";

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/src/nixos";
      ngc = "sudo nix-collect-garbage --delete-older-than 2d";
      nup = "sudo nix-channel --update";

      cat = "bat";

      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
      "......" = "../../../../..";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "lein" "thefuck" ];
      theme = "bira";
    };
  };

  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
  services.locate.localuser = null;

  nixpkgs.config.allowUnfree = true;
}
