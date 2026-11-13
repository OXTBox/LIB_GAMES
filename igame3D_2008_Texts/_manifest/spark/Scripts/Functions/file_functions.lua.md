<!-- Spark first-look of Data/Scripts/Functions/file_functions.lua (model spark-x2.6-4b, 2026-11-12 06:52). DRAFT for Claude to review. -->

## file_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable file system, path generation, script loading, and folder/file listing helpers for the iGame3D engine, along with utilities for generating FLUID UI windows, preview screenshots, and scanning script folders. It supports engine-level file operations and script management across the game's Data folder structure.
- **Depends on:** `gameroot`, `game_func`, `whatItems`, `whatPath`, `whatwindow`, `myFileName`, `whatText`, `bundleroot`, `ig3d_CreateDirectory_s`, `ListFolder`, `parseFluid`, `loadMesh`, `setSceneInfo`, `setCameraInfo`, `setLightInfo`, `setObjectInfo`, `getObjectInfo`, `loadLevel`, `gObjects`, and the `Data/` folder paths used for script, Fluid, WTF, and preview file locations.
- **Provides:** Functions for fast file path generation (`fastFilePaths`), folder/file listing (`listFolders`, `listFiles`, `isFile`, `ListFolder`, `ls`, `getFileText`), file writing (`writetoURL`, `writeafterURL`), script loading and UI handling (`go_gui`, `dofilewithoutwait`, `OPEN_UI_WINDOWS`), script scanning and parsing (`ListFolder`, `dirandsubdirs`, `getfilelist`, `getAllFoldersandFiles`, `parseScriptsForFunctions`), and WTF preview generation (`createWTFPreviewPNG`, `batchPreviewsForFolder`), plus helper globals for shared scanning state (`gFoldersFound`, `gFilesFound`, `gScriptsPath`).
- **Assets it needs:** None (no specific model, image, sound, emitter, or font file names are named; it operates on generic file paths and engine calls).
- **Procedural:** Generates WTF preview PNGs from WTF model files using engine scaling and screenshot calls, and generates FLUID UI Lua files via `parseFluid`; also generates unique file paths for directory/file naming.
- **Glossary:**
  - `Data/` - The fixed folder root where all game assets and code live, referenced by path construction for file access.
  - `dofile` - Engine call that loads a Lua file into the current script context.
  - `loadLevel` - Engine call that switches the active game level by folder path.
  - `ig3d_CreateDirectory_s` - Engine call that creates a directory under the Data folder.
  - `listFolders` / `listFiles` - Functions that list subfolders or files inside a given path using the file system listing API.
  - `parseFluid` - Engine call that parses a FLUID UI file and generates a Lua script file for it.
  - `WTF` - Folder containing 3D model files in the "iGame3D Mdl" text format.
  - `FLUID` - Folder containing FLTK UI files (`.fl` designer files plus their `.lua` scripts).
- **Keep / port / drop:** keep - Core reusable file system, path, and script listing helpers are directly useful for building new engine file operations.

## file_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable file system, path generation, script loading, and folder/file listing helpers for the iGame3D engine, along with utilities for generating FLUID UI windows, preview screenshots, and scanning script folders. It supports engine-level file operations and script management across the game's Data folder structure.
- **Depends on:** `gameroot`, `game_func`, `whatItems`, `whatPath`, `whatwindow`, `myFileName`, `whatText`, `bundleroot`, `ig3d_CreateDirectory_s`, `ListFolder`, `parseFluid`, `loadMesh`, `setSceneInfo`, `setCameraInfo`, `setLightInfo`, `setObjectInfo`, `getObjectInfo`, `loadLevel`, `gObjects`, and the `Data/` folder paths used for script, Fluid, WTF, and preview file locations.
- **Provides:** Functions for fast file path generation (`fastFilePaths`), folder/file listing (`listFolders`, `listFiles`, `isFile`, `ListFolder`, `ls`, `getFileText`), file writing (`writetoURL`, `writeafterURL`), script loading and UI handling (`go_gui`, `dofilewithoutwait`, `OPEN_UI_WINDOWS`), script scanning and parsing (`ListFolder`, `dirandsubdirs`, `getfilelist`, `getAllFoldersandFiles`, `parseScriptsForFunctions`), and WTF preview generation (`createWTFPreviewPNG`, `batchPreviewsForFolder`), plus helper globals for shared scanning state (`gFoldersFound`, `gFilesFound`, `gScriptsPath`).
- **Assets it needs:** None (no specific model, image, sound, emitter, or font file names are named; it operates on generic file paths and engine calls).
- **Procedural:** Generates WTF preview PNGs from WTF model files using engine scaling and screenshot calls, and generates FLUID UI Lua files via `parseFluid`; also generates unique file paths for directory/file naming.
- **Glossary:**
  - `Data/` - The fixed folder root where all game assets and code live, referenced by path construction for file access.
  - `dofile` - Engine call that loads a Lua file into the current script context.
  - `loadLevel` - Engine call that switches the active game level by folder path.
  - `ig3d_CreateDirectory_s` - Engine call that creates a directory under the Data folder.
  - `listFolders` / `listFiles` - Functions that list subfolders or files inside a given path using the file system listing API.
  - `parseFluid` - Engine call that parses a FLUID UI file and generates a Lua script file for it.
  - `WTF` - Folder containing 3D model files in the "iGame3D Mdl" text format.
  - `FLUID` - Folder containing FLTK UI files (`.fl` designer files plus their `.lua` scripts).
- **Keep / port / drop:** keep - Core reusable file system, path, and script listing helpers are directly useful for building new engine file operations.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Contains the file header comment and the fast file path helper functions; no setup, globals or widget definitions outside the function sections.
- **Uses:** `gameroot`, `os.time`, `lfs.dir`, `lfs.attributes`, `io.open`, `string.char` (engine/host calls and standard library functions used by the functions below).
- **Reusable:** yes - path and file listing helpers are reusable for engine file operations.

### fastFilePaths
- **Does:** Creates a directory under the Data folder for the given folder name, then builds a unique file path for the extension and returns it.
- **Uses:** `gameroot`, `ig3d_CreateDirectory_s` (engine directory creation call), `os.time` (for unique path naming), `Data/` path construction.
- **Reusable:** yes - generic directory and file path generation logic.

### listFolders
- **Does:** Lists all subfolders inside the given path, skipping the `.` and `..` entries, and returns them as a table.
- **Uses:** `lfs.dir` (file system listing), `lfs.attributes` (to check if an entry is a directory), `Data/` path construction.
- **Reusable:** yes - generic file system folder listing logic.

### folderExists
- **Does:** Checks whether a given folder name exists in the list of folders returned by `listFolders`.
- **Uses:** `listFolders` (function call), `Data/` path construction.
- **Reusable:** yes - simple existence check logic.

### listFiles
- **Does:** Lists all files inside the given path, skipping `.` and `..` entries and the `.DS_Store` file, and returns them as a table.
- **Uses:** `lfs.dir` (file system listing), `lfs.attributes` (to check if an entry is a file), `Data/` path construction.
- **Reusable:** yes - generic file system file listing logic.

### isFile
- **Does:** Checks whether the given file path is a regular file by inspecting its file mode attribute.
- **Uses:** `lfs.attributes` (file system attribute lookup), `Data/` path construction.
- **Reusable:** yes - simple file type check logic.

### writetoURL
- **Does:** Writes the given text to a file with the given name, prepending and appending newline characters, then closes the file.
- **Uses:** `io.open` (file writing call), `string.char` (newline character creation).
- **Reusable:** yes - simple text file writing logic.

## Part 2 of 5

### Top level
- **Does:** No top-level code outside the defined functions; the file only contains the four listed functions.
- **Uses:** `io.open`, `io.close`, `string.char`, `string.sub`, `string.find`, `dofile`, `isFile`, `listFolders`, `listFiles`, `table.getn`, `gameroot`, `game_func`, `whatItems`, `whatPath` as referenced in the functions.
- **Reusable:** no

### writeafterURL
- **Does:** Appends a text string to a file at the given path, separated by newline characters, then closes the file.
- **Uses:** `io.open` (opens file in append mode), `io.close`, `string.char`, `string.write`, `myFileName` (file path), `whatText` (text to append).
- **Reusable:** yes

### go_gui
- **Does:** Loads the FLUID console UI files if no window name is provided, otherwise loads the FLUID UI file and its Lua script for the specified window.
- **Uses:** `dofile`, `isFile`, `gameroot`, `whatwindow` (window name), `guicxxFile` and `guiluaFile` (computed UI file paths under `Data/Fluid/`).
- **Reusable:** yes

### dofilewithoutwait
- **Does:** Loads a Lua file without changing the current game function, then restores the original game function if one was active.
- **Uses:** `dofile`, `game_func` (global game function variable), `fileName` (file path to load).
- **Reusable:** yes

### ListFolder
- **Does:** Lists folders and files under a given path, returning either the folder list, file list, or combined list based on the `whatItems` argument.
- **Uses:** `listFolders`, `listFiles`, `table.getn`, `string.sub`, `string.find`, `gameroot`, `whatPath` (directory path), `whatItems` (item type filter), `folderCount`, `fileCount`, `folderList`, `fileList`, `folders`, `files` (local variables).
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 5

### Top level
- **Does:** No top-level code outside the defined functions; the file consists solely of the function definitions listed below.
- **Uses:** nothing
- **Reusable:** no

### ls
- **Does:** Lists the files in a given path and returns the resulting file list.
- **Uses:** engine call `ListFolder(tpath)`; no globals, files or Data/ paths read or written directly.
- **Reusable:** yes

### getFileText
- **Does:** Reads the entire contents of a file and returns it as a string.
- **Uses:** file I/O via `io.open(w, "r")` and `wf:read("*a")`; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### appreset
- **Does:** Resets the application by loading the bundler game script from the bundler root.
- **Uses:** engine call `dofile(bundleroot.."Data/game script.lua")`; no other engine calls, globals or Data/ paths.
- **Reusable:** no

### folderPath
- **Does:** Sets the custom gameroot path when requested, otherwise returns the current gameroot from the scene info.
- **Uses:** engine calls `getSceneInfo(IG3D_ROOT)`; globals `gameroot`, `bundleroot` referenced; no direct Data/ paths.
- **Reusable:** no

### OPEN_UI_WINDOWS
- **Does:** Opens a FLUID UI window by locating its .fl and .lua files, parsing the FLUID file, and loading the generated Lua file.
- **Uses:** engine calls `getSceneInfo(IG3D_ROOT)` and `dofile(LuaOutFile)`; globals `gameroot`, `FluidInFile`, `LuaOutFile`; Data/ paths built as `gameroot.."Data/Fluid/"..whichWindow.."/"..whichWindow..".fl"` and `.lua` variants; engine call `parseFluid(FluidInFile, LuaOutFile)`.
- **Reusable:** no

## Part 4 of 5

### Top level
- **Does:** Defines shared parsing state variables for scanning scripts and folders, and sets the base path for script directory scanning.
- **Uses:** Globals `gFoldersFound`, `gFilesFound`, `gScriptsPath`; path `gameroot.."Data/Scripts"`.
- **Reusable:** no

### createWTFPreviewPNG
- **Does:** Loads a WTF model, scales it to fit a 356x356 window, sets camera and light settings, then saves a screenshot PNG to the specified full image path.
- **Uses:** Engine calls `loadMesh`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshBounds__6f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetFourViews_b`, `ig3d_SetWindowBounds_4i`, `setSceneInfo`, `setCameraInfo`, `setLightInfo`, `ig3d_SetMode_i`, `ig3d_SaveScreenshot_s2bi`; globals `ig3d_scene`; file paths `thefile1` (WTF relative to root) and `thefile2` (full image path).
- **Reusable:** no

### batchPreviewsForFolder
- **Does:** Lists all files in the source folder, finds WTF files, and generates a preview PNG for each by calling createWTFPreviewPNG with the WTF path and a derived preview path.
- **Uses:** Engine calls `listFiles` (via `lfs.dir`), `createWTFPreviewPNG`; globals `gameroot`; file paths `thefolder1` (relative folder) and `thefolder2` (relative preview folder).
- **Reusable:** no

### dirandsubdirs
- **Does:** Recursively scans a given path, collects all subdirectories into the shared `gFoldersFound` global, skipping the path's own leading dot.
- **Uses:** Engine calls `lfs.dir`, `lfs.attributes`; globals `gFoldersFound`; path `tPath`.
- **Reusable:** no

## Part 5 of 5

### Top level
- **Does:** The file contains only the three listed functions; there is no setup, global definitions, or widget code outside them.
- **Uses:** `lfs.dir`, `lfs.attributes`, `dirandsubdirs`, `io.open`, `string` utilities, globals `gFilesFound`, `gFoldersFound`, `gameroot`, and `Data/` paths used for script folders.
- **Reusable:** yes - the functions operate on generic file system paths and script text, making them reusable for script-related file operations in a new engine.

### getfilelist
- **Does:** Lists Lua files in a given path, collecting their full Data/ paths into the shared gFilesFound list.
- **Uses:** `lfs.dir`, `lfs.attributes`, globals `gFilesFound` and `gameroot`, and `Data/` folder paths built from the input path.
- **Reusable:** yes - generic file listing logic that works for any script folder path.

### getAllFoldersandFiles
- **Does:** Recursively collects all folders and files under a given path, then runs getfilelist on each folder to populate gFilesFound with all Lua files found.
- **Uses:** `dirandsubdirs`, `getfilelist`, globals `gFoldersFound` and `gFilesFound`, and `Data/` folder paths derived from the input path.
- **Reusable:** yes - generic recursive folder/file collection logic for script directories.

### parseScriptsForFunctions
- **Does:** Reads all Lua files under a Scripts folder, extracts function definitions from their text, deduplicates functions by name, and prints the collected function list along with its count before returning the function output string.
- **Uses:** `io.open`, `string` utilities, globals `gFilesFound` and `gameroot`, and `Data/Scripts` path.
- **Reusable:** yes - generic script parsing and function extraction logic for Lua script folders.
- **Procedural:** no
