{
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./_acme.nix
    ./_nginx.nix
    ./_cloudflared.nix
  ];

  sops = {
    secrets = {
      "kopia-repository-token" = {};
      "wg.conf" = {
        format = "binary";
        sopsFile = ./../secrets/wg.conf;
      };
    };
  };

  nixarr = {
    enable = true;
    mediaDir = "/fun";
    stateDir = "/var/lib/nixarr";

    jellyfin.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;

    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      # todo: figure out how to update this easier
      peerPort = 46634;
      vpn.enable = true;
      extraSettings = {
        peer-limit-global = 500;
        cache-size-mb = 256;
        incomplete-dir = "/var/lib/transmission/.incomplete";
        incomplete-dir-enabled = true;
        download-queue-enabled = true;
        download-queue-size = 20;
        speed-limit-up = 500;
        speed-limit-up-enabled = true;
        rpc-authentication-required = true;
        rpc-username = vars.userName;
        rpc-whitelist-enabled = false;
        # todo: figure out how to integrate rpc-password into sops-nix
        rpc-password = "{7d827abfb09b77e45fe9e72d97956ab8fb53acafoPNV1MpJ";
      };
    };

    vpn = {
      enable = true;
      wgConf = config.sops.secrets."wg.conf".path;
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
  };

  environment.systemPackages = with pkgs; [
    # To enable `intel_gpu_top`
    intel-gpu-tools
    # because nixarr does not include it by default
    wireguard-tools
  ];

  services.nginx = {
    virtualHosts = {
      "watch.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8096";
        };
      };

      "prowlarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:9696";
        };
      };

      "radarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:7878";
        };
      };

      "sonarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8989";
        };
      };

      "transmission.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091";
        };
      };
    };
  };

  systemd = {
    tmpfiles.rules = ["d /var/lib/nixarr 0755 root root"];

    services = {
      "backup-nixarr" = {
        description = "Backup Nixarr installation with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets."kopia-repository-token".path}";
          ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /var/lib/nixarr";
          ExecStartPost = "${pkgs.kopia}/bin/kopia repository disconnect";
        };
      };
    };

    timers = {
      "backup-nixarr" = {
        description = "Backup Nixarr installation with Kopia";
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
      "/var/lib/nixarr"
      "/var/lib/transmission/.incomplete"
    ];
  };
}
