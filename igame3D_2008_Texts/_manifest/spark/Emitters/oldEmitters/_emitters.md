<!-- Spark first-look of Data/Emitters/oldEmitters/_emitters (model spark-x2.6-4b, 2026-11-12 19:04). DRAFT for Claude to review. -->

## _emitters
- **Kind:** emitter-settings
- **Purpose:** This file defines the particle emitter settings for the COSMOS, More puslar, bullet, explosion and fireball emitters, using the fixed key-value format of an `.emt` emitter-settings file. It contains shared default parameters and per-emitter settings for texture, amount, emission rate, life, fade, area, size, speed, and animation references. The file is a static asset definition that configures particle behavior for the game's emitters.
- **Depends on:** `images/blastwhite.png`, `images/fire-animated.mov`, `animations/fire-animated.gif`, `bullet.wtf`
- **Provides:** No engine calls, globals, or other file dependencies are used; it provides the emitter settings themselves for the named emitters.
- **Assets it needs:** `images/blastwhite.png`, `images/fire-animated.mov`, `animations/fire-animated.gif`, `bullet.wtf`
- **Procedural:** none
- **Glossary:**
  - emitter-settings - a `.emt` file containing key-value particle configuration for an emitter
  - particle emitter - a component that emits particles with configured settings
  - key-value settings - parameter pairs (name = value) defining emitter behavior
  - texture - a referenced image asset used to style emitted particles
  - animation reference - a reference to a video or GIF asset used for animated particle behavior
- **Keep / port / drop:** keep - it is a fixed asset definition format that other files rely on for emitter configuration.

---

# Part notes

## Part 1 of 6

### Top level
- **Does:** Contains the particle emitter definitions for COSMOS, More puslar, bullet, explosion and fireball, each with key-value particle settings.
- **Uses:** `images/blastwhite.png`, `images/fire-animated.mov`, `animations/fire-animated.gif`, `bullet.wtf` paths; `lux=true` settings; no engine calls, globals or Data/ folders.
- **Reusable:** no
- **Procedural:** yes

## Part 2 of 6

### Top level
- **Does:** Defines the settings for several particle emitters in the Emitters/oldEmitters folder, including shared defaults and per-emitter key-value parameters.
- **Uses:** `.emt` file content only; no engine calls, globals or Data/ paths are used.
- **Reusable:** yes - the `.emt` key-value format is a fixed asset definition format.
- **Procedural:** no

## Part 3 of 6

### Top level
- **Does:** Defines the particle emitter settings for the oldEmitters folder, including shared defaults and per-emitter key-value parameters.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### Top level
- **Does:** Defines the settings for several particle emitters in the Emitters/oldEmitters folder, including shared defaults and per-emitter key-value parameters such as texture, amount, emission rate, life, fade, area, size, speed, and animation references.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 5 of 6

### Top level
- **Does:** Defines particle emitter settings for the Emitters/oldEmitters folder, including shared size variance, speed, lux, weight, explode, move, scale, rotate and anim parameters, and per-emitter texture, amount, emission rate, life, fade, area, size, speed, weight, explode, move, scale, rotate and anim settings.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 6 of 6

### Top level
- **Does:** Defines the default settings for the oldEmitters particle emitter file, setting speed, lux, weight, explode, move, scale and rotate values.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no
