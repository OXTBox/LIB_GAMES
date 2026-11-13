<!-- Spark first-look of Data/Scripts/Functions/Menus/main_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:19). DRAFT for Claude to review. -->

## main_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines shared menu-related globals and functions that build the application menu bar and handle main menu widget callbacks for the iGame3D engine. It provides the menu fill functions, menu index lookup helpers, and the main menu interaction logic used by the game's menu system.
- **Depends on:** Scripts/Functions/Menus menu fill functions (`fill_FileMenu`, `fill_EditMenu`, `fill_LevelMenu`, `fill_EntityMenu`, `fill_LibraryMenu`), engine calls (`item`), and globals set elsewhere (`mainMenuIndex`, `gLastMenuPick`, `menuIndexCount`, `LibStartVal`, `oldChar`, `lastLoadedFile`).
- **Provides:** Shared menu globals (`mainMenuIndex`, `menuIndexCount`, `LibStartVal`, `oldChar`, `lastLoadedFile`, `gLastMenuPick`), reusable menu bar construction function `FillMenuBar`, reusable menu index output function `outputMenuIndices`, and main menu callback handler `main_menu_callback`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (no assets are generated from numbers or rules; only menu structure and callback logic are defined).
- **Glossary:**
  - iGame3D calls - Engine function calls used to read or set object properties in the iGame3D engine.
  - menu fill functions - Functions that populate individual sections of the application menu bar.
  - main menu widget callback - The callback handler that processes user input from the main menu interface.
  - menu index lookup - A table mapping menu labels to corresponding menu index values used to dispatch menu actions.
- **Keep / port / drop:** keep - It is a core, reusable reference for the engine's menu system structure and interaction logic.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines shared menu-related globals used by the menu functions: `mainMenuIndex`, `menuIndexCount`, `LibStartVal`, `oldChar`, `lastLoadedFile`, `gLastMenuPick`.
- **Uses:** nothing
- **Reusable:** yes

### FillMenuBar
- **Does:** Builds the application menu bar by calling the menu fill functions in a fixed order: `fill_FileMenu()`, `fill_EditMenu()`, `fill_LevelMenu()`, `fill_EntityMenu()`, `fill_LibraryMenu()`. Several fill functions are commented out.
- **Uses:** engine calls (menu fill functions `fill_FileMenu`, `fill_EditMenu`, `fill_LevelMenu`, `fill_EntityMenu`, `fill_LibraryMenu`)
- **Reusable:** yes

### main_menu_callback
- **Does:** Handles the main menu widget callback. It reads the menu label, value, and text from the widget, looks up the corresponding menu index in `mainMenuIndex`, and dispatches to the matching menu pick function based on the menu head text.
- **Uses:** globals (`mainMenuIndex`, `gLastMenuPick`), engine calls (`item`)
- **Reusable:** no

### outputMenuIndices
- **Does:** Prints the menu index value for the given `tVal` to the output, using the `mainMenuIndex` lookup table.
- **Uses:** globals (`mainMenuIndex`)
- **Reusable:** yes

### Top level
- **Does:** Defines shared menu-related globals used by the menu functions: `mainMenuIndex`, `menuIndexCount`, `LibStartVal`, `oldChar`, `lastLoadedFile`, `gLastMenuPick`.
- **Uses:** nothing
- **Reusable:** yes
