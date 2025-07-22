{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = (
      pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    );
    style = ./style.css;

    settings = {
      bar = {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/notification"
          "clock"
          "tray"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "bluetooth"
          "network"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
            empty = "";
          };
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
            ];
          };
        };

        "custom/notification" = {
          tooltip = false;
          format = "";
          on-click = "swaync-client -t -sw";
          escape = true;
        };

        clock = {
          format = "{:%I:%M:%S %p} ";
          interval = 1;
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            format = {
              today = "<span color='#fAfBfC'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "shift_down";
            on-click = "shift_up";
          };
        };

        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "";
          tooltip-format-disconnected = "Error";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} 🖧 ";
          on-click = "kitty nmtui";
        };

        bluetooth = {
          format-on = "󰂯";
          format-off = "BT-off";
          format-disabled = "󰂲";
          format-connected-battery = "{device_battery_percentage}% 󰂯";
          format-alt = "{device_alias} 󰂯";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          on-click-right = "blueman-manager";
        };

        tray = {
          icon-size = 14;
          spacing = 1;
        };
      };
      # mainBar = {
      #   layer = "top";
      #   position = "top";
      #   output = [
      #     "DP-1"
      #   ];
      #   modules-left = [ "hyprland/workspaces" ];
      #   modules-center = [ ];
      #   modules-right = [
      #     "hyprland/submap"
      #     "hyprland/language"
      #     "pulseaudio"
      #     "clock"
      #   ];
      #   "pulseaudio" = {
      #     format = "{volume}% {icon} {format_source}";
      #     format-bluetooth = "{volume}% {icon} {format_source}";
      #     format-bluetooth-muted = " {icon} {format_source}";
      #     format-muted = " {format_source}";
      #     format-source = "{volume}% ";
      #     format-source-muted = "";
      #     format-icons = {
      #       headphone = "";
      #       hands-free = "";
      #       headset = "";
      #       phone = "";
      #       portable = "";
      #       car = "";
      #       default = [
      #         ""
      #         ""
      #         ""
      #       ];
      #     };
      #     on-click = "pavucontrol";
      #   };
      #   "tray" = {
      #     spacing = 10;
      #   };
      #   "clock" = {
      #     # // "timezone": "America/New_York",
      #     tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      #     interval = 1;
      #     format = "{:%H:%M:%S}";
      #     format-alt = "{:%Y-%m-%d}";
      #   };
      #   "hyprland/workspaces" = {
      #     format = "<sub>{icon}</sub>";
      #     format-window-separator = " ";
      #   };
      # };
      # secondBar = {
      #   layer = "top";
      #   position = "top";
      #   output = [
      #     "HDMI-A-1"
      #   ];
      #   modules-left = [ "hyprland/workspaces" ];
      #   modules-right = [
      #     "tray"
      #   ];
      #   "clock" = {
      #     # // "timezone": "America/New_York",
      #     tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      #     interval = 1;
      #     format = "{:%H:%M:%S}";
      #     format-alt = "{:%Y-%m-%d}";
      #   };
      #   "tray" = {
      #     spacing = 10;
      #   };
      #   "hyprland/workspaces" = {
      #     format = "<sub>{icon}</sub>";
      #     format-window-separator = " ";
      #   };
      # };
    };
  };
}
