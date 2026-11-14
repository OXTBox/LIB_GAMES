<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Utilities.lua (model spark-x2.6-4b, 2026-11-12 17:46). DRAFT for Claude to review. -->

## UDG_Utilities.lua
- **Kind:** library
- **Purpose:** This file contains utility functions for the iGame3D engine, including random object and safe-place placement helpers, level text and FPS display utilities, and level listing and A* scheduling checks. It supports UDG level setup, rendering, and gameplay logic.
- **Depends on:** `Data/` folder paths, `dofile` for loading scripts, globals such as `gObjects`, `gSafePlaces`, `gStatusString`, `gTextboxFonts`, `levelmapXY`, `grid`, `gNumRowVertices`, `gNumColumnVertices`, `ListFolder`, `listFiles`, and engine calls like `getObjectInfo`, `setObjectInfo`, `setCameraInfo`, `ig3d_SetTextboxInfo_4i4f2s`, `getSceneInfo`, `setText_boxInfo`, and `RTS_print`.
- **Provides:** `udg_place_objects_randomly`, `udg_create_safe_places_randomly`, `udg_display_levelText`, `udg_display_FPS`, `udg_listLevels`, `udg_object_may_astar`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** yes - `udg_create_safe_places_randomly` generates safe place entries from the level grid coordinates, and `udg_listLevels` generates a level listing by scanning folder contents and extracting names from file names.
- **Glossary:**
  - `levelmapXY - The level map grid used to position objects and generate safe places.`
  - `gSafePlaces - A table storing generated safe place coordinates.`
  - `nextAStarTime - An object field tracking when its A* scheduling time is due.`
  - `dontPlaceRandomly - A flag disabling random object placement.`
  - `loadLevel - Switches the active level by folder path.`
  - `make/get - Engine calls used to create or retrieve objects by kind and name.`
  - `setObjectInfo - Engine call to set object property values.`
  - `setCameraInfo - Engine call to set camera property values.`
- **Keep / port / drop:** keep - reusable utility functions for random placement, level text/FPS display, level listing, and A* scheduling checks.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this part of the file.
- **Uses:** nothing
- **Reusable:** no

### udg_place_objects_randomly
- **Does:** Randomly repositions objects in the level map, and repositions the player box and camera to match the first zombie's position, but only when the level map is present and random placement is not disabled.
- **Uses:** `dontPlaceRandomly`, `levelmapXY`, `gObjects`, `crosshair`, `getObjectInfo`, `setObjectInfo`, `playerBox`, `zombies`, `setCameraInfo`, `math.random`
- **Reusable:** no

### udg_create_safe_places_randomly
- **Does:** Generates up to 20 safe place entries from the level grid, only including grid spots whose y-coordinate is below 0.2 (outside the floor), and stores their x, y and z coordinates in `gSafePlaces`.
- **Uses:** `levelmapXY`, `grid`, `gNumRowVertices`, `gNumColumnVertices`, `math.random`, `table.insert`
- **Reusable:** no

### udg_display_levelText
- **Does:** Updates the text alpha value for a level text box, then renders the selected text box with the given text, font, size and color, unless the text has already been displayed or the alpha has dropped to zero.
- **Uses:** `currentText`, `lastTexti`, `textalpha`, `gTextboxFonts`, `levelText`, `gSelectedTextBoxNum`, `ig3d_SetTextboxInfo_4i4f2s`
- **Reusable:** no

### udg_display_FPS
- **Does:** Updates the console text box with an empty string, prints the frame rate, drawn faces and status string from the scene, using the RTS console widget.
- **Uses:** `RTS_console`, `setText_boxInfo`, `getSceneInfo`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_FPS`, `IG3D_DRAWN_FACES`, `RTS_print`, `gStatusString`
- **Reusable:** no

## Part 2 of 2

### Top level

### udg_listLevels
- **Does:** Builds a list of UDG level short names by scanning the UDG level folders under the Data folder, then returns the concatenated short names.
- **Uses:** `gameroot`, `ListFolder`, `listFiles`, `string.find`, `string.sub`, `table.insert`, `print`
- **Reusable:** yes - it scans a folder structure and extracts level names from file names, reusable for similar level listing tasks.
- **Procedural:** yes - it generates a level listing by scanning folder contents and extracting names from files.

### udg_object_may_astar
- **Does:** Checks whether an object's next A* scheduling time has passed, and if so sets it to the current time plus one second and returns true; otherwise returns false.
- **Uses:** `time`, object fields `nextAStarTime`
- **Reusable:** yes - a simple time-based scheduling check that can be reused for similar object scheduling logic.
- **Procedural:** no
