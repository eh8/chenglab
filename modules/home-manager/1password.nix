{
  lib,
  pkgs,
  ...
}: {
  programs = {
    git.extraConfig = {
      gpg.ssh.program = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux "${pkgs._1password-gui}/bin/op-ssh-sign")
        (lib.mkIf pkgs.stdenv.isDarwin "/Applications/1Password.app/Contents/MacOS/op-ssh-sign")
      ];
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
