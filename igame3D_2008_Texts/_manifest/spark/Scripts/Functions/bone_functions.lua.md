<!-- Spark first-look of Data/Scripts/Functions/bone_functions.lua (model spark-x2.6-4b, 2026-11-12 06:32). DRAFT for Claude to review. -->

## bone_functions.lua
- **Kind:** library
- **Purpose:** This file provides Lua functions for managing mesh bones, their attached meshes, vertex attachments, and the bone hierarchy tree used by the iGame3D engine. It also includes helper functions for building new bones and refreshing the bone list display.
- **Depends on:** `Data/` folder paths (e.g., `Data/WTF/Characters/truebonesTpose.wtf`), engine calls such as `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_ClusterMeshBones`, `ig3d_SelectMeshBone_s`, `ig3d_SelectMeshAttachedToBone_s`, `ig3d_AttachVertexToBone_s`, `ig3d_GetMeshBonesList__s`, `ig3d_MakeBoneFromVertex_2s`, and globals including `meshBones`, `w`, `removeSpaces`, `bdepth`, `bonelist`, `recursiveBonePrint`, `bonelist`, and `fltk.fl_input`.
- **Provides:** Functions `prepMeshForBones`, `boneMeshCluster`, `meshBonesClicked`, `selectBoneMesh`, `boneattacher`, `recursiveBonePrint`, `selBoneInListFromName`, `listBones`, and `bonemaker`.
- **Assets it needs:** `Data/WTF/Characters/truebonesTpose.wtf` (mesh file loaded by `prepMeshForBones`).
- **Procedural:** none
- **Glossary:**
  - mesh bone - A bone attached to a mesh in the iGame3D engine, used to control mesh transforms and vertex attachments.
  - truebonesTpose - The mesh file containing the truebone tpose data loaded by `prepMeshForBones`.
  - mesh bone list - The list of bones returned by `ig3d_GetMeshBonesList__s`, parsed into a tree structure by `listBones`.
  - mesh bone widget - A FLTK UI widget (`meshBones`) used to display and select mesh bone names.
  - cluster mesh bones - The engine operation `ig3d_ClusterMeshBones` that groups selected mesh bones for display.
- **Keep / port / drop:** keep - Core bone management logic that other engine scripts rely on for mesh and bone operations.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** The file contains no setup, global declarations, or widget definitions outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### prepMeshForBones
- **Does:** Resets the selected mesh transform, sets its position to zero, makes it invisible, and loads the truebonesTpose mesh from the Data folder.
- **Uses:** Engine calls `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `loadMesh`; file path `Data/WTF/Characters/truebonesTpose.wtf`.
- **Reusable:** no

### boneMeshCluster
- **Does:** Shows all meshes and clusters the selected mesh bones.
- **Uses:** Engine calls `ig3d_ShowAll`, `ig3d_ClusterMeshBones`.
- **Reusable:** no

### meshBonesClicked
- **Does:** Checks the clicked mesh bone widget value, and if it is non-zero, selects the mesh bone whose name matches the cleaned text of the widget.
- **Uses:** Engine call `ig3d_SelectMeshBone_s`; globals `w`, `removeSpaces`; widget `w` with `text` and `value` methods.
- **Reusable:** no

### selectBoneMesh
- **Does:** Selects the mesh attached to the bone whose name matches the cleaned text of the mesh bone widget.
- **Uses:** Engine call `ig3d_SelectMeshAttachedToBone_s`; globals `removeSpaces`, `meshBones` (widget with `text` and `value` methods).
- **Reusable:** no

### boneattacher
- **Does:** Attaches the vertex to the bone whose name matches the cleaned text of the mesh bone widget.
- **Uses:** Engine call `ig3d_AttachVertexToBone_s`; globals `removeSpaces`, `meshBones` (widget with `text` and `value` methods).
- **Reusable:** no

### recursiveBonePrint
- **Does:** Recursively prints the names of the given bone and its subs, appending a tab character for each level of recursion, to the mesh bone list.
- **Uses:** Globals `meshBones` (widget with `add` method); no engine calls or file paths.
- **Reusable:** no

### selBoneInListFromName
- **Does:** Iterates the mesh bone list, compares each cleaned entry to the given name, and selects the matching entry by setting its value.
- **Uses:** Engine call `meshBones:value` (widget method); globals `removeSpaces`, `meshBones` (widget with `text` and `value` methods).
- **Reusable:** no

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the `listBones` and `bonemaker` functions.
- **Uses:** `ig3d_GetMeshBonesList__s`, `ig3d_MakeBoneFromVertex_2s`, `fltk.fl_input`, `meshBones`, `bdepth`, `recursiveBonePrint`, `bonelist` (local tables), and string manipulation utilities.
- **Reusable:** no
- **Procedural:** no

### listBones
- **Does:** Parses the returned mesh bone list into a tree structure with name, numeric index, parent and child subsections, then clears the display bone list and prints the tree via recursion.
- **Uses:** `ig3d_GetMeshBonesList__s`, `meshBones:clear`, `recursiveBonePrint`, local tables `bonelist`, `bdepth`, and string parsing utilities (`string.gmatch`, `string.find`, `string.sub`).
- **Reusable:** no
- **Procedural:** no

### bonemaker
- **Does:** Prompts the user for a new bone name and parent bone name via a FLTK input dialog, creates the bone with the specified parent using the engine bone creation call, refreshes the bone list, and leaves the parent selection call commented out.
- **Uses:** `fltk.fl_input`, `ig3d_MakeBoneFromVertex_2s`, `listBones`, local string parsing utilities (`string.find`, `string.sub`), and the commented `selBoneInListFromName` call.
- **Reusable:** no
- **Procedural:** no
