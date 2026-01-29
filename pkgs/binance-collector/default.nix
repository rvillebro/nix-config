{
  lib,
  buildPythonApplication,
  hatchling,
  # dependencies
  aiohttp,
  polars,
  typer,
  textual,
  python-slugify,
  pydantic,
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
      rev = "3e8c94d5168cceba26fa95fc62a1fb292285f562";
    })
    + "/apps/binance-collector";

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

  pythonImportsCheck = ["binance_collector"];

  meta = with lib; {
    description = "Binance data collector for crypto trading";
    license = licenses.mit;
    mainProgram = "collect-stream";
  };
}
