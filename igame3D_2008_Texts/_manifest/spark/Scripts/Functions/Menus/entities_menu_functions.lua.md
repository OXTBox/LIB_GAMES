<!-- Spark first-look of Data/Scripts/Functions/Menus/entities_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:14). DRAFT for Claude to review. -->

## entities_menu_functions.lua
- **Kind:** library
- **Purpose:** This file provides the Entity menu population and pick-routing logic for the iGame3D main menu. It defines the Entity menu item labels and a function that fills the Entity section of the main menu, then routes selected Entity menu rows to the appropriate Entity browser or editor.
- **Depends on:** `menuIndexCount`, `mainMenuIndex`, `menuBar` (globals); `ModelsBrowser`, `CameraBrowser`, `lightswindow`, `mesheditor`, `colorswindow`, `ParticleBrowser`, `TextboxBrowser`, `gameroot` (globals); `Data/` folder paths; `tPick` argument; engine calls (`item`, `OPEN_UI_WINDOWS`, `editingModeSwitch`, `make_current`, `hide`).
- **Provides:** `entityMenuText` table, `fill_EntityMenu` function, `entityMenuPick` function.
- **Assets it needs:** none (no model, image, sound, emitter, font, or `Data/` asset file names are named).
- **Procedural:** none (it builds menu lines from existing labels and routes selections to existing UI objects; no asset is generated from numbers or rules).
- **Glossary:**
  - `entityMenuText` - table holding the labels for the Entity menu items.
  - `fill_EntityMenu` - function that populates the Entity section of the main menu.
  - `entityMenuPick` - function that routes a selected Entity menu row to the matching Entity browser or editor.
  - `menuBar` - global UI element used to add menu lines.
  - `mainMenuIndex` - global used to assign the Entity label to the corresponding main menu index.
  - `menuIndexCount` - global used to track the total menu index count.
  - `Data/` - folder where game assets and scripts live, referenced by path concatenation.
  - `OPEN_UI_WINDOWS` - engine call used to open UI windows for the pick routing.
- **Keep / port / drop:** keep - the menu population and pick-routing logic is reusable for other menu sections.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the `entityMenuText` table holding the Entity menu item labels, then implements `fill_EntityMenu` to populate the Entity section of the main menu.
- **Uses:** `menuIndexCount`, `mainMenuIndex`, `menuBar` (globals); no `Data/` paths, engine calls or file reads.
- **Reusable:** yes - the menu population logic is generic and can be reused for other menu sections.

### fill_EntityMenu
- **Does:** Counts the Entity menu items plus three, assigns the Entity label to the corresponding main menu index, iterates over the `entityMenuText` labels to build each menu line, adds each line to the menu bar, and updates the total menu index count.
- **Uses:** `menuIndexCount`, `mainMenuIndex`, `menuBar` (globals); no engine calls, file paths or `Data/` reads.
- **Reusable:** yes - the menu item population pattern is generic and can be reused for other menu sections.

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the `entityMenuPick` function.
- **Uses:** nothing
- **Reusable:** no

### entityMenuPick
- **Does:** Picks entity menu coordinates, builds the combined pick path and title, then routes the selection to the appropriate entity browser or editor based on the selected menu row.
- **Uses:** engine calls (`item`, `OPEN_UI_WINDOWS`, `editingModeSwitch`, `make_current`, `hide`), globals (`ModelsBrowser`, `CameraBrowser`, `lightswindow`, `mesheditor`, `colorswindow`, `ParticleBrowser`, `TextboxBrowser`, `gameroot`), files and `Data/` paths (`gameroot.."Data/"`), plus the `tPick` argument.
- **Reusable:** no
- **Procedural:** no
