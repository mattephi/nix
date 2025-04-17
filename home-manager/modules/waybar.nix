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
        modules-left = [ ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "clock"
        ];

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
      };
    };
  };
}
