<!-- Spark first-look of Data/Levels/iFly/iFly_Controls/load script.lua (model spark-x2.6-4b, 2026-11-12 18:36). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file is the control script for the iFly level. It sets up the scene background and control text boxes, reads the older command script to fill in text and key mappings, and runs the main control loop that handles input, mouse interactions, and writes the controls script file.
- **Depends on:** `Data/FontPngs/default32_1.png`, `Data/Levels/iFly/iFly_controls.txt`, `loop` (defined in this file), `load`, `loadLevel`, `input`, `gSelBox`, `setText_boxInfo`, `keys`, `gMSpeed`, `gMouseSpeed`, `gMouseMax`, `gMouseMin`, `numberToMinusSigns`, `click`, `mouseCoords`, `getText_boxInfo`, `boxes`, `IG3D_TEXT`, `IG3D_COLOR`, `getSceneInfo`, `io.open`, `loadLevel`, `start`
- **Provides:** `loop` (the main control loop for the iFly level), `numberToMinusSigns` (builds a string of `n` minus signs), `mouseInBox` (checks if mouse coordinates fall within bounds), `mouseCoords` (reads current mouse and window coordinates from scene info)
- **Assets it needs:** `Data/FontPngs/default32_1.png`
- **Procedural:** none
- **Glossary:**
  - `setSceneInfo` - engine call to set scene properties such as background color
  - `make` - engine call to build an iGame3D object
  - `setText_boxInfo` - engine call to set properties of a text box
  - `getSceneInfo` - engine call to read scene properties such as mouse line and window coordinates
  - `loadLevel` - engine call to switch to a level folder
  - `IG3D_TEXT` - constant naming the text property being read or set
  - `IG3D_COLOR` - constant naming the color property being read or set
  - `IG3D_MOUSE_LINE` - constant naming the mouse line property being read
  - `IG3D_WINDOW_COORDS` - constant naming the window coordinates property being read
- **Keep / port / drop:** keep - it is the level control script for iFly, reusable as a reference for level control setup and looping

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Sets the scene background color, builds and configures the iFly control text boxes, then reads the older command script to fill in the remaining text and key mappings.
- **Uses:** `setSceneInfo`, `make`, `setText_boxInfo`, `getSceneInfo`, `io.lines`, globals `gNumBoxes`, `gSelBox`, `gMouseSpeed`, `gMouseMin`, `gMouseMax`, `gMSpeed`, `load`, `boxes`, `texts`, `keys`, and paths `Data/FontPngs/default32_1.png`, `Data/Levels/iFly/iFly_controls.txt`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 3

### Top level
- **Does:** Sets the global `gMouseSpeed` from the key state and updates the text box with the mouse sensitivity label.
- **Uses:** `keys`, `setText_boxInfo`, `numberToMinusSigns`, globals `mspeed`
- **Reusable:** no

### numberToMinusSigns
- **Does:** Builds a string of `n` minus signs by appending `"-"` `n` times and returns it.
- **Uses:** nothing
- **Reusable:** yes - pure string construction

### mouseInBox
- **Does:** Returns true if the given mouse coordinates fall within the specified rectangular bounds, otherwise returns false.
- **Uses:** nothing
- **Reusable:** yes - pure coordinate comparison

### mouseCoords
- **Does:** Reads the current mouse line and window coordinates from the scene info, returns the three coordinate values.
- **Uses:** `getSceneInfo`, `IG3D_MOUSE_LINE`, `IG3D_WINDOW_COORDS`
- **Reusable:** yes - pure data read

### Top level
- **Does:** Sets `gMouseSpeed` from the key state and updates the text box with the mouse sensitivity label.
- **Uses:** `keys`, `setText_boxInfo`, `numberToMinusSigns`, globals `mspeed`
- **Reusable:** no

## Part 3 of 3

### Top level
- **Does:** Sets `game_func` to `loop` and contains the top-level setup lines for the iFly controls script.
- **Uses:** `loop` (defined in this file), `load`, `loadLevel`, `input`, `gSelBox`, `setText_boxInfo`, `keys`, `gMSpeed`, `gMouseSpeed`, `gMouseMax`, `gMouseMin`, `numberToMinusSigns`, `click`, `mouseCoords`, `getText_boxInfo`, `boxes`, `IG3D_TEXT`, `IG3D_COLOR`, `getSceneInfo`, `io.open`, `getText_boxInfo`, `loadLevel`, `start`, `load`.
- **Reusable:** no

### loop
- **Does:** Implements the main control loop for the iFly level, handling input, mouse interactions, and writing the controls script file.
- **Uses:** `load`, `loadLevel`, `input`, `gSelBox`, `setText_boxInfo`, `boxes`, `keys`, `gMSpeed`, `gMouseSpeed`, `gMouseMax`, `gMouseMin`, `numberToMinusSigns`, `click`, `mouseCoords`, `getText_boxInfo`, `mouseInBox`, `getSceneInfo`, `io.open`, `load`, `start`.
- **Reusable:** no

### loop
- **Does:** nothing
- **Uses:** nothing
- **Reusable:** no
