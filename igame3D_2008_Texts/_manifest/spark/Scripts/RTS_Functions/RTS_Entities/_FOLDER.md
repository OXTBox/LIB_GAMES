<!-- Spark folder manifest of Data/Scripts/RTS_Functions/RTS_Entities (model spark-x2.6-4b, 2026-11-12 14:36). DRAFT. -->

# Data/Scripts/RTS_Functions/RTS_Entities
- **Role:** This folder holds the reusable Lua libraries that define and configure the RTS game's entity types, including buildings, cars, doors, windows, guns, humans, zombies, teams, and the shared particle emitters for the game. It builds object tables by scanning the global object collection and applying engine property settings so the RTS game can be assembled from existing objects.
- **Entry point:** none
- **Files:**
  - RTS_BloodPencil.lua - library that loads blood pencil textures and applies a temporary texture to every material of every scene object to prepare for blood decal rendering.
  - RTS_Building.lua - library that scans all game objects, builds buildings and walls tables, and applies default physics and visual settings to each entry.
  - RTS_Car.lua - library that loads the RTS_Vehicles library and builds the cars table by scanning gObjects for car-like objects.
  - RTS_Door.lua - library that scans gObjects for door-named objects, configures them with gravity, mass, shadow settings and door state flags, and builds the doors table.
  - RTS_Emitters.lua - emitter-settings file that loads RTS particle emitters and reports missing required emitters to the user.
  - RTS_GUI.lua - library that assigns the first text box from gTextboxes to the RTS_console global.
  - RTS_Gun.lua - library that builds the shared guns table by scanning gObjects for gun objects, configures them, and assigns guns to humans without existing guns.
  - RTS_Human.lua - library that scans gObjects, matches human names, repositions matched objects to the ground, and records tracking light assignments for humans.
  - RTS_Teams.lua - library that defines global team identifier constants shared with the RTS entity code.
  - RTS_Window.lua - engine-core file that scans gObjects for window-named objects, applies default settings, builds the windows table, and prints the final window count.
  - RTS_Zombie.lua - library that defines the zombies table, loads zombie animation caches, and provides the getRandomAnimationOfStyle helper for selecting random zombie animations by style.
- **Shared with other folders:** It needs the engine globals gObjects, gDoShadows, gHumanNames, humans, gTrackingLights, gTrackingLight, gTextboxes, gGunEmitter, tireTraces, bloodParticles, bloodParticles2, muzzleFlash, unitMarkerFriendly, unitMarkerEnemy, doorsTeam, windowsTeam, master, gameroot, and engine calls such as getObjectInfo, setObjectInfo, setSound_emitterInfo, putObjectOnGround, computeShadowModelName, assign_free_sound_emitter, init_car, and loadTexture. Other folders take the built entity tables (buildings, walls, cars, doors, windows, guns, zombies) and the shared team identifiers from this folder.
- **Procedure candidates:** The buildings, doors, windows, and guns tables are produced by code that scans gObjects and applies default property settings to matched objects; the human tracking lists and zombie animation caches are built by scanning gObjects and applying configuration logic; the RTS_console global is assigned by code that selects the first text box from gTextboxes.
- **Glossary:**
  - gObjects - shared global table holding all game objects, scanned by these libraries to build entity tables.
  - getObjectInfo - engine call that reads property values from a game object.
  - setObjectInfo - engine call that writes property values to a game object.
  - setSound_emitterInfo - engine call that configures sound emitter properties on an object.
  - putObjectOnGround - engine call/helper that repositions an object to the ground.
  - computeShadowModelName - engine helper that computes the shadow model name for an object.
  - zombies - table holding zombie entity configuration and animation cache data.
  - getRandomAnimationOfStyle - function that selects a random animation name and linked flag from a style-specific animation table.
- **Verdict:** keep - The folder contains reusable library code that builds entity tables by scanning gObjects and applying engine property settings, which is directly reusable when assembling a new RTS game or engine.
