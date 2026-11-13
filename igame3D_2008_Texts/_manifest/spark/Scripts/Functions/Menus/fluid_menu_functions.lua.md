<!-- Spark first-look of Data/Scripts/Functions/Menus/fluid_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:15). DRAFT for Claude to review. -->

## fluid_menu_functions.lua
- **Kind:** ui-dialog
- **Purpose:** Defines the `FluidsMenuText` table and the `fill_FluidsMenu` function that populate the fluid menu by reading the contents of the Fluid folder and building menu lines for each file. The function counts the Fluid folder entries, constructs menu lines for each file, adds them to the menu bar, and resets the menu index count. It depends on the Fluid folder contents and the menu state globals to function.
- **Depends on:** `getSceneInfo(IG3D_ROOT)`, `lfs.dir`, `menuIndexCount`, `mainMenuIndex`, `menuBar`, `oldChar`, `menuLine` globals/state; the `Data/Fluid` folder path built from the scene root; FLTK menu bar widgets (`menuBar:add`, `menuBar:value`).
- **Provides:** `FluidsMenuText` table, `fill_FluidsMenu` function.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** yes - it generates menu lines and menu index state from the contents of the Fluid folder and the menu state globals, rather than loading a pre-existing asset file.
- **Glossary:**
  - `FluidsMenuText` - table holding the text content used to populate the fluid menu.
  - `fill_FluidsMenu` - function that builds and adds the fluid menu lines to the menu bar.
  - `menuBar` - FLTK menu bar widget used to display the fluid menu.
  - `lfs.dir` - function used to list files in a folder.
  - `getSceneInfo` - engine call used to read scene-level information.
  - `IG3D_ROOT` - constant naming the root scene object used to build folder paths.
  - `menuIndexCount` - global state tracking the current menu index count.
  - `mainMenuIndex` - global state tracking the current main menu index.
- **Keep / port / drop:** keep - it is a reusable reference for building fluid menu UI from folder contents.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `FluidsMenuText` table and the `fill_FluidsMenu` function that populates the fluid menu.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `lfs.dir`, `menuIndexCount`, `mainMenuIndex`, `menuBar`, `oldChar`, `menuLine` globals/state; reads files under the `Data/Fluid` folder path built from the scene root.
- **Reusable:** no - it builds a menu index based on the contents of the Fluid folder and requires the menu state globals to be present.

### fill_FluidsMenu
- **Does:** Counts the Fluid folder entries, builds menu lines for each file, adds them to the menu bar, and resets the menu index count.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `lfs.dir`, `string.sub`, `string.upper`, `menuBar:add`, `menuBar:value`, `menuIndexCount`, `mainMenuIndex`, `oldChar`; reads files under the `Data/Fluid` folder path built from the scene root.
- **Reusable:** no - it depends on the Fluid folder contents and the menu state globals to function.
- **Procedural:** no
