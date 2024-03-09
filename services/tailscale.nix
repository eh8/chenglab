{config, ...}: {
  sops.secrets.tailscale-authkey = {};

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-authkey.path;
  };

  fileSystems."/var/lib/tailscale" = {
    device = "/nix/persist/var/lib/tailscale";
    fsType = "none";
    options = ["bind"];
  };
}
