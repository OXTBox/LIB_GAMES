<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Car.lua (model spark-x2.6-4b, 2026-11-12 14:37). DRAFT for Claude to review. -->

## UDG_Car.lua
- **Kind:** library
- **Purpose:** This file loads the RTS vehicle library, builds the `cars` table, and scans `gObjects` to register car objects for the game. It provides the shared vehicle definitions and registration logic used by other scripts working with RTS cars.
- **Depends on:** `Data/Scripts/RTS_Functions/RTS_Vehicles.lua` (loaded via `dofile`), `gObjects`, `gDoShadows`, `computeLODModelName`, `IG3D_*` constants, and the RTS vehicle functions `getObjectInfo`, `setObjectInfo`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `init_car`, plus the `Data/` folder path structure.
- **Provides:** the `cars` table, plus the car registration logic that scans `gObjects` and configures car objects using the engine call patterns and constants.
- **Assets it needs:** none named explicitly (vehicle models, sounds, and emitters are referenced through the loaded RTS vehicle library and engine calls rather than direct file names).
- **Procedural:** none
- **Glossary:**
  - `gObjects` - global table shared across Lua files holding registered game objects.
  - `getObjectInfo` / `setObjectInfo` - engine calls that read or set object properties such as position, rotation, and text.
  - `IG3D_*` - constants naming the properties being read or set by engine calls (e.g., position, text).
  - `assign_free_sound_emitter` / `setSound_emitterInfo` - engine calls used to attach and configure sound emitters for objects.
  - `init_car` - engine function used to initialize a car object.
  - `computeLODModelName` - engine function used to compute the model name for level of detail rendering.
- **Keep / port / drop:** keep - it is a reusable library file defining core vehicle registration logic for the RTS game.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads the RTS vehicle library, builds the `cars` table, and scans `gObjects` to register car objects.
- **Uses:** `dofile(gameroot.."Data/Scripts/RTS_Functions/RTS_Vehicles.lua")`, `getObjectInfo`, `setObjectInfo`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `init_car`, globals `gObjects`, `cars`, `gDoShadows`, `computeLODModelName`, `IG3D_*` constants.
- **Reusable:** no
- **Procedural:** no
