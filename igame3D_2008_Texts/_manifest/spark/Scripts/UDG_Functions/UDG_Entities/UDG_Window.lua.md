<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Window.lua (model spark-x2.6-4b, 2026-11-12 14:42). DRAFT for Claude to review. -->

## UDG_Window.lua
- **Kind:** engine-core
- **Purpose:** This file defines the `windows` table by scanning `gObjects` and initializing each window entry with position, rotation, house flag, alive flag, team, health, and box shape. It also provides `handle_UDG_Windows`, which updates the position and rotation of every window in the table when the window is alive and its health is greater than zero.
- **Depends on:** `gObjects`, `gObjectPositions`, `gObjectRotations`, `computeShadowModelName`, `windowTeam`, `gDoShadows`, `Data/` folder paths, and globals set elsewhere in the engine (e.g., `ig3d_box`).
- **Provides:** the `windows` table and the `handle_UDG_Windows` function.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (the file builds the `windows` table from existing `gObjects` entries and configures window properties; it does not generate assets from numbers or rules).
- **Glossary:**
  - `gObjects` - the shared global table of game objects in the engine.
  - `getObjectInfo` / `setObjectInfo` - engine calls that read or set object properties such as position, rotation, and shape.
  - `IG3D_...` - constants naming the properties being read or set on objects (e.g., `IG3D_POSITION`, `IG3D_ROTATION`).
  - `windowTeam` - a function that assigns a team value to a window object.
  - `computeShadowModelName` - a function that computes the shadow model name for a window object.
  - `gDoShadows` - a global flag controlling whether shadows are enabled for objects.
  - `house flag` - a flag marking a window as a house window.
  - `alive flag` - a flag marking a window as currently active.
- **Keep / port / drop:** keep - it is a core engine component that builds and updates window state from existing game objects, useful as a reference for other entity tables.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `windows` table and builds it by scanning `gObjects`, then initializes each window entry with position, rotation, house flag, alive flag, team, health, and box shape.
- **Uses:** `gObjects`, `gObjectPositions`, `gObjectRotations`, `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, `windowTeam`, `gDoShadows`, `IG3D_NAME`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_SHAPE`, `IG3D_MASS`, `IG3D_COLLBOX_MULTIPLICATORS`, `ig3d_box`
- **Reusable:** no
- **Procedural:** no

### handle_UDG_Windows
- **Does:** Updates the position and rotation of every window in the `windows` table when the window is alive and health is greater than zero.
- **Uses:** `windows`, `setObjectInfo`, `IG3D_POSITION`, `IG3D_ROTATION`
- **Reusable:** no
- **Procedural:** no
