{ inputs, pkgs, ... }:
{
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];
    plugins = [ ];
    # Disable packages, since we are using NixOS module.
    package = null;
    portalPackage = null;
    settings = {
      monitor = [
        "HDMI-A-1,1920x1080@60,0x0,1,transform,3"
        "DP-1,2560x1440@165,1080x0,1"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,18"
        "XCURSOR_THEME,macOS"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "NVD_BACKEND,direct"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
      ];

      # Binds section
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "pkill rofi || rofi -show drun -modes drun,window,ssh -show-icons";

      exec-once = [
        "waybar & dunst & blueman-applet &"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 1;
        layout = "dwindle";
      };

      decoration = {
        rounding = 4;
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          # "workspaces,1,1.94,almostLinear,fade"
          # "workspacesIn,1,1.21,almostLinear,fade"
          # "workspacesOut,1,1.94,almostLinear,fade"
          "workspaces,1,1.94,default,slide"
        ];

      };

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "opacity 0.85 0.85,class:.*$terminal.*"
      ];

      input = {
        kb_layout = "us, ru";
        kb_options = "grp:ctrl_space_toggle";
        follow_mouse = 1;
      };

      device = [
        {
          name = "pulsar-4k-dongle";
          sensitivity = -1.5;
        }
        {
          name = "pulsar-mouse";
          sensitivity = -1.5;
        }
      ];

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      bind = [
        # Session control
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen"
        # Screencapture
        "SUPER_CTRL_SHIFT, 4, exec, hyprshot -m region --clipboard-only"
        "SUPER_CTRL, 4, exec, hyprshot -m region -o /home/mattephi/Pictures/Hyprshot"
        "SUPER_CTRL_SHIFT, 3, exec, hyprshot -m output --clipboard-only"
        "SUPER_CTRL, 3, exec, hyprshot -m output -o /home/mattephi/Pictures/Hyprshot"
        # Scratchpad
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
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
        # App Management
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, SPACE, exec, $menu"
        # Window Movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    # NOTE: It is impossible to convert all the binds because
    # of the issues with submaps syntax, which is currently not
    # implemented in the home-manager module.
    extraConfig = '''';
  };
}
