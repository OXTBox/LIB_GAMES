<!-- Spark folder manifest of Data/Scripts/FPS_Functions (model spark-x2.6-4b, 2026-11-12 15:11). DRAFT. -->

# Data/Scripts/FPS_Functions
- **Role:** This folder holds the FPS game's core logic and AI routines, providing the per-frame game update cycle, FPS AI behavior, and initialization setup used by the FPS level.
- **Entry point:** FPS_Init.lua - it runs the FPS game initialization sequence, loading level paths, engine settings, script libraries, and game state.
- **Files:**
  - FPS_AI.lua - contains the FPS AI update cycle function `handle_FPSAI`, the global `gDangerFlag` set to `false` at the top level, and scene LOD, timed sense, object distance, zombie AI, and keyboard time control logic.
  - FPS_Game.lua - defines the global state and per-frame logic for the FPS game, including `handle_FPS` and `objpart`, plus top-level globals for input, camera, and blood particle effects.
  - FPS_Init.lua - runs the FPS game initialization sequence, configuring engine and game state through setup calls and loading script libraries.
- **Shared with other folders:** It depends on `Data/` folder paths and code loaded via `dofile(...)`, globals set elsewhere such as `gSensesTime`, `gSensesInterval`, `gObjects`, `gObjectNames`, `RTS_console`, `bloodonfloor`, and engine functions including `setText_boxInfo`, `getSceneInfo`, `setSceneInfo`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `play_car_sounds`, `handle_health`, `handle_ai`, `setObjectInfo`, `getObjectInfo`, `setParticle_emitterInfo`, `fltk_update`, and host functions `time`, `string.find`, `math.random`. It is loaded by `Data/Scripts/FPS_Init.lua` via `dofile` from `Data/Scripts/FPS_Functions/FPS_*.lua`.
- **Procedure candidates:** `handle_FPSAI` - the function that runs the FPS AI update cycle; `handle_FPS` - the function that runs the FPS game input, camera/object updates, level loading, and per-frame game logic; `objpart` - the function that applies blood particle effects to objects.
- **Glossary:**
  - `handle_FPSAI` - the function that runs the FPS AI update cycle for the game.
  - `handle_FPS` - the function that runs the FPS game input, camera/object updates, level loading, and per-frame game logic.
  - `objpart` - the function that applies blood particle effects to objects.
  - `gDangerFlag` - a global flag set to `false` at the top of FPS_AI.lua to control danger state.
  - `gSensesTime` / `gSensesInterval` - globals used to manage timed sense handling in the AI cycle.
  - `setObjectInfo` / `getObjectInfo` - engine calls used to read or set object properties such as position, rotation, and other attributes.
  - `setParticle_emitterInfo` - engine call used to configure particle emitter settings.
  - `fltk_update` - engine call used to refresh the FLTK user interface after AI updates.
  - `loadLevel` - switches the active game level.
  - `dofile` - loads a Lua script file from a path.
- **Verdict:** keep - it contains the core FPS game logic, AI update routines, and initialization sequence that other game files depend on for FPS behavior and state setup.
