<!-- Spark first-look of Data/Emitters/oldEmitters/Star/_emitters (model spark-x2.6-4b, 2026-11-12 18:30). DRAFT for Claude to review. -->

## _emitters
- **Kind:** emitter-settings
- **Purpose:** This file defines two particle emitter settings, `sparklesparkle.emt` and `starBal.emt`, by specifying texture, amount, emission rate, life, fade, area, size, size variance, lux, weight, explode, move, scale, rotate and animation parameters for each emitter. It serves as a reusable data definition for particle emitters in the engine.
- **Depends on:** `images/blastwhite.png` texture path; `.emt` emitter settings; nothing else.
- **Provides:** the two emitter settings `sparklesparkle.emt` and `starBal.emt` as defined particle emission configurations.
- **Assets it needs:** `images/blastwhite.png`
- **Procedural:** none
- **Glossary:**
  - emitter-settings - a file defining particle emission parameters for a particle emitter.
  - `.emt` - the fixed data format used to store particle emitter settings.
  - texture - the image asset used by an emitter for its visual appearance.
  - amount - the number of particles an emitter produces.
  - emission rate - the frequency at which particles are emitted.
  - life - the duration particles remain active.
  - fade - the behavior of particle visibility over time.
  - area - the spatial region over which particles are emitted.
  - size - the visual size of emitted particles.
  - size variance - the variation in particle size.
  - lux - a parameter controlling particle light properties.
  - weight - a parameter controlling particle behavior.
  - explode - a parameter controlling particle outward movement.
  - move - a parameter controlling particle movement.
  - scale - a parameter controlling particle scaling.
  - rotate - a parameter controlling particle rotation.
  - anim - a parameter controlling particle animation.
- **Keep / port / drop:** keep - the `.emt` key-value format is a fixed data format reusable for other particle emitters.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines two particle emitter settings, `sparklesparkle.emt` and `starBal.emt`, with texture, amount, emission rate, life, fade, area, size, size variance, lux, weight, explode, move, scale, rotate and anim parameters.
- **Uses:** `images/blastwhite.png` texture path; `.emt` emitter settings; nothing else.
- **Reusable:** yes - the `.emt` key-value format is a fixed data format that can be reused for other particle emitters.
- **Procedural:** no
