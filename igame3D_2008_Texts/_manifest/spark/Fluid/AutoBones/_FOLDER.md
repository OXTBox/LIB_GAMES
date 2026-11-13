<!-- Spark folder manifest of Data/Fluid/AutoBones (model spark-x2.6-4b, 2026-11-12 19:35). DRAFT. -->

# Data/Fluid/AutoBones
- **Role:** This folder holds the Auto Boning tool for the iGame3D engine, a FLTK user interface and Lua helper routines that prepare meshes for bone clustering and cluster mesh bones for the Auto Boning workflow.
- **Entry point:** AutoBones.lua
- **Files:**
  - AutoBones.fl - FLTK UI dialog defining the BoningWindow window, label, widget layout, and button callbacks for mesh preparation and bone clustering operations.
  - AutoBones.lua - tool that sets up the Auto Boning window with its buttons, starts the FLTK application, and provides helper routines make_window, prepMeshForBones, and boneMeshCluster.
- **Shared with other folders:** Needs `Data/WTF/Characters/human_bones.wtf` and the engine calls ig3d_ScaleSelectedMeshTo_3f, ig3d_SetMeshPositionNoUndo_3f, ig3d_MakeInvisible, loadMesh, ig3d_ShowAll, ig3d_ClusterMeshBones, plus fltk, gLabelTable, and BoningWindow. Others take the BoningWindow widget definition and its callback bindings from this folder.
- **Procedure candidates:** make_window, prepMeshForBones, and boneMeshCluster are code routines that produce the window setup and mesh preparation/bone clustering operations instead of being stored as separate files.
- **Glossary:**
  - BoningWindow - the FLTK user interface widget defined by AutoBones.fl for the Auto Boning workflow.
  - Auto Boning - the workflow for preparing meshes and clustering mesh bones in the AutoBones tool.
  - make_window - engine/tool routine that creates the BoningWindow window.
  - prepMeshForBones - helper routine that prepares meshes for bone clustering.
  - boneMeshCluster - helper routine that clusters the bones of a mesh.
  - ig3d_ClusterMeshBones - engine call that clusters the bones of a mesh.
  - ig3d_ScaleSelectedMeshTo_3f - engine call that scales the selected mesh to 3D coordinates.
  - ig3d_SetMeshPositionNoUndo_3f - engine call that sets the mesh position without triggering an undo action.
  - ig3d_MakeInvisible - engine call that makes an object invisible.
  - loadMesh - engine call that loads a mesh file from a path.
  - ig3d_ShowAll - engine call that shows all objects in the scene.
- **Verdict:** keep - it is a functional tool file with reusable helper routines for mesh preparation and bone clustering, and the FLTK UI dialog definition provides a clear callback structure for mesh boning workflows.
