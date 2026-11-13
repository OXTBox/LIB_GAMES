<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Sounds.lua (model spark-x2.6-4b, 2026-11-12 17:43). DRAFT for Claude to review. -->

## UDG_Sounds.lua
- **Kind:** library
- **Purpose:** This file provides sound management functions for the iGame3D engine, handling zombie idle, footstep, hit, and eat sound playback, voice emitter configuration, and sound emitter count setup. It contains only function definitions and a global link assignment with no top-level executable code.
- **Depends on:** `gObjects` (shared global), `Data/Sounds/` sound files, `Data/` path construction, `setSound_emitterInfo`, `getObjectInfo`, `isFemale`, `math.random`, `time`, and the `soundEmittersHack` global link.
- **Provides:** `udg_handle_zombie_idle_sounds`, `udg_update_object_sounds`, `udg_set_gender_specific_pitch`, `udg_play_scared_sound`, `udg_play_get_eaten_sound`, `udg_play_eat_sound`, `udg_play_hit_sound`, `udg_play_zombie_acknowledge_sound`, `udg_play_zombie_idle_sound`, `udg_play_footsteps_sound`, `udg_soundEmittersHack`, and the global `soundEmittersHack`.
- **Assets it needs:** `Data/Sounds/zombie_yes.ogg`, `Data/Sounds/zombie_idle1.ogg`, `Data/Sounds/zombie_idle2.ogg`, `Data/Sounds/zombie_idle3.ogg`, `Data/Sounds/zombie_idle4.ogg`, `Data/Sounds/footsteps_walk.ogg`, `Data/Sounds/footsteps_run.ogg`
- **Procedural:** yes — `udg_soundEmittersHack` generates sound emitter names, positions, and empty samples based on the number of objects and sound emitter count rules, rather than loading a pre-existing asset file.
- **Glossary:**
  - `setSound_emitterInfo - Configures a sound emitter object's properties such as pitch, position, sample, stop, loop, and start state.`
  - `getObjectInfo - Reads the current properties of an object, including position, pitch, and other engine-defined attributes.`
  - `IG3D_POSITION - Engine constant naming the position property of an object being read or set.`
  - `IG3D_SAMPLE - Engine constant naming the sample property of a sound emitter being read or set.`
  - `IG3D_LOOP - Engine constant naming the loop property of a sound emitter being read or set.`
  - `soundEmittersHack - Global function that ensures enough sound emitters exist for the game objects.`
  - `gObjects - Shared global table containing all game objects.`
  - `Data/Sounds - Folder containing sound asset files used by the sound functions.`
- **Keep / port / drop:** keep - Core sound playback and emitter configuration logic is directly reusable for a new engine's sound system.

---

# Part notes

## Part 1 of 2

### udg_handle_zombie_idle_sounds
- **Does:** Iterates through all objects in `gObjects`, and for each team 1 object that is alive, plays the zombie idle sound.
- **Uses:** `gObjects`, `udg_play_zombie_idle_sound`
- **Reusable:** yes

### udg_update_object_sounds
- **Does:** Iterates through all objects in `gObjects`, reads the position of each object's underlying object, and sets the sound emitter positions for its noise and voice sound emitters, then plays the footstep sound.
- **Uses:** `gObjects`, `getObjectInfo`, `setSound_emitterInfo`, `udg_play_footsteps_sound`, `IG3D_POSITION`
- **Reusable:** yes

### udg_set_gender_specific_pitch
- **Does:** Sets the voice sound emitter pitch to 200 if the object is female, otherwise sets it to 100.
- **Uses:** `isFemale`, `setSound_emitterInfo`, `IG3D_PITCH`
- **Reusable:** yes

### udg_play_scared_sound
- **Does:** Stops and resets the voice sound emitter, sets its pitch to 100 and position to the object's underlying object position, selects a scared sound sample (with a female-specific prefix and random suffix), starts the sound, and sets the emitter's sample.
- **Uses:** `getObjectInfo`, `setSound_emitterInfo`, `isFemale`, `math.random`, `IG3D_STOP`, `IG3D_PITCH`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_START`, `gObjects` (via `obj.cObj`), `Data/` path construction
- **Reusable:** yes

### udg_play_get_eaten_sound
- **Does:** Stops and resets the voice sound emitter, sets its pitch to 100 and position to the object's underlying object position, selects a female-specific eaten sound sample, starts the sound, and sets the emitter's sample.
- **Uses:** `getObjectInfo`, `setSound_emitterInfo`, `isFemale`, `IG3D_STOP`, `IG3D_PITCH`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_START`, `obj.cObj`, `Data/` path construction
- **Reusable:** yes

### udg_play_eat_sound
- **Does:** Sets the object's next idle sound time, stops and resets the voice sound emitter, sets its pitch to 100 and position to the object's underlying object position, selects the zombie eating sound sample, stops the sound loop, starts the sound, and sets the emitter's sample.
- **Uses:** `time`, `math.random`, `setSound_emitterInfo`, `getObjectInfo`, `obj.cObj`, `IG3D_STOP`, `IG3D_PITCH`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `Data/` path construction
- **Reusable:** yes

### udg_play_hit_sound
- **Does:** Sets the object's next idle sound time, stops and resets the noise sound emitter, sets its pitch to 100 and position to the object's underlying object position, selects the body hit sound sample, stops the sound loop, starts the sound, and sets the emitter's sample.
- **Uses:** `time`, `math.random`, `setSound_emitterInfo`, `getObjectInfo`, `obj.cObj`, `IG3D_STOP`, `IG3D_PITCH`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `Data/` path construction
- **Reusable:** yes

## Part 2 of 2

### Top level
- **Does:** No top-level code outside the function definitions; the file contains only the four listed functions and their associated global setup.
- **Uses:** nothing
- **Reusable:** no

### udg_play_zombie_acknowledge_sound
- **Does:** Plays the zombie acknowledgment sound by configuring the zombie's voice sound emitter with a stop state, gender-specific pitch, object position, sample file, loop disabled, and start state, and sets the next idle sound time.
- **Uses:** `setSound_emitterInfo`, `getObjectInfo`, `IG3D_STOP`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `time`, `math.random`, `obj`, `obj.voiceSndEmt`, `obj.cObj`, `Data/Sounds/zombie_yes.ogg`
- **Reusable:** yes

### udg_play_zombie_idle_sound
- **Does:** Plays a random zombie idle sound if the current time exceeds the zombie's next idle sound time, configuring the voice sound emitter with stop, pitch, position, random sample from the idle sample list, loop disabled, and start state, then sets a new next idle sound time.
- **Uses:** `setSound_emitterInfo`, `getObjectInfo`, `IG3D_STOP`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `time`, `math.random`, `obj`, `obj.voiceSndEmt`, `obj.cObj`, `gZombieIdleSamples`, `Data/Sounds/zombie_idle1.ogg`, `Data/Sounds/zombie_idle2.ogg`, `Data/Sounds/zombie_idle3.ogg`, `Data/Sounds/zombie_idle4.ogg`
- **Reusable:** yes

### udg_play_footsteps_sound
- **Does:** Triggers walking and running footstep sounds based on the zombie's animation name and walking/running state, configuring the noise sound emitter with stop, position, sample file, loop enabled, and start state, and resets walking/running state when the animation is neither Walk nor Run.
- **Uses:** `setSound_emitterInfo`, `getObjectInfo`, `IG3D_STOP`, `IG3D_POSITION`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `obj`, `obj.health`, `obj.anim.name`, `obj.isWalking`, `obj.isRunning`, `obj.noiseSndEmt`, `obj.cObj`, `Data/Sounds/footsteps_walk.ogg`, `Data/Sounds/footsteps_run.ogg`
- **Reusable:** yes

### udg_soundEmittersHack
- **Does:** Creates extra sound emitters if the total number of sound emitters is below three times the number of objects, assigning each new emitter a generated name, position, and empty sample, then registers the emitter count and links the function to `soundEmittersHack`.
- **Uses:** `make`, `setSound_emitterInfo`, `IG3D_POSITION`, `IG3D_SAMPLE`, `gNumSoundEmitters`, `gNumObjects`, `gSoundEmitterNames`, `gSoundEmitterPositions`, `gSoundEmitterSamples`, `gSoundEmitters`, `table.insert`, `Data/` paths (none directly referenced in this function)
- **Reusable:** no
- **Procedural:** yes

### soundEmittersHack
- **Does:** No standalone code; this is the assignment that links the `udg_soundEmittersHack` function to the global `soundEmittersHack`.
- **Uses:** `udg_soundEmittersHack`
- **Reusable:** no
