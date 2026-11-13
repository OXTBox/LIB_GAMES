<!-- Spark first-look of Data/Fluid/Colors/Colors.fl (model spark-x2.6-4b, 2026-11-12 21:09). DRAFT for Claude to review. -->

## Colors.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface for the iGame3D color editing tool, defining the Colors window layout, color input and toggle widgets, and the embedded FLTK code blocks that drive color and fog editing. It renders the color edit window, applies selected color settings to the scene, light, or fog, and supports color source extraction and colormap selection.
- **Depends on:** `Data/Images/Colors/colorsource.png`, `Data/Images/Colors/colorsource.png` (texture path used in color source extraction), engine calls `getSceneInfo`, `setSceneInfo`, `getLightInfo`, `setLightInfo`, `ig3d_SetBackgroundColor_3f`, `ig3d_SetGridColor_3f`, `ig3d_GetColorInTexture_s6i_4f`, constants `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOG`, `IG3D_TINT_COLOR`, globals `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `gChosenLight`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `gFogEnabled`, `colorswindow`, `colormap`, `w`, `toggleAmb`, `toggleDif`, `toggleSpec`, `Rfld`, `Gfld`, `Bfld`, `showColorChooser`, `displayColorAttribute`, `applyColor`, `color_event_callback`, `mousex`, `mousey`, `tCount`, `texFile`, `wleft`, `wtop`, `wright`, `wbottom`, `quote`, `Fl:flush`, `fltk.fl_show_colormap`, `fltk.fl_color_chooser`, `Fl:set_color`, `Fl:event_x_root`, `Fl:event_y_root`, `Fl:event_x()`, `Fl:event_y()`, `Fl:event()`, `Fl:event_x_root`, `Fl:event_y_root`, `murgaLua.getFltkEventText()`, `colorswindow:make_current()`, `colorswindow:redraw()`, `colorswindow:show()`, `lfs.dir`
- **Provides:** `make_window`, `MaxOfOne`, `displayColorAttribute`, `applyColor`, `colorBtnClicked`, `colormap_cb`, `handleColorInput`, `showColorChooser`, `colorFromSource`, `color_event_callback`, `colorswindow`
- **Assets it needs:** `Data/Images/Colors/colorsource.png`
- **Procedural:** none
- **Glossary:**
  - iGame3D calls and constants - Engine API calls and property constants used to read or set object attributes in the iGame3D engine, e.g. `getSceneInfo`, `setLightInfo`, `IG3D_FOG`
  - FLTK UI calls - FLTK user interface function calls used to create, show, and manipulate widgets, e.g. `colorswindow:show()`, `Fl:flush`
  - FLUID (FLTK UI designer) - The FLTK-based UI designer used to author the `.fl` file's widget layout and code blocks
  - Color edit mode - A state (`gColorEditMode`) that selects which color attributes are being edited, such as background, grid, light, or fog
  - Color source texture - The texture (`Data/Images/Colors/colorsource.png`) used to extract colors from a mouse position
- **Keep / port / drop:** keep - It is a complete, reusable color editing UI for the iGame3D engine that other files depend on.

---

# Part notes

## Part 1 of 6

### make_window
- **Does:** Opens the window and sets up color editing state, loads the color source texture, registers images, and initializes color attribute and target globals.
- **Uses:** `getSceneInfo`, `setSceneInfo`, `loadTexture`, `fltk.fl_register_images`, `gameroot`, `Data/Images/Colors/colorsource.png`, globals `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogRed`, `gFogGreen`, `gFogBlue`, `gFogstart`, `gFogend`, `quote`
- **Reusable:** yes
- **Procedural:** no

### MaxOfOne
- **Does:** Converts the input value to a number, prints it, and returns 1 if the numeric value is greater than or equal to 1.
- **Uses:** `tonumber`
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 6

### displayColorAttribute
- **Does:** Renders the color edit window, shows/hides the appropriate color edit fields based on `gColorEditMode`, updates color and fog fields from the selected object's info, and applies the chosen color values to the fields.
- **Uses:** `colorswindow:make_current()`, `colorswindow:redraw()`, widget calls (`toggleAmb:value(...)`, `fogStartFld:value(...)`, etc.), globals `gColorEditMode`, `gChosenLight`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, engine calls `getLightInfo`, `getSceneInfo`, constants `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOG`, `IG3D_TINT_COLOR`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** No top-level code outside the `displayColorAttribute` function; the only code outside the function is the trailing `code {-- applyColor` block marker.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 6

### applyColor
- **Does:** Applies the current color edit mode's color settings to the scene, light, or fog based on the active mode and attribute.
- **Uses:** Engine calls `ig3d_SetBackgroundColor_3f`, `ig3d_SetGridColor_3f`, `setSceneInfo`, `setLightInfo`; globals `gColorEditMode`, `gRed`, `gGreen`, `gBlue`, `gFogEnabled`, `gFogstart`, `gFogend`, `gColorAttribute`, `gChosenLight`, `gAlpha`; `IG3D_FOG`, `IG3D_TINT_COLOR`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`.
- **Reusable:** yes
- **Procedural:** no

### colorBtnClicked
- **Does:** Handles color button clicks by matching the clicked label to the color target, updates the edit mode, toggles fog enable state, and shows the color chooser.
- **Uses:** FLTK UI calls `w:label()`, `w:value()`; globals `gColorTargets`, `gColorEditMode`, `gColorAttribute`, `gfogEnabled`, `colorswindow`, `showColorChooser`, `displayColorAttribute`; engine calls `applyColor()`.
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### Top level
- **Does:** Contains no setup, global definitions, or widget definitions outside the four listed functions; the file continues with an unshown `color_event_callback` section.
- **Uses:** nothing
- **Reusable:** no

### colormap_cb
- **Does:** Updates the colormap widget's color and label from the selected colormap color, triggers redraws and change notification, then shows the colormap widget and flushes FLTK.
- **Uses:** `fltk.fl_show_colormap`, `colormap` (widget), `w` (widget), `Fl:flush`
- **Reusable:** yes

### handleColorInput
- **Does:** Reads the selected label of the color input widget, toggles the corresponding attribute switch widgets and displays the color attribute, applies the selected RGB/alpha field values, or updates fog scene info and fog end value when the label is Start or End.
- **Uses:** `w` (widget), `toggleAmb`, `toggleDif`, `toggleSpec` (widgets), `displayColorAttribute`, `applyColor`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `getSceneInfo`, `IG3D_FOG`
- **Reusable:** no

### showColorChooser
- **Does:** Displays the current color attributes, opens the FLTK color chooser with the current RGB values, converts the chosen color to normalized RGB values, updates the color field widgets and color window, then applies the updated color.
- **Uses:** `displayColorAttribute`, `gRed`, `gGreen`, `gBlue`, `fltk.fl_color_chooser`, `Fl:set_color`, `gColorEditMode`, `colorswindow`, `Rfld`, `Gfld`, `Bfld`, `applyColor`
- **Reusable:** yes

### colorFromSource
- **Does:** Reads the selected texture file and widget bounding box coordinates, captures the mouse event coordinates, extracts the color at the mouse position from the texture, and prints the texture path and coordinates along with the extracted RGB values.
- **Uses:** `ColorSource` (widget), `w` (widget), `texFile`, `wleft`, `wtop`, `wright`, `wbottom`, `Fl:event_x_root`, `Fl:event_y_root`, `ig3d_GetColorInTexture_s6i_4f`
- **Reusable:** yes

### color_event_callback
- **Does:** Not shown in the provided code; no implementation details are available.
- **Uses:** nothing
- **Reusable:** no

## Part 5 of 6

### color_event_callback
- **Does:** Handles FLTK mouse events on the colors window, records event coordinates, prints event text, and updates the color count or extracts color values from a texture based on the event type.
- **Uses:** `colorswindow`, `evt`, `mousex`, `mousey`, `tCount`, `texFile`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`, `murgaLua.getFltkEventText()`, `colorswindow:redraw()`, `Data/Images/Colors/colorsource.png`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 6

### colorswindow
- **Does:** Defines the Colors window widget layout and its embedded FLTK code blocks, then shows, makes it current, redraws it, and calls displayColorAttribute.
- **Uses:** Widget definitions (`Fl_Window`, `Fl_Value_Input`, `Fl_Button`) with `xywh`, `callback`, and `code` blocks; engine/FLTK calls inside code blocks (`colorswindow:show()`, `colorswindow:make_current()`, `colorswindow:redraw()`, `displayColorAttribute()`); no `Data/` paths or engine object calls.
- **Reusable:** yes
- **Procedural:** no

### Top level
- **Does:** Contains the top-level widget and code definitions for the Colors window, including the window, color input fields, toggle buttons, and embedded FLTK code blocks.
- **Uses:** Widget definitions (`Fl_Window`, `Fl_Value_Input`, `Fl_Button`) with `xywh`, `callback`, and `code` blocks; FLTK calls inside code blocks (`colorswindow:show()`, `colorswindow:make_current()`, `colorswindow:redraw()`, `displayColorAttribute()`); no `Data/` paths or engine object calls.
- **Reusable:** yes
- **Procedural:** no
