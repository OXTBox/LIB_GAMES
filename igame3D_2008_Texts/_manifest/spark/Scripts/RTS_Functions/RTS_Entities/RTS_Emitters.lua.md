<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Emitters.lua (model spark-x2.6-4b, 2026-11-12 14:33). DRAFT for Claude to review. -->

## RTS_Emitters.lua
- **Kind:** emitter-settings
- **Purpose:** Loads the particle emitters defined for the RTS entities, and reports to the user if any required emitters are missing from the engine. It centralizes the emitter setup for the RTS game's particles.
- **Depends on:** Engine calls (`get(ig3d_particle_emitter, ...)`), globals (`gGunEmitter`, `tireTraces`, `bloodParticles`, `bloodParticles2`, `muzzleFlash`, `unitMarkerFriendly`, `unitMarkerEnemy`), `Data/` folder paths referenced by emitter names, and the Scripts/RTS_Functions/RTS_Entities folder containing this file.
- **Provides:** No standalone functions or globals are defined here; it operates on the emitter globals referenced above and the engine's emitter lookup calls.
- **Assets it needs:** Particle emitters (`.emt` settings) named in the code, referenced via `Data/` paths; no models, images, sounds, or fonts are named.
- **Procedural:** none
- **Glossary:**
  - particle emitter - A `.emt` file defining how particles are emitted, with settings for model, amount, rate, life, fade, size, speed, and other parameters.
  - ig3d_particle_emitter - The engine object kind used to look up particle emitters when loading them.
  - emitter name - The identifier used to reference a specific particle emitter in the code.
- **Keep / port / drop:** keep - It is a core reference for loading and validating RTS particle emitters, reusable when building similar engine scripts.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads particle emitters from the engine and prints a warning if any are missing.
- **Uses:** Engine calls (`get(ig3d_particle_emitter, ...)`), globals (`gGunEmitter`, `tireTraces`, `bloodParticles`, `bloodParticles2`, `muzzleFlash`, `unitMarkerFriendly`, `unitMarkerEnemy`), `Data/` paths (via emitter names referenced in the code).
- **Reusable:** no
- **Procedural:** no
