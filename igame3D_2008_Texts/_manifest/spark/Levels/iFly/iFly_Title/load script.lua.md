<!-- Spark first-look of Data/Levels/iFly/iFly_Title/load script.lua (model spark-x2.6-4b, 2026-11-12 19:00). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file is the entry script for the iFly level. It configures the game root from scene information, loads the default level, and sets up shared game state such as the number of boxes, selected box index, title labels, level names, and the title wait and escape key handling functions.
- **Depends on:** `getSceneInfo(IG3D_ROOT)`, `loadLevel("Data/Levels/default")`, globals `gNumBoxes`, `gSelBox`, `labels`, `levels`, `game_func`, `edit_func`
- **Provides:** The game state globals and functions defined at the top level of this file, including the number of boxes, selected box index, title labels, level names, and the title wait and escape key functions.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `IG3D_ROOT` - Engine constant naming the scene property being read for the game root.
  - `loadLevel` - Engine call that switches the active level by path.
  - `gNumBoxes` - Global shared between files storing the number of boxes.
  - `gSelBox` - Global shared between files storing the selected box index.
  - `labels` - Global shared between files holding title labels.
  - `levels` - Global shared between files holding level names.
  - `game_func` - Global shared between files holding the game function.
  - `edit_func` - Global shared between files holding the edit function.
- **Keep / port / drop:** keep - it is the required entry script for the iFly level and defines core shared game state.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the game root from the scene info, loads the default level, and defines the number of boxes, selected box index, title labels, level names, and the title wait and escape key functions.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `loadLevel("Data/Levels/default")`, globals `gNumBoxes`, `gSelBox`, `labels`, `levels`, `game_func`, `edit_func`.
- **Reusable:** no
- **Procedural:** no
