{
  lib,
  pkgs,
  ...
}: {
  programs = {
    git.settings = {
      gpg.ssh.program = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux "${pkgs._1password-gui}/bin/op-ssh-sign")
        (lib.mkIf pkgs.stdenv.isDarwin "/Applications/1Password.app/Contents/MacOS/op-ssh-sign")
      ];
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      # inspo: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
      matchBlocks."*" = lib.mkMerge [
        {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        }
        (lib.mkIf pkgs.stdenv.isLinux {
          identityAgent = "~/.1password/agent.sock";
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          identityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        })
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
