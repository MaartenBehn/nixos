{ lib, fetchPypi, beets, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "beets-check";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "beets_check";
    inherit version;
    sha256 = "sha256-f2HV0Pj9M0i9AazFuR5oB9rwLEiHAclLtud3wIiGrNU=";
  };

  nativeBuildInputs = [
    beets
    python3Packages.poetry-core
  ];

  meta = with lib; {
    description = "beets plugin verifying file integrity with checksums";
    homepage = "http://www.github.com/geigerzaehler/beets-check";
    maintainers = with maintainers; [ johnhamelink ];
    license = licenses.mit;
  };
}
