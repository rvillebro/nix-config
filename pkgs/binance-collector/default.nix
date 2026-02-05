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
}:
buildPythonApplication rec {
  pname = "binance-collector";
  version = "1.0.0";
  pyproject = true;

  src =
    (builtins.fetchGit {
      url = "git@github.com:rvillebro/cryptic.git";
      ref = "main";
      rev = "89868675415caf6725bcc9d67cf805483504bb4a";
    })
    + "/apps/binance-collector-py";

  build-system = [hatchling];

  dependencies = [
    aiohttp
    polars
    typer
    textual
    python-slugify
    pydantic
    binance-core
  ];


  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = ["binance_collector"];

  meta = with lib; {
    description = "Binance data collector for crypto trading";
    license = licenses.mit;
    mainProgram = "collect-stream";
  };
}
