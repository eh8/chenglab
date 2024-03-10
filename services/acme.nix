{config, ...}: {
  sops.secrets.cloudflare-api-email = {};
  sops.secrets.cloudflare-api-key = {};

  # https://carjorvaz.com/posts/setting-up-wildcard-lets-encrypt-certificates-on-nixos/
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin+acme@chengeric.com";

    certs."chengeric.com" = {
      domain = "chengeric.com";
      extraDomainNames = ["*.chengeric.com"];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      # https://go-acme.github.io/lego/dns/cloudflare/
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-key.path;
      };
    };
  };

  fileSystems."/var/lib/acme" = {
    device = "/nix/persist/var/lib/acme";
    fsType = "none";
    options = ["bind"];
  };

  users.users.nginx.extraGroups = ["acme"];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
