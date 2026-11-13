<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw3D8.fl (model spark-x2.6-4b, 2026-11-12 23:58). DRAFT for Claude to review. -->

## DungeonDraw3D8.fl
- **Kind:** ui-dialog
- **Purpose:** This file is a FLTK fluid UI designer data file for the DungeonDraw3D8 mapper tool. It loads the edit level, sets the mapper mode, loads the DSB dungeon conversion script, and builds the window, grid, browser, and menu controls used to edit and save dungeon maps.
- **Depends on:** `Data/Levels/edit/` (via `loadLevel`), `Data/Scripts/Convert/DSB_Dungeons.lua` (via `dofile`), `Data/Scripts/Convert/dungeonout.lua` (via `dofile`), `Data/WTF/Floors/stone2floor4x4.wtf`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `Data/WTF/Dungeons/DM`, `Data/WTF/Dungeons/` (via `gameroot.."Data/WTF/Dungeons/"`), `Data/` paths written via `gameroot.."Data/..."` pattern, engine calls (`ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_LoadMesh_sf_b`, `ig3d_DuplicateMesh`, `ig3d_SaveMesh_sf_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_DeleteMesh_b`, `ig3d_InvertMeshSelection`, `ig3d_GetMode__i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_SetFacePos_b3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`), globals (`gObjects`, `gMapFile`, `currentLevel`, `WEWall`, `NSWall`, `TheFloor`, `nTagNumber`, `quadtag`, `QX`, `QY`, `qx`, `qy`, `meshx`, `meshy`, `meshz`, `baseBtnColor`, `GridSize`, `GridSpread`, `GridSize`, `quadSize`, `cubeSize`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `textArray`, `textmapXY`, `btnListXY`, `btnList`, `XYSpawned`, `XYSpawned`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `BtnBrowser`, `BtnListBrowser`, `AttrListBrowser`, `DWindow`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText.Source`, `MapTextFld`, `MapTextWindow`, `tPick`, `gMapFile`, `dungeonout`, `parseDungeon`, `ButtonSpawnXY`, `ulistBtnList`, `Mapper_MenuBarFill`, `MapperAllMenuPick`, `MapperCurrentPick`, `MapperBrowsersMenuPick`, `MapperMenu`, `MapperMenuBarFill`, `make_window`, `numberofitems`, `itemDelimiter`, `DelimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString`, `delimitedString

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 16

### Top level
- **Does:** Defines the file-level setup for the FLTK UI designer, including the `make_window` function body and the `numberofitems` helper function.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`, `math.random`, `string.gfind`, `string.gfind` related globals (`DelimitedString`, `itemDelimiter`, `cr`), and the `make_window`/`numberofitems` functions defined in this file.
- **Reusable:** yes - the `numberofitems` helper is a generic string parsing utility; the setup calls are engine-specific and require the same engine context.

### make_window
- **Does:** Opens the FLTK window for the UI designer, loads the edit level, sets the engine mode, and initializes the UI designer's grid, button, text, and level state variables.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")`, `math.random`, and the initialized variables (`baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `gMapFile`).
- **Reusable:** no - this is a setup routine for this specific UI designer file, tied to the edit level and DSB conversion script.

### numberofitems
- **Does:** Counts the number of items in a delimited string by splitting on the given delimiter and counting the matches.
- **Uses:** `string.gfind`, `math.random` is not used here; uses `itemDelimiter` (defaults to `","` when `nil`), `DelimitedString`, and returns the item count.
- **Reusable:** yes - generic string parsing logic that works for any delimited string input.
- **Procedural:** no

## Part 2 of 16

### Top level
- **Does:** Contains the file-level setup and widget definitions for the DungeonDraw3D8 FLUID mapper part, including the `code {--loadFloors` block that begins the next function section.
- **Uses:** nothing
- **Reusable:** no

### item
- **Does:** Splits an input string into individual items based on a delimiter, then returns the requested item by index, handling both positive and negative indices.
- **Uses:** `string.gfind`, `string.sub`, `string.find`
- **Reusable:** yes - pure string parsing and indexing logic.
- **Procedural:** no

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned vertex coordinates, creating a mesh tag, setting mesh tool and default mesh settings, drawing quad edges, and scaling the mesh to the configured cube dimensions.
- **Uses:** `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `nTagNumber`, `quadtag`, `drawVertex`, `drawLine`
- **Reusable:** no
- **Procedural:** yes - generates a mesh object and its associated geometry from numeric grid parameters.

## Part 3 of 16

### Top level
- **Does:** Contains the trailing `code {-- idrawWallZ` fragment, which is a FLUID UI designer code block marker with a comment label; no setup, global definitions or widget logic is present in this portion.
- **Uses:** nothing
- **Reusable:** no

### loadTheFloor
- **Does:** Loads the stone floor mesh from the Data folder, increments the shared tag counter, creates a tagged mesh object for the floor, sets default mesh properties, pushes the mesh to the undo cache, and either loads the mesh with scaling and vertex selection or clears the floor reference if loading fails; returns the floor mesh object.
- **Uses:** `gameroot.."Data/WTF/Floors/stone2floor4x4.wtf"`, `nTagNumber`, `TheFloor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`, `vcubelength`
- **Reusable:** yes
- **Procedural:** no

### icopyFloors
- **Does:** Copies the existing floor mesh to a new tagged mesh, sets the mesh tool to select tool, pushes the mesh to the undo cache, duplicates the mesh and moves it to the new mesh tag, calculates grid-aligned target coordinates from the given x/y inputs, positions and scales the duplicated mesh, then restores the saved mode; returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `quadtag`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `vcubelength`, `meshx`, `meshy`, `meshz`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`
- **Reusable:** yes
- **Procedural:** no

### icopyRoofs
- **Does:** Identical logic to icopyFloors for copying the existing floor mesh to a new tagged mesh, setting mesh tool and properties, duplicating and re-tagging the mesh, calculating grid-aligned target coordinates from the given x/y inputs, positioning and scaling the duplicated mesh at the given height, then restoring the saved mode; returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `quadtag`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `vcubelength`, `vcubeheight`, `meshx`, `meshy`, `meshz`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`
- **Reusable:** yes
- **Procedural:** no

### code {-- idrawWallZ
- **Does:** Contains a FLUID UI designer code block marker with the comment label `idrawWallZ`; no executable logic is present in this fragment.
- **Uses:** nothing
- **Reusable:** no

## Part 4 of 16

### idrawWallZ
- **Does:** Draws a wall mesh for a given face by computing grid coordinates, creating a tagged mesh, setting its face position and scale, and rendering wall geometry via `drawVertex`/`drawLine` commands.
- **Uses:** Engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`; globals `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `wallstring`, `savedmode`, `QX`, `QY`; functions `drawVertex`, `drawLine`, `loadstring`; file/path `Data/` referenced via `gameroot.."Data/..."` pattern for code loading.
- **Reusable:** yes - the coordinate calculation and mesh setup logic for wall drawing can be reused for other wall variants.
- **Procedural:** yes - generates a 3D wall mesh geometry from face and grid parameters.

### Top level
- **Does:** Defines shared wall state variables `WEWall` and `NSWall` for the wall drawing section, and contains the `loadTheWalls` code block header.
- **Uses:** Globals `WEWall`, `NSWall`; code block `loadTheWalls`.
- **Reusable:** no - setup-only code for this section.
- **Procedural:** no

## Part 5 of 16

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall model, positions it far away, and returns the assigned wall tag number for north/south faces or the west/east wall tag otherwise.
- **Uses:** `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `face`, `theMesh`, `WEWall`, `NSWall`, `savedmode`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** yes

## Part 6 of 16

### icopyWalls
- **Does:** Duplicates a wall mesh at a given grid position and face, then positions and scales the new mesh according to the specified face.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `WEWall`, `NSWall`, `nTagNumber`, `savedmode`, `face`, `qx`, `qy`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`; variables `quadtag`, `QX`, `QY`, `meshx`, `meshy`, `meshz`.
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** No top-level code outside the `icopyWalls` function.
- **Uses:** nothing
- **Reusable:** yes

## Part 7 of 16

### iloadWalls
- **Does:** Loads a wall mesh for a given face, position and grid coordinates, creates a mesh tag, selects it, positions it, and restores the previous mode.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `nTagNumber`, `quadtag`, `face`, `QX`, `QY`, `savedmode`, `theMesh`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the trailing FLUID file content after the `iloadWalls` function, including a browser control setup block.
- **Uses:** `os.time`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `code`, `uBtnList BROWSER CODE AHEAD 1129`
- **Reusable:** no

## Part 8 of 16

### Top level
- **Does:** Contains no setup, globals, widget definitions, or other top-level code outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list browser widget, filters button positions into unique entries, and restores the last selected button index after redrawing.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes `ulistBtnList` when the button list browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no

## Part 9 of 16

### uBtnListBrowserControlClicked
- **Does:** Handles the click of the browser control button, manages double-click behavior, and refreshes the attribute list browser based on the selected button index.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `XYSpawned`, `listSpawnXY()`, `time()`, `os.time()`, `tonumber()`, `#`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and clears its reference when the close button is clicked.
- **Uses:** `w:hide()`, `w=nil`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles grid cell clicks, generates a color from the colormap or random value, extracts coordinates from the tooltip, adds the coordinate to the button list if not present, marks the cell as occupied, updates the text array, and refreshes the button list.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `tonumber()`, `string.len()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 16

### Top level
- **Does:** Contains the file-level setup for the Fluid/Mappers `DungeonDraw3D8.fl` part, including the trailing `code {--quadGrid` marker and no standalone top-level executable logic outside the defined functions.
- **Uses:** nothing
- **Reusable:** no

### startGrid
- **Does:** Builds the grid button and text map arrays, generates FLTK button scripts for each grid cell, loads them via `loadstring`, and triggers redraws of the keeper window and DWindow.
- **Uses:** `GridSize`, `GridSpread`, `Q`, `textArray`, `btnListXY`, `textmapXY`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `makeabutton`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`, `loadstring`
- **Reusable:** no

### resetGrid
- **Does:** Clears all grid-related arrays and re-initializes the per-row and per-cell structures for the grid, resetting text map entries to "0".
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`, `textArray`
- **Reusable:** yes

### stackcb
- **Does:** Handles the spacebar key event to show the color map, checks for FLTK events, and ends the callback block.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 11 of 16

### Top level
- **Does:** Sets up the quadGrid function body, which builds a dungeon mesh by loading walls, floors, and text map positions, then renders and saves the resulting mesh.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `quadwalls`, `textmapXY`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `idrawWallZ`, `icopyRoofs`, `icopyFloors`, `idrawQuad`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `currentLevel`, `gameroot`, `Data/WTF/Dungeons/DM`, `quadGrid`
- **Reusable:** no

### quadGrid
- **Does:** Iterates over quadwalls to place wall geometry at grid positions, then iterates over textmapXY to place floor or roof geometry, finally renders, selects the whole mesh, combines overlapping and equal materials, saves the mesh, inverts selection, and switches editing mode.
- **Uses:** `quadwalls`, `textmapXY`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `idrawWallZ`, `icopyRoofs`, `icopyFloors`, `idrawQuad`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `currentLevel`, `gameroot`, `Data/WTF/Dungeons/DM`
- **Reusable:** no
- **Procedural:** yes

## Part 12 of 16

### Top level
- **Does:** Contains the closing of the preceding `resetMapper` function and the opening of `saveMapOut`, plus shared setup for the mapper.
- **Uses:** `GridSize`, `GridSpread`, `baseBtnColor`, `DWindow`, `loadstring`, `dofile`, `gameroot`, `textArray`, `dsbtext2map`, `currentLevel`, `Q`, `io.open`, `io.close`, `string.sub`, `string.len`, `string.len`
- **Reusable:** no

### resetMapper
- **Does:** Rebuilds the mapper button grid, resets mapper state variables, and redraws the mapper window.
- **Uses:** `GridSize`, `baseBtnColor`, `DWindow`, `loadstring`, `dofile`, `gameroot`, `textArray`, `btnListXY`, `textmapXY`, `MapperMenuIndex`, `GridSpread`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gridSize`, `quadSize`, `WEWall`, `NSWall`, `TheFloor`, `GridSize`, `GridSpread`, `btnListXY`, `textmapXY`, `textArray`, `MapperMenuIndex`, `dofile`
- **Reusable:** no

### saveMapOut
- **Does:** Writes the generated dungeon map data to a Lua file named after the current level, then appends the corresponding dsb text-to-map mapping.
- **Uses:** `currentLevel`, `textArray`, `dsbtext2map`, `io.open`, `io.close`, `string.sub`, `string.len`, `Q`
- **Reusable:** no

## Part 13 of 16

### Top level
- **Does:** Defines the `DWindow` FLTK window with its scroll group, timer setup, and shared menu state tables; contains the Mapper MENU FUNCTIONS section with the `MapperMenuIndex` and `MapperMenuText` tables.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `murgaLua.createFltkTimer`, `timer:callback`, `timer:do_callback`, `BtnBrowser`, `MapperMenu`, `table.insert`, `tostring`.
- **Reusable:** no

### DWindow
- **Does:** Creates the main DWindow widget with its label, close callback, geometry, resizable range, visible state, nested scroll and group widgets, and the timer-driven redraw/startGrid logic.
- **Uses:** `Fl_Window`, `label`, `callback`, `xywh`, `type`, `when`, `resizable`, `size_range`, `visible`, `Fl_Scroll`, `Fl_Group`, `DWindow:show()`, `startGrid()`, `DWindow:redraw()`, `murgaLua.createFltkTimer()`, `timer:callback`, `timer:do_callback()`.
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with file paths for the source menu items, then adds an empty entry and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu:add()`, `MapperMenuIndex`, `table.insert()`, `MapperMenu:redraw()`.
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Populates the mapper control menu with map index paths, adds empty entries, and redraws the menu; the All/control menu loop is commented out.
- **Uses:** `BtnBrowser`, `dsbtext2map`, `MapperMenu:add()`, `MapperMenuIndex`, `table.insert()`, `MapperMenu:redraw()`.
- **Reusable:** yes

## Part 14 of 16

### MapperCurrentPick
- **Does:** Prints the pick argument, defaults it to 1 if it is nil, prints the map file path, resets the mapper, loads the map file, sets the current level, runs the dungeon output routine, loads the dungeon output script, parses the dungeon, and updates the spawn button, button list, menu bar, browser button, and quad grid.
- **Uses:** `tPick`, `gMapFile`, `resetMapper()`, `dofile()`, `currentLevel`, `dungeonout()`, `parseDungeon()`, `ButtonSpawnXY()`, `ulistBtnList()`, `Mapper_MenuBarFill()`, `BtnBrowser:redraw()`, `quadGrid()`, `Data/Scripts/Convert/dungeonout.lua`
- **Reusable:** no
- **Procedural:** no

## Part 15 of 16

### MapperBrowsersMenuPick
- **Does:** Handles the pick action in the mapper browser menu, supporting New, Duplicate, Open and Save actions for the mapper Lua file, and opens the mapper file for parsing when opened.
- **Uses:** Engine calls and globals: `BtnBrowser`, `MakeMapper`, `chooseFile`, `resetMapper`, `dofile`, `currentLevel`, `parseDungeon`, `ButtonSpawnXY`, `ulistBtnList`, `Mapper_MenuBarFill`, `BtnBrowser:redraw`, `MapTextFld:clear`, `MapTextWindow:show`, `io.open`, `io.close`, `textArray`, `MapTextFld:add`, `MapTextWindow:redraw`, `Q`, `string.len`, `string.sub`. File paths referenced: `gameroot.."Data/WTF/Dungeons/"`.
- **Reusable:** no
- **Procedural:** no

## Part 16 of 16

### Top level
- **Does:** Defines the FLTK widget layout for the Mapper UI, including the Mapper menu bar, browser widgets, and the MapTextWindow, and wires the initial show/redraw behavior.
- **Uses:** `BtnBrowser`, `Mapper_MenuBarFill`, `MapTextWindow` (widgets defined in this file); `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser` (FLTK UI calls).
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Handles the Mapper menu selection callback: reads the selected menu label and value, looks up neighboring menu entries via `MapperMenuIndex`, and dispatches to the appropriate menu picker based on the selected entry.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick` (globals/functions referenced in this code).
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the Mapper source and control menus by calling the two menu fill functions, and returns after completing both.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu` (functions referenced in this code).
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the FLTK window for the Mapper browser widget, with a close callback, position/size properties, a menu bar with the menu selection callback, and two browser child widgets.
- **Uses:** `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser` (FLTK UI calls); `BtnBrowser`, `MapperMenu`, `BtnListBrowser`, `AttrListBrowser` (widgets defined in this file).
- **Reusable:** no

### MapTextWindow
- **Does:** Defines the FLTK window for the Map text window, with a close callback, position/size properties, a resizable text field child widget, and a code block that shows the browser, fills the menu bar, hides the map text window, and redraws the browser.
- **Uses:** `Fl_Window`, `Fl_Browser` (FLTK UI calls); `MapTextWindow`, `MapTextFld` (widgets defined in this file); `BtnBrowser`, `Mapper_MenuBarFill` (widgets/functions referenced in this code).
- **Reusable:** no
