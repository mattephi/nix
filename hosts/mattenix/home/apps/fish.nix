{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    plugins = with pkgs.fishPlugins; [
      {
        # Modern prompt
        name = "tide";
        src = tide.src;
      }
      {
        # Bash source
        name = "bass";
        src = bass.src;
      }
      {
        # Text expansions (!!, ...)
        name = "puffer";
        src = puffer.src;
      }
      {
        # Autoclosing brackets
        name = "pisces";
        src = pisces.src;
      }
      {
        # humantime $CMD_DURATION
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
