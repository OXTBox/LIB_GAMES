<!-- Spark first-look of Data/Scripts/FPS_Functions/FPS_Init.lua (model spark-x2.6-4b, 2026-11-12 15:10). DRAFT for Claude to review. -->

## FPS_Init.lua
- **Kind:** level-script
- **Purpose:** This file runs the initialization sequence for the iGame3D FPS game, loading level paths and engine settings, preloading script libraries, setting up game objects and entity behaviors, configuring the scene, camera, light, particle, and object settings, and loading the FPS-specific function scripts. It is a setup sequence specific to the FPS game's startup.
- **Depends on:** `gameroot`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gObjects`, `RTSFUNCTIONS`, `RTSENTITIES`, `FPSFUNCTIONS`, and the script libraries loaded via `dofile` from `Data/Scripts/Functions/math_functions.lua`, `Data/Scripts/RTS_Functions/RTS_*.lua`, `Data/Scripts/RTS_Functions/RTS_Entities/RTS_*.lua`, and `Data/Scripts/FPS_Functions/FPS_*.lua`.
- **Provides:** No standalone functions or globals are defined here; it configures engine and game state through the setup calls listed in the file.
- **Assets it needs:** none named in this file (no models, images, sounds, emitters, or fonts are referenced).
- **Procedural:** none
- **Glossary:**
  - `dofile` - Loads a Lua script file from a path.
  - `loadLevel` - Switches the active game level (not used in this file's code).
  - `gObjects` - A shared global table holding game objects.
  - `setSceneInfo` - Configures scene-level settings for the game.
  - `setLightInfo` - Configures light settings for the game.
  - `getLightInfo` - Reads current light settings for the game.
  - `setParticle_emitterInfo` - Configures particle emitter settings for the game.
  - `getObjectInfo` - Reads property values from an object.
- **Keep / port / drop:** keep - it is the core initialization sequence for the FPS game and serves as a reference for setting up engine and game state.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads level path and engine settings, preloads script libraries, initializes game objects and entity behaviors, configures scene, camera, light, particle and object settings, and loads FPS-specific function scripts.
- **Uses:** `gameroot`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gObjects`, `RTSFUNCTIONS`, `RTSENTITIES`, `FPSFUNCTIONS`, `dofile`, `init_all_objects`, `HumansWithGuns`, `allEntitySoundCollLOD`, `setSceneInfo`, `setLightInfo`, `getLightInfo`, `math.random`, `get`, `getObjectInfo`, `setObjectInfo`, `getCameraInfo`, `setBoneInfo`, `getCameraInfo`, `setParticle_emitterInfo`, `loadLevel` (not used in this code), `Data/` paths such as `Data/Scripts/Functions/math_functions.lua`, `Data/Scripts/RTS_Functions/RTS_*.lua`, `Data/Scripts/RTS_Functions/RTS_Entities/RTS_*.lua`, `Data/Scripts/FPS_Functions/FPS_*.lua`
- **Reusable:** no - it is a setup sequence specific to the iGame3D FPS game initialization.
- **Procedural:** no
