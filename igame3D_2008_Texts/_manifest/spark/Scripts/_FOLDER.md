<!-- Spark folder manifest of Data/Scripts (model spark-x2.6-4b, 2026-11-12 18:23). DRAFT. -->

# Data/Scripts
- **Role:** This folder holds the foundational Lua libraries and core engine logic for the iGame3D engine, providing shared global state, constants, and reusable object, camera, light, and collision management helpers used across the game. It also contains a short test/example script for verifying basic object rotation and scene rendering behavior.
- **Entry point:** `core.lua`
- **Files:**
  - `core.lua - engine-core file providing foundational global state, constants, and core object/camera/light management functions for the iGame3D Lua engine`
  - `testrun.lua - short test/example script that configures object rotation, renders the current scene, and prints the selected object name`
- **Shared with other folders:** Needs `Data/` folder paths for scripts and socket libraries, globals set elsewhere such as `game_func`, `coll_o_m`, `coll_o_o`, `coll_o_p`, `coll_p_p`, `coll_p_m`, `gObjects`, `gNumObjects`, `gNativeOS`, `camera`, `edit_func`, `murgaLua`, and the `Data/Scripts/LuaSocket/` folder for socket library files. It provides core engine functions and globals to other scripts in the folder and the rest of the engine.
- **Procedure candidates:** None identified in the provided notes; the files define stored code and constants rather than producing procedural outputs from code.
- **Glossary:**
  - `gObjects - Global list of registered visual objects`
  - `gNumObjects - Global counter for the number of registered visual objects`
  - `gNativeOS - Global holding the host operating system name`
  - `game_func - Global function called when the game idle is triggered`
  - `edit_func - Global function called when the edit idle is triggered`
  - `IG3D_* - Engine property and constant identifiers used to read or set object, camera, and light properties`
  - `ig3d_object - The kind of object used for visual object creation and management`
  - `coll_o_m / coll_o_o / coll_o_p / coll_p_p / coll_p_m - Global collision dispatch functions for object and particle interactions`
- **Verdict:** keep - core.lua provides essential engine reference and reusable object management helpers, and testrun.lua is a useful focused example for new engine development.
