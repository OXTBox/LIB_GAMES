<!-- Spark first-look of Data/Scripts/Functions/dungeon_functions.lua (model spark-x2.6-4b, 2026-11-12 06:46). DRAFT for Claude to review. -->

## dungeon_functions.lua
- **Kind:** library
- **Purpose:** This file provides shared setup and helper routines for the iGame3D dungeon and map mapper workflows, including DSB conversion helpers, grid and button management, dungeon parsing, and mapper UI wiring. It supports the DSB text-to-map conversion flow and the interactive dungeon map browser used by the engine's dungeon and level systems.
- **Depends on:** Other Scripts files (DSB conversion libraries, `makenewdsbtext`, `parseDungeon`, `ButtonSpawnXY`), `Data/` folders (Scripts/Convert, WTF/Dungeons), globals set elsewhere (`gObjects`, `gameroot`, `gMapFile`, `gMapName`, `currentMapLevel`, `textArray`, `GridSize`, `DungeonMapperWindow`, `MapperMenuIndex`, `MapperMenuText`), and engine calls (`dofile`, `loadLevel`, `loadstring`, `lfs.dir`).
- **Provides:** Functions such as `BtnBrowserListMaps`, `ulistBtnList`, `saveBSDMAP`, `saveMappedXY`, `saveMapDSBInsertTextMapOut`, `wClose`, `gridcb`, `startGrid`, `stackcb`, `quadGrid`, `resetAllButtons`, `resetGrid`, `resetDSB`, `resetMapper`, `parseTextMapXY`, `MapListCurrentPick`, `openMapFiles`, `fillMapperSourceMenu`, `fillMapperControlMenu`, `MapperCurrentPick`, `MapperBrowsersMenuPick`, `Mapper_menu_callback`, `Mapper_MenuBarFill`, plus nested mapper UI widgets and menu tables (`MapperMenuIndex`, `MapperMenuText`, `MapperMenuText.Source`, `MapperMenuText.Maps`).
- **Assets it needs:** None named as required assets (no models, images, sounds, emitters, or fonts are read or written by the code).
- **Procedural:** Generates UI button code and map/DSB conversion scripts from numeric grid coordinates, text arrays, and map data rules (e.g., `startGrid` builds FLTK button code via `loadstring`, `saveBSDMAP`/`saveMapDSBInsertTextMapOut` write generated Lua conversion scripts, `openMapFiles` generates a map table string from level map coordinates).
- **Glossary:**
  - `DSB conversion` - The iGame3D text-to-map conversion flow that translates text map data into 3D dungeon maps.
  - `map level` - A specific dungeon or level folder/level identifier used to select game content.
  - `grid button` - A FLTK button representing a grid cell coordinate for dungeon map editing.
  - `map text array` - The text-based map data array used to build dungeon maps and mapper UI.
  - `mapper window` - The FLTK window used to browse and edit dungeon maps interactively.
  - `dofile` - Engine call that loads a Lua file from a path.
  - `loadstring` - Engine call that compiles and runs a dynamically constructed Lua string.
  - `dsb_text2map` - Engine call that wraps a text-to-map conversion script for use in the DSB flow.
- **Keep / port / drop:** keep - Core helper routines and mapper UI wiring are reusable reference material for building dungeon/map tooling in a new engine.

---

# Part notes

## Part 1 of 10

### Top level
- **Does:** Defines shared setup variables and loads the DSB conversion scripts before the `BtnBrowserListMaps` function is defined.
- **Uses:** Globals (`gObjects`, `gameroot`), files (`Data/Scripts/Convert/DSB_global.lua`, `Data/Scripts/Convert/DSB_Dungeons.lua`), engine calls (`dofile`).
- **Reusable:** no

### BtnBrowserListMaps
- **Does:** Clears the map browser button list, populates it with one entry per map in the DSB conversion table, and triggers a redraw of the browser button.
- **Uses:** Globals (`BtnBrowser`, `dsbtext2map`, `BtnListBrowser`), engine calls (`BtnListBrowser:clear`, `BtnListBrowser:add`, `BtnBrowser:redraw`).
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 10

### Top level
- **Does:** No top-level code outside the three listed functions; the file begins directly with the function definitions.
- **Uses:** nothing
- **Reusable:** no

### ulistBtnList
- **Does:** Rebuilds the button list browser UI, filters valid button list entries, and restores the last selected button position when available.
- **Uses:** Engine/UI calls (`BtnBrowser:make_current()`, `BtnListBrowser:value()`, `BtnListBrowser:clear()`, `BtnListBrowser:add()`, `BtnListBrowser:redraw()`, `BtnListBrowser:select()`, `BtnListBrowser:value()`, `BtnListBrowser:selected()`, `DungeonMapperWindow:make_current()`), globals (`God`, `BtnListBrowserIndex`, `btnListXY`, `gLastSelection`), and UI widget references (`BtnBrowser`, `BtnListBrowser`, `DungeonMapperWindow`).
- **Reusable:** no

### uBtnListBrowserControlDoubleClicked
- **Does:** Invokes the button list rebuild routine when the browser control is double-clicked.
- **Uses:** Engine/UI call (`ulistBtnList()`), no direct engine calls, globals, files or Data/ paths.
- **Reusable:** no

### uBtnListBrowserControlClicked
- **Does:** Handles single clicks on the button list browser control: triggers the double-click routine if the click repeats within 0.4 seconds, otherwise selects the clicked button via `MapListCurrentPick`.
- **Uses:** Engine/UI calls (`w:value()`, `uBtnListbrowserControlDoubleClicked(w)`, `MapListCurrentPick(n)`), globals (`gLastBrowserControlClick`, `gLastSelection`), and the clicked widget `w`.
- **Reusable:** no

## Part 3 of 10

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### saveBSDMAP
- **Does:** Writes a DSB text-to-map conversion script to a user-selected Lua file, building the output string from the text array and wrapping it in a `dsb_text2map` call.
- **Uses:** `chooseFile`, `MapTextFld`, `MapTextWindow`, `io.open`, `gameroot`, `Data/WTF/Dungeons/` path, `gMapFile`, `gMapName`, `textArray`, `Q`, `dsb_text2map`, `fileShortNameFromPath`
- **Reusable:** no

### saveMappedXY
- **Does:** Writes a level map XY coordinate table to a generated Lua file under the Dungeons folder, using the current map level and map name.
- **Uses:** `currentMapLevel`, `gMapName`, `gMapOutFile`, `io.open`, `gameroot`, `Data/WTF/Dungeons/` path, `textmapXY`, `CBI`, `CBO`
- **Reusable:** no

### saveMapDSBInsertTextMapOut
- **Does:** Writes a DSB text-to-map conversion script to a generated Lua file under the Dungeons folder, appends the map text entries and the `dsbtext2map` table entry, then loads the generated file with `dofile`.
- **Uses:** `currentMapLevel`, `gMapName`, `gMapOutFile`, `io.open`, `gameroot`, `Data/WTF/Dungeons/` path, `textArray`, `dsbtext2map`, `Q`, `CBI`, `CBO`, `dofile`
- **Reusable:** no

## Part 4 of 10

### Top level
- **Does:** No top-level code outside the three defined functions; the file only contains the function definitions for `wClose`, `gridcb`, and `startGrid`.
- **Uses:** Globals referenced inside the functions: `Fl`, `fltk`, `math`, `string`, `table`, `randomColor`, `newcolor`, `tt`, `xt`, `x`, `y`, `n`, `xys`, `s`, `i`, `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`, `GridSpread`, `Q`, `DungeonMapperWindow`, `makeabutton`, `baseBtnColor`, `x0y0`, `keeper`. No `Data/` paths, engine object calls, or asset files are read or written.
- **Reusable:** no

### wClose
- **Does:** Hides the given button widget and sets the widget reference to `nil` to release it.
- **Uses:** Engine UI widget calls (`w:hide()`), no engine object calls, globals, or files.
- **Reusable:** yes

### gridcb
- **Does:** Handles button click events: reads the button tooltip to extract grid coordinates, updates the button list and coordinate maps, sets the button color and value, and triggers a UI refresh.
- **Uses:** UI widget calls (`w:tooltip()`, `w:color()`, `w:value()`), engine UI event call (`Fl:event_key()`), globals (`randomColor`, `newcolor`, `tt`, `xt`, `x`, `y`, `n`, `xys`, `s`, `i`, `btnList`, `textmapXY`, `btnListXY`, `serialXY`, `textArray`, `GridSize`), and no files or `Data/` paths.
- **Reusable:** yes

### startGrid
- **Does:** Initializes the grid button arrays, generates FLTK button code for each grid cell, loads the generated button code via `loadstring`, and triggers UI redraws for the button keeper and dungeon mapper window.
- **Uses:** UI widget calls (`fltk.fl_color()`, `fltk.FL_FLAT_BOX`, `fltk:Fl_Button()`), globals (`textArray`, `btnListXY`, `randomColor`, `fltk`, `GridSize`, `GridSpread`, `Q`, `DungeonMapperWindow`, `makeabutton`, `baseBtnColor`, `x0y0`, `keeper`), and no `Data/` paths, engine object calls, or files.
- **Reusable:** no

## Part 5 of 10

### Top level
- **Does:** No top-level code outside the function definitions; the file begins with blank lines before the first function.
- **Uses:** nothing
- **Reusable:** no

### stackcb
- **Does:** Handles the space key event to toggle the color map display, then updates the FLTK UI state.
- **Uses:** `Fl:event_key()`, `fltk.fl_show_colormap(randomColor)`, `fltk_update()`, `Fl:check()`
- **Reusable:** no

### quadGrid
- **Does:** Deletes the current mesh, loads wall/floor assets for the current map level, iterates grid wall and floor coordinates to draw or copy them, then saves the combined mesh and resets mesh selection.
- **Uses:** `ig3d_DeleteMesh_b`, `loadTheWalls`, `loadTheFloor`, `parseDungeon`, `render`, `ig3d_ShowAll`, `ig3d_SelectWholeMesh`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_GetNumberOfPolys__i`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `ig3d_InvertMeshSelection`, plus globals `WEWall`, `NSWall`, `TheFloor`, `quadwalls`, `textmapXY`, `gridSize`, `currentMapLevel`, `gMapName`, `gameroot`
- **Reusable:** no

### resetAllButtons
- **Does:** Builds a string that resets all grid button colors to the base button color, then loads that string as a new function to clear all buttons.
- **Uses:** globals `baseBtnColor`, `GridSize`
- **Reusable:** yes

### resetGrid
- **Does:** Initializes empty button and text coordinate arrays, and pre-fills a text array with zero values for all grid positions.
- **Uses:** globals `GridSize`
- **Reusable:** yes

## Part 6 of 10

### Top level
- **Does:** The file contains no setup, global definitions, or widget definitions outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### resetDSB
- **Does:** Resets all global state variables used by the DSB dungeon generation flow, then loads the DSB conversion libraries from the Data folder.
- **Uses:** globals (listSpawnxy, spawnXY, XYSpawned, dsbspawn, spawninpack, exvar, dsbaddchampion, dsbtext2map, wallset, spawngrid, spawnindex, spawntext, foundindex, level, which), engine calls (dofile with paths `gameroot.."Data/Scripts/Convert/DSB_global.lua"` and `gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua"`), and calls to newbsdtext2Map().
- **Reusable:** no

### resetMapper
- **Does:** Resets all global state variables used by the dungeon mapper flow, clears the button lists, resets the grid, and triggers a redraw of the mapper window.
- **Uses:** globals (GridSize, GridSpread, vgridwidth, vgridlength, vcubewidth, vcubelength, vcubeheight, gridSize, quadSize, WEWall, NSWall, TheFloor, grpGrid, drpGrid, drpColors, btnMakeList, btnList, cubewalls, quadwalls), engine calls (ClearAllButtons(), resetGrid(), DungeonMapperWindow:redraw()), and references to the DungeonMapperWindow widget.
- **Reusable:** no

### parseTextMapXY
- **Does:** Iterates over the textmapXY coordinate pairs, clamps each coordinate to GridSize, generates a button name, and if the mapper window exists, loads and runs a string that colors the corresponding button.
- **Uses:** globals (textmapXY, GridSize, dsbtext2mapButtonChanges), engine calls (loadstring with dynamically constructed code, and the generated button's color method), and references to the DungeonMapperWindow widget.
- **Reusable:** no

## Part 7 of 10

### Top level
- **Does:** No functions defined at top level; the file content is entirely contained within the `MapListCurrentPick` function.
- **Uses:** Globals `textArray`, `GridSize`, `currentMapLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `CBI`, `CBO`, `gMapFile`, `resetMapper`, `parseDungeon`, `fltk_update`.
- **Reusable:** no

### MapListCurrentPick
- **Does:** Builds a formatted string from the `textArray` by cycling through its elements in groups of `GridSize`, then updates the current map level, regenerates the map text table via `makenewdsbtext`, resets the mapper, parses the selected dungeon, and refreshes the FLTK UI.
- **Uses:** Globals `textArray`, `GridSize`, `currentMapLevel`, `dsbtext2map`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `CBI`, `CBO`, `gMapFile`, `resetMapper`, `parseDungeon`, `fltk_update`. Files/paths: none directly read or written in this function.
- **Reusable:** no
- **Procedural:** yes

## Part 8 of 10

### Top level
- **Does:** Defines the `DungeonMapperWindow` FLTK window and its nested scroll/group widgets, plus the `MapperMenuIndex`, `MapperMenuText`, and `MapperMenuText.Source`/`MapperMenuText.Maps` tables used by the dungeon map mapper menu functions.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `gLabelTable`, `DungeonMapperWindow:label`, `DungeonMapperWindow:callback`, `DungeonMapperWindow:resize`, `DungeonMapperWindow:when`, `DungeonMapperWindow:size_range`, `DungeonMapperWindow:show`, and the global `gLabelTable`.
- **Reusable:** no

### openMapFiles
- **Does:** Opens a dungeon map file, processes its level map data, builds a map table string, executes it to populate the map table, and if there is existing map data, refreshes the dungeon map browser and parses the current dungeon level.
- **Uses:** `chooseFile`, `dofile`, `fileShortNameFromPath`, `resetMapper`, `resetDSB`, `zeromap`, `zeroline`, `textArray`, `levelmapXY`, `dsbtextsethead`, `currentText2MapTable`, `makenewdsbtext`, `BtnBrowserListMaps`, `parseDungeon`, `gMapFile`, `gMapName`, `currentMapLevel`, `GridSize`, `tTitle`, `tFile`, `CBI`, `CBO`, `Q`, `lfs.dir` (not directly called here, only listed as available engine context), and `Data/` paths via `gameroot.."Data/WTF/Dungeons/"`.
- **Reusable:** no
- **Procedural:** yes - it generates a map table string from level map coordinates and executes it to set up the dungeon map data structure.

## Part 9 of 10

### Top level
- **Does:** No top-level code outside the three function definitions is present in the provided file.
- **Uses:** nothing
- **Reusable:** no

### fillMapperSourceMenu
- **Does:** Populates the mapper source menu with File/ entries from the mapper source text, adds a trailing empty line, and refreshes the menu and index.
- **Uses:** globals `BtnBrowser`, `MapperMenuText.Source`, `MapperMenu`, `MapperMenuIndex`; no engine calls, Data paths, or files read/written.
- **Reusable:** yes

### fillMapperControlMenu
- **Does:** Adds empty menu lines, a Convert/to 3D entry, and additional empty lines to the mapper control menu, then refreshes the menu, index and UI.
- **Uses:** globals `MapperMenu`, `MapperMenuIndex`; no engine calls, Data paths, or files read/written.
- **Reusable:** yes

### MapperCurrentPick
- **Does:** Prints the pick value and map file path, resets the mapper, loads the map file and its spawn script, sets the current map level if unset, parses the dungeon, and refreshes UI elements.
- **Uses:** globals `gMapFile`, `BtnBrowser`, `currentMapLevel`, `BSDDungeonSpawnsOut`; calls `dofile`, `parseDungeon`, `ButtonSpawnXY`, `BtnBrowserListMaps`, `BtnBrowser:redraw`, `fltk_update`, `quadGrid`; no Data paths read/written.
- **Reusable:** no

### MapperBrowsersMenuPick
- **Does:** Handles browser menu picks: resets and loads a new map for "New", opens map files for "Open", saves mapped XY for "Save ig3d", and saves the BSD text map for "Save BSD Text".
- **Uses:** globals `BtnBrowser`, `resetMapper`, `newbsdtext2Map`, `currentMapLevel`, `dsbtext2map`, `parseDungeon`, `BtnBrowserListMaps`, `BtnBrowser:redraw`, `fltk_update`; calls `dofile` is not present; no Data paths read/written.
- **Reusable:** no

## Part 10 of 10

### Top level
- **Does:** No setup, globals, widget definitions, or other top-level code exists in this file beyond the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### Mapper_menu_callback
- **Does:** Handles the Mapper menu button callback: reads the button's label, value, and text, maps the value to menu index values, prints debug output, and based on the selected menu item either triggers the browser menu pick or the quadGrid conversion.
- **Uses:** `w:label()`, `w:value()`, `w:text()` (FLTK widget calls), `MapperMenuIndex` (global table), `item(1, index, "/")` (engine call), `MapperBrowsersMenuPick(tPick)` (global function call), `quadGrid()` (global function call), `print()` (Lua built-in).
- **Reusable:** no

### Mapper_MenuBarFill
- **Does:** Fills the Mapper source and control menus by calling the two fill functions for the source and control menus.
- **Uses:** `BtnBrowser` (global flag/object reference), `fillMapperSourceMenu()` (global function call), `fillMapperControlMenu()` (global function call).
- **Reusable:** no
