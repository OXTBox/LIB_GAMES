<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_AI.lua (model spark-x2.6-4b, 2026-11-12 16:03). DRAFT for Claude to review. -->

## RTS_AI.lua
- **Kind:** library
- **Purpose:** This file implements the RTS AI behaviour for iGame3D, defining shared global AI settings, object sense handling, perception prioritization, task execution, combat and animation logic, and the top-level AI entry points that drive an AI object's behaviour. It is a reusable library of AI logic that can be adapted for a new engine.
- **Depends on:** `Data/Scripts/Functions/math_functions.lua`, `Data/Scripts/Functions/` subfolders (`Senses`, `Vehicles`, `Weapons`, `Orders`, `Utilities`), engine globals (`gObjects`, `gameroot`, `gSensesInterval`, `gSensesTime`, `gRelevantActingDistance`, `gZoomDistance`, `gLookAround`, `gTrackedObject`, `gInverseGameSpeed`, `gSpeedResetTime`, `gOldGameSpeed`, `gActivateStartSounds`, `gTrackedPosition`, `gSelectionRect`, `gDraggingSelRect`, `gDanger`), engine functions (`getObjectInfo`, `setObjectInfo`, `setSound_emitterInfo`, `setMaterialInfo`, `getMaterialInfo`, `get`, `getBoneInfo`, `setBoneInfo`, `getObjectModelPath_s_s`, `ig3d_GetObjectModelPath_s_s`, `ig3d_SetMode_i`, `drive_car_around`, `resetCollisionToDefault`, `destroyHouse`, `checkGameEndCondition`, `correctCrossingPosition`, `getNextCrossingPosition`, `steer_aim`, `car_stuck`, `car_flipped`, `putObjectOnGround`, `drawToTexture`, `generateAStarPathBetweenPositions`, `forget_corpses`, `handle_object_remembering`, `handle_object_eyes`, `handle_object_ears`, `handle_behaviour`, `handle_order_and_behaviour`, `getRandomAnimationOfStyle`), and object state fields (`sensed`, `mind`, `behaviour`, `task`, `anim`, `vehicle`, `order`, `cObj`, `cObj` model references, etc.).
- **Provides:** Functions `computeLODModelName`, `computeShadowModelName`, `handle_senses`, `comparePriorities`, `sort_perceived_objects_by_priority`, `handle_behaviour`, `handle_health`, `task_to_string`, `try_to_reach_object`, `do_task`, `handle_order_and_behaviour`, `handle_ai`, plus shared globals `gSensesInterval`, `gSensesTime`, `gRelevantActingDistance`, `gZoomDistance`, `gLookAround`, `gTrackedObject`, `gInverseGameSpeed`, `gSpeedResetTime`, `gOldGameSpeed`, `gActivateStartSounds`, `gTrackedPosition`, `gObjects`, `gSelectionRect`, `gDraggingSelRect`, `gDanger`, `gDangerO`, and constants such as `object_action_goto`, `object_action_stab`, `object_action_idle`, `object_action_shootat`, `object_action_melee`, `object_action_lookat`, `object_action_drive`, `object_action_eat`, `object_action_sidestep`, and task ID prefix constants used by `task_to_string`.
- **Assets it needs:** Models referenced via `Data/WTF` (e.g. `low.wtf`, `shadow.wtf`), images (`Data/Images/Decals/holepainter.png`, `Data/Images/Decals/bloodpencil.png`), sounds (`udg_play_hit_sound`, `udg_play_get_eaten_sound`, `udg_play_eat_sound`), emitters (`.emt` particle settings), fonts (`Data/FontPngs`), BVH motion capture data, and 3D model files named in `Data/WTF` via `make(ig3d_object, "file.wtf")` calls.
- **Procedural:** yes - generates procedural paths and animation parameters: `try_to_reach_object` generates an A* path between object positions and trims it based on source/target distance; `do_task` and other functions compute animation tables, movement values, and object orientation from task types, object state, and numeric parameters (e.g. `math.ceil`, `math.random`, `math.max`, `math.floor`).
- **Glossary:**
  - `ig3d_object` - iGame3D object kind used as the first argument to `make`/`get` calls to reference an object.
  - `IG3D_POSITION` - iGame3D constant naming the position property of an object, read or set via `getObjectInfo`/`setObjectInfo`.
  - `IG3D_NAME` - iGame3D constant naming the name property of an object, read via `getObjectInfo` to extract model paths.
  - `low.wtf` / `shadow.wtf` - model file names appended to object model paths to get low-level and shadow-level model names.
  - `sensed` - object field holding the list of perceived objects used for AI prioritization and sorting.
  - `mind` - object field holding remembered perceived object entries used for AI memory tracking.
  - `object_action_*` - constants naming AI task/action types (e.g. `object_action_goto`, `object_action_shootat`) that drive AI behaviour.
  - `task` - object field referencing the task object that drives the AI object's current behaviour.
- **Keep / port / drop:** keep - core reusable AI logic for RTS-style object behaviour, sense handling, and task execution that can be referenced when building a new engine.

---

# Part notes

## Part 1 of 13

### Top level
- **Does:** Defines shared global settings for the RTS AI system, including sense handling intervals, tracking parameters, and initial object tracking state.
- **Uses:** Globals `gSensesInterval`, `gSensesTime`, `gRelevantActingDistance`, `gZoomDistance`, `gLookAround`, `gTrackedObject`, `gInverseGameSpeed`, `gSpeedResetTime`, `gOldGameSpeed`, `gActivateStartSounds`, `gTrackedPosition`, `gObjects`, `gSelectionRect`, `gDraggingSelRect`, `gDanger`; engine calls `getObjectInfo(obj, IG3D_POSITION)`; paths `gameroot.."Data/Scripts/Functions/math_functions.lua"` and `/RTS_Functions/".."Senses","Vehicles","Weapons","Orders","Utilities"`.
- **Reusable:** no

### computeLODModelName
- **Does:** Computes the low-level model file name for an object by extracting the model path and appending `low.wtf`.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_NAME)`, `ig3d_GetObjectModelPath_s_s(name)`; global `gameroot`; string operations `string.sub`.
- **Reusable:** yes

### computeShadowModelName
- **Does:** Computes the shadow-level model file name for an object by extracting the model path and appending `shadow.wtf`.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_NAME)`, `ig3d_GetObjectModelPath_s_s(name)`; global `gameroot`; string operations `string.sub`.
- **Reusable:** yes

### handle_senses
- **Does:** Runs the sense handling steps for an active object by invoking the eyes and ears sense handlers, with a placeholder comment for additional senses.
- **Uses:** Engine calls `handle_object_eyes(obj)`, `handle_object_ears(obj)`; global `obj`.
- **Reusable:** no

### comparePriorities
- **Does:** Compares two perceived object priority values, returning true when the first object has a higher priority than the second.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 13

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### sort_perceived_objects_by_priority
- **Does:** Calculates a priority value for each perceived object in the object's sensed list, stores the computed priority on each perceived object, sorts the sensed list by priority, and inserts a remembered entry for each perceived object into the object's mind table.
- **Uses:** `obj.sensed`, `obj.mind`, `gRelevantActingDistance`, `objdistance`, `unique_mind_insert`, `table.sort`, `math.max`, `math.floor`, `comparePriorities`, `object_action_goto` through `object_action_stab` (object action constants), `gRelevantActingDistance`
- **Reusable:** yes - pure data sorting and priority calculation logic that can be reused for similar perceived object prioritization in a new engine.

### handle_behaviour
- **Does:** Invokes the behaviour method of the given object to drive its behaviour.
- **Uses:** `obj.behaviour(obj)`
- **Reusable:** yes - a thin wrapper that can be reused wherever an object's behaviour needs to be triggered.

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 13

### Top level
- **Does:** No top-level code outside the `handle_health` function.
- **Uses:** nothing
- **Reusable:** no

### handle_health
- **Does:** Handles zero health states for an object: if it has a driver, resets the driver and its vehicle; if it is alive, decrements death count, clears vehicle and weapon state, marks the object as ignored for collision, stops animation, and triggers game end checks; if it has a house, destroys the house.
- **Uses:** Engine calls `setObjectInfo`, `getObjectInfo`, `setSound_emitterInfo`, `drive_car_around`, `resetCollisionToDefault`, `destroyHouse`, `checkGameEndCondition`; globals `IG3D_COLL`, `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_OMEGA`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_ROTATION_MATRIX`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ANIMATION`, `IG3D_RAGDOLL`; globals `default_behaviour`, `object_action_idle`; global `time`.
- **Reusable:** no
- **Procedural:** no

## Part 4 of 13

### Top level
- **Does:** No top-level code outside the two defined functions; the file contains only the function definitions for `task_to_string` and `try_to_reach_object`.
- **Uses:** nothing
- **Reusable:** no

### task_to_string
- **Does:** Converts a task object into a human-readable string by selecting a task-specific prefix based on its ID, appending the name of the object referenced by the task if it is not nil.
- **Uses:** `getObjectInfo(tsk.objInQuestion.cObj, IG3D_NAME)`
- **Reusable:** yes - it is a pure string formatting function that maps task IDs to fixed prefixes and reads a single object name.

### try_to_reach_object
- **Does:** Computes a target position offset from the source object's position, generates an A* path between the source and target objects, updates the task's position fields with the path's start position, and trims the path if the source and target are already within the reached tolerance.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `getObjectInfo(target.cObj, IG3D_POSITION)`, `normalized`, `vecLength`, `generateAStarPathBetweenPositions`, `gGridSize`, `gReachedTolerance`, `obj.lastpath`, `obj.pth`, `obj.task`
- **Reusable:** no - it depends on engine object info, path generation, and task/path state fields that are specific to the engine's object model.
- **Procedural:** no

## Part 5 of 13

### Top level
- **Does:** No top-level code outside the `do_task` function; the file begins directly with the function definition.
- **Uses:** nothing
- **Reusable:** no

### do_task
- **Does:** Updates a tasked object's position string and ground placement if it is below -15, then configures its animation table for team 1 zombies, records the previous animation name, reads the object's rotation matrix, and sets animation parameters and movement values based on the task type (cry, kick, stab, hit, punchair, goto).
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`, `getObjectInfo(obj.cObj, IG3D_NAME)`, `putObjectOnGround(obj)`, `RTS_print`, `math.ceil`, `turn_towards`, `try_to_reach_object`, `turn_towards_spot`, globals `zombieAnims`, `obj`, `obj.task`, `obj.anim`, `obj.team`, `obj.oldanimname`, `obj.animPickTable`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 13

### Top level
- **Does:** Contains the task-driven movement logic for RTS AI objects, handling runoff, runto, runtospot, and walktospot actions by setting animation parameters and object orientation.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_POSITION)`, `getObjectInfo(obj.cObj, IG3D_OMEGA)`, `setObjectInfo(obj.cObj, IG3D_OMEGA, ox,oy*2,oz)`; globals `obj`, `a31`, `a32`, `a33`, `IG3D_POSITION`, `IG3D_OMEGA`; helper functions `turn_away_from`, `try_to_reach_object`, `turn_towards_spot`, `normalized`, `dot`.
- **Reusable:** no
- **Procedural:** no

## Part 7 of 13

### Top level
- **Does:** Contains top-level script logic for RTS AI behaviour, including animation and weapon firing/melee handling for AI objects.
- **Uses:** Engine calls `getObjectInfo`, `get`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `getBoneInfo`, `normalized`; globals `obj`, `a31`, `a32`, `a33`, `gGunEmitter`, `muzzleFlash`, `gGunEmitter`; constants `IG3D_OMEGA`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`; globals `object_action_shootat`, `object_action_melee`; functions `turn_towards`, `dirToAngles`, `default_behaviour`, `aimingAtFriendlyObject`; file `Data/` paths referenced via engine path construction.
- **Reusable:** no
- **Procedural:** no

## Part 8 of 13

### Top level
- **Does:** Contains the top-level combat and animation logic for the RTS AI, handling stun triggers, movement animation, combat progression, and zombie conversion when a human is defeated.
- **Uses:** `obj`, `obj.team`, `obj.mayStunThisCombat`, `obj.mayStunAgainTime`, `obj.event`, `obj.task.objInQuestion`, `obj.anim`, `obj.nextMeleeAttack`, `obj.meleeDelay`, `obj.meleeInterval`, `obj.meleeWeapon`, `obj.gun`, `obj.order`, `obj.cObj`, `obj.killer`, `math.random`, `time`, `getObjectInfo`, `setObjectInfo`, `normalized`, `isFemale`, `IG3D_POSITION`, `IG3D_VELOCITY`, `udg_play_hit_sound`, `udg_play_get_eaten_sound`, `a41`, `a42`, `a43`, and local variables `dmg`, `dx`, `dy`, `dz`, `px`, `py`, `pz`, `qx`, `qy`, `qz`.
- **Reusable:** no
- **Procedural:** no

## Part 9 of 13

### Top level
- **Does:** Contains top-level script logic for RTS AI behavior, including collision-based decal drawing, health/order state updates, mind tracking, animation and vehicle driving setup.
- **Uses:** Engine calls `getObjectInfo`, `setMaterialInfo`, `drawToTexture`, `getMaterialInfo`, `get`, `getBoneInfo`, `setObjectInfo` (via `setMaterialInfo`), globals `a31`, `a32`, `a33`, `obj`, `obj.task`, `obj.order`, `obj.anim`, `obj.vehicle`, `obj.targetCrossing`, `obj.nextTurn`, `obj.footOnGas`, `obj.vehicle.cObj`, `obj.task.objInQuestion`, `obj.task.id`, `object_action_idle`, `object_action_lookat`, `object_action_drive`, `unique_mind_insert`, `vecLength`, `math.random`, `math.abs`, `dirs`, `nearestCrossing`; data paths `Data/Images/Decals/holepainter.png`; constants `IG3D_EXACT_COLLISION_DATA`, `IG3D_TRANSPARENT`, `IG3D_TEXTURE`, `IG3D_ADD`, `IG3D_CLAMP`, `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_STEERING_ANGLE`.
- **Reusable:** no
- **Procedural:** no

## Part 10 of 13

### Top level
- **Does:** Contains the top-level code for the RTS AI part, handling AI vehicle control logic and reanimation task setup.
- **Uses:** Engine calls including `correctCrossingPosition`, `getNextCrossingPosition`, `steer_aim`, `car_stuck`, `car_flipped`, `getObjectInfo`, `setObjectInfo`, `putObjectOnGround`, `setSound_emitterInfo`, `drive_car_around`, `setObjectInfo`, `setSound_emitterInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo

## Part 11 of 13

### Top level
- **Does:** Contains only top-level code for zombie AI behaviour handling: animation state reset, repositioning logic when reanimation time is reached, and task-driven actions for eating and sidestepping.
- **Uses:** Engine calls including `getObjectInfo`, `setObjectInfo`, `get`, `getBoneInfo`, `setBoneInfo`, `setParticle_emitterInfo`, `drawToTexture`; globals such as `time`, `IG3D_POSITION`, `IG3D_BOUNDS`, `IG3D_ROTATION`, `IG3D_ENABLED`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_ADD`, `IG3D_REPEAT`, `bloodParticles`, `zombie_behaviour`, `object_action_eat`, `object_action_sidestep`, `udg_play_eat_sound`; file path `Data/Images/Decals/bloodpencil`..".png"; variables `obj`, `obj.cObj`, `obj.task`, `obj.order`, `obj.anim`, `obj.mind`, `obj.behaviour`, `obj.blood`, `obj.nextMeleeAttack`, `obj.task.objInQuestion`, `bn1`, `bn2`, `px`, `py`, `pz`, `qx`, `qy`, `qz`, `dx`, `dy`, `dz`, `tx`, `ty`, `tz`, `result`, `u`, `v`, `m`.
- **Reusable:** no
- **Procedural:** no

## Part 12 of 13

### Top level
- **Does:** Contains the continuation of animation and velocity setup logic for an object, including animation state updates and velocity application.
- **Uses:** `obj`, `obj.anim`, `obj.task`, `obj.cObj`, `obj.oldanimname`, `obj.animPickTable`, `obj.anim.name`, `obj.anim.link`, `obj.pace`, `setObjectInfo`, `getObjectInfo`, `IG3D_OMEGA`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, `IG3D_ANIMATION`, `IG3D_VELOCITY`, `getRandomAnimationOfStyle`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 13

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the function `handle_order_and_behaviour` and `handle_ai`.
- **Uses:** nothing
- **Reusable:** no

### handle_order_and_behaviour
- **Does:** Handles combat stun timing for an object, then either invokes its event callback or order callback, otherwise falls back to the base behaviour.
- **Uses:** `obj.mayStunThisCombat`, `obj.mayStunAgainTime`, `time()`, `obj.event`, `obj.order`, `handle_behaviour`
- **Reusable:** yes

### handle_ai
- **Does:** Clears the object's sensed list, optionally runs sense handling, forgets dead corpses, remembers perceived objects, sorts perceived objects by priority, updates the global danger object and its path, then delegates order/behaviour handling.
- **Uses:** `obj.sensed`, `handle_senses`, `forget_corpses`, `handle_object_remembering`, `sort_perceived_objects_by_priority`, `gDanger`, `gDangerO`, `ig3d_SetMode_i`, `getObjectInfo`, `task_to_string`, `handle_order_and_behaviour`
- **Reusable:** yes
- **Procedural:** no
