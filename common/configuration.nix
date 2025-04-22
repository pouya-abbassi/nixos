{ pkgs, lib, ... }:

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

  boot.tmp.cleanOnBoot = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [
        51820 # wg
      ];
      allowedUDPPortRanges = [
        { from = 32768; to = 60999; } # Tor Snowflake
      ];
    };
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.pouya.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
      strategy = [
        "history"
        "match_prev_cmd"
      ];
    };

    shellInit = "eval \"$(direnv hook zsh)\"";

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/src/nixos";
      ngc = "sudo nix-collect-garbage --delete-older-than 2d";
      nup = "sudo nix-channel --update";

      cat = "bat";
      noti = "noti -g -f ~/.config/noti.yaml";

      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
      "......" = "../../../../..";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      directory.truncate_to_repo = false;
      sudo.disabled = false;
      sudo.format = "[$symbol]($style)";
      git_branch.format = " [$symbol$branch(:$remote_branch)]($style) ";
      git_commit.only_detached = false;
      format = lib.concatStrings [
        "╭─ "
        "$username"
        "$hostname"
        "$directory"
        "$rust"
        "$go"
        "$terraform"
        "$package"
        "$nix_shell"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$cmd_duration"
        "$sudo"
        "$line_break"
        "$character"
      ];
      character = {
        success_symbol = "╰─[\\$](bold white)";
        error_symbol = "╰─[\\$](bold red)";
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    '' ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyvUJK9jI07Vp1jBNUvlOYjX2/QQy+gFtotGtNko4vt pouya@strix ''
    '' ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9ghAXnjzSQ47x5iswFUgivRwYUt2/r6qdI3GWToiEX pouya@poco ''
  ];

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
      overalljails = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    direnv
  ];

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
  };

  services.snowflake-proxy = {
    enable = true;
    capacity = 100;
  };

  nixpkgs.config.allowUnfree = true;
}
