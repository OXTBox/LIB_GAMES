<!-- Spark folder manifest of Data/Scripts/Convert (model spark-x2.6-4b, 2026-11-12 15:01). DRAFT. -->

# Data/Scripts/Convert
- **Role:** This folder holds conversion utilities and level scripts that transform source assets into iGame3D engine code and level layouts. It includes converters for character, animation, mesh, dungeon, and FLUID-generated source workflows, plus the level script for the dungeonout dungeon.
- **Entry point:** unsure: no single entry point file is identified in the provided summaries that starts or loads the rest of the folder's scripts.
- **Files:**
  - AquariusCharactersPMB.lua - font conversion script that builds a global `chr` table of 8-row binary character bitmaps and glyph tables for the AquariusCharactersPMB conversion.
  - BVHtoWIFtoWTF.lua - conversion utilities that translate BVH animation data into WIF path tables and then into WTF animation files, supporting the truebonesmaster character workflow.
  - ConvermakeLevel1tomesh.lua - converter that converts the WTF mesh list into a level by creating, positioning, scaling and rotating each mesh object from the WTF catalog, then loading each mesh into the game.
  - DSB_Dungeons.lua - conversion utility for the DSB dungeon system, building formatted data representations of spawn, champion, text-to-map, and spawn-in-pack tables, generating Lua output files for the Dungeons WTF folder, and overriding DSB spawn and champion functions to collect arguments into shared tables.
  - DSB_global.lua - global base configuration for the DSB conversion script, establishing stable base values, shared data tables, and the startup routine that initializes the engine for the conversion process.
  - cxxToiGame3DLua.lua - converter that converts FLUID-generated C++ source files into Lua scripts suitable for the iGame3D engine, routing file loads through a custom conversion dispatcher so generated code is translated on the fly.
  - dungeonout.lua - level script for the dungeonout dungeon level, defining champion and door spawn data, door button triggers, and a large set of spawn entries and associated event variables for the dungeon layout.
- **Shared with other folders:** The scripts reference engine folders such as Data/WTF/Dungeons, Data/Levels, and Data/WTF for mesh, animation, and level assets, and use engine globals and path conventions (e.g., `gameroot.."Data/<Folder>/<file>"`, `dofile(...)`, `loadLevel("Data/Levels/X")`) to load or reference assets.
- **Procedure candidates:** AquariusCharactersPMB.lua generates character glyph bitmaps and glyph tables from character code ranges and binary patterns; BVHtoWIFtoWTF.lua generates Lua path table files, sorted BVH/WIF conversion table files, and WIF/WTF animation files from scanned BVH/WIF folder contents and numeric frame data; ConvermakeLevel1tomesh.lua generates mesh objects, positions, rotations, scales, and visibility states from the WTF catalog list; DSB_Dungeons.lua generates a Lua output file under Data/WTF/Dungeons from spawn data via io.open and f:write, and generates formatted string representations of structured data tables; cxxToiGame3DLua.lua generates .lua files from FLUID .cxx and .fl source files by parsing source, converting window code into Lua, and writing converted output; dungeonout.lua generates the dungeonout level layout by constructing spawn entries, object placements, and associated event variable configurations from numeric coordinates, object types, and fixed rules.
- **Glossary:**
  - iGame3D - the 2008 3D game engine scripted in Lua 5.1 using murgaLua, FLTK, and LuaFileSystem.
  - WTF - 3D models and text format "iGame3D Mdl" assets used by converters and level scripts.
  - BVH - motion capture data used as input for animation conversion utilities.
  - WIF - intermediate animation path table format used in the BVHtoWIFtoWTF conversion workflow.
  - FLUID - FLTK user interface designer whose generated C++ source is converted into Lua scripts.
  - Level - a game or demo folder under Data/Levels, started by load script.lua.
  - Emitters - .emt particle settings referenced by the engine's particle system.
  - Spawn - object placement entries used to build level layouts from numeric coordinates and object types.
- **Verdict:** keep - the folder contains core conversion and level-building tools that directly produce engine-ready assets and level layouts, and its scripts rely on the engine's standard folders and conventions, so it is reusable in a new engine.
