{ lib, fetchPypi, beets, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "beets-lidarr-fields";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wlybw3v0QLfeIgbezz5PQdbGFsu9KLI1AkVQD4CrgI4=";
  };

  nativeBuildInputs = [
    beets
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  meta = with lib; {
    description = ''
    Beets plugin that defines some useful template fields to customize
    your path formats in a more lidarr (default) way.
    '';
    homepage = "https://github.com/rafaelparente/beets-lidarr-fields";
    maintainers = with maintainers; [ johnhamelink ];
    license = licenses.mit;
  };
}
