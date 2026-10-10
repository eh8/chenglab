{
  lib,
  vars,
  ...
}: {
  services.rustdesk-server = {
    enable = true;
    # note: LAN access is allowed by svr2's existing trusted-LAN firewall rules.
    openFirewall = false;
    signal.relayHosts = ["rustdeck.${vars.domain}"];
  };

  # inspo: https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/
  # note: native client ports only; websocket ports 21118/21119 are omitted.
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [21115 21116 21117];
    allowedUDPPorts = [21116];
  };

  # note: use the module's static account with the impermanence bind mount.
  systemd.services = {
    rustdesk-signal.serviceConfig.DynamicUser = lib.mkForce false;
    rustdesk-relay.serviceConfig.DynamicUser = lib.mkForce false;
  };

  chenglab.kopiaBackup.paths = ["/var/lib/rustdesk"];

  environment.persistence."/nix/persist".directories = [
    {
      directory = "/var/lib/rustdesk";
      user = "rustdesk";
      group = "rustdesk";
      mode = "0750";
    }
  ];
}
