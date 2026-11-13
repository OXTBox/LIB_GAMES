<!-- Spark first-look of Data/Scripts/Functions/Menus/particles_menu_functions.lua (model spark-x2.6-4b, 2026-11-12 06:25). DRAFT for Claude to review. -->

## particles_menu_functions.lua
- **Kind:** library
- **Purpose:** This file defines the shared particle menu functions for the iGame3D engine, covering menu population, emitter control actions, and menu callback handling for the particle browser UI. It provides reusable menu configuration and control logic for particle emitter management.
- **Depends on:** Other Scripts/Functions/Menus files and engine globals set elsewhere; relies on engine calls for particle emitter operations and menu redrawing; uses the `Emitters/` and `Current/`/`All/` folder path constructions referenced by the menu population functions.
- **Provides:** `fillParticlesSourceMenu`, `fillParticlesControlMenu`, `particlesCurrentPick`, `particlesAllMenuPick`, `particlesEmittersMenuPick`, `particles_menu_callback`, plus shared particle menu state tables and source/control menu label tables.
- **Assets it needs:** Emitters folder entries (`.emt` particle settings) referenced by the source menu population; no exact model, image, sound, or font file names are named.
- **Procedural:** none
- **Glossary:**
  - `ParticleBrowser` - The shared particle emitter browser object used to populate and control particle menu UI.
  - `ParticlesMenu` - The FLTK menu widget that holds the particle source and control menu entries.
  - `ig3d_particle_emitter` - The engine object kind used to read and set particle emitter properties.
  - `IG3D_STOP`, `IG3D_CLEAR_PARTICLES`, `IG3D_START` - Engine constants naming the properties read or set on particle emitters for stop, clear, and start actions.
  - `EmissionInputGroup` - A particle emitter group used to control emitter input settings in the particle menu.
  - `EmitterSourceGroup` - A particle emitter group used to load the particle source list in the particle menu.
- **Keep / port / drop:** keep - reusable menu population and emitter control logic that other particle menu files depend on.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines shared particle menu state tables and the source/control menu labels used by the particle menu functions.
- **Uses:** nothing beyond the file's own local tables and string literals.
- **Reusable:** yes - the label tables provide reusable menu configuration for particle menus.

### fillParticlesSourceMenu
- **Does:** Populates the particles source menu with Emitters folder entries, adds a blank separator line, and redraws the menu.
- **Uses:** globals `ParticleBrowser`, `ParticlesMenu`, `ParticlesMenuIndex`, `ParticlesMenuText`; engine calls `ParticlesMenu:add` and `ParticlesMenu:redraw`; string path construction using `"Emitters/"`.
- **Reusable:** yes - the menu population logic can be reused for similar particle source menu layouts.

### fillParticlesControlMenu
- **Does:** Populates the particles control menu with Current and All control entries, adds blank separator lines, and redraws the menu.
- **Uses:** globals `ParticleBrowser`, `ParticlesMenu`, `ParticlesMenuIndex`, `ParticlesMenuText`; engine calls `ParticlesMenu:add` and `ParticlesMenu:redraw`; string path construction using `"Current/"` and `"All/"`.
- **Reusable:** yes - the menu population logic can be reused for similar particle control menu layouts.

### particlesCurrentPick
- **Does:** Handles particle emitter control actions based on the selected particle and picked control value, applying start/stop/clear emitter info and redrawing the render.
- **Uses:** globals `gSelectedParticle`, `runningParticle`, `render`; engine calls `get(ig3d_particle_emitter, gSelectedParticle)`, `setParticle_emitterInfo`, `render`; constants `IG3D_STOP`, `IG3D_CLEAR_PARTICLES`, `IG3D_START`.
- **Reusable:** no - it is specific to particle emitter control actions tied to the selected particle.

## Part 2 of 3

### Top level
- **Does:** No top-level code outside the three particle menu functions; the file contains only the function definitions listed.
- **Uses:** nothing
- **Reusable:** no

### particlesAllMenuPick
- **Does:** Handles particle emitter stop, clear and run actions based on the selected pick value, iterating over the emitter list count and calling the corresponding particle operations with a render call after clearing.
- **Uses:** Engine calls (`getlinecount`, `render`), globals (`ig3d_GetParticle_emittersList__s`, `stopParticle`, `clearParticle`, `runParticle`), no `Data/` paths.
- **Reusable:** yes

### particlesEmittersMenuPick
- **Does:** Controls emitter menu actions: hides most emitter groups, shows the save-as group for Save, or shows the source group and triggers source list loading for Make, and runs the duplicate emitter action.
- **Uses:** Engine calls (`CurParticleInfo`, `PickedParticleAttribute`, `emitterSourceList`), globals (`ParticleBrowser`, `EmissionInputGroup`, `EmitterSourceGroup`, `EmitterValueGroup`, `EmitterTextureGroup`, `EmitterSaveAsGroup`, `ValueListBrowser`, `gSourceRequest`, `ParticleBrowserWindowUpdate`), no `Data/` paths.
- **Reusable:** yes

### particles_menu_callback
- **Does:** Reads the menu widget label, value and text, maps the value to menu head indices, dispatches the pick action based on the selected menu head, and handles clear actions for All and Current menu heads.
- **Uses:** Engine calls (`item`), globals (`ParticlesMenuIndex`, `ParticlesmenuHead`, `particlesEmittersMenuPick`, `particlesCurrentPick`, `particlesAllMenuPick`, `Fl:check`, `io.flush`), no `Data/` paths.
- **Reusable:** yes

## Part 3 of 3

### particles_MenuBarFill
- **Does:** Returns early if `ParticleBrowser` is nil, otherwise fills the particles source menu and the particles control menu.
- **Uses:** globals (`ParticleBrowser`), functions (`fillParticlesSourceMenu`, `fillParticlesControlMenu`)
- **Reusable:** no
- **Procedural:** no
