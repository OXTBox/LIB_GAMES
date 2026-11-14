<!-- Spark first-look of Data/Levels/iFly/iFly_Briefing/load script.lua (model spark-x2.6-4b, 2026-11-12 18:33). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file starts the iFly level by loading mesh and texture assets, configuring camera and scene settings, creating avatar and text box objects, setting the briefing text, and loading the iFly level directory. Its loop section drives the game runtime, loading the current level when the load time is reached and handling the force object update on the n key.
- **Depends on:** `loop`, `loadtime`, `time`, `loadLevel`, `theLevel`, `click`, `setObjectInfo`, `gObjects`, `IG3D_FORCE`; `Data/` paths `Data/WTF/street/rollfield.wtf`, `Data/Images/Street/rollfield.png`, `Data/Images/Foliage/grass.png`, `Data/Images/Vehicles/drewjetfighter.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/FontPngs/default32_1.png`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly`; engine calls `loadMesh`, `loadTexture`, `loadFont`, `setCameraInfo`, `make`, `setObjectInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `getSceneInfo`, `setLightInfo`, `loadLevel`; globals `gObjects`, `gNumObjects`, `gParticleEmitters`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gNumTextboxes`, `gTextboxes[1]`, `gObjects[1].cObj`, `gObjects[2].cObj`; constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_NAME`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`, `IG3D_CAST_SHADOW`, `IG3D_ROOT`, `IG3D_MOUSE_VIEW`, `IG3D_RECEIVE_SHADOW`, `IG3D_FORCE`; file `io.open`; string `briefing`; variables `playerName`, `theLevel`, `loadtime`.
- **Provides:** The top-level level initialization code and the `loop` function that runs the game loop, handling level loading and the n-key force update; no other globals are defined by this file.
- **Assets it needs:** `Data/WTF/street/rollfield.wtf`, `Data/Images/Street/rollfield.png`, `Data/Images/Foliage/grass.png`, `Data/Images/Vehicles/drewjetfighter.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly`.
- **Procedural:** none
- **Glossary:**
  - `loadMesh` - Engine call that loads a mesh asset into the game.
  - `loadTexture` - Engine call that loads a texture image into the game.
  - `loadFont` - Engine call that loads a font asset into the game.
  - `setObjectInfo` - Engine call that sets properties on an object, such as position or rotation.
  - `setText_boxInfo` - Engine call that sets properties on a text box object.
  - `setSceneInfo` - Engine call that sets properties on the scene.
  - `setLightInfo` - Engine call that sets properties on a light.
  - `loadLevel` - Engine call that switches the active level.
  - `loop` - The game loop function that runs repeatedly during gameplay.
  - `n` - The key that triggers the force object update in the loop.
  - `loadtime` - The time value used to gate level loading in the loop.
- **Keep / port / drop:** keep - it is the standard level startup script for iFly, showing how assets, objects, and the game loop are configured.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Starts the iFly level by loading mesh and texture assets, configuring camera and scene settings, creating two avatar objects and one text box, setting the briefing text, and loading the iFly level directory.
- **Uses:** Engine calls `loadMesh`, `loadTexture`, `loadFont`, `setCameraInfo`, `make`, `setObjectInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `getSceneInfo`, `setText_boxInfo`, `loadLevel`; globals `gObjects`, `gNumObjects`, `gParticleEmitters`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gNumTextboxes`, `gTextboxes[1]`, `gObjects[1].cObj`, `gObjects[2].cObj`; `Data/` paths `Data/WTF/street/rollfield.wtf`, `Data/Images/Street/rollfield.png`, `Data/Images/Foliage/grass.png`, `Data/Images/Vehicles/drewjetfighter.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/FontPngs/default32_1.png`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly`; constants `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_NAME`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_TINT_COLOR`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `IG3D_FOV`, `IG3D_ENABLED`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `IG3D_SPOTLIGHT`, `IG3D_CAST_SHADOW`, `IG3D_ROOT`, `IG3D_MOUSE_VIEW`, `IG3D_RECEIVE_SHADOW`; file `io.open`; string `briefing`; variables `playerName`, `theLevel`, `loadtime`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Sets `game_func` to `loop` and contains the top-level code for the script.
- **Uses:** `loop`, `loadtime`, `time`, `loadLevel`, `theLevel`, `click`, `setObjectInfo`, `gObjects`, `IG3D_FORCE`.
- **Reusable:** no

### loop
- **Does:** Runs when the game loop executes. If `loadtime` is non-zero and `time()` reaches or exceeds `loadtime`, it loads the current level. Otherwise, if the `n` key is clicked, it sets `loadtime` to `time()+2` and sets the force object's position to `0,0,2`.
- **Uses:** `loadtime`, `time`, `loadLevel`, `theLevel`, `click`, `setObjectInfo`, `gObjects`, `IG3D_FORCE`.
- **Reusable:** no
- **Procedural:** no
