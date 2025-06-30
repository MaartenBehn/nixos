{ pkgs, ... }: {
  home.packages = (with pkgs; [ 
    unityhub 
    vscode
  ]);
}
