{ lib, fetchPypi, beets, essentia-extractor, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "beets-xtractor";
  version = "0.4.2";

  src = fetchPypi {
    pname = "beets_xtractor";
    inherit version;
    sha256 = "sha256-wn25Kewkj0oT+BVnLFuJaLAbZGLkA2eu6bgF1rWTGIk=";
  };

  nativeBuildInputs = [
    beets
  ];

  propagatedBuildInputs = [
    essentia-extractor
  ];

  meta = with lib; {
    description = "A beets plugin to add low and high level musical information to songs.";
    homepage = "https://github.com/adamjakab/BeetsPluginXtractor";
    maintainers = with maintainers; [ johnhamelink ];
    license = licenses.mit;
  };
}
