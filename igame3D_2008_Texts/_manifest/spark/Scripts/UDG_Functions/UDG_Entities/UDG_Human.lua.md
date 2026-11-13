<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Human.lua (model spark-x2.6-4b, 2026-11-12 14:39). DRAFT for Claude to review. -->

## UDG_Human.lua
- **Kind:** library
- **Purpose:** This file defines shared human-related data and setup logic for the iGame3D engine, centralizing the human name table, the collection of human objects, tracking light data, and the initialization steps that configure human objects for gameplay. It applies default and role-specific human settings to collected human objects and assigns behaviour tables based on object position or random checks.
- **Depends on:** `Data/` folder paths, `gObjects`, `gObjectWTFs`, `gTrackingLights`, `gTrackingLight`, `gHumanNames`, `humans`, `putObjectOnGround`, `dofile` (via shared Scripts folders), and engine constants such as `IG3D_POSITION`.
- **Provides:** `gHumanNames` (shared human name table), `humans` (collection of human objects), `gTrackingLights` and `gTrackingLight` (tracking light data), plus the setup logic functions `udg_gauntlet_humans` and `udg_sniper_humans` that configure human objects.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** yes — the file runs setup logic that filters objects into the humans list and assigns tracking light indices, and applies default/role-specific settings (including random behaviour table selection) to human objects based on rules.
- **Glossary:**
  - `gObjects` - A shared global collection of engine objects used across scripts.
  - `getObjectInfo` - An engine call that reads property values from an object, such as position or text.
  - `humans` - The collection of human objects managed by this file for gameplay setup.
  - `gTrackingLights` - A shared global tracking light data table used to track human objects.
  - `gunned_civilian_behaviour` / `soldier_behaviour` - Behaviour tables assigned to human objects based on random checks during setup.
  - `sniper_behaviour` - Behaviour table assigned to sniper human objects during setup.
- **Keep / port / drop:** keep - it centralizes shared human setup logic and data that other scripts rely on for consistent human configuration.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the shared human name table, the humans collection, tracking light tracking data, and runs setup logic that filters objects into the humans list and assigns tracking light indices.
- **Uses:** `gObjects`, `gObjectWTFs`, `getObjectInfo`, `string.find`, `string.sub`, `string.sub`, `putObjectOnGround`, `table.insert`, `gTrackingLights`, `gTrackingLight`, `gHumanNames`, `humans`, `print`.
- **Reusable:** no
- **Procedural:** no

### udg_gauntlet_humans
- **Does:** Iterates over all collected human objects and applies default gauntlet human settings, including disabling player following, setting standard hearing/scare/far distance values, and assigning either `gunned_civilian_behaviour` or `soldier_behaviour` based on a random check.
- **Uses:** `humans`, `getObjectInfo`, `math.random`, `gunned_civilian_behaviour`, `soldier_behaviour`.
- **Reusable:** yes
- **Procedural:** no

### udg_sniper_humans
- **Does:** Iterates over all collected human objects, reads their position, and applies sniper-specific settings to humans whose Y coordinate is greater than 1, including disabling player following, setting sniper hearing/scare/far distance values, and assigning `sniper_behaviour`.
- **Uses:** `humans`, `getObjectInfo`, `IG3D_POSITION`, `math` (via `getObjectInfo` position read), `sniper_behaviour`.
- **Reusable:** yes
- **Procedural:** no
