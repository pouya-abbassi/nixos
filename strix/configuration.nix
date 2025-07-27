{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = pkgs.sleek-grub-theme.override {
          withBanner = "PouyaCode";
          withStyle = "dark";
        };
      };
    };
  };

  networking = {
    enableIPv6 = true;
    nameservers = [
      "45.90.28.40"
      "45.90.30.40"
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
      plugins = (with pkgs; [
        networkmanager-openvpn
      ]);
    };
    hostName = "strix";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    nat = {
      enable = true;
      enableIPv6 = true;
    };

    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    firewall = rec {
      checkReversePath = "loose";
      logReversePathDrops = true;
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  # age = {
  #   identityPaths = [ "/root/.ssh/id_ed25519" ];
  #   secrets = {
  #     dnscrypt.file = ../secrets/dnscrypt.age;
  #   };
  # };

  # services.dnscrypt-proxy2 = {
  #   enable = true;
  #   configFile = config.age.secrets.dnscrypt.path;
  # };

  # systemd.services.dnscrypt-proxy2.serviceConfig = {
  #   StateDirectory = "dnscrypt-proxy";
  #   User = "root";
  # };

  users.users.pouya = {
    isNormalUser = true;
    description = "Pouya";
    extraGroups = [
      "audio"
      "dialout"
      "disk"
      "docker"
      "lp"
      "networkmanager"
      "scanner"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Steam Remote Play
      localNetworkGameTransfers.openFirewall = true; # Local Network Game Transfers
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce  ; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    gvfs.enable = true; # Thunar mount, trash, ethc.
    tumbler.enable = true; # Thunar image thumbnail
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };
  # Enable SANE to scan documents.
  # hardware.sane.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  hardware.ledger.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  services.udisks2.enable = true;

  virtualisation.docker.enable = true;

  services.clamav = {
    scanner = {
      enable = true;
      interval = "Sat *-*-* 15:00:00";
    };
    updater.enable = true;
    daemon.enable = true;
  };

  services.asusd = {
    enable = true;
    enableUserService = true;
    profileConfig.text = "balanced";
    fanCurvesConfig.source = ./rog/fan_curve.ron;
  };

  services.supergfxd = {
    enable = true;
    settings = builtins.readFile ./rog/supergfxd.conf;
  };

  services.syncthing = {
    enable = true;
    user = "pouya";
    group = "users";
    dataDir = "/home/pouya";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    settings = {
      options.urAccepted = -1;
      devices = {
        "x4" = { id = "D3VI3WJ-QLE7L4L-VSCUZQE-COORJYU-WAAQNU4-SRZAWBA-R5SYIUS-UYUUVAF"; };
        "s25" = { id = "GRN2FJF-ISRGNY4-NDTGNYW-5ZXMEPU-FOJXH4R-UZPQIHP-R5MKY5S-WU7UFAR"; };
      };
      folders = {
        "notes" = {
          path = "~/notes";
          devices = [ "x4" "s25" ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    ubuntu_font_family
    vazir-fonts
    xkcd-font
  ];

  system.stateVersion = "23.11";
}
