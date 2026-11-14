<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Keyboard.lua (model spark-x2.6-4b, 2026-11-12 16:34). DRAFT for Claude to review. -->

## RTS_Keyboard.lua
- **Kind:** library
- **Purpose:** This file provides keyboard-driven controls for the iGame3D engine, including time and light manipulation functions and a helper that selects tracked objects for the team-select screen. It defines a shared global flag and several key-handling routines that adjust game speed, scene speed, and tracked light properties in response to user input.
- **Depends on:** `Data/` folder paths for Scripts and Levels folders; globals `gOldGameSpeed`, `gSpeedResetTime`, `gTrackedObject`, `gObjects`, `gTeamSelect`, `gTrackingLights`, `gTrackLightEnabled`, and functions `unselectAllObjects()`; engine calls for scene info, object info, and light info.
- **Provides:** Globals `gTrackLightEnabled`; functions `bulletTimeKey`, `stopTimeKey`, `tabThroughObjects`, `trackLightsKey`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none
- **Glossary:**
  - `bulletTimeKey` - A function that toggles freeze-time slow mode and resets game speed when a specified key is pressed.
  - `trackLightsKey` - A function that adjusts ambient light values and updates tracked light properties based on a numeric key.
  - `gTrackLightEnabled` - A shared global flag set to `false` at file level, controlling tracked light behavior.
  - `IG3D_SPEED` - An engine constant naming the scene speed property being read or set.
  - `IG3D_POSITION` - An engine constant naming the object position property being read or set.
  - `IG3D_AMBIENT` - An engine constant naming the light ambient property being read or set.
  - `IG3D_ENABLED` - An engine constant naming the light enabled property being read or set.
- **Keep / port / drop:** keep - It provides reusable keyboard control logic for game speed and tracked lights that other scripts likely depend on.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the shared global `gTrackLightEnabled` as `false--true` at file level.
- **Uses:** nothing
- **Reusable:** no

### bulletTimeKey
- **Does:** Toggles freeze time slow mode when the specified key is pressed, resetting game speed to `gOldGameSpeed` if the time threshold has been reached.
- **Uses:** `time()`, `key(tkey,"n")`, `getSceneInfo`, `setSceneInfo`, `IG3D_SPEED`, `gSpeedResetTime`, `gOldGameSpeed`
- **Reusable:** no

### stopTimeKey
- **Does:** Sets the scene speed to `0.0001` when the specified key is pressed.
- **Uses:** `key(tkey,"-")`, `setSceneInfo`, `IG3D_SPEED`
- **Reusable:** no

### tabThroughObjects
- **Does:** Iterates through tracked objects to find the next alive object belonging to the team selected for the team-select screen, unselects all objects, and selects the found object with its position copied to the tracking position.
- **Uses:** `gTrackedObject`, `gObjects`, `alive`, `team`, `gTeamSelect`, `#gObjects`, `unselectAllObjects()`, `getObjectInfo`, `IG3D_POSITION`, `gTrackedPosition`, `gTrackingLights`, `gTrackedObject`
- **Reusable:** no

### Top level
- **Does:** Nothing beyond the file-level global assignment shown above.
- **Uses:** nothing
- **Reusable:** no

## Part 2 of 2

### trackLightsKey
- **Does:** Adjusts ambient light values when a numeric key is supplied, then updates every tracked light's position, ambient, diffuse, specular, enabled and attenuation settings.
- **Uses:** `getLightInfo`, `getObjectInfo`, `setLightInfo`, `passed`, globals `gAr,gAg,gAb,gAa,gDr,gDg,gDb,gDa,gTrackingLights,gTrackLightEnabled`, constants `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_POSITION`, `IG3D_ENABLED`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`
- **Reusable:** no
- **Procedural:** no
