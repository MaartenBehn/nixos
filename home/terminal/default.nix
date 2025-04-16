{ terminal, ...}: {

  imports = (if terminal == "ghostty" then [./ghostty.nix] else [])
    ++ (if terminal == "alacritty" then [./alacritty.nix] else [])
    ++ (if terminal == "kitty" then [./kitty.nix] else []);
}
