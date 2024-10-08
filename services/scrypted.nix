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

  # Initially generated using compose2nix v0.1.9.
  # Based off of https://github.com/koush/scrypted/blob/main/install/docker/docker-compose.yml

  networking.firewall = {
    # Homekit requires random port to connect with accessories. It is easier to
    # whitelist an entire trusted network rather than tediously open ports for
    # each camera.

    # inspo: https://discourse.nixos.org/t/open-firewall-ports-only-towards-local-network/13037/2
    extraCommands = ''
      iptables -A nixos-fw -p tcp --source 10.0.10.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 10.0.10.0/24 -j nixos-fw-accept
    '';
    extraStopCommands = ''
      iptables -D nixos-fw -p tcp --source 10.0.10.0/24 -j nixos-fw-accept || true
      iptables -D nixos-fw -p udp --source 10.0.10.0/24 -j nixos-fw-accept || true
    '';
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      "scrypted" = {
        image = "ghcr.io/koush/scrypted";
        environment = {
          SCRYPTED_DOCKER_AVAHI = "true";
        };
        volumes = [
          "/var/lib/scrypted:/server/volume:rw"
        ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        log-driver = "journald";
        extraOptions = [
          "--log-opt=max-file=10"
          "--log-opt=max-size=10m"
          "--network=host"
          "--security-opt=apparmor:unconfined"
          "--dns=1.1.1.1,1.0.0.1" # without this, host DNS points to tailscale which doesn't work in container
        ];
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "scrypted.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "https://127.0.0.1:10443";
        };
      };
    };
  };

  systemd = {
    tmpfiles.rules = ["d /var/lib/scrypted 0755 root root"];

    targets = {
      "podman-compose-scrypted-root" = {
        unitConfig = {
          Description = "Root target generated by compose2nix.";
        };
        wantedBy = ["multi-user.target"];
      };
    };

    services = {
      "podman-scrypted" = {
        serviceConfig = {
          Restart = lib.mkOverride 500 "always";
        };
        partOf = [
          "podman-compose-scrypted-root.target"
        ];
        wantedBy = [
          "podman-compose-scrypted-root.target"
        ];
      };

      "backup-scrypted" = {
        description = "Backup Scrypted installation with Kopia";
        wantedBy = ["default.target"];
        # warning: following line is needed to prevent race condition with homebridge.nix
        after = ["backup-homebridge.service"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets."kopia-repository-token".path}";
          ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /var/lib/scrypted";
          ExecStartPost = "${pkgs.kopia}/bin/kopia repository disconnect";
        };
      };
    };

    timers = {
      "podman-auto-update" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 7:00:00";
          RandomizedDelaySec = "1h";
        };
      };

      "backup-scrypted" = {
        description = "Backup Scrypted installation with Kopia";
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
      "/var/lib/scrypted"
      # Commented out since this is already enabled in homebridge.nix
      # /var/lib/containers
    ];
  };
}
