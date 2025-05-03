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
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
      {
        name = "fish-you-should-use";
        src = fish-you-should-use.src;
      }
    ];

    functions = {
      fish_greeting = {
        body = "";
      };
    };
  };
}
