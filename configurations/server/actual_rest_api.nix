{pkgs, ...}: let 
init = pkgs.writeShellScriptBin "init" ''
    mkdir /var/lib/actual-server-api 
    cd /var/lib/actual-server-api 
    rm -rf actual-http-api/
    git clone https://github.com/jhonderson/actual-http-api.git
    cd actual-http-api

    npm install
    yarn build:server
  '';

in {

}
