<!-- Spark first-look of Data/Levels/iFly/iFly_EnterName/load script.lua (model spark-x2.6-4b, 2026-11-12 18:37). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file is the entry script for the iFly level. It sets up the level's global state, initializes the scene, camera, light, and text box configuration, then starts the name entry prompt by entering the game loop.
- **Depends on:** `loadLevel("Data/Levels/iFly/iFly_EnterName")` (level loading), `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png` (font paths), engine calls `loadTexture`, `loadFont`, `setCameraInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `make`, `getObjectInfo`-style info setters, globals `gObjects`, `gNumObjects`, `gParticleEmitters`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gNumTextboxes`, `IG3D_*` constants, and `time()`.
- **Provides:** The `loop` function, which handles the iFly text box input, edits the text string, writes the updated text to a level file, loads the next level, and manages the insertion mark and timer; the game function `loop` is set as the active game function for the level.
- **Assets it needs:** Fonts: `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`.
- **Procedural:** none
- **Glossary:**
  - `IG3D_*` - iGame3D engine constants that name the property being read or set in object/scene/camera/light/text box calls.
  - `loadLevel` - switches the active level by loading a folder path.
  - `gTextboxes` - global list of text boxes used by the level's input handling.
  - `insmark` - insertion mark used to track text editing position.
  - `tim` - timer used to manage the name entry prompt timing.
  - `game_func` - global setting the active game function for the level.
  - `loop` - the game function that runs the level's main update logic.
- **Keep / port / drop:** keep - serves as the reference entry script for iFly level setup and text box input handling.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets up the iFly level's global state and initial scene, camera, light and text box configuration, then starts the name entry prompt.
- **Uses:** Engine calls `loadTexture`, `loadFont`, `setCameraInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `make`, `getObjectInfo`-style info setters, globals `gObjects`, `gNumObjects`, `gParticleEmitters`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gNumTextboxes`, `IG3D_*` constants, and `time()`. Files/paths read: `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Sets the game function to `loop` and contains the top-level setup lines for the file.
- **Uses:** `gTextboxes`, `IG3D_TEXT`, `IG3D_ROOT`, `input`, `getSceneInfo`, `io.open`, `loadLevel`, `beep`, `time`, `str`, `insmark`, `tim`, `game_func`, `loop`
- **Reusable:** no

### loop
- **Does:** Handles the iFly text box input, edits the text string, writes the updated text to a level file, loads the next level, and manages the insertion mark and timer.
- **Uses:** `gTextboxes`, `IG3D_TEXT`, `IG3D_ROOT`, `input`, `getSceneInfo`, `io.open`, `loadLevel`, `beep`, `time`, `str`, `insmark`, `tim`, `game_func`, `loop`
- **Reusable:** no
- **Procedural:** no
