<!-- Spark folder manifest of Data/Fluid/DungeonMapper (model spark-x2.6-4b, 2026-11-13 00:24). DRAFT. -->

# Data/Fluid/DungeonMapper
- **Role:** This folder holds the DungeonMapper tool, a FLTK-based user interface for editing and converting dungeon maps in iGame3D. It loads map data from DSB text files, lets users draw or erase map elements on a grid, and saves mapped maps back to DSB or mesh files.
- **Entry point:** DungeonMapper.lua
- **Files:** DungeonMapper.fl - FLUID twin of DungeonMapper.lua; DungeonMapper.lua - DungeonMapper tool UI and converter logic; DungeonMapper1226830pm.fl - FLUID twin of DungeonMapper1226830pm.lua; DungeonMapper1226830pm.lua - DSB-to-3D map converter driving the FLTK UI; DungeonMapperwModels.fl - FLUID twin of DungeonMapperwModels.lua
- **Shared with other folders:** Needs DSB conversion scripts, level folders via loadLevel, and Data folder paths. Others use its map editing and conversion tools.
- **Procedure candidates:** DSB text map data converted into a 3D dungeon grid and written back to DSB or mesh files.
- **Glossary:** DSB - text map data format read by the tool. FLTK - user interface framework used by the tool. DSB_Dungeons - Lua script loaded for map conversion. FLUID - FLTK UI designer text format for the .fl files.
- **Verdict:** keep - it contains the complete DungeonMapper tool and its converter, needed for dungeon map editing and conversion in the engine.
