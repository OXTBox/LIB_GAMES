<!-- Spark first-look of Data/Fluid/Lights/Lights.fl (model spark-x2.6-4b, 2026-11-12 22:35). DRAFT for Claude to review. -->

## Lights.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface for the iGame3D light editor, providing a window and control panel to configure light attributes such as position, ambient, diffuse, specular, spot, and attenuation. It reads and writes light properties through engine calls, handles light editing input, and manages the visibility of the lights UI.
- **Depends on:** `ig3d_SetSelection_s("light "..gChosenLight)`, `displayLightAttribute()`, `getLightInfo`, `setLightInfo`, `gLightEditMode`, `gChosenLight`, `lightswindow`, `lightChoice`, `lightenableswitch`, `lightAmbientGrp`, `lightDiffuseGrp`, `lightSpecularGrp`, `lightSpotGrp`, `lightAttenuateGrp`, `togglePos`, `ig3d_ShowLights_b`, `ig3d_ShowLights_b`, `ig3d_SetSelection_s`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_SPOTLIGHT`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`
- **Provides:** `make_window`, `MaxOfOne`, `getLight`, `lightsVisibility`, `lightBtnClicked`, `enableButtonClicked`, `displayLightAttribute`, `handleLightInput`
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `ig3d_ShowLights_b - Engine call that shows or hides the lights UI, taking a boolean argument.`
  - `ig3d_SetSelection_s - Engine call that sets the selected object in the engine, taking a string argument.`
  - `IG3D_* constants - Engine property names used to read or set light attributes such as position, ambient, diffuse, specular, spot, and attenuation.`
  - `FLTK widget calls - User interface widget methods like label, value, hide, and redraw used to configure the UI.`
  - `lightAttributes - List of light attribute names used by the UI to define available light properties.`
  - `gLightEditMode - Global that stores the current light editing mode selected by the user.`
  - `gChosenLight - Global that stores the index of the currently selected light.`
- **Keep / port / drop:** keep (a complete, reusable reference for building light configuration UIs in the iGame3D engine)

---

# Part notes

## Part 1 of 6

### Top level
- **Does:** Contains the file header and the global setup for the Light UI, including the light attribute names, quote character, light edit mode and chosen light globals.
- **Uses:** `lightAttributes={"Position","Ambient","Diffuse","Specular","Spot","Attenuate"}`, `quote ='"'`, `gLightEditMode = "Position"`, `gChosenLight = 1`
- **Reusable:** yes

### make_window
- **Does:** Defines the make_window function that opens the light window.
- **Uses:** nothing
- **Reusable:** yes

### MaxOfOne
- **Does:** Prints the numeric value of the given argument, then returns 1 if the value is greater than or equal to 1, otherwise returns nothing.
- **Uses:** nothing
- **Reusable:** yes

### getLight
- **Does:** Increments the chosen light counter, sets the selection to the matching light, and displays the light attribute.
- **Uses:** `gChosenLight`, `ig3d_SetSelection_s("light "..gChosenLight)`, `displayLightAttribute()`
- **Reusable:** yes

### lightsVisibility
- **Does:** Reads the visibility label, changes it to Hide Lights when visible, toggles the lights visibility flag via the engine call, and updates the label back to Show Lights when hidden.
- **Uses:** `w:label()`, `w:label("Hide Lights")`, `ig3d_ShowLights_b(true)`, `w:label("Show Lights")`, `ig3d_ShowLights_b(false)`
- **Reusable:** yes

### lightBtnClicked
- **Does:** Sets the light edit mode from the button label, hides all light attribute groups, resets their toggle values to 0, sets the button value to 1, and displays the light attribute.
- **Uses:** `w:label()`, `lightPositionGrp:hide()`, `lightAmbientGrp:hide()`, `lightDiffuseGrp:hide()`, `lightSpecularGrp:hide()`, `lightSpotGrp:hide()`, `lightAttenuateGrp:hide()`, `togglePos:value(0)`, `toggleAmb:value(0)`, `toggleDif:value(0)`, `toggleSpec:value(0)`, `toggleSpot:value(0)`, `toggleAtten:value(0)`, `w:value(1)`, `displayLightAttribute()`
- **Reusable:** yes

### enableButtonClicked
- **Does:** Reads the current enabled state of the chosen light, sets it to false if enabled, or true if not enabled, sets the button value to 1, and redraws the lights window.
- **Uses:** `getLightInfo(gChosenLight,IG3D_ENABLED)`, `setLightInfo(gChosenLight,IG3D_ENABLED, false)`, `setLightInfo(gChosenLight,IG3D_ENABLED, true)`, `w:value(1)`, `lightswindow:redraw()`
- **Reusable:** yes

### (displayLightAttribute section)
- **Does:** Contains the displayLightAttribute code block, which is present but not fully shown in this part.
- **Uses:** nothing shown in this part
- **Reusable:** unsure
- **Procedural:** no

## Part 2 of 6

### displayLightAttribute
- **Does:** Reads the chosen light's current attributes, updates the enabled switch based on its enabled state, and populates the active light editing group with the corresponding attribute values.
- **Uses:** `getLightInfo`, `gLightEditMode`, `gChosenLight`, `lightswindow`, `lightenableswitch`, `lightPositionGrp`, `lightxpos`, `lightypos`, `lightzpos`, `lightwpos`, `lightAmbientGrp`, `lightramb`, `lightgamb`, `lightbamb`, `lightaamb`, `lightDiffuseGrp`, `lightdiffuser`, `lightdiffuseg`, `lightdiffuseb`, `lightdiffusea`, `lightSpecularGrp`, `lightspecularr`, `lightspecularg`, `lightspecularb`, `lightspeculara`, `lightSpotGrp`, `lightspotdx`, `lightspotdy`, `lightspotdz`, `lightspotcutoff`, `lightspotexponent`, `lightAttenuateGrp`, `lightattenuatequadratic`, `lightattenuatelinear`, `lightattenuateconstant`, `IG3D_ENABLED`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_SPOTLIGHT`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Contains the trailing code block marker for the `handleLightInput` callback that follows this function in the file.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 6

### handleLightInput
- **Does:** Handles light editing input by switching the active light edit mode, reading and setting light property values, and redrawing the light UI after changes.
- **Uses:** `lightswindow:make_current()`, `lightswindow:redraw()`, `gLightEditMode`, `gChosenLight`, `IG3D_POSITION`, `IG3D_AMBIENT`, `IG3D_DIFFUSE`, `IG3D_SPECULAR`, `IG3D_SPOTLIGHT`, `IG3D_CONSTANT_ATTENUATION`, `IG3D_LINEAR_ATTENUATION`, `IG3D_QUADRATIC_ATTENUATION`, `setLightInfo`, `getLightInfo`, `displayLightAttribute`, FLTK widget calls (`w:label()`, `w:value()`, `togglePos:value()`, etc.)
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### lightswindow
- **Does:** Defines the Lights window widget, including its label, window geometry and size range, plus the nested light control groups, buttons, and value inputs that make up the light configuration UI.
- **Uses:** `Fl_Window`, `Fl_Choice`, `Fl_Group`, `Fl_Button`, `Fl_Value_Input` FLTK UI constructs; widget attributes such as `label`, `xywh`, `callback`, `down_box`, `labelsize`, `align`, `minimum`, `maximum`, `step`, `value`, `textsize`, `visible`, `size_range`, `open`; callbacks `getLight`, `enableButtonClicked`, `lightBtnClicked`, `handleLightInput`.
- **Reusable:** no
- **Procedural:** no

## Part 5 of 6

### Top level
- **Does:** Defines the FLTK UI widgets for the light control panel, including value input fields for light color and spot light direction, each wired to the shared `handleLightInput` callback.
- **Uses:** `Fl_Value_Input`, `Fl_Group`, `callback`, `xywh`, `labelsize`, `align`, `minimum`, `step`, `value`, `textsize` FLTK UI attributes; widgets `lightgamb`, `lightbamb`, `lightaamb`, `lightDiffuseGrp`, `lightSpecularGrp`, `lightSpotGrp` and their child inputs.
- **Reusable:** no
- **Procedural:** no

## Part 6 of 6

### Top level
- **Does:** Builds the light UI group, wires its widgets and callbacks, then initialises the light editor state and shows the light window.
- **Uses:** FLTK widgets (`Fl_Group`, `Fl_Value_Input`, `Fl_Repeat_Button`) and their FLUID text attributes (`xywh`, `labelsize`, `align`, `minimum`, `maximum`, `step`, `value`, `label`, `callback`); engine calls (`lightChoice:add`, `lightChoice:value`, `lightenableswitch:value`, `lightAmbientGrp:hide`, `lightDiffuseGrp:hide`, `lightSpecularGrp:hide`, `lightSpotGrp:hide`, `lightAttenuateGrp:hide`, `togglePos:value`, `lightswindow:show`, `displayLightAttribute`, `ig3d_ShowLights_b`, `getLight`); globals (`lightChoice`, `lightenableswitch`, `lightAmbientGrp`, `lightDiffuseGrp`, `lightSpecularGrp`, `lightSpotGrp`, `lightAttenuateGrp`, `togglePos`, `lightswindow`); commented-out debug prints.
- **Reusable:** no
- **Procedural:** no
