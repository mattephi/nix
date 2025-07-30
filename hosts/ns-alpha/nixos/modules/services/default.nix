{

  services.openssh.enable = true;

  imports = [
    ./caddy
    ./searx
    ./freshrss
    ./mailserver
    ./firefly-iii
    ./mtprotoproxy
  ];
}
