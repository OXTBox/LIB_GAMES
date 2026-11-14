<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw.fl (model spark-x2.6-4b, 2026-11-12 23:14). DRAFT for Claude to review. -->

## DungeonDraw.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK UI designer source for the DungeonDraw mapper tool, which loads the edit level, builds and edits dungeon maps through a grid, and saves the resulting map. It wires the mapper window, grid controls, browser menus, and map-output logic together.
- **Depends on:** `loadLevel("Data/Levels/edit/")`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `ig3d_SetMode_i`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `render`, `saveMapOut`, `ulistBtnList`, `parseDungeon`, `loadstring`, `gLastBrowserControlClick`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLastSelection`, `gLast

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 14

### Top level
- **Does:** Defines the `make_window` function and the `numberofitems` function, with setup code for the window and item parsing.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, `string.gfind`, `string.gfind` related globals (`cr`, `itemDelimiter`, `DelimitedString`).
- **Reusable:** no

### make_window
- **Does:** Opens the window, loads the edit level, sets the engine mode, and initializes the window's data structures and settings for the grid and button lists.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, globals `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a string by splitting on a delimiter, defaulting the delimiter to a comma if not provided.
- **Uses:** `string.gfind`, globals `itemDelimiter`, `DelimitedString`, `numofitems`.
- **Reusable:** yes - pure string and data counting logic.

### Top level
- **Does:** Defines the `make_window` function and the `numberofitems` function, with setup code for the window and item parsing.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, `string.gfind`, `string.gfind` related globals (`cr`, `itemDelimiter`, `DelimitedString`).
- **Reusable:** no

## Part 2 of 14

### Top level
- **Does:** Contains the continuation setup for the file, including the `iloadfloors` code block that initializes `TheFloor` to `nil`.
- **Uses:** nothing
- **Reusable:** no

### item
- **Does:** Splits a delimited string into individual item substrings based on a delimiter, then returns items by index, handling negative indices for reversed lookup.
- **Uses:** `string.gfind`, `string.sub`, `string.find`
- **Reusable:** yes - pure string parsing and indexing logic.
- **Procedural:** no

### idrawquad
- **Does:** Draws a quad mesh at a grid-aligned position, sets up mesh tool state, draws quad edges, and scales the mesh to the configured cube dimensions.
- **Uses:** `math.floor`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `drawVertex`, `drawLine`, `nTagNumber`, `nTagNumber`
- **Reusable:** no
- **Procedural:** yes - generates a mesh geometry object from grid coordinates.

### iloadfloors
- **Does:** Initializes the `TheFloor` variable to `nil` as part of the file's setup code.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 14

### Top level
- **Does:** Contains the trailing `code {-- idrawwallZ` marker that follows the end of `iloadfloors`, with no executable setup, global definitions, or widget configuration shown.
- **Uses:** nothing
- **Reusable:** no

### loadTheFloor
- **Does:** Loads the stone floor mesh, creates a tagged mesh for the floor, positions and scales it, and returns the created mesh tag or nil if the mesh fails to load.
- **Uses:** `gameroot.."Data/WTF/Floors/stone2floor4x4.wtf"`, `nTagNumber`, `TheFloor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`
- **Reusable:** yes
- **Procedural:** no

### iloadfloors
- **Does:** Duplicates the existing floor mesh, moves the duplicate to a grid-aligned position, and returns without doing anything if no floor mesh exists yet.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `savedmode`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `qx`, `qy`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `math.floor`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 14

### idrawwallZ
- **Does:** Draws a wall mesh at a given position and face, computing grid-aligned vertex coordinates for north/south/east/west faces, then creates the mesh, sets its tool and default tag, and renders the face-specific vertex/line commands.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `face`, `drawVertex`, `drawLine`, `loadstring`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `wallstring`, `savedmode`, `QX`, `QY`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Declares the shared wall string tables for north, west, east and south faces, and initializes the WEWall and NSWall shared wall references to nil.
- **Uses:** `wallstring`, `WEWall`, `NSWall`
- **Reusable:** yes
- **Procedural:** no

## Part 5 of 14

### loadTheWalls
- **Does:** Creates a mesh tag for each wall face, loads the matching wall model, adjusts its scale and position, and returns the assigned tag numbers for the west/east and north/south walls.
- **Uses:** `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `vcubewidth`, `vcubelength`, `savedmode`, `WEWall`, `NSWall`, `face`, `meshx`, `meshy`, `meshz`
- **Reusable:** yes
- **Procedural:** no

## Part 6 of 14

### iloadwalls
- **Does:** Computes grid coordinates for a wall face, creates a mesh tag, loads a wall mesh, positions and scales it, then restores the previous mode.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `gameroot`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 14

### icopyWalls
- **Does:** Duplicates the selected wall mesh, places the duplicate at a grid-aligned position depending on the wall face, and returns the mesh to the previous mode.
- **Uses:** `WEWall`, `NSWall`, `nTagNumber`, `quadtag`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `TheFloor`, `face`, `qx`, `qy`
- **Reusable:** yes - a reusable wall duplication and placement routine for grid-aligned mesh placement.
- **Procedural:** yes - generates a new mesh instance at a computed grid-aligned position.

### Top level
- **Does:** Defines the `icopyWalls` function and includes the following top-level code: a browser control setup block that initializes `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, and a comment marking browser code as ahead.
- **Uses:** `os.time`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `code`
- **Reusable:** no - contains setup-only browser control initialization code.
- **Procedural:** no

## Part 8 of 14

### Top level
- **Does:** Contains no setup, globals, or widget definitions outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list browser widget, preserving the last selected button position when possible, and restores the selection state afterward.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Handles the double-click event on the button list browser control by invoking `ulistBtnList`.
- **Uses:** `ulistBtnList`
- **Reusable:** no

## Part 9 of 14

### uBtnListBrowserControlClicked
- **Does:** Handles the click on the browser control button, manages double-click detection, and refreshes the attribute list browser based on the selected button index.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `XYSpawned`, `listSpawnXY()`, `time()`, `os.time()`, `gLastSelection`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the close button and clears its reference when clicked.
- **Uses:** `w:hide()`, `w=nil`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles grid cell clicks, generates a color based on the colormap or random value, extracts coordinates from the tooltip, adds the coordinate to the button list, marks the grid and text map cells, updates the serial coordinate and text array, and refreshes the button list.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `string.len()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 14

### Top level
- **Does:** Defines the FLUID `.fl` file's top-level structure, including the `code {--quadGrid` block that contains the grid-related functions.
- **Uses:** nothing
- **Reusable:** no

### startGrid
- **Does:** Generates the grid button and text map layout by iterating over the grid, creating button and text map entries for each cell, and invoking the button callback.
- **Uses:** `GridSize`, `GridSpread`, `btnListXY`, `textmapXY`, `math.random`, `fltk.fl_color`, `tostring`, `loadstring`, `makeabutton`, `gridcb`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`
- **Reusable:** no

### resestGrid
- **Does:** Resets the grid button and text map entry arrays to their initial empty/zero state by iterating over the grid dimensions.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`
- **Reusable:** yes

### stackcb
- **Does:** Handles the space key event to show the color map, checks for FLTK events, and ends the callback block.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 11 of 14

### Top level
- **Does:** Contains the file-level setup and widget definitions for the DungeonDraw mapper, including the `quadGrid` and `resetMapper` function bodies shown.
- **Uses:** `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `loadTheWalls`, `TheEast`, `TheWest`, `iloadwalls`, `idrawwallZ`, `ig3d_ShowAll`, `DWindow`, `resestGrid`, `loadstring`, `saveMapOut`, `ulistBtnList`, `BtnBrowser`, plus globals `textmapXY`, `quadwalls`, `gridSize`, `baseBtnColor`, `currentLevel`, `GridSize`, `btnListXY`, `textArray`, `ButtonSpawnXY`, `parseDungeon`.
- **Reusable:** no

### quadGrid
- **Does:** Renders the dungeon floor and walls by iterating over the `textmapXY` and `quadwalls` arrays, scaling coordinates by `gridSize`, and drawing quads or walls based on whether floor/wall loading succeeds, then calls `ig3d_ShowAll`.
- **Uses:** `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `loadTheWalls`, `TheEast`, `TheWest`, `iloadwalls`, `idrawwallZ`, `ig3d_ShowAll`, globals `textmapXY`, `quadwalls`, `gridSize`.
- **Reusable:** no

### resetMapper
- **Does:** Resets the mapper state by generating a button color string for every grid cell, executing it via `loadstring`, then calls `resestGrid` and refreshes the UI windows and saved map output.
- **Uses:** `loadstring`, `resestGrid`, `DWindow`, `saveMapOut`, `ulistBtnList`, `BtnBrowser`, globals `GridSize`, `baseBtnColor`, `currentLevel`, `btnListXY`, `textArray`, `ButtonSpawnXY`, `parseDungeon`.
- **Reusable:** no

## Part 12 of 14

### Top level
- **Does:** Contains the file-level setup and widget definitions for the DungeonDraw FLTK mapper, including the `DWindow` widget with its `code` block and the mapper menu functions section.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group` widget definitions; `DWindow:show()`, `startGrid()`, `parseDungeon(1)`, `DWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`; globals `currentLevel`, `textArray`, `dsbtext2map`, `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`; `Data/` paths referenced via `File/` menu entries.
- **Reusable:** no

### saveMapOut
- **Does:** Writes the current dungeon map data as a Lua file for the current level, then appends the map-to-text mapping table to the same file.
- **Uses:** `io.open`, `string.len`, `string.sub`, `string.format`-style concatenation; globals `currentLevel`, `textArray`, `dsbtext2map`; file path `dungeonmap..currentLevel..".lua"` (written to current working directory, not under `Data/`); `io.close`.
- **Reusable:** yes - pure data serialization logic that can be reused for similar map export tasks.

### DWindow
- **Does:** Defines the main mapper window widget with its label, close callback, geometry, resizability settings, and an embedded code block that initializes the mapper UI, starts the grid, parses the dungeon, redraws the window, and sets up a timer for the stack callback.
- **Uses:** `Fl_Window` widget definition with `label`, `callback wClose open`, `xywh`, `type`, `when`, `resizable`, `size_range`, `visible`; code block calls `DWindow:show()`, `startGrid()`, `parseDungeon(1)`, `DWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`; globals `currentLevel`, `textArray`, `dsbtext2map`, `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`.
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with the source menu options, adding each option as a file path entry and redrawing the menu.
- **Uses:** `BtnBrowser` global; `MapperMenuText.Source` table; `MapperMenu:add`, `MapperMenu:redraw`; globals `MapperMenuIndex`, `MapperMenuText`; string concatenation for menu line paths.
- **Reusable:** yes - menu population logic that can be reused for similar source menu setups.
- **Procedural:** no

## Part 13 of 14

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the three listed functions; the file is part 13 of 14 and continues earlier parts.
- **Uses:** nothing
- **Reusable:** no

### fillMapperControlMenu
- **Does:** Builds the map control menu by adding numbered map entries and blank separators to the menu and index tables, then redraws the menu.
- **Uses:** `MapperMenu`, `MapperMenuIndex`, `BtnBrowser`, `dsbtext2map`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** no

### MapperCurrentPick
- **Does:** Prints the pick value, resets the current level to the numeric value of the pick, calls resetMapper and quadGrid.
- **Uses:** `print`, `currentLevel`, `resetMapper`, `quadGrid`
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles browser menu picks: returns early if the browser button is missing, prints the pick, blocks the New option, runs MakeMapper for Duplicate, opens and parses a chosen Lua file for Open, and writes a formatted dungeon map Lua file for Save.
- **Uses:** `BtnBrowser`, `print`, `tPick`, `tFile`, `tTitle`, `chooseFile`, `dofile`, `textmapXY`, `parseDungeon`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `textArray`, `io.open`, `string.len`, `string.sub`, `Q`
- **Reusable:** no

## Part 14 of 14

### Top level
- **Does:** Contains the file-level setup and widget definitions for the DungeonDraw FLUID mapper, including the Mapper menu bar, browser widgets, and MapTextWindow, plus the top-level code block that shows the Mapper window, fills the menu bar, hides the map text window, and runs spawn/UI/map-save/grid setup calls.
- **Uses:** `BtnBrowser`, `MapperMenu`, `BtnListBrowser`, `AttrListBrowser`, `MapTextWindow`, `MapTextFld`, `ButtonSpawnXY`, `ulistBtnList`, `saveMapOut`, `quadGrid`, `fillMapperSourceMenu`, `fillMapperControlMenu`, `Mapper_menu_callback`, `Mapper_MenuBarFill`, `MapTextWindow:hide()`, `BtnBrowser:show()`, `BtnBrowser:redraw()`.
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Handles the Mapper menu bar click, reads the selected menu item and its adjacent menu items, dispatches to the appropriate menu picker based on the selected item, and clears the menu selection after the action.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `Fl:check()`, `io.flush()`.
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the Mapper source and control menus when the Mapper browser window is visible, by calling the two menu fill functions.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`.
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the Mapper browser FLTK window with its close callback, menu bar, list browser widgets, and the top-level code block that shows the Mapper window, fills the menu bar, hides the map text window, runs spawn/UI/map-save/grid setup calls, and redraws the browser.
- **Uses:** `BtnBrowser`, `MapperMenu`, `BtnListBrowser`, `AttrListBrowser`, `ButtonSpawnXY`, `ulistBtnList`, `saveMapOut`, `quadGrid`, `Mapper_MenuBarFill`, `MapTextWindow:hide()`, `BtnBrowser:show()`, `BtnBrowser:redraw()`, `wClose`, `open`, `xywh`, `type`, `Double`, `visible`, `callback`, `Fl_Menu_Bar`, `Fl_Browser`, `labelsize`, `textsize`, `Hold`, `resizable`, `size_range`.
- **Reusable:** no

### MapTextWindow
- **Does:** Defines the map text window FLTK widget with its close callback, a text field browser inside, and the top-level code block that hides the map text window after the Mapper menu bar is filled.
- **Uses:** `MapTextWindow`, `wClose`, `open`, `xywh`, `type`, `Double`, `resizable`, `size_range`, `visible`, `callback`, `Fl_Window`, `Fl_Browser`, `labelsize`, `textsize`, `Hold`, `resizable`.
- **Reusable:** no
