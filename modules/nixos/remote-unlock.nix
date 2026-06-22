{
  config,
  vars,
  ...
}: {
  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent";
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      authorizedKeys = config.users.users.${vars.userName}.openssh.authorizedKeys.keys;
      hostKeys = ["/nix/secret/initrd/ssh_host_ed25519_key"];
    };
  };
}
