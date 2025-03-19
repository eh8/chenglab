{
  vars,
  osConfig,
  ...
}: {
  programs.git = {
    userName = vars.fullName;
    userEmail = vars.userEmail;
    signing = {
      key =
        if osConfig.networking.hostName == "workchng"
        then vars.sshPublicKeyWork
        else vars.sshPublicKeyPersonal;
      signByDefault = true;
    };
  };
}
