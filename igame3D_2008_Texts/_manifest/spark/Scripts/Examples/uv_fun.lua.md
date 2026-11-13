<!-- Spark first-look of Data/Scripts/Examples/uv_fun.lua (model spark-x2.6-4b, 2026-11-12 15:08). DRAFT for Claude to review. -->

## uv_fun.lua
- **Kind:** test/example
- **Purpose:** This file is a small example script that configures a square scene object with position, rotation, and texture, then defines an ocean animation function and a wrapper function that invokes the ocean animation before running the previously stored game function. It demonstrates how scene objects, materials, and animation state are set and used in the iGame3D engine.
- **Depends on:** `Data/` folder paths for scene info and materials, globals `gTime`, `game_func`, `oldGameFunc`, and engine functions `setSceneInfo`, `make`, `setObjectInfo`, `get`, `setMaterialInfo`; the `oceaneffect` function defined in the same file.
- **Provides:** `oceaneffect` (updates ocean animation state and applies UV transformation to a material), `myFunction` (calls `oceaneffect` then runs `oldGameFunc` if present), and `game_func` (assigned at top level).
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in the code).
- **Procedural:** none (the file only configures existing objects and defines functions; no assets are generated from numbers or rules).
- **Glossary:**
  - `setSceneInfo - Engine call to set the scene information path for the current game.`
  - `setObjectInfo - Engine call to set a property (e.g., position or rotation) of an object.`
  - `setMaterialInfo - Engine call to set a property (e.g., texture) of a material.`
  - `IG3D_ROOT - Engine constant naming the root property being read or set on an object.`
  - `IG3D_TEXTURE - Engine constant naming the texture property being read or set on a material.`
  - `IG3D_UV_TRANSFORMATION - Engine constant naming the UV transformation property being read or set on a material.`
  - `game_func - Global variable holding the previously stored game function to be invoked after ocean animation.`
  - `oldGameFunc - Global variable holding the previous game function to run after ocean animation.`
- **Keep / port / drop:** keep - it is a small, self-contained example of scene object and material configuration with animation logic, useful as a reference for new engine scripts.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the scene info path, creates a square object, configures its position and rotation, retrieves a material and sets its texture, then defines the `oceaneffect` and `myFunction` functions and assigns `game_func`.
- **Uses:** `setSceneInfo`, `make`, `setObjectInfo`, `get`, `setMaterialInfo`, `IG3D_ROOT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXTURE`, `IG3D_UV_TRANSFORMATION`, `time`, `math.random`, `passed`, `click`, `gTime`, `oldGameFunc`, `game_func`

### oceaneffect
- **Does:** Updates ocean animation state based on elapsed time and user input, then applies the updated UV transformation to the retrieved material.
- **Uses:** `time`, `math.random`, `passed`, `click`, `setMaterialInfo`, `IG3D_UV_TRANSFORMATION`, `m`, `gTime`, `ox`, `oy`, `rot`, `omega`

### myFunction
- **Does:** Calls `oceaneffect`, then invokes the previously stored `oldGameFunc` if it exists.
- **Uses:** `oceaneffect`, `oldGameFunc`
- **Reusable:** no
- **Procedural:** no
