<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Camera.lua (model spark-x2.6-4b, 2026-11-12 16:26). DRAFT for Claude to review. -->

## RTS_Camera.lua
- **Kind:** library
- **Purpose:** This file implements the RTS camera update logic for iGame3D, handling zoom, look-around, rotation, and camera/light position updates driven by input keys and game state. It contains only the `RTSCamera` function with no additional top-level setup, global definitions, or widget code.
- **Depends on:** Engine calls `getSceneInfo`, `getCameraInfo`, `setCameraInfo`, `setLightInfo`, `getObjectInfo`; globals `gZoomDistance`, `gLookAround`, `gTrackedPosition`, `gTrackedObject`, `gInverseGameSpeed`, `gObjects`, and input/vector variables such as `tx`, `ty`, `tz`, `x2`, `y2`, `z2`, `x`, `y`, `z`, `dx`, `dy`, `dz`, `ds`, `a11`–`a44`, `a31`, `a32`, `a33`, `rtd`, `mx`, `my`, `mz`, `x3`, `y3`, `z3`, `t`; functions `key`, `passed`, `normalized`, `vecLength`, `dirToAngles`; math functions `math.max`, `math.min`, `math.cos`, `math.sin`; constants `IG3D_WHEEL_DELTA`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`.
- **Provides:** the `RTSCamera` function, which performs the RTS camera update logic.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` paths are named).
- **Procedural:** none
- **Glossary:**
  - `IG3D_WHEEL_DELTA - iGame3D constant used for wheel-based zoom input handling`
  - `IG3D_ROTATION_MATRIX - iGame3D constant used for rotation matrix calculations`
  - `IG3D_POSITION - iGame3D property constant naming the position property of an object`
  - `IG3D_ROTATION - iGame3D property constant naming the rotation property of an object`
  - `getSceneInfo - engine call that retrieves scene information for camera/light updates`
  - `getCameraInfo - engine call that retrieves camera information for camera updates`
  - `setCameraInfo - engine call that sets camera information for camera updates`
  - `setLightInfo - engine call that sets light information for light position updates`
- **Keep / port / drop:** keep - it is a reusable camera update logic implementation that ties camera, tracking, and light updates together.

---

# Part notes

## Part 1 of 1

### RTSCamera
- **Does:** Implements the RTS camera update logic, handling zoom, look-around, rotation, and camera/light position updates based on input keys and game state.
- **Uses:** Engine calls `getSceneInfo`, `getCameraInfo`, `setCameraInfo`, `setLightInfo`, `getObjectInfo`; globals `gZoomDistance`, `gLookAround`, `gTrackedPosition`, `gTrackedObject`, `gInverseGameSpeed`, `gObjects`, `tx`, `ty`, `tz`, `x2`, `y2`, `z2`, `x`, `y`, `z`, `dx`, `dy`, `dz`, `ds`, `a11`–`a44`, `a31`, `a32`, `a33`, `rtd`, `mx`, `my`, `mz`, `x3`, `y3`, `z3`, `t`; functions `key`, `passed`, `normalized`, `vecLength`, `dirToAngles`, `math.max`, `math.min`, `math.cos`, `math.sin`; constants `IG3D_WHEEL_DELTA`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`; no `Data/` paths.
- **Reusable:** no - it ties camera, tracking, and light updates together with specific game-specific input handling.
- **Procedural:** no

### Top level
- **Does:** none - the file contains only the `RTSCamera` function with no additional top-level setup, global definitions, or widget code.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no
