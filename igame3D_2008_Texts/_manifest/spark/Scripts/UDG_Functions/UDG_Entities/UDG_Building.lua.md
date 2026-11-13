<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Building.lua (model spark-x2.6-4b, 2026-11-12 14:36). DRAFT for Claude to review. -->

## UDG_Building.lua
- **Kind:** library
- **Purpose:** This file builds building and wall object tables by scanning the shared `gObjects` list, then applies default physics and visual settings to each building and wall object. It is a reusable helper for constructing UDG building and wall entities with standard engine defaults.
- **Depends on:** `gObjects` (shared global), `getObjectInfo`, `setObjectInfo`, `computeShadowModelName` (engine calls), globals `gDoShadows` and `buildingTeam` (set elsewhere), no `Data/` file paths.
- **Provides:** No named functions or globals are listed as provided by this file; it operates directly on the shared `gObjects` table to configure building and wall objects.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** none (the file scans existing objects and applies configuration settings rather than generating assets from numbers or rules).
- **Glossary:**
  - `gObjects` - shared global table holding all game objects, scanned by this file to build building and wall tables.
  - `getObjectInfo` - engine call that reads property values from an object.
  - `setObjectInfo` - engine call that sets property values on an object.
  - `computeShadowModelName` - engine helper that derives a shadow model name for an object.
  - `gDoShadows` - global flag controlling whether shadow rendering is enabled.
  - `buildingTeam` - global value identifying the building team for the objects being configured.
- **Keep / port / drop:** keep - reusable reference for applying default physics and visual settings to building and wall objects in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds building and wall object tables by scanning the shared `gObjects` list, then applies default physics and visual settings to each building and wall object.
- **Uses:** `gObjects`, `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, globals `gDoShadows`, `buildingTeam`; no `Data/` file paths.
- **Reusable:** no
- **Procedural:** no
