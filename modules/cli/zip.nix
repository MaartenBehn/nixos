{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = with pkgs; [
      (writeShellScriptBin "compress" '' 
        if (($# == 1)); then
            tar -cvzf "$1.tar.gz" $1
        else
            echo "Wrong number of arguments..."
        fi     
      '')
      (writeShellScriptBin "extract" ''    
        for i in "$@"; do
            tar -xvzf $i
            break
        done  
      '')
    ];
  };
}
