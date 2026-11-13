<!-- Spark first-look of Data/Fluid/Colors/MikColors.lua (model spark-x2.6-4b, 2026-11-12 21:13). DRAFT for Claude to review. -->

## MikColors.lua
- **Kind:** ui-dialog
- **Purpose:** Defines the top-level UI setup for the color editor, including the color map button and color chooser button along with their callback logic for applying color choices to the editor.
- **Depends on:** `fltk.` UI calls (`fl_show_colormap`, `fl_color_chooser`, `align`, `callback`, `color`, `redraw`, `show`, `set_changed`, `redraw_label`, `flush`), `gEditingMode`, `gRed`, `gGreen`, `gBlue`, `colorChooser`, `handleColorInput`, `colormap`, `w`, `left`, `bw`, `row`, `pop`, `color_o`, `k`, `hexcolor`, `string.format`
- **Provides:** `colormap_cb` (color map callback), `pop` (color map button), plus UI setup for the color editor including the color chooser and its callback logic.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `fltk.` - FLTK user interface calls used to build and manage the UI widgets.
  - `colormap` - The FLTK color chooser widget used for selecting colors in the editor.
  - `callback` - UI callback mechanism that runs code when a button or widget is activated.
  - `redraw` - UI method that refreshes the widget display.
  - `set_changed` - UI method marking that the widget has changed so it can be redrawn.
- **Keep / port / drop:** keep
- **Reason:** Serves as a reusable reference for building color editor UI with FLTK color chooser and callback logic.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the top-level UI setup for the color editor, including the color map button, color chooser button, and their callbacks.
- **Uses:** `fltk.` UI calls (`fl_show_colormap`, `fl_color_chooser`, `align`, `callback`, `color`, `redraw`, `show`, `set_changed`, `redraw_label`, `flush`), `gEditingMode`, `gRed`, `gGreen`, `gBlue`, `colorChooser`, `handleColorInput`, `colormap`, `w`, `left`, `bw`, `row`, `pop`, `colorchooser`, `color_o`, `k`, `hexcolor`, `string.format`.
- **Reusable:** no
- **Procedural:** no
