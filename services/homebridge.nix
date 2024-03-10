{...}: {
  imports = [
    ./acme.nix
  ];

  # https://lmy.medium.com/from-ansible-to-nixos-3a117b140bec
  networking.firewall.interfaces."enp9s0" = {
    allowedTCPPorts = [5353 8581 51789];
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
      "muffins.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8581";
        };
      };
    };
  };

  fileSystems."/var/lib/homebridge" = {
    device = "/nix/persist/var/lib/homebridge";
    fsType = "none";
    options = ["bind"];
  };
}
