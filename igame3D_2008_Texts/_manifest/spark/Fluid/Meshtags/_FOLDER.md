<!-- Spark folder manifest of Data/Fluid/Meshtags (model spark-x2.6-4b, 2026-11-13 01:05). DRAFT. -->

# Data/Fluid/Meshtags
- **Role:** This folder provides a FLTK user interface for managing mesh tags in iGame3D, letting developers add, browse, select, hide, remove, and export tagged mesh vertices. It sets up the mesh tag window and controls, then runs the FLTK application.
- **Entry point:** MeshTags.lua
- **Files:** MeshTags.fl - FLUID twin of MeshTags.lua; MeshTags.lua - FLTK UI for mesh tag management.
- **Shared with other folders:** Needs mesh tag scripts and levels under Data/, plus engine mesh tag calls and globals tagsloaded, TagNameList, gLabelTable. Others use its mesh tag management UI.
- **Procedure candidates:** updateTagBrowser() updates the mesh tag browser from engine mesh tag data; addToTagList and selectTagLine add and select mesh tags; exportTagsAction exports tagged mesh vertices.
- **Glossary:**
  - mesh tag - A named tag applied to mesh vertices in iGame3D, managed via the Mesh Tags UI.
  - mesh tag list - The list of existing mesh tags returned by ig3d_GetMesh_tagsList__s().
  - mesh vertex selection - Selecting specific mesh vertices using mesh tag indices via ig3d_SelectMesh_tagVertices_ib().
  - mesh centroid - The center point of a mesh, accessed via ig3d_GetMeshCentroid__3f().
  - mesh visibility - The visibility state of a mesh tag, set via ig3d_SetMesh_tagVisibility_ib().
- **Verdict:** keep - It is a complete, reusable FLTK mesh tag management UI that follows iGame3D's existing object and call patterns, with no missing assets or procedural dependencies.
