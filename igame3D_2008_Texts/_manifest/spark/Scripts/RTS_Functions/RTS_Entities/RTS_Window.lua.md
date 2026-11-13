<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Window.lua (model spark-x2.6-4b, 2026-11-12 14:35). DRAFT for Claude to review. -->

## RTS_Window.lua
- **Kind:** engine-core
- **Purpose:** Builds a `windows` table by scanning every object in `gObjects`, keeping only objects whose name contains `window`, applying default settings to each retained object and printing the final window count. The file configures window-related game objects according to engine constants and shadow settings.
- **Depends on:** `gObjects` (shared global), `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, `gDoShadows`, `windowsTeam`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_CAST_SHADOW`, and the `Data/` path convention for engine calls.
- **Provides:** the `windows` table (built by scanning and configuring objects) and the window-count print output.
- **Assets it needs:** none named (no models, images, sounds, emitters, or fonts are referenced).
- **Procedural:** none
- **Glossary:**
  - `gObjects` - shared global table of all game objects in the engine.
  - `getObjectInfo` - engine call that reads property values from an object.
  - `setObjectInfo` - engine call that sets property values on an object.
  - `computeShadowModelName` - engine helper that derives a shadow model name for an object.
  - `gDoShadows` - shared global controlling shadow rendering for game objects.
  - `IG3D_*` - engine constants naming object properties (e.g. position, mass, shadow casting).
- **Keep / port / drop:** keep - a reusable reference for configuring window objects in a new iGame3D-based engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds a `windows` table by scanning all objects in `gObjects`, keeping only objects whose name contains `window`, then applies default settings to each kept object and prints the final window count.
- **Uses:** `gObjects`, `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, `gDoShadows`, `windowsTeam`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_CAST_SHADOW`, plus the `Data/` path convention for engine calls.
- **Reusable:** no
- **Procedural:** no
