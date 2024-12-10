{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer
    ];
  };
}
