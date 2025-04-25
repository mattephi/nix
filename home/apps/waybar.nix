{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = (
      pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    );

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = [
          "DP-1"
        ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "hyprland/submap"
          "hyprland/language"
          "pulseaudio"
          "clock"
        ];
        "pulseaudio" = {
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
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          # // "timezone": "America/New_York",
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%Y-%m-%d}";
        };
        "hyprland/workspaces" = {
          format = "<sub>{icon}</sub>";
          format-window-separator = " ";
        };
      };
      secondBar = {
        layer = "top";
        position = "top";
        output = [
          "HDMI-A-1"
        ];
        modules-left = [ "hyprland/workspaces" ];
        modules-right = [
          "tray"
        ];
        "clock" = {
          # // "timezone": "America/New_York",
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%Y-%m-%d}";
        };
        "tray" = {
          spacing = 10;
        };
        "hyprland/workspaces" = {
          format = "<sub>{icon}</sub>";
          format-window-separator = " ";
        };
      };
    };
  };
}
