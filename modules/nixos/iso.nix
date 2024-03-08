{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    croc
    git
    vim
  ];

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkcgwjYMHqUDnx0JIOSXQ/TN80KEaFvvUWA2qH1AHFC"
    ];
    initialPassword = "nixos";
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
