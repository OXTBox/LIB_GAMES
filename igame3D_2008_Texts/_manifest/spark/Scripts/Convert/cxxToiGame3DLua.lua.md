<!-- Spark first-look of Data/Scripts/Convert/cxxToiGame3DLua.lua (model spark-x2.6-4b, 2026-11-12 14:52). DRAFT for Claude to review. -->

## cxxToiGame3DLua.lua
- **Kind:** converter
- **Purpose:** This file converts FLUID-generated C++ source files into Lua scripts suitable for the iGame3D engine, routing file loads through a custom conversion dispatcher so generated code is translated on the fly. It parses FLUID source, converts window code into Lua, writes the converted output, and handles level or UI rebuilds as part of the conversion process.
- **Depends on:** `dofile` (overridden by this file), `Data/`-based file paths referenced by conversion functions, globals set elsewhere such as `gConverterString`, `ig3d_RebuildMacMenubar`, and the FLUID-to-Lua conversion helpers `parseFluid`, `convertFluidToIg3d`, `convertCxxToIg3d`.
- **Provides:** `converterCustomPrint`, `convertFluidToIg3d`, `convertCxxToIg3d`, `split`, `converterDofile`, and the global override of `dofile` to route file loads through the converter.
- **Assets it needs:** none (no model, image, sound, emitter, font, or other named asset files are referenced).
- **Procedural:** generates a `.lua` file from a FLUID `.cxx` source file by parsing the source, converting FLUID-generated window code into Lua, and writing the converted output to a `.lua` file; also generates converted Lua files from FLUID `.fl` files via `convertFluidToIg3d`.
- **Glossary:**
  - FLUID - the FLTK user interface designer whose C++ source files are converted into Lua.
  - murgaLua - the Lua host environment used for the generated Lua scripts.
  - ig3d_RebuildMacMenubar - a global call used to rebuild the mac menu bar UI after FLUID conversion.
  - convertFluidToIg3d - a conversion function that turns a FLUID `.fl` file into a corresponding Lua file.
  - parseFluid - a conversion helper that parses a FLUID source file to produce Lua code.
  - gConverterString - a global string accumulator used to collect and print conversion output.
  - dofile - the Lua file loading function overridden by this file to route loads through the converter.
- **Keep / port / drop:** keep - it is a reusable reference for converting FLUID-generated C++ files into iGame3D Lua scripts.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the file-level conversion entry points and global state used by the conversion functions.
- **Uses:** Globals `gConverterString`, `gConverterString` (via `converterCustomPrint`), `print` (redirected to `converterCustomPrint`), and the `Data/`-based file paths referenced by the conversion functions.
- **Reusable:** no

### converterCustomPrint
- **Does:** Accumulates the arguments passed to it into a single string, appends it to `gConverterString` with a newline, and prints the result via the redirected print function.
- **Uses:** Global `gConverterString` (read and written), global `print` (redirected to `converterCustomPrint`).
- **Reusable:** yes

### convertFluidToIg3d
- **Does:** Converts a FLUID `.fl` file to a corresponding `.lua` file by parsing the source file, then returns the generated `.lua` file path.
- **Uses:** File path construction using `string.sub` on the input file name to derive the output `.lua` path, and calls `parseFluid(theFluidFile, parsedFile)` (a file path is derived from the input file name).
- **Reusable:** no

### convertCxxToIg3d
- **Does:** Validates the input C++ file argument, prints a usage message to the console if the argument is missing, resets `gConverterString`, and redirects the global `print` function to `converterCustomPrint` for later restoration.
- **Uses:** Global `gConverterString` (reset), global `print` (redirected to `converterCustomPrint`), and the input file path argument.
- **Reusable:** no

## Part 2 of 3

### Top level
- **Does:** Sets up conversion state variables, reads the C++ source file line by line, converts FLUID-generated window code into Lua, writes the converted output to a `.lua` file, and returns that file path.
- **Uses:** `io.lines`, `string.gsub`, `string.find`, `string.sub`, `print`, `io.open`, globals `gConverterString`, `theCxxFile`, `theLuaFile`, and `Data/` paths referenced via `theCxxFile` (no explicit `Data/` path calls shown here).
- **Reusable:** no - it is a full conversion pipeline for a specific C++ to Lua translation task.

### split
- **Does:** Splits a given line into a table of non-space character sequences, returning an empty table for lines shorter than 1 character.
- **Uses:** `string.len`, `string.gmatch`, `table.insert` (pure string and table functions, no engine calls, globals, or file paths).
- **Reusable:** yes - pure string splitting logic, reusable for any line tokenization task.
- **Procedural:** no

### (no other functions in this part)
- **Does:** Not applicable - this part only defines the `split` function and contains no additional functions.

## Part 3 of 3

### Top level
- **Does:** Defines the `converterDofile` function and overrides the default `dofile` global with `converterDofile` so all subsequent `dofile` calls route through the converter.
- **Uses:** Globals `actualdofile`, `dofile`, `ig3d_RebuildMacMenubar`; no `Data/` paths or engine calls directly.
- **Reusable:** yes - the global override pattern is reusable for routing file loads through a custom converter.

### converterDofile
- **Does:** Routes `dofile` calls by file extension: returns the converted result for `.cxx` files, converts and rebuilds the mac menu bar for `.fl` files, and loads the original file unchanged otherwise.
- **Uses:** Globals `actualdofile`, `convertCxxToIg3d`, `convertFluidToIg3d`, `ig3d_RebuildMacMenubar`; no `Data/` paths or engine calls directly.
- **Reusable:** no - it is a conditional dispatcher tied to specific conversion functions and UI rebuild behavior.
- **Procedural:** no
