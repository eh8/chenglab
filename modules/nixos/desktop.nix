{
  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];

    users."eh8" = {
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "git"

        ".cache"
        ".config"
        ".gnupg"
        ".local"
        ".ssh"
        ".mozilla"
        ".vscode"
      ];
      files = [
        ".zsh_history"
      ];
    };
  };
}
