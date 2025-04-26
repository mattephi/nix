{ pkgs, ... }:
let
  commonSettings = {
    "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
    "terminal.integrated.fontFamily" = "'JetBrainsMono NF'";
    "editor.wordWrap" = "bounded";
    "editor.wordWrapColumn" = 80;
    "editor.fontSize" = 12;
    "git.confirmSync" = false;
    "git.autofetch" = true;
  };
  commonExtensions = with pkgs.vscode-marketplace; [
    github.copilot
    github.copilot-chat
  ];
in
{
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (
        builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "1fdjpm6i66n74cd2bfb2brmilj1842dig2fjxg4r9ximlkl0kf50";
        }
      );
      version = "latest";

      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    });
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
            extensions = with pkgs.vscode-marketplace; [
              bbenoist.nix
              brettm12345.nixfmt-vscode
            ];
            userSettings = {
              "editor.formatOnSave" = true;
            };
          };
          tex = {
            extensions = with pkgs.vscode-marketplace; [
              james-yu.latex-workshop
              iamhyc.overleaf-workshop
            ];
          };
        };
  };
}
