<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapper1226830pm.lua (model spark-x2.6-4b, 2026-11-13 00:23). DRAFT for Claude to review. -->

## DungeonMapper1226830pm.lua
- **Kind:** converter
- **Purpose:** This file is the DungeonMapper tool, a converter that reads BSD text map data, maps it into a 3D dungeon grid, and writes the resulting mapped dungeon data back out. It drives the FLTK UI for browsing maps, editing grids, and saving mapped output.
- **Depends on:** files loaded via `dofile`: `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`; `Data/` paths written in: `Data/WTF/Dungeons/`, `Data/Scripts/Convert/DSB_Dungeons.lua`; engine calls and globals from other files: `dofile`, `loadLevel`, `make`, `get`, `getObjectInfo`, `setObjectInfo`, `loadstring`, `lfs.dir`, `fltk.`/`Fl_...` UI calls, `murgaLua.` host calls, `ig3d_...` engine calls, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Scroll`, `fltk:Fl_Group`,

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 14

### Top level
- **Does:** Contains the file's top-level setup code: global variable initializations, path/string constants, engine mode and object references, and the DSB dungeon conversion setup that loads `Data/Scripts/Convert/DSB_Dungeons.lua` and builds a base string for `dsbtext2Map`.
- **Uses:** Globals `Q`, `CBI`, `CBO`, `gameroot`, `gObjects`; file path `Data/Scripts/Convert/DSB_Dungeons.lua`; engine calls `dofile`; data structures `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `currentLevel`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `baseBtnColor`, `meshDrawBrushSize`, `WEWall`, `NSWall`, `TheFloor`, `gMapName`, `gMapFile`, `gMapOutFile`, `gBSDDungeonOutFile`, `dsbtext2map`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`.
- **Reusable:** no

### gridInsertDraw
- **Does:** Inserts a grid cell into the map's button list, text map coordinates, and button list coordinates, and records the cell's serial coordinate in the text array.
- **Uses:** Data structures `btnList`, `textmapXY`, `btnListXY`, `textArray`, `GridSize`; engine calls `table.insert`.
- **Reusable:** yes

### BtnBrowserListMaps
- **Does:** Clears the browser button list, adds one entry for each existing DSB dungeon map, redraws the browser, and resets the last browser control click time and selection state.
- **Uses:** Data structures `BtnListBrowser`, `dsbtext2map`; engine calls `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnBrowser:redraw()`; globals `BtnBrowser`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`.
- **Reusable:** no

### <function name>
- **Does:** Not present in this part.
- **Uses:** nothing
- **Reusable:** no

## Part 2 of 14

### ulistBtnList
- **Does:** Rebuilds the button list browser control, lists the entries from `btnListXY`, and restores the previously selected entry when the control is redrawn.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `gLastSelection`, `btnListXY`, `DungeonMapperWindow`, `gLastBrowserControlClick`, `MapListCurrentPick`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes the button list rebuild routine when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlClicked
- **Does:** Selects the clicked browser entry, and on double click within the click delay triggers the double-click handler.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `MapListCurrentPick`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 14

### updateCurrentLevelMap
- **Does:** Rebuilds the current level's text-to-map table string from `textArray`, then if a `dsbtext2map` entry exists for the current level, loads and runs it to update the map.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `CBI`, `CBO`, `string.sub`, `loadstring`, `loadLevel`-related level handling via `currentLevel`; no `Data/` paths.
- **Reusable:** yes - pure data assembly and table lookup logic.

### saveBSDMAP
- **Does:** Clears and shows the map text field, prompts for a save file, writes the level map table content to the chosen `.lua` file, and closes the file.
- **Uses:** `MapTextFld`, `MapTextWindow`, `chooseFile`, `gameroot`, `Data/WTF/Dungeons/` path, `gMapFile`, `gMapName`, `fileShortNameFromPath`, `io.open`, `gMapFile`, `textArray`, `CBI`, `CBO`, `string.len`, `string.sub`, `MapTextFld:clear`, `MapTextFld:add`, `MapTextWindow:redraw`, `io.close`.
- **Reusable:** no - depends on UI widgets and file I/O specifics.

### saveMappedXY
- **Does:** Writes the current level's mapped XY coordinates into a generated `.lua` file under `Data/WTF/Dungeons/`, closing the file after writing.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `gameroot`, `Data/WTF/Dungeons/` path, `textmapXY`, `CBI`, `CBO`, `io.open`, `io.close`.
- **Reusable:** no - depends on file I/O and level/map name state.

## Part 4 of 14

### saveMapDSBInsertTextMapOut
- **Does:** Writes the generated text map file, then loads it back with dofile so the map data is active.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `Q`, `string.len`, `string.sub`, `io.open`, `io.close`, `dofile`, `gameroot`
- **Reusable:** no
- **Procedural:** yes

### wClose
- **Does:** Hides the given FLTK window and sets it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes

### fastquickquad
- **Does:** Scales the input coordinates by gridSize, copies the floor for the scaled position, moves the camera to the mesh centroid, faces the centroid, shows all objects, and refreshes the current level pick.
- **Uses:** `TheFloor`, `WEWall`, `NSWall`, `gridSize`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `loadTheWalls`, `loadTheFloor`, `currentLevel`
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 14

### quickquad
**Does:** Builds the wall and floor grid for the current level by copying wall and floor meshes at grid positions, adjusting camera position and face for wall cells.
**Uses:** `MapListCurrentPick`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `Data/` paths referenced via engine load helpers.
**Reusable:** no

### startGrid
**Does:** Populates the grid button list by generating one FLTK button per grid cell, then triggers redraw of the keeper and DungeonMapperWindow.
**Uses:** `GridSize`, `GridSpread`, `Q`, `fltk.fl_color`, `fltk.fl_show_colormap`, `fltk.FL_FLAT_BOX`, `makeabutton`, `loadstring`, `btnListXY`, `baseBtnColor`, `x0y0:color`, `keeper:redraw`, `DungeonMapperWindow:redraw`, `gridcb`.
**Reusable:** no

### stackcb
**Does:** Handles the space key event to show the color map, then updates the FLTK UI state.
**Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `fltk_update`, `Fl:check`.
**Reusable:** no

## Part 6 of 14

### quadGrid
- **Does:** Builds the game grid by copying wall, floor and roof meshes at grid positions, then renders and saves the resulting mesh.
- **Uses:** `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `parseText2Map`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `render`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `currentLevel`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `gMapName`, `gameroot`, `Data/` paths (`Data/WTF/Dungeons/`), plus globals `quadGrid`, `resetAllButtons`, `resetGrid`
- **Reusable:** no
- **Procedural:** yes

### resetAllButtons
- **Does:** Generates a string of button color reset commands for every grid cell, loads it as a string function, and stores the result in `ClearAllButtons`.
- **Uses:** `baseBtnColor`, `GridSize`, `loadstring`, `ClearAllButtons`
- **Reusable:** yes
- **Procedural:** yes

### resetGrid
- **Does:** Initializes the grid button and text map tracking arrays, and fills the text array with zero values for every grid cell.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`, `textArray`
- **Reusable:** yes
- **Procedural:** yes

## Part 7 of 14

### resetDSB
- **Does:** Resets all DSB-related state variables and loads the DSB conversion scripts, clearing spawn and grid data structures.
- **Uses:** Globals `listSpawnxy`, `spawnXY`, `XYSpawned`, `dsbspawn`, `spawninpack`, `exvar`, `dsbaddchampion`, `dsbtext2map`, `newbsdtext2Map`, `wallset`, `spawngrid`, `spawnindex`, `spawntext`, `foundindex`, `level`, `which`, `GridSize`, `gameroot`; files `Data/Scripts/Convert/DSB_global.lua` and `Data/Scripts/Convert/DSB_Dungeons.lua` via `dofile`.
- **Reusable:** no

### resetMapper
- **Does:** Resets the DungeonMapper grid and wall state variables, clears button lists, and triggers a redraw of the DungeonMapperWindow.
- **Uses:** Globals `GridSize`, `GridSpread`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnList`, `cubewalls`, `quadwalls`, `ClearAllButtons`, `resetGrid`, `DungeonMapperWindow`.
- **Reusable:** no

### parseTextMapXY
- **Does:** Parses the text map XY coordinates, clamps values to GridSize, generates button names, and triggers color changes for existing DSB text-to-map buttons.
- **Uses:** Globals `textmapXY`, `GridSize`, `DungeonMapperWindow`, `dsbtext2mapButtonChanges`; engine calls `tonumber`, `tostring`, `loadstring`, and `loadstring`-invoked `dsbtext2mapButtonChanges()`.
- **Reusable:** no

## Part 8 of 14

### MapListCurrentPick
- **Does:** Validates the selected map number, updates the current level map, resets the mapper, parses the map text into the level map, and refreshes the FLTK UI.
- **Uses:** `updateCurrentLevelMap()`, `currentLevel`, `resetMapper()`, `parseText2Map()`, `fltk_update()`, `n`
- **Reusable:** no
- **Procedural:** no

### openMapFiles
- **Does:** Opens a chosen map file, loads it, builds the level map grid, generates the DSB text table, and refreshes the map list if the map table is non-empty.
- **Uses:** `chooseFile()`, `tTitle`, `tFile`, `gMapFile`, `gameroot`, `resetMapper()`, `resetDSB()`, `dofile()`, `GridSize`, `zeromap`, `zeroline`, `levelmapXY`, `textArray`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `fileShortNameFromPath()`, `gMapName`, `BtnBrowserListMaps()`, `parseText2Map()`, `fltk_update()`
- **Reusable:** no
- **Procedural:** yes - generates the level map grid and DSB text table from the loaded map file

## Part 9 of 14

### DungeonToolListBrowserCB
- **Does:** Returns early when the browser widget has no value or a zero value, otherwise records the selected tool number, makes the DungeonMapperWindow current, selects the matching tool from DungeonTools, and for the "brush" tool clears and repopulates the options button with the current meshDrawBrushSize, a "+" and a "-" label.
- **Uses:** `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonToolListBrowser:add`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add`, `DungeonTools`, `DungeonTool`, `DungeonToolOptionsBtn`, `meshDrawBrushSize`
- **Reusable:** no
- **Procedural:** no

### DungeonToolOptionsBtnCB
- **Does:** Records the options button value, and when the selected tool is "brush", adjusts meshDrawBrushSize by one depending on the recorded value, clamps meshDrawBrushSize between 1 and 20, then clears and repopulates the options button with the clamped size, a "+" and a "-" label.
- **Uses:** `w:value()`, `DungeonToolOptionsBtnVal`, `DungeonTool`, `meshDrawBrushSize`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add`
- **Reusable:** no
- **Procedural:** no

### updateDungeonToolListBrowser
- **Does:** Falls back to "map" when DungeonTool is nil, clears the tool list browser, then adds every entry from DungeonTools in order to the browser.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add`, `DungeonTools`
- **Reusable:** yes
- **Procedural:** no

## Part 10 of 14

### brushQuad
- **Does:** Draws a quad on the current level map using the brush size and center coordinates, then updates the map and optional brush buttons.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `currentLevel`, `resetMapper`, `parseText2Map`, `brushButtons`, `loadstring`
- **Reusable:** no
- **Procedural:** yes

### Notes
- **Does:** No description required beyond the function scope; this section is omitted per the single-function-per-section rule.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 11 of 14

### Top level
- **Does:** Sets up the DungeonMapper window and its label, close callback, resize range, scroll and group widgets, then shows the window. Also initializes the Mapper menu tables.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `gLabelTable`, `DungeonMapperWindow`, `Fl_Group`, `Fl_Group:current`, `DungeonMapperWindow:show`, `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`
- **Reusable:** no

### gridcb
- **Does:** Handles clicks on the grid buttons, updates the color and value of the clicked button, draws the appropriate map or tool view, and refreshes the current level map.
- **Uses:** `w:tooltip`, `Fl:event_key`, `fltk.fl_show_colormap`, `math.random`, `string.sub`, `string.find`, `tonumber`, `tostring`, `DungeonTool`, `gridInsertDraw`, `w:color`, `w:value`, `updateCurrentLevelMap`, `pathMapDraw`, `brushQuad`, `meshDrawBrushSize`, `GridSize`, `Fl:check`
- **Reusable:** no

### Mapper menu initialization
- **Does:** Creates empty tables for the Mapper menu index, menu text, and menu text maps, and defines the source menu labels.
- **Uses:** `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`
- **Reusable:** no

## Part 12 of 14

### fillMapperSourceMenu
- **Does:** Populates the source menu with File/ entries from MapperMenuText.Source, adds a trailing empty line, and redraws the menu.
- **Uses:** `MapperMenu`, `MapperMenuText.Source`, `MapperMenuIndex`, `MapperMenu:add`, `table.insert`, `MapperMenu:redraw`
- **Reusable:** yes
- **Reusable reason:** Pure menu data population and redraw logic, no engine-specific procedural generation.

### fillMapperControlMenu
- **Does:** Adds empty menu entries, adds a Convert/to 3D entry, adds trailing empty entries, and redraws the menu with a UI refresh.
- **Uses:** `MapperMenu`, `MapperMenuIndex`, `MapperMenu:add`, `table.insert`, `MapperMenu:redraw`, `fltk_update`
- **Reusable:** yes
- **Reusable reason:** Pure menu data population and redraw logic, no engine-specific procedural generation.

### MapperCurrentPick
- **Does:** Resets the mapper, loads the current spawn file if present, sets the current level, parses the level into the map, and refreshes the UI and grid.
- **Uses:** `BtnBrowser`, `BSDDungeonSpawnsOut`, `dofile`, `currentLevel`, `parseText2Map`, `ButtonSpawnXY`, `BtnBrowserListMaps`, `BtnBrowser:redraw`, `fltk_update`, `quadGrid`, `resetMapper`
- **Reusable:** no
- **Reusable reason:** Drives level loading and map parsing with state-dependent UI refreshes.

### MapperBrowsersMenuPick
- **Does:** Handles browser menu selections: resets and maps the current level for New, opens map files for Open, saves mapped XY and BSD text for the corresponding save options.
- **Uses:** `BtnBrowser`, `resetMapper`, `newbsdtext2Map`, `currentLevel`, `dsbtext2map`, `parseText2Map`, `BtnBrowserListMaps`, `openMapFiles`, `saveMappedXY`, `saveMapDSBInsertTextMapOut`
- **Reusable:** no
- **Reusable reason:** State-dependent menu action handlers tied to specific mapper workflows.

## Part 13 of 14

### Mapper_menu_callback
- **Does:** Handles the mapper menu callback by reading the selected menu value and pick from the current button, then updates the menu head and converter state based on the selection, and flushes the IO stream.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `quadGrid`, `Fl:check`, `io.flush`
- **Reusable:** no
- **Procedural:** no

## Part 14 of 14

### Top level
- **Does:** Sets up the DungeonMapper window, menu bar, browser widgets, text window and timer, then starts the FLTK event loop.
- **Uses:** `DungeonMapperWindow:show()`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `Fl_Group:current`, `Fl_Group:current():parent()`, `Fl_Group:current():resizable`, `Fl:run()`, and globals `BtnBrowser`, `MapperMenu`, `DungeonToolListBrowser`, `BtnListBrowser`, `DungeonToolOptionsBtn`, `MapTextWindow`, `MapTextFld`.
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is nil, then fills the mapper source and control menus.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`.
- **Reusable:** yes

### DungeonMapperWindow:show
- **Does:** Shows the DungeonMapper window and starts the grid, button resets, and DSB reset.
- **Uses:** `DungeonMapperWindow:show()`, `startGrid()`, `resetAllButtons()`, `resetDSB()`.
- **Reusable:** no

### DungeonMapperWindow:redraw
- **Does:** Redraws the DungeonMapper window and sets up the stack timer callback.
- **Uses:** `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`.
- **Reusable:** no

### BtnBrowser setup
- **Does:** Creates the browser button widget, assigns its close callback, sets its size, and hides its show call.
- **Uses:** `fltk:Fl_Double_Window`, `BtnBrowser:callback(wClose)`, `BtnBrowser:resize(6,50,176,228)`, `--BtnBrowser:show()`.
- **Reusable:** no

### MapperMenu setup
- **Does:** Creates the menu bar widget, assigns its menu callback, sets its size and colors, and sets the current group to the parent group.
- **Uses:** `fltk:Fl_Menu_Bar`, `MapperMenu:callback(Mapper_menu_callback)`, `MapperMenu:resize(-5,-2,180,22)`, `MapperMenu:color(38)`, `MapperMenu:labelsize(10)`, `MapperMenu:textsize(10)`, `Fl_Group:current(Fl_Group:current():parent())`.
- **Reusable:** no

### DungeonToolListBrowser setup
- **Does:** Creates the tool list browser widget, assigns its callback

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->
