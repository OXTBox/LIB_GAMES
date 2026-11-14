<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapper1226830pm.lua (model spark-x2.6-4b, 2026-11-12 22:02). DRAFT for Claude to review. -->

## DungeonMapper1226830pm.lua
- **Kind:** tool
- **Purpose:** This file is the main tool script for the DungeonMapper, a 2008 iGame3D Lua 5.1 engine tool that builds, edits, and saves dungeon maps through a FLTK-based user interface. It wires up the map browser, grid editing, DSB dungeon conversion, and tool options, then runs the window and menu setup at the end.
- **Depends on:** `Data/Scripts/Convert/DSB_Dungeons.lua` (loaded via `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`), `Data/Scripts/Convert/DSB_global.lua` (loaded via `dofile(gameroot.."Data/Scripts/Convert/DSB_global.lua")`), `Data/Scripts/Convert/DSB_Dungeons.lua` (loaded via `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`), `Data/WTF/Dungeons/` (used in `chooseFile("Save Lua","*.lua",gameroot.."Data/WTF/Dungeons/")`), `Data/Scripts/Convert/DSB_Dungeons.lua` (loaded via `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`), engine calls `ig3d_SetMode_i(1)`, `dofile`, `loadLevel`, `loadstring`, `lfs.dir`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeabutton`, `makeab

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 14

### Top level
- **Does:** Contains the file-level setup and global state initialization before the function definitions, including UI mode settings, grid and map data tables, and the DSB dungeon conversion setup.
- **Uses:** Globals `Q`, `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `btnList`, `textmapXY`, `XYSpawned`, `textArray`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `currentLevel`, `meshDrawBrushSize`, `WEWall`, `NSWall`, `TheFloor`, `gMapName`, `gMapFile`, `gMapOutFile`, `gBSDDungeonOutFile`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`; engine calls `ig3d_SetMode_i(1)`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`; file paths `Data/Scripts/Convert/DSB_Dungeons.lua`; globals `CBI`, `CBO`, `math.random`, `lfs.dir` (via `lfs.dir` referenced in background context); `loadstring`, `loadLevel` (referenced in background context).
- **Reusable:** no

### gridInsertDraw
- **Does:** Inserts a grid coordinate pair into the button list, text map coordinates, and button list XY tables, and records the corresponding serial coordinate in the text array.
- **Uses:** Globals `btnList`, `textmapXY`, `btnListXY`, `textArray`, `GridSize`; no engine calls, file paths or other globals.
- **Reusable:** yes

### BtnBrowserListMaps
- **Does:** Clears the browser button list, adds each index from the DSB text map table to the browser button list, triggers a redraw of the browser button, and resets the last browser control click time and selection state.
- **Uses:** Globals `BtnBrowser`, `BtnListBrowser`, `dsbtext2map`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`; engine calls `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnBrowser:redraw()`; no file paths or other globals.
- **Reusable:** no

## Part 2 of 14

### ulistBtnList
- **Does:** Rebuilds the button list browser control from the current button list coordinates, then restores the previously selected button if one exists.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DungeonMapperWindow`, `God`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes the button list rebuild routine when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlClicked
- **Does:** Validates the clicked button value, tracks click timing to detect double clicks, and selects the corresponding button list entry.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `MapListCurrentPick`, `uBtnListbrowserControlDoubleClicked`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 14

### updateCurrentLevelMap
- **Does:** Rebuilds the current level's text-to-map table string from `textArray`, optionally regenerating and running the generated Lua table when `currentLevel` is set, and updates `currentText2MapTable`.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `loadstring`, `CBI`, `CBO`, `string.sub`, `string.len`, `MapTextFld`, `MapTextWindow` (via `MapTextFld:clear()` and `MapTextWindow:show()`), `chooseFile` (via `saveBSDMAP` context only if referenced here — not in this function body), `io` (not used here).
- **Reusable:** yes - pure data assembly and table generation logic for level map text conversion.
- **Procedural:** yes - generates the `makenewdsbtext` Lua table from the assembled string.

### saveBSDMAP
- **Does:** Clears and shows the map text field, prompts the user to choose a save Lua file, writes the level map table content into that file, and closes the file handle.
- **Uses:** `MapTextFld:clear()`, `MapTextWindow:show()`, `chooseFile("Save Lua","*.lua",gameroot.."Data/WTF/Dungeons/")`, `gameroot`, `io.open`, `gMapFile`, `fileShortNameFromPath`, `textArray`, `MapTextFld:add()`, `MapTextWindow:redraw()`, `CBI`, `CBO`, `string.len`, `string.sub`, `gMapFile`, `gMapName`, `io.close`.
- **Reusable:** no - tied to the DungeonMapper UI and file saving flow.
- **Procedural:** no

### saveMappedXY
- **Does:** Resolves the current level and map name, builds the output file path, writes the level map XY coordinates table into the file, and closes the file handle.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `gameroot`, `textmapXY`, `CBI`, `CBO`, `string.sub`, `io.open`, `io.close`.
- **Reusable:** yes - pure data serialization logic for level map coordinates.
- **Procedural:** no

## Part 4 of 14

### saveMapDSBInsertTextMapOut
- **Does:** Writes the generated map text file, then loads it back with dofile so the map data is active.
- **Uses:** `currentLevel`, `gMapName`, `gMapOutFile`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `Q`, `string.len`, `string.sub`, `io.open`, `io.close`, `dofile`, `gameroot`
- **Reusable:** no
- **Procedural:** yes

### wClose
- **Does:** Hides the given FLTK window and sets it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes

### fastquickquad
- **Does:** Scales the input coordinates by gridSize, loads wall/floor assets once if needed, adjusts camera position and facing, shows all maps, and refreshes the current map list pick.
- **Uses:** `TheFloor`, `WEWall`, `NSWall`, `loadTheWalls`, `loadTheFloor`, `gridSize`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `IG3D_POSITION`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `currentLevel`
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 14

### quickquad
**Does:** Builds the wall and floor grid for the current level by iterating the quadwall table, copying wall or floor meshes at grid positions, and adjusting camera position and face for wall cells.
**Uses:** `MapListCurrentPick`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `quadwalls`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `IG3D_POSITION`, `gObjects`-style shared state referenced by these names.
**Reusable:** no

### startGrid
**Does:** Creates a grid of buttons per cell, generates FLTK button code for each cell, loads and executes the generated button code, then redraws the base button color and the DungeonMapper window.
**Uses:** `math.random`, `fltk.fl_color`, `tostring`, `loadstring`, `makeabutton`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `x0y0:color`, `keeper:redraw`, `DungeonMapperWindow:redraw`, `gridcb`, `Fl_Button`, `fltk.FL_FLAT_BOX`, `fltk.fl_show_colormap`, `fltk_update`, `Fl:check`.
**Reusable:** no

### stackcb
**Does:** Handles the space key event by showing the color map when the space key is pressed, then updates the FLTK interface state.
**Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `fltk_update`, `Fl:check`, `nc`, `newcolor`.
**Reusable:** no

## Part 6 of 14

### quadGrid
- **Does:** Builds the quad grid by loading wall/floor assets, parsing the current level map, copying wall or floor geometry at grid positions, then saving and finalizing the mesh.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `parseText2Map`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `WEWall`, `NSWall`, `TheFloor`, `quadwalls`, `gridSize`, `currentLevel`, `gMapName`, `gameroot`, `baseBtnColor`
- **Reusable:** no
- **Procedural:** yes

### resetAllButtons
- **Does:** Generates a string of button color reset commands for every grid cell, loads it as a string function, and assigns it to `ClearAllButtons`.
- **Uses:** `baseBtnColor`, `GridSize`
- **Reusable:** yes
- **Procedural:** yes

### resetGrid
- **Does:** Initializes empty button and text map arrays, fills a text array with zero values for every grid cell, and ends the function.
- **Uses:** `GridSize`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 14

### resetDSB
- **Does:** Resets all DSB (dungeon spawn) state variables and loads the DSB conversion scripts, clearing spawn grids, spawn data, and level-related state.
- **Uses:** Globals `listSpawnxy`, `spawnXY`, `XYSpawned`, `dsbspawn`, `spawninpack`, `exvar`, `dsbaddchampion`, `dsbtext2map`, `newbsdtext2Map`, `wallset`, `spawngrid`, `spawnindex`, `spawntext`, `foundindex`, `level`, `which`, `GridSize`; engine calls `dofile(gameroot.."Data/Scripts/Convert/DSB_global.lua")` and `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`.
- **Reusable:** yes
- **Procedural:** no

### resetMapper
- **Does:** Resets the DungeonMapper grid and wall state variables, clears button lists, and triggers a redraw of the DungeonMapper window.
- **Uses:** Globals `GridSize`, `GridSpread`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnList`, `cubewalls`, `quadwalls`; engine calls `ClearAllButtons()`, `resetGrid()`, `DungeonMapperWindow:redraw()`.
- **Reusable:** yes
- **Procedural:** no

### parseTextMapXY
- **Does:** Parses the text map XY coordinates, clamps values to GridSize, generates button names, and triggers button color changes for each coordinate pair.
- **Uses:** Globals `textmapXY`, `GridSize`, `DungeonMapperWindow`, `dsbtext2mapButtonChanges`; engine calls `loadstring(act)` and `dsbtext2mapButtonChanges()`.
- **Reusable:** yes
- **Procedural:** no

## Part 8 of 14

### MapListCurrentPick
- **Does:** Validates the selected map number, updates the current level map, resets the mapper, parses the map text, and refreshes the FLTK UI when a map pick is made.
- **Uses:** `updateCurrentLevelMap()`, `currentLevel`, `resetMapper()`, `parseText2Map()`, `fltk_update()`, `n`
- **Reusable:** no
- **Procedural:** no

### openMapFiles
- **Does:** Opens a chosen map file, loads it, builds the level map table, creates the new DSB text, and refreshes the map browser if the map table is non-empty.
- **Uses:** `chooseFile()`, `tTitle`, `tFile`, `gMapFile`, `gameroot`, `resetMapper()`, `resetDSB()`, `dofile()`, `GridSize`, `zeromap`, `zeroline`, `levelmapXY`, `textArray`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext()`, `fileShortNameFromPath()`, `gMapName`, `BtnBrowserListMaps()`, `parseText2Map()`, `fltk_update()`
- **Reusable:** no
- **Procedural:** yes

## Part 9 of 14

### DungeonToolListBrowserCB
- **Does:** Returns early when the clicked tool value is nil or zero, otherwise records the tool number, selects the matching DungeonMapperWindow tool, and for the brush tool clears and repopulates the options button with the current meshDrawBrushSize, a plus sign, and a minus sign.
- **Uses:** `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonTools`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add()`, `meshDrawBrushSize`
- **Reusable:** no
- **Procedural:** no

### DungeonToolOptionsBtnCB
- **Does:** Records the options button value, and when the selected tool is brush, adjusts meshDrawBrushSize by one for values 2 and 3, clamps it between 1 and 20, then clears and repopulates the options button with the clamped size, a plus sign, and a minus sign.
- **Uses:** `w:value()`, `DungeonTool`, `DungeonToolOptionsBtnVal`, `meshDrawBrushSize`, `DungeonToolOptionsBtn:clear()`, `DungeonToolOptionsBtn:add()`
- **Reusable:** no
- **Procedural:** no

### updateDungeonToolListBrowser
- **Does:** If DungeonTool is nil it defaults it to "map", clears the tool list browser, then adds every entry from DungeonTools into the browser in order.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add()`, `DungeonTools`
- **Reusable:** yes
- **Procedural:** no

## Part 10 of 14

### brushQuad
- **Does:** Draws a quad on the current level map, updates the map text, and loads the generated brush button script to apply it.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `currentLevel`, `resetMapper`, `parseText2Map`, `loadstring`, `brushButtons`, `bs`, `s`, `xb`, `xf`, `yb`, `yf`, `xys`, `btnm`
- **Reusable:** no
- **Procedural:** yes

### resetMapper
- **Does:** Resets the mapper state after a brush quad is drawn.
- **Uses:** nothing
- **Reusable:** no

### parseText2Map
- **Does:** Parses the current level text into the level map.
- **Uses:** `currentLevel`
- **Reusable:** no

### updateCurrentLevelMap
- **Does:** Updates the current level map.
- **Uses:** nothing
- **Reusable:** no

### gridInsertDraw
- **Does:** Inserts a drawn quad entry into the level map.
- **Uses:** nothing
- **Reusable:** no

## Part 11 of 14

### Top level
- **Does:** Sets up the DungeonMapper window and its surrounding FLTK UI elements, then defines the Mapper menu data tables.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `gLabelTable`, `DungeonMapperWindow`, `Fl_Group:current()`, `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`
- **Reusable:** no

### gridcb
- **Does:** Handles clicks on the grid buttons, updates the color and value of the clicked button, and routes the action based on the current DungeonTool setting.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap`, `math.random`, `string.sub`, `string.find`, `tonumber`, `tostring`, `DungeonTool`, `gridInsertDraw`, `pathMapDraw`, `brushQuad`, `meshDrawBrushSize`, `updateCurrentLevelMap`, `quickquad`, `Fl:check`, `GridSize`, `btnList`, `DungeonMapperWindow`, `gLabelTable`
- **Reusable:** no

### Mapper menu data setup
- **Does:** Initializes the Mapper menu data tables and populates the Source menu text entries.
- **Uses:** `MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`
- **Reusable:** yes
- **Procedural:** no

## Part 12 of 14

### fillMapperSourceMenu
- **Does:** Populates the source menu with the source file names from the mapper menu text, then redraws the menu.
- **Uses:** `MapperMenu`, `MapperMenuText.Source`, `MapperMenuIndex`, `BtnBrowser`, `table.insert`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes
- **Procedural:** no

### fillMapperControlMenu
- **Does:** Adds blank menu entries, then adds the "Convert/to 3D" menu entry, updates the menu index and redraws the menu, then refreshes the FLTK UI.
- **Uses:** `MapperMenu`, `MapperMenuIndex`, `fltk_update`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes
- **Procedural:** no

### MapperCurrentPick
- **Does:** Resets the mapper, loads the spawn file if present, sets the current level if unset, parses the level into the map, and refreshes the spawn button, map browser, button and grid.
- **Uses:** `BtnBrowser`, `BSDDungeonSpawnsOut`, `dofile`, `currentLevel`, `parseText2Map`, `ButtonSpawnXY`, `BtnBrowserListMaps`, `BtnBrowser`, `fltk_update`, `quadGrid`, `resetMapper`, `newbsdtext2Map`, `saveMappedXY`, `saveMapDSBInsertTextMapOut`
- **Reusable:** no
- **Procedural:** no

### MapperBrowsersMenuPick
- **Does:** Handles the browser menu pick: resets and rebuilds the map for "New", opens map files for "Open", and saves the mapped XY or BSD text for the corresponding save options.
- **Uses:** `BtnBrowser`, `resetMapper`, `newbsdtext2Map`, `currentLevel`, `parseText2Map`, `BtnBrowserListMaps`, `openMapFiles`, `saveMappedXY`, `saveMapDSBInsertTextMapOut`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 14

### Mapper_menu_callback
- **Does:** Runs when the mapper menu button is clicked. It reads the menu label, value and pick from the button, looks up adjacent menu indices, and either opens the file browser pick menu, runs the quadGrid conversion, or does nothing further.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `quadGrid`, `Fl:check`, `io.flush`, and the FLTK widget calls `w:label()`, `w:value()`, `w:text()`.
- **Reusable:** no
- **Procedural:** no

## Part 14 of 14

### Top level
- **Does:** Sets up the DungeonMapper window, menu bar, browser widgets, text window and timer, then shows the window and starts the main flow.
- **Uses:** `DungeonMapperWindow:show()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `Fl_Group:current`, `Fl_Group:current():parent()`, `Fl_Group:current():resizable()`, `Fl:run()`, plus widget setup calls such as `resize`, `callback`, `type`, `labelsize`, `textsize`, `color`, `size_range`, `show`, `hide`, and globals `BtnBrowser`, `MapperMenu`, `DungeonToolListBrowser`, `BtnListBrowser`, `DungeonToolOptionsBtn`, `MapTextWindow`, `MapTextFld`, `menudir0`, `timer`.
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is nil, then fills the mapper source menu and control menu.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`.
- **Reusable:** yes

### Mapper_MenuBarFill
- **Does:** Shows the main window, starts a timer callback, creates and configures the browser button and menu bar, then creates and configures the tool list, list, options browser widgets.
- **Uses:** `DungeonMapperWindow:show()`, `startGrid()`, `resetAllButtons()`, `resetDSB()`, `DungeonMapperWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `BtnBrowser:callback(wClose)`, `BtnBrowser:resize()`, `MapperMenu:callback(Mapper_menu_callback)`, `MapperMenu:resize()`, `MapperMenu:color()`, `MapperMenu:labelsize()`, `MapperMenu:textsize()`, `Fl_Group:current()`, `DungeonToolListBrowser:callback(DungeonToolListBrowserCB)`, `DungeonToolListBrowser:resize()`, `DungeonToolListBrowser:type()`, `DungeonToolListBrowser:labelsize()`, `DungeonToolListBrowser:textsize()`, `BtnListBrowser:callback(uBtnListBrowserControlClicked)`, `BtnListBrowser:resize()`, `BtnListBrowser:type()`, `BtnListBrowser:labelsize()`, `BtnListBrowser:textsize()`, `DungeonToolOptionsBtn:callback(DungeonToolOptionsBtnCB)`, `DungeonToolOptionsBtn:resize()`, `DungeonToolOptionsBtn:type()`, `DungeonToolOptionsBtn:labelsize()`, `DungeonToolOptionsBtn:textsize()`, `men

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->
