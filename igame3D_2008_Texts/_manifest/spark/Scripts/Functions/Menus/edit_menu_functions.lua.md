<!-- Spark first-look of Data/Scripts/Functions/Menus/edit_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:13). DRAFT for Claude to review. -->

## edit_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines the Edit menu UI for the iGame3D engine, providing the `editMenuText` table with Edit menu labels and the `editMenuPick` function that resolves selected menu item selections. It populates the Edit menu by appending fixed labels to the main menu index, adding each label to the menu bar, and recording full menu paths for each item. The `editMenuPick` function formats the selected item title and handles the Clear Scene menu item by invoking `clearsceneClicked()`.
- **Depends on:** `menuIndexCount`, `mainMenuIndex`, `menuBar`, `editMenuText`, `clearsceneClicked` globals set elsewhere; `Data/` folder path prefix for loading referenced files; `print` for output.
- **Provides:** `editMenuText` table, `fill_EditMenu` function, `editMenuPick` function.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (the file configures menu UI elements and records paths; it does not generate assets from numbers or rules).
- **Glossary:**
  - `menuBar` - FLTK UI widget container used to display the Edit menu labels.
  - `menuIndexCount` - Count of existing menu items used to track menu index positions.
  - `mainMenuIndex` - Index of the main menu used as the base for the Edit menu labels.
  - `editMenuText` - Table holding the fixed labels for the Edit menu.
  - `clearsceneClicked` - Function called when the Clear Scene menu item is selected.
- **Keep / port / drop:** keep - it is a reusable reference for building menu UI in the iGame3D engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `editMenuText` table holding the Edit menu labels and the `editMenuPick` function that resolves menu item selections.
- **Uses:** `menuIndexCount`, `mainMenuIndex`, `menuBar`, `item`, `gameroot`, `Data/` path prefix, `print`
- **Reusable:** no
- **Procedural:** no

### fill_EditMenu
- **Does:** Populates the Edit menu by appending the fixed menu labels to the main menu index, then adds each label to the menu bar and records the full menu path for each item.
- **Uses:** `menuIndexCount`, `mainMenuIndex`, `menuBar`, `editMenuText`, `table.getn`
- **Reusable:** yes
- **Procedural:** no

### editMenuPick
- **Does:** Resolves the selected menu item by combining the row and column pick values, formats the title, and handles the Clear Scene menu item by calling `clearsceneClicked()`.
- **Uses:** `item`, `gameroot`, `Data/` path prefix, `print`, `editMenuText` (via Clear Scene label check), `clearsceneClicked`
- **Reusable:** no
- **Procedural:** no
