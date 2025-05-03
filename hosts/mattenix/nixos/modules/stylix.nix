{ pkgs, inputs, ... }:

let
  wallpaperFlake = inputs.nix-wallpaper;
  wallpaperDrv = wallpaperFlake.packages.${pkgs.system}.default.override {
    preset = "gruvbox-dark";
    logoSize = 10.0;
  };
  imgPath = "${wallpaperDrv}/share/wallpapers/nixos-wallpaper.png";
in
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = imgPath;

    fonts = {
      sizes = {
        terminal = 10;
      };

      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
  };
}
