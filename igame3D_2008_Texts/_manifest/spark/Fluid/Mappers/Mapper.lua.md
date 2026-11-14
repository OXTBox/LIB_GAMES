<!-- Spark first-look of Data/Fluid/Mappers/Mapper.lua (model spark-x2.6-4b, 2026-11-13 00:35). DRAFT for Claude to review. -->

## Mapper.lua
- **Kind:** ui-dialog
- **Purpose:** This file defines a FLTK-based UI dialog for iGame3D, including color cycling logic, rectangle drawing helpers, and window/button setup to drive the interactive interface. It builds and shows a FLTK window with buttons wired to drawing callbacks, then starts the FLTK event loop.
- **Depends on:** globals `counter`, `counterStep`, `counterLimit`, `DWindow`, `color_cycle`, `qx`, `qy`, `qs`; engine calls `fltk.fl_color`, `fltk.fl_rectf`, `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk.FL_NO_BOX`, `math.floor`, `Fl:event_x()`, `Fl:event_y()`, `w:x()`, `w:y()`, `Fl:run`; user interface calls `Fl_Window`, `Fl_Group`, `Fl_Button`, `callback`, `resize`, `labelsize`, `box`, `current`, `show`, `make_current`, `do_callback`.
- **Provides:** globals `counter`, `color_cycle`, `drawBox`, `drawrectF`; FLTK widget setup and callback wiring for the mapper UI.
- **Assets it needs:** none
- **Procedural:** generates rectangle drawing positions and button configurations from numeric parameters and rules (e.g., color cycle values, fixed button sizes) rather than loading asset files.
- **Glossary:**
  - `fltk.fl_color` - FLTK engine call that applies a color to the UI.
  - `fltk.fl_rectf` - FLTK engine call that draws a filled rectangle with floating-point coordinates.
  - `DWindow` - global FLTK window object used to manage the mapper UI window.
  - `color_cycle` - global function that cycles colors using the `counter` global and applies the resulting color.
  - `drawBox` - callback function that captures event coordinates, draws a square rectangle, and triggers color cycling.
  - `drawrectF` - function that draws a filled rectangle using a color cycle and a square of a given size.
  - `callback` - FLTK user interface call that wires a button to a function.
  - `resize` - FLTK user interface call that sets a widget's width and height.
- **Keep / port / drop:** keep - serves as a reusable reference for FLTK UI construction and color cycling logic in iGame3D.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Sets the global `counter` to 95 at file start.
- **Uses:** nothing
- **Reusable:** no

### color_cycle
- **Does:** Increments the global `counter` by `counterStep`, resets it to `counterStep` if it exceeds `counterLimit`, then applies the resulting color via `fltk.fl_color`.
- **Uses:** globals `counter`, parameters `baseColor`, `counterLimit`, `counterStep`; engine call `fltk.fl_color`
- **Reusable:** yes

### drawBox
- **Does:** Captures the current event coordinates, selects the active DWindow, prints the coordinates and computed box position, calls `color_cycle` with fixed arguments, draws a square rectangle at the event coordinates, and prints a redraw hint.
- **Uses:** globals `DWindow`; engine calls `Fl:event_x()`, `Fl:event_y()`, `w:x()`, `w:y()`, `fltk.fl_rectf`; global `color_cycle`
- **Reusable:** no

## Part 2 of 5

### Top level
- **Does:** Contains one setup line and several FLTK widget creation and configuration blocks; no functions.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk.FL_NO_BOX`, `fltk.fl_rectf`, `color_cycle`, `math.floor`, `DWindow`, `widget`, `x1y1` through `x4y2`.
- **Reusable:** no

### drawrectF
- **Does:** Draws a filled rectangle using a color cycle and a square of the given size, centered at the given top-left coordinates.
- **Uses:** `color_cycle`, `math.floor`, `fltk.fl_rectf`, `qx`, `qy`, `qs`.
- **Reusable:** yes

### drawBox
- **Does:** Not defined in this part; no code or description available for this function.
- **Uses:** nothing
- **Reusable:** unsure
- **Procedural:** no

## Part 3 of 5

### drawrectF (continued)
- **Does:** Creates several FLTK buttons with the `drawBox` callback, resizes each to a given width, height and size, and applies no border and label size 11.
- **Uses:** `fltk:Fl_Button`, `fltk.FL_NO_BOX`, `callback`, `resize`, `labelsize` (user interface calls only)
- **Reusable:** no

## Part 4 of 5

### drawrectF (continued)
- **Does:** Creates several FLTK buttons with fixed sizes and no box, each wired to drawBox, then sets their label size to 11.
- **Uses:** fltk:Fl_Button, fltk.FL_NO_BOX, drawBox (callback), resize, box, labelsize
- **Reusable:** no
- **Procedural:** no

## Part 5 of 5

### Top level
- **Does:** Builds and shows the FLTK window, wires the button callbacks, and starts the FLTK event loop.
- **Uses:** `fltk:Fl_Button`, `x3y6:resize`, `x3y6:box`, `x3y6:labelsize`, `x4y6:callback`, `x5y6:callback`, `x6y6:callback`, `Fl_Group:current`, `DWindow:show`, `DWindow:make_current`, `DWindow:do_callback`, `Fl:run`
- **Reusable:** no
