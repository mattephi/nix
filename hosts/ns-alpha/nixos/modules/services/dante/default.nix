{
  services.dante = {
    enable = true;
    config = ''
      logoutput: syslog

      internal: 0.0.0.0 port = 8388
      external: enp1s0

      method: none
      user.privileged: root
      user.notprivileged: nobody

      client pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: error
      }

      pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        protocol: tcp udp
        log: connect error
      }
    '';
  };

  # Expose port 1080
  networking.firewall.allowedTCPPorts = [ 8388 ];
}
