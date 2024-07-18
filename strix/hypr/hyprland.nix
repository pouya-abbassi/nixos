{
  # See https://wiki.hyprland.org/Configuring/Monitors/
  #monitor=,preferred,auto,auto
  #monitor=DP-1, 1920x1200, 320x0, 1
  monitor = [
    #"HDMI-A-1, 1920x1200, 320x0, 1"
    "DP-1, 1920x1200, 320x0, 1"
    "eDP-1, 2560x1440, 0x1200, 1"
  ];

  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  exec-once = [
    "waybar & nm-applet & hyprpaper & mako & udiskie & librewolf"
    "swayidle -w timeout 900  'hyprlock'"
  ];

  "$terminal" = "terminator";
  "$fileManager" = "pcmanfm";
  "$menu" = "rofi -show drun -show-icons -theme arthur";
  "$hyprshot" = "hyprshot -m output --clipboard-only";
  "$hyprlock" = "hyprlock";

  "env" = [
    "XCURSOR_SIZE,24"
    "QT_QPA_PLATFORMTHEME,qt5ct"
  ];

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input = {
    kb_layout = "us,ir";
    kb_variant = "dvorak,";
    kb_model = "";
    kb_options = "grp:shifts_toggle";
    kb_rules = "";
    numlock_by_default = true;

    follow_mouse = 1;

    touchpad = {
      natural_scroll = "no";
    };

    sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
  };

  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    "col.active_border" = "rgba(33ccffff) rgba(00ff99ff) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    layout = "dwindle";

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;
  };

  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  decoration =
    {
      rounding = 10;
      blur = {
        enabled = false;
        size = 3;
        passes = 1;
      };

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

  # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
  animations = {
    enabled = "yes";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
  dwindle = {
    pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = "yes"; # you probably want this
  };

  # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
  master = {
    new_status= "master";
  };

  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  gestures = {
    workspace_swipe = "off";
  };

  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  misc = {
    #force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
  };

  # Example per-device config
  # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
  device = {
    name = "epic-mouse-v1";
    sensitivity = -0.5;
  };

  # Example windowrule v1
  # windowrule = float, ^(kitty)$
  # Example windowrule v2
  # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
  # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
  windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.


  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  "$mainMod" = "SUPER";

  # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
  bind = [
    "$mainMod, RETURN, exec, $terminal"
    "$mainMod, Q, killactive,"
    #bind = "$mainMod, M, exit,"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, SPACE, togglefloating,"
    "$mainMod, D, exec, $menu"
    "$mainMod, P, pseudo," # dwindle
    "$mainMod, V, togglesplit," # dwindle
    "$mainMod, W, fullscreen,"
    ", PRINT, exec, $hyprshot"
    "$mainMod, DELETE, exec, $hyprlock"

    # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, h, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, l, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, k, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod, j, movefocus, d"

    # Move focused window
    "SUPER SHIFT, left, movewindow, l"
    "SUPER SHIFT, H, movewindow, l"
    "SUPER SHIFT, right, movewindow, r"
    "SUPER SHIFT, L, movewindow, r"
    "SUPER SHIFT, up, movewindow, u"
    "SUPER SHIFT, K, movewindow, u"
    "SUPER SHIFT, down, movewindow, d"
    "SUPER SHIFT, J, movewindow, d"

    # Switch workspaces with mainMod + [0-9]
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"

    # Example special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
}
