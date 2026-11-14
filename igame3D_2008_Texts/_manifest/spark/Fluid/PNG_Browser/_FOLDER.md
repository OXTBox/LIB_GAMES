<!-- Spark folder manifest of Data/Fluid/PNG_Browser (model spark-x2.6-4b, 2026-11-13 01:45). DRAFT. -->

# Data/Fluid/PNG_Browser
- **Role:** This folder provides a PNG file browser and preview tool for the iGame3D engine, letting users navigate PNG directories, select and load PNG textures into the particle browser, and preview selected PNG files in a shared image box.
- **Entry point:** PNG_Browser.lua
- **Files:** PNG_Browser.fl - FLUID twin of PNG_Browser.lua; PNG_Browser.lua - PNG file browser and preview UI tool
- **Shared with other folders:** Needs Data/Images/Colors/white.png and engine calls for texture loading, preview updates, directory navigation, and particle browser integration.
- **Procedure candidates:** PNG_BrowserNew constructs the browser window and widgets; listPNGFiles scans and lists PNG files in the current directory.
- **Glossary:**
  - `gBrowserFiles - Shared list of PNG files and directories in the current browser directory.`
  - `gBrowserPath - Current PNG directory path used to scan and navigate files.`
  - `gCatchTexturePath - Shared record of the texture path loaded from the PNG browser.`
  - `PNGBrowserNew - Constructor for creating the PNG browser window and its widgets.`
  - `gLastBrowserControlClick - Shared control click state used for browser interaction.`
  - `gLastSelection - Shared selection state for the PNG browser.`
  - `gObjects - Shared global object table used by engine code.`
  - `ParticleBrowser - Shared particle browser object referenced by the PNG tool.`
  - `gLabelTable - Shared label table used by the UI tool.`
  - `goDirsUp - Engine call to navigate up one directory level.`
  - `lfs.dir - murgaLua host call to list files in a directory.`
- **Verdict:** keep - It is a complete, reusable UI tool for PNG texture browsing and previewing that matches the engine's existing UI patterns and dependencies.
