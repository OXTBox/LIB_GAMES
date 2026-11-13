<!-- Spark first-look of Data/Scripts/Convert/DSB_Dungeons.lua (model spark-x2.6-4b, 2026-11-12 14:50). DRAFT for Claude to review. -->

## DSB_Dungeons.lua
- **Kind:** converter
- **Purpose:** This file is a conversion utility for the DSB dungeon system, building formatted data representations of spawn, champion, text-to-map, and spawn-in-pack tables, generating Lua output files for the Dungeons WTF folder, and overriding DSB spawn and champion functions to collect arguments into shared tables. It also defines empty stub functions for dungeon-specific actions and commented-out file loads.
- **Depends on:** `Data/` folder paths (specifically `Data/WTF/Dungeons` for generated output), globals such as `gMapFile`, `fileShortNameFromPath`, `gameroot`, `currentLevel`, `DungeonMapperWindow`, `dsbspawn`, `dsbaddchampion`, `spawninpack`, `dsbtext2map`, `listexvars`, `listChampions`, `listspawninpack`, `listdspspawn`, `listSpawnXY`, `spawnedgrid`, `parseText2Map`, `dsbtext2mapButtonChanges`, `GridSize`, `ColorSpawnButtons`, `spawnXY`, `spawnindex`, `spawntext`, `spawngrid`, `dsbpsawn`, `dsbtext2mapButtonChanges`, and `loadstring`; also relies on `dofile` for loading referenced scripts.
- **Provides:** Functions for formatted data serialization (`listexvars`, `listspawninpack`, `listChampions`, `listdsbtext2map`, `listdspspawn`, `spawnedgrid`, `parseText2Map`, `BSDDungeonSpawnsOut`, `listSpawnXY`, `ButtonSpawnXY`), overrides for DSB spawn and champion functions (`dsb_spawn`, `dsb_add_champion`, `spawn_in_pack`, `dsb_text2map`), and empty stub functions (`dungeon_translate`, `dsb_spawnburst_begin`, `dsb_spawnburst_end`, `dsb_set_maxhp`, `dsb_set_gameflag`, `dsb_champion_toparty`, `dsb_party_place`, `dsb_image2map`, `dsb_level_wallset`, `dsb_set_exviewinst`, `dsb_set_hp`, `dsb_alt_wallset`, `dsb_disable`, `spawn_pit`).
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named; it only generates a Lua file under `Data/WTF/Dungeons`).
- **Procedural:** yes - generates a Lua output file (`<short map name>_BSDout.lua`) under `Data/WTF/Dungeons` from spawn data via `io.open` and `f:write`, and generates formatted string representations of structured data tables (spawn, champion, text-to-map, spawn-in-pack) from existing tables.
- **Glossary:**
  - `dsbtext2map` - DSB text-to-map data table holding map text, coordinates, and button actions.
  - `dsbspawn` - DSB spawn data table collecting spawn arguments for the DSB dungeon system.
  - `dsbaddchampion` - DSB champion data table collecting champion arguments for the DSB dungeon system.
  - `spawninpack` - DSB spawn-in-pack data table collecting spawn-in-pack arguments for the DSB dungeon system.
  - `BSDDungeonSpawnsOut` - function that writes formatted spawn data to a generated Lua file under the Dungeons WTF folder.
  - `parseText2Map` - function that parses a text map into coordinate lists, wall metadata, and button actions.
  - `listdspspawn` - function that builds a formatted text representation of the `dsbspawn` table.
  - `dofile` - engine call used to load Lua scripts from file paths.
- **Keep / port / drop:** keep - serves as a reusable reference for DSB dungeon data serialization and conversion logic.

---

# Part notes

## Part 1 of 9

### Top level
- **Does:** Defines UI-related variables, color and direction constants, and builds a base string plus a compiled Lua string for the dsbtext2Map table.
- **Uses:** Globals such as `CBI`, `CBO`, `math.random`; no `Data/` paths or engine calls.
- **Reusable:** no
- **Procedural:** yes - generates the `bsdtext2MapBaseString` and `newbsdtext2Map` values from looped string construction.

## Part 2 of 9

### Top level
- **Does:** No functions or top-level code are present in this file section.
- **Uses:** nothing
- **Reusable:** no

### listexvars
- **Does:** Recursively walks the nested `exvar` table, formats its values into a readable string, and returns the formatted string when the target index matches, or accumulates all formatted entries when the target is `"*"`.
- **Uses:** globals (`exvar`, `Q`), no engine calls, no `Data/` paths.
- **Reusable:** yes - pure string and table traversal logic that can be reused for similar variable formatting tasks.
- **Procedural:** no

## Part 3 of 9

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### listspawninpack
- **Does:** Builds a formatted string representation of spawn-in-pack data, filtering entries by a matching check variable, and returns only the filtered output if any matches exist.
- **Uses:** globals `spawninpack`, `listexvars`, `Q`, `echck`, `which`, local variables `s`, `sb`, `ws`, `sout`; no `Data/` paths or engine calls.
- **Reusable:** yes - the string formatting logic for structured data tables is reusable for similar spawn/pack data serialization tasks.

### listChampions
- **Does:** Builds a formatted string representation of the dsbaddchampion data table, applying quote wrapping to string values, and returns the full formatted output.
- **Uses:** globals `dsbaddchampion`, `Q`, local variables `s`, `sout`; no `Data/` paths or engine calls.
- **Reusable:** yes - the string formatting logic for structured data tables is reusable for similar champion data serialization tasks.

## Part 4 of 9

### Top level
- **Does:** No top-level code outside the three defined functions; the file contains only the function definitions listed.
- **Uses:** nothing
- **Reusable:** no

### listdsbtext2map
- **Does:** Builds a formatted text representation of the dsbtext2map table, optionally returning only the section matching the given index `which`. It processes each row of the table, converting string values with surrounding quotes and nested tables into comma-separated text, then assembles the full output.
- **Uses:** globals `dsbtext2map`, `Q`; no engine calls, files, or Data/ paths.
- **Reusable:** yes - pure string and table data formatting logic.

### listdspspawn
- **Does:** Builds a formatted text representation of the dsbspawn table, appending optional spawn pack details and emission variable mappings for each row. It returns nil if the `dsbpsawn` global is not set, and only includes extra details when the corresponding variables exist.
- **Uses:** globals `dsbspawn`, `dsbpsawn`, `listChampions`, `listspawninpack`, `listexvars`, `Q`; no engine calls, files, or Data/ paths.
- **Reusable:** yes - pure string and table data formatting logic.

### BSDDungeonSpawnsOut
- **Does:** Writes the output of `listdspspawn` to a generated Lua file under the Data/WTF/Dungeons folder, named using the current map file's short name. It returns nil if the output is nil or the file cannot be opened for writing.
- **Uses:** globals `gMapFile`, `fileShortNameFromPath`, `gameroot`; writes to a generated path `gameroot.."Data/WTF/Dungeons/<short map name>_BSDout.lua"` via `io.open` and `f:write`; no engine calls.
- **Reusable:** no - generates a file from existing data, tied to the current map context.
- **Procedural:** yes - generates a Lua output file from existing spawn data.

## Part 5 of 9

### Top level
- **Does:** No top-level code outside the two defined functions.
- **Uses:** nothing
- **Reusable:** no

### listSpawnXY
- **Does:** Builds a Lua string describing spawn points from the `dsbspawn` table, executes each spawn definition via `loadstring`, and collects spawn data into `listSpawnxy`, `spawnindex`, and `XYSpawned` when the spawn level matches the current level.
- **Uses:** globals `dsbspawn`, `Q`, `currentLevel`, `loadstring`, `table.insert`; no `Data/` paths or engine object calls.
- **Reusable:** yes - pure data processing and string generation from existing table data.

### ButtonSpawnXY
- **Does:** Calls `listSpawnXY`, filters spawn points to those matching the current level, builds a button definition string, optionally executes the button color action via `loadstring` and redraws the DungeonMapperWindow, and returns the generated button string.
- **Uses:** globals `listSpawnXY`, `currentLevel`, `DungeonMapperWindow`, `ColorSpawnButtons`, `table.insert`; no `Data/` paths or engine object calls.
- **Reusable:** yes - data filtering and string generation from spawn data, with changes needed for the DungeonMapperWindow dependency.

## Part 6 of 9

### Top level
- **Does:** none
- **Uses:** nothing

### spawnedgrid
- **Does:** Builds a grid string from spawn positions, then returns the grid text for use by the level system. It reads spawn position data, fills a 52x52 grid, and collects non-table values into a text string.
- **Uses:** `listdspspawn()`, `listSpawnXY()`, `loadstring()`, `table.insert()`, `tonumber()`, `pairs()`, `spawnXY`, `spawnindex`, `spawntext`, `spawngrid`
- **Reusable:** no
- **Procedural:** yes

## Part 7 of 9

### Top level
- **Does:** No top-level code outside `parseText2Map`; the file begins directly with the function definition.
- **Uses:** nothing
- **Reusable:** no

### parseText2Map
- **Does:** Parses a text map into coordinate lists, wall metadata, and button actions, then triggers dungeon map button color changes for each valid coordinate.
- **Uses:** globals `dsbtext2map`, `dsbtext2mapButtonChanges`, `DungeonMapperWindow`, `GridSize`; no engine calls or `Data/` paths.
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 9

### Top level
- **Does:** Contains no setup, global definitions, or widget definitions; only the listed function stubs and overrides follow.
- **Uses:** nothing
- **Reusable:** no

### dsb_spawn
- **Does:** Overrides the DSB spawn function to collect spawn arguments into a shared `dsbspawn` table and return the first argument.
- **Uses:** globals `dsbspawn`, `arg`
- **Reusable:** yes

### dsb_add_champion
- **Does:** Overrides the DSB add champion function to collect champion arguments into a shared `dsbaddchampion` table and return a concatenated name string.
- **Uses:** globals `dsbaddchampion`, `arg`
- **Reusable:** yes

### spawn_in_pack
- **Does:** Overrides the spawn in pack function to collect pack arguments into a shared `spawninpack` table, records the length of `dsbspawn` as the first element, and returns the first argument.
- **Uses:** globals `spawninpack`, `dsbspawn`, `arg`
- **Reusable:** yes

### dsb_text2map
- **Does:** Overrides the DSB text to map function to collect text arguments into a shared `dsbtext2map` table and return the length of that table.
- **Uses:** globals `dsbtext2map`, `arg`
- **Reusable:** yes

### dungeon_translate
- **Does:** Defines an empty `dungeon_translate` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_spawnburst_begin
- **Does:** Defines an empty `dsb_spawnburst_begin` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_spawnburst_end
- **Does:** Defines an empty `dsb_spawnburst_end` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_set_maxhp
- **Does:** Defines an empty `dsb_set_maxhp` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_set_gameflag
- **Does:** Defines an empty `dsb_set_gameflag` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_champion_toparty
- **Does:** Defines an empty `dsb_champion_toparty` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_party_place
- **Does:** Defines an empty `dsb_party_place` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_image2map
- **Does:** Defines an empty `dsb_image2map` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_level_wallset
- **Does:** Defines an empty `dsb_level_wallset` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

### dsb_set_exviewinst
- **Does:** Defines an empty `dsb_set_exviewinst` function with no implementation.
- **Uses:** nothing
- **Reusable:** no

## Part 9 of 9

### Top level
- **Does:** Contains four empty function definitions for `dsb_set_hp`, `dsb_alt_wallset`, `dsb_disable`, and `spawn_pit`, followed by two commented-out `dofile` calls pointing to `/Applications/dsbtest35/dm/dungeon.lua` and `/Applications/dsbtest35/dungeonout.lua`.
- **Uses:** nothing
- **Reusable:** no

### dsb_set_hp
- **Does:** Defines an empty function `dsb_set_hp` with no implementation or body content.
- **Uses:** nothing
- **Reusable:** no

### dsb_alt_wallset
- **Does:** Defines an empty function `dsb_alt_wallset` with no implementation or body content.
- **Uses:** nothing
- **Reusable:** no

### dsb_disable
- **Does:** Defines an empty function `dsb_disable` with no implementation or body content.
- **Uses:** nothing
- **Reusable:** no

### spawn_pit
- **Does:** Defines an empty function `spawn_pit` with no implementation or body content.
- **Uses:** nothing
- **Reusable:** no
