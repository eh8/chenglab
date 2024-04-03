{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./_acme.nix
    ./_nginx.nix
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

    # inspo: https://github.com/NixOS/nixpkgs/issues/226365
    # "it's always DNS!"
    interfaces."podman+".allowedUDPPorts = [53];
  };

  virtualisation.oci-containers.containers."homebridge" = {
    image = "homebridge/homebridge:latest";
    volumes = ["/var/lib/homebridge:/homebridge"];
    extraOptions = [
      "--network=host"
      "--dns=127.0.0.1"
    ];
  };

  services.nginx = {
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

  sops.secrets.kopia-repository-token = {};

  systemd = {
    tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];

    services = {
      "backup-homebridge" = {
        description = "Backup Homebridge installation with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets.kopia-repository-token.path}";
          ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /var/lib/homebridge";
          ExecStartPost = "${pkgs.kopia}/bin/kopia repository disconnect";
        };
      };
    };

    timers = {
      "backup-homebridge" = {
        enable = true;
        description = "Backup Homebridge installation with Kopia";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 4:00:00";
          RandomizedDelaySec = "1h";
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
