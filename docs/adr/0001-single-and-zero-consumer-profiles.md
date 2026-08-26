# Single- and zero-consumer NixOS profiles are allowed

The NixOS profile taxonomy permits profiles imported by only one host (or by no active host), rather than minimizing to only multi-host-shared profiles. `desktop.nix` serves only xps13, `server.nix` only rpi4, and `media-server.nix` is imported by no active host but kept as a dormant profile for future use (all its services are currently commented out).

This is a deliberate scope decision. "Minimize the number of profiles" means minimizing *redundant roles*, not forcing each profile to earn reuse. Profiles define reusable categories of machine; a category may today describe a single box, and still be worth carving out for the shape it gives the host layer (a thin, hardware-only leaf) and for future reuse.