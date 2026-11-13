<!-- Spark first-look of Data/Scripts/Functions/uv_functions.lua (model spark-x2.6-4b, 2026-11-12 15:54). DRAFT for Claude to review. -->

## uv_functions.lua
- **Kind:** library
- **Purpose:** This file provides UV-related callbacks and helper functions for configuring mesh UV mapping in the iGame3D engine. It maps control inputs to fixed tuples, retrieves matching UV sizes for a mesh rotation, and applies UV scaling, offsetting, and cylindrical mapping operations through engine calls.
- **Depends on:** `uvmapaxis`, `uvrot`, `uvwidth`, `uvheight`, `uvscaleu`, `uvscalev`, `uvoffu`, `uoffv` controls (globals set elsewhere); engine calls `ig3d_GetMatchingUVSizesForMesh_fb3f_2f`, `ig3d_GenerateAndApplyMeshUVMapping_5fb3f`, `ig3d_ScaleUVMapping_2f`, `ig3d_OffsetUVMapping_2f`, `ig3d_GenerateAndApplyMeshCylindricUVMapping`; `getMapAxisFromControls()` defined in this file.
- **Provides:** `getMapAxisFromControls`, `uvmatcher`, `applyuvmapping`, `scaleuvmapping`, `offsetuvmapping`, `cylindricMappingClicked`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or loaded).
- **Procedural:** yes - `getMapAxisFromControls` and the UV mapping functions generate or configure UV data (tuples, mapping parameters) from numeric control values and engine calls instead of loading asset files.
- **Glossary:**
  - UV mapping - mesh texture coordinate mapping configuration handled via engine calls.
  - `uvmapaxis` - control holding the current map axis value used to determine UV mapping parameters.
  - `ig3d_...` calls - engine functions invoked to perform UV mapping operations on meshes.
  - `getMapAxisFromControls` - function that reads the map axis value from controls and returns a fixed tuple based on that value.
- **Keep / port / drop:** keep - reusable UV mapping helper library for new engine development.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the file-level comment and no setup, globals, or widget definitions outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### getMapAxisFromControls
- **Does:** Reads the current map axis value from `uvmapaxis`, and returns a tuple based on that value: `false,0,0,0` for axis 0, `true,1,0,0` for axis 1, `true,0,1,0` for axis 2, and `true,0,0,1` otherwise.
- **Uses:** `uvmapaxis:value()`
- **Reusable:** yes - pure conditional mapping of a numeric input to a fixed tuple.

### uvmatcher
- **Does:** Gets the map axis from controls, retrieves matching UV sizes for the current rotation via an engine call, then sets the UV width and height values from those sizes.
- **Uses:** `getMapAxisFromControls()`, `uvrot:value()`, `ig3d_GetMatchingUVSizesForMesh_fb3f_2f(uvrot:value(), b, dx,dy,dz)`, `uvwidth:value(u)`, `uvheight:value(v)`
- **Reusable:** no

### applyuvmapping
- **Does:** Reads the current UV width and height values, calls an engine call to generate and apply the mesh UV mapping with the rotation and map axis from controls, and writes the result back to the UV width and height values.
- **Uses:** `uvwidth:value()`, `uvheight:value()`, `uvrot:value()`, `getMapAxisFromControls()`, `ig3d_GenerateAndApplyMeshUVMapping_5fb3f(uvwidth:value(), uvheight:value(), 0,0, uvrot:value(), getMapAxisFromControls())`
- **Reusable:** no

### scaleuvmapping
- **Does:** Reads the current UV scale U and V values and calls an engine call to scale the UV mapping with those values.
- **Uses:** `uvscaleu:value()`, `uvscalev:value()`, `ig3d_ScaleUVMapping_2f(uvscaleu:value(), uvscalev:value())`
- **Reusable:** yes - pure data-driven engine call for a numeric mapping operation.

### offsetuvmapping
- **Does:** Reads the current UV offset U and V values and calls an engine call to offset the UV mapping with those values.
- **Uses:** `uvoffu:value()`, `uoffv:value()`, `ig3d_OffsetUVMapping_2f(uvoffu:value(), uvoffv:value())`
- **Reusable:** yes - pure data-driven engine call for a numeric mapping operation.

### cylindricMappingClicked
- **Does:** Takes a widget argument `w`, and calls an engine call to generate and apply the mesh cylindrical UV mapping.
- **Uses:** `w`, `ig3d_GenerateAndApplyMeshCylindricUVMapping()`
- **Reusable:** no

### Top level
- **Does:** Contains the file-level comment `--UV-related callbacks and functions` and no setup, globals, or widget definitions outside the listed functions.
- **Uses:** nothing
- **Reusable:** no
