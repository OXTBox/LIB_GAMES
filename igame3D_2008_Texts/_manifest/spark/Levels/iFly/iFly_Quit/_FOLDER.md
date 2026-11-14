<!-- Spark folder manifest of Data/Levels/iFly/iFly_Quit (model spark-x2.6-4b, 2026-11-12 18:42). DRAFT. -->

# Data/Levels/iFly/iFly_Quit
- **Role:** This folder is the level script directory for the iFly level in iGame3D. It contains the entry script that starts the level session and performs the quit action for the current iGame3D session.
- **Entry point:** load script.lua
- **Files:** load script.lua - level-script entry file for the iFly level, starting the level session and executing the quit behavior for the current session
- **Shared with other folders:** none; the script depends on nothing and provides no main functions or globals other files use.
- **Procedure candidates:** none; the script only executes the quit behavior for the current session and has no procedural code producing stored assets.
- **Glossary:** iGame3D session - the current running 3D game session managed by the engine; quit - the action of ending the current iGame3D session; level-script - the entry script for a level that starts the level session when the level is loaded
- **Verdict:** keep - it is the standard entry script for a level, useful as a reference for adding new level scripts.
