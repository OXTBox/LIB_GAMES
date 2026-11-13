<!-- Spark first-look of Data/Scripts/Convert/AquariusCharactersPMB.lua (model spark-x2.6-4b, 2026-11-12 14:45). DRAFT for Claude to review. -->

## AquariusCharactersPMB.lua
- **Kind:** converter
- **Purpose:** This file is a font conversion script that builds a global `chr` table of 8-row binary character bitmaps and glyph tables for the AquariusCharactersPMB conversion. It defines character glyph data across many character code ranges, storing each glyph as 8-row binary patterns, matrices, or nested tables. The script prepares the character set data used by the conversion process.
- **Depends on:** `Data/` folder paths for loading scripts and resources; global `chr` table entries are defined here and consumed by other scripts; no external `dofile` or `loadLevel` calls are shown in this file.
- **Provides:** The global `chr` table containing character glyph bitmaps, glyph tables, and character data for the AquariusCharactersPMB conversion; no standalone functions are defined in this file.
- **Assets it needs:** none (no model, image, sound, emitter, font, or other named asset files are referenced in this file).
- **Procedural:** yes — the file generates character glyph bitmaps and glyph tables from character code ranges and binary patterns instead of loading external asset files.
- **Glossary:**
  - `chr` - Global table storing character glyph bitmaps and character data for the conversion script.
  - `8-row binary pattern` - A glyph stored as eight rows of binary `0`/`1` characters representing a character's pixel pattern.
  - `AquariusCharactersPMB conversion` - The font conversion process this script supports, building character glyph data for the PMB character set.
  - `IG3D_... constant` - Engine property name used in object info calls to identify the property being read or set (e.g., position, rotation).
- **Keep / port / drop:** keep - This file is a reusable reference for building character glyph data tables for the AquariusCharactersPMB conversion.

---

# Part notes

## Part 1 of 29

### Top level
- **Does:** Defines the `chr` table containing eight 8-row binary character bitmaps, one per character index.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 29

### Top level
- **Does:** Defines glyph bitmaps for character set indices 10 through 18 as 8-row binary patterns.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 29

### Top level
- **Does:** Defines character glyph definitions for the font conversion script, storing each glyph as a multi-line binary pattern inside a `chr` table.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 29

### Top level
- **Does:** Defines character glyph tables for the AquariusCharactersPMB conversion, storing each character's 8x8 bitmap as a Lua table.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 29

### Top level
- **Does:** Defines character glyph data as 8-row binary matrices stored in global `chr` entries for characters 0x30 through 0x39.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 6 of 29

### Top level
- **Does:** Defines character glyph data as nested string tables keyed by character code, storing each glyph as a fixed-width binary pattern.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 7 of 29

### Top level
- **Does:** Defines character glyph bitmaps for the ASCII characters 0 through 63 as 8-row binary patterns.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 8 of 29

### Top level
- **Does:** Defines character glyph bitmaps for characters 64 through 71 as 8-row binary matrices.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 9 of 29

### Top level
- **Does:** Defines eight character bitmaps by assigning them to the `chr` table, one entry per character code from 72 to 80.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 10 of 29

### Top level
- **Does:** Defines eight character bit patterns by assigning them to the `chr` table indices 81 through 89.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 11 of 29

### Top level
- **Does:** Defines glyph bitmaps for characters 90 through 98 as 8-row binary patterns, continuing earlier parts of the script.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 12 of 29

### Top level
- **Does:** Defines character glyph tables for the character set, storing each glyph as an 8-row binary pattern inside a `chr` array indexed by glyph number.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** yes

## Part 13 of 29

### Top level
- **Does:** Defines character glyph data for the Aquarius characters part of the engine.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 14 of 29

### Top level
- **Does:** Defines character sprite data for the AquariusCharactersPMB conversion, storing each character's pixel pattern in a character data table.
- **Uses:** nothing
- **Reusable:** no

## Part 15 of 29

### Top level
- **Does:** Defines glyph data for the character set by assigning 8-row binary patterns to `chr[126]` through `chr[134]`.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 16 of 29

### Top level
- **Does:** Defines character pixel patterns as Lua tables using `chr[...]` keys and nested 8-row binary string values.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 17 of 29

### Top level
- **Does:** Defines character glyph data as 8x8 binary patterns for character codes 144 through 151.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 18 of 29

### Top level
- **Does:** Defines eight character glyph tables by assigning them to global `chr` indices 152 through 160.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 19 of 29

### Top level
- **Does:** Defines eight character codes (chr[161] through chr[169]) as fixed 8-row binary patterns, continuing earlier setup for the character conversion script.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 20 of 29

### Top level
- **Does:** Defines character sprite frame glyphs by assigning them to `chr[170]` through `chr[178]`, each glyph stored as a fixed 8-row bitmap of `0` and `1` characters.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 21 of 29

### Top level
- **Does:** Defines character sprite patterns as indexed string arrays, continuing earlier parts of the conversion script.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 22 of 29

### Top level
- **Does:** Defines glyph definitions for the character set by assigning 8x8 bitmap patterns to `chr[188]` through `chr[196]`.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 23 of 29

### Top level
- **Does:** Defines character glyph data as 8-row binary matrices for character codes 197 through 205.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 24 of 29

### Top level
- **Does:** Defines character glyph data as Lua tables keyed by character code, each containing an 8-row binary pattern.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 25 of 29

### Top level
- **Does:** Defines character glyph data as 8x8 binary matrices stored in global character table entries.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** yes

## Part 26 of 29

### Top level
- **Does:** Defines glyph data for the character font by assigning 8x8 bitmap patterns to character codes 224 through 231.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 27 of 29

### Top level
- **Does:** Defines eight character glyph tables by assigning them to the `chr` table, each containing eight rows of eight binary characters.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 28 of 29

### Top level
- **Does:** Defines eight character codes (chr[241] through chr[249]) as 8x8 binary patterns, each stored as a Lua array.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 29 of 29

### Top level
- **Does:** Defines eight character font glyphs as 8x8 bit patterns, one per character code from 250 to 255.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no
