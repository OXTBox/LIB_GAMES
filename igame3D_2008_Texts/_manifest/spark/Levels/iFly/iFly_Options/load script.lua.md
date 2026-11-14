<!-- Spark first-look of Data/Levels/iFly/iFly_Options/load script.lua (model spark-x2.6-4b, 2026-11-12 18:39). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file configures the iFly options text boxes and sets up the main game loop for the iFly level. It loads the iFly title level, handles mouse clicks on the text boxes to toggle their values, and writes the selected values to a file when the save box is clicked.
- **Depends on:** `loop` (defined in this file), `game_func` (global), `load` (global), `loadLevel` (global), `click` (global), `mouseCoords` (defined in this file), `gSelBox` (global), `gNumBoxes` (global), `getText_boxInfo` (engine call), `setText_boxInfo` (engine call), `getSceneInfo` (engine call), `io.open` (global), `start` (global), `loadLevel` (path `Data/Levels/iFly/iFly_Title`), `Data/Levels/iFly/iFly_options.txt`
- **Provides:** `loop` (main game loop function), `mouseInBox` (box hit detection function), `mouseCoords` (mouse coordinate reader function), `toggled` (value flip function), `game_func` (assignment of the main loop function)
- **Assets it needs:** none
- **Procedural:** yes (sets the scene background color, configures text boxes, loads options file lines into text boxes, initializes box/text value arrays, sets the engine loop function)
- **Glossary:**
  - iGame3D calls - Engine calls used to read or set object properties such as text box info, scene info, and mouse coordinates.
  - text box - A UI element in the iGame3D interface that displays text and can be toggled via mouse clicks.
  - loadLevel - Switches the game to a specific level folder.
  - mouseCoords - Reads the current mouse line and window coordinates from the scene.
  - toggled - Flips a value between "YES" and "NO" based on its current value.
- **Keep / port / drop:** keep (core level setup and main loop logic for iFly, reusable as a reference for new level scripts)

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets the scene background color, creates and configures the iFly options text boxes, loads the options file lines into the text boxes, and initializes the box/text value arrays used for toggling.
- **Uses:** `setSceneInfo`, `make`, `setText_boxInfo`, `loadFont`, `getSceneInfo`, `io.lines`, globals `gNumBoxes`, `gSelBox`, `load`, `boxes`, `texts`, `vals`, `i`
- **Reusable:** no
- **Procedural:** yes

## Part 2 of 2

### Top level
- **Does:** Sets the engine loop function to `loop` and contains the one-line setup outside functions.
- **Uses:** `loop` (function defined in this part), `game_func` (global), `load`, `loadLevel`, `click`, `mouseCoords`, `gSelBox`, `gNumBoxes`, `getText_boxInfo`, `setText_boxInfo`, `getSceneInfo`, `io.open`, `getText_boxInfo`, `start` (globals referenced in code).
- **Reusable:** no

### mouseInBox
- **Does:** Returns true only when the given mouse coordinates fall inside the specified rectangular box, otherwise returns false.
- **Uses:** nothing
- **Reusable:** yes

### mouseCoords
- **Does:** Reads the current mouse line and window coordinates from the scene, returns the three coordinate values.
- **Uses:** `getSceneInfo`, `IG3D_MOUSE_LINE`, `IG3D_WINDOW_COORDS`
- **Reusable:** yes

### toggled
- **Does:** Flips a value between "YES" and "NO" based on its current value.
- **Uses:** nothing
- **Reusable:** yes

### loop
- **Does:** Runs the main game loop: loads the iFly title level when `load` is true, processes mouse clicks over text boxes to toggle their values and update their text, and writes the selected text box values to a file when the save box is clicked.
- **Uses:** `load`, `loadLevel`, `click`, `mouseCoords`, `gSelBox`, `gNumBoxes`, `getText_boxInfo`, `setText_boxInfo`, `getSceneInfo`, `io.open`, `start`, `game_func` (set at end of file), `loadLevel` (path `Data/Levels/iFly/iFly_Title`), `Data/Levels/iFly/iFly_options.txt`
- **Reusable:** no

### game_func
- **Does:** Assigns the `loop` function as the engine's main loop function.
- **Uses:** `loop`
- **Reusable:** yes
