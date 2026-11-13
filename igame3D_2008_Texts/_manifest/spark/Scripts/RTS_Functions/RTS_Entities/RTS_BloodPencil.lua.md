<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_BloodPencil.lua (model spark-x2.6-4b, 2026-11-12 14:32). DRAFT for Claude to review. -->

## RTS_BloodPencil.lua
- **Kind:** library
- **Purpose:** This file loads blood pencil textures and applies a temporary texture to every material of every object in the scene, preparing the scene for blood decal rendering. It is a helper library for adding blood pencil effects to game objects.
- **Depends on:** `Data/` folder paths for texture files, `loadTexture`, `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo`, `gObjects`, `os.time()`, and engine constants `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`; other Scripts libraries loaded via `dofile` as needed.
- **Provides:** No standalone named functions are described in the provided code; it performs scene-wide texture assignment directly at the top level.
- **Assets it needs:** Images (specific `Data/Images/Decals/...` texture paths are referenced, exact filenames not fully specified in the provided code).
- **Procedural:** none
- **Glossary:**
  - `setMaterialInfo - Sets the properties of a material object to a specified value.`
  - `getObjectInfo - Reads the current property value of an object using an IG3D property constant.`
  - `IG3D_TEXTURE - Engine constant naming the texture property being read or set.`
  - `IG3D_FRAGMENT_SHADER_SUPPORTED - Engine constant indicating whether fragment shader support is available.`
  - `loadTexture - Loads a texture file into the engine for use in materials.`
  - `gObjects - Global table holding all objects in the current scene.`
- **Keep / port / drop:** keep - It is a reusable scene setup helper for adding blood pencil textures to objects.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads blood pencil textures and assigns a temporary texture to every material of every object in the scene.
- **Uses:** `loadTexture` with `Data/Images/Decals/...` paths, `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo`, `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`, `gObjects`, `os.time()`.
- **Reusable:** no
- **Procedural:** no
