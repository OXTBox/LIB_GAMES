<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapperwModels.fl (model spark-x2.6-4b, 2026-11-12 22:26). DRAFT for Claude to review. -->

## DungeonMapperwModels.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface designer source for the DungeonMapper 3D game tool, defining the window, menus, browser, and tool widgets plus their Lua callbacks that drive map editing and level loading. It wires the FLUID UI structure to the engine's object and level management calls used by the DungeonMapper tool.
- **Depends on:** `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_global.lua` (via `resetDSB`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `resetDSB`), `Data/Scripts/Convert/DS

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 19

### make_window
- **Does:** Opens the DungeonMapper FLTK window and sets up the level editing state, grid parameters, object/path collections, and file path variables for the map editor.
- **Uses:** `ig3d_SetMode_i`, `math.random`, `dofile`, `loadstring`, `CBI`, `CBO`, `gameroot`, `lfs`-style path concatenation via `..`, `loadLevel` (commented out), `make_window` widget definition, and local variables defined within the function.
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Defines the FLTK data file header and the `make_window` function body that opens the UI and initializes editor state.
- **Uses:** `version`, `header_name`, `code_name`, `Function`, `code`, `Q`, `CBI`, `CBO`, `make_window`, `open`, `--` comments.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 19

### Top level
- **Does:** Contains the file-level setup and global state declarations for the DungeonMapper Fluid UI part, including the `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, and `BtnListBrowserIndex` globals.
- **Uses:** Globals `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, `BtnListBrowserIndex`; no engine calls, files or Data/ paths.

### gridInsertDraw
- **Does:** Inserts a grid coordinate into the button list, a text map coordinate, and a button list XY coordinate, then sets a serial index value in the text array for the grid cell.
- **Uses:** Globals `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`; no engine calls, files or Data/ paths.
- **Reusable:** yes - pure data table manipulation and index assignment.

### BtnBrowserListMaps
- **Does:** Clears the browser button list, adds each index from the `dsbtext2map` table as a string, redraws the browser, and selects the current level in the button list.
- **Uses:** Globals `BtnBrowser`, `BtnListBrowser`, `currentLevel`, `dsbtext2map`; no engine calls, files or Data/ paths.
- **Reusable:** yes - data table iteration and UI selection logic.

### ulistBtnList
- **Does:** Builds a button list from the grid button XY coordinates, tracks the selected button index, redraws the browser, and restores the last selection if it is valid.
- **Uses:** Globals `God`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `DungeonMapperWindow`, `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`; no engine calls, files or Data/ paths.
- **Reusable:** yes - data table iteration and UI selection logic.

## Part 3 of 19

### Top level
- **Does:** Contains the file-level code blocks and widget-related definitions that precede the listed functions, including the trailing `end} {}` marker.
- **Uses:** nothing
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event of the list browser button by invoking the list browser control function.
- **Uses:** `uBtnListBrowserControl()` (via `ulistBtnList()`), `w` (the clicked widget parameter)
- **Reusable:** no

### uBtnListBrowserControlClicked
- **Does:** Handles the click event of the list browser button, tracking click timing and selection state, and either triggering the double-click handler or loading the selected map level.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `time()`, `MapListCurrentPick(n)`, `uBtnListbrowserControlDoubleClicked(w)`
- **Reusable:** no

### updateCurrentLevelMap
- **Does:** Builds a text table string from the current level's text array, then if the level map table exists, generates a new string table from it and executes it.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `CBI`, `CBO`, `loadstring`, `makenewdsbtext()`
- **Reusable:** no

### saveBSDMAP
- **Does:** Not defined in the provided code; no implementation is shown.
- **Uses:** nothing
- **Reusable:** no

## Part 4 of 19

### saveBSDMAP
- **Does:** Saves the current map text array into a Lua file, writing a formatted string into the file and closing it.
- **Uses:** `MapTextFld:clear()`, `MapTextWindow:show()`, `chooseFile`, `io.open`, `gMapPath`, `gMapFile`, `gMapName`, `textArray`, `MapTextFld:add`, `MapTextWindow:redraw`, `dsb_text2map`, `gMapOutFile`, `fileShortNameFromPath`
- **Reusable:** yes
- **Procedural:** no

### saveMapDSBInsertTextMapOut
- **Does:** Writes a generated Lua table file for the current level, appends the map text array to it, inserts the table into `dsbtext2map`, closes the file, and loads the generated file.
- **Uses:** `currentLevel`, `gMapName`, `DSBMap2TEXTOutFile`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `dofile`, `gMapOutFile`, `io.open`
- **Reusable:** yes
- **Procedural:** yes

### Top level
- **Does:** No top-level code outside the two functions is present in this part.
- **Uses:** nothing
- **Reusable:** n/a

## Part 5 of 19

### saveMappedXY
- **Does:** Writes the mapped level data (text map, enemies, friends, button colors) to a file, building each section as a comma-separated string and trimming the trailing separator before writing.
- **Uses:** Globals `currentLevel`, `textmapXY`, `gMapEnemy`, `gMapFriend`, `gMapButtonColors`, `gMapFile`, plus string operations (`string.sub`) and `io.open`/`io.close` for file writing.
- **Reusable:** yes - pure data serialization logic that can be adapted for other mapped level data sets.
- **Procedural:** no

### wClose
- **Does:** Hides the given FLTK window and sets it to nil.
- **Uses:** Nothing from the engine, globals, files or `Data/` paths; operates on the passed window argument.
- **Reusable:** yes - simple widget cleanup helper.
- **Procedural:** no

### fastquickquad
- **Does:** Scales the input coordinates by grid size, loads walls/floor if not already loaded, copies the floor, centers the mesh, adjusts camera position and facing, shows all objects, and refreshes the current level's pick list.
- **Uses:** Engine calls `loadTheWalls`, `loadTheFloor`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`; globals `TheFloor`, `WEWall`, `NSWall`, `gridSize`, `currentLevel`; parameters `x`, `y`.
- **Reusable:** no - level-specific mapping interaction logic.
- **Procedural:** no

## Part 6 of 19

### Top level
- **Does:** Contains the file-level code blocks and widget/setup context for the DungeonMapper Fluid UI file, including the `code {-- startGrid` and `code {-- quadGrid` markers that frame the embedded Lua sections.
- **Uses:** nothing
- **Reusable:** no

### quickquad
- **Does:** Builds the wall and floor grid for the current level by iterating over quadwalls, copying wall meshes or floor meshes at grid positions, adjusting camera position and facing for wall faces, and clearing floor/roof copy actions for non-wall faces.
- **Uses:** `MapListCurrentPick`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `GridSize`, `GridSpread`, `x1y1`, `DungeonMapperWindow`
- **Reusable:** no

### startGrid
- **Does:** Populates the grid button layout by iterating over grid positions, generating FLTK button code for each cell, creating the buttons via `loadstring`, and updating the button color and UI state after population.
- **Uses:** `textArray`, `btnListXY`, `math.random`, `fltk.fl_color`, `tostring`, `loadstring`, `GridSize`, `GridSpread`, `Q`, `keeper`, `DungeonMapperWindow`, `x1y1`
- **Reusable:** no

### stackcb
- **Does:** Handles the space key event to show the color map, refreshes the UI, and checks for pending FLTK events.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `fltk_update`, `Fl:check`, `nc`, `newcolor`
- **Reusable:** no

## Part 7 of 19

### Top level
- **Does:** Contains the file-level setup and widget/code blocks for the DungeonMapper Fluid UI, including the `code` block containing `resetAllButtons` and the `code` block for `recolorMapButtons`.
- **Uses:** `loadstring`, `ClearAllButtons`, `baseBtnColor`, `GridSize` (implicitly via the loop bounds in `resetAllButtons`), and the FLUID UI `code`/`callback` structure.
- **Reusable:** no

### quadGrid
- **Does:** Builds the current level map by parsing the level text into a grid, deleting the existing mesh, loading wall/floor models, copying them to grid positions based on face type, and rendering the result.
- **Uses:** `updateCurrentLevelMap`, `parseText2Map`, `currentLevel`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `loadAModelTemplate`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `theDropMeshTagNumber`, `icopyModelWalls`, `icopyModelFloors`, `render`, `loadCubeWalls`, `loadTheWalls`, `loadTheFloor`, `loadAModelTemplate`, `Data/` paths referenced via `Misc/SnowMound2x2.wtf`.
- **Reusable:** no

### resetAllButtons
- **Does:** Recreates the button color string for every grid cell, builds a Lua string containing those color assignments, and loads it as a string to clear all map buttons to the base button color.
- **Uses:** `GridSize`, `baseBtnColor`, `loadstring`, `ClearAllButtons`, FLUID UI `code` block structure.
- **Reusable:** yes
- **Procedural:** no

## Part 8 of 19

### Top level
- **Does:** Contains the file-level continuation structure and the `code {-- resetMapper` marker, with no executable function definitions outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### recolorMapButtons
- **Does:** Recolors map buttons by matching each button level against the current level, then loads and runs a generated string-based recolor script for matching buttons.
- **Uses:** `gMapButtonColors`, `currentLevel`, `gMapButtonColors`, `ReColorAllButtons`, `loadstring`, `print`
- **Reusable:** no
- **Procedural:** no

### resetGrid
- **Does:** Resets the grid text array to zeros and initializes button coordinate and text coordinate tracking variables.
- **Uses:** `GridSize`, `textArray`
- **Reusable:** yes
- **Procedural:** no

### resetDSB
- **Does:** Initializes DSB-related state variables, loads the DSB conversion scripts, and prepares the DSB spawn and text mapping structures.
- **Uses:** `GridSize`, `gameroot`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `newbsdtext2Map`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 19

### Top level
- **Does:** Contains the continuation of the file after the listed functions, including the `openMapFiles` code block that begins the file's remaining content.
- **Uses:** nothing
- **Reusable:** no

### resetMapper
- **Does:** Resets the DungeonMapper state by setting grid and cube dimensions, clearing wall and group references, initializing empty dictionaries for buttons and grids, clearing buttons, resetting the grid, recoloring map buttons, and triggering the DungeonMapperWindow redraw.
- **Uses:** `ClearAllButtons()`, `resetGrid()`, `recolorMapButtons()`, `DungeonMapperWindow:redraw()`
- **Reusable:** no

### parseTextMapXY
- **Does:** Parses the text map coordinate pairs, clamps each coordinate to the grid size, builds a button identifier from the clamped coordinates, and executes the corresponding button color change action if the DungeonMapperWindow exists.
- **Uses:** `GridSize`, `textmapXY`, `DungeonMapperWindow`, `loadstring()`, `tostring()`, `tonumber()`
- **Reusable:** yes

### MapListCurrentPick
- **Does:** Selects a current level, resets the mapper state, updates the current level map, resets all buttons, parses the level's text map, recolorizes map buttons, and triggers a UI update.
- **Uses:** `currentLevel`, `resetMapper()`, `updateCurrentLevelMap()`, `resetAllButtons()`, `parseText2Map()`, `recolorMapButtons()`, `fltk_update()`
- **Reusable:** no

### openMapFiles
- **Does:** Contains the opening of the `openMapFiles` code block that begins the file's remaining content.
- **Uses:** nothing
- **Reusable:** no

## Part 10 of 19

### openMapFiles
- **Does:** Opens a Lua map file, resets mapper and DSB state, builds the map grid from the loaded level map, generates the DSB text table, and updates the DungeonMapper window.
- **Uses:** `chooseFile`, `tTitle`, `gMapPath`, `gameroot`, `string.sub`, `string.find`, `resetMapper`, `resetDSB`, `dofile`, `GridSize`, `levelmapXY`, `dsbtext2map`, `zeromap`, `zeroline`, `gridInsertDraw`, `string.rep`, `CBI`, `CBO`, `loadstring`, `fileShortNameFromPath`, `BtnBrowserListMaps`, `parseText2Map`, `levelmapColors`, `gMapButtonColors`, `recolorMapButtons`, `DungeonMapperWindow:redraw`, plus file paths under `Data/` referenced via `gMapPath` and `gameroot`.
- **Reusable:** no
- **Procedural:** yes - it generates a map grid table and DSB text table from the loaded map file contents.

### Top level
- **Does:** Contains the trailing FLUID widget definition block for the DungeonToolListBrowser callback, which is outside the `openMapFiles` function.
- **Uses:** `DungeonToolListBrowserCB` (widget callback block context from the FLUID file).
- **Reusable:** no

## Part 11 of 19

### Top level
- **Does:** Contains the file-level code block for the DungeonMapper Fluid UI, including the `updateDungeonToolListBrowser` function and the trailing `eraserTool` code block marker.
- **Uses:** nothing
- **Reusable:** no

### DungeonToolListBrowserCB
- **Does:** Updates the current level map, parses the current level text into the map, reads the selected tool number from the browser widget, refreshes the current tool window, and populates the tool options browser with the selected tool's options (brush size adjustments, friend and enemy entity values).
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `gMapRNDFriend`, `gMapRNDEnemy`, `DungeonTools`, `DungeonTool`, `meshDrawBrushSize`
- **Reusable:** no

### DungeonToolOptionsBrowserCB
- **Does:** Reads the selected tool and option value, adjusts the brush size for the brush tool, clamps the brush size between 1 and 20, clears and repopulates the options browser with the brush size and plus/minus buttons, and selects the corresponding friend or enemy entity for the Friend tool.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `w:value()`, `DungeonTool`, `meshDrawBrushSize`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `gMapRNDFriend`, `gMapRNDEnemy`, `gSelectedDropEntity`
- **Reusable:** no

### updateDungeonToolListBrowser
- **Does:** Clears the tool list browser, ensures a default tool is selected if none is set, and adds every tool from the `DungeonTools` table to the browser list.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add()`, `DungeonTools`
- **Reusable:** yes

### eraserTool
- **Does:** Contains the code block marker for the eraser tool section, with no visible function or implementation code.
- **Uses:** nothing
- **Reusable:** no

## Part 12 of 19

### Top level
- **Does:** Defines the `eraserTool` function, which removes a button from `btnList`, clears its mapped text position, updates the serial coordinate, marks the coordinate as erased, loads a button color function, updates the map button color table, and refreshes the DungeonMapper window.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `baseBtnColor`, `gMapButtonColors`, `updateCurrentLevelMap`, `parseText2Map`, `DungeonMapperWindow`, `loadstring`, `GridSize`
- **Reusable:** no
- **Procedural:** no

### eraserTool
- **Does:** Executes the eraser tool logic: removes the specified button from `btnList`, clears the mapped text position in `textmapXY` and `btnListXY`, computes the serial coordinate, marks it as erased in `textArray`, loads and runs the button color function, updates `gMapButtonColors`, refreshes the current level map, and redraws the DungeonMapper window.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `baseBtnColor`, `gMapButtonColors`, `updateCurrentLevelMap`, `parseText2Map`, `DungeonMapperWindow`, `loadstring`, `GridSize`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 19

### Top level
- **Does:** Defines the `brushQuad` function that draws grid buttons for a quad of a given size and position, then updates the map and redraws the window.
- **Uses:** `GridSize`, `btnList`, `gMapButtonColors`, `gridInsertDraw`, `updateCurrentLevelMap`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow`, `currentLevel`
- **Reusable:** no
- **Procedural:** yes

### brushQuad
- **Does:** Validates the quad bounds against `GridSize`, builds the button name string from `btnList`, iterates the quad grid cells, inserts draw entries for new cells, records button color/value metadata, and refreshes the map and window.
- **Uses:** `math.floor`, `string.find`, `tostring`, `table.insert`, `GridSize`, `btnList`, `gMapButtonColors`, `gridInsertDraw`, `updateCurrentLevelMap`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow`, `currentLevel`
- **Reusable:** no
- **Procedural:** yes

## Part 14 of 19

### Top level
- **Does:** Defines the `gridcb` callback for the DungeonMapper FLTK UI, handling color selection, coordinate parsing from tooltips, and tool-specific map drawing actions.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.find()`, `string.len()`, `string.sub()`, `tonumber()`, `DungeonTool`, `eraserTool()`, `btnList`, `gridInsertDraw()`, `w:color()`, `w:value()`, `gMapButtonColors`, `updateCurrentLevelMap()`, `pathMapDraw()`, `gMapFriend`, `gMapEnemy`, `gridInsertDraw()`, `updateCurrentLevelMap()`, `quickquad()`, `brushQuad()`, `meshDrawBrushSize`, `GridSize`, `serialXY`, `Fl:check()`, and the `code {-- fillmapSaveOptionsBrowser` block marker.
- **Reusable:** no

### gridcb
- **Does:** Processes the tooltip of the current widget, optionally updates the color map when the space key is pressed, parses the tooltip to extract x and y coordinates, and dispatches the drawing action based on the active `DungeonTool` setting.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.find()`, `string.len()`, `string.sub()`, `tonumber()`, `DungeonTool`, `eraserTool()`, `btnList`, `gridInsertDraw()`, `w:color()`, `w:value()`, `gMapButtonColors`, `updateCurrentLevelMap()`, `pathMapDraw()`, `gMapFriend`, `gMapEnemy`, `gridInsertDraw()`, `updateCurrentLevelMap()`, `quickquad()`, `brushQuad()`, `meshDrawBrushSize`, `GridSize`, `serialXY`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 15 of 19

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the listed functions; the file continues with an unshown `openMapSaveWindow` section.
- **Uses:** nothing
- **Reusable:** no

### fillmapSaveOptionsBrowser
- **Does:** Rebuilds the save options browser and list from the chosen and table option lists, then restores the previously selected option index and redraws both widgets.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsAdd
- **Does:** Adds the currently selected table option to the chosen options list, then refreshes the save options browser.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `fillmapSaveOptionsBrowser`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsRemove
- **Does:** Removes the currently selected option index from the chosen options list, then refreshes the save options browser.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsChosen`, `fillmapSaveOptionsBrowser`
- **Reusable:** yes
- **Procedural:** no

### saveMapButtonClicked
- **Does:** Sets the map name from the text input, defaults it to "untitled" if empty, creates the map folder under Data/Levels if it does not exist, then saves the mapped XY coordinates.
- **Uses:** `mapNameTextInput`, `gMapName`, `folderExists`, `gameroot`, `ig3d_CreateDirectory_s`, `saveMappedXY`
- **Reusable:** no
- **Procedural:** no

### refreshMapFileLists
- **Does:** Sets the map name and path from the text input, then clears and populates the map save paths browser with the map folder, map XY Lua file, and map mesh WTF file paths.
- **Uses:** `mapNameTextInput`, `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `MapSavePathsBrowser`, `gameroot`
- **Reusable:** yes
- **Procedural:** no

### mapNameTextInputCB
- **Does:** Refreshes the map file lists when the map name text input changes.
- **Uses:** `refreshMapFileLists`
- **Reusable:** yes
- **Procedural:** no

## Part 16 of 19

### Top level
- **Does:** Defines the shared menu state tables and the menu text labels used by the mapper functions, plus the continuation of the mapper menu functions.
- **Uses:** `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`, `BtnBrowser`, `MapperMenu`, `fltk_update`
- **Reusable:** no

### openMapSaveWindow
- **Does:** Shows the MapSaveWindow, marks it as the current window, and restores the saved map name into the map name text input, then refreshes the map file lists.
- **Uses:** `MapSaveWindow:show()`, `MapSaveWindow:make_current()`, `mapNameTextInput:value(gMapName)`, `refreshMapFileLists()`
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, and Save entries, adds an empty trailing entry, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu:add()`, `MapperMenuIndex`, `table.insert()`, `MapperMenu:redraw()`
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Populates the mapper control menu with empty entries, adds the Convert to 3D entry, adds empty trailing entries, redraws the menu, and updates the FLTK interface.
- **Uses:** `MapperMenu:add()`, `MapperMenuIndex`, `table.insert()`, `MapperMenu:redraw()`, `fltk_update()`
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Resolves the pick value to a valid level, loads the current level's spawn script if available, parses the level into the map, runs the spawn and map browser setup, redraws the browser, updates the interface, and draws the quad grid.
- **Uses:** `BtnBrowser`, `BSDDungeonSpawnsOut()`, `dofile()`, `currentLevel`, `parseText2Map()`, `ButtonSpawnXY()`, `BtnBrowserListMaps()`, `BtnBrowser:redraw()`, `fltk_update()`, `quadGrid()`
- **Reusable:** no

## Part 17 of 19

### Top level
- **Does:** Defines the FLTK window and its nested scroll/group widgets for the DungeonMapper UI, with a close callback and initial label.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `Fl_Button` widget definitions; `xywh` widget properties; `callback wClose`; `label {Click Grid 256}`; `visible`; `resizable`; `size_range`; `align`.
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles the browser menu pick action, resetting the mapper and parsing the current level for "New", opening map files for "Open", opening the map save window for "Save", and saving the BSD text map for "Save BSD Text".
- **Uses:** `resetMapper()`, `newbsdtext2Map()`, `currentLevel`, `parseText2Map()`, `BtnBrowserListMaps()`, `openMapFiles()`, `openMapSaveWindow()`, `saveMapDSBInsertTextMapOut()`, `BtnBrowser` (nil check).
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Reads the menu widget label, value and text, maps the value to menu indices, and dispatches menu actions based on the selected item, including updating the current level map, parsing it, and drawing the quad grid.
- **Uses:** `w:label()`, `w:value()`, `w:text()`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick()`, `updateCurrentLevelMap()`, `parseText2Map()`, `quadGrid()`, `Fl:check()`, `io.flush()`, `BtnBrowser` (nil check).
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the mapper source menu and control menu widgets when the browser button is present.
- **Uses:** `BtnBrowser` (nil check), `fillMapperSourceMenu()`, `fillMapperControlMenu()`.
- **Reusable:** no

### DungeonMapperWindow
- **Does:** Defines the main DungeonMapper window widget with its label, close callback, geometry and resizable size range, plus nested scroll and group widgets for the window content.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `xywh`, `label {Click Grid 256}`, `callback wClose`, `resizable`, `size_range`, `align`, `visible`, `type`, `when`.
- **Reusable:** no

## Part 18 of 19

### Top level
- **Does:** Defines the two FLTK UI windows MapSaveWindow and BtnBrowser, including their widgets, labels, callbacks and geometry.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Input`, `Fl_Menu_Bar` widget definitions; callback names `hide`, `saveOptionsAdd`, `saveOptionsRemove`, `mapNameTextInputCB`, `saveMapButtonClicked`, `Mapper_menu_callback`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`; `Data/` paths referenced by widget labels (`Levels/`); nothing else.
- **Reusable:** no

### MapSaveWindow
- **Does:** Builds the Save Map window containing the map name input, save option browser and buttons, and the paths browser.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Input` widget definitions; callback names `mapNameTextInputCB`, `saveOptionsAdd`, `saveOptionsRemove`, `saveMapButtonClicked`; `Data/` path label `Levels/`; nothing else.
- **Reusable:** no

### BtnBrowser
- **Does:** Builds the BtnBrowser window containing the mapper menu bar, tool list browser, button list browser and tool options browser.
- **Uses:** `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser` widget definitions; callback names `Mapper_menu_callback`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`; nothing else.
- **Reusable:** no

## Part 19 of 19

### Top level
- **Does:** Defines the `MapTextWindow` FLTK window with its child browser field, then runs setup and update code inside its code blocks.
- **Uses:** `Fl_Window`, `Fl_Browser` (FLTK UI widgets), `MapTextWindow`, `MapTextFld`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `MapSaveWindow:hide()`, `BtnBrowser:show()`, `BtnBrowserListMaps()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`, `DungeonMapperWindow:show()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`
- **Reusable:** no

### MapTextWindow
- **Does:** Creates the `MapTextWindow` FLTK window with a `Double` type and specified size range, containing a `Hold` type `Fl_Browser` named `MapTextFld` sized to match the window, and wires its code blocks to setup and update logic.
- **Uses:** `Fl_Window`, `xywh`, `type`, `hide`, `resizable`, `size_range`, `Fl_Browser`, `xywh`, `type`, `labelsize`, `textsize`, `code`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `MapSaveWindow:hide()`, `BtnBrowser:show()`, `BtnBrowserListMaps()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`, `DungeonMapperWindow:show()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`
- **Reusable:** no
