<!-- Spark first-look of Data/Scripts/Functions/edit_mode_functions.lua (model spark-x2.6-4b, 2026-11-12 06:47). DRAFT for Claude to review. -->

## edit_mode_functions.lua
- **Kind:** engine-core
- **Purpose:** This file provides editing-mode control functions for the iGame3D engine. It manages the active editing mode, applies the matching mouse, mesh tool, and focus settings for each mode, and exposes UI toggle buttons that switch between editing modes and refresh the interface.
- **Depends on:** globals `gEditingMode`, `gMouse`; engine calls `setSceneInfo`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_TellFocus_b`, `ig3d_GetMode__i`, `UIUpdate`; engine call `editingModeSwitch` (defined in this file).
- **Provides:** `editingModeSwitch`, `EditModeToggle`, `viewplaytoggle`, `editbutton`.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` paths are named).
- **Procedural:** none
- **Glossary:**
  - editing mode - the active mode of the engine's editing state, controlling mouse and mesh tool behavior.
  - select_entity - an editing mode that selects entities for editing.
  - lookaround - an editing mode for viewing the scene around the current camera position.
  - mesh tool - the engine tool used for mesh editing, selected by the editing mode.
  - focus - the engine's focus state, updated when the editing mode changes.
- **Keep:** yes, it is a reusable set of editing-mode control functions for the engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** The file contains no top-level code outside the defined functions; setup, globals, widget definitions, or settings are absent.
- **Uses:** nothing
- **Reusable:** no

### editingModeSwitch
- **Does:** Switches the engine editing mode based on the new editing mode value, applying corresponding mouse, mesh tool, and focus settings for each mode, and updates the editing mode when the drop entity edit mode is triggered.
- **Uses:** globals `gEditingMode`, `gMouse`; engine calls `setSceneInfo`, `ig3d_SetMode_i`, `ig3d_SetMeshTool_i`, `ig3d_TellFocus_b`, `ig3d_GetMode__i`; no file or `Data/` path reads or writes.
- **Reusable:** no

### EditModeToggle
- **Does:** Toggles the editing mode between play and select_entity, then calls editingModeSwitch with the resulting mode.
- **Uses:** globals `gEditingMode`; engine call `editingModeSwitch`; no file or `Data/` path reads or writes.
- **Reusable:** no

### viewplaytoggle
- **Does:** Toggles the editing mode between lookaround and play, then calls editingModeSwitch with the resulting mode.
- **Uses:** globals `gEditingMode`; engine call `editingModeSwitch`; no file or `Data/` path reads or writes.
- **Reusable:** no

### editbutton
- **Does:** Calls EditModeToggle to switch the editing mode, then calls UIUpdate to refresh the UI.
- **Uses:** engine call `UIUpdate`; no file or `Data/` path reads or writes.
- **Reusable:** no
