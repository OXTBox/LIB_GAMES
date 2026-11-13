<!-- Spark folder manifest of Data/Fluid/CameraBrowser (model spark-x2.6-4b, 2026-11-13 00:13). DRAFT. -->

# Data/Fluid/CameraBrowser
- **Role:** This folder holds the CameraBrowser user interface for iGame3D, letting programmers browse, edit, and replace camera attributes, values, textures, and WTF sources through FLTK widgets.
- **Entry point:** CameraBrowser.lua
- **Files:** CameraBrowser.fl - FLUID twin of CameraBrowser.lua; CameraBrowser.lua - CameraBrowser UI logic; script.fl - FLUID script file for the folder.
- **Shared with other folders:** Needs engine camera globals and WTF model data from elsewhere; provides camera tool UI to users.
- **Procedure candidates:** CameraBrowser:make_current() and CameraBrowser:show() build the dialog UI; CameraBrowser:label() updates the dialog labels.
- **Glossary:** CameraBrowser - FLTK user interface for browsing and editing cameras; FLUID - FLTK UI designer text format; WTF - 3D model and text source format; FLTK - user interface library; FL - FLTK UI file format.
- **Verdict:** keep - it is a complete, self-contained camera editing UI matching the engine's camera management needs.
