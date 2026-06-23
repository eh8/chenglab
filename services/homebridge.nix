{...}: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  # inspo: https://lmy.medium.com/from-ansible-to-nixos-3a117b140bec
  networking.firewall = {
    # need to add ports for each added child bridge
    allowedTCPPorts = [5353 50000 50001 50002];
    allowedUDPPorts = [5353];

    allowedTCPPortRanges = [
      {
        from = 50100;
        to = 50200;
      }
    ];
  };

  services = {
    homebridge.enable = true;
    nginx = {
      virtualHosts = {
        "home.chengeric.com" = {
          forceSSL = true;
          useACMEHost = "chengeric.com";
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "http://127.0.0.1:8581";
          };
        };
      };
    };
  };

  systemd = {
    tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];
  };

  chenglab.kopiaBackup.paths = ["/var/lib/homebridge"];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/homebridge"
    ];
  };
}
