<!-- Spark first-look of Data/Scripts/Convert/DSB_global.lua (model spark-x2.6-4b, 2026-11-12 14:52). DRAFT for Claude to review. -->

## DSB_global.lua
- **Kind:** converter
- **Purpose:** This file provides the global base configuration for the DSB conversion script, establishing stable base values, shared data tables, and the startup routine that initializes the engine for the conversion process. It is a reference for understanding how the DSB conversion system is structured and configured.
- **Depends on:** engine calls (`dsb_viewport`), globals set elsewhere in the DSB script set (e.g., `system_color`, `debug_color`, `scroll_color`, `magic_system_colors`, `magic_runes`, `power_multipliers`, `rune_costs`, `runes_per_set`, `rune_sets`, `g_disabled_runes`, `dsb_update_strings`, `lua_manifest`), and the `Data/` folder structure for the DSB conversion project.
- **Provides:** Global base configuration values, location constants, XP data tables, stat names, message IDs, special target constants, system/AI/missile/condition/graphics/game/Mparty flag constant sets, shared numeric constants, global color/rune/power multiplier/cost tables, disabled rune flags, an alias to a renamed function, the ordered file list parsed by the Lua manifest, and the global startup routine for the DSB conversion script.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` asset files are named or required by this file).
- **Procedural:** none (the file defines static configuration values, tables, and constants rather than generating assets from numbers or rules).
- **Glossary:**
  - DSB conversion script - the 2008 3D game engine scripted in Lua 5.1 used for the DSB project, with its own global configuration and startup routine.
  - `Data/` folder - the central folder in the iGame3D project where all project code, assets, and folders are organized.
  - `dofile(...)` - the iGame3D engine call used to load Lua code from a file path.
  - `loadLevel("Data/Levels/X")` - the iGame3D engine call used to switch the active game or demo level.
  - `IG3D_...` constants - iGame3D engine constants that name the property being read or set (e.g., `IG3D_POSITION` for position), not the kind of object.
  - `ig3d_...` first argument - the iGame3D engine call pattern where the first argument names the kind of object (e.g., `ig3d_object`).
  - `.fl` file - FLUID (FLTK UI designer) text file containing FLTK UI widgets and Lua code blocks for the iGame3D user interface.
  - `.emt` file - particle emitter settings file in the iGame3D project, containing `key=value` pairs for particle behavior.
- **Keep / port / drop:** keep - this file is a stable base configuration reference for the DSB conversion script, valuable for understanding and extending the project.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Defines global base configuration values, location constants, XP data tables, stat names, message IDs, and special target constants for the DSB conversion script.
- **Uses:** Globals only; no engine calls, file reads or writes, and no Data/ paths.
- **Reusable:** yes - the location constants, XP data tables, stat names and message ID definitions are stable base configuration that other scripts can reference.
- **Procedural:** no

## Part 2 of 5

### Top level
- **Does:** Defines the constant values used by the engine's system, AI, missile, condition, graphics, game and Mparty flag sets.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 5

### Top level
- **Does:** Defines shared numeric constants for mouse lock states, inventory slots, basic stats, classes, subskills, bars, and monster attack types, plus the initial value of the mouse throwing hand.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 5

### Top level
- **Does:** Defines global color, rune, power multiplier and cost tables, disabled rune flags, an alias to a renamed function, and the ordered list of files parsed by the Lua manifest.
- **Uses:** Globals (`system_color`, `debug_color`, `scroll_color`, `magic_system_colors`, `magic_runes`, `power_multipliers`, `rune_costs`, `runes_per_set`, `rune_sets`, `g_disabled_runes`, `dsb_update_strings`, `lua_manifest`). No engine calls, files or `Data/` paths.
- **Reusable:** yes - the color, rune and cost tables are generic data definitions reusable across scripts.
- **Procedural:** no

## Part 5 of 5

### Top level
- **Does:** Starts the global startup routine for the iGame3D engine.
- **Uses:** engine calls (`dsb_viewport`), no globals, files or `Data/` paths.
- **Reusable:** no
- **Procedural:** no
