{ pkgs, ... }:
let
  commonSettings = {
    # "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
    "terminal.integrated.fontFamily" = "'JetBrainsMono NF'";
    "editor.wordWrap" = "bounded";
    "editor.wordWrapColumn" = 80;
    "editor.formatOnSave" = true;
    # "editor.fontSize" = 10;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    # nixd setup
    "nix.serverPath" = "nixd";
    "nix.enableLanguageServer" = true;
    "nix.formatting" = {
      "command" = "nixfmt";
    };
    "nixd" = {
      "nixpkgs" = {
        "expr" = "(builtins.getFlake \"/home/mattephi/nix\").inputs.nixpkgs";
      };
      "formatting" = {
        "command" = "nixfmt";
      };
      "options" = {
        "nixos" = {
          "expr" = "(builtins.getFlake \"/home/mattephi/nix\").nixosConfigurations.mattenix.options";
        };
      };
    };
  };
  commonExtensions =
    with pkgs.vscode-marketplace-release;
    [
      github.copilot
      github.copilot-chat
    ]
    ++ (with pkgs.vscode-marketplace; [
      # Support for Nix in all profiles
      jnoortheen.nix-ide
      mkhl.direnv
      arrterian.nix-env-selector
    ]);
in
{
  stylix.targets.vscode.profileNames = [
    "default"
    "tex"
    "xr"
  ];
  programs.vscode = {
    enable = true;
    #package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #  src = (
    #    builtins.fetchTarball {
    #      url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #      sha256 = "1fdjpm6i66n74cd2bfb2brmilj1842dig2fjxg4r9ximlkl0kf50";
    #    }
    #  );
    #  version = "latest";
    #
    #  buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    #});
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
          default = { };
          tex = {
            extensions = with pkgs.vscode-marketplace; [
              james-yu.latex-workshop
              iamhyc.overleaf-workshop
            ];
          };
          xr = {
            extensions = with pkgs.vscode-marketplace; [
              slevesque.shader
              dtoplak.vscode-glsllint
              circledev.glsl-canvas
              ms-vscode.cmake-tools
              ms-vscode.cpptools
            ];
          };
        };
  };
}
