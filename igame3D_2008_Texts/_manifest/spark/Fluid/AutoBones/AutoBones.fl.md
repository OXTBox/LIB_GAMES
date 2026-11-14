<!-- Spark first-look of Data/Fluid/AutoBones/AutoBones.fl (model spark-x2.6-4b, 2026-11-12 19:19). DRAFT for Claude to review. -->

## AutoBones.fl
- **Kind:** ui-dialog
- **Purpose:** This file defines the BoningWindow FLTK user interface for the iGame3D engine, providing a window with label and widget layout plus button callbacks for mesh preparation and bone clustering operations.
- **Depends on:** `Data/WTF/Characters/human_bones.wtf`, `prepMeshForBones`, `boneMeshCluster`, `make_window`, `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `ig3d_ShowAll`, `ig3d_ClusterMeshBones`
- **Provides:** `BoningWindow` widget definition with its label, buttons, and callback bindings for the BoningWindow.
- **Assets it needs:** `Data/WTF/Characters/human_bones.wtf`
- **Procedural:** none
- **Glossary:**
  - `Fl_Window` - FLTK UI designer widget used to define the BoningWindow window.
  - `xywh` - FLTK widget layout property specifying widget position and size.
  - `callback` - FLTK widget binding that associates a button with a code block or named function.
  - `ig3d_ScaleSelectedMeshTo_3f` - engine call that scales the selected mesh.
  - `ig3d_SetMeshPositionNoUndo_3f` - engine call that sets the selected mesh position without undo.
  - `ig3d_MakeInvisible` - engine call that makes a mesh invisible.
  - `ig3d_ShowAll` - engine call that shows all meshes.
  - `ig3d_ClusterMeshBones` - engine call that clusters the bones of a mesh.
- **Keep / port / drop:** keep
  - Reason: A complete, reusable FLTK UI dialog definition with clear callback structure for mesh boning workflows.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the BoningWindow FLTK window with its label and widget layout, and includes the code block for the BoningWindow.
- **Uses:** `Fl_Window`, `Fl_Button`, `xywh`, `labelsize`, `callback`, `label`, `BoningWindow:show()`, `make_window`, `prepMeshForBones`, `boneMeshCluster`
- **Reusable:** no

### make_window
- **Does:** Opens the BoningWindow FLTK window with the label "Auto Boning" and the specified widget layout.
- **Uses:** `Fl_Window`, `label`, `xywh`, `type`, `when`, `make_window`
- **Reusable:** no

### prepMeshForBones
- **Does:** Sets the selected mesh scale and position, makes it invisible, then loads the human bones mesh from the Data/WTF path.
- **Uses:** `ig3d_ScaleSelectedMeshTo_3f`, `ig3d_SetMeshPositionNoUndo_3f`, `ig3d_MakeInvisible`, `loadMesh`, `Data/WTF/Characters/human_bones.wtf`
- **Reusable:** no

### boneMeshCluster
- **Does:** Shows all meshes and clusters the bones of the selected mesh.
- **Uses:** `ig3d_ShowAll`, `ig3d_ClusterMeshBones`
- **Reusable:** no

### BoningWindow
- **Does:** Defines the BoningWindow widget with its label, two buttons (Set 1x1x1 and 0,0,0 and Load Bones, and Set Auto Bones), and the callback bindings for the two buttons.
- **Uses:** `Fl_Button`, `label`, `callback`, `xywh`, `labelsize`, `prepMeshForBones`, `boneMeshCluster`
- **Reusable:** no
