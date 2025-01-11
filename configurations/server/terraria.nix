{config, lib, pkgs, ...}: let 

	dataDir = "/var/lib/terraria";
	worldDir = "${dataDir}/worlds";

	# Simple config file serializer. Not very robust.
	mkConfig = options:
		builtins.toFile
			"terraria.cfg"
			(lib.concatStrings
				(lib.mapAttrsToList
					(name: value: "${name}=${toString value}\n")
					options));

	# Config Generator
	mkWorld = name: {
		worldSize ? "large",
	}: {
		config = mkConfig {
			world = "${worldDir}/${name}.wld";
			password = "1234";
			seed = "stroby-${name}";
			autocreate = { small = 1; medium = 2; large = 3; }.${worldSize};
			upnp = 0;
		};
	};

	# High-level Config
	worlds = lib.mapAttrs mkWorld {
		my-first-world = {};
		some-other-world = {
			worldSize = "medium";
		};
	};

	world = worlds.my-first-world;
in {

   
	users.users.terraria = {
    isSystemUser = true;
		group = "terraria";
		home = dataDir;
		uid = config.ids.uids.terraria; # NixOS has a Terraria user, so use those IDs.
	};

	users.groups.terraria = {
		gid = config.ids.gids.terraria;
	};

	systemd.sockets.terraria = {
		socketConfig = {
			ListenFIFO = ["/run/terraria.sock"];
			SocketUser = "terraria";
			SocketMode = "0660";
			RemoveOnStop = true;
		};
	};

	systemd.services.terraria = {
		wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];
		bindsTo = ["terraria.socket"];

		preStop = ''
			printf '\nexit\n' >/run/terraria.sock
		'';

		serviceConfig = {
			User = "terraria";
			ExecStart = lib.escapeShellArgs [
				"${pkgs.terraria-server}/bin/TerrariaServer"
				"-config" world.config
			];

			StateDirectory = "terraria";
			StateDirectoryMode = "0750";

			StandardInput = "socket";
			StandardOutput = "journal";
			StandardError = "journal";

			KillSignal = "SIGCONT"; # Wait for exit after `ExecStop` (https://github.com/systemd/systemd/issues/13284)
			TimeoutStopSec = "1h";
		};
	};

  networking.firewall = {
    allowedTCPPorts = [ 
      7777
      7778
    ];
  };

  environment.systemPackages = with pkgs; [
    _6tunnel
  ];

  # stroby.backup.terraria.paths = [
  # 	dataDir
  #];
}
