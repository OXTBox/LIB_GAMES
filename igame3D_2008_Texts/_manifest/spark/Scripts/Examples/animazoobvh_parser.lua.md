<!-- Spark first-look of Data/Scripts/Examples/animazoobvh_parser.lua (model spark-x2.6-4b, 2026-11-12 15:02). DRAFT for Claude to review. -->

## animazoobvh_parser.lua
- **Kind:** converter
- **Purpose:** This file converts BVH motion capture files into iGame3D mesh assets by parsing the BVH hierarchy and motion data, building per-frame local matrices and neutral poses, and writing a new mesh object in place of the original BVH file. It is a reusable example of BVH-to-mesh conversion for the iGame3D engine.
- **Depends on:** `Data/` folder paths, `dofile`-loaded Scripts libraries, globals set elsewhere (`gBoneStart`, `gYMod`, `gFirstFrame`, `rootBone`, `bvhmarker`, `gFrameTime`), engine calls (`setObjectInfo`, `getObjectInfo`, `get`, `setBoneInfo`, `make`, `saveMesh`, `delete`), and helper functions (`matrixConcat`, `loadBVHHeader`, `loadBVHMotions`, `neutralPose`, `calculatePoseFromLocalMatrices`, `createMeshBones`, `loadBVHFile`).
- **Provides:** Functions for BVH parsing and mesh generation: `startTabsRemoved`, `loadAnotherBone`, `loadBVHHeader`, `createLocalMatricesForBVHFrame`, `calculatePoseFromLocalMatrices`, `loadBVHMotions`, `neutralPose`, `createMeshBones`, `loadBVHFile`; globals `gBoneStart`, `gYMod`, `gFirstFrame`, `rootBone`, `bvhmarker`, `gFrameTime`.
- **Assets it needs:** `Data/WTF/Characters/animazoobvh.wtf`, `Data/WTF/Weapons/bullet`, `Data/WTF/Characters/animazooJacky.wtf` (BVH source files and mesh output paths it names).
- **Procedural:** yes - it generates mesh assets from BVH files and parsed motion data by reading BVH headers, frame data, and hierarchy lines, computing local matrices and neutral poses, and writing a new mesh object in place of the original BVH file.
- **Glossary:**
  - BVH - Binary Hierarchical Skeleton format used for motion capture data in iGame3D.
  - `setObjectInfo` / `getObjectInfo` - engine calls that read or set named properties (e.g. position, rotation) of an object.
  - `IG3D_POSITION` / `IG3D_ROTATION` / `IG3D_ROTATION_MATRIX` - engine constants naming the properties being read or set on objects.
  - `bvhmarker` - a marker object used to store generated BVH frame and mesh data.
  - `neutralPose` - resets a bone's rotation and position to zero and records its offset as the neutral pose.
  - `createMeshBones` - recursively creates mesh bones for a BVH hierarchy, drawing vertex positions and setting mesh positions.
  - `loadBVHFile` - top-level function that runs the full BVH-to-mesh conversion pipeline.
- **Keep / port / drop:** keep - it is a complete, reusable example of BVH-to-mesh conversion logic for the iGame3D engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Declares shared global variables used by the BVH loading functions: `gBoneStart`, `gYMod`, and `gFirstFrame`.
- **Uses:** nothing
- **Reusable:** no

### startTabsRemoved
- **Does:** Strips leading whitespace (spaces or tabs) from a string and returns the trimmed string.
- **Uses:** nothing
- **Reusable:** yes

### loadAnotherBone
- **Does:** Parses a BVH header line to build a new bone object, recursively loading child bones from the file, and returns the constructed bone.
- **Uses:** globals `gBoneStart`; file handle `fh` (reads lines via `fh:read("*l")`); string functions `string.sub`, `string.gmatch`, `string.gmatch` iteration.
- **Reusable:** no

### loadBVHHeader
- **Does:** Reads the BVH hierarchy and root lines from the file, extracts the root bone name, and loads the root bone via `loadAnotherBone`.
- **Uses:** file handle `fh` (reads lines via `fh:read("*l")`); global `rootBone` (written); string functions `string.sub`.
- **Reusable:** no

## Part 2 of 4

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `createLocalMatricesForBVHFrame`.
- **Uses:** nothing
- **Reusable:** no

### createLocalMatricesForBVHFrame
- **Does:** Recursively builds local rotation and position matrices for each frame of a BVH bone, accumulates per-channel rotation and position values, and writes the final neutral and per-frame bone info to the BVH marker object.
- **Uses:** Engine calls `setObjectInfo`, `getObjectInfo`, `get`, `setBoneInfo` with constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`; globals `gFirstFrame`, `bvhmarker`; helper functions `matrixConcat`; no file or `Data/` path reads or writes.
- **Reusable:** yes - pure matrix and data transformation logic for BVH frame processing.
- **Procedural:** yes - generates per-frame local matrices and bone info for a BVH animation frame.

## Part 3 of 4

### Top level
- **Does:** The file contains no setup, global definitions, widget definitions, or other top-level code outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### calculatePoseFromLocalMatrices
- **Does:** Recursively accumulates the parent's neutral offsets into each bone's neutral coordinates, then recurses through all child bones.
- **Uses:** nothing
- **Reusable:** yes

### loadBVHMotions
- **Does:** Reads a BVH file handle, extracts frame count and frame time values, reads all frame lines into a table, and returns the table of frame lines.
- **Uses:** `fh:read("*l")`, `string.gmatch`, global `gFrameTime`, file handle `fh`
- **Reusable:** yes

### neutralPose
- **Does:** Resets the rotation and position of the specified bone to zero, copies the bone's offset coordinates into its neutral coordinates, then recurses into child bones.
- **Uses:** `get(ig3d_bone, bvhmarker, bone.index)`, `setBoneInfo`, `IG3D_ROTATION`, `IG3D_POSITION`, globals `bone`, `rootBone`, `bvhmarker`
- **Reusable:** yes

### createMeshBones
- **Does:** Recursively creates mesh bones for each bone, drawing a vertex at the scaled neutral position and setting the mesh position, then recurses into child bones.
- **Uses:** `drawVertex`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeBoneFromVertex_2s`, globals `bone`, `rootBone`
- **Reusable:** yes
- **Procedural:** yes

## Part 4 of 4

### Top level
No code outside the `loadBVHFile` function.

### loadBVHFile
- **Does:** Reads the given BVH file, normalizes its line endings, loads the BVH header and motion data, builds the character mesh and neutral pose, saves the resulting mesh file, and replaces the original file with a new mesh object.
- **Uses:** `io.open`, `string.gsub`, `make`, `loadBVHHeader`, `loadBVHMotions`, `neutralPose`, `calculatePoseFromLocalMatrices`, `createMeshBones`, `saveMesh`, `setObjectInfo`, `delete`, globals `buffer`, `bvhmarker`, `rootBone`, `poses`, engine constants `IG3D_POSITION`, and paths `Data/WTF/Characters/animazoobvh.wtf` and `Weapons/bullet`, `Characters/animazooJacky.wtf`.
- **Reusable:** no
- **Procedural:** yes - it generates a mesh asset from a BVH file and its parsed motion data.
