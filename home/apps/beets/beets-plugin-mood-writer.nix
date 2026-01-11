{ lib, pkgs, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "beets-mood-writer";
  version = "1.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "MaartenBehn";
    repo = "beets-mood";
    rev = "edeae040c23b5b794becdfc04274c0790c27c1d3";
    hash = "sha256-u5nv77NIVEuO/DU1pDL3CcYa1OURkcjsKv+4rrpMLfI=";
  };


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
