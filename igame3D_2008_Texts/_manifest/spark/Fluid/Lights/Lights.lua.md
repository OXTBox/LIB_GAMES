<!-- Spark first-look of Data/Fluid/Lights/Lights.lua (model spark-x2.6-4b, 2026-11-12 22:39). DRAFT for Claude to review. -->

## Lights.lua
- **Kind:** ui-dialog
- **Purpose:** This file implements the FLTK-based light editing and management interface for iGame3D, providing UI widgets for selecting lights, editing light attributes, toggling visibility, and configuring light settings. It sets up the light editor window, builds the light input controls, and runs the initial light configuration to enable light rendering.
- **Depends on:** `gLightEditMode`, `gChosenLight`, `gLightEditMode`, `gLabelTable`, `gLightEditMode`, `gChosenLight`, `gLightEditMode`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`, `gLabelTable`,

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 10

### Top level
- **Does:** Sets the light attribute list, quote character, light edit mode and chosen light globals at file start.
- **Uses:** `lightAttributes={"Position","Ambient","Diffuse","Specular","Spot","Attenuate"}`, `quote ='"'`, `gLightEditMode = "Position"`, `gChosenLight = 1`
- **Reusable:** yes

### MaxOfOne
- **Does:** Converts a value to a number, returns 1 when the number is at least 1, otherwise returns nothing.
- **Uses:** `tonumber(w)`
- **Reusable:** yes

### getLight
- **Does:** Increments the chosen light index, selects the matching light in the engine, and refreshes the light attribute display.
- **Uses:** `gChosenLight`, `ig3d_SetSelection_s("light "..gChosenLight)`, `displayLightAttribute()`
- **Reusable:** no

### lightsVisibility
- **Does:** Reads the lights visibility label, toggles the lights visibility state and label, and calls the engine lights visibility toggle.
- **Uses:** `lightsVisible`, `w:label()`, `ig3d_ShowLights_b(true)`, `ig3d_ShowLights_b(false)`
- **Reusable:** no

### lightBtnClicked
- **Does:** Sets the light edit mode from the clicked button label, hides all light attribute groups, resets their toggle values, enables the button, and refreshes the light attribute display.
- **Uses:** `gLightEditMode`, `w:label()`, `lightPositionGrp:hide()`, `lightAmbientGrp:hide()`, `lightDiffuseGrp:hide()`, `lightSpecularGrp:hide()`, `lightSpotGrp:hide()`, `lightAttenuateGrp:hide()`, `togglePos:value(0)`, `toggleAmb:value(0)`, `toggleDif:value(0)`, `toggleSpec:value(0)`, `toggleSpot:value(0)`, `toggleAtten:value(0)`, `w:value(1)`, `displayLightAttribute()`
- **Reusable:** no

### enableButtonClicked
- **Does:** Reads the current light enabled state, toggles it via the engine light info setters, enables the button, and redraws the lights window.
- **Uses:** `gChosenLight`, `getLightInfo(gChosenLight,IG3D_ENABLED)`, `setLightInfo(gChosenLight,IG3D_ENABLED, false)`, `setLightInfo(gChosenLight,IG3D_ENABLED, true)`, `w:value(1)`, `lightswindow:redraw()`
- **Reusable:** no

## Part 2 of 10

### displayLightAttribute
- **Does:** Opens the light editor window, reads and prints light state, updates the enable switch, reads light attributes by property, and shows the relevant light editing group with its values.
- **Uses:** `lightswindow`, `GLEM`, `gLightEditMode`, `gChosenLight`, `getLightInfo`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_SPOTLIGHT`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `lightenableswitch`, `lightPositionGrp`, `lightxpos`, `lightypos`, `lightzpos`, `lightwpos`, `lightAmbientGrp`, `lightramb`, `lightgamb`, `lightbamb`, `lightaamb`, `lightDiffuseGrp`, `lightdiffuser`, `lightdiffuseg`, `lightdiffuseb`, `lightdiffusea`, `lightSpecularGrp`, `lightspecularr`, `lightspecularg`, `lightspecularb`, `lightspeculara`, `lightSpotGrp`, `lightspotdx`, `lightspotdy`, `lightspotdz`, `lightspotcutoff`, `lightspotexponent`, `lightAttenuateGrp`, `lightattenuatequadratic`, `lightattenuatelinear`, `lightattenuateconstant`, `lightswindow:redraw`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 10

### Top level
- **Does:** Sets up the lights window and label table before the light input handler runs.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`
- **Reusable:** no

### handleLightInput
- **Does:** Handles light editing input by switching light modes, reading widget values, updating light info, and redrawing the UI.
- **Uses:** `lightswindow`, `gLightEditMode`, `togglePos`, `lightxpos`, `lightypos`, `lightzpos`, `lightwpos`, `setLightInfo`, `gChosenLight`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_SPOTLIGHT`, `getLightInfo`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `displayLightAttribute`, `lightswindow:redraw`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 10

### handleLightInput (continued)
- **Does:** Builds the Lights UI panel: creates the light choice and attribute button group widgets, adds their labels to the shared gLabelTable, and wires their callbacks to getLight and lightBtnClicked.
- **Uses:** gLabelTable, lightswindow, fltk widget constructors and methods (label, resize, when, callback, down_box, labelsize, align, textsize, size_range), getLight, lightBtnClicked
- **Reusable:** no
- **Procedural:** no

## Part 5 of 10

### handleLightInput (continued)
- **Does:** This section continues the light input handling by creating and configuring FLTK UI widgets for light position and ambient settings, wiring their callbacks to `handleLightInput`, and updating the shared `gLabelTable` with their labels.
- **Uses:** `fltk:Fl_Group`, `fltk:Fl_Value_Input`, `fltk:Fl_Button`, `gLabelTable`, `handleLightInput`, `lightBtnClicked`, `table.insert`, `toggleAtten:resize`, `toggleAtten:callback`, `toggleAtten:label`, `toggleAtten:down_box`, `toggleAtten:labelsize`, `Fl_Group:current`, `lightPositionGrp:resize`, `lightPositionGrp:labelsize`, `lightPositionGrp:align`, `lightxpos:label`, `lightxpos:callback`, `lightxpos:resize`, `lightxpos:labelsize`, `lightxpos:align`, `lightxpos:minimum`, `lightxpos:maximum`, `lightxpos:step`, `lightxpos:value`, `lightxpos:textsize`, and the same configuration pattern for `lightypos`, `lightzpos`, `lightwpos`.
- **Reusable:** no
- **Procedural:** no

## Part 6 of 10

### handleLightInput (continued)
- **Does:** Builds the light intensity input widgets, registers their labels in `gLabelTable`, and wires each to `handleLightInput`, then positions the group and its child inputs.
- **Uses:** `fltk:Fl_Value_Input`, `gLabelTable`, `table.insert`, `handleLightInput`, `Fl_Group:current`, `Fl_Group`
- **Reusable:** yes
- **Procedural:** no

## Part 7 of 10

### handleLightInput (continued)
- **Does:** Builds the light control UI widgets and wires their callbacks to `handleLightInput`, then positions the current FLTK group under the main group.
- **Uses:** `fltk:Fl_Value_Input`, `fltk:Fl_Group`, `gLabelTable`, `handleLightInput`, `Fl_Group`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 10

### handleLightInput (continued)
- **Does:** Builds the light spot control group and its value input widgets, each wired to handleLightInput, and registers their labels in gLabelTable.
- **Uses:** fltk:Fl_Group, fltk:Fl_Value_Input, gLabelTable, handleLightInput, table.insert
- **Reusable:** no
- **Procedural:** no

## Part 9 of 10

### Top level
- **Does:** Builds the light settings window widgets and wires their callbacks, then shows the window and adds light choice entries.
- **Uses:** `fltk:Fl_Value_Input`, `fltk:Fl_Group`, `fltk:Fl_Repeat_Button`, `gLabelTable`, `handleLightInput`, `lightsVisibility`, `lightswindow`, `lightChoice`, `table.insert`, `Fl_Group:current`, `Fl_Group:current():parent()`, `add`
- **Reusable:** no
- **Procedural:** no

## Part 10 of 10

### Top level
- **Does:** Sets initial values for light choice and enable switches, hides light groups, shows the lights window, runs the light attribute display, enables light rendering, selects a light, and exits the FLTK loop.
- **Uses:** `lightChoice`, `lightenableswitch`, `lightAmbientGrp`, `lightDiffuseGrp`, `lightSpecularGrp`, `lightSpotGrp`, `lightAttenuateGrp`, `togglePos`, `lightswindow`, `displayLightAttribute`, `ig3d_ShowLights_b`, `getLight`, `Fl:run`
- **Reusable:** no
- **Procedural:** no
