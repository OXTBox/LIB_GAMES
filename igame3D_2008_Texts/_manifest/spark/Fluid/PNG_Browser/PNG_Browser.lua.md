<!-- Spark first-look of Data/Fluid/PNG_Browser/PNG_Browser.lua (model spark-x2.6-4b, 2026-11-13 01:45). DRAFT for Claude to review. -->

## PNG_Browser.lua
- **Kind:** ui-dialog
- **Purpose:** This file provides a PNG file browser and preview tool for the iGame3D engine, allowing users to navigate PNG directories, select and load PNG textures into the particle browser, and preview selected PNG files in a shared image box. It sets up the browser window and its widgets, handles file selection and directory navigation, and manages the associated texture loading and preview updates.
- **Depends on:** `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`, `time`, `gLastBrowserControlClick`, `gLastSelection`, `gBrowserPath`, `gBrowserFiles`, `gObjects`, `gCatchTexturePath`, `ParticleBrowser`, `PNGBrowserNew`, `gLabelTable`, `goDirsUp`, `listPNGFiles`, `updatePNGPreviewBox`, `pngLoad`, `browserControlDoubleClicked`, `updateTexture`, `loadTexture`, `fltk:Fl_Double_Window`, `fltk:Fl_Box`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `fltk:Fl_Group`, `Fl:run`, `gameroot`, `Data/Images/`, `Data/Images/Colors/white.png`
- **Provides:** `pngFileBrowser`, `pngPreviewBox`, `PNGBrowserNew`, `listPNGFiles`, `updatePNGPreviewBox`, `pngLoad`, `browserControlDoubleClicked`, `browserControlClicked`, `PNGBrowserNew` (as a widget constructor)
- **Assets it needs:** `Data/Images/Colors/white.png`
- **Procedural:** none
- **Glossary:**
  - `gBrowserFiles - A shared list of PNG files and directories in the current browser directory.`
  - `gBrowserPath - The current PNG directory path used to scan and navigate files.`
  - `gCatchTexturePath - A shared record of the texture path loaded from the PNG browser.`
  - `PNGBrowserNew - A constructor for creating the PNG browser window and its widgets.`
  - `loadTexture - Engine call to load a texture from a file path.`
  - `updateTexture - Engine call to refresh a texture object after loading.`
  - `goDirsUp - Engine call to navigate up one directory level.`
  - `lfs.dir - murgaLua host call to list files in a directory.`
- **Keep / port / drop:** keep (a complete, reusable UI tool for PNG texture browsing and previewing)

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets the last browser control click time and last selection index at file startup, then defines the four PNG browser functions.
- **Uses:** `time()`, `gLastBrowserControlClick`, `gLastSelection`, `gBrowserPath`, `gBrowserFiles`, `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`, `pngFileBrowser`, `pngPreviewBox`, `Fl_Shared_Image`, `loadTexture`, `gCatchTexturePath`, `ParticleBrowser`, `PNGBrowserNew`, `gObjects`, `goDirsUp`, `listPNGFiles`, `updatePNGPreviewBox`, `pngLoad`, `browserControlDoubleClicked`.
- **Reusable:** no

### listPNGFiles
- **Does:** Clears the PNG file browser and directory list, then scans the current PNG directory for files and directories, recording each in `gBrowserFiles` and adding it to the PNG file browser UI.
- **Uses:** `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`, `gBrowserPath`, `gBrowserFiles`, `pngFileBrowser`, `listPNGFiles` (via `gBrowserFiles` population), `goDirsUp` (indirectly via directory navigation).
- **Reusable:** yes

### updatePNGPreviewBox
- **Does:** Registers shared images, resolves the PNG file name from the given name, loads the matching image or a default white image, sets the preview box background color, applies the image and redraws the preview box.
- **Uses:** `fltk.fl_register_images`, `gBrowserPath`, `string.sub`, `Fl_Shared_Image.get`, `pngPreviewBox:color`, `pngPreviewBox:image`, `pngPreviewBox:redraw`, `gameroot`, `Data/Images/Colors/white.png`.
- **Reusable:** yes

### pngLoad
- **Does:** Returns early if no PNG file is selected, skips directory entries, creates a new object in `gObjects`, loads the selected PNG texture, records the texture path in `gCatchTexturePath`, and refreshes the texture if the particle browser exists.
- **Uses:** `pngFileBrowser:value`, `gBrowserFiles`, `tonumber`, `gObjects`, `table.insert`, `loadTexture`, `gCatchTexturePath`, `ParticleBrowser`, `updateTexture`, `PNGBrowserNew:make_current`, `gameroot`, `Data/Images/` path prefix.
- **Reusable:** yes

### browserControlDoubleClicked
- **Does:** Returns early for directory entries, navigates the PNG directory when a directory is selected, refreshes the PNG file list after navigation, and returns early for the parent directory entry.
- **Uses:** `gBrowserFiles`, `gBrowserPath`, `goDirsUp`, `listPNGFiles`.
- **Reusable:** yes

## Part 2 of 2

### Top level
- **Does:** Sets up the PNG Browser window and its widgets, then starts the FLTK application.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Box`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `gLabelTable`, `PNGBrowserNew`, `pngPreviewBox`, `pngFileBrowser`, `widget`, `Fl_Group`, `Fl:run`, plus the top-level `do` blocks and `listPNGFiles()` call shown in the code.
- **Reusable:** no

### browserControlClicked
- **Does:** Handles clicks on the PNG file browser widget: updates the PNG preview box for selected files, tracks click timing to detect double clicks, and records the selected file value.
- **Uses:** `gBrowserFiles`, `updatePNGPreviewBox`, `time`, `gLastBrowserControlClick`, `gLastSelection`, `browserControlDoubleClicked`, `w:value()`, `w:clicked`-style widget methods (`value()`, `clicked`), plus the widget `w` passed into the function.
- **Reusable:** no

### browserControlDoubleClicked
- **Does:** Not shown in this code section; no implementation is provided for this function.
- **Uses:** nothing in this section
- **Reusable:** no
- **Procedural:** no
