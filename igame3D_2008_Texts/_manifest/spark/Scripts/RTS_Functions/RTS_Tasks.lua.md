<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Tasks.lua (model spark-x2.6-4b, 2026-11-12 16:41). DRAFT for Claude to review. -->

## RTS_Tasks.lua
- **Kind:** library
- **Purpose:** This file defines shared rotation and turn-control functions for a 3D game engine, letting objects be rotated toward or away from other objects or spots. It contains no top-level executable code, only function definitions.
- **Depends on:** Engine globals and constants (`IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`, `normalized`, `dot`, `math.min`, `math.max`, `getObjectInfo`, `setObjectInfo`, `get`, `getBoneInfo`, `ig3d_bone`), plus the `Data/` folder structure for level loading.
- **Provides:** `turn_away_from`, `turn_towards`, `turn_towards_obj_bone`, `turn_towards_spot` — functions that compute and set object rotation/omega values to rotate objects toward or away from targets.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or loaded).
- **Procedural:** none
- **Glossary:**
  - `IG3D_POSITION -` Engine property constant naming the position property of an object.
  - `IG3D_ROTATION_MATRIX -` Engine property constant naming the rotation matrix property of an object.
  - `IG3D_OMEGA -` Engine property constant naming the omega property of an object, used to set rotation direction/amount.
  - `getObjectInfo -` Engine call that reads object property values by object and property constant.
  - `setObjectInfo -` Engine call that sets object property values by object and property constant.
  - `getBoneInfo -` Engine call that reads property values of a bone object.
  - `ig3d_bone -` Engine object kind used to reference bone objects.
  - `turn -` Game action of rotating an object toward or away from a target.
- **Keep / port / drop:** keep - shared rotation math logic used by multiple turn functions, reusable in new engines.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No top-level code outside the three function definitions.
- **Uses:** nothing
- **Reusable:** no

### turn_away_from
- **Does:** Rotates obj1 away from obj2 by computing the angle between obj1's rotation matrix and the direction to obj2, clamping the angle to avoid invalid acos inputs, and setting obj1's omega.
- **Uses:** `getObjectInfo(obj1.cObj, IG3D_POSITION)`, `getObjectInfo(obj2.cObj, IG3D_POSITION)`, `getObjectInfo(obj1.cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(obj1.cObj, IG3D_OMEGA, 0, math.acos(d)*mult, 0)`, `normalized`, `dot`, `math.min`, `math.max`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`
- **Reusable:** yes - shared rotation math logic used by the other turn functions

### turn_towards
- **Does:** Rotates obj1 towards obj2 by computing the angle between obj1's rotation matrix and the direction to obj2, clamping the angle to avoid invalid acos inputs, and setting obj1's omega.
- **Uses:** `getObjectInfo(obj1.cObj, IG3D_POSITION)`, `getObjectInfo(obj2.cObj, IG3D_POSITION)`, `getObjectInfo(obj1.cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(obj1.cObj, IG3D_OMEGA, 0, math.acos(d)*mult, 0)`, `normalized`, `dot`, `math.min`, `math.max`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`
- **Reusable:** yes - shared rotation math logic used by the other turn functions

### turn_towards_obj_bone
- **Does:** Rotates obj1 towards the position of obj2's bone by computing the angle between obj1's rotation matrix and the direction to the bone's position, clamping the angle to avoid invalid acos inputs, and setting obj1's omega.
- **Uses:** `getObjectInfo(obj1.cObj, IG3D_POSITION)`, `getBoneInfo(get(ig3d_bone, obj2.cObj, bn), IG3D_POSITION)`, `getObjectInfo(obj1.cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(obj1.cObj, IG3D_OMEGA, 0, math.acos(d)*mult, 0)`, `normalized`, `dot`, `math.min`, `math.max`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`, `get(ig3d_bone, obj2.cObj, bn)`
- **Reusable:** yes - shared rotation math logic used by the other turn functions

## Part 2 of 2

### Top level
- **Does:** nothing
- **Uses:** nothing
- **Reusable:** no

### turn_towards_spot
- **Does:** Rotates an alive object so its forward direction points toward a given spot by computing the normalized direction and the rotation matrix, then setting the object's omega.
- **Uses:** `getObjectInfo(obj1.cObj, IG3D_POSITION)`, `getObjectInfo(obj1.cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(obj1.cObj, IG3D_OMEGA, 0, math.acos(d)*mult, 0)`, `normalized`, `dot`, `math.min`, `math.max`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`
- **Reusable:** no
- **Procedural:** no
