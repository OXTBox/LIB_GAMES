<!-- Spark first-look of Data/Scripts/Functions/particlesbrowser_functions.lua (model spark-x2.6-4b, 2026-11-12 15:21). DRAFT for Claude to review. -->

## particlesbrowser_functions.lua
- **Kind:** tool
- **Purpose:** This file implements the particle emitter browser for iGame3D, letting a programmer select, edit, run, and save particle emitters through UI widgets and menu actions. It manages emitter source files, emitter attribute values, and particle emitter lifecycle controls, and drives the particle browser window and related menus.
- **Depends on:** `Data/` folder paths for emitter files, FLTK UI files and their Lua code, engine calls for emitter/particle info and texture loading, shared globals such as `gObjects`, `gParticleBrowser`, and the `ParticleBrowser` UI object; `loadLevel` and `dofile` for loading level scripts and files.
- **Provides:** Functions for emitter list and value browsing (`EmitBrowserValueCatch`, `updateEmitterListBrowser`, `CurParticleInfo`, `emitterSourceList`, `PickedParticleAttribute`, `ValueListCallback`, `readEmitterFile`, `pickEmissionSource`, `NewEmissionSource`, `RenameEmitter`, `EMTAttPicked`, `SetEmitterSource`, `MakeEmitter`, `DuplicateEmitter`, `runButton`, `stopButton`, `stopParticle`, `clearParticle`, `runParticle`, `changeVal`, `valInput`, `changeBool`, `particleBoolBtnPick`, `handle_particle_browser`, `SaveEmitterSource`, `particleSaveButtonClick`, `listPNGFiles`, `pngLoad`, `updateTexture`, `updatePNGPreviewBox`, `browserControlDoubleClicked`, `browserControlClicked`, `ParticlesMakePick`, `emitterListBrowserCallback`, `fillParticlesSourceMenu`, `fillParticlesControlMenu`, `particlesCurrentPick`, `particlesAllMenuPick`, `particlesEmittersMenuPick`, `particles_menu_callback`, `particles_MenuBarFill`, `emtFileBrowserCallback`, `ParticleBrowserShow`; UI state globals for the particle browser.
- **Assets it needs:** Emitters (`.emt` files), Images (PNG files), Sounds (none named), Fonts (none named), Models (none named).
- **Procedural:** yes — generates emitter entries from emitter source files and emitter list lines, builds emitter attribute value lists from parsed emitter files, and constructs emitter source/control menu options from the engine's emitter data.
- **Glossary:**
  - emitter - A particle emission source defined by a `.emt` file with attribute and value settings.
  - emitter source - The `.emt` file path that defines an emitter's settings.
  - particle emitter - A running or selectable particle emission source tracked in the particle browser.
  - emitter attribute - A named setting (model, amount, life, etc.) inside an emitter file.
  - emitter value - A value paired with an emitter attribute in an emitter file.
  - ParticleBrowser - The FLTK UI window for browsing and editing particle emitters.
  - IG3D_... - Engine property constants used to read/set object properties such as position, rotation, text, and info.
- **Keep / port / drop:** keep - Core emitter browser logic and UI flow are reusable as a reference for building particle editing tools in a new engine.

---

# Part notes

## Part 1 of 18

### Top level
- **Does:** Defines file-level globals for the particle browser, including selection state, emitter and particle value tracking, path constants, and UI state variables.
- **Uses:** Globals such as `gObjName`, `gCurSel`, `gSelectedParticle`, `gAttributePicked`, `gEVals`, `particleFieldValues`, `gEmitterFileValues`, `gEmitterFileAttributes`, `lastPushed`, `storedSingleSelect`, `dragged`, `gLastBrowserControlClick`, `gLastSelection`, `ParticleBrowserFileList`, `gParticleFilesShortNames`, `gEmissionSource`, `gEmissionSourcePath`, `gParticleValues`, `gParticleAttributes`, `gSelParticleData`, `gBrowserImagesPath`, `gBrowserEMTPath`, `gBrowserImagesFiles`, `gBrowserEMTFiles`, `gCatchModelPath`, `gCatchTexturePath`, `gEmtFileBrowserLines`, `gSourceRequest`, `gEmitterNewName`, `gNewEmitterValueItems`, `gEmitterValueItems`, `gOldInfo`, and the engine call `ig3d_GetSelection__s()`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 18

### Top level
- **Does:** The file contains a single function, `EmitBrowserValueCatch`, which collects values from various UI elements and rebuilds the emitter value item list.
- **Uses:** `particleFieldValues`, `EmitterListBrowser`, `EmitAttListBrowser`, `emtFileBrowser`, `BoolBtn`, `ParticleValInputA`, `ParticleValInputB`, `ParticleValInputC`, `ParticleValInputD`, `NameInput`, `gEmitterValueItems`, `gNewEmitterValueItems`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 18

### ParticleBrowserWindowUpdate
- **Does:** Updates the Particle Browser window based on the requested argument, refreshing emitter and attribute lists, restoring selected values, and applying any changes made by the browser.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `gParticleFilesShortNames`, `gParticleAttributes`, `gParticleValues`, `gParticleEmitters`, `gSelectedParticle`, `gEmitterSourcePath`, `gOldInfo`, `gSelectedParticleInfo`, `gSourceRequest`, `emtFileBrowser`, `SourceNameInput`, `EmitAttListBrowser`, `ValueListBrowser`, `EmitterListBrowser`, `particleFieldValues`, `fltk_update`, plus engine globals and FLTK widget calls.
- **Reusable:** no
- **Procedural:** no

## Part 4 of 18

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### CurParticleInfo
- **Does:** Loads the particle emitter list, selects a particle by index or existing selection, fetches emitter info, sets the selected object name, reads emitter attributes from the info text, and updates the particle browser window.
- **Uses:** `ig3d_GetParticle_emittersList__s`, `ig3d_GetParticle_emitterInfo_s_s`, `ig3d_SetSelection_s`, `getlinecount`, `getlineof`, `string.find`, `string.sub`, `table.insert`, `ParticleBrowserWindowUpdate`, `particleFieldValues`, `gSelectedParticle`, `gSelectedParticleInfo`, `gObjName`, `gEmitterSourcePath`, `gParticleValues`, `gParticleAttributes`, `gSelParticleData`, `EmitterInfoLineCount`, `EmitterLineN`, `EmitterAttributeName`, `EmitterAttributeValue`, `gCatchTexturePath`, `gCatchModelPath`, `SourceNameInput:value()`, `listFiles`
- **Reusable:** no

### emitterSourceList
- **Does:** Lists emitter files in the specified emitter directory, strips the last 5 characters from each file name to create short names, and stores them in shared tables.
- **Uses:** `ParticleBrowser:make_current`, `gameroot`, `listFiles`, `string.sub`, `table.insert`, `ParticlesinDir`, `ParticlesFileList`, `gParticleFilesShortNames`
- **Reusable:** yes
- **Procedural:** yes

## Part 5 of 18

### updateEmitterListBrowser
- **Does:** Runs the emitter list browser update, clears the stored emitter list, reads the emitter list from the engine, counts its lines, and appends each non-nil line name to the particle emitter list table, then refreshes the particle browser window.
- **Uses:** `EmitBrowserValueCatch`, `gParticleEmitters`, `ig3d_GetParticle_emittersList__s`, `getlinecount`, `getlineof`, `ParticleBrowserWindowUpdate`
- **Reusable:** no
- **Procedural:** no

## Part 6 of 18

### Top level
- **Does:** Contains no setup, global definitions, widget definitions, or other code outside the `PickedParticleAttribute` function.
- **Uses:** nothing
- **Reusable:** no

### PickedParticleAttribute
- **Does:** Renders the picked particle attribute UI based on the selected attribute index, showing or hiding relevant groups and widgets, and populates the value browser with the attribute's value.
- **Uses:** `ParticleBrowser`, `particleFieldValues`, `gSelectedParticleInfo`, `CurParticleInfo`, `gParticleValues`, `gParticleAttributes`, `ParticleValInputA` through `ParticleValInputD`, `EmitterValueGroup`, `NameInput`, `MakeEmitterBtn`, `EmitterSourceGroup`, `EmissionInputGroup`, `EmitterTextureGroup`, `EmitterSaveAsGroup`, `CurValBrowser`, `ParticleBrowserWindowUpdate`, `gSourceRequest`, `emtFileBrowser`, `listPNGFiles`, `pngPreviewBox`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 18

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file beyond the two function definitions.
- **Uses:** nothing
- **Reusable:** no

### ValueListCallback
- **Does:** Validates the value passed to the callback, then drives the EmitAttListBrowser and EmitBrowserValueCatch UI elements, selects the attribute, and triggers PickedParticleAttribute for the particle field value at index 2.
- **Uses:** `ParticleBrowser` (global), `EmitAttListBrowser` (global), `EmitBrowserValueCatch` (global), `PickedParticleAttribute` (global), `particleFieldValues` (global)
- **Reusable:** no

### readEmitterFile
- **Does:** Reads an emitter file, normalizes its line endings, rewrites it with normalized line endings, parses the file into attribute and value pairs, and triggers ParticleBrowser redraw.
- **Uses:** `io.open` (engine file I/O), `string.gsub`, `string.find`, `string.sub`, `string.len`, `string.char`, `tostring`, `table.insert`, `ParticleBrowser` (global), `gameroot` (global), `gEmitterFileValues` (global), `gEmitterFileAttributes` (global), `Attrline` (local variable)
- **Reusable:** no
- **Procedural:** yes
- **Note:** The function contains a marked DEFECTIVE comment and contains redundant duplicate reads/writes of the file, so reuse requires careful validation of the implementation.

## Part 8 of 18

### Top level
- **Does:** The file contains three functions: pickEmissionSource, NewEmissionSource, and RenameEmitter, with no additional setup, globals, or widget definitions outside these functions.
- **Uses:** nothing
- **Reusable:** no

### pickEmissionSource
- **Does:** Selects an emission source from the particle browser, updates the selected particle emitter info, saves and restarts the level, then restarts the particle emitter and refreshes the emitter list browser.
- **Uses:** `ParticleBrowser:make_current()`, `EmitBrowserValueCatch()`, `CurParticleInfo()`, `emitterSourceList()`, `SourceNameInput:value()`, `gEmitterSourcePath`, `gSelParticleData`, `gSelectedParticle`, `gSelectedParticleInfo`, `get(ig3d_particle_emitter, ...)`, `ig3d_SetParticle_emitterInfo_2s()`, `ig3d_GetParticle_emitterInfo_s_s()`, `save_level()`, `restartbutton()`, `updateEmitterListBrowser()`, `fltk_update()`, and the `Data/` path prefix `"Data/Emitters/"`.
- **Reusable:** yes
- **Procedural:** no

### NewEmissionSource
- **Does:** Creates a new emission source by setting the emitter source path, updates the selected particle emitter info, saves and restarts the level, then restarts the particle emitter and refreshes the emitter list browser.
- **Uses:** `ParticleBrowserWindowUpdate("newEmissionSource")`, `CurParticleInfo()`, `gEmitterSourcePath`, `string.find()`, `setParticle_emitterInfo()`, `gSelParticleData`, `get(ig3d_particle_emitter, ...)`, `ig3d_SetParticle_emitterInfo_2s()`, `save_level()`, `restartbutton()`, `fltk_update()`, and the `Data/` path prefix `"Data/Emitters/"`.
- **Reusable:** yes
- **Procedural:** no

### RenameEmitter
- **Does:** Renames the selected particle emitter by updating the selected particle emitter info, saves and restarts the level, then refreshes the emitter list browser and updates the particle info display.
- **Uses:** `ParticleBrowser:make_current()`, `EmitBrowserValueCatch()`, `CurParticleInfo()`, `gSelParticleData`, `get(ig3d_particle_emitter, ...)`, `ig3d_SetParticle_emitterInfo_2s()`, `ig3d_GetParticle_emitterInfo_s_s()`, `save_level()`, `restartbutton()`, `updateEmitterListBrowser()`, `CurParticleInfo()`, `fltk_update()`.
- **Reusable:** yes
- **Procedural:** no

## Part 9 of 18

### Top level
- **Does:** Contains the two functions `EMTAttPicked` and `SetEmitterSource` for the particle browser script.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `PickedParticleAttribute`, `particleFieldValues`, `gAttributePicked`, `gEmissionSource`, `ParticlesFileList`, `sourceListBrowser`, `gSelectedParticleInfo`, `gSelectedParticle`, `ig3d_SetParticle_emitterInfo_2s`, `get`, `setParticle_emitterInfo`, `IG3D_START`, `string.gmatch`, `string.find`, `string.sub`, `string.gsub` (via string concatenation), `lfs.dir` (not present in this code), `Data/Emitters/` path construction, `ig3d_particle_emitter`, `ig3d_object`, `ig3d_text_box` (not present in this code).
- **Reusable:** no
- **Procedural:** no

### EMTAttPicked
- **Does:** Handles picking an emitter attribute value from the particle browser, making the current particle browser, reading the selected value, emitting the browser value catch, storing the picked attribute, and applying the picked particle attribute to the specified particle field.
- **Uses:** `ParticleBrowser`, `ParticleBrowser:make_current()`, `w:value()`, `EmitBrowserValueCatch()`, `PickedParticleAttribute`, `particleFieldValues`, `gAttributePicked`, `w` (widget parameter).
- **Reusable:** no
- **Procedural:** no

### SetEmitterSource
- **Does:** Sets the emitter source for the selected particle, builds the selected particle attribute string by extracting each line from the selected particle info, updates the emitter info with the new source path, and sets the start info for the running particle emitter.
- **Uses:** `ParticleBrowser`, `gEmissionSource`, `ParticlesFileList`, `sourceListBrowser:value()`, `gSelectedParticleInfo`, `gSelectedParticle`, `ig3d_SetParticle_emitterInfo_2s`, `get`, `setParticle_emitterInfo`, `IG3D_START`, `string.gmatch`, `string.find`, `string.sub`, `string` concatenation, `Data/Emitters/` path construction, `ig3d_particle_emitter`.
- **Reusable:** no
- **Procedural:** no

## Part 10 of 18

### Top level
- **Does:** No top-level code outside the `MakeEmitter` function; the file contains only the function definition.
- **Uses:** `ParticleBrowser`, `gEmitterSourcePath`, `gParticleValues`, `gParticleNamesAndEMTs`, `gParticleEmitters`, `gSelectedParticle`, `gObjName`, `ig3d_GetParticle_emittersList__s`, `getlinecount`, `getlineof`, `string.find`, `string.sub`, `make`, `ig3d_SetSelection_s`, `ig3d_GetSelection__s`, `setParticle_emitterInfo`, `IG3D_START`, `EmitterListBrowser`, `particleFieldValues`, `updateEmitterListBrowser`, `runButton`
- **Reusable:** no

### MakeEmitter
- **Does:** Creates a new particle emitter entry by locating matching emitter source files from the emitter list, appends the new emitter to the emitter tracking tables, selects it in the UI, and updates the emitter list browser.
- **Uses:** `ParticleBrowser`, `gEmitterSourcePath`, `gParticleValues`, `gParticleNamesAndEMTs`, `gParticleEmitters`, `gSelectedParticle`, `gObjName`, `ig3d_GetParticle_emittersList__s`, `getlinecount`, `getlineof`, `string.find`, `string.sub`, `make`, `ig3d_SetSelection_s`, `ig3d_GetSelection__s`, `setParticle_emitterInfo`, `IG3D_START`, `EmitterListBrowser`, `particleFieldValues`, `updateEmitterListBrowser`, `runButton`
- **Reusable:** no
- **Procedural:** no

## Part 11 of 18

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the four listed functions.
- **Uses:** nothing
- **Reusable:** no

### DuplicateEmitter
- **Does:** Duplicates the selected emitter by locating its source `.emt` path, counting matching emitter entries, and appending the matched emitter to the particle emitter list with a new object.
- **Uses:** `ParticleBrowser`, `PickedParticleAttribute`, `CurParticleInfo`, `gEmitterSourcePath`, `gParticleValues`, `ig3d_GetParticle_emittersList__s`, `getlinecount`, `string.find`, `string.sub`, `getlineof`, `gSelectedParticle`, `gParticleNamesAndEMTs`, `gParticleEmitters`, `make`, `ig3d_SetSelection_s`, `setParticle_emitterInfo`, `ig3d_GetSelection__s`, `updateEmitterListBrowser`
- **Reusable:** no

### runButton
- **Does:** Retrieves the currently selected particle emitter and sets its start state.
- **Uses:** `get`, `setParticle_emitterInfo`, `IG3D_START`
- **Reusable:** no

### stopButton
- **Does:** Retrieves the currently selected particle emitter and sets its stop state.
- **Uses:** `get`, `setParticle_emitterInfo`, `IG3D_STOP`
- **Reusable:** no

### stopParticle
- **Does:** Stops the particle emitter identified by the given line number in the emitter list.
- **Uses:** `ig3d_GetParticle_emittersList__s`, `getlinecount`, `getlineof`, `get`, `setParticle_emitterInfo`, `IG3D_STOP`
- **Reusable:** no

### clearParticle
- **Does:** Stops the particle emitter identified by the given index and clears its particles.
- **Uses:** `get`, `setParticle_emitterInfo`, `IG3D_STOP`, `IG3D_CLEAR_PARTICLES`
- **Reusable:** no

## Part 12 of 18

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code exists in this file; the file contains only the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### runParticle
- **Does:** Retrieves the particle emitter list, reads the nth line of the list, and if the line is not nil, loads the corresponding particle emitter and sets its start property.
- **Uses:** `ig3d_GetParticle_emittersList__s()`, `getlinecount`, `getlineof`, `get(ig3d_particle_emitter, pname)`, `setParticle_emitterInfo`, `IG3D_START`, global `runningParticle`
- **Reusable:** no

### changeVal
- **Does:** Validates the ParticleBrowser is loaded, emits a browser value catch event, then reads the selected particle field, updates the corresponding emitter value based on the field index, writes the updated field values to a string, sets the particle emitter info with the string, and refreshes the render and UI.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `particleFieldValues`, `setVal`, `gSelectedParticleInfo`, `CurParticleInfo`, `gSelParticleData`, `gParticleValues`, `gParticleAttributes`, `get(ig3d_particle_emitter, gSelectedParticle)`, `ig3d_SetParticle_emitterInfo_2s`, `render`, `fltk_update`
- **Reusable:** no

### valInput
- **Does:** Validates the ParticleBrowser is loaded, emits a browser value catch event, builds a comma-separated string from the new emitter value items, and passes that string to changeVal.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `gNewEmitterValueItems`, `changeVal`
- **Reusable:** no

## Part 13 of 18

### Top level
- **Does:** No top-level code outside the three function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### changeBool
- **Does:** Changes the boolean value of a selected particle emitter's field value, by reading the current value, rebuilding the field value string with the new boolean, and writing it back to the emitter.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `gSelectedParticle`, `gSelectedParticleInfo`, `gOldSel`, `gCurSel`, `runningParticle`, `changeLine`, `particleFieldValues`, `setParticle_emitterInfo`, `getlinecount`, `getlineof`, `get`, `setVal`, `ig3d_SetParticle_emitterInfo_2s`, `ig3d_GetParticle_emitterInfo_s_s`, `fltk_update`
- **Reusable:** yes - it implements a reusable boolean field value update flow for particle emitters.

### particleBoolBtnPick
- **Does:** Invokes the boolean value change function with the button's current value, then updates the picked particle attribute.
- **Uses:** `ParticleBrowser`, `changeBool`, `PickedParticleAttribute`, `w:value()`
- **Reusable:** yes - it is a small reusable button action wrapper.

### handle_particle_browser
- **Does:** Sets the particle browser as the current browser, handles selection changes after an "o" click, and refreshes the emitter list browser with a UI update.
- **Uses:** `ParticleBrowser`, `click`, `gCurSel`, `gOldSel`, `ig3d_GetSelection__s`, `updateEmitterListBrowser`, `fltk_update`
- **Reusable:** yes - it is a reusable browser lifecycle handler.

## Part 14 of 18

### Top level
- **Does:** No setup, globals, widget definitions or other code outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### SaveEmitterSource
- **Does:** Saves the current particle emitter source settings to a file, then refreshes the emitter source list. It only writes the existing emitter data and updates the selected emitter path if the current source name differs from the stored one.
- **Uses:** `ParticleBrowser`, `SourceNameInput`, `gSelectedParticleInfo`, `gSelParticleData`, `gEmitterSourcePath`, `gameroot`, `io.open`, `emitterSourceList`, `NewEmissionSource` (only referenced in commented-out code)
- **Reusable:** no

### particleSaveButtonClick
- **Does:** Triggers saving of the current emitter source, refreshes the emitter source list, hides the emitter save-as-group widget and shows the emitter value group widget.
- **Uses:** `ParticleBrowser`, `SaveEmitterSource`, `emitterSourceList`, `EmitterSaveAsGroup`, `EmitterValueGroup`
- **Reusable:** no

### listPNGFiles
- **Does:** Clears the particle browser image file list, scans the configured image path directory with `lfs.dir`, and adds matching PNG files and subdirectories to the browser file list and the tracked file list.
- **Uses:** `ParticleBrowser`, `gBrowserImagesFiles`, `pngFileBrowser`, `lfs.dir`, `lfs.attributes`, `gBrowserImagesPath`
- **Reusable:** yes

### pngLoad
- **Does:** Loads the selected image file from the tracked file list into the engine texture system, records the loaded texture path for later use. It returns early if no file is selected or the selected entry is a directory.
- **Uses:** `ParticleBrowser`, `pngFileBrowser`, `gBrowserImagesFiles`, `gObjects`, `loadTexture`, `gCatchTexturePath`, `gameroot`
- **Reusable:** yes

## Part 15 of 18

### Top level
- **Does:** No top-level code outside the four listed functions; the file contains only the function definitions for updateTexture, updatePNGPreviewBox, browserControlDoubleClicked, and browserControlClicked.
- **Uses:** nothing

### updateTexture
- **Does:** Loads the PNG texture for the particle browser, updates the texture path value, and refreshes the FLTK UI.
- **Uses:** `ParticleBrowser` (global), `pngLoad()`, `loadTexture(gCatchTexturePath)`, `changeVal(gCatchTexturePath)`, `fltk_update()`
- **Reusable:** yes

### updatePNGPreviewBox
- **Does:** Registers shared images, resolves the PNG path for a given name, updates the PNG preview box with the image, refreshes dependent UI elements, and triggers texture and UI updates.
- **Uses:** `ParticleBrowser` (global), `fltk.fl_register_images()`, `gBrowserImagesPath`, `string.sub(name, 1,-5)`, `Fl_Shared_Image.get(a..b,128,128)`, `Fl_Shared_Image.get(gameroot.."Data/Images/Colors/white.png")`, `pngPreviewBox`, `EmitterTextureGroup`, `updateTexture()`, `fltk_update()`
- **Reusable:** yes

### browserControlDoubleClicked
- **Does:** When the browser control is double-clicked, navigates the image folder path based on the selected file, then refreshes the PNG file list.
- **Uses:** `gBrowserImagesFiles`, `gBrowserImagesPath`, `goDirsUp(gBrowserImagesPath, 1)`, `listPNGFiles()`
- **Reusable:** yes

### browserControlClicked
- **Does:** When the browser control is clicked, opens the selected PNG file for preview if it is a file, then handles rapid repeated clicks to trigger folder navigation.
- **Uses:** `w:value()`, `gBrowserImagesFiles`, `time()`, `gLastBrowserControlClick`, `gLastSelection`, `browserControlDoubleClicked()`
- **Reusable:** yes

## Part 16 of 18

### Top level
- **Does:** Defines the shared particle menu state tables and the particle source/control menu population functions; no standalone setup or global definitions outside these functions.
- **Uses:** `ParticlesMenu`, `ParticleBrowser`, `ParticlesMenuIndex`, `ParticlesMenuText`, `gParticleNamesAndEMTs`, `gParticleEmitters`, `gSelectedParticle`, `gObjName`, `gCurSel`, `ig3d_GetParticle_emittersList__s()`, `getlinecount`, `getlineof`, `string.find`, `string.len`, `make(ig3d_particle_emitter, ...)`, `ig3d_SetSelection_s`, `setParticle_emitterInfo`, `ig3d_GetSelection__s`, `updateEmitterListBrowser`, `ParticlesMenu:add`, `ParticlesMenu:redraw`, `ParticlesMenu:value`, `get(ig3d_particle_emitter, ...)`, `CurParticleInfo`, `PickedParticleAttribute`, `print`.
- **Reusable:** no

### ParticlesMakePick
- **Does:** Creates and selects a particle emitter for the given emitter name, records its source path and particle name, and refreshes the emitter list browser.
- **Uses:** `gEmitterSourcePath`, `ig3d_GetParticle_emittersList__s()`, `getlinecount`, `getlineof`, `string.find`, `string.len`, `gSelectedParticle`, `gParticleNamesAndEMTs`, `gParticleEmitters`, `make(ig3d_particle_emitter, ...)`, `gObjName`, `ig3d_SetSelection_s`, `setParticle_emitterInfo`, `ig3d_GetSelection__s`, `gCurSel`, `updateEmitterListBrowser`.
- **Reusable:** yes

### emitterListBrowserCallback
- **Does:** Prints the current emitter list value, returns early if the particle browser is not initialized, then loads the selected emitter's particle info and refreshes its attributes.
- **Uses:** `print`, `ParticleBrowser`, `w:value()`, `get(ig3d_particle_emitter, gSelectedParticle)`, `CurParticleInfo`, `PickedParticleAttribute`.
- **Reusable:** no

### fillParticlesSourceMenu
- **Does:** Populates the particle source menu with the Make, Save, and Duplicate options, adds a blank separator line, and redraws the menu.
- **Uses:** `ParticleBrowser`, `ParticlesMenuText.Source`, `ParticlesMenu`, `ParticlesMenuIndex`, `ParticlesMenu:add`, `ParticlesMenu:redraw`.
- **Reusable:** yes

### fillParticlesControlMenu
- **Does:** Populates the particle control menu with Run, Stop, and Clear options, adds blank separator lines, adds an All section with the same control options, and redraws the menu.
- **Uses:** `ParticleBrowser`, `ParticlesMenuText.Control`, `ParticlesMenu`, `ParticlesMenuIndex`, `ParticlesMenu:add`, `ParticlesMenu:redraw`.
- **Reusable:** yes

## Part 17 of 18

### Top level
- **Does:** No top-level code outside the three particle menu functions; the file contains only the function definitions listed below.
- **Uses:** nothing
- **Reusable:** no

### particlesCurrentPick
- **Does:** Handles particle emitter pick actions: stops or clears particles for a selected emitter, starts the emitter and sets gravity, or stops it, then renders the scene after each action.
- **Uses:** `get(ig3d_particle_emitter, gSelectedParticle)`, `setParticle_emitterInfo`, `render`, globals `runningParticle`, `emitter`, `gSelectedParticle`
- **Reusable:** no

### particlesAllMenuPick
- **Does:** Iterates over all particle emitters in the particle list, stopping, clearing, or running every emitter based on the selected menu action, rendering after each emitter is processed.
- **Uses:** `ig3d_GetParticle_emittersList__s`, `getlinecount`, `stopParticle`, `clearParticle`, `runParticle`, `render`
- **Reusable:** no

### particlesEmittersMenuPick
- **Does:** Handles particle emitter menu actions: saves the current emitter configuration, opens the emitter source browser and shows the source list, or duplicates the emitter via the MakeEmitter function.
- **Uses:** `ParticleBrowser`, `CurParticleInfo`, `PickedParticleAttribute`, `EmissionInputGroup`, `EmitterSourceGroup`, `EmitterValueGroup`, `EmitterTextureGroup`, `EmitterSaveAsGroup`, `emtFileBrowser`, `gSourceRequest`, `ValueListBrowser`, `emitterSourceList`, `ParticleBrowserWindowUpdate`, `MakeEmitter`
- **Reusable:** no

## Part 18 of 18

### Top level
- **Does:** No top-level code outside the three function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### particles_menu_callback
- **Does:** Handles the particle emitters menu selection callback, reads the selected menu value and text, maps the value to menu index values, and dispatches to the appropriate particle menu pick functions based on the selected menu head.
- **Uses:** `ParticleBrowser`, `ParticlesMenuIndex`, `ParticlesmenuHead`, `particlesEmittersMenuPick`, `particlesCurrentPick`, `particlesAllMenuPick`, `item`, `Fl:check`, `io.flush`
- **Reusable:** no

### particles_MenuBarFill
- **Does:** Fills the particle emitters menu bar by invoking the particle source menu and particle control menu fill functions.
- **Uses:** `ParticleBrowser`, `fillParticlesSourceMenu`, `fillParticlesControlMenu`
- **Reusable:** no

### emtFileBrowserCallback
- **Does:** Handles the emitter file browser callback, catches the emitter source value, shows the make emitter button, sets the emitter source path from the selected emitter file list entry, and either picks the emission source or sets the new emitter name based on the requested action.
- **Uses:** `ParticleBrowser`, `EmitBrowserValueCatch`, `w:value`, `MakeEmitterBtn`, `gEmitterSourcePath`, `ParticlesFileList`, `gSourceRequest`, `pickEmissionSource`, `gParticleFilesShortNames`, `gEmitterNewName`
- **Reusable:** no

### ParticleBrowserShow
- **Does:** Shows the particle emitters browser, initializes empty particle data structures when emitter count is missing or zero, hides the default particle browser groups, fills the menu bar, and updates the emitter list browser, then runs the picked particle attribute logic if a particle was previously selected.
- **Uses:** `gNumParticleEmitters`, `gParticleNamesAndEMTs`, `gParticlePositions`, `gParticleRotations`, `gParticleEmitters`, `gSelectedParticle`, `ParticleBrowser`, `particles_MenuBarFill`, `emitterSourceList`, `updateEmitterListBrowser`, `PickedParticleAttribute`
- **Reusable:** no
