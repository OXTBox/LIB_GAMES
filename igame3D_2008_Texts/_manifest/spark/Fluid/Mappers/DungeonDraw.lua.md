<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw.lua (model spark-x2.6-4b, 2026-11-12 23:20). DRAFT for Claude to review. -->

## DungeonDraw.lua
- **Kind:** tool
- **Purpose:** DungeonDraw is a 2008 iGame3D 3D game engine tool that builds and renders a dungeon grid map through a FLTK-based mapper UI. It loads an edit level, lets the user place and configure floor and wall quads on a grid, renders the resulting dungeon, and saves the map data as a Lua file.
- **Depends on:** `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `Data/WTF/Floors/stone2floor4x4.wtf`, `Data/Levels/edit/` (via `loadLevel`), engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMeshTool_i`, `ig3d_SetMode_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMode_i`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMeshTool_i`, `ig3d_SetMode_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMode_i`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMeshTool_i`, `ig3d_SetMode_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMode_i`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMeshTool_i`, `ig3d_SetMode_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMode_i`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMeshTool_i`, `ig3d_SetMode_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMode_i`, `ig3d_DuplicateMesh`, `ig

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 13

### Top level
- **Does:** Sets up global variables and UI state for the DungeonDraw mapper, loads the edit level, enables edit mode, and defines helper globals for item counting and string handling.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, globals `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `cr`, `itemDelimiter`, and `Q`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a delimited string by splitting on the given delimiter and counting the matches.
- **Uses:** `string.gfind`, globals `DelimitedString`, `itemDelimiter`, and `numofitems`.
- **Reusable:** yes - pure string and data counting logic.
- **Procedural:** no

## Part 2 of 13

### Top level
- **Does:** Contains the single top-level line `TheFloor=nil` that initializes the floor reference variable to nil.
- **Uses:** nothing
- **Reusable:** yes

### item
- **Does:** Splits a delimited string into individual item substrings, then returns the requested item by index, handling both positive and negative indices.
- **Uses:** `string.gfind`, `string.sub`, `string.find`, `n`, `ofwhatString`, `itemDelimiter`, `itemResults`, `numofitems`, `counter`
- **Reusable:** yes - pure string parsing and indexing logic

### idrawquad
- **Does:** Draws a quad mesh at a given grid position, sets up the mesh tool state, and scales the selected mesh to the current viewport dimensions.
- **Uses:** `qx`, `qy`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `savedmode`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** yes - generates a mesh object and its vertex/line geometry from numeric grid coordinates

### iloadfloors
- **Does:** No code is present for this function in this part.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 3 of 13

### loadTheFloor
- **Does:** Loads the stone floor mesh into a named mesh tag, positions and scales it, and returns the created mesh tag or nil if the mesh fails to load.
- **Uses:** `gameroot`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`, `Data/WTF/Floors/stone2floor4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

### iloadfloors
- **Does:** Duplicates the existing floor mesh, moves the duplicate to a grid-aligned position, and returns without doing anything if no floor mesh exists yet.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `qx`, `qy`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `math.floor`, `meshx`, `meshy`, `meshz`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 13

### idrawwallZ
- **Does:** Draws a wall mesh at a given position and face, computing grid-aligned vertex coordinates for the face, then creates and configures the mesh, draws its geometry, and resets the tool mode.
- **Uses:** Engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`; globals `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `nTagNumber`, `quadtag`, `savedmode`, `wallstring`, `drawVertex`, `drawLine`, `loadstring`; Data paths: none directly.
- **Reusable:** yes - the face coordinate calculation and mesh creation/configuration pattern for wall drawing can be reused for other wall types.
- **Procedural:** yes - generates a wall mesh geometry from the face and position parameters.

### idrawwallZ
- **Does:** Nothing additional; this is the only function in the part.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 5 of 13

### Top level
- **Does:** Records the last browser control click time and resets selection-related globals before the browser button list code begins.
- **Uses:** `os.time()`, globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`.
- **Reusable:** yes

### iloadwalls
- **Does:** Loads a wall mesh at a computed grid position for a given face, creates a mesh tag, sets mesh tool and default mesh settings, positions the mesh, and restores the saved mode.
- **Uses:** Engine calls `math.floor`, `ig3d_GetMode__i`, `ig3d_SelectWholeMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, plus globals/paths `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `quadtag`, `face`, `savedmode`, `theMesh`, `gameroot`, `wallstring`.
- **Reusable:** no
- **Procedural:** yes

## Part 6 of 13

### ulistBtnList
- **Does:** Rebuilds the button list browser widget, preserving the current selection when the list changes, and switches back to the main window.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Rebuilds the button list browser when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 13

### uBtnListBrowserControlClicked
- **Does:** Handles the click of the list browser button, selecting an attribute list entry, clearing and repopulating the attribute list browser, and updating the last selection state.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `XYSpawned`, `listSpawnXY()`, `time()`, `os.time()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and releases its reference by setting it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles grid button clicks, computes a color from the colormap or random value, extracts coordinates from the tooltip, appends the coordinate to the button list if not present, marks the coordinate as used, sets the text array value, and updates the button color and value.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `string.len()`, `tostring()`, `table.insert()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 13

### startGrid
- **Does:** Builds the grid of buttons and text map entries for the current grid size, then redraws the button list and main window.
- **Uses:** `GridSize`, `GridSpread`, `Q`, `btnListXY`, `textmapXY`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `makeabutton`, `loadstring`, `keeper`, `DWindow`, `gridcb`
- **Reusable:** no
- **Procedural:** yes

### resestGrid
- **Does:** Resets the button and text map arrays for every grid cell back to their default empty/zero state.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`
- **Reusable:** yes

### stackcb
- **Does:** Checks whether the space key is pressed and shows the color map if so, then checks FLTK for events.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 9 of 13

### quadGrid
- **Does:** Renders the dungeon grid by iterating the textmapXY and quadwalls arrays, drawing floor quads or wall quads at grid coordinates, then calls ig3d_ShowAll to display the result.
- **Uses:** Engine calls `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `ig3d_ShowAll`, `DWindow:redraw`; globals `textmapXY`, `quadwalls`, `gridSize`, `baseBtnColor`; files implied by the Data/ path convention for the floor/wall load functions.
- **Reusable:** no

### resetMapper
- **Does:** Resets the mapper state by rebuilding the button color string for the grid, executing it via loadstring, then calls resestGrid, redraws the window and related UI elements, and re-parses the current level.
- **Uses:** Engine calls `DWindow:redraw`, `loadstring`, `resestGrid`; globals `GridSize`, `baseBtnColor`, `textmapXY`, `textArray`, `btnListXY`, `currentLevel`, `parseDungeon`, `ButtonSpawnXY`, `saveMapOut`, `ulistBtnList`, `BtnBrowser:redraw`; file paths implied by the Data/ path convention for the level parsing and map saving functions.
- **Reusable:** no

## Part 10 of 13

### Top level
- **Does:** Sets up the DungeonDraw window and its initial UI state, then starts the dungeon map parsing and timer-driven callback flow.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `Fl_Group`, `startGrid()`, `parseDungeon(1)`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `DWindow:show()`, `DWindow:redraw()`.
- **Reusable:** no

### saveMapOut
- **Does:** Writes the current dungeon map data as a Lua file named after the current level, then appends the map-to-text mapping table to the same file.
- **Uses:** `io.open`, `currentLevel`, `textArray`, `dsbtext2map`, `Q`, `string.len`, `string.sub`, `tFile:write`, `io.close`.
- **Reusable:** yes - string concatenation and file write logic for map serialization.
- **Procedural:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, Save, Duplicate entries pointing to the File/ directory, adds an empty trailing entry, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu:add`, `MapperMenuIndex`, `MapperMenu:redraw()`.
- **Reusable:** yes - menu population logic using existing menu and index tables.
- **Procedural:** no

## Part 11 of 13

### fillMapperControlMenu
- **Does:** Builds the map control menu with map entries and empty separator lines, then marks the menu for redrawing.
- **Uses:** `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `dsbtext2map`, `MapperMenuText`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Prints the pick value, sets the current level from the pick, resets the mapper, and redraws the quad grid.
- **Uses:** `print`, `tonumber`, `currentLevel`, `resetMapper`, `quadGrid`
- **Reusable:** yes

### MapperBrowsersMenuPick
- **Does:** Handles browser menu picks for new, duplicate, open and save actions, opening a chosen Lua file, parsing the dungeon map, and saving the map text to a file.
- **Uses:** `BtnBrowser`, `tPick`, `MakeMapper`, `chooseFile`, `tTitle`, `tFile`, `dofile`, `textmapXY`, `parseDungeon`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `textArray`, `io.open`, `string.len`, `string.sub`, `Q`
- **Reusable:** no

## Part 12 of 13

### Mapper_menu_callback
- **Does:** Handles the mapper menu button callback. It reads the button label, value and text, resolves the corresponding menu index, and dispatches the chosen menu action or clear action, then flushes the IO stream.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `MapperAllMenuPick`, `MapperCurrentPick`, `item`, `Fl:check`, `io.flush`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 13

### Top level
- **Does:** Sets up the DungeonDraw mapper UI widgets, runs the mapper menu fill, and starts the FLTK application loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `BtnBrowser`, `MapperMenu`, `MapTextWindow`, `MapTextFld`, `Fl_Group`, `Fl:run()`, plus the mapper UI setup code outside functions.
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is nil, then fills the mapper source and control menus.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`.
- **Reusable:** no

### ButtonSpawnXY
- **Does:** Not shown in this code section; no implementation details available.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

### ulistBtnList
- **Does:** Not shown in this code section; no implementation details available.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

### saveMapOut
- **Does:** Not shown in this code section; no implementation details available.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

### quadGrid
- **Does:** Not shown in this code section; no implementation details available.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no
