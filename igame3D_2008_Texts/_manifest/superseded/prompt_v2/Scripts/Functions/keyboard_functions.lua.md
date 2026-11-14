<!-- Spark first-look of Data/Scripts/Functions/keyboard_functions.lua (model spark-x2.6-4b, 2026-11-12 06:57). DRAFT for Claude to review. -->

## keyboard_functions.lua
- **Kind:** library
- **Purpose:** This file provides keyboard input handling utilities for the iGame3D engine, managing mouse and editing state flags, view coordinate definitions, and functions for loading levels, opening UI windows, toggling view and editing modes, adjusting font size, and applying WASD movement and rotation controls to game objects.
- **Depends on:** `Data/` folder paths, globals set elsewhere (e.g., `gMouse`, `gEditingMode`, `gFourView`, `gObjects`, `FontSizeMod`, `OPEN_UI_WINDOWS`), engine functions (`loadLevel`, `input`, `key`, `game_func`, `viewplaytoggle`, `editingModeSwitch`, `ig3d_SetMode_i`, `ig3d_SetFourViews_b`, `go`, `setObjectInfo`, `getObjectInfo`, `fltk_update`), and UI files such as `UIMainTools` and its `.fl`/`.lua` components.
- **Provides:** Functions including `escape_to`, `open_gui_keys`, `igame3d_controlkeys`, `adjustFontSize`, `default_escapekey`, `drive_off`, `WASD_pushObject`, plus global flags controlling mouse and editing state (`gMouse`, `lookmode`, `gEditingMode`, `gFourView`, `gViewX`, `gViewY`, `gViewZ`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `FontSizeMod`).
- **Assets it needs:** none (no model, image, sound, emitter, font, or other named asset files are referenced).
- **Procedural:** none (the file only defines functions and sets global flags; it does not generate assets from numbers or rules).
- **Glossary:**
  - `IG3D_POSITION` - A property constant naming the position of an object, used when reading or setting object position data.
  - `IG3D_TORQUE` - A property constant naming the torque value of an object, used to apply rotational force to objects.
  - `IG3D_ROTATION_MATRIX` - A property constant naming the rotation matrix of an object, used to set object rotation data.
  - `IG3D_OMEGA` - A property constant naming the angular velocity of an object, used to set rotational motion data.
  - `IG3D_FORCE` - A property constant naming the force value of an object, used to set object movement data.
  - `IG3D_VECTOR_CONSTRAINT` - A property constant naming the vector constraint value of an object, used to set object movement constraints.
  - `loadLevel` - An engine function that switches the active game level by loading a specified level folder.
  - `dofile` - An engine function that loads a Lua script file from a given path.
- **Keep / port / drop:** keep - it is a reusable keyboard input and editing control library for the iGame3D engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Sets global flags controlling mouse and editing state, defines view coordinates, and defines the start of the `escape_to` function.
- **Uses:** Globals (`gMouse`, `lookmode`, `gEditingMode`, `gFourView`, `gViewX`, `gViewY`, `gViewZ`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`).
- **Reusable:** no

### escape_to
- **Does:** Loads the specified level, defaulting to the timed level if no level is provided, and returns early if the timed level is still loading or has finished loading.
- **Uses:** Globals (`aLevel`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`), engine call (`loadLevel`).
- **Reusable:** yes

### open_gui_keys
- **Does:** Reads input keys and opens the console, script editor, or mesh editor UI window based on the pressed keys.
- **Uses:** Engine calls (`input`, `key`), globals (`OPEN_UI_WINDOWS`).
- **Reusable:** yes

Wait, the top level code includes the toggle object editing setup lines and the `escape_to` function start. Let me correct the top level section to accurately reflect the code outside the functions:

### Top level
- **Does:** Sets global flags controlling mouse and editing state, defines four-view view coordinates, and defines the start of the `escape_to` function.
- **Uses:** Globals (`gMouse`, `lookmode`, `gEditingMode`, `gFourView`, `gViewX`, `gViewY`, `gViewZ`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`).
- **Reusable:** no

### escape_to
- **Does:** Loads the specified level, defaulting to the timed level if no level is provided, and returns early if the timed level is still loading or has finished loading.
- **Uses:** Globals (`aLevel`, `gTimedLevel`, `gTimedLevelLoad`, `gTimedLevelLoadTime`, `game_func`, `loadLevel`), engine call (`loadLevel`).
- **Reusable:** yes

### open_gui_keys
- **Does:** Reads input keys and opens the console, script editor, or mesh editor UI window based on the pressed keys.
- **Uses:** Engine calls (`input`, `key`), globals (`OPEN_UI_WINDOWS`).
- **Reusable:** yes

## Part 2 of 4

### Top level
- **Does:** Contains no setup, global definitions, or widget definitions outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### igame3d_controlkeys
- **Does:** Handles control and command key presses to toggle view modes, switch editing modes, toggle four-view mode, and open the key GUI.
- **Uses:** Engine input calls (`key`), globals (`gEditingMode`, `gFourView`), engine functions (`viewplaytoggle`, `editingModeSwitch`, `ig3d_SetMode_i`, `ig3d_SetFourViews_b`, `open_gui_keys`), and the commented-out `escape_to` path reference.
- **Reusable:** no

### adjustFontSize
- **Does:** Adjusts the global `FontSizeMod` value by 0.1 when the right bracket or left bracket keys are pressed, respectively.
- **Uses:** Engine input calls (`key`), global (`FontSizeMod`).
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the two defined functions.
- **Uses:** nothing
- **Reusable:** no

### default_escapekey
- **Does:** Reads the current input character and key name, then if the key is Escape toggles the viewplay toggle, shows the UIMainTools UI window if it is not already open, and beeps on click.
- **Uses:** `input(false)`, `viewplaytoggle()`, `gEditingMode`, `UIMainTools`, `OPEN_UI_WINDOWS("UIMainTools")`, `UIMainTools:show()`, `onClickBeep()`, `igame3d_controlkeys()`, `fltk_update()`
- **Reusable:** no

### drive_off
- **Does:** Moves the given object forward or backward with W and S, and applies torque to the object with A and D to rotate it up or down, resetting torque to zero otherwise.
- **Uses:** `key("w", "-")`, `key("s", "-")`, `key("a", "-")`, `key("d", "-")`, `go(obj.cObj, ...)`, `setObjectInfo(obj.cObj, IG3D_TORQUE, ...)`, `passed()`
- **Reusable:** no

## Part 4 of 4

### Top level

### WASD_pushObject
- **Does:** Applies WASD key input to an object by setting rotation, force and torque values, and resets the trick counter and force values when keys are pressed.
- **Uses:** Engine calls (`getObjectInfo`, `setObjectInfo` with `IG3D_ROTATION_MATRIX`, `IG3D_OMEGA`, `IG3D_FORCE`, `IG3D_TORQUE`, `IG3D_VECTOR_CONSTRAINT`), global `gObjects` and `key` function.
- **Reusable:** no
- **Procedural:** no
