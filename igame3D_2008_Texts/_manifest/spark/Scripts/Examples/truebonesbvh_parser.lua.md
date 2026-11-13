<!-- Spark first-look of Data/Scripts/Examples/truebonesbvh_parser.lua (model spark-x2.6-4b, 2026-11-12 15:08). DRAFT for Claude to review. -->

## truebonesbvh_parser.lua
- **Kind:** converter
- **Purpose:** This file is a Lua converter that reads BVH motion capture files and builds a 3D character skeleton from their bone and frame data. It parses BVH headers and motion lines, computes per-frame local matrices for each bone, generates mesh bones for the skeleton, and writes a skeleton model file for use in the engine.
- **Depends on:** `Data/` folder paths (e.g., `Data/WTF/Characters/truebonesbvh.wtf`), global variables such as `bvhmarker`, `gFirstFrame`, `gYMod`, and engine globals including `ig3d_scene`, `ig3d_object`, `ig3d_bone`, and constants such as `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`; it loads BVH files via file handles and uses engine calls for object and bone manipulation.
- **Provides:** Functions for BVH parsing and skeleton generation, including `startTabsRemoved`, `loadAnotherBone`, `loadBVHHeader`, `loadIdentityMatrix`, `createLocalMatricesForBVHFrame`, `calculatePoseFromLocalMatrices`, `loadBVHMotions`, `neutralPose`, `createMeshBones`, and `loadBVHFile`.
- **Assets it needs:** none (it generates its output model rather than loading named model, image, sound, emitter, or font assets).
- **Procedural:** yes - it generates a skeleton WTF model file from parsed BVH motion data and per-frame bone channel values, and builds mesh bones and local matrices from numeric BVH data instead of loading pre-existing assets.
- **Glossary:**
  - BVH - Binary Hierarchical Skeleton format for motion capture data, parsed by this file into bone and frame structures.
  - `bvhmarker` - global marker object used to apply and propagate bone transforms during BVH processing.
  - `gFirstFrame` - global controlling the start index for bone indexing during BVH loading.
  - `gYMod` - global controlling vertical motion handling during BVH processing.
  - `IG3D_POSITION` - engine constant naming the position property read or set on objects and bones.
  - `IG3D_ROTATION` - engine constant naming the rotation property read or set on objects and bones.
  - `IG3D_ROTATION_MATRIX` - engine constant naming the rotation matrix property read or set on objects and bones.
  - `setBoneInfo` - engine call used to set properties on a bone, such as rotation and position.
- **Keep / port / drop:** keep - it is a reusable BVH-to-skeleton converter with clear parsing and transform-propagation logic for a new engine.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Defines global variables controlling BVH loading behavior and the start index for bone indexing.
- **Uses:** nothing
- **Reusable:** no

### startTabsRemoved
- **Does:** Strips leading whitespace (spaces or tabs) from a string and returns the trimmed string.
- **Uses:** nothing
- **Reusable:** yes

### loadAnotherBone
- **Does:** Reads a BVH bone section from the file handle, parses its offset and channel data, recursively loads child bones, and returns the constructed bone table.
- **Uses:** `startTabsRemoved`, `string.gmatch`, `string.sub`
- **Reusable:** no

### loadBVHHeader
- **Does:** Reads the BVH header lines, extracts the root bone name, and loads the root bone via `loadAnotherBone`.
- **Uses:** `loadAnotherBone`, `string.sub`, `fh:read`
- **Reusable:** no

### loadIdentityMatrix
- **Does:** Returns the 4x4 identity matrix as a flat list of 16 numbers.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 4

### Top level
- **Does:** No top-level code outside the function definition; the file contains only the function `createLocalMatricesForBVHFrame`.
- **Uses:** nothing
- **Reusable:** no

### createLocalMatricesForBVHFrame
- **Does:** Recursively builds local matrices for each frame of a BVH bone, applying rotation and position channels to a marker object and propagating child bone transforms.
- **Uses:** `loadIdentityMatrix()`, `beep()`, `setObjectInfo`, `getObjectInfo`, `matrixConcat`, `get(ig3d_bone, bvhmarker, bone.index)`, `setBoneInfo`, globals `bvhmarker`, `gFirstFrame`, `gYMod`, `ig3d_bone`, constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`, `IG3D_ROTATION_MATRIX`
- **Reusable:** yes - pure matrix transformation and recursive transform propagation logic for BVH bones.
- **Procedural:** yes - generates per-frame local matrices for a BVH bone based on its channel values.

## Part 3 of 4

### Top level
- **Does:** No top-level code exists outside the three defined functions; the file contains only the function definitions for the listed functions.
- **Uses:** nothing
- **Reusable:** no

### calculatePoseFromLocalMatrices
- **Does:** Recursively accumulates the parent's neutral offsets into each bone's neutral coordinates, then recurses through all child bones to apply the same accumulation.
- **Uses:** nothing
- **Reusable:** yes

### loadBVHMotions
- **Does:** Reads the BVH motion file header lines, parses the frame count and frame time values from the lines, reads all frame data lines into a table, and returns the table of frame lines.
- **Uses:** `fh:read("*l")` (file read call), `string.gmatch`, `gFrameTime` (global assignment)
- **Reusable:** yes

### neutralPose
- **Does:** Resets the rotation and position of the specified bone to zero, copies the bone's offset coordinates into its neutral coordinates, then recurses through all child bones to apply the same reset.
- **Uses:** `setBoneInfo`, `get(ig3d_bone, bvhmarker, bone.index)`, `IG3D_ROTATION`, `IG3D_POSITION`, `bone.offx`, `bone.offy`, `bone.offz`, `bone.children`
- **Reusable:** yes

### createMeshBones
- **Does:** Recursively creates mesh bones for each bone: for bones with a parent, draws a vertex at the scaled neutral position, sets the mesh position, and creates a bone from the vertex, then recurses through all child bones.
- **Uses:** `drawVertex`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeBoneFromVertex_2s`, `bone.parent`, `rootBone`, `bone.name`, `bone.neutralx`, `bone.neutraly`, `bone.neutralz`, `bone.children`
- **Reusable:** yes
- **Procedural:** yes

## Part 4 of 4

### Top level
- **Does:** No top-level code outside the `loadBVHFile` function; the file contains only the function definition and its body.
- **Uses:** nothing
- **Reusable:** no

### loadBVHFile
- **Does:** Loads a BVH file, normalizes its line endings, parses its header and motion data, calculates the root bone pose, optionally generates and saves a skeleton WTF file, then replaces the bullet marker object with the truebonesmaster model and sets its position.
- **Uses:** `delete(ig3d_scene, false)`, `make(ig3d_object, ...)`, `setObjectInfo(obj, IG3D_NAME, ...)`, `setObjectInfo(obj, IG3D_POSITION, ...)`, `fltk.fl_message(...)`, `loadBVHHeader(fh)`, `loadBVHMotions(fh)`, `neutralPose(rootBone)`, `calculatePoseFromLocalMatrices(rootBone)`, `createMeshBones(rootBone)`, `saveMesh("Data/WTF/Characters/truebonesbvh.wtf")`, `io.open(fileName, "r")`, `io.open(fileName, "w")`, `string.gsub(buffer, "\r\n", "\n")`, `ig3d_scene`, `ig3d_object`, `IG3D_NAME`, `IG3D_POSITION`
- **Reusable:** no
- **Procedural:** yes
