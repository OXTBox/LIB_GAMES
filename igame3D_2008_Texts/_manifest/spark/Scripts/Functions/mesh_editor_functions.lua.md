<!-- Spark first-look of Data/Scripts/Functions/mesh_editor_functions.lua (model spark-x2.6-4b, 2026-11-12 07:08). DRAFT for Claude to review. -->

## mesh_editor_functions.lua
- **Kind:** tool
- **Purpose:** This file provides mesh editing utilities for the iGame3D engine, including mesh alignment, selection and duplication controls, mesh modification operations, and bone creation helpers for selected meshes. It contains no setup or top-level code, only standalone functions that configure or manipulate meshes through engine calls and FLTK UI interactions.
- **Depends on:** engine functions such as `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_DuplicateMesh`, `ig3d_MakeInvisible`, `ig3d_InvertMeshSelection`, `ig3d_SelectWholeMesh`, `ig3d_ShowAll`, `ig3d_SubdivideMesh`, `ig3d_ExtrudeSelectedMesh_fb`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_SetLineWidth_f`, `ig3d_SetPointSize_f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MeshFaceAwayFromCamera`, `ig3d_InvertMeshFaces`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineSelectedMeshOverlaps_f`, `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_MagicCatch_fb`, `ig3d_TellFocus_b`, `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`, `ig3d_SetBackfaceCulling_b`, `ig3d_SetMeshZBuffering_b`, `ig3d_SetMeshPosition_3f`, `

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### alignIt
- **Does:** Aligns the mesh size and triggers mesh alignment.
- **Uses:** `ig3d_SetMeshAlignmentSize_f`, `ig3d_AlignMesh`
- **Reusable:** yes

### backfaceControlClicked
- **Does:** Toggles backface culling based on the button value.
- **Uses:** `ig3d_SetBackfaceCulling_b`
- **Reusable:** yes

### DoMagic
- **Does:** Calls the magic catch function with the magic value and a toggle flag based on the button value.
- **Uses:** `ig3d_MagicCatch_fb`, globals `magicCyl`, `magicValue`
- **Reusable:** yes

### duplicateButtonClicked
- **Does:** Duplicates the selected mesh.
- **Uses:** `ig3d_DuplicateMesh`
- **Reusable:** yes

### hideSelectionClicked
- **Does:** Makes the selected mesh invisible.
- **Uses:** `ig3d_MakeInvisible`
- **Reusable:** yes

### invertSelectionClicked
- **Does:** Inverts the current mesh selection.
- **Uses:** `ig3d_InvertMeshSelection`
- **Reusable:** yes

### selectAllClicked
- **Does:** Selects the whole mesh.
- **Uses:** `ig3d_SelectWholeMesh`
- **Reusable:** yes

### showAllClicked
- **Does:** Shows all objects.
- **Uses:** `ig3d_ShowAll`
- **Reusable:** yes

### selectConnectedClicked
- **Does:** Selects the mesh connected to the current selection.
- **Uses:** `ig3d_SelectConnectedMesh`
- **Reusable:** yes

### subdivideClicked
- **Does:** Subdivides the selected mesh.
- **Uses:** `ig3d_SubdivideMesh`
- **Reusable:** yes

### extrudeButtonClicked
- **Does:** Extrudes the selected mesh by the configured depth with the true flag.
- **Uses:** `ig3d_ExtrudeSelectedMesh_fb`, globals `extrudeDepth`
- **Reusable:** yes

### zbufferControlClicked
- **Does:** Toggles mesh z-buffering based on the button value.
- **Uses:** `ig3d_SetMeshZBuffering_b`
- **Reusable:** yes

### handlePositionValueFields
- **Does:** Tells the engine the input field has focus, waits for Enter, then sets the mesh position from the field values.
- **Uses:** `ig3d_TellFocus_b`, `ig3d_SetMeshPosition_3f`, `Fl:event_key`, globals `xpos`, `ypos`, `zpos`
- **Reusable:** yes

### handleScaleValueFields
- **Does:** Tells the engine the input field has focus, waits for Enter, then sets the mesh scale from the field values.
- **Uses:** `ig3d_TellFocus_b`, `ig3d_ScaleSelectedMesh_3f`, `Fl:event_key`, globals `xsize`, `ysize`, `zsize`
- **Reusable:** yes

## Part 2 of 4

### Top level
- **Does:** No setup, globals, widget definitions or other code outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### handleGetButton
- **Does:** Retrieves the centroid coordinates of the current mesh and writes them into the xpos, ypos and zpos value fields.
- **Uses:** engine calls `ig3d_GetMeshCentroid__3f()`; globals `xpos`, `ypos`, `zpos`.
- **Reusable:** yes

### handleGetSizeButton
- **Does:** Retrieves the mesh width, height and depth values and writes them into the xsize, ysize and zsize value fields.
- **Uses:** engine call `meshHWD()`; globals `xsize`, `ysize`, `zsize`.
- **Reusable:** yes

### handleExtrudeValueField
- **Does:** Tells the engine the input field has focus, checks whether the Enter key was pressed, and if so triggers the extrude button click.
- **Uses:** engine calls `ig3d_TellFocus_b(true)`; globals `extrudeButtonClicked`, `Fl:event_key()`, `fltk.FL_Enter`, `fltk.FL_KP_Enter`.
- **Reusable:** yes

### handlelinewidth
- **Does:** Reads the value of the given width widget and sets the mesh line width using the engine call.
- **Uses:** engine call `ig3d_SetLineWidth_f`; widget `w`.
- **Reusable:** yes

### handlepointwidth
- **Does:** Reads the value of the given point size widget and sets the mesh point size using the engine call.
- **Uses:** engine call `ig3d_SetPointSize_f`; widget `w`.
- **Reusable:** yes

### removeSpaces
- **Does:** Removes all tab and space characters from the input string and returns the cleaned string.
- **Uses:** no engine calls, globals or files; operates on the passed string argument.
- **Reusable:** yes

### faceMeshIn
- **Does:** Calls the engine function to orient the mesh faces away from the camera.
- **Uses:** engine call `ig3d_MeshFaceAwayFromCamera()`.
- **Reusable:** yes

### faceMeshOut
- **Does:** Calls the engine function to orient the mesh faces away from the camera, then inverts the mesh faces.
- **Uses:** engine calls `ig3d_MeshFaceAwayFromCamera()`, `ig3d_InvertMeshFaces()`.
- **Reusable:** yes

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the functions listed below.
- **Uses:** nothing
- **Reusable:** no

### boneComponents
- **Does:** Iterates over visible vertices in the selected mesh, creates an invisible bone for each component, and attaches the vertex to the corresponding bone, then shows all objects.
- **Uses:** engine calls `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_GetMeshCentroid__3f`, `drawVertex`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_MakeInvisible`, `ig3d_AttachVertexToBone_s`, `ig3d_ShowAll`; no files or Data/ paths read or written.
- **Reusable:** no

### boneComponentsExtruding
- **Does:** Same vertex iteration and bone creation logic as boneComponents, but first extrudes the selected mesh with the provided extrusion value before creating and attaching the bones, then shows all objects.
- **Uses:** engine calls `ig3d_SelectAVisibleVertex__b`, `ig3d_SelectConnectedMesh`, `ig3d_ExtrudeSelectedMesh_fb`, `ig3d_GetMeshCentroid__3f`, `drawVertex`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_MakeInvisible`, `ig3d_AttachVertexToBone_s`, `ig3d_ShowAll`; no files or Data/ paths read or written.
- **Reusable:** no
- **Procedural:** no

## Part 4 of 4

### Top level
- **Does:** No top-level code outside the `boneCarComponents` function.
- **Uses:** nothing
- **Reusable:** no

### boneCarComponents
- **Does:** Creates a bone for each unique wheel component of a selected mesh by iterating visible vertices, grouping them by position, and attaching each vertex to its corresponding bone.
- **Uses:** engine calls `ig3d_SelectWholeMesh()`, `ig3d_CombineSelectedMeshOverlaps_f(0.02)`, `ig3d_SelectAVisibleVertex__b()`, `ig3d_SelectConnectedMesh()`, `ig3d_GetMeshCentroid__3f()`, `ig3d_MakeBoneFromVertex_2s()`, `ig3d_AttachVertexToBone_s()`, `ig3d_MakeInvisible()`, `ig3d_ShowAll()`; no globals, files or `Data/` paths.
- **Reusable:** no
- **Procedural:** yes
