{ pkgs, ... }:
{
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

      input = {
        kb_layout = "us, ru";
        kb_options = "grp:ctrl_space_toggle";
        follow_mouse = 1;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
    extraConfig = ''
      ###################
      ### MY PROGRAMS ###
      ###################

      $terminal = ghostty
      $menu = rofi -show drun
      # $browser = WAYLAND_DISPLAY="" google_chrome_stable

      #################
      ### AUTOSTART ###
      #################

      exec-once = waybar & dunst & blueman-applet &

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      env = XCURSOR_SIZE,18
      env = HYPRCURSOR_SIZE,18
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = ELECTRON_OZONE_PLATFORM_HINT,auto
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = NVD_BACKEND,direct
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm

      #####################
      ### LOOK AND FEEL ###
      #####################

      general {
          gaps_in = 2
          gaps_out = 2

          border_size = 1

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = scroller
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 3
          rounding_power = 2

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = yes, please :)

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrule = bordersize 0, floating:0, onworkspace:f[1]
      # windowrule = rounding 0, floating:0, onworkspace:f[1]

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master {
          new_status = master
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      #misc {
      #    force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
      #    disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
      #}


      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      #input {
      #    kb_layout = us, ru
      #    kb_variant =
      #    kb_model =
      #    kb_options = grp:ctrl_space_toggle
      #    kb_rules =

      #    follow_mouse = 1

      #    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

      #    touchpad {
      #        natural_scroll = false
      #    }
      #}

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }


      ###################
      ### KEYBINDINGS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/
      $mainMod = SUPER # Sets "Windows" key as main modifier

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, T, exec, $terminal
      # bind = $mainMod, B, exec, WAYLAND_DISPLAY="" google-chrome-stable
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      # bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, SPACE, exec, pkill rofi || $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, slash, scroller:jump,
      bind = $mainMod, F, fullscreen

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Hyprscroller

      # Move windows
      bind = $mainMod CTRL, left, movewindow, l
      bind = $mainMod CTRL, right, movewindow, r
      bind = $mainMod CTRL, up, movewindow, u
      bind = $mainMod CTRL, down, movewindow, d
      bind = $mainMod ALT, left, movewindow, l, nomode
      bind = $mainMod ALT, right, movewindow, r, nomode
      bind = $mainMod ALT, up, movewindow, u, nomode
      bind = $mainMod ALT, down, movewindow, d, nomode

      # Modes
      bind = $mainMod, bracketleft, scroller:setmode, row
      bind = $mainMod, bracketright, scroller:setmode, col

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

      # Admit/Expel
      bind = $mainMod, I, scroller:admitwindow,
      bind = $mainMod, O, scroller:expelwindow,
      bind = $mainMod SHIFT, I, scroller:admitwindow, r
      bind = $mainMod SHIFT, O, scroller:expelwindow, l

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

      # Pin
      bind = $mainMod, P, scroller:pin,

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

      # bind key to toggle overview (normal)
      bind = $mainMod, tab, scroller:toggleoverview
      # bind = ,mouse:275, scroller:toggleoverview

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Example special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Laptop multimedia keys for volume and LCD brightness
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

      # Requires playerctl
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule
      # windowrule = float,class:^(kitty)$,title:^(kitty)$

      # Ignore maximize requests from apps. You'll probably like this.
      windowrule = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

    '';
  };
}
