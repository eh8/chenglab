{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    trashy
  ];
}
