<!-- Spark first-look of Data/Scripts/Functions/physics_functions.lua (model spark-x2.6-4b, 2026-11-12 15:27). DRAFT for Claude to review. -->

## physics_functions.lua
- **Kind:** library
- **Purpose:** This file contains reusable physics helper functions for the iGame3D engine. It configures object gravity and shape, generates random impulse values for objects, and applies position, rotation, and impulse adjustments to all tracked objects.
- **Depends on:** `gObjects`, `gNumObjects` globals set elsewhere; functions `heavyball` and `ballImpulse` defined in this file; engine constants `IG3D_GRAVITY_MULTIPLIER`, `IG3D_SHAPE`, `IG3D_IMPULSE`, `IG3D_POSITION`, `IG3D_ROTATION`; `ig3d_sphere` object constructor.
- **Provides:** `heavyball`, `randImpulse`, `ballImpulse`, `snaptoY`
- **Assets it needs:** none
- **Procedural:** yes — `randImpulse` and `ballImpulse` generate random impulse values and position/rotation offsets from the current time and object iteration rules rather than loading any asset file.
- **Glossary:**
  - `setObjectInfo - Engine call to set a property value on an object, using an object kind and property constant.`
  - `getObjectInfo - Engine call to read a property value from an object, using an object kind and property constant.`
  - `gObjects - Shared global table holding the tracked objects used by the physics functions.`
  - `gNumObjects - Shared global counting all tracked objects used by the physics functions.`
  - `IG3D_* constants - Engine property identifiers that name the property being read or set on an object.`
- **Keep / port / drop:** keep - reusable physics helper functions for new engine development.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the four listed functions.
- **Uses:** nothing
- **Reusable:** no

### heavyball
- **Does:** Sets the gravity multiplier and sphere shape on the object stored in the given object table entry.
- **Uses:** `setObjectInfo`, `gObjects`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_SHAPE`, `ig3d_sphere`
- **Reusable:** yes

### randImpulse
- **Does:** Seeds the random number generator from the current time and returns a random impulse power between -2 and 1.
- **Uses:** `math.randomseed`, `os.time`, `math.random`
- **Reusable:** yes

### ballImpulse
- **Does:** Iterates over all objects, seeds the random generator, computes random x/y/z impulse values, and sets the impulse property on each object's core object.
- **Uses:** `gObjects`, `gNumObjects`, `math.randomseed`, `os.time`, `math.random`, `setObjectInfo`, `IG3D_IMPULSE`
- **Reusable:** yes

### snaptoY
- **Does:** Iterates over all objects, adjusts their position and rotation based on the object index and random offsets, sets the new position, and calls heavyball and ballImpulse for each object.
- **Uses:** `getObjectInfo`, `getCameraInfo`, `setObjectInfo`, `gObjects`, `gNumObjects`, `math.random`, `heavyball`, `ballImpulse`, `IG3D_POSITION`, `IG3D_ROTATION`
- **Reusable:** yes
