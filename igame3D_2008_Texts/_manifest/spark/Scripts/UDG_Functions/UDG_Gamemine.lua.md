<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Gamemine.lua (model spark-x2.6-4b, 2026-11-12 17:21). DRAFT for Claude to review. -->

## UDG_Gamemine.lua
- **Kind:** library
- **Purpose:** This file is a Lua library for the iGame3D 3D game engine, providing UDG-specific game logic, target click handling, and the main UDG game loop. It contains no setup or widget code at the top level, with only a global flag assignment outside functions.
- **Depends on:** `Data/` folder paths (e.g., `gameroot.."Data/<Folder>/<file>"`), `gObjects` and other shared globals, and functions from other Scripts libraries such as `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `udg_display_FPS`, plus engine calls like `getObjectInfo`, `setObjectInfo`, `setSceneInfo`, `setCameraInfo`, `setLightInfo`, `getSceneInfo`, `loadLevel`, and `dofile`.
- **Provides:** `pick_highest_ranked_zombie`, `udg_handle_target_click_selection`, `deDollObjects`, and `handle_udg`; also sets the global `gDoVelocityClamp=true`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none
- **Glossary:**
  - `IG3D_POSITION -` iGame3D property constant used to read or set an object's position.
  - `IG3D_MOUSE_LINE -` iGame3D constant naming the mouse line property used for collision checks.
  - `gDoVelocityClamp -` global flag assigned at top level to control velocity clamping behavior.
  - `getObjectInfo -` iGame3D call that reads object properties by property constant.
  - `setObjectInfo -` iGame3D call that sets object properties by property constant.
  - `loadLevel -` iGame3D call that switches the active game or demo level.
  - `lineCollision -` iGame3D call that checks whether a line intersects an object.
- **Keep / port / drop:** keep - core UDG game logic and target interaction handlers that are reusable for new engine implementations.

---

# Part notes

## Part 1 of 3

### pick_highest_ranked_zombie
- **Does:** Finds the nearest zombie object from the given coordinates, first checking zombies with no ranking order, then any other alive team-1 zombie if none are ranked.
- **Uses:** `gObjects`, `getObjectInfo` with `IG3D_POSITION`, `vecLength`
- **Reusable:** yes - pure data lookup and distance calculation over existing object lists
- **Procedural:** no

### Top level
- **Does:** nothing

## Part 2 of 3

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions; the only code outside functions is a single global assignment `gDoVelocityClamp=true`.
- **Uses:** `gDoVelocityClamp=true` (global assignment)
- **Reusable:** no

### udg_handle_target_click_selection
- **Does:** Handles target click selection by checking the mouse line collision, then either triggers zombie combat or zombie path generation based on collision type and object team.
- **Uses:** `click`, `getSceneInfo`, `IG3D_MOUSE_LINE`, `lineCollision`, `pick_highest_ranked_zombie`, `getObjectInfo`, `IG3D_POSITION`, `normalized`, `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `sceneryTeam`, `doorTeam`, `windowTeam`, `IG3D_MOUSE_LINE`
- **Reusable:** no

### deDollObjects
- **Does:** Is an empty function with no implementation.
- **Uses:** nothing
- **Reusable:** yes

Wait, the global assignment `gDoVelocityClamp=true` appears after the functions, so it is top-level code. Let me correct the top-level section to reflect that accurately.

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions; the only code outside functions is a single global assignment `gDoVelocityClamp=true`.
- **Uses:** `gDoVelocityClamp=true` (global assignment)
- **Reusable:** no

### deDollObjects
- **Does:** Is an empty function with no implementation.
- **Uses:** nothing
- **Reusable:** yes

### udg_handle_target_click_selection
- **Does:** Handles target click selection by checking the mouse line collision, then either triggers zombie combat or zombie path generation based on collision type and object team.
- **Uses:** `click`, `getSceneInfo`, `IG3D_MOUSE_LINE`, `lineCollision`, `pick_highest_ranked_zombie`, `getObjectInfo`, `IG3D_POSITION`, `normalized`, `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `sceneryTeam`, `doorTeam`, `windowTeam`
- **Reusable:** no

Wait, the required order is `udg_handle_target_click_selection` first, then `deDollObjects`. I need to fix the order.

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the two listed functions; the only code outside functions is a single global assignment `gDoVelocityClamp=true`.
- **Uses:** `gDoVelocityClamp=true` (global assignment)
- **Reusable:** no

### udg_handle_target_click_selection
- **Does:** Handles target click selection by checking the mouse line collision, then either triggers zombie combat or zombie path generation based on collision type and object team.
- **Uses:** `click`, `getSceneInfo`, `IG3D_MOUSE_LINE`, `lineCollision`, `pick_highest_ranked_zombie`, `getObjectInfo`, `IG3D_POSITION`, `normalized`, `generateAStarPathBetweenPositions`, `run_on_path`, `udg_play_zombie_acknowledge_sound`, `sceneryTeam`, `doorTeam`, `windowTeam`
- **Reusable:** no

### deDollObjects
- **Does:** Is an empty function with no implementation.
- **Uses:** nothing
- **Reusable:** yes

## Part 3 of 3

### Top level
- **Does:** No function exists at the top level of this file; the code is entirely contained within the `handle_udg` function.
- **Uses:** nothing
- **Reusable:** no

### handle_udg
- **Does:** Handles UDG game loop logic: updates camera rotation from mouse delta, toggles ragdoll state for objects, computes normalized forward direction for movement, processes movement and camera controls via keys, clamps player velocity, updates camera position, sets scene mouse view and light settings, and triggers UDG utility display.
- **Uses:** `getSceneInfo`, `setCameraInfo`, `setObjectInfo`, `getObjectInfo`, `setSceneInfo`, `setLightInfo`, `key`, `loadLevel`, `gObjects`, `gDoVelocityClamp`, `gCameraSpeed`, `levelislit`, `playerBox`, `first`, `x`, `y`, `z`, `forw`, `a11`-`a44`, `gActivateStartSounds`, `currentText`, `normalized`, `vecLength`, `dark`, `lit`, `udg_display_FPS`
- **Reusable:** no
- **Procedural:** no
