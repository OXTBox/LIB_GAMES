<!-- Spark first-look of Data/Scripts/Functions/particle_functions.lua (model spark-x2.6-4b, 2026-11-12 07:22). DRAFT for Claude to review. -->

## particle_functions.lua
- **Kind:** emitter-settings
- **Purpose:** Defines emitter style data and helper functions for managing particle emitters in iGame3D, including loading emitter styles, resolving emitter property settings, and creating new particle emitters with shared position and rotation tracking.
- **Depends on:** `Data/Emitters/firebig.emt` path, globals `emt`, `emissionCommand`, `emitter`, `gParticleNamesAndEMTs`, `gParticlePositions`, `gParticleRotations`, `gParticleEmitters`, `runningParticle`, and engine calls such as `getCameraInfo`, `make`, `get`, `setParticle_emitterInfo`; `SETemitterStyle` is called at file scope.
- **Provides:** `emt` table, `SETemitterStyle`, `GETEmitterStyle`, `setEmitters`, `newEmitter`; emitter style data and emitter creation logic.
- **Assets it needs:** `Data/Emitters/firebig.emt` (exact file name).
- **Procedural:** yes (creates a new particle emitter by assigning a unique name, default emitter path, and shared position/rotation data, then builds and configures the emitter object).
- **Glossary:**
  - `emitter` - table of emitter style data used to configure particle emitters.
  - `SETemitterStyle` - engine call that applies a named emitter style to an emitter.
  - `setParticle_emitterInfo` - engine call that sets particle emitter property values.
  - `gParticleNamesAndEMTs` - shared global table tracking registered emitter names and emitter types.
  - `Data/` path - folder-based path used to locate engine assets and scripts.
  - `make` - engine call that creates an object of a given type.
  - `get` - engine call that retrieves an object by name.
- **Keep / port / drop:** keep - core emitter configuration and creation logic reusable for new engine particle systems.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Defines the `emt` table holding emitter style data, then calls `setEmitters()` and `SETemitterStyle("anyemitter","flaming")` at file scope.
- **Uses:** Globals `emt`, `emissionCommand`, `firename`, `firepath` (no `Data/` paths read or written directly here).
- **Reusable:** no

### SETemitterStyle
- **Does:** Loads a generated emitter style string into a Lua string, then iterates over each emitter in the `emitter` table, loads and runs the corresponding style command for each.
- **Uses:** Globals `emt`, `emissionCommand`, `loadstring`; no engine calls, files or `Data/` paths.
- **Reusable:** no

### GETEmitterStyle
- **Does:** Resolves the emitter name to a default if it is nil, then builds and loads a string that sets the particle emitter info for the requested emitter and property, returning the resulting engine call string.
- **Uses:** Globals `emitter`, `loadstring`; no engine calls, files or `Data/` paths.
- **Reusable:** no

### setEmitters
- **Does:** Populates the `emt.flaming` and `emt.fireball` emitter style tables with default emitter parameters, then calls `SETemitterStyle("anyemitter","flaming")` to apply the flaming emitter style.
- **Uses:** Globals `emt`, `SETemitterStyle`; no engine calls, files or `Data/` paths.
- **Reusable:** no

## Part 2 of 2

### Top level

### newEmitter
- **Does:** Creates a new particle emitter by assigning a unique name and default emitter path, then registers the emitter name, position and rotation in shared particle tables, builds the emitter object, and sets its position and rotation.
- **Uses:** Engine calls (`getCameraInfo`, `make`, `get`, `setParticle_emitterInfo`), globals (`gParticleNamesAndEMTs`, `gParticlePositions`, `gParticleRotations`, `gParticleEmitters`, `runningParticle`), and `Data/` path `Data/Emitters/firebig.emt`.
- **Reusable:** no
- **Procedural:** yes
