<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Collisions.lua (model spark-x2.6-4b, 2026-11-12 16:27). DRAFT for Claude to review. -->

## RTS_Collisions.lua
- **Kind:** library
- **Purpose:** This file contains collision-handling logic for the iGame3D engine, providing functions that manage object-to-object collisions, damage application, vehicle driving state changes, door opening, fight orders, and untangle events based on object movement.
- **Depends on:** `Data/` folder paths (including `Data/Images/Decals/bloodpencil`), other Lua scripts loaded via `dofile` and `loadLevel`, globals such as `gObjects`, and engine functions/constants like `get`, `getObjectInfo`, `setObjectInfo`, `setBoneInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `loadLevel`, `time`, `vecLength`, `normalized`, `opendoor`, `fight_enemy_order`, `eat_dead_human`, `object_action_eat`, `object_action_melee`, and constants `IG3D_VELOCITY`, `IG3D_START`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_NAME`, `IG3D_RAGDOLL`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_TEXTURE`, `IG3D_ADD`, `IG3D_REPEAT`.
- **Provides:** `objectAgainstParticles` and `objectAgainstObject` functions, which handle object-to-object and object-to-particle collision logic.
- **Assets it needs:** `Data/Images/Decals/bloodpencil` (image path used for blood decals).
- **Procedural:** none
- **Glossary:**
  - `IG3D_*` constants - Engine constants naming properties such as position, rotation, velocity, and collision data used in object info calls.
  - `getObjectInfo` / `setObjectInfo` - Engine calls to read or set object properties like position, rotation, and velocity.
  - `setBoneInfo` / `setParticle_emitterInfo` / `setSound_emitterInfo` - Engine calls to set properties on bones, particle emitters, and sound emitters.
  - `dofile` - Engine call to load a Lua script from a file path.
  - `loadLevel` - Engine call to switch the active game or demo level.
  - `gObjects` - Global shared between files holding game objects.
  - `opendoor` - Function that opens a door.
  - `fight_enemy_order` - Function that assigns a fight order to an object.
  - `eat_dead_human` / `object_action_eat` / `object_action_melee` - Functions handling eating and melee collision actions for objects.
- **Keep / port / drop:** keep - useful reference for implementing object collision logic in a new engine.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** The file contains a single function, `objectAgainstParticles`, with no additional top-level setup, globals, or widget definitions.
- **Uses:** `get`, `getBoneInfo`, `setBoneInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `getObjectInfo`, `normalized`, `drawToTexture`, `math.random`, and constants `IG3D_NAME`, `IG3D_RAGDOLL`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_TEXTURE`, `IG3D_ADD`, `IG3D_REPEAT`. Also reads/writes object fields such as `team`, `cObj`, `bone`, `health`, `blood`, and uses the `Data/Images/Decals/bloodpencil` path.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Contains no setup, global declarations, widget definitions, or other code outside the `objectAgainstObject` function.
- **Uses:** nothing
- **Reusable:** no

### objectAgainstObject
- **Does:** Handles collisions between two objects by applying damage based on their velocity, triggering vehicle driving state changes, opening doors, assigning fight orders, and setting untangle events when one object moves faster than the other.
- **Uses:** `getObjectInfo`, `setSound_emitterInfo`, `setObjectInfo`, `get`, `dofile`, `loadLevel`, `gObjects`, `time`, `vecLength`, `normalized`, `opendoor`, `fight_enemy_order`, `eat_dead_human`, `object_action_eat`, `object_action_melee`, `object_action_eat`, `IG3D_VELOCITY`, `IG3D_START`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `doorTeam`, `objdistance`, `coll_o_p`, `coll_o_o`
- **Reusable:** no
- **Procedural:** no
