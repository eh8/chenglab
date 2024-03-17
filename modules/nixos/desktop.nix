{
  environment.persistence."/nix/persist" = {
    # Folders you want to map
    directories = [
      "/etc/NetworkManager/system-connections"
    ];

    users."eh8" = {
      directories = [
        # Personal files
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "git"

        # Config folders
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
