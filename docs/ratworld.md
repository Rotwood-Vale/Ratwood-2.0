# Ratworld (Persistent Rogueworld)

This is an initial scaffolding for Ratworld, a persistent-leaning game mode building on the unused Rogueworld concept.

What’s in this PR (so far):

- Map config `_maps/ratworld.json` that reuses the Rogueworld map bundle.
- Auto-loading of Ratworld extra z-levels (`_maps/map_files/otherz/ratworld.json`).
- Core modules under `code/modules/ratworld/`:
  - `rarity.dm`: item rarity constants and helpers (Common → Artifact, Ascendant placeholder).
  - `socketing.dm`: generic component to socket `/obj/item/roguegem` into items with failure risk for non-magicians.
  - `stash.dm`: per-player vault (Mammon bank) persisted to `data/player_saves/<c>/<ckey>/ratworld/stash.json` with simple testing verbs.
  - `roles.dm`: admin-managed persistent roles (duke/priest/etc.) stored in `data/ratworld/roles.json` and loaded by Persistence SS.
- Unit tests: rarity mapping and socketing happy-path smoke test.

Enabling Ratworld locally:

1. Open `code/rt.dm` and uncomment `#define RATWORLD` (near the top).
2. Build as usual; the map will be forced to `_maps/ratworld.json`.

Trying the Vault (temporary verbs):

- In-game, use these verbs under the "Ratworld" category:
  - "Vault Balance" — prints your current mammon balance.
  - "Deposit Mammon" — moves mammon from your on-hand account to the vault.
  - "Withdraw Mammon" — pulls from the vault to your on-hand account.

Notes and follow-ups:

- A TGUI for the stash plus item deposit/withdrawal is planned; current stash handles mammon only.
- Gem socketing is opt-in via `AddComponent(/datum/component/ratworld_socketable, max_sockets)`. Wiring for specific gear and reroll attributes will follow.
- Role assignment is admin-only for now (`Ratworld` verbs: Assign Duke/Duchess, Assign Priest, View Roles).
- Death/burial changes are sketched but not enforced yet; see the design doc and `code/modules/ratworld/` for stubs.

