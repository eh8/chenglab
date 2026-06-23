{config, ...}: let
  metricsId = "3325626";
in {
  sops = {
    secrets."grafana-cloud-token" = {};

    templates."alloy.env".content = ''
      GRAFANA_CLOUD_TOKEN="${config.sops.placeholder."grafana-cloud-token"}"
    '';
  };

  services.alloy = {
    enable = true;
    environmentFile = config.sops.templates."alloy.env".path;
  };

  environment.etc."alloy/config.alloy".text = ''
    prometheus.exporter.self "alloy_check" {}

    discovery.relabel "alloy_check" {
      targets = prometheus.exporter.self.alloy_check.targets

      rule {
        target_label = "instance"
        replacement  = constants.hostname
      }

      rule {
        target_label = "alloy_hostname"
        replacement  = constants.hostname
      }

      rule {
        target_label = "job"
        replacement  = "integrations/alloy-check"
      }
    }

    prometheus.scrape "alloy_check" {
      targets         = discovery.relabel.alloy_check.output
      forward_to      = [prometheus.relabel.alloy_check.receiver]
      scrape_interval = "60s"
    }

    prometheus.relabel "alloy_check" {
      forward_to = [prometheus.remote_write.grafana_cloud.receiver]

      rule {
        source_labels = ["__name__"]
        regex         = "(prometheus_target_sync_length_seconds_sum|prometheus_target_scrapes_.*|prometheus_target_interval.*|prometheus_sd_discovered_targets|alloy_build.*|prometheus_remote_write_wal_samples_appended_total|process_start_time_seconds)"
        action        = "keep"
      }
    }

    discovery.relabel "node" {
      targets = prometheus.exporter.unix.node.targets

      rule {
        target_label = "instance"
        replacement  = constants.hostname
      }

      rule {
        target_label = "job"
        replacement  = "integrations/node_exporter"
      }
    }

    prometheus.exporter.unix "node" {
      disable_collectors = ["ipvs", "btrfs", "infiniband", "xfs", "zfs"]

      filesystem {
        fs_types_exclude     = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
        mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
        mount_timeout        = "5s"
      }

      netclass {
        ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
      }

      netdev {
        device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
      }
    }

    prometheus.scrape "node" {
      targets    = discovery.relabel.node.output
      forward_to = [prometheus.relabel.node.receiver]
    }

    prometheus.relabel "node" {
      forward_to = [prometheus.remote_write.grafana_cloud.receiver]

      rule {
        source_labels = ["__name__"]
        regex         = "node_scrape_collector_.+"
        action        = "drop"
      }
    }

    prometheus.remote_write "grafana_cloud" {
      endpoint {
        url = "https://prometheus-prod-66-prod-us-east-3.grafana.net/api/prom/push"

        basic_auth {
          username = "${metricsId}"
          password = sys.env("GRAFANA_CLOUD_TOKEN")
        }
      }
    }
  '';
}
