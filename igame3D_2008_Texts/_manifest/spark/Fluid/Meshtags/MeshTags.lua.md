<!-- Spark first-look of Data/Fluid/Meshtags/MeshTags.lua (model spark-x2.6-4b, 2026-11-13 01:04). DRAFT for Claude to review. -->

## MeshTags.lua
- **Kind:** ui-dialog
- **Purpose:** This file implements a FLTK user interface for managing mesh tags in iGame3D, providing controls to add, browse, select, hide, remove, and export tagged mesh vertices. It sets up the mesh tag window and its controls, then runs the FLTK application.
- **Depends on:** `Data/` folder paths for mesh tag scripts and levels, engine calls `ig3d_GetMesh_tagsList__s()`, `ig3d_CreateMesh_tag_s()`, `ig3d_AddToMesh_tag_i(i)`, `ig3d_SelectMesh_tagVertices_ib(i,bool)`, `ig3d_MakeInvisible()`, `ig3d_SetMesh_tagVisibility_ib(i,bool)`, `ig3d_RemoveFromMesh_tag_i(i)`, `ig3d_ShowAll()`, `ig3d_SelectWholeMesh()`, `ig3d_GetMeshCentroid__3f()`, global `tagsloaded`, global `TagNameList`, global `gLabelTable`, FLTK UI functions `fltk:Fl_Double_Window`, `fltk:Fl_Input`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `fltk:Fl:run()`, FLTK event functions `Fl:event_key()`, `fltk.FL_Enter`, `fltk.FL_KP_Enter`, FLTK widget methods `TagNameAddField:value()`, `TagNameList:clear()`, `TagNameList:add()`, `TagNameList:remove()`, `TagNameList:bottomline()`, `TagNameList:select()`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `numberofitems()`, `item()`, `w:size()`, `w:selected()`, `w:text()`, `w:value()`, FLTK UI setup globals `MeshtagsWindow`, `TagNameAddField`, `TagNameList`, `TagVerticesButton`, `SelectTaggedButton`, `ShowTagged`, `HideTaggedButton`, `UnTagVerticesButton`, `ExportTags`, `updateTagBrowser()`
- **Provides:** Functions for adding/selecting mesh tags (`addToTagList`, `selectTagLine`), updating the tag browser (`updateTagBrowser`), and actions for tag selection, hiding, removal, and export (`tagVerticesAction`, `selectTaggedAction`, `showTaggedAction`, `hideTaggedAction`, `removeFromTagsAction`, `exportTagsAction`), plus the global `tagsloaded` storing the mesh tag list.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - mesh tag - A named tag applied to mesh vertices in iGame3D, managed via the Mesh Tags UI.
  - mesh tag list - The list of existing mesh tags returned by `ig3d_GetMesh_tagsList__s()`.
  - mesh vertex selection - Selecting specific vertices of a mesh using mesh tag indices via `ig3d_SelectMesh_tagVertices_ib()`.
  - mesh centroid - The center point of a mesh, accessed via `ig3d_GetMeshCentroid__3f()`.
  - mesh visibility - The visibility state of a mesh tag, set via `ig3d_SetMesh_tagVisibility_ib()`.
- **Keep / port / drop:** keep - A complete, reusable UI implementation for mesh tag management that follows iGame3D's existing object and call patterns.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Ensures the mesh tag list exists before creating the initial tag objects, then stores the returned tag list in the global `tagsloaded`.
- **Uses:** `ig3d_GetMesh_tagsList__s()`, `ig3d_CreateMesh_tag_s()`, global `tagsloaded`
- **Reusable:** no

### addToTagList
- **Does:** Returns early if the active key is not Enter, then creates a mesh tag for the entered tag name, refreshes the tag browser, and selects the newly added tag line.
- **Uses:** `Fl:event_key()`, `fltk.FL_Enter`, `fltk.FL_KP_Enter`, `TagNameAddField:value()`, `ig3d_CreateMesh_tag_s()`, `updateTagBrowser()`, `TagNameList:remove()`, `TagNameList:bottomline()`, `TagNameList:select()`, global `TagNameList`
- **Reusable:** no

### updateTagBrowser
- **Does:** Clears the tag browser, reads the mesh tag list, counts its lines, and adds each non-nil line to the browser list.
- **Uses:** `TagNameList:clear()`, `ig3d_GetMesh_tagsList__s()`, `numberofitems()`, `item()`, `TagNameList:add()`, global `TagNameList`
- **Reusable:** no

### selectTagLine
- **Does:** Iterates the selected tag lines, toggles vertex selection based on the line index, and collects the selected line text into a selection string.
- **Uses:** `w:size()`, `w:selected()`, `w:text()`, `w:value()`, `ig3d_SelectMesh_tagVertices_ib()`, global `w`
- **Reusable:** no

## Part 2 of 3

### tagVerticesAction
- **Does:** Iterates the tag list, selects the entries that are currently selected, adds them to the mesh via the tag index, and prints the selected tag names joined by newlines.
- **Uses:** `TagNameList` (tag list object), `ig3d_AddToMesh_tag_i(i)`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `print`
- **Reusable:** yes
- **Reusable detail:** pure data/selection logic over the tag list, no asset generation.

### selectTaggedAction
- **Does:** Iterates the tag list, selects the entries that are currently selected, deselects them on the mesh via the tag index, and prints the selected tag names joined by newlines.
- **Uses:** `TagNameList` (tag list object), `ig3d_SelectMesh_tagVertices_ib(i,false)`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `print`
- **Reusable:** yes
- **Reusable detail:** pure data/selection logic over the tag list, no asset generation.

### showTaggedAction
- **Does:** Shows all mesh tags, then for each selected tag selects it on the mesh, makes it invisible, hides its visibility, and prints the selected tag names joined by newlines; finally selects the whole mesh.
- **Uses:** `TagNameList` (tag list object), `ig3d_ShowAll()`, `ig3d_SelectMesh_tagVertices_ib(i,true)`, `ig3d_MakeInvisible()`, `ig3d_SetMesh_tagVisibility_ib(i,false)`, `ig3d_SetMesh_tagVisibility_ib(i,true)`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `ig3d_SelectWholeMesh()`, `print`
- **Reusable:** yes
- **Reusable detail:** pure data/selection logic over the tag list, no asset generation.

### hideTaggedAction
- **Does:** Iterates the tag list, for each selected tag selects it on the mesh, makes it invisible, hides its visibility, and prints the selected tag names joined by newlines.
- **Uses:** `TagNameList` (tag list object), `ig3d_SelectMesh_tagVertices_ib(i,true)`, `ig3d_MakeInvisible()`, `ig3d_SetMesh_tagVisibility_ib(i,false)`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `print`
- **Reusable:** yes
- **Reusable detail:** pure data/selection logic over the tag list, no asset generation.

### removeFromTagsAction
- **Does:** Iterates the tag list, for each selected tag removes it from the mesh via the tag index, and prints the selected tag names joined by newlines.
- **Uses:** `TagNameList` (tag list object), `ig3d_RemoveFromMesh_tag_i(i)`, `TagNameList:selected(i)`, `TagNameList:text(i)`, `print`
- **Reusable:** yes
- **Reusable detail:** pure data/selection logic over the tag list, no asset generation.

## Part 3 of 3

### Top level
- **Does:** Sets up the Mesh Tags window and its controls, then runs the FLTK application.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Input`, `fltk:Fl_Browser`, `fltk:Fl_Button`, `gLabelTable`, `MeshtagsWindow`, `TagNameAddField`, `TagNameList`, `TagVerticesButton`, `SelectTaggedButton`, `ShowTagged`, `HideTaggedButton`, `UnTagVerticesButton`, `ExportTags`, `Fl:run()`, `updateTagBrowser()`
- **Reusable:** no

### exportTagsAction
- **Does:** Builds an export string for tagged mesh vertices, prints it, and triggers the mesh vertex tagging action for each selected tag.
- **Uses:** `TagNameList`, `ig3d_SelectMesh_tagVertices_ib`, `ig3d_GetMeshCentroid__3f`, `ig3d_CreateMesh_tag_s`, `ig3d_AddToMesh_tag_i`, `print`
- **Reusable:** no
- **Procedural:** no
