<!-- Spark folder manifest of Data/Levels/iFly/iFly_Briefing (model spark-x2.6-4b, 2026-11-12 18:34). DRAFT. -->

# Data/Levels/iFly/iFly_Briefing
- **Role:** This folder holds the startup script for the iFly level, which initializes mesh and texture assets, configures camera and scene settings, creates avatar and text box objects, sets the briefing text, and loads the iFly level directory. It also provides the game loop that runs during gameplay, handling level loading when the load time is reached and updating the force object on the n key.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script that starts the iFly level by loading assets, configuring settings, creating objects, setting the briefing text, and loading the level directory, plus the loop function that runs the game runtime.
- **Shared with other folders:** It needs `Data/WTF/street/rollfield.wtf`, `Data/Images/Street/rollfield.png`, `Data/Images/Foliage/grass.png`, `Data/Images/Vehicles/drewjetfighter.png`, `Data/FontPngs/default32_1.png`, `Data/FontPngs/default32_2.png`, `Data/Levels/iFly/iFly_name.txt`, and `Data/Levels/iFly/iFly` from elsewhere. It provides the level startup and game loop code that other level folders reuse.
- **Procedure candidates:** none
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
  - `loadtime` - The time value used to gate level loading in the loop.
  - `n` - The key that triggers the force object update in the loop.
- **Verdict:** keep - it is the standard level startup script for iFly, showing how assets, objects, and the game loop are configured, and it provides reusable startup and loop code for the level.
