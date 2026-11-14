<!-- Spark folder manifest of Data/Scripts/iFly_Functions (model spark-x2.6-4b, 2026-11-12 18:13). DRAFT. -->

# Data/Scripts/iFly_Functions
- **Role:** This folder holds the reusable Lua libraries and level scripts that drive the iFly game session, covering AI behavior, math helpers, plane controls, and game initialization.
- **Entry point:** iFly_Init.lua
- **Files:**
  - iFly_AI.lua - library containing iFly_AI game logic for enemy and friend initialization, movement, shooting, power-up pickup, camera positioning, and cloud particle emitter generation
  - iFly_Game.lua - level-script serving as the main script for the iFly game session, starting the game, loading the iFly title level, configuring scene and sound settings, and running the game loop with ship control, enemy and friendly AI, and particle/sound emitter updates
  - iFly_Init.lua - engine-core file initializing the iFly game by loading math and plane libraries, reading control and option files, setting global shadow, cloud, and mouse state, and running the full iFly startup sequence including object setup, sound emitter configuration, cloud generation, and camera/plane initialization
  - iFly_math.lua - library providing math helper functions for vector and angle utility calculations used by other scripts, defining the global SMALL_NUM constant alongside the helpers
  - iFly_plane.lua - library providing reusable plane-related functions for the iGame3D engine, including plane orientation and control state initialization, plane rotation and throttle computation, and plane physics application to plane objects
- **Shared with other folders:** The scripts depend on the iGame3D engine core (Data folder paths, dofile loading, engine object calls, global state such as gObjects) and on the math and plane libraries within this folder for 3D calculations and plane behavior. Other folders take the game logic, math helpers, and plane functions from here to drive their own sessions.
- **Procedure candidates:** iFly_Init.lua performs the full iFly startup sequence (object setup, sound emitter configuration, cloud generation, camera/plane initialization) as code; iFly_Game.lua runs the game loop with ship control, enemy and friendly AI, and particle/sound emitter updates as code.
- **Glossary:**
  - iFly_AI - game logic library for enemy and friend initialization, movement, shooting, power-up pickup, camera positioning, and cloud particle emitter generation
  - iFly_Game - main script for the iFly game session that starts the game, loads the title level, configures scene and sound settings, and runs the game loop
  - iFly_Init - engine-core file that initializes the iFly game startup sequence including object setup, sound emitter configuration, cloud generation, and camera/plane initialization
  - iFly_math - math helper library providing vector and angle utility functions and the global SMALL_NUM constant
  - iFly_plane - library providing reusable plane-related functions for plane orientation, control state, rotation, throttle, and physics
- **Verdict:** keep - The files contain distinct, reusable game logic and library code for the iFly session that directly supports engine-level behavior and game flow, with clear entry point and shared dependencies that fit the engine structure.
