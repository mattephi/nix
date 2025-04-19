{ pkgs, ... }:
let
  commonSettings = {
    "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
    "editor.fontSize" = 12;
    "git.confirmSync" = false;
  };
  commonExtensions = with pkgs.vscode-extensions; [
    github.copilot
    github.copilot-chat
  ];
in
{
  programs.vscode = {
    enable = true;
    profiles =
      pkgs.lib.mapAttrs
        (
          name: cfg:
          let
            overrides = cfg.userSettings or { };
            profileExtensions = cfg.extensions or [ ];
          in
          cfg
          // {
            userSettings = commonSettings // overrides;
            extensions = profileExtensions ++ commonExtensions;
          }
        )
        {
          nix = {
            extensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              brettm12345.nixfmt-vscode
            ];
            userSettings = {
              "editor.formatOnSave" = true;
            };
          };
        };
  };
}
