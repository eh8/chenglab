{
  lib,
  pkgs,
  vars,
  ...
}: {
  programs = {
    git.extraConfig = {
      # inspo: https://wiki.nixos.org/wiki/1Password#Configuring_Git
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
    };
    ssh = {
      enable = true;
      extraConfig = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux ''
          IdentityAgent "~/.1password/agent.sock"
        '')
        (lib.mkIf pkgs.stdenv.isDarwin ''
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        '')
      ];
    };
  };

  xdg.configFile."1Password/ssh/agent.toml" = {
    text = ''
      [[ssh-keys]]
      item = "SSH Key - Personal"
    '';
  };
}
