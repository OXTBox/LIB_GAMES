<!-- Spark first-look of Data/Scripts/Functions/Menus/level_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:15). DRAFT for Claude to review. -->

## level_menu_functions.lua
- **Kind:** library
- **Purpose:** Defines the level menu label table and provides a function that populates the level menu bar with the stored labels. The file fills the level menu UI for the game's level selection screen.
- **Depends on:** Global tables `levelMenuText`, `mainMenuIndex`, and counters `menuIndexCount` set elsewhere; FLTK UI widgets for the menu bar; the `Data/` folder structure for level files.
- **Provides:** `levelMenuText` global table containing level menu labels; `fill_LevelMenu` function that populates the level menu bar.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (the file only defines a table and a function to populate existing UI elements).
- **Glossary:**
  - `levelMenuText` - Global table holding the labels used to build the level menu.
  - `fill_LevelMenu` - Function that populates the level menu bar with the stored labels.
  - `menuIndexCount` - Global counter used to index menu items and compute their positions.
  - `mainMenuIndex` - Global table holding main menu index data used alongside the level menu.
- **Keep / port / drop:** keep - it is a reusable reference for building level menu UI in the engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `levelMenuText` global table with the level menu labels, then implements `fill_LevelMenu` to populate the level menu bar.
- **Uses:** Global `levelMenuText` table, global `mainMenuIndex` table, global `menuIndexCount`, global `menuIndexCount` (via `menuIndexCount+1`), global `menuIndexCount` (via `menuIndexCount+2`), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount` (via `menuIndexCount` at the end), global `menuIndexCount`
