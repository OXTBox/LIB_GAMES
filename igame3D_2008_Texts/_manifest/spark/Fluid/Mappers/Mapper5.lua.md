<!-- Spark first-look of Data/Fluid/Mappers/Mapper5.lua (model spark-x2.6-4b, 2026-11-13 00:55). DRAFT for Claude to review. -->

## Mapper5.lua
- **Kind:** ui-dialog
- **Purpose:** This file is a FLTK-based UI tool for building and managing a 3D game mapper, providing window drawing, grid interaction, and button browser controls for the mapper workflow. It sets up the mapper's initial configuration variables and drives the mapper's grid and button list interactions through FLTK widgets and engine calls.
- **Depends on:** `fltk.fl_rectf`, `fltk.fl_color`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk.FL_UP_FRAME`, `fltk.FL_BORDER_FRAME`, `murgaLua.createFltkTimer`, `Fl:event`, `Fl:event_x`, `Fl:event_y`, `Fl:check`, `Fl:run`, `ig3d_GetWindowBounds__4i()`, `time()`, `loadstring()`, `math.random()`, `math.floor`, `lfs.dir`, `lfs.dir` (via `lfs.dir`), `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `gGLX`, `gGLY`, `gGLR`, `gGLB`, `BtnBrowser`, `BtnListBrowser`, `DWindow`, `grid`, `grp`, `timer`, `idleDrag`, `ulistBtnList()`, `mapDrop()`, `drawBox()`, `drawrectF()`, `startGrid()`, `keeper:add()`, `BtnListBrowser:make_current()`, `BtnListBrowser:value()`, `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnBrowser:redraw()`, `BtnListBrowser:select()`, `BtnListBrowser:value()`, `BtnListBrowser:selected()`, `DWindow:make_current()`, `DWindow:w()`, `DWindow:h()`, `grid:hide()`, `grid:redraw()`, `grid:make_current()`, `grid:w()`, `grid:h()`, `table.insert`, `gObjects`, `gLabelTable`, `loadLevel` (via `loadLevel`), `load script.lua` (via `load script.lua`), `dofile` (via `dofile`), `make(ig3d_object, "file.wtf")`, `get(ig3d_object, name)`, `getObjectInfo(obj, IG3D_POSITION)`, `setObjectInfo(obj, IG3D_ROTATION, x, y, z)`, `loadLevel("Data/Levels/X")`, `fltk.fl_rectf`, `fltk.fl_color`, `Fl:event`, `Fl:event_x`, `Fl:event_y`, `Fl:check`, `Fl:run`, `ig3d_GetWindowBounds__4i()`, `time()`, `loadstring()`, `math.random()`, `math.floor`, `lfs.dir`, `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `gGLX`, `gGLY`, `gGLR`, `gGLB`, `BtnBrowser`, `BtnListBrowser`, `DWindow`, `grid`, `grp`, `timer`, `idleDrag`, `ulistBtnList()`, `mapDrop()`, `drawBox()`, `drawrectF()`, `startGrid()`, `keeper:add()`, `BtnListBrowser:make_current()`, `BtnListBrowser:value()`, `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnBrowser:redraw()`, `BtnListBrowser:select()`, `BtnListBrowser:value()`, `BtnListBrowser:selected()`, `DWindow:make_current()`, `DWindow:w()`, `DWindow:h()`, `grid:hide()`, `grid:redraw()`, `grid:make_current()`, `grid:w()`, `grid:h()`, `table.insert`, `gObjects`, `gLabelTable`, `loadLevel`, `load script.lua`, `dofile`, `make`, `get`, `getObjectInfo`, `setObjectInfo`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_POSITION`, `IG3

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Sets initial variables for the mapper, including `counter=95`, `houseGrid={{32,32}}`, `objectGrid={}`, `col=1`, `row=1`, `entityColor=5`, `esize=2`, and `ep=0`.
- **Uses:** nothing
- **Reusable:** no

### mapDrop
- **Does:** Drops a box at the given mouse coordinates, snaps the coordinates to a 64-pixel grid, checks whether the grid cell is already occupied, and if not adds the cell to `houseGrid`.
- **Uses:** `fltk.fl_rectf`, `houseGrid`, `mx`, `my`, `nx`, `ny`, `col`, `row`, `esize`
- **Reusable:** no

### drawBox
- **Does:** Sets the current DWindow, sets the entity color, and on FLTK event 1 reads the event coordinates; if the box size is not 8, draws a square box at those coordinates, otherwise calls `mapDrop` with them.
- **Uses:** `DWindow:make_current`, `fltk.fl_color`, `fltk.fl_rectf`, `Fl:event`, `Fl:event_x`, `Fl:event_y`, `esize`, `mapDrop`
- **Reusable:** no

## Part 2 of 4

### Top level
- **Does:** Contains 8 top-level lines outside functions: a comment, `gLastBrowserControlClick=time()`, `gLastSelection=-1`, `guSelectedBtn=""`, a comment, a call to `ig3d_GetWindowBounds__4i()` assigning `gGLX,gGLY,gGLR,gGLB`, and a comment.
- **Uses:** Globals `gLastBrowserControlClick`, `gLastSelection`, `guSelectedBtn`, `gGLX`, `gGLY`, `gGLR`, `gGLB`; engine call `ig3d_GetWindowBounds__4i()`; global `time()`.
- **Reusable:** no

### drawrectF
- **Does:** Draws a filled rectangle using a color cycle, then creates a half-size offset pair and calls the FLTK rectangle function to render a square of the given size.
- **Uses:** Globals `color_cycle`, `math.floor`, `fltk.fl_rectf`; parameters `qx`, `qy`, `qs`.
- **Reusable:** yes

### ulistBtnList
- **Does:** Loads the current button browser, reads its current value, clears the button list, adds only button entries longer than 2 characters, redraws the browser, restores the selected button, then switches to the main window.
- **Uses:** Engine calls `BtnBrowser:make_current()`, `BtnListBrowser:value()`, `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnBrowser:redraw()`, `BtnListBrowser:select()`, `BtnListBrowser:value()`, `BtnListBrowser:selected()`, `DWindow:make_current()`; globals `BtnBrowser`, `BtnListBrowser`, `DWindow`, `btnList`; parameter `n`.
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes the button list browser control routine when the browser control is double-clicked.
- **Uses:** Engine call `ulistBtnList()`; parameter `w`.
- **Reusable:** no

### uBtnListBrowserControlClicked
- **Does:** Validates the clicked button value, prints it, tracks click timing and selection state to detect double clicks, and updates the last click time and selected button value accordingly.
- **Uses:** Engine calls `time()`, `w:value()`; globals `gLastBrowserControlClick`, `gLastSelection`; parameters `w`.
- **Reusable:** no

### flCheck
- **Does:** Prints the current FLTK event value.
- **Uses:** Engine call `Fl:event()`; parameter none.
- **Reusable:** no

## Part 3 of 4

### startGrid
- **Does:** Builds the grid cell tables `grpGrid` and `drpGrid`, and the button list `btnList` by iterating the grid width and height in steps of 10.
- **Uses:** `grid:w()`, `grid:h()`, `table.insert`, `grpGrid`, `drpGrid`, `btnList`
- **Reusable:** yes
- **Procedural:** yes

### idleDrag
- **Does:** Handles idle dragging over the grid, updates drop positions and colors, creates or updates FLTK buttons for each grid cell, and redraws the window when the drag ends.
- **Uses:** `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`, `DWindow:w()`, `DWindow:h()`, `grid:hide()`, `grid:redraw()`, `grid:make_current()`, `Fl:check()`, `fltk.fl_color()`, `fltk.FL_FLAT_BOX`, `loadstring()`, `math.random()`, `grpGrid`, `drpGrid`, `btnList`, `drpColors`, `keeper:add()`, `ulistBtnList()`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 4

### Top level
- **Does:** Sets up the main double window and its child widgets, starts the idle drag loop, and runs the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk.FL_UP_FRAME`, `fltk.FL_BORDER_FRAME`, `murgaLua.createFltkTimer`, `gLabelTable`, `DWindow`, `BtnBrowser`, `grid`, `grp`, `timer`, `idleDrag`, `Fl:run`
- **Reusable:** no

### gridCB
- **Does:** Handles the grid callback by printing the current FLTK event and ending the function.
- **Uses:** `Fl:event`
- **Reusable:** yes

### idleDrag
- **Does:** Drives the idle drag behavior by printing the current FLTK event and returning.
- **Uses:** `Fl:event`
- **Reusable:** yes

### flCheck
- **Does:** Handles the browser window callback (not defined in this part).
- **Uses:** nothing
- **Reusable:** no

### uBtnListBrowserControlClicked
- **Does:** Handles the list browser control click callback (not defined in this part).
- **Uses:** nothing
- **Reusable:** no
