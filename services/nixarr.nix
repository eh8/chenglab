{
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./acme.nix
    ./nginx.nix
    ./cloudflared.nix
  ];

  sops = {
    secrets = {
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
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-driver
      libvdpau-va-gl
      intel-vaapi-driver
      libva-vdpau-driver
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
          proxyPass = "http://127.0.0.1:${toString config.nixarr.jellyfin.port}";
        };
      };

      "prowlarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.prowlarr.port}";
        };
      };

      "radarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.radarr.port}";
        };
      };

      "sonarr.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.sonarr.port}";
        };
      };

      "transmission.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.nixarr.transmission.uiPort}";
        };
      };
    };
  };

  systemd.tmpfiles.rules = ["d /var/lib/nixarr 0755 root root"];

  chenglab.kopiaBackup.paths = ["/var/lib/nixarr"];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/nixarr"
      "/var/lib/transmission/.incomplete"
    ];
  };
}
