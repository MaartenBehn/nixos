{ lib, pkgs, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "beets-mood-writer";
  version = "1.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "MaartenBehn";
    repo = "beets-mood";
    rev = "1f098666b8682d227232f2ba8ee7744bcfca9de1";
    hash = "sha256-+6Mq8mR/tF1Z+GyooMz9fWGV57bFhbHXBVBDkHpUMDA="; # build and get the hash from the error
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
