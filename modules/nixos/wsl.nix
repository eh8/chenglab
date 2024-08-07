{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  users.users.eh8 = {
    isNormalUser = true;
    description = "eh8";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  wsl.enable = true;
  wsl.defaultUser = "eh8";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
