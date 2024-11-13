{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    trashy
    kubectl
    # inspo: https://mynixos.com/nixpkgs/package/azure-cli
    (azure-cli.withExtensions [azure-cli.extensions.k8s-extension])
  ];
}
