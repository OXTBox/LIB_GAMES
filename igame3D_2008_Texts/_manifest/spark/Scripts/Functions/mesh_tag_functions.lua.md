<!-- Spark first-look of Data/Scripts/Functions/mesh_tag_functions.lua (model spark-x2.6-4b, 2026-11-12 07:10). DRAFT for Claude to review. -->

## mesh_tag_functions.lua
- **Kind:** library
- **Purpose:** This file provides Lua functions for preparing and managing mesh tag data in the iGame3D engine, including mesh preparation, tagging and selection workflows, recursive mesh name printing, and tree conversion of the mesh tag list. It also includes a function to create new mesh tag entries and refresh their display.
- **Depends on:** Other Scripts/Functions Lua libraries, engine functions such as `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_ClusterMeshmesh_Tags`, `ig3d_SelectMeshmesh_Tags_s`, `ig3d_SelectMeshAttachedTomesh_Tags_s`, `ig3d_AttachVertexTomesh_Tags_s`, `ig3d_GetMeshmesh_TagsList__s`, `ig3d_Makemesh_TagsFromVertex_2s`, the `Data/` folder for loading WTF mesh files, the `removeSpaces` global, the `mesh_Tagslist` global, and FLTK UI components such as `meshmesh_Tags` and `mesh_Tagslist`.
- **Provides:** Functions `prepMeshFormesh_Tags`, `mesh_TagsMeshCluster`, `meshmesh_TagsClicked`, `selectmesh_TagsMesh`, `mesh_Tagsattacher`, `recursivemesh_TagsPrint`, `selmesh_TagsInListFromName`, `listmesh_Tags`, and `mesh_Tagsmaker`.
- **Assets it needs:** `Data/WTF/Characters/truemesh_TagsTpose.wtf` (mesh file loaded for tagging preparation).
- **Procedural:** none
- **Glossary:**
  - mesh_Tags - Engine-managed tag data attached to meshes for identification and organization.
  - ig3d_* calls - Engine function calls used to manipulate meshes, tags, and related objects.
  - mesh_Tagslist - Global list of mesh tag entries used for tree construction and display.
  - removeSpaces - Global function that strips spaces from input text for matching.
  - FLTK UI - User interface components used for input and display in the engine.
- **Keep / port / drop:** keep - core mesh tagging and list management logic that other engine files rely on for mesh tag workflows.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### prepMeshFormesh_Tags
- **Does:** Prepares a mesh for tagging by scaling it, setting its position to zero, making it invisible, and loading a specific tag mesh file.
- **Uses:** Engine calls `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `loadMesh`; file path `Data/WTF/Characters/truemesh_TagsTpose.wtf`.
- **Reusable:** no

### mesh_TagsMeshCluster
- **Does:** Shows all meshes and clusters the selected mesh for tagging.
- **Uses:** Engine calls `ig3d_ShowAll`, `ig3d_ClusterMeshmesh_Tags`.
- **Reusable:** no

### meshmesh_TagsClicked
- **Does:** Checks if a clicked value is non-zero, then selects the mesh matching the cleaned text value.
- **Uses:** Engine call `ig3d_SelectMeshmesh_Tags_s`; global `removeSpaces`; widget access `w:value()`, `w:text(w:value())`.
- **Reusable:** no

### selectmesh_TagsMesh
- **Does:** Selects the mesh matching the cleaned text value from the mesh tag widget.
- **Uses:** Engine call `ig3d_SelectMeshAttachedTomesh_Tags_s`; global `removeSpaces`; widget access `meshmesh_Tags:text`, `meshmesh_Tags:value`.
- **Reusable:** no

### mesh_Tagsattacher
- **Does:** Attaches the mesh matching the cleaned text value from the mesh tag widget.
- **Uses:** Engine call `ig3d_AttachVertexTomesh_Tags_s`; global `removeSpaces`; widget access `meshmesh_Tags:text`, `meshmesh_Tags:value`.
- **Reusable:** no

### recursivemesh_TagsPrint
- **Does:** Recursively prints mesh names into the mesh tag list, building a tab-indented string for each node in the mesh hierarchy.
- **Uses:** Widget access `meshmesh_Tags:add`; global `b.name`, `b.subs`.
- **Reusable:** no

### selmesh_TagsInListFromName
- **Does:** Searches the mesh tag list for a name matching the cleaned input, and sets the matching list item's value.
- **Uses:** Global `removeSpaces`, `mesh_Tagslist`, `meshmesh_Tags:text`, `meshmesh_Tags:value`.
- **Reusable:** no

## Part 2 of 2

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### listmesh_Tags
- **Does:** Converts the returned mesh_Tags list into a tree structure, builds parent/child relationships, clears the mesh_Tags display, and prints the tree using recursion.
- **Uses:** engine calls (`ig3d_GetMeshmesh_TagsList__s`), globals (`mesh_Tagslist`, `bdepth`, `meshmesh_Tags`), and no file or `Data/` paths.
- **Reusable:** yes - pure data transformation and tree construction logic.

### mesh_Tagsmaker
- **Does:** Prompts the user for a new mesh_Tags name and parent mesh_Tags name via FLTK input, creates the mesh_Tags using the engine call, then refreshes the mesh_Tags list display.
- **Uses:** engine calls (`ig3d_Makemesh_TagsFromVertex_2s`, `listmesh_Tags`), globals (`fltk`), and no file or `Data/` paths.
- **Reusable:** no - tied to the specific mesh_Tags creation workflow.
- **Procedural:** no
