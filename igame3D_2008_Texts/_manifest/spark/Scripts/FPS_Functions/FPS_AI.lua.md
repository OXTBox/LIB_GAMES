<!-- Spark first-look of Data/Scripts/FPS_Functions/FPS_AI.lua (model spark-x2.6-4b, 2026-11-12 15:09). DRAFT for Claude to review. -->

## FPS_AI.lua
- **Kind:** engine-core
- **Purpose:** This file contains the FPS AI update cycle for the iGame3D engine, handling scene LOD configuration, timed sense management, object distance updates, AI behavior for zombies, and keyboard time controls before refreshing the FLTK UI. It also sets the `gDangerFlag` global to `false` at the top level.
- **Depends on:** `Data/` folder paths and code loaded via `dofile(...)`; globals set elsewhere such as `gSensesTime`, `gSensesInterval`, `gObjects`, `gObjectNames`, `RTS_console`, `bloodonfloor`; engine functions including `setText_boxInfo`, `getSceneInfo`, `setSceneInfo`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `play_car_sounds`, `handle_health`, `handle_ai`, `setObjectInfo`, `getObjectInfo`, `setParticle_emitterInfo`, `fltk_update`; constants including `IG3D_TEXT`, `IG3D_LOD_DISTANCE`, `IG3D_FPS`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_START`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`; and host functions `time`, `string.find`, `math.random`.
- **Provides:** The `handle_FPSAI` function, which runs the FPS AI update cycle; the global `gDangerFlag` set to `false` at the top level.
- **Assets it needs:** none named in this file (no models, images, sounds, emitters, or fonts are referenced).
- **Procedural:** none
- **Glossary:**
  - `gDangerFlag` - a global flag set to `false` at the top of the file to control danger state.
  - `handle_FPSAI` - the function that runs the FPS AI update cycle for the game.
  - `gSensesTime` / `gSensesInterval` - globals used to manage timed sense handling in the AI cycle.
  - `setObjectInfo` / `getObjectInfo` - engine calls used to read or set object properties such as position, rotation, and other attributes.
  - `setParticle_emitterInfo` - engine call used to configure particle emitter settings.
  - `fltk_update` - engine call used to refresh the FLTK user interface after AI updates.
- **Keep / port / drop:** keep - it is a core AI update routine that other game files likely depend on for FPS AI behavior.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets the `gDangerFlag` global to `false`.
- **Uses:** `gDangerFlag` (global starting with `g`)
- **Reusable:** no

## Part 2 of 2

### Top level
- **Does:** The file contains only the function `handle_FPSAI`; there is no setup, global definitions, or widget code outside the function.
- **Uses:** `setText_boxInfo`, `getSceneInfo`, `setSceneInfo`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `play_car_sounds`, `handle_health`, `handle_ai`, `setObjectInfo`, `getObjectInfo`, `setParticle_emitterInfo`, `bulletTimeKey`, `stopTimeKey`, `fltk_update`, and globals `gSensesTime`, `gSensesInterval`, `gObjects`, `gObjectNames`, `RTS_console`, `bloodonfloor`, `RTS_console`, plus constants `IG3D_TEXT`, `IG3D_LOD_DISTANCE`, `IG3D_FPS`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_START`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, and constants `time`, `string.find`, `math.random`.
- **Reusable:** no

### handle_FPSAI
- **Does:** Runs the FPS AI update cycle, resetting the console text box, configuring scene LOD settings, managing timed sense handling, updating object distances, highlighting marked objects, handling held guns, playing car sounds, checking health for non-player objects, running object AI and freeze/unfreeze logic for zombies, and applying keyboard time controls before refreshing the FLTK UI.
- **Uses:** `setText_boxInfo`, `getSceneInfo`, `setSceneInfo`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `play_car_sounds`, `handle_health`, `handle_ai`, `setObjectInfo`, `getObjectInfo`, `setParticle_emitterInfo`, `bulletTimeKey`, `stopTimeKey`, `fltk_update`, and globals `gSensesTime`, `gSensesInterval`, `gObjects`, `gObjectNames`, `RTS_console`, `bloodonfloor`, plus constants `IG3D_TEXT`, `IG3D_LOD_DISTANCE`, `IG3D_FPS`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_START`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, and functions `time`, `string.find`, `math.random`.
- **Reusable:** no
- **Procedural:** no
