<!-- Spark first-look of Data/Scripts/Functions/Menus/file_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:14). DRAFT for Claude to review. -->

## file_menu_functions.lua
- **Kind:** ui-dialog
- **Purpose:** Defines the file menu bar for the iGame3D interface, including menu construction, file selection and loading, level naming, and script saving logic. It wires the file menu to engine load/save functions and file chooser dialogs so users can open, save, load and export game assets.
- **Depends on:** `Data/` folder paths, `gameroot` global, `fltk` UI helpers, `lfs`-style file listing helpers, engine load/save functions (`loadLevel`, `loadMesh`, `loadTexture`, `loadSound`, `loadObject`, `loadFont`, `save_level`, `save_levelMesh`, `save_levelState`, `save_screenshot`, `save_asWTF`, `save_asOBJ`, `save_as3DS`, `save_asMeshwork`), `openScript`, `exittomenu`, and `lastLoadedFile` path handling shared with `openfile`/`savefile`.
- **Provides:** `fill_FileMenu`, `openLevel`, `nameLevel`, `fileMenuPick`, `openfile`, `savefile`, `saveScript`, plus menu text labels and index tracking globals (`mainMenuIndex`, `fileMenuText`, `menuBar`, `menuIndexCount`).
- **Assets it needs:** none (no model, image, sound, emitter or font file names are referenced).
- **Procedural:** none
- **Glossary:**
  - `fltk.fl_file_chooser` - FLTK file chooser dialog used to let users select files or folders.
  - `ig3d_SetLevelName_s` - Engine call that writes a level name to the level name file under `Data/Levels`.
  - `Data/` - Folder holding all game assets and scripts, referenced by relative path in code.
  - `loadLevel` - Engine call that switches the active level by folder path.
  - `save_*` functions - Engine calls that save game assets to the `Data/` folder.
  - `lastLoadedFile` - Shared path variable tracking the most recently loaded file for reuse in file handlers.
- **Keep / port / drop:** keep - core UI logic for the file menu that other menus and game scripts depend on.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the file menu text labels, menu index tracking variables, and the menu construction logic for the file menu.
- **Uses:** Globals `mainMenuIndex`, `fileMenuText`, `menuBar`, `menuIndexCount`; no engine calls, file paths or Data/ reads/writes.
- **Reusable:** no

### fill_FileMenu
- **Does:** Builds the File menu bar by adding Open, Save, Load and Export menu lines to the menu bar and records their indices in `mainMenuIndex`.
- **Uses:** Globals `mainMenuIndex`, `fileMenuText`, `menuBar`; no engine calls, no file paths or Data/ reads/writes.
- **Reusable:** yes

### openLevel
- **Does:** Opens a file chooser dialog to select an image file.
- **Uses:** `fltk.fl_file_chooser` with the title "Choose a picture" and image file filter; no engine calls, no file paths or Data/ reads/writes.
- **Reusable:** no

### nameLevel
- **Does:** Sets the level name for a given level name by writing to the level name file under the Data/Levels folder.
- **Uses:** `ig3d_SetLevelName_s` with path `gameroot.."Data/Levels/"..levelName`; no other engine calls, globals or file reads/writes.
- **Reusable:** yes

### fileMenuPick
- **Does:** Picks a menu item from the file menu, constructs the selected file path, and dispatches to the appropriate file handler based on the selected menu section.
- **Uses:** Globals `item`, `gameroot`, `savefile`, `openfile`; no engine calls, no file paths or Data/ reads/writes.
- **Reusable:** no

## Part 2 of 3

### Top level
- **Does:** Contains the file-level setup and shared context for the two menu functions, including the repeated file icon loading and the `lastLoadedFile` path handling shared by `openfile` and `savefile`.
- **Uses:** `gameroot`, `fltk:Fl_File_Icon`, `Data/` paths, `lfs`-style file listing helpers referenced via `chooseFolder`/`chooseFile`, and engine calls such as `loadLevel`, `loadMesh`, `loadTexture`, `loadSound`, `loadObject`, `loadFont`, `OPEN_UI_WINDOWS`, `openScript`, `exittomenu`, and the `save_*` functions referenced by `savefile`.
- **Reusable:** no

### openfile
- **Does:** Opens a file based on the selected menu category, choosing the appropriate file or folder under the `Data/` folder, then loads it with the matching engine load function or opens the script editor.
- **Uses:** `gameroot`, `Data/` folder paths, `chooseFolder`, `chooseFile`, `loadLevel`, `loadMesh`, `loadTexture`, `loadSound`, `loadObject`, `loadFont`, `OPEN_UI_WINDOWS`, `openScript`, `exittomenu`, `fltk:Fl_File_Icon`, and `lastLoadedFile` path handling.
- **Reusable:** no

### savefile
- **Does:** Saves a game asset based on the selected menu category by dispatching to the matching `save_*` function for the chosen category.
- **Uses:** `gameroot`, `Data/` folder paths, and the `save_level`, `save_levelMesh`, `save_levelState`, `save_screenshot`, `save_asWTF`, `save_asOBJ`, `save_as3DS`, `save_asMeshwork` functions referenced by the menu dispatch.
- **Reusable:** no

## Part 3 of 3

### Top level

### saveScript
- **Does:** Opens a file chooser when no filename is set, writes the current script editor content to the chosen file, and returns true on success or false if the chooser is cancelled.
- **Uses:** `fltk.fl_file_chooser`, `path:label`, `closer:activate`, `io.open`, `editor:value`, `saver:deactivate`; writes to the user-selected file path.
- **Reusable:** no
- **Procedural:** no
