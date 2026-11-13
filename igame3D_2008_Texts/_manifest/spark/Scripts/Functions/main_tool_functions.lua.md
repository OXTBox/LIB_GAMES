<!-- Spark first-look of Data/Scripts/Functions/main_tool_functions.lua (model spark-x2.6-4b, 2026-11-12 06:58). DRAFT for Claude to review. -->

## main_tool_functions.lua
- **Kind:** tool
- **Purpose:** This file provides the main tools UI logic for iGame3D, handling button clicks for the main tools interface, building the main tools window with its icon groups, menu bar, and associated callbacks, and defining the global tables used to manage the tools UI state.
- **Depends on:** Other Scripts files (edit functions, UI helper functions), globals set elsewhere (buttonID, oldButton, UIMainTools, iconFiles, toolButton, imageFile), Data folder paths (Data/Fluid, Data/Icons/MainTools), and engine calls (dofile, fltk UI calls).
- **Provides:** Global tables `iconFiles` and `toolButton` (with empty `button` and `file` sub-tables), the `MainToolsClick` function for routing main tools button clicks, and the `UI_MAINTOOLS_WINDOW` function for building the main tools UI window.
- **Assets it needs:** Images from Data/Icons/MainTools/ (exact file names not specified in provided code).
- **Procedural:** none
- **Glossary:**
  - `ig3d_object` - Engine object kind used as the first argument of make/get calls to reference objects.
  - `IG3D_...` - Engine property constants naming the property read or set in object/scene/camera/light/material calls.
  - `dofile` - Engine call that loads a Lua file from a path.
  - `loadLevel` - Engine call that switches the active game or demo level.
  - `fltk:` - User interface module used for building FLTK UI elements.
  - `Data/` - Folder where all game assets and code live, referenced in path strings.
  - `toolButton` - Global table used to manage state of main tools UI buttons.
  - `iconFiles` - Global table used to manage icon file references for the main tools UI.
- **Keep / port / drop:** keep (core UI logic for main tools interface, reusable reference for new engine tool UI implementation)

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the global `iconFiles` and `toolButton` tables used by the main tools UI, containing empty `button`, `file` sub-tables.
- **Uses:** nothing
- **Reusable:** yes

### MainToolsClick
- **Does:** Handles clicks on the main tools buttons by reading the button label, toggling button state, and routing to the corresponding edit functions or UI windows based on the button ID.
- **Uses:** Engine calls (`w:label()`, `w:value()`, `dofile(...)`), globals (`buttonID`, `oldButton`, `ModelsBrowser`, `lightswindow`, `colorswindow`, `console`, `WTFBrowserNew`, `mesheditor`, `ZGS_Maker`, `ParticleBrowser`, `TextboxBrowser`, `gameroot`), file paths (`Data/Fluid/...`), and UI helpers (`lookbutton()`, `toggleQuadView()`, `editingModeSwitch()`, `OPEN_UI_WINDOWS()`, `openfile()`, `fltk_update()`).
- **Reusable:** no

Wait, the instructions say if there is code outside any function, start with `### Top level`. The code after the function ends has `iconFiles={}` etc. which is outside the function, so that goes in Top level. But the Top level section should describe only what the code shows. Let me correct:

### Top level
- **Does:** Defines global tables `iconFiles` and `toolButton` (with empty `button` and `file` sub-tables) used for the main tools UI.
- **Uses:** nothing
- **Reusable:** yes

### MainToolsClick
- **Does:** Handles clicks on the main tools buttons by reading the button label, toggling button state, and routing to the corresponding edit functions or UI windows based on the button ID.
- **Uses:** Engine calls (`w:label()`, `w:value()`, `dofile(...)`), globals (`buttonID`, `oldButton`, `ModelsBrowser`, `lightswindow`, `colorswindow`, `console`, `WTFBrowserNew`, `mesheditor`, `ZGS_Maker`, `ParticleBrowser`, `TextboxBrowser`, `gameroot`), file paths (`Data/Fluid/...`), and UI helpers (`lookbutton()`, `toggleQuadView()`, `editingModeSwitch()`, `OPEN_UI_WINDOWS()`, `openfile()`, `fltk_update()`).
- **Reusable:** no

Wait, the rules say "Mention a call, global or path only if it appears in the code you were given." All those do appear. But let's make it shorter as per "short, exact notes". Also, the Top level code is outside the function, so that's correct.

Wait, the file says "Functions in this part: MainToolsClick" and "This part is the start of the file." So the Top level code is part of this part, so it should be included.

Let me adjust to be more concise:

### Top level
- **Does:** Defines global tables `iconFiles` and `toolButton` (

## Part 2 of 2

### Top level
- **Does:** Contains the `UI_MAINTOOLS_WINDOW` function, which sets up the main tools window and its associated UI elements.
- **Uses:** Engine UI calls (`fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Shared_Image.get`, `fltk.fl_register_images`), globals (`UIMainTools`, `toolButton`, `iconFiles`, `imageFile`), file paths (`Data/Icons/MainTools/`), and UI helper functions (`fixIcons`, `FillMenuBar`, `main_menu_callback`, `MainToolsClick`, `UIMainToolsCB`).
- **Reusable:** no

### UI_MAINTOOLS_WINDOW
- **Does:** Builds and configures the UI main tools window, creates a group for icon buttons from the MainTools icon folder, adds a menu bar, and finalizes the window setup including icon fixing and menu bar population.
- **Uses:** Engine UI calls (`fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `fltk:Fl_Shared_Image.get`, `fltk.fl_register_images`), globals (`UIMainTools`, `toolButton`, `iconFiles`, `imageFile`), file paths (`Data/Icons/MainTools/`), and UI helper functions (`fixIcons`, `FillMenuBar`, `main_menu_callback`, `MainToolsClick`, `UIMainToolsCB`).
- **Reusable:** no
- **Procedural:** no
