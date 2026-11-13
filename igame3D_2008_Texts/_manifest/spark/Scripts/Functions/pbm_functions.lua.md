<!-- Spark first-look of Data/Scripts/Functions/pbm_functions.lua (model spark-x2.6-4b, 2026-11-12 15:26). DRAFT for Claude to review. -->

## pbm_functions.lua
- **Kind:** converter
- **Purpose:** This file provides reusable PBM text parsing, grid-to-mesh-map generation, and screenshot extraction utilities for the iGame3D engine. It reads PBM files, converts their data into structured tables, builds mesh maps from grid values, and extracts subgrids from PBM screenshots for later use.
- **Depends on:** `Data/` folder paths (e.g., `Data/WTF/AquaChar/chr<ii>.wtf`, `/AquariusCharactersPMB.lua`, `/AquariusXY.lua`), `lfs.dir`/`lfs.attributes` for directory listing, `io.open`/`io.close` for file reading/writing, and globals set elsewhere such as `pbmtable`, `pbms_to_table`, `shortPBMfile`, `pbmscreenshottable`, `Aquariuspeeks`, `textmapXY`, `CBI`, `CBO`, `Q`, and mesh-related globals like `gFloorWTF`, `meshdone`, `convertMeshObjectsTablesToMeshFile`.
- **Provides:** Functions `listFiles`, `item`, `fileNameFromPath`, `fileShortNameFromPath`, `read_pbm`, `pbms_to_table`, `parsePBM2Map`, `write_pbmMeshMapstoFile`, `read_pbm_screenshot`, `read_pbmScreenXY`, `setpeeks`, `peek`, `doit`, plus globals `pbmtable`, `pbmtableoutput`, `fileList`, `textArray`, `btnListXY`, `textmapXY`, `btnList`, `quadwalls`, `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gFloorWTF`, `meshdone`, `textmapXY`, `CBI`, `CBO`, `Q`, `ig3d_DeleteMesh_b`, `ig3d_GetMesh_tagsList__s`, `ig3d_DeleteMesh_tag_i`, `convertMeshObjectsTablesToMeshFile`, `pbmSequentialTable`, `pbmlinelength`, `pbmlinedepth`, `pbmscreenshottable`, `shortPBMfile`, `Aquariuspeeks`.
- **Assets it needs:** None named (no models, images, sounds, emitters, or fonts are referenced in the code).
- **Procedural:** yes - generates PBM mesh map files from grid values and structured PBM data, and collects screenshot subgrids from stored PBM screenshot data via coordinate rules.
- **Glossary:**
  - PBM - a plain text bitmap format used for storing grid data and screenshots in this engine.
  - PBM2 map - a character string parsed into structured tables for floor, quad wall, button, and text map data.
  - PBM mesh map - a generated file built from grid values that defines mesh objects for the game.
  - PBM screenshot - a PBM text file containing pixel data used for UI lookups and subgrid extraction.
  - PokeOut - a text file written by `doit` to output extracted character commands.
- **Keep / port / drop:** keep - reusable parsing and grid-to-mesh-map conversion logic that other engine files depend on.

---

# Part notes

## Part 1 of 6

### Top level
- **Does:** Defines shared global tables and constants used across the file, including `pbmtable`, `pbmtableoutput`, `fileList`, `textArray`, `btnListXY`, `textmapXY`, `btnList`, `quadwalls`, and the string constants `CBI`, `CBO`, `Q`.
- **Uses:** nothing
- **Reusable:** no

### listFiles
- **Does:** Lists files in a given directory path, filtering out `.` and `..`, skipping `.DS_Store`, and returning the list of file names.
- **Uses:** `lfs.dir`, `lfs.attributes`, `Data/` paths (read via the `path` argument)
- **Reusable:** yes

### item
- **Does:** Splits a string by a delimiter into items, returning the nth item by index, handling negative indices for the last item and positive indices for forward lookup.
- **Uses:** `string.find`, `string.gfind`, `string.sub`
- **Reusable:** yes

### fileNameFromPath
- **Does:** Returns the file name portion of a full file path by extracting the last item split on `/`.
- **Uses:** `item`
- **Reusable:** yes

### fileShortNameFromPath
- **Does:** Returns the short file name from a full path by extracting the last item split on `/`, falling back to `"untitled"` if the extracted name is nil or contains no dot.
- **Uses:** `item`, `string.find`, `string.sub`
- **Reusable:** yes

## Part 2 of 6

### Top level
- **Does:** No setup, globals or widget definitions appear outside the two functions below.
- **Uses:** nothing
- **Reusable:** no

### read_pbm
- **Does:** Reads a PBM text file, parses its header and grid data, and stores the parsed grid values into the `pbmtable` table keyed by the short filename of the file.
- **Uses:** `io.open`, `string.sub`, `string.match`, `string.find`, `string.gsub`, `string.gmatch`, `string.len`, `string.rep`, `table.insert`, `fileNameFromPath`, `pbmtable`, `pbmdata`, `pbmhead`, `pbmgrid`, `shortfile`
- **Reusable:** no

### pbms_to_table
- **Does:** Lists files in the given path, reads each file through `read_pbm`, builds a character mapping table from the parsed PBM data, writes the mapping table to `/AquariusCharactersPMB.lua`.
- **Uses:** `listFiles`, `read_pbm`, `pbmtable`, `chr`, `table.sort`, `pairs`, `io.open`, `f:write`, `io.close`, `tpath`, `fileList`, `sb`
- **Reusable:** no
- **Procedural:** yes

## Part 3 of 6

### Top level
- **Does:** No top-level code outside the `parsePBM2Map` function.
- **Uses:** nothing
- **Reusable:** no

### parsePBM2Map
- **Does:** Parses a PBM2 map character string into structured tables for floor/quad wall data, button positions, and text map coordinates.
- **Uses:** `pbms_to_table`, `pbmtable`, `string.sub`, `string.len`, `tostring`, `table.insert`, `#` (string length operator)
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### Top level
- **Does:** No functions or setup code outside the `write_pbmMeshMapstoFile` function; the remaining lines after the function define global variables and a global alias.
- **Uses:** Globals `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gFloorWTF`, `meshdone`, `textmapXY`, `CBI`, `CBO`, `Q`, `ig3d_DeleteMesh_b`, `ig3d_GetMesh_tagsList__s`, `ig3d_DeleteMesh_tag_i`, `convertMeshObjectsTablesToMeshFile`, `io`, `makepbms`, `pbmSequentialTable`, `pbmlinelength`, `pbmlinedepth`, `pbmscreenshottable`, `shortPBMfile`.
- **Reusable:** no

### write_pbmMeshMapstoFile
- **Does:** Generates a PBM mesh map file by iterating over grid values, building mesh object tables, writing them to a file, and deleting existing mesh objects for the current grid value.
- **Uses:** Globals `nTagNumber`, `vgridwidth`, `vgridlength`, `vcubewidth`, `vcubelength`, `vcubeheight`, `gridSize`, `cubeSize`, `gFloorWTF`, `meshdone`, `textmapXY`, `CBI`, `CBO`, `Q`, `ig3d_DeleteMesh_b`, `ig3d_GetMesh_tagsList__s`, `ig3d_DeleteMesh_tag_i`, `convertMeshObjectsTablesToMeshFile`, `io`; writes to `/AquariusXY.lua`; reads/writes `Data/WTF/AquaChar/chr<ii>.wtf` via `convertMeshObjectsTablesToMeshFile`.
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 6

### Top level
- **Does:** No setup, globals or widget definitions appear outside the three function definitions.
- **Uses:** nothing
- **Reusable:** no

### read_pbm_screenshot
- **Does:** Reads a PBM screenshot file, parses its header and grid dimensions, strips whitespace from the pixel data, and stores the parsed pixel rows in `pbmscreenshottable` keyed by a shortened filename derived from the input path.
- **Uses:** `io.open`, `io.close`, `fileNameFromPath`, `string.sub`, `string.match`, `string.find`, `string.gsub`, `string.rep`, `string.gmatch`, `string.len`, `string.insert` via `table.insert`, `pbmscreenshottable`, `pbmSequentialTable`, `shortPBMfile`, `pbmdata`, `pbmhead`, `pbmgrid`, `pbmlinelength`, `pbmlinedepth`
- **Reusable:** yes - pure data parsing and storage of PBM screenshot content.

### read_pbmScreenXY
- **Does:** Extracts a 7-column by 7-row subgrid from the stored PBM screenshot data based on the given row and column coordinates, concatenating the matching pixel rows and returning the extracted subgrid as a string.
- **Uses:** `pbmscreenshottable`, `shortPBMfile`, `string.sub`, `string.len`
- **Reusable:** yes - pure data extraction from stored PBM screenshot data.

### setpeeks
- **Does:** Iterates over a grid of coordinates spaced 9 apart across the PBM screenshot dimensions, calls `read_pbmScreenXY` for each coordinate, and appends non-nil results to the `Aquariuspeeks` table.
- **Uses:** `pbmlinedepth`, `pbmlinelength`, `read_pbmScreenXY`, `Aquariuspeeks`, `table.insert`
- **Reusable:** yes - pure data collection from stored PBM screenshot data.

## Part 6 of 6

### Top level
- **Does:** The file contains the functions `peek` and `doit`, plus a call to `read_pbm_screenshot` outside any function.
- **Uses:** `Aquariuspeeks`, `pbmtable`, `pbms_to_table`, `setpeeks`, `read_pbm_screenshot`, `io.open`, `io.close`, and the path `/Users/williamgriffin/Applications/CrossOver/VirtualAquarius/quicktyp/pokeout.txt`
- **Reusable:** no
- **Procedural:** no

### peek
- **Does:** Returns the value of the `Aquariuspeeks` table at the index passed as the argument.
- **Uses:** `Aquariuspeeks`
- **Reusable:** yes

### doit
- **Does:** Iterates over the `Aquariuspeeks` table, finds the first character index for each entry, builds a command string, writes it to a PokeOut text file, and calls `read_pbm_screenshot` for a PBM screenshot.
- **Uses:** `Aquariuspeeks`, `pbmtable`, `pbms_to_table`, `setpeeks`, `read_pbm_screenshot`, `io.open`, `io.close`, and the path `/Users/williamgriffin/Applications/CrossOver/VirtualAquarius/quicktyp/pokeout.txt`
- **Reusable:** no
- **Procedural:** no
