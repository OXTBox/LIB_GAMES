<!-- Spark first-look of Data/Scripts/Convert/BVHtoWIFtoWTF.lua (model spark-x2.6-4b, 2026-11-12 20:43). DRAFT for Claude to review. -->

## BVHtoWIFtoWTF.lua
- **Kind:** converter
- **Purpose:** This file provides a workflow for converting BVH motion capture data into WIF text files and then into WTF animation assets. It scans BVH folder structures, builds path and animation tables, matches BVH and WIF animation names, and generates the final WTF animation files for use in the engine.
- **Depends on:** `listFolders`, `listFiles`, `gameroot`, `io.open`, `io.close`, `string.sub`, `string.find`, `string.char`, `dofile`, `loadLevel`, `loadBVHFile`, `getObjectInfo`, `ig3d_GetObjectBonesList_s_s`, `ig3d_GetObjectBoneInfo_2s_6f`, `createLocalMatricesForBVHFrame`, `gFrameTime`, `getFileText`, `WTFNoAnimFile`, `Data/BVH/TrueBones/`, `Data/BVHPathTables.lua`, `Data/WIF/`, `Data/WIFPathTables.lua`, `Data/WTF/WIF/`, `Data/WTF/Characters/truebonesmaster.wtf`, `ig3d_object`, `ig3d_text_box`
- **Provides:** Conversion workflow functions for BVH-to-WIF-to-WTF asset conversion, including BVH path table generation, WIF path table construction, animation name matching and conversion table building, BVH-to-WIF file conversion, WTF animation file creation, and WIF-to-WTF conversion logic.
- **Assets it needs:** none
- **Procedural:** yes - generates WIF text files from BVH source files, generates WIF path tables from the Data/WIF folder structure, generates WIF-to-WTF animation files from BVH text folders and numeric animation counts, and generates WTF animation assets from BVH text folders.
- **Glossary:**
  - BVH - Binary BVH motion capture format used as the source asset for conversion.
  - WIF - Text format for organized BVH animation data used as an intermediate conversion asset.
  - WTF - 3D model/animation asset format used as the final conversion output.
  - TrueBones - BVH folder structure containing motion capture animation data.
  - BVHPathTables - Generated Lua table file holding scanned BVH folder paths and animation names.
  - WIFPathTables - Generated Lua table file holding organized WIF folder paths and animation names.
  - conversionTable - Table matching BVH and WIF animation paths for conversion.
- **Keep / port / drop:** keep - serves as a reusable reference for BVH-to-WIF-to-WTF asset conversion workflows.

---

# Part notes

## Part 1 of 7

### Top level
- **Does:** Contains only the conversion workflow instructions for converting BVH to WIF to WTF.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 2 of 7

### createBVHPathTables
- **Does:** Scans the TrueBones BVH folder structure, collects anim names and load paths into tables, and writes them to a generated Lua file.
- **Uses:** `listFolders`, `listFiles`, `gameroot`, `io.open`, `io.close`, `string.sub`, `string.find`, `string.char`, `print`, `BVHTables` (local table), `Data/BVH/TrueBones/` paths, `Data/BVHPathTables.lua` output path.
- **Reusable:** yes - the folder traversal and table-building logic can be reused for similar BVH path collection tasks with adjusted paths and table names.
- **Procedural:** yes - generates a Lua asset file from scanned folder contents.

## Part 3 of 7

### recreateWIFPathTables
- **Does:** Builds and writes the WIFTables tables for organized BVH files under Data/WIF, then writes the generated tables to Data/WIFPathTables.lua.
- **Uses:** `listFolders`, `listFiles`, `io.open`, `io.close`, `gameroot`, `Data/` paths (`gameroot.."Data/WIF/"`, `gameroot.."Data/WIFPathTables.lua"`), string manipulation helpers used in the code.
- **Reusable:** yes - the table construction and file-writing logic for organizing BVH path tables can be reused for similar WIF asset organization tasks.
- **Procedural:** yes - generates the WIFPathTables.lua file from the contents of the Data/WIF folder structure.

## Part 4 of 7

### sortBVHWIFTables
- **Does:** Matches BVH animation names against WIF animation names, builds a conversion table of matched paths, and writes the resulting table file to disk.
- **Uses:** `dofile`, `gameroot`, `BVHTables`, `WIFTables`, `lfs`-style path construction via `gameroot.."Data/..."`, `io.open`/`io.close`, string concatenation with `string.sub`, and the globals `pathsMatched`, `counter`, `ntext`, `itext`, `otext`, `qt`, `namestable`, `intable`, `outtable`, `conversionTableOut`, `myFileName`, `myFile`.
- **Reusable:** no
- **Procedural:** yes

### sortBVHWIFTables
- **Does:** Matches BVH animation names against WIF animation names, builds a conversion table of matched paths, and writes the resulting table file to disk.
- **Uses:** `dofile`, `gameroot`, `BVHTables`, `WIFTables`, `io.open`/`io.close`, string concatenation with `string.sub`, and the globals `pathsMatched`, `counter`, `ntext`, `itext`, `otext`, `qt`, `namestable`, `intable`, `outtable`, `conversionTableOut`, `myFileName`, `myFile`.
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 7

### convertBVHtoWIF
- **Does:** Converts BVH files into WIF (.txt) files by reading BVH files, writing sorted animation frame data, and closing the output file.
- **Uses:** `dofile` with paths `/ig3d_mac_xcode/Data/Scripts/Examples/truebonesbvh_parser.lua`, `gameroot.."Data/BVHPathTables.lua"`, `io.open` for reading BVH files and writing WIF files, `loadBVHFile`, `getObjectInfo`, `ig3d_GetObjectBonesList_s_s`, `ig3d_GetObjectBoneInfo_2s_6f`, `createLocalMatricesForBVHFrame`, `string.gmatch`, `math.floor`, `math.floor`/`#` for frame counting, `gFrameTime`, `BVHtoWIF.animname`, `BVHtoWIF.import`, `BVHtoWIF.export`, `BVHTables.animname`, `BVHTables.pathtoload`, `gameroot`, `poses`, `rootBone`, `ig3d_object`/`ig3d_text_box` object info calls, `print`, and the `for` loops for iterating files and frames.
- **Reusable:** with changes - depends on BVH parsing, object bone info, and WIF file writing logic specific to this conversion.
- **Procedural:** yes - generates WIF asset files from BVH source files and frame data.

## Part 6 of 7

### WTFNoAnimFile
- **Does:** Reads the source WTF file, removes the `#Animations` chunk if present, and returns the file text without the animation chunk.
- **Uses:** `gameroot`, `io.open`, `string.find`, `string.sub`, `Data/WTF/Characters/truebonesmaster.wtf`
- **Reusable:** yes - string and file text manipulation
- **Procedural:** no

## Part 7 of 7

### convertWIFtoWTF
- **Does:** Creates animation WTF files from exported BVH text folders, then writes the resulting animation data to WTF output files.
- **Uses:** `listFolders`, `listFiles`, `getFileText`, `WTFNoAnimFile`, `math.floor`, `string.find`, `string.gmatch`, `string.len`, `string.sub`, `string.char`, `io.open`, `io.close`, globals `gameroot`, `Data/` paths `gameroot.."Data/WIF/"`, `gameroot.."Data/WTF/WIF/"`
- **Reusable:** no
- **Procedural:** yes - generates WTF animation assets from BVH text folders and numeric animation counts.
