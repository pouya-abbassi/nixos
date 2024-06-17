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

    # utils
    ack
    aria2
    btop
    dig
    encfs
    ffmpeg
    file
    hdparm
    htop
    iotop
    netcat
    nix-tree
    parted
    pass
    pinentry-curses
    protonvpn-cli
    ripgrep
    smartmontools
    sshfs
    thefuck
    tldr
    tmux
    traceroute
    tree
    udiskie
    udisks
    unzip
    v2raya
    wget
    zip

    # desktop
    dunst
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    libnotify
    networkmanagerapplet
    rofi-wayland
    swayidle
    wl-clipboard

    # gui
    ark
    blender-hip
    calibre
    darktable
    dolphin
    gimp
    gnome.gnome-disk-utility
    gparted
    graphite-kde-theme
    inkscape
    ledger-live-desktop
    libreoffice
    libsForQt5.filelight
    libsForQt5.qt5ct
    libsForQt5.skanlite
    loupe
    lxappearance
    obs-studio
    pavucontrol
    pcmanfm
    protonmail-bridge-gui
    protonvpn-gui
    siril
    slack
    spotify
    sublime
    telegram-desktop
    terminator
    thunderbird
    ventoy
    vlc
    zafiro-icons

    # browsers
    firefox
    librewolf
    ungoogled-chromium

    # code
    ansible
    awscli2
    clang-tools
    clojure
    clojure-lsp
    fg42.outputs.packages.x86_64-linux.default
    git
    nodePackages.svgo
    nodejs_22
    terraform
    tig
    vim
    virtualenv
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

  programs.hyprlock = {
    enable = true;
    settings = import ./hypr/hyprlock.nix;
  };

  services.hyprpaper = {
    enable = true;
    settings = import ./hypr/hyprpaper.nix;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
