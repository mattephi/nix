{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      # TODO: Manage this in vscode module
      # using derivations or anything else
      code = "code --use-gl=desktop";
    };
    history.size = 10000;
  };
}
