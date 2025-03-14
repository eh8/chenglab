{vars, ...}: {
  programs.git = {
    userName = vars.fullName;
    userEmail = vars.userEmail;
    signing = {
      key = vars.sshPublicKey;
      signByDefault = true;
    };
  };
}
