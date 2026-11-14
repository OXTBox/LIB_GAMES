<!-- Spark folder manifest of Data/Fluid/PBMMapper (model spark-x2.6-4b, 2026-11-13 01:44). DRAFT. -->

# Data/Fluid/PBMMapper
- **Role:** A FLTK-based tool for editing and converting PBM/DSB map data into iGame3D mesh and level files. It loads map files, lets the user draw quads and walls on a grid, saves edited maps back to DSB or PBM formats, and converts mapped geometry into mesh objects for the current level.
- **Entry point:** PBMMapper.lua
- **Files:** PBMMapper.fl - FLUID twin of PBMMapper.lua; PBMMapper.lua - tool for PBM/DSB map editing and mesh conversion; pbmimages.fl - FLUID twin of pbmimages.lua
- **Shared with other folders:** Depends on DSB Convert scripts and level path construction; provides PBM/DSB map editing and mesh conversion tools.
- **Procedure candidates:** Load map files and draw quads/walls on a grid; save edited maps to DSB or PBM formats; convert mapped geometry into mesh objects for the current level.
- **Glossary:** PBMMapper - FLTK-based tool for editing and converting PBM/DSB map data; DSB - map data format saved by the tool; mesh - converted geometry objects for the current level; FLTK - user interface framework used by the tool; iGame3D - 3D game engine scripted in Lua 5.1
- **Verdict:** keep - It is a self-contained map editing and mesh conversion tool with clear file roles and reusable conversion procedures for the engine.
