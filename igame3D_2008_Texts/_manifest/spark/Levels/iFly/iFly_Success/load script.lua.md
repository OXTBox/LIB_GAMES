<!-- Spark first-look of Data/Levels/iFly/iFly_Success/load script.lua (model spark-x2.6-4b, 2026-11-12 18:43). DRAFT for Claude to review. -->

## load script.lua
- **Kind:** level-script
- **Purpose:** This file is the auto-generated level script for the iFly level. It loads the level's assets and scene settings, builds the level objects and text boxes, reads the player name from the level file, sets the briefing text, and configures shadows, lights, and camera view. It also defines the level's update logic, including the land collision handler and the main loop that waits for load completion or a user click.
- **Depends on:** `loadMesh`, `loadTexture`, `loadFont`, `setCameraInfo`, `make`, `setObjectInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `getSceneInfo`, `io.open`, `gObjects`, `gTextboxes`, `gNumObjects`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gNumTextboxes`, `gParticleEmitters`, `gSoundEmitters`, `gGroups`, `gTextboxes`, `gObjects`, `IG3D_*` constants, `Data/` paths (`Data/WTF/rollfield.wtf`, `Data/Images/...`, `Data/FontPngs/...`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly_Title`), globals `theLevel`, `loadtime`, `playerName`, `briefing`, `land`, `loop`.
- **Provides:** `loop`, `land`, and the global assignments `game_func = loop`, `coll_o_m = land`; also the level-level globals `theLevel`, `loadtime`, `playerName`, `briefing`.
- **Assets it needs:** `Data/WTF/rollfield.wtf`, `Data/Images/...`, `Data/FontPngs/...`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly_Title`.
- **Procedural:** none
- **Glossary:**
  - `IG3D_*` constants - Engine property identifiers used to read or set object, scene, camera, light, and text box properties.
  - `loadLevel` - Switches the active level by loading the folder for the current game or demo.
  - `make` - Creates an iGame3D object from a file path or object kind.
  - `setObjectInfo` - Sets the position, rotation, velocity, omega, or force property of an object.
  - `setText_boxInfo` - Configures the text box used for in-game text display.
  - `setSceneInfo` - Configures the scene settings for the level.
  - `setLightInfo` - Configures the light settings for the level.
  - `loadMesh` - Loads a 3D model mesh asset.
- **Keep / port / drop:** keep - This is the standard auto-generated level script for iGame3D, so it is a useful reference for adding new level scripts.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Loads level assets and scene settings, builds the iFly level objects and text box, reads the player name from a level file, sets the briefing text, and configures shadows, lights and camera view.
- **Uses:** `loadMesh`, `loadTexture`, `loadFont`, `setCameraInfo`, `make`, `setObjectInfo`, `setText_boxInfo`, `setSceneInfo`, `setLightInfo`, `setText_boxInfo`, `getSceneInfo`, `io.open`, `gObjects`, `gTextboxes`, `gNumObjects`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gNumTextboxes`, `gParticleEmitters`, `gSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gObjects`, `IG3D_*` constants, `Data/` paths (`Data/WTF/rollfield.wtf`, `Data/Images/...`, `Data/FontPngs/...`, `Data/Levels/iFly/iFly_name.txt`, `Data/Levels/iFly/iFly_Title`), globals `theLevel`, `loadtime`, `playerName`, `briefing`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** Sets `coll_o_m` to `land` and assigns `game_func` to `loop` after the function definitions.
- **Uses:** `land` (defined above), `loop` (defined above)
- **Reusable:** no

### loop
- **Does:** Checks if the load time has passed and loads the current level, or waits for a click on "n" to set the load time.
- **Uses:** `loadtime`, `time()`, `click("n")`, `loadLevel(theLevel)`
- **Reusable:** no

### land
- **Does:** Reads the velocity of an object, sets its velocity and omega to zero, and sets a downward force on it.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_VELOCITY)`, `setObjectInfo(obj.cObj, IG3D_VELOCITY, 0,0,z)`, `setObjectInfo(obj.cObj, IG3D_OMEGA, 0,0,0)`, `setObjectInfo(obj.cObj, IG3D_FORCE, 0,-3,0)`
- **Reusable:** no

### land
- **Does:** Assigns the `land` function to the global `coll_o_m`.
- **Uses:** `land`
- **Reusable:** no
