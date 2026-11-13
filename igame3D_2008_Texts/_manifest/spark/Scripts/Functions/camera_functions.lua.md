<!-- Spark first-look of Data/Scripts/Functions/camera_functions.lua (model spark-x2.6-4b, 2026-11-12 06:34). DRAFT for Claude to review. -->

## camera_functions.lua
- **Kind:** engine-core
- **Purpose:** This file provides camera lookaround and movement utilities for the iGame3D 3D engine, including camera key management, object-facing rotation, mouse/keyboard lookaround handling, and camera follow logic. It also defines helper routines for setting fixed camera views and toggling four-view settings.
- **Depends on:** Other Scripts/Functions files (via `dofile`-style loading of sibling scripts), engine calls (`time()`, `getCameraInfo`, `setCameraInfo`, `editingModeSwitch`, `getObjectInfo`, `setObjectInfo`, `getSceneInfo`, `setSceneInfo`, `input`, `click`, `lineCollision`, `ig3d_TellFocus_b`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetFourViews_b`), globals (`gObjects`, `gMouse`, `st`, `speed`, `selectedobject`, `gFourView`, `cameras`, `cameraKeyCount`), and the `Data/` folder structure for level loading.
- **Provides:** Functions `lookbutton`, `cameraKey`, `faceObj`, `camera_faceObj`, `camera_face_xyz`, `lookaround`, `camera_WASDRFSpaceLoop`, `facetitles`, `camera_followObject`, `toggleQuadView`, plus global lookaround state variables (`cxa`, `cya`, `cza`, `speed`, `st`, `selectedobject`, `cameraKeyCount`) and the camera key array (`cameras`).
- **Assets it needs:** none (no model, image, sound, emitter, font, or `Data/` asset file names are referenced).
- **Procedural:** none (all functionality is implemented via engine calls and input handling; no assets are generated from numbers or rules).
- **Glossary:**
  - `lookaround` - The camera editing mode that lets the user rotate and move the camera via mouse and keyboard input.
  - `IG3D_POSITION` - Engine constant naming the position property of an object, scene, camera, or other engine object.
  - `IG3D_ROTATION` - Engine constant naming the rotation property of an object, scene, camera, or other engine object.
  - `IG3D_MOUSE_VIEW` - Engine constant used to set the scene to mouse view mode.
  - `editingModeSwitch` - Engine call that switches the active editing mode of the engine, such as "lookaround".
  - `getCameraInfo` / `setCameraInfo` - Engine calls used to read or set camera position and rotation properties.
  - `getObjectInfo` / `setObjectInfo` - Engine calls used to read or set properties of named objects, such as rotation or position.
  - `ig3d_GetMeshCentroid__3f` - Engine call that returns the 3D centroid coordinates of a mesh.
- **Keep / port / drop:** keep - Core camera and lookaround logic is reusable for any engine built on the same iGame3D call patterns.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines global lookaround state variables and the camera key counter, plus the start of the lookbutton function.
- **Uses:** Globals `cxa`, `cya`, `cza`, `speed`, `st`, `selectedobject`, `cameraKeyCount`; engine calls `time()`, `getCameraInfo`, `setCameraInfo`; file `camera_functions.lua` (Scripts/Functions).
- **Reusable:** no

### lookbutton
- **Does:** Activates the lookaround editing mode for the camera.
- **Uses:** Engine call `editingModeSwitch("lookaround")`.
- **Reusable:** yes

### cameraKey
- **Does:** Manages the camera key list: when called with no argument it appends a new camera entry to the camera key array and returns the existing camera position/rotation values for the new entry; when called with an argument it returns the stored position and rotation values for that camera key.
- **Uses:** Globals `cameras`, `cameraKeyCount`; engine calls `getCameraInfo`, `setCameraInfo`; file `camera_functions.lua` (Scripts/Functions).
- **Reusable:** no

### faceObj
- **Does:** Rotates the camera or a named object to face a given object: if the target object is the camera, it sets the camera rotation to face the given object; otherwise it sets the named object's rotation to face the given object.
- **Uses:** Engine calls `getObjectInfo`, `getCameraInfo`, `setCameraInfo`, `setObjectInfo`; globals `gObjects`; file `camera_functions.lua` (Scripts/Functions).
- **Reusable:** no

### camera_faceObj
- **Does:** Rotates the camera to face the given object, defaulting the object name to the default camera object if no name is provided.
- **Uses:** Engine calls `getObjectInfo`, `getCameraInfo`, `setCameraInfo`; globals `gObjects`; file `camera_functions.lua` (Scripts/Functions).
- **Reusable:** no

### camera_face_xyz
- **Does:** Rotates the camera to face the given x, y, z coordinates, defaulting the coordinates to the mesh centroid of the default object if no coordinates are provided.
- **Uses:** Engine calls `getCameraInfo`, `setCameraInfo`, `ig3d_GetMeshCentroid__3f`; globals `gObjects`; file `camera_functions.lua` (Scripts/Functions).
- **Reusable:** no

## Part 2 of 3

### lookaround
- **Does:** Handles mouse lookaround and keyboard camera movement, updating camera rotation and position based on input and scene state.
- **Uses:** Engine calls (`input`, `click`, `getSceneInfo`, `lineCollision`, `getCameraInfo`, `setCameraInfo`, `ig3d_TellFocus_b`, `setSceneInfo`, `getObjectInfo`-style info reads via `getCameraInfo`), globals (`st`, `speed`, `passed`, `cya`, `cxa`, `cx`, `cy`, `cz`, `mx`, `my`, `mz`, `char`, `code`, `name`), and no `Data/` file paths.
- **Reusable:** no
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** No top-level setup, globals, or widget definitions appear outside the function definitions.
- **Uses:** nothing
- **Reusable:** no

### camera_WASDRFSpaceLoop
- **Does:** Controls camera movement while the space bar is pressed: calls the default escape key handler, and if the mouse is active, runs the lookaround routine.
- **Uses:** `default_escapekey()`, `gMouse`, `lookaround()`
- **Reusable:** no

### facetitles
- **Does:** Sets the scene to mouse view mode and positions and rotates the camera to fixed coordinates.
- **Uses:** `setSceneInfo(IG3D_MOUSE_VIEW, false)`, `setCameraInfo(IG3D_POSITION, 0,0,10)`, `setCameraInfo(IG3D_ROTATION, 0,180,0)`
- **Reusable:** yes

### camera_followObject
- **Does:** Moves the camera toward a selected object based on its rotation matrix, velocity, and lateral offset, then updates the camera position.
- **Uses:** `getObjectInfo(selectedobject, IG3D_ROTATION_MATRIX)`, `getCameraInfo(IG3D_POSITION)`, `getObjectInfo(selectedobject, IG3D_VELOCITY)`, `setCameraInfo(IG3D_POSITION, x,y,z)`, globals `selectedobject`
- **Reusable:** no

### toggleQuadView
- **Does:** Toggles the four-view setting and applies the new value to the engine's four views.
- **Uses:** `gFourView`, `ig3d_SetFourViews_b(gFourView)`
- **Reusable:** yes
