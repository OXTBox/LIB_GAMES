<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Utilities.lua (model spark-x2.6-4b, 2026-11-12 16:46). DRAFT for Claude to review. -->

## RTS_Utilities.lua
- **Kind:** library
- **Purpose:** This file contains reusable utility functions for the iGame3D RTS engine, including text box creation and console output helpers, object selection and highlighting utilities, selection rectangle configuration, house destruction and ragdoll setup, game end condition checks, and collision reset helpers. It provides standalone functions that other scripts can call to manage game objects, selection state, and object properties.
- **Depends on:** `Data/` folder paths (e.g., `gameroot.."Data/<Folder>/<file>"`), globals such as `gObjects`, `gTextboxes`, `gTextboxFonts`, `gNumTextboxes`, `gStatusString`, `gDraggingSelRect`, `gSelectionRect`, `gTeamSelect`, `selectionRect.cObj`, `kSelectionBoxDist`, and functions like `make`, `setText_boxInfo`, `getText_boxInfo`, `setObjectInfo`, `getObjectInfo`, `setBoneInfo`, `getBoneInfo`, `getCameraInfo`, `getSceneInfo`, `get(ig3d_bone, ...)`, `setMaterialInfo`, `setParticle_emitterInfo`, `ig3d_GetLevelName__s__`, `ig3d_GetObjectModelPath_s_s`, `ig3d_GetWindowBounds__4i`, `ig3d_FoolMousePosition_2i`, `ig3d_box`, `normalized`, `drawGridDebug()`, `loadLevel`, and `dofile` (used for loading code via `Data/` paths).
- **Provides:** Functions including `makeTextBox`, `RTS_print`, `drawGridDebug`, `hiliteMarkedObjects`, `unselectAllObjects`, `somethingSelected`, `setSelectionRect`, `handle_selection_box`, `destroyHouse`, `checkGameEndCondition`, `isFemale`, and `resetCollisionToDefault`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this file).
- **Procedural:** none (the file only configures existing objects, sets properties, and checks state; it does not generate assets from numbers or rules).
- **Glossary:**
  - `IG3D_*` - Engine constants that name the property being read or set on an object (e.g., `IG3D_POSITION` for position, `IG3D_TEXT` for text).
  - `ig3d_object` / `ig3d_bone` / `ig3d_material` - Engine object types used as the first argument to `make`/`get` calls.
  - `gObjects` - Global table of all game objects, accessed by iterating or checking properties on each entry.
  - `setObjectInfo` / `getObjectInfo` - Engine calls to read or set properties (position, rotation, bounds, etc.) on an object.
  - `setBoneInfo` / `getBoneInfo` - Engine calls to read or set properties on a bone within an object.
  - `ragdoll` - Object state where bones are torn down and re-enabled for simulated falling motion.
  - `selectionRect` - Object used to define the selection rectangle for mouse-based object selection.
- **Keep / port / drop:** keep - reusable utility functions for object management, selection, and game state checks that other scripts rely on.

---

# Part notes

## Part 1 of 8

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### makeTextBox
- **Does:** Creates a text box object, configures its position, size, and color, and records the assigned index in the global `gNumTextboxes`.
- **Uses:** `make`, `setText_boxInfo`, `gTextboxes`, `gTextboxFonts`, `gNumTextboxes`, `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_COLOR`
- **Reusable:** yes

### RTS_print
- **Does:** Appends the given text to the console text box, updates the console text box size, and sets the console text box text to the current level name.
- **Uses:** `setText_boxInfo`, `getText_boxInfo`, `RTS_console`, `IG3D_TEXT`, `IG3D_SIZE`, `ig3d_GetLevelName__s__`
- **Reusable:** yes

## Part 2 of 8

### drawGridDebug
- **Does:** Marks enemy and friendly objects on a debug grid by setting particle emitter info, walking enemy path points, and drawing debug markers for grid, nds, and nds2 elements.
- **Uses:** `gObjects`, `setParticle_emitterInfo`, `unitMarkerEnemy`, `unitMarkerFriendly`, `IG3D_SIZE`, `IG3D_POSITION`, `IG3D_START`, `gNumRowVertices`, `gNumColumnVertices`, `grid`, `nds`, `gende`, `ganfang`, `nds3`, `nds2`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** none

## Part 3 of 8

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the `hiliteMarkedObjects` and `unselectAllObjects` functions.
- **Uses:** nothing
- **Reusable:** no

### hiliteMarkedObjects
- **Does:** Iterates all objects in reverse order, updates emission material properties for blinking or non-blinking marked objects, and configures particle emitters for selected objects based on their selection state, bounds, and path/order targets.
- **Uses:** `get(ig3d_material, ...)`, `setMaterialInfo(m, IG3D_EMISSION, ...)`, `getObjectInfo(obj, IG3D_POSITION)`, `getObjectInfo(obj, IG3D_BOUNDS)`, `setParticle_emitterInfo(..., IG3D_POSITION/IG3D_SIZE/IG3D_START, ...)`, `gObjects`, `unitMarkerFriendly`, `unitMarkerEnemy`, `passed()`, `math.max`, `drawGridDebug()` (commented out), `IG3D_EMISSION`, `IG3D_BOUNDS`
- **Reusable:** no

### unselectAllObjects
- **Does:** Sets the `selected` field to `false` for every object in the `gObjects` table.
- **Uses:** `gObjects`
- **Reusable:** yes

### Procedural
- No section

## Part 4 of 8

### somethingSelected
- **Does:** Iterates through the `gObjects` table, checking each object for the `selected` property, and returns `true` as soon as one object is selected. If no object is selected, it returns `false`.
- **Uses:** `gObjects` (global table of objects)
- **Reusable:** yes
- **Procedural:** no

## Part 5 of 8

### Top level
- **Does:** The file contains a comment noting that several long utility functions are outsourced to this file, with `setSelectionRect` listed as one of them.
- **Uses:** nothing
- **Reusable:** no

### setSelectionRect
- **Does:** Sets the position and rotation of a selection rectangle object, then computes and sets the four corner bone positions based on the camera, window bounds, mouse line, and a fixed selection box distance.
- **Uses:** `get(ig3d_bone, selectionRect.cObj, "one")`, `get(ig3d_bone, selectionRect.cObj, "three")`, `get(ig3d_bone, selectionRect.cObj, "five")`, `get(ig3d_bone, selectionRect.cObj, "seven")`, `get(ig3d_bone, selectionRect.cObj, "two")`, `get(ig3d_bone, selectionRect.cObj, "four")`, `get(ig3d_bone, selectionRect.cObj, "six")`, `get(ig3d_bone, selectionRect.cObj, "eight")`, `getCameraInfo(IG3D_POSITION)`, `setObjectInfo(selectionRect.cObj, IG3D_POSITION, cx,cy,cz)`, `setObjectInfo(selectionRect.cObj, IG3D_ROTATION, 0,0,0)`, `ig3d_GetWindowBounds__4i()`, `ig3d_FoolMousePosition_2i(left,top)`, `getSceneInfo(IG3D_MOUSE_LINE)`, `normalized(dx,dy,dz)`, `setBoneInfo(upperleft, IG3D_POSITION, x-cx,y-cy,z-cz)`, `setBoneInfo(upperright, IG3D_POSITION, x-cx,y-cy,z-cz)`, `setBoneInfo(lowerright, IG3D_POSITION, x-cx,y-cy,z-cz)`, `setBoneInfo(lowerleft, IG3D_POSITION, x-cx,y-cy,z-cz)`, globals `selectionRect.cObj`, `kSelectionBoxDist`, constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_MOUSE_LINE`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 8

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file.
- **Uses:** nothing
- **Reusable:** no

### handle_selection_box
- **Does:** Handles mouse selection box interactions to toggle object selection state based on mouse drag and click events.
- **Uses:** `click`, `getSceneInfo`, `getObjectInfo`, `key`, globals `gDraggingSelRect`, `gSelectionRect`, `gObjects`, `gTeamSelect`, `gTeamSelect` (via `gObjects[i].team`), plus constants `IG3D_MOUSE_LINE`, `IG3D_WINDOW_COORDS`, `IG3D_POSITION`
- **Reusable:** no

### handle_selection_box
- **Does:** No procedural generation of assets is performed; this function only manipulates existing object state and UI state.
- **Reusable:** no

## Part 7 of 8

### Top level
- **Does:** No top-level code outside the two function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### destroyHouse
- **Does:** Marks a house object as dead, sets its rotation and mass properties, disables its colliding behavior, and tears down its bones to make it ragdoll, then re-enables ragdoll mode and disables all remaining bones until the last one is removed.
- **Uses:** `setObjectInfo`, `get`, `setBoneInfo`, `getBoneInfo`, `IG3D_OMEGA`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_MASS`, `IG3D_RAGDOLL`, `IG3D_NAME`, plus the `obj` parameter and `cObj` property accessed inside the function.
- **Reusable:** no

### checkGameEndCondition
- **Does:** Counts the number of team 0 and team 1 objects with a positive death count, then sets `gStatusString` based on whether all teams are dead, only zombies remain, only humans remain, or both teams have remaining dead objects.
- **Uses:** `gObjects`, `gStatusString`, plus the `team` and `deathCount` properties accessed inside the function.
- **Reusable:** yes
- **Procedural:** no

## Part 8 of 8

### Top level
- **Does:** The file contains two functions: `isFemale` and `resetCollisionToDefault`. No setup, globals, or widget definitions appear outside these functions.
- **Uses:** `ig3d_GetObjectModelPath_s_s`, `getObjectInfo`, `setObjectInfo`, `IG3D_NAME`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_BONE_COLL`, `IG3D_COLLBOX_MULTIPLICATORS`, `IG3D_SHAPE`, `IG3D_POSITION`, `gameroot`, `ig3d_box`
- **Reusable:** yes
- **Procedural:** no

### isFemale
- **Does:** Determines whether an object is female by extracting the model file name from the object's model path and checking it against a list of known female model filenames.
- **Uses:** `getObjectInfo`, `ig3d_GetObjectModelPath_s_s`, `IG3D_NAME`, `gameroot`
- **Reusable:** yes
- **Procedural:** no

### resetCollisionToDefault
- **Does:** Resets the collision settings of an object to its default state by clearing the vector constraint, disabling the bone collision, resetting collider multipliers, setting the shape to a box, and restoring the original collision state.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `IG3D_COLL`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_BONE_COLL`, `IG3D_COLLBOX_MULTIPLICATORS`, `IG3D_SHAPE`, `ig3d_box`
- **Reusable:** yes
- **Procedural:** no
