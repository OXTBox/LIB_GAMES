<!-- Spark first-look of Data/Scripts/Functions/decal_functions.lua (model spark-x2.6-4b, 2026-11-12 06:39). DRAFT for Claude to review. -->

## decal_functions.lua
- **Kind:** library
- **Purpose:** This file provides a Lua function that applies bloodpencil decals to game objects by loading dedicated decal textures and assigning each object's materials a unique temporary texture. It is part of the iGame3D scripting library for adding blood decal effects to levels.
- **Depends on:** `Data/Images/Decals/` folder for bloodpencil textures, engine calls for texture and material management, global `gObjects` shared across files, and `os.time()` for assigning unique texture identifiers.
- **Provides:** `decal_BloodPencil` function, which loads the three bloodpencil textures and configures material textures for all alive objects in `gObjects`.
- **Assets it needs:** `Data/Images/Decals/bloodpencil1.png`, `Data/Images/Decals/bloodpencil2.png`, `Data/Images/Decals/bloodpencil3.png`
- **Procedural:** none
- **Glossary:**
  - `ig3d_material` - iGame3D engine call naming the kind of object being manipulated, here a material.
  - `ig3d_texture` - iGame3D engine call naming the kind of object being manipulated, here a texture.
  - `IG3D_TEXTURE` - iGame3D constant naming the property being read or set, here texture-related configuration.
  - `IG3D_FRAGMENT_SHADER_SUPPORTED` - iGame3D constant indicating whether fragment shader support is enabled for the engine.
  - `gObjects` - global shared between files in iGame3D that holds references to all game objects.
  - `loadTexture` - engine call that loads a texture file into the engine for use in rendering.
  - `setMaterialInfo` - engine call that sets material properties such as textures for a material object.
  - `getObjectInfo` - engine call that retrieves object property values for a given object.
- **Keep / port / drop:** keep - it is a reusable library function for applying bloodpencil decals in iGame3D levels.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the function `decal_BloodPencil` with no setup, globals, or widget definitions outside the function.
- **Uses:** `loadTexture` with `Data/Images/Decals/bloodpencil1.png`, `Data/Images/Decals/bloodpencil2.png`, `Data/Images/Decals/bloodpencil3.png` paths; engine calls `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo` with `ig3d_material`, `ig3d_texture`, `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`; global `gObjects`; global `os.time()`.
- **Reusable:** no
- **Procedural:** no

### decal_BloodPencil
- **Does:** Loads three bloodpencil textures, then iterates over all alive objects in `gObjects`, assigns a unique temporary texture to each material of each object using a timestamp and material index, and skips texture unit 2 assignment when fragment shader support is disabled.
- **Uses:** `loadTexture` with `Data/Images/Decals/bloodpencil1.png`, `Data/Images/Decals/bloodpencil2.png`, `Data/Images/Decals/bloodpencil3.png` paths; engine calls `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo` with `ig3d_material`, `ig3d_texture`, `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`; globals `gObjects`, `os.time()`.
- **Reusable:** no
- **Procedural:** no
