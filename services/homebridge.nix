{
  config,
  pkgs,
  lib,
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

  sops.secrets."kopia-repository-token" = {};

  systemd = {
    tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];

    services = {
      "backup-homebridge" = {
        description = "Backup Homebridge installation with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets."kopia-repository-token".path}";
          ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /var/lib/homebridge";
          ExecStartPost = "${pkgs.kopia}/bin/kopia repository disconnect";
        };
      };
    };

    timers = {
      "backup-homebridge" = {
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
    ];
  };
}
