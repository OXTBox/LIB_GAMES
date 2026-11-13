<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Lights.lua (model spark-x2.6-4b, 2026-11-12 17:40). DRAFT for Claude to review. -->

## UDG_Lights.lua
- **Kind:** library
- **Purpose:** This file provides reusable lighting configuration routines for the iGame3D credits and work scenes, plus a scene-level lighting setup for Level 1 and a dedicated lighting routine for the Snipersalle scene. It configures scene properties and light parameters using engine calls to set standard lighting settings.
- **Depends on:** Engine calls `setSceneInfo`, `setLightInfo`, and `getCameraInfo`; globals `levelislit` (set to `true` by UDGWorkLighting, used by UDGLevel1Lighting); `Data/` folder paths for level and scene scripts; `Scripts/` folder for Lua libraries.
- **Provides:** `UDGCreditsLighting`, `UDGWorkLighting`, `UDGLevel1Lighting`, `udg_snipersalleylights`
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named)
- **Procedural:** none
- **Glossary:**
  - `setSceneInfo` - engine call that sets scene-level properties such as tint, fog, background color, and field of view.
  - `setLightInfo` - engine call that sets light properties such as enabled state, position, ambient, diffuse, specular, and attenuation parameters.
  - `getCameraInfo` - engine call that retrieves camera information, used to set light position.
  - `IG3D_*` - engine constants naming the properties being read or set in calls like `setSceneInfo` and `setLightInfo`.
  - `levelislit` - global flag marking whether the current level is lit, set to `true` by `UDGWorkLighting` and `false` by `UDGLevel1Lighting`.
- **Keep / port / drop:** keep - reusable lighting configuration routines that set standard scene and light parameters for new scenes.

---

# Part notes

## Part 1 of 3

### UDGCreditsLighting
- **Does:** Configures scene and light settings for the credits lighting scene, setting scene properties, enabling lights, and assigning their positions, color, and attenuation parameters.
- **Uses:** Engine calls `setSceneInfo` and `setLightInfo` with constants `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`.
- **Reusable:** yes - it is a reusable lighting configuration routine that sets standard scene and light parameters.

### UDGWorkLighting
- **Does:** Configures scene and light settings for the work lighting scene, setting scene properties, enabling lights, assigning their parameters, and marking the scene as lit.
- **Uses:** Engine calls `setSceneInfo` and `setLightInfo` with constants `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`. Also sets global `levelislit = true`.
- **Reusable:** yes - it is a reusable lighting configuration routine that sets standard scene and light parameters.

## Part 2 of 3

### Top level
- **Does:** Contains no code outside the `UDGLevel1Lighting` function; no setup, globals or widget definitions appear.
- **Uses:** nothing
- **Reusable:** no

### UDGLevel1Lighting
- **Does:** Configures scene-level lighting settings and the four light objects for Level 1, then sets the `levelislit` flag to `false`.
- **Uses:** `setSceneInfo`, `setLightInfo`, `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`, `levelislit`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** No functions or top-level code outside the listed function; the file contains only the function `udg_snipersalleylights`.
- **Uses:** Engine calls `setSceneInfo`, `setLightInfo`, `getCameraInfo`, and constants `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`.
- **Reusable:** no

### udg_snipersalleylights
- **Does:** Configures the scene tint, fog, background color, field of view, and the enabled state, position, and light properties for four lights, using the camera position for the third light.
- **Uses:** Engine calls `setSceneInfo`, `setLightInfo`, `getCameraInfo`; constants `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`.
- **Reusable:** no
- **Procedural:** no
