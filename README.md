# LIB_GAMES

Game and demo scripts for the owner's engines, kept as plain text files. Purpose:
`LIB_GAMES_Purpose.md`.

| Folder | What it holds |
|---|---|
| `Vibecode3D_Games/` | Card scripts for Vibecode3D, one file per `Play.<Game>` card: `Vibecode3D_Play_<Game>.livecodescript` |
| `xt3d_Games/` | Games and demos for xt3d (empty so far) |
| `TEMPLATES_DO_NOT_COMMIT/` | Old iGame3D and T3D games to recreate. Not in git (see `.gitignore`); to be looked at later |

## Vibecode3D games

Each file is the whole script of one game card. The rules for writing one (hooks such as
`Game.OnStart`, name prefixes, Escape to Developer) are in
`~/projects/Vibecode3D/LiveCode_Claude_Kit/kit/docs/game-cards.md`.

| File | Game |
|---|---|
| `Vibecode3D_Play_Canyon.livecodescript` | Canyon: 3D canyon run from the 2D "Defensive" |
| `Vibecode3D_Play_Hunter.livecodescript` | Hunter: first-person gem hunt |
| `Vibecode3D_Play_demo.livecodescript` | Demo: engine showcase |
| `Vibecode3D_Play_Simple_Test1.livecodescript` | Spinning cube: the standard first test (click reverses the spin) |
| `Vibecode3D_Play_Simple_Test2.livecodescript` | small test |
| `Vibecode3D_Play_Face.livecodescript` | Face: Claude's face as vector blocks, the "LIB_MCP connected" card. Needs `../LIB_MCP` and `../LIB_MAP` |

### Putting a game into the stack

With the Vibecode3D stack open in the IDE (so `MCP.Attach` has started LIB_MCP on port
8766), Claude can do it from WSL. By hand, type this into the IDE's Message Box (change
`Face` to the game's name), then save the stack:

```
Game.Rebuild "Face", false
set the script of card "Play.Face" to URL "file://wsl$/Ubuntu/home/igame3d/projects/LIB_GAMES/Vibecode3D_Games/Vibecode3D_Play_Face.livecodescript"
save.card.script.to.set "Play.Face"
Game.Select "Face"
Game.Play
```

`Game.Rebuild` makes the card; the script is then stored in the stack's
`GAME_CARD_SCRIPTS` set, so later rebuilds keep it.

Every script here is compile-checked with `~/projects/LIB_MCP/tools/lcmcp compile` before
it is committed.
