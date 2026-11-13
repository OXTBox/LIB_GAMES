<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Human.lua (model spark-x2.6-4b, 2026-11-12 14:35). DRAFT for Claude to review. -->

## RTS_Human.lua
- **Kind:** library
- **Purpose:** Builds the human tracking lists by scanning objects in `gObjects`, matching their names against the predefined human name list, repositioning matched objects to the ground, and recording tracking light assignments for the game.
- **Depends on:** `gObjects`, `gHumanNames`, `humans`, `gTrackingLights`, `gTrackingLight` globals set elsewhere; helper function `putObjectOnGround`; engine calls (`getObjectInfo`); `Data/` folder structure.
- **Provides:** The human tracking list construction logic (scanning `gObjects`, name matching, ground repositioning, tracking light recording) used by other scripts.
- **Assets it needs:** none named (no models, images, sounds, emitters, or fonts referenced in this section).
- **Procedural:** none
- **Glossary:**
  - `gObjects` - Global table of all objects in the game, scanned to find human entities.
  - `gHumanNames` - Predefined list of names used to identify human objects.
  - `gTrackingLights` - Global collection of tracking lights assigned to human objects.
  - `getObjectInfo` - Engine call that reads object properties such as position.
  - `putObjectOnGround` - Helper function that repositions an object to the ground.
- **Keep / port / drop:** keep - It is a reusable library logic for building human tracking lists in the engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds the human tracking lists by scanning objects in `gObjects`, matching their names against the predefined human name list, repositioning matched objects to the ground, and recording tracking light assignments.
- **Uses:** Engine calls (`getObjectInfo`), globals (`gObjects`, `gHumanNames`, `humans`, `gTrackingLights`, `gTrackingLight`), helper functions (`putObjectOnGround`), and `Data/` paths (none directly referenced in this section).
- **Reusable:** no
- **Procedural:** no
