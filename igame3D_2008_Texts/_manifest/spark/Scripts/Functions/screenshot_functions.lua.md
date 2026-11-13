<!-- Spark first-look of Data/Scripts/Functions/screenshot_functions.lua (model spark-x2.6-4b, 2026-11-12 15:31). DRAFT for Claude to review. -->

## screenshot_functions.lua
- **Kind:** exporter
- **Purpose:** This file provides a function for saving the current game screen as a PNG image file. It generates a filename that includes a timestamp to keep saved screens uniquely identifiable. The function is intended for exporting the current screen state to a file on the system.
- **Depends on:** `gameroot` (shared global), `ig3d_GetLevelName__s` (engine call for level name), `os.time` (host Lua standard library call), `ig3d_SaveScreenshot_s2bi` (engine call for saving screenshots)
- **Provides:** `save_screenshot` (the function that saves the current screen as a timestamped PNG file)
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or required by this file)
- **Procedural:** yes (generates a timestamped PNG filename based on the current time and level name rather than loading a pre-existing file)
- **Glossary:**
  - `ig3d_GetLevelName__s` - engine call that retrieves the name of the current game level
  - `ig3d_SaveScreenshot_s2bi` - engine call that saves the current screen as a screenshot file
  - `gameroot` - shared global used to build file paths for the game
- **Keep / port / drop:** keep (useful reference for implementing screenshot export in a new engine)

---

# Part notes

## Part 1 of 1

### save_screenshot
- **Does:** Saves the current screen as a PNG file with a timestamped name.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s`, `os.time`, `ig3d_SaveScreenshot_s2bi`
- **Reusable:** yes
- **Procedural:** no
