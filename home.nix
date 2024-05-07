{ config, pkgs, fg42, lib, ... }:

{
  home.username = "pouya";
  home.homeDirectory = "/home/pouya";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    ack
    aria2
    ark
    blender-hip
    btop
    calibre
    clojure
    clojure-lsp
    darktable
    dig
    dolphin
    dunst
    encfs
    ffmpeg
    fg42.outputs.packages.x86_64-linux.default
    file
    firefox
    gimp
    git
    gnome.gnome-disk-utility
    go
    gparted
    graphite-kde-theme
    hdparm
    htop
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    inkscape
    kate
    ledger-live-desktop
    libnotify
    librewolf
    libsForQt5.filelight
    libsForQt5.qt5ct
    libsForQt5.skanlite
    lxappearance
    lxappearance
    netcat
    networkmanagerapplet
    nix-tree
    nodePackages.svgo
    obs-studio
    parted
    pass
    pavucontrol
    pcmanfm
    pinentry-curses
    protonmail-bridge-gui
    protonvpn-cli
    protonvpn-gui
    ripgrep
    rofi-wayland
    siril
    slack
    smartmontools
    spotify
    sublime
    swayidle
    sxiv
    telegram-desktop
    terminator
    terraform
    thefuck
    thunderbird
    tig
    tldr
    tmux
    traceroute
    tree
    ungoogled-chromium
    unzip
    v2raya
    vim
    vlc
    wget
    wl-clipboard
    zafiro-icons
    zip
  ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.magit
    ];
  };

  programs.waybar = {
    enable = true;
    settings = import ./waybar/config.nix;
    style = builtins.readFile ./waybar/style.css;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkForce (import ./hypr/hyprland.nix);
    xwayland.enable = true;
  };

  home.file = {
    ".config/hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
    ".config/hypr/hyprpaper.conf".text = ''
      preload = ~/src/nixos/wall.jpg
      wallpaper = , ~/src/nixos/wall.jpg
      splash = false
      ipc = off
    '';

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
