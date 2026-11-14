<!-- Spark folder manifest of Data/Levels/iFly/iFly_Title (model spark-x2.6-4b, 2026-11-12 19:00). DRAFT. -->

# Data/Levels/iFly/iFly_Title
- **Role:** This folder is the entry script folder for the iFly level. It configures the game root from scene information, loads the default level, and sets up shared game state such as the number of boxes, selected box index, title labels, level names, and the title wait and escape key handling functions.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script entry script for the iFly level that configures the game root from scene information, loads the default level, and sets up shared game state including box counts, selected box index, title labels, level names, and the title wait and escape key functions.
- **Shared with other folders:** Needs `getSceneInfo(IG3D_ROOT)` and `loadLevel("Data/Levels/default")` from the engine, and uses shared globals `gNumBoxes`, `gSelBox`, `labels`, `levels`, `game_func`, `edit_func` defined at the top level of this file.
- **Procedure candidates:** The game state globals and functions defined at the top level of this file, including the number of boxes, selected box index, title labels, level names, and the title wait and escape key functions, are produced by code in this file rather than stored as separate files.
- **Glossary:**
  - `IG3D_ROOT` - Engine constant naming the scene property being read for the game root.
  - `loadLevel` - Engine call that switches the active level by path.
  - `gNumBoxes` - Global shared between files storing the number of boxes.
  - `gSelBox` - Global shared between files storing the selected box index.
  - `labels` - Global shared between files holding title labels.
  - `levels` - Global shared between files holding level names.
  - `game_func` - Global shared between files holding the game function.
  - `edit_func` - Global shared between files holding the edit function.
- **Verdict:** keep - it is the required entry script for the iFly level and defines core shared game state; the notes confirm it should be retained for porting as the level entry point.
