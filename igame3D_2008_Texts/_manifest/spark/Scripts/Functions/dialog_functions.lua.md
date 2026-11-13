<!-- Spark first-look of Data/Scripts/Functions/dialog_functions.lua (model spark-x2.6-4b, 2026-11-12 06:40). DRAFT for Claude to review. -->

## dialog_functions.lua
- **Kind:** ui-dialog
- **Purpose:** This file provides small UI helper functions for selecting folders or files in the iGame3D engine. It offers reusable dialogs to collect user-selected directories or filenames and returns the stored path or filename. The file contains no setup, globals, or widget definitions beyond these function definitions.
- **Depends on:** `fltk.fl_dir_chooser` and `fltk.fl_file_chooser` UI calls, global `gameroot`, globals `tFolder` and `tFile` set elsewhere, helper `replaceText`, and the `Data/` folder path structure used by the engine.
- **Provides:** `chooseFolder`, `chooseFile`, and `canceldialog` functions; globals `tFolder` and `tFile` are populated by the chooser functions.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none
- **Glossary:**
  - `fltk` - The FLTK user interface library used by the engine for dialogs and widgets.
  - `fl_dir_chooser` / `fl_file_chooser` - FLTK dialog functions that open folder or file selection windows.
  - `gameroot` - A global path used to build engine file paths under the `Data/` folder.
  - `tFolder` / `tFile` - Globals that store the selected directory path or filename returned by the chooser functions.
  - `replaceText` - A helper function used by the chooser functions to process the returned path or filename.
- **Keep / port / drop:** keep - reusable UI helpers for selecting folders and files in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** No setup, globals, widget definitions, or other top-level code exists in this file beyond the function definitions.
- **Uses:** nothing
- **Reusable:** no

### chooseFolder
- **Does:** Opens a folder chooser dialog, stores the returned directory path into the global `tFolder` if a directory is selected, and returns the stored path.
- **Uses:** `fltk.fl_dir_chooser(title,start_path,relative)`, global `gameroot`, global `tFolder`, helper `replaceText`.
- **Reusable:** yes

### chooseFile
- **Does:** Opens a file chooser dialog, stores the returned filename into the global `tFile` if a file is selected, and returns the stored path.
- **Uses:** `fltk.fl_file_chooser(title,filename_filter,start_path,relative)`, global `gameroot`, global `tFile`, helper `replaceText`.
- **Reusable:** yes

### canceldialog
- **Does:** Performs no visible or functional action; the function body is empty.
- **Uses:** nothing
- **Reusable:** no
