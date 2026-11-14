<!-- Spark first-look of Data/Scripts/iFly_Functions/iFly_Init.lua (model spark-x2.6-4b, 2026-11-12 17:54). DRAFT for Claude to review. -->

## iFly_Init.lua
- **Kind:** engine-core
- **Purpose:** Initializes the iFly game by loading math and plane libraries, reading control and option files, setting global shadow, cloud, and mouse state, and running the full iFly startup sequence including object setup, sound emitter configuration, cloud generation, and camera/plane initialization.
- **Depends on:** `Data/Scripts/iFly_Functions/...` libraries, `Data/Levels/iFly/...` level files, `Data/Sounds/...` sound files, engine constants (`IG3D_ROOT`, `IG3D_BONE_COLL`, `IG3D_MASS`, `IG3D_COLL`, `IG3D_SIZE`, `IG3D_IGNORE_COLL`, `IG3D_BILLBOARD_Z`, `IG3D_SAMPLE`, `IG3D_POSITION`, `IG3D_REPEAT`), and globals set elsewhere (`gShadows`, `gClouds`, `gMouseSpeed`, `gPowerUpsStart`, `gPowerUpsEnd`, `gPickupDistance`, `gReachDistance`, `gProtectionDistance`, `gMaxThrottle`, `gMinThrottle`, `gEnemyThrottle`, `gTimeToImpact`, `gNumDeadEnemies`, `gCamVector`, `gCamRot`, `gNumAttackPaths`, `gNumDefendPaths`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `firstFrame`).
- **Provides:** Global state and constants for iFly initialization (shadow, cloud, mouse, power-up, distance, throttle, and camera variables), plus the iFly startup steps including object setup, sound emitter configuration, cloud generation, camera and plane initialization.
- **Assets it needs:** none named (no models, images, sounds, emitters, or fonts are explicitly listed in this file's code).
- **Procedural:** none
- **Glossary:**
  - `dofile - Loads a Lua file so its code runs in the current script.`
  - `make - Creates an engine object of a named kind using a file path.`
  - `get - Reads a named property from an object.`
  - `setObjectInfo - Sets a named property (e.g. position) on an object.`
  - `setParticle_emitterInfo - Configures a particle emitter's settings.`
  - `setSound_emitterInfo - Configures a sound emitter's settings.`
  - `make_cloud - Generates a cloud object for the game.`
  - `loadLevel - Switches the active level folder.`
- **Keep / port / drop:** keep (core initialization logic that defines the shared global state and startup steps reusable across iFly variants)

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads the iFly math and plane libraries, reads control and option files into tables, sets global shadow/cloud/mouse state, defines global constants and camera variables, loads the AI library, and runs the iFly initialization steps including object setup, sound emitter configuration, cloud generation, camera and plane initialization.
- **Uses:** `getSceneInfo`, `dofile`, `io.lines`, `make`, `get`, `setObjectInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `getObjectInfo`, `make_cloud`, `updateFromVisualCamera`, `init_plane`, `init_enemies`, `init_friends`, `gObjects`, `Data/` paths (`Data/Scripts/iFly_Functions/...`, `Data/Levels/iFly/...`, `Data/Sounds/...`), engine constants (`IG3D_ROOT`, `IG3D_BONE_COLL`, `IG3D_MASS`, `IG3D_COLL`, `IG3D_SIZE`, `IG3D_IGNORE_COLL`, `IG3D_BILLBOARD_Z`, `IG3D_SAMPLE`, `IG3D_POSITION`, `IG3D_REPEAT`), globals (`gShadows`, `gClouds`, `gMouseSpeed`, `gPowerUpsStart`, `gPowerUpsEnd`, `gPickupDistance`, `gReachDistance`, `gProtectionDistance`, `gMaxThrottle`, `gMinThrottle`, `gEnemyThrottle`, `gTimeToImpact`, `gNumDeadEnemies`, `gCamVector`, `gCamRot`, `gNumAttackPaths`, `gNumDefendPaths`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `firstFrame`), and variables (`controls`, `options`, `cloudpath`, `muzzle`, `muzzlestart`, `ship`, `mother`, `motherengine`, `gun`, `hitSnd`, `engineSnd`, `gunSnd`, `water`, `camera`).
- **Reusable:** no
- **Procedural:** no
