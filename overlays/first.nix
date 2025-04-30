final: prev: {
  # Use newer version of WiVRn
  wivrn = prev.wivrn.overrideAttrs {
    version = "0.24.1";
    src = prev.fetchFromGitHub {
      owner = "WiVRn";
      repo = "WiVRn";
      rev = "e7f67b9";
      sha256 = "aWQcGIrBoDAO7XqWb3dQLBKg5RZYxC7JxwZ+OBSwmEs=";
    };
  };
  # Use newer version of basalt-monado and enable CUDA support
  # TODO: make cuda optional
  basalt-monado = prev.basalt-monado.overrideAttrs (old: {
    version = "latest";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mateosss";
      repo = "basalt";
      rev = "0ced9e5ad280fc38d3f0ec5d0d33795f888760e8";
      sha256 = "+mgyuHEJZU6eRY4J+4XISYOFCWTcxWqrps512clynpc=";
      fetchSubmodules = true;
    };
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.autoAddDriverRunpath ];
    buildInputs = old.buildInputs or [ ] ++ [ prev.cudaPackages.cudatoolkit ];
  });
  # Fix flickering in some electron apps
  # TODO: At some point it should be unnecessary
  google-chrome = prev.google-chrome.override {
    commandLineArgs = "--enable-features=WaylandLinuxDrmSyncobj";
  };
  vscode = prev.vscode.override {
    commandLineArgs = "--use-gl=desktop";
  };
  logseq = prev.logseq.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.makeWrapper ];
    postInstall = ''
      ${old.postInstall or ""}
      wrapProgram $out/bin/logseq \
        --add-flags --use-gl=desktop"
        "
    '';
  });
  discord = prev.discord.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.makeWrapper ];
    postInstall = ''
      ${old.postInstall or ""}
      wrapProgram $out/bin/discord \
        --add-flags --use-gl=desktop"
        "
    '';
  });
}
