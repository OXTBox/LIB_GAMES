<!-- Spark first-look of Data/Scripts/Functions/mesh_tool_functions.lua (model spark-x2.6-4b, 2026-11-12 20:51). DRAFT for Claude to review. -->

## mesh_tool_functions.lua
- **Kind:** tool
- **Purpose:** This file provides mesh editing tools for the iGame3D engine, including loading and configuring floor, wall, and drop meshes, drawing grid-aligned mesh geometry, duplicating and transforming meshes, and converting level or mesh object tables into saved mesh files. It supports mesh tool operations such as selecting mesh tools, creating tagged mesh objects, and applying position, scale, and rotation transforms to meshes.
- **Depends on:** engine calls `ig3d_SetMeshTool_i`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_InvertMeshFaces`, `ig3d_RotateSelectedMesh_6f`, `ig3d_SaveMesh_sf_b`, `ig3d_ShowAll`, `ig3d_MakeInvisible`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `ig3d_ShowAll`, `ig3d_GetMode__i`; globals `gFloorMesh`, `gEWWallMesh`, `gNSWallMesh`, `nTagNumber`, `meshTagListTable`, `theMesh`, `TheFloor`, `meshx`, `meshy`, `meshz`, `vcubewidth`, `vcubelength`, `savedmode`, `bonesgroup`, `uvmappinggroup`, `materialsgroup`, `magicgroup`, `gEditingMode`, `WEWall`, `NSWall`, `theDropMeshTagNumber`, `theDropMesh`, `gMeshExclusionList`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `zObjectWTFs`, `zObjectNames`, `zObjectSizes`, `zObjectRotations`, `zObjectPositions`, `whichLevel`, `whichobject`, `whichfile`, `gObjects`, `gameroot`, `l2m`, `drawVertex`, `drawLine`, `loadstring`, `loadLevel`, `render`, `math.floor`, `string.find`, `string.sub`, `string.gsub`, `io.open`, `boneName`, `meshdone`, `camera_face_xyz`; Data/ paths `Data/WTF/Floors/snowfloor2x2.wtf`, `Data/WTF/Walls/NSwall2x2snow.wtf`, `Data/WTF/Walls/EWwall2x2snow.wtf`, `Data/Levels/<Folder>/load script.lua`, `gameroot.."Data/WTF/"`.
- **Provides:** `setMeshTool`, `loadTheFloor`, `loadTheWalls`, `mesh_drawQuad`, `idrawWallZ`, `icopyFloors`, `icopyRoofs`, `icopyWalls`, `loadAModelTemplate`, `iCopyWTFXY`, `loadCubeWalls`, `icopyCubeWalls`, `convertLevelObjectsToMesh`, `convertMeshObjectsTableToMesh`, `convertMeshObjectsTablesToMeshFile`, and global `l2m = convertLevelObjectsToMesh`.
- **Assets it needs:** `Data/WTF/Floors/snowfloor2x2.wtf`, `Data/WTF/Walls/NSwall2x2snow.wtf`, `Data/WTF/Walls/EWwall2x2snow.wtf`.
- **Procedural:** yes - generates wall mesh geometry and mesh tags for faces, generates grid-aligned quad meshes, duplicates and transforms meshes, and converts level or mesh object tables into saved mesh files using computed positions, scales, and rotations.
- **Glossary:** mesh tool - the editing tool selection for manipulating meshes in iGame3D; mesh tag - a tagged mesh object created with `ig3d_CreateMesh_tag_s` for individual mesh objects; mesh centroid - the center point of a mesh retrieved with `ig3d_GetMeshCentroid__3f`; mesh face - a face of a mesh used for wall and quad geometry; mesh duplication - copying a mesh into a new tagged mesh with `ig3d_DuplicateMesh`; mesh conversion - converting level or mesh object tables into saved mesh files.
- **Keep / port / drop:** keep - core mesh editing and conversion logic reusable for new mesh tool implementations.

---

# Part notes

## Part 1 of 9

### Top level
- **Does:** Contains three top-level lines that set global mesh path variables: `gFloorMesh`, `gEWWallMesh` and `gNSWallMesh`, plus the function definitions `setMeshTool` and `loadTheFloor`.
- **Uses:** Globals `gFloorMesh`, `gEWWallMesh`, `gNSWallMesh`; engine calls `ig3d_SetMeshTool_i`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`; globals `nTagNumber`, `meshTagListTable`, `meshTagListTable`, `theMesh`, `TheFloor`, `meshx`, `meshy`, `meshz`, `vcubewidth`, `vcubelength`, `savedmode`, `bonesgroup`, `uvmappinggroup`, `materialsgroup`, `magicgroup`, `gEditingMode`; paths `Data/WTF/Floors/snowfloor2x2.wtf`, `Data/WTF/Walls/NSwall2x2snow.wtf`, `Data/WTF/Walls/EWwall2x2snow.wtf`.
- **Reusable:** no

### setMeshTool
- **Does:** Sets the mesh editing tool selection, shows the matching editing group, and applies the chosen mesh tool mode. It reads the selected label to decide which group to display and which tool mode to apply.
- **Uses:** Engine calls `hideAllGroups()`, `Translate:show()`, `ig3d_SetMeshTool_i`; globals `gEditingMode`, `bonesgroup`, `uvmappinggroup`, `materialsgroup`, `magicgroup`; engine calls `w:label()`.
- **Reusable:** no

### loadTheFloor
- **Does:** Loads the configured floor mesh, creates a tagged mesh object, scales it to the level dimensions, repositions it, and returns the created mesh tag. It increments the tag counter and appends the tag name to the mesh tag list table.
- **Uses:** Engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `gFloorMesh`, `gameroot`, `nTagNumber`, `meshTagListTable`, `theMesh`, `TheFloor`, `meshx`, `meshy`, `meshz`, `vcubewidth`, `vcubelength`, `savedmode`; paths `Data/WTF/Floors/snowfloor2x2.wtf`.
- **Reusable:** no

## Part 2 of 9

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall mesh, positions and scales it, and returns the assigned wall tag number for north/south faces or the west/east wall tag otherwise.
- **Uses:** `nTagNumber`, `meshTagListTable`, `gameroot`, `gEWWallMesh`, `gNSWallMesh`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `face`, `WEWall`, `NSWall`
- **Reusable:** yes - reusable for loading and configuring wall meshes for any wall face.

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned vertex coordinates, creating a mesh tag, setting its face position and scale, and restoring the saved mode afterward.
- **Uses:** `qx`, `qy`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `savedmode`, `nTagNumber`, `meshTagListTable`, `math.floor`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_PushMeshToUndoCache`, `drawVertex`, `drawLine`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `quadtag`
- **Reusable:** yes - reusable for generating grid-aligned quad meshes in the mesh tool.

## Part 3 of 9

### idrawWallZ
- **Does:** Draws a wall quad for a given face, computes its grid position, creates a mesh tag, and renders the wall geometry for the face.
- **Uses:** `math.floor`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vcubeheight`, `drawVertex`, `drawLine`, `loadstring`, `ig3d_GetMode__i`, `nTagNumber`, `meshTagListTable`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `wallstring`, `savedmode`, `QX`, `QY`
- **Reusable:** yes - pure geometry and mesh tool drawing logic for wall quads
- **Procedural:** yes - generates a wall mesh geometry and mesh tag for a face

## Part 4 of 9

### icopyFloors
- **Does:** Duplicates the selected floor mesh into a new tagged mesh at a given grid position, then positions and scales it to match the floor grid cell.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_PushMeshToUndoCache`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `TheFloor`, `nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`; math `math.floor`.
- **Reusable:** yes - pure mesh duplication and grid placement logic.

### icopyRoofs
- **Does:** Duplicates the selected floor mesh into a new tagged mesh at a given grid position, then positions and scales it to match the floor grid cell, inverts the mesh faces, and restores the saved edit mode.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_InvertMeshFaces`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `TheFloor`, `nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `vcubeheight`; math `math.floor`.
- **Reusable:** yes - pure mesh duplication and grid placement logic, with an added face inversion step.

## Part 5 of 9

### Top level
- **Does:** Declares `theDropMeshTagNumber = nil` at file top level; no other top-level statements.
- **Uses:** nothing
- **Reusable:** yes

### icopyWalls
- **Does:** Creates and positions a wall quad mesh for a given grid position and face, duplicates the selected wall mesh, and adjusts quad geometry for north/south/east/west faces.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_InvertMeshFaces`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `WEWall`, `NSWall`, `nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `vcubebwidth`; variables `qx`, `qy`, `face`.
- **Reusable:** no

### loadAModelTemplate
- **Does:** Loads a WTF mesh model into a new drop mesh tag, scales and positions it, and returns the tag number assigned to the drop mesh.
- **Uses:** Engine calls `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `gameroot`, `gNSWallMesh`, `nTagNumber`, `meshTagListTable`, `savedmode`, `theDropMesh`, `theDropMeshTagNumber`, `TheFloor`, `vcubewidth`, `vcubelength`; variables `theMesh`, `meshx`, `meshy`, `meshz`.
- **Reusable:** no

## Part 6 of 9

### iCopyWTFXY
- **Does:** Copies a dropped WTF mesh into a new mesh tag, scales it to the current cube dimensions, and positions it on the grid at the given face coordinates.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `theDropMeshTagNumber`, `nTagNumber`, `savedmode`, `vcubewidth`, `vcubeheight`, `vcubelength`, `vgridwidth`, `vgridlength`, `QX`, `QY`, `meshx`, `meshy`, `meshz`; `math.floor`.
- **Reusable:** no
- **Procedural:** yes

### loadCubeWalls
- **Does:** Creates a new mesh tag for the given face, optionally loads a matching wall mesh, positions it at the origin then at the specified corner, and returns the assigned wall tag number for the face.
- **Uses:** Engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `nTagNumber`, `meshTagListTable`, `theMesh`, `WEWall`, `NSWall`, `savedmode`; `string.upper`.
- **Reusable:** no
- **Procedural:** yes

## Part 7 of 9

### icopyCubeWalls
- **Does:** Creates a new mesh for a cube wall on a given face, positions and scales it, and returns when the required wall meshes or face are missing.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `WEWall`, `NSWall`, `nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`, `meshx`, `meshy`, `meshz`, and local variables `qx`, `qy`, `face`; no `Data/` paths.
- **Reusable:** no

### icopyCubeWalls
- **Does:** Computes the placement coordinates for the wall based on the selected face, using grid alignment and centroid retrieval.
- **Uses:** Engine calls `ig3d_GetMeshCentroid__3f`; globals `qx`, `qy`, `face`, `vcubewidth`, `vcubeheight`, `vcubelength`, `vgridwidth`, `QX`, `QY`, `meshx`, `meshy`, `meshz`; no `Data/` paths.
- **Reusable:** no

### icopyCubeWalls
- **Does:** Restores the saved edit mode after creating and positioning the wall mesh.
- **Uses:** Engine call `ig3d_SetMode_i`; global `savedmode`; no `Data/` paths.
- **Reusable:** no

## Part 8 of 9

### Top level
- **Does:** Contains the two mesh conversion functions and the global assignment `l2m = convertLevelObjectsToMesh`.
- **Uses:** `io.open`, `string.find`, `string.sub`, `string.gsub`, `loadstring`, `loadLevel`-related level path construction via `gameroot.."Data/Levels/"..whichLevel.."/load script.lua"`, engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `render`, `gMeshExclusionList`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `nTagNumber`, `whichLevel`, `whichobject`, `whichLevel` globals.
- **Reusable:** no

### convertLevelObjectsToMesh
- **Does:** Converts level objects into meshes, optionally filtering to a single specified object, by reading the level's `load script.lua`, extracting object definitions, loading each object's mesh, applying position/scale/rotation, and saving the resulting mesh file.
- **Uses:** `io.open`, `string.find`, `string.sub`, `string.gsub`, `loadstring`, `render`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `gameroot`, `whichLevel`, `whichobject`, `gMeshExclusionList`, `zObjectWTFs`, `zObjectNames`, `zObjectSizes`, `zObjectRotations`, `zObjectPositions`, `nTagNumber`, `Data/Levels/` path construction.
- **Reusable:** no

### convertMeshObjectsTableToMesh
- **Does:** Converts the mesh object table into meshes, skipping objects listed in the exclusion list, applying position/scale/rotation, selecting and inverting mesh selection, and saving the resulting mesh file for the level.
- **Uses:** `string.find`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMeshTag_i` (via `ig3d_SetDefaultMesh_tag_i`), `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `render`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `gameroot`, `whichLevel`, `gMeshExclusionList`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `nTagNumber`, `Data/Levels/` path construction.
- **Reusable:** no

## Part 9 of 9

### convertMeshObjectsTablesToMeshFile
- **Does:** Converts a table of mesh objects into a mesh file by loading each mesh, applying size/rotation/position transforms, drawing vertices, attaching bones, and saving the result.
- **Uses:** `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `gameroot`, `drawVertex`, `camera_face_xyz`, `boneName`, `meshdone`, `render`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_AttachVertexToBone_s`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `ig3d_ShowAll`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `Data/` path `gameroot.."Data/WTF/"`, `whichfile`
- **Reusable:** no
- **Procedural:** yes

### convertMeshObjectsTablesToMeshFile
- **Does:** Converts a table of mesh objects into a mesh file by loading each mesh, applying size/rotation/position transforms, drawing vertices, attaching bones, and saving the result.
- **Uses:** `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `gameroot`, `drawVertex`, `camera_face_xyz`, `boneName`, `meshdone`, `render`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_AttachVertexToBone_s`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `ig3d_ShowAll`, `ig3d_CombineEqualMeshMaterials`, `ig3d_SaveMesh_sf_b`, `Data/` path `gameroot.."Data/WTF/"`, `whichfile`
- **Reusable:** no
- **Procedural:** yes
