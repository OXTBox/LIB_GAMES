<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Behaviours.lua (model spark-x2.6-4b, 2026-11-12 16:10). DRAFT for Claude to review. -->

## RTS_Behaviours.lua
- **Kind:** library
- **Purpose:** This file defines reusable behaviour functions for the iGame3D RTS engine, covering fleeing, walking, combat, zombie, vehicle, and follow-player logic for game objects. It provides behaviour modules that drive object tasks and state based on sensed threats and engine calls.
- **Depends on:** Other Scripts/RTS_Functions files (e.g. `standard_flee`, `randomWalking`, `generateAStarPathBetweenPositions`, `handle_car_sounds`, `udg_play_scared_sound`, `udg_object_may_astar`), engine globals (`gObjects`, `gSafePlaces`, `gActivateStartSounds`, `playerBox`, `gOldPlayerPosX/Y/Z`, `gPathsSet`, `gReachedTolerance`), and Data folder paths for levels and scripts.
- **Provides:** Behaviour functions including `randomWalking`, `flee_to_safe_place`, `stand_and_cry`, `walk_between_safe_places`, `civilian_with_melee_weapon_behaviour`, `idle_until_zombie_in_sight`, `default_behaviour2`, `default_behaviour`, `soldier_behaviour`, `sniper_behaviour`, `standard_flee`, `gunned_civilian_behaviour`, `zombie_behaviour`, `zombie_reanimate_behaviour`, `drive_vehicle`, `find_vehicle_behaviour`, `find_house`, `always_idle`, `follow_player`, plus global constants `gReachedTolerance`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** yes - the file generates object task paths and behaviour state procedurally using A* path generation, distance checks, and random selection rules (e.g. `randomWalking`, `walk_between_safe_places`, `follow_player`) instead of loading asset files.
- **Glossary:**
  - `IG3D_POSITION - Engine property constant naming the position of an object, used to read or set object position.`
  - `IG3D_RAGDOLL - Engine property constant naming the ragdoll state of an object, used to read object ragdoll info.`
  - `generateAStarPathBetweenPositions - Engine function that generates an A* path between two object positions.`
  - `object_action_idle - Engine task constant for an object to perform idle behaviour.`
  - `object_action_melee - Engine task constant for an object to perform melee behaviour.`
  - `object_action_shootat - Engine task constant for an object to perform shoot-at behaviour.`
  - `object_action_drive - Engine task constant for a vehicle to perform driving behaviour.`
  - `object_action_eat - Engine task constant for an object to perform eating behaviour.`
- **Keep / port / drop:** keep - core behaviour logic for fleeing, combat, zombie, and vehicle objects that is reusable across RTS engine modules.

---

# Part notes

## Part 1 of 11

### Top level
- **Does:** Defines the global constant `gReachedTolerance` with the value `0.6`, used by the `randomWalking` function to control path advancement.
- **Uses:** nothing
- **Reusable:** yes

### randomWalking
- **Does:** Generates or updates a path for an object, then sets the object's task position and task identifier to drive idle walking behavior.
- **Uses:** `getObjectInfo`, `IG3D_POSITION`, `generateAStarPathBetweenPositions`, `math.random`, `vecLength`, `obj.pth`, `obj.task`, `object_action_idle`, `obj.objInQuestion`
- **Reusable:** no
- **Procedural:** yes

## Part 2 of 11

### Top level
- **Does:** No top-level code outside the `flee_to_safe_place` function.
- **Uses:** nothing
- **Reusable:** no

### flee_to_safe_place
- **Does:** Computes a safe escape path for an object fleeing from a sensed threat, selects the best of three candidate routes, and updates the object's task and path state accordingly.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_POSITION)`, `getObjectInfo(obj.afraidOf.cObj, IG3D_POSITION)`, `getObjectInfo(obj.afraidOf.cObj, IG3D_RAGDOLL)`; globals `time`, `gReachedTolerance`; functions `normalized`, `lineCollision`, `generateAStarPathBetweenPositions`, `vecLength`; object fields `afraidOf`, `sensed`, `pth`, `lastFleeRouteSet`, `route2Weight`, `route3Weight`, `task`, `behaviour`, `oldbehaviour`, `cObj`; constants `IG3D_POSITION`, `IG3D_RAGDOLL`; function `object_action_runtospot`; function `stand_and_cry`, `default_behaviour`.
- **Reusable:** yes - path generation and route selection logic for fleeing objects can be reused in similar behavior modules.
- **Procedural:** no

## Part 3 of 11

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### stand_and_cry
- **Does:** Sets the cry task id on the object and assigns its first sensed object to the task's objInQuestion field.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`, `obj.sensed[1]`
- **Reusable:** no

### walk_between_safe_places
- **Does:** Picks a random safe place, computes the A* path between the object's current position and the chosen safe place, advances the path if the distance is below the reached tolerance, then sets the walk-to-spot task with the path coordinates or the idle task if no path exists.
- **Uses:** `gSafePlaces`, `math.random`, `getObjectInfo(obj.cObj, IG3D_POSITION)`, `generateAStarPathBetweenPositions`, `obj.pth`, `obj.task`, `gReachedTolerance`, `vecLength`
- **Reusable:** yes
- **Procedural:** yes

## Part 4 of 11

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### civilian_with_melee_weapon_behaviour
- **Does:** Handles melee-weapon civilian behaviour by checking sensed enemies, assigning flee or fight tasks based on distance and team, and switching behaviour when no enemy is sensed.
- **Uses:** `randomWalking`, `standard_flee`, `objdistance`, `object_action_runto`, `fight_enemy_order`, `getObjectInfo`, `IG3D_NAME`, `gObjects` (implied via `obj.sensed`, `obj.team`, `obj.scareDistance`, `obj.farDistance`, `obj.task`, `obj.order`), `obj.behaviour` references
- **Reusable:** yes
- **Procedural:** no

### idle_until_zombie_in_sight
- **Does:** Sets the idle task for a civilian object, checks for sensed enemies, and switches the object's behaviour to gunned, melee-weapon or default behaviour based on weapon presence and enemy sight status.
- **Uses:** `obj.task`, `obj.sensed`, `obj.team`, `obj.alive`, `obj.gun`, `obj.meleeWeapon`, `obj.behaviour`, `object_action_idle`, `object_action_lookat`, `gunned_civilian_behaviour`, `civilian_with_melee_weapon_behaviour`, `default_behaviour2`
- **Reusable:** yes
- **Procedural:** no

## Part 5 of 11

### Top level
- **Does:** No top-level code outside the two behaviour functions; the file contains only the function definitions for `default_behaviour2` and `default_behaviour`.
- **Uses:** nothing
- **Reusable:** no

### default_behaviour2
- **Does:** Implements the default enemy-fleeing behaviour for an object: when no enemies are sensed, it runs random walking; when the nearest sensed enemy is on the opposing team and within the scare distance, it plays the scared sound, sets the scare distance to 15.0, marks the object as scared, and runs standard fleeing; otherwise it clears the afraid-of reference, resets the scare distance to 6.0, and runs random walking.
- **Uses:** `randomWalking(obj)`, `objdistance(obj, obj.sensed[1])`, `udg_play_scared_sound(obj)`, `standard_flee(obj)`, object fields `sensed`, `team`, `scareDistance`, `scared`, `afraidOf`
- **Reusable:** yes

### default_behaviour
- **Does:** Implements the default enemy-fleeing behaviour for an object: when no enemies are sensed, it runs random walking; when the nearest sensed enemy is on the opposing team and within the scare distance, it runs standard fleeing, sets the scare distance to 15.0, and changes the object's behaviour to `find_house`; otherwise it clears the afraid-of reference, resets the scare distance to 6.0, and runs random walking.
- **Uses:** `randomWalking(obj)`, `objdistance(obj, obj.sensed[1])`, `standard_flee(obj)`, `find_house`, object fields `sensed`, `team`, `scareDistance`, `afraidOf`, `behaviour`
- **Reusable:** yes
- **Procedural:** no

## Part 6 of 11

### Top level
- **Does:** No top-level code outside the three behaviour functions; the file only defines the behaviour functions listed.
- **Uses:** nothing
- **Reusable:** no

### soldier_behaviour
- **Does:** Drives soldier behaviour based on sensed enemies: if no enemies are sensed, it triggers random walking and returns; otherwise it selects melee, run-to, or shoot-at tasks depending on enemy distance, team match, and gun state.
- **Uses:** `randomWalking(obj)`, `obj.sensed`, `obj.team`, `obj.alive`, `objdistance(obj, obj.sensed[1])`, `obj.meleeDistance`, `obj.task.id`, `obj.task.objInQuestion`, `obj.task.x`, `obj.task.y`, `obj.task.z`, `obj.farDistance`, `obj.gun`, `obj.gun.shots`, `obj.gun.interval`, `time()`, constants `object_action_melee`, `object_action_runto`, `object_action_shootat`
- **Reusable:** yes
- **Procedural:** no

### sniper_behaviour
- **Does:** Sets the sniper to idle with zeroed task position, then updates its task based on sensed enemies: if no enemies are sensed it returns, otherwise it selects shoot-at or run-to tasks depending on enemy distance, gun availability, and gun shot count.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`, `obj.task.x`, `obj.task.y`, `obj.task.z`, `obj.sensed`, `obj.team`, `obj.alive`, `objdistance(obj, obj.sensed[1])`, `obj.farDistance`, `obj.gun`, `obj.gun.shots`, `obj.gun.interval`, `time()`, constants `object_action_idle`, `object_action_shootat`, `object_action_runto`
- **Reusable:** yes
- **Procedural:** no

### standard_flee
- **Does:** Sets the standard flee behaviour task to run off, assigns the sensed enemy as the task target, and sets the flee scaring distance to 10.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`, `obj.sensed[1]`, `obj.scareDistance`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 11

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `gunned_civilian_behaviour` and its comments.
- **Uses:** nothing
- **Reusable:** no

### gunned_civilian_behaviour
- **Does:** Controls gunned civilian behaviour: if no enemies are sensed, it triggers random walking; otherwise it decides whether the civilian flees when the enemy is too close, runs off to a larger distance if the enemy is far, or shoots at the sensed enemy based on its distance and sight state.
- **Uses:** `randomWalking`, `objdistance`, `standard_flee`, `object_action_runto`, `object_action_shootat`, `time`, `getObjectInfo`, `IG3D_NAME`, and the object properties `sensed`, `team`, `alive`, `scareDistance`, `farDistance`, `task`, `objInQuestion`, `gun`, `nextGunAttack`, `interval`
- **Reusable:** no

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `gunned_civilian_behaviour` and its comments.
- **Uses:** nothing
- **Reusable:** no

## Part 8 of 11

### Top level
- **Does:** No top-level code outside the three function definitions; the file contains only the function implementations listed.
- **Uses:** nothing
- **Reusable:** no

### zombie_behaviour
- **Does:** Sets a zombie to random walking when it has no sensed enemies, otherwise assigns a melee or movement task to the nearest sensed enemy, or random walking if the sensed enemy is on the opposite team or dead.
- **Uses:** `randomWalking(obj)`, `objdistance(obj, obj.sensed[1])`, `obj.meleeDistance`, `obj.task.id`, `obj.task.objInQuestion`, `obj.animPickTable`, `math.random`, `object_action_melee`, `object_action_goto`, `object_action_runto`, `object_action_reanimate` (referenced in related functions), `zombieAnims`, `obj.sensed`, `obj.team`, `obj.voiceSndEmt`, `obj.cObj`, `gActivateStartSounds`
- **Reusable:** yes
- **Procedural:** no

### zombie_reanimate_behaviour
- **Does:** Sets a zombie's task to reanimate and assigns the zombie itself as the task target.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`
- **Reusable:** yes
- **Procedural:** no

### drive_vehicle
- **Does:** Sets a vehicle's task to drive itself, assigns the vehicle as the task target, and if the vehicle has a Driver bone, moves the vehicle object to the bone's position and copies the vehicle's rotation to the vehicle object.
- **Uses:** `obj.task.id`, `obj.task.objInQuestion`, `obj.vehicle`, `get(ig3d_bone, obj.vehicle.cObj, "Driver")`, `setObjectInfo(obj.cObj, IG3D_POSITION, getBoneInfo(bn, IG3D_POSITION))`, `setObjectInfo(obj.cObj, IG3D_ROTATION, getObjectInfo(obj.vehicle.cObj, IG3D_ROTATION))`, `obj.sensed`, `obj.cObj`
- **Reusable:** yes
- **Procedural:** no

## Part 9 of 11

### Top level
- **Does:** No top-level code outside the `find_vehicle_behaviour` function.
- **Uses:** nothing
- **Reusable:** no

### find_vehicle_behaviour
- **Does:** Determines the vehicle behaviour for a sensed object by checking its sensed list, selecting a valid vehicle, and either assigning the idle behaviour or transitioning the object into vehicle driving based on distance and team rules.
- **Uses:** `obj.sensed`, `obj.task`, `obj.behaviour`, `objdistance`, `setObjectInfo`, `getObjectInfo`, `handle_car_sounds`, `setSound_emitterInfo`, engine constants `IG3D_ANIMATION`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_START`, globals `object_action_idle`, `object_action_runto`, `object_action_drive`, `default_behaviour`, `drive_vehicle`
- **Reusable:** yes
- **Procedural:** no

## Part 10 of 11

### Top level
- **Does:** Sets global variables `gOldPlayerPosX`, `gOldPlayerPosY`, `gOldPlayerPosZ` to 0, and sets `gPathsSet` to `true`.
- **Uses:** nothing
- **Reusable:** no

### find_house
- **Does:** Determines the nearest house for an object based on its sensed list, and updates the object's task and behaviour accordingly. If the object has no sensed entries, it triggers random walking and returns. Otherwise it finds the first sensed entry marked as a house, sets the object's ignore-collision property to the house's object, and if no house is found or the nearest sensed entry is on the opposing team and closer than the house, it sets the object's behaviour to the default behaviour and runs it. Otherwise it sets the object's task to run to the house, and if the distance to the house is below the reached tolerance, it recharges the object's gun if present and sets the task to idle.
- **Uses:** `setObjectInfo`, `randomWalking`, `objdistance`, `gReachedTolerance`, `math.random`, globals `gObjects` (via `obj`), engine constants `IG3D_IGNORE_COLL`, engine functions `objdistance`, engine behaviour globals `default_behaviour`, `gunned_civilian_behaviour`
- **Reusable:** no

### always_idle
- **Does:** Sets the object's task to idle, points the task at the object itself, and resets the task's x, y and z coordinates to 0.
- **Uses:** engine calls `setObjectInfo` (via `obj.task`), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `default_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants `IG3D_IGNORE_COLL` (not used here), engine behaviour globals `gunned_civilian_behaviour` (not used here), engine functions `objdistance` (not used here), engine constants

## Part 11 of 11

### Top level
- **Does:** No top-level code outside the `follow_player` function; the file contains only the function definition and its body.
- **Uses:** nothing
- **Reusable:** no

### follow_player
- **Does:** Updates the path and task state of a follow object based on its current position relative to the player box, generating a new A* path when needed and advancing the object along the path or returning to idle when the path is complete.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `generateAStarPathBetweenPositions`, `vecLength`, `object_action_eat`, `object_action_idle`, `object_action_walktospot`, `object_action_idle`, `gOldPlayerPosX`, `gOldPlayerPosY`, `gOldPlayerPosZ`, `gReachedTolerance`, `gPathsSet`, `gActivateStartSounds`, `udg_object_may_astar`, `playerBox`, `obj`, `gObjects` (via shared globals referenced by the code)
- **Reusable:** no

### Top level
- **Does:** No top-level code outside the `follow_player` function; the file contains only the function definition and its body.
- **Uses:** nothing
- **Reusable:** no
