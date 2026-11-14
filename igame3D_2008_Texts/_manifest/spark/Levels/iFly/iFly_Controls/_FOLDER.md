<!-- Spark folder manifest of Data/Levels/iFly/iFly_Controls (model spark-x2.6-4b, 2026-11-12 18:36). DRAFT. -->

# Data/Levels/iFly/iFly_Controls
- **Role:** This folder holds the control script for the iFly level. It sets up the scene background and control text boxes, reads the older command script to fill in text and key mappings, and runs the main control loop handling input, mouse interactions, and writing the controls script file.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script that configures the iFly level controls, reads the older command script, and runs the main control loop
- **Shared with other folders:** Needs `Data/FontPngs/default32_1.png` and `Data/Levels/iFly/iFly_controls.txt`; takes `loop`, `load`, `loadLevel`, `input`, `gSelBox`, `setText_boxInfo`, `keys`, `gMSpeed`, `gMouseSpeed`, `gMouseMax`, `gMouseMin`, `numberToMinusSigns`, `click`, `mouseCoords`, `getText_boxInfo`, `boxes`, `IG3D_TEXT`, `IG3D_COLOR`, `getSceneInfo`, `io.open`, `start` from elsewhere.
- **Procedure candidates:** `loop` (the main control loop for the iFly level), `numberToMinusSigns` (builds a string of `n` minus signs), `mouseInBox` (checks if mouse coordinates fall within bounds), `mouseCoords` (reads current mouse and window coordinates from scene info) are produced by code in this file.
- **Glossary:**
  - `loop` - the main control loop for the iFly level
  - `numberToMinusSigns` - builds a string of `n` minus signs
  - `mouseInBox` - checks if mouse coordinates fall within bounds
  - `mouseCoords` - reads current mouse and window coordinates from scene info
  - `loadLevel` - engine call to switch to a level folder
  - `setText_boxInfo` - engine call to set properties of a text box
  - `getSceneInfo` - engine call to read scene properties such as mouse line and window coordinates
  - `IG3D_TEXT` - constant naming the text property being read or set
  - `IG3D_COLOR` - constant naming the color property being read or set
  - `IG3D_MOUSE_LINE` - constant naming the mouse line property being read
  - `IG3D_WINDOW_COORDS` - constant naming the window coordinates property being read
- **Verdict:** keep - it is the level control script for iFly, reusable as a reference for level control setup and looping.
