<!-- Spark first-look of Data/Fluid/AutoBones/AutoBones.lua (model spark-x2.6-4b, 2026-11-12 19:35). DRAFT for Claude to review. -->

## AutoBones.lua
- **Kind:** tool
- **Purpose:** This file sets up the Auto Boning window with its buttons and starts the FLTK application, providing helper routines that prepare meshes for bone clustering and cluster mesh bones for the Auto Boning workflow.
- **Depends on:** `fltk` (Fl_Double_Window, Fl_Button, run), `gLabelTable`, `BoningWindow`, `Data/WTF/Characters/human_bones.wtf`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `loadMesh`, `ig3d_ShowAll`, `ig3d_ClusterMeshBones`
- **Provides:** `make_window`, `prepMeshForBones`, `boneMeshCluster`
- **Assets it needs:** `Data/WTF/Characters/human_bones.wtf`
- **Procedural:** none
- **Glossary:**
  - Auto Boning - the workflow for preparing meshes and clustering mesh bones in the AutoBones tool.
  - `ig3d_ScaleSelectedMeshTo_3f` - engine call that scales the selected mesh to 3D coordinates.
  - `ig3d_SetMeshPositionNoUndo_3f` - engine call that sets the mesh position without triggering an undo action.
  - `ig3d_MakeInvisible` - engine call that makes an object invisible.
  - `loadMesh` - engine call that loads a mesh file from a path.
  - `ig3d_ShowAll` - engine call that shows all objects in the scene.
  - `ig3d_ClusterMeshBones` - engine call that clusters the bones of a mesh.
- **Keep / port / drop:** keep - it is a functional tool file with reusable helper routines for mesh preparation and bone clustering.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets up the Auto Boning window and its buttons, then starts the FLTK application.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Button`, `gLabelTable`, `BoningWindow`, `Fl:run()`, `Data/` path `Data/WTF/Characters/human_bones.wtf`
- **Reusable:** no

### prepMeshForBones
- **Does:** Prepares the selected mesh for bone clustering by scaling it, setting its position, making it invisible, and loading the human bones mesh.
- **Uses:** `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `loadMesh("Data/WTF/Characters/human_bones.wtf")`
- **Reusable:** no

### boneMeshCluster
- **Does:** Shows all objects and clusters the mesh bones.
- **Uses:** `ig3d_ShowAll`, `ig3d_ClusterMeshBones`
- **Reusable:** no
