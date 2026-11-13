<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Attributes.lua (model spark-x2.6-4b, 2026-11-12 16:04). DRAFT for Claude to review. -->

## RTS_Attributes.lua
- **Kind:** library
- **Purpose:** This file defines two reusable Lua functions for initializing game objects and running a final pass over all registered game objects to configure their attributes. It contains no top-level executable code, only the function definitions.
- **Depends on:** `Data/` folder paths, `gObjects` global, `default_behaviour`, `object_action_idle`, `gMasterAnimSource`, `selectionRect`, `alive`, `cObj`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `computeLODModelName`, `lineCollision`, `vecLength`, and the `IG3D_*` constants used in object info calls.
- **Provides:** `putObjectOnGround`, `init_object`, `init_all_objects`, `allEntitySoundCollLOD`.
- **Assets it needs:** `Data/Sounds/bodyhit.ogg`
- **Procedural:** none
- **Glossary:**
  - `getObjectInfo` - reads the current property values of a game object.
  - `setObjectInfo` - writes property values to a game object.
  - `IG3D_POSITION` - the property name for an object's position.
  - `IG3D_GRAVITY_MULTIPLIER` - the property name for an object's gravity multiplier.
  - `IG3D_COLL` - the property name for an object's collision setting.
  - `IG3D_VECTOR_CONSTRAINT` - the property name for an object's vector constraint setting.
  - `IG3D_BONE_COLL` - the property name for an object's bone collision setting.
  - `IG3D_CAST_SHADOW` - the property name for an object's cast shadow setting.
  - `IG3D_LOD_MODEL` - the property name for an object's LOD model setting.
- **Keep / port / drop:** keep - reusable initialization logic for game objects and a final attribute pass over all registered objects.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No top-level code outside the two defined functions; the file begins directly with the function definitions.
- **Uses:** nothing
- **Reusable:** no

### putObjectOnGround
- **Does:** Moves an object away from a ray path, casts upward and downward rays from the object's position to find the nearest collision, then repositions the object at the nearest collision point with a small upward offset.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `lineCollision`, `vecLength`, `IG3D_BOUNDS`, `IG3D_POSITION`
- **Reusable:** no

### init_object
- **Does:** Initializes default state and attributes for a game object, setting flags, numeric values, animation state, task data, and other default properties.
- **Uses:** `time`, `math.random`, `gObjects`, `default_behaviour`, `object_action_idle`
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the two defined functions; the file consists solely of the two function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### init_all_objects
- **Does:** Iterates over all registered game objects, initializes each object's values, adjusts the position of each object's underlying model to avoid start intersections, applies ground placement, and performs special handling for the master object and selection box.
- **Uses:** `gObjects`, `init_object`, `getObjectInfo`, `setObjectInfo`, `putObjectOnGround`, `string.sub`, `gMasterAnimSource`, `selectionRect`, `alive`, `cObj`, `IG3D_POSITION`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_COLL`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_BONE_COLL`, `IG3D_CAST_SHADOW`, `IG3D_LOD_MODEL`
- **Reusable:** no

### allEntitySoundCollLOD
- **Does:** Runs a final pass over all registered game objects, sets gravity for every object, and configures sound emitters, collision, shadow, and LOD model settings for alive objects.
- **Uses:** `gObjects`, `setObjectInfo`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `gDoShadows`, `computeLODModelName`, `alive`, `cObj`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_SAMPLE`, `Data/Sounds/bodyhit.ogg`, `IG3D_BONE_COLL`, `IG3D_CAST_SHADOW`, `IG3D_LOD_MODEL`
- **Reusable:** no
