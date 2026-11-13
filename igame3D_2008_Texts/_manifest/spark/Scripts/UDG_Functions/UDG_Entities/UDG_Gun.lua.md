<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Gun.lua (model spark-x2.6-4b, 2026-11-12 14:38). DRAFT for Claude to review. -->

## UDG_Gun.lua
- **Kind:** library
- **Purpose:** This file defines and configures gun-related objects for the UDG game, including scanning and tagging gun entities, assigning guns to humans, and setting gun properties and sound settings. It supports both manual gun assignment and automatic gun population for the game's entities.
- **Depends on:** `gObjects` global table, `humans` global table, `guns` global table, `resetCollisionToDefault`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `setObjectInfo`, `getObjectInfo`, `loadLevel` (via `Data/` folder structure), and `Data/Sounds/` sound files.
- **Provides:** `guns` global table (gun-tagged object collection), gun assignment and configuration logic for humans, and automatic gun population logic for objects.
- **Assets it needs:** `Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg`
- **Procedural:** none
- **Glossary:**
  - `gObjects` - global table holding all game objects, scanned for gun-related entities.
  - `guns` - global table used to collect and manage gun-tagged objects.
  - `getObjectInfo` - engine call to read properties of a game object.
  - `setObjectInfo` - engine call to set properties of a game object.
  - `resetCollisionToDefault` - engine call to reset an object's collision settings to default.
  - `assign_free_sound_emitter` - engine call to assign a free sound emitter to an object.
  - `setSound_emitterInfo` - engine call to configure a sound emitter's properties.
  - `IG3D_NAME` - engine constant naming the NAME property being read or set.
- **Keep / port / drop:** keep - reusable gun tagging and configuration logic for similar entity categorization tasks.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the `guns` table by scanning all objects in `gObjects`, tagging matching objects as guns and setting their gun-related properties.
- **Uses:** Engine calls (`getObjectInfo`, `setObjectInfo`), globals (`gObjects`, `resetCollisionToDefault`), and file paths (`Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg`).
- **Reusable:** yes - the gun tagging and property assignment logic can be reused for similar object categorization tasks.

### HumansWithGuns
- **Does:** Randomly assigns a gun to a random human, ignoring humans that already have a gun or melee weapon, and configures the gun's sound emitter and collision settings.
- **Uses:** Engine calls (`assign_free_sound_emitter`, `setSound_emitterInfo`, `setObjectInfo`), globals (`humans`, `gunned_civilian_behaviour`, `guns`), and file paths (`Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg`).
- **Reusable:** no - the assignment logic depends on the specific gun and human state setup for this engine.

### AllHumansWithGuns
- **Does:** Iterates through all humans, randomly assigning a gun to those without an existing gun or melee weapon, choosing between civilian and soldier behaviour and configuring the gun's properties.
- **Uses:** Engine calls (`assign_free_sound_emitter`, `setSound_emitterInfo`, `setObjectInfo`), globals (`humans`, `gunned_civilian_behaviour`, `soldier_behaviour`, `guns`), and file paths (`Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg`).
- **Reusable:** no - the assignment logic depends on the specific gun and human state setup for this engine.

## Part 2 of 2

### udg_sniper_guns
- **Does:** Iterates over all objects in `gObjects`, selects those whose name starts with `glo`, `gun` or `rif`, marks them as guns, resets their collision to default, and configures their gun-related properties and sound settings.
- **Uses:** `gObjects`, `getObjectInfo`, `resetCollisionToDefault`, `guns` (global table), `IG3D_NAME`, `Data/Sounds/rifle.ogg`, `Data/Sounds/colt45.ogg`
- **Reusable:** yes - the object filtering and gun property setup logic can be reused for similar entity categorization in other scripts.
- **Procedural:** no
