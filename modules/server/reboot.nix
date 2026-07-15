{
  flake.modules.nixos.server = { pkgs, ... }: {
    systemd.services.daily-reboot = {
      description = "Reboot the system daily at 6am";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
      };
    };

    systemd.timers.daily-reboot = {
      description = "Timer for daily reboot at 6am";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 06:00:00";
        Persistent = true;
        Unit = "daily-reboot.service";
      };
    };
  };
}
