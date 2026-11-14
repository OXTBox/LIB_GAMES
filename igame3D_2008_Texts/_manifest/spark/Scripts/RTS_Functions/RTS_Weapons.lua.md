<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Weapons.lua (model spark-x2.6-4b, 2026-11-12 17:05). DRAFT for Claude to review. -->

## RTS_Weapons.lua
- **Kind:** library
- **Purpose:** This file contains utility functions for weapons in the iGame3D engine. It provides helpers to attach guns and two-handed weapons to carrier objects, check for friendly object collisions, find friendly objects in an area, and configure right-handed pistol and melee weapon behavior across the shared object list.
- **Depends on:** `Data/` folder paths, `fltk.fl_message`, `getBoneInfo`, `setObjectInfo`, `setBoneInfo`, `getObjectInfo`, `lineCollision`, `vecLength`, `gObjects`, and the `IG3D_...` constants (IG3D_ROTATION_MATRIX, IG3D_POSITION, IG3D_ROTATION, IG3D_COLL) defined elsewhere in the engine.
- **Provides:** `attachGunToHand`, `attachTwoHandedWeaponToHand`, `aimingAtFriendlyObject`, `friendlyObjectsInAreaOfEnemy`, `rightHandedPistols`, `handle_melee_weapons`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (the file only configures object properties and bone settings; it does not generate assets from numbers or rules).
- **Glossary:**
  - `ig3d_bone - The kind of object argument used when calling engine get/set functions to operate on a bone.`
  - `IG3D_... - Engine constants that name the property being read or set (e.g., position, rotation, collision) in object and bone calls.`
  - `gObjects - A shared global list of objects used to iterate over all objects in the game.`
  - `hand bone - A bone of a carrier object used as the attachment point for weapons.`
  - `blood - A property set to false to disable blood effects on objects.`
  - `lineCollision - A function used to check whether a line between two points collides with an object.`
- **Keep / port / drop:** keep - reusable utility functions for weapon attachment and configuration that other weapon scripts can rely on.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the file header comment describing the file as some utility functions for weapons.
- **Uses:** nothing
- **Reusable:** no

### attachGunToHand
- **Does:** Attaches a gun to the specified hand bone of a carrier object by setting the gun's rotation matrix and position, and configuring the hand bone's rotation and position.
- **Uses:** `fltk.fl_message`, `get(ig3d_bone, ...)`, `getBoneInfo`, `setObjectInfo`, `setBoneInfo`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_ROTATION`
- **Reusable:** yes
- **Procedural:** no

### attachTwoHandedWeaponToHand
- **Does:** Attaches a two-handed weapon to the specified hand bone of a carrier object by setting the weapon's rotation matrix and position, and configuring the hand bone's rotation and position.
- **Uses:** `fltk.fl_message`, `get(ig3d_bone, ...)`, `getBoneInfo`, `setObjectInfo`, `setBoneInfo`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_ROTATION`
- **Reusable:** yes
- **Procedural:** no

### aimingAtFriendlyObject
- **Does:** Checks whether a line between two points collides with a friendly object, temporarily disabling collision detection for the target object and restoring the original collision setting afterward.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `IG3D_COLL`, `lineCollision`
- **Reusable:** yes
- **Procedural:** no

### friendlyObjectsInAreaOfEnemy
- **Does:** Iterates through all shared objects to find any friendly object within a given distance of the enemy object, returning true if found.
- **Uses:** `getObjectInfo`, `vecLength`, `gObjects`
- **Reusable:** yes
- **Procedural:** no

### rightHandedPistols
- **Does:** Sets blood to false for all objects in the shared object list, then attaches any non-nil gun property to the right hand bone of each object.
- **Uses:** `gObjects`, `attachGunToHand`
- **Reusable:** yes
- **Procedural:** no

### handle_melee_weapons
- **Does:** Sets blood to false for all objects in the shared object list, then attaches any non-nil melee weapon property to the right hand bone of each object.
- **Uses:** `gObjects`, `attachTwoHandedWeaponToHand`
- **Reusable:** yes
- **Procedural:** no
