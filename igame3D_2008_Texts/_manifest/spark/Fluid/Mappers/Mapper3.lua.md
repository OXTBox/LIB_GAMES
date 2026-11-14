<!-- Spark first-look of Data/Fluid/Mappers/Mapper3.lua (model spark-x2.6-4b, 2026-11-13 00:38). DRAFT for Claude to review. -->

## Mapper3.lua
- **Kind:** tool
- **Purpose:** This file is a FLTK-based mapper tool for iGame3D, used to place and configure grid markers and entity buttons in a mapper UI. It sets up the main double window, handles grid dragging and drop events, and wires entity button callbacks to build the mapper configuration.
- **Depends on:** `fltk` (FLTK UI calls), `murgaLua` (host functions), `lfs.dir` (file listing), `DWindow` (engine window object), `gLabelTable` (shared label table), `timer` (FLTK timer object), `houseGrid` (grid state variable), `tempGrid` (temporary grid variable), `mapDrop` (marker placement function), `drawBox` (box drawing function), `drawrectF` (rectangle drawing function), `dragGrid` (grid dragging function), `dragGridLong` (long grid dragging function), `idleDrag` (idle drag handler), `event_callback` (FLTK event handler), `entityBtnClick` (entity button callback), `color_cycle` (color cycling function), `esize` (grid cell size variable), `col`/`row` (grid column/row variables), `nx`/`ny` (grid cell coordinates variables), `qs` (rectangle size variable), `math.floor` (math floor function), `math.random` (random number function), `table.insert` (table insert function), `Fl:wait`/`Fl:run`/`Fl:check`/`Fl:do_callback`/`Fl:run` (FLTK event loop functions), `Fl_event_key` (FLTK key event constant), `Fl:getFltkEventText` (FLTK event text function), `timer:doWait` (timer wait function), `timer:callback` (timer callback function), `DWindow:make_current` (window current setter), `DWindow:label`/`DWindow:resize`/`DWindow:when` (window label/resize/when functions), `fltk:Fl_Double_Window`/`fltk:Fl_Group`/`fltk:Fl_Button` (FLTK widget constructors), `fltk.FL_BORDER_FRAME`/`fltk.FL_Escape` (FLTK style constants), `fltk:labelsize` (FLTK label size function), `fltk.fl_color`/`fltk.fl_rectf` (FLTK drawing functions), `Fl:event`/`Fl:event_x`/`Fl:event_y` (FLTK event functions), `Fl:wait` (FLTK wait function), `murgaLua.getFltkEventText` (FLTK event text function), `murgaLua.createFltkTimer` (FLTK timer creator), `lfs.dir` (file listing function)
- **Provides:** `mapDrop`, `drawBox`, `drawrectF`, `dragGridLong`, `idleDrag`, `dragGrid`, `event_callback`, `entityBtnClick`, `timer` (FLTK timer object), `DWindow` (engine window object), `gLabelTable` (shared label table), `houseGrid` (grid state variable), `tempGrid` (temporary grid variable), `esize` (grid cell size variable), `col`/`row` (grid column/row variables), `nx`/`ny` (grid cell coordinates variables), `qs` (rectangle size variable), `tCount` (event counter variable), `entityColor` (entity color variable), `color_cycle` (color cycling function)
- **Assets it needs:** none
- **Procedural:** yes - generates temporary grid state (`tempGrid`) and mapper UI widgets (buttons, window, group) from event coordinates, grid cell sizes, and button configuration parameters.
- **Glossary:**
  - `houseGrid` - grid state variable holding placed marker positions for the mapper.
  - `esize` - grid cell size used to determine marker placement and drawing.
  - `DWindow` - engine window object used for mapper UI setup and event handling.
  - `fltk.fl_rectf` - FLTK drawing call for rendering rectangle widgets.
  - `mapDrop` - function that places a drop marker at given mouse coordinates.
  - `dragGrid` - function that handles grid dragging events and fills a temporary grid with rectangles.
  - `entityBtnClick` - callback function for entity button interactions in the mapper UI.
  - `murgaLua` - host environment providing FLTK and file system functions for the engine.
- **Keep / port / drop:** keep - reusable mapper UI and grid handling logic for iGame3D.

---

# Part notes

## Part 1 of 6

### Top level
- **Does:** Sets initial counters and grid state for the mapper file, including `counter=95`, `houseGrid={{32,32}}`, `objectGrid={}`, and the `col`, `row`, `entityColor`, `esize`, `ep` variables.
- **Uses:** nothing
- **Reusable:** no

### mapDrop
- **Does:** Places a drop marker at the given mouse coordinates, adjusts the marker position and grid row/column based on which 64-unit grid cell the point falls into, checks whether a marker already exists at that cell, and adds a new marker to `houseGrid` if none exists.
- **Uses:** `fltk.fl_rectf`, `houseGrid`, `mx`, `my`, `nx`, `ny`, `col`, `row`, `esize`
- **Reusable:** no

### drawBox
- **Does:** Sets the current FLTK window, selects the entity color, checks for a FLTK event, and either draws a square of the current `esize` or calls `mapDrop` with the event coordinates if `esize` is 8.
- **Uses:** `DWindow:make_current`, `fltk.fl_color`, `fltk.fl_rectf`, `Fl:event`, `Fl:event_x`, `Fl:event_y`, `esize`, `mapDrop`
- **Reusable:** no

### drawrectF
- **Does:** Cycles the color to red, calculates half the given size, adjusts the rectangle coordinates by subtracting the half size, and draws a square rectangle of the given size.
- **Uses:** `color_cycle`, `qs`, `math.floor`, `fltk.fl_rectf`
- **Reusable:** yes

### Top level
- **Does:** Generates a temporary grid after the function definitions, initializing `tempGrid={}`.
- **Uses:** `tempGrid`
- **Reusable:** no

## Part 2 of 6

### dragGridLong
- **Does:** Handles long grid dragging events, selects the current window, and fills a temporary grid with rectangles based on the event coordinates.
- **Uses:** `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`, `DWindow:make_current()`, `fltk.fl_color()`, `fltk.fl_rectf()`, `math.random()`, `table.insert()`, `lfs.dir` is not used here.
- **Reusable:** no
- **Procedural:** yes

### idleDrag
- **Does:** Selects the current window when the idle drag event is active.
- **Uses:** `DWindow:make_current()`, `Fl:event()` is not called here.
- **Reusable:** no
- **Procedural:** no

### dragGrid
- **Does:** Handles grid dragging events, selects the current window, and fills a temporary grid with rectangles scaled by the event coordinates.
- **Uses:** `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`, `DWindow:make_current()`, `fltk.fl_color()`, `fltk.fl_rectf()`, `math.random()`, `table.insert()`, `lfs.dir` is not used here.
- **Reusable:** no
- **Procedural:** yes

## Part 3 of 6

### Top level
- **Does:** Sets up the main double window and its label, resizes it, and creates the group with six rows of buttons.
- **Uses:** `fltk:Fl_Double_Window`, `DWindow`, `gLabelTable`, `table.insert`, `DWindow:label`, `DWindow:resize`, `DWindow:when`, `fltk:Fl_Group`, `grp:resize`, `fltk:Fl_Button`, `x1y1` through `x3y2`, `fltk.FL_BORDER_FRAME`, `fltk:labelsize`
- **Reusable:** no

### event_callback
- **Does:** Waits for FLTK events, reads the current event, resets `tCount` when event 7 occurs, triggers the drag grid, and waits briefly afterward.
- **Uses:** `Fl:wait`, `Fl:event`, `evt`, `murgaLua.getFltkEventText`, `tCount`, `dragGrid(DWindow)`, `timer:doWait(0.1)`
- **Reusable:** no

### event_callback
- **Does:** nothing
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### event_callback (continued)
- **Does:** Creates several empty FLTK buttons with border frames and label sizes, then resizes each button to a given width, height and fixed 64x64 size.
- **Uses:** `fltk:Fl_Button`, `fltk.FL_BORDER_FRAME`, `resize`, `box`, `labelsize` (FLTK UI calls); no engine calls, globals or `Data/` paths.
- **Reusable:** yes - the button creation and resize pattern is a reusable UI setup block.
- **Procedural:** no

## Part 5 of 6

### event_callback (continued)
- **Does:** Creates and configures a row of empty FLTK buttons in the Fluid/Mappers UI, setting each button's size, border style and label size.
- **Uses:** `fltk:Fl_Button`, `fltk.FL_BORDER_FRAME`, `resize`, `box`, `labelsize`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 6

### Top level
- **Does:** Creates the Fluid mapper window widgets, wires the entity button callbacks, starts the FLTK timer, and runs the FLTK event loop.
- **Uses:** `fltk:Fl_Button`, `fltk.FL_BORDER_FRAME`, `fltk.FL_Escape`, `gLabelTable`, `entityBtnClick`, `DWindow`, `murgaLua.createFltkTimer`, `timer:callback`, `timer:doWait`, `Fl:run`, `Fl:check`, `Fl:do_callback`, `Fl_event_key`
- **Reusable:** no
- **Procedural:** no
