<!-- Spark folder manifest of Data/Levels/iFly/iFly_Success (model spark-x2.6-4b, 2026-11-12 18:59). DRAFT. -->

# Data/Levels/iFly/iFly_Success
- **Role:** This folder holds the auto-generated level script for the iFly level, which loads the level's assets and scene settings, builds the level objects and text boxes, reads the player name from the level file, sets the briefing text, configures shadows, lights, and camera view, and defines the level's update logic including the land collision handler and the main loop waiting for load completion or a user click.
- **Entry point:** load script.lua
- **Files:** load script.lua - auto-generated level script for the iFly level that loads level assets and scene settings, builds level objects and text boxes, reads the player name, sets briefing text, configures shadows/lights/camera, defines update logic and the main loop.
- **Shared with other folders:** Needs assets from elsewhere under Data/ (e.g. Data/WTF/rollfield.wtf, Data/Images/..., Data/FontPngs/..., Data/Levels/iFly/iFly_name.txt, Data/Levels/iFly/iFly_Title) and engine globals such as gObjects, gTextboxes, gNumObjects, gNumParticleEmitters, gSoundEmitters, gNumSoundEmitters, gGroups, gNumGroups, gNumTextboxes, gParticleEmitters, gSoundEmitters, gGroups, gTextboxes, gObjects, and IG3D_* constants.
- **Procedure candidates:** The level's update logic (land collision handler and main loop) and the level-level global assignments (theLevel, loadtime, playerName, briefing) are defined by code in this script rather than stored as separate files.
- **Glossary:**
  - `loadLevel` - Switches the active level by loading the folder for the current game or demo.
  - `make` - Creates an iGame3D object from a file path or object kind.
  - `setObjectInfo` - Sets the position, rotation, velocity, omega, or force property of an object.
  - `setText_boxInfo` - Configures the text box used for in-game text display.
  - `setSceneInfo` - Configures the scene settings for the level.
  - `setLightInfo` - Configures the light settings for the level.
  - `loadMesh` - Loads a 3D model mesh asset.
  - `IG3D_*` constants - Engine property identifiers used to read or set object, scene, camera, light, and text box properties.
- **Verdict:** keep - This is the standard auto-generated level script for iGame3D and serves as a useful reference for adding new level scripts; it contains the level's core setup, update logic, and entry point.
