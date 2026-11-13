<!-- Spark first-look of Data/Fluid/Collector/Collector.lua (model spark-x2.6-4b, 2026-11-12 21:04). DRAFT for Claude to review. -->

## Collector.lua
- **Kind:** ui-dialog
- **Purpose:** This file defines the Collector FLTK user interface for iGame3D, creating the main window with a level browser, collect button, destination input, and choice button, wiring the collect and destination-choice callbacks, and running the FLTK application after loading the level list. It also provides helper functions for collecting selected levels into a table and for populating the level browser with all available levels.
- **Depends on:** `fltk` (FLTK user interface), `gLabelTable`, `Collector` (the FLTK window), `levelListBrowser`, `collectorButton`, `collectDestination`, `widget`, `collectLevels`, `getListOfAllLevels`, `listLevelsInBrowser`, `Fl:run`
- **Provides:** `collectAllSelectedLevels`, `selectCollectDestination`, `listLevelsInBrowser`
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - FLTK window - the base FLTK interface window used to build the Collector UI
  - level browser - a FLTK widget listing available game levels for selection
  - collect destination - the directory path where collected levels are stored
  - FLTK folder chooser - the FLTK dialog used to select a directory for the collect destination
- **Keep / port / drop:** keep

## Collector.lua
- **Kind:** ui-dialog
- **Purpose:** This file implements the Collector UI for iGame3D, building the main FLTK window with a level browser, collect button, destination input, and choose button, wiring the collect and destination-choice callbacks, and running the FLTK application after loading the level list. It also provides helper functions for collecting selected levels into a table and for populating the level browser with all available levels.
- **Depends on:** `fltk` (FLTK user interface), `gLabelTable`, `Collector` (the FLTK window), `levelListBrowser`, `collectorButton`, `collectDestination`, `widget`, `collectLevels`, `getListOfAllLevels`, `listLevelsInBrowser`, `Fl:run`
- **Provides:** `collectAllSelectedLevels`, `selectCollectDestination`, `listLevelsInBrowser`
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - FLTK window - the base FLTK interface window used to build the Collector UI
  - level browser - a FLTK widget listing available game levels for selection
  - collect destination - the directory path where collected levels are stored
  - FLTK folder chooser - the FLTK dialog used to select a directory for the collect destination
- **Keep / port / drop:** keep

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Creates the Collector FLTK window and its child widgets, including the level browser, collect button, destination input, and choose button, and wires the collect and destination-choice callbacks.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `fltk:Fl_Input`, `fltk.fl_dir_chooser`, `gLabelTable`, `Collector`, `levelListBrowser`, `collectorButton`, `collectDestination`, `widget`, `Collector:show`, `Collector:resize`
- **Reusable:** no

### collectAllSelectedLevels
- **Does:** Collects the selected levels from the level list browser into a table, updates the collect button label, and calls collectLevels with the collected table and the collect destination value.
- **Uses:** `getListOfAllLevels`, `levelListBrowser:selected`, `tonumber`, `table.insert`, `collectorButton:label`, `Collector:redraw`, `collectLevels`, `collectDestination:value`
- **Reusable:** no

### selectCollectDestination
- **Does:** Opens the FLTK folder chooser, appends a trailing slash if the chosen directory name does not already end with one, and stores the chosen directory in the collect destination input.
- **Uses:** `fltk.fl_dir_chooser`, `string.sub`, `collectDestination:value`
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Calls `listLevelsInBrowser()` once, then sets the collect destination path and runs the FLTK application.
- **Uses:** `listLevelsInBrowser`, `collectDestination:value`, `Fl:run`
- **Reusable:** no

### listLevelsInBrowser
- **Does:** Clears the level list browser, loads all levels into it via `getListOfAllLevels()`, and adds each level to the browser list.
- **Uses:** `levelListBrowser:clear`, `levelListBrowser:add`, `getListOfAllLevels`
- **Reusable:** no

### listLevelsInBrowser
- **Does:** Sets the collect destination path to `/ig3d_collected/`.
- **Uses:** `collectDestination:value`
- **Reusable:** no
