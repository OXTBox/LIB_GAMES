<!-- Spark first-look of Data/Emitters/oldEmitters/Blast/_emitters (model spark-x2.6-4b, 2026-11-12 18:24). DRAFT for Claude to review. -->

## _emitters
- **Kind:** emitter-settings
- **Purpose:** This file holds the particle emitter settings for the blast effects in iGame3D. It contains only the configuration data for the blast-related particle emitters, with no top-level functions. The settings are reusable as particle definitions for new engine builds.
- **Depends on:** `.emt` particle settings files (BLASTERBeam.emt, blaststat.emt, blaststatatoo.emt, blasttat2.emt) and their referenced `images/` textures.
- **Provides:** none
- **Assets it needs:** BLASTERBeam.emt, blaststat.emt, blaststatatoo.emt, blasttat2.emt, images/ textures
- **Procedural:** none
- **Glossary:** emitter-settings - configuration file defining particle emission parameters for 3D effects; `.emt` - file format for particle emitter settings containing key-value particle definitions
- **Keep / port / drop:** keep - reusable particle definitions for blast effects in a new engine

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains only the particle emitter settings for the blast effects, with no top-level functions.
- **Uses:** `.emt` particle settings files (BLASTERBeam.emt, blaststat.emt, blaststatatoo.emt, blasttat2.emt) and their referenced `images/` textures.
- **Reusable:** yes - the `.emt` key-value particle settings are reusable as particle definitions.
