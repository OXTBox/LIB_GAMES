<!-- Spark first-look of Data/Fluid/ClassesBrowser/ClassesBrowser.lua (model spark-x2.6-4b, 2026-11-12 20:31). DRAFT for Claude to review. -->

## ClassesBrowser.lua
- **Kind:** ui-dialog
- **Purpose:** Defines the ClassesBrowser UI component and its supporting class/entity configuration tables, WTF asset browsing and preview logic, and the FLTK event loop setup for the class list browser. It brings up the ClassesBrowser window, refreshes its view, lists and filters WTF files, renders WTF previews, and runs the FLTK event loop for the class browser widgets.
- **Depends on:** `ClassesBrowser` (component), `ClassListBrowser`, `AddClassInput`, `ClassObjectsGroup`, `ClassObjectsBrowser`, `AddObjectBtn`, `DeleteObjectBtn`, `WTFBrowserGroup`, `cWTFFileBrowser`, `cWTFPreviewBox`, `cWTFPreviewNote`, `gLabelTable`, `gDefaultEntityClasses`, `gHumanNames`, `RTSENTITIES`, `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`, `gObjects`, `gDropObject`, `make`, `loadMesh`, `loadLevel`, `gameroot`, `Data/` paths (`Data/WTF/`, `Data/Images/Colors/white.png`), `lfs.dir`, `lfs.attributes`, `lfs.mkdir`, `lfs.`, `fltk.`, `Fl_...`, `fltk_update`, `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Input`, `fltk:Fl_Box`, `Fl:run`, `ig3d_CreateDirectory_s`, `ig3d_SetWindowBounds_4i`, `gGLX`, `gGLY`, `gGLR`, `gGLB`, `createWTFPreviewPNG`, `goDirsUp`, `uclistWTFFiles`, `ClassesBrowserCatch`, `ClassListBrowserClicked`, `cWTFAddObjectClicked`, `cWTFPreviewLoadMesh`, `ucreatePreviewsClicked`, `cWTFbrowserControlDoubleClicked`, `cWTFbrowserControlClicked`, `ChangeGameType`, `w:value()`, `time`, `gLastBrowserControlClick`, `guLastSelection`, `Fl_Shared_Image.get()`, `fltk.fl_register_images()`, `print`, `string.sub`, `string.gsub`, `table.insert`, `table.insert`
- **Provides:** `ClassesBrowserCatch`, `uclistWTFFiles`, `updatecWTFPreviewBox`, `cWTFAddObjectClicked`, `cWTFPreviewLoadMesh`, `ucreatePreviewsClicked`, `cWTFbrowserControlDoubleClicked`, `cWTFbrowserControlClicked`, `ClassListBrowserClicked`, `ChangeGameType`, plus the shared global class/entity tables (`gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`)
- **Assets it needs:** `Data/WTF/` folder files, `Data/Images/Colors/white.png`
- **Procedural:** none
- **Glossary:**
  - `WTF file` - 3D model assets stored in the `Data/WTF/` folder with a "iGame3D Mdl" text format
  - `WTF preview PNG` - generated PNG assets created for selected WTF files or folders to display previews
  - `ClassesBrowser` - the FLTK UI component for browsing and managing entity classes
  - `WTF file browser` - the FLTK browser widget used to list and navigate files inside the WTF folder
  - `ig3d_CreateDirectory_s` - engine call that creates a directory in the game data folder
  - `ig3d_SetWindowBounds_4i` - engine call that sets the bounds of the GLX window
- **Keep / port / drop:** keep - core UI browsing and preview logic reusable for new engine class and asset management

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines shared global state and class tables used by the file browser and related scripts. The top level also sets up global browser state variables and window bounds before the function definitions.
- **Uses:** Globals `gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, and tables `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`.
- **Reusable:** yes - the global class and entity table definitions are reusable shared configuration.

### ClassesBrowserCatch
- **Does:** Brings up the ClassesBrowser UI, triggers its redraw, and updates the FLTK interface state to refresh the current view.
- **Uses:** Engine calls `ClassesBrowser:make_current()`, `ClassesBrowser:redraw()`, `fltk_update()`.
- **Reusable:** no - this is a UI refresh action tied to the ClassesBrowser component.

### uclistWTFFiles
- **Does:** Clears the WTF file browser contents, lists files and directories under the WTF folder, and adds valid WTF files and directory entries to the browser and the file list table.
- **Uses:** Globals `gcWTFBrowserPath`, `gcWTFBrowserFiles`, `cWTFFileBrowser`; engine calls `lfs.dir`, `lfs.attributes`; string operations `string.sub`; table operations `table.insert`. Path used: `gameroot.."Data/WTF/"`.
- **Reusable:** yes - the file listing and filtering logic for WTF assets is reusable for similar asset folder browsing.

### updatecWTFPreviewBox
- **Does:** Registers shared images, resolves the preview image path for the given WTF name, updates the preview note label, and renders the WTF preview image in the preview box.
- **Uses:** Globals `gcWTFBrowserPath`, `gameroot`; engine calls `fltk.fl_register_images()`, `Fl_Shared_Image.get()`; string operations `string.gsub`, `string.sub`; table/field access on `cWTFPreviewBox`, `cWTFPreviewNote`; `print`. Path used: `gameroot.."Data/Images/Colors/white.png"`.
- **Reusable:** yes - the preview image resolution and rendering logic is reusable for similar WTF preview display components.

## Part 2 of 4

### cWTFAddObjectClicked
- **Does:** Adds a newly selected WTF file as a new 3D object to the object list, creating the object from the file path.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gObjects`, `gDropObject`, `make`, `gameroot`, `Data/WTF/` path construction
- **Reusable:** no
- **Procedural:** no

### cWTFPreviewLoadMesh
- **Does:** Adds a newly selected WTF file as a new 3D object to the object list and loads its mesh.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gObjects`, `loadMesh`, `gameroot` path construction
- **Reusable:** no
- **Procedural:** no

### ucreatePreviewsClicked
- **Does:** Creates WTF preview PNG assets for a selected WTF file or folder, updates the preview box, and resizes the GLX window.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gcWTFBrowserPath`, `ig3d_CreateDirectory_s`, `createWTFPreviewPNG`, `updatecWTFPreviewBox`, `goDirsUp`, `gameroot`, `ig3d_SetWindowBounds_4i`, `gGLX`, `gGLY`, `gGLR`, `gGLB`
- **Reusable:** no
- **Procedural:** yes

### cWTFbrowserControlDoubleClicked
- **Does:** Navigates the WTF file browser path for a selected folder, loads the updated WTF file list, or adjusts the current WTF path when selecting the parent folder.
- **Uses:** `gcWTFBrowserFiles`, `gcWTFBrowserPath`, `goDirsUp`, `uclistWTFFiles`, `gameroot`, `Data/WTF/` path construction
- **Reusable:** no
- **Procedural:** no

## Part 3 of 4

### cWTFbrowserControlClicked
- **Does:** Checks whether the clicked WTF browser control has a non-zero value, then updates the WTF preview box for the selected file if it is a file, and records the click time and last selection for double-click handling.
- **Uses:** `gcWTFBrowserFiles`, `updatecWTFPreviewBox`, `time`, `gLastBrowserControlClick`, `guLastSelection`, `cWTFbrowserControlDoubleClicked`, `w:value()`
- **Reusable:** no
- **Procedural:** no

### ClassListBrowserClicked
- **Does:** Triggers the `ClassesBrowserCatch` action when the class list browser control is clicked.
- **Uses:** `ClassesBrowserCatch`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 4

### Top level
- **Does:** Sets up the ClassesBrowser window and its surrounding FLTK widgets, then runs the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Input`, `fltk:Fl_Box`, `lfs.dir`, `lfs.attributes`, `lfs.mkdir`, `gLabelTable`, `gDefaultEntityClasses`, `uclistWTFFiles`, `Fl:run`, `ClassesBrowser`, `ClassListBrowser`, `AddClassInput`, `ClassObjectsGroup`, `ClassObjectsBrowser`, `AddObjectBtn`, `DeleteObjectBtn`, `WTFBrowserGroup`, `cWTFFileBrowser`, `cWTFPreviewBox`, `cWTFPreviewNote`, `gameroot`
- **Reusable:** no

### ChangeGameType
- **Does:** Prints the current game type value, checks whether a matching Scripts folder already exists, creates the `_Entities` subfolder if it does not, and updates the game type input widget.
- **Uses:** `print`, `lfs.dir`, `lfs.attributes`, `lfs.mkdir`, `string.sub`, `w:value()`, `gameroot`, `gLabelTable`, `ClassesBrowser`, `ClassListBrowser`, `AddClassInput`, `uclistWTFFiles`, `Fl:run`
- **Reusable:** no
- **Procedural:** no
