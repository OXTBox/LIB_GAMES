<!-- Spark first-look of Data/Scripts/iFly_Functions/iFly_plane.lua (model spark-x2.6-4b, 2026-11-12 17:57). DRAFT for Claude to review. -->

## iFly_plane.lua
- **Kind:** library
- **Purpose:** This file provides reusable plane-related functions for the iGame3D engine, including initialization of plane orientation and control state, computation of plane rotations and throttle, and application of plane physics to plane objects.
- **Depends on:** Engine property access calls (`getObjectInfo`, `setObjectInfo`), engine functions (`normalized`, `dot`, `distance_object_to_point`, `vecLength`, `passed`), globals set elsewhere (`gEnemyThrottle`, `gMinThrottle`, `gMaxThrottle`, `FORCE_EQUALIZER_COEFFICIENT`, `TORQUE_EQUALIZER_COEFFICIENT`, `MIN_TORQUE_MAGNITUDE`, `MAX_TORQUE_MAGNITUDE`, `TORQUE_COEFFICIENT`, `MIN_TORQUE_COMPONENT`, `MAX_TORQUE_COMPONENT`), and the `Data/` folder structure for engine code loading.
- **Provides:** `init_plane`, `plane_control`, `plane_control2`, `apply_plane_physicsnew`
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named)
- **Procedural:** none
- **Glossary:**
  - `IG3D_ROTATION_MATRIX - Engine property constant naming the rotation matrix of an object being read or set.`
  - `IG3D_VELOCITY - Engine property constant naming the velocity of an object being read or set.`
  - `IG3D_FORCE - Engine property constant naming the force of an object being set.`
  - `IG3D_TORQUE - Engine property constant naming the torque of an object being set.`
  - `throttle - The control input value controlling plane movement speed.`
  - `rotation matrix - A matrix used to compute and apply yaw, pitch, and roll to an object.`
  - `thrust - The input value used to drive plane physics calculations.`
- **Keep / port / drop:** keep - reusable plane control and physics logic for similar engines.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines global constants for equalizer and torque coefficients, minimum/maximum torque values, camera tightness, and torque coefficient used by the plane functions and related scripts.
- **Uses:** Nothing (pure constants).

### init_plane
- **Does:** Initializes a plane object's orientation and control state to default values, using the enemy throttle value for the throttle property.
- **Uses:** Engine property assignments on the passed `obj` argument; global `gEnemyThrottle`.
- **Reusable:** yes (pure object state initialization).

### plane_control
- **Does:** Computes and applies yaw, pitch, and roll to an enemy plane object based on the rotation matrix and target point, then sets throttle based on distance to the target point when the object has defend enabled.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)` and `getObjectInfo(obj.cObj, IG3D_MASS)`; engine functions `normalized`, `dot`, `distance_object_to_point`; globals `gEnemyThrottle`, `gMinThrottle`, `gMaxThrottle`; object properties `obj.x`, `obj.y`, `obj.z`, `obj.cObj`, `obj.defend`, `obj.throttle`, `obj.yaw`, `obj.pitch`, `obj.roll`.
- **Reusable:** no (game-specific plane control logic).

### plane_control2
- **Does:** Computes and applies yaw, pitch, and roll to a friendly plane object based on the rotation matrix and target point, then sets throttle based on distance to the target point scaled by the mothership throttle.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`; engine functions `dot`, `distance_object_to_point`; globals `gMaxThrottle`; object properties `obj.x`, `obj.y`, `obj.z`, `obj.cObj`, `obj.mothership.throttle`, `obj.throttle`, `obj.yaw`, `obj.pitch`, `obj.roll`, `obj.mothership`; global `passed()`.
- **Reusable:** no (game-specific friendly plane control logic).

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `apply_plane_physicsnew`.
- **Uses:** nothing
- **Reusable:** no

### apply_plane_physicsnew
- **Does:** Applies plane physics to an object by computing and setting rotation matrix, velocity, force and torque values based on thrust, pitch, yaw and roll inputs.
- **Uses:** Engine calls `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`, `getObjectInfo(obj.cObj, IG3D_VELOCITY)`, `setObjectInfo(obj.cObj, IG3D_FORCE, ...)`, `setObjectInfo(obj.cObj, IG3D_TORQUE, ...)`; globals `FORCE_EQUALIZER_COEFFICIENT`, `TORQUE_EQUALIZER_COEFFICIENT`, `passed()`, `vecLength`, `normalized`, and constants `MIN_TORQUE_MAGNITUDE`, `MAX_TORQUE_MAGNITUDE`, `TORQUE_COEFFICIENT`, `MIN_TORQUE_COMPONENT`, `MAX_TORQUE_COMPONENT`; no file or `Data/` paths are read or written.
- **Reusable:** yes - pure physics calculation logic that can be reused for plane physics in similar engines.
- **Procedural:** no
