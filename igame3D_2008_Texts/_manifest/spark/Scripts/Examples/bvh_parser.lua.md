<!-- Spark first-look of Data/Scripts/Examples/bvh_parser.lua (model spark-x2.6-4b, 2026-11-12 15:05). DRAFT for Claude to review. -->

## bvh_parser.lua
- **Kind:** tool
- **Purpose:** This file is a Lua utility for parsing and processing BVH (motion capture) files in the iGame3D engine. It reads BVH headers, motions, and bone structures, computes local transformation matrices for frames, builds neutral poses and mesh bones, and saves the resulting mesh to the character BVH path. It is used to convert BVH motion data into engine-compatible bone and mesh definitions.
- **Depends on:** `Data/` folder paths for BVH files and character mesh output; globals `gBoneStart`, `gYMod`, `gFirstFrame`, `bvhmarker`, `gFrameTime`, `rootBone`, `buffer`, `fh`, `poses`; engine functions `get`, `setObjectInfo`, `setBoneInfo`, `matrixConcat`, `drawVertex`, `ig3d_MakeBoneFromVertex_2s`, `saveMesh`, `delete`; engine constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`; iterator function `itrtr`; helper functions `startTabsRemoved`, `loadAnotherBone`, `loadBVHHeader`, `createLocalMatricesForBVHFrame`, `calculatePoseFromLocalMatrices`, `loadBVHMotions`, `neutralPose`, `createMeshBones`, `loadBVHFile`.
- **Provides:** Functions for BVH parsing and processing: `startTabsRemoved`, `loadAnotherBone`, `loadBVHHeader`, `createLocalMatricesForBVHFrame`, `calculatePoseFromLocalMatrices`, `loadBVHMotions`, `neutralPose`, `createMeshBones`, `loadBVHFile`; globals `gBoneStart`, `gYMod`, `gFirstFrame`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced in this code).
- **Procedural:** yes - generates BVH frame local transformation matrices from BVH channel data, builds neutral poses and mesh bones from BVH bone data, and saves the resulting mesh to the character BVH path using the provided input data.
- **Glossary:**
  - BVH - Binary Hierarchical Structure, the motion capture format parsed and processed by this file.
  - BVH frame - a unit of motion data in a BVH file containing channel offsets, neutral coordinates, and child frames.
  - local transformation matrix - a matrix computed for a BVH frame to represent its local position and rotation offsets.
  - neutral pose - the zeroed rotation and position state of a bone, used as a base for mesh bone creation.
  - mesh bone - a bone created from a vertex and parent name to represent a mesh vertex in the BVH output.
- **Keep / port / drop:** keep - a reusable BVH parsing and matrix generation tool that converts BVH motion data into engine-compatible bone and mesh definitions for new engines.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines two module-level globals used by the BVH loading functions: `gBoneStart` (tracks the next available bone index), `gYMod` (unused in this part), and `gFirstFrame` (unused in this part).
- **Uses:** nothing
- **Reusable:** no

### startTabsRemoved
- **Does:** Strips leading whitespace (spaces or tabs) from a string and returns the trimmed string.
- **Uses:** `string.sub`
- **Reusable:** yes

### loadAnotherBone
- **Does:** Reads a BVH bone block from the file handle, parses its offset and channel definitions, recursively loads child bones, and returns a new bone table with the parsed properties.
- **Uses:** `string.sub`, `string.gmatch`, `table.insert`, `gBoneStart`, `startTabsRemoved`
- **Reusable:** no

### loadBVHHeader
- **Does:** Reads the BVH header lines from the file handle, extracts the root bone name, and loads the root bone via `loadAnotherBone`.
- **Uses:** `string.sub`, `loadAnotherBone`
- **Reusable:** no

## Part 2 of 4

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `createLocalMatricesForBVHFrame`.
- **Uses:** nothing
- **Reusable:** no

### createLocalMatricesForBVHFrame
- **Does:** Builds local transformation matrices for a BVH frame by iterating its channels, accumulating position and rotation offsets, concatenating rotation matrices, computing neutral offsets, and propagating the result to child frames.
- **Uses:** `bone` (BVH frame object with `channels`, `offx`, `offy`, `offz`, `neutralx`, `neutraly`, `neutralz`, `index`, `children`), `itrtr` (iterator function), `gFirstFrame` (global), `gYMod` (global), `bvhmarker` (global), `get`, `setObjectInfo`, `getObjectInfo`, `setBoneInfo`, `matrixConcat`, engine constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`, `IG3D_ROTATION_MATRIX` property access pattern
- **Reusable:** yes - pure matrix and BVH frame transformation logic, reusable for BVH frame matrix generation in similar engines
- **Procedural:** yes - generates local transformation matrices for a BVH frame from its channel data and child frames

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the three defined functions; the file contains only the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### calculatePoseFromLocalMatrices
- **Does:** Recursively accumulates the parent's neutral offsets into each bone's neutral coordinates, then recurses through all child bones to apply the same calculation.
- **Uses:** nothing
- **Reusable:** yes

### loadBVHMotions
- **Does:** Reads a BVH motion file handle, extracts frame count and frame time values from the file lines, reads all frame lines into a table, and returns the table of frame lines.
- **Uses:** `fh:read("*l")`, `string.gmatch`, `gFrameTime`, `table.insert`
- **Reusable:** yes

### neutralPose
- **Does:** Resets the rotation and position of the specified bone to zero, copies the bone's offset coordinates into its neutral coordinates, then recurses through all child bones to apply the same reset.
- **Uses:** `setBoneInfo`, `get(ig3d_bone, bvhmarker, bone.index)`, `IG3D_ROTATION`, `IG3D_POSITION`, `bone.offx`, `bone.offy`, `bone.offz`, `bone.children`
- **Reusable:** yes

### createMeshBones
- **Does:** For each bone with a parent, records the parent's name (or "None" if the parent is rootBone) and draws a vertex at the bone's neutral coordinates, then creates a mesh bone from the bone name and parent name. Recurses through all child bones to apply the same logic.
- **Uses:** `bone.parent`, `rootBone`, `bone.neutralx`, `bone.neutraly`, `bone.neutralz`, `bone.name`, `bone.children`, `drawVertex`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** yes
- **Procedural:** yes

## Part 4 of 4

### Top level
- **Does:** No top-level code exists outside the `loadBVHFile` function.
- **Uses:** nothing
- **Reusable:** no

### loadBVHFile
- **Does:** Reads the given BVH file, normalizes its line endings, loads the BVH header and motions, builds the neutral pose and mesh bones for the root bone, saves the resulting mesh to the character BVH path, and cleans up the temporary marker object.
- **Uses:** `io.open`, `string.gsub`, `make`, `loadBVHHeader`, `loadBVHMotions`, `neutralPose`, `calculatePoseFromLocalMatrices`, `createMeshBones`, `saveMesh`, `setObjectInfo`, `delete`, `IG3D_POSITION`, `bvhmarker`, `buffer`, `fh`, `poses`, `rootBone`
- **Reusable:** no
- **Procedural:** yes
