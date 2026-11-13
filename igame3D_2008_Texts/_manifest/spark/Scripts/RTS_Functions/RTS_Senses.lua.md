<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Senses.lua (model spark-x2.6-4b, 2026-11-12 16:39). DRAFT for Claude to review. -->

## RTS_Senses.lua
- **Kind:** library
- **Purpose:** This file provides sensor and memory logic for a 3D game engine, handling distance table construction, eye and ear line-of-sight detection, and object sensing state management for game objects. It contains no top-level setup or widget definitions.
- **Depends on:** `Data/` folder paths, engine calls such as `getCameraInfo`, `getObjectInfo`, `getBoneInfo`, `setObjectInfo`, `get`, `normalized`, `dot`, `lineCollision`, and globals `gObjects`, `gDistances`, plus functions `unique_sense_insert`, `getBoneInfo`, and engine constants like `IG3D_POSITION`, `IG3D_COLL`, `IG3D_ROTATION_MATRIX`, `IG3D_NAME`.
- **Provides:** `buildDistancesTable`, `objdistance`, `handle_object_eyes`, `handle_object_ears`, `unique_mind_insert`, `unique_sense_insert`, `forget_corpses`, `handle_object_remembering`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** builds the distance table and object sensing state tables from object positions, distances, and game rules (e.g., marking objects as heard when within hearing range, removing dead objects from the mind table) rather than loading asset files.
- **Glossary:**
  - `gObjects` - shared table of all game objects in the engine.
  - `gDistances` - precomputed table of pairwise object distances built by `buildDistancesTable`.
  - `IG3D_POSITION` - engine constant naming the position property of an object.
  - `IG3D_COLL` - engine constant naming the collision property of an object.
  - `IG3D_ROTATION_MATRIX` - engine constant naming the rotation matrix property of an object.
  - `unique_sense_insert` - function that inserts an object into a sensing table only if no matching object already exists.
  - `unique_mind_insert` - function that inserts an object into a mind table only if no matching object with the same `o` field already exists.
  - `forget_corpses` - function that removes dead objects from an object's mind table.
- **Keep / port / drop:** keep - core sensor and memory logic that can be reused for similar detection calculations in a new engine.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** The file contains two functions, `buildDistancesTable` and `objdistance`, with no additional top-level setup, globals, or widget definitions.
- **Uses:** Engine calls `getCameraInfo(IG3D_POSITION)`, `getObjectInfo(obj, IG3D_POSITION)`, and global `gObjects`, `gDistances`.
- **Reusable:** no

### buildDistancesTable
- **Does:** Builds a distance table for relevant game objects, either marking all objects as relevant or computing pairwise distances between relevant objects and storing them in `gDistances`.
- **Uses:** Engine calls `getCameraInfo(IG3D_POSITION)`, `getObjectInfo(obj, IG3D_POSITION)`, and globals `gObjects`, `gDistances`.
- **Reusable:** yes - pure data table construction based on object positions and distance calculations.

### objdistance
- **Does:** Returns the precomputed distance between two objects from the distances table built by `buildDistancesTable`.
- **Uses:** Global `gDistances`.
- **Reusable:** yes - simple lookup of a precomputed data value.

## Part 2 of 3

### Top level
- **Does:** No top-level code outside the `handle_object_eyes` function.
- **Uses:** nothing
- **Reusable:** no

### handle_object_eyes
- **Does:** Computes the head bone position, disables object collision for the object, checks line of sight to other objects in the scene, and restores the original collision state afterward.
- **Uses:** `get(ig3d_bone, obj.cObj, "head")`, `getBoneInfo(bn, IG3D_POSITION)`, `getObjectInfo(obj.cObj, IG3D_COLL)`, `setObjectInfo(obj.cObj, IG3D_COLL, false)`, `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(obj.cObj, IG3D_COLL, oldcoll)`, `getObjectInfo(gObjects[i].cObj, IG3D_POSITION)`, `normalized(dx,dy,dz)`, `dot(a31,a32,a33, dx,dy,dz)`, `lineCollision(x,y,z, x2,y2,z2)`, `gObjects`, `obj.vehicle`, `unique_sense_insert`
- **Reusable:** yes - the line-of-sight detection logic using bone positions, rotation matrix dot products and collision checks can be reused for similar sensor calculations.
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file.
- **Uses:** nothing
- **Reusable:** no

### handle_object_ears
- **Does:** Iterates over all objects in the shared `gObjects` table, marks other objects as heard when within the hearing range, and inserts the heard object into the object's `sensed` table via `unique_sense_insert`.
- **Uses:** `gObjects`, `objdistance`, `getObjectInfo`, `IG3D_NAME`, `unique_sense_insert`, `obj.hearingDistance`, `obj.noise`, `obj.sensed`, `obj.heardFlag`, `obj.mind`
- **Reusable:** yes
- **Procedural:** no

### unique_mind_insert
- **Does:** Checks whether a given object already exists in the provided table by matching its `o` field, copies its `seenFlag` and `heardFlag` values if present, and returns without inserting if a match is found; otherwise appends the object to the table.
- **Uses:** `tbl`, `thng`, `o`, `seenFlag`, `heardFlag`
- **Reusable:** yes
- **Procedural:** no

### unique_sense_insert
- **Does:** Checks whether a given object already exists in the provided table by direct equality match, returns without inserting if a match is found, otherwise appends the object to the table.
- **Uses:** `tbl`, `thng`
- **Reusable:** yes
- **Procedural:** no

### forget_corpses
- **Does:** Removes dead (health <= 0) objects from the object's `mind` table by scanning the table backwards and deleting matching entries.
- **Uses:** `obj.mind`, `obj.mind[i].o.health`
- **Reusable:** yes
- **Procedural:** no

### handle_object_remembering
- **Does:** Iterates over the object's `mind` table, copies the `heardFlag` and `seenFlag` values from each mind entry to the corresponding object, and inserts each mind object into the object's `sensed` table via `unique_sense_insert`.
- **Uses:** `obj.mind`, `obj.mind[i].o.heardFlag`, `obj.mind[i].o.seenFlag`, `unique_sense_insert`, `obj.sensed`
- **Reusable:** yes
- **Procedural:** no
