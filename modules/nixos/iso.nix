{vars, ...}: {
  imports = [
    ./_packages.nix
  ];

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      vars.sshPublicKeyPersonal
    ];
  };

  users.motd = ''
    Welcome to the Chenglab ISO installer!

    To install the system, copy and paste the following command:

    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/eh8/chenglab/main/install.sh)"

  '';

  security.sudo.wheelNeedsPassword = false;

  # needed for ventoy
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.openssh = {
    enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
