final: prev: {
  # Fix flickering in some electron apps
  # TODO: At some point it should be unnecessary
  google-chrome = prev.google-chrome.override {
    commandLineArgs = "--enable-features=WaylandLinuxDrmSyncobj";
  };
  discord = prev.discord.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.makeWrapper ];
    postInstall = ''
      ${old.postInstall or ""}
      wrapProgram $out/bin/discord \
        --add-flags --use-gl=desktop"
        "
    '';
  });
  # Recent version
  firefly-iii = prev.firefly-iii.overrideAttrs (old: rec {
    src = prev.fetchFromGitHub {
      owner = "firefly-iii";
      repo = "firefly-iii";
      rev = "0aa90b945395180f7048a218b8f0b496457ab2d1";
      sha256 = "sha256-qP5r3nSQe9O2fyRk3k3xRoiz6bdzpySm95XgpQjc0lg=";
    };
    npmDeps = prev.fetchNpmDeps {
      inherit src;
      name = "firefly-iii-npm-deps";
      hash = "sha256-26uf7c4fwnmMZ8RW7BF+EFa4QaUhIKEQ3n3VMO1LVBQ=";
    };
  });
  # FHS obsidian
  obsidian-fhs =
    let
      base = prev.buildFHSEnv {
        name = "obsidian-fhs";
        targetPkgs = pkgs: [
          pkgs.obsidian
          pkgs.stdenv.cc.cc.lib
          pkgs.egl-wayland
          pkgs.bashInteractive
        ];
        runScript = ''
          #!${prev.bashInteractive}/bin/bash
          exec obsidian "$@"
        '';
      };
      desktop = prev.makeDesktopItem {
        name = "obsidian-fhs";
        desktopName = "Obsidian (FHS)";
        comment = "Knowledge base";
        icon = "obsidian";
        exec = "${base}/bin/obsidian-fhs %u";
        categories = [ "Office" ];
        mimeTypes = [ "x-scheme-handler/obsidian" ];
      };
    in
    prev.symlinkJoin {
      name = "obsidian-fhs";
      paths = [
        base
        desktop
      ];
    };
}
