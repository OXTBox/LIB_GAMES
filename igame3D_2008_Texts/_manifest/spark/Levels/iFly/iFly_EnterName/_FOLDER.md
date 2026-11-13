<!-- Spark folder manifest of Data/Levels/iFly/iFly_EnterName (model spark-x2.6-4b, 2026-11-12 18:38). DRAFT. -->

# Data/Levels/iFly/iFly_EnterName
- **Role:** This folder is the entry script for the iFly level, which sets up the level's global state, initializes the scene, camera, light, and text box configuration, then starts the name entry prompt by entering the game loop.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script entry file for the iFly level that sets up level state, initializes scene/camera/light/text box configuration, and starts the name entry prompt via the game loop.
- **Shared with other folders:** Needs the font assets `Data/FontPngs/default32_1.png` and `Data/FontPngs/default32_2.png`, and uses engine-level globals (`gObjects`, `gNumObjects`, `gParticleEmitters`, `gNumParticleEmitters`, `gSoundEmitters`, `gNumSoundEmitters`, `gGroups`, `gNumGroups`, `gTextboxes`, `gNumTextboxes`), engine constants (`IG3D_*`), and the `loadLevel` function to switch levels.
- **Procedure candidates:** The `loop` function, which handles the iFly text box input, edits the text string, writes the updated text to a level file, loads the next level, and manages the insertion mark and timer; the game function `loop` is set as the active game function for the level.
- **Glossary:**
  - `loadLevel` - switches the active level by loading a folder path.
  - `gTextboxes` - global list of text boxes used by the level's input handling.
  - `insmark` - insertion mark used to track text editing position.
  - `tim` - timer used to manage the name entry prompt timing.
  - `game_func` - global setting the active game function for the level.
  - `loop` - the game function that runs the level's main update logic.
  - `loadTexture` - engine call used to load textures referenced by the level.
  - `loadFont` - engine call used to load fonts referenced by the level.
  - `setCameraInfo` - engine call used to set camera configuration for the level.
  - `setText_boxInfo` - engine call used to set text box configuration for the level.
  - `setSceneInfo` - engine call used to set scene configuration for the level.
  - `setLightInfo` - engine call used to set light configuration for the level.
- **Verdict:** keep - serves as the reference entry script for iFly level setup and text box input handling, with no missing or unverifiable components.
