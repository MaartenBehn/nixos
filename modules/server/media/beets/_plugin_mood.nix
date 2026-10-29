{ lib, pkgs, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "mood";
  version = "0.0.1";

  /*
  src = pkgs.fetchFromGitHub {
    owner = "MaartenBehn";
    repo = "beets-mood";
    rev = "980c955224ed1821da64b3e82c8286a49a534611";
    hash = "sha256-a0clBsC58suG7JQPlJiH3OUnmV1/L1jCFqEO3b9d+bQ=";
  };
  */
  src = /home/stroby/dev/beets-mood;

  nativeBuildInputs = [
    beets
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  meta = with lib; {
    description = ''
    '';
    homepage = "https://github.com/MaartenBehn/beets-mood";
    maintainers = with maintainers; [ MaartenBehn ];
    license = licenses.mit;
  };
}
