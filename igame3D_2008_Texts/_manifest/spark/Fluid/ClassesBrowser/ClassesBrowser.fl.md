<!-- Spark first-look of Data/Fluid/ClassesBrowser/ClassesBrowser.fl (model spark-x2.6-4b, 2026-11-12 20:28). DRAFT for Claude to review. -->

## ClassesBrowser.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface definition for the iGame3D ClassesBrowser, which lets a programmer browse and manage entity classes, WTF model files, and game type settings inside the engine. It sets up the window and its widgets, wires the browser controls to their actions, and runs the initial setup that shows the browser and populates its class list.
- **Depends on:** `gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`, `gameroot`, `ig3d_GetWindowBounds__4i()`, `lfs.dir`, `lfs.attributes`, `string.sub`, `string.gsub`, `Fl_Shared_Image.get`, `print`, `ClassesBrowser:make_current()`, `ClassesBrowser:redraw()`, `fltk_update()`, `lfs.dir`, `lfs.attributes`, `string.sub`, `gcWTFBrowserPath`, `gcWTFBrowserFiles`, `cWTFFileBrowser:clear()`, `cWTFFileBrowser:add()`, `table.insert`, `fltk.fl_register_images()`, `gameroot`, `Fl_Shared_Image.get`, `cWTFPreviewBox:color()`, `cWTFPreviewNote:label()`, `cWTFPreviewBox:w()`, `cWTFPreviewBox:h()`, `cWTFPreviewBox:image()`, `cWTFPreviewBox:redraw()`, `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gObjects`, `gDropObject`, `make(ig3d_object, ...)`, `loadMesh(...)`, `ig3d_CreateDirectory_s`, `createWTFPreviewPNG`, `goDirsUp`, `ig3d_SetWindowBounds_4i`, `gGLX`, `gGLY`, `gGLR`, `gGLB`, `ClassesBrowser:show()`, `ClassListBrowser:add()`, `Data/` paths referenced by the WTF browser setup, `w:value()`
- **Provides:** `make_window`, `ClassesBrowserCatch`, `uclistWTFFiles`, `updatecWTFPreviewBox`, `cWTFAddObjectClicked`, `cWTFPreviewLoadMesh`, `ucreatePreviewsClicked`, `cWTFbrowserControlDoubleClicked`, `cWTFbrowserControlClicked`, `ClassListBrowserClicked`, `ChangeGameType`, and the ClassesBrowser window/widget setup code
- **Assets it needs:** none named as required assets (WTF files are listed dynamically via `lfs.dir` from the `Data/WTF/` folder)
- **Procedural:** yes — generates WTF preview PNG assets for selected WTF files/folders via `createWTFPreviewPNG`, and creates the Entities subfolder in the Scripts folder when a new game type is selected
- **Glossary:**
  - `WTF file` - iGame3D 3D model files in the `Data/WTF/` folder, loaded with `make(ig3d_object, "file.wtf")`
  - `WTF browser` - FLTK browser widget used to list and select WTF files and folders
  - `entity class` - a predefined set of entity types (humans, cars, zombies, etc.) managed by `gDefaultEntityClasses`
  - `game type` - a selected value that triggers scanning of the Scripts folder and folder creation for a new game
  - `ClassesBrowser` - the FLTK UI window that provides the class browsing and management interface
- **Keep / port / drop:** keep - a complete reference for the iGame3D FLTK UI pattern for browsing model assets and managing entity classes

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines the top-level setup for the ClassesBrowser FLTK UI file, including the initial class and entity data tables, the WTF browser state variables, and the window bounds constants.
- **Uses:** `gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, `gObjects`-style shared tables (`humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`), `gameroot`, `ig3d_GetWindowBounds__4i()`, `lfs.dir`, `lfs.attributes`, `string.sub`, `string.gsub`, `Fl_Shared_Image.get`, `print`.
- **Reusable:** no

### make_window
- **Does:** Defines the `make_window` function for the ClassesBrowser UI, which opens the window with an empty body.
- **Uses:** `gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`.
- **Reusable:** no

### ClassesBrowserCatch
- **Does:** Defines the `ClassesBrowserCatch` function, which makes the ClassesBrowser current, triggers a redraw, and updates the FLTK UI state.
- **Uses:** `ClassesBrowser:make_current()`, `ClassesBrowser:redraw()`, `fltk_update()`.
- **Reusable:** no

### uclistWTFFiles
- **Does:** Defines the `uclistWTFFiles` function, which clears the WTF file browser and lists WTF files and directories from the WTF folder, adding each to the file browser and the tracked file list.
- **Uses:** `lfs.dir`, `lfs.attributes`, `string.sub`, `gcWTFBrowserPath`, `gcWTFBrowserFiles`, `cWTFFileBrowser:clear()`, `cWTFFileBrowser:add()`, `table.insert`.
- **Reusable:** yes

### updatecWTFPreviewBox
- **Does:** Defines the `updatecWTFPreviewBox` function, which registers shared images, maps the WTF folder path to a preview folder path, resolves the preview image for a given name, updates the preview note label, and draws the image in the preview box.
- **Uses:** `fltk.fl_register_images()`, `gcWTFBrowserPath`, `string.gsub`, `string.sub`, `gameroot`, `Fl_Shared_Image.get`, `cWTFPreviewBox:color()`, `cWTFPreviewNote:label()`, `cWTFPreviewBox:w()`, `cWTFPreviewBox:h()`, `cWTFPreviewBox:image()`, `cWTFPreviewBox:redraw()`.
- **Reusable:** yes

## Part 2 of 4

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the four listed functions; the file continues from earlier parts.
- **Uses:** nothing
- **Reusable:** no

### cWTFAddObjectClicked
- **Does:** Adds a newly created WTF object to the object list and wires it to the selected WTF file path, skipping directories and empty browser selections.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gObjects`, `gDropObject`, `make(ig3d_object, ...)`, `gameroot`, `Data/WTF/` path construction
- **Reusable:** no

### cWTFPreviewLoadMesh
- **Does:** Adds a new object to the object list and loads the selected WTF mesh file into it, skipping directories and empty browser selections.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gObjects`, `loadMesh(...)`, `gameroot` path construction
- **Reusable:** no

### ucreatePreviewsClicked
- **Does:** Creates WTF preview PNG assets for the selected WTF file or folder, updates the preview box, and resets the GLX window bounds.
- **Uses:** `cWTFFileBrowser`, `gcWTFBrowserFiles`, `gcWTFBrowserPath`, `ig3d_CreateDirectory_s`, `createWTFPreviewPNG`, `updatecWTFPreviewBox`, `goDirsUp`, `ig3d_SetWindowBounds_4i`, `gGLX`, `gGLY`, `gGLR`, `gGLB`
- **Reusable:** no

### cWTFbrowserControlDoubleClicked
- **Does:** Updates the WTF browser path based on the double-clicked folder, refreshes the WTF file list, and restores the WTF directory path if the browser moves above it.
- **Uses:** `gcWTFBrowserFiles`, `gcWTFBrowserPath`, `goDirsUp`, `uclistWTFFiles`, `gameroot`, `Data/WTF/` path construction
- **Reusable:** no

## Part 3 of 4

### Top level
- **Does:** Defines the three listed functions and their surrounding FLUID code blocks; no setup, globals or widget definitions outside these functions.
- **Uses:** `gcWTFBrowserFiles`, `updatecWTFPreviewBox`, `cWTFbrowserControlDoubleClicked`, `ClassesBrowserCatch`, `time`, `gLastBrowserControlClick`, `guLastSelection`, `makedir`, `lfs.dir`, `lfs.attributes`, `lfs.mkdir`, `gameroot`, `string.sub`, `assert`, `w:value()`
- **Reusable:** no

### cWTFbrowserControlClicked
- **Does:** Handles the click on the WTF browser control: if the selected file is a file, updates the WTF preview box; tracks click timing to trigger double-click behavior; records the last selection.
- **Uses:** `gcWTFBrowserFiles`, `updatecWTFPreviewBox`, `cWTFbrowserControlDoubleClicked`, `time`, `gLastBrowserControlClick`, `guLastSelection`, `w:value()`
- **Reusable:** no

### ClassListBrowserClicked
- **Does:** Handles the click on the class list browser control by invoking `ClassesBrowserCatch`.
- **Uses:** `ClassesBrowserCatch`, `w:value()`
- **Reusable:** no

### ChangeGameType
- **Does:** Prints the selected value, scans the Scripts folder for entries, creates the Entities subfolder when the selected value is a new directory, and skips creation if the value already exists.
- **Uses:** `w:value()`, `gameroot`, `lfs.dir`, `lfs.attributes`, `lfs.mkdir`, `string.sub`, `assert`, `makedir`
- **Reusable:** no
- **Procedural:** yes

## Part 4 of 4

### Top level
- **Does:** Defines the ClassesBrowser window and its widgets, then runs setup code that shows the browser, makes it current, adds default entity classes to the class list, and lists WTF files.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Input`, `Fl_Group`, `Fl_Button`, `Fl_Box` widget definitions; `ClassesBrowser:show()`, `ClassesBrowser:make_current()`, `ClassListBrowser:add()`, `gDefaultEntityClasses`, `uclistWTFFiles()`; `Data/` paths referenced by the WTF browser setup.
- **Reusable:** no

### ClassesBrowser
- **Does:** Creates the ClassesBrowser window with its fixed size and visible state, and defines the ClassListBrowser, AddClassInput, ClassObjectsGroup, AddObjectBtn, DeleteObjectBtn, WTFBrowserGroup, and AddClassInput (Game Type) widgets with their labels, callbacks, tooltips, sizes, and states.
- **Uses:** `Fl_Window`, `Fl_Browser`, `Fl_Input`, `Fl_Group`, `Fl_Button`, `Fl_Box` widget properties; callbacks `ClassListBrowserClicked`, `uWTFbrowserControlClicked`, `ChangeGameType`; `Data/` paths referenced by the WTF browser setup.
- **Reusable:** no

### ClassesBrowser
- **Does:** Runs the browser setup code: shows the ClassesBrowser, makes it the current class browser, iterates `gDefaultEntityClasses` and adds each entry to `ClassListBrowser`, then calls `uclistWTFFiles()`.
- **Uses:** `ClassesBrowser:show()`, `ClassesBrowser:make_current()`, `ClassListBrowser:add()`, `gDefaultEntityClasses`, `uclistWTFFiles()`.
- **Reusable:** no

### ClassesBrowser
- **Does:** Adds the default entity classes to the class list by iterating the `gDefaultEntityClasses` global and calling `ClassListBrowser:add()` for each value.
- **Uses:** `gDefaultEntityClasses`, `ClassListBrowser:add()`.
- **Reusable:** no

### ClassesBrowser
- **Does:** Lists the WTF files for the current browser context via the `uclistWTFFiles()` call.
- **Uses:** `uclistWTFFiles()`.
- **Reusable:** no
