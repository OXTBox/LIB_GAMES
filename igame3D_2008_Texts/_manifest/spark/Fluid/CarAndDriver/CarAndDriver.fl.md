<!-- Spark first-look of Data/Fluid/CarAndDriver/CarAndDriver.fl (model spark-x2.6-4b, 2026-11-12 20:25). DRAFT for Claude to review. -->

## CarAndDriver.fl
- **Kind:** ui-dialog
- **Purpose:** This file defines the FLTK user interface for the CarAndDriver level, including the RNDRTS_Maker window with its input fields, buttons and callbacks, plus the level-building and auto-script generation functions used to configure and save the level. It drives the level's entity creation, object info collection and auto-script output through the Fluid UI designer structure.
- **Depends on:** `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `PlayBtn:hide()`, `gObjects`, `gSoundFiles`, `gFontFiles`, `gameroot`, `Data/` paths referenced inside the script sections, `RNDRTSLoadScript`, `RNDRTSLoadScriptOut`, `LevelNameFld`, `AutoLevelName`, `updateTotal`, `saveLoadScript`, `playRNDRTS`, `randomizeit`, `RNDRTSMakerLevel`, `ig3d_CreateDirectory_s`, `io.open`, `Fl:event_key`, `ig3d_GetLevelName__s`, `loadLevel`, `math.randomseed`, `math.random`, `math.random(1,20)`, `table.insert`, `table.remove`, `dofile`, `make`, `setObjectInfo`, `setCameraInfo`, `setSceneInfo`, `setLightInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `setText_boxInfo`, `loadSound`, `loadFont`, `loadLevel`, `RNDRTS_Maker:redraw()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_Maker:make_current()`, `RNDRTS_Maker:show()`, `RNDRTS_M

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 8

### Top level
- **Does:** Defines the FLTK user interface file for the Fluid folder, setting its version, header name and code name metadata.
- **Uses:** nothing
- **Reusable:** no

## Part 2 of 8

### Top level
- **Does:** Defines the top-level constants, object name lists, position/rotation tables, and the `RNDRTSLoadScript` array that holds the five staged autoscript sections for the CarAndDriver level.
- **Uses:** `math.randomseed`, `math.random`, `print`, `table.insert`, `dofile` (via the script array), `make`, `setObjectInfo`, `setCameraInfo`, `loadSound`, `loadFont`, `setSceneInfo`, `setLightInfo`, `setParticle_emitterInfo`, `setSound_emitterInfo`, `setText_boxInfo`, `loadLevel` (not present in this code), `gObjects`, `gSoundFiles`, `gFontFiles`, `gameroot`, `RNDRTSLoadScript`, `RNDRTSLoadScript[1]` through `RNDRTSLoadScript[5]`, and the `Data/` paths referenced inside the script sections.
- **Reusable:** no

### make_window
- **Does:** Defines the `make_window` function with an empty body, containing only the function header and opening brace.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 8

### Top level
- **Does:** Contains the trailing comment about creating houses first to clear housePos tables, with no functions defined in this section.
- **Uses:** nothing
- **Reusable:** no

### AutoLevelName
- **Does:** Builds a level name from the selected building, human, gun, car and enemy counts, updates the level name field and redraws the renderer, then returns the generated name.
- **Uses:** `BuildingsFld`, `HumansFld`, `GunsFld`, `CarsFld`, `EnemyFld` field value calls; `LevelNameFld` field value call; `RNDRTS_Maker:redraw()`; global `levelName`
- **Reusable:** yes

### updateTotal
- **Does:** Sums the selected building, human, gun, car and enemy counts, writes the total into the total field, and ends the function.
- **Uses:** `BuildingsFld`, `HumansFld`, `GunsFld`, `CarsFld`, `EnemyFld` field value calls; `TotalFld` field value call
- **Reusable:** yes

### randomizeit
- **Does:** Generates random counts for each category, writes them into the corresponding fields, builds the level name with a `_RTS` suffix, updates the level name field, calls updateTotal, hides the play button, and ends the function.
- **Uses:** `BuildingsFld`, `HumansFld`, `GunsFld`, `CarsFld`, `EnemyFld` field value calls; `LevelNameFld` field value call; `updateTotal()`; `PlayBtn:hide()`; `math.random(1,20)`; global `levelName`
- **Reusable:** yes

### Top level
- **Does:** Contains the trailing comment about creating houses first to clear housePos tables, with no functions defined in this section.
- **Uses:** nothing
- **Reusable:** no

## Part 4 of 8

### createBuildings
- **Does:** Generates building and wall entities for the configured number of buildings, placing them at random positions and assigning random wall types.
- **Uses:** `BuildingsFld`, `RTS_Buildings`, `housePos`, `zObjectWTFs`, `zObjectNames`, `zObjectColls`, `zObjectPositions`, `RTS_WallsWide`, `RTS_WallsLong`, `math.random`, `table.insert`, `table.remove`
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the trailing code block that generates entity spaces from the remaining empty housePos values.
- **Uses:** `housePos`
- **Reusable:** no

## Part 5 of 8

### Top level
- **Does:** Contains the file-level setup and widget/code blocks for the CarAndDriver FLUID interface, including the continuation of earlier parts.
- **Uses:** `code {...}` blocks, `callback {...}`/`callback name` blocks, `Fl_Window`, `Fl_Button` widget definitions, and the function definitions EntityLocations, setEntityPos, createEnemy, createEntities.
- **Reusable:** no

### EntityLocations
- **Does:** Generates a list of entity positions by iterating over a defined housePos table and expanding each position into a grid of candidate coordinates, storing them in entityPos.
- **Uses:** `housePos`, `entityPos` (table globals), `table.insert`.
- **Reusable:** no

### setEntityPos
- **Does:** Picks a random unused entity position, removes it from entityPos, and inserts a new position into zObjectPositions for the entity, returning the x and z coordinates.
- **Uses:** `math.random`, `entityPos`, `zObjectPositions`, `table.remove`, `table.insert`.
- **Reusable:** yes

### createEnemy
- **Does:** Generates the specified number of enemies by selecting random enemy types, creating corresponding WTF model paths and names, and adding them to the shared object tables.
- **Uses:** `EnemyFld:value()`, `maxEnemy`, `numEnemy`, `math.random`, `RTS_Enemy`, `zObjectWTFs`, `zObjectNames`, `zObjectColls`, `table.insert`.
- **Reusable:** yes

### createEntities
- **Does:** Generates the specified numbers of humans, guns, and cars by selecting random character/weapon/vehicle types, creating corresponding WTF model paths and names, and adding them to the shared object tables.
- **Uses:** `HumansFld:value()`, `maxHumans`, `CarsFld:value()`, `maxCars`, `GunsFld:value()`, `maxGuns`, `math.random`, `RTS_Humans`, `RTS_Weapons`, `RTS_Cars`, `zObjectWTFs`, `zObjectNames`, `zObjectColls`, `setEntityPos`, `numcars`, `table.insert`.
- **Reusable:** yes

## Part 6 of 8

### Top level
- **Does:** Defines the `getAllObjectInfo` function and includes a `selected` block plus a `-- saveLoadScript` comment; no other top-level setup, globals or widget definitions appear in this code.
- **Uses:** nothing
- **Reusable:** no

### getAllObjectInfo
- **Does:** Iterates over `zObjectWTFs` using `zObjectPositions`, `zObjectNames`, `zObjectColls`, building comma-separated string arrays for object names, positions, rotations, sizes, colls and HUD flags, then returns the assembled `objectInfoOut` string.
- **Uses:** `zObjectWTFs`, `zObjectPositions`, `zObjectNames`, `zObjectColls`, `objectInfoOut`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 8

### Top level
- **Does:** Contains no setup, globals, widget definitions, or other top-level code outside the two functions `saveLoadScript` and `playRNDRTS`; the file consists solely of these two functions.
- **Uses:** `math.randomseed`, `createBuildings`, `EntityLocations`, `createEntities`, `createEnemy`, `setEntityPos`, `getAllObjectInfo`, `RNDRTSLoadScript`, `RNDRTSLoadScriptOut`, `LevelNameFld`, `AutoLevelName`, `LevelNameFld:value()`, `LevelNameFld:add`, `ig3d_CreateDirectory_s`, `gameroot`, `io.open`, `PlayBtn`, `Fl:event_key`, `ig3d_GetLevelName__s`, `loadLevel`, `RNDRTSMakerLevel`, `LevelNameFld:value()`
- **Reusable:** no
- **Procedural:** no

### saveLoadScript
- **Does:** Generates and writes an auto-script file for a level, then updates the level name field if the current level name is too short. It seeds the random number generator, builds level content, collects object info, assembles the script output, creates the level folder if needed, and writes the script file.
- **Uses:** `math.randomseed(os.time())`, `createBuildings()`, `EntityLocations()`, `createEntities()`, `createEnemy()`, `setEntityPos()`, `getAllObjectInfo()`, `RNDRTSLoadScript`, `RNDRTSLoadScriptOut`, `LevelNameFld:value()`, `LevelNameFld:add()`, `AutoLevelName()`, `ig3d_CreateDirectory_s(gameroot.."Data/Levels/"..levelName)`, `gameroot`, `io.open(levelFile, "w")`, `PlayBtn:show()`
- **Reusable:** no
- **Procedural:** yes - it generates and writes a level auto-script file based on level content and collected object info.

### playRNDRTS
- **Does:** Loads the level matching the configured level name field, skipping execution if the space key is pressed, and returns early if the level name does not match the expected maker level.
- **Uses:** `Fl:event_key()`, `ig3d_GetLevelName__s()`, `loadLevel(RNDRTSMakerLevel)`, `LevelNameFld:value()`, `RNDRTSMakerLevel`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 8

### Top level
- **Does:** Defines the RNDRTS_Maker window and its widgets, then runs setup code that shows the maker, hides PlayBtn, and makes it the current maker.
- **Uses:** `Fl_Window`, `Fl_Value_Input`, `Fl_Input`, `Fl_Value_Output`, `Fl_Button` widget definitions; `RNDRTS_Maker:show()`, `PlayBtn:hide()`, `RNDRTS_Maker:make_current()` calls; `updateTotal`, `saveLoadScript`, `playRNDRTS`, `randomizeit`, `AutoLevelName` callback names.
- **Reusable:** no

### RNDRTS_Maker
- **Does:** Creates the RNDRTS_Maker window with a Double-when-visible label, and defines the input fields, output field, buttons and their callbacks for building and saving level scripts.
- **Uses:** `Fl_Window RNDRTS_Maker`, `Fl_Value_Input`, `Fl_Input`, `Fl_Value_Output`, `Fl_Button` widget definitions; `updateTotal`, `saveLoadScript`, `playRNDRTS`, `randomizeit`, `AutoLevelName` callback names; `RNDRTS_Maker` widget name.
- **Reusable:** no

### updateTotal
- **Does:** Updates the total value shown in the Total output field when the building, human, gun, car, or enemy input fields change.
- **Uses:** `updateTotal` callback name; `TotalFld` widget reference.
- **Reusable:** no

### saveLoadScript
- **Does:** Handles the Save button click to save the current level script.
- **Uses:** `saveLoadScript` callback name; `SaveBtn` widget reference.
- **Reusable:** no

### playRNDRTS
- **Does:** Handles the Play button click to play the current level.
- **Uses:** `playRNDRTS` callback name; `PlayBtn` widget reference.
- **Reusable:** no

### randomizeit
- **Does:** Handles the Randomize button click to randomize the level parameters.
- **Uses:** `randomizeit` callback name; `Randomize` widget reference.
- **Reusable:** no

### AutoLevelName
- **Does:** Handles the Auto button click to generate an auto-generated level name based on the current field values.
- **Uses:** `AutoLevelName` callback name; `AutoBtn` widget reference.
- **Reusable:** no
