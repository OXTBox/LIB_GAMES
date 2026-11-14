<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Orders.lua (model spark-x2.6-4b, 2026-11-12 16:37). DRAFT for Claude to review. -->

## RTS_Orders.lua
- **Kind:** library
- **Purpose:** This file defines combat and movement task helpers for enemy objects in the iGame3D engine, covering order-based movement, vehicle driving, eating, gun pickup, and path-based actions. It contains only function implementations with no top-level setup, globals, or UI definitions.
- **Depends on:** Other Scripts libraries (e.g., `drive_to_spot`, `drive_to_obj`, `run_on_path`, `handle_car_sounds`, `assign_free_sound_emitter`, `gunned_civilian_behaviour`), engine globals (`gReachedTolerance`, `gObjects`), and engine property constants (`IG3D_ANIMATION`, `IG3D_VEHICLE`, `IG3D_VELOCITY`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`, `IG3D_IGNORE_COLL`), and object fields such as `cObj`, `task`, `order`, `vehicle`, `pth`, `gun`, `target`, `targetCrossing`, `nextTurn`.
- **Provides:** Functions for assigning enemy tasks (`fight_enemy_order`, `eat_dead_human`, `attackHouseForSomeTime`), movement and driving (`run_to_vehicle`, `run_to_house`, `run_to_spot`, `walk_to_spot`, `drive_to_obj`, `drive_to_spot`, `walk_on_path`, `run_on_path`, `pickup_gun`), and path/vehicle handling (`drive_vehicle`, `drive_to_obj`).
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (the file only configures object tasks, positions, and vehicle driving; it does not generate assets from numbers or rules).
- **Glossary:**
  - `IG3D_*` - Engine property constants that name the property being read or set on objects (e.g., `IG3D_POSITION` for position, `IG3D_VEHICLE` for vehicle state).
  - `object_action_*` - Engine task action identifiers used to assign movement or combat tasks to objects.
  - `drive_to_obj` - Function that drives an object to a target object by computing a direction and calling `drive_to_spot`.
  - `run_on_path` - Function that advances an object along its path based on distance tolerance and updates its task.
  - `gReachedTolerance` - Shared engine global used to check whether an object has reached its target position.
  - `gObjects` - Shared engine global holding the collection of game objects.
  - `gunned_civilian_behaviour` - Shared engine global controlling behavior for objects picking up guns.
  - `setSound_emitterInfo` - Engine call used to configure sound emitters for objects.
- **Keep / port / drop:** keep - core task and movement logic for enemy objects that other Scripts files rely on for combat and movement behavior.

---

# Part notes

## Part 1 of 6

### fight_enemy_order
- **Does:** Assigns combat or idle tasks to an enemy object based on whether the target is alive, whether the object is a vehicle, and the object's current animation and distance to the target.
- **Uses:** `objdistance`, `obj.meleeDistance`, `obj.farDistance`, `obj.team`, `obj.oldanimname`, `obj.task.id`, `obj.task.objInQuestion`, `obj.order`, `obj.pth`, `obj.vehicle`, `obj.gun`, `obj.gun.shots`, `obj.gun.interval`, `obj.nextGunAttack`, `obj.target.seenFlag`, `object_action_idle`, `object_action_melee`, `object_action_runto`, `object_action_shootat`, `time`, `drive_to_obj`, `run_on_path`
- **Reusable:** no
- **Procedural:** no

## Part 2 of 6

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the `run_to_vehicle` and `run_to_house` functions.
- **Uses:** nothing
- **Reusable:** no

### run_to_vehicle
- **Does:** Handles running to a vehicle by first attempting path-based movement if the object has a path, then either driving to the target object or, if the target has no driver, moving to the vehicle and transitioning the object into vehicle-driving mode with the target as its driver.
- **Uses:** `run_on_path`, `drive_to_obj`, `objdistance`, `setObjectInfo`, `getObjectInfo`, `handle_car_sounds`, `setSound_emitterInfo`, `time`, `object_action_runto`, `object_action_drive`, `drive_vehicle`, `gReachedTolerance` (via shared engine globals), engine property constants `IG3D_ANIMATION`, `IG3D_VEHICLE`, `IG3D_VELOCITY`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`
- **Reusable:** no

### run_to_house
- **Does:** Handles running to a house by first attempting path-based movement if the object has a path, then either driving to the target object or, if the target has no driver, moving to the vehicle and transitioning the object into vehicle-driving mode with the target as its driver.
- **Uses:** `run_on_path`, `drive_to_obj`, `objdistance`, `setObjectInfo`, `getObjectInfo`, `math.random`, `gReachedTolerance`, `object_action_runto`, `object_action_idle`, `gunned_civilian_behaviour`, engine property constants `IG3D_IGNORE_COLL`, `IG3D_POSITION`, `IG3D_ANIMATION`, `IG3D_VEHICLE`, `IG3D_VELOCITY`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`
- **Reusable:** no

## Part 3 of 6

### Top level
- **Does:** No top-level code outside the four function definitions; the file contains only the function implementations listed.
- **Uses:** nothing
- **Reusable:** no

### eat_dead_human
- **Does:** Sets the task action for an object to either eat or goto based on whether the object is already at the target, then assigns the target to the object's question object.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`, `object_action_goto`, `object_action_eat`
- **Reusable:** no

### run_to_spot
- **Does:** Checks whether the object has reached its target spot, clears the order if it has, then sets the object's task to run to the spot with the target coordinates, or routes to the vehicle if one exists.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `vecLength`, `gReachedTolerance`, `obj.order`, `obj.vehicle`, `obj.task.id`, `obj.task.x`, `obj.task.y`, `obj.task.z`, `object_action_runtospot`
- **Reusable:** no

### walk_to_spot
- **Does:** Mirrors run_to_spot but sets the object's task to walk to the spot with the target coordinates, or routes to the vehicle if one exists.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `vecLength`, `gReachedTolerance`, `obj.order`, `obj.vehicle`, `obj.task.id`, `obj.task.x`, `obj.task.y`, `obj.task.z`, `object_action_walktospot`
- **Reusable:** no

### drive_to_obj
- **Does:** Computes the normalized direction between the target object and the current object, then calls drive_to_spot with the target position offset by the given distance along that direction.
- **Uses:** `getObjectInfo(target.cObj, IG3D_POSITION)`, `getObjectInfo(obj.cObj, IG3D_POSITION)`, `normalized`, `drive_to_spot`
- **Reusable:** no

### drive_to_spot
- **Does:** Configures the object to drive, sets the target crossing coordinates and straight turn direction, sets the drive task with the vehicle as the question object, and positions the object's driver bone and rotation to match the vehicle.
- **Uses:** `obj.behaviour`, `obj.targetCrossing`, `obj.nextTurn`, `obj.task.id`, `obj.task.objInQuestion`, `get(ig3d_bone, obj.vehicle.cObj, "Driver")`, `setObjectInfo(obj.cObj, IG3D_POSITION, getBoneInfo(bn, IG3D_POSITION))`, `setObjectInfo(obj.cObj, IG3D_ROTATION, getObjectInfo(obj.vehicle.cObj, IG3D_ROTATION))`
- **Reusable:** no

## Part 4 of 6

### Top level
- **Does:** No setup, globals, or widget definitions appear in this file.
- **Uses:** nothing
- **Reusable:** no

### walk_on_path
- **Does:** Updates the task and order target positions for an object moving along a path, switching the task to idle or walktospot (or driving to a spot for vehicles), and advancing the path when the current position is within tolerance.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `gReachedTolerance`, `object_action_idle`, `object_action_walktospot`, `vecLength`, `drive_to_spot(obj, x, y, z)`, and the object fields `obj.cObj`, `obj.vehicle`, `obj.task`, `obj.pth`, `obj.order`
- **Reusable:** no
- **Procedural:** no

## Part 5 of 6

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### run_on_path
- **Does:** Advances an object along its path by checking the distance to the next path segment against the reached tolerance, then updates the object's task and order targets accordingly.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `gReachedTolerance`, `vecLength`, `object_action_idle`, `object_action_runtospot`, `drive_to_spot(obj, x, y, z)`, and the fields `obj.cObj`, `obj.vehicle`, `obj.pth`, `obj.task`, `obj.order`
- **Reusable:** no

### attackHouseForSomeTime
- **Does:** Sets the object's task to melee action with the target as the question object, and clears the order if the elapsed time exceeds the order's continue time or the target's health is already negative.
- **Uses:** `time()`, `object_action_melee`, and the fields `obj.task`, `obj.order`, `target.health`
- **Reusable:** no

## Part 6 of 6

### Top level

### pickup_gun
- **Does:** Handles gun pickup for an object: runs the path if one exists, otherwise drives to the target or runs to it, then if the object is close and meets pickup conditions, marks the target as a gun, sets the object's behaviour and sound emitter, and resets the object's task and order.
- **Uses:** `run_on_path`, `drive_to_obj`, `objdistance`, `gReachedTolerance`, `gObjects`, `object_action_runto`, `object_action_idle`, `gunned_civilian_behaviour`, `assign_free_sound_emitter`, `setSound_emitterInfo`, `setObjectInfo`, `getObjectInfo`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `target.sample`, `target.recharge`, `obj.task`, `obj.order`, `obj.vehicle`, `obj.team`, `obj.gun`
- **Reusable:** no
- **Procedural:** no
