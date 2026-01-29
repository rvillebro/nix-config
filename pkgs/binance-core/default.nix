{
  lib,
  buildPythonPackage,
  hatchling,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "binance-core";
  version = "0.1.0";
  pyproject = true;

  src =
    (builtins.fetchGit {
      url = "git@github.com:rvillebro/cryptic.git";
      ref = "main";
      rev = "347f6fc15b689ad81d0e6f8abbb900abacad9e45";
    })
    + "/packages/binance-core";

  build-system = [hatchling];

  dependencies = [aiohttp];

  pythonImportsCheck = ["binance_core"];

  meta = with lib; {
    description = "Core utilities for Binance trading";
    license = licenses.mit;
    maintainers = [];
  };
}
