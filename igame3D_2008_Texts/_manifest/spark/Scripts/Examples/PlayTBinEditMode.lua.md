<!-- Spark first-look of Data/Scripts/Examples/PlayTBinEditMode.lua (model spark-x2.6-4b, 2026-11-12 15:01). DRAFT for Claude to review. -->

## PlayTBinEditMode.lua
- **Kind:** test/example
- **Purpose:** This file is an example script for the iGame3D engine that demonstrates BVH parsing and browsing for TrueBones BVH data. It sets the engine mode to 2, loads the TrueBones BVH file, and runs a test loop to display and edit BVH frames through the FLTK UI.
- **Depends on:** `Data/Scripts/Examples/truebonesbvh_parser.lua`, `Data/Fluid/BVHbrowser/BVHbrowser.fl`, `Data/BVH/TrueBones/A/AddonPak2.BVH`, engine calls (`ig3d_SetMode_i`, `loadBVHFile`), globals set elsewhere (`gCurFrame`, `gStart`, `edit_func`), and the loaded scripts' referenced `Data/` paths.
- **Provides:** `truebonesbvhtestloop`, a procedural function that advances the BVH test loop by a passed time, computes the current frame, extracts the frame's pose string, creates local matrices for the BVH frame, optionally applies the neutral pose, and updates the FLTK UI.
- **Assets it needs:** `Data/BVH/TrueBones/A/AddonPak2.BVH` (BVH file loaded by the script).
- **Procedural:** yes — generates the test loop's frame matrices and pose updates from the passed time and accumulated loop state, rather than loading a pre-existing asset.
- **Glossary:**
  - `BVH` - A binary format storing motion capture pose data for 3D objects.
  - `ig3d_SetMode_i` - An engine call that sets the engine's current mode.
  - `loadBVHFile` - An engine call that loads a BVH file into the engine.
  - `gCurFrame` - A global holding the current BVH frame index.
  - `edit_func` - A global function used to edit BVH frames in the UI.
  - `createLocalMatricesForBVHFrame` - An engine call that creates local transformation matrices for a BVH frame.
- **Keep / port / drop:** keep — a reusable example demonstrating BVH parsing and UI interaction for the iGame3D engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads the BVH parser and FLUID BVH browser scripts, sets the engine mode to 2, loads the TrueBones BVH file, sets the current frame to 1, and initializes the test loop start value.
- **Uses:** `dofile` with `Data/Scripts/Examples/truebonesbvh_parser.lua` and `Data/Fluid/BVHbrowser/BVHbrowser.fl` paths, `ig3d_SetMode_i`, `loadBVHFile` with `Data/BVH/TrueBones/A/AddonPak2.BVH`, globals `gCurFrame`, `gStart`, and `edit_func`.

### truebonesbvhtestloop
- **Does:** Advances the test loop by the passed time, computes the current frame from the accumulated time, resets and restarts the frame if it exceeds the number of poses, extracts the current frame's pose string, creates local matrices for the BVH frame, optionally applies the neutral pose when the minus key is pressed, and updates the FLTK UI.
- **Uses:** Engine calls `passed`, `createLocalMatricesForBVHFrame`, `click`; globals `gStart`, `gFrameTime`, `poses`, `rootBone`, `edit_func`; files referenced via `Data/` paths used by the loaded scripts.
- **Reusable:** no
- **Procedural:** yes
