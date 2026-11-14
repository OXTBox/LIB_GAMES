<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_AI.lua (model spark-x2.6-4b, 2026-11-12 17:16). DRAFT for Claude to review. -->

## UDG_AI.lua
- **Kind:** library
- **Purpose:** This file implements UDG AI logic for the iGame3D engine, including scene LOD and sense management, zombie near-player and sight handling, object task execution, and floor collision checks. It also contains smaller helper functions for zombie distance and near-player state marking.
- **Depends on:** `Data/` folder paths, globals set elsewhere such as `gObjects`, `gPathsSet`, `gOldPlayerPosX`, `gOldPlayerPosY`, `gOldPlayerPosZ`, `playerBox`, `gDangerFlag`, `gAISliceSize`, `gAISliceOffset`, `gSensesTime`, `gSensesInterval`, and engine functions like `setSceneInfo`, `getObjectInfo`, `setObjectInfo`, `getBoneInfo`, `setParticle_emitterInfo`, `get`, `do_task`, `fltk_update`; loads code via `dofile` and levels via `loadLevel`.
- **Provides:** `handle_UDGAI`, `udg_zombies_in_touch_distance`, `udg_build_zombie_near_values`, `udg_enemy_in_sight`, `udg_zombies_follow`, `udg_untangle`, `getupfromfloor`, `coll_obj_mesh_udg`, and the `coll_o_m` alias.
- **Assets it needs:** `Data/Sounds/bodyhitfloor.ogg`
- **Procedural:** none
- **Glossary:**
  - `IG3D_POSITION -` engine property constant naming the object's position.
  - `IG3D_RAGDOLL -` engine property constant for ragdoll object state.
  - `IG3D_COLL -` engine property constant for collision state.
  - `IG3D_GRAVITY_MULTIPLIER -` engine property constant for gravity multiplier.
  - `IG3D_VECTOR_CONSTRAINT -` engine property constant for vector constraint configuration.
  - `IG3D_LINK_MAIN_BONE_TO_VELOCITY -` engine property constant for main bone velocity linking.
  - `IG3D_IGNORE_OBJECT_COLLS -` engine property constant for collision ignore state.
  - `IG3D_LOD_DISTANCE -` engine property constant for scene LOD distance parameters.
- **Keep / port / drop:** keep - core AI logic and helper functions reusable in a new engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Sets the global `gDangerFlag` to false and defines the globals `gAISliceSize` (equal to the length of `gObjects`) and `gAISliceOffset` (set to 0).
- **Uses:** Globals `gDangerFlag`, `gObjects`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 4

### Top level
- **Does:** Contains no top-level code outside the `handle_UDGAI` function; the file consists solely of the function implementation.
- **Uses:** `setSceneInfo`, `time`, `gSensesTime`, `gSensesInterval`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `handle_melee_weapons`, `play_car_sounds`, `handle_health`, `gAISliceOffset`, `gAISliceSize`, `gObjects`, `setObjectInfo`, `getObjectInfo`, `get`, `getBoneInfo`, `setParticle_emitterInfo`, `bloodonfloor`, `IG3D_LOD_DISTANCE`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_START`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, `do_task`, `bulletTimeKey`, `stopTimeKey`, `fltk_update`
- **Reusable:** no

### handle_UDGAI
- **Does:** Runs UDG AI logic: sets scene LOD distance parameters, manages timed sense handling, builds distance tables, triggers object AI and health processing, handles object freeze/reanimate states, runs task execution, and applies keyboard time controls before updating the FLTK UI.
- **Uses:** `setSceneInfo(IG3D_LOD_DISTANCE, 5,50,50,50)`, `time`, `gSensesTime`, `gSensesInterval`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `handle_melee_weapons`, `play_car_sounds`, `handle_health`, `gAISliceOffset`, `gAISliceSize`, `gObjects`, `setObjectInfo`, `getObjectInfo`, `get`, `getBoneInfo`, `setParticle_emitterInfo`, `bloodonfloor`, `IG3D_LOD_DISTANCE`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_START`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, `do_task`, `bulletTimeKey`, `stopTimeKey`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 4

### Top level
- **Does:** No top-level code exists outside the four listed functions.
- **Uses:** nothing
- **Reusable:** no

### udg_zombies_in_touch_distance
- **Does:** Determines whether two zombie objects are within a 2.5-unit distance, returning true only when the object distance is less than 2.5.
- **Uses:** `objdistance(z1, z2)`
- **Reusable:** yes - pure distance comparison logic.

### udg_build_zombie_near_values
- **Does:** Marks zombie objects that are near the player as nearPlayer, using a growing set of nearby objects, then optionally prints nearPlayer state for team 1 zombies when key "k" or "n" is pressed.
- **Uses:** `gObjects`, `playerBox`, `key`, `print`, `udg_zombies_in_touch_distance`
- **Reusable:** yes - data-driven object state marking logic.

### udg_enemy_in_sight
- **Does:** Checks whether an object has sensed objects on the opposing team, returning true if the first sensed object belongs to the opposing team.
- **Uses:** `obj.sensed`, `obj.team`
- **Reusable:** yes - pure object state comparison logic.

### udg_zombies_follow
- **Does:** Builds the zombie near-player values, then if gPathsSet is set, stores the player's current position in global variables and resets gPathsSet to false.
- **Uses:** `gPathsSet`, `gOldPlayerPosX`, `gOldPlayerPosY`, `gOldPlayerPosZ`, `getObjectInfo(playerBox, IG3D_POSITION)`, `udg_build_zombie_near_values`
- **Reusable:** yes - state management logic tied to engine object info calls.

## Part 4 of 4

### Top level
- **Does:** No top-level code outside the three function definitions and the `coll_o_m` alias.
- **Uses:** nothing
- **Reusable:** no

### udg_untangle
- **Does:** Sets the task fields on an object to transfer order and target data, and restores the old order if the current order's continue time has passed.
- **Uses:** nothing
- **Reusable:** no

### getupfromfloor
- **Does:** Resets the object's freeze state and health, enables collision and gravity, sets the ragdoll animation and order, then configures rotation and velocity constraints on the object's main bone.
- **Uses:** `setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, false)`, `setObjectInfo(obj.cObj, IG3D_COLL, true)`, `setObjectInfo(obj.cObj, IG3D_GRAVITY_MULTIPLIER, 1)`, `setObjectInfo(obj.cObj, IG3D_ROTATION, 0,0,0)`, `setObjectInfo(obj.cObj, IG3D_GRAVITY_MULTIPLIER, 1)`, `setObjectInfo(obj.cObj, IG3D_VECTOR_CONSTRAINT, 0,1,0)`, `setObjectInfo(obj.cObj, IG3D_LINK_MAIN_BONE_TO_VELOCITY, false)`, `time()`
- **Reusable:** no

### coll_obj_mesh_udg
- **Does:** Checks if the object is a team greater than 1 or a ragdoll not yet hit the floor, then triggers a floor hit sound and checks whether the object's position is above its current position to set an untangle event.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_RAGDOLL)`, `getBoneInfo(get(ig3d_bone, obj.cObj, "head"), IG3D_POSITION)`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_LOOP, false)`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_VOLUME, 3)`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_SAMPLE, "Data/Sounds/bodyhitfloor.ogg")`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))`, `setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)`, `getObjectInfo(obj.cObj, IG3D_POSITION)`, `normalized(ox-x, 0, oz-z)`, `time()`, `getObjectInfo(obj.cObj, IG3D_RAGDOLL)`
- **Reusable:** no

### coll_o_m
- **Does:** Alias that binds the `coll_obj_mesh_udg` function to the name `coll_o_m`.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no
