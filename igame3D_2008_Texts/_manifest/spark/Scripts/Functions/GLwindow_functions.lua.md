<!-- Spark first-look of Data/Scripts/Functions/GLwindow_functions.lua (model spark-x2.6-4b, 2026-11-12 06:27). DRAFT for Claude to review. -->

## GLwindow_functions.lua
- **Kind:** engine-core
- **Purpose:** This file defines the `toggleQuadView` function, which controls the global `gFourView` flag and applies that flag change to the engine through the `ig3d_SetFourViews_b` call. It provides no other top-level or reusable functionality.
- **Depends on:** globals `gFourView` (set elsewhere), engine call `ig3d_SetFourViews_b` (part of the iGame3D engine API).
- **Provides:** `toggleQuadView` (toggles `gFourView` and updates the engine with `ig3d_SetFourViews_b`).
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or data paths are named).
- **Procedural:** none
- **Glossary:**
  - `gFourView` - A global flag tracking the four-view state of the game.
  - `ig3d_SetFourViews_b` - An iGame3D engine call that applies the four-view flag value to the engine.
- **Keep / port / drop:** keep - it is a small, focused utility function that directly maps a global flag to an engine call, useful as a reference for adding similar view-state controls to a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** nothing
- **Uses:** nothing
- **Reusable:** no

### toggleQuadView
- **Does:** Toggles the global `gFourView` flag and applies the change to the engine via `ig3d_SetFourViews_b(gFourView)`.
- **Uses:** globals `gFourView`, engine call `ig3d_SetFourViews_b`
- **Reusable:** no
- **Procedural:** no
