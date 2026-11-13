<!-- Spark folder manifest of Data/Scripts/Functions/Menus (model spark-x2.6-4b, 2026-11-12 06:26). DRAFT. -->

# Data/Scripts/Functions/Menus
- **Role:** This folder holds the reusable menu construction and interaction libraries for the iGame3D engine, covering main menu, file, edit, entity, fluid, level, levels, library, mesh, objects, and particle menu sections. Each file defines its menu label tables, fills the corresponding menu bar, and routes selected menu items to the matching engine UI windows or editors.
- **Entry point:** none
- **Files:**
  - edit_menu_functions.lua - Defines the Edit menu UI for iGame3D, providing the `editMenuText` table, `fill_EditMenu` function, and `editMenuPick` function that resolves selected Edit menu items.
  - entities_menu_functions.lua - Provides Entity menu population and pick-routing logic, defining `entityMenuText`, `fill_EntityMenu`, and `entityMenuPick` to route selected Entity rows to Entity browsers or editors.
  - file_menu_functions.lua - Defines the file menu bar for iGame3D, including menu construction, file selection/loading, level naming, and script saving logic via `fill_FileMenu`, `openLevel`, `nameLevel`, `fileMenuPick`, `openfile`, `savefile`, `saveScript`.
  - fluid_menu_functions.lua - Defines the `FluidsMenuText` table and `fill_FluidsMenu` function that populate the fluid menu by reading the Fluid folder contents and adding menu lines to the menu bar.
  - level_menu_functions.lua - Defines the level menu label table `levelMenuText` and `fill_LevelMenu` function that populates the level menu bar with stored labels.
  - levels_menu_functions.lua - Defines the functions driving the Levels menu UI, including menu building from level folders, restart/clear/exit/save actions, and level save logic via `LevelsMenuText`, `fill_LevelsMenu`, `exittomenu`, `restartbutton`, `newLevel`, `save_levelState`, `save_levelMesh`, `save_level`, `saveAsNewLevel`, `levelMenuPick`.
  - library_menu_functions.lua - Defines the `LibraryMenuText` table, `fill_LibraryMenu`, `Library_menu_callback`, and `libraryMenuPick` functions for library menu construction and pick routing.
  - main_menu_functions.lua - Defines shared menu globals and functions for the application menu bar, including `FillMenuBar`, `outputMenuIndices`, and `main_menu_callback` handler.
  - mesh_menu_functions.lua - Defines the mesh menu structure and its fill, pick, save, and callback logic, including `fillMeshbase`, `fillMeshSelect`, `fillMeshFace`, `fillMeshView`, `fillMeshMirror`, `fill_MeshMenu`, `meshBasePick`, `meshSelectPick`, `meshFacePick`, `meshViewPick`, `meshMirrorPick`, `save_asWTF`, `save_asOBJ`, `save_as3DS`, `save_asMeshWork`, `mesh_menu_callback`, plus globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`.
  - objects_menu_functions.lua - Defines the Objects menu construction logic, providing `ObjectsMenuText`, `fill_ObjectsMenu`, and `loadObject` functions to build the Objects menu bar from WTF model folders.
  - particles_menu_functions.lua - Defines the shared particle menu functions for iGame3D, covering menu population, emitter control actions, and menu callback handling via `fillParticlesSourceMenu`, `fillParticlesControlMenu`, `particlesCurrentPick`, `particlesAllMenuPick`, `particlesEmittersMenuPick`, `particles_menu_callback`, plus shared particle menu state tables and label tables.
- **Shared with other folders:** Needs `Data/` folder paths, engine globals such as `menuIndexCount`, `mainMenuIndex`, `menuBar`, `gObjects`, `gCurObject`, `gNumObjects`, `gLastMenuPick`, `LibStartVal`, `oldChar`, `lastLoadedFile`, and engine calls like `item`, `OPEN_UI_WINDOWS`, `make`, `get`, `loadLevel`, `save_*`, `getSceneInfo`, `lfs.dir`, `dofile`, `make_current`, `hide`, `editingModeSwitch`. Other menu files and game scripts take from this folder for menu bar construction, menu pick routing, and shared menu state.
- **Procedure candidates:** `fluid_menu_functions.lua` generates menu lines from the Fluid folder contents via `lfs.dir` and `getSceneInfo`; `levels_menu_functions.lua` generates menu entries by scanning `Data/Levels/` folder contents and mapping level folders to menu lines; `mesh_menu_functions.lua` generates mesh menu index entries from `MeshMenuText` tables and default WTF/OBJ/3DS/Meshwork file paths under `Data/` via `fastFilePaths`.
- **Glossary:**
  - `menuBar` - FLTK UI widget container used to display menu labels and add menu lines.
  - `menuIndexCount` - Global counter tracking the number of existing menu items used to compute menu index positions.
  - `mainMenuIndex` - Global table/value used as the base index for menu labels and to resolve menu actions.
  - `fill_*Menu` - Functions that populate individual menu sections of the application menu bar from label tables and folder contents.
  - `menu pick` - Functions that route selected menu rows to matching engine UI windows, browsers, or editors.
  - `Data/` - Folder holding game assets, scripts, and level folders, referenced by relative path concatenation in code.
  - `OPEN_UI_WINDOWS` - Engine call used to open UI windows for menu pick routing.
  - `lfs.dir` - Function used to list files in folders for menu population.
- **Verdict:** keep - These files form the complete, reusable menu system for the iGame3D engine; they define all menu sections, their label tables, fill logic, and pick routing, and are depended upon by other game scripts and menus.
