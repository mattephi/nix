{
  config,
  inputs,
  ...
}:

let
  # mtg v2.2.8 requires Go >= 1.26, which the pinned system nixpkgs (Oct 2025)
  # does not ship yet. Build it with a recent nixpkgs (go 1.26) without moving
  # the rest of the system off the stable pin.
  mtg = inputs.nixpkgs-bleed.legacyPackages.x86_64-linux.callPackage ../../../../../../pkgs/mtg.nix { };
in
{
  systemd.services.mtg = {
    description = "mtg MTProto proxy for Telegram";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      # Secret config rendered by sops; handed to the (dynamic) service user
      # via systemd credentials so it is never world-readable.
      LoadCredential = "mtg.toml:${config.sops.templates."mtg.toml".path}";
      ExecStart = "${mtg}/bin/mtg run %d/mtg.toml";

      DynamicUser = true;
      Restart = "on-failure";
      RestartSec = "5s";

      # hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];
}
