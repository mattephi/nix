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
