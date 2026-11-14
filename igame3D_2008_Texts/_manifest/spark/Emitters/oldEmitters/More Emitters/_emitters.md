<!-- Spark first-look of Data/Emitters/oldEmitters/More Emitters/_emitters (model spark-x2.6-4b, 2026-11-12 18:29). DRAFT for Claude to review. -->

## _emitters
- **Kind:** emitter-settings
- **Purpose:** This file contains particle emitter settings for the Emitters/oldEmitters/More Emitters folder, defining key-value parameters for several `.emt` particle emitter files and the emitter settings for `truecomet.emt`. It provides no executable functions or top-level logic, only configuration data for particle emitters.
- **Depends on:** `images/blast0.png`, `images/lights.png`, `animations/fire-animated.gif` texture paths; `.emt` particle settings key-value pairs (amount, emission rate, life, fade, area, size, size variance, speed, weight, explode, move, scale, rotate, anim, lux).
- **Provides:** no functions or globals; only emitter configuration settings for the named `.emt` files.
- **Assets it needs:** `images/blast0.png`, `images/lights.png`, `animations/fire-animated.gif`, `truecomet.emt`, `.emt` emitter files in Emitters/oldEmitters/More Emitters.
- **Procedural:** none
- **Glossary:**
  - `.emt` - particle emitter settings file containing key-value pairs for particle behavior.
  - `emission rate` - particle emission rate setting for an emitter.
  - `life` - particle lifetime setting for an emitter.
  - `explode` - flag setting for emitter particle explosion behavior.
  - `move` - flag setting for emitter particle movement behavior.
  - `scale` - flag setting for emitter particle scaling behavior.
  - `rotate` - flag setting for emitter particle rotation behavior.
  - `anim` - flag setting for emitter particle animation behavior.
- **Keep / port / drop:** keep - serves as a reference for emitter configuration parameters for reuse in new engines.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Contains only particle emitter settings for several `.emt` files, with no top-level functions.
- **Uses:** `images/blast0.png`, `images/lights.png`, `animations/fire-animated.gif` texture paths; `.emt` key-value particle settings (amount, emission rate, life, fade, area, size, size variance, speed, weight, explode, move, scale, rotate, anim, lux).
- **Reusable:** no
- **Procedural:** no

## Part 2 of 5

### Top level
- **Does:** Defines particle emitter settings for the Emitters/oldEmitters/More Emitters folder, using key=value pairs for each emitter file.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 3 of 5

### Top level
- **Does:** Defines particle emitter settings for the oldEmitters/More Emitters Emitters folder, including shared defaults and per-emitter key-value parameters.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 4 of 5

### Top level
- **Does:** Defines several particle emitter settings in the Emitters folder, each with its own `#`-prefixed `.emt` file name and key-value parameters.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 5 of 5

### Top level
- **Does:** Defines the particle emitter settings for `truecomet.emt`, including texture, amount, emission rate, life, fade, area, size, speed, and related flags.
- **Uses:** `images/blast0.png` (texture path), `.emt` emitter settings keys (`texture`, `amount`, `emission rate`, `life`, `fade`, `area`, `size`, `size variance`, `speed`, `lux`, `weight`, `explode`, `move`, `scale`, `rotate`, `anim`).
- **Reusable:** no
- **Procedural:** no
