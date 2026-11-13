<!-- Spark first-look of Data/Scripts/Examples/truebonesbuilder1.lua (model spark-x2.6-4b, 2026-11-12 15:06). DRAFT for Claude to review. -->

## truebonesbuilder1.lua
- **Kind:** test/example
- **Purpose:** This file defines two TrueBones construction functions that build tagged mesh vertices and link bones into torso, left arm, right arm, left leg, and right leg hierarchies for a TrueBones-style skeleton. It is a standalone example script for creating TrueBones-style bone sets from mesh vertices.
- **Depends on:** nothing; no files are loaded, no `Data/` paths are referenced, and no globals are set elsewhere.
- **Provides:** `makeTrueBonesTorso`, `makeTrueBonesLeftArm`, `makeTrueBonesRightArm`, `makeTrueBonesLeftLeg`, `makeTrueBonesRightLeg`.
- **Assets it needs:** none; no models, images, sounds, emitters, or fonts are named.
- **Procedural:** yes; the file generates mesh vertices and bone hierarchies from rules for creating TrueBones-style skeleton segments, rather than loading any asset file.
- **Glossary:**
  - `ig3d_CreateMesh_tag_s - Creates a mesh with a tag for TrueBones-style vertex construction.`
  - `drawVertex - Adds a vertex to the mesh being built for the TrueBones skeleton.`
  - `ig3d_AddToMesh_tag_i - Assigns a tagged vertex to the mesh being built.`
  - `ig3d_MakeBoneFromVertex_2s - Creates a bone from a vertex in the mesh hierarchy.`
- **Keep / port / drop:** keep - it is a reusable example of building TrueBones-style skeleton hierarchies from mesh vertices.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No top-level code outside the two function definitions; the file only defines the two TrueBones construction functions.
- **Uses:** nothing
- **Reusable:** no

### makeTrueBonesTorso
- **Does:** Creates a TrueBones-style torso skeleton by adding tagged mesh vertices, assigning each vertex to a mesh, and linking bones in a torso hierarchy from hip up through head and collar points.
- **Uses:** `ig3d_CreateMesh_tag_s`, `drawVertex`, `ig3d_AddToMesh_tag_i`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** no

### makeTrueBonesLeftArm
- **Does:** Creates a TrueBones-style left arm skeleton by adding tagged mesh vertices, assigning each vertex to a mesh, and linking bones in a left arm hierarchy from shoulder down through forearm and hand.
- **Uses:** `ig3d_CreateMesh_tag_s`, `drawVertex`, `ig3d_AddToMesh_tag_i`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** no

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the three function definitions; the file only contains the function bodies for creating true bone sets.
- **Uses:** nothing
- **Reusable:** no

### makeTrueBonesRightArm
- **Does:** Creates the right arm bone hierarchy by building three mesh-based bone segments: right shoulder, right forearm, and right hand, each with a vertex and bone connection.
- **Uses:** `ig3d_CreateMesh_tag_s`, `drawVertex`, `ig3d_AddToMesh_tag_i`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** no

### makeTrueBonesLeftLeg
- **Does:** Creates the left leg bone hierarchy by building three mesh-based bone segments: left thigh, left shin, and left foot, each with a vertex and bone connection.
- **Uses:** `ig3d_CreateMesh_tag_s`, `drawVertex`, `ig3d_AddToMesh_tag_i`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** no

### makeTrueBonesRightLeg
- **Does:** Creates the right leg bone hierarchy by building three mesh-based bone segments: right thigh, right shin, and right foot, each with a vertex and bone connection.
- **Uses:** `ig3d_CreateMesh_tag_s`, `drawVertex`, `ig3d_AddToMesh_tag_i`, `ig3d_MakeBoneFromVertex_2s`
- **Reusable:** no
