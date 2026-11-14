<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapper1226830pm.fl (model spark-x2.6-4b, 2026-11-12 21:55). DRAFT for Claude to review. -->

## DungeonMapper1226830pm.fl
- **Kind:** ui-dialog
- **Purpose:** This is a FLTK user interface designer file for the DungeonMapper tool, defining the window and widgets that let a programmer map dungeons and manage their levels. It wires up the browser, menu, grid editing, and map text windows, and drives the tool through its startup, reset, and redraw routines.
- **Depends on:** `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/WTF/Dungeons/` (map files), `Data/` path context for the Fluid/DungeonMapper folder, engine calls (`make_window`, `open`, `loadLevel`, `loadstring`, `dofile`, `fltk_update`, `fltk.fl_show_colormap`, `Fl:event_key`, `murgaLua.createFltkTimer`), globals (`gMapName`, `gMapFile`, `gMapOutFile`, `gBSDDungeonOutFile`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `GridSize`, `GridSpread`, `DungeonTools`, `DungeonTool`, `DungeonToolOptionsBtnVal`, `MeshDrawBrushSize`, `MapTextWindow`, `MapTextFld`, `DungeonMapperWindow`, `DungeonToolListBrowser`, `BtnListBrowser`, `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText.Source`, `currentLevel`, `currentText2MapTable`, `textArray`, `textmapXY`, `btnListXY`, `btnList`, `levelmapXY`, `selected`, `baseBtnColor`, `meshDrawBrushSize`, `Q`, `CBI`, `CBO`, `time`, `os.time`, `fileShortNameFromPath`, `chooseFile`, `io.open`, `io.close`, `io.flush`, `tonumber`, `tostring`, `string.sub`, `string.find`, `string.len`, `math.random`, `math.floor`, `loadLevel`), and globals from the DSB conversion scripts (`dsbtext2map`, `dsbtextsethead`, `newbsdtext2Map`, `listSpawnxy`, `spawnXY`, `XYSpawned`, `dsbspawn`, `spawninpack`, `exvar`, `dsbaddchampion`, `wallset`, `spawngrid`, `spawnindex`, `spawntext`, `foundindex`, `level`, `which`, `dsbtext2mapButtonChanges`, `levelmapXY`, `zeromap`, `zeroline`, `makenewdsbtext`, `BSDDungeonSpawnsOut`, `ButtonSpawnXY`, `BSDDungeonSpawnsOut`).
- **Provides:** The FLTK UI widgets and callbacks for the DungeonMapper tool, including `DungeonMapperWindow`, `BtnBrowser`, `BtnListBrowser`, `DungeonToolListBrowser`, `DungeonToolOptionsBtn`, `MapTextWindow`, `MapTextFld`, and the menu callback `Mapper_menu_callback`; the tool functions that drive the UI, such as `startGrid`, `resetAllButtons`, `resetDSB`, `resetMapper`, `parseText2Map`, `parseTextMapXY`, `updateCurrentLevelMap`, `saveMappedXY`, `saveMapDSBInsertTextMapOut`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonToolListBrowser`, `updateDungeonTool

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 13

### Top level
- **Does:** Defines the file-level setup for the DungeonMapper FLTK UI, including window creation parameters, global UI state variables, and the initial load of the DSB dungeon conversion script.
- **Uses:** `make_window`, `open`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`, `CBI`, `CBO`, `math.random`, `loadstring`, `loadLevel` (referenced in commented code), `gMapName`, `gMapFile`, `gMapOutFile`, `gBSDDungeonOutFile`, `GridSize`, `GridSpread`, `DungeonTools`, `DungeonTool`, and the UI state tables/variables defined in the code.
- **Reusable:** no

### make_window
- **Does:** Creates the main FLTK window for the DungeonMapper UI with the specified version, header and code file names, and opens it.
- **Uses:** `make_window`, `open`, `header_name`, `header_name {.h}`, `code_name`, `code_name {.cxx}`, `version 1.0108`.
- **Reusable:** yes

### gridInsertDraw
- **Does:** Adds a grid cell to the UI button list, text map coordinates, and button list coordinates, and marks the corresponding serial coordinate as occupied in the text array.
- **Uses:** `table.insert`, `textArray`, `GridSize`, `btnList`, `textmapXY`, `btnListXY`, `x`, `y`.
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 13

### Top level
- **Does:** Contains the shared setup code for the DungeonMapper1226830pm FLUID file, including the `code` block that defines browser control state variables and the `uBtnList BROWSER CODE AHEAD 1129` comment.
- **Uses:** Globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, plus widgets `BtnListBrowser`, `BtnBrowser`, `DungeonMapperWindow`.
- **Reusable:** no

### BtnBrowserListMaps
- **Does:** Clears the map browser list, populates it with entries numbered 1 through `\#dsbtext2map`, and triggers a redraw of the browser widget.
- **Uses:** Globals `BtnBrowser`, `BtnListBrowser`, `dsbtext2map`.
- **Reusable:** yes

### ulistBtnList
- **Does:** Rebuilds the map browser list based on the current selection, filters valid button positions, tracks the selected index, and restores the previous selection if one exists.
- **Uses:** Globals `God`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `DungeonMapperWindow`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`.
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes `ulistBtnList` when the browser control is double-clicked.
- **Uses:** Globals `ulistBtnList`.
- **Reusable:** no

## Part 3 of 13

### uBtnListBrowserControlClicked
- **Does:** Handles the click on the browser control button, selecting a level from the list and tracking double-click behavior.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `MapListCurrentPick`, `time`, `os.time`
- **Reusable:** no
- **Procedural:** no

### updateCurrentLevelMap
- **Does:** Builds a map table string from the current level's text array, then loads and runs it to update the current level map.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `loadstring`, `CBI`, `CBO`, `string.sub`, `string.len`
- **Reusable:** no
- **Procedural:** no

### saveBSDMAP
- **Does:** Clears the map text field, opens a file dialog for saving, writes the level map data to the chosen file.
- **Uses:** `MapTextFld:clear()`, `MapTextWindow:show()`, `chooseFile`, `gameroot`, `io.open`, `gMapFile`, `gMapName`, `fileShortNameFromPath`, `textArray`, `MapTextFld:add()`, `MapTextWindow:redraw()`, `string.len`, `string.sub`, `io.close`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 13

### Top level
- **Does:** Contains the file's top-level code blocks and widget/setup definitions; no standalone functions beyond those listed.
- **Uses:** `code {--saveMapout}`, `code {-- wClose}`, `code {-- fastquickquad}` blocks; globals referenced in the listed functions (`currentLevel`, `gMapName`, `gMapOutFile`, `textmapXY`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `Q`, `gridSize`, `TheFloor`, `WEWall`, `NSWall`, `MapListCurrentPick`).
- **Reusable:** no

### saveMappedXY
- **Does:** Saves the mapped XY coordinates of the current level to a generated Lua map file, then closes the file handle.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `gameroot`, `io.open`, `io.close`, `textmapXY`, `CBI`, `CBO`, `string.sub`; writes to `gameroot.."Data/WTF/Dungeons/"..gMapName..currentLevel.."_ig3dmap.lua"`.
- **Reusable:** yes - pure data serialization of existing coordinate arrays into a Lua file.

### saveMapDSBInsertTextMapOut
- **Does:** Saves the DSB text map data to a generated Lua file, inserts the map table into `dsbtext2map`, loads the generated file with `dofile`, and closes the file handle.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `gameroot`, `io.open`, `io.close`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `Q`, `string.sub`, `dofile`; writes to `gameroot.."Data/WTF/Dungeons/"..gMapName..currentLevel.."_dsbtextmap.lua"`.
- **Reusable:** yes - data serialization and table insertion logic for existing map data.

### wClose
- **Does:** Hides a given FLTK window and sets it to nil.
- **Uses:** `w` (window argument); no engine calls, globals or file paths.
- **Reusable:** yes - simple UI cleanup logic.

### fastquickquad
- **Does:** Adjusts the camera position and orientation for the current level, then triggers the level pick flow.
- **Uses:** `TheFloor`, `WEWall`, `NSWall`, `loadTheWalls`, `loadTheFloor`, `gridSize`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `currentLevel`; no file paths or data reads.
- **Reusable:** no - level-specific camera setup logic tied to this engine's level system.

## Part 5 of 13

### Top level
- **Does:** Contains the file-level setup and widget/code block structure for the DungeonMapper1226830pm FLUID file, including the `code {-- startGrid` and `code {-- quadGrid` blocks that frame the function definitions.
- **Uses:** nothing
- **Reusable:** no

### quickquad
- **Does:** Builds a grid quad wall layout by loading wall and floor assets, iterating over quad wall definitions, copying walls or floors based on face direction, and adjusting camera position and face for wall quads.
- **Uses:** `MapListCurrentPick`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `IG3D_POSITION`
- **Reusable:** no

### startGrid
- **Does:** Initializes the grid button layout, generates grid button widgets with random colors, and triggers redraw of the keeper and DungeonMapperWindow widgets.
- **Uses:** `textArray`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `fltk.fl_color`, `fltk:Fl_Button`, `keeper:add`, `btnm:box`, `btnm:show`, `btnm:tooltip`, `btnm:callback`, `btnm:when`, `loadstring`, `baseBtnColor`, `x0y0:color`, `keeper:redraw`, `DungeonMapperWindow:redraw`
- **Reusable:** no

### stackcb
- **Does:** Handles the space key event to show the color map, updates the UI state, and checks for widget events.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `fltk_update`, `Fl:check`
- **Reusable:** no

## Part 6 of 13

### Top level
- **Does:** Contains the file-level setup and widget/code block definitions for the DungeonMapper1226830pm FLUID file, including the `quadGrid`, `resetAllButtons`, and `resetGrid` function blocks.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `parseText2Map`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `ClearAllButtons`, `loadstring`, `baseBtnColor`, `GridSize`, `currentLevel`, `gMapName`, `gameroot`, `WEWall`, `NSWall`, `TheFloor`, `quadwalls`, `quadGrid`, `resetAllButtons`, `resetGrid`, `btnListXY`, `textmapXY`, `textArray`
- **Reusable:** no

### quadGrid
- **Does:** Builds the wall and floor mesh for the current level by copying wall and floor geometry at grid positions, then renders and saves the resulting mesh.
- **Uses:** `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `parseText2Map`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `render`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `currentLevel`, `gMapName`, `gameroot`, `Data/WTF/Dungeons/`
- **Reusable:** no

### resetAllButtons
- **Does:** Generates a Lua string that resets all grid button colors to the base button color, then loads it as a Lua function via `loadstring` to clear all buttons.
- **Uses:** `baseBtnColor`, `GridSize`, `loadstring`, `ClearAllButtons`
- **Reusable:** yes

### resetGrid
- **Does:** Initializes empty button and text map arrays, then populates the text array with zero values for every grid position.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`, `textArray`
- **Reusable:** yes

## Part 7 of 13

### Top level
- **Does:** Contains the file-level continuation setup and the trailing `end} {}` closing marker for the preceding function section, with no independent functional logic.
- **Uses:** nothing
- **Reusable:** no

### resetDSB
- **Does:** Resets all DSB (dungeon spawn) related state variables, loads the DSB global and dungeon conversion scripts, and initializes the spawn grid structures.
- **Uses:** `dofile(gameroot.."Data/Scripts/Convert/DSB_global.lua")`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`, `newbsdtext2Map()`, globals `listSpawnxy`, `spawnXY`, `XYSpawned`, `dsbspawn`, `spawninpack`, `exvar`, `dsbaddchampion`, `dsbtext2map`, `wallset`, `spawngrid`, `spawnindex`, `spawntext`, `foundindex`, `level`, `which`
- **Reusable:** no

### resetMapper
- **Does:** Resets the DungeonMapper grid and wall state variables, clears the button lists, calls `ClearAllButtons()` and `resetGrid()`, then triggers a redraw of the DungeonMapperWindow.
- **Uses:** `ClearAllButtons()`, `resetGrid()`, `DungeonMapperWindow:redraw()`, globals `GridSize`, `GridSpread`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnList`, `cubewalls`, `quadwalls`
- **Reusable:** no

### parseTextMapXY
- **Does:** Iterates over the textmapXY coordinate pairs, clamps x and y values to GridSize, builds a button identifier, and if the DungeonMapperWindow exists, generates a string action to color the corresponding button and invokes it.
- **Uses:** `tonumber`, `tostring`, globals `textmapXY`, `GridSize`, `DungeonMapperWindow`, `dsbtext2mapButtonChanges`, `loadstring`
- **Reusable:** no

### MapListCurrentPick
- **Does:** No code for this function is provided in the given source.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 8 of 13

### MapListCurrentPick
- **Does:** Validates the selected map index, updates the current level map, resets the mapper, and parses the map text into the level map.
- **Uses:** `updateCurrentLevelMap()`, `currentLevel`, `resetMapper()`, `parseText2Map(currentLevel)`, `fltk_update()`
- **Reusable:** yes
- **Procedural:** no

### openMapFiles
- **Does:** Opens a chosen map file, resets mapper and DSB state, builds the level map grid, generates the DSB text table, and loads it into the DSB.
- **Uses:** `chooseFile(tTitle,"*.lua",gameroot.."Data/WTF/Dungeons/")`, `gMapFile`, `resetMapper()`, `resetDSB()`, `dofile(gMapFile)`, `GridSize`, `levelmapXY`, `zeromap`, `zeroline`, `textArray`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext()`, `fileShortNameFromPath(gMapFile)`, `currentLevel`, `BtnBrowserListMaps()`, `parseText2Map(currentLevel)`, `fltk_update()`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Contains the commented-out BSD spawn and map file loading fallback code block for the file.
- **Uses:** `BSDDungeonSpawnsOut()`, `dofile(f)`, `parseText2Map(currentLevel)`, `fltk_update()`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 13

### Top level
- **Does:** Contains the file-level FLUID UI structure and the `brushQuad` code block that begins the file but belongs to no listed function.
- **Uses:** nothing
- **Reusable:** no

### DungeonToolListBrowserCB
- **Does:** Selects a tool from the browser, switches the active DungeonMapper window, and for the brush tool clears and repopulates the options button with the current brush size, plus plus and minus buttons.
- **Uses:** `DungeonMapperWindow:make_current()`, `DungeonTools`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add()`, `meshDrawBrushSize`
- **Reusable:** no

### DungeonToolOptionsBtnCB
- **Does:** Stores the selected option value, adjusts the brush size by one for plus or minus selections, clamps the brush size between 1 and 20, and clears and repopulates the options button with the current brush size, plus plus and minus buttons.
- **Uses:** `DungeonToolOptionsBtnVal`, `DungeonTool`, `meshDrawBrushSize`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add()`
- **Reusable:** no

### updateDungeonToolListBrowser
- **Does:** Falls back to the map tool if no tool is set, clears the tool list browser, and adds every entry from the DungeonTools table to it.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonTools`
- **Reusable:** no

## Part 10 of 13

### Top level
- **Does:** Contains the `brushQuad` function body and trailing widget/code blocks for the DungeonMapper FLTK file.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `brushButtons`, `resetMapper`, `parseText2Map`, `currentLevel`, `selected`, `loadstring`, `string.find`, `math.floor`, `tostring`, `loadstring`
- **Reusable:** no
- **Procedural:** no

### brushQuad
- **Does:** Draws grid buttons for a quad spanning from x/y to x/y plus size, clamps the quad bounds to GridSize/0, inserts draw entries for valid grid cells, builds a button script string, loads and runs it, then resets the mapper and parses the current level map.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `brushButtons`, `resetMapper`, `parseText2Map`, `currentLevel`, `selected`, `loadstring`, `string.find`, `math.floor`, `tostring`
- **Reusable:** no
- **Procedural:** yes - generates a button script string for grid drawing and runs it to update the level map.

## Part 11 of 13

### Top level
- **Does:** Defines the `gridcb` callback and the `DungeonMapperWindow` FLTK window, including its scrollable container, group, and initial menu setup code.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `tonumber()`, `tostring()`, `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `Fl_Button` widget definitions, and the `Data/` path context for the Fluid/DungeonMapper folder.
- **Reusable:** no

### gridcb
- **Does:** Handles grid click events to update grid coordinates, color, value, and map drawing based on the active DungeonTool setting.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `tonumber()`, `tostring()`, `DungeonTool`, `gridInsertDraw()`, `w:color()`, `w:value()`, `updateCurrentLevelMap()`, `pathMapDraw()`, `brushQuad()`, `meshDrawBrushSize`, `GridSize`, `Fl:check()`.
- **Reusable:** no

### DungeonMapperWindow
- **Does:** Defines the main FLTK window for the DungeonMapper, including its label, close callback, geometry, scrollable area, group, and initial mapper menu setup variables.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `callback wClose open`, `xywh` widget geometry, and the `Data/` path context for the Fluid/DungeonMapper folder.
- **Reusable:** no

## Part 12 of 13

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the three listed functions; the file consists solely of the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the source menu with File/ entries from MapperMenuText.Source, tracks them in MapperMenuIndex, adds an empty separator line, and redraws the menu.
- **Uses:** BtnBrowser, MapperMenuText.Source, MapperMenu, MapperMenuIndex
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Adds empty separator lines to the control menu, adds a Convert/to 3D entry, tracks it in MapperMenuIndex, adds empty separators, redraws the menu, and calls fltk_update.
- **Uses:** MapperMenu, MapperMenuIndex, fltk_update
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Resets the mapper, loads the spawn file if present, sets the current level to 1 if unset, parses the level text into the map, and refreshes the spawn button, map browser, button and grid.
- **Uses:** BSDDungeonSpawnsOut, currentLevel, parseText2Map, ButtonSpawnXY, BtnBrowserListMaps, BtnBrowser, fltk_update, quadGrid
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles menu pick actions: resets and regenerates the map for New, opens map files for Open, saves the mapped XY and BSD text for the corresponding save options.
- **Uses:** resetMapper, newbsdtext2Map, currentLevel, dsbtext2map, parseText2Map, BtnBrowserListMaps, openMapFiles, saveMappedXY, saveMapDSBInsertTextMapOut
- **Reusable:** no

## Part 13 of 13

### Top level
- **Does:** Defines the top-level widget layout and startup flow for the DungeonMapper FLTK UI, including the menu bar, browser widgets, text window, and the timer setup that drives the redraw cycle.
- **Uses:** `DungeonMapperWindow`, `BtnBrowser`, `DungeonToolListBrowser`, `BtnListBrowser`, `DungeonToolOptionsBtn`, `MapTextWindow`, `MapTextFld`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `DungeonMapperWindow:show()`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `DungeonMapperWindow:redraw()`, `BtnBrowser:show()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Handles the menu bar click callback: reads the clicked menu label, current value, and text, maps them to menu index values, and acts on the selected menu item by opening the browser picker for File or calling `quadGrid()` for the Convert option.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MapperBrowsersMenuPick`, `quadGrid()`, `item(1, tIndex, "/")`, `item(1, tIndex2, "/")`, `Fl:check()`, `io.flush()`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the mapper source and control menus when the menu bar is populated, by calling the two menu fill functions.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the browser button widget with its close callback, position/size, type, and visibility settings.
- **Uses:** `callback wClose open`, `xywh {6 50 176 228}`, `type Double visible`
- **Reusable:** no

### MapTextWindow
- **Does:** Defines the text window widget with its close callback, position/size, double visibility, resizable range, and contains the text field widget.
- **Uses:** `callback wClose open`, `xywh {214 631 329 263}`, `type Double hide resizable size_range {329 263 331 579}`, `Fl_Browser MapTextFld`, `xywh {0 0 330 576}`, `type Hold labelsize 9 textsize 10 resizable`
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Defines the menu bar widget with its callback, position/size, color, and label/text size settings.
- **Uses:** `callback Mapper_menu_callback open`, `xywh {-5 -2 180 22}`, `color 38`, `labelsize 10`, `textsize 10`
- **Reusable:** no

### DungeonToolListBrowser
- **Does:** Defines the tool list browser widget with its callback, position/size, type, and label/text size settings.
- **Uses:** `callback DungeonToolListBrowserCB`, `xywh {50 30 45 190}`, `type Hold labelsize 10 textsize 10`
- **Reusable:** no

### BtnListBrowser
- **Does:** Defines the second browser widget with its callback, position/size, type, and label/text size settings.
- **Uses:** `callback uBtnListBrowserControlClicked`, `xywh {5 30 45 190}`, `type Hold labelsize 10 textsize 10`
- **Reusable:** no

### DungeonToolOptionsBtn
- **Does:** Defines the options browser widget with its callback, position/size, type, and label/text size settings.
- **Uses:** `callback DungeonToolOptionsBtnCB`, `xywh {95 30 75 190}`, `type Hold labelsize 10 textsize 10`
- **Reusable:** no

### MapTextFld
- **Does:** Defines the text field widget inside the text window with its position/size, type, label/text size, and resizable settings.
- **Uses:** `xywh {0 0 330 576}`, `type Hold labelsize 9 textsize 10 resizable`
- **Reusable:** no

### code
- **Does:** Defines the startup code block for the DungeonMapper window: shows the window, starts the grid, resets buttons and data structures, triggers a redraw, sets up the redraw timer with its callback and do_callback, and shows the browser button while hiding the text window and updating the tool list browser.
- **Uses:** `DungeonMapperWindow:show()`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `DungeonMapperWindow:redraw()`, `timer = murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `DungeonMapperWindow:show()`, `BtnBrowser:show()`, `Mapper_MenuBarFill()`, `MapTextWindow:hide()`, `updateDungeonToolListBrowser()`, `BtnBrowser:redraw()`
- **Reusable:** no
