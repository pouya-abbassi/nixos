{ config, pkgs, lib, ... }:

{
  home.username = "pouya";
  home.homeDirectory = "/home/pouya";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # utils
    ack
    aria2
    bat
    btop
    dig
    file
    gnupg
    htop
    iotop
    killall
    lsof
    mlocate
    netcat
    nethogs
    nix-tree
    parted
    ripgrep
    sshfs
    tmux
    traceroute
    tree
    unzip
    wget
    whois
    zip
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ../common/vimrc;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
