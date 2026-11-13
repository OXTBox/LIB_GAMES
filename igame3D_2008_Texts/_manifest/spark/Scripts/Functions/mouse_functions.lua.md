<!-- Spark first-look of Data/Scripts/Functions/mouse_functions.lua (model spark-x2.6-4b, 2026-11-12 07:18). DRAFT for Claude to review. -->

## mouse_functions.lua
- **Kind:** library
- **Purpose:** This file provides default mouse function settings and shared setup for the mouse-related functions in iGame3D. It defines reusable helpers that compute mouse cursor 3D positions, check whether the mouse is inside a rectangle, and set up path objects from mouse interactions.
- **Depends on:** Engine calls (`ig3d_CreatePath_s`, `ig3d_SetPathInfo_is`, `ig3d_SetPathsVisible_b`, `getSceneInfo`, `ig3d_GetWindowBounds__4i`, `ig3d_Get3DPositionFrom2DCoordinates_2ib_3f`, `ig3d_IsMouseButtonDown__b`), globals (`gEditingMode`, `allPoints`), engine helper (`mouseloc`), file path (`path1`), and FLTK event helpers (`Fl:event_x_root`, `Fl:event_y_root`).
- **Provides:** Functions `mouseloc`, `mouseInBox`, `gridPen`, `PathFromMouseDown`, `onClickBeep`, `mouseCoords`, plus default mouse function settings from the file header.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (no assets are generated from numbers or rules; only object configuration and coordinate calculations are performed).
- **Glossary:**
  - `ig3d_CreatePath_s` - Engine call that creates a path object for mouse-based path editing.
  - `IG3D_MOUSE_LINE` - Engine constant naming the scene property holding the mouse line data.
  - `IG3D_WINDOW_COORDS` - Engine constant naming the scene property holding window coordinate data.
  - `gEditingMode` - Global shared between files that stores the current editing mode of the game.
  - `allPoints` - Global shared between files that holds the list of points for path objects.
  - `path1` - File path referenced by the engine call to load the path file.
  - `mouseloc` - Engine helper function that computes the 3D position of the mouse cursor.
  - `meshtoolPath` - Editing mode value that triggers path mouse down actions.
- **Keep / port / drop:** keep - reusable mouse interaction helpers and default settings for new mouse-driven engine code.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the file's default mouse function settings and shared setup for the mouse-related functions.
- **Uses:** Engine calls (`ig3d_CreatePath_s`, `ig3d_SetPathInfo_is`, `ig3d_SetPathsVisible_b`, `getSceneInfo`), globals (`gEditingMode`, `allPoints`), files (`path1` referenced via `ig3d_CreatePath_s`).
- **Reusable:** no

### mouseloc
- **Does:** Computes the 3D position of the mouse cursor by reading scene info for the mouse line and window coordinates, then converts the 2D window coordinates to 3D coordinates.
- **Uses:** Engine calls (`getSceneInfo` with `IG3D_MOUSE_LINE` and `IG3D_WINDOW_COORDS`), engine helper (`ig3d_GetWindowBounds__4i`), engine helper (`ig3d_Get3DPositionFrom2DCoordinates_2ib_3f`).
- **Reusable:** yes

### mouseInBox
- **Does:** Returns true if the given mouse coordinates fall inside the specified rectangle, otherwise returns false.
- **Uses:** nothing
- **Reusable:** yes

### gridPen
- **Does:** Returns the fixed 3D coordinates (0, 0, 0) for the grid pen tool.
- **Uses:** nothing
- **Reusable:** yes

### PathFromMouseDown
- **Does:** Sets up the path object, marks the path as visible, reads the current mouse 3D position, converts it to a comma-separated string, appends it to the path's point list, and updates the path's point information.
- **Uses:** Engine calls (`ig3d_CreatePath_s`, `ig3d_SetPathInfo_is`, `ig3d_SetPathsVisible_b`, `ig3d_GetPathInfo_i_s`, `ig3d_SetPathInfo_is`), engine helper (`mouseloc`), globals (`allPoints`), file path (`path1`).
- **Reusable:** no

### onClickBeep
- **Does:** Checks if the mouse button is currently pressed, and if the editing mode is `meshtoolPath`, triggers the path mouse down action.
- **Uses:** Engine calls (`ig3d_IsMouseButtonDown__b`), globals (`gEditingMode`), engine helper (`PathFromMouseDown`), FLTK event helpers (`Fl:event_x_root`, `Fl:event_y_root`).
- **Reusable:** no

### mouseCoords
- **Does:** Reads the current mouse 3D position from scene info, applies the window coordinate transformation to it, and returns the transformed 3D coordinates.
- **Uses:** Engine calls (`getSceneInfo` with `IG3D_MOUSE_LINE` and `IG3D_WINDOW_COORDS`).
- **Reusable:** yes
