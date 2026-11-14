<!-- Spark folder manifest of Data/Fluid/Lights (model spark-x2.6-4b, 2026-11-12 22:55). DRAFT. -->

# Data/Fluid/Lights
- **Role:** This folder holds the FLTK-based light editor UI for iGame3D, letting a programmer configure light attributes such as position, ambient, diffuse, specular, spot, and attenuation, and manage light visibility. The FLUID `.fl` file defines the light configuration dialog, while the matching `.lua` file builds the editing controls and runs the initial light configuration.
- **Entry point:** Lights.lua
- **Files:** Lights.fl - FLTK user interface file for the iGame3D light editor, defining the light configuration window and control panel widgets. Lights.lua - Lua implementation of the FLTK-based light editing and management interface, building the light editor window, input controls, and running the initial light configuration.
- **Shared with other folders:** Needs engine calls and globals such as `gLightEditMode`, `gChosenLight`, `gLabelTable`, `ig3d_SetSelection_s`, `ig3d_ShowLights_b`, and the `IG3D_*` property constants from the engine; takes light objects and their property data from the engine's light management.
- **Procedure candidates:** The light editor UI is built and managed by code: the `.fl` file defines the dialog structure and the `.lua` file constructs the editing controls, sets up the light editor window, and runs the initial light configuration to enable light rendering.
- **Glossary:**
  - `ig3d_ShowLights_b - Engine call that shows or hides the lights UI, taking a boolean argument.`
  - `ig3d_SetSelection_s - Engine call that sets the selected object in the engine, taking a string argument.`
  - `IG3D_* constants - Engine property names used to read or set light attributes such as position, ambient, diffuse, specular, spot, and attenuation.`
  - `gLightEditMode - Global that stores the current light editing mode selected by the user.`
  - `gChosenLight - Global that stores the index of the currently selected light.`
  - `gLabelTable - Global used by the light editor to manage label/value controls for light attributes.`
  - `lightAttributes - List of light attribute names used by the UI to define available light properties.`
  - `FLTK widget calls - User interface widget methods like label, value, hide, and redraw used to configure the UI.`
- **Verdict:** keep - The folder provides a complete, reusable reference for building light configuration UIs in the iGame3D engine, with the `.fl` and `.lua` files together defining the full light editor interface and its setup logic.
