<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Gun.lua (model spark-x2.6-4b, 2026-11-12 14:35). DRAFT for Claude to review. -->

## RTS_Gun.lua
- **Kind:** library
- **Purpose:** Defines the shared `guns` table by scanning existing game objects and applying gun-related configuration to them, then assigns each gun to a human that does not already have one so guns are distributed among players.
- **Depends on:** `Data/` folder paths, `dofile`-loaded scripts, globals `gObjects`, `humans`, `gunned_civilian_behaviour`, `guns`, `assign_free_sound_emitter`; engine constants `IG3D_NAME`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_BONE_COLL`, `IG3D_SHAPE`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_SAMPLE`; sound files `Data/Sounds/rifle.ogg` and `Data/Sounds/colt45.ogg`.
- **Provides:** the shared `guns` table, the `HumansWithGuns` helper that assigns guns to humans and configures their behaviour, sound emitter and gun reference.
- **Assets it needs:** sounds `Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg` (no models, images, emitters, or fonts named).
- **Procedural:** none (it scans existing objects and configures their properties rather than generating assets from numbers or rules).
- **Glossary:**
  - `gObjects` - global table of existing game objects used to scan for guns.
  - `gunned_civilian_behaviour` - global setting controlling behaviour for gunned civilian objects.
  - `assign_free_sound_emitter` - engine function that assigns a free sound emitter to an object.
  - `setSound_emitterInfo` - engine call that sets sound emitter properties on an object.
  - `setObjectInfo` - engine call that sets properties on a game object.
  - `getObjectInfo` - engine call that reads properties from a game object.
  - `IG3D_*` - engine constants naming the properties being read or set on objects (e.g. position, collision, shape).
- **Keep / port / drop:** keep - reusable library code for distributing guns to humans in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the shared `guns` table and populates it by scanning existing objects, then sets gun-related properties on those objects.
- **Uses:** `getObjectInfo`, `setObjectInfo`, globals `gObjects`, `humans`, `gunned_civilian_behaviour`, `assign_free_sound_emitter`, engine constants `IG3D_NAME`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_BONE_COLL`, `IG3D_SHAPE`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_SAMPLE`; file path `Data/Sounds/rifle.ogg` and `Data/Sounds/colt45.ogg`.
- **Reusable:** no

### HumansWithGuns
- **Does:** Randomly assigns each gun in the `guns` table to a human that does not already have a gun, configuring the human's behaviour, sound emitter and gun reference, and disabling collision and gravity on the gun object.
- **Uses:** `setSound_emitterInfo`, `setObjectInfo`, globals `guns`, `humans`, `gunned_civilian_behaviour`, `assign_free_sound_emitter`; engine constants `IG3D_SAMPLE`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`.
- **Reusable:** no
- **Procedural:** no
