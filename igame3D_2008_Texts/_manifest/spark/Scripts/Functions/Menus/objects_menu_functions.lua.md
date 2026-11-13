<!-- Spark first-look of Data/Scripts/Functions/Menus/objects_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:23). DRAFT for Claude to review. -->

## objects_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines the Objects menu construction logic for the iGame3D engine, providing functions that build the Objects menu bar from WTF model folders and load selected objects into the current object state. It contains no setup or global state outside the functions it defines.
- **Depends on:** `Data/` folder paths, `lfs.dir`, `string.sub`, `string.upper`, `make`, `getSceneInfo`, `IG3D_ROOT`, `menuIndexCount`, `mainMenuIndex`, `Library_menuBar`, `gNumObjects`, `gObjects`, `gCurObject`, `item`, `print`, and the `ObjectsMenuText` table defined in this file.
- **Provides:** `ObjectsMenuText` table, `fill_ObjectsMenu`, `loadObject` functions used to build and populate the Objects menu.
- **Assets it needs:** WTF model folders (no exact file names named), scene WTF directory (via `getSceneInfo`).
- **Procedural:** none
- **Glossary:**
  - WTF model - iGame3D 3D model assets stored in the WTF folder.
  - Objects menu - the menu bar listing available WTF model objects for selection.
  - `gCurObject` - global variable holding the currently selected object.
  - `gNumObjects` - global variable tracking the total number of loaded objects.
  - `Library_menuBar` - FLTK UI widget used to display the Objects menu bar.
  - `IG3D_ROOT` - engine constant used to build paths to scene assets.
- **Keep / port / drop:** keep - core menu construction logic reusable for new iGame3D-based engines.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `ObjectsMenuText` table used to build the Objects menu, and contains no setup or global state outside these functions.
- **Uses:** `lfs.dir`, `string.sub`, `string.upper`, `make`, `getSceneInfo`, `IG3D_ROOT`, `menuIndexCount`, `mainMenuIndex`, `Library_menuBar`, `gNumObjects`, `gObjects`, `gCurObject`, `item`, `print`.
- **Reusable:** no
- **Procedural:** no

### fill_ObjectsMenu
- **Does:** Builds the Objects menu by listing WTF model folders from the scene's WTF directory, then adds the Scene object entries to the menu bar and updates the menu index count.
- **Uses:** `lfs.dir`, `string.sub`, `string.upper`, `getSceneInfo`, `IG3D_ROOT`, `menuIndexCount`, `mainMenuIndex`, `Library_menuBar:add`, `Library_menuBar:value`, `ObjectsMenuText`, `menuIndexCount`, `gNumObjects`, `gObjects`, `gCurObject`, `make`, `item`, `print`.
- **Reusable:** no
- **Procedural:** no

### loadObject
- **Does:** Increments the object count, resolves the WTF file path from the given file name, creates an `ig3d_object` from the WTF path, and sets it as the current object.
- **Uses:** `make`, `gNumObjects`, `gObjects`, `gCurObject`, `item`, `string.sub`, `print`.
- **Reusable:** no
- **Procedural:** no
