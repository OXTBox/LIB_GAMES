<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw3D8.lua (model spark-x2.6-4b, 2026-11-13 00:32). DRAFT for Claude to review. -->

## DungeonDraw3D8.lua
- **Kind:** tool
- **Purpose:** This file is a mapper tool for the iGame3D engine, used to edit and build dungeon level maps through a FLTK-based UI. It loads the DSB_Dungeons conversion script, builds grids of walls, floors, and roofs, and provides menu and save/load flows for the mapper workflow.
- **Depends on:** `Data/Scripts/Convert/DSB_Dungeons.lua` (loaded via `dofile`), `Data/` paths written in the file (`Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `Data/WTF/Dungeons/DM<currentLevel>.wtf`, `Data/WTF/Floors/stone2floor4x4.wtf`), engine calls (`ig3d_*` mesh/object operations, `make`, `get`, `getObjectInfo`, `setObjectInfo`), globals from other files (`Q`, `baseBtnColor`, `gObjects`, `gMapFile`, `currentLevel`, `nTagNumber`, `WEWall`, `NSWall`, `TheFloor`, `quadwalls`, `textArray`, `GridSize`, `GridSpread`, `delimitedString`, `itemDelimiter`, `DelimitedString`, `numofitems`, `itemList`, `face`, `qx`, `qy`, `savedmode`, `meshx`, `meshy`, `meshz`, `quadtag`, `XYSpawned`, `XYSpawned`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `AttrListBrowser`, `listSpawnXY`, `DWindow`, `MapTextFld`, `MapTextWindow`, `MapTextWindow`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`, `Mapper_MenuBarFill`, `Mapper_menu_callback`, `MapperCurrentPick`, `MapperBrowsersMenuPick`, `MapperAllMenuPick`, `dungeonout`, `parseDungeon`, `dsbtext2map`, `tFile`, `tFile:write`, `dsbtext2map`, `chooseFile`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Group`, `fltk:Fl_Double_Window`, `fltk.fl_show_colormap`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `fltk:Fl_Group`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_D

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 17

### Top level
- **Does:** Sets up global variables and engine calls for the DungeonDraw3D8 mapper, including loading the edit level, switching engine mode, loading the DSB conversion script, and defining string helpers.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`, globals such as `Q`, `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `gMapFile`, `DelimitedString`, `numofitems`, `cr`, `itemDelimiter`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a delimited string by splitting on the given delimiter and incrementing a counter for each match.
- **Uses:** `string.gfind`, globals `itemList`, `itemDelimiter`, `DelimitedString`, `numofitems`.
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 17

### item
- **Does:** Splits a delimited string into individual item substrings, then returns the nth item by index, handling negative indices as reversed lookups.
- **Uses:** `string.gfind`, `string.sub`, `string.find`; local variables `itemResults`, `delimitedString`, `counter`, `numofitems`, `subset`, `delimiterstart`, `delimiterend`, `subresult`, `n`, `ofwhatString`, `itemDelimiter`.
- **Reusable:** yes - pure string parsing and indexing logic.

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned vertex coordinates, creating a mesh tag, setting mesh tool and default mesh settings, drawing quad boundary lines, and scaling the mesh to the configured cubewidth and cubelength.
- **Uses:** `math.floor`, engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, plus globals `QX`, `QY`, `nTagNumber`, `quadtag`, `savedmode`, `meshx`, `meshy`, `meshz`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`; local variables `qx`, `qy`.
- **Reusable:** no - depends on engine-specific mesh and grid state.
- **Procedural:** yes - generates a mesh object and its associated quad geometry from input coordinates.

## Part 3 of 17

### loadTheFloor
- **Does:** Loads the stone floor mesh, tags it with an incrementing tag number, positions and scales it, and returns the created mesh object or nil if the load fails.
- **Uses:** `gameroot`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`, `theMesh`, `Data/WTF/Floors/stone2floor4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

### icopyFloors
- **Does:** Duplicates the loaded floor mesh, moves it to the grid position given by qx and qy, and returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `math.floor`, `qx`, `qy`
- **Reusable:** yes
- **Procedural:** yes

### icopyRoofs
- **Does:** Duplicates the loaded floor mesh, moves it to the grid position given by qx and qy at the cube height, and returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `vgridlength`, `math.floor`, `qx`, `qy`
- **Reusable:** yes
- **Procedural:** yes

## Part 4 of 17

### Top level
- **Does:** Declares the two wall-related object references as `nil` at the start of the file, continuing the earlier parts of the mapper script.
- **Uses:** nothing
- **Reusable:** no

### idrawWallZ
- **Does:** Draws a wall mesh for a given face position and face direction, computing grid-aligned vertex coordinates for the face, creates a mesh tag, sets mesh tool and default mesh settings, draws the wall geometry via string evaluation, positions and scales the mesh, then restores the previous mode.
- **Uses:** `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `math.floor`, `ig3d_GetMode__i`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `loadstring`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 17

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall mesh, positions it far away, and returns the assigned wall tag number for north/south or west/east.
- **Uses:** `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `face`, `theMesh`, `WEWall`, `NSWall`, `savedmode`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** yes

### loadTheWalls
- **Does:** assigns the created mesh tag to WEWall or NSWall, loads the corresponding wall mesh, positions it at (10000, 10000, 10000), and returns the assigned wall tag number based on the face.
- **Uses:** `face`, `WEWall`, `NSWall`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** no
- **Procedural:** yes

## Part 6 of 17

### icopyWalls
- **Does:** Duplicates a wall mesh at a given grid position and face, then positions and scales the new mesh so it fits the grid cell.
- **Uses:** `WEWall`, `NSWall`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `math.floor`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `qx`, `qy`, `face`
- **Reusable:** yes - a reusable wall duplication and grid placement routine for 3D level building.
- **Procedural:** yes - generates a new mesh object from an existing wall mesh and grid parameters.

## Part 7 of 17

### Top level
- **Does:** Records the last browser control click time, resets the last selection index, clears the selected button name, and initializes the browser button list as an empty table.
- **Uses:** `os.time()`, globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`
- **Reusable:** yes

### iloadWalls
- **Does:** Loads a wall mesh for the given face at the specified grid coordinates, creates a mesh tag for the wall, selects it, positions it, and scales it to the cube dimensions.
- **Uses:** globals `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `quadtag`, `savedmode`, `theMesh`, `face`, `QX`, `QY`, engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `ig3d_ScaleSelectedMeshTo_3f`, `math.floor`; file paths `gameroot.."Data/Wtf/Walls/EWwall4x4.wtf"` and `gameroot.."Data/Wtf/Walls/NSwall4x4.wtf"`
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 17

### ulistBtnList
- **Does:** Rebuilds the button list browser widget from the current button list coordinates, preserving the last selected button, then returns to the main window.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** no
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Triggers the button list browser rebuild when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 17

### uBtnListBrowserControlClicked
- **Does:** Handles the click of the browser control button, selecting an attribute list entry, clearing and repopulating the attribute browser list, and tracking the last selection and click time.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser`, `listSpawnXY`, `XYSpawned`, `time`, `os.time`, `btnList`, `btnListXY`, `textmapXY`, `serialXY`, `textArray`, `GridSize`, `ulistBtnList`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and releases its reference by setting it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Gets the button tooltip, optionally shows the color map, picks a random or tooltip-based color, updates the button color and value, and records the button's grid position in the button and text map tables.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap`, `math.random`, `string.sub`, `string.find`, `tonumber`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 17

### startGrid
- **Does:** Builds the grid of buttons and text entries for the mapper, then redraws the window and keeper.
- **Uses:** `textArray`, `btnListXY`, `textmapXY`, `GridSize`, `GridSpread`, `Q`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `makeabutton`, `loadstring`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`
- **Reusable:** no
- **Procedural:** yes

### resetGrid
- **Does:** Clears the grid state and rebuilds the empty button and text entry tables for every grid cell.
- **Uses:** `btnListXY`, `textmapXY`, `textArray`, `GridSize`
- **Reusable:** yes

### stackcb
- **Does:** Handles the space key event to show the color map, then checks for FLTK events.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 11 of 17

### quadGrid
- **Does:** Builds the dungeon mesh by iterating wall and floor grid entries, copying or drawing walls and floors, then renders, selects, combines, saves the mesh and switches editing mode.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `icopyWalls`, `idrawWallZ`, `icopyRoofs`, `icopyFloors`, `idrawQuad`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, plus globals `WEWall`, `NSWall`, `TheFloor`, `quadwalls`, `textmapXY`, `gridSize`, `polycount`, `currentLevel`, `gameroot`; reads/writes `Data/WTF/Dungeons/DM<currentLevel>.wtf`.
- **Reusable:** no
- **Procedural:** yes

### icopyWalls
- **Does:** Copies wall geometry for a given grid position and face when both wall loaders are available.
- **Uses:** `icopyWalls` (called from `quadGrid` with `x`, `y`, `face` arguments).
- **Reusable:** no

### idrawWallZ
- **Does:** Draws wall geometry for a given grid position and face when wall loading is unavailable.
- **Uses:** `idrawWallZ` (called from `quadGrid` with `x`, `y`, `face` arguments).
- **Reusable:** no

### icopyRoofs
- **Does:** Copies roof geometry for a given grid position when the floor object exists.
- **Uses:** `icopyRoofs` (called from `quadGrid` with `x`, `y` arguments).
- **Reusable:** no

### icopyFloors
- **Does:** Copies floor geometry for a given grid position when the floor object exists.
- **Uses:** `icopyFloors` (called from `quadGrid` with `x`, `y` arguments).
- **Reusable:** no

### idrawQuad
- **Does:** Draws quad geometry for a given grid position when the floor object does not exist.
- **Uses:** `idrawQuad` (called from `quadGrid` with `x`, `y` arguments).
- **Reusable:** no

### lookbutton
- **Does:** Invokes the look button action after switching to select_entity editing mode.
- **Uses:** `lookbutton` (called from `quadGrid`).
- **Reusable:** no

## Part 12 of 17

### resetMapper
- **Does:** Resets the mapper UI state, rebuilds the button color string and loads it, then reconfigures the mapper grid variables and loads the dungeon conversion script.
- **Uses:** `GridSize`, `baseBtnColor`, `DWindow`, `loadstring`, `dofile`, `gameroot`, `Data/Scripts/Convert/DSB_Dungeons.lua`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 17

### Top level
- **Does:** Sets up the DWindow FLTK double window and its initial UI state, then starts the grid and timer-based map rendering flow.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `DWindow`, `Fl_Group`, `startGrid`, `murgaLua.createFlTimer`, `stackcb`, `MapperMenuIndex`, `MapperMenuText`, `MapperMenu`
- **Reusable:** no

### saveMapOut
- **Does:** Writes the current map data as a Lua file named after the current level, then appends the dsb text-to-map mapping to the same file.
- **Uses:** `io.open`, `currentLevel`, `textArray`, `dsbtext2map`, `Q`, `string.len`, `string.sub`, `tFile:write`, `io.close`
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, Save, Duplicate entries plus an empty entry, and tracks the menu items in the menu index table.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu`, `MapperMenuIndex`
- **Reusable:** yes
- **Procedural:** no

## Part 14 of 17

### Top level
- **Does:** Contains one line of code, initializing the global `gMapFile` to an empty string.
- **Uses:** nothing
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Builds a menu of map entries from the current map index, appends blank menu lines, redraws the mapper menu, and inserts the corresponding entries into the mapper menu index table.
- **Uses:** `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `dsbtext2map`, `MapperMenu:add`, `MapperMenu:redraw`, `table.insert`
- **Reusable:** no

### MapperCurrentPick
- **Does:** Prints the pick argument and current map file, resets the mapper, loads the map file, sets the current level, runs the dungeon output and conversion script, parses the dungeon, and refreshes the mapper UI.
- **Uses:** `print`, `gMapFile`, `resetMapper`, `dofile`, `currentLevel`, `dungeonout`, `parseDungeon`, `ButtonSpawnXY`, `ulistBtnList`, `Mapper_MenuBarFill`, `BtnBrowser:redraw`, `quadGrid`
- **Reusable:** no

### gMapFile
- **Does:** Initializes the global `gMapFile` to an empty string at the top level of the file.
- **Uses:** nothing
- **Reusable:** yes

## Part 15 of 17

### MapperBrowsersMenuPick
- **Does:** Runs the mapper browser pick action, handling New, Duplicate, Open and Save choices by loading or saving the current mapper Lua file and updating the mapper UI state.
- **Uses:** Engine calls `chooseFile`, `dofile`, `MapTextFld:clear`, `MapTextWindow:show`, `MapTextWindow:redraw`, `BtnBrowser:redraw`; globals `BtnBrowser`, `tFile`, `gMapFile`, `currentLevel`, `dsbtext2map`, `textArray`, `MapTextFld`, `MapTextWindow`, `MapTextWindow`, `Q`; `Data/` path `gameroot.."Data/WTF/Dungeons/"`; file operations `io.open`, `io.close`.
- **Reusable:** no
- **Procedural:** no

## Part 16 of 17

### Mapper_menu_callback
- **Does:** Handles the mapper menu button callback. It reads the button's label, value and text, looks up neighboring menu entries by value, and dispatches to the matching mapper menu picker or clears the current mapper when the selected entry is a clear option.
- **Uses:** `BtnBrowser` (global), `w:label()`, `w:value()`, `w:text()` (FLTK widget calls), `MapperMenuIndex` (global), `MappermenuHead`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `Fl:check()`, `io.flush()` (FLTK/host calls)
- **Reusable:** no
- **Procedural:** no

## Part 17 of 17

### Top level
- **Does:** Sets up the mapper UI widgets, runs the mapper menu fill, and starts the FLTK application loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `Fl_Group`, `BtnBrowser`, `MapperMenu`, `MapTextWindow`, `MapTextFld`, `Mapper_MenuBarFill`, `Fl:run`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is nil, otherwise fills the mapper source and control menus.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the browser button, its close callback, and resizes it for the mapper source menu.
- **Uses:** `fltk:Fl_Double_Window`, `BtnBrowser`, `wClose`, `resize`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the mapper menu bar, assigns its callback, sets its size and colors, and selects the current group.
- **Uses:** `fltk:Fl_Menu_Bar`, `MapperMenu`, `Mapper_menu_callback`, `resize`, `color`, `labelsize`, `textsize`, `Fl_Group`, `current`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the list browser buttons, assigns their click callback, sets their size, type, and text sizes.
- **Uses:** `fltk:Fl_Browser`, `BtnListBrowser`, `uBtnListBrowserControlClicked`, `resize`, `type`, `labelsize`, `textsize`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the attribute list browser, assigns its click callback, sets its size, type, and text sizes.
- **Uses:** `fltk:Fl_Browser`, `AttrListBrowser`, `uBtnListBrowserControlClicked`, `resize`, `type`, `labelsize`, `textsize`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Creates the map text window, assigns its close callback, sets its size, hides the unknown attribute, makes the group resizable, and creates the map text field with its size and text settings.
- **Uses:** `fltk:Fl_Double_Window`, `MapTextWindow`, `wClose`, `resize`, `resizable`, `size_range`, `fltk:Fl_Browser`, `MapTextFld`, `resize`, `type`, `labelsize`, `textsize`
- **Reusable:** no
