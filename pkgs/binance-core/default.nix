{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  hatchling,
  aiohttp,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "binance-core";
  version = "0.1.0";
  pyproject = true;

  src =
    (builtins.fetchGit {
      url = "git@github.com:rvillebro/cryptic.git";
      ref = "main";
      rev = "5a21c6146d9f21e8bd8aaeda6aba19c11fe00390";
    })
    + "/packages/binance-core";

  build-system = [hatchling];

  dependencies = [aiohttp];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = ["binance_core"];

  meta = with lib; {
    description = "Core utilities for Binance trading";
    license = licenses.mit;
    maintainers = [];
  };
}
