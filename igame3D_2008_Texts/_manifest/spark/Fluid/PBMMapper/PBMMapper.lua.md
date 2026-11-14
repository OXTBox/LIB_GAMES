<!-- Spark first-look of Data/Fluid/PBMMapper/PBMMapper.lua (model spark-x2.6-4b, 2026-11-13 01:43). DRAFT for Claude to review. -->

## PBMMapper.lua
- **Kind:** tool
- **Purpose:** PBMMapper is a FLTK-based tool for editing and converting PBM/DSB map data into iGame3D mesh and level files. It loads map files, lets the user draw quads and walls on a grid, saves the edited map back to DSB or PBM formats, and converts the mapped geometry into mesh objects for the current level.
- **Depends on:** `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Levels/` path construction, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 22

### Top level
- **Does:** Sets up the top-level state and initial configuration for the PBMMapper, including engine mode, grid and text-map variables, level path construction, DSB dungeon loading, and human list initialization.
- **Uses:** `ig3d_SetMode_i`, `math.random`, `dofile`, `loadstring`, `lfs`-style path construction via `gameroot`, `CBI`, `CBO`, `item`, `get`, `loadLevel`, `table.insert`, and globals such as `gMapName`, `gMapPath`, `gMapFile`, `gMapMeshPath`, `gMapEnemy`, `gMapFriend`, `gMapPaths`, `gMapMaterials`, `gMapEmitters`, `gMapWeapons`, `gMapTags`, `gMapButtonColors`, `gMapFoundFloors`, `gMapFoundWalls`, `gMapRNDEnemy`, `gMapRNDFriend`, `gSelectedDropEntity`, `dsbtext2map`, `bsdtext2MapBaseString`, `newbsdtext2Map`, `cubewalls`, `quadwalls`, `DungeonTools`, `DungeonTool`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `humanlist`, `zombielist`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 22

### parsePBM2Map
- **Does:** Parses a PBM2 map character string into table structures for floor/button positions, then draws the map by iterating the collected positions and applying button color changes.
- **Uses:** `dofile`, `pbms_to_table`, `tostring`, `string.sub`, `string.len`, `table.insert`, `tonumber`, `loadstring`, `DungeonMapperWindow`, `GridSize`, `textArray`, `btnListXY`, `textmapXY`, `btnList`, `quadwalls`, `pbmblock`, `schc`, `sb`, `xys`, `dsbtext2mapButtonChanges`
- **Reusable:** no
- **Procedural:** no

### gridInsertDraw
- **Does:** Inserts a grid cell into the map position tables, assigns a serialized text array index for the cell, and marks the cell as filled with value "1".
- **Uses:** `table.insert`, `GridSize`, `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 22

### BtnBrowserListMaps
- **Does:** Clears the map browser list, adds one entry per map index from `dsbtext2map`, redraws the browser, selects and sets the current level entry.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `currentLevel`, `dsbtext2map`, `gLastBrowserControlClick`, `gLastSelection`, `gSelectedBtn`, `BtnListBrowserIndex`, `os.time()`
- **Reusable:** no
- **Procedural:** no

### ulistBtnList
- **Does:** Rebuilds the map browser list from `btnListXY`, records each entry's coordinates in `BtnListBrowserIndex`, redraws the browser, restores the last selection, and switches to the dungeon mapper window.
- **Uses:** `God`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `DungeonMapperWindow`, `gLastSelection`, `gLastBrowserControlClick`, `gSelectedBtn`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 22

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event of the browser list button by invoking the list browser control function.
- **Uses:** nothing
- **Reusable:** yes

### uBtnListBrowserControlClicked
- **Does:** Validates the button value, tracks click timing and selection, and either triggers the double-click handler or loads the selected level map.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `MapListCurrentPick`, `time`, `os.time`
- **Reusable:** yes

### updateCurrentLevelMap
- **Does:** Builds a map string from the current level's text array, then if the level map already exists, generates a new map function from the assembled table string and executes it.
- **Uses:** `textArray`, `GridSize`, `currentLevel`, `dsbtext2map`, `dsbtextsethead`, `dsbtextset`, `currentText2MapTable`, `makenewdsbtext`, `CBI`, `CBO`, `string.sub`
- **Reusable:** yes
- **Procedural:** yes

## Part 5 of 22

### saveBSDMAP
- **Does:** Saves the current map text array into a Lua file, formatting the text into 52-character chunks and wrapping the result in a `dsb_text2map` call.
- **Uses:** `MapTextFld`, `MapTextWindow`, `chooseFile`, `io.open`, `gMapPath`, `gMapFile`, `gMapName`, `textArray`, `Q`, `CBI`, `CBO`, `gMapOutFile`, `fileShortNameFromPath`, `dsb_text2map`
- **Reusable:** yes - the 52-character chunking and file-writing logic for map text can be reused for similar map text exports.

### saveMapDSBInsertTextMapOut
- **Does:** Writes a generated Lua file containing the map text array and a `dsbtext2map` table entry, then loads that generated file with `dofile`.
- **Uses:** `currentLevel`, `gMapName`, `DSBMap2TEXTOutFile`, `textArray`, `dsbtext2map`, `CBI`, `CBO`, `io.open`, `dofile`, `gMapPath`
- **Reusable:** yes - the table insertion and file generation pattern for map text output can be reused for similar map text exports.

## Part 6 of 22

### saveMappedXY
- **Does:** Builds the map data text, writes it to the map data file and the level map content file, then closes nothing explicitly beyond the io.open writes.
- **Uses:** `gMapFile`, `gMapName`, `gMapContentFile`, `currentLevel`, `textmapXY`, `gMapButtonColors`, `gMapEnemy`, `gMapFriend`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `CBI`, `CBO`, `Q`, `io.open`, `io.close`, `gameroot`
- **Reusable:** no
- **Procedural:** yes

### wClose
- **Does:** Hides the given FLTK window and sets the window reference to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 22

### fastquickquad
- **Does:** Initializes wall and floor loading if not already done, scales grid coordinates, centers the camera on the mesh centroid, shows all objects, and picks the current level.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `icopyFloors`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `ig3d_ShowAll`, `MapListCurrentPick`, `currentLevel`, `gridSize`, `TheFloor`, `WEWall`, `NSWall`
- **Reusable:** no

### quickquad
- **Does:** Picks the current level, deletes the mesh, reloads walls and floor, iterates the quadwalls, copies walls or floor based on face, adjusts camera position and face, and redraws the mapper window.
- **Uses:** `MapListCurrentPick`, `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `icopyFloors`, `icopyRoofs`, `quadwalls`, `gridSize`, `TheFloor`, `WEWall`, `NSWall`, `getCameraInfo`, `setCameraInfo`, `camera_face_xyz`, `currentLevel`
- **Reusable:** no

### startGrid
- **Does:** Builds a grid of buttons, creates FLTK button widgets with callbacks and tooltips, loads a string to create the button, inserts grid coordinates into a text array, reads the base button color, and redraws the mapper window.
- **Uses:** `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Button`, `keeper:add`, `btnListXY`, `GridSize`, `GridSpread`, `Q`, `loadstring`, `makeabutton`, `textArray`, `x1y1:color`, `keeper:redraw`, `DungeonMapperWindow:redraw`
- **Reusable:** no

## Part 8 of 22

### stackcb
- **Does:** Checks whether the key event is the spacebar, and if so shows the color map; then updates the FLTK interface.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap(nc)`, `fltk_update()`, `Fl:check()`
- **Reusable:** yes
- **Procedural:** no

### convertMapXYToMesh
- **Does:** Updates the current level map, parses the text into a map, saves the mapped coordinates, deletes the existing mesh, builds mesh objects from quad walls, converts the mesh objects table to a mesh, saves the mesh, and saves the new level.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `saveMappedXY()`, `ig3d_DeleteMesh_b(true)`, `render()`, `convertMeshObjectsTableToMesh(gMapName)`, `ig3d_SaveMesh_sf_b(gMapMeshPath,100)`, `saveAsNewLevel()`, globals `quadwalls`, `gridSize`, `face`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `gMapName`, `gMapMeshPath`
- **Reusable:** no
- **Procedural:** yes

## Part 9 of 22

### quadGrid
- **Does:** Rebuilds the current level map by parsing the level text into wall/face entries, then iterates the quadwalls table, computes grid positions, and renders the result; finally saves the new level.
- **Uses:** `updateCurrentLevelMap`, `parseText2Map`, `currentLevel`, `quadwalls`, `gridSize`, `render`, `saveAsNewLevel`, `ig3d_DeleteMesh_b`, `loadstring`, `ClearAllButtons`
- **Reusable:** no
- **Procedural:** yes

### resetAllButtons
- **Does:** Builds a string of button color assignments for every grid cell, loads it as a string, and assigns it to `ClearAllButtons`.
- **Uses:** `GridSize`, `baseBtnColor`, `loadstring`, `ClearAllButtons`
- **Reusable:** yes
- **Procedural:** no

## Part 10 of 22

### recolorMapButtons
**Does:** Iterates the map button color table, prints matching button names, builds a Lua string for the matching button, loads and runs it to recolor buttons for the current level.
**Uses:** `gMapButtonColors`, `currentLevel`, `gMapButtonColors`, `loadstring`, `ReColorAllButtons`, `print`
**Reusable:** no

### resetGrid
**Does:** Initializes empty button and text mapping arrays, fills the text array with zeros across the grid size.
**Uses:** `GridSize`
**Reusable:** yes

### resetDSB
**Does:** Resets DSB-related state variables, loads the DSB global and dungeon conversion scripts from the Data folder, and initializes the spawn and wall state structures.
**Uses:** `GridSize`, `gameroot`, `Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`, `dofile`
**Reusable:** no

## Part 11 of 22

### resetMapper
- **Does:** Resets the dungeon mapper state, grid dimensions, wall and button collections, then redraws the mapper window.
- **Uses:** `ClearAllButtons()`, `resetGrid()`, `recolorMapButtons()`, `DungeonMapperWindow:redraw()`; sets local variables such as `GridSize`, `GridSpread`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnList`, `cubewalls`, `quadwalls`.
- **Reusable:** yes
- **Procedural:** no

### parseTextMapXY
- **Does:** Parses the text map coordinate pairs, clamps each coordinate to `GridSize`, builds a button name, and triggers the corresponding button color change.
- **Uses:** `GridSize`, `textmapXY`, `DungeonMapperWindow`, `loadstring`, `dsbtext2mapButtonChanges`, `tostring`, `tonumber`; writes `act` and `dsbtext2mapButtonChanges`.
- **Reusable:** yes
- **Procedural:** no

### MapListCurrentPick
- **Does:** Selects the given level number, resets the mapper, updates the current level map, parses the level's text map, recolors map buttons, and refreshes the FLTK UI.
- **Uses:** `currentLevel`, `resetMapper()`, `updateCurrentLevelMap()`, `resetAllButtons()`, `parseText2Map(currentLevel)`, `recolorMapButtons()`, `fltk_update()`; reads `n`.
- **Reusable:** yes
- **Procedural:** no

## Part 12 of 22

### openMapFiles
- **Does:** Opens a Lua map file, builds the level map grid, loads the map into the DSB text table, and updates the map button colors and window.
- **Uses:** `chooseFile`, `tTitle`, `gMapPath`, `tFile`, `gameroot`, `string.sub`, `string.find`, `string.rep`, `dofile`, `GridSize`, `levelmapXY`, `dsbtext2map`, `zeromap`, `zeroline`, `gridInsertDraw`, `CBI`, `CBO`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `fileShortNameFromPath`, `gMapName`, `currentLevel`, `BtnBrowserListMaps`, `parseText2Map`, `levelmapColors`, `gMapButtonColors`, `recolorMapButtons`, `DungeonMapperWindow:redraw`
- **Reusable:** no
- **Procedural:** yes

### openMapFiles
- **Does:** Applies the level map color entries to the map button color list and repaints the map buttons.
- **Uses:** `levelmapColors`, `tonumber`, `table.insert`, `gMapButtonColors`, `recolorMapButtons`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 22

### DungeonToolListBrowserCB
- **Does:** Updates the current level map, parses the current level text into a map, then based on the selected tool value either shows brush size controls or lists available characters/enemies for the selected tool.
- **Uses:** `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `w:value()`, `DungeonMapperWindow:make_current()`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `DungeonTools`, `humanlist`, `zombielist`, `meshDrawBrushSize`
- **Reusable:** no
- **Procedural:** no

### DungeonToolOptionsBrowserCB
- **Does:** Reads the selected option value, updates the current level map and parses the current level, then adjusts the brush size for the brush tool, clamps it to the valid range, and updates the option browser; for the Friend and Enemy tools it sets the drop model path based on the selected list entry.
- **Uses:** `w:value()`, `updateCurrentLevelMap()`, `parseText2Map(currentLevel)`, `DungeonTool`, `DungeonToolOptionsBtnVal`, `meshDrawBrushSize`, `DungeonToolOptionsBrowser:clear()`, `DungeonToolOptionsBrowser:add()`, `humanlist`, `zombielist`
- **Reusable:** no
- **Procedural:** no

### updateDungeonToolListBrowser
- **Does:** Ensures the current tool defaults to `"map"` if unset, clears the tool list browser, then adds every entry from `DungeonTools` in order.
- **Uses:** `DungeonTool`, `DungeonToolListBrowser:clear()`, `DungeonToolListBrowser:add()`, `DungeonTools`
- **Reusable:** yes
- **Procedural:** no

## Part 14 of 22

### eraserTool
- **Does:** Removes a button from the button list, clears its mapped text coordinates, updates the serial coordinate and text array entry, builds a button name string, loads a color function for the button, and updates the current level map and button colors.
- **Uses:** `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `baseBtnColor`, `gMapButtonColors`, `updateCurrentLevelMap`, `parseText2Map`, `DungeonMapperWindow`, `loadstring`
- **Reusable:** no
- **Procedural:** no

## Part 15 of 22

### brushQuad
- **Does:** Draws a quad on the current level map by inserting grid cells and updating the map, then refreshes the map button colors and window.
- **Uses:** `GridSize`, `btnList`, `gridInsertDraw`, `updateCurrentLevelMap`, `gMapButtonColors`, `currentLevel`, `parseText2Map`, `recolorMapButtons`, `DungeonMapperWindow:redraw`
- **Reusable:** no
- **Procedural:** yes

### brushQuad
- **Does:** Computes the quad's grid bounds, clamps them to the grid limits, and builds the button name string for each cell.
- **Uses:** `size`, `x`, `y`, `GridSize`, `btnList`
- **Reusable:** no
- **Procedural:** yes

## Part 16 of 22

### gridcb
- **Does:** Handles the click callback for the grid buttons, parsing the tooltip to get grid coordinates, applying the active DungeonTool action, and updating the map state.
- **Uses:** Engine/global calls and state: `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.find()`, `string.len()`, `string.sub()`, `tonumber()`, `gDropx`, `gDropz`, `DungeonTool`, `eraserTool()`, `btnList`, `gridSize`, `gridInsertDraw()`, `w:color()`, `w:value()`, `gMapButtonColors`, `updateCurrentLevelMap()`, `pathMapDraw()`, `gMapFriend`, `icopyModelWalls()`, `meshDrawBrushSize`, `brushQuad()`, `Fl:check()`.
- **Reusable:** no
- **Procedural:** no

### gridcb
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes, copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 17 of 22

### fillmapSaveOptionsBrowser
- **Does:** Rebuilds the save-options browser and list from the chosen and table options, then restores the selected entry and redraws both widgets.
- **Uses:** `mapSaveOptionsListBrowser`, `mapSaveOptionsBrowser`, `mapSaveOptionsTable`, `mapSaveOptionsChosen`, `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsListBrowser:add()`, `mapSaveOptionsListBrowser:clear()`, `mapSaveOptionsListBrowser:selected()`, `mapSaveOptionsListBrowser:select()`, `mapSaveOptionsListBrowser:redraw()`, `mapSaveOptionsBrowser:redraw()`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsAdd
- **Does:** Adds the selected table entry to the chosen options, then refreshes the save-options browser.
- **Uses:** `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsBrowser:value()`, `mapSaveOptionsChosen`, `mapSaveOptionsTable`, `fillmapSaveOptionsBrowser()`
- **Reusable:** yes
- **Procedural:** no

### saveOptionsRemove
- **Does:** Removes the selected entry from the chosen options, then refreshes the save-options browser.
- **Uses:** `mapSaveOptionsListBrowser:value()`, `mapSaveOptionsBrowser:value()`, `mapSaveOptionsChosen`, `fillmapSaveOptionsBrowser()`
- **Reusable:** yes
- **Procedural:** no

### saveMapButtonClicked
- **Does:** Sets the map name from the text input, creates the level folder if it does not exist, then saves the mapped XY data.
- **Uses:** `mapNameTextInput:value()`, `gMapName`, `folderExists()`, `gameroot`, `ig3d_CreateDirectory_s()`, `saveMappedXY()`, `Data/Levels/` path construction
- **Reusable:** no
- **Procedural:** yes

### refreshMapFileLists
- **Does:** Sets the map name and path from the text input, then clears and adds the map path, map XY file and map mesh file paths to the save paths browser.
- **Uses:** `mapNameTextInput:value()`, `gameroot`, `MapSavePathsBrowser:clear()`, `MapSavePathsBrowser:add()`, `Data/Levels/` path construction
- **Reusable:** yes
- **Procedural:** no

### mapNameTextInputCB
- **Does:** Refreshes the map file lists when the map name text input changes.
- **Uses:** `refreshMapFileLists()`
- **Reusable:** yes
- **Procedural:** no

## Part 18 of 22

### openMapSaveWindow
- **Does:** Shows the map save window, sets its current state, restores the saved map name into the map name text input, and refreshes the map file lists.
- **Uses:** `MapSaveWindow:show()`, `MapSaveWindow:make_current()`, `mapNameTextInput:value(gMapName)`, `refreshMapFileLists()`
- **Reusable:** no
- **Procedural:** no

### fillMapperSourceMenu
- **Does:** Builds the source menu for the mapper by adding the New, Open, and Save entries plus an empty line, records their indices, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenu:add()`, `table.insert()`, `MapperMenu:redraw()`, `MapperMenuText.Source`
- **Reusable:** yes
- **Procedural:** no

### fillMapperControlMenu
- **Does:** Adds empty menu lines, adds the Convert to 3D entry with its recorded index, adds another empty line, and redraws the menu with a UI refresh.
- **Uses:** `MapperMenu:add()`, `table.insert()`, `MapperMenu:redraw()`, `fltk_update()`, `MapperMenuText`
- **Reusable:** yes
- **Procedural:** no

### MapperCurrentPick
- **Does:** Resolves the pick value to 1 if it is nil or 0, loads the spawn script for the current level if available, ensures a valid current level, parses the map from the current level, runs spawn and browser setup, redraws the browser, refreshes the UI, and draws the quad grid.
- **Uses:** `BtnBrowserSpawnsOut`, `currentLevel`, `parseText2Map()`, `ButtonSpawnXY()`, `BtnBrowserListMaps()`, `BtnBrowser:redraw()`, `fltk_update()`, `quadGrid()`, `dofile()`
- **Reusable:** no
- **Procedural:** no

## Part 19 of 22

### MapperBrowsersMenuPick
- **Does:** Handles the menu pick for the mapper browser, routing the chosen action to the matching mapper setup or level map actions.
- **Uses:** `BtnBrowser`, `resetMapper`, `newbsdtext2Map`, `currentLevel`, `parseText2Map`, `BtnBrowserListMaps`, `openMapFiles`, `openMapSaveWindow`, `saveMapDSBInsertTextMapOut`
- **Reusable:** no
- **Procedural:** no

### Mapper_menu_callback
- **Does:** Reads the menu widget label, value and text, maps the value to menu index values, and dispatches the pick to the mapper browser or level map conversion logic when the menu head is File or Convert.
- **Uses:** `BtnBrowser`, `w:label`, `w:value`, `w:text`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `updateCurrentLevelMap`, `parseText2Map`, `convertMapXYToMesh`
- **Reusable:** no
- **Procedural:** no

## Part 20 of 22

### Mapper_MenuBarFill
- **Does:** Builds and shows the DungeonMapperWindow, creates its scroll and group widgets, then builds and shows the MapSaveWindow and its browser, button and label widgets.
- **Uses:** `BtnBrowser`, `gLabelTable`, `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `DungeonMapperWindow`, `MapSaveWindow`, `MapSaveTextFld`, `mapSaveOptionsBrowser`, `mapSaveOptionsListBrowser`, `addsaveoptionbtn`, `wClose`, `hide`, `saveOptionsAdd`, `fillMapperSourceMenu`, `fillMapperControlMenu`
- **Reusable:** no
- **Procedural:** no

## Part 21 of 22

### Mapper_MenuBarFill (continued)
- **Does:** Builds the save-map, dungeon tool and list browser widgets, wires their callbacks and labels, and shows the browser window after the widgets are created.
- **Uses:** `fltk:Fl_Button`, `fltk:Fl_Input`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Group`, `gLabelTable`, `MapSaveWindow`, `BtnBrowser`, `MapperMenu`, `DungeonToolListBrowser`, `BtnListBrowser`, `DungeonToolOptionsBrowser`, and callbacks `saveOptionsRemove`, `mapNameTextInputCB`, `saveMapButtonClicked`, `DungeonToolListBrowserCB`, `uBtnListBrowserControlClicked`, `DungeonToolOptionsBrowserCB`, `wClose`, `Mapper_menu_callback`.
- **Reusable:** no
- **Procedural:** no

## Part 22 of 22

### Mapper_MenuBarFill (continued)
- **Does:** Continues the long Mapper_MenuBarFill function by setting up the map text window, its resizable group and browser text field, then showing the dungeon mapper window and starting a timer callback.
- **Uses:** fltk widget creation and configuration calls (`fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `resize`, `type`, `labelsize`, `textsize`, `current`, `resizable`, `size_range`, `show`, `hide`, `redraw`, `callback`, `do_callback`), engine globals (`startGrid`, `resetAllButtons`, `resetDSB`, `Mapper_MenuBarFill`, `MapTextWindow`, `MapTextFld`, `Fl_Group`, `BtnBrowser`, `BtnBrowserListMaps`, `updateDungeonToolListBrowser`, `DungeonMapperWindow`, `timer`, `murgaLua`, `parseText2Map`, `parsePBM2Map`), and `Data/` paths referenced by the surrounding script.
- **Reusable:** no
- **Procedural:** no
