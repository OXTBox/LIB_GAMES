<!-- Spark folder manifest of Data/Fluid/Collector (model spark-x2.6-4b, 2026-11-12 21:06). DRAFT. -->

# Data/Fluid/Collector
- **Role:** This folder holds the FLTK-based user interface for the Collector tool in iGame3D, which lets a player browse and collect game levels and choose where collected levels are stored. The folder combines a Lua implementation of the Collector UI with the FLUID UI definition that builds the window layout and interaction logic.
- **Entry point:** collector.fl
- **Files:**
  - Collector.lua - Lua implementation of the Collector FLTK user interface, defining the main window, level browser, collect and destination-choice widgets, wiring callbacks, and helper functions for collecting selected levels and populating the level browser.
  - collector.fl - Fluid UI definition for the Collector window, providing the FLTK widget layout, interaction logic, and the collect destination widget value.
- **Shared with other folders:** The folder depends on `fltk` (FLTK user interface), `gLabelTable`, and the level list helpers `getListOfAllLevels`, `collectLevels`, and `listLevelsInBrowser` from other engine folders. It provides the Collector UI to the game, and other folders use the level list data it references.
- **Procedure candidates:** The `make_window` function in collector.fl builds the Collector window layout and interaction logic procedurally from FLTK widget definitions, and the Lua helper functions `collectAllSelectedLevels`, `selectCollectDestination`, and `listLevelsInBrowser` produce the UI behavior and level browser population programmatically rather than being stored as static files.
- **Glossary:**
  - FLTK window - the base FLTK interface window used to build the Collector UI.
  - level browser - a FLTK widget listing available game levels for selection.
  - collect destination - the directory path where collected levels are stored.
  - FLTK folder chooser - the FLTK dialog used to select a directory for the collect destination.
  - FLTK widget - FLTK UI widget used to define the Collector window layout, including `Fl_Window`, `Fl_Browser`, `Fl_Button`, and `Fl_Input`.
  - callback - FLTK property that defines the function executed when a widget is activated.
  - xywh - FLTK property defining the position and size of a widget.
  - value - FLTK property used to set the value of a widget, such as the collect destination directory.
- **Verdict:** keep, this folder is a complete, working UI definition for the Collector window that provides reusable reference for adding FLTK-based UI to a new engine.
