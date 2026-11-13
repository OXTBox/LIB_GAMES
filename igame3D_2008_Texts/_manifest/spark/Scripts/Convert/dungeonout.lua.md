<!-- Spark first-look of Data/Scripts/Convert/dungeonout.lua (model spark-x2.6-4b, 2026-11-12 15:00). DRAFT for Claude to review. -->

## dungeonout.lua
- **Kind:** level-script
- **Purpose:** This file is the level script for the dungeonout dungeon level. It defines champion and door spawn data, door button triggers, and a large set of spawn entries and associated event variables for the dungeon layout, including object types, positions, rotations, directions, and interactive object configurations. It is written in Lua 5.1 and uses the iGame3D engine's spawn and event variable conventions to build the level.
- **Depends on:** `Data/` folder paths, `dofile`-loaded Lua libraries, `loadLevel("Data/Levels/dungeonout")` level loading, globals such as `gObjects` and `gameroot`, and engine calls for setting object, scene, camera, light, bone, material, particle, and text_box info.
- **Provides:** No standalone functions or globals are defined here; it provides the level's spawn tables (e.g., `dsbspawn`, `exvar`), door and door button spawn entries, and associated event variable configurations that other files or the engine use to build and run the dungeonout level.
- **Assets it needs:** Models, images, sounds, emitters (`.emt`), fonts (FontPngs), and text format "iGame3D Mdl" models referenced by the spawn entries; exact file names are not listed in the provided parts.
- **Procedural:** yes - it generates the dungeonout level layout by constructing spawn entries, object placements, and associated event variable configurations from numeric coordinates, object types, and fixed rules rather than loading a pre-made level asset.
- **Glossary:**
  - `dsbspawn` - Table holding spawn entries for the dungeonout level, each entry carrying object type, position, rotation, and associated variable settings.
  - `exvar` - Event variable configuration attached to spawn entries, setting activation, interaction, and behavior rules for objects like triggers, buttons, teleporters, and generators.
  - `IG3D_POSITION` - Engine constant naming the position property being read or set on an object.
  - `make` / `get` - Engine calls used to create or retrieve objects by kind and file/name, e.g. `make(ig3d_object, "file.wtf")`.
  - `loadLevel` - Engine call that switches the active level by its `Data/Levels` folder path.
  - `dofile` - Engine call that loads a Lua file from a path.
  - `getObjectInfo` / `setObjectInfo` - Engine calls that read or set object property values such as position, rotation, and text.
- **Keep / port / drop:** keep - it is a complete level script that defines the dungeonout level's spawn layout and event rules, useful as a reference for building other iGame3D level scripts.

---

# Part notes

## Part 1 of 69

### Top level
- **Does:** Defines the champion and spawn entry data tables for the dungeon level, containing static position, name and spawn configuration values.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 2 of 69

### Top level
- **Does:** Defines spawn data for doorframe objects in the dungeonout level, one entry per line.
- **Uses:** Global `dsbspawn` table; no engine calls, globals beyond `dsbspawn`, or `Data/` paths.
- **Reusable:** no
- **Procedural:** yes

## Part 3 of 69

### Top level
- **Does:** Defines spawn entries for door objects in the dungeon level, each with a door type, dimensions, and position.
- **Uses:** Global `dsbspawn` table; no engine calls, files, or Data/ paths.
- **Reusable:** yes - the table structure can be reused for adding door spawn definitions in other levels.

## Part 4 of 69

### Top level
- **Does:** Defines a table of door spawn entries for the dungeon out level, one entry per line.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 69

### Top level
- **Does:** Defines spawn entries for door objects and door button triggers, then sets the door button target to door_ra.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths.
- **Reusable:** yes - the entry format is a reusable table structure for spawn and trigger definitions.

## Part 6 of 69

### Top level
- **Does:** Defines door button spawn entries and their target door reference, then writes the same pair repeatedly for each door button.
- **Uses:** Globals `exvar` and `dsbspawn`; no engine calls, file paths, or Data/ paths.
- **Reusable:** no
- **Procedural:** yes

## Part 7 of 69

### Top level
- **Does:** Defines spawn data for door buttons and their target objects, then records each button's target as door_ra.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, files or Data/ paths.
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, including door button positions, emitter and object spawns, and chest-related spawn data.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes

## Part 9 of 69

### Top level
- **Does:** Defines spawn entries for dungeonout, including object spawns, trigger and emitter-like spawn configurations, and associated emitter variables.
- **Uses:** Globals `dsbspawn`, `exvar`, and constants `IN_OBJ`, `SOUTH`, `NORTHWEST`, `EAST`, `CENTER`, `WEST`, `NORTH`; no engine calls, file paths or Data/ paths.
- **Reusable:** no
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 10 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level by setting spawn metadata and object variable values.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn and object variable tables); no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** no

## Part 11 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level and sets trigger/mirror/wand variable values.
- **Uses:** Globals `dsbspawn`, `exvar`, and direction constants (SOUTH, EAST, NORTHWEST, CENTER, NORTH, NORTHEAST, WEST, SOUTHEAST); no engine calls, file paths, or Data/ paths.
- **Reusable:** no
- **Procedural:** no

## Part 12 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and sets associated exvar values for mirrors, scrolls, and triggers.
- **Uses:** Globals `dsbspawn` and `exvar` (shared names starting with lowercase letters, no `Data/` paths or engine calls).
- **Reusable:** no
- **Procedural:** yes - it generates spawn data (object placements and associated variable settings) for the level layout.

## Part 13 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, covering object placements, trigger/teleporter setups, and text-based exvar configurations.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn/event variable tables); no engine calls, file paths, or `Data/` paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates spawn entries and event variable configurations for the level layout.

## Part 14 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated activation or deactivation variables, setting object types, positions, directions, and variable properties.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 15 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, setting object type, position, rotation, and optional event configuration.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn and event variable tables); no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates spawn entries and event variable configurations for the level layout.

## Part 16 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, with no functions or setup logic.
- **Uses:** Globals `dsbspawn` and `exvar` (shared name globals), plus directional constants (`CENTER`, `NORTHWEST`, etc.) used in spawn definitions.
- **Reusable:** yes - the spawn entry and event variable patterns are reusable for adding new spawned objects and their linked events to a level.
- **Procedural:** no

## Part 17 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level and their associated event variables, with no functions or setup logic.
- **Uses:** Globals `dsbspawn` and `exvar` (shared name-based tables), plus object names and directional constants used in the spawn definitions.
- **Reusable:** no
- **Procedural:** no

## Part 18 of 69

### Top level
- **Does:** Defines spawn entries for objects and their associated variables in the dungeon level, using fixed numeric coordinates and object types.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths or Data/ paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 19 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level and their associated event variables, setting object type, position, rotation, and optional event configuration.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn/event configuration tables); no engine calls, files, or `Data/` paths are read or written.
- **Reusable:** no
- **Procedural:** no

## Part 20 of 69

### Top level
- **Does:** Defines spawn variables and spawn entries for a dungeon level, setting object types, positions, directions, and associated event variables.
- **Uses:** Engine data structures (`dsbspawn`, `exvar`) and `Data/` level layout paths implied by the spawn coordinates; no direct engine calls, globals beyond these data structures, or file reads/writes.
- **Reusable:** yes - the spawn and event variable definitions are reusable layout data for level configuration.

## Part 21 of 69

### Top level
- **Does:** Defines spawn entries and their associated variables for the dungeon level, continuing earlier setup.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, file paths or Data/ paths.
- **Reusable:** no
- **Procedural:** yes

## Part 22 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level, including object spawn data and associated event variables.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes

## Part 23 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, setting object types, positions, rotation, direction, and event configuration values.
- **Uses:** Globals `dsbspawn` (spawn definitions) and `exvar` (event variable configurations); no engine calls, `Data/` paths, or file reads/writes.
- **Reusable:** no
- **Procedural:** no

## Part 24 of 69

### Top level
- **Does:** Defines spawn entries and associated variable settings for the dungeon level, listing objects with position, rotation and type, and setting per-object behavior variables.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, file paths or Data/ paths.
- **Reusable:** no
- **Procedural:** no

## Part 25 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level by assigning trigger, object, and variable configurations to `dsbspawn` and `exvar` tables.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, `Data/` paths, or file reads/writes.
- **Reusable:** no
- **Procedural:** yes - it generates spawn configurations (object placements and associated variable settings) for the level layout.

## Part 26 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, setting object types, positions, rotation, direction, and optional event configuration.
- **Uses:** `dsbspawn` table entries, `exvar` table entries, and direction constants (SOUTH, NORTH, etc.); no engine calls, globals beyond these tables, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 27 of 69

### Top level
- **Does:** Defines spawn entries and their associated variable settings for the dungeon out level, continuing from earlier parts.
- **Uses:** Globals `dsbspawn`, `exvar`, and constants `SOUTH`, `NORTH`, `NORTHEAST`, `SOUTHWEST`, `CENTER`, `WEST`, `EAST`, `NORTHWEST`, `SOUTHEAST`; writes to `dsbspawn` and `exvar` tables.
- **Reusable:** no
- **Procedural:** yes

## Part 28 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, setting object type, position, rotation, direction and event configuration values.
- **Uses:** Globals `dsbspawn` (spawn table), `exvar` (event variable table), and constants `CENTER`, `SOUTH`, `WEST`, `NORTH`, `EAST`, `SOUTHWEST`, `NORTHEAST` used to configure spawned objects and their event settings.
- **Reusable:** yes - the spawn and event variable configuration pattern for adding level objects can be reused for other level scripts.

## Part 29 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated trigger variables, setting object names, positions, directions, and trigger behavior.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, file paths, or Data/ paths.
- **Reusable:** no
- **Procedural:** no

## Part 30 of 69

### Top level
- **Does:** Defines trigger spawn entries and their associated event variables, then lists spawn entries for teleporters, slime drains, movable walls, slimes, and fountain lions.
- **Uses:** Globals `exvar` and `dsbspawn`; no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** yes

## Part 31 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated trigger variables, setting object types, positions, directions, and trigger behaviors.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates spawn entries and trigger variable configurations for the level layout.

## Part 32 of 69

### Top level
- **Does:** Defines spawn entries and teleporter/alcove settings for the dungeon level, with no functions or setup beyond these top-level assignments.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, `Data/` paths, or files are read or written.
- **Reusable:** no
- **Procedural:** no

## Part 33 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level by assigning object type, position, rotation and direction to `dsbspawn` table entries, and sets event variables for objects that require activation or interaction.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, `Data/` paths, or files are read or written.
- **Reusable:** yes - the spawn and event variable definitions are generic level configuration entries that can be reused across similar dungeon level scripts.
- **Procedural:** no

## Part 34 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and associated event variables, setting object spawns, activation rules, and properties for each spawned entity.
- **Uses:** Globals `dsbspawn` and `exvar` (shared between files, names starting with `g`), plus directional constants such as `EAST`, `NORTH`, `CENTER`, `SOUTHEAST`, `SOUTHWEST`, `NORTHEAST`, `NORTHWEST`, `SOUTH`.
- **Reusable:** no
- **Procedural:** yes

## Part 35 of 69

### Top level
- **Does:** Defines spawn entries and their associated variable settings for the dungeon level, continuing earlier parts of the conversion.
- **Uses:** Globals `dsbspawn` and `exvar` (shared namespaces for spawn definitions and spawn variables); no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** yes

## Part 36 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level and their associated variable settings, with no functions or top-level executable logic beyond these declarations.
- **Uses:** Globals `exvar` and `dsbspawn`; no engine calls, `Data/` paths, or file reads/writes.
- **Reusable:** no
- **Procedural:** no

## Part 37 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, each with a spawn object type, size, position and direction, and optional event variables for trigger, button, wall or teleporter behavior.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn and event variable tables), plus object type names such as `keyhole_solid`, `teleporter`, `trigger`, `button_green` and `ring_plain`.
- **Reusable:** no
- **Procedural:** yes

## Part 38 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level, each with object type, dimensions, position, and associated exvar settings for relays, alcoves, cracks, generators, and other interactive objects.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn and event variable tables); no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates spawn configurations for game objects based on fixed numeric and object type rules.

## Part 39 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level and their associated event variables, containing object type, position, rotation, and optional event configuration.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 40 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated variable configurations, continuing from earlier parts of the file.
- **Uses:** Globals `dsbspawn` and `exvar` (shared between files, names starting with `g`), plus object type names such as `teleporter`, `bluehaze`, `x_relay`, `smallswitch`, `x_counter`, `hook`, `pad_tiny`, `trigger`, `crossbow`, `stairsdown`, `sconce_empty`, `ring_plain`, `pad`, `monster_generator`, `lever_up`, `movablewall`, `crack`, and `mithral_mail`, `alcove_vi`.
- **Reusable:** no
- **Procedural:** no

## Part 41 of 69

### Top level
- **Does:** Defines spawn entries and their associated variable settings for the dungeon out level, continuing from earlier parts.
- **Uses:** Globals `dsbspawn` and `exvar` (shared between files, names starting with `g` are globals), plus object type names and direction constants used in the spawn definitions.
- **Reusable:** no
- **Procedural:** yes

## Part 42 of 69

### Top level
- **Does:** Defines spawn entries for a dungeon level by assigning object names, sizes, positions and directions to `dsbspawn` indices, and sets per-entry variables such as charge, text, destroy flags, operation targets and messages.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, `Data/` paths or files are read or written.
- **Reusable:** yes - the spawn entry pattern is a compact data structure for level object placement and per-object configuration.
- **Procedural:** no

## Part 43 of 69

### Top level
- **Does:** Defines spawn entries for dungeonout level 12 and associated exvar settings for those spawned objects.
- **Uses:** Global tables `dsbspawn` and `exvar`, plus object type names and direction constants used in the spawn definitions.
- **Reusable:** no
- **Procedural:** yes

## Part 44 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, including object types, positions, rotation, and optional `exvar` configuration values.
- **Uses:** Globals `dsbspawn` and `exvar` (shared namespaces for spawn definitions and spawn variables); no engine calls, file paths, or `Data/` paths are used.
- **Reusable:** yes - the structure of spawn definitions with object type, position, rotation, and optional variable configuration is reusable for other level spawn scripts.

## Part 45 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level by assigning object type, position, rotation, and optional event variables to indexed `dsbspawn` keys.
- **Uses:** Globals `dsbspawn` and `exvar` (no `Data/` paths, no engine calls).
- **Reusable:** no
- **Procedural:** yes - it generates the spawn layout for the level by assigning object types, positions, rotations and event settings to indexed spawn entries.

## Part 46 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated variable configurations, continuing from earlier parts of the script.
- **Uses:** Global tables `dsbspawn` and `exvar` (shared globals), plus object type names used in spawn definitions such as `floorslime`, `ghost`, `pad`, `trigger`, `teleporter`, `bluehaze`, `movablewall`, `wallslime`, `gorface`, `brickswitch`, `monster_generator`, `stairsdown`, `stairsup`, `mace_order`, `keyhole_skeleton`, `fulbomb`, `button_green`, `pad_small`, and `wallgrate`.
- **Reusable:** no
- **Procedural:** no

## Part 47 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level and their associated variable settings, continuing from earlier parts of the script.
- **Uses:** Engine data tables (`exvar`, `dsbspawn`) and the `Data/` level folder paths implied by the script context; no direct engine calls, globals beyond these tables, or file reads/writes.
- **Reusable:** yes - the spawn entry and variable definition patterns are reusable for adding new level objects and their associated settings.

## Part 48 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated variable settings, using flat key-value assignments.
- **Uses:** Globals `dsbspawn` and `exvar` (shared names starting with `g`), plus object type names such as `wallslime`, `teleporter`, and `trigger` referenced by their spawn entries. No engine calls or `Data/` paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 49 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, including object spawns, associated exvar settings, and level-level variables.
- **Uses:** Engine calls: none. Globals: `dsbspawn`, `exvar`. Files and `Data/` paths: none.
- **Reusable:** no
- **Procedural:** yes

## Part 50 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, with no functions or top-level executable logic beyond these assignments.
- **Uses:** Globals `dsbspawn` (spawn configuration table) and `exvar` (event variable table); no engine calls, `Data/` paths, or file operations.
- **Reusable:** no
- **Procedural:** no

## Part 51 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated variable configurations, continuing earlier parts of the script.
- **Uses:** Globals `dsbspawn` and `exvar` (shared namespaces for spawn definitions and spawn variable settings); no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** yes - it generates spawn definitions and their variable configurations for the level.

## Part 52 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level by assigning object spawn configurations and associated variable data to indexed keys in the `dsbspawn` table.
- **Uses:** Table assignments (`dsbspawn[...]`, `exvar[...]`) with object names, spawn parameters, target/operation settings, text content and numeric values. No engine calls, globals beyond the tables or `Data/` paths appear.
- **Reusable:** yes - the spawn configuration and variable definition pattern can be reused for other level spawn definitions.

## Part 53 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, including object types, positions, rotation, and associated variable settings.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes

## Part 54 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, each with a spawn type, position, facing, and optional per-object variable settings.
- **Uses:** Nothing external; uses the `dsbspawn` table and `exvar` table to store spawn definitions and object variable configurations.
- **Reusable:** no
- **Procedural:** no

## Part 55 of 69

### Top level
- **Does:** Defines spawn entries and their associated variables for the dungeon level, setting object types, positions, orientations, and variable values.
- **Uses:** Globals `dsbspawn` and `exvar` (shared namespaces for spawn definitions and spawn variables); no engine calls, `Data/` paths, or file reads/writes.
- **Reusable:** no
- **Procedural:** no

## Part 56 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level by assigning fake objects, setting their spawn parameters, and configuring associated trigger or emitter variables.
- **Uses:** Globals `dsbspawn` and `exvar`; no engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates spawn configurations for the level by assigning object types, parameters, and associated variables to spawn entries.

## Part 57 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, each with positional and behavior settings, and sets associated behavior variables.
- **Uses:** `dsbspawn` table, `exvar` table, and `Data/`-based spawn definitions; no engine calls, globals beyond these tables, or file paths.
- **Reusable:** no
- **Procedural:** yes - generates spawn entries and behavior variables for the level layout.

## Part 58 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, with no functions or setup logic.
- **Uses:** Globals `dsbspawn` and `exvar` that store spawn configurations and event settings; no engine calls, `Data/` paths, or file operations.
- **Reusable:** yes - the spawn and event variable definitions are generic configuration data that can be reused across similar level scripts.

## Part 59 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, including object type and position data, and sets per-object variable settings for shooters, triggers, and teleporters.
- **Uses:** Globals `dsbspawn` (spawn definitions) and `exvar` (per-object variable settings); no engine calls, file paths, or `Data/` paths are read or written.
- **Reusable:** no
- **Procedural:** yes - it generates spawn definitions and per-object variable configurations for the level layout.

## Part 60 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level by assigning object names, positions, rotation and direction to `dsbspawn` table entries, and sets `exvar` settings for referenced objects.
- **Uses:** Table assignments (`dsbspawn`, `exvar`) with object names, numeric coordinates, direction constants and string values; no engine calls, globals beyond these tables or `Data/` paths.
- **Reusable:** yes - the spawn entry pattern for level object placement can be reused for other level scripts.
- **Procedural:** yes - generates level spawn layouts by assigning object positions and settings for the dungeonout level.

## Part 61 of 69

### Top level
- **Does:** Defines spawn entries and their associated variable settings for the dungeon out level, covering wall rings, pads, triggers, teleporters, coin generators, and monster generators.
- **Uses:** Engine spawn configuration variables (`dsbspawn`, `exvar`), level-related settings (`lev`, `opby`, `opby_party`, `opby_monster`, `opby_thing`), and direction constants (`EAST`, `CENTER`, `SOUTHEAST`, `NORTHEAST`). No `Data/` file paths or engine object calls are used.
- **Reusable:** yes - the spawn entry and variable definitions are generic configuration data that can be reused across levels with adjusted coordinates and settings.
- **Procedural:** no

## Part 62 of 69

### Top level
- **Does:** Defines spawn entries and their associated variable settings for the dungeon out level, continuing from earlier parts.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, file paths or `Data/` paths are read or written.
- **Reusable:** no
- **Procedural:** no

## Part 63 of 69

### Top level
- **Does:** Defines spawn entries and associated variable settings for the dungeon out level, continuing from earlier parts.
- **Uses:** Globals `dsbspawn`, `exvar`; no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** yes

## Part 64 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon out level, including object names, positions, rotation, and per-object variable settings.
- **Uses:** Globals `dsbspawn` and `exvar` (shared spawn and variable tables); no engine calls, file paths, or Data/ paths are read or written.
- **Reusable:** no
- **Procedural:** yes

## Part 65 of 69

### Top level
- **Does:** Defines spawn entries for the dungeonout level and their associated exvar settings, continuing from earlier parts of the script.
- **Uses:** Globals `dsbspawn` and `exvar` (shared between files, names starting with `g`), plus directional constants (SOUTHWEST, WEST, CENTER, etc.). No engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** no

## Part 66 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and associated exvar settings for interactive objects.
- **Uses:** Globals `dsbspawn` and `exvar` (no engine calls, no Data/ paths).
- **Reusable:** no
- **Procedural:** no

## Part 67 of 69

### Top level
- **Does:** Defines spawn entries and associated variable settings for the dungeon level, listing object types, positions, orientations, and per-object parameters.
- **Uses:** Globals `dsbspawn` and `exvar` (shared namespaces for spawn definitions and spawn variable settings); no engine calls, file paths, or `Data/` paths are read or written.
- **Reusable:** yes - the spawn definition and variable parameter patterns are reusable for adding new spawn entries to the level.

## Part 68 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level, each with a spawn type, dimensions, orientation, and associated `exvar` configuration for teleporters, triggers, monster generators, fire pits, and other objects.
- **Uses:** Globals `dsbspawn` (spawn definitions) and `exvar` (per-object spawn configuration variables). No engine calls, `Data/` paths, or file operations are used.
- **Reusable:** no
- **Procedural:** yes

## Part 69 of 69

### Top level
- **Does:** Defines spawn entries for the dungeon level and their associated event variables, setting object names, positions, rotation, direction, and event configuration.
- **Uses:** Globals `dsbspawn` and `exvar` (shared between files), plus directional constants (SOUTH, EAST, etc.) referenced in spawn definitions. No engine calls, file paths, or Data/ paths are used.
- **Reusable:** no
- **Procedural:** yes - it generates a level layout by defining spawned object placements and their event rules.
