<!-- Spark first-look of Data/Scripts/Functions/path_functions.lua (model spark-x2.6-4b, 2026-11-12 15:23). DRAFT for Claude to review. -->

## path_functions.lua
- **Kind:** library
- **Purpose:** Defines shared path-related state, constants, and functions for managing paths in the iGame3D engine, including rebuilding and parsing path lists and info, adding and creating paths, and drawing path vertices.
- **Depends on:** `gPathList`, `selectedPath`, `selectedPathInfo` shared globals; engine calls `ig3d_GetPathsList__s()`, `ig3d_GetPathInfo_i_s(i)`, `ig3d_SetPathInfo_is(selectedPath, tinfo)`, `ig3d_AddToPath_i(selectedPath)`, `ig3d_CreatePath_s(s)`, `ig3d_SetPathsVisible_b(true)`, `drawVertex`; `Data/` folders for Scripts/Functions and Levels are used for file loading via `dofile` and `loadLevel`.
- **Provides:** `getPathList`, `getPathInfo2`, `setPathInfo2`, `addToPath`, `newPath`, `showPaths`, `hidePaths`, `pathMapDraw`, and shared path state globals `gPathList`, `selectedPath`, `selectedPathInfo`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** yes - `getPathInfo2` parses engine path info strings into `{x,y,z}` tuple tables, and `setPathInfo2` serializes and writes path info tables to the engine; `pathMapDraw` draws vertices based on coordinate sums and updates path info.
- **Glossary:**
  - `ig3d_* calls - Engine function calls that operate on iGame3D objects, paths, or state.
  - `path list - A collection of paths managed by the engine, stored as a string and rebuilt into a table via `getPathList`.
  - `path info - Per-path data (e.g. vertex coordinates) stored as a string, parsed into tuples via `getPathInfo2` and written via `setPathInfo2`.
  - `selected path - The current path index used for operations, stored in the shared `selectedPath` global.
  - `shared globals - Names starting with `g` that are shared across files, such as `gPathList`, `selectedPath`, `selectedPathInfo`.
- **Keep / port / drop:** keep - core reusable path management logic that other files likely depend on for path editing and drawing.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the shared path-related state and constants used by the path functions, including the path list table, selected path index, and selected path info table.
- **Uses:** `gPathList`, `selectedPath`, `selectedPathInfo` (names starting with `g` are shared globals); no engine calls, files or `Data/` paths are read or written here.

### getPathList
- **Does:** Rebuilds the global path list from the engine's path list string, returning the populated table of path strings.
- **Uses:** `ig3d_GetPathsList__s()`, `getlinecount()`, `getlineof()`, `gPathList` (shared global); no files or `Data/` paths.
- **Reusable:** yes - pure data retrieval and table population logic.

### getPathInfo2
- **Does:** Reads the engine's path info string for a given path index, parses its line entries into a table of `{x,y,z}` tuples, and stores them in the selected path info table.
- **Uses:** `ig3d_GetPathInfo_i_s(i)`, `getlinecount()`, `getlineof()`, `selectedPathInfo` (shared global); no files or `Data/` paths.
- **Reusable:** yes - pure data parsing and table population logic.

### setPathInfo2
- **Does:** Appends a new `{x,y,z}` tuple to the selected path info table, serializes the full table into a string, and writes that string to the engine's path info for the selected path.
- **Uses:** `selectedPathInfo` (shared global), `ig3d_SetPathInfo_is(selectedPath, tinfo)`; no files or `Data/` paths.
- **Reusable:** yes - pure data serialization and setting logic.

### addToPath
- **Does:** Adds the current selected path to the engine's path list.
- **Uses:** `ig3d_AddToPath_i(selectedPath)`, `selectedPath` (shared global); no files or `Data/` paths.
- **Reusable:** yes - simple engine call wrapper.

### newPath
- **Does:** Creates a new path in the engine, refreshes the global path list, and sets the selected path index to the newly created path's position in the list.
- **Uses:** `ig3d_CreatePath_s(s)`, `getPathList()`, `gPathList`, `selectedPath` (shared globals); no files or `Data/` paths.
- **Reusable:** yes - simple engine call and state update logic.

### showPaths
- **Does:** Makes the paths visible in the engine.
- **Uses:** `ig3d_SetPathsVisible_b(true)`; no files or `Data/` paths.
- **Reusable:** yes - simple engine call wrapper.

### hidePaths
- **Does:** Makes the paths visible in the engine.
- **Uses:** `ig3d_SetPathsVisible_b(true)`; no files or `Data/` paths.
- **Reusable:** yes - simple engine call wrapper.

Note: `hidePaths` contains the same engine call as `showPaths`; the code as written does not hide paths, so this is described exactly as shown.

## Part 2 of 2

### Top level

### pathMapDraw
- **Does:** Draws a vertex on the selected path, marks the path visible, and updates the path info when the vertex coordinates sum to zero.
- **Uses:** `gPathList`, `newPath`, `getPathList`, `drawVertex`, `ig3d_AddToPath_i`, `ig3d_SetPathsVisible_b`, `selectedPath`, `selectedPathInfo`, `ig3d_GetPathInfo_i_s`, `ig3d_SetPathInfo_is`, `getPathInfo`, `string.find`, `string.sub`
- **Reusable:** no
- **Procedural:** no
