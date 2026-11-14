<!-- Spark folder manifest of Data/Fluid/CarAndDriver (model spark-x2.6-4b, 2026-11-12 20:26). DRAFT. -->

# Data/Fluid/CarAndDriver
- **Role:** This folder holds the FLTK user interface for the CarAndDriver level, built with the FLUID UI designer. It provides the RNDRTS_Maker window with input fields, buttons and callbacks, plus level-building and auto-script generation functions that configure and save the level.
- **Entry point:** CarAndDriver.fl
- **Files:** CarAndDriver.fl - FLTK user interface file for the CarAndDriver level, defining the RNDRTS_Maker window, input fields, buttons, callbacks, and level-building/auto-script generation functions.
- **Shared with other folders:** It needs gObjects, gSoundFiles, gFontFiles, gameroot, Data/ paths, and the RNDRTS-related libraries (RNDRTS_Maker, RNDRTSLoadScript, RNDRTSLoadScriptOut, RNDRTSMakerLevel, ig3d_CreateDirectory_s) from elsewhere. It takes from other folders the level's entity files, sound files, font files and level folders referenced by its script sections.
- **Procedure candidates:** Level-building and auto-script generation functions that configure and save the level, including object info collection, auto-script output, and level name handling; these are produced by code rather than stored as files.
- **Glossary:**
  - RNDRTS_Maker - FLTK UI window for the CarAndDriver level with input fields, buttons and callbacks.
  - FLTK user interface - the FLUID (FLTK) UI designer structure used to build the level's interface.
  - auto-script generation - code that produces the level's script output from collected entity info.
  - gObjects - shared global holding engine objects used by the UI.
  - setObjectInfo - engine call to set object property values.
  - loadLevel - engine call to switch to a level folder.
- **Verdict:** keep - the file contains the complete FLTK UI and level-building logic for the CarAndDriver level, which is needed to build and run the level; it depends on existing engine libraries and shared globals that are already present in the engine.
