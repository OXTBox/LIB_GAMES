<!-- Spark first-look of Data/Scripts/FPS_Functions/FPS_Game.lua (model spark-x2.6-4b, 2026-11-12 15:10). DRAFT for Claude to review. -->

## FPS_Game.lua
- **Kind:** level-script
- **Purpose:** This file defines the global state and per-frame logic for the FPS game, including input handling, camera and object updates, level loading, and blood particle effects applied to objects. It contains only the `handle_FPS` and `objpart` functions along with top-level global variable definitions for the game.
- **Depends on:** `Data/Levels/FPS` (loaded via `loadLevel`), `Data/Images/Decals/bloodpencil` (blood decal texture), `Data/` folder paths used for code loading, globals set elsewhere such as `gObjects`, `gVelocityClamp`, `gCameraSpeed`, `gSoundEmitters`, `playerBox`, `FPSgun`, `playerGunSound`, and functions like `getSceneInfo`, `setCameraInfo`, `setObjectInfo`, `getObjectInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `getParticle_emitterInfo`, `getMaterialInfo`, `drawToTexture`, `handle_FPSAI`, and `default_escapekey`.
- **Provides:** `handle_FPS` (FPS game input, camera/object updates, level loading, per-frame game logic), `objpart` (blood particle effects on objects), and the global variables `gLastClick`, `gDoubleClickInterval`, `gStatusString`, `gCameraSpeed`, `gVelocityClamp`.
- **Assets it needs:** `Data/Images/Decals/bloodpencil` (blood decal texture).
- **Procedural:** none
- **Glossary:**
  - `IG3D_POSITION` - the property constant naming the object's position being read or set.
  - `IG3D_EXACT_COLLISION_DATA` - the property constant naming the exact collision data queried for an object.
  - `IG3D_TEXTURE` - the property constant naming the texture being drawn to an object's material.
  - `IG3D_ADD` - the property constant naming the operation applied to a texture.
  - `IG3D_CLAMP` - the property constant naming the operation applied to a texture.
  - `normalized` - a function used to compute normalized offset coordinates for blood particle effects.
  - `vecLength` - a function used to compute the length of a vector for camera/object updates.
- **Keep / port / drop:** keep - it is the core game logic and state setup for the FPS level, useful as a reference for building a new engine.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines global variables for the FPS game, including last click time, double-click interval, status string, camera speed, and velocity clamp.
- **Uses:** Globals `gLastClick`, `gDoubleClickInterval`, `gStatusString`, `gCameraSpeed`, `gVelocityClamp`.
- **Reusable:** no

## Part 2 of 3

### Top level
- **Does:** The file contains only the `handle_FPS` function; there is no setup, global definitions, or widget code outside the function.
- **Uses:** nothing
- **Reusable:** no

### handle_FPS
- **Does:** Handles FPS game input, camera and object updates, level loading, and per-frame game logic for the FPS level.
- **Uses:** `getSceneInfo`, `setCameraInfo`, `setObjectInfo`, `getObjectInfo`, `loadLevel`, `key`, `click`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `setSceneInfo`, `default_escapekey`, `getCameraInfo`, `normalized`, `vecLength`, `gObjects`, `gVelocityClamp`, `gCameraSpeed`, `playerBox`, `FPSgun`, `playerGunSound`, `first`, `xa`, `ya`, `za`, `x`, `y`, `z`, `forw`, `handle_FPSAI`, `Data/Levels/FPS`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** No top-level code outside the `objpart` function; the file contains only the function definition.
- **Uses:** nothing
- **Reusable:** no

### objpart
- **Does:** Applies blood particle effects to an object when it is not already marked as having blood, by computing normalized offset coordinates, querying exact collision data for the object, and drawing a blood decal texture to the object's material.
- **Uses:** `getParticle_emitterInfo`, `get`, `getObjectInfo`, `setSound_emitterInfo`, `drawToTexture`, `getMaterialInfo`, `math.random`, `normalized`, `gSoundEmitters`, `IG3D_POSITION`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_TEXTURE`, `IG3D_ADD`, `IG3D_CLAMP`, `Data/Images/Decals/bloodpencil`
- **Reusable:** no
- **Procedural:** no
