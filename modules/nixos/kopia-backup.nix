{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chenglab.kopiaBackup;
in {
  options.chenglab.kopiaBackup.paths = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = "Paths included in this host's Kopia snapshot.";
  };

  config = lib.mkIf (cfg.paths != []) {
    sops.secrets."kopia-repository-token" = {};

    systemd = {
      services.kopia-backup = {
        description = "Back up host data with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStartPre = "${lib.getExe pkgs.kopia} repository connect from-config --token-file ${config.sops.secrets."kopia-repository-token".path}";
          ExecStart = "${lib.getExe pkgs.kopia} snapshot create ${lib.escapeShellArgs cfg.paths}";
          ExecStartPost = "${lib.getExe pkgs.kopia} repository disconnect";
        };
      };

      timers.kopia-backup = {
        description = "Back up host data with Kopia";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 4:00:00";
          RandomizedDelaySec = "1h";
        };
      };
    };
  };
}
