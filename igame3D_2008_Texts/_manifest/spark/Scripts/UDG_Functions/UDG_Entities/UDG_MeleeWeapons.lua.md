<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_MeleeWeapons.lua (model spark-x2.6-4b, 2026-11-12 14:41). DRAFT for Claude to review. -->

## UDG_MeleeWeapons.lua
- **Kind:** library
- **Purpose:** This file defines shared weapon classification and assignment logic for the iGame3D engine, specifically for melee weapons used by the UDG (UDG_Functions) game scripts. It scans level objects to identify two-handed melee weapons, distributes them among human characters, and configures each human with the required melee weapon behavior and object settings.
- **Depends on:** `gObjects` (shared global), `isTwoHandedWeapon`, `resetCollisionToDefault`, `meleeWeaponsTeam`, `civilian_with_melee_weapon_behaviour`, `humans`, `Data/` folder paths referenced via `gameroot` for model lookups, and the `ig3d_GetObjectModelPath_s_s` engine call used to resolve model paths.
- **Provides:** The `meleeWeapons` table (populated with classified melee weapons), the `isTwoHandedWeapon` function, and the `HumansWithMeleeWeapons` routine that assigns weapons to humans.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are referenced).
- **Procedural:** none (the file only scans existing objects and configures their properties; it does not generate or place assets).
- **Glossary:**
  - `meleeWeapons` - A shared table that holds classified melee weapons and their assignment targets.
  - `isTwoHandedWeapon` - A function that checks whether an object is a two-handed melee weapon by comparing its model path.
  - `gObjects` - A shared global table containing all objects in the current level.
  - `IG3D_NAME` - An engine constant naming the object property being read (the object name).
  - `IG3D_COLL` - An engine constant naming the object property being set (collision settings).
  - `IG3D_GRAVITY_MULTIPLIER` - An engine constant naming the object property being set (gravity multiplier).
  - `gameroot` - A global used to build `Data/` folder paths for model lookups.
- **Keep / port / drop:** keep - it provides reusable weapon classification and assignment logic that other game scripts depend on.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the shared `meleeWeapons` table and the `isTwoHandedWeapon` function, then populates `meleeWeapons` by scanning `gObjects` and marking qualifying objects as melee weapons.
- **Uses:** `gObjects`, `isTwoHandedWeapon`, `resetCollisionToDefault`, `meleeWeaponsTeam`, `civilian_with_melee_weapon_behaviour`, `setObjectInfo`, `IG3D_NAME`, `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`, `humans`, `math.random`, `Data/` paths referenced via `gameroot` in the model path lookup.
- **Reusable:** no - it is a game-specific weapon classification and weapon assignment routine tied to specific level objects and weapon sets.

### isTwoHandedWeapon
- **Does:** Checks whether a given object is a two-handed melee weapon by resolving its model path, extracting the model folder name, and comparing it against the two known two-handed weapon model names.
- **Uses:** `ig3d_GetObjectModelPath_s_s`, `getObjectInfo` (with `IG3D_NAME`), `gameroot`, `string.sub`, `Data/` paths implied by the model path lookup.
- **Reusable:** yes - the model name comparison logic is generic and can be reused for other weapon classification checks.

### isSingleHandedWeapon
- **Does:** Not present in this part of the file; the function body is commented out.
- **Uses:** nothing in this part.
- **Reusable:** no

### HumansWithMeleeWeapons
- **Does:** Iterates over the pre-populated `meleeWeapons` table, randomly assigns each weapon to a human that does not already have a gun or melee weapon, and configures the human with melee weapon behavior and weapon-related object settings.
- **Uses:** `meleeWeapons`, `humans`, `math.random`, `civilian_with_melee_weapon_behaviour`, `setObjectInfo` (with `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`), `Data/` paths referenced via `gameroot` in the model path lookup, `resetCollisionToDefault` (used in the `meleeWeapons` population loop).
- **Reusable:** no - it is a game-specific weapon distribution routine tied to the current weapon set and human roster.

### Top level
- **Does:** Populates the `meleeWeapons` table by scanning all objects in `gObjects`, marking two-handed melee weapons with `isMeleeWeapon=true` and resetting collision/gravity settings, then prints the final count of assigned melee weapons.
- **Uses:** `gObjects`, `isTwoHandedWeapon`, `resetCollisionToDefault`, `meleeWeaponsTeam`, `meleeWeapons`, `setObjectInfo` (with `IG3D_COLL`, `IG3D_GRAVITY_MULTIPLIER`), `humans`, `math.random`, `Data/` paths referenced via `gameroot` in the model path lookup.
- **Reusable:** no - it is a game-specific weapon classification and assignment routine tied to specific level objects and weapon sets.
