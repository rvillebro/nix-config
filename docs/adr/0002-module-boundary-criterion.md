# Module boundary: module only for a coherent multi-knob bundle

A capability earns a `modules/*` module only when it is a **coherent bundle**: more than one knob, with interconnected tools/settings that must play together behind its option namespace. Single knobs and fixed/no-variation facts are not module-worthy.

Reaching for `lib.mkDefault` (in a profile / base fact) and `lib.mkForce` or a plain value (at the host/user leaf) is the preferred alternative to a module when the variation is just *default-vs-override* across a small number of leaves — it adds no option boilerplate for a decision boundary that doesn't need one.

## Applied

- **`modules/nixos/`** — only `binance-collector` qualifies today (multi-knob: `stream`/`rest`/config paths + interconnected service user, group, systemd units, hardening). Locale/timezone, the `nix` setup + gc schedule, and the `rav` user account are uniform base facts → inline in `profiles/nixos/base.nix`. Networking/firewall is role texture → inline in the role profiles (`desktop`/`server`).
- **`modules/home-manager/`** — **empty**: no module-worthy bundle. The shared git identity + ssh client + shell/editors are base facts → `mkDefault` in `profiles/home/base.nix`; a per-machine user leaf overrides with `mkForce`/plain.

## Namespace and collection

- A single umbrella **`myConfig`** is the option namespace across both `modules/nixos/*` and (future) `modules/home-manager/*`. `binance-collector` migrates from `rav.nixos.binance-collector` to `myConfig.binance-collector.*`.
- Both `modules/nixos/default.nix` and `modules/home-manager/default.nix` use the standard collection shape `{ imports = [ ./<file>.nix ... ]; }`; a consumer pulls the whole dir with `imports = [ ../../modules/nixos ]`. The previous attrset-export shape (`binance-collector = import ...`) is dropped.