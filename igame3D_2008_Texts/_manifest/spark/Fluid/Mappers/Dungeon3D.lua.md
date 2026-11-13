<!-- Spark first-look of Data/Fluid/Mappers/Dungeon3D.lua (model spark-x2.6-4b, 2026-11-12 23:07). DRAFT for Claude to review. -->

## Dungeon3D.lua
- **Kind:** tool
- **Purpose:** This file is the Dungeon3D mapper tool, which sets up the global state and UI variables for editing a dungeon level, builds and renders the dungeon grid, and saves the edited map data. It loads the edit level, switches engine mode, and provides helper functions for parsing item strings and drawing grid quads and walls.
- **Depends on:** `loadLevel("Data/Levels/edit/")`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, engine calls `ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_LoadMesh_sf_b`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `ig3d_GetMode__i`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `Data/WTF/Floors/stone2floor4x4.wtf`, `Data/` path `gameroot.."Data/Wtf/Walls/EWwall4x4.wtf"`, `gameroot.."Data/Wtf/Walls/NSwall4x4.wtf"`, globals `gObjects`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`, `AttrListBrowser`, `XYSpawned`, `textmapXY`, `quadwalls`, `GridSize`, `GridSpread`, `textArray`, `baseBtnColor`, `currentLevel`, `nTagNumber`, `TheFloor`, `savedmode`, `Q`, `tFile`, `tTitle`, `tFile`, `MapTextWindow`, `MapTextFld`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`, `MapperMenuBarFill`, `ButtonSpawnXY`, `parseDungeon`, `saveMapOut`, `resetMapper`, `quadGrid`, `ulistBtnList`, `gLabelTable`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `cr`, `itemDelimiter`, `delimitedString`, `itemResults`, `Q`, `QX`, `QY`, `face`, `wallstring`, `textArray`, `dsbtext2map`, `dsbtext2map`, `ButtonSpawnXY`, `Fl`, `Fl_Group`, `Fl_Button`, `Fl_Window`, `Fl_Browser`, `Fl_Menu_Bar`, `Fl_Scroll`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `Fl:redraw`, `Fl:add`, `Fl:clear`, `Fl:hide`, `Fl:show`, `Fl:label`, `Fl:value`, `Fl:color`, `Fl:tooltip`, `Fl:event_key`, `Fl:check`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 13

### Top level
- **Does:** Sets up global state and UI variables for the Dungeon3D mapper, loads the edit level, switches engine mode, and defines helper globals for item parsing.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, globals `baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `quadSize`, `cr`, `itemDelimiter`.
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a delimited string by splitting on the given delimiter and counting the matches.
- **Uses:** `string.gfind`, globals `DelimitedString`, `itemDelimiter`.
- **Reusable:** yes - pure string parsing logic.
- **Procedural:** no

## Part 2 of 13

### Top level
- **Does:** Contains a single top-level line that resets `TheFloor` to `nil`.
- **Uses:** nothing
- **Reusable:** yes

### item
- **Does:** Splits a delimited string into individual item substrings, then returns the requested item by index, handling negative indices as reversed lookups.
- **Uses:** `string.gfind`, `string.sub`, `string.find`, `n`, `ofwhatString`, `itemDelimiter`, `itemResults`
- **Reusable:** yes - string splitting and indexed lookup logic

### idrawquad
- **Does:** Draws a quad mesh at a grid-aligned position, sets up the mesh tool state, and scales the selected mesh to the current viewport dimensions.
- **Uses:** `qx`, `qy`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `savedmode`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`
- **Reusable:** no - depends on viewport and grid globals and mesh tool state

### iloadfloors
- **Does:** No code is present for this function in this part.
- **Uses:** nothing
- **Reusable:** unsure - no implementation shown, cannot confirm behavior

## Part 3 of 13

### loadTheFloor
- **Does:** Loads the stone floor mesh, tags it with a unique floor tag, positions and scales it, and returns the created mesh tag or nil if the mesh fails to load.
- **Uses:** `gameroot`, `nTagNumber`, `TheFloor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `Data/WTF/Floors/stone2floor4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

### iloadfloors
- **Does:** Duplicates the existing floor mesh, moves it to a grid-aligned position, and returns early if no floor mesh exists yet.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `qx`, `qy`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 13

### idrawwallZ
- **Does:** Draws a wall mesh for a given face at the given position, computing grid-aligned vertex coordinates for north/south/east/west faces and then creating, configuring and positioning the mesh.
- **Uses:** Engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`; globals `nTagNumber`, `quadtag`, `savedmode`, `wallstring`, `vcubewidth`, `vcubeheight`, `vcubelength`, `vgridwidth`, `vgridwidth`; engine helpers `loadstring`, `math.floor`, `drawVertex`, `drawLine`.
- **Reusable:** yes - the face coordinate calculation and mesh creation/positioning pattern for wall drawing can be reused for other wall types.
- **Procedural:** yes - generates a wall mesh geometry and mesh configuration from face and position inputs.

### idrawwallZ
- **Does:** Nothing beyond the function body above; no separate top-level section is written for this part.
- **Uses:** nothing additional beyond the function described above.
- **Reusable:** not applicable.
- **Procedural:** not applicable.

## Part 5 of 13

### Top level
- **Does:** Records the last browser control click time and resets selection-related state for the browser button list.
- **Uses:** `os.time()`, globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `BtnListBrowserIndex`
- **Reusable:** no

### iloadwalls
- **Does:** Computes grid coordinates for a wall face, creates a mesh tag, loads a wall mesh file, positions and scales the mesh, then restores the previous mode.
- **Uses:** globals `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `nTagNumber`, `quadtag`, `savedmode`, `theMesh`, `QX`, `QY`, `face`, `gameroot`, engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_ScaleSelectedMeshTo_3f`, `Data/` path `gameroot.."Data/Wtf/Walls/EWwall4x4.wtf"` and `gameroot.."Data/Wtf/Walls/NSwall4x4.wtf"`
- **Reusable:** no
- **Procedural:** yes

## Part 6 of 13

### ulistBtnList
- **Does:** Rebuilds the button list browser widget from the stored button positions, preserving the previously selected button, then makes the main window current.
- **Uses:** `BtnBrowser`, `BtnListBrowser`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`, `DWindow`
- **Reusable:** yes - pure UI list reconstruction logic using existing stored data and widget calls.
- **Procedural:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Triggers a full rebuild of the button list browser when the browser control is double-clicked.
- **Uses:** `ulistBtnList`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 13

### uBtnListBrowserControlClicked
- **Does:** Handles the click on the browser control button, selecting an attribute list entry, clearing and repopulating the attribute list browser, and updating the last selection state.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `listSpawnXY()`, `XYSpawned`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `time()`, `os.time()`, `BtnListBrowser`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and releases its reference by setting it to nil.
- **Uses:** `w:hide()`, `w`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles grid button clicks, generates a color from the colormap or random value, extracts coordinates from the tooltip, adds the coordinate to the button list if not present, marks the coordinate as used, sets the text array value, and updates the button color and value.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `tonumber()`, `string.len()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 13

### startGrid
- **Does:** Creates grid button and text map entries for every cell, generates button scripts, and redraws the grid UI.
- **Uses:** `GridSize`, `GridSpread`, `Q`, `fltk.fl_color`, `fltk.fl_show_colormap`, `Fl_Button`, `fltk.FL_FLAT_BOX`, `btnListXY`, `textmapXY`, `makeabutton`, `loadstring`, `gridcb`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`, `Fl:event_key`, `Fl:check`
- **Reusable:** no
- **Procedural:** yes

### resestGrid
- **Does:** Clears the grid button and text map entry arrays for every cell, resetting their stored values to zero.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`
- **Reusable:** yes

### stackcb
- **Does:** Checks for the space key event to show the color map, then checks FLTK for updates.
- **Uses:** `Fl:event_key`, `fltk.fl_show_colormap`, `nc`, `Fl:check`
- **Reusable:** no

## Part 9 of 13

### quadGrid
- **Does:** Renders the dungeon grid by iterating the textmapXY and quadwalls arrays, drawing floor quads or wall quads at grid coordinates, then shows all objects.
- **Uses:** Engine calls `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `ig3d_ShowAll`; globals `textmapXY`, `quadwalls`, `gridSize`; files/paths implied by the engine call pattern (no explicit Data/ paths in this code).
- **Reusable:** no

### resetMapper
- **Does:** Resets the mapper grid by building a Lua string of button color assignments, executing it, then reloading the dungeon grid, redrawing the window and related UI elements.
- **Uses:** Engine calls `DWindow:redraw`; globals `GridSize`, `baseBtnColor`, `loadstring`, `resestGrid`, `parseDungeon`, `ButtonSpawnXY`, `saveMapOut`, `ulistBtnList`, `BtnBrowser:redraw`; data structures `textmapXY`, `textArray`, `btnListXY`.
- **Reusable:** no

## Part 10 of 13

### Top level
- **Does:** Sets up the DWindow double window and its label, close callback, resize and show behavior, plus the keeper scroll and group widgets; then starts the grid, parses the dungeon level, and initializes the Mapper menu state and source menu entries.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `gLabelTable`, `DWindow`, `Fl_Group`, `startGrid`, `parseDungeon(1)`, `murgaLua.createFltkTimer`, `MapperMenu`, `MapperMenuIndex`, `MapperMenuText`, `BtnBrowser`
- **Reusable:** no

### saveMapOut
- **Does:** Writes the current dungeon map data to a Lua file named after the current level, formatting the text array into a compact string and appending the dsb_text2map mapping, then closes the file.
- **Uses:** `io.open`, `currentLevel`, `textArray`, `dsbtext2map`, `string.len`, `string.sub`, `string.len`, `Q`, `tFile:write`, `io.close`
- **Reusable:** yes
- **Procedural:** no

### fillMapperSourceMenu
- **Does:** Populates the Mapper source menu with New, Open, Save and Duplicate entries derived from the MapperMenuText.Source list, adds an empty menu line, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu`, `MapperMenuIndex`, `MapperMenu:add`, `table.insert`, `MapperMenu:redraw`
- **Reusable:** yes
- **Procedural:** no

## Part 11 of 13

### fillMapperControlMenu
- **Does:** Builds the mapper control menu by adding level map entries to the menu and its index table, then adds blank separator lines and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `dsbtext2map`, `MapperMenuText` (commented out), `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Prints the pick value, sets the current level from the numeric pick, resets the mapper, and runs the quad grid.
- **Uses:** `print`, `currentLevel`, `resetMapper`, `quadGrid`
- **Reusable:** yes

### MapperBrowsersMenuPick
- **Does:** Handles browser menu picks: returns early if the browser is absent, prints the pick, blocks the New option, runs MakeMapper for Duplicate, opens and parses a chosen Lua file for Open, and writes the map text array to dungeonmap.lua for Save.
- **Uses:** `BtnBrowser`, `print`, `tTitle`, `chooseFile`, `tFile`, `dofile`, `textmapXY`, `parseDungeon`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `textArray`, `Q`, `io.open`, `io.close`
- **Reusable:** yes
- **Reusable:** yes

## Part 12 of 13

### Mapper_menu_callback
- **Does:** Runs when the mapper menu button is clicked, reads the current menu value and text, resolves the corresponding menu item index, and dispatches the chosen action or clears the current map.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MappermenuHead`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `w:label()`, `w:value()`, `w:text()`, `item(1, tIndex, "/")`, `Fl:check()`, `io.flush()`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 13

### Top level
- **Does:** Sets up the Fluid mapper UI widgets, runs the mapper menu fill, and starts the FLTK application loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Browser`, `BtnBrowser`, `MapperMenu`, `MapTextWindow`, `MapTextFld`, `Fl_Group`, `Fl`, `Mapper_MenuBarFill`, `ButtonSpawnXY`, `ulistBtnList`, `saveMapOut`, `quadGrid`
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Returns early if the browser button is nil, otherwise fills the mapper source and control menus.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`
- **Reusable:** no

### ButtonSpawnXY
- **Does:** Not shown in this section of code; no description available.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Not shown in this section of code; no description available.
- **Uses:** nothing
- **Reusable:** no

### saveMapOut
- **Does:** Not shown in this section of code; no description available.
- **Uses:** nothing
- **Reusable:** no

### quadGrid
- **Does:** Not shown in this section of code; no description available.
- **Uses:** nothing
- **Reusable:** no
