{ inputs, pkgs, ... }:
{
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];
    plugins = [ pkgs.hyprlandPlugins.hyprscroller ];
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

      exec-once = [
        "waybar & dunst & blueman-applet &"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 1;
        "col.active_border" = "rgba(ff6550ee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "scroller";
      };

      decoration = {
        rounding = 3;
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
          "workspaces,1,1.94,almostLinear,fade"
          "workspacesIn,1,1.21,almostLinear,fade"
          "workspacesOut,1,1.94,almostLinear,fade"
        ];

      };

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
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
          name = "heatmoving-pulsar-mouse";
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

      # Binds section
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "pkill rofi || rofi -matching fuzzy -show drun -modes drun,window,ssh -show-icons";

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
        "$mainMod, T, exec, $terminal"
        "$mainMod, SPACE, exec, $menu"
        # Window Movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        # Hyprscroller
        "$mainMod, slash, scroller:jump"
        # Hyprscroller:movement
        "$mainMod CTRL, left, movewindow, l"
        "$mainMod CTRL, right, movewindow, r"
        "$mainMod CTRL, up, movewindow, u"
        "$mainMod CTRL, down, movewindow, d"
        "$mainMod ALT, left, movewindow, l, nomode"
        "$mainMod ALT, right, movewindow, r, nomode"
        "$mainMod ALT, up, movewindow, u, nomode"
        "$mainMod ALT, down, movewindow, d, nomode"
        # Hyprscoller:modes
        "$mainMod, bracketleft, scroller:setmode, row"
        "$mainMod, bracketright, scroller:setmode, col"
        "$mainMod, P, scroller:pin"
        "$mainMod, tab, scroller:toggleoverview"
        "$mainMod, I, scroller:admitwindow,"
        "$mainMod, O, scroller:expelwindow,"
        "$mainMod SHIFT, I, scroller:admitwindow, r"
        "$mainMod SHIFT, O, scroller:expelwindow, l"
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
    extraConfig = ''
      # Hyprscroller Submaps

      # Sizes submap
      # will switch to a submap called sizing
      bind = $mainMod, r, submap, sizing
      # will start a submap called "align"
      submap = sizing
      # sets repeatable binds for aligning the active window
      bind = , 1, scroller:setsize, oneeighth
      bind = , 1, submap, reset
      bind = , 2, scroller:setsize, onesixth
      bind = , 2, submap, reset
      bind = , 3, scroller:setsize, onefourth
      bind = , 3, submap, reset
      bind = , 4, scroller:setsize, onethird
      bind = , 4, submap, reset
      bind = , 5, scroller:setsize, threeeighths
      bind = , 5, submap, reset
      bind = , 6, scroller:setsize, onehalf
      bind = , 6, submap, reset
      bind = , 7, scroller:setsize, fiveeighths
      bind = , 7, submap, reset
      bind = , 8, scroller:setsize, twothirds
      bind = , 8, submap, reset
      bind = , 9, scroller:setsize, threequarters
      bind = , 9, submap, reset
      bind = , 0, scroller:setsize, fivesixths
      bind = , 0, submap, reset
      bind = , minus, scroller:setsize, seveneighths
      bind = , minus, submap, reset
      bind = , equal, scroller:setsize, one
      bind = , equal, submap, reset
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # Center submap
      # will switch to a submap called center
      bind = $mainMod, C, submap, center
      # will start a submap called "center"
      submap = center
      # sets repeatable binds for resizing the active window
      bind = , C, scroller:alignwindow, c
      bind = , C, submap, reset
      bind = , m, scroller:alignwindow, m
      bind = , m, submap, reset
      bind = , right, scroller:alignwindow, r
      bind = , right, submap, reset
      bind = , left, scroller:alignwindow, l
      bind = , left, submap, reset
      bind = , up, scroller:alignwindow, u
      bind = , up, submap, reset
      bind = , down, scroller:alignwindow, d
      bind = , down, submap, reset
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # Fit size submap
      # will switch to a submap called fitsize
      bind = $mainMod, W, submap, fitsize
      # will start a submap called "fitsize"
      submap = fitsize
      # sets binds for fitting columns/windows in the screen
      bind = , W, scroller:fitsize, visible
      bind = , W, submap, reset
      bind = , right, scroller:fitsize, toend
      bind = , right, submap, reset
      bind = , left, scroller:fitsize, tobeg
      bind = , left, submap, reset
      bind = , up, scroller:fitsize, active
      bind = , up, submap, reset
      bind = , down, scroller:fitsize, all
      bind = , down, submap, reset
      bind = , bracketleft, scroller:fitwidth, all
      bind = , bracketleft, submap, reset
      bind = , bracketright, scroller:fitheight, all
      bind = , bracketright, submap, reset
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset
    '';
  };
}
