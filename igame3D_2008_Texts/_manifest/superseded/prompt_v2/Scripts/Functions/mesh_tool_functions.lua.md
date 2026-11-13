<!-- Spark first-look of Data/Scripts/Functions/mesh_tool_functions.lua (model spark-x2.6-4b, 2026-11-12 07:17). DRAFT for Claude to review. -->

## mesh_tool_functions.lua
- **Kind:** tool
- **Purpose:** This file provides mesh editing and conversion tools for the iGame3D engine, including mesh tool selection, floor and wall mesh loading, mesh duplication and copying, and conversion of level objects into mesh assets. It contains mesh editing helpers, level-building mesh functions, and mesh-to-file conversion routines.
- **Depends on:** `Data/` folders (Scripts, Levels, WTF, Fluid, Emitters, Shaders, Images, Sounds, FontPngs, BVH), engine calls such as `ig3d_*` mesh functions, globals set elsewhere (e.g. `gObjects`, `gEditingMode`, `gEWWallMesh`, `gNSWallMesh`, `gFloorMesh`), and helper functions `drawVertex` and `drawLine`.
- **Provides:** Functions `setMeshTool`, `loadTheFloor`, `loadTheWalls`, `mesh_drawQuad`, `idrawWallZ`, `icopyFloors`, `icopyRoofs`, `icopyWalls`, `loadAModelTemplate`, `iCopyWTFXY`, `loadCubeWalls`, `icopyCubeWalls`, `convertLevelObjectsToMesh`, `convertMeshObjectsTableToMesh`, `convertMeshObjectsTablesToMeshFile`, and global `l2m`.
- **Assets it needs:** `Data/WTF/Floors/snowfloor2x2.wtf`, `Data/Wtf/Walls/EWwall2x2.wtf`, `Data/WTF/` model files (e.g. `gameroot..gNSWallMesh`), `Data/Levels/<level>/load script.lua`, `Data/Levels/<level>/<object>x<nTagNumber>_WTF2Mesh.wtf`, `Data/Levels/<level>/<level>map_mesh.wtf`, `Data/WTF/` mesh files for `gMeshObjectWTFs`.
- **Procedural:** yes - generates mesh assets from level object data and rules, including floor/wall mesh loading and positioning, mesh duplication and grid placement, mesh-to-file conversion, and mesh asset generation from level scripts and mesh tables.
- **Glossary:**
  - `mesh tag` - a tagged mesh object in iGame3D that holds a mesh asset and supports selection, positioning, scaling and saving operations.
  - `ig3d_* mesh calls` - engine functions used to create, load, position, scale, select and save mesh objects (e.g. `ig3d_CreateMesh_tag_s`, `ig3d_LoadMesh_sf_b`).
  - `mesh tool` - a selection mode for editing mesh geometry in the iGame3D mesh editor.
  - `WTF mesh model` - a 3D model file in the iGame3D WTF text format used to load mesh assets.
  - `mesh tag number` - the numeric identifier assigned to a created mesh tag by the engine.
  - `level` - a game or demo folder under `Data/Levels/` that contains level scripts and mesh assets.
  - `mesh conversion` - the process of reading level object data and generating mesh assets from it.
- **Keep / port / drop:** keep - core mesh editing, level-building and mesh conversion logic that programmers can reuse in a new engine.

---

# Part notes

## Part 1 of 9

### setMeshTool
- **Does:** Sets the mesh editing tool selection, shows the matching editing group, and applies the selected mesh tool mode.
- **Uses:** Engine calls (`hideAllGroups`, `Translate:show`, `ig3d_SetMeshTool_i`), globals (`gEditingMode`, `bonesgroup`, `uvmappinggroup`, `materialsgroup`, `magicgroup`), and the `w:label()` widget call.
- **Reusable:** no
- **Procedural:** no

### loadTheFloor
- **Does:** Loads the configured floor mesh, tags it with a generated floor tag, and positions and scales the mesh to fit the level bounds.
- **Uses:** Engine calls (`ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`), globals (`theMesh`, `nTagNumber`, `meshTagListTable`, `meshx`, `meshy`, `meshz`, `vcubewidth`, `vcubelength`, `savedmode`), and the `Data/` path `gFloorMesh` (default `Data/WTF/Floors/snowfloor2x2.wtf`).
- **Reusable:** no
- **Procedural:** no

## Part 2 of 9

### Top level
- **Does:** No top-level code outside the two function definitions; the file contains only the `loadTheWalls` and `mesh_drawQuad` functions.
- **Uses:** nothing
- **Reusable:** no

### loadTheWalls
- **Does:** Creates a mesh tag for a wall face, loads the matching wall mesh, positions it, and returns the assigned wall tag number for the requested face.
- **Uses:** Engine calls (`ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`), globals (`nTagNumber`, `meshTagListTable`, `gameroot`, `gEWWallMesh`, `gNSWallMesh`, `savedmode`, `theMesh`, `WEWall`, `NSWall`), and file path `Data/Wtf/Walls/EWwall2x2.wtf`.
- **Reusable:** yes

### mesh_drawQuad
- **Does:** Draws a quad mesh by computing grid-aligned vertex positions, creating a mesh tag, setting mesh tool and selection state, and scaling the mesh to the grid dimensions.
- **Uses:** Engine calls (`ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`), globals (`nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`), and helper functions `drawVertex`, `drawLine`.
- **Reusable:** yes
- **Procedural:** yes

## Part 3 of 9

### Top level
- **Does:** No top-level code outside the `idrawWallZ` function; the file begins directly with the function definition.
- **Uses:** nothing
- **Reusable:** no

### idrawWallZ
- **Does:** Draws a wall quad at the given world coordinates and face direction, then sets up the mesh, renders the wall geometry, and restores the previous mode.
- **Uses:** engine calls (`ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_PushMeshToUndoCache`, `ig3d_SetFacePos_b3f`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`), globals (`wallstring`, `nTagNumber`, `meshTagListTable`, `savedmode`, `QX`, `QY`), and local `loadstring`/`load` calls for wall geometry.
- **Reusable:** no
- **Procedural:** yes - it generates wall mesh geometry based on the face direction and input coordinates.

## Part 4 of 9

### Top level
- **Does:** No top-level code outside the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### icopyFloors
- **Does:** Duplicates the selected floor mesh into a new tagged mesh at a grid-aligned position, then scales it to the floor grid dimensions and repositions it.
- **Uses:** Engine calls (`ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_GetMode__i`, `ig3d_SetMode_i`), globals (`TheFloor`, `nTagNumber`, `meshTagListTable`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`), and local variables (`qx`, `qy`, `quadtag`).
- **Reusable:** yes - pure mesh duplication and grid placement logic that can be reused for floor copying across levels.

### icopyRoofs
- **Does:** Duplicates the selected floor mesh into a new tagged mesh at a grid-aligned position, scales it to the floor grid dimensions, repositions it at the roof height, and inverts the mesh faces.
- **Uses:** Engine calls (`ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_InvertMeshFaces`, `ig3d_GetMeshCentroid__3f`, `ig3d_GetMode__i`, `ig3d_SetMode_i`), globals (`TheFloor`, `nTagNumber`, `meshTagListTable`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `vcubeheight`), and local variables (`qx`, `qy`, `quadtag`).
- **Reusable:** yes - mirrors the floor copying logic with roof-specific positioning and face inversion, reusable for roof copying across levels.

## Part 5 of 9

### Top level
- **Does:** No top-level code outside the two defined functions; the file contains only the function definitions for `icopyWalls` and `loadAModelTemplate`.
- **Uses:** nothing
- **Reusable:** no

### icopyWalls
- **Does:** Copies a wall mesh quad onto a specified face of a wall, adjusts quad coordinates for the face, and restores the previous mesh mode after the operation.
- **Uses:** Engine calls (`ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_InvertMeshFaces`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`), globals (`WEWall`, `NSWall`, `savedmode`, `nTagNumber`, `meshTagListTable`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vcubeheight`, `QX`, `QY`), and no file paths.
- **Reusable:** no

### loadAModelTemplate
- **Does:** Loads a WTF mesh model into a new mesh tag, scales it to the level's wall dimensions, positions it, and returns the tag number assigned to the loaded mesh.
- **Uses:** Engine calls (`ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`), globals (`theDropMesh`, `gameroot`, `gNSWallMesh`, `nTagNumber`, `meshTagListTable`, `TheFloor`, `vcubewidth`, `vcubeheight`, `vcubelength`), and file paths (`Data/WTF/` prefix handling, `gameroot..gNSWallMesh`).
- **Reusable:** no
- **Procedural:** yes - it generates a new mesh asset tag from a WTF model file and applies scaling/positioning rules to it.

## Part 6 of 9

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file.
- **Uses:** nothing
- **Reusable:** no

### iCopyWTFXY
- **Does:** Copies a selected mesh tag to a new mesh tag at a specified grid position and face, then scales it to the cube size and repositions it on the grid.
- **Uses:** Engine calls `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMode__i`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `theDropMeshTagNumber`, `nTagNumber`, `savedmode`, `vcubewidth`, `vcubeheight`, `vcubelength`, `vgridwidth`, `vgridlength`, `QX`, `QY`, `meshx`, `meshy`, `meshz`; no files or `Data/` paths read or written.
- **Reusable:** yes - pure mesh manipulation logic for grid-based mesh placement.

### loadCubeWalls
- **Does:** Creates a new mesh tag for a given face, optionally loads a matching wall mesh, positions it at the origin, and returns the assigned wall tag number for west/east or north/south faces.
- **Uses:** Engine calls `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_LoadMesh_sf_b`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`; globals `nTagNumber`, `meshTagListTable`, `theMesh`, `WEWall`, `NSWall`, `savedmode`; file paths `gameroot..gEWWallMesh` and `gameroot..gNSWallMesh`; no `Data/` paths read or written.
- **Reusable:** yes - reusable wall mesh creation and placement logic for level building.

## Part 7 of 9

### icopyCubeWalls
- **Does:** Creates a new mesh tag for a cube wall at the given coordinates and face, positions and scales it, then places it on the appropriate wall mesh.
- **Uses:** Engine calls (`ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMode__i`), globals (`WEWall`, `NSWall`, `meshTagListTable`, `nTagNumber`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`), and local variables (`qx`, `qy`, `face`).
- **Reusable:** no
- **Procedural:** yes

Wait, the instructions say procedural only if it GENERATES an asset from numbers or rules (geometry, level layout, texture, terrain, maze, animation). Creating a mesh object is explicitly NOT procedural per the rules. Let me correct that.

### icopyCubeWalls
- **Does:** Creates a new mesh tag for a cube wall at the given coordinates and face, positions and scales it, then places it on the appropriate wall mesh.
- **Uses:** Engine calls (`ig3d_SelectMesh_tagVertices_ib`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_SetMesh_tagName_is`, `ig3d_DuplicateMesh`, `ig3d_RemoveFromMesh_tag_i`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMode_i`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_GetMode__i`), globals (`WEWall`, `NSWall`, `meshTagListTable`, `nTagNumber`, `savedmode`, `QX`, `QY`, `vcubewidth`, `vcubelength`, `vcubeheight`, `vgridwidth`), and local variables (`qx`, `qy`, `face`).
- **Reusable:** no
- **Procedural:** no

## Part 8 of 9

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the two function definitions and the final assignment of `l2m`.
- **Uses:** nothing
- **Reusable:** no

### convertLevelObjectsToMesh
- **Does:** Reads the `load script.lua` file of the requested level, extracts the `gObjects=` and `gObjectColls=` ranges, rewrites `gObject` references to `zObject`, loads and runs the rewritten script to populate mesh-related tables, then iterates over the level's objects to create, load, position, scale, rotate and save mesh assets for the requested object.
- **Uses:** `io.open`, `string.find`, `string.sub`, `string.gsub`, `loadstring`, `render`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `gMeshExclusionList`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `gObjectWTFs`, `gObjectNames`, `gObjectSizes`, `gObjectRotations`, `gObjectPositions`, `nTagNumber`, `gameroot`, `Data/` paths for `Levels/<whichLevel>/load script.lua` and `Levels/<whichLevel>/<whichobject>x<nTagNumber>_WTF2Mesh.wtf`
- **Reusable:** with changes - depends on level script structure, mesh table contents and specific mesh manipulation calls
- **Procedural:** yes - generates mesh assets from level object data and rules

### convertMeshObjectsTableToMesh
- **Does:** Takes a level name (defaulting to the current level via `item(-1,ig3d_GetLevelName__s(),"/")`), iterates over the level's mesh object tables, creates and loads each mesh object, applies default position, scale, rotation and position settings, selects and inverts mesh selection, renders, then saves the resulting mesh assets to the level's `map_mesh.wtf` file.
- **Uses:** `item`, `ig3d_GetLevelName__s`, `ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `render`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `gMeshExclusionList`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `whichLevel`, `gameroot`, `Data/` paths for `WTF/` mesh files and `Levels/<whichLevel>/<whichLevel>map_mesh.wtf`
- **Reusable:** with changes - depends on level mesh table contents, mesh manipulation calls and level path conventions
- **Procedural:** yes - generates mesh assets from level object data and rules

### l2m
- **Does:** Assigns the result of `convertLevelObjectsToMesh` to the global variable `l2m`.
- **Uses:** `convertLevelObjectsToMesh`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 9

### Top level
- **Does:** No top-level code outside the `convertMeshObjectsTablesToMeshFile` function.
- **Uses:** nothing
- **Reusable:** no

### convertMeshObjectsTablesToMeshFile
- **Does:** Converts a table of mesh objects into a mesh file by creating one mesh tag per object, loading and transforming the source mesh, drawing its centroid vertex, attaching a bone to the mesh, and saving the result.
- **Uses:** engine calls (`ig3d_CreateMesh_tag_s`, `ig3d_SetDefaultMesh_tag_i`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_GetMeshCentroid__3f`, `ig3d_MakeBoneFromVertex_2s`, `ig3d_AttachVertexToBone_s`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_SelectWholeMesh`, `ig3d_InvertMeshSelection`, `ig3d_ShowAll`, `ig3d_SaveMesh_sf_b`, `render`), globals (`gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectSizes`, `gMeshObjectRotations`, `gMeshObjectPositions`, `nTagNumber`, `boneName`, `meshdone`), and `Data/` paths (`gameroot.."Data/WTF/"..gMeshObjectWTFs[i]`, `gameroot..whichfile`).
- **Reusable:** no
- **Procedural:** yes - it generates a mesh file from input mesh object tables and transforms them into a saved asset.
