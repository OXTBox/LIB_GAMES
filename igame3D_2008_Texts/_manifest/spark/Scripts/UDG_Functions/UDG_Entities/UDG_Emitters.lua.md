<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Emitters.lua (model spark-x2.6-4b, 2026-11-12 14:37). DRAFT for Claude to review. -->

## UDG_Emitters.lua
- **Kind:** emitter-settings
- **Purpose:** This file loads particle emitter definitions from the engine and reports any missing emitters so the game can proceed without unconfigured particle systems. It reads named emitters used by the UDG entities and prints a warning when an emitter is absent from the engine.
- **Depends on:** engine calls `get(ig3d_particle_emitter, name)` to load emitters; globals `gGunEmitter`, `tireTraces`, `bloodParticles`, `bloodParticles2`, `muzzleFlash`, `unitMarkerFriendly`, `unitMarkerEnemy` set elsewhere; `Data/` folder paths for emitter assets.
- **Provides:** no standalone functions; it operates on the named particle emitter globals and engine emitter lookup.
- **Assets it needs:** particle emitters named `gGunEmitter`, `tireTraces`, `bloodParticles`, `bloodParticles2`, `muzzleFlash`, `unitMarkerFriendly`, `unitMarkerEnemy`.
- **Procedural:** none
- **Glossary:**
  - particle emitter - a particle system definition loaded from the engine for 3D effects
  - ig3d_particle_emitter - engine call kind naming the particle emitter object type
  - get - engine call used to retrieve an object by name from the engine
  - warning - printed message indicating a missing required asset
- **Keep / port / drop:** keep - it is a reusable reference for loading and validating particle emitters in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Loads particle emitters from the engine and prints a warning if any of them are missing.
- **Uses:** `get(ig3d_particle_emitter, name)` engine calls, globals `gGunEmitter`, `tireTraces`, `bloodParticles`, `bloodParticles2`, `muzzleFlash`, `unitMarkerFriendly`, `unitMarkerEnemy`.
- **Reusable:** no
- **Procedural:** no
