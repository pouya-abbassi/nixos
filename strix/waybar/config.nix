{
  mainBar = {
    layer = "top"; # Waybar at top layer
    position = "top"; # Waybar position (top|bottom|left|right)
    height = 24; # Waybar height (to be removed for auto height)
    spacing = 4; # Gaps between modules (4px)
    modules-left = [
      "hyprland/workspaces"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "idle_inhibitor"
      "custom/tomat"
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "temperature"
      "backlight"
      "battery"
      "clock"
      "tray"
    ];
    # Modules configuration
    "hyprland/workspaces" = {
      disable-scroll = true;
      # all-outputs = true;
      warp-on-scroll = false;
      on-click = "activate";
      urgent = "";
      active = "";
      # default = "";
      sort-by-number = true;
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      # "icon-size = 21;
      spacing = 5;
    };
    clock = {
      # timezone = "America/New_York";
      interval = 1;
      format = "{:%H:%M:%S}";
      tooltip-format = "<small>UTC: {tz_list}</small>\n<big>{:%F %a}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%Y-%m-%d}";
      timezones = [
        ""
        "UTC"
      ];
      calendar = {
        mode = "month";
        mode-mon-col = 3;
      };
      actions = {
        # on-scroll-up: "shift_up";
        # on-scroll-down: "shift_down";
        on-click-right = "mode";
      };
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory = {
      format = "{}% ";
    };
    temperature = {
      critical-threshold = 80;
      format = "{temperatureC}°C {icon}";
      format-icons = [ "" "" "" ];
    };
    backlight = {
      scroll-step = 5;
      format = "{percent}% {icon}";
      format-icons = [ "" "" "" "" "" "" "" "" "" ];
    };
    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-full = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = [ "" "" "" "" "" ];
    };
    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ipaddr}/{cidr} ";
      tooltip-format = "{ifname} via {gwaddr} ";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    pulseaudio = {
      scroll-step = 5;
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = " {icon} {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" "" ];
      };
      on-click = "pavucontrol";
    };
    "custom/tomat" = {
      exec = "tomat status";
      interval = 1;
      return-type = "json";
      format = "{text}";
      tooltip = true;
      on-click = "tomat toggle";
      on-click-right = "tomat skip";
    };
  };
}
