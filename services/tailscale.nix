{config, ...}: {
  sops.secrets."tailscale-authkey" = {};

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale-authkey".path;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-routes=10.0.0.0/8"
    ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/tailscale"
    ];
  };
}
