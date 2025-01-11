{ 
  config, 
  lib, 
  pkgs,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  unzip,
  zlib, 
...}: 
let   
  terraria-server = stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.4.9";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    sha256 = "sha256-Mk+5s9OlkyTLXZYVT0+8Qcjy2Sb5uy2hcC8CML0biNY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];
  buildInputs = [
    stdenv.cc.cc.libgcc
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    mainProgram = "TerrariaServer";
    maintainers = with maintainers; [
      ncfavier
      tomasajt
    ];
  };
  };

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
				"${terraria-server}/bin/TerrariaServer"
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
