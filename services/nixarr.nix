{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./acme.nix
    ./nginx.nix
    ./cloudflared.nix
  ];

  systemd.tmpfiles.rules = ["d /var/lib/nixarr 0755 root root"];

  nixarr = {
    enable = true;
    mediaDir = "/fun/media";
    stateDir = "/var/lib/nixarr";
    jellyfin.enable = true;
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
    };
  };

  sops.secrets.kopia-repository-token = {};

  systemd.services = {
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

  systemd.timers = {
    "backup-nixarr" = {
      enable = true;
      description = "Backup Nixarr installation with Kopia";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 4:00:00";
        RandomizedDelaySec = "1h";
        Persistent = true;
      };
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/nixarr"
    ];
  };
}
