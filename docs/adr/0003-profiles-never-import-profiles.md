# Profiles never import profiles; the leaf declares its imports

A Profile must not import another Profile. Every Profile import is declared explicitly by the leaf — a Host (`hosts/<name>/`) or a User (`users/<name>/<host>.nix`) — so a leaf's `imports` list is a complete inventory of what is pulled into that machine or home. This reverses the earlier idea of profiles composing into hierarchies (e.g. a laptop profile importing a desktop profile).

## Why

- **Leaf as overview.** To know what a host or user gets, you read one file's `imports` list — no chasing transitive imports through profile hierarchies.
- **No hidden coupling.** With profile-on-profile imports, editing one profile silently changes the contents of every profile beneath it. Keeping composition at the leaf makes each change's blast radius visible.
- **A Profile's job is defaults, not composition.** Profiles import Modules and set their options; combining Profiles is the leaf's decision, per-host/per-user.

## Trade-off accepted

Leaves repeat their imports (`base` + `dev` + `gui`, etc. appear in several user files). That redundancy is deliberate: explicitness at the leaf outweighs DRY here, and the number of profiles stays small.