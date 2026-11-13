<!-- Spark first-look of Data/Fluid/EntityPicker/EntityPicker.fl (model spark-x2.6-4b, 2026-11-12 22:28). DRAFT for Claude to review. -->

## EntityPicker.fl
- **Kind:** ui-dialog
- **Purpose:** This file defines the FLTK user interface for the EntityPicker, creating the window and its nested groups along with the browser, value input, menu button, and output widgets used by the EntityPicker.
- **Depends on:** nothing
- **Provides:** the make_window function that builds the EntityPicker's FLTK window and nested UI groups.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:** 
  - FLTK - the user interface toolkit used by the FLUID UI designer to build the window widgets.
  - FLUID - the FLTK User Interface Designer that authors this `.fl` file.
  - EntityPicker - the application component this UI file supports, managing entity selection and value input.
- **Keep / port / drop:** keep (serves as a reference for building FLTK-based UI in the iGame3D engine).

---

# Part notes

## Part 1 of 1

### make_window
- **Does:** Creates the FLTK window and its nested groups, check browser, value input, menu button and output widget for the EntityPicker.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no
