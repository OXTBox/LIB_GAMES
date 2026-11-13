<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Door.lua (model spark-x2.6-4b, 2026-11-12 14:37). DRAFT for Claude to review. -->

## UDG_Door.lua
- **Kind:** library
- **Purpose:** This file defines shared door management logic for the UDG game, including a table of door objects and functions to open, close, and auto-close doors based on timers. It centralizes door state handling so other scripts can reuse door opening and closing behavior.
- **Depends on:** `gObjects`, `gObjectPositions`, `gObjectRotations`, `gDoShadows`, `doorTeam`, `computeShadowModelName`, `passed()`, `closedoors`, `IG3D_*` constants, and the `Data/` folder structure for loading scripts and objects.
- **Provides:** `doors` table (populated with door objects and defaults), `closedoors`, `handle_UDG_Doors`, `opendoor`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** no (it configures and manages existing door objects rather than generating assets from numbers or rules).
- **Glossary:**
  - `IG3D_*` constants - Engine property identifiers used to read or set object properties such as position, rotation, animation, and collision.
  - `gObjects` - Global table holding all game objects, used to find door objects for management.
  - `doorTeam` - Shared reference to the door object set used by door management functions.
  - `passed()` - Engine call used to determine the current time or state for door timer logic.
  - `setObjectInfo` - Engine call used to set properties on an object, such as animation and collision flags.
  - `getObjectInfo` - Engine call used to read properties from an object, such as position and rotation.
  - `computeShadowModelName` - Engine helper used to compute the shadow model name for door objects.
- **Keep / port / drop:** keep - it provides reusable door management logic that other scripts depend on for opening and closing doors.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the shared `doors` table and `alldoorsopen`/`lastdoorstate` flags, then populates `doors` with door objects found in `gObjects` and applies door defaults.
- **Uses:** `gObjects`, `gObjectPositions`, `gObjectRotations`, `getObjectInfo`, `setObjectInfo`, `computeShadowModelName`, `doorTeam`, `gDoShadows`, `ig3d_box`, `passed()`, `IG3D_*` constants.
- **Reusable:** no
- **Procedural:** no

### closedoors
- **Does:** Closes a door object by stopping its animation, re-enabling collision, and resetting its open state and close timer.
- **Uses:** `setObjectInfo` with `IG3D_ANIMATION`, `IG3D_COLL`, `obj.cObj`, `obj.open`, `obj.timetoclose`.
- **Reusable:** yes

### handle_UDG_Doors
- **Does:** Iterates over all doors, increments each door's close timer by `passed()`, and closes doors whose timer exceeds 2.
- **Uses:** `doors`, `doors[i].objectnum`, `doors[i].position`, `doors[i].rotation`, `doors[i].timetoclose`, `closedoors`, `passed()`, `IG3D_*` constants.
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 2

### opendoor
- **Does:** Opens a door object by setting its collision flag to false and assigning an animation to its child object, choosing between "OpenIn" and "OpenOut" based on a random value.
- **Uses:** Engine calls (`setObjectInfo`), globals (`obj`, `IG3D_COLL`, `IG3D_ANIMATION`), engine constants (`IG3D_POSITION` not used here).
- **Reusable:** yes - a small conditional animation assignment for door opening logic.
- **Procedural:** no
