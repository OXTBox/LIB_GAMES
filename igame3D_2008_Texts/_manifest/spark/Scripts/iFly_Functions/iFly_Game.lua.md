<!-- Spark first-look of Data/Scripts/iFly_Functions/iFly_Game.lua (model spark-x2.6-4b, 2026-11-12 17:53). DRAFT for Claude to review. -->

## iFly_Game.lua
- **Kind:** level-script
- **Purpose:** This file is the main script for the iFly game session. It starts the game by reading the player name, loading the iFly title level, configuring scene and sound settings, and runs the game loop with ship control, enemy and friendly AI, and particle/sound emitter updates.
- **Depends on:** `Data/Levels/iFly/iFly_Title` level, `Data/Sounds/exp.ogg` sound, `Data/` folder path conventions, engine calls such as `input`, `setSceneInfo`, `loadLevel`, `getObjectInfo`, `setObjectInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `setText_boxInfo`, `getBoneInfo`, `getSceneInfo`, and globals set elsewhere such as `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gShadows`, `engineSnd`, `gunSnd`, `camera`, `water`, `mother`, `ship`, `splash`, `shrabnel`, `bigFire`, `gTextboxes`, `gMouseSpeed`, `gMinThrottle`, `gMaxThrottle`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `firstFrame`, `options`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `gTimedLevelLoad`, `gTimedLevelLoadTime

---

# Part notes

## Part 1 of 6

### airforce
- **Does:** Starts the iFly game session by reading the input name, switching to the iFly title level, configuring scene and sound settings, handling enemy and friendly AI, and running the first-frame initialization and ship-related logic.
- **Uses:** Engine calls `input`, `setSceneInfo`, `updateFromAllVisualObjects`, `updateFromVisualCamera`, `setSound_emitterInfo`, `handle_enemies`, `handle_friends`, `getObjectInfo`, `setObjectInfo`, `setParticle_emitterInfo`, `time`; globals `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gStartTime`, `firstFrame`, `options`, `gShadows`, `engineSnd`, `gunSnd`, `camera`, `water`, `mother`, `ship`, `splash`, `shrabnel`, `bigFire`; paths `Data/Levels/iFly/iFly_Title`; engine constants `IG3D_MOUSE_VIEW`, `IG3D_FULLSCREEN`, `IG3D_RECEIVE_SHADOW`, `IG3D_CAST_SHADOW`, `IG3D_VELOCITY`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_FORCE`, `IG3D_LOOP`, `IG3D_START`, `IG3D_PITCH`, `IG3D_BONE_TRAVERSAL`; variables `char`, `code`, `name`, `x`, `y`, `z`.
- **Reusable:** no

### Top level
- **Does:** Contains the file header comment and the game section marker, with no additional top-level code outside the `airforce` function.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 6

### Top level
- **Does:** Contains setup calls for sound emitters, a timed level timer, and player input, throttle, atom bomb and strafing/rolling control logic.
- **Uses:** `setSound_emitterInfo`, `setParticle_emitterInfo`, `setMaterialInfo`, `get`, `click`, `key`, `time`, globals `engineSnd`, `gunSnd`, `gun`, `m`, `ship`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `atomtime`, `muzzlestart`, `muzzle`, `gMaxThrottle`, `controls`, `passed`, `Data/` path `Data/Sounds/exp.ogg`, `Data/Levels/iFly`.
- **Reusable:** no
- **Procedural:** no

## Part 3 of 6

### Top level
- **Does:** Contains the top-level setup and runtime logic for the iFly game script, including ship control state updates, camera and board gun positioning, afterburner configuration, and FPS/time text box updates.
- **Uses:** Engine calls such as `get`, `setParticle_emitterInfo`, `setObjectInfo`, `getBoneInfo`, `getSceneInfo`, `setSound_emitterInfo`, `setText_boxInfo`; globals including `ship`, `camera`, `b`, `m`, `gMinThrottle`, `gMaxThrottle`, `gStartTime`, `gMouseSpeed`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `gTextboxes`, `engineSnd`, `controls`, `time`, `math`, `formattedTime`; and data paths referenced via `Data/` folder conventions.
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### Top level
- **Does:** Contains the closing of a function and a top-level block that sets `game_func` to `nil`, loads the timed level via `loadLevel(gTimedLevel)`, and returns.
- **Uses:** `game_func`, `loadLevel`, `gTimedLevel`
- **Reusable:** no
- **Procedural:** no

## Part 5 of 6

### Top level
- **Does:** No top-level code outside the three function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### particlesAgainstMesh
- **Does:** Sets particle emitter info for splash and fire emitters based on the y-coordinate of the collision point, and optionally updates the atomic1 particle emitter position and start when the system is "abomb".
- **Uses:** `setParticle_emitterInfo`, `time`, globals `lilsplash`, `fire`, `atomic1`, constants `IG3D_POSITION`, `IG3D_START`, `IG3D_VELOCITY`, parameter `psys`
- **Reusable:** no

### objectsAgainstMesh
- **Does:** When the object is active, resets fire emitter position, velocity and start, sets hitSnd sound emitter position and start, decrements the object life by 100, and leaves a commented-out watercoll flag assignment when the y-coordinate is below -0.1.
- **Uses:** `setParticle_emitterInfo`, `setSound_emitterInfo`, globals `fire`, `hitSnd`, constants `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_START`, parameter `obj`, `bone`, `x`, `y`, `z`
- **Reusable:** no

### objectsAgainstParticles
- **Does:** When the object is active, resets fire emitter position and velocity (using the object's velocity), sets fire emitter start and hitSnd sound emitter position and start. If the object is mother, it handles turret lifecycles by reading bone names, decrementing turret lifecycles, disabling dead turret bones and resetting mother mass when a turret's life reaches zero; otherwise it decrements the object life by 1.
- **Uses:** `setParticle_emitterInfo`, `setSound_emitterInfo`, `get`, `getBoneInfo`, `string.sub`, `string.len`, `getObjectInfo`, `setBoneInfo`, `setObjectInfo`, globals `fire`, `hitSnd`, `mother`, `bigFire`, `ig3d_bone`, constants `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_START`, `IG3D_NAME`, `IG3D_ENABLED`, `IG3D_COLL`, `IG3D_MASS`, parameter `obj`, `bone`, `psys`, `x`, `y`, `z`
- **Reusable:** no

## Part 6 of 6

### Top level

### objectsAgainstObjects
- **Does:** When either object or bone is `mother`, or when either object is `water`, it configures the `fire` particle emitter and `hitSnd` sound emitter at the given position, then decrements the life of both objects by 5 if they have a life value.
- **Uses:** `setParticle_emitterInfo`, `setSound_emitterInfo`, `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_START`, `fire`, `hitSnd`, `obj1.life`, `obj2.life`, `mother`, `water`
- **Reusable:** no
- **Procedural:** no
