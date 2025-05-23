{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        ms-vscode.hexeditor

        ## Rust
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer
        fill-labs.dependi
        tamasfe.even-better-toml

        # Theme
        enkia.tokyo-night
        pkief.material-icon-theme
    ];

    userSettings = {
      workbench.colorTheme = "Tokyo Night Storm";
      workbench.iconTheme = "material-icon-theme";
      workbench.productIconTheme = "material-product-icons";

      editor.minimap.enabled = false;
      editor.renderWhitespace = "selection";
      editor.renderLineHighlight = "none";
      editor.overviewRulerBorder = false;
      editor.hideCursorInOverviewRuler = true;
    };
  };
}
