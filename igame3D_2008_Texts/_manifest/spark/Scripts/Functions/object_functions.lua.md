<!-- Spark first-look of Data/Scripts/Functions/object_functions.lua (model spark-x2.6-4b, 2026-11-12 07:21). DRAFT for Claude to review. -->

## object_functions.lua
- **Kind:** engine-core
- **Purpose:** This file provides reusable object creation and mesh configuration helpers for the iGame3D engine, including default square billboard creation, random rotation and force application, block array generation, mesh transformation and deletion, and procedural floor/wall mesh object registration. It supports building game objects from model files and grid-aligned positions.
- **Depends on:** `Data/` folder paths, `dofile` for loading Lua libraries, engine globals such as `gObjects`, `selectedobject`, `gameroot`, and engine calls like `make`, `get`, `getObjectInfo`, `setObjectInfo`, `loadMesh`, `delete`, plus `ig3d_*` mesh functions and `IG3D_*` property constants defined elsewhere.
- **Provides:** Functions `makedefaultSquare`, `RND_pushObject`, `arrayObjects`, `createBlockarray`, `meshifyObject`, `icopyModelFloors`, `icopyModelWalls`, `iBuildMeshObjectTables`; globals `gFloorWTF`, `gEWWallWTF`, `gNSWallWTF`, `gDropMesh`, `gDropModel`, `arrayObjects`.
- **Assets it needs:** `Billboards/square.wtf`, `cube.wtf` (default WTF path), model files referenced via `loadMesh` and `ig3d_GetObjectModelPath_s_s` (exact names not specified in provided code).
- **Procedural:** yes - generates mesh objects and block arrays from grid indices, model file paths, and position/face parameters instead of loading static asset files; also creates default square billboard objects and applies random rotation/force settings.
- **Glossary:**
  - `ig3d_object` - object kind used as the first argument to `make` and `get` to specify the type of object being created or retrieved.
  - `IG3D_*` - constants naming the property being read or set on an object (e.g., `IG3D_POSITION`, `IG3D_ROTATION`).
  - `setObjectInfo` - engine call that sets named properties (position, rotation, size, collision, HUD) on an object.
  - `make` - engine call that creates an object from a WTF model file path.
  - `loadMesh` - engine call that loads a mesh model file for transformation.
  - `gObjects` - global table tracking created game objects.
  - `loadLevel` - engine call that switches the active game level folder.
  - `dofile` - engine call that loads a Lua script file from a path.
- **Keep / port / drop:** keep - core reusable object and mesh configuration helpers that programmers can reuse when building game objects in a new engine.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions.
- **Uses:** nothing
- **Reusable:** no

### makedefaultSquare
- **Does:** Creates a default square billboard object, then sets its rotation, position, and size via object info.
- **Uses:** make (ig3d_object, "Billboards/square.wtf"), setObjectInfo with IG3D_ROTATION, IG3D_POSITION, IG3D_SIZE
- **Reusable:** yes

### RND_pushObject
- **Does:** Selects a default object if none is provided, reads its rotation matrix, then applies random rotation and force/torque settings based on a random key value.
- **Uses:** getObjectInfo (IG3D_ROTATION_MATRIX), setObjectInfo (IG3D_OMEGA, IG3D_FORCE, IG3D_TORQUE, IG3D_VECTOR_CONSTRAINT), gObjects, selectedobject
- **Reusable:** no

### arrayObjects
- **Does:** Declares an empty array named arrayObjects at the end of the file.
- **Uses:** nothing
- **Reusable:** no

## Part 2 of 5

### Top level
- **Does:** Defines global variables `gFloorWTF`, `gEWWallWTF`, `gNSWallWTF` and `gDropMesh` at file scope.
- **Uses:** nothing
- **Reusable:** no

### createBlockarray
- **Does:** Creates a 10x10 block array of objects by iterating over column and row indices, placing each object at a grid position derived from the column and row values.
- **Uses:** `make(ig3d_object, wtfFile)`, `get(ig3d_object, gObjects[i].cObj)`, `setObjectInfo(pObject, IG3D_POSITION, xcol, yplane, zrow)`, globals `gObjects`, `arrayObjects`, `gameroot`; reads/writes the `wtfFile` path argument (defaults to `"cube.wtf"` if nil).
- **Reusable:** no

### meshifyObject
- **Does:** Applies mesh transformations to an object, loads its model file, resizes and rotates the selected mesh, sets the object position, then deletes the object.
- **Uses:** `getObjectInfo(obj, IG3D_POSITION)`, `getObjectInfo(obj, IG3D_ROTATION)`, `getObjectInfo(obj, IG3D_SIZE)`, `getObjectInfo(obj, IG3D_NAME)`, `loadMesh(fileToLoad)`, `ig3d_ScaleSelectedMesh_3f`, `ig3d_RotateSelectedMesh_6f`, `ig3d_SetMeshPositionNoUndo_3f`, `delete(ig3d_object, obj)`, globals `ig3d_GetObjectModelPath_s_s`, `gameroot`; reads/writes the `obj` path argument.
- **Reusable:** no

## Part 3 of 5

### Top level
- **Does:** No top-level statements outside the `icopyModelFloors` function.
- **Uses:** nothing
- **Reusable:** no

### icopyModelFloors
- **Does:** Copies model floors for a given position and face by computing grid-aligned coordinates, then registers the floor object and sets its name, position, rotation, size, collision and HUD properties.
- **Uses:** globals `gDropMesh`, `gFloorWTF`, `vcubewidth`, `vgridwidth`, `vcubelength`, `vgridlength`, `gObjectPositions`, `gObjectRotations`, `gObjectColls`, `gObjectHUDs`, `gObjectSizes`, `gObjectNames`, `gObjectWTFs`, `gObjects`, `i`; engine calls `make(ig3d_object, ...)`, `setObjectInfo(...)` with `IG3D_NAME`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_SIZE`, `IG3D_COLL`, `IG3D_HUD`; no `Data/` paths read or written.
- **Reusable:** no
- **Procedural:** yes

## Part 4 of 5

### Top level
- **Does:** No functions or setup code outside `icopyModelWalls`; the file contains only the function definition and its body.
- **Uses:** Globals `gDropModel`, `gEWWallWTF`, `gNSWallWTF`, `gFloorWTF`, `gObjectPositions`, `gObjectRotations`, `gObjectColls`, `gObjectHUDs`, `gObjectSizes`, `gObjectNames`, `gObjectWTFs`, `gObjects`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `gMeshObjectWTFs`, `gMeshObjectNames`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `make`, `setObjectInfo`, `IG3D_NAME`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_SIZE`, `IG3D_COLL`, `IG3D_HUD`, `math.floor`, `table.insert`.
- **Reusable:** no

### icopyModelWalls
- **Does:** Creates a drop model object at a specified grid-aligned position and face, then registers it in the mesh object tracking tables and builds the corresponding `ig3d_object` with its name, position, rotation, size, collision and HUD settings.
- **Uses:** Engine calls `make(ig3d_object, gDropModel)`, `setObjectInfo(obj, IG3D_NAME/IG3D_POSITION/IG3D_ROTATION/IG3D_SIZE/IG3D_COLL/IG3D_HUD, ...)`; globals `gDropModel`, `gEWWallWTF`, `gNSWallWTF`, `gFloorWTF`, `gObjectPositions`, `gObjectRotations`, `gObjectColls`, `gObjectHUDs`, `gObjectSizes`, `gObjectNames`, `gObjectWTFs`, `gObjects`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`, `math.floor`, `table.insert`; files/paths: none directly read or written.
- **Reusable:** no
- **Procedural:** yes - generates a mesh object asset from position, face and model selection parameters.

## Part 5 of 5

### Top level
- **Does:** No top-level code outside the `iBuildMeshObjectTables` function.
- **Uses:** nothing
- **Reusable:** no

### iBuildMeshObjectTables
- **Does:** Computes grid-aligned world coordinates for a drop mesh position based on its face, then records the position, rotation, size, name and WTF model for the mesh object table.
- **Uses:** globals `gDropModel`, `gEWWallWTF`, `gNSWallWallWTF`, `gFloorWTF`, `gMeshObjectPositions`, `gMeshObjectRotations`, `gMeshObjectSizes`, `gMeshObjectNames`, `gMeshObjectWTFs`, `vcubewidth`, `vcubelength`, `vgridwidth`, `vgridlength`; no engine calls or file paths.
- **Reusable:** no
- **Procedural:** yes
