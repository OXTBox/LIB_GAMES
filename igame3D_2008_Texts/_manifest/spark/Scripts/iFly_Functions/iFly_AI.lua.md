<!-- Spark first-look of Data/Scripts/iFly_Functions/iFly_AI.lua (model spark-x2.6-4b, 2026-11-12 17:50). DRAFT for Claude to review. -->

## iFly_AI.lua
- **Kind:** library
- **Purpose:** This file contains the iFly_AI game logic, implementing enemy and friend initialization, movement, shooting, power-up pickup, camera positioning, and cloud particle emitter generation for the iGame3D engine.
- **Depends on:** `Data/` folder paths (e.g., `Data/Sounds/exp.ogg`), engine globals such as `gEnemies`, `gFriends`, `gPowerUpsStart`, `gPowerUpsEnd`, `gPickupDistance`, `gObjects`, and engine calls like `init_plane`, `get`, `setObjectInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `getPathInfo`, `getBoneInfo`, `getCameraInfo`, `setCameraInfo`, `setLightInfo`, `setText_boxInfo`, `getSceneInfo`, `getObjectInfo`, `setObjectInfo`, `getObjectInfo`, `getPathInfo`, `getBoneInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `setObjectInfo`, `

---

# Part notes

## Part 1 of 8

### Top level
- **Does:** No top-level code outside the function definitions is present in this part of the file.
- **Uses:** nothing
- **Reusable:** no

### init_enemies
- **Does:** Initializes each enemy object by setting its core state, path references, emitter and sound settings, then configures its particle emitters and collision behavior.
- **Uses:** Engine calls `init_plane`, `get`, `getPathInfo`, `setParticle_emitterInfo`, `setObjectInfo`, `distance_object_to_object`; globals `gEnemies`, `gNumEnemies`, `gEnemyAfterburners`, `gEnemyParticleEmitters1`, `gEnemyParticleEmitters2`, `gEnemySndEmitters`, `gEnemyTextboxes`, `gProtectionDistance`, `gNumDefendPaths`, `gNumAttackPaths`, `math.random`; object references `ship`, `mother`.
- **Reusable:** no

### enemies_in_range
- **Does:** Checks whether the given object is within the protection distance of any enemy in the enemy list.
- **Uses:** Engine call `distance_object_to_object`; globals `gEnemies`, `gNumEnemies`, `gProtectionDistance`.
- **Reusable:** yes

### friends_in_range
- **Does:** Checks whether the given object is within the protection distance of the ship or any friend in the friend list.
- **Uses:** Engine call `distance_object_to_object`; globals `gFriends`, `gNumFriends`, `gProtectionDistance`.
- **Reusable:** yes

### init_friends
- **Does:** Initializes each friend object by setting its core state, position offset, emitter and sound settings, then configures its particle emitter collision behavior.
- **Uses:** Engine calls `init_plane`, `setObjectInfo`; globals `gFriends`, `gNumFriends`, `gProtectionDistance`, `math.random`; object references `ship`.
- **Reusable:** no

## Part 2 of 8

### Top level
- **Does:** No top-level code outside the `handle_friends` function; the file contains only the function definition.
- **Uses:** nothing
- **Reusable:** no

### handle_friends
- **Does:** Iterates over active friend objects, handles their death by stopping sound/particle emitters and resetting object state, and otherwise updates plane position, physics, and shooting behavior for active friends.
- **Uses:** `gFriends`, `gNumFriends`, `setSound_emitterInfo`, `setParticle_emitterInfo`, `getObjectInfo`, `setObjectInfo`, `enemies_in_range`, `plane_control2`, `apply_plane_physicsnew`, `normalized`, `cross`, `math.max`, engine constants `IG3D_STOP`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_START`, `IG3D_BONE_TRAVERSAL`, `IG3D_ROTATION`, `IG3D_VELOCITY`, `IG3D_FORCE`, `IG3D_TORQUE`, `IG3D_COLL`, `IG3D_ROTATION_MATRIX`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 8

### Top level
- **Does:** No top-level code outside `handle_enemies`.
- **Uses:** nothing
- **Reusable:** no

### handle_enemies
- **Does:** Sets mothership and enemy emitter/textbox info, handles timed level completion, updates enemy targets within range, and marks enemies dead when their life reaches zero.
- **Uses:** `setObjectInfo`, `get`, `setParticle_emitterInfo`, `getBoneInfo`, `getObjectInfo`, `getSceneInfo`, `setText_boxInfo`, `gTimedLevelLoad`, `gNumDeadEnemies`, `gNumEnemies`, `gTimedLevel`, `gTimedLevelLoadTime`, `time`, `gEnemies`, `gFriends`, `mother`, `motherengine`, `ship`, `gNumFriends`, `IG3D_OMEGA`, `IG3D_VELOCITY`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_WINDOW_COORDS`, `IG3D_STOP`, `distance_object_to_object`, `friends_in_range`, `setSound_emitterInfo`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 8

### Top level
- **Does:** Contains the top-level code for the iFly_AI script, which sets up enemy particle and sound emitter information, configures enemy object properties, and updates enemy movement and defense logic.
- **Uses:** Engine calls `setSound_emitterInfo`, `setParticle_emitterInfo`, `setObjectInfo`, `get`, `getObjectInfo`, `getPathInfo`, `getBoneInfo`, `distance_object_to_object`, `getObjectInfo`; globals `gEnemies`, `splash`, `fshrabnel`, `bigFire`, `smoke`, `ig3d_bone`, `gProtectionDistance`, `gReachDistance`, `math`; file path `Data/Sounds/exp.ogg`.
- **Reusable:** no
- **Procedural:** no

## Part 5 of 8

### Top level
- **Does:** Contains only top-level code for the iFly_AI script; there are no functions defined at the top level.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 6 of 8

### Top level
- **Does:** Contains only the closing end of the preceding section; no top-level code or functions are present.
- **Uses:** nothing
- **Reusable:** no

## Part 7 of 8

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code appears in this file.
- **Uses:** nothing
- **Reusable:** no

### handle_powerups
- **Does:** Iterates over the power-up range, and when a power-up is within the pickup distance of the ship, increases the ship's strafing value and moves the power-up object to a fixed position.
- **Uses:** `gPowerUpsStart`, `gPowerUpsEnd`, `gPickupDistance`, `ship`, `gObjects`, `distance_object_to_object`, `setObjectInfo`, `IG3D_POSITION`
- **Reusable:** no

### position_camera
- **Does:** Reads the ship's rotation matrix and velocity, computes a camera position offset based on the ship's position and velocity, applies longitudinal and lateral movement adjustments, then sets the camera rotation and position, and updates the second light's position.
- **Uses:** `ship`, `getObjectInfo`, `getCameraInfo`, `setCameraInfo`, `setLightInfo`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_VELOCITY`, `IG3D_ROTATION`, `vecLength`, `normalized`, `dot`
- **Reusable:** no

### formattedTime
- **Does:** Converts a numeric time value into a `m:ss` formatted string by splitting it into minutes and seconds, padding seconds with a leading zero when needed.
- **Uses:** `math.floor`
- **Reusable:** yes
- **Procedural:** no

## Part 8 of 8

### make_cloud
- **Does:** Generates particle emitters for a cloud by reading path data, then sets each emitter's position, size, and start info with scaled offsets.
- **Uses:** `getPathInfo`, `setParticle_emitterInfo`, `IG3D_COUNT`, `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_START`, `n`, `px`, `py`, `pz`, `path`, `emitter`, `x`, `y`, `z`, `xsize`, `ysize`, `zsize`
- **Reusable:** no
- **Procedural:** yes
