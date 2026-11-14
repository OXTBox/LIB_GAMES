<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Init.lua (model spark-x2.6-4b, 2026-11-12 16:33). DRAFT for Claude to review. -->

## RTS_Init.lua
- **Kind:** level-script
- **Purpose:** Loads the RTS multi-folder level setup by preloading script libraries, initializing game object variables, assigning entity behaviors, configuring scene, light, and shadow settings, and preparing the A* grid for the level.
- **Depends on:** `gameroot`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gObjects`, `RTSFUNCTIONS`, `RTSENTITIES`, `Data/` folder paths, and the libraries loaded via `dofile` (Scripts libraries, Levels folder scripts).
- **Provides:** The initialization routines and setup steps used to configure the RTS multi-folder level, including object initialization, entity behavior assignment, scene/light/shadow configuration, and A* grid preparation.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this file).
- **Procedural:** none
- **Glossary:**
  - `dofile - Loads a Lua script file into the current environment.`
  - `gLevelPath - A global path variable used to locate level folders.`
  - `gDoShadows - A global flag controlling whether shadows are enabled.`
  - `setSceneInfo - A call that configures scene-level settings.`
  - `setLightInfo - A call that configures light-level settings.`
  - `setupAStarGrid - A call that prepares the A* grid for pathfinding.`
  - `IG3D_RECEIVE_SHADOW - A constant naming the property being read or set for shadow reception.`
  - `math.random - The host's random number generator used for procedural values.`
- **Keep / port / drop:** keep (core level initialization logic that defines how multi-folder RTS levels are set up and reused).

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads the RTS multi-folder level setup, preloads script libraries, initializes game object variables, assigns entity behaviors, configures scene/light/shadow settings, and prepares the A* grid.
- **Uses:** `gameroot`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gObjects`, `RTSFUNCTIONS`, `RTSENTITIES`, `dofile`, `init_all_objects`, `HumansWithGuns`, `allEntitySoundCollLOD`, `setSceneInfo`, `setLightInfo`, `getLightInfo`, `setupAStarGrid`, `IG3D_RECEIVE_SHADOW`, `math.random`, `#`
- **Reusable:** no
- **Procedural:** no
