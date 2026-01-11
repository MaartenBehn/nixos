{ lib, pkgs, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "beets-mood-writer";
  version = "0.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "MaartenBehn";
    repo = "beets-mood";
    rev = "15a94d64e5c5bcc28ba7281f9cc37a8d05a884c2";
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
