<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Events.lua (model spark-x2.6-4b, 2026-11-12 16:28). DRAFT for Claude to review. -->

## RTS_Events.lua
- **Kind:** library
- **Purpose:** This file defines event task helpers for the RTS game, including tasks that set object actions and event timeouts for stunned, finish, untangle, kickhead, waitforhitbad, and hit events, plus the hitbad event task that schedules a delayed hitbad event and plays the hit sound. It also carries file-level comments stating that orders override behaviours and events override orders.
- **Depends on:** `Data/` folder paths for Scripts/RTS_Functions libraries; engine globals and functions such as `object_action_lookat`, `object_action_stab`, `object_action_sidestep`, `object_action_kick`, `object_action_punchair`, `hitbad_event`, `getObjectInfo`, `setObjectInfo`, `time`, and constants `IG3D_NAME`, `IG3D_RAGDOLL`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`; `loadLevel("Data/Levels/X")` level loading mechanism.
- **Provides:** `stunned_event`, `finishhim_event`, `untangle_event`, `kickhead_event`, `waitforhitbad_event`, `hitbad_event` functions.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none (no assets are generated from numbers or rules; only object actions, event tasks, and state settings are configured).
- **Glossary:**
  - `event task` - a task set on an object to run when a game event occurs, such as looking at, stabbing, or sidestepping a target.
  - `object_action_*` - engine calls that set a specific action on an object, e.g. `object_action_lookat` sets the look-at action.
  - `IG3D_*` - engine constants that name the property being read or set on an object, such as `IG3D_NAME` for the object's name.
  - `ragdoll` - an object type that can be enabled to apply ragdoll physics behaviour.
  - `ignore-collision` - a property that disables object collision for an object.
  - `hitbad event` - an event that triggers when an object hits a bad target, scheduled with a delay and accompanied by the hit sound.
- **Keep / port / drop:** keep - it is a reusable library of event task helpers for RTS game logic.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Contains only file-level comments describing that orders override behaviours and events override orders.
- **Uses:** nothing
- **Reusable:** no

### stunned_event
- **Does:** Sets the stunned event task to look at the target with zero position, and clears the event once the event timeout has passed.
- **Uses:** `object_action_lookat`, `getObjectInfo(obj.cObj, IG3D_NAME)`, `time()`, `IG3D_NAME`
- **Reusable:** yes

### finishhim_event
- **Does:** Sets the finish event task to stab the target with zero position, and clears the event once the event timeout has passed.
- **Uses:** `object_action_stab`, `getObjectInfo(obj.cObj, IG3D_NAME)`, `time()`, `IG3D_NAME`
- **Reusable:** yes

### untangle_event
- **Does:** Sets the untangle event task to sidestep the target at the event's stored position, and clears the event once the timeout passes; if the object is a ragdoll, zeroes the task position.
- **Uses:** `object_action_sidestep`, `getObjectInfo(obj.cObj, IG3D_RAGDOLL)`, `time()`, `IG3D_RAGDOLL`
- **Reusable:** yes

### kickhead_event
- **Does:** Sets the kickhead event task to kick the target with zero position, and clears the event once the event timeout has passed.
- **Uses:** `object_action_kick`, `getObjectInfo(obj.cObj, IG3D_NAME)`, `time()`, `IG3D_NAME`
- **Reusable:** yes

### waitforhitbad_event
- **Does:** Sets the waitforhitbad event task to punch the target with zero position, and once the timeout passes schedules the hitbad event with a 2.5 second delay and plays the hit sound if enabled.
- **Uses:** `object_action_punchair`, `hitbad_event`, `time()`, `IG3D_NAME`
- **Reusable:** yes

### Procedural:
No section

## Part 2 of 2

### Top level

### hitbad_event
- **Does:** Sets the hit event task on an object, marks the target as the object in question, schedules the event timeout, and if the object is not already a ragdoll, enables its ragdoll and ignore-collision properties; if the timeout elapses, clears the ragdoll and ignore-collision state, resets rotation and vector constraint, and clears the event.
- **Uses:** `getObjectInfo`, `setObjectInfo`, `time`, `object_action_hit`, `IG3D_RAGDOLL`, `IG3D_IGNORE_OBJECT_COLLS`, `IG3D_ROTATION`, `IG3D_VECTOR_CONSTRAINT`
- **Reusable:** no
- **Procedural:** no
