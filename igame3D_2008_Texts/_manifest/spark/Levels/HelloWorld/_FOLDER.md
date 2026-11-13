<!-- Spark folder manifest of Data/Levels/HelloWorld (model spark-x2.6-4b, 2026-11-12 06:06). DRAFT. -->

# Data/Levels/HelloWorld
- **Role:** This folder holds the top-level setup script for the HelloWorld level in iGame3D, which configures a text box and the game update routine for the level.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script that creates a text box using the default font, sets its text and position, and configures the game update routine to use the built-in FLTK updating function.
- **Shared with other folders:** Needs the `Data/` folder path convention, the `Data/FontPngs/default32_1.png` font asset, and the `Data/FontPngs/default32_2.png` font asset referenced in header comments; shares the `make`, `setText_boxInfo`, `game_func`, `fltk_update`, `IG3D_TEXT`, and `IG3D_POSITION` engine calls and globals with the rest of the engine.
- **Procedure candidates:** none; the file only creates and configures an existing object and sets the update routine directly, with no procedural generation of assets or code.
- **Glossary:**
  - iGame3D calls - Engine API functions used to create, read, and set object properties in the game.
  - IG3D_TEXT - Constant naming the text property of a text box object.
  - IG3D_POSITION - Constant naming the position property of an object.
  - make - Engine call that creates a new object of the specified type and loads its asset.
  - setText_boxInfo - Engine call that sets properties (text, position) on a text box object.
  - game_func - Global variable that selects the routine used to update the game loop.
- **Verdict:** keep - it is a minimal, clear example of configuring a text box and game update routine for a level, with no missing or unverifiable components.
