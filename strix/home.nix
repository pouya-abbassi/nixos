{ config, pkgs, fg42, lib, ... }:

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
    encfs
    ffmpeg
    file
    gnupg
    hdparm
    htop
    iotop
    killall
    lsof
    mlocate
    mtr
    netcat
    nethogs
    nix-tree
    noti
    parted
    pass
    pciutils
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
    usbutils
    v2raya
    wget
    whois
    zip
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting

    # desktop
    dunst
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    libnotify
    networkmanagerapplet
    nvtopPackages.amd
    rofi-wayland
    swayidle
    wl-clipboard

    # gui
    ark
    blender-hip
    calibre
    darktable
    dolphin
    evince
    gimp
    gnome-disk-utility
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
    protonup-qt
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
    fg42.outputs.packages.${system}.default
    git
    nodePackages.svgo
    nodejs_22
    terraform
    tig
    virtualenv
  ];

  programs = {
    zsh = {
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake ~/src/nixos";
        ngc = "sudo nix-collect-garbage --delete-older-than 2d";
        nup = "sudo nix-channel --update";
        cat = "bat";
        noti = "noti -g -f ~/.config/noti.yaml";
      };
      localVariables = {
        EDITOR = "vim";
      };
    };
    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.magit
      ];
    };
    vim = {
      enable = true;
      extraConfig = builtins.readFile ../common/vimrc;
    };
    waybar = {
      enable = true;
      settings = import ./waybar/config.nix;
      style = builtins.readFile ./waybar/style.css;
    };
    hyprlock = {
      enable = true;
      settings = import ./hypr/hyprlock.nix;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    home-manager.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkForce (import ./hypr/hyprland.nix);
    xwayland.enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = import ./hypr/hyprpaper.nix;
  };

  services.gnome-keyring.enable = true;

  services.mpris-proxy.enable = true;

  homeage = {
    identityPaths = [ "~/.ssh/id_ed25519" ];
    installationType = "activation";

    file."noti" = {
      source = ../secrets/noti.age;
      symlinks = [ "/home/pouya/.config/noti.yaml" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
