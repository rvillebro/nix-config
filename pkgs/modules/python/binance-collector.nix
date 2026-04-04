{
  lib,
  buildPythonApplication,
  hatchling,
  pytestCheckHook,
  aiohttp,
  polars,
  typer,
  textual,
  python-slugify,
  pydantic,
  pytest-asyncio,
  binance-core,
  sd-notify,
  crypticSrc,
}:
buildPythonApplication rec {
  pname = "binance-collector";
  version = "1.0.0";
  pyproject = true;

  src = crypticSrc + "/apps/binance-collector-py";

  build-system = [hatchling];

  dependencies = [
    aiohttp
    polars
    typer
    textual
    python-slugify
    pydantic
    binance-core
    sd-notify
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = ["binance_collector"];

  meta = with lib; {
    description = "Binance data collector for crypto trading";
    license = licenses.mit;
    mainProgram = "binance-collector";
  };
}
