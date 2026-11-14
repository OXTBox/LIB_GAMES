<!-- Spark first-look of Data/Fluid/BVHbrowser/BVHbrowser.fl (model spark-x2.6-4b, 2026-11-12 19:37). DRAFT for Claude to review. -->

## BVHbrowser.fl
- **Kind:** ui-dialog
- **Purpose:** This file defines the FLTK UI for the BVH browser, a tool for browsing BVH files, running BVH animations, adjusting BVH speed, and converting BVH files into conversion text files. It sets up the window and its widgets, wires click and double-click handlers, and manages the list of available BVH files and selected entries.
- **Depends on:** `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gBVHBrowserPath`, `gBVHBrowserFiles`, `bvhFileBrowser`, `goDirsUp`, `loadBVHFile`, `createLocalMatricesForBVHFrame`, `getObjectInfo`, `IG3D_NAME`, `gFrameTime`, `ig3d_bone`, `getBoneInfo`, `ig3d_GetObjectBoneInfo_2s_6f`, `io.open`, `gameroot`, `Data/BVH/Conversions/`, `BVHBrowser`
- **Provides:** `make_window`, `listBVHFiles`, `bvhRunAnimClicked`, `bvhspeedControlClicked`, `bvhbrowserControlClicked`, `bvhbrowserControlDoubleClicked`, `convertButtonClicked`, `BVHBrowser`
- **Assets it needs:** none
- **Procedural:** generates a conversion text file with frame and bone matrix data from a selected BVH file, writing the generated content to disk.
- **Glossary:**
  - BVH - a 3D motion capture file format used for animation data.
  - BVHBrowser - the FLTK UI window for browsing and manipulating BVH files.
  - `gBVHBrowserPath` - global variable holding the current BVH file path used for loading files.
  - `gBVHBrowserFiles` - global variable holding the list of available BVH files and directories.
  - `loadBVHFile` - engine call used to load a selected BVH file.
  - `getObjectInfo` - engine call used to read object property values.
  - `IG3D_NAME` - engine constant naming the object name property being read or set.
  - `createLocalMatricesForBVHFrame` - function used to generate frame matrix data for BVH conversion.
- **Keep / port / drop:** keep - a complete, reusable reference for BVH file handling and UI interaction in the engine.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the FLTK window setup for the BVH browser, including initial global state for the last click time, last selection, BVH path, and file list.
- **Uses:** `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gBVHBrowserPath`, `gBVHBrowserFiles`, `gameroot`, `lfs.dir`, `lfs.attributes`, `bvhFileBrowser`, `goDirsUp`
- **Reusable:** no

### make_window
- **Does:** Opens the BVH browser window, initializing the global state variables used by the rest of the file.
- **Uses:** `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gBVHBrowserPath`, `gBVHBrowserFiles`
- **Reusable:** no

### listBVHFiles
- **Does:** Clears the file browser and directory list, then scans the BVH folder to populate the list of files and directories.
- **Uses:** `lfs.dir`, `lfs.attributes`, `string.sub`, `bvhFileBrowser:clear`, `bvhFileBrowser:add`, `gBVHBrowserPath`, `gBVHBrowserFiles`
- **Reusable:** yes

### bvhRunAnimClicked
- **Does:** Returns early if the selected BVH entry is not a file, then loads the selected BVH file with animation conversion disabled.
- **Uses:** `bvhFileBrowser:value`, `gBVHBrowserFiles`, `loadBVHFile`, `gBVHBrowserPath`
- **Reusable:** no

### bvhspeedControlClicked
- **Does:** Updates the BVH speed coefficient from the speed control widget value.
- **Uses:** `w:value`, `gBVHSpeedCoefficient`
- **Reusable:** no

### bvhbrowserControlDoubleClicked
- **Does:** Handles double-clicking the BVH browser control: navigates into a directory or loads the selected file, then refreshes the file list if navigating.
- **Uses:** `bvhFileBrowser:value`, `gBVHBrowserFiles`, `goDirsUp`, `gBVHBrowserPath`, `listBVHFiles`, `bvhRunAnimClicked`
- **Reusable:** no

## Part 2 of 3

### Top level
- **Does:** Defines the FLUID UI file structure for the BVH browser, including the `code` block containing the two click handler functions and the `selected` callback block.
- **Uses:** nothing
- **Reusable:** no

### bvhbrowserControlClicked
- **Does:** Handles control button clicks in the BVH browser, manages double-click detection via timing, and updates the last selection state.
- **Uses:** `gBVHBrowserFiles`, `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `time()`, `bvhbrowserControlDoubleClicked(w)`, `w:value()`, `tonumber()`
- **Reusable:** no

### convertButtonClicked
- **Does:** Loads a selected BVH file, generates a conversion text file with frame and bone matrix data, and writes the conversion output to disk.
- **Uses:** `bvhFileBrowser`, `gBVHBrowserFiles`, `gBVHBrowserPath`, `loadBVHFile`, `getObjectInfo`, `IG3D_NAME`, `gFrameTime`, `math.floor`, `string.gmatch`, `createLocalMatricesForBVHFrame`, `get`, `ig3d_bone`, `getBoneInfo`, `IG3D_NAME`, `ig3d_GetObjectBoneInfo_2s_6f`, `objname`, `a`, `io.open`, `gameroot`, `Data/BVH/Conversions/`, `fh:write`, `fh:close`
- **Reusable:** no

### selected
- **Does:** Defines the selected callback block for the BVH browser UI.
- **Uses:** nothing
- **Reusable:** no

## Part 3 of 3

### Top level
- **Does:** Defines the BVHBrowser window and its widgets, including the browser control, animation run button, speed slider, and convert button.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Button`, `Fl_Value_Slider` widget definitions; `BVHBrowser:show()`; `listBVHFiles()`; `bvhbrowserControlClicked`, `bvhRunAnimClicked`, `bvhspeedControlClicked`, `convertButtonClicked` callbacks.
- **Reusable:** no

### BVHBrowser
- **Does:** Shows the BVHBrowser window and lists the available BVH files via the browser control callback.
- **Uses:** `BVHBrowser:show()`; `listBVHFiles()`.
- **Reusable:** no
