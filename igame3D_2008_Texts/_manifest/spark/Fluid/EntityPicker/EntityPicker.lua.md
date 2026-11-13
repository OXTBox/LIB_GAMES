<!-- Spark first-look of Data/Fluid/EntityPicker/EntityPicker.lua (model spark-x2.6-4b, 2026-11-12 22:28). DRAFT for Claude to review. -->

## EntityPicker.lua
- **Kind:** ui-dialog
- **Purpose:** Builds the EntityPicker FLTK user interface for selecting and configuring entities in the iGame3D engine, displays it, and runs the FLTK event loop to handle user interaction.
- **Depends on:** `fltk` (FLTK UI modules), `widget` (FLTK widget helpers), `gLabelTable` (shared global table), `table.insert` (Lua table helper)
- **Provides:** the main functions or globals other files use for constructing and running the EntityPicker UI (per the header comment, the file contains the `make_window` function definition).
- **Assets it needs:** none named in the code
- **Procedural:** none
- **Glossary:**
  - `Fl_Double_Window - FLTK double-height window widget used to build the EntityPicker UI`
  - `Fl_Group - FLTK group widget used to organize UI elements within the EntityPicker`
  - `Fl_Check_Browser - FLTK check browser widget used for UI interaction in the EntityPicker`
  - `Fl_Value_Input - FLTK value input widget used for UI interaction in the EntityPicker`
  - `Fl_Menu_Button - FLTK menu button widget used for UI interaction in the EntityPicker`
  - `Fl_Output - FLTK output widget used for UI interaction in the EntityPicker`
  - `widget:resize - FLTK widget helper that resizes a UI widget`
  - `widget:labelsize - FLTK widget helper that sets a UI widget's label size`
- **Keep / port / drop:** keep (serves as a reusable reference for building FLTK-based entity selection UIs in the iGame3D engine)

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds the EntityPicker FLTK UI, shows it, and runs the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Check_Browser`, `fltk:Fl_Value_Input`, `fltk:Fl_Menu_Button`, `fltk:Fl_Output`, `widget:resize`, `widget:labelsize`, `widget:textsize`, `widget:label`, `widget:align`, `widget:textfont`, `widget:show`, `Fl_Group:current`, `Fl:run`, `gLabelTable`, `table.insert`
- **Reusable:** no
- **Procedural:** no
