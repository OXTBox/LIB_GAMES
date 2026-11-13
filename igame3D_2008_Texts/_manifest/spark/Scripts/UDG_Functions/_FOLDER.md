<!-- Spark folder manifest of Data/Scripts/UDG_Functions (model spark-x2.6-4b, 2026-11-12 17:46). DRAFT. -->

# Data/Scripts/UDG_Functions
- **Role:** This folder holds the UDG-specific Lua libraries and level scripts that implement the game logic, AI, editor helpers, sound, text box, lighting, and utility routines for the iGame3D engine. It provides reusable functions for gameplay, scene setup, and level configuration, with the engine-core initialization file serving as the entry point for starting a UDG game session.
- **Entry point:** UDG_Init.lua
- **Files:**
  - UDG_AI.lua - library implementing UDG AI logic including scene LOD and sense management, zombie near-player and sight handling, object task execution, floor collision checks, and helper functions for zombie distance and near-player state marking.
  - UDG_Editor.lua - tool providing editor helper functions for creating game objects and handling editor key input, including a door creation routine and empty placeholder functions for scenery, woman, and man object creation, plus a key handler routing pressed keys to matching creation functions.
  - UDG_Game.lua - level-script containing core UDG game logic including the main game loop, target click selection handling, a helper finding the highest-ranked zombie, and a global flag controlling velocity clamping behavior.
  - UDG_Gamemine.lua - library providing UDG-specific game logic, target click handling, and the main UDG game loop, with no setup or widget code at the top level and only a global flag assignment outside functions.
  - UDG_Init.lua - engine-core file initializing the UDG game engine by setting global game state variables, preloading engine and RTS helper scripts, loading UDG entity scripts, and running initialization steps that place objects, create safe places, and check game end conditions.
  - UDG_Lights.lua - library providing reusable lighting configuration routines for credits and work scenes, a scene-level lighting setup for Level 1, and a dedicated lighting routine for the Snipersalle scene, configuring scene properties and light parameters via engine calls.
  - UDG_Sounds.lua - library providing sound management functions for zombie idle, footstep, hit, and eat sound playback, voice emitter configuration, and sound emitter count setup, with only function definitions and a global link assignment and no top-level executable code.
  - UDG_Textboxes.lua - library configuring global text box font lists, positions, sizes, and colors, creating text boxes with their properties, and defining the showLevelLoading function to update the first text box during level loading and render the scene.
  - UDG_Utilities.lua - library containing utility functions for random object and safe-place placement helpers, level text and FPS display utilities, and level listing and A* scheduling checks, supporting UDG level setup, rendering, and gameplay logic.
- **Shared with other folders:** This folder shares its UDG entity scripts with the UDG_Entities sub-folder and depends on engine-level calls and globals such as gObjects, gameroot, and the iGame3D engine APIs for object, scene, camera, light, bone, material, particle, and text box information handling.
- **Procedure candidates:** UDG_Init.lua runs procedural initialization steps including random object placement, safe place creation, and game end condition checks; UDG_Sounds.lua contains the procedural function `udg_soundEmittersHack` that generates sound emitter names, positions, and empty samples based on object count and sound emitter count rules; UDG_Utilities.lua contains procedural functions `udg_create_safe_places_randomly` that generate safe place entries from level grid coordinates and `udg_listLevels` that generates a level listing by scanning folder contents and extracting names from file names.
- **Glossary:**
  - UDG AI logic - scene LOD and sense management, zombie near-player and sight handling, object task execution, and floor collision checks implemented in UDG_AI.lua.
  - Safe places - generated game state entries for safe locations, created procedurally from level grid coordinates in UDG_Utilities.lua.
  - Sound emitter count - the number of sound emitters configured for UDG sound playback, managed in UDG_Sounds.lua.
  - Level listing - a generated list of UDG levels, produced by scanning folder contents and extracting names from file names in UDG_Utilities.lua.
  - Game loop - the main UDG game logic loop, defined in UDG_Game.lua and UDG_Gamemine.lua.
  - Engine-core initialization - the UDG_Init.lua entry point that sets global game state, preloads scripts, loads entity scripts, and runs initialization steps.
  - Editor key input - key handling in UDG_Editor.lua that routes pressed keys to matching object creation functions.
- **Verdict:** keep - the folder contains the core UDG game logic, AI, editor, sound, text box, lighting, and utility libraries needed to run the UDG game in the iGame3D engine, with clear entry point and reusable procedural functions that align with the engine's structure.
