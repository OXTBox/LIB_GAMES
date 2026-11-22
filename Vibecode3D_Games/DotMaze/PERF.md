# DotMaze: making it smooth, one measured step at a time

Since 21 Nov the lean version is its own game, **DotMazeLean** (`Vibecode3D_Play_DotMazeLean.livecodescript`,
map in `DotMazeLean_map.txt`); `Vibecode3D_Play_DotMaze.livecodescript` is the original again (owner:
"save ... as DotMazeLean"), so both can be compared.

Owner, 21 Nov 2026: "the FPS of the first version is terrible, make it smooth as light, step by step."

How each step is measured: the real engine (the Game Player, Engine 1 = pure xTalk Vibecode3D) in the
LIB_MCP test standalone, `tools/engine_play.sh DotMaze Maze "65363:40 65362:40 0:60"`, same moves every
time; fps = frames drawn a second (the player's status line; from step 1 also on the game's HUD as
`FPS n`). Headless ms = `tools/headless_play.sh` (the game's rules alone, no drawing).

The game's rules run a fixed 30 steps a second whatever the fps (the engine runs missed steps back to
back), so a low fps does not slow the game: it makes it jerky. 30 fps is the ceiling: nothing changes
between steps.

| step | what changed | fps | headless ms a step | copy |
|---|---|---|---|---|
| 0 | the original: 136 wall boxes + 120 dot boxes, each its own object (8 points, 12 edges) | **7** | 0.02 | `step0_DotMaze_original.livecodescript` |
| 1 | walls = ONE mesh of loose lines: only the outline of each wall block, straight runs as one line, front and back (keeps the depth); FPS on the HUD | **11-12** | 0.01 | `step1_walls_one_mesh.livecodescript` |
| 2 | dots = ONE mesh (a 4-line square a dot), built again when a dot is eaten | **21** | 0.02 | `step2_dots_one_mesh.livecodescript` |
| 3 | the Game Player (LIB_DEV `game_player.livecodescript`, every game): the time a frame takes now comes OFF the 33 ms wait instead of on top of it. Same game script as step 2 | **30** (the ceiling) | 0.02 | LIB_DEV branch `dotmaze-perf` |
| (check) | step 0's original script with step 3's player | 9 | | |
| (check) | WreckRing with step 3's player | 30 | | |

Notes
- Game logic costs next to nothing (0.02 ms a step headless): all the time is drawing.
- Steps 1-2 stay inside the engine contract (`Mesh.New / AddVertex / AddLine / Define`), so they work
  on both engines (XT and xRay) with no contract change.
- The HUD's FPS counts frames, not steps: a step that comes 20 ms or more after the last one starts
  a new frame (missed steps run back to back a few ms apart).
- Before step 3 the player drew a frame, then waited a full 33 ms, so 15 ms of drawing gave
  1000 / 48 = 21 fps. Now it waits 33 ms minus the frame's own time: any game that draws in under
  33 ms gets the full 30.
- The marker-instance idea (`Dots.Set`, points = where, markerPoints = the shape) is a contract change
  and waits for the owner's word (`LIB_LLMOUT/Sonnet/HANDOFF_NEXT.md`).
