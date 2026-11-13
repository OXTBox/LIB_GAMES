<!-- Spark first-look of Data/Scripts/Functions/main_tool_functions.lua (model spark-x2.6-4b, 2026-11-12 20:46). DRAFT for Claude to review. -->

## main_tool_functions.lua
- **Kind:** tool
- **Purpose:** This file provides main tools click handling and the setup routines for the main tools UI window. It manages button clicks in the main tools window, toggles UI windows and editing modes, opens FLTK UI files, and builds the main tools window with its icon buttons, menu bar, and icon fixer.
- **Depends on:** Globals `getSceneInfo`, `IG3D_ROOT`; `Data/` paths for `Fluid/Lights/Lights.fl`, `Fluid/Colors/Colors.fl`, `Fluid/console/console.fl`, `Fluid/WTFbrowser/WTFbrowser.fl`, `Fluid/mesh_editor/mesh_editor.fl`, `Fluid/UDG_Options/UDG_Options.fl`, `Fluid/ParticleBrowser/ParticleBrowser.fl`, `Fluid/TextboxBrowser/TextboxBrowser.fl`, and `Data/Icons/` via `iconPath`; engine calls `w:label()`, `Fl:event_key()`, `w:value()`, `dofile()`, `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `fltk.fl_register_images`, `Fl_Shared_Image.get`, `Fl_Group:current`, `UIMainTools`, `UIMainToolsCB`, `main_menu_callback`, `Fl:scheme`, `UIMainTools:make_current`, `fixIcons`, `FillMenuBar`; globals `oldButton`, `ModelsBrowser`, `lightswindow`, `colorswindow`, `console`, `WTFBrowserNew`, `mesheditor`, `ZGS_Maker`, `ParticleBrowser`, `TextboxBrowser`, `editingModeSwitch()`, `OPEN_UI_WINDOWS()`, `openfile()`, `lookbutton()`, `toggleQuadView()`, `EmitBrowserValueCatch()`, `listTextBoxes()`, `fltk_update()`; `lfs.dir`, `string.sub`, `string.len`, `string.gsub`; `Data/Icons/MainTools/` path.
- **Provides:** `MainToolsClick`, `UI_MAINTOOLS_WINDOW`, `UIMainToolsCB`, `fixIcons`, `FillMenuBar`, `main_menu_callback`, `editingModeSwitch()`, `OPEN_UI_WINDOWS()`, `openfile()`, `lookbutton()`, `toggleQuadView()`, `EmitBrowserValueCatch()`, `listTextBoxes()`, `fltk_update()`.
- **Assets it needs:** none named (only `Data/Icons/` and `Data/Icons/MainTools/` paths are referenced, no specific model, image, sound, emitter or font file names are listed).
- **Procedural:** yes (creates FLTK UI window, icon button group, menu bar, and icon fixer objects from code rules and `lfs.dir` listing).
- **Glossary:**
  - FLTK UI file - FLUID designer text file (`Fl_Window`, `Fl_Button` etc.) used to build FLTK windows.
  - `IG3D_ROOT` - engine global used to build `Data/` paths for loading files.
  - `dofile` - engine call that loads a Lua file from a path.
  - `loadLevel` - engine call that switches the active level folder (background, not in this file's code; omit).
  - `fltk_update` - engine call used to refresh FLTK UI state.
- **Keep / port / drop:** keep - core tools UI setup and click handling reference for building new engine tools.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Contains the file-level setup code outside functions, including the `iconFiles={}` initialization and the `iconPath`/`toolButton` variable definitions.
- **Uses:** Globals `getSceneInfo`, `IG3D_ROOT`, and `Data/` path construction via string concatenation.
- **Reusable:** no

### MainToolsClick
- **Does:** Handles button clicks in the main tools window, toggling UI windows, switching editing modes, and opening FLTK UI files based on the clicked button label.
- **Uses:** Engine calls `w:label()`, `Fl:event_key()`, `w:value()`, `dofile()`, `getSceneInfo()`, `IG3D_ROOT`; globals `oldButton`, `ModelsBrowser`, `lightswindow`, `colorswindow`, `console`, `WTFBrowserNew`, `mesheditor`, `ZGS_Maker`, `ParticleBrowser`, `TextboxBrowser`, `editingModeSwitch()`, `OPEN_UI_WINDOWS()`, `openfile()`, `lookbutton()`, `toggleQuadView()`, `EmitBrowserValueCatch()`, `listTextBoxes()`, `fltk_update()`; `Data/` paths for `Fluid/Lights/Lights.fl`, `Fluid/Colors/Colors.fl`, `Fluid/console/console.fl`, `Fluid/WTFbrowser/WTFbrowser.fl`, `Fluid/mesh_editor/mesh_editor.fl`, `Fluid/UDG_Options/UDG_Options.fl`, `Fluid/ParticleBrowser/ParticleBrowser.fl`, `Fluid/TextboxBrowser/TextboxBrowser.fl`, and `Data/Icons/` via `iconPath`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### UI_MAINTOOLS_WINDOW
- **Does:** Sets up the main tools window, its icon button group, menu bar, and icon fixer, then shows the window and activates it.
- **Uses:** `getSceneInfo`, `IG3D_ROOT`, `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `lfs.dir`, `string.sub`, `string.len`, `string.gsub`, `fltk.FL_THIN_UP_BOX`, `fltk.FL_BORDER_BOX`, `fltk.fl_register_images`, `Fl_Shared_Image.get`, `Fl_Group:current`, `UIMainTools`, `UIMainToolsCB`, `main_menu_callback`, `Fl:scheme`, `UIMainTools:make_current`, `fixIcons`, `FillMenuBar`, `Data/Icons/MainTools/` path
- **Reusable:** no
- **Procedural:** yes

### UIMainToolsCB
- **Does:** Drives the main tools window setup sequence, including icon collection, button creation, menu bar configuration, and final window activation.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `lfs.dir`, `string.sub`, `string.len`, `string.gsub`, `fltk.FL_THIN_UP_BOX`, `fltk.FL_BORDER_BOX`, `fltk.fl_register_images`, `Fl_Shared_Image.get`, `Fl_Group:current`, `UIMainTools`, `UIMainToolsCB`, `main_menu_callback`, `Fl:scheme`, `UIMainTools:make_current`, `fixIcons`, `FillMenuBar`, `Data/Icons/MainTools/` path
- **Reusable:** no
- **Procedural:** yes
