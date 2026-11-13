<!-- Spark folder manifest of Data/Emitters/oldEmitters/Glo (model spark-x2.6-4b, 2026-11-12 18:27). DRAFT. -->

# Data/Emitters/oldEmitters/Glo
- **Role:** This folder holds three particle emitter settings for the iGame3D engine, covering the globall200, glowball200, and glowball400 emitters. The settings define each emitter's texture, emission parameters, visual and motion properties, along with scale, rotate, and animation settings. They serve as a reference for particle emitter configuration in the engine.
- **Entry point:** none
- **Files:**
  - globall200.emt - particle emitter settings for the globall200 emitter
  - glowball200.emt - particle emitter settings for the glowball200 emitter
  - glowball400.emt - particle emitter settings for the glowball400 emitter
- **Shared with other folders:** The emitters are used by other files to configure particle behavior; they need no other assets from elsewhere.
- **Procedure candidates:** none
- **Glossary:**
  - texture - the image asset applied to a particle emitter
  - emission rate - how often particles are emitted from the emitter
  - life - the duration particles remain active
  - fade - whether particle visibility decreases over time
  - area - the spatial region particles are emitted from
  - size - the visual size of emitted particles
  - size variance - variation in particle size
  - lux flag - flag controlling light-related emitter behavior
  - weight - emitter priority or weighting value
  - explode - whether particles move outward from the emission point
  - move - particle movement behavior
  - scale - overall size multiplier for the emitter
  - rotate - rotation behavior for the emitter
  - anim settings - animation parameters applied to the emitter
- **Verdict:** keep - the folder provides reusable particle emitter configuration settings for the iGame3D engine, matching the emitter definitions referenced by the three files in the folder.
