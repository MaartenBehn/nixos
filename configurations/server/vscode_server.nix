{ pkgs-2405, domains, local_domain, ... }: {

  networking.firewall = {
    allowedTCPPorts = [ 44820 ];
  }; 
  
  systemd.services.vscode = {
    path = with pkgs-2405; [
      openvscode-server
      nix
    ];
    ##script = "cd /home/stroby/dev/embedded_systems/ && nix-shell ./shell.nix --impure --command 'openvscode-server --without-connection-token --host ::'"; 
    script = "openvscode-server --connection-token voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6 --host 127.0.0.1 --port 8081 --accept-server-license-terms";
    # script = "openvscode-server --connection-token voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6 --host 0.0.0.0 --port 8081 --accept-server-license-terms";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
    serviceConfig.User = "stroby";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "code.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8081/"; 
      };

      serverAliases = [
        "www.code.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}

/*

OpenVSCode Server 1.88.1

Usage: openvscode-server [options]

Options
  --host <ip-address>            The host name or IP address the server should listen to. If not set, defaults to 'localhost'.
  --port <port | port range>     The port the server should listen to. If 0 is passed a random free port is picked. If a range in the format num-num is passed, a free port from the range (end
                                 inclusive) is selected.
  --socket-path <path>           The path to a socket file for the server to listen to.
  --server-base-path <path>      The path under which the web UI and the code server is provided. Defaults to '/'.`
  --connection-token <token>     A secret that must be included with all requests.
  --connection-token-file <path> Path to a file that contains the connection token.
  --without-connection-token     Run without a connection token. Only use this if the connection is secured by other means.
  --accept-server-license-terms  If set, the user accepts the server license terms and the server will be started without a user prompt.
  --server-data-dir              Specifies the directory that server data is kept in.
  --telemetry-level <level>      Sets the initial telemetry level. Valid levels are: 'off', 'crash', 'error' and 'all'. If not specified, the server will send telemetry until a client
                                 connects, it will then use the clients telemetry setting. Setting this to 'off' is equivalent to --disable-telemetry
  --user-data-dir <dir>          Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code.
  -h --help                      Print usage.

Troubleshooting
  --log <level> Log level to use. Default is 'info'. Allowed values are 'critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'. You can also configure the log level of an extension by
                passing extension id and log level in the following format: '${publisher}.${name}:${logLevel}'. For example: 'vscode.csharp:trace'. Can receive one or more such entries.
  -v --version  Print version.

Extensions Management
  --extensions-dir <dir>              Set the root path for extensions.
  --install-extension <ext-id | path> Installs or updates an extension. The argument is either an extension id or a path to a VSIX. The identifier of an extension is '${publisher}.${name}'.
                                      Use '--force' argument to update to latest version. To install a specific version provide '@${version}'. For example: 'vscode.csharp@1.2.3'.
  --update-extensions                 Update the installed extensions.
  --uninstall-extension <ext-id>      Uninstalls an extension.
  --list-extensions                   List the installed extensions.
  --show-versions                     Show versions of installed extensions, when using --list-extensions.
  --category <category>               Filters installed extensions by provided category, when using --list-extensions.
  --pre-release                       Installs the pre-release version of the extension, when using --install-extension
  --start-server                      Start the server when installing or uninstalling extensions. To be used in combination with 'install-extension', 'install-builtin-extension' and 'uninstall-extension'. 



[program:ipv4_tunnel_test_tcp]
command=socat tcp4-listen:44820,fork,reuseaddr tcp6-connect:stroby.duckdns.org:44820
autostart=yes
autorestart=yes
startsecs=3

[program:ipv4_tunnel_test_udp]
command=socat udp4-listen:44820,fork,reuseaddr udp6-connect:stroby.duckdns.org:44820
autostart=yes
autorestart=yes
startsecs=3
*/ 
