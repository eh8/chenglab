{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  programs.git = {
    userName = "Eric Cheng";
    userEmail = "eric@chengeric.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkcgwjYMHqUDnx0JIOSXQ/TN80KEaFvvUWA2qH1AHFC";
      signByDefault = true;
    };
    extraConfig = {
      gpg = {format = "ssh";};
      "gpg \"ssh\"" = {program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";};
    };
  };
}
