<!-- Spark first-look of Data/Scripts/Functions/Menus/library_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:18). DRAFT for Claude to review. -->

## library_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines the `LibraryMenuText` table and provides functions that build the library menu bar entries, handle the callback for selected library items, and resolve library picks to open the matching UI windows. It supports the library menu interaction for the iGame3D engine.
- **Depends on:** Other Scripts/Functions/Menus files for shared menu globals; engine calls for menu bar and UI window management; globals set elsewhere such as `menuIndexCount`, `mainMenuIndex`, `LibStartVal`, `gLastMenuPick`, `console`, `wifBrowser`, `WTFBrowserNew`, `uBrowserNew`.
- **Provides:** `LibraryMenuText` table, `fill_LibraryMenu`, `Library_menu_callback`, `libraryMenuPick` functions.
- **Assets it needs:** none (no model, image, sound, emitter, font, or data file names are referenced).
- **Procedural:** none (no asset is generated from numbers or rules; it only builds menu entries and configures UI window behavior).
- **Glossary:**
  - `menuBar:add` - Engine call that adds a menu bar entry to the library menu.
  - `OPEN_UI_WINDOWS` - Engine call that opens the UI window matching a library pick.
  - `LibraryMenuText` - Local table listing library menu entries for the library menu.
  - `mainMenuIndex` - Global table used to resolve adjusted menu values to their corresponding actions.
  - `gLastMenuPick` - Global tracking the selected library pick value.
  - `w:label()`, `w:value()`, `w:text()` - Engine calls that read the label, value, and text of a clicked menu item.
- **Keep / port / drop:** keep - it is a reusable library function for building and handling the library menu UI.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `LibraryMenuText` table listing library menu entries, and contains no other top-level setup, global declarations, or widget definitions.
- **Uses:** Nothing beyond the local `LibraryMenuText` table.
- **Reusable:** no

### fill_LibraryMenu
- **Does:** Builds the Library menu bar entries by appending each library folder name to `Library/` and adding the resulting path to the menu bar, tracking the total menu index count.
- **Uses:** Engine calls (`menuBar:add`), globals (`menuIndexCount`, `mainMenuIndex`, `LibraryMenuText`).
- **Reusable:** yes

### Library_menu_callback
- **Does:** Retrieves the selected menu label, adjusted value, and text from the clicked menu item, prints these values, and resolves the adjusted value against the `mainMenuIndex` table.
- **Uses:** Engine calls (`w:label()`, `w:value()`, `w:text()`), globals (`LibStartVal`, `mainMenuIndex`).
- **Reusable:** no

### libraryMenuPick
- **Does:** Records the selected library pick value, then hides and clears the corresponding browser or console UI window if present, opens the matching UI window via `OPEN_UI_WINDOWS`, and handles the UniversalBrowser case when no specific window was opened.
- **Uses:** Engine calls (`w:hide()`, `OPEN_UI_WINDOWS`), globals (`gLastMenuPick`, `console`, `wifBrowser`, `WTFBrowserNew`, `uBrowserNew`).
- **Reusable:** no
