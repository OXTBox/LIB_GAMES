<!-- Spark first-look of Data/Fluid/Colors/Colors.lua (model spark-x2.6-4b, 2026-11-12 21:12). DRAFT for Claude to review. -->

## Colors.lua
- **Kind:** ui-dialog
- **Purpose:** This file implements the color editing interface for iGame3D, allowing users to adjust scene color, fog, tint, and light attributes through a FLTK-based window with color input widgets, color chooser, and fog toggle controls. It loads a color source texture and manages the color edit workflow from setup through display, application, and event handling.
- **Depends on:** `Data/Images/Colors/colorsource.png`, `gLabelTable`, `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `gChosenLight`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `getSceneInfo`, `setSceneInfo`, `getLightInfo`, `setLightInfo`, `fltk.fl_register_images`, `fltk.fl_show_colormap`, `fltk.fl_color_chooser`, `murgaLua.getFltkEventText`, `ig3d_GetColorInTexture_s6i_4f`, `ig3d_SetBackgroundColor_3f`, `ig3d_SetGridColor_3f`, `showColorChooser`, `displayColorAttribute`, `applyColor`, `colorBtnClicked`, `handleColorInput`, `colorFromSource`, `color_event_callback`, `MaxOfOne`
- **Provides:** `MaxOfOne`, `displayColorAttribute`, `applyColor`, `colorBtnClicked`, `colormap_cb`, `handleColorInput`, `showColorChooser`, `colorFromSource`, `color_event_callback`
- **Assets it needs:** `Data/Images/Colors/colorsource.png`
- **Procedural:** none
- **Glossary:**
  - `IG3D_FOG - iGame3D constant naming the fog property being read or set`
  - `IG3D_BACKGROUND_COLOR - iGame3D constant naming the background color property`
  - `fltk - FLTK user interface library used for the color editing window`
  - `gColorEditMode - global tracking the current color editing mode`
  - `gColorAttribute - global tracking the active color attribute being edited`
  - `gColorTargets - global list of color targets matched by color button labels`
  - `gChosenLight - global tracking the selected light for color application`
  - `fltk.fl_color_chooser - FLTK color chooser widget used to request user color input`
- **Keep / port / drop:** keep - core color editing UI logic that is directly reusable for new iGame3D color interfaces

## Colors.lua
- **Kind:** ui-dialog
- **Purpose:** This file provides the color editing interface for iGame3D, letting users adjust scene color, fog, tint, and light attributes through a FLTK-based window with color input widgets, color chooser, and fog toggle controls. It loads a color source texture and manages the color edit workflow from setup through display, application, and event handling.
- **Depends on:** `Data/Images/Colors/colorsource.png`, `gLabelTable`, `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `gChosenLight`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `getSceneInfo`, `setSceneInfo`, `getLightInfo`, `setLightInfo`, `fltk.fl_register_images`, `fltk.fl_show_colormap`, `fltk.fl_color_chooser`, `murgaLua.getFltkEventText`, `ig3d_GetColorInTexture_s6i_4f`, `ig3d_SetBackgroundColor_3f`, `ig3d_SetGridColor_3f`, `showColorChooser`, `displayColorAttribute`, `applyColor`, `colorBtnClicked`, `handleColorInput`, `colorFromSource`, `color_event_callback`, `MaxOfOne`
- **Provides:** `MaxOfOne`, `displayColorAttribute`, `applyColor`, `colorBtnClicked`, `colormap_cb`, `handleColorInput`, `showColorChooser`, `colorFromSource`, `color_event_callback`
- **Assets it needs:** `Data/Images/Colors/colorsource.png`
- **Procedural:** none
- **Glossary:**
  - `IG3D_FOG - iGame3D constant naming the fog property being read or set`
  - `IG3D_BACKGROUND_COLOR - iGame3D constant naming the background color property`
  - `fltk - FLTK user interface library used for the color editing window`
  - `gColorEditMode - global tracking the current color editing mode`
  - `gColorAttribute - global tracking the active color attribute being edited`
  - `gColorTargets - global list of color targets matched by color button labels`
  - `gChosenLight - global tracking the selected light for color application`
  - `fltk.fl_color_chooser - FLTK color chooser widget used to request user color input`
- **Keep / port / drop:** keep - core color editing UI logic that is directly reusable for new iGame3D color interfaces

---

# Part notes

## Part 1 of 7

### Top level
- **Does:** Sets global color editing state and attributes, loads the color source texture, registers FLTK images, reads scene color/fog info, and defines the `MaxOfOne` function.
- **Uses:** `colorAttributes`, `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `getSceneInfo`, `setSceneInfo`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `gameroot`, `loadTexture`, `fltk.fl_register_images`, `colorsourcefile`, `quote`, `gRed`, `gBlue`, `gGreen`, `Alpha`, `gfogEnabled`, `gFogRed`, `gFogGreen`, `gFogBlue`, `gFogstart`, `gFogend`, `choosr`, `choosg`, `choosb`
- **Reusable:** no

### MaxOfOne
- **Does:** Converts the input value to a number, returns 1 if the number is at least 1, otherwise returns nothing.
- **Uses:** `tonumber`
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 7

### displayColorAttribute
- **Does:** Renders the color editor window, shows or hides the Fog fields and toggles, then updates the color fields and redraws the window based on the current color edit mode.
- **Uses:** `colorswindow`, `gColorEditMode`, `gChosenLight`, `gColorAttribute`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `getLightInfo`, `getSceneInfo`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOG`, `IG3D_TINT_COLOR`, widget calls such as `make_current`, `value`, `hide`, `show`, `redraw`
- **Reusable:** no
- **Procedural:** no

### displayColorAttribute
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes, copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 3 of 7

### applyColor
- **Does:** Applies the current color edit mode to the scene, grid, fog, tint, or selected light, using the color and attribute globals.
- **Uses:** `gColorEditMode`, `gRed`, `gGreen`, `gBlue`, `gFogstart`, `gFogend`, `gfogEnabled`, `gColorAttribute`, `gChosenLight`, `gAlpha`, `setSceneInfo`, `setLightInfo`, `ig3d_SetBackgroundColor_3f`, `ig3d_SetGridColor_3f`, `IG3D_FOG`, `IG3D_TINT_COLOR`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`
- **Reusable:** yes
- **Procedural:** no

### colorBtnClicked
- **Does:** Handles a color button click by matching the button label to a color target, updates the edit mode and color window label, toggles fog enable state, and shows the color chooser.
- **Uses:** `w:label()`, `w:value()`, `gColorTargets`, `gColorEditMode`, `gColorAttribute`, `gfogEnabled`, `applyColor`, `colorswindow:label`, `showColorChooser`, `displayColorAttribute`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 7

### colormap_cb
- **Does:** Updates the color map widget's color, label, redraw state and visibility, then flushes the FLTK UI.
- **Uses:** `fltk.fl_show_colormap`, `fltk.fl_color_chooser` (via `fltk.fl_color_chooser`), `w:redraw`, `w:show`, `w:set_changed`, `w:redraw_label`, `Fl:flush`, and the `colormap` widget.
- **Reusable:** yes
- **Procedural:** no

### handleColorInput
- **Does:** Reads the color input widget's label, toggles the corresponding attribute switches and updates the color display for Ambient, Diffuse, Specular, R, G, B, A, Start and End inputs, applying the resulting color values.
- **Uses:** `w:label`, `w:value`, `w:redraw`, `toggleAmb`, `toggleDif`, `toggleSpec`, `displayColorAttribute`, `applyColor`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `gfogEnabled`, `gFogstart`, `gFogend`, `getSceneInfo(IG3D_FOG)`, and the `Rfld`, `Gfld`, `Bfld`, `Afld` widgets.
- **Reusable:** no
- **Procedural:** no

### showColorChooser
- **Does:** Displays the color attribute, asks the user for a new color, converts the chosen color to 0–255 values, updates the color fields and redraws the color window, then applies the new color.
- **Uses:** `displayColorAttribute`, `gRed`, `gGreen`, `gBlue`, `fltk.fl_color_chooser`, `Fl:set_color`, `colorswindow:make_current`, `colorswindow:redraw`, `Rfld:value`, `Gfld:value`, `Bfld:value`, `applyColor`.
- **Reusable:** no
- **Procedural:** no

### colorFromSource
- **Does:** Reads the source texture file and widget bounds, gets the mouse event coordinates, extracts the color at the mouse position from the texture, and prints the texture path, bounds and extracted color values.
- **Uses:** `ColorSource:image`, `w:x`, `w:y`, `w:w`, `w:h`, `Fl:event_x_root`, `Fl:event_y_root`, `ig3d_GetColorInTexture_s6i_4f`, and the `texFile` local.
- **Reusable:** no
- **Procedural:** no

## Part 5 of 7

### Top level
- **Does:** Sets up the Colors window and its color input widgets, and registers the color event callback.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `colorswindow`, `Rfld`, `Gfld`, `Bfld`, `Afld`, `handleColorInput`, `murgaLua.getFltkEventText`, `Data/` path `/Data/Images/Colors/colorsource.png`
- **Reusable:** no

### color_event_callback
- **Does:** Handles mouse events on the Colors window, records event coordinates, prints event text, and updates color values when the event is type 5.
- **Uses:** `colorswindow`, `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`, `murgaLua.getFltkEventText`, `tCount`, `texFile`, `gRed`, `gGreen`, `gBlue`, `gAlpha`, `ig3d_GetColorInTexture_s6i_4f`, `colorswindow:redraw()`
- **Reusable:** no

### handleColorInput
- **Does:** nothing shown in this code section
- **Uses:** nothing
- **Reusable:** no

## Part 6 of 7

### color_event_callback (continued)
- **Does:** Builds the fog start, fog end, and edit toggle widgets for the color event UI, labels them from the shared gLabelTable, wires their callbacks, and sets their sizes, bounds, and initial values.
- **Uses:** fltk widget constructors (`fltk:Fl_Value_Input`, `fltk:Fl_Button`), `gLabelTable`, `handleColorInput`, `colorBtnClicked`, `table.insert`, widget methods (`label`, `callback`, `resize`, `labelsize`, `align`, `minimum`, `maximum`, `step`, `value`, `textsize`, `down_box`), `fltk.FL_THIN_DOWN_BOX`.
- **Reusable:** no
- **Procedural:** no

## Part 7 of 7

### Top level
- **Does:** Shows the colors window, creates and configures FLTK buttons and a color cube, then runs the FLTK application.
- **Uses:** `colorswindow`, `fltk`, `displayColorAttribute`, `Fl:run()`, `colormap`, `colorchooser`, `color_cube`
- **Reusable:** no
- **Procedural:** no
