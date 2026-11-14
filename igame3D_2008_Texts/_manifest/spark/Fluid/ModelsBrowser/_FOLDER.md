<!-- Spark folder manifest of Data/Fluid/ModelsBrowser (model spark-x2.6-4b, 2026-11-13 01:33). DRAFT. -->

# Data/Fluid/ModelsBrowser
- **Role:** This folder holds the iGame3D model browser tool, a Lua/FLTK UI for browsing and editing 3D models from the WTF model folder, managing model attributes, materials, bones, and values, and loading or switching game levels.
- **Entry point:** ModelsBrowser.lua
- **Files:** ModelsBrowser.fl - FLUID twin of ModelsBrowser.lua; ModelsBrowser.lua - model browser tool with model listing, attribute parsing, material/value editing, and level loading.
- **Shared with other folders:** Needs WTF model files, Images, Emitters, Help scripting text, and level folders via loadLevel; others use its model browsing and level switching.
- **Procedure candidates:** Parse model attributes and values from file data; edit material and value attributes; load or switch game levels through the browser.
- **Glossary:** model browser - tool for browsing and editing 3D models; WTF - folder of 3D model files; FLTK - user interface framework; loadLevel - switches game level; getObjectInfo - reads object property info.
- **Verdict:** keep - it is a functional engine tool with clear Lua and FLUID structure for model management and level loading.
