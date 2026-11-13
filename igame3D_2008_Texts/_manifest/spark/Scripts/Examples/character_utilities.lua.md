<!-- Spark first-look of Data/Scripts/Examples/character_utilities.lua (model spark-x2.6-4b, 2026-11-12 15:06). DRAFT for Claude to review. -->

## character_utilities.lua
- **Kind:** library
- **Purpose:** This file provides reusable Lua helper functions for manipulating character objects and their bones, specifically for attaching a gun to a target object and configuring a character's right-hand gun focus pose. It contains no top-level executable code, only the two defined helper functions.
- **Depends on:** Engine functions `get`, `getBoneInfo`, `getObjectInfo`, `setObjectInfo`, `setBoneInfo`, `setObjectInfo` with `ig3d_bone` and `ig3d_object` object kinds; constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_OMEGA`, `IG3D_ROTATION_MATRIX`; math helpers `normalized`, `cross`, `dot`; global `gObjects`; `Data/` folder path structure for engine object loading.
- **Provides:** `attachGunToObject` and `onehandgunfocus` functions, which attach a gun to a target object and set a character's right-hand gun focus pose respectively.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or loaded).
- **Procedural:** none (the functions compute rotation matrices, plane equations, and pose values from parameters; they do not generate or load asset files).
- **Glossary:**
  - `ig3d_bone` - Engine object kind used to reference character bones.
  - `ig3d_object` - Engine object kind used to reference character objects.
  - `IG3D_POSITION` - Engine constant naming the position property of an object or bone.
  - `IG3D_ROTATION` - Engine constant naming the rotation property of a bone.
  - `IG3D_OMEGA` - Engine constant naming the angular velocity property of an object.
  - `IG3D_ROTATION_MATRIX` - Engine constant naming the rotation matrix property of an object.
  - `bone_name` - A name identifying a specific bone on a character object.
  - `target` / `source` - Parameters naming the target object and source object used for gun attachment.
- **Keep / port / drop:** keep - reusable pure rotation, pose, and vector math helpers for character weapon manipulation.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** No top-level code outside the two defined functions; the file begins directly with the function definitions.
- **Uses:** nothing
- **Reusable:** no

### attachGunToObject
- **Does:** Attaches a gun to a target object by computing rotation matrices for the target's arm and shoulder bones, adjusting the hand bone position, and setting the source object's rotation matrix.
- **Uses:** Engine calls `get(ig3d_bone, target, bone_name)`, `getBoneInfo(bone, IG3D_POSITION)`, `getObjectInfo(target, IG3D_ROTATION_MATRIX)`, `setObjectInfo(source, IG3D_ROTATION_MATRIX, ...)`; constants `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`; math helpers `normalized`, `cross`; globals `gObjects` referenced via the `target`/`source` parameters.
- **Reusable:** yes - pure rotation and vector math for object attachment.

### onehandgunfocus
- **Does:** Sets the focus pose for a character's right-hand gun by configuring arm and chest bone rotations, computing a plane equation to orient the gun, and setting the object's angular velocity.
- **Uses:** Engine calls `get(ig3d_bone, obj.cObj, bone_name)`, `getBoneInfo(bone, IG3D_POSITION)`, `setBoneInfo(bone, IG3D_ROTATION, ...)`, `setObjectInfo(obj.cObj, IG3D_OMEGA, ...)`; constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_OMEGA`; math helpers `normalized`, `cross`, `dot`, `math.acos`; globals referenced via the `obj` parameter.
- **Reusable:** yes - pure pose and orientation math for character weapon focus.
