{
  vars,
  osConfig,
  ...
}: let
  isWorkDevice = osConfig.networking.hostName == "workchng";
in {
  home = {
    # inspo: https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
    file.".ssh/allowed_signers".text =
      if isWorkDevice
      then "* ${vars.sshPublicKeyWork}"
      else "* ${vars.sshPublicKeyPersonal}";
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = vars.fullName;
          email = vars.userEmail;
          signingkey =
            if isWorkDevice
            then vars.sshPublicKeyWork
            else vars.sshPublicKeyPersonal;
        };
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };
}
