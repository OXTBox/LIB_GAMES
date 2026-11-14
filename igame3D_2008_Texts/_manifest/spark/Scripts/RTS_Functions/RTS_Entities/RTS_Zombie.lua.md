<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Zombie.lua (model spark-x2.6-4b, 2026-11-12 19:01). DRAFT for Claude to review. -->

## RTS_Zombie.lua
- **Kind:** library
- **Purpose:** This file initialises shared zombie data structures, populates zombie objects from the object list, loads zombie animation caches, and defines the animation table used by the animation function. It also provides a helper that selects a random animation entry from a given style's animation table.
- **Depends on:** `gObjects`, `master`, `zombies`, `Characters`, `offstz`, `offst`, `Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`, `ig3d_GetObjectModelAnimOffset_s_i`, `ig3d_ReadAnimationsFromFileIntoCache_si`, `gameroot`, `Data/` paths, engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`, `assign_free_sound_emitter`, `string.sub`, `math.random`, `table.insert`), `animTable`, `style`, `linked`
- **Provides:** `getRandomAnimationOfStyle`
- **Assets it needs:** `Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`
- **Procedural:** none
- **Glossary:**
  - `ig3d_GetObjectModelAnimOffset_s_i - Engine call that retrieves the animation offset for an object model.`
  - `ig3d_ReadAnimationsFromFileIntoCache_si - Engine call that loads animation data from a file into a cache.`
  - `animTable - Table holding the animation entries for a zombie style.`
  - `style - The zombie style used to select animations.`
  - `linked - Flag indicating whether an animation entry is linked.`
- **Keep / port / drop:** keep (reusable helper for selecting random zombie animations)

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Initialises shared zombie data structures and populates zombie objects from the object list, then loads zombie animation caches and defines the animation table used by the animation function.
- **Uses:** `gObjects`, `master`, `zombies`, `Characters`, `offstz`, `offst`, `ig3d_GetObjectModelAnimOffset_s_i`, `ig3d_ReadAnimationsFromFileIntoCache_si`, `gameroot`, `Data/` paths (`Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`), engine calls (`getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`, `assign_free_sound_emitter`, `string.sub`, `math.random`, `table.insert`).
- **Reusable:** no

### getRandomAnimationOfStyle
- **Does:** Selects a random animation entry from a given style's animation table, returning the animation name and its linked flag, or falls back to the requested style and linked flag if no matching style exists or the table is nil.
- **Uses:** `animTable`, `style`, `linked`, `math.random`, `#` (table length), `==` (string comparison).
- **Reusable:** yes
- **Procedural:** no
