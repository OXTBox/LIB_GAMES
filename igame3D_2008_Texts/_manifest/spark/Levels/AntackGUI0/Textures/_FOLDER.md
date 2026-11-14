<!-- Spark folder manifest of Data/Levels/AntackGUI0/Textures (model spark-x2.6-4b, 2026-11-12 18:31). DRAFT. -->

# Data/Levels/AntackGUI0/Textures
- **Role:** This folder holds the texture assets for the AntackGUI0 level, providing image resources used by the game's GUI rendering.
- **Entry point:** none
- **Files:** GUI00.png - texture image asset for the AntackGUI0 GUI; GUI01.png - texture image asset for the AntackGUI0 GUI
- **Shared with other folders:** Needs textures referenced by the GUI scripts and level code in Data/Levels/AntackGUI0; other folders in the engine take GUI textures from this folder as needed for rendering.
- **Procedure candidates:** none
- **Glossary:**
  - GUI - graphical user interface element for the game
  - Texture - image asset used for rendering in the game
  - AntackGUI0 - game or demo level folder
  - Level - a folder containing game or demo content, loaded via loadLevel
  - Data - folder containing all engine and game data files
- **Verdict:** keep - The folder contains only static texture image assets required by the AntackGUI0 GUI, which are necessary for the level's rendering and should be retained in the port.
