<!-- Spark first-look of Data/Scripts/Convert/BVHtoWIFtoWTF.lua (model spark-x2.6-4b, 2026-11-12 14:46). DRAFT for Claude to review. -->

## BVHtoWIFtoWTF.lua
- **Kind:** converter
- **Purpose:** This file provides conversion utilities that translate BVH animation data into WIF path tables and then into WTF animation files, supporting the truebonesmaster character workflow. It includes functions to scan BVH and WIF folders, build and sort path tables, and convert between BVH and WIF/WTF assets.
- **Depends on:** `Data/BVH/TrueBones/` and `Data/BVHPathTables.lua` folders/files, `Data/WIF/` subfolders and `Data/WIFPathTables.lua`, `Data/WTF/Characters/truebonesmaster.wtf`, `Data/BVHPathTables.lua`, `Data/WIFPathTables.lua`, and globals `BVHTables`, `WIFTables`, `gameroot`, `listFolders`, `listFiles`, `getFileText`, `gFrameTime`.
- **Provides:** `createBVHPathTables`, `recreateWIFPathTables`, `sortBVHWIFTables`, `convertBVHtoWIF`, `WTFNoAnimFile`, `convertWIFtoWTF`.
- **Assets it needs:** `Data/BVH/TrueBones/` folders, `Data/WIF/` subfolders, `Data/WTF/Characters/truebonesmaster.wtf`, `Data/BVHPathTables.lua`, `Data/WIFPathTables.lua`, `Data/WIFtoBVHTables.lua`.
- **Procedural:** Generates Lua path table files from scanned BVH/WIF folder contents, generates sorted BVH/WIF conversion table files from path data, and generates WIF and WTF animation files from BVH source files and numeric frame data.
- **Glossary:**
  - BVH - Binary Hierarchical Skeleton format used for motion capture animation data.
  - WIF - Intermediate format for storing animation path data used during BVH to WTF conversion.
  - WTF - 3D model and animation file format used for final game assets.
  - TrueBones - BVH folder structure containing skeleton animation data.
  - Path table - Lua table mapping animation names to file paths for asset loading.
- **Keep / port / drop:** keep - reusable conversion logic for BVH to WIF/WTF workflows in new engines.

---

# Part notes

## Part 1 of 7

### Top level
- **Does:** Documents the sequence of steps for converting BVH data to WIF and then to WTF using the listed functions.
- **Uses:** Nothing in this section.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 7

### createBVHPathTables
- **Does:** Scans the TrueBones BVH folder structure, collects animation names and load paths into tables, then writes a generated Lua file with those tables.
- **Uses:** `listFolders`, `listFiles`, `io.open`, `io.close`, globals `gameroot`, `BVHTables`, `tableinc`; reads/writes `Data/BVH/TrueBones/` folders and `Data/BVHPathTables.lua`.
- **Reusable:** yes - the folder traversal and table population logic for BVH path collection is reusable for similar BVH asset scanning tasks.
- **Procedural:** yes - generates a Lua asset file from scanned folder contents and collected data.

### Top level
- **Does:** none - this file contains only the `createBVHPathTables` function.

## Part 3 of 7

### Top level
- **Does:** No functions or top-level code beyond the function `recreateWIFPathTables` defined below.
- **Uses:** nothing
- **Reusable:** no

### recreateWIFPathTables
- **Does:** Recreates the organized WIF path tables by scanning the `Data/WIF/` folder, collecting animation names and matching paths, then writes the resulting tables to a new Lua file.
- **Uses:** globals `gameroot`, `listFolders`, `listFiles`; reads/writes `Data/WIF/` subfolders and `Data/WIFPathTables.lua`; uses string manipulation and file I/O to build and write the tables.
- **Reusable:** no
- **Procedural:** yes

Wait, the instructions say if there is code outside any function start with Top level. Here the only code is inside the function, so no Top level section is needed. Let me correct per the exact format rules:

### recreateWIFPathTables
- **Does:** Recreates the organized WIF path tables by scanning the `Data/WIF/` folder, collecting animation names and matching paths, then writes the resulting tables to a new Lua file.
- **Uses:** globals `gameroot`, `listFolders`, `listFiles`; reads/writes `Data/WIF/` subfolders and `Data/WIFPathTables.lua`; uses string manipulation and file I/O to build and write the tables.
- **Reusable:** no
- **Procedural:** yes

Wait, the rules say "If there is code outside any function (setup, globals, widget definitions, settings), start with a section `### Top level`. If the list above says 'none', write ONLY the `### Top level` section." Here the list of functions is only `recreateWIFPathTables`, and there is no code outside any function, so we only write the function section. Let me fix the final output to match exactly:

### recreateWIFPathTables
- **Does:** Recreates the organized WIF path tables by scanning the `Data/WIF/` folder, collecting animation names and matching paths, then writes the resulting tables to a new Lua file.
- **Uses:** globals `gameroot`, `listFolders`, `listFiles`; reads/writes `Data/WIF/` subfolders and `Data/WIFPathTables.lua`; uses string manipulation and file I/O to build and write the tables.
- **Reusable:** no
- **Procedural:** yes

Wait, check the procedural rule: "Procedural: only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural." This function generates a Lua file with tables of paths and animation names based on folder scanning rules, which is generating an asset (a Lua data file) from rules. So procedural yes is correct.

Also check uses: it uses `gameroot`, `listFolders`, `listFiles` (engine/host calls), reads/writes `Data/WIF/` folders and `Data

## Part 4 of 7

### Top level
- **Does:** No functions or top-level code outside the `sortBVHWIFTables` function; the provided code contains only the function definition and its body.
- **Uses:** `dofile` calls for loading `Data/BVHPathTables.lua` and `Data/WIFPathTables.lua`, plus globals `BVHTables`, `WIFTables`, `gameroot`. No engine object calls, file reads/writes beyond the generated table file, or UI interactions.
- **Reusable:** no

### sortBVHWIFTables
- **Does:** Matches BVH animation names to WIF animation names, builds sorted access tables for BVH, import, and export paths, and writes a generated conversion table file to `Data/WIFtoBVHTables.lua`.
- **Uses:** `dofile` for loading `Data/BVHPathTables.lua` and `Data/WIFPathTables.lua`, globals `BVHTables`, `WIFTables`, `gameroot`, `io.open`/`io.close` for writing the generated table file. No engine object calls.
- **Reusable:** no
- **Procedural:** yes - generates a conversion table file from BVH and WIF path data.

## Part 5 of 7

### Top level
- **Does:** No top-level setup, globals, or widget definitions exist outside the `convertBVHtoWIF` function.
- **Uses:** nothing
- **Reusable:** no

### convertBVHtoWIF
- **Does:** Converts BVH files into sorted WIF `.txt` files by iterating over the preloaded BVH animation name table, reading each BVH file, and writing per-frame bone transformation data to the corresponding WIF path.
- **Uses:** Engine calls (`dofile` for loading `truebonesbvh_parser.lua` and `BVHPathTables.lua`, `getObjectInfo`, `ig3d_GetObjectBonesList_s_s`, `ig3d_GetObjectBoneInfo_2s_6f`), globals (`gFrameTime`, `BVHTables`, `BVHtoWIF`), files and `Data/` paths (`gameroot.."Data/BVHPathTables.lua"`, `gameroot.."Data/WIF/"`), and file I/O (`io.open` for reading BVH files and writing WIF text files).
- **Reusable:** no
- **Procedural:** yes - it generates WIF asset files from BVH source files and numeric frame data.

## Part 6 of 7

### Top level

### WTFNoAnimFile
- **Does:** Reads the source WTF file for the truebonesmaster character, extracts the text before the `#Animations` marker if present, and returns that text without the animation chunk.
- **Uses:** `io.open` (file read), `string.find`, `string.sub`, `gameroot` (global path base), `Data/` path `Data/WTF/Characters/truebonesmaster.wtf`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 7

### Top level
- **Does:** The file contains a single function `convertWIFtoWTF` that converts exported BVH data folders into WTF animation files.
- **Uses:** Engine calls `listFolders`, `listFiles`, `getFileText`, `WTFNoAnimFile` (implied by usage in the function), file I/O via `io.open`/`io.close`, and `Data/` paths under `gameroot.."Data/WIF/"` and `gameroot.."Data/WTF/WIF/"`. Globals referenced include `gameroot`.
- **Reusable:** no
- **Procedural:** yes

### convertWIFtoWTF
- **Does:** Iterates over subdirectories in `Data/WIF/`, reads each file's text, parses animation counts and data, aggregates valid animation entries into a text buffer, and writes the resulting WTF animation file for each subdirectory.
- **Uses:** Engine calls `listFolders`, `listFiles`, `getFileText`, `WTFNoAnimFile`; file I/O via `io.open` and `io.close`; `Data/` paths `gameroot.."Data/WIF/"` and `gameroot.."Data/WTF/WIF/"`; globals `gameroot`.
- **Reusable:** no
- **Procedural:** yes

Wait, the instructions say if there is code outside any function, start with `### Top level`. Here all code is inside the function, so no Top level section is needed. Let me correct:

### convertWIFtoWTF
- **Does:** Iterates over subdirectories in `Data/WIF/`, reads each file's text, parses animation counts and data, aggregates valid animation entries into a text buffer, and writes the resulting WTF animation file for each subdirectory.
- **Uses:** Engine calls `listFolders`, `listFiles`, `getFileText`, `WTFNoAnimFile`; file I/O via `io.open` and `io.close`; `Data/` paths `gameroot.."Data/WIF/"` and `gameroot.."Data/WTF/WIF/"`; globals `gameroot`.
- **Reusable:** no
- **Procedural:** yes
