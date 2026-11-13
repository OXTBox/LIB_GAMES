<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Scenery.lua (model spark-x2.6-4b, 2026-11-12 14:41). DRAFT for Claude to review. -->

## UDG_Scenery.lua
- **Kind:** library
- **Purpose:** This file sets up the scenery objects in the game by scanning the full inventory of game objects, keeping only those whose names contain "scenery", and applying default physics and visual settings to each match. It is a one-time setup pass that prepares the scenery layer for the rest of the game to use.
- **Depends on:** `gObjects`, `gObjectPositions`, `gObjectRotations` (shared globals set elsewhere), `getObjectInfo`, `setObjectInfo`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_SHAPE`, `ig3d_box`, `sceneryTeam`, `computeShadowModelName` (functions/globals defined in other files), and the `Data/` folder structure for game assets.
- **Provides:** No standalone functions or globals are defined here; the file performs the scenery setup pass directly using the shared engine calls and globals listed above.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this file).
- **Procedural:** none (the file scans existing game objects and configures them; it does not generate or place assets from numbers or rules).
- **Glossary:**
  - `gObjects` - shared global table holding all game objects in the current level.
  - `getObjectInfo` / `setObjectInfo` - engine calls used to read and modify properties of a single game object.
  - `IG3D_*` constants - engine constants that name the property being read or set on an object (e.g. position, gravity multiplier, mass, shape).
  - `ig3d_box` - engine call used to create or configure a box-shaped object.
  - `sceneryTeam` - shared global used to group or reference the scenery objects being configured.
  - `computeShadowModelName` - function that computes the shadow model name for an object.
- **Keep / port / drop:** keep - it is a reusable setup pass that defines how scenery objects are configured in the game.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds the scenery table by scanning all game objects, filtering those whose names contain "scenery", and applies default physics and visual settings to each matched object.
- **Uses:** `gObjects`, `gObjectPositions`, `gObjectRotations`, `getObjectInfo`, `setObjectInfo`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_SHAPE`, `ig3d_box`, `sceneryTeam`, `computeShadowModelName`; file `UDG_Scenery.lua` under `Scripts/UDG_Functions/UDG_Entities`.
- **Reusable:** no - it is a one-time setup pass that depends on the full game object inventory and shared global state.
- **Procedural:** no
