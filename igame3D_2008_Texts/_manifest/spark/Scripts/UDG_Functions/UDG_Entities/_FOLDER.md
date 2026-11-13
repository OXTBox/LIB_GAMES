<!-- Spark folder manifest of Data/Scripts/UDG_Functions/UDG_Entities (model spark-x2.6-4b, 2026-11-12 14:43). DRAFT. -->

# Data/Scripts/UDG_Functions/UDG_Entities

- **Role:** This folder holds the UDG game entity libraries that build and configure the game's objects, emitters, windows, and level exit entries from the shared `gObjects` inventory. It centralizes entity setup, door state, weapon assignment, human configuration, and zombie population logic for the UDG game.
- **Entry point:** none
- **Files:**
  - UDG_BloodPencil.lua - library that loads blood decal textures and assigns a unique temporary texture to every material of every scene object to prepare the scene for blood decal rendering.
  - UDG_Building.lua - library that scans `gObjects`, builds building and wall object tables, and applies default physics and visual settings to each building and wall object.
  - UDG_Car.lua - library that loads the RTS vehicle library, builds the `cars` table, and scans `gObjects` to register car objects for the game.
  - UDG_Door.lua - library defining shared door management logic, including a table of door objects and functions to open, close, and auto-close doors based on timers.
  - UDG_Emitters.lua - emitter-settings file that loads particle emitter definitions from the engine and reports missing emitters with warnings.
  - UDG_GUI.lua - library that assigns the first element of the `gTextboxes` table to the `RTS_console` global.
  - UDG_Gun.lua - library that defines and configures gun-related objects, scans and tags gun entities, assigns guns to humans, and sets gun properties and sound settings.
  - UDG_Human.lua - library defining shared human-related data and setup logic, including the human name table, human object collection, light data tracking, and initialization steps that configure human objects with default, role-specific settings and behaviour tables.
  - UDG_LevelExits.lua - level-script that builds a `levelexit` table from objects whose names contain `levelexit`, then configures each entry with position, rotation, physics, and entity flags for the UDG level.
  - UDG_MeleeWeapons.lua - library defining shared melee weapon classification and assignment logic, scanning level objects to identify two-handed melee weapons, distributing them among humans, and configuring human melee weapon behaviour and object settings.
  - UDG_Scenery.lua - library that scans the full `gObjects` inventory, keeps objects whose names contain "scenery", and applies default physics and visual settings to each match.
  - UDG_Teams.lua - library defining global team identifiers used by UDG entity code to identify and manage teams within the game.
  - UDG_Window.lua - engine-core file defining the `windows` table by scanning `gObjects` and initializing each window entry with position, rotation, house flag, alive flag, team, health, and box shape, plus `handle_UDG_Windows` to update window position and rotation when alive and health is greater than zero.
  - UDG_Zombie.lua - library defining the shared zombies table, configuring zombie population settings and animation source caching, and providing `getRandomAnimationOfStyle` for selecting a random animation matching a given style.
- **Shared with other folders:** This folder needs `gObjects`, `gTextboxes`, and engine object/emitter loading functions from the engine and other UDG_Functions scripts. It provides entity configuration tables and setup logic to other UDG_Functions scripts working with game objects, emitters, windows, and level entities.
- **Procedure candidates:** UDG_BloodPencil.lua generates temporary texture assignments for scene object materials using texture loading and procedural assignment rules. UDG_Human.lua runs setup logic that filters objects into the humans list, assigns tracking light indices, and applies default/role-specific settings including random behaviour table selection to human objects.
- **Glossary:**
  - `gObjects` - shared global list of game objects used by entity setup scripts to scan and configure objects.
  - `gTextboxes` - shared global table of text boxes used by GUI scripts to reference console output.
  - `levelexit` - table built from objects whose names contain `levelexit` to define level exit entities.
  - `windows` - table built from `gObjects` entries to define UDG window entities with position, rotation, health, and flags.
  - `cars` - table built by UDG_Car.lua to register RTS vehicle objects for the game.
  - `getRandomAnimationOfStyle` - function in UDG_Zombie.lua that selects a random animation matching a given style.
  - `handle_UDG_Windows` - function in UDG_Window.lua that updates window position and rotation when the window is alive and health is greater than zero.
- **Verdict:** keep - The folder contains the core entity setup and configuration logic for the UDG game, with clear separation of entity types, reusable libraries, and level-specific setup routines that directly support the game's object management.
