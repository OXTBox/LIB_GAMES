<!-- Spark first-look of Data/Scripts/Functions/material_functions.lua (model spark-x2.6-4b, 2026-11-12 07:01). DRAFT for Claude to review. -->

## material_functions.lua
- **Kind:** library
- **Purpose:** This file provides material management functions for the iGame3D engine, including ocean effect animation, material list and selection controls, material property settings, and material change handling. It supports creating, renaming, deleting, and configuring materials for meshes and drives the ocean effect material animation.
- **Depends on:** Other Scripts/Functions files (material-related globals and helper functions), engine calls such as `setMaterialInfo`, `ig3d_TellFocus_b`, `ig3d_CreateMaterial_s`, `ig3d_SetMeshMaterialName_is`, `ig3d_DeleteMaterial_i`, `ig3d_GetMeshMaterialsList__s`, `ig3d_SelectMeshOfMaterial_i`, `ig3d_SetMaterialForSelectedMesh_i`, `ig3d_MakeMeshSmoothShaded_b`, `ig3d_TellFocus_b`, `ig3d_MakeMeshSmoothShaded_b`, and `ig3d_SelectMeshOfMaterial_i`; globals set elsewhere (`gTime`, `matox`, `matoy`, `matmovx`, `matmovy`, `matrot`, `omega`, `beep`, `matred`, `matgreen`, `matblue`, `matalpha`, `matbool`, `matpath`, `meshMaterials`, `matsetting`); FLTK UI components (`meshMaterials`, `matsetting`, `fltk.fl_input`); `Data/` folder paths for material-related files (none directly referenced in the provided code).
- **Provides:** Functions for ocean effect animation (`oceaneffect`), material list management (`listMaterials`, `selectMaterialMesh`, `materialattacher`, `materialmaker`, `renameMaterial`, `clearMaterial`, `setupmatsettingschooser`), boolean/int conversion helpers (`booleanToInt`, `intToBoolean`), material settings UI handling (`matsettingChosen`, `matsettingChange`, `meshMaterialsClicked`), and top-level global state assignments for ocean effect animation.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (no assets are generated from numbers or rules; only object configuration and UI state updates are performed).
- **Glossary:**
  - `IG3D_UV_TRANSFORMATION - Engine property constant naming the UV transformation property of a material.`
  - `setMaterialInfo - Engine call that sets a property value on a material object.`
  - `meshMaterials - FLTK widget holding the list of current mesh materials.`
  - `matsetting - FLTK settings object used to configure material property options.`
  - `ig3d_TellFocus_b - Engine call that requests focus on a UI element.`
  - `ig3d_CreateMaterial_s - Engine call that creates a new material with a given name.`
  - `ig3d_SetMeshMaterialName_is - Engine call that renames a material at a specific list index.`
  - `ig3d_DeleteMaterial_i - Engine call that deletes a material at a specific list index.`
- **Keep / port / drop:** keep - Core material management and ocean effect animation logic is reusable for new engine material systems.

---

# Part notes

## Part 1 of 4

### Top level
- **Does:** Contains initial global variable assignments for the ocean effect animation state and the animation time counter.
- **Uses:** Globals `matox`, `matoy`, `matmovx`, `matmovy`, `matrot`, `gTime`.
- **Reusable:** no

### oceaneffect
- **Does:** Drives the ocean effect animation by updating transformation parameters over time and applying them to a material's UV transformation property.
- **Uses:** Engine calls `time()`, `passed()`, `click("-")`, `setMaterialInfo(m, IG3D_UV_TRANSFORMATION, ...)`; globals `gTime`, `matox`, `matoy`, `matmovx`, `matmovy`, `matrot`, `omega`; parameter `m` (material object).
- **Reusable:** no

### listMaterials
- **Does:** Clears the material list widget and repopulates it with the current mesh material list from the engine.
- **Uses:** Engine call `ig3d_GetMeshMaterialsList__s()`; widget `meshMaterials`; no `Data/` paths.
- **Reusable:** yes

### selectMaterialMesh
- **Does:** Selects the material corresponding to the currently selected mesh material list index.
- **Uses:** Widget `meshMaterials`; engine call `ig3d_SelectMeshOfMaterial_i(i)`; no `Data/` paths.
- **Reusable:** yes

### materialattacher
- **Does:** Attaches the currently selected material to the selected mesh using the current material list index.
- **Uses:** Widget `meshMaterials`; engine call `ig3d_SetMaterialForSelectedMesh_i(i)`; no `Data/` paths.
- **Reusable:** yes

### materialmaker
- **Does:** Creates a new material with a user-entered name, refreshes the material list, and restores the previously selected material index.
- **Uses:** Engine calls `ig3d_TellFocus_b(true)`, `ig3d_CreateMaterial_s(mname)`; widget `meshMaterials`; user input via `fltk.fl_input(...)`; no `Data/` paths.
- **Reusable:** yes

### renameMaterial
- **Does:** Renames the material at the currently selected index after the user enters a new name, refreshes the material list, and restores the selected index.
- **Uses:** Engine calls `ig3d_TellFocus_b(true)`, `ig3d_SetMeshMaterialName_is(i, mname)`; widget `meshMaterials`; user input via `fltk.fl_input(...)`; no `Data/` paths.
- **Reusable:** yes

## Part 2 of 4

### Top level
- **Does:** none
- **Uses:** nothing

### clearMaterial
- **Does:** Deletes materials while the material list is non-empty, then refreshes the material list.
- **Uses:** `meshMaterials` (a settings object with `value()`), `ig3d_DeleteMaterial_i`, `listMaterials`
- **Reusable:** yes

### setupmatsettingschooser
- **Does:** Clears the mats setting chooser and adds the standard material property options to it.
- **Uses:** `matsetting` (a settings object with `clear()` and `add()`)
- **Reusable:** yes

### booleanToInt
- **Does:** Converts a boolean to an integer, returning 1 for true and 0 otherwise.
- **Uses:** nothing
- **Reusable:** yes

### intToBoolean
- **Does:** Converts an integer to a boolean, returning true for 1 and false otherwise.
- **Uses:** nothing
- **Reusable:** yes

## Part 3 of 4

### Top level
- **Does:** No top-level code outside the `matsettingChosen` function.
- **Uses:** nothing
- **Reusable:** no

### matsettingChosen
- **Does:** Updates the material settings UI based on the chosen material property index, then reads the selected material's property values and writes them back to the UI controls.
- **Uses:** engine calls (`get(ig3d_material, -1, j)`), engine constants (`IG3D_COLOR`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_EMISSION`, `IG3D_SHININESS`, `IG3D_DEPTH`, `IG3D_WIRE`, `IG3D_SMOOTH`, `IG3D_TRANSPARENT`, `IG3D_LUX`, `IG3D_SHADER`, `IG3D_TEXTURE`), globals (`beep`, `matred`, `matgreen`, `matblue`, `matalpha`, `matpath`, `matbool`, `meshMaterials`, `booleanToInt`), and `Data/` paths it reads or writes: none
- **Reusable:** no
- **Procedural:** no

## Part 4 of 4

### Top level
- **Does:** No functions or setup code; the file contains only the two listed functions and a comment noting callbacks above belong to the FLUID 08 20 2008 UI file.
- **Uses:** nothing
- **Reusable:** no

### matsettingChange
- **Does:** Handles material property changes: checks for Enter key input, reads material setting options and color/path values, selects a material object, and applies the selected material property and color values to it.
- **Uses:** Engine calls (`get`, `setMaterialInfo`, `ig3d_TellFocus_b`, `ig3d_MakeMeshSmoothShaded_b`), globals (`matsetting`, `meshMaterials`, `matred`, `matgreen`, `matblue`, `matalpha`, `matbool`, `matpath`, `ig3d_material`), and `Data/` paths (none directly referenced in this code).
- **Reusable:** no

### meshMaterialsClicked
- **Does:** Triggers the chosen material setting option by calling `matsettingChosen` with the `matsetting` widget.
- **Uses:** Engine calls (none directly), globals (`matsettingChosen`, `matsetting`).
- **Reusable:** no
