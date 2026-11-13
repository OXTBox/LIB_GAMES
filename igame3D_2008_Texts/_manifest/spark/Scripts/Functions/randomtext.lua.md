<!-- Spark first-look of Data/Scripts/Functions/randomtext.lua (model spark-x2.6-4b, 2026-11-12 15:29). DRAFT for Claude to review. -->

## randomtext.lua
- **Kind:** library
- **Purpose:** This file provides reusable text generation and cycling helpers for the iGame3D text arcade functions. It defines shared global state and font tables, a helper that cycles text across text boxes, and two pure string-generation functions that produce random or full ASCII text.
- **Depends on:** `gNumTextboxes` (global referenced by the `invaders` helper), `arcadeFont`, `textDirections`, `cyclerate`, `cycledchar`, `cycleString`, `bnum` (globals or locals defined in this file); engine calls `passed()`, `ig3d_GetTextboxInfo_i_3i4f2s`, `ig3d_GetWindowBounds__4i`, `ig3d_SetTextboxInfo_4i4f2s`; `Data/` folder paths are not used by this file.
- **Provides:** `textArcade`, `cycleArcade`, `invaders`, `randomtext`, `allchar` (functions defined in this file).
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` paths are named or used).
- **Procedural:** yes - `randomtext` and `allchar` generate text strings from random numbers, ASCII code ranges, and length limits instead of loading asset files.
- **Glossary:**
  - `textbox` - a text display object in the iGame3D engine, referenced by text-box info calls.
  - `arcadeFont` - a local table mapping font names to glyph name/glyph pairs used for text rendering.
  - `gNumTextboxes` - a global counter tracking the number of text boxes, used to wrap cycling counters.
  - `passed()` - an engine call used to advance or trigger text-related logic.
  - `ig3d_GetTextboxInfo_i_3i4f2s` - engine call that reads text box info (position, text, etc.).
  - `ig3d_SetTextboxInfo_4i4f2s` - engine call that sets text box info (position, text, etc.).
  - `ig3d_GetWindowBounds__4i` - engine call that returns window bounds for text box positioning.
- **Keep / port / drop:** keep - reusable text generation and cycling logic for the text arcade functions.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines shared global state and font table for the text arcade functions, plus the `invaders` helper that cycles text across text boxes.
- **Uses:** `arcadeFont` (local table of font name and glyph pairs), `os.time`, `gNumTextboxes` (global referenced by `invaders`), `textDirections` (local table), `textDrop`, `bnum` (local counters), `passed()` (engine call).
- **Reusable:** no

### textArcade
- **Does:** Returns the second glyph of the arcade font entry for the given font index, cycling the glyph selection when the requested character exceeds the glyph length.
- **Uses:** `arcadeFont` (local table), `string.len`, `string.sub` (string functions).
- **Reusable:** yes

### cycleArcade
- **Does:** Increments the global cyclerate counter, updates the current cycling character, and sets the text content of a text box using the arcade font glyph. It also adjusts the text box position based on window bounds and text direction.
- **Uses:** `cyclerate`, `cycledchar`, `cycleString`, `arcadeFont`, `textDirections`, `passed()`, `ig3d_GetTextboxInfo_i_3i4f2s`, `ig3d_GetWindowBounds__4i`, `ig3d_SetTextboxInfo_4i4f2s` (engine calls), `string.len`, `string.sub` (string functions).
- **Reusable:** no

### invaders
- **Does:** Advances the text box cycling counter and triggers text updates across three text boxes, wrapping the counter when it exceeds `gNumTextboxes/8`.
- **Uses:** `bnum` (local counter), `gNumTextboxes` (global referenced by `invaders`), `cycleArcade` (function from this file).
- **Reusable:** no

## Part 2 of 2

### Top level
No code outside the two defined functions.

### randomtext
- **Does:** Generates a random text string of length `n`, printing the current text whenever its length reaches the limit `w`, and appends random bytes drawn from the range `ls` to `le` to build the result.
- **Uses:** `math.random`, `string.char`, `print`. No engine calls, globals, files or `Data/` paths are used.
- **Reusable:** yes - pure string and random data generation logic.

### allchar
- **Does:** Builds a text string by appending every character from ASCII code 1 through 128, printing the current text whenever its length reaches the limit 40 and resetting the accumulator.
- **Uses:** `string.char`, `print`. No engine calls, globals, files or `Data/` paths are used.
- **Reusable:** yes - pure string and data generation logic.
