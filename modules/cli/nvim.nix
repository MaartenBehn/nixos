{ inputs, ... }: {
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = with pkgs; [
      inputs.nixvim.packages."${pkgs.stdenv.hostPlatform.system}".default
      xclip
      lazygit
      lldb
      nodePackages.prettier
      terraform
      cargo
      rustc
      shader-slang
      typst

      (writeShellScriptBin "nix-vim-update" ''
        cd /home/$USER/nixos/ 
        git add --all 
        nix flake update nixvim 
        cd -
      '')
      (writeShellScriptBin "nix-vim-rebuild" ''
        cd /home/$USER/nixos/ 
        git add --all 
        sudo nix flake update nixvim 
        sudo nixos-rebuild switch --flake . --impure 
        cd -
      '')
      (writeShellScriptBin "nix-vim-config" ''
        cd ~/dev/nixvim 
        nvim . 
        cd - 
      '')
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
