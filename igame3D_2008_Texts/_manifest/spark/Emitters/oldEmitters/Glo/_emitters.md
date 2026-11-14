<!-- Spark first-look of Data/Emitters/oldEmitters/Glo/_emitters (model spark-x2.6-4b, 2026-11-12 18:26). DRAFT for Claude to review. -->

## _emitters
- **Kind:** emitter-settings
- **Purpose:** This file defines three particle emitter settings for the iGame3D engine, covering the globall200, glowball200, and glowball400 emitters. Each emitter configuration sets its texture, emission parameters, visual and motion properties, along with scale, rotate, and animation settings.
- **Depends on:** nothing
- **Provides:** the three particle emitter settings (globall200.emt, glowball200.emt, glowball400.emt) used by other files to configure particle behavior.
- **Assets it needs:** globall200.emt, glowball200.emt, glowball400.emt
- **Procedural:** none
- **Glossary:** emitter settings - particle emission configuration values for iGame3D; texture - the image asset applied to a particle emitter; emission rate - how often particles are emitted from the emitter; life - the duration particles remain active; fade - whether particle visibility decreases over time; area - the spatial region particles are emitted from; size - the visual size of emitted particles; size variance - variation in particle size; lux flag - flag controlling light-related emitter behavior; weight - emitter priority or weighting value; explode - whether particles move outward from the emission point; move - particle movement behavior; scale - overall size multiplier for the emitter; rotate - rotation behavior for the emitter; anim settings - animation parameters applied to the emitter.
- **Keep / port / drop:** keep - serves as a reference for particle emitter configuration in iGame3D.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines three particle emitter settings: globall200.emt, glowball200.emt, and glowball400.emt. Each sets a texture, amount, emission rate, life, fade, area, size, size variance, lux flag, weight, explode and move values, plus scale, rotate and anim settings.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no
