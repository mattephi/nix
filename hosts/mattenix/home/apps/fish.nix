{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        src = tide.src;
      }
      {
        name = "bass";
        src = bass.src;
      }
      {
        name = "sponge";
        src = sponge.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
      {
        name = "pisces";
        src = pisces.src;
      }
      {
        name = "humantime-fish";
        src = humantime-fish.src;
      }
    ];

    functions = {
      fish_greeting = {
        body = "";
      };
    };
  };
}
