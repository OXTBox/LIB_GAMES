<!-- Spark first-look of Data/Scripts/Convert/ConvermakeLevel1tomesh.lua (model spark-x2.6-4b, 2026-11-12 14:47). DRAFT for Claude to review. -->

## ConvermakeLevel1tomesh.lua
- **Kind:** converter
- **Purpose:** This file converts the WTF mesh list into a level by creating, positioning, scaling and rotating each mesh object from the WTF catalog, then loading each mesh into the game. It is a procedural conversion tool for building Level1 from its source mesh assets.
- **Depends on:** `Data/` folder paths (specifically `gameroot.."Data/WTF/"`), globals `zObjects`, `zObjectWTFs`, `zObjectNames`, `zObjectPositions`, `zObjectRotations`, and engine calls such as `ig3d_CreateMesh_tag_s`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_MakeInvisible`.
- **Provides:** No standalone functions or globals are defined; it performs the mesh conversion directly using the object catalog arrays and engine calls listed above.
- **Assets it needs:** WTF mesh files (exact names not specified in the provided code, referenced via the `Data/WTF/` path).
- **Procedural:** yes; it generates mesh objects and their positions, rotations, scales, and visibility states from the WTF catalog list and rules defined in the file, rather than loading pre-existing asset files.
- **Glossary:**
  - `ig3d_CreateMesh_tag_s` - Engine call that creates a mesh object from a WTF mesh file.
  - `ig3d_LoadMesh_sf_b` - Engine call that loads a mesh file into the game.
  - `ig3d_AddToMesh_tag_i` - Engine call that adds a mesh object to the active mesh list.
  - `ig3d_SetMeshPositionNoUndo_3f` - Engine call that sets a mesh object's position without triggering an undo action.
  - `ig3d_ScaleSelectedMesh_3f` - Engine call that scales a selected mesh object.
  - `ig3d_RotateSelectedMesh_6f` - Engine call that rotates a selected mesh object.
  - `ig3d_MakeInvisible` - Engine call that makes a mesh object invisible.
  - `WTF` - Folder containing 3D mesh assets in the "iGame3D Mdl" text format.
- **Keep / port / drop:** keep - it is a direct, reusable reference for converting WTF meshes into game objects in iGame3D.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the object catalog arrays and loops to create, position, scale and rotate each mesh object from the WTF list, then loads each mesh.
- **Uses:** Globals `zObjects`, `zObjectWTFs`, `zObjectNames`, `zObjectPositions`, `zObjectRotations`, `gameroot`; engine calls `ig3d_CreateMesh_tag_s`, `ig3d_LoadMesh_sf_b`, `ig3d_AddToMesh_tag_i`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_MakeInvisible`; `Data/` path `gameroot.."Data/WTF/"`.
- **Reusable:** no
- **Procedural:** yes
