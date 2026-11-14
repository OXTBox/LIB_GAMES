<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Textboxes.lua (model spark-x2.6-4b, 2026-11-12 17:44). DRAFT for Claude to review. -->

## UDG_Textboxes.lua
- **Kind:** library
- **Purpose:** This file configures the global text box font lists, positions, sizes, and colors, creates text boxes with their properties, and defines the `showLevelLoading` function used to update the first text box during level loading and render the scene.
- **Depends on:** `loadFont`, `make`, `setText_boxInfo`, `render` (engine calls), `Data/FontPngs/` font paths, globals `gFontFiles`, `gTextboxFonts`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxes`, `gNumTextboxes` (set elsewhere), and `loadLevel` (level switching, background engine usage).
- **Provides:** `showLevelLoading` function; global text box configuration lists (`gTextboxFonts`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`) and the created text box collection (`gTextboxes`).
- **Assets it needs:** Font Pngs from `Data/FontPngs/` (exact paths named in the file).
- **Procedural:** none
- **Glossary:**
  - `text_box` - A UI element used to display text in the game, created and configured via `make` and `setText_boxInfo`.
  - `IG3D_POSITION` - Constant naming the position property of an object, used to set text box placement.
  - `IG3D_SIZE` - Constant naming the size property of an object, used to set text box dimensions.
  - `IG3D_COLOR` - Constant naming the color property of an object, used to set text box colors.
  - `IG3D_FONT` - Constant naming the font property of an object, used to set text box fonts.
  - `IG3D_TEXT` - Constant naming the text property of an object, used to set the text content of a text box.
- **Keep / port / drop:** keep - reusable text box setup and level loading update logic for other text box systems.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets up global text box font lists, positions, sizes and colors, creates text boxes with their properties, and defines the `showLevelLoading` function.
- **Uses:** `loadFont`, `make`, `setText_boxInfo`, `render`, `math.random`, `table.insert`, `gFontFiles`, `gTextboxFonts`, `gTextboxPositions`, `gTextboxSizes`, `gTextboxColors`, `gTextboxes`, `gNumTextboxes`, `IG3D_POSITION`, `IG3D_SIZE`, `IG3D_COLOR`, `IG3D_FONT`, `Data/FontPngs/` paths
- **Reusable:** yes - the text box setup and configuration logic can be reused for other text box systems.

### showLevelLoading
- **Does:** Updates the first text box with the level name, loading state, size, font, position and color, then renders the scene.
- **Uses:** `setText_boxInfo`, `render`, `gTextboxes`, `gTextboxFonts`, `IG3D_TEXT`, `IG3D_SIZE`, `IG3D_FONT`, `IG3D_POSITION`, `IG3D_COLOR`
- **Reusable:** yes - the text box update logic can be reused for other level loading text updates.
- **Procedural:** no
