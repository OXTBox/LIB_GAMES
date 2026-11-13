<!-- Spark first-look of Data/Scripts/oldConvert/cxxToiGame3DLua.lua (model spark-x2.6-4b, 2026-11-12 18:18). DRAFT for Claude to review. -->

## cxxToiGame3DLua.lua
- **Kind:** converter
- **Purpose:** This file is a conversion tool that translates FLUID-generated C++ source files into iGame3D Lua code, supporting the conversion of FLUID UI files to Lua as well. It parses FLUID source and C++ files, validates inputs, redirects file loading through a custom converter, and rebuilds the Mac menu bar after fluid conversions.
- **Depends on:** `Data/` folder paths for source and generated Lua files, `Scripts/` folder for FLUID conversion helpers, globals such as `gConverterString`, `theCxxFile`, `theLuaFile`, `Marker`, `PrefixFlag`, `touchCode`, `Fld`, `currentLine`, `winname`, `s`, `e`, `f`, `print`, `rememberedPrint`, `game_func`, `runner`, `ig3d_RebuildMacMenubar`, `Fl:scheme`, `Fl:run`, and `loadLevel` (background engine references).
- **Provides:** Globals `gConverterString` and `converterCustomPrint`, functions `convertFluidToIg3d`, `convertCxxToIg3d`, `split`, `converterDofile`, and the global `dofile` override `converterDofile`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** yes - generates Lua source files from FLUID `.fl` files and C++ `.cxx` files by parsing source content and applying conversion rules to produce output text.
- **Glossary:**
  - iGame3D - the 3D game engine this converter produces Lua code for.
  - FLUID - the UI designer whose `.fl` files are converted to Lua.
  - CXX - C++ source files that are converted into iGame3D Lua code.
  - dofile - Lua file loading function that is overridden by this converter to route conversions.
  - ig3d_RebuildMacMenubar - engine call used to rebuild the Mac menu bar after fluid conversion.
- **Keep / port / drop:** keep - serves as a reusable reference for converting FLUID/C++ sources into iGame3D Lua code.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the global `gConverterString` and the `converterCustomPrint` helper used by the conversion functions to accumulate output text.
- **Uses:** `gConverterString` (global), `tostring`, `..` string concatenation, `\n` newline literal.
- **Reusable:** yes
- **Procedural:** no

### converterCustomPrint
- **Does:** Accumulates the given arguments into a string and appends a newline to the global `gConverterString`.
- **Uses:** `gConverterString` (global), `tostring`, string concatenation with `..`, `\n` literal.
- **Reusable:** yes
- **Procedural:** no

### convertFluidToIg3d
- **Does:** Converts a FLUID `.fl` file to a corresponding `.lua` file by parsing the FLUID file and returning the generated `.lua` path.
- **Uses:** `string.sub` (operates on `theFluidFile`), `parseFluid` (called with `theFluidFile` and the generated `.lua` path), returns the generated `.lua` path.
- **Reusable:** no
- **Procedural:** yes

### convertCxxToIg3d
- **Does:** Validates the input CXX file, prints a usage message if the input is missing, resets the global `gConverterString`, and redirects the `print` function to `converterCustomPrint` for later restoration.
- **Uses:** `print` (global function), `converterCustomPrint` (function), `gConverterString` (global), string concatenation with `..`, `\n` literal.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 3

### Top level
- **Does:** Contains setup variables, global state, and post-processing logic for converting a C++ source file into a Lua file, plus the `split` function definition.
- **Uses:** `io.lines`, `string.gsub`, `string.find`, `string.len`, `string.gmatch`, `string.sub`, `io.open`, globals `gConverterString`, `theCxxFile`, `theLuaFile`, `Marker`, `PrefixFlag`, `touchCode`, `Fld`, `currentLine`, `winname`, `s`, `e`, `f`, `print`, `rememberedPrint`, `game_func`, `runner`, `ig3d_RebuildMacMenubar`, `Fl:scheme`, `Fl:run`, `loadLevel` is not referenced here.
- **Reusable:** no

### split
- **Does:** Splits a input line into a table of non-space character sequences, returning an empty table if the input is empty.
- **Uses:** `string.len`, `string.gmatch`, `table.insert`. No engine calls, globals or file paths.
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** Defines the `converterDofile` function and overrides the default `dofile` global with `converterDofile` so all subsequent `dofile` calls route through the converter.
- **Uses:** `dofile`, `actualdofile`, `convertCxxToIg3d`, `convertFluidToIg3d`, `ig3d_RebuildMacMenubar`
- **Reusable:** yes
- **Procedural:** no

### converterDofile
- **Does:** Routes file loading through the converter: returns the default dofile result for nil input, converts `.cxx` files to iGame3D and loads them, converts `.fl` files to iGame3D, rebuilds the Mac menu bar after fluid conversion, and loads other files directly.
- **Uses:** `theFile`, `actualdofile`, `convertCxxToIg3d`, `convertFluidToIg3d`, `ig3d_RebuildMacMenubar`, `dofile`
- **Reusable:** no
- **Procedural:** no
