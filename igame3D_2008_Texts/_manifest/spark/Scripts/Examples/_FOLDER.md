<!-- Spark folder manifest of Data/Scripts/Examples (model spark-x2.6-4b, 2026-11-12 15:09). DRAFT. -->

# Data/Scripts/Examples
- **Role:** This folder holds example and utility scripts for the iGame3D engine, including BVH parsing and conversion tools, TrueBones skeleton construction examples, character utilities, and FLTK menu examples. It serves as a reusable reference for new engine scripts and demonstrates BVH-to-mesh conversion, skeleton generation, and UI interaction.
- **Entry point:** none
- **Files:**
  - PlayTBinEditMode.lua - Example script demonstrating BVH parsing and browsing for TrueBones BVH data, setting engine mode to 2, loading a TrueBones BVH file, and running a test loop to display and edit BVH frames through the FLTK UI.
  - animazoobvh_parser.lua - Converter that parses BVH motion capture files, builds per-frame local matrices and neutral poses, and writes a new mesh object in place of the original BVH file.
  - bvh_parser.lua - Lua utility for parsing and processing BVH files, computing local transformation matrices for frames, building neutral poses and mesh bones, and saving the resulting mesh to the character BVH path.
  - character_utilities.lua - Library providing reusable helper functions for attaching a gun to a target object and configuring a character's right-hand gun focus pose.
  - example_menu.lua - Menu example defining a callback function and building a FLTK window, menu bar, and menu items with shortcuts, then displaying the window to demonstrate menu interaction.
  - truebonesbuilder1.lua - Example script defining two TrueBones construction functions that build tagged mesh vertices and link bones into torso, left arm, right arm, left leg, and right leg hierarchies for a TrueBones-style skeleton.
  - truebonesbvh_parser.lua - Lua converter that reads BVH motion capture files and builds a 3D character skeleton from bone and frame data, computing per-frame local matrices, generating mesh bones, and writing a skeleton model file.
  - uv_fun.lua - Small example script configuring a square scene object with position, rotation, and texture, defining an ocean animation function and a wrapper function that invokes the ocean animation before running the previously stored game function.
- **Shared with other folders:** The BVH-related scripts depend on `Data/` folder paths, engine calls, and globals set elsewhere (e.g., `gCurFrame`, `gStart`, `edit_func`, `bvhmarker`, `gFirstFrame`, `gYMod`, `gBoneStart`, `gFrameTime`, `gTime`, `game_func`, `oldGameFunc`, `rootBone`). The Fluid BVHbrowser FLTK UI is referenced by PlayTBinEditMode.lua. Others take helper functions and globals from this folder where applicable.
- **Procedure candidates:** BVH-to-mesh conversion pipelines (animazoobvh_parser.lua, bvh_parser.lua, truebonesbvh_parser.lua) that generate mesh assets, local transformation matrices, neutral poses, and skeleton model files from parsed BVH data; TrueBones skeleton construction (truebonesbuilder1.lua) that generates mesh vertices and bone hierarchies from rules; ocean animation and scene/material configuration (uv_fun.lua) that defines animation functions and updates scene object and material state.
- **Glossary:**
  - BVH - Binary Hierarchical Skeleton format used for motion capture data in iGame3D.
  - BVH frame - a unit of motion data in a BVH file containing channel offsets, neutral coordinates, and child frames.
  - local transformation matrix - a matrix computed for a BVH frame to represent its local position and rotation offsets.
  - neutral pose - the zeroed rotation and position state of a bone, used as a base for mesh bone creation.
  - mesh bone - a bone created from a vertex and parent name to represent a mesh vertex in the BVH output.
  - ig3d_SetMode_i - Engine call that sets the engine's current mode.
  - loadBVHFile - Engine call that loads a BVH file into the engine.
  - createLocalMatricesForBVHFrame - Engine call that creates local transformation matrices for a BVH frame.
  - ig3d_bone - Engine object kind used to reference character bones.
  - ig3d_object - Engine object kind used to reference character objects.
- **Verdict:** keep - The folder contains reusable, self-contained examples and tools for BVH parsing/conversion, TrueBones construction, character utilities, and FLTK UI, with clear procedural logic that can be reused in a new engine.
