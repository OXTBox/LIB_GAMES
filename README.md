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
| `Vibecode3D_Play_Antack.livecodescript` | Antack: the owner's uDevGame 2002 T3D game as a vector game. Title, Fight 1-4, Trainer, You Win / You Lost. Data: `Antack/antack_data.txt`, made from `T3D_Texts` by `tools/t3d_to_antack.py` |
| `Vibecode3D_Play_Face.livecodescript` | Face: Claude's face as vector blocks, the "LIB_MCP connected" card. Needs `../LIB_MCP` and `../LIB_MAP` |
| `Vibecode3D_Play_Amazing_Couple.livecodescript` | Amazing Couple (was Heroes): third-person companions in a 1-bit generated vector maze (`Bit.Maze`), starring PROMPT & GLAZE (`../PROMPT_GLAZE`). Stick figures with their own captured walk and idle and a captured jog on Shift, all from LIB_MOCAP; the one you are not playing follows by `Map.FindPath`; TAB switches; reach the gold beacon together for a new maze. Runs in Vibecode3D and in the xt3d games bench. Needs `../LIB_BIT`, `../LIB_MAP`, `../LIB_MOCAP/library` |
| `Vibecode3D_Play_Thrmnlra.livecodescript` | GLRBAL THRMNLRA RWA (working title): the owner's typing war game, and the first game made with the **Sequencer** (cutscenes as clips on a timeline, `Sequencer/README.md`). Intro and Map sequences in `Thrmnlra/Data/`; design in `Thrmnlra/DESIGN.md` |
| `Vibecode3D_Play_uDead.livecodescript` | uDead: the owner's uDeadGame (iGame3D, uDevGames 2008) as a vector game. You command a horde of the dead: click to send or attack, F follow, H hold, R rush, Z zombie time. Generated maps (highway hotel, warehouse, alley, container yard, arcade, round again and harder); the 30 maps of 2009 as legacy (`uDead/udead_levels.txt`, made by `tools/udg_to_udead.py`). Design and what is tested: `uDead/DESIGN.md` |
| `Vibecode3D_Play_NineBall.livecodescript` | Nine Ball: **Scott Rossi's nine ball with Jim Hurley's table physics**, rewritten for Vibecode3D and xt3d (credits, what is kept and what changed: `NineBall/README.md`). Two players, nine ball rules; drag from the cue ball with the mouse, or arrows + Space |
| `Vibecode3D_Play_BankShotBounce.livecodescript` | Bank Shot Bounce: the owner's billiards idea, concept and levels by Spark, **table physics by Jim Hurley** (as in Nine Ball). Sink the numbered balls in order, keep your white ball out; five tables (plain, slick felt, bumper, sliding pockets, hourglass on sticky felt). Drag back from your ball (slingshot) or arrows + Space. Notes: `BankShotBounce/README.md` |
| `Vibecode3D_Play_BatDuel` `WallBreaker` `LongWorm` `SkyRaiders` `VineRun` `RockField` `CrossTraffic` `DotMaze` `StackDown` `SoftLanding` `CityShield` `DeepDive` | Twelve small original arcade games: Spark wrote each concept and level table, Claude the script (`../LIB_SPARK/arcade/REVIEW.md`). Arrows and Space; 5 levels each |

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

`tools/headless_play.sh <Game> <Prefix> "<keys>:<steps> ..."` runs a game card's rules with no window (engine calls stubbed by `tools/engine_stubs.livecodescript`): it catches run-time errors and checks rules; it does not show the game.

The stand-ins are the engine contract (`LIB_ig3d/ENGINE_CONTRACT.md`) as code: one for every call the contract lists and the XT engine has, and nothing else, so a game that passes headless calls only the contract. `python3 -I ../LIB_ig3d/tools/contract_check.py --stubs` checks that; without `--stubs` it lists what every game uses outside the contract.

Every script here is compile-checked with `~/projects/LIB_MCP/tools/lcmcp compile` before
it is committed.

## Licence

GPL-3.0 (see `LICENSE`), because the xTalk work here is built on the GPL-licensed LiveCode Community 9 engine. Copyright (c) 2026 xAction.

The Python files (`.py`) and other material that is not xTalk are also offered under the MIT licence, Copyright (c) 2026 xAction: you may use them under either licence.
