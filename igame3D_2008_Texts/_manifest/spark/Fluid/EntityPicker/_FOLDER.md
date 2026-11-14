<!-- Spark folder manifest of Data/Fluid/EntityPicker (model spark-x2.6-4b, 2026-11-12 22:29). DRAFT. -->

# Data/Fluid/EntityPicker
- **Role:** This folder provides the FLTK-based user interface for the EntityPicker, a component used to select and configure entities in the iGame3D engine. The `.fl` file defines the window and nested UI groups, while the `.lua` file builds and runs the interface to handle entity selection and value input.
- **Entry point:** EntityPicker.lua
- **Files:**
  - EntityPicker.fl - FLTK user interface file defining the EntityPicker window, nested groups, browser, value input, menu button, and output widgets via the make_window function.
  - EntityPicker.lua - Lua file that builds the EntityPicker FLTK user interface, displays it, and runs the FLTK event loop for user interaction; contains the make_window function definition.
- **Shared with other folders:** Needs `fltk` (FLTK UI modules), `widget` (FLTK widget helpers), `gLabelTable` (shared global table), and `table.insert` (Lua table helper) from elsewhere. Serves as a reusable reference for building FLTK-based entity selection UIs in the iGame3D engine.
- **Procedure candidates:** The `make_window` function builds the EntityPicker UI procedurally from FLTK widgets; the EntityPicker.lua file runs the FLTK event loop to handle user interaction procedurally.
- **Glossary:**
  - FLTK - the user interface toolkit used by the FLUID UI designer to build the window widgets.
  - FLUID - the FLTK User Interface Designer that authors this `.fl` file.
  - EntityPicker - the application component this UI file supports, managing entity selection and value input.
  - Fl_Double_Window - FLTK double-height window widget used to build the EntityPicker UI.
  - Fl_Group - FLTK group widget used to organize UI elements within the EntityPicker.
  - Fl_Check_Browser - FLTK check browser widget used for UI interaction in the EntityPicker.
  - Fl_Value_Input - FLTK value input widget used for UI interaction in the EntityPicker.
  - Fl_Menu_Button - FLTK menu button widget used for UI interaction in the EntityPicker.
  - Fl_Output - FLTK output widget used for UI interaction in the EntityPicker.
  - widget:resize - FLTK widget helper that resizes a UI widget.
  - widget:labelsize - FLTK widget helper that sets a UI widget's label size.
- **Verdict:** keep, as it serves as a reusable reference for building FLTK-based entity selection UIs in the iGame3D engine and provides the UI structure for the EntityPicker component.
