<!-- Spark first-look of Data/Fluid/BVHbrowser/BVHbrowser.lua (model spark-x2.6-4b, 2026-11-12 19:39). DRAFT for Claude to review. -->

## BVHbrowser.lua
- **Kind:** tool
- **Purpose:** This file provides a BVH file browser tool for iGame3D, allowing users to list and navigate BVH folders, select and load BVH files, adjust animation speed, and convert selected BVH files into iGame3D animations. It sets up a FLTK UI window with directory browsing and conversion controls, and manages the BVH file list and interaction state during startup and runtime.
- **Depends on:** `Data/BVH/` path (`gBVHBrowserPath`), `loadBVHFile`, `goDirsUp`, `lfs.dir`, `lfs.attributes`, `bvhFileBrowser`, `gBVHBrowserFiles`, `gBVHBrowserPath`, `gBVHSpeedCoefficient`, `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gLabelTable`, `BVHBrowser`, `fltk`, `math.floor`, `io.open`, `gameroot`, `rootBone`, `poses`, `gFrameTime`, `ig3d_bone`, `IG3D_NAME`, `ig3d_GetObjectBoneInfo_2s_6f`, `createLocalMatricesForBVHFrame`, `getObjectInfo`, `loadLevel`
- **Provides:** `listBVHFiles`, `bvhRunAnimClicked`, `bvhspeedControlClicked`, `bvhbrowserControlDoubleClicked`, `bvhbrowserControlClicked`, `convertButtonClicked`, `BVHBrowser` (FLTK window), `bvhFileBrowser` (FLTK browser control)
- **Assets it needs:** none
- **Procedural:** yes - generates an iGame3D animation conversion text file by writing converted BVH data to a file handle using math.floor and BVH frame data.
- **Glossary:**
  - BVH - Binary Hierarchical Structure, a format used for motion capture data that this tool loads and converts.
  - `gBVHBrowserFiles` - global table storing the list of BVH files and directories found in the BVH folder.
  - `gBVHSpeedCoefficient` - global variable controlling the playback speed of loaded BVH animations.
  - `gBVHLastBrowserControlClick` - global timestamp tracking the last click on the BVH browser control.
  - `gBVHLastSelection` - global state tracking the last selection index in the BVH browser.
  - `loadBVHFile` - engine function used to load a selected BVH file into the engine.
  - `ig3d_GetObjectBoneInfo_2s_6f` - engine call used to retrieve bone information for BVH conversion.
  - `createLocalMatricesForBVHFrame` - engine function used to create local matrices for a BVH frame during conversion.
- **Keep / port / drop:** keep - a complete, reusable tool for BVH file management and conversion in iGame3D.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Sets the last BVH browser control click timestamp and last selection index at file startup, then defines the BVH file listing and interaction functions.
- **Uses:** `time()`, `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gameroot`, `Data/BVH/` path construction, `lfs.dir`, `lfs.attributes`, `bvhFileBrowser`, `gBVHBrowserFiles`, `goDirsUp`.
- **Reusable:** no

### listBVHFiles
- **Does:** Clears the BVH file list and directory browser, then scans the BVH folder for files and subdirectories, records each in `gBVHBrowserFiles` and adds it to the browser UI.
- **Uses:** `bvhFileBrowser:clear()`, `lfs.dir(gBVHBrowserPath)`, `lfs.attributes(f)`, `gBVHBrowserFiles`, `bvhFileBrowser:add`, `goDirsUp` (via path construction), `Data/BVH/` path (`gBVHBrowserPath`).
- **Reusable:** yes

### bvhRunAnimClicked
- **Does:** Returns early if the selected BVH entry is not a file, then loads the selected BVH file with `loadBVHFile` using the false flag.
- **Uses:** `bvhFileBrowser:value()`, `gBVHBrowserFiles`, `loadBVHFile`, `Data/BVH/` path (`gBVHBrowserPath`).
- **Reusable:** yes

### bvhspeedControlClicked
- **Does:** Sets the global BVH speed coefficient to the value of the clicked speed control multiplied by 0.01.
- **Uses:** `w:value()`, `gBVHSpeedCoefficient`.
- **Reusable:** yes

### bvhbrowserControlDoubleClicked
- **Does:** Returns early if the selected BVH entry is a directory, otherwise loads the selected BVH file via `bvhRunAnimClicked`. For directories, updates the BVH path to the selected directory or parent directory and re-lists the BVH files.
- **Uses:** `bvhFileBrowser:value()`, `gBVHBrowserFiles`, `gBVHBrowserPath`, `goDirsUp`, `listBVHFiles`, `bvhRunAnimClicked`, `Data/BVH/` path (`gBVHBrowserPath`).
- **Reusable:** yes

## Part 2 of 3

### bvhbrowserControlClicked
- **Does:** Checks whether the clicked control has a value of zero and returns early if so. Otherwise it resolves the selected BVH file from the global `gBVHBrowserFiles` table using the control's numeric value, records the current time, and updates the last-click timestamp and last-selection state based on whether the click is within the 0.4-second double-click window.
- **Uses:** `w:value()`, `time()`, `gBVHBrowserFiles`, `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `bvhbrowserControlDoubleClicked`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** Sets up the BVH Browser FLTK window and its controls, then runs the FLTK application.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `fltk:Fl_Value_Slider`, `gLabelTable`, `BVHBrowser`, `bvhFileBrowser`, `BVHBrowser:show()`, `Fl:run()`, plus the top-level `do` blocks that create the widgets and register their callbacks.
- **Reusable:** no

### convertButtonClicked
- **Does:** Converts a selected BVH file into an iGame3D animation by writing a conversion text file, then closes the file handle.
- **Uses:** `bvhFileBrowser:value()`, `gBVHBrowserFiles`, `gBVHBrowserPath`, `loadBVHFile`, `getObjectInfo`, `ig3d_GetObjectBoneInfo_2s_6f`, `createLocalMatricesForBVHFrame`, `math.floor`, `math.floor`, `io.open`, `gameroot`, `Data/BVH/Conversions/`, `fh:write`, `fh:close`, plus globals `rootBone`, `poses`, `gFrameTime`, `ig3d_bone`, `IG3D_NAME`.
- **Reusable:** no
- **Procedural:** yes
