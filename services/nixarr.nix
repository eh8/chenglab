{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./_acme.nix
    ./_nginx.nix
    ./_cloudflared.nix
  ];

  sops.secrets.wg-conf = {
    format = "binary";
    sopsFile = ./../secrets/wg.conf;
  };

  nixarr = {
    enable = true;
    mediaDir = "/fun/media";
    stateDir = "/var/lib/nixarr";

    jellyfin.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;

    transmission = {
      enable = false;
      # vpn.enable = true;
    };

    # vpn = {
    #   enable = true;
    #   wgConf = config.sops.secrets.wg-conf.path;
    # };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  hardware.opengl = {
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
          proxyPass = "http://127.0.0.1:8096";
        };
      };

      "prowlarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9696";
        };
      };

      "radarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
        };
      };

      "sonarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
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

  sops.secrets.kopia-repository-token = {};

  systemd = {
    tmpfiles.rules = ["d /var/lib/nixarr 0755 root root"];

    services = {
      "backup-nixarr" = {
        description = "Backup Nixarr installation with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets.kopia-repository-token.path}";
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
    ];
  };
}
