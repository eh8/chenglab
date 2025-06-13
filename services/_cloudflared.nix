{
  config,
  pkgs,
  lib,
  ...
}: {
  sops.secrets = {
    "cloudflare-tunnel" = {
      format = "binary";
      sopsFile = ./../secrets/cloudflare-tunnel;
    };
    "cloudflare-token" = {
      format = "binary";
      sopsFile = ./../secrets/cloudflare-cert.pem;
    };
  };

  environment.etc."cloudflared/cert.pem".source = config.sops.secrets."cloudflare-token".path;

  services.cloudflared = {
    enable = true;
    tunnels = {
      "chenglab-01" = {
        credentialsFile = config.sops.secrets."cloudflare-tunnel".path;
        default = "http_status:404";
        ingress = {
          "watch.chengeric.com" = {
            service = "http://localhost:8096";
          };
        };
      };
    };
  };

  systemd.services = {
    "cloudflared-route-tunnel" = {
      description = "Point traffic to tunnel subdomain";
      after = [
        "network-online.target"
        "cloudflared-tunnel-chenglab-01.service"
      ];
      wants = [
        "network-online.target"
        "cloudflared-tunnel-chenglab-01.service"
      ];
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.cloudflared} tunnel route dns 'Chenglab-01' 'watch.chengeric.com'";
      };
    };
  };
}
