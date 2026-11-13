<!-- Spark first-look of Data/Scripts/Functions/scene_functions.lua (model spark-x2.6-4b, 2026-11-12 15:30). DRAFT for Claude to review. -->

## scene_functions.lua
- **Kind:** engine-core
- **Purpose:** This file contains core scene and background management functions for the iGame3D engine. It provides helpers to set and fade the scene background color, create title objects, and cycle the background color components. It has no setup, global definitions, or widget code outside these functions.
- **Depends on:** `Data/` folder paths for scene and object files, `setSceneInfo`, `getSceneInfo`, `make`, `setObjectInfo`, and the `IG3D_...` constants used by the scene functions; `math.abs` for color interpolation.
- **Provides:** `sky`, `fadeto`, `create_titles`, `colorcyclebackground` functions for controlling scene background color, title object creation, and background color cycling.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (no assets are generated from numbers or rules; object placement and configuration are performed directly in code).
- **Glossary:**
  - `setSceneInfo` - Engine call used to set scene-level properties such as background color.
  - `getSceneInfo` - Engine call used to read scene-level properties such as background color.
  - `IG3D_BACKGROUND_COLOR` - Constant naming the scene property for background color.
  - `IG3D_ROTATION` - Constant naming the object property for rotation.
  - `IG3D_POSITION` - Constant naming the object property for position.
  - `IG3D_SIZE` - Constant naming the object property for size.
  - `make` - Engine call used to create an iGame3D object.
  - `setObjectInfo` - Engine call used to set properties on an existing iGame3D object.
- **Keep / port / drop:** keep - core scene and background management functions that other engine files likely rely on for scene configuration and color handling.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### sky
- **Does:** Sets the iGame3D scene background color to the given red, green, and blue values, then returns the resulting background color info.
- **Uses:** `setSceneInfo`, `getSceneInfo`, `IG3D_BACKGROUND_COLOR`, `math.abs`
- **Reusable:** yes

### fadeto
- **Does:** Fades the iGame3D scene background color toward the given red, green, and blue values by interpolating each channel and rendering after each update.
- **Uses:** `getSceneInfo`, `setSceneInfo`, `IG3D_BACKGROUND_COLOR`, `math.abs`, `passed`, `render`
- **Reusable:** yes

### create_titles
- **Does:** Creates a square iGame3D object for the title, sets its rotation and position, and sets its size.
- **Uses:** `make`, `setObjectInfo`, `IG3D_ROTATION`, `IG3D_POSITION`, `IG3D_SIZE`, `a`
- **Reusable:** no

### colorcyclebackground
- **Does:** Increments the background color components by small fixed amounts, reverses the increment direction when a component reaches 1, and updates the scene background color with the new values.
- **Uses:** `setSceneInfo`, `IG3D_BACKGROUND_COLOR`, `rb`, `gb`, `bb`, `RedBack`, `GreenBack`, `BlueBack`
- **Reusable:** yes
