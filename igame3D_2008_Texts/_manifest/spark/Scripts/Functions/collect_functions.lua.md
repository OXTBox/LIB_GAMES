<!-- Spark first-look of Data/Scripts/Functions/collect_functions.lua (model spark-x2.6-4b, 2026-11-12 06:37). DRAFT for Claude to review. -->

## collect_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable Lua source-processing, asset collection, and file/level management helpers for the iGame3D engine. It handles comment stripping, script analysis for referenced asset paths, file existence checks, directory creation, and copying asset folders into the game data layout. It also manages shared global state for tracking loaded files and collecting referenced assets during level or script loading.
- **Depends on:** `dofile`, `Data/` folder paths (Scripts, Levels, WTF, Fluid, Shaders, Icons), globals set elsewhere (`gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable`, `gameroot`, `game_func`, `titleWait`), and helper functions defined in the same file.
- **Provides:** `gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable`, `dofiledump`, `makedump`, `loadMeshdump`, `loadLeveldump`, `removeCommentsFromString`, `insertIfMissing`, `collectFilesFromScript`, `removeNonExistingFilesFromTable`, `createAllPathsOnTheWay`, `getRecursiveFileList`, `getListOfAllLevels`, `collectLevels`.
- **Assets it needs:** none (no specific model, image, sound, emitter, or font file names are named).
- **Procedural:** yes - generates asset path lists by scanning script text for referenced files, recursively collecting files under folders, and copying asset folders into the target Data path.
- **Glossary:**
  - `gDoFileRemember` - shared global table tracking files that have been loaded or processed, used to remember loaded file paths.
  - `gCollectSearchTable` - global search table used by collection functions to scan Lua script text for referenced file paths.
  - `Data/` - the engine's central folder holding all game assets and code, organized into Scripts, Levels, WTF, Fluid, Shaders, Icons, etc. folders.
  - `loadLevel` - engine call that switches the active game level by its Data/Levels folder path.
  - `make` - engine call that creates an object of a given kind using a file path.
  - `loadMesh` - engine call that loads a 3D mesh model from a WTF file path.
  - `lfs.dir` - LFS (Lua File System) call that lists files and directories in a given folder.
  - `lfs.attributes` - LFS call that checks the mode (file or directory) of a given path.
- **Keep / port / drop:** keep - reusable source processing and asset collection logic for building new engine asset management systems.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines the shared global state `gDoFileRemember` and its table `gDoFileRemembered`, plus the `gCollectSearchTable` search table used by the collection functions.
- **Uses:** Globals `gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable`. No engine calls, file paths or data reads/writes.

### dofiledump
- **Does:** Reads a Lua file, strips comments and rewrites dump-related function calls, then executes the resulting code. It also records the file path in the remember table when the file matches the expected name.
- **Uses:** Files read via `io.open` and `f:read("*a")`; globals `gDoFileRemember`, `gDoFileRemembered`; engine calls `loadstring` and `code()`. No `Data/` paths.
- **Reusable:** yes - the comment-stripping and call-rewriting logic is generic for Lua source processing.

### makedump
- **Does:** Records the WTF model path or emitter path in the remember table when the object kind matches, then delegates to the engine `make` call.
- **Uses:** Globals `gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable` (via shared collection logic); engine call `make`; paths built from `gameroot.."Data/WTF/"` and `gameroot..`.
- **Reusable:** yes - the path-recording and delegation pattern is reusable for asset dump collection.

### loadMeshdump
- **Does:** Records the mesh path in the remember table, then delegates to the engine `loadMesh` call.
- **Uses:** Globals `gDoFileRemember`, `gDoFileRemembered`; engine call `loadMesh`; path built from `gameroot..what`.
- **Reusable:** yes - the path-recording and delegation pattern is reusable for asset dump collection.

### loadLeveldump
- **Does:** Records the level path in the remember table, runs the level's `load script.lua` through `dofiledump`, then delegates to the engine `loadLevel` call.
- **Uses:** Globals `gDoFileRemember`, `gDoFileRemembered`; engine calls `dofiledump` and `loadLevel`; paths built from `gameroot..theFile`.
- **Reusable:** yes - the path-recording and level-loading delegation pattern is reusable for level dump collection.

### removeCommentsFromString
- **Does:** Strips comment lines and trailing comment content from a Lua string, replacing them with newlines.
- **Uses:** No engine calls, globals, files or `Data/` paths. Pure string manipulation.
- **Reusable:** yes - generic string processing logic.

### insertIfMissing
- **Does:** Checks whether an element already exists in a table, and if not, appends it to the table.
- **Uses:** No engine calls, globals, files or `Data/` paths. Pure table manipulation.
- **Reusable:** yes - generic table insertion logic.

## Part 2 of 4

### Top level
- **Does:** No top-level code outside the `collectFilesFromScript` function; the file contains only the function definition.
- **Uses:** Globals `gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable`, `gameroot`, `game_func` referenced inside the function.
- **Reusable:** no

### collectFilesFromScript
- **Does:** Recursively collects file paths referenced in a Lua script by scanning the script text against a global search table, resolving nested references, and returning a deduplicated list of full `Data/` paths.
- **Uses:** Engine calls (`io.open`, `loadstring`, `loadLevel` referenced via string replacement in the script), globals (`gDoFileRemember`, `gDoFileRemembered`, `gCollectSearchTable`, `gameroot`, `game_func`), files (`theFile` input path, `gameroot..fileList[i]` and `myRemembered[i]` recursive inputs), and `Data/` path construction.
- **Reusable:** no
- **Procedural:** yes - it generates a list of asset file paths by analyzing script content and recursive references.

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the four listed functions; the file contains only the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### removeNonExistingFilesFromTable
- **Does:** Removes entries from the provided table that do not correspond to existing readable files, then returns the cleaned table.
- **Uses:** `io.open` to test file existence; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### createAllPathsOnTheWay
- **Does:** Creates each directory along the path of the given path string, printing each created directory path as it is made.
- **Uses:** `lfs.mkdir` to create directories; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### getRecursiveFileList
- **Does:** Recursively collects all file paths under the given folder, including files and nested subdirectories, and returns them in a table.
- **Uses:** `lfs.dir` to list folder contents, `lfs.attributes` to check file/directory mode; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### getListOfAllLevels
- **Does:** Lists all level folders under the Data/Levels folder, returning their full Data/Levels path names in a table.
- **Uses:** `lfs.dir` and `lfs.attributes` to inspect folder contents; `gameroot.."Data/Levels/"` to build the folder path; no engine calls.
- **Reusable:** yes

## Part 4 of 4

### collectLevels
- **Does:** Collects files from Scripts, Icons, Fluid, Shaders folders and each level folder, then copies them into the target path while creating missing parent directories, and loads the default level after the copy.
- **Uses:** Engine calls (`getRecursiveFileList`, `loadLevel`, `fltk.fl_message`), globals (`gameroot`, `game_func`, `titleWait`), file paths under `Data/` (Scripts, Icons, Fluid, Shaders, level folders, `Data/game script.lua`, `Data/alternateRoot.txt`), and helper functions (`removeNonExistingFilesFromTable`, `collectFilesFromScript`, `insertIfMissing`, `createAllPathsOnTheWay`, `murgaLua.fileCopy`).
- **Reusable:** no - it copies asset file lists between Data folders and drives level loading, with specific folder and path dependencies.
- **Procedural:** no
