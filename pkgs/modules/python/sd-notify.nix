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
  pname = "sd-notify";
  version = "0.1.0";
  pyproject = true;

  src = crypticSrc + "/packages/sd-notify";

  build-system = [hatchling];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = ["sd_notify"];

  meta = with lib; {
    description = "Systemd Notifier and Watchdog helper";
    license = licenses.mit;
    maintainers = [];
  };
}
