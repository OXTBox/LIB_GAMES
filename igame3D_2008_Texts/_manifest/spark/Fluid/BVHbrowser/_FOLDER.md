<!-- Spark folder manifest of Data/Fluid/BVHbrowser (model spark-x2.6-4b, 2026-11-12 19:39). DRAFT. -->

# Data/Fluid/BVHbrowser
- **Role:** This folder holds the BVH browser tool for iGame3D, a FLTK UI for browsing BVH motion capture files, running BVH animations, adjusting playback speed, and converting BVH files into conversion text files. The folder provides a reusable reference for BVH file handling and UI interaction in the engine.
- **Entry point:** BVHbrowser.lua
- **Files:**
  - BVHbrowser.fl - FLTK UI dialog defining the BVH browser window, widgets, click and double-click handlers, and file list management.
  - BVHbrowser.lua - BVH file browser tool that sets up the FLTK UI, manages BVH file lists and interaction state, and generates iGame3D animation conversion text files.
- **Shared with other folders:** Needs `Data/BVH/` paths, `loadBVHFile`, `goDirsUp`, `lfs.dir`, `lfs.attributes`, `gBVHBrowserFiles`, `gBVHBrowserPath`, `gBVHSpeedCoefficient`, `gBVHLastBrowserControlClick`, `gBVHLastSelection`, `gLabelTable`, `bvhFileBrowser`, `BVHBrowser`, `fltk`, `math.floor`, `io.open`, `gameroot`, `rootBone`, `poses`, `gFrameTime`, `ig3d_bone`, `IG3D_NAME`, `ig3d_GetObjectBoneInfo_2s_6f`, `createLocalMatricesForBVHFrame`, `getObjectInfo`, `loadLevel`, and `Data/BVH/Conversions/` for output files. Others take the generated conversion text files and BVH file data from this folder.
- **Procedure candidates:** Generating conversion text files with frame and bone matrix data from a selected BVH file, writing converted BVH data to disk using `io.open`, and generating iGame3D animation conversion text files by writing converted BVH data to a file handle using `math.floor` and BVH frame data.
- **Glossary:**
  - BVH - Binary Hierarchical Structure, a format used for motion capture data that the tool loads and converts.
  - BVHBrowser - the FLTK UI window for browsing and manipulating BVH files.
  - `gBVHBrowserFiles` - global table storing the list of BVH files and directories found in the BVH folder.
  - `gBVHSpeedCoefficient` - global variable controlling the playback speed of loaded BVH animations.
  - `loadBVHFile` - engine function used to load a selected BVH file into the engine.
  - `createLocalMatricesForBVHFrame` - engine function used to create local matrices for a BVH frame during conversion.
  - `ig3d_GetObjectBoneInfo_2s_6f` - engine call used to retrieve bone information for BVH conversion.
  - `gBVHBrowserPath` - global variable holding the current BVH file path used for loading files.
  - `gBVHLastSelection` - global state tracking the last selection index in the BVH browser.
  - `gBVHLastBrowserControlClick` - global timestamp tracking the last click on the BVH browser control.
- **Verdict:** keep - the folder contains a complete, reusable BVH file handling and UI tool with clear entry point, shared dependencies, and existing procedural generation for conversion text files, matching the keep criteria for porting to a new engine.
