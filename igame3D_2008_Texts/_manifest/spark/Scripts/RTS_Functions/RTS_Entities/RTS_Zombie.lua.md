<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Zombie.lua (model spark-x2.6-4b, 2026-11-12 14:36). DRAFT for Claude to review. -->

## RTS_Zombie.lua
- **Kind:** library
- **Purpose:** Defines the `zombies` table and zombie object configuration logic for the RTS zombie entities, loads zombie animation caches, and provides the `getRandomAnimationOfStyle` helper for selecting random zombie animations by style.
- **Depends on:** Engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`), globals (`gObjects`, `master`, `gameroot`), files (`Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`), and `Data/` folder paths.
- **Provides:** `zombies` table, `getRandomAnimationOfStyle` function.
- **Assets it needs:** `Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`
- **Procedural:** none
- **Glossary:**
  - `ig3d_object` - Engine object kind used as the first argument of make/get calls to reference game objects.
  - `getObjectInfo` - Engine call that reads property values from an object.
  - `setSound_emitterInfo` - Engine call that configures sound emitter properties for an object.
  - `putObjectOnGround` - Engine call that places an object on the ground.
  - `getRandomAnimationOfStyle` - Function that selects a random animation name and linked flag from a style-specific animation table.
  - `zombies` - Table holding zombie entity configuration and animation cache data.
- **Keep / port / drop:** keep - reusable zombie entity configuration and animation selection logic for new engine implementations.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `zombies` table and sets up zombie object configuration logic, animation cache loading, and the `getRandomAnimationOfStyle` function.
- **Uses:** Engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`), globals (`gObjects`, `master`, `gameroot`), files (`Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`), and `Data/` paths.
- **Reusable:** no

### getRandomAnimationOfStyle
- **Does:** Selects a random animation name and linked flag from the animation table matching the given style, or returns the style and linked flag unchanged if no matching entry exists or the animation table is nil.
- **Uses:** nothing
- **Reusable:** yes

Wait, the instructions say to write one section per function in order, and the file has only one function listed. Let me correct the output to follow the exact format:

### Top level
- **Does:** Defines the `zombies` table, configures zombie objects in `gObjects`, loads zombie animation caches, and defines the `getRandomAnimationOfStyle` function.
- **Uses:** Engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`), globals (`gObjects`, `master`, `gameroot`), files (`Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`), and `Data/` paths.
- **Reusable:** no

### getRandomAnimationOfStyle
- **Does:** Selects a random animation name and linked flag from the animation table matching the given style, or returns the style and linked flag unchanged if the animation table is nil or no matching style entry exists.
- **Uses:** nothing
- **Reusable:** yes

Wait, the top level code is outside the function, so it should be the `### Top level` section first, then the function section. Let me ensure the format matches exactly:

### Top level
- **Does:** Defines the `zombies` table, configures zombie objects in `gObjects`, loads zombie animation caches, and defines the `getRandomAnimationOfStyle` function.
- **Uses:** Engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`), globals (`gObjects`, `master`, `gameroot`), files (`Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`), and `Data/` paths.
- **Reusable:** no

### getRandomAnimationOfStyle
- **Does:** Selects a random animation name and linked flag from the animation table matching the given style, or returns the style and linked flag unchanged if the animation table is nil or no matching style entry exists.
- **Uses:** nothing
- **Reusable:** yes

Note: The `Procedural
