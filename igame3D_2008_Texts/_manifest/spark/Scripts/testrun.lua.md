<!-- Spark first-look of Data/Scripts/testrun.lua (model spark-x2.6-4b, 2026-11-12 18:23). DRAFT for Claude to review. -->

## testrun.lua
- **Kind:** test/example
- **Purpose:** This file is a short test or example script that configures the rotation of a selected object, renders the current scene, and prints the name of the selected object. It is used to verify or demonstrate basic object rotation and scene rendering behavior in the iGame3D engine.
- **Depends on:** `Data/` folder paths for engine resources, global engine state such as `gObjects` and `gameroot`, and engine functions including `setObjectInfo`, `render`, and `ig3d_GetSelection__s`.
- **Provides:** No dedicated functions or globals are defined; it performs direct engine calls to set object rotation, render the scene, and output the selected object name.
- **Assets it needs:** none (no specific models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (the file only configures existing object rotation and renders the scene; it does not generate assets from numbers or rules).
- **Glossary:**
  - `setObjectInfo - Engine call to set properties of an object, using a property constant such as IG3D_ROTATION.`
  - `ig3d_GetSelection__s - Engine call to retrieve the currently selected object in the engine.`
  - `render - Engine call to render the current scene.`
  - `IG3D_ROTATION - Engine constant naming the rotation property of an object.`
- **Keep / port / drop:** keep - it is a short, focused example of basic object rotation and scene rendering that serves as a useful reference for new engine development.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the rotation of the selected object to 0, 90, 0, renders the scene, and prints the name of the selected object.
- **Uses:** `setObjectInfo`, `ig3d_GetSelection__s`, `render`, `IG3D_ROTATION`
- **Reusable:** no
