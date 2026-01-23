{ lib, pkgs, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "beets-mood-writer";
  version = "0.0.5";

  src = pkgs.fetchFromGitHub {
    owner = "MaartenBehn";
    repo = "beets-mood";
    rev = "c8eb13eb7056b37072b8ccf801d5c78a5cdd3d05";
    hash = "";
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
