{config, ...}: {
  sops.secrets.tailscale-authKey = {};

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-authKey.path;
  };
}
