{ config, pkgs, lib, ... }:

let
  cfg = config.services.nextcloud;
in
{
  options.services.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud service";
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "The hostname under which Nextcloud is reachable.";
    };
    httpsPort = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "The port number for HTTPS connections to Nextcloud.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 ] ++ lib.optional (cfg.httpsPort != null) cfg.httpsPort;

    services.nginx = {
      enable = true;
      virtualHosts = {
        "${cfg.hostName}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            root = pkgs.nextcloud;
            index = "index.php";
            extraConfig = ''
              location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
              }

              location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
                deny all;
              }

              location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
                deny all;
              }

              location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|oc[ms]-provider/.+)\.php(?:$|/) {
                include ${pkgs.nginx}/conf/fastcgi_params;
                fastcgi_split_path_info ^(.+\.php)(/.*)$;
                try_files $fastcgi_script_name =404;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param HTTPS on;
                fastcgi_pass unix:/var/run/phpfpm/nextcloud.sock;
              }

              location ~ ^/(?:updater|oc[ms]-provider)(?:$|/) {
                try_files $uri/ =404;
                index index.php;
              }

              location ~ \.(?:css|js|woff2?|svg|gif|map)$ {
                try_files $uri /index.php$request_uri;
                access_log off;
              }
            '';
          };
        };
      };
    };

    services.phpfpm.pools.nextcloud = {
      user = cfg.user;
      group = cfg.group;
      listen = "/var/run/phpfpm/nextcloud.sock";
      settings = {
        "pm" = "dynamic";
        "pm.max_children" = "120";
        "pm.start_servers" = "12";
        "pm.min_spare_servers" = "6";
        "pm.max_spare_servers" = "18";
      };
    };

    services.nextcloud = {
      enable = true;
      hostName = cfg.hostName;
      httpsPort = cfg.httpsPort;
      config = {
        dbtype = "mysql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        dbhost = "/run/mysqld/mysqld.sock";
        adminUser = "admin";
        adminPass = "admin"; # You should change this to a secure password or use a secret management solution
        # Additional Nextcloud configuration options can be set here
      };
      # Include additional Nextcloud configuration here
    };

    # Ensure the Nextcloud data directory is writable by the web server
    systemd.tmpfiles.rules = [
      "d /var/lib/nextcloud/data 0750 ${cfg.user} ${cfg.group}"
    ];
  };
}
