<!-- Spark first-look of Data/Fluid/Mappers/Dungeon3D.fl (model spark-x2.6-4b, 2026-11-12 23:01). DRAFT for Claude to review. -->

## Dungeon3D.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface designer source for the Dungeon3D mapper tool, defining the window, grid, button, and menu widgets used to edit dungeon floors, walls, and maps. It loads the dungeon reader script and the edit level, then drives the mapper UI through widget callbacks and engine calls to build and save dungeon geometry.
- **Depends on:** `loadLevel("Data/Levels/edit/")`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`, engine calls `ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_GetMode__i`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_DeleteMesh_b`, `ig3d_ShowAll`, `render`, `loadstring`, `parseDungeon`, `saveMapOut`, `ButtonSpawnXY`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `idrawwallZ`, `ulistBtnList`, `resestGrid`, `startGrid`, `resetMapper`, `quadGrid`, `makeabutton`, `keeper:add`, `keeper:redraw`, `DWindow:redraw`, `DWindow:show`, `DWindow:redraw`, `BtnBrowser:redraw`, `MapperMenu:add`, `MapperMenu:redraw`, `MapperMenuBarFill`, `MapTextFld`, `MapTextWindow`, `MapTextFld`, `MapTextWindow`, `dsbtext2map`, `tFile:write`, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `Fl_Window`, `Fl_Scroll`, `Fl_Group`, `Fl_Button`, `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser`, `Fl_Group`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `Fl_Window`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 12

### Top level
- **Does:** Defines the `make_window` function and the `numberofitems` function, with FLUID UI setup code inside the `make_window` body.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, `string.gfind`, `string.gfind` related globals (`cr`, `itemDelimiter`, `DelimitedString`), and FLUID file-level declarations (`version`, `header_name`, `code_name`, `Function`).
- **Reusable:** no

### make_window
- **Does:** Opens the FLUID UI window for the Dungeon3D mapper, loads the edit level, sets the engine mode, and initializes UI state variables including grid and button arrays.
- **Uses:** `loadLevel("Data/Levels/edit/")`, `ig3d_SetMode_i(1)`, `dofile("/Applications/dsbtest35/base/dungeonreader.lua")`, `math.random`, and the UI state globals (`baseBtnColor`, `grpGrid`, `drpGrid`, `drpColors`, `btnMakeList`, `btnListXY`, `GridSize`, `GridSpread`, `nc`, `newcolor`, `btnList`, `textmapXY`, `XYSpawned`, `currentLevel`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `quadSize`).
- **Reusable:** no

### numberofitems
- **Does:** Counts the number of items in a string by splitting on a delimiter, defaulting the delimiter to `","` if not provided.
- **Uses:** `string.gfind`, the `DelimitedString` global, the `itemDelimiter` global, and the `itemList` parameter.
- **Reusable:** yes - pure string parsing logic that can be reused for any delimiter-based item counting.
- **Procedural:** no

## Part 2 of 12

### Top level
- **Does:** Contains the file-level setup for the Fluid/Mappers `Dungeon3D.fl` file, including the trailing `code {--iloadfloors` block that initializes `TheFloor` to `nil`.
- **Uses:** nothing
- **Reusable:** no

### item
- **Does:** Splits an input string by a delimiter into a list of substrings, then returns the requested substring by index, handling negative indices for reversed lookup.
- **Uses:** nothing
- **Reusable:** yes - pure string splitting and indexing logic.

### idrawquad
- **Does:** Draws a quad mesh at a grid-aligned position, sets up the mesh tool and undo cache, draws the quad's four edges, and scales the mesh to the configured cube dimensions.
- **Uses:** engine calls `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`; globals `nTagNumber`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`; helper calls `drawVertex`, `drawLine`; file-level state from the `iloadfloors` code block (`TheFloor`).
- **Reusable:** no

### iloadfloors
- **Does:** Initializes the floor state variable to `nil`.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 12

### loadTheFloor
- **Does:** Loads the stone floor mesh, tags it with a unique floor identifier, positions and scales it, and returns the created mesh object or nil if the mesh fails to load.
- **Uses:** `gameroot`, `nTagNumber`, `TheFloor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `vcubewidth`, `vcubelength`
- **Reusable:** yes
- **Procedural:** no

### iloadfloors
- **Does:** Duplicates the existing floor mesh, repositions and scales it to a grid-aligned position, and restores the previous mode after the operation.
- **Uses:** `TheFloor`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `nTagNumber`, `quadtag`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `math.floor`, `meshx`, `meshy`, `meshz`, `savedmode`, `QX`, `QY`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 12

### idrawwallZ
- **Does:** Draws a wall quad at a given position and face, computing grid-aligned vertex coordinates for north/south/east/west faces, then creates a mesh tag, sets mesh tool and default mesh settings, and renders the wall geometry via loaded string functions.
- **Uses:** Engine calls `math.floor`, `ig3d_GetMode__i`, `ig3D_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`; globals `vcubewidth`, `vcubelength`, `vcubehight`, `vgridwidth`, `nTagNumber`, `quadtag`, `savedmode`, `wallstring`, `drawVertex`, `drawLine`; file/string loading via `loadstring`.
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the file-level setup for the wall drawing function, including the wallface string table and the trailing `code {-- iloadwalls` marker.
- **Uses:** globals `wallstring`, `drawVertex`, `drawLine`; string table `wallstring={"north","west","east","south"}`.
- **Reusable:** no

## Part 5 of 12

### iloadwalls
- **Does:** Computes grid coordinates for a wall face, creates a mesh tag, selects the mesh vertices, positions the mesh, and restores the previous mode.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `gameroot`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

### Top level
- **Does:** Defines the wall face name list, computes grid coordinates for each wall face, creates and configures the wall mesh tag, loads the appropriate wall model, positions and scales the mesh, and restores the saved mode.
- **Uses:** `math.floor`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `gameroot`, `nTagNumber`, `quadtag`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `Data/Wtf/Walls/EWwall4x4.wtf`, `Data/Wtf/Walls/NSwall4x4.wtf`
- **Reusable:** yes
- **Procedural:** no

## Part 6 of 12

### Top level
- **Does:** No setup, globals or widget definitions appear outside the two functions.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list browser by clearing it, rebuilding the index table and button list from btnListXY, then redraws the browser and restores the last selection if it exists.
- **Uses:** BtnBrowser, BtnListBrowser, BtnListBrowserIndex, gLastSelection, btnListXY
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes ulistBtnList when the button list browser control is double-clicked.
- **Uses:** ulistBtnList
- **Reusable:** no

## Part 7 of 12

### uBtnListBrowserControlClicked
- **Does:** Handles the click on the list browser button, manages double-click detection, and refreshes the attribute list browser based on the selected item.
- **Uses:** `w:value()`, `gLastBrowserControlClick`, `gLastSelection`, `uBtnListbrowserControlDoubleClicked`, `BtnListBrowserIndex`, `AttrListBrowser:clear()`, `AttrListBrowser:add()`, `AttrListBrowser:redraw()`, `XYSpawned`, `listSpawnXY()`, `time()`, `os.time()`, `tonumber()`
- **Reusable:** no
- **Procedural:** no

### wClose
- **Does:** Hides the given window and clears its reference when the close button is clicked.
- **Uses:** `w:hide()`, `w=nil`
- **Reusable:** yes
- **Procedural:** no

### gridcb
- **Does:** Handles grid cell clicks, generates a color for the cell, extracts coordinates from the tooltip, adds the cell to the button list, marks the cell as selected, and updates the UI.
- **Uses:** `w:tooltip()`, `Fl:event_key()`, `fltk.fl_show_colormap()`, `math.random()`, `string.sub()`, `string.find()`, `string.len()`, `tonumber()`, `btnList`, `btnListXY`, `textmapXY`, `GridSize`, `textArray`, `w:color()`, `w:value()`, `ulistBtnList()`, `Fl:check()`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 12

### Top level
- **Does:** Contains the file-level FLUID UI code block and closing widget/callback structure for the Dungeon3D.fl mapper file.
- **Uses:** nothing
- **Reusable:** no

### startGrid
- **Does:** Generates grid buttons and text map entries for the grid, then triggers a redraw of the base button color and the DWindow.
- **Uses:** `GridSize`, `GridSpread`, `btnListXY`, `textmapXY`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `Q`, `loadstring`, `makeabutton`, `keeper:add`, `baseBtnColor`, `x0y0:color()`, `keeper:redraw()`, `DWindow:redraw()`
- **Reusable:** no

### resestGrid
- **Does:** Resets the grid button and text map arrays to empty/zeroed state for all grid cells.
- **Uses:** `GridSize`, `btnListXY`, `textmapXY`
- **Reusable:** yes

### stackcb
- **Does:** Handles the space key event to show the color map, checks for FLTK events, and ends the callback block.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap`, `nc`, `Fl:check()`
- **Reusable:** no

## Part 9 of 12

### Top level
- **Does:** Contains the file-level setup and widget definitions for the Fluid/Mappers part 9 of 12, including the `quadGrid` and `resetMapper` function bodies and the `code` block for `saveMapout`.
- **Uses:** Engine calls and globals referenced in the code: `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `ig3d_ShowAll`, `DWindow:redraw`, `loadstring`, `resestGrid`, `parseDungeon`, `ButtonSpawnXY`, `saveMapOut`, `ulistBtnList`, `BtnBrowser:redraw`. Also uses file-level variables and globals such as `textmapXY`, `quadwalls`, `gridSize`, `baseBtnColor`, `currentLevel`, `GridSize`, `btnListXY`, `textArray`, `btnListXY`.
- **Reusable:** no

### quadGrid
- **Does:** Draws floor quads and wall quads across the grid by iterating over `textmapXY` and `quadwalls`, scaling coordinates by `gridSize`, loading floor/wall data or drawing quads, and calling `render` after each iteration, then calls `ig3d_ShowAll`.
- **Uses:** Engine calls and globals: `ig3d_DeleteMesh_b`, `loadTheFloor`, `iloadfloors`, `idrawquad`, `render`, `ig3d_ShowAll`. Variables: `textmapXY`, `quadwalls`, `gridSize`.
- **Reusable:** no

### resetMapper
- **Does:** Resets the mapper by generating a string of button color assignments for every grid cell, executing that string with `loadstring`, then calls `resestGrid`, refreshes the DWindow, clears the mapper data arrays, re-parses the current level, spawns button positions, refreshes the DWindow, saves the map output, and refreshes the button browser.
- **Uses:** Engine calls and globals: `loadstring`, `resestGrid`, `DWindow:redraw`, `parseDungeon`, `ButtonSpawnXY`, `saveMapOut`, `ulistBtnList`, `BtnBrowser:redraw`. Variables: `GridSize`, `baseBtnColor`, `currentLevel`, `btnListXY`, `textArray`, `textmapXY`.
- **Reusable:** no

### saveMapout
- **Does:** Contains the start of the `saveMapout` code block, with no visible function body or logic shown in this code.
- **Uses:** nothing shown in this code
- **Reusable:** no

## Part 10 of 12

### Top level
- **Does:** Contains the file-level setup and widget definitions for the Dungeon3D FLUID mapper part, including the `DWindow` widget and its nested scroll/group widgets, plus the mapper menu functions and menu state tables.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group` widget definitions with `xywh`, `code` blocks, `murgaLua.createFltkTimer()`, `timer:callback(stackcb)`, `timer:do_callback()`, `MapperMenu`, `BtnBrowser`, `MapperMenuIndex`, `MapperMenuText`, `DWindow:show()`, `startGrid()`, `parseDungeon(1)`, `DWindow:redraw()`.
- **Reusable:** no

### saveMapOut
- **Does:** Writes the current dungeon map data as a Lua file named `dungeonmap..currentLevel..".lua"`, serializes the text array into a quoted comma-separated string, appends the dsb text-to-map mapping, and closes the file.
- **Uses:** `io.open`, `string.len`, `string.sub`, `string.format`-style concatenation, `currentLevel`, `textArray`, `dsbtext2map`, `tFile:write`, `io.close`.
- **Reusable:** yes
- **Procedural:** no

### DWindow
- **Does:** Defines the main mapper window widget with a label, close callback, window geometry, resizable range, and nested scroll and group widgets for the mapper interface.
- **Uses:** `Fl_Window`, `Fl_Scroll`, `Fl_Group` widget definitions with `xywh`, `label`, `callback`, `type`, `when`, `resizable`, `size_range`, `visible`.
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with New, Open, Save, Duplicate entries and an empty entry, inserts the menu lines and empty string into the menu index table, and redraws the menu.
- **Uses:** `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu`, `MapperMenuIndex`, `table.insert`, `MapperMenu:add`, `MapperMenu:redraw`.
- **Reusable:** yes
- **Procedural:** no

## Part 11 of 12

### Top level
- **Does:** Contains no setup, global definitions, or widget-level code outside the three listed functions; the file is part 11 of 12 and continues earlier parts.
- **Uses:** nothing
- **Reusable:** no

### fillMapperControlMenu
- **Does:** Populates the mapper control menu with map entries and empty separator lines, then redraws the menu. It returns early if the browser button is nil.
- **Uses:** `BtnBrowser`, `MapperMenu`, `MapperMenuIndex`, `tostring`, `table.insert`, `MapperMenu:add`, `MapperMenu:redraw`
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Prints the selected pick value, converts it to a number for the current level, resets the mapper, and redraws the quad grid. Returns early if the browser button is nil.
- **Uses:** `BtnBrowser`, `print`, `tonumber`, `currentLevel`, `resetMapper`, `quadGrid`
- **Reusable:** yes

### MapperBrowsersMenuPick
- **Does:** Handles browser menu selections: returns early for New, runs MakeMapper for Duplicate, opens and parses a chosen Lua file for Open, and writes a formatted dungeon map Lua file for Save. Returns early if the browser button is nil.
- **Uses:** `BtnBrowser`, `print`, `tPick`, `MakeMapper`, `chooseFile`, `tTitle`, `tFile`, `dofile`, `textmapXY`, `parseDungeon`, `quadGrid`, `MapTextFld`, `MapTextWindow`, `textArray`, `string.len`, `string.sub`, `io.open`, `io.close`, `Q`
- **Reusable:** yes

### Procedural
- **Does:** Generates a dungeon map Lua file from the current map text array by formatting entries into a 52-character line structure and wrapping the result in a Lua table.
- **Uses:** `textArray`, `MapTextFld`, `MapTextWindow`, `io.open`, `io.close`, `string.len`, `string.sub`, `Q`
- **Reusable:** yes
- **Note:** Creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 12 of 12

### Top level
- **Does:** Contains the file-level setup and widget definitions for the Fluid/Mappers part 12, including the `code` block that runs initial setup and redraw operations.
- **Uses:** `BtnBrowser`, `Mapper_MenuBarFill`, `MapTextWindow`, `ButtonSpawnXY`, `ulistBtnList`, `saveMapOut`, `quadGrid`, `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser`, `code` blocks; no `Data/` paths or engine calls beyond those widgets.
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Handles the Mapper menu button callback: returns early if `BtnBrowser` is nil, reads the menu button label, value and text, maps the value to menu indices, and dispatches the selected menu item or clear actions, then flushes the IO stream.
- **Uses:** `BtnBrowser`, `MapperMenuIndex`, `MapperBrowsersMenuPick`, `MapperCurrentPick`, `MapperAllMenuPick`, `Fl:check()`, `io.flush()`; no `Data/` paths or engine calls.
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Runs when the mapper menu bar is filled: returns early if `BtnBrowser` is nil, then calls `fillMapperSourceMenu()` and `fillMapperControlMenu()`.
- **Uses:** `BtnBrowser`, `fillMapperSourceMenu`, `fillMapperControlMenu`; no `Data/` paths or engine calls.
- **Reusable:** no

### BtnBrowser
- **Does:** Defines the `BtnBrowser` FLTK window widget with a close callback, menu bar, list browsers, and a text window, with layout and styling properties.
- **Uses:** `Fl_Window`, `Fl_Menu_Bar`, `Fl_Browser`, `callback`, `xywh`, `type`, `visible`, `color`, `labelsize`, `textsize`, `resizable`, `size_range`, `code` blocks; no `Data/` paths or engine calls.
- **Reusable:** no

### MapTextWindow
- **Does:** Defines the `MapTextWindow` FLTK window widget with a close callback, layout, resizable size range, and a text field browser inside it.
- **Uses:** `Fl_Window`, `Fl_Browser`, `callback`, `xywh`, `type`, `visible`, `resizable`, `size_range`, `code` blocks; no `Data/` paths or engine calls.
- **Reusable:** no
