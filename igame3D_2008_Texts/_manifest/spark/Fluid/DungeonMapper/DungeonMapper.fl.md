<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapper.fl (model spark-x2.6-4b, 2026-11-12 21:24). DRAFT for Claude to review. -->

## DungeonMapper.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK UI designer source for the DungeonMapper tool, a window-based interface for editing dungeon maps, converting map data to mesh objects, and managing map save options. It defines the main window, map browser, tool browser, and save window widgets along with their callbacks, and drives the map editing workflow through a timer and menu callbacks.
- **Depends on:** Engine calls `ig3d_SetMode_i`, `ig3d_GetMeshCentroid__3f`, `ig3d_DeleteMesh_b`, `ig3d_SaveMesh_sf_b`, `getCameraInfo`, `setCameraInfo`, `ig3d_ShowAll`, `make`, `dofile`, `loadstring`, `loadLevel`; globals `gObjects`, `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`, `currentLevel`, `textArray`, `btnList`, `btnListXY`, `textmapXY`, `serialXY`, `GridSize`, `GridSpread`, `Q`, `x1y1`, `keeper`, `fltk`, `lfs.dir`, `murgaLua.`, `CBI`, `CBO`, `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `mapNameTextInput`, `mapNameTextInputCB`, `mapNameTextInput:value`, `MapSaveWindow`, `MapTextWindow`, `DungeonMapperWindow`, `DungeonToolOptionsBrowser`, `DungeonToolListBrowser`, `DungeonTool`, `DungeonMapperWindow:redraw`, `DungeonToolOptionsBrowser:clear`, `DungeonToolOptionsBrowser:add`, `DungeonToolOptionsBrowser:make_current`, `DungeonToolListBrowser:clear`, `DungeonToolListBrowser:add`, `BtnBrowser`, `BtnBrowserListMaps`, `BtnBrowser:redraw`, `BtnBrowser:show`, `BtnBrowserSpawnsOut`, `ButtonSpawnXY`, `MapListCurrentPick`, `MapListCurrentPick(n)`, `MapTextFld`, `MapTextWindow`, `gMapOutFile`, `DSBMap2TEXTOutFile`, `fileShortNameFromPath`, `folderExists`, `ig3d_CreateDirectory_s`, `MapSavePathsBrowser`, `MapSaveWindow:show`, `MapSaveWindow:make_current`, `MapSaveWindow:hide`, `MapTextWindow:hide`, `MapSaveWindow:redraw`, `MapSaveWindow:make_current`, `timer`, `timer:callback`, `timer:do_callback`, `MapSaveOptionsTable`, `MapSaveOptionsChosen`, `MapSaveOptionsListBrowser`, `MapSaveOptionsBrowser`, `MapSaveOptionsChosen`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `fillmapSaveOptionsBrowser`, `saveOptionsAdd`, `saveOptionsRemove`, `saveMapButtonClicked`, `refreshMapFileLists`, `mapNameTextInputCB`, `saveMapDSBInsertTextMapOut`, `saveBSDMAP`, `saveMapDSBInsertTextMapOut`, `saveMappedXY`, `convertMapXYToMesh`, `convertMeshObjectsTableToMesh`, `iBuildMeshObjectTables`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `saveAsNewLevel`, `parseTextMapXY`, `parseText2Map`, `updateCurrentLevelMap`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`,

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 21

### Top level
- **Does:** Defines the FLTK user interface file for DungeonMapper, setting its version, header name and code name metadata.
- **Uses:** nothing
- **Reusable:** no

## Part 2 of 21

### make_window
- **Does:** Opens the DungeonMapper window and sets up the initial state for the dungeon mapping workflow, including level path configuration, grid parameters, and tool lists.
- **Uses:** Engine calls `ig3d_SetMode_i`, `math.random`, `CBI`, `CBO`, `dofile`, `loadstring`; globals `gObjects`, `gameroot`, `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`; file paths `Data/Scripts/Convert/DSB_Dungeons.lua`, `/ig3d_mac_xcode/Data/Scripts/Functions/pbm_functions.lua`, `Data/Levels/<gMapName>/<gMapName>mapXY.lua`, `Data/Levels/<gMapName>/<gMapName>map_mesh.wtf`.
- **Reusable:** no
- **Procedural:** yes - generates the DSB text2Map base string and loads the DSB dungeon conversion script, plus builds the human list from zombie names and template names.

### Top level
- **Does:** Contains the setup code outside the `make_window` function, including the window open action, initial variable assignments, level path and file configuration, and the DSB conversion setup.
- **Uses:** Engine calls `ig3d_SetMode_i`, `math.random`, `dofile`, `loadstring`; globals `gObjects`, `gameroot`, `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`; file paths `Data/Scripts/Convert/DSB_Dungeons.lua`, `/ig3d_mac_xcode/Data/Scripts/Functions/pbm_functions.lua`, `Data/Levels/<gMapName>/<gMapName>mapXY.lua`, `Data/

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 3 of 21

### Top level
- **Does:** Contains the file-level setup and global state declarations for the DungeonMapper FLTK UI, including the `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, and `BtnListBrowserIndex` globals.
- **Uses:** nothing
- **Reusable:** no

### gridInsertDraw
- **Does:** Inserts a button entry and text/button coordinate entries into shared lists, computes a serial coordinate for the text array, and marks that coordinate as active.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`
- **Reusable:** no

### BtnBrowserListMaps
- **Does:** Clears the browser button list, adds entries for each map in `dsbtext2map`, triggers a redraw, and selects the current level in the browser.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `dsbtext2map`, `currentLevel`, `redraw`, `select`, `selected`, `value`
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the browser button list from the button coordinate list, preserving the last selection if valid, redraws the browser, and makes the DungeonMapper window current.
- **Uses:** `God`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DungeonMapperWindow`, `make_current`, `clear`, `add`, `select`, `value`, `selected`, `redraw`
- **Reusable:** no

## Part 4 of 21

### Top level
- **Does:** Contains the file-level code blocks and widget-related definitions that form the base of this part, including the trailing `end} {}` closing structure.
- **Uses:** nothing
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event of the list browser button by invoking `ulistBtnList()`.
- **Uses:** `ulistBtnList()`
- **Reusable:** no

### uBtnListBrowserControlClicked
- **Does:** Handles the click event of the list browser button. It returns early if the button value is 0, otherwise records the click time, checks for rapid repeated clicks using `gLastBrowserControlClick` and `gLastSelection`, triggers `MapListCurrentPick(n)` for single clicks, and updates `gLastSelection` with the current button value.
- **Uses:** `w:value()`, `os.time()`, `gLastBrowserControlClick`, `gLastSelection`, `time()`, `MapListCurrentPick(n)`
- **Reusable:** no

### updateCurrentLevelMap
- **Does:** Builds a text string from the `textArray` by concatenating elements in groups of `GridSize`, then if `currentLevel` is nil sets it to 1. If `dsbtext2map[currentLevel]` exists, constructs a table header string, builds a map table string from the grouped text, loads the string with `loadstring`, and executes it.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `CBI`, `CBO`, `loadstring`, `makenewdsbtext()`
- **Reusable:** no

### saveBSDMAP
- **Does:** Not defined in the provided code; no function body is shown for this section.
- **Uses:** nothing
- **Reusable:** no

## Part 5 of 21

### saveBSDMAP
- **Does:** Saves the current map text into a chosen Lua file, writing a generated `dsb_text2map` table entry and calling `dofile` on the map output file.
- **Uses:** `chooseFile`, `io.open`, `gMapPath`, `gMapFile`, `gMapName`, `textArray`, `MapTextFld`, `MapTextWindow`, `dsb_text2map`, `gMapOutFile`, `dofile`, `fileShortNameFromPath`
- **Reusable:** no
- **Procedural:** no

### saveMapDSBInsertTextMapOut
- **Does:** Writes the current map text and DSB map table entries to a generated Lua file under the map path, then loads that file with `dofile`.
- **Uses:** `currentLevel`, `gMapName`, `DSBMap2TEXTOutFile`, `io.open`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `dofile`, `gMapPath`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 21

### saveMappedXY
- **Does:** Writes the current level map data and mesh object data to a generated Lua file, then closes the files. It builds the map data string from the current level and map arrays, writes it to `gMapFile`, and writes the mesh object arrays to `gMapContentFile`.
- **Uses:** `gMapFile`, `gMapContentFile`, `gMapName`, `gMapContentFile`, `currentLevel`, `textmapXY`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `CBI`, `CBO`, `Q`, `gameroot`, `io.open`, `io.close`, `string.sub`, `gMeshObjectWTFs`
- **Reusable:** no
- **Procedural:** yes

### wClose
- **Does:** Hides the given FLTK window and sets it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 21

### Top level
- **Does:** Contains the file-level setup and widget/state definitions that the functions depend on, including the `startGrid` function body and the `code {-- startGrid ... }` block.
- **Uses:** `textArray`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `x1y1`, `DungeonMapperWindow`, `keeper`, `fltk`, `loadstring`, `makeabutton`, `make`, `loadTheWalls`, `loadTheFloor`, `MapListCurrentPick`, `currentLevel`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `ig3d_ShowAll`, `ig3d_DeleteMesh_b`, `gridcb`, `fltk:Fl_Button`, `fltk.FL_FLAT_BOX`, `fltk.fl_color`, `lfs.dir` (not present in this code), `murgaLua.` (not present in this code).
- **Reusable:** no

### fastquickquad
- **Does:** Builds the quickquad mesh, updates camera position and facing, and triggers the current level's map pick logic.
- **Uses:** `TheFloor`, `WEWall`, `NSWall`, `loadTheWalls`, `loadTheFloor`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `currentLevel`, `gridSize`.
- **Reusable:** no

### quickquad
- **Does:** Deletes the current mesh, loads wall and floor assets, copies them to grid positions based on quadwalls, and adjusts camera position and facing for each wall.
- **Uses:** `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`.
- **Reusable:** no

### startGrid
- **Does:** Generates a grid of buttons by iterating over grid positions, creating FLTK button widgets with callbacks, and triggers the keeper and window redraws.
- **Uses:** `textArray`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `x1y1`, `DungeonMapperWindow`, `keeper`, `fltk`, `fltk.fl_color`, `fltk:Fl_Button`, `fltk.FL_FLAT_BOX`, `loadstring`, `makeabutton`, `gridcb`, `make`, `math.random`, `tostring`, `fltk:Fl_Button`.
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 21

### Top level
- **Does:** Contains the file-level continuation structure and the `stackcb` function body, which handles the space key event by showing the color map and updating the FLTK interface.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap(nc)`, `fltk_update()`, `Fl:check()`, `newcolor`, `nc`
- **Reusable:** no

### stackcb
- **Does:** Handles the space key event: if the key is 32, shows the color map using the current color name, then updates the FLTK interface and checks for widget updates.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap(nc)`, `fltk_update()`, `Fl:check()`, `newcolor`, `nc`
- **Reusable:** no

### convertMapXYToMesh
- **Does:** Updates the current level map, parses the text into a map, saves the mapped coordinates, deletes the existing mesh, builds mesh objects from quad walls, converts the mesh objects table to a mesh, saves the mesh file, and saves the new level.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `saveMappedXY()`, `ig3d_DeleteMesh_b(true)`, `render()`, `convertMeshObjectsTableToMesh(gMapName)`, `ig3d_SaveMesh_sf_b(gMapMeshPath,100)`, `saveAsNewLevel()`, `quadwalls`, `gridSize`, `face`, `iBuildMeshObjectTables()`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `gMapName`, `gMapMeshPath`
- **Reusable:** no

### quadGrid
- **Does:** Contains the `quadGrid` code block header; no executable logic is present in this section.
- **Uses:** nothing
- **Reusable:** no

## Part 9 of 21

### Top level
- **Does:** Contains the file-level setup and widget/code blocks for DungeonMapper, including the `quadGrid` and `resetAllButtons` functions shown.
- **Uses:** `updateCurrentLevelMap`, `parseText2Map`, `currentLevel`, `quadwalls`, `gridSize`, `render`, `loadstring`, `ClearAllButtons`, `baseBtnColor`, `GridSize`, `loadLevel` (via level loading context), `Data/` paths referenced in surrounding code context.
- **Reusable:** no

### quadGrid
- **Does:** Builds the current level map by parsing the level text into the quad wall grid, deleting the existing mesh, and rendering the rebuilt map; also saves the new level as a new level.
- **Uses:** `updateCurrentLevelMap`, `parseText2Map`, `currentLevel`, `quadwalls`, `gridSize`, `render`, `ig3d_DeleteMesh_b`, `saveAsNewLevel`, `Data/` paths for level files.
- **Reusable:** no

### resetAllButtons
- **Does:** Recreates a string of button color definitions for every grid cell, loads it as a string function, and stores it in `ClearAllButtons`.
- **Uses:** `GridSize`, `baseBtnColor`, `loadstring`, `ClearAllButtons`.
- **Reusable:** yes
- **Procedural:** yes

## Part 10 of 21

### Top level
- **Does:** Contains the file-level code blocks for the Fluid/DungeonMapper `.fl` file, including the `resetGrid` and `resetDSB` function definitions and their surrounding widget/code structure.
- **Uses:** `gMapButtonColors`, `currentLevel`, `gMapButtonColors`, `ReColorAllButtons`, `GridSize`, `GridSize`, `GridSize`, `GridSize`, `newbsdtext2Map()`, `gameroot`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`
- **Reusable:** no

### recolorMapButtons
- **Does:** Recolors map buttons by matching each button level against `currentLevel`, then loads and runs a generated string to reapply the button color.
- **Uses:** `gMapButtonColors`, `currentLevel`, `gMapButtonColors`, `ReColorAllButtons`, `loadstring`, `print`
- **Reusable:** no

### resetGrid
- **Does:** Resets the grid text array to zero values for the full grid size.
- **Uses:** `GridSize`, `GridSize`, `GridSize`, `GridSize`
- **Reusable:** yes

### resetDSB
- **Does:** Initializes DSB-related state variables and loads the DSB conversion scripts from the Data folder.
- **Uses:** `GridSize`, `GridSize`, `GridSize`, `GridSize`, `newbsdtext2Map()`, `gameroot`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`
- **Reusable:** no

### resetMapper
- **Does:** Contains the code block for the `resetMapper` function, which is not fully defined in the provided code.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 11 of 21

### Top level
- **Does:** Contains the file-level continuation setup and the opening of the `openMapFiles` code block, with no function definitions beyond those listed.
- **Uses:** nothing
- **Reusable:** no

### resetMapper
- **Does:** Resets the DungeonMapper grid and button state, then triggers the window redraw. It sets grid and cube dimensions, clears wall and button references, clears the grid and button dictionaries, and calls the button reset, grid reset, button recolor, and window redraw functions.
- **Uses:** `ClearAllButtons()`, `resetGrid()`, `recolorMapButtons()`, `DungeonMapperWindow:redraw()`
- **Reusable:** no

### parseTextMapXY
- **Does:** Parses the text map coordinate pairs, clamps each coordinate to the grid size, builds a button name from the clamped coordinates, and triggers the corresponding button color change if the button exists.
- **Uses:** `GridSize`, `DungeonMapperWindow`, `loadstring`, `dsbtext2mapButtonChanges`, `#textmapXY`
- **Reusable:** no

### MapListCurrentPick
- **Does:** Selects the given level number, resets the mapper state, updates the current level map, parses the level's text map, recolors the map buttons, and refreshes the FLTK UI.
- **Uses:** `currentLevel`, `resetMapper()`, `updateCurrentLevelMap()`, `resetAllButtons()`, `parseText2Map()`, `recolorMapButtons()`, `fltk_update()`
- **Reusable:** no

## Part 12 of 21

### openMapFiles
- **Does:** Opens a Lua map file, resets mapper and DSB state, builds the level map grid, generates the DSB text table, and loads the map into the DungeonMapper window.
- **Uses:** `chooseFile`, `tTitle`, `gMapPath`, `tFile`, `gameroot`, `string.sub`, `string.find`, `resetMapper`, `resetDSB`, `dofile`, `GridSize`, `levelmapXY`, `dsbtext2map`, `zeromap`, `zeroline`, `gridInsertDraw`, `Q`, `CBI`, `CBO`, `makenewdsbtext`, `fileShortNameFromPath`, `gMapName`, `currentLevel`, `dsbtextsethead`, `currentText2MapTable`, `BtnBrowserListMaps`, `parseText2Map`, `levelmapColors`, `gMapButtonColors`, `recolorMapButtons`, `DungeonMapperWindow`, `redraw`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the trailing FLUID widget definition block for the DungeonToolListBrowser callback, which is outside the `openMapFiles` function.
- **Uses:** `code {-- DungeonToolListBrowserCB`
- **Reusable:** no

## Part 13 of 21

### Top level
- **Does:** Contains the file-level setup and widget/code blocks for the DungeonMapper FLTK interface, including the `code` blocks defining the three listed functions and the trailing `eraserTool` code block.
- **Uses:** `DungeonMapperWindow`, `DungeonToolOptionsBrowser`, `DungeonToolListBrowser`, `DungeonTools`, `humanlist`, `zombielist`, `meshDrawBrushSize`, `DungeonToolOptionsBtnVal`, `gDropModel`, `currentLevel`, `updateCurrentLevelMap`, `parseText2Map`, `DungeonTool`
- **Reusable:** no

### DungeonToolListBrowserCB
- **Does:** Handles the tool list browser callback: updates the current level map, parses the current level text to map, returns early if no valid tool number is selected, selects the current tool, switches to the tool options browser, and populates the options browser with brush size controls or the selected friend/enemy model names.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `DungeonTools`, `DungeonTool`, `DungeonToolOptionsBrowser`, `humanlist`, `zombielist`, `meshDrawBrushSize`
- **Reusable:** no

### DungeonToolOptionsBrowserCB
- **Does:** Handles the tool options browser callback: updates the current level map and parses the current level text to map, adjusts the brush size for brush tools with bounds, clears and repopulates the options browser with brush controls, and sets the drop model path for friend or enemy tools.
- **Uses:** `DungeonToolOptionsBtnVal`, `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `DungeonTool`, `meshDrawBrushSize`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `humanlist`, `zombielist`, `gDropModel`
- **Reusable:** no

### updateDungeonToolListBrowser
- **Does:** Updates the tool list browser by clearing it and adding every entry from the `DungeonTools` table, defaulting the active tool to `"map"` if it is unset.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add()`, `DungeonTools`
- **Reusable:** yes

### eraserTool
- **Does:** Contains the `eraserTool` code block with no visible function body or implementation shown in the provided code.
- **Uses:** nothing
- **Reusable:** no

## Part 14 of 21

### Top level
- **Does:** Defines the `eraserTool` function that removes a button from `btnList` and clears its mapped textbox entry when a button at coordinates `(x, y)` is selected.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `gMapButtonColors`, `baseBtnColor`, `GridSize`, `currentLevel`, `DungeonMapperWindow`, `updateCurrentLevelMap`, `parseText2Map`
- **Reusable:** no

### eraserTool
- **Does:** Removes the selected button from `btnList`, clears the corresponding `textmapXY` and `btnListXY` entries for its coordinates, updates the current level map and text-to-map mapping, then redraws the DungeonMapper window.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `gMapButtonColors`, `baseBtnColor`, `GridSize`, `currentLevel`, `DungeonMapperWindow`, `updateCurrentLevelMap`, `parseText2Map`
- **Reusable:** no
- **Procedural:** no

## Part 15 of 21

### Top level
- **Does:** Defines the `brushQuad` function and includes the FLUID `code` block for the DungeonMapper window.
- **Uses:** `GridSize`, `btnList`, `gMapButtonColors`, `gMapButtonColors`, `gridInsertDraw`, `updateCurrentLevelMap`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow`, `currentLevel`, `size`, `x`, `y`, `xb`, `yb`, `xf`, `yf`, `bs`, `s`, `nc`, `i`, `ii`, `xys`, `btnm`, `string.find`, `tostring`, `table.insert`
- **Reusable:** no

### brushQuad
- **Does:** Draws grid buttons for a quad of given size and coordinates by inserting draw entries, updating the level map, recording button color/value data, and redrawing the window.
- **Uses:** `GridSize`, `btnList`, `gMapButtonColors`, `gridInsertDraw`, `updateCurrentLevelMap`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow`, `currentLevel`, `size`, `x`, `y`, `xb`, `yb`, `xf`, `yf`, `bs`, `s`, `nc`, `i`, `ii`, `xys`, `btnm`, `string.find`, `tostring`, `table.insert`
- **Reusable:** no
- **Procedural:** no

## Part 16 of 21

### gridcb
- **Does:** Handles the grid map button callback: reads the tooltip for grid coordinates, updates the drop position, applies the active DungeonTool action, and refreshes the map.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.find()`, `string.sub()`, `tonumber()`, `gDropx`, `gDropz`, `DungeonTool`, `eraserTool()`, `btnList`, `gridSize`, `gridInsertDraw()`, `w:color()`, `w:value()`, `gMapButtonColors`, `updateCurrentLevelMap()`, `pathMapDraw()`, `gMapFriend`, `gMapEnemy`, `gDropModel`, `icopyModelWalls()`, `brushQuad()`, `meshDrawBrushSize`, `GridSize`, `serialXY`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Contains the trailing FLUID file content marker for the fillmapSaveOptionsBrowser code block, with no executable setup or global definitions in this section.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 17 of 21

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the listed functions; the file continues with an unshown `openMapSaveWindow` section.
- **Uses:** nothing
- **Reusable:** no

### fillmapSaveOptionsBrowser
- **Does:** Rebuilds the save options browser and list from the chosen and table option lists, then restores the selected option and redraws both widgets.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsAdd
- **Does:** Adds the currently selected table option to the chosen list, then refreshes the save options browser.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `fillmapSaveOptionsBrowser`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsRemove
- **Does:** Removes the currently selected option from the chosen list, then refreshes the save options browser.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `fillmapSaveOptionsBrowser`
- **Reusable:** yes
- **Procedural:** no

### saveMapButtonClicked
- **Does:** Reads the map name from the text input, defaults it to "untitled" if empty, ensures the corresponding Levels folder exists, then saves the mapped XY coordinates.
- **Uses:** `mapNameTextInput`, `gMapName`, `folderExists`, `gameroot`, `ig3d_CreateDirectory_s`, `saveMappedXY`
- **Reusable:** no
- **Procedural:** no

### refreshMapFileLists
- **Does:** Reads the current map name, builds the map path, map XY Lua file path and map mesh WTF path, then refreshes the map save paths browser with those three paths.
- **Uses:** `mapNameTextInput`, `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `MapSavePathsBrowser`, `gameroot`
- **Reusable:** yes
- **Procedural:** no

### mapNameTextInputCB
- **Does:** Refreshes the map file lists when the map name text input changes.
- **Uses:** `refreshMapFileLists`
- **Reusable:** yes
- **Procedural:** no

## Part 18 of 21

### Top level
- **Does:** Defines the shared menu state tables and the menu source text used by the mapper functions, plus the continuation of the mapper menu setup block.
- **Uses:** `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`, `BtnBrowser`, `MapperMenu:add`, `MapperMenu:redraw`, `fltk_update`
- **Reusable:** yes
- **Procedural:** no

### openMapSaveWindow
- **Does:** Shows the MapSaveWindow, marks it as the current window, and restores the saved map name into the map name text input, then refreshes the map file lists.
- **Uses:** `MapSaveWindow:show()`, `MapSaveWindow:make_current()`, `mapNameTextInput:value(gMapName)`, `refreshMapFileLists()`
- **Reusable:** no
- **Procedural:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, and Save entries, adds an empty trailing entry, and refreshes the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu:add`, `MapperMenu:redraw`, `table.insert`, `MapperMenuIndex`
- **Reusable:** yes
- **Procedural:** no

### fillMapperControlMenu
- **Does:** Populates the mapper control menu with empty entries, adds the Convert to 3D entry, adds empty trailing entries, and refreshes the menu and UI.
- **Uses:** `MapperMenu:add`, `MapperMenuIndex`, `MapperMenu:redraw`, `fltk_update`
- **Reusable:** yes
- **Procedural:** no

### MapperCurrentPick
- **Does:** Resolves the pick value, loads the current level's spawn script if available, ensures a valid current level, parses the map from the current level, and refreshes the spawn button, map browser, UI and quad grid.
- **Uses:** `BtnBrowserSpawnsOut`, `dofile`, `currentLevel`, `parseText2Map`, `ButtonSpawnXY`, `BtnBrowserListMaps`, `BtnBrowser:redraw`, `fltk_update`, `quadGrid`
- **Reusable:** no
- **Procedural:** no

## Part 19 of 21

### Top level
- **Does:** Contains no setup, globals, widget definitions, or standalone code outside the three listed functions; the file body consists solely of the three function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles the "New", "Open", "Save", and "Save BSD Text" menu choices for the mapper browser, resetting the mapper and parsing the current level map when "New" is chosen, opening map files or the map save window for the other choices.
- **Uses:** `resetMapper()`, `newbsdtext2Map()`, `currentLevel`, `parseText2Map()`, `BtnBrowserListMaps()`, `openMapFiles()`, `openMapSaveWindow()`, `saveMapDSBInsertTextMapOut()`, `BtnBrowser`
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Reads the selected menu label, value, and text from the current menu widget, maps the value to menu index values, and routes the selection: calls `MapperBrowsersMenuPick` for the "File" menu, runs the Convert flow (update current level map, parse text to map, convert map XY to mesh) when the adjacent menu item is "Convert".
- **Uses:** `BtnBrowser`, `w:label()`, `w:value()`, `w:text()`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick()`, `updateCurrentLevelMap()`, `parseText2Map()`, `currentLevel`, `convertMapXYToMesh()`, `Fl:check()`, `io.flush()`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the mapper source menu and mapper control menu when the mapper browser widget is present.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`
- **Reusable:** no

## Part 20 of 21

### Top level
- **Does:** Defines the FLTK widget structure for the DungeonMapper UI, including the main window, save window, and button browser window, with labels, callbacks, and geometry.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `Fl_Browser`, `Fl_Button`, `Fl_Input`, `Fl_Menu_Bar` widget definitions; callbacks `wClose`, `hide`, `saveOptionsAdd`, `saveOptionsRemove`, `mapNameTextInputCB`, `saveMapButtonClicked`, `Mapper_menu_callback`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`.
- **Reusable:** no

### DungeonMapperWindow
- **Does:** Defines the main DungeonMapper window with a label, close callback, scrollable content area containing a group, and resizable geometry.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group` widget definitions; callbacks `wClose`; geometry `xywh {287 312 407 408}`, `xywh {0 0 420 425}`, `xywh {331 330 452 447}`; attributes `type Double`, `when 1`, `resizable`, `size_range`, `align 5`, `visible`.
- **Reusable:** no

### MapSaveWindow
- **Does:** Defines the map save window with a label, hide callback, and browser/button/input widgets for saving maps and selecting save options.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Input` widget definitions; callbacks `hide`, `saveOptionsAdd`, `saveOptionsRemove`, `mapNameTextInputCB`, `saveMapButtonClicked`; geometry `xywh {7 298 368 129}`, `xywh {10 283 350 117}`, `xywh {225 203 135 70}`, `xywh {10 203 135 70}`, `xywh {160 203 50 20}`, `xywh {160 228 50 20}`, `xywh {46 4 309 20}`, `xywh {260 104 79 20}`, `xywh {10 38 345 61}`; attributes `type Double`, `hide`, `size_range`, `labelsize`, `textsize`, `align`, `when 1`, `labelsize 9`, `textsize 10`.
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the button browser window with a close/open callback, menu bar, and three browser widgets for selecting dungeon tools and their options.
- **Uses:** `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser` widget definitions; callbacks `wClose`, `open`, `Mapper_menu_callback`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`; geometry `xywh {6 50 228 238}`, `xywh {-5 -2 415 24}`; attributes `type Double`, `visible`, `color 38`, `labelsize 10`, `textsize 10`, `when 4`, `type Hold`.
- **Reusable:** no

## Part 21 of 21

### Top level
- **Does:** Defines the `MapTextWindow` FLTK window with its browser field and code blocks, then runs setup actions and starts a timer callback.
- **Uses:** `Fl_Window`, `Fl_Browser` widget definitions; `startGrid()`, `resetAllButtons()`, `resetDSB()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `MapSaveWindow:hide()`, `BtnBrowser:show()`, `BtnBrowserListMaps()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`, `DungeonMapperWindow:show()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`.
- **Reusable:** no

### MapTextWindow
- **Does:** Creates the `MapTextWindow` window, adds a `MapTextFld` browser field to it, and defines code blocks that run setup functions and trigger menu/tool/browser updates and timer setup.
- **Uses:** `Fl_Window`, `Fl_Browser` widget definitions; `startGrid()`, `resetAllButtons()`, `resetDSB()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `MapSaveWindow:hide()`, `BtnBrowser:show()`, `BtnBrowserListMaps()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`, `DungeonMapperWindow:show()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`.
- **Reusable:** no
