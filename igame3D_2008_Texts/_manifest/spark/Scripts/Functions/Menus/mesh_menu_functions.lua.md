<!-- Spark first-look of Data/Scripts/Functions/Menus/mesh_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:22). DRAFT for Claude to review. -->

## mesh_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines the mesh menu structure and its fill, pick, save, and callback logic for the iGame3D 3D engine. It builds the mesh menu index from menu text tables, routes mesh editing actions through pick handlers, and provides functions to save the selected mesh as WTF, OBJ, 3DS, and Meshwork files.
- **Depends on:** Other Scripts/Functions/Menus files or globals set elsewhere; globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`, `gMapMeshPath`, and helper functions `fastFilePaths`; engine functions such as `ig3d_DuplicateMesh`, `ig3d_ExtrudeSelectedMesh_fb`, `ig3d_SaveMeshAsWTF_sf`, and `ig3d_MirrorSelectedMesh_3i`; Data/ folders for WTF, OBJ, 3DS, Meshwork, and Scripts/Functions/Menus paths.
- **Provides:** Functions `fillMeshbase`, `fillMeshSelect`, `fillMeshFace`, `fillMeshView`, `fillMeshMirror`, `fill_MeshMenu`, `meshBasePick`, `meshSelectPick`, `meshFacePick`, `meshViewPick`, `meshMirrorPick`, `save_asWTF`, `save_asOBJ`, `save_as3DS`, `save_asMeshWork`, `mesh_menu_callback`, plus globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** yes - the mesh menu index and menu entries are generated from the `MeshMenuText` tables and menu line entries, and default WTF/OBJ/3DS/Meshwork file paths are generated under the Data/ folders using `fastFilePaths`.
- **Glossary:**
  - mesh menu - the FLTK menu structure for selecting and editing mesh data in iGame3D.
  - mesh pick - the action routing logic that maps a selected menu option to a mesh editing engine function.
  - WTF - iGame3D 3D model file format stored under the Data/WTF folder.
  - mesh mirror - mirroring an iGame3D mesh along a defined axis using MIRRORX, MIRRORY, or MIRRORZ constants.
  - mesh menu callback - the FLTK button callback that handles mesh menu button interactions and dispatches pick actions.
- **Keep / port / drop:** keep - it is a complete, reusable mesh menu implementation with clear fill, pick, and save logic for reuse in a new iGame3D-based engine.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the Mesh menu structure and fills the mesh menu index with menu line entries.
- **Uses:** Globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`; no engine calls, files or Data/ paths.

### fillMeshbase
- **Does:** Fills the base mesh menu entries from `MeshMenuText.base`, appending each menu line to the mesh menu and recording it in `MeshMenuIndex`.
- **Uses:** Globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`; no engine calls, files or Data/ paths.
- **Reusable:** yes - pure menu text generation and index bookkeeping.

### fillMeshSelect
- **Does:** Fills the select mesh menu entries from `MeshMenuText.Select`, appending each menu line to the mesh menu and recording it in `MeshMenuIndex`.
- **Uses:** Globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`; no engine calls, files or Data/ paths.
- **Reusable:** yes - pure menu text generation and index bookkeeping.

### fillMeshFace
- **Does:** Fills the face mesh menu entries from `MeshMenuText.Face`, appending each menu line to the mesh menu and recording it in `MeshMenuIndex`.
- **Uses:** Globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`; no engine calls, files or Data/ paths.
- **Reusable:** yes - pure menu text generation and index bookkeeping.

### fillMeshView
- **Does:** Fills the view mesh menu entries from `MeshMenuText.View`, appending each menu line to the mesh menu and recording it in `MeshMenuIndex`.
- **Uses:** Globals `MeshMenuIndex`, `MeshMenuText`, `meshIndexCount`, `meshMenu`; no engine calls, files or Data/ paths.
- **Reusable:** yes - pure menu text generation and index bookkeeping.

## Part 2 of 3

### Top level
- **Does:** No top-level code outside the function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### fillMeshMirror
- **Does:** Appends the "Mirror" menu entry to the mesh menu index, then copies the existing Mirror menu text entries into the menu and index arrays.
- **Uses:** MeshMenuIndex, MeshMenuText, meshMenu (no Data/ paths or engine calls used)
- **Reusable:** yes

### fill_MeshMenu
- **Does:** Fills the mesh menu index by calling the mesh menu fill functions for base, select, face, view, and mirror entries in sequence.
- **Uses:** fillMeshbase, fillMeshSelect, fillMeshFace, fillMeshView, fillMeshMirror (no Data/ paths or engine calls used)
- **Reusable:** yes

### meshBasePick
- **Does:** Routes mesh base pick actions based on the selected pick option, invoking the corresponding mesh editing engine function or setting the action value.
- **Uses:** tPick, action, extrudeDepth, ig3d_DuplicateMesh, ig3d_ExtrudeSelectedMesh_fb, ig3d_CombineSelectedMeshOverlaps_f, ig3d_SubdivideMesh, ig3d_DeleteMesh_b (no Data/ paths used)
- **Reusable:** no

### meshSelectPick
- **Does:** Routes mesh selection pick actions based on the selected pick option, invoking the corresponding mesh selection engine function or leaving the same-material and same-tag options unhandled.
- **Uses:** tPick, meshBones, ig3d_SelectWholeMesh, ig3d_SelectConnectedMesh, ig3d_InvertMeshSelection, ig3d_SelectMeshAttachedToBone_s, removeSpaces (no Data/ paths used)
- **Reusable:** no

### meshFacePick
- **Does:** Routes mesh face pick actions based on the selected pick option, invoking the corresponding face editing engine function or leaving the option unhandled.
- **Uses:** tPick, faceMeshIn, faceMeshOut, ig3d_InvertMeshFaces (no Data/ paths used)
- **Reusable:** no

### meshViewPick
- **Does:** Routes mesh view pick actions based on the selected pick option, invoking the corresponding mesh view engine function or leaving the option unhandled.
- **Uses:** tPick, ig3d_MakeInvisible, ig3d_ShowAll (no Data/ paths used)
- **Reusable:** no

## Part 3 of 3

### Top level
- **Does:** No top-level code outside the defined functions; the file contains only the function definitions listed.
- **Uses:** nothing
- **Reusable:** no

### meshMirrorPick
- **Does:** Sets the mirror axis for the selected mesh based on the given index value, using the MIRRORX, MIRRORY, or MIRRORZ constants.
- **Uses:** engine call `ig3d_MirrorSelectedMesh_3i`, parameter `tIndex`
- **Reusable:** yes

### save_asWTF
- **Does:** Saves the selected mesh as a WTF file, using the existing map mesh path if set, otherwise generating a default WTF path under the WTF folder.
- **Uses:** engine call `ig3d_SaveMeshAsWTF_sf`, globals `gMapMeshPath`, helper `fastFilePaths`, file path `Data/WTF/.wtf`
- **Reusable:** yes

### save_asOBJ
- **Does:** Saves the selected mesh as an OBJ file using a default OBJ path generated under the OBJ folder.
- **Uses:** engine call `ig3d_SaveMeshAsOBJ_sf`, helper `fastFilePaths`, file path `Data/OBJ/.obj`
- **Reusable:** yes

### save_as3DS
- **Does:** Saves the selected mesh as a 3DS file using a default 3DS path generated under the 3DS folder.
- **Uses:** engine call `ig3d_SaveMeshAs3DS_sf`, helper `fastFilePaths`, file path `Data/3DS/.3ds`
- **Reusable:** yes

### save_asMeshWork
- **Does:** Saves the selected mesh as a Meshwork file using a default Meshwork path generated under the Meshwork folder.
- **Uses:** engine call `ig3d_SaveMeshAsMeshwork_sf`, helper `fastFilePaths`, file path `Data/Meshwork/.mesh`
- **Reusable:** yes

### mesh_menu_callback
- **Does:** Handles the mesh menu button callback by reading the button's label, value, and text, mapping the value to a menu index, and dispatching the pick action based on the selected menu head.
- **Uses:** engine calls `item`, `Fl:check()`, `io.flush()`, globals `MeshMenuIndex`, `tMenu`, `tVal`, `tPick`, `tIndex`, `tIndex1`, `tIndex2`, `meshmenuHead`, helper functions `meshBasePick`, `meshSelectPick`, `meshFacePick`, `meshViewPick`, `meshMirrorPick`, file path `Data/Scripts/Functions/Menus`
- **Reusable:** yes

### Top level
- **Does:** No top-level code outside the defined functions; the file contains only the function definitions listed.
- **Uses:** nothing
- **Reusable:** no
