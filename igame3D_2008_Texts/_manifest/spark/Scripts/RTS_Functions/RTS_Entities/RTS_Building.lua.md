<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Building.lua (model spark-x2.6-4b, 2026-11-12 14:32). DRAFT for Claude to review. -->

## RTS_Building.lua
- **Kind:** library
- **Purpose:** Builds the buildings and walls tables by scanning all game objects, then applies default physics and visual settings to each entry in the tables. The file prepares these tables so other scripts can reference building and wall objects with consistent default properties.
- **Depends on:** `gObjects` (shared global), `getObjectInfo`, `setObjectInfo`, `computeShadowModelName` (engine calls), `Data/` folder paths, globals `gDoShadows` set elsewhere.
- **Provides:** The buildings and walls tables, populated by scanning game objects and applying default physics and visual settings to each entry.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** none
- **Glossary:**
  - `gObjects` - shared global table holding all game objects, used to scan for buildings and walls.
  - `getObjectInfo` - engine call that reads property values from a game object.
  - `setObjectInfo` - engine call that writes property values to a game object.
  - `computeShadowModelName` - engine helper that computes the shadow model name for an object.
  - `gDoShadows` - global flag controlling whether shadow generation is enabled for objects.
- **Keep / port / drop:** keep - serves as a reusable reference for building default object properties in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds the buildings and walls tables by scanning all game objects, then applies default physics and visual settings to each entry.
- **Uses:** `gObjects`, `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, globals `gDoShadows`; reads/writes object properties and table entries.
- **Reusable:** no
- **Procedural:** no
