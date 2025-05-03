{
  programs = {
    nix-index-database.comma.enable = true;

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
