<!-- Spark first-look of Data/Scripts/Functions/animation_functions.lua (model spark-x2.6-4b, 2026-11-12 06:30). DRAFT for Claude to review. -->

## animation_functions.lua
- **Kind:** converter
- **Purpose:** This file contains the BVH-to-WIF-to-WTF conversion workflow functions, which generate animation path tables, convert BVH animation files into WIF files, and export WIF animation data into WTF animation assets. It supports model animation loading and playback setup for the engine.
- **Depends on:** `Data/` folder paths, `Data/Scripts/Examples/truebonesbvh_parser.lua`, `Data/BVHPathTables.lua`, `Data/WIFPathTables.lua`, `Data/WIFtoBVHTables.lua`, globals `gAnimSourceModel`, `gAnimsList`, `gObjName`, `BVHTables`, `WIFTables`, `BVHtoWIF`, `gFrameTime`, `gameroot`, and engine calls such as `ig3d_GetObjectModelPath_s_s`, `ig3d_GetObjectModelAnimOffset_s_i`, `ig3d_ReadModelAnimationsFromFile_2si`, `ig3d_SetAutoBoneUpdating_b`, `setObjectInfo`, `getObjectInfo`, `getFileText`, and `WTFNoAnimFile`.
- **Provides:** `ModelAnimationList`, `runLevelAnim`, `createBVHPathTables`, `recreateWIFPathTables`, `sortBVHWIFTables`, `convertBVHtoWIF`, `WTFNoAnimFile`, `convertWIFtoWTF`.
- **Assets it needs:** `Data/BVH/TrueBones/` folders, `Data/WIF/` folders, `Data/WTF/Characters/truebonesmaster.wtf`, `Data/BVHPathTables.lua`, `Data/WIFPathTables.lua`, `Data/WIFtoBVHTables.lua`, `Data/Scripts/Examples/truebonesbvh_parser.lua`.
- **Procedural:** yes - generates `BVHPathTables.lua`, `WIFPathTables.lua`, `WIFtoBVHTables.lua`, WIF `.txt` files, and WTF animation asset files from folder contents, file lists, and numeric animation data.
- **Glossary:**
  - BVH - Binary Hierarchical Skeleton format used for motion capture animation data.
  - WIF - WIF animation file format, a text-based export of BVH animation data used by the engine.
  - WTF - 3D model file format in the iGame3D engine, used for animation assets.
  - TrueBones - BVH folder structure containing motion capture animation data.
  - Animation offset - the starting frame offset for a model animation source file.
  - Auto bone updating - engine setting that automatically updates bones during animation playback.
- **Keep / port / drop:** keep - core conversion workflow and reusable animation parsing logic that programmers can reuse for new engine animation setup.

---

# Part notes

## Part 1 of 7

### Top level
- **Does:** Contains the file-level comment block describing the BVH-to-WIF-to-WTF conversion workflow functions, with no executable setup or global definitions.
- **Uses:** nothing
- **Reusable:** no

### ModelAnimationList
- **Does:** Reads a model animation source file, parses its animation entries into a list of animation objects, and returns the populated list; returns early if the source file cannot be opened.
- **Uses:** Engine calls `ig3d_GetObjectModelPath_s_s` and `ig3d_GetObjectModelAnimOffset_s_i`; globals `gAnimSourceModel`, `gAnimsList`, `gObjName`; file access via `io.open` on the model path returned by the engine call.
- **Reusable:** yes - pure data parsing logic for reading and structuring model animation files.

### runLevelAnim
- **Does:** Loads the animation source model, reads its animation offset, loads animations into the target object, enables auto bone updating, and sets the target object's animation based on the provided list index and play flag.
- **Uses:** Engine calls `get(ig3d_object, trgt)`, `ig3d_GetObjectModelAnimOffset_s_i`, `ig3d_ReadModelAnimationsFromFile_2si`, `ig3d_SetAutoBoneUpdating_b`, `setObjectInfo`; globals `gAnimsList`; file path from `ig3d_GetObjectModelPath_s_s(src)`.
- **Reusable:** yes - reusable animation playback setup logic for model-based animation loading.
- **Procedural:** no

## Part 2 of 7

### createBVHPathTables
- **Does:** Scans the TrueBones BVH folder structure, collects animation names and load paths into tables, then writes them to a generated Lua file.
- **Uses:** `listFolders`, `listFiles`, `io.open`, `io.close`, globals `gameroot`, `BVHTables`, `tableinc`; reads/writes `Data/BVH/TrueBones/` folders and writes `Data/BVHPathTables.lua`.
- **Reusable:** no - it is a one-off asset generation routine tied to the BVH folder layout and specific output file.
- **Procedural:** yes - it generates the `BVHPathTables.lua` file from folder contents and file lists.

## Part 3 of 7

### Top level
- **Does:** No functions or top-level code outside `recreateWIFPathTables` are present in this file.
- **Uses:** nothing
- **Reusable:** no

### recreateWIFPathTables
- **Does:** Scans the `Data/WIF/` folder and its subdirectories, builds name-to-path lookup tables for organized BVH files, then writes the generated tables to a new Lua file.
- **Uses:** `listFolders`, `listFiles`, `io.open`, `gameroot` (for `Data/WIF/` and `Data/WIFPathTables.lua` paths), plus the file `Data/WIFPathTables.lua` written to disk.
- **Reusable:** no
- **Procedural:** yes - generates the WIF path tables file from the contents of the `Data/WIF/` directory structure.

## Part 4 of 7

### Top level
- **Does:** No top-level code outside the `sortBVHWIFTables` function.
- **Uses:** nothing
- **Reusable:** no

### sortBVHWIFTables
- **Does:** Matches BVH animation names against WIF animation names, builds sorted access tables for animation paths, and writes a conversion table file to the Data folder.
- **Uses:** `dofile` with paths `gameroot.."Data/BVHPathTables.lua"` and `gameroot.."Data/WIFPathTables.lua"`, globals `BVHTables`, `WIFTables`, `gameroot`, `io.open`/`io.close`, and writes to `gameroot.."Data/WIFtoBVHTables.lua"`.
- **Reusable:** no
- **Procedural:** yes

## Part 5 of 7

### convertBVHtoWIF
- **Does:** Converts BVH animation files into sorted .txt (WIF) files, tracking failed files via the `nstrt` parameter to resume from the next file.
- **Uses:** Engine calls (`dofile` for loading helper scripts, `getObjectInfo` with `IG3D_NAME`), globals (`gFrameTime`, `BVHTables`, `BVHtoWIF`), files (`Data/Scripts/Examples/truebonesbvh_parser.lua`, `Data/BVHPathTables.lua`, `Data/WIF/` paths), and `Data/` folder paths.
- **Reusable:** no - it depends on specific BVH parsing, WIF export, and table-based path logic specific to this conversion workflow.
- **Procedural:** yes - it generates WIF .txt files from BVH animation data by processing frames and writing bone transformation data.

## Part 6 of 7

### WTFNoAnimFile
- **Does:** Reads the specified WTF file, strips the animation chunk from its text, and returns the modified text used as a template for creating WIF animation WTF files.
- **Uses:** Files and `Data/` paths (`gameroot.."Data/WTF/Characters/truebonesmaster.wtf"`), engine file I/O via `io.open` with read mode, string manipulation (`string.find`, `string.sub`).
- **Reusable:** yes - it is a reusable string/data processing helper for extracting WTF file content without animation chunks.
- **Procedural:** no

## Part 7 of 7

### Top level
- **Does:** The file contains the function `convertWIFtoWTF`, which converts exported BVH animation data from the `Data/WIF` folder into animation files under `Data/WTF/WIF/`.
- **Uses:** `listFolders`, `listFiles`, `getFileText`, `WTFNoAnimFile`, `io.open`, `io.close`, `string.find`, `string.sub`, `string.gmatch`, `string.len`, `math.floor`, and globals `gameroot`. No engine calls to `getObjectInfo`, `make`, `loadLevel`, etc. are used.
- **Reusable:** no
- **Procedural:** yes - it generates WTF animation asset files from BVH text data in the WIF folder.

### convertWIFtoWTF
- **Does:** Walks every subfolder under `Data/WIF/`, reads each file's text, parses the animation count and data, and writes a combined animation WTF file for the folder into `Data/WTF/WIF/` with the folder name as the filename.
- **Uses:** `listFolders(gameroot.."Data/WIF/")`, `listFiles`, `getFileText`, `WTFNoAnimFile`, `io.open`, `io.close`, and globals `gameroot`. Reads/writes paths under `Data/WIF/` and `Data/WTF/WIF/`.
- **Reusable:** no
- **Procedural:** yes - it generates WTF animation asset files from BVH text data.
