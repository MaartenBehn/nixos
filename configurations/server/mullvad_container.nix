{ pkgs, lib, nix-version, ... }: {
# skim this blog post:
# https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
networking.nat.enable = true;
networking.nat.internalInterfaces = [ "ve-mullvad-vpn" ];

# change this to your actual network interface (run ifconfig or ip a)
networking.nat.externalInterface = "enp3s0f3u1";

# critical fix for mullvad-daemon to run in container, otherwise errors with: "EPERM: Operation not permitted"
# It seems net_cls API filesystem is deprecated as it's part of cgroup v1. So it's not available by default on hosts using cgroup v2.
# https://github.com/mullvad/mullvadvpn-app/issues/5408#issuecomment-1805189128
fileSystems."/tmp/net_cls" = {
  device = "net_cls";
  fsType = "cgroup";
  options = [ "net_cls" ];
};

containers.mullvad-vpn = {
  ephemeral = true;
  autoStart = true;
  privateNetwork = true;

  # these IP choices are arbitrary, copied from https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
  hostAddress = "192.168.100.10";
  localAddress = "192.168.100.11";

  bindMounts = {
    "/etc/mullvad-vpn" = {
      hostPath = "/etc/mullvad-vpn";
      isReadOnly = false;
    };
    "/var/cache/mullvad-vpn" = {
      hostPath = "/var/cache/mullvad-vpn";
      isReadOnly = false;
    };
    "/var/log/mullvad-vpn" = {
      hostPath = "/var/log/mullvad-vpn";
      isReadOnly = false;
    };

    "/media" = {
      hostPath = "/media";
      isReadOnly = false;
    };
    };

    config =
      { pkgs, ... }:
      {
        system.stateVersion = nix-version;

        # apparently need this for DNS to work
        networking.useHostResolvConf = false;
        services.resolved.enable = true;

        services.mullvad-vpn.enable = true;
        # each mullvad account login will generate a new "device" (wireguard key)
        # and you're limited to 5 devices per account
        # go to https://mullvad.net/en/account/devices to clear out old devices
        systemd.services."mullvad-daemon".postStart = ''
        while ! ${pkgs.mullvad}/bin/mullvad status >/dev/null; do sleep 1; done

        # REPLACE with your actual mullvad account number
        account="1403472689034236"

        # only login if we're not already logged in otherwise we'll get a new device
        current_account="$(${pkgs.mullvad}/bin/mullvad account get | grep "account:" | sed 's/.* //')"
        if [[ "$current_account" != "$account" ]]; then
        ${pkgs.mullvad}/bin/mullvad account login "$account"
        fi

        ${pkgs.mullvad}/bin/mullvad lan set allow
        ${pkgs.mullvad}/bin/mullvad relay set location us sjc
        ${pkgs.mullvad}/bin/mullvad lockdown-mode set on
        ${pkgs.mullvad}/bin/mullvad auto-connect set on

        # disconnect/reconnect is dirty hack to fix mullvad-daemon not reconnecting after a suspend
        ${pkgs.mullvad}/bin/mullvad disconnect
        sleep 0.1
        ${pkgs.mullvad}/bin/mullvad connect
        '';


        systemd.services.qbittorrent-nox = {
          path = with pkgs; [
            qbittorrent-nox
          ];
          script = "qbittorrent-nox";
          wantedBy = [ "network-online.target" ];
		      after = [ "network.target" ];
          serviceConfig.User = "stroby";
        };


      };
  };
}
