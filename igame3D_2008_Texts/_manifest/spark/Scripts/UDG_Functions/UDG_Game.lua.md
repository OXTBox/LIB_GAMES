<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Game.lua (model spark-x2.6-4b, 2026-11-12 17:19). DRAFT for Claude to review. -->

## UDG_Game.lua
- **Kind:** level-script
- **Purpose:** This file contains the core logic for the UDG game, including the main game loop, target click selection handling, and a helper that finds the highest-ranked zombie. It also sets a global flag controlling velocity clamping behavior.
- **Depends on:** `Data/` folder paths, `gObjects` global object table, `gDoVelocityClamp` global flag, and functions from other Scripts libraries such as `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `handle_UDGAI`, `udg_zombies_follow`, `udg_handle_zombie_idle_sounds`, `udg_update_object_sounds`, `udg_display_FPS`, `udg_display_levelText`, and `loadLevel`.
- **Provides:** `pick_highest_ranked_zombie`, `udg_handle_target_click_selection`, `deDollObjects`, `handle_udg`, and the global `gDoVelocityClamp`.
- **Assets it needs:** none named in this file.
- **Procedural:** none
- **Glossary:**
  - `IG3D_POSITION -` the property name used to read or set an object's position.
  - `IG3D_MOUSE_LINE -` the property name used for mouse line collision checks.
  - `IG3D_ROTATION -` the property name used to read or set object rotation.
  - `IG3D_VELOCITY -` the property name used to read or set object velocity.
  - `IG3D_FORCE -` the property name used to read or set object force.
  - `IG3D_MOUSE_VIEW -` the property name used to read or set mouse view state.
  - `IG3D_CONSTANT_ATTENUATION -` the property name used for constant attenuation settings.
  - `IG3D_LINEAR_ATTENUATION -` the property name used for linear attenuation settings.
  - `IG3D_QUADRATIC_ATTENUATION -` the property name used for quadratic attenuation settings.
- **Keep / port / drop:** keep - core game logic and helper functions that other UDG files depend on.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** No top-level code outside the `pick_highest_ranked_zombie` function.
- **Uses:** nothing
- **Reusable:** no

### pick_highest_ranked_zombie
- **Does:** Finds the nearest zombie to the given coordinates, first preferring zombies with no `order` value, then falling back to all alive zombies, and returns the matching zombie object.
- **Uses:** `gObjects` (global object table), `getObjectInfo(obj, IG3D_POSITION)`, `vecLength`
- **Reusable:** no
- **Procedural:** no

## Part 2 of 3

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions; the only other code is a single global assignment `gDoVelocityClamp=true`.
- **Uses:** `gDoVelocityClamp` (global)
- **Reusable:** no

### udg_handle_target_click_selection
- **Does:** Handles target click selection by checking the mouse line collision, then either triggers zombie combat or zombie path generation based on the collision result and object team.
- **Uses:** `click`, `getSceneInfo`, `IG3D_MOUSE_LINE`, `lineCollision`, `pick_highest_ranked_zombie`, `getObjectInfo`, `IG3D_POSITION`, `normalized`, `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `sceneryTeam`, `doorTeam`, `windowTeam`, `IG3D_MOUSE_LINE`
- **Reusable:** no

### deDollObjects
- **Does:** Is an empty function with no implementation.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 3

### Top level
- **Does:** Contains no top-level code outside the `handle_udg` function; the entire file content is the function definition.
- **Uses:** nothing
- **Reusable:** no

### handle_udg
- **Does:** Handles the main UDG game loop logic, including mouse delta camera rotation, doll activation, camera and object info updates, movement input handling, lighting and camera adjustments, and calls to other UDG subsystems.
- **Uses:** `getSceneInfo`, `setCameraInfo`, `setObjectInfo`, `getObjectInfo`, `setSceneInfo`, `key`, `loadLevel`, `dark`, `lit`, `getCameraInfo`, `normalized`, `vecLength`, `time`, `first`, `xa`, `ya`, `za`, `x`, `y`, `z`, `forw`, `a11` through `a44`, `playerBox`, `gDoVelocityClamp`, `gCameraSpeed`, `levelislit`, `currentText`, `gObjects`, `setLightInfo`, `handle_UDGAI`, `udg_zombies_follow`, `gActivateStartSounds`, `udg_handle_zombie_idle_sounds`, `udg_update_object_sounds`, `udg_display_FPS`, `udg_display_levelText`, `default_escapekey`, `IG3D_MOUSE_DELTA`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`, `IG3D_RAGDOLL`, `IG3D_VELOCITY`, `IG3D_FORCE`, `IG3D_POSITION`, `IG3D_MOUSE_VIEW`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`
- **Reusable:** no
- **Procedural:** no
