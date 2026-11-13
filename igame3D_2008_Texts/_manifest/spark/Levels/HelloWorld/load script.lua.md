<!-- Spark first-look of Data/Levels/HelloWorld/load script.lua (model spark-x2.6-4b, 2026-11-12 06:06). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file is the top-level setup script for the HelloWorld level in iGame3D. It creates a text box using the default font, sets its text and position, and configures the game update routine to use the built-in FLTK updating function.
- **Depends on:** `Data/FontPngs/default32_1.png` font asset, `Data/` folder path convention, `make`, `setText_boxInfo`, `game_func` global, `fltk_update`, `IG3D_TEXT`, `IG3D_POSITION` constants, and the iGame3D startup font loading behavior.
- **Provides:** No standalone functions or globals; it configures the HelloWorld level's text box and update routine directly.
- **Assets it needs:** `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png` (referenced in header comments for the default font).
- **Procedural:** none (it only creates and configures an existing object; no assets are generated from numbers or rules).
- **Glossary:**
  - iGame3D calls - Engine API functions used to create, read, and set object properties in the game.
  - IG3D_TEXT - Constant naming the text property of a text box object.
  - IG3D_POSITION - Constant naming the position property of an object.
  - make - Engine call that creates a new object of the specified type and loads its asset.
  - setText_boxInfo - Engine call that sets properties (text, position) on a text box object.
  - game_func - Global variable that selects the routine used to update the game loop.
- **Keep:** Yes, it is a minimal, clear example of configuring a text box and game update routine for a level.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the top-level setup code for the HelloWorld level script, including creating a text box with the default font, setting its text and position, and configuring the game update routine.
- **Uses:** `make(ig3d_text_box, ...)`, `setText_boxInfo(...)`, `game_func=fltk_update`, `Data/FontPngs/default32_1.png` path, `IG3D_TEXT`, `IG3D_POSITION` constants.
- **Reusable:** no
- **Procedural:** no

```
-- Create a new text box t with the default font 
-- This font is loaded at startup of iGame3D and uses "Data/FontPngs/default32_1.png" and "Data/FontPngs/default32_2.png"
t=make(ig3d_text_box, "Data/FontPngs/default32_1.png")
-- Make this text box read "Hello, World"
setText_boxInfo(t, IG3D_TEXT, "Hello, World")
-- Set the position of the text box to top-left corner of the window (with an offset of 50 pixels in the horizontal and vertical)
setText_boxInfo(t, IG3D_POSITION, 50,50)
-- Use only the FLTK updating routine as the game function. You can define your own function and make game_func
-- point to it to run your own game code
game_func=fltk_update
```
