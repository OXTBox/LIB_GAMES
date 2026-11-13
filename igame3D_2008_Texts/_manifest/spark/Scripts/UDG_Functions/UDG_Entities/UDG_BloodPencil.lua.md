<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_BloodPencil.lua (model spark-x2.6-4b, 2026-11-12 14:36). DRAFT for Claude to review. -->

## UDG_BloodPencil.lua
- **Kind:** library
- **Purpose:** This file loads blood decal textures and assigns a unique temporary texture to every material of every object in the scene, preparing the scene for blood decal rendering. It is a procedural setup script for adding blood decals to game objects.
- **Depends on:** `Data/` folder paths for decal textures, `loadTexture` calls, `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo`, `gObjects`, `os.time()`, and engine constants `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`; other Scripts libraries loaded via `dofile`.
- **Provides:** No standalone functions or globals are described for this file; it performs scene-level material texture assignment directly at the top level.
- **Assets it needs:** Images (specifically `Data/Images/Decals/` decal texture files); no models, sounds, emitters, or fonts are named.
- **Procedural:** yes; it generates temporary texture assignments for materials of scene objects using texture loading and procedural assignment rules rather than loading pre-existing asset files.
- **Glossary:**
  - `setMaterialInfo - Assigns properties to an object's material, such as texture or shader settings.`
  - `getObjectInfo - Retrieves information about an object, including its current properties.`
  - `getSceneInfo - Retrieves information about the current scene, such as its objects and settings.`
  - `IG3D_TEXTURE - Engine constant naming the texture property being read or set.`
  - `loadTexture - Engine call to load a texture asset into the engine.`
  - `gObjects - Global shared between files holding references to scene objects.`
- **Keep / port / drop:** keep - it is a reusable procedural setup script for adding blood decals to objects in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads blood decal textures and assigns a unique temporary texture to every material of every object in the scene.
- **Uses:** `loadTexture` with `Data/Images/Decals/` paths, `get`, `setMaterialInfo`, `make`, `getObjectInfo`, `getSceneInfo`, `IG3D_TEXTURE`, `IG3D_FRAGMENT_SHADER_SUPPORTED`, `gObjects`, `os.time()`.
- **Reusable:** no
- **Procedural:** yes
