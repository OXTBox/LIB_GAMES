<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Game.lua (model spark-x2.6-4b, 2026-11-12 16:32). DRAFT for Claude to review. -->

## RTS_Game.lua
- **Kind:** engine-core
- **Purpose:** This file is the core game script for the RTS game in iGame3D, handling mouse click and selection logic, the RTS game loop, camera and light tracking, and keyboard-driven time and camera controls. It wires together engine calls, game state globals, and level-level behavior to drive the RTS gameplay.
- **Depends on:** `Data/` folder paths (e.g., `Data/Fluid/console/console.fl` referenced in commented code), `Scripts/RTS_Functions` sibling code, and globals set elsewhere such as `gObjects`, `gTrackingLights`, `gTrackedPosition`, `gZoomDistance`, `gLookAround`, `gInverseGameSpeed`, `gSelectionRect`, `gActivateStartSounds`, and engine constants like `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_TEXT`, `IG3D_FPS`, `IG3D_LOD_DISTANCE`, `IG3D_DRAWN_FACES`, `IG3D_WHEEL_DELTA`, `IG3D_ROTATION_MATRIX`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`.
- **Provides:** Globals `gLastClick`, `gDoubleClickInterval`, `gStatusString`; functions `handle_clicks`, `handle_RTS`, and top-level selection/setup logic for the RTS game (including click handling, time controls, tracking key actions, camera/light setup, and keyboard-driven camera and object position adjustments).
- **Assets it needs:** none named as required assets (no models, images, sounds, emitters, or fonts are explicitly listed as needed by this file).
- **Procedural:** none (the file configures and drives existing game objects, camera, lights, and selection state; it does not generate assets from numbers or rules).
- **Glossary:**
  - `handle_clicks` - Function that processes mouse clicks, manages double-click detection, and handles drag-based object movement and line collision.
  - `handle_RTS` - Function that drives the RTS game loop, updating console text, scene settings, health, AI, and team selection.
  - `gTrackingLights` - Global tracking state for lights used during camera/object tracking.
  - `gTrackedPosition` - Global tracking state for the position of the tracked object.
  - `gZoomDistance` - Global tracking state for the zoom distance of the camera.
  - `gLookAround` - Global tracking state for camera rotation.
  - `gInverseGameSpeed` - Global tracking state for the inverse game speed used in camera/object updates.
  - `setSelectionRect` - Engine call used to update the selection rectangle state.
- **Keep / port / drop:** keep - This is the core game script for the RTS engine, containing reusable click, selection, loop, and camera logic that other game files rely on.

---

# Part notes

## Part 1 of 8

### Top level
- **Does:** Defines three global variables at the top of the file: `gLastClick`, `gDoubleClickInterval`, and `gStatusString`.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 2 of 8

### Top level
- **Does:** No top-level code outside the `handle_clicks` function.
- **Uses:** nothing
- **Reusable:** no

### handle_clicks
- **Does:** Handles mouse clicks by managing double-click detection, resetting object selection state, computing line collision with the mouse, and moving selected objects along the mouse line when no object is hit.
- **Uses:** `gDraggingSelRect`, `handle_selection_box`, `click`, `gLastClick`, `time`, `gDoubleClickInterval`, `getSceneInfo`, `IG3D_SPEED`, `gObjects`, `stepOutOfCar`, `lineCollision`, `getSceneInfo`, `IG3D_MOUSE_LINE`, `somethingSelected`, `getObjectInfo`, `IG3D_POSITION`, `setObjectInfo`, `generateAStarPathBetweenPositions`, `run_on_path`, `gTrackingLights`, `lightN`, `setLightInfo`, `IG3D_ROTATION`, `gTeamSelect`, `gDraggingSelRect`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 8

### Top level
- **Does:** Contains the top-level selection-handling logic that decides whether a selection box is active, and otherwise updates selected objects based on the selected object's team, vehicle, house, or gun type.
- **Uses:** `boxPopUp`, `key`, `unselectAllObjects`, `handle_selection_box`, `gTeamSelect`, `gObjects`, `getObjectInfo`, `setObjectInfo`, `generateAStarPathBetweenPositions`, `gTrackingLights`, `IG3D_POSITION`, `lx`, `ly`, `lz`, `o.team`, `o.isVehicle`, `o.house`, `o.isGun`, `o.selected`, `o.cObj`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 8

### Top level
- **Does:** Ends a block, then clears the selection rectangle and drag state when the "-" click is not handled.
- **Uses:** `click`, `gSelectionRect`, `gDraggingSelRect`
- **Reusable:** no

## Part 5 of 8

### Top level
- **Does:** Contains no top-level code outside the `handle_RTS` function; the file begins directly with the function definition.
- **Uses:** nothing
- **Reusable:** no

### handle_RTS
- **Does:** Drives the RTS game loop, updating console text, scene LOD settings, printing debug and scene info, handling timed sense calculations, object highlighting, weapon and vehicle actions, health checks, team selection toggles, and object AI processing.
- **Uses:** `setText_boxInfo`, `getSceneInfo`, `setSceneInfo`, `RTS_print`, `gStatusString`, `gObjects`, `getObjectInfo`, `task_to_string`, `time`, `key`, `gSensesTime`, `gSensesInterval`, `buildDistancesTable`, `hiliteMarkedObjects`, `rightHandedPistols`, `play_car_sounds`, `handle_health`, `handle_ai`, `gTrackLightEnabled`, `gTeamSelect`, `tabThroughObjects`, `unselectAllObjects`, `RTS_console`, `IG3D_TEXT`, `IG3D_FPS`, `IG3D_LOD_DISTANCE`, `IG3D_DRAWN_FACES`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 8

### Top level
- **Does:** Contains top-level setup and control logic for the RTS game, including freeze and reanimate handling for game objects, keyboard time controls, click handling, and tracking key actions.
- **Uses:** `gObjects`, `time()`, `setObjectInfo`, `IG3D_RAGDOLL`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`, `IG3D_LINK_MAIN_BONE_TO_VELOCITY`, `IG3D_POSITION`, `gTrackedPosition`, `gTrackingLights`, `gTrackedObject`, `gTeamSelect`, `handle_ai`, `handle_clicks`, `unselectAllObjects`, `tabThroughObjects`, `bulletTimeKey`, `stopTimeKey`, `key`, `trackLightsKey`, `rts_play_zombie_ambient_sound`, `zombie_behaviour`, `zombie_reanimate_behaviour`.
- **Reusable:** no
- **Procedural:** no

## Part 7 of 8

### Top level
- **Does:** Sets up tracked light and camera tracking state, then handles keyboard input to adjust zoom distance, camera rotation, and tracked object position.
- **Uses:** `gTrackingLights`, `gObjects`, `gTrackedObject`, `gZoomDistance`, `gLookAround`, `gInverseGameSpeed`, `gTrackedPosition`, `getSceneInfo`, `getCameraInfo`, `getObjectInfo`, `key`, `passed`, `normalized`, `math.max`, `math.min`, `IG3D_WHEEL_DELTA`, `IG3D_ROTATION_MATRIX`, `trackLightsKey`, `tx`, `ty`, `tz`, `a11`-`a44`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 8

### Top level
- **Does:** Contains top-level setup code for the RTS game camera and scene state update, including camera position and rotation calculation, light configuration, and selection rectangle updates.
- **Uses:** Engine calls `getCameraInfo`, `setCameraInfo`, `getSceneInfo`, `setLightInfo`, `setSelectionRect`, `fltk_update`; globals `gTrackedPosition`, `gLookAround`, `gZoomDistance`, `gInverseGameSpeed`, `gActivateStartSounds`, `gSelectionRect`, `a31`, `a32`, `a33`, `a11`, `a12`, `a13`, `rtd`, `mx`, `my`, `mz`, `x2`, `y2`, `z2`, `x3`, `y3`, `z3`, `dx`, `dy`, `dz`, `ds`, `t`, `dirToAngles`, `vecLength`, `normalized`, `passed`, `math`; file path `Data/Fluid/console/console.fl` referenced in commented-out code.
- **Reusable:** no
- **Procedural:** no
