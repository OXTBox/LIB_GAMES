<!-- Spark folder manifest of Data/Levels/iFly/iFly_Options (model spark-x2.6-4b, 2026-11-12 18:40). DRAFT. -->

# Data/Levels/iFly/iFly_Options
- **Role:** This folder holds the options configuration for the iFly level. It configures the iFly options text boxes, loads the iFly title level, handles mouse clicks on the text boxes to toggle their values, and writes the selected values to a file when the save box is clicked.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script that configures iFly options text boxes, sets up the main game loop, loads the iFly title level, handles text box mouse clicks, and writes selected values to a file.
- **Shared with other folders:** Needs `loop`, `game_func`, `load`, `loadLevel`, `click`, `mouseCoords`, `gSelBox`, `gNumBoxes`, `getText_boxInfo`, `setText_boxInfo`, `getSceneInfo`, `io.open`, `start`, and the path `Data/Levels/iFly/iFly_Title`; takes `Data/Levels/iFly/iFly_options.txt` as input.
- **Procedure candidates:** The main game loop (`loop`), box hit detection (`mouseInBox`), mouse coordinate reader (`mouseCoords`), value flip (`toggled`), and the save-writing logic are code procedures that configure the level and manage its options; the options file is loaded into text boxes and written from selected values.
- **Glossary:**
  - iGame3D calls - Engine calls used to read or set object properties such as text box info, scene info, and mouse coordinates.
  - text box - A UI element in the iGame3D interface that displays text and can be toggled via mouse clicks.
  - loadLevel - Switches the game to a specific level folder.
  - mouseCoords - Reads the current mouse line and window coordinates from the scene.
  - toggled - Flips a value between "YES" and "NO" based on its current value.
  - level-script - A script file that configures level options, sets up the main game loop, and handles level-specific UI interactions.
- **Verdict:** keep - It contains the core level setup and main loop logic for iFly, which is reusable as a reference for new level scripts, and its procedures are directly relevant to level configuration and option management.
