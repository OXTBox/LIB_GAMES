<!-- Spark folder manifest of Data/Fluid/MeshtagBrowser (model spark-x2.6-4b, 2026-11-13 01:01). DRAFT. -->

# Data/Fluid/MeshtagBrowser
- **Role:** This folder provides a FLTK user interface for browsing and editing mesh tags in iGame3D, including listing used tags, selecting/editing tag textures, and navigating PNG directories.
- **Entry point:** MeshtagBrowser.lua
- **Files:** MeshtagBrowser.fl - FLUID twin of MeshtagBrowser.lua; MeshtagBrowser.lua - ui-dialog wiring FLTK widgets to mesh tag browser callbacks and running the FLTK app.
- **Shared with other folders:** Needs gameroot global and Data/Images/ path; provides mesh tag browsing UI for other Fluid FLTK dialogs.
- **Procedure candidates:** Runs FLTK application after initializing mesh tag list; wires FLTK widgets to mesh tag browser callbacks.
- **Glossary:** mesh tag - tag used to identify mesh objects in iGame3D; FLTK - user interface toolkit used by the engine; FLUID - FLTK UI designer producing .fl files; ui-dialog - FLTK dialog type for this interface.
- **Verdict:** keep - it is a self-contained FLTK mesh tag browser UI that matches the engine's mesh tag workflow and needs only the gameroot global and Images path.
