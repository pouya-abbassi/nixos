{ pkgs, lib, st, ... }:

{
  home.username = "pouya";
  home.homeDirectory = "/home/pouya";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # utils
    ack
    aria2
    asusctl
    bat
    btop
    dig
    encfs
    ffmpeg
    file
    git
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
    papeer
    parted
    pass
    pciutils
    pinentry-curses
    ripgrep
    smartmontools
    sshfs
    thefuck
    tldr
    traceroute
    tree
    udiskie
    udisks
    unzip
    usbutils
    v2raya
    wget
    whois
    xorg.xhost
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
    ffmpegthumbnailer
    gimp
    gnome-disk-utility
    gparted
    graphite-kde-theme
    hiddify-app
    inkscape
    ledger-live-desktop
    libreoffice
    libsForQt5.filelight
    libsForQt5.qt5ct
    libsForQt5.skanlite
    loupe
    lxappearance
    pavucontrol
    pcmanfm
    siril
    slack
    spotify
    st
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
    chromium
  ];

  programs = {
    zsh = {
      enable = true;
      autocd = true;
      defaultKeymap = "emacs";
      oh-my-zsh.enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 100000;
      keyMode = "emacs";
      baseIndex = 1;
      plugins = (with pkgs.tmuxPlugins; [
        {
          plugin = jump;
        }
        {
          plugin = tmux-thumbs;
          extraConfig = ''
            set -g @thumbs-key t
            set -g @thumbs-unique enabled
            set -g @thumbs-command 'echo -n {} | wl-copy'
          '';
        }
        {
          plugin = nord;
          extraConfig = ''
            set -g @plugin "arcticicestudio/nord-tmux"
          '';
        }
      ]);
      extraConfig = ''
        bind  c  new-window      -c "#{pane_current_path}"
        bind  %  split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        set -g renumber-windows on
      '';
    };

    fg42 = {
      enable = true;
      extraModules = [
        {
          fg42.fonts = [
            pkgs.udev-gothic-nf
          ];

          fg42.font = {
            name = "JetBrainsMono Nerd Font";
            size = 11;
          };
        }
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

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
      ];
    };

    home-manager.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkForce (import ./hypr/hyprland.nix);
    xwayland.enable = true;
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = import ./hypr/hyprpaper.nix;
    };

    gnome-keyring.enable = true;

    mpris-proxy.enable = true;

    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  homeage = {
    identityPaths = [ "~/.ssh/id_ed25519" ];
    installationType = "activation";

    file."noti" = {
      source = ../secrets/noti.age;
      symlinks = [ "/home/pouya/.config/noti.yaml" ];
    };
  };

}
