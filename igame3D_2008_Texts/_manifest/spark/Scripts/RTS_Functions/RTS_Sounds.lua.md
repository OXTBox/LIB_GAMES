<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Sounds.lua (model spark-x2.6-4b, 2026-11-12 16:40). DRAFT for Claude to review. -->

## RTS_Sounds.lua
- **Kind:** library
- **Purpose:** This file configures scene sound damping parameters and a global sound emitter counter at load, and provides functions for assigning free sound emitters and setting up zombie voice sound emitters. It supports sound handling for the RTS game.
- **Depends on:** `Data/Sounds/zombie.ogg` (sound asset path), `gSoundEmitters`, `gSoundEmittersHighwaterMark` (globals set elsewhere), and engine functions `setSceneInfo`, `setSound_emitterInfo`, `ig3d_SetMode_i` (used by the file's code).
- **Provides:** `assign_free_sound_emitter`, `rts_play_zombie_ambient_sound`, plus the global sound emitter counter `gSoundEmittersHighwaterMark` set at load.
- **Assets it needs:** `Data/Sounds/zombie.ogg`
- **Procedural:** none
- **Glossary:**
  - `setSceneInfo - Engine call to set scene-level parameters such as sound damping.`
  - `IG3D_SOUND_DAMPING - Engine constant naming the sound damping property being set.`
  - `gSoundEmittersHighwaterMark - Global counter tracking the current free sound emitter index for the highwater mark.`
  - `setSound_emitterInfo - Engine call to configure a sound emitter with stop, pitch, volume, sample, loop and start settings.`
  - `ig3d_SetMode_i - Engine call naming the mode property being set on an object.`
  - `isFemale - Function used to adjust zombie voice pitch for female zombies.`
- **Keep / port / drop:** keep — reusable sound emitter and zombie voice configuration code for reuse in new engines.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets scene sound damping parameters and a global sound emitter counter value at file load.
- **Uses:** `setSceneInfo`, `IG3D_SOUND_DAMPING`, `gSoundEmittersHighwaterMark`
- **Reusable:** yes

### assign_free_sound_emitter
- **Does:** Returns the current free sound emitter for the highwater mark index, then increments the highwater mark counter and resets it to 1 if the counter exceeds the number of sound emitters.
- **Uses:** `gSoundEmitters`, `gSoundEmittersHighwaterMark`, `ig3d_SetMode_i`, `print`
- **Reusable:** no

### rts_play_zombie_ambient_sound
- **Does:** Configures the zombie object's voice sound emitter with stop, pitch, volume, sample path, loop and start settings, adjusting pitch for female zombies.
- **Uses:** `setSound_emitterInfo`, `IG3D_STOP`, `IG3D_PITCH`, `IG3D_VOLUME`, `IG3D_SAMPLE`, `IG3D_LOOP`, `IG3D_START`, `isFemale`, `obj.voiceSndEmt`, `Data/Sounds/zombie.ogg`
- **Reusable:** yes

### Procedural
- No section created: no asset generation from numbers or rules is performed in this file.
