<!-- Spark folder manifest of Data/Emitters/oldEmitters/Star (model spark-x2.6-4b, 2026-11-12 18:31). DRAFT. -->

# Data/Emitters/oldEmitters/Star
- **Role:** This folder holds two particle emitter settings, `sparklesparkle.emt` and `starBal.emt`, defined in a reusable `.emt` data file. The file defines the texture, amount, emission rate, life, fade, area, size, size variance, lux, weight, explode, move, scale, rotate and animation parameters for each emitter, serving as reusable particle emission configurations for the engine.
- **Entry point:** none
- **Files:**
  - `_emitters - emitter-settings file defining the two particle emitter settings sparklesparkle.emt and starBal.emt`
  - `sparklesparkle.emt - particle emitter setting defined in the emitter-settings file`
  - `starBal.emt - particle emitter setting defined in the emitter-settings file`
- **Shared with other folders:** Needs `images/blastwhite.png` texture path from elsewhere. No other folders take from this folder.
- **Procedure candidates:** none
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
- **Verdict:** keep - the `.emt` key-value format is a fixed data format reusable for other particle emitters, and the emitter settings are stored as data files that can be reused in new engine projects.
