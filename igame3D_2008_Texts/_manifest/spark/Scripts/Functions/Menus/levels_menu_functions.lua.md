<!-- Spark first-look of Data/Scripts/Functions/Menus/levels_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:17). DRAFT for Claude to review. -->

## levels_menu_functions.lua
- **Kind:** level-script
- **Purpose:** This file defines the functions that drive the Levels menu UI, including building the menu from level folders, handling menu actions such as restarting, clearing scenes, exiting menus, and saving levels. It also contains the level save and save-as logic used when interacting with level selection screens.
- **Depends on:** `Data/` folder structure and `Data/Levels/` folder scanning, `dofile` for loading level scripts, globals set elsewhere such as `menuIndexCount`, `mainMenuIndex`, `menuBar`, `game_func`, `askLevel`, `asksaveLevel`, `levelStateFile`, `levelState`, `gameroot`, `tLevel`, `levelPath`, `IG3D_LEVEL_MESH`, and engine calls like `getSceneInfo`, `loadLevel`, `ig3d_GetLevelName__s`, `setSceneInfo`, `saveMesh`, `saveLevel`, `OPEN_UI_WINDOWS`.
- **Provides:** `LevelsMenuText` table, `fill_LevelsMenu`, `exittomenu`, `restartbutton`, `clearsceneClicked`, `newLevel`, `save_levelState`, `save_levelMesh`, `save_level`, `saveAsNewLevel`, `levelMenuPick`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** yes - it generates menu entries by scanning the `Data/Levels/` folder contents and mapping level folders to menu lines, and builds level mesh file paths from the current level name.
- **Glossary:**
  - `LevelsMenuText - Table holding the text content used to populate the Levels menu UI.`
  - `mainMenuIndex - Global tracking the indices of level entries in the menu bar.`
  - `askLevel - Global flag indicating whether the level selection UI has been requested.`
  - `asksaveLevel - Global flag indicating whether a save-as level dialog is already open.`
  - `IG3D_LEVEL_MESH - Engine constant naming the level mesh property being set.`
  - `loadLevel - Engine call that switches the active level.`
  - `saveMesh - Engine call that saves the level mesh file.`
- **Keep / port / drop:** keep - it is a complete, reusable reference for building and handling level menu interactions in a new engine.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the `LevelsMenuText` table and the function `fill_LevelsMenu`, which builds the Levels menu by scanning the `Data/Levels/` folder and populating the menu bar.
- **Uses:** Engine calls (`getSceneInfo`, `lfs.dir`), globals (`menuIndexCount`, `mainMenuIndex`, `menuBar`, `oldChar`, `LevelsMenuText`), file paths (`Data/Levels/`), and `Data/` folder structure.
- **Reusable:** no
- **Procedural:** yes - it generates menu entries by scanning folder contents and mapping level folders to menu lines.

### fill_LevelsMenu
- **Does:** Builds the Levels menu by listing level folders under `Data/Levels/`, creating menu lines for each folder and tracking their indices in `mainMenuIndex`.
- **Uses:** Engine calls (`getSceneInfo`, `lfs.dir`), globals (`menuIndexCount`, `mainMenuIndex`, `menuBar`, `oldChar`, `LevelsMenuText`), file paths (`Data/Levels/`), and `Data/` folder structure.
- **Reusable:** no
- **Procedural:** yes - it generates menu entries by scanning folder contents and mapping level folders to menu lines.

### exittomenu
- **Does:** Exits the menu by loading the default level and clearing the active game function reference.
- **Uses:** Engine call (`loadLevel`), globals (`game_func`), file path (`Data/Levels/default`).
- **Reusable:** no

### restartbutton
- **Does:** Restarts the currently loaded level by reading its name, deleting the current scene, and loading that level again.
- **Uses:** Engine calls (`ig3d_GetLevelName__s`, `delete`, `loadLevel`), globals (`tLevel`).
- **Reusable:** no

### clearsceneClicked
- **Does:** Clears the current scene when the clear scene button is clicked.
- **Uses:** Engine call (`delete`), globals (`ig3d_scene`).
- **Reusable:** no

### newLevel
- **Does:** Opens the level selection UI window if the `askLevel` flag is not already set.
- **Uses:** Engine call (`OPEN_UI_WINDOWS`), global (`askLevel`).
- **Reusable:** no

### save_levelState
- **Does:** Saves the current level state script to a file named after the current level under the game root, writing the level state script contents to that file.
- **Uses:** Engine calls (`ig3d_GetLevelName__s`, `ig3d_GetStateScript__s`), globals (`levelStateFile`, `levelState`, `gameroot`), file path (`gameroot..level name/savedstate.lua`), and `Data/` folder structure.
- **Reusable:** no

## Part 2 of 2

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### save_levelMesh
- **Does:** Builds the level mesh file path from the current level name, sets the scene level mesh info to that path, and saves the mesh file.
- **Uses:** `ig3d_GetLevelName__s()`, `setSceneInfo`, `saveMesh`, globals `gameroot`, `levelPath`, `IG3D_LEVEL_MESH`
- **Reusable:** no

### save_level
- **Does:** Saves the current level mesh, checks whether the level's load script is locked, then calls the level save function.
- **Uses:** `save_levelMesh`, `ig3d_GetLevelName__s`, `io.open`, `getlineof`, `get`, `saveLevel`, globals `gameroot`, `tLevel`
- **Reusable:** no

### saveAsNewLevel
- **Does:** Opens the save-as level dialog if no save-as level is already set, otherwise shows the existing save-as level dialog.
- **Uses:** globals `asksaveLevel`, `dofile`
- **Reusable:** no

### levelMenuPick
- **Does:** Picks a level menu cell, maps the selected cell to the corresponding action, and runs that action.
- **Uses:** `item`, globals `gameroot`, `action`, `editingModeSwitch`, `clearsceneClicked`, `restartbutton`, `exittomenu`, `save_level`, `saveAsNewLevel`, `newLevel`
- **Reusable:** no
