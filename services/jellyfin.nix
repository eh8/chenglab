{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "waffle.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };
  };

  fileSystems."/var/lib/jellyfin" = {
    device = "/nix/persist/var/lib/jellyfin";
    fsType = "none";
    options = ["bind"];
  };

  # Enable hardware transcoding
  # https://nixos.wiki/wiki/Jellyfin
  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  # };
  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-media-driver
  #     vaapiIntel
  #     vaapiVdpau
  #     libvdpau-va-gl
  #     intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
  #   ];
  # };

  # services.caddy = {
  #   virtualHosts."watch.chengeric.com".extraConfig = ''
  #     reverse_proxy localhost:8096
  #   '';
  # };
}
