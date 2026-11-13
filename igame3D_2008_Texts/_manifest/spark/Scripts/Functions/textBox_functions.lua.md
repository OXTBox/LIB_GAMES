<!-- Spark first-look of Data/Scripts/Functions/textBox_functions.lua (model spark-x2.6-4b, 2026-11-12 15:53). DRAFT for Claude to review. -->

## textBox_functions.lua
- **Kind:** engine-core
- **Purpose:** This file provides core functions for managing text boxes in the iGame3D engine, including displaying and resetting text boxes, rendering the title menu and wait screen, and configuring text box fonts and vertical offsets. It also contains helper functions for listing folders and populating level/label arrays from folder structures.
- **Depends on:** Other Scripts files (e.g., `facetitles`, `colorcyclebackground`, `adjustFontSize`, `loadLevel`, `loadTexture`, `loadFont`), globals (`gObjects`, `gNumBoxes`, `gTextRed`, `gTextGreen`, `gTextBlue`, `gTextAlpha`, `gFontSize`, `gDefaultFontA`, `gDefaultFontB`, `gTextboxes`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxFonts`, `gEditingMode`, `gSelBox`, `gFourView`, `gFontSize`, `gTextboxes`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxFonts`, `gDefaultFontA`, `gDefaultFontB`, `boxes`, `levels`, `labels`, `game_func`, `showFonts`, `offsetYtext`, `viewstatus`), and the `Data/` folder paths for fonts and levels.
- **Provides:** `displayText`, `resetTextBoxes`, `titleMenu`, `titleWait`, `labels_folders`, `textBox_folders`, `TextBox_Levels_Menu`, `useFont`, `toggleText`.
- **Assets it needs:** `Data/FontPngs/default32_1.png`, `Data/FontPngs/` (font variants), `Data/FontPngs/` font textures, `Data/FontPngs/` font pair, `Data/FontPngs/` 32px font variants, `Data/Levels/` folders, `Data/` folder paths for levels and labels.
- **Procedural:** none
- **Glossary:**
  - `text box` - A UI element in the engine that displays text, managed via `boxes` and `setText_boxInfo`.
  - `IG3D_*` - Engine constants naming the properties of objects (e.g., `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_COLOR`, `IG3D_FONT`) used to read or set object attributes.
  - `make` / `get` - Engine calls used to create or retrieve objects by kind and name.
  - `loadLevel` - Switches the active game level by loading a level folder.
  - `fltk_update` - Updates the FLTK user interface after engine changes.
  - `facetitles` - A function that populates text box titles/labels for the UI.
  - `gNumBoxes` - Global counter tracking the total number of text boxes.
- **Keep / port / drop:** keep - Core text box management logic is reusable for similar UI text handling in a new engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines the `displayText` and `resetTextBoxes` functions for text box handling.
- **Uses:** `getSceneInfo`, `IG3D_WINDOW_COORDS`, `setText_boxInfo`, `boxes`, `gNumBoxes`, `gTextRed`, `gTextGreen`, `gTextBlue`, `gTextAlpha`, `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_COLOR`, `IG3D_FONT`, `Data/FontPngs/default32_1.png`
- **Reusable:** yes - text box positioning, sizing and text setting logic can be reused for similar text box operations.

### displayText
- **Does:** Positions and configures a text box by computing its coordinates from the window and box number, then sets its position, size, and text content.
- **Uses:** `getSceneInfo`, `IG3D_WINDOW_COORDS`, `setText_boxInfo`, `boxes`, `gNumBoxes`, `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_TEXT`
- **Reusable:** yes - the coordinate calculation and text box configuration pattern is reusable for text box display operations.

### resetTextBoxes
- **Does:** Resets all text boxes by setting their color and font to default values for each box in the range from 1 to `gNumBoxes`.
- **Uses:** `setText_boxInfo`, `boxes`, `gNumBoxes`, `IG3D_COLOR`, `gTextRed`, `gTextGreen`, `gTextBlue`, `gTextAlpha`, `IG3D_FONT`, `Data/FontPngs/default32_1.png`
- **Reusable:** yes - the default text box reset logic is reusable for restoring text box states.

## Part 2 of 4

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the `titleMenu` and `titleWait` functions.
- **Uses:** nothing
- **Reusable:** no

### titleMenu
- **Does:** Renders the title menu by cycling background colors, sizing the font based on the number of boxes and view configuration, drawing each label with staggered column and row offsets, and handling level selection via mouse clicks.
- **Uses:** `colorcyclebackground()`, `GlRect("w,h")`, `adjustFontSize()`, `getText_boxInfo(boxes[i], IG3D_SIZE)`, `getText_boxInfo(boxes[i], IG3D_BOUNDS)`, `setText_boxInfo(boxes[i], IG3D_COLOR, ...)`, `displayText(...)`, `load`, `glw`, `glh`, `gFourView`, `gNumBoxes`, `gFontSize`, `textRowBase`, `textColumn`, `textColumnMod`, `textRowMod`, `textRow`, `textIndent`, `labels`, `gSelBox`, `levels`, `clickedLevel`, `loadLevel(clickedLevel)`, `click("n")`, `mouseCoords()`, `mouseInBox(...)`, `mouseX`, `mouseY`, `gameroot` (referenced in commented code only), `load script.lua` (referenced in commented code only)
- **Reusable:** no

### titleWait
- **Does:** Sets the default escape key behavior, reads the current camera position, invokes `titleMenu()` to display the menu, updates the FLTK interface, and ends the function.
- **Uses:** `default_escapekey()`, `getCameraInfo(IG3D_POSITION)`, `titleMenu()`, `fltk_update()`
- **Reusable:** no

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the three listed functions; the file contains only the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### labels_folders
- **Does:** Creates a list of folders under the given path, maps each folder name into the levels and labels arrays, and strips characters from folder names when stripChars is provided.
- **Uses:** `ListFolder`, `string.sub`, `#` (array length operator), parameters `whatPath`, `stripChars`, `tFont`
- **Reusable:** yes

### textBox_folders
- **Does:** Lists folders under the given path, creates a text box for each folder, sets text box color, size and font info, maps folder names into levels and labels arrays, and records the total box count in gNumBoxes.
- **Uses:** `ListFolder`, `make`, `ig3d_text_box`, `setText_boxInfo`, `gDefaultFontA`, `gFontSize`, `gTextboxes`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxFonts`, `gNumBoxes`, `string.sub`, `#`, parameters `whatPath`, `stripChars`, `tFont`
- **Reusable:** yes

### TextBox_Levels_Menu
- **Does:** Sets up the levels menu UI by ensuring text box state and font defaults exist, calls facetitles unless editing mode is lookaround, populates text boxes from the levels folder, and configures the game function and editing mode for level selection.
- **Uses:** `facetitles`, `gEditingMode`, `gTextboxes`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxFonts`, `gDefaultFontA`, `gFontSize`, `boxes`, `levels`, `labels`, `game_func`, `titleWait`, `default_escapekey`, `ig3d_SetMode_i`, parameters `whatPath`, `stripChars`, `tFont`
- **Reusable:** no

## Part 4 of 4

### Top level
- **Does:** No top-level code outside the two defined functions; the file only defines `useFont` and `toggleText`.
- **Uses:** nothing
- **Reusable:** no

### useFont
- **Does:** Loads the specified font's 32px variants, loads both font textures and the font pair, then updates the position info of all text boxes to use the first font variant. If the requested font file does not exist, it prints a message indicating the missing font path.
- **Uses:** `lfs.dir`, `gameroot`, `loadTexture`, `loadFont`, `setText_boxInfo`, `getText_boxInfo` (via `toggleText`), `IG3D_FONT`, globals `gDefaultFontA`, `gDefaultFontB`, `boxes`, `gDefaultFontA`/`gDefaultFontB` assignments, `Data/FontPngs/` path construction
- **Reusable:** yes - pure font loading and text box font configuration logic that can be reused for font management in a similar engine

### toggleText
- **Does:** Toggles the global `showFonts` flag based on the `viewstatus` argument, sets `offsetYtext` to 10000 when fonts are hidden and -10000 when visible, then adjusts the position info of the specified text box or all text boxes by the offset if the argument `n` is greater than 1.
- **Uses:** globals `showFonts`, `offsetYtext`, `boxes`, `getText_boxInfo`, `setText_boxInfo`, `IG3D_POSITION`
- **Reusable:** yes - text box vertical offset toggling logic that can be reused for similar text box positioning features

### toggleText
- **Does:** No additional code beyond the function definition; this section is not applicable.
- **Uses:** nothing
- **Reusable:** no
