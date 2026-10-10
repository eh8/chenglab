{
  config,
  lib,
  ...
}: {
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = [config.networking.hostName];
  };

  # Use the module's static account with the impermanence bind mount.
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
