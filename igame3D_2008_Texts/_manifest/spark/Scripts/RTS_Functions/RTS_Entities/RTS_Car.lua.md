<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Car.lua (model spark-x2.6-4b, 2026-11-12 14:33). DRAFT for Claude to review. -->

## RTS_Car.lua
- **Kind:** library
- **Purpose:** This file loads the RTS_Vehicles library and builds a `cars` table by scanning `gObjects` for car-like objects, enabling reuse of car definitions and behavior across the RTS game scripts.
- **Depends on:** `Data/Scripts/RTS_Functions/RTS_Vehicles.lua` (loaded via `dofile`), `Data/` folder path structure, globals `gObjects`, `gDoShadows`, and engine functions/constants such as `getObjectInfo`, `setObjectInfo`, `computeLODModelName`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `init_car`, plus `IG3D_NAME`, `IG3D_CAST_SHADOW`, `IG3D_LOD_MODEL`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_MASS`, `IG3D_SAMPLE`, `IG3D_LOOP`.
- **Provides:** The `cars` table (built by scanning `gObjects` for car-like objects), along with the supporting functions and constants used to initialize and configure car objects.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (the file builds a table by scanning existing objects; no assets are generated from numbers or rules).
- **Glossary:**
  - `gObjects` - Global table of game objects shared across scripts, used to scan for car-like objects.
  - `getObjectInfo` / `setObjectInfo` - Engine calls that read or set properties (e.g., position, rotation) of a named object.
  - `IG3D_...` - Constants naming the property being read or set on an object (e.g., `IG3D_NAME`, `IG3D_CAST_SHADOW`).
  - `dofile` - Engine call that loads a Lua file from a path.
  - `loadLevel` - Engine call that switches the active game or demo level (referenced in background context for level loading).
  - `init_car` - Function used to initialize a car object (referenced in the file's dependency list).
- **Keep / port / drop:** keep - serves as a reusable reference for building car object tables and scanning `gObjects` for car-like entities.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads the RTS_Vehicles library and builds the cars table by scanning gObjects for car-like objects.
- **Uses:** `dofile(gameroot.."Data/Scripts/RTS_Functions/RTS_Vehicles.lua")`, globals `gObjects`, `cars`, `gDoShadows`, `getObjectInfo`, `setObjectInfo`, `computeLODModelName`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `init_car`, `IG3D_NAME`, `IG3D_CAST_SHADOW`, `IG3D_LOD_MODEL`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_MASS`, `IG3D_SAMPLE`, `IG3D_LOOP`.
- **Reusable:** no
- **Procedural:** no
