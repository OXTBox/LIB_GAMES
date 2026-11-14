<!-- Spark folder manifest of Data/Emitters/oldEmitters/Blast (model spark-x2.6-4b, 2026-11-12 18:24). DRAFT. -->

# Data/Emitters/oldEmitters/Blast
- **Role:** This folder holds the particle emitter settings for the blast effects in iGame3D. It stores configuration data for the blast-related particle emitters, with no top-level functions, so the settings can be reused as particle definitions for new engine builds.
- **Entry point:** none
- **Files:** BLASTERBeam.emt - particle emitter settings file for the blast effects, containing key-value particle definitions; blaststat.emt - particle emitter settings file for the blast effects, containing key-value particle definitions; blaststatatoo.emt - particle emitter settings file for the blast effects, containing key-value particle definitions; blasttat2.emt - particle emitter settings file for the blast effects, containing key-value particle definitions
- **Shared with other folders:** Needs `images/` textures referenced by the emitter settings files.
- **Procedure candidates:** none
- **Glossary:** emitter-settings - configuration file defining particle emission parameters for 3D effects; `.emt` - file format for particle emitter settings containing key-value particle definitions; particle definitions - reusable configuration data for particle emission parameters used in 3D effects; particle emission parameters - configuration values defining how particles are emitted, including model, amount, emission rate, life, fade, size, speed, and explode settings; images/ textures - texture assets referenced by the emitter settings files
- **Verdict:** keep - These are reusable particle definitions for blast effects, and the folder contains only configuration data with no top-level functions, so they can be carried over to a new engine build.
