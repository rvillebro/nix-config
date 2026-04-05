{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  hatchling,
  aiohttp,
  pytest-asyncio,
  crypticSrc,
}:

buildPythonPackage rec {
  pname = "binance-core";
  version = "0.1.0";
  pyproject = true;

  src = crypticSrc + "/packages/binance-core";
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
