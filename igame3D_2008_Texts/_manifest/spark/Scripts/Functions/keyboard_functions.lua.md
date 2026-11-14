<!-- Spark first-look of Data/Scripts/Functions/keyboard_functions.lua (model spark-x2.6-4b, 2026-11-12 20:45). DRAFT for Claude to review. -->

## keyboard_functions.lua
- **Kind:** library
- **Purpose:** This file provides keyboard-driven control functions for a 2008 Lua 5.1 3D game engine, handling editing/view mode switching, key-based UI window opening, WASD object manipulation, and escape-key behavior. It defines reusable helper functions for interacting with engine input, object state, and UI windows.
- **Depends on:** `gMouse`, `lookmode`, `gEditingMode`, `gFourView`, `gViewX`, `gViewY`, `gViewZ`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`, `input`, `key`, `OPEN_UI_WINDOWS`, `viewplaytoggle`, `editingModeSwitch`, `ig3d_SetMode_i`, `ig3d_SetFourViews_b`, `UIMainTools`, `onClickBeep`, `fltk_update`, `go`, `setObjectInfo`, `IG3D_TORQUE`, `passed`, `getObjectInfo`, `gObjects`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`, `IG3D_FORCE`, `IG3D_VECTOR_CONSTRAINT`
- **Provides:** `escape_to`, `open_gui_keys`, `igame3d_controlkeys`, `adjustFontSize`, `default_escapekey`, `drive_off`, `WASD_pushObject`
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `gEditingMode` - global flag tracking the current editing mode of the engine.
  - `OPEN_UI_WINDOWS` - engine call used to open UI windows based on a named window.
  - `IG3D_*` constants - engine constants naming the properties being read or set on objects (e.g., position, torque, rotation matrix).
  - `setObjectInfo` - engine call used to set properties on an object (e.g., torque, rotation matrix, force).
  - `getObjectInfo` - engine call used to read properties on an object.
  - `loadLevel` - engine call used to switch the active game or demo level.
  - `input` - engine call used to read user input (key presses, mouse state).
  - `key` - engine call used to check for specific key presses (e.g., W, A, D, bracket keys).
- **Keep / port / drop:** keep - reusable keyboard control helpers for a new engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Sets global flags for mouse and editing state, then defines the two functions `escape_to` and `open_gui_keys`.
- **Uses:** `gMouse`, `lookmode`, `gEditingMode`, `gFourView`, `gViewX`, `gViewY`, `gViewZ`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`, `input`, `key`, `OPEN_UI_WINDOWS`
- **Reusable:** no

### escape_to
- **Does:** Loads a level, defaulting to the timed level if no level is given, and only loads it after the timed level load time has passed.
- **Uses:** `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `loadLevel`
- **Reusable:** yes

### open_gui_keys
- **Does:** Reads a key input and opens the console, script editor, or mesh editor UI window based on the pressed key.
- **Uses:** `input`, `key`, `OPEN_UI_WINDOWS`
- **Reusable:** yes

## Part 2 of 4

### igame3d_controlkeys
- **Does:** Handles input keys to switch editing/view modes, toggle four-view mode, adjust the editing mode, and open the key GUI.
- **Uses:** `input`, `key`, `gEditingMode`, `gFourView`, `viewplaytoggle`, `editingModeSwitch`, `ig3d_SetMode_i`, `ig3d_SetFourViews_b`, `open_gui_keys`
- **Reusable:** no
- **Procedural:** no

### adjustFontSize
- **Does:** Adjusts the global `FontSizeMod` value by 0.1 when the right bracket or left bracket key is pressed, respectively.
- **Uses:** `key`
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 4

### default_escapekey
- **Does:** Handles the Escape key: toggles the play view and, when editing is not in play mode, shows the UIMainTools UI window or opens it if it does not exist yet, then beeps on click.
- **Uses:** `input(false)`, `viewplaytoggle()`, `gEditingMode`, `UIMainTools`, `OPEN_UI_WINDOWS("UIMainTools")`, `UIMainTools:show()`, `onClickBeep()`, `igame3d_controlkeys()`, `fltk_update()`
- **Reusable:** no

### drive_off
- **Does:** Moves the given object along the Z axis by 20 units per frame when W is pressed, and applies torque to the object along the Y axis when A is pressed, reducing torque when D is pressed and zeroing it otherwise.
- **Uses:** `key("w", "-")`, `key("s", "-")`, `key("a", "-")`, `key("d", "-")`, `go()`, `setObjectInfo()`, `IG3D_TORQUE`, `passed()`
- **Reusable:** no

## Part 4 of 4

### WASD_pushObject
- **Does:** Applies WASD keyboard input to an object by setting rotation matrix, force, and torque values, with the object defaulting to `gObjects[1].cObj` when no name is given.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `key`, `gObjects`, `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`, `IG3D_FORCE`, `IG3D_TORQUE`, `IG3D_VECTOR_CONSTRAINT`
- **Reusable:** no
- **Procedural:** no
