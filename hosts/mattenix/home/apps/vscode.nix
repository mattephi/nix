{ pkgs, ... }:
let
  commonSettings = {
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
    "github.copilot.chat.editor.temporalContext.enabled" = true;
    "C_Cpp.copilotHover" = "enabled";
    "github.copilot.nextEditSuggestions.enabled" = true;
    "github.copilot.nextEditSuggestions.fixes" = true;
    "github.copilot.chat.codesearch.enabled" = true;
    "github.copilot.chat.agent.thinkingTool" = true;
    "telemetry.feedback.enabled" = false;
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "latex" = false;
    };
  };
  commonExtensions =
    with pkgs.vscode-marketplace-release;
    [
      github.copilot
      github.copilot-chat
    ]
    ++ (with pkgs.vscode-marketplace; [
      mkhl.direnv
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      ms-azuretools.vscode-docker
      ms-azuretools.vscode-containers
      ms-vscode-remote.remote-containers
      yzhang.markdown-all-in-one
      asvetliakov.vscode-neovim
    ]);
  commonBindings = [ ];
in
{
  stylix.targets.vscode.profileNames = [
    "default"
    "tex"
    "cpp"
    "xr"
    "pyt"
  ];
  programs.vscode = {
    enable = true;
    profiles =
      pkgs.lib.mapAttrs
        (
          name: cfg:
          let
            overrides = cfg.userSettings or { };
            profileExtensions = cfg.extensions or [ ];
            keybindings = cfg.keybindings or [ ];
          in
          cfg
          // {
            userSettings = commonSettings // overrides;
            extensions = profileExtensions ++ commonExtensions;
            keybindings = commonBindings ++ keybindings;
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
              ms-vscode.cpptools-extension-pack
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
          pyt = {
            extensions =
              with pkgs.vscode-marketplace;
              [
                ms-python.python
                ms-python.vscode-pylance
                ms-python.debugpy
                ms-toolsai.jupyter-keymap
                ms-toolsai.jupyter-renderers
                ms-toolsai.vscode-jupyter-cell-tags
                ms-toolsai.vscode-jupyter-slideshow
              ]
              ++ (with pkgs.vscode-marketplace-release; [
                ms-toolsai.jupyter
              ]);
          };
        };
  };
}
