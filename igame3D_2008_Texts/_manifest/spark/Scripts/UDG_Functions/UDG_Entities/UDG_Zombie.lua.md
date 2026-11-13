<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Zombie.lua (model spark-x2.6-4b, 2026-11-12 14:42). DRAFT for Claude to review. -->

## UDG_Zombie.lua
- **Kind:** library
- **Purpose:** Defines the shared zombies table for the UDG zombie entity system, configures zombie population settings and animation source caching, and provides the getRandomAnimationOfStyle function for selecting a random animation matching a given style.
- **Depends on:** Other Scripts files (gObjects, gObjectWTFs, master, assign_free_sound_emitter, zombie_behaviour, Characters, zombieAnims set elsewhere); Data folder paths (Data/Sounds/zombie.ogg, Data/WTF/WIF/Walk_Zombie.wtf, Data/WTF/Characters/truebonesmaster.wtf); engine calls (getObjectInfo, setSound_emitterInfo, putObjectOnGround, math.random).
- **Provides:** The shared `zombies` table, the `getRandomAnimationOfStyle` function, and the zombie population configuration and animation caching setup defined at top level.
- **Assets it needs:** Data/Sounds/zombie.ogg, Data/WTF/WIF/Walk_Zombie.wtf, Data/WTF/Characters/truebonesmaster.wtf
- **Procedural:** none
- **Glossary:**
  - `zombie_behaviour - Shared configuration table for zombie entity behaviour in the UDG system.`
  - `zombieAnims - Table holding zombie animation names and linked flags for animation selection.`
  - `getObjectInfo - Engine call that reads object property values such as position or text.`
  - `setSound_emitterInfo - Engine call that configures sound emitter properties for an object.`
  - `putObjectOnGround - Engine call that places an object on the ground.`
  - `getRandomAnimationOfStyle - Function that selects a random matching animation name and linked flag from a style.`
- **Keep / port / drop:** keep - core shared library code for the UDG zombie entity system that other files depend on.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the shared `zombies` table, sets up zombie population configuration and animation source caching, and defines the `getRandomAnimationOfStyle` function.
- **Uses:** Globals `gObjects`, `gObjectWTFs`, `master`, `assign_free_sound_emitter`, `zombie_behaviour`, `offstz`, `offst`, `Characters`, `zombieAnims`; file paths `Data/Sounds/zombie.ogg`, `Data/WTF/WIF/Walk_Zombie.wtf`, `Data/WTF/Characters/truebonesmaster.wtf`; engine calls `getObjectInfo`, `setSound_emitterInfo`, `putObjectOnGround`, `math.random`.
- **Reusable:** no

### getRandomAnimationOfStyle
- **Does:** Selects a random animation name and linked flag from the animation table matching the given style, returning the animation name and linked flag if no matching style exists.
- **Uses:** Globals `math.random`; no engine calls, files or data paths read or written.
- **Reusable:** yes
- **Procedural:** no
