<!-- Spark first-look of Data/Fluid/DungeonMapper/DungeonMapper.lua (model spark-x2.6-4b, 2026-11-12 21:48). DRAFT for Claude to review. -->

## DungeonMapper.lua
- **Kind:** tool
- **Purpose:** This file is the DungeonMapper tool, a FLTK-based user interface for editing and converting dungeon maps in iGame3D. It loads map data from DSB text files, lets the user draw or erase map elements on a grid, and saves the mapped map back to DSB or mesh files. It also provides tools for browsing maps, managing dungeon tool options, and saving mapped maps with user-chosen options.
- **Depends on:** `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Levels/` (via `loadLevel`), `Data/` folder paths, engine calls (`dofile`, `loadstring`, `loadLevel`, `make`, `get`, `getObjectInfo`, `setObjectInfo`, `ig3d_GetLevelName__s`, `ig3d_SetMode_i`, `ig3d_DeleteMesh_b`, `ig3d_GetMeshCentroid__3f`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `ig3d_CreateDirectory_s`, `CBI`, `CBO`), globals (`gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`, `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, `BtnListBrowserIndex`, `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`, `GridSpread`, `GridSize`, `baseBtnColor`, `currentLevel`, `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `gMapButtonColors`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `gDropx`, `gDropz`, `gDropModel`, `meshDrawBrushSize`, `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `mapNameTextInput`, `MapSavePathsBrowser`, `tTitle`, `tFile`, `gMapOutFile`, `DSBMap2TEXTOutFile`, `gMapContentFile`, `levelmapXY`, `levelmapColors`, `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `MapTextFld`, `MapTextWindow`, `MapTextWindow`, `MapTextFld`, `MapSaveWindow`, `MapSaveTextFld`, `MapSaveWindow`, `MapSaveWindow`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBtnVal`, `DungeonToolListBrowser`, `DungeonToolListBrowser`, `DungeonToolListBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `DungeonToolOptionsBrowser`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 21

### Top level
- **Does:** Sets up the DungeonMapper top-level state, loads the DSB conversion script, builds the map XY base string and loads it, and initializes the dungeon tool and level lists.
- **Uses:** `dofile`, `loadstring`, `loadLevel`, `math.random`, `table.insert`, `gameroot`, `CBI`, `CBO`, `ig3d_GetLevelName__s`, `ig3d_SetMode_i`, `lfs.dir` (via `lfs.dir` referenced in background context), `Data/` paths (`Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Levels/`), globals (`gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`), and `Data/` folder paths.
- **Reusable:** no
- **Procedural:** yes - generates the map XY base string from the 52-row loop and loads the generated string to build the map data.

## Part 2 of 21

### Top level
- **Does:** Contains four lines of top-level code outside functions: `gLastBrowserControlClick=os.time()`, `gLastSelection=-1`, `gSelectedBtn=""`, and `BtnListBrowserIndex ={{}}`.
- **Uses:** Globals `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, `BtnListBrowserIndex`.
- **Reusable:** no

### gridInsertDraw
- **Does:** Inserts a grid cell into the button list, text map, and button list coordinates, then records the serial coordinate and marks it as filled in the text array.
- **Uses:** Globals `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`.
- **Reusable:** yes

### BtnBrowserListMaps
- **Does:** Clears the browser button list, adds entries for each map index from the `dsbtext2map` table, redraws the browser, selects and sets the current level on the button list.
- **Uses:** Globals `BtnBrowser`, `BtnListBrowser`, `currentLevel`, `dsbtext2map`, `gLastBrowserControlClick` (via surrounding top-level setup).
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list from the grid coordinates, records coordinates in the index table, redraws the browser, restores the last selection if present, and makes the DungeonMapper window current.
- **Uses:** Globals `God`, `BtnBrowser`, `BtnListBrowser`, `currentLevel`, `btnListXY`, `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, `BtnListBrowserIndex`, `DungeonMapperWindow`.
- **Reusable:** no

## Part 3 of 21

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event of the list browser button by refreshing the list browser control.
- **Uses:** nothing
- **Reusable:** yes

### uBtnListBrowserControlClicked
- **Does:** Handles the click event of the list browser button, preventing duplicate rapid clicks, selecting a level via the list, and updating the current level map.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `MapListCurrentPick`, `time`, `os.time`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `GridSize`, `textArray`, `CBI`, `CBO`
- **Reusable:** yes

### updateCurrentLevelMap
- **Does:** Builds a string from the text array, wraps it into a table format string, loads it as a new function, and calls that function when the current level map exists.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `CBI`, `CBO`, `string.sub`, `loadstring`
- **Reusable:** yes

## Part 4 of 21

### saveBSDMAP
- **Does:** Saves the current map text array into a Lua file, formats it as a BSD map text, and writes the result to the chosen file.
- **Uses:** `MapTextFld`, `MapTextWindow`, `chooseFile`, `gMapPath`, `gMapFile`, `gMapName`, `textArray`, `Q`, `CBI`, `CBO`, `dsb_text2map`, `io.open`, `io.close`, `fileShortNameFromPath`, `gMapOutFile`
- **Reusable:** no
- **Procedural:** no

### saveMapDSBInsertTextMapOut
- **Does:** Writes the current map text array and level mapping table to a generated Lua file, then loads that file with `dofile`.
- **Uses:** `currentLevel`, `gMapName`, `DSBMap2TEXTOutFile`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `gMapPath`, `gMapOutFile`, `io.open`, `io.close`, `dofile`
- **Reusable:** no
- **Procedural:** no

## Part 5 of 21

### saveMappedXY
- **Does:** Writes the mapped level data and mesh object data to files, then closes any opened file handles.
- **Uses:** `gMapFile`, `gMapContentFile`, `gMapName`, `currentLevel`, `textmapXY`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `CBI`, `CBO`, `Q`, `gameroot`, `io.open`, `io.close`, `string.sub`
- **Reusable:** no
- **Procedural:** yes

### wClose
- **Does:** Hides the given FLTK window and sets the window variable to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

## Part 6 of 21

### fastquickquad
- **Does:** Loads the wall and floor assets for the current level if they have not already been loaded, then moves the camera to a fixed offset above the mesh centroid, faces the mesh, shows all objects, and refreshes the current level pick list.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `currentLevel`, `gridSize`, `TheFloor`, `WEWall`, `NSWall`
- **Reusable:** no

### quickquad
- **Does:** Refreshes the current level pick list, deletes the current mesh, reloads the east and north walls and floor assets, then copies wall or floor assets for each quad wall in the current quad layout and adjusts the camera to face the copied mesh centroid.
- **Uses:** `MapListCurrentPick`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `quadwalls`, `gridSize`, `TheFloor`, `WEWall`, `NSWall`
- **Reusable:** no

### startGrid
- **Does:** Builds a grid of buttons for the current level, creates one button per grid cell with a generated label, loads the button's action script, inserts a placeholder text entry for each cell, then refreshes the button color and redraws the DungeonMapper window.
- **Uses:** `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Button`, `keeper:add`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `loadstring`, `makeabutton`, `textArray`, `x1y1:color`, `keeper:redraw`, `DungeonMapperWindow:redraw`, `gridcb`
- **Reusable:** no

## Part 7 of 21

### stackcb
- **Does:** Handles the space key event by showing the color map when the key is 32, then updates the FLTK interface state.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap(nc)`, `fltk_update()`, `Fl:check()`
- **Reusable:** no

### convertMapXYToMesh
- **Does:** Updates the current level map, parses the map text into map coordinates, saves the mapped coordinates, deletes the existing mesh, builds mesh objects from quad walls, converts the mesh objects table to a mesh, saves the mesh, and saves the new level.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `saveMappedXY()`, `ig3d_DeleteMesh_b(true)`, `render()`, `convertMeshObjectsTableToMesh(gMapName)`, `ig3d_SaveMesh_sf_b(gMapMeshPath,100)`, `saveAsNewLevel()`, globals `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `quadwalls`, `gridSize`, `gMapName`, `gMapMeshPath`
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 21

### quadGrid
- **Does:** Rebuilds the current level map by parsing the level text into a grid, deleting the existing mesh, placing wall/floor/roof geometry at grid positions, and saving the result as a new level.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `ig3d_DeleteMesh_b(true)`, `render()`, `saveAsNewLevel()`, globals `quadwalls`, `gridSize`, `baseBtnColor`, and `Data/` level paths referenced via `currentLevel` and `gMapMeshPath`.
- **Reusable:** no
- **Procedural:** yes

### resetAllButtons
- **Does:** Builds a string that restores every grid button to its base color, then loads it as a Lua string to clear all buttons.
- **Uses:** `baseBtnColor`, `GridSize`, `loadstring()`, and the button name pattern `"x"..tostring(i).."y"..tostring(ii)`; writes no files or engine calls.
- **Reusable:** yes
- **Procedural:** no

## Part 9 of 21

### recolorMapButtons
- **Does:** Iterates the map button color table, finds entries matching the current level, builds a Lua string for re-coloring all buttons, loads it with `loadstring`, and calls the result.
- **Uses:** `gMapButtonColors`, `currentLevel`, `ReColorAllButtons`, `loadstring`, `print`
- **Reusable:** no
- **Procedural:** no

### resetGrid
- **Does:** Initializes empty button and text-map coordinate tables, then fills a text array with zeros across the grid size.
- **Uses:** `GridSize`
- **Reusable:** yes
- **Procedural:** no

### resetDSB
- **Does:** Resets DSB-related state tables, loads the DSB conversion scripts from the Data folder, and clears DSB state variables.
- **Uses:** `GridSize`, `gameroot`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `dofile`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 21

### resetMapper
- **Does:** Resets the DungeonMapper grid and button state, then redraws the mapper window.
- **Uses:** `ClearAllButtons()`, `resetGrid()`, `recolorMapButtons()`, `DungeonMapperWindow:redraw()`; sets local variables such as `GridSize`, `GridSpread`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnList`, `cubewalls`, `quadwalls`.
- **Reusable:** yes
- **Procedural:** no

### parseTextMapXY
- **Does:** Reads the text map coordinates, clamps them to the grid size, builds a button name, and triggers the corresponding button color change.
- **Uses:** `tonumber`, `tostring`, `loadstring`, `DungeonMapperWindow:make_current()`, `DungeonMapperWindow`, `GridSize`, `textmapXY`, `dsbtext2mapButtonChanges`; writes `act` and `dsbtext2mapButtonChanges`.
- **Reusable:** yes
- **Procedural:** no

### MapListCurrentPick
- **Does:** Selects the given level, resets the mapper, updates the current level map, parses the level's text map, and redraws the UI.
- **Uses:** `currentLevel`, `resetMapper()`, `updateCurrentLevelMap()`, `resetAllButtons()`, `parseText2Map(currentLevel)`, `recolorMapButtons()`, `fltk_update()`; references commented-out `BSDDungeonSpawnsOut()` and `dofile(f)` code.
- **Reusable:** no
- **Procedural:** no

## Part 11 of 21

### openMapFiles
- **Does:** Opens a Lua map file, resets the mapper and DSB state, builds the level map table, loads the map into the DSB text box, and updates the DungeonMapper window.
- **Uses:** `chooseFile`, `tTitle`, `gMapPath`, `tFile`, `gameroot`, `string.sub`, `string.find`, `resetMapper`, `resetDSB`, `dofile`, `GridSize`, `levelmapXY`, `dsbtext2map`, `zeromap`, `zeroline`, `gridInsertDraw`, `string.rep`, `string.sub`, `CBI`, `CBO`, `loadstring`, `fileShortNameFromPath`, `gMapName`, `currentLevel`, `BtnBrowserListMaps`, `parseText2Map`, `levelmapColors`, `gMapButtonColors`, `recolorMapButtons`, `DungeonMapperWindow:redraw`
- **Reusable:** no
- **Procedural:** yes

## Part 12 of 21

### DungeonToolListBrowserCB
- **Does:** Updates the current level map, parses the level text into the map, then handles the selected tool: for the brush tool it shows size plus plus/minus buttons, for Friend or Enemy tools it clears the browser and lists the corresponding character lists.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `DungeonTools`, `humanlist`, `zombielist`, `meshDrawBrushSize`
- **Reusable:** no

### DungeonToolOptionsBrowserCB
- **Does:** Reads the option button value, updates the current level map and parses the level text, then adjusts the brush size for the brush tool, clamps it between 1 and 20, and for Friend or Enemy tools builds the drop model path from the selected list entry.
- **Uses:** `w:value()`, `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `DungeonTool`, `DungeonToolOptionsBtnVal`, `meshDrawBrushSize`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `humanlist`, `zombielist`, `gDropModel`
- **Reusable:** no

### updateDungeonToolListBrowser
- **Does:** Ensures `DungeonTool` defaults to `"map"` when unset, clears the tool list browser, then adds every entry from `DungeonTools` in order.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add()`, `DungeonTools`
- **Reusable:** yes
- **Procedural:** no

## Part 13 of 21

### eraserTool
- **Does:** Removes a button from the button list and clears its mapped coordinates, then updates the current level map and redraws the DungeonMapper window.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `gMapButtonColors`, `baseBtnColor`, `GridSize`, `updateCurrentLevelMap`, `parseText2Map`, `DungeonMapperWindow:redraw`, `loadstring`
- **Reusable:** no
- **Procedural:** no

## Part 14 of 21

### brushQuad
- **Does:** Draws a quad on the current level map by inserting grid cells, updating the level map, and recoloring map buttons.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `gMapButtonColors`, `currentLevel`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow:redraw`
- **Reusable:** no
- **Procedural:** yes

### brushQuad
- **Does:** Computes the quad's bounding coordinates, clamps them to grid bounds, and builds the button list string for the quad.
- **Uses:** `size`, `x`, `y`, `GridSize`, `btnList`
- **Reusable:** no
- **Procedural:** yes

## Part 15 of 21

### gridcb
- **Does:** Handles clicks on the grid buttons, converts the button tooltip into grid coordinates, and applies the selected DungeonTool action to the grid cell.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.find()`, `string.sub()`, `string.len()`, `tonumber()`, `gDropx`, `gDropz`, `DungeonTool`, `eraserTool()`, `btnList`, `gridSize`, `gridInsertDraw()`, `w:color()`, `w:value()`, `gMapButtonColors`, `updateCurrentLevelMap()`, `pathMapDraw()`, `gMapFriend`, `gMapEnemy`, `icopyModelWalls()`, `brushQuad()`, `meshDrawBrushSize`, `GridSize`, `serialXY`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### gridcb
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes,
  copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and
  data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level
  layout, a texture, a terrain, a maze, an animation) - creating or setting up one
  object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 16 of 21

### fillmapSaveOptionsBrowser
- **Does:** Rebuilds the save-options browser and list from the chosen and table options, then restores the selected option and redraws both widgets.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsListBrowser:clear()`, `mapSaveOptionsListBrowser:add()`, `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsListBrowser:selected()`, `mapSaveOptionsListBrowser:select()`, `mapSaveOptionsListBrowser:redraw()`, `mapSaveOptionsBrowser:redraw()`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsAdd
- **Does:** Adds the selected table option to the chosen options, then refreshes the save-options browser.
- **Uses:** `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsBrowser:value()`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `fillmapSaveOptionsBrowser()`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsRemove
- **Does:** Removes the selected option from the chosen options, then refreshes the save-options browser.
- **Uses:** `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsBrowser:value()`, `mapSaveOptionsChosen`, `fillmapSaveOptionsBrowser()`
- **Reusable:** yes
- **Procedural:** no

### saveMapButtonClicked
- **Does:** Reads the map name from the text input, defaults it to untitled if empty, ensures the level folder exists under Data/Levels, then saves the mapped XY coordinates.
- **Uses:** `mapNameTextInput:value()`, `gMapName`, `folderExists()`, `gameroot`, `ig3d_CreateDirectory_s()`, `saveMappedXY()`
- **Reusable:** no
- **Procedural:** no

### refreshMapFileLists
- **Does:** Reads the current map name, builds the level folder path, mapXY script path and map_mesh model path, then clears and populates the map save paths browser.
- **Uses:** `mapNameTextInput:value()`, `gameroot`, `MapSavePathsBrowser:clear()`, `MapSavePathsBrowser:add()`
- **Reusable:** yes
- **Procedural:** no

### mapNameTextInputCB
- **Does:** Refreshes the map file lists when the map name text input changes.
- **Uses:** `refreshMapFileLists()`
- **Reusable:** yes
- **Procedural:** no

## Part 17 of 21

### Top level
- **Does:** Contains the file-level setup lines `MapperMenuIndex={}` and `MapperMenuText={}` that initialize the mapper menu state before the function sections.
- **Uses:** nothing
- **Reusable:** yes

### openMapSaveWindow
- **Does:** Shows the map save window, makes it current, restores the saved map name into the map name text input, and refreshes the map file lists.
- **Uses:** `MapSaveWindow:show()`, `MapSaveWindow:make_current()`, `mapNameTextInput:value(gMapName)`, `refreshMapFileLists()`
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, and Save entries, adds a blank separator line, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenu:add()`, `table.insert()`, `MapperMenu:redraw()`, `MapperMenuText.Source`
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Populates the mapper control menu with blank separator lines and a Convert to 3D entry, then redraws the menu and updates the FLTK interface.
- **Uses:** `MapperMenu:add()`, `table.insert()`, `MapperMenu:redraw()`, `fltk_update()`
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Resolves the pick argument to a valid level, loads the current level's spawn script if present, parses the level into the map, and refreshes the spawn button, map browser, and grid.
- **Uses:** `BSDDungeonSpawnsOut()`, `dofile()`, `currentLevel`, `parseText2Map()`, `ButtonSpawnXY()`, `BtnBrowserListMaps()`, `BtnBrowser:redraw()`, `fltk_update()`, `quadGrid()`
- **Reusable:** no

## Part 18 of 21

### MapperBrowsersMenuPick
- **Does:** Handles the menu pick action for the mapper browser, dispatching to the appropriate action based on the selected menu item.
- **Uses:** `BtnBrowser`, `resetMapper()`, `newbsdtext2Map()`, `currentLevel`, `parseText2Map()`, `BtnBrowserListMaps()`, `openMapFiles()`, `openMapSaveWindow()`, `saveMapDSBInsertTextMapOut()`, `MakeMapper()` (commented out), `updateCurrentLevelMap()`, `convertMapXYToMesh()`
- **Reusable:** no
- **Procedural:** no

### Mapper_menu_callback
- **Does:** Reads the selected menu item from the FLTK button and routes the action to the mapper menu pick handler or the map conversion flow.
- **Uses:** `BtnBrowser`, `w:label()`, `w:value()`, `w:text()`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick()`, `updateCurrentLevelMap()`, `parseText2Map()`, `convertMapXYToMesh()`
- **Reusable:** no
- **Procedural:** no

## Part 19 of 21

### Top level
- **Does:** Sets up the DungeonMapper window and its sub-windows, labels, callbacks and sizes; continues earlier parts by filling the mapper menu bar.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `gLabelTable`, `DungeonMapperWindow`, `MapSaveWindow`, `MapSaveTextFld`, `mapSaveOptionsBrowser`, `mapSaveOptionsListBrowser`, `addsaveoptionbtn`, `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`, `wClose`, `hide`, `saveOptionsAdd`, `Fl_Group:current()`, `DungeonMapperWindow:label`, `DungeonMapperWindow:callback`, `DungeonMapperWindow:resize`, `DungeonMapperWindow:when`, `DungeonMapperWindow:size_range`, `DungeonMapperWindow:show`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is absent, then fills the mapper source menu and mapper control menu.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`
- **Reusable:** yes

### Mapper_MenuBarFill
- **Does:** Creates the DungeonMapper double window, adds a label and close callback, sets its size and resizable group, then creates a scrollable keeper group.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `DungeonMapperWindow`, `Fl_Group:current()`, `DungeonMapperWindow:label`, `DungeonMapperWindow:callback`, `DungeonMapperWindow:resize`, `DungeonMapperWindow:when`, `DungeonMapperWindow:size_range`, `DungeonMapperWindow:show`, `fltk:Fl_Scroll`, `Fl_Group:current():resizable`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the MapSave window, adds a Save Map label and hide callback, sets its size and resizable group, then creates the save text field.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `MapSaveWindow`, `hide`, `DungeonMapperWindow:label`, `MapSaveWindow:label`, `MapSaveWindow:callback`, `MapSaveWindow:resize`, `MapSaveWindow:size_range`, `fltk:Fl_Browser`, `gLabelTable`, `MapSaveTextFld`, `MapSaveTextFld:label`, `MapSaveTextFld:resize`, `MapSaveTextFld:type`, `MapSaveTextFld:labelsize`, `MapSaveTextFld:align`, `MapSaveTextFld:textsize`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the Save Options browser, adds the Save Options label, sets its size and text formatting attributes.
- **Uses:** `fltk:Fl_Browser`, `gLabelTable`,

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 20 of 21

### Top level
- **Does:** Builds the DungeonMapper UI widgets, registers shared labels in `gLabelTable`, wires callbacks, and shows the browser and menu windows.
- **Uses:** `fltk:Fl_Button`, `fltk:Fl_Input`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Group`, `gLabelTable`, `MapSaveWindow`, `BtnBrowser`, `MapperMenu`, `DungeonToolListBrowser`, `BtnListBrowser`, `DungeonToolOptionsBrowser`, and callbacks `saveOptionsRemove`, `mapNameTextInputCB`, `saveMapButtonClicked`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`, `wClose`, `Mapper_menu_callback`.
- **Reusable:** no
- **Procedural:** no

## Part 21 of 21

### Top level
- **Does:** Builds the Fluid UI window and its text fields, shows the mapper window, starts the timer callback, and runs the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `Fl_Group`, `MapTextWindow`, `MapTextFld`, `DungeonMapperWindow`, `BtnBrowser`, `BtnBrowserListMaps`, `updateDungeonToolListBrowser`, `DungeonMapperWindow`, `murgaLua.createFltkTimer`, `timer:callback`, `timer:do_callback`, `Fl:run`
- **Reusable:** no
- **Procedural:** no
