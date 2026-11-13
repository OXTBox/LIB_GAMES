<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Init.lua (model spark-x2.6-4b, 2026-11-12 17:22). DRAFT for Claude to review. -->

## UDG_Init.lua
- **Kind:** engine-core
- **Purpose:** This file initializes the UDG game engine by setting global game state variables, preloading engine and RTS helper scripts, loading UDG entity scripts, and running the initialization phase that places objects, creates safe places, and checks game end conditions. It serves as the entry point for starting a UDG game session.
- **Depends on:** `Data/` folder paths, `Scripts/` folder libraries (RTS helper scripts, UDG function modules), globals set elsewhere such as `gameroot`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gLastClick`, `gDoubleClickInterval`, `gStatusString`, `gCameraSpeed`, `gVelocityClamp`, `levelislit`, `RTSFUNCTIONS`, `UDGENTITIES`, `gObjects`, `gObjectPositions`; engine calls like `dofile`, `loadLevel`, `make`, `get`, `getObjectInfo`, `setObjectInfo`, `setBoneInfo`, `setSceneInfo`, `setCameraInfo`, `setLightInfo`, `getCameraInfo`, `setSound_emitterInfo`, `assign_free_sound_emitter`, `setupAStarGrid`.
- **Provides:** Global game state variables and initialization functions including `udg_init`, `udg_place_objects_randomly`, `udg_create_safe_places_randomly`, `checkGameEndCondition`, plus the entity scripts loaded to initialize game objects.
- **Assets it needs:** none named explicitly (no model, image, sound, emitter, or font file names are listed in the provided code).
- **Procedural:** yes - the file generates game state by running procedural initialization steps including random object placement, safe place creation, and game end condition checks based on engine rules and game state variables.
- **Glossary:**
  - `setObjectInfo - Sets properties on an object using the IG3D_* constant to name the property being read or set.`
  - `getObjectInfo - Reads object properties using the IG3D_* constant to name the property being read.`
  - `ig3d_object - The kind of object passed as the first argument to make/get calls in the engine.`
  - `IG3D_* constants - Engine constants used to name properties being read or set on objects, scenes, cameras, lights, bones, materials, particles, and text boxes.`
  - `dofile - Engine call used to load Lua scripts from a file path.`
  - `loadLevel - Engine call used to switch the active game level.`
  - `gObjects - Global table holding game objects shared across files.`
  - `gObjectPositions - Global table holding object positions used during initialization.`
- **Keep / port / drop:** keep - this is the core initialization entry point for UDG games and provides reusable setup logic for new engine implementations.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets global game state variables, preloads engine and RTS helper scripts, then loads UDG entity scripts to initialize game objects.
- **Uses:** `gameroot`, `dofile`, `gLevelPath`, `gDoShadows`, `gMasterAnimSource`, `gSelectionRectModel`, `gTrackingLight`, `gObjCycle`, `gTeamSelect`, `gLastClick`, `gDoubleClickInterval`, `gStatusString`, `gCameraSpeed`, `gVelocityClamp`, `levelislit`, `RTSFUNCTIONS`, `UDGENTITIES`, `init_all_objects()`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Loads UDG function modules, runs the init phase, and triggers random object placement, safe place creation, and game end condition checks.
- **Uses:** `gameroot`, `dofile`, `UDGFUNCTIONS`, `udg_init`, `udg_place_objects_randomly`, `udg_create_safe_places_randomly`, `checkGameEndCondition`
- **Reusable:** no

### udg_init
- **Does:** Initializes the game state by setting player box properties, assigning default behaviours and sound emitters, configuring object shapes and collision settings, setting camera and light positions, restoring object positions, and running game setup functions.
- **Uses:** `setObjectInfo`, `gObjects`, `playerBox`, `randomWalking`, `default_behaviour`, `default_behaviour2`, `standard_flee`, `flee_to_safe_place`, `zombie_behaviour`, `follow_player`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `getCameraInfo`, `setLightInfo`, `setCameraInfo`, `get`, `ig3d_object`, `ig3d_particle_emitter`, `isFemale`, `getObjectInfo`, `IG3D_*` constants, `gObjectPositions`, `crosshair`, `bloodonfloor`, `HumansWithGuns`, `HumansWithMeleeWeapons`, `allEntitySoundCollLOD`, `setupAStarGrid`, `setBoneInfo`, `setSceneInfo`, `print`
- **Reusable:** no

### udg_place_objects_randomly
- **Does:** Randomly places game objects according to the engine's placement rules.
- **Uses:** nothing
- **Reusable:** no

### udg_create_safe_places_randomly
- **Does:** Randomly creates safe places for gameplay.
- **Uses:** nothing
- **Reusable:** no

### checkGameEndCondition
- **Does:** Checks whether the game should end based on current game state.
- **Uses:** nothing
- **Reusable:** no
