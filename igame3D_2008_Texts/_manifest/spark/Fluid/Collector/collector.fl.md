<!-- Spark first-look of Data/Fluid/Collector/collector.fl (model spark-x2.6-4b, 2026-11-12 21:05). DRAFT for Claude to review. -->

## collector.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the Fluid UI definition for the Collector window of iGame3D, providing the FLTK widget layout and interaction logic for collecting used game data. It defines the window entry point, level collection handling, and folder selection for the collector's destination directory.
- **Depends on:** `getListOfAllLevels()`, `collectLevels(collTbl, collectDestination:value())`, `fltk.fl_dir_chooser()`, FLTK widget definitions (`Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Input`) with their `xywh` and `callback` properties.
- **Provides:** `make_window` function, `collectAllSelectedLevels` function, `selectCollectDestination` function, `listLevelsInBrowser` function, and the `collectDestination` widget value.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `Fl_Window` - FLTK UI widget used to define the Collector window.
  - `Fl_Browser` - FLTK UI widget used to display and select levels in the UI.
  - `Fl_Button` - FLTK UI widget used for buttons in the Collector window.
  - `Fl_Input` - FLTK UI widget used for input fields in the Collector window.
  - `callback` - FLTK property that defines the function executed when a widget is activated.
  - `xywh` - FLTK property defining the position and size of a widget.
  - `value` - FLTK property used to set the value of a widget, such as the collect destination directory.
- **Keep / port / drop:** keep
- **Reason:** This file is a complete, working UI definition for the Collector window that provides reusable reference for adding FLTK-based UI to a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the Fluid UI file header and the top-level widget definitions for the Collector window, including the `Collector:show()` call and the initial `collectDestination:value("/ig3d_collected/")` setup.
- **Uses:** `Collector:show()`, `collectDestination:value("/ig3d_collected/")`, FLTK widget definitions (`Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Input`) with their `xywh` and `callback` properties.
- **Reusable:** no

### make_window
- **Does:** Defines the `make_window` function as the UI file entry point, opening the Collector window.
- **Uses:** `open` block for the `Collector` `Fl_Window` widget.
- **Reusable:** no

### collectAllSelectedLevels
- **Does:** Collects all selected levels from the level browser, updates the collector button label, triggers a redraw, collects the selected levels to the destination directory, and restores the button label.
- **Uses:** `getListOfAllLevels()`, `levelListBrowser:selected(i)`, `collectorButton:label(...)`, `Collector:redraw()`, `collectLevels(collTbl, collectDestination:value())`, `collectDestination:value()`.
- **Reusable:** no

### selectCollectDestination
- **Does:** Opens a folder chooser to select the directory for collecting used data, ensures the directory path ends with a slash, and sets the chosen directory as the collect destination.
- **Uses:** `fltk.fl_dir_chooser("Please choose a folder to collect the used data to...","/",false)`, `string.sub(dirname, -1,-1)`, `collectDestination:value(dirname)`.
- **Reusable:** no

### listLevelsInBrowser
- **Does:** Clears the level browser, loads all levels from `getListOfAllLevels()`, and adds each level to the browser.
- **Uses:** `levelListBrowser:clear()`, `getListOfAllLevels()`, `levelListBrowser:add(tbl[i])`.
- **Reusable:** yes

### Top level
- **Does:** Contains the top-level execution code that shows the Collector window and initializes the collect destination directory to `/ig3d_collected/`.
- **Uses:** `Collector:show()`, `collectDestination:value("/ig3d_collected/")`.
- **Reusable:** no
