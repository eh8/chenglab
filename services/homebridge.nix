{
  imports = [
    ./acme.nix
  ];

  # inspo: https://lmy.medium.com/from-ansible-to-nixos-3a117b140bec
  networking.firewall = {
    # need to add ports for each added child bridge
    allowedTCPPorts = [5353 50000 50001 50002];
    allowedUDPPorts = [5353];

    allowedTCPPortRanges = [
      {
        from = 52100;
        to = 52150;
      }
    ];
  };

  systemd.tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];

  virtualisation.oci-containers.containers."homebridge" = {
    image = "homebridge/homebridge:latest";
    volumes = ["/var/lib/homebridge:/homebridge"];
    extraOptions = ["--network=host"];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "home.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8581";
        };
      };
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/homebridge"
      "/var/lib/containers"
    ];
  };
}
