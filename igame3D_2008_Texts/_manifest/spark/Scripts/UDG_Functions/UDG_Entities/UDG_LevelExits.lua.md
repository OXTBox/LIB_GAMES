<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_LevelExits.lua (model spark-x2.6-4b, 2026-11-12 14:39). DRAFT for Claude to review. -->

## UDG_LevelExits.lua
- **Kind:** level-script
- **Purpose:** Builds a `levelexit` table from the game objects whose names contain `levelexit`, then configures each entry with position, rotation, physics, and entity flags for the UDG level. It is a level-specific setup routine used to define exit entities for the UDG game or demo.
- **Depends on:** Other files in the `Scripts/UDG_Functions/UDG_Entities` folder that provide the referenced globals and helper functions; globals `gObjects`, `gObjectPositions`, `gObjectRotations`, `levelexitTeam`, `gDoShadows`, and `computeShadowModelName` set elsewhere; no `Data/` file paths are used.
- **Provides:** The `levelexit` table, assembled from matching game objects and configured with position, rotation, physics, and entity flag settings.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in the file).
- **Procedural:** none (the file builds and configures existing game objects; it does not generate assets from numbers or rules).
- **Glossary:**
  - `levelexit` - A table collecting the exit entities for a level, built from game objects whose names contain `levelexit`.
  - `getObjectInfo` - Engine call that reads the current property values of a game object.
  - `setObjectInfo` - Engine call that writes property values to a game object.
  - `gObjects` - Global table holding the game objects shared across files.
  - `gDoShadows` - Global flag controlling whether shadows are rendered.
  - `computeShadowModelName` - Helper function used to derive a shadow model name for an object.
  - `levelexitTeam` - Global name associated with the UDG level's exit entity configuration.
- **Keep / port / drop:** keep - it is a level-specific setup routine that documents how exit entities are configured for the UDG level and can be reused for similar level entity setups.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds a `levelexit` table from the game objects whose names contain `levelexit`, then configures each entry with position, rotation, physics and entity flags.
- **Uses:** `getObjectInfo`, `setObjectInfo`, globals `gObjects`, `gObjectPositions`, `gObjectRotations`, `levelexitTeam`, `gDoShadows`, `computeShadowModelName`; no `Data/` paths.
- **Reusable:** no - it is a level-specific entity collection and setup routine tied to the UDG level structure.
- **Procedural:** no
