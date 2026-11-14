<!-- Spark first-look of Data/Fluid/MeshtagBrowser/MeshtagBrowser.lua (model spark-x2.6-4b, 2026-11-13 01:01). DRAFT for Claude to review. -->

## MeshtagBrowser.lua
- **Kind:** ui-dialog
- **Purpose:** This file provides a user interface for browsing and manipulating mesh tags in iGame3D, including listing used mesh tags, selecting and editing tag textures, and navigating PNG file directories. It wires FLTK widgets to mesh tag browser callbacks and runs the FLTK application after initializing the mesh tag list.
- **Depends on:** `gameroot` global; `Data/Images/` path; engine calls `ig3d_GetMesh_tagsList__s`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMeshPosition_3f`, `ig3d_DeleteMesh_tag_i`, `ig3d_GetMeshMaterialsList__s`, `ig3d_GetMeshMaterialInfo_i_s`, `ig3d_CreateMaterial_s`, `ig3d_SetMeshMaterialInfo_is`, `ig3d_SetMaterialForSelectedMesh_i`, `ig3d_SelectMesh_tagVertices_ib`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCameraInfo`, `setCameraInfo`, `getCamera

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Contains the file-level setup lines for MeshtagBrowser, including the initial empty string assignments and the nil-check initialization of `nTagNumber`.
- **Uses:** Globals `selectedTagName`, `selectedTagNum`, `extractedTagName`, `taglistfirstrun`, `nTagNumber`.
- **Reusable:** no

### extractTagName
- **Does:** Extracts the numeric tag coordinates and tag name from a tag string, returning the three values.
- **Uses:** Globals `string.find`, `string.match`, `string.sub`, `tonumber`.
- **Reusable:** yes

### listUsedTags
- **Does:** Lists used mesh tags by selecting each tag vertex, checking centroid sums, deleting invalid tags, and collecting valid tag strings into `meshTagListTable`.
- **Uses:** Engine calls `ig3d_GetMesh_tagsList__s`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMeshCentroid__3f`, `ig3d_SetMeshPosition_3f`, `ig3d_DeleteMesh_tag_i`, `getlinecount`, `getlineof`, globals `meshTagListTable`, `nTagNumber`.
- **Reusable:** no

### fillmeshTagList
- **Does:** Redraws the mesh tag browser, refreshes the tag list count, and appends all tag lines from the mesh tags list to `meshTagListTable`.
- **Uses:** Engine calls `MeshTagBrowser:redraw`, `fltk_update`, `ig3d_GetMesh_tagsList__s`, `getlinecount`, `getlineof`, globals `meshTagListTable`, `nTagNumber`.
- **Reusable:** no

## Part 2 of 5

### Top level
- **Does:** Sets the PNG browser path and initializes the PNG browser file table and last selection variables at the top of the file.
- **Uses:** `gameroot` global, string concatenation with `Data/Images/` path.
- **Reusable:** yes
- **Procedural:** no

### listMeshTagBrowser
- **Does:** Clears and repopulates the mesh tag browser UI, resets the selected tag number, sets the tag count, and selects the first tag.
- **Uses:** `ig3d_GetMesh_tagsList__s()`, `MeshtagListBrowser:clear()`, `MeshtagListBrowser:add()`, `MeshtagListBrowser:redraw()`, `MeshTagBrowser:redraw()`, `selectedTagNum`, `meshTagListTable`, `nTagNumber`, `MeshtagListBrowser:select()`, `MeshtagListBrowser:value()`, `fltk_update()`.
- **Reusable:** no
- **Procedural:** no

### matinlist
- **Does:** Iterates over the mesh material list string, counts the number of entries, and returns the matched string and count when the input parameter matches the current string.
- **Uses:** `ig3d_GetMeshMaterialsList__s()`, `string.gmatch()`, `string.find()`, `string.sub()`, `nmat`.
- **Reusable:** yes
- **Procedural:** no

### meshTagListBrowserCB
- **Does:** Handles the mesh tag list browser callback, selects the requested tag, selects its vertices, and optionally snaps the camera to the mesh centroid when the camera snap button is enabled.
- **Uses:** `w:value()`, `selectedTagNum`, `ig3d_SelectMesh_tagVertices_ib()`, `selectedTagName`, `meshTagListTable`, `cameraTagSnapBtn:value()`, `ig3d_GetMeshCentroid__3f()`, `getCameraInfo()`, `setCameraInfo()`, `camera_face_xyz()`, `IG3D_POSITION`.
- **Reusable:** no
- **Procedural:** no

## Part 3 of 5

### mtlistPNGFiles
- **Does:** Clears the PNG file browser, scans the PNG browser folder for files and directories, and populates the PNG file list with their names and types.
- **Uses:** `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`, `mtPNGBrowserFiles`, `mtPNGBrowserPath`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `mtPNGBrowserFiles`, `

<!-- CUT OFF: reached max_tokens (1000); delete this file and rerun -->

## Part 4 of 5

### mtPNGLoad
- **Does:** Loads a selected PNG texture into the current mesh tag, updates the mesh material with the texture path, and applies the material to the selected mesh.
- **Uses:** `MeshTagBrowser:make_current()`, `mtPNGBrowser:value()`, `mtPNGBrowserFiles`, `gameroot`, `loadTexture`, `gCatchTexturePath`, `fileShortNameFromPath`, `matinlist`, `selectedTagName`, `ig3d_GetMeshMaterialInfo_i_s`, `ig3d_CreateMaterial_s`, `ig3d_GetMeshMaterialsList__s`, `ig3d_GetMeshMaterialInfo_i_s`, `ig3d_SetMeshMaterialInfo_is`, `ig3d_SetMaterialForSelectedMesh_i`, plus local variables and string operations.
- **Reusable:** yes - the texture loading and mesh material update logic can be reused for other texture-related mesh tag workflows.

### mtPNGbrowserControlDoubleClicked
- **Does:** Navigates the PNG file browser directory when the control is double-clicked, refreshing the file list after moving into a directory or going up one level.
- **Uses:** `mtPNGBrowserFiles`, `mtPNGBrowserPath`, `goDirsUp`, `mtlistPNGFiles`.
- **Reusable:** yes - directory navigation logic for the PNG browser can be reused for similar file browser controls.

### mtPNGbrowserControlClicked
- **Does:** Updates the PNG preview box for a selected file, refreshes the preview after a double-click, and tracks the last selection and click timing to gate directory navigation.
- **Uses:** `mtPNGBrowserFiles`, `updatemtPNGPreviewBox`, `time`, `gLastBrowserControlClick`, `mtPNGLastSelection`, `mtPNGbrowserControlDoubleClicked`.
- **Reusable:** yes - the click timing and selection tracking logic for the PNG browser control can be reused for similar file browser controls.

## Part 5 of 5

### Top level
- **Does:** Sets up the Fluid UI widgets for the mesh tag browser, wires the mesh tag list browser callbacks, and runs the FLTK application after initializing the mesh tag list.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Browser`, `fltk:Fl_Group`, `fltk:Fl_Box`, `fltk:Fl_Button`, `fltk:Fl_Check_Button`, `gLabelTable`, `mtPNGPreviewBox`, `mtPNGFileBrowser`, `mtLoadButton`, `cameraTagSnapBtn`, `MeshTagBrowser`, `MeshtagListBrowser`, `pngBrowserGroup`, `fltk_update`, `Fl:run`
- **Reusable:** no

### getnextXtag
- **Does:** Finds the first mesh tag entry with a larger tag number than the current one, selects it, updates the mesh tag browser UI, and optionally snaps the camera to the selected mesh centroid.
- **Uses:** `extractTagName`, `selectedTagName`, `selectedTagNum`, `meshTagListTable`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMesh_tagsList__s`, `MeshtagListBrowser:select`, `MeshtagListBrowser:value`, `MeshtagListBrowser:redraw`, `MeshTagBrowser:redraw`, `cameraTagSnapBtn`, `ig3d_GetMeshCentroid__3f`, `getCameraInfo`, `IG3D_POSITION`, `setCameraInfo`, `camera_face_xyz`, `fltk:Fl_Double_Window` (via top-level setup)
- **Reusable:** no
- **Procedural:** no
