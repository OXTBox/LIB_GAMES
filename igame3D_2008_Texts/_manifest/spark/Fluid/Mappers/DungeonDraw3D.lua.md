<!-- Spark first-look of Data/Fluid/Mappers/DungeonDraw3D.lua (model spark-x2.6-4b, 2026-11-12 23:50). DRAFT for Claude to review. -->

## DungeonDraw3D.lua
- **Kind:** tool
- **Purpose:** This file is the DungeonDraw3D mapper tool, a Lua script that builds and edits dungeon maps by generating grid-based meshes, walls, floors, and button/text map entries, then saving the resulting dungeon map data. It loads the edit level and the dungeon reader script, sets up the mapper UI and menu state, and runs the mapper workflow from the current level.
- **Depends on:** `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `loadLevel("Data/Levels/edit/")`, engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_GetMode__i`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `ig3d_DeleteMesh_b`, `chooseFile`, `dsbtext2map`, `parseDungeon`, `saveMapOut`, `editingModeSwitch`, `render`, `makeabutton`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`, `BtnBrowser:redraw`, `Fl:run()`, `Fl:check()`, `Fl:hide()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()`, `Fl:redraw()`, `Fl:add()`, `Fl:run()`, `Fl:check()`, `Fl:show()

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 16

### Top level
- **Does:** Sets up global variables and UI-related state for the DungeonDraw3D mapper, loads the edit level and dungeon reader script, and defines the `numberofitems` function.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, `string.gfind`, globals such as `Q`, `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gridSize`, `quadSize`, `itemDelimiter`, `DelimitedString`, `numofitems`, `cr`, `itemDelimiter`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a delimited string by splitting on the given delimiter and counting the matches.
- **Uses:** `string.gfind`, globals `itemList`, `itemDelimiter`, `DelimitedString`, `numofitems`.
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 16

### Top level
- **Does:** Contains the single top-level line `TheFloor=nil`, which resets the floor reference to nil.
- **Uses:** nothing
- **Reusable:** yes

### item
- **Does:** Splits a delimited string into individual items, then returns the item at a given index, handling both positive and negative indices.
- **Uses:** `string.gfind`, `string.sub`, `string.find`
- **Reusable:** yes

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned coordinates, creating a mesh tag, setting mesh tool and default mesh settings, drawing quad edges, and scaling the mesh to the grid dimensions.
- **Uses:** `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`
- **Reusable:** no

### loadFloors
- **Does:** Not present in this code section; no function body or description available.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 16

### loadTheFloor
- **Does:** Loads the stone floor mesh, tags it with an incrementing tag number, and returns the created mesh object or nil if the load fails.
- **Uses:** `gameroot`, `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`, `theMesh`, `Data/WTF/Floors/stone2floor4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

### icopyFloors
- **Does:** Duplicates the loaded floor mesh into a new tagged floor mesh, positions it on the grid at the given coordinates, and returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `math.floor`, `qx`, `qy`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`
- **Reusable:** yes
- **Procedural:** no

### icopyRoofs
- **Does:** Duplicates the loaded floor mesh into a new tagged roof mesh, positions it on the grid at the given coordinates with the cube height offset, and returns nothing.
- **Uses:** `TheFloor`, `nTagNumber`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `math.floor`, `qx`, `qy`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`, `vgridlength`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 16

### Top level
- **Does:** Declares the two wall-related global variables `WEWall` and `NSWall` as `nil` at the start of the file.
- **Uses:** nothing
- **Reusable:** yes

### idrawWallZ
- **Does:** Draws a wall quad at the given position and face by computing grid coordinates, creating a mesh tag, drawing the appropriate wall geometry via `loadstring`, setting mesh and face properties, and restoring the previous mode afterward.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `loadstring`, `drawVertex`, `drawLine`, `wallstring`, `face`, `qx`, `qy`
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 16

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall model, positions it far away, and returns the assigned tag number for the face.
- **Uses:** `nTagNumber`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `gameroot`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, `face`, `theMesh`, `WEWall`, `NSWall`, `savedmode`, `meshx`, `meshy`, `meshz`
- **Reusable:** no
- **Procedural:** yes

## Part 6 of 16

### icopyWalls
- **Does:** Duplicates a wall mesh at a given grid position and face, then positions and scales the new mesh so it fits the grid cell.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `WEWall`, `NSWall`, `nTagNumber`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`; variables `qx`, `qy`, `face`.
- **Reusable:** no

### icopyWalls
- **Does:** Computes the grid-aligned position offset for the wall based on its face, using the grid dimensions and cell size.
- **Uses:** Globals `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`; variables `qx`, `qy`, `face`, `QX`, `QY`.
- **Reusable:** no

### icopyWalls
- **Does:** Applies the final mesh positioning and centroid-based scaling for the duplicated wall mesh, restoring the previous mode afterward.
- **Uses:** Engine calls `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; variables `meshx`, `meshy`, `meshz`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubeheight`.
- **Reusable:** no

## Part 7 of 16

### Top level
- **Does:** Records the last browser control click time, resets the last selection index, clears the selected button name, and initializes the button list browser index table.
- **Uses:** `os.time()`, globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`
- **Reusable:** yes

### iloadWalls
- **Does:** Loads a wall quad for the given face, positions it on the grid, selects it, and sets its tool and default mesh tag.
- **Uses:** globals `vcubewidth`, `vcubelength`, `vgridwidth`, `QX`, `QY`, `nTagNumber`, `quadtag`, `theMesh`, `savedmode`, `face`, `gameroot`, engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`; paths `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 16

### ulistBtnList
- **Does:** Rebuilds the button list browser widget, preserving the current selection, and moves the active window to the browser.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** yes
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Re-runs the button list browser rebuild when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 16

### uBtnListBrowserControlClicked
- **Does:** Handles the click of the browser control button, selecting an attribute list entry, spawning its attribute list items at the selected grid position, and updating the selection state.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser`, `listSpawnXY`, `XYSpawned`, `time`, `os.time`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and releases its reference by setting it to nil.
- **Uses:** `w:hide()`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Generates a random or event-based color, reads the tooltip of the clicked widget to derive a grid position, adds the position to the button list if not already present, marks the position as used, sets the text array entry, applies the color and resets the button value, and refreshes the button list.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap`, `math.random`, `string.sub`, `string.find`, `tonumber`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** yes

## Part 10 of 16

### startGrid
- **Does:** Creates a grid of buttons and text map entries for every cell in the grid, then redraws the button list and window.
- **Uses:** `GridSize`, `GridSpread`, `Q`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `makeabutton`, `loadstring`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`, and the local tables `btnListXY`, `textmapXY`.
- **Reusable:** no

### resestGrid
- **Does:** Clears the per-cell button and text map tables for every grid cell, resetting their values to zero.
- **Uses:** `GridSize`, the local tables `btnListXY`, `textmapXY`.
- **Reusable:** yes

### stackcb
- **Does:** Checks whether the space key is pressed to show the color map, then checks FLTK for events.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`.
- **Reusable:** no

## Part 11 of 16

### quadGrid
- **Does:** Builds the dungeon mesh by loading walls and floor, drawing or copying them per grid cell, then renders, selects the whole mesh, combines overlaps and equal materials, saves the mesh, and switches to select_entity mode.
- **Uses:** `loadTheWalls`, `loadTheFloor`, `quadwalls`, `textmapXY`, `gridSize`, `WEWall`, `NSWall`, `TheFloor`, `icopyWalls`, `idrawWallZ`, `icopyRoofs`, `icopyFloors`, `idrawQuad`, `render`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, `editingModeSwitch`, `lookbutton`, `gameroot`, `currentLevel`, `polycount`
- **Reusable:** no
- **Procedural:** yes

## Part 12 of 16

### resetMapper
- **Does:** Resets the mapper UI state, rebuilds the dungeon map from the current level, and saves the generated map output.
- **Uses:** `GridSize`, `baseBtnColor`, `loadstring`, `resestGrid`, `DWindow:redraw`, `textmapXY`, `textArray`, `btnListXY`, `parseDungeon`, `currentLevel`, `ButtonSpawnXY`, `DWindow`, `saveMapOut`, `ulistBtnList`, `BtnBrowser:redraw`
- **Reusable:** no
- **Procedural:** yes

## Part 13 of 16

### Top level
- **Does:** Contains top-level setup code for the DungeonDraw3D Fluid/Mappers part, including a FLTK double window creation, label table initialization, menu source list setup, and timer initialization for the mapper menu functions.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `DWindow`, `Fl_Group`, `murgaLua.createFltkTimer`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`, `BtnBrowser`, `startGrid`, `stackcb`
- **Reusable:** no

### saveMapOut
- **Does:** Writes the dungeon map data as a Lua file named `dungeonmap..currentLevel..".lua"`, formatting text array entries into a serialized string and appending a dsb_text2map call to the file content.
- **Uses:** `io.open`, `textArray`, `dsbtext2map`, `currentLevel`, `Q`, `string.len`, `string.sub`, `string.len`, `tFile:write`, `io.close`
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with file menu items for New, Open, Save, and Duplicate, plus an empty separator item, and updates the menu index and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu`, `MapperMenuIndex`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes
- **Procedural:** no

## Part 14 of 16

### fillMapperControlMenu
- **Does:** Builds the mapper control menu by adding numbered map entries and blank separators to the menu and its index table, then redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `dsbtext2map`, `MapperMenuText` (referenced in commented-out code only), `tostring`, `table.insert`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes - menu construction and index bookkeeping logic
- **Procedural:** no

### MapperCurrentPick
- **Does:** Prints the pick value, converts it to a number for the current level, resets the mapper, and runs the quad grid setup.
- **Uses:** `tPick`, `currentLevel`, `resetMapper`, `quadGrid`, `tonumber`
- **Reusable:** no
- **Procedural:** no

## Part 15 of 16

### MapperBrowsersMenuPick
- **Does:** Handles the pick action for the mapper browser menu, dispatching to New, Duplicate, Open or Save actions based on the selected pick text.
- **Uses:** Engine calls `chooseFile`, `dofile`, `MapTextFld:clear`, `MapTextWindow:show`, `MapTextWindow:redraw`, `io.open`, `io.close`; globals `BtnBrowser`, `tFile`, `textArray`, `textmapXY`, `resetMapper`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `gameroot`, `Q`; file paths under `gameroot.."Data/WTF/Dungeons/"`.
- **Reusable:** yes
- **Procedural:** no

### Mapper_menu_callback
- **Does:** Reads the menu widget label, value and pick text, maps the value to menu head and adjacent menu head indices, and dispatches the pick to the matching mapper menu handler or clears the current mapper.
- **Uses:** Engine calls `w:label`, `w:value`, `w:text`, `Fl:check`, `io.flush`; globals `BtnBrowser`, `tMenu`, `tVal`, `tPick`, `tIndex`, `tIndex1`, `tIndex2`, `MapperMenuIndex`, `MappermenuHead`, `MapperCurrentPick`, `MapperAllMenuPick`; UI widget `w`.
- **Reusable:** yes
- **Procedural:** no

## Part 16 of 16

### Top level
- **Does:** Sets up the mapper UI widgets, shows the browser and menu bar, calls `Mapper_MenuBarFill()`, then hides the text window and runs the FLTK application.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `BtnBrowser`, `MapperMenu`, `MapTextWindow`, `MapTextFld`, `Fl_Group`, `Fl:run()`, `Mapper_MenuBarFill()`, `wClose`, `uBtnListBrowserControlClicked`, `Mapper_menu_callback`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Runs when the mapper browser is active; returns early if `BtnBrowser` is nil, otherwise fills the mapper source and control menus.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu()`, `fillMapperControlMenu()`
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** nothing in this code section
- **Uses:** nothing
- **Reusable:** no

### fillMapperControlMenu
- **Does:** nothing in this code section
- **Uses:** nothing
- **Reusable:** no
