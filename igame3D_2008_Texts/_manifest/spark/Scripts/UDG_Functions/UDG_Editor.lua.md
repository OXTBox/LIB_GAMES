<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Editor.lua (model spark-x2.6-4b, 2026-11-12 17:17). DRAFT for Claude to review. -->

## UDG_Editor.lua
- **Kind:** tool
- **Purpose:** This file provides editor helper functions for creating game objects and handling editor key input. It defines a door creation routine and empty placeholder functions for scenery, woman, and man object creation, plus a key handler that routes pressed keys to the matching creation function.
- **Depends on:** `Data/` folder paths, `gObjectWTFs`, `gObjectNames`, `gObjectPositions`, `gObjectRotations`, `gObjects`, `doors`, `getCameraInfo`, `input`, and `key` (globals set elsewhere in the engine).
- **Provides:** `UDG_makeDoor`, `UDG_makeScenery`, `UDG_makeWoman`, `UDG_makeMan`, `UDG_editor_keys`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** none (placing and configuring a door object is not generating an asset from numbers or rules).
- **Glossary:**
  - `IG3D_POSITION -` A property constant naming the position of an object, used when reading or setting object position.
  - `IG3D_ROTATION -` A property constant naming the rotation of an object, used when reading or setting object rotation.
  - `IG3D_NAME -` A property constant naming the name of an object, used when assigning a generated name to a created object.
  - `IG3D_SIZE -` A property constant naming the size of an object, used when setting size on a created object.
  - `IG3D_COLL -` A property constant naming collision settings for an object, used when configuring a created object.
  - `IG3D_HUD -` A property constant naming HUD settings for an object, used when configuring a created object.
  - `make -` A call that creates an object of a given kind, used to build the door object.
  - `setObjectInfo -` A call that sets properties (such as position, rotation, size, collision, HUD) on an existing object, used to configure the created door.
- **Keep / port / drop:** keep - it is a reusable editor helper for creating door objects and routing editor keys to object creation functions.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** No top-level code outside the function definitions; the file begins directly with the function `UDG_makeDoor` and ends after `UDG_editor_keys`.
- **Uses:** nothing
- **Reusable:** no

### UDG_makeDoor
- **Does:** Creates a door object in the game, assigning it a generated name, position, rotation, size, collision and HUD settings, and registers it in the door list.
- **Uses:** `getCameraInfo`, `IG3D_POSITION`, `IG3D_ROTATION`, `gObjectWTFs`, `gObjectNames`, `gObjectPositions`, `gObjectRotations`, `gObjects`, `make`, `setObjectInfo`, `IG3D_NAME`, `IG3D_SIZE`, `IG3D_COLL`, `IG3D_HUD`, `doors`
- **Reusable:** no

### UDG_makeScenery
- **Does:** Defines an empty function `UDG_makeScenery` with no implementation.
- **Uses:** nothing
- **Reusable:** no

### UDG_makeWoman
- **Does:** Defines an empty function `UDG_makeWoman` with no implementation.
- **Uses:** nothing
- **Reusable:** no

### UDG_makeMan
- **Does:** Defines an empty function `UDG_makeMan` with no implementation.
- **Uses:** nothing
- **Reusable:** no

### UDG_editor_keys
- **Does:** Reads a key input and calls the corresponding object creation function based on the pressed key.
- **Uses:** `input`, `key`, `UDG_makeDoor`, `UDG_makeScenery`, `UDG_makeWoman`, `UDG_makeMan`
- **Reusable:** no
