<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw3D.fl (model spark-x2.6-4b, 2026-11-12 23:43). DRAFT for Claude to review. -->

## DungeonDraw3D.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface designer source for the DungeonDraw3D mapper tool, defining the main window, grid editing controls, browser and menu widgets, and their event handling. It drives the dungeon editor workflow by loading the edit level, setting the editor mode, and wiring the mapper UI to the dungeon editor scripts.
- **Depends on:** `loadLevel("Data/Levels/edit/")`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `ig3d_SetMode_i`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetFacePos_b3f`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `ig3d_DeleteMesh_b`, `loadstring`, `lfs.dir`, `murgaLua.createFltkTimer()`, `parseDungeon`, `dsbtext2map`, `ButtonSpawnXY()`, `saveMapOut()`, `editingModeSwitch`, `makeabutton`, `loadLevel`, `load script.lua`, `loadLevel("Data/Levels/edit/")`, `Data/Wtf/Floors/stone2floor4x4.wtf`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `Data/Wtf/Walls/stone2floor4x4.wtf`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `Data/Wtf/`, `Data/Wtf/Floors/`, `Data/Wtf/Walls/`, `Data/Levels/`, `Data/Levels/edit/`, `Data/Levels/X`, `Data/`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 15

### Top level
- **Does:** Defines the `make_window` function and the `numberofitems` function, plus file-level setup variables and constants for the FLTK UI window.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, `string.gfind`, `string.gfind` related globals, and file-level variables such as `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`.
- **Reusable:** no

### make_window
- **Does:** Opens the FLTK UI window for the DungeonDraw3D mapper, loads the edit level, sets the engine mode, and initializes the window's data structures and variables.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `math.random`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, and file-level variables `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a comma-delimited string by splitting on the delimiter and counting the matches.
- **Uses:** `string.gfind`, `string.gfind` related globals, and the parameters `itemList`, `itemDelimiter`.
- **Reusable:** yes

### Top level
- **Does:** Contains file-level setup code, string helper definitions, and constants outside the functions.
- **Uses:** `string.gfind` related globals, `math.random`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, and file-level variables `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`.
- **Reusable:** no

## Part 2 of 15

### Top level
- **Does:** Contains the trailing `code {--loadFloors` block that sets `TheFloor=nil`, with no functions defined in this section.
- **Uses:** nothing
- **Reusable:** no

### item
- **Does:** Splits a delimited string into individual items based on a delimiter, then returns the requested item by index, handling negative indices as reversed lookups.
- **Uses:** `string.gfind`, `string.sub`, `string.find`
- **Reusable:** yes - pure string parsing logic that can be reused for similar delimited string extraction tasks.

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned vertex coordinates, creating a new mesh tag, setting mesh tool and selection mode, drawing quad boundary lines, and scaling the mesh to the configured grid dimensions.
- **Uses:** `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `ig3d_GetMode__i`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`
- **Reusable:** no

### loadFloors
- **Does:** Sets `TheFloor` to `nil`, with no further logic in this section.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 15

### Top level
- **Does:** Contains the trailing `code {-- idrawWallZ` fragment that follows the three functions, with no setup, global definitions, or widget definitions shown.
- **Uses:** nothing
- **Reusable:** no

### loadTheFloor
- **Does:** Loads the stone floor mesh from the Data folder, tags it with an incrementing tag number, creates the mesh object, and scales it to the current grid dimensions before returning the mesh tag. If the mesh fails to load, it sets the mesh to nil and returns nil.
- **Uses:** `gameroot.."Data/WTF/Floors/stone2floor4x4.wtf"`, `nTagNumber`, `TheFloor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`, `vcubez`
- **Reusable:** yes
- **Procedural:** no

### icopyFloors
- **Does:** Duplicates the existing floor mesh, moves it to the grid position specified by qx and qy, and returns the new mesh tag. It returns early if no floor mesh exists yet.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `savedmode`
- **Reusable:** yes
- **Procedural:** no

### icopyRoofs
- **Does:** Duplicates the existing floor mesh, moves it to the grid position specified by qx and qy at the cube height level, and returns the new mesh tag. It returns early if no floor mesh exists yet.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `vcubeheight`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `savedmode`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 15

### idrawWallZ
- **Does:** Draws a wall quad for a given face by computing grid coordinates, creating a tagged mesh, setting its face position and scale, and executing the corresponding vertex/line drawing code.
- **Uses:** Engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`; globals `vcubewidth`, `vcubeheight`, `vcubelength`, `vgridwidth`, `nTagNumber`, `quadtag`, `savedmode`, `wallstring`, `drawVertex`, `drawLine`; file/code references `loadstring(wallstring["west"])` and `loadstring(wallstring["north"])`.
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Defines the shared wall tag variables `WEWall` and `NSWall` as nil at the start of the `loadTheWalls` code block.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 5 of 15

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall mesh, positions it far away, and returns the assigned wall tag number for the face.
- **Uses:** `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `face`, `theMesh`, `WEWall`, `NSWall`, `savedmode`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 15

### icopyWalls
- **Does:** Duplicates a wall mesh at a specified grid position and face, then positions and scales the new mesh to match the wall’s grid cell.
- **Uses:** `WEWall`, `NSWall`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `math.floor`, globals `savedmode`, `nTagNumber`, `quadtag`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `face`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** No top-level code outside the `icopyWalls` function.
- **Uses:** nothing
- **Reusable:** yes

## Part 7 of 15

### iloadWalls
- **Does:** Loads a wall mesh for a given face and position, creating a mesh tag for the wall and placing it at the computed grid coordinates.
- **Uses:** Engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `gameroot`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, globals `QX`, `QY`, `nTagNumber`, `quadtag`, `theMesh`, `savedmode`, `face`, `qx`, `qy`; files `Data/Wtf/Walls/EWwall4x4.wtf` and `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Defines the `iloadWalls` function body, including wall string setup, face-based coordinate calculation, mesh creation and placement logic, and ends the function with empty closing braces.
- **Uses:** Engine calls and globals as listed in `iloadWalls` above; no additional engine calls, globals, files or `Data/` paths beyond those used inside the function.
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 15

### Top level
- **Does:** Contains no setup, globals, or widget definitions outside the two listed functions; the file consists solely of the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list browser UI, preserving the last selected button position when possible, and restores the prior selection state after redrawing.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `gLastSelection`, `btnListXY`, `DWindow`
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event on the button list browser control by invoking `ulistBtnList` to refresh the list.
- **Uses:** `ulistBtnList`
- **Reusable:** no

## Part 9 of 15

### uBtnListBrowserControlClicked
- **Does:** Handles the click on the button list browser control, selecting an item, refreshing the attribute list browser, and updating the last selection timestamp.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `XYSpawned`, `listSpawnXY()`, `time()`, `os.time()`, `btnList`, `btnListXY`, `textmapXY`, `serialXY`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the close button widget and clears its reference when clicked.
- **Uses:** `w:hide()`, `w=nil`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles the grid callback, generates a color for the widget, extracts coordinates from the tooltip, adds the coordinate to the button list if not present, marks the coordinate as used, updates the serial coordinate and text array, and refreshes the button list.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `string.len()`, `btnList`, `btnListXY`, `textmapXY`, `serialXY`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 15

### Top level
- **Does:** Defines the file's grid-related functions and contains the FLUID UI code block for the quadGrid mapper.
- **Uses:** nothing
- **Reusable:** no

### startGrid
- **Does:** Iterates over the grid, creates button and text map entries for each cell, generates button scripts via `loadstring`, and triggers redraws of the keeper and DWindow.
- **Uses:** `GridSize`, `GridSpread`, `btnListXY`, `textmapXY`, `fltk.fl_color`, `tostring`, `math.random`, `loadstring`, `makeabutton`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`
- **Reusable:** no

### resestGrid
- **Does:** Resets the grid button and text map entries to empty/zeroed state for all grid cells.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`
- **Reusable:** yes

### stackcb
- **Does:** Checks for the space key event to show the color map, then calls `Fl:check()`.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 11 of 15

### quadGrid
- **Does:** Builds the dungeon walls and floor quads from the quadwalls and textmapXY tables, then renders, selects, combines, saves the mesh, and switches editing mode.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `quadwalls`, `textmapXY`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `idrawWallZ`, `icopyRoofs`, `icopyFloors`, `idrawQuad`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `gameroot`, `currentLevel`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the trailing `code {-- Reset all buttons` block that follows the quadGrid function, with no additional visible logic described in this code.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 12 of 15

### Top level
- **Does:** Contains the file's top-level widget definitions and global setup for the DungeonDraw3D mapper, including the `DWindow` FLTK window and its nested scroll/group widgets.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group` (FLTK UI widgets), `DWindow` (the defined FLTK window), `murgaLua.createFltkTimer()` (host global).
- **Reusable:** no

### resetMapper
- **Does:** Renders the grid button color string, executes it via `loadstring`, resets the grid state, redraws the window, clears text/button coordinate arrays, parses the current level, spawns button coordinates, and redraws the window and other UI elements before saving the map output.
- **Uses:** `loadstring`, `DWindow:redraw()`, `resestGrid()`, `parseDungeon`, `ButtonSpawnXY()`, `saveMapOut()`, `ulistBtnList()`, `BtnBrowser:redraw()`, `currentLevel`, `GridSize`, `baseBtnColor`, `textmapXY`, `textArray`, `btnListXY`, `ButtonSpawnXY()`.
- **Reusable:** no

### saveMapOut
- **Does:** Writes the dungeon map data to a Lua file named `dungeonmap` followed by the current level number, formatting the text array into a valid Lua table string, appending the dsb text-to-map mapping, and closing the file.
- **Uses:** `io.open`, `textArray`, `dsbtext2map`, `currentLevel`, `Q`, `string.len`, `string.sub`, `io.close`.
- **Reusable:** yes - data formatting and file writing logic for map output.

### DWindow
- **Does:** Defines the main mapper window widget with its label, close callback, positioning, resizability, visible state, nested scroll and group widgets, and top-level code that shows the window, starts the grid, redraws the window, and sets up a timer callback for the stack callback.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `DWindow:show()`, `startGrid()`, `DWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback`, `timer:do_callback()`, `wClose`.
- **Reusable:** no

## Part 13 of 15

### Top level
- **Does:** Contains no setup, global definitions, or widget definitions outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the source menu with File/ entries from MapperMenuText.Source, adds a blank line, and refreshes the menu.
- **Uses:** BtnBrowser, MapperMenu, MapperMenuText.Source, MapperMenuIndex, table.insert, MapperMenu:add, MapperMenu:redraw
- **Reusable:** no

### fillMapperControlMenu
- **Does:** Populates the control menu with Maps/ entries for indices 0 through dsbtext2map-1, adds two blank lines, and refreshes the menu. The All/ control loop is commented out.
- **Uses:** BtnBrowser, dsbtext2map, MapperMenu, MapperMenuText (referenced in commented code), MapperMenuIndex, table.insert, MapperMenu:add, MapperMenu:redraw
- **Reusable:** no

### MapperCurrentPick
- **Does:** Prints the pick value, converts it to a number for currentLevel, calls resetMapper(), then calls quadGrid().
- **Uses:** tPick, currentLevel, resetMapper, quadGrid
- **Reusable:** no

## Part 14 of 15

### Top level
- **Does:** Contains no setup, global definitions, or widget definitions outside the two mapped functions; the file consists solely of the two function definitions below.
- **Uses:** nothing
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles the pick action for the mapper browser menu, routing the selected pick value to the appropriate mapper workflow actions such as creating a new mapper, opening a mapper file, or saving the mapper text.
- **Uses:** `BtnBrowser`, `MakeMapper`, `chooseFile`, `dofile`, `textmapXY`, `resetMapper`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `gameroot`, `io.open`, `string.len`, `string.sub`, `print`
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Reads the current menu value, pick value, and menu head from the mapper menu widget, maps the value to menu head indices, and dispatches the pick to the appropriate mapper menu handler or clears the current mapper.
- **Uses:** `BtnBrowser`, `w:label()`, `w:value()`, `w:text()`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `Fl:check()`, `io.flush()`
- **Reusable:** no

## Part 15 of 15

### Top level
- **Does:** Defines the FLUID window widgets BtnBrowser and MapTextWindow, their menu bar and browser fields, and the code block that shows BtnBrowser, calls Mapper_MenuBarFill, hides MapTextWindow, and redraws BtnBrowser.
- **Uses:** `BtnBrowser`, `MapTextWindow`, `BtnListBrowser`, `AttrListBrowser`, `MapperMenu`, `MapTextFld`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`, `BtnBrowser:show()`, `MapTextWindow:hide()`, `BtnBrowser:redraw()`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if BtnBrowser is nil, then fills the mapper source menu and mapper control menu.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the FLUID window BtnBrowser with a close callback, a menu bar with the Mapper_menu_callback, and two Hold-type browser fields for the list and attribute browsers.
- **Uses:** `BtnBrowser`, `wClose`, `MapperMenu`, `Mapper_menu_callback`, `BtnListBrowser`, `AttrListBrowser`, `uBtnListBrowserControlClicked`
- **Reusable:** no

### MapTextWindow
- **Does:** Defines the FLUID window MapTextWindow with a close callback, a resizable browser field for the map text field, and a size range.
- **Uses:** `MapTextWindow`, `wClose`, `MapTextFld`, `size_range {329 263 331 579}`
- **Reusable:** no
