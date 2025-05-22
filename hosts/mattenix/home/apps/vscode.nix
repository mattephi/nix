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
    "git.repositoryScanMaxDepth" = 5;
    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };
    "debug.onTaskErrors" = "abort";
    "editor.minimap.enabled" = false;
    # nixd setup
    "nix.serverPath" = "nixd";
    "nix.enableLanguageServer" = true;
    "nix.formatting" = {
      "command" = "nixfmt";
    };
    "latex-workshop.formatting.latex" = "latexindent";
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
      ms-azuretools.vscode-docker
      arrterian.nix-env-selector
      yzhang.markdown-all-in-one
      asvetliakov.vscode-neovim
    ]);
in
{
  stylix.targets.vscode.profileNames = [
    "default"
    "tex"
    "cpp"
    "xr"
  ];
  programs.vscode = {
    enable = true;
    # package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #   src = (
    #     builtins.fetchTarball {
    #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #       sha256 = "0wmqjqg9jy2hz1dkgwdk2gqaprvk2wvsxya8q5ipf25skvfxzxm3";
    #     }
    #   );
    #   version = "latest";

    #   buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    # });
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
          cpp = {
            extensions = with pkgs.vscode-marketplace; [
              ms-vscode.cpptools
              ms-vscode.cmake-tools
              ms-vscode.cpptools-themes
              ms-vscode.cpptools-extension-pack # Needed to remove notification
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
          python = {
            extensions = with pkgs.vscode-marketplace; [
              ms-python.python
              ms-python.vscode-pylance
              ms-python.debugpy
              ms-toolsai.jupyter-keymap
              ms-toolsai.jupyter-renderers
              ms-toolsai.vscode-jupyter-cell-tags
              ms-toolsai.vscode-jupyter-slideshow
              ms-toolsai.jupyter-keymap

            ];
          };
        };
  };
}
