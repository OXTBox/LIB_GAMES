<!-- Spark first-look of Data/Fluid/ModelsBrowser/ModelsBrowser.lua (model spark-x2.6-4b, 2026-11-13 01:18). DRAFT for Claude to review. -->

## ModelsBrowser.lua
- **Kind:** tool
- **Purpose:** This file is the iGame3D 3D game engine's model browser tool, built in Lua 5.1 with a FLTK user interface. It lets a programmer browse and edit 3D models from the WTF model folder, manage model attributes, materials, bones, and values, and load or switch game levels through the model browser. It combines model file listing, attribute parsing, material and value editing, and menu-driven level loading.
- **Depends on:** `Data/WTF/` model files, `Data/Images/` image paths, `Data/Emitters` emitter paths, `Data/Help/scripting.txt`, `Data/` level folders via `loadLevel`, `Data/` script paths via `load script.lua` construction, engine calls (`getObjectInfo`, `getSceneInfo`, `ig3d_GetObjectsList__s`, `ig3d_SetObjectMaterialInfo_sis`, `ig3d_SetObjectInfo_2s`, `ig3d_SetSelection_s`, `ig3d_GetLevelName__s()`, `ig3d_GetObjectModelPath_s_s`), globals (`gObjects`, `gNumModels`, `gSceneInfo`, `gModelsToolTipPicked`, `gNumObjects`, `gModelsBrowserFiles`, `gModelsBrowserPath`, `gModelsFilesShortNames`, `gModelsourcePath`, `gWTFReplacementFile`, `gLastSourceDirectory`, `gDropModel`, `gLastModelsSourceBrowserControlClick`, `gLastModelsSourceSelection`, `gSelModelsData`, `gModelsAttributes`, `gModelsValues`, `gModelsDetailsInfo`, `gObjectInfoAttributes`, `gObjectNames`, `gObjectColls`, `gObjectHUDs`, `gObjectWTFs`, `gObjectNames`, `gObjectPositions`, `gObjectRotations`, `gObjectSizes`, `gObjectNum`, `gObjName`, `gSelectedModels`, `gSelectedModelsInfo`, `gSelectedMaterial`, `gSelectedMaterialData`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gSelectedMaterial`, `gselModelsMaterialsList`, `gModelsMaterialsValueItems`, `gModelsMaterialsValueItems`, `gNewModelsMaterialsValueItems`, `gNewModelsMaterialsValueItems`, `gNewModelsValueItems`, `gFoundAttributes`, `gModelsAttVars`, `gModelsGetInfoTable`, `gModelsDetailsInfo`, `gModelsValueItems`, `gModelsShortPath`, `gModelsSourcePath`, `gselModelsBoneList`, `gModelsToolTipPicked`, `gModelsFilesShortNames`, `gModelsourcePath`, `gModelsShortPath`, `gModelsSourcePath`, `gModelsFilesShortNames`, `gModelsValueItems`, `gModelsAttributes`, `gModelsValues`, `gSourceRequest`, `gModelsSourcePath`, `gModelsShortPath`, `gModelsFilesShortNames`, `gModelsBrowserFiles`, `gModelsBrowserPath`, `gLastSourceDirectory`, `gDropModel`, `gDropx`, `gDropy`, `gDropz`, `gObjNum`, `gObjName`, `gNumObjects`, `gNumHelpedAttributes`, `gNumModels`, `gSceneInfo`, `gModelsBrowserFiles`, `gModelsBrowserPath`, `gModelsFilesShortNames`, `gModelsourcePath`, `gModelsShortPath`, `gModelsSourcePath`, `gModelsFilesShortNames`, `gModelsValueItems`, `gModelsAttributes`, `gModelsValues`, `gSourceRequest`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gselModelsMaterialsList`, `gSelectedMaterialData`, `gSelectedMaterial`, `gObjName`, `gSelectedModelsInfo`, `gSelectedModels`, `gSelectedMaterial`, `gSelectedMaterialData`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gSelectedMaterial`, `gselModelsMaterialsList`, `gModelsMaterialsValueItems`, `gModelsMaterialsValueItems`, `gNewModelsMaterialsValueItems`, `gNewModelsMaterialsValueItems`, `gNewModelsValueItems`, `gFoundAttributes`, `gModelsAttVars`, `gModelsGetInfoTable`, `gModelsDetailsInfo`, `gObjectInfoAttributes`, `gModelsAttributes`, `gModelsValues`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 29

### Top level
- **Does:** Initializes the ModelsBrowser UI state, global variables, and engine-level settings for the model browser, including object and model data structures and path definitions.
- **Uses:** `getObjectInfo`, `getSceneInfo`, `time`, `gameroot`, `Data/` paths (`Data/WTF/`, `Data/Images/`, `Data/Emitters`), globals (`gObjects`, `gNumModels`, `gSceneInfo` related constants), and `fltk` UI references.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 29

### MaxOfOne
- **Does:** Returns 1 when the given value is at least 1, otherwise returns nothing.
- **Uses:** nothing
- **Reusable:** yes

### executeTable
- **Does:** Iterates over the given table, loads each element as a Lua string, and runs it if it has no load error, otherwise shows a message with the error.
- **Uses:** `loadstring`, `fltk.fl_message`
- **Reusable:** yes

### ModelsBrowserGroupsHide
- **Does:** Hides model browser groups based on the currently selected tool tip and object count, showing/hiding input groups and widgets accordingly.
- **Uses:** `gModelsToolTipPicked`, `gNumObjects`, `ModelsSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `ModelsTextureGroup`, `ModelsSaveAsGroup`, `ModelsInputGroup`, `ModelsValueGroup`, `ModelsValInputA`, `ModelsValInputB`, `ModelsValInputC`, `ModelsValInputD`, `ModelsBoolBtn`, `ModelsNameInput`, `ModelsBonesGroup`, `ModelsMaterialsGroup`, `ModelsMaterialsInputGroup`, `ModelsMaterialsValInputA`, `ModelsMaterialsValInputB`, `ModelsMaterialsValInputC`, `ModelsMaterialsValInputD`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `hide()`, `show()`, `value()`
- **Reusable:** no

### ModelsBrowserGroupsHide
- **Does:** Hides model browser groups based on the currently selected tool tip and object count, showing/hiding input groups and widgets accordingly.
- **Uses:** `gModelsToolTipPicked`, `gNumObjects`, `ModelsSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `ModelsTextureGroup`, `ModelsSaveAsGroup`, `ModelsInputGroup`, `ModelsValueGroup`, `ModelsValInputA`, `ModelsValInputB`, `ModelsValInputC`, `ModelsValInputD`, `ModelsBoolBtn`, `ModelsNameInput`, `ModelsBonesGroup`, `ModelsMaterialsGroup`, `ModelsMaterialsInputGroup`, `ModelsMaterialsValInputA`, `ModelsMaterialsValInputB`, `ModelsMaterialsValInputC`, `ModelsMaterialsValInputD`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `hide()`, `show()`, `value()`
- **Reusable:** no

## Part 3 of 29

### listWTFFiles
- **Does:** Lists WTF files and directories under the WTF model browser folder, clearing the browser and showing the source group, then records each entry in the WTF file list table.
- **Uses:** `lfs.dir`, `lfs.attributes`, `wtfFileBrowser:clear()`, `wtfFileBrowser:add`, `ModelsSourceGroup:show()`, globals `gModelsBrowserFiles`, `gModelsBrowserPath`, `gModelsBrowserFiles`
- **Reusable:** yes
- **Reusable reason:** Pure file listing and table population logic that can be reused for other WTF browser folders.

### resetObjectTables
- **Does:** Reads the object list from the engine, returns early if the list is too short, then rebuilds the object-related global tables and restores object properties from the saved object list.
- **Uses:** `ig3d_GetObjectsList__s`, `getlinecount`, `getlineof`, `get`, `getObjectInfo`, `IG3D_COLL`, `IG3D_HUD`, globals `gObjects`, `gObjectColls`, `gObjectHUDs`, `gObjectWTFs`, `gObjectNames`, `gObjectPositions`, `gObjectRotations`, `gObjectSizes`, `gameroot`, `Data/WTF/` path construction
- **Reusable:** yes
- **Reusable reason:** Table rebuild and property restoration logic reusable for object state reset in a new engine.

## Part 4 of 29

### ModelsBrowserValueCatch
- **Does:** Rebuilds the model value item lists from the current browser and button values, then updates the FLTK interface.
- **Uses:** `ModelsFieldValues`, `ModelsListBrowser`, `ModelsAttListBrowser`, `wtfFileBrowser`, `ModelsBoolBtn`, `ModelsValInputA`–`D`, `ModelsNameInput`, `ModelsMaterialsBrowser`, `ModelsMaterialsAttributesBrowser`, `ModelsMaterialsBoolBtn`, `gModelsValueItems`, `gModelsMaterialsValueItems`, `gNewModelsValueItems`, `gNewModelsMaterialsValueItems`, `curValBool`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

### <function name>
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes, copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 5 of 29

### parseHelpForModelsAttributes
- **Does:** Parses the engine's scripting help text to build the list of model attributes, appending any new attributes found to the existing attribute list.
- **Uses:** `ModelsBrowserValueCatch()`, `gFoundAttributes`, `whichCommand`, `whichElement`, `gameroot`, `io.open`, `string.char`, `string.gmatch`, `string.find`, `string.sub`, `string.len`, `string.lower`, `table.insert`, and the file path `Data/Help/scripting.txt`
- **Reusable:** yes - it relies only on string manipulation and table operations to extract attribute names from help text.
- **Procedural:** no

### parseHelpForModelsAttributes
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes, copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 6 of 29

### parseModelsAttributesTable
- **Does:** Builds model attribute lookup tables by scanning `gFoundAttributes` and generating get-info commands for model objects.
- **Uses:** `gFoundAttributes`, `gModelsDetailsInfo`, `gObjectInfoAttributes`, `gModelsAttVars`, `gModelsGetInfoTable`, `gObjNum`, `tText`, `tally`, `string`, `table`
- **Reusable:** no
- **Procedural:** no

### updateModelAttributesTables
- **Does:** Rebuilds the model details and selected model data tables by executing the generated get-info commands and aggregating their results.
- **Uses:** `gModelsDetailsInfo`, `gModelsGetInfoTable`, `gSelModelsData`, `gModelsAttributes`, `gFoundAttributes`, `executeTable`, `string`, `table`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 29

### showModelsColorChooser
- **Does:** Opens a color chooser for the selected material attribute, applies the chosen color to the selected object, updates the RGB input fields, and persists the new material value.
- **Uses:** `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gRed`, `gGreen`, `gBlue`, `fltk.fl_color_chooser`, `Fl:set_color`, `ModelsMaterialsValInputA`, `ModelsMaterialsValInputB`, `ModelsMaterialsValInputC`, `ModelsBrowserValueCatch`, `gNewModelsMaterialsValueItems`, `changeModelsMaterialsVal`
- **Reusable:** no
- **Procedural:** no

## Part 8 of 29

### ModelsBrowserWindowUpdate
- **Does:** Updates the ModelsBrowser UI based on the requested argument, then refreshes the FLTK interface. It handles source list loading, model attribute and value lists, selection state, and new-model setup.
- **Uses:** Engine calls and globals from the code: `ModelsBrowser`, `ModelsBrowser:make_current()`, `ModelsBrowserValueCatch()`, `ModelsFieldValues`, `ModelsFieldValues[1]`, `ModelsFieldValues[2]`, `ModelsBrowserGroupsHide()`, `wtfFileBrowser`, `gModelsFilesShortNames`, `gModelsourcePath`, `SourceNameInput`, `updateModelAttributesTables()`, `gSelModelsData`, `gModelsAttributes`, `ModelsAttListBrowser`, `ModelsValueListBrowser`, `gOldInfo`, `gSelectedModelsInfo`, `gObjectNames`, `gSourceRequest`, `ModelsListBrowser`, `ModelsAttListBrowser`, `ModelsValueListBrowser`, `fltk_update()`. Files/paths referenced: `Data/WTF/` (string search within `gModelsourcePath`).
- **Reusable:** yes - the argument-driven UI update pattern and list refresh logic can be reused for similar browser windows.
- **Procedural:** no

### ModelsBrowserWindowUpdate (newModels branch)
- **Does:** When the argument is `newModels`, it sets the second attribute and value list entries to index 2, selects them, and calls `ModelsBrowserValueCatch()` to refresh the model.
- **Uses:** Engine calls and globals from the code: `ModelsAttListBrowser`, `ModelsValueListBrowser`, `ModelsAttListBrowser:value(2)`, `ModelsValueListBrowser:value(2)`, `ModelsAttListBrowser:select(2)`, `ModelsValueListBrowser:select(2)`, `ModelsBrowserValueCatch()`.
- **Reusable:** yes - the selection and refresh sequence for new model setup is reusable for similar model creation flows.
- **Procedural:** no

### ModelsBrowserWindowUpdate (updateMaterialsBrowser branch)
- **Does:** When the argument is `updateMaterialsBrowser`, it performs no additional actions.
- **Uses:** nothing
- **Reusable:** no

### ModelsBrowserWindowUpdate (source list and selection handling)
- **Does:** When the argument is `SourceList`, it loads the short model names into the WTF file browser, clears it first, and refreshes the interface. When the argument is `CurModelsInfo`, it updates the source name input from `gModelsourcePath`, refreshes the model attribute and value lists, and restores the old selected model info if there is more than one selected model. When the argument is `updateModelsListBrowser`, it clears and repopulates the model list browser with object names, updates the selected model index, and clears the source request. When the selected WTF file or model index is set, it updates the corresponding browser selections and values.
- **Uses:** Engine calls and globals from the code: `ModelsBrowser`, `ModelsBrowser:make_current()`, `ModelsBrowserValueCatch()`, `ModelsFieldValues`, `ModelsFieldValues[1]`, `ModelsFieldValues[2]`, `ModelsBrowserGroupsHide()

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 9 of 29

### updateModelsListBrowser
- **Does:** Reads the model object list, splits it into a name list, and refreshes the models list browser UI.
- **Uses:** `ModelsBrowserValueCatch`, `ig3d_GetObjectsList__s`, `getlinecount`, `getlineof`, `string.len`, `string.gsub` (via `string.gmatch`), `gObjectNames`, `ModelsBrowserWindowUpdate`, `Data/` paths from the surrounding engine layout
- **Reusable:** yes - list extraction and UI refresh logic for model browsing
- **Procedural:** no

### updateMaterialBrowsers
- **Does:** Hides the model group browser, refreshes material tables, clears and repopulates the material value, attribute and model material browsers, then restores the previously selected material fields.
- **Uses:** `ModelsBrowserValueCatch`, `ModelsBrowserGroupsHide`, `updateMaterialsTables`, `ModelsMaterialsAttributesBrowser:clear`, `ModelsMaterialsValuesBrowser:clear`, `ModelsMaterialsBrowser:clear`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gselModelsMaterialsList`, `ModelsFieldValues`, `#` (table length), `tonumber`, `string.gmatch`, `string.gsub`
- **Reusable:** yes - material browser refresh and selection restoration logic
- **Procedural:** no

## Part 10 of 29

### changeModelsMaterialsVal
- **Does:** Updates the material value for the selected model, rebuilds the material string, applies it to the selected models, prints the resulting material update, and refreshes the material browser and UI.
- **Uses:** `ModelsBrowser`, `ModelsFieldValues`, `gSelectedModelsInfo`, `gSelectedMaterialData`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gSelectedMaterial`, `gObjName`, `ModelsMaterialsBrowser`, `ig3d_SetObjectMaterialInfo_sis`, `updateMaterialBrowsers`, `fltk_update`, `print`
- **Reusable:** yes
- **Procedural:** no

### updateMaterialsTables
- **Does:** Rebuilds the selected material attribute/value tables from the model's material list and material info, adds the material list to the browser, and populates the attribute and value tables with parsed material info lines.
- **Uses:** `ModelsFieldValues`, `gSelectedMaterial`, `gselModelsMaterialsList`, `ModelsMaterialsBrowser`, `ig3d_GetObjectMaterialsList_s_s`, `ig3d_GetObjectMaterialInfo_si_s`, `getlinecount`, `getlineof`, `string.len`, `string.find`, `string.sub`, `table.insert`
- **Reusable:** yes
- **Procedural:** no

## Part 11 of 29

### ModelsMaterialsValInput
- **Does:** Builds a comma-separated string from the `gNewModelsMaterialsValueItems` list, then passes it to `changeModelsMaterialsVal`.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `gNewModelsMaterialsValueItems`, `changeModelsMaterialsVal`
- **Reusable:** no
- **Procedural:** no

## Part 12 of 29

### PickedMaterialsAttribute
- **Does:** Shows the picked-models materials UI based on the selected material index, splits comma-separated material values, and populates the corresponding FLTK input widgets and boolean button.
- **Uses:** Engine calls and globals from the code: `ModelsBrowser == nil`, `ModelsBrowserValueCatch()`, `ModelsFieldValues`, `CurModelsInfo()`, `ModelsBrowserGroupsHide()`, `gSelectedModelsInfo`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gModelsMaterialsValueItems`, `gModelsMaterialsValueItems`, `ModelsMaterialsGroup`, `ModelsMaterialsInputGroup`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsBoolBtn`, `ModelsMaterialsNameInput`, `ModelsMaterialsValInputA`–`D`, `Models

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 13 of 29

### changeModelsMaterialsBool
- **Does:** Toggles the material boolean value for the selected model, rebuilds the material string, and pushes the updated material info to the model.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `ModelsFieldValues`, `gChangeMaterial`, `gSelectedMaterialAttributes`, `gSelectedMaterialValues`, `MatString`, `MaterialsUpdate`, `ig3d_SetObjectMaterialInfo_sis`, `fltk_update`
- **Reusable:** yes
- **Procedural:** no

### CurModelsInfo
- **Does:** Loads the object list, selects an object by index, reads its info, sets selection and model path, populates the bone browser, and updates the model browser window.
- **Uses:** `ModelsBrowserValueCatch`, `ig3d_GetObjectsList__s`, `getlinecount`, `getlineof`, `gNumObjects`, `gSelectedModels`, `gSelectedModelsInfo`, `gDropx`, `gDropy`, `gDropz`, `gObjNum`, `gObjName`, `get(ig3d_object, ...)`, `ig3d_SetSelection_s`, `ig3d_GetObjectModelPath_s_s`, `gModelsSourcePath`, `gModelsShortPath`, `gselModelsBoneList`, `ModelsBonesBrowser:clear`, `ModelsBonesBrowser:add`, `parseHelpForModelsAttributes`, `parseModelsAttributesTable`, `gNumHelpedAttributes`, `ModelsBrowserWindowUpdate`
- **Reusable:** no
- **Procedural:** no

## Part 14 of 29

### changeModelsVal
- **Does:** Updates the model value for the selected model field, writes the updated values into the object info string, and refreshes the model info.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `ModelsFieldValues`, `gSelectedModelsInfo`, `gSelModelsData`, `gModelsValues`, `gObjectInfoAttributes`, `gObjectNum`, `gObjName`, `ig3d_SetObjectInfo_2s`, `CurModelsInfo`
- **Reusable:** yes
- **Procedural:** no

### ModelsValInput
- **Does:** Reads the current model value list from the input, passes it to changeModelsVal to update the model value.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `gNewModelsValueItems`, `changeModelsVal`
- **Reusable:** yes
- **Procedural:** no

### changeModelsBool
- **Does:** Sets the selected model field to true or false based on the input value, executes the corresponding setObjectInfo call, and refreshes the UI.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `ModelsFieldValues`, `CurModelsInfo`, `gSelectedModelsInfo`, `gSelModelsData`, `gObjectInfoAttributes`, `gObjectNum`, `gObjName`, `loadstring`, `fltk_update`
- **Reusable:** yes
- **Procedural:** no

## Part 15 of 29

### PickObjectDetails
- **Does:** Shows the selected object's attribute group based on the current attribute line, and lists WTF files when the attribute is source.
- **Uses:** `ModelsBrowserValueCatch`, `gModelsAttributes`, `ModelsFieldValues`, `ModelsBonesGroup`, `ModelsMaterialsGroup`, `listWTFFiles`
- **Reusable:** no
- **Procedural:** no

## Part 16 of 29

### PickedModelsAttribute
- **Does:** Opens the ModelsBrowser UI, updates the selected model's name and value fields based on the selected attribute index, and handles the source replacement path when the attribute is the source list.
- **Uses:** `ModelsBrowser`, `ModelsBrowserValueCatch`, `ModelsFieldValues`, `CurModelsInfo`, `ModelsBrowserGroupsHide`, `ModelsNameInput`, `ModelsValInputA`–`D`, `ModelsBoolBtn`, `ModelsInputGroup`, `ModelsValueGroup`, `ModelsSourceGroup`, `wtfFileBrowser`, `ModelsSourceGroup`, `gSelectedModelsInfo`, `gModelsValueItems`, `gSelModelsData`, `gModelsAttributes`, `gModelsValues`, `gSourceRequest`, `fltk_update`, `numberofitems`, `item`, `string.find`, `string.len`, `tonumber`, `table.insert`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

### PickedModelsAttribute
- **Does:** Splits the model value string by commas into individual value items, stores them in `gModelsValueItems`, and shows the appropriate numeric input field based on the item index when no boolean value is active.
- **Uses:** `gModelsValueItems`, `gSelModelsData`, `string.find`, `numberofitems`, `item`, `table.insert`, `tonumber`, `gModelsValueItems`
- **Reusable:** yes
- **Procedural:** no

### PickedModelsAttribute
- **Does:** Sets the boolean button label and value based on the model attribute, shows or hides the numeric input field depending on whether the value is a boolean or numeric, and updates the numeric input field values for each item index.
- **Uses:** `gModelsAttributes`, `gModelsValueItems`, `ModelsBoolBtn`, `ModelsValInputA`–`D`, `string.len`, `tonumber`, `gModelsValueItems`
- **Reusable:** no
- **Procedural:** no

## Part 17 of 29

### RenameModels
- **Does:** Renames the selected model by the value in the model name field, updates the model list browser, and refreshes the picked model attribute.
- **Uses:** `tostring`, `changeModelsVal`, `updateModelsListBrowser`, `PickedModelsAttribute`, `ModelsFieldValues`, `w:value()`
- **Reusable:** yes

### ModelsAttPicked
- **Does:** Selects and sets the picked model attribute value from the clicked widget, then refreshes the picked model attribute.
- **Uses:** `ModelsBrowser`, `ModelsValueListBrowser`, `ModelsValueListBrowser:value`, `ModelsValueListBrowser:select`, `ModelsValueListBrowser:selected`, `ModelsBrowserValueCatch`, `PickedModelsAttribute`, `ModelsFieldValues`, `w:value()`
- **Reusable:** yes

### ModelsMaterialsAttributesBrowserCallback
- **Does:** Sets the selected material attribute, updates material browsers, refreshes the picked material attribute, and shows the model color chooser when the attribute is colorful.
- **Uses:** `gSelectedMaterialAttribute`, `ModelsMaterialsAttributesBrowser`, `ModelsMaterialsAttributesBrowser:select`, `ModelsMaterialsAttributesBrowser:value`, `ModelsMaterialsAttributesBrowser:selected`, `ModelsMaterialsValuesBrowser`, `ModelsMaterialsValuesBrowser:select`, `ModelsMaterialsValuesBrowser:value`, `ModelsMaterialsValuesBrowser:selected`, `updateMaterialBrowsers`, `PickedMaterialsAttribute`, `colorfulMaterialAtt`, `showModelsColorChooser`, `w:value()`
- **Reusable:** yes

### ModelsMaterialsBrowserCallback
- **Does:** Sets the selected material from the clicked widget and updates the material browsers.
- **Uses:** `gSelectedMaterial`, `updateMaterialBrowsers`, `w:value()`
- **Reusable:** yes

### ModelsBonesBrowserCallback
- **Does:** Does nothing.
- **Uses:** nothing
- **Reusable:** no

### ModelsValueListCallback
- **Does:** Selects and sets the picked model attribute value from the clicked widget, then refreshes the picked model attribute.
- **Uses:** `ModelsBrowser`, `ModelsAttListBrowser`, `ModelsAttListBrowser:value`, `ModelsAttListBrowser:select`, `ModelsAttListBrowser:selected`, `ModelsBrowserValueCatch`, `PickedModelsAttribute`, `ModelsFieldValues`, `w:value()`
- **Reusable:** yes

### ModelsSourceBrowserControlDoubleClicked
- **Does:** On double click, if the selected source is a directory, moves the model browser path up or into the directory and refreshes the list of WTF files.
- **Uses:** `gModelsBrowserFiles`, `gModelsBrowserPath`, `goDirsUp`, `listWTFFiles`, `gLastSourceDirectory`, `w:value()`
- **Reusable:** no

## Part 18 of 29

### ModelsSourcebrowserControlClicked
- **Does:** Handles the click on the models source browser control. It updates the WTF preview, sets the replacement WTF file and drop model, shows the replacement and replace-all buttons, and tracks double-click timing and source selection.
- **Uses:** `gModelsBrowserFiles`, `gWTFReplacementFile`, `gLastSourceDirectory`, `gDropModel`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `gModelsShortPath`, `time()`, `gLastModelsSourceBrowserControlClick`, `gLastModelsSourceSelection`, `ModelsSourceBrowserControlDoubleClicked`, `ig3d_GetLevelName__s()` (via `fileName`), `loadLevel` (via `fileName`), `load script.lua` path construction; engine globals referenced in the code.
- **Reusable:** yes - the click handling and timing logic for the source browser control can be reused in similar source browser controls.

### ReplaceWTFSourceBtnClick
- **Does:** Opens the current level's `load script.lua`, extracts the `gObjectWTFs` table definition from it, replaces that table definition with the new WTF replacement file, writes the updated script back, and loads the current level again.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s()`, `io.open`, `f:read("*a")`, `f:close()`, `string.find`, `string.sub`, `loadstring`, `gObjectWTFs`, `gObjectNum`, `gWTFReplacementFile`, `loadLevel`, `load script.lua` path construction; engine globals referenced in the code.
- **Reusable:** yes - the string extraction and table replacement logic for refreshing WTF source definitions is reusable for similar script-based asset refresh operations.

## Part 19 of 29

### Top level
- **Does:** Declares the Models menu index and menu text tables, which the model browser functions use to build the menu.
- **Uses:** nothing
- **Reusable:** yes

### ReplaceAllWTFSourceBtnClick
- **Does:** Reads the current level's load script, replaces every short model path with the full WTF replacement file path, writes the modified script back, then reloads the current level.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s()`, `io.open`, `string.gmatch`, `string.gsub`, `gWTFReplacementFile`, `loadLevel`, `gModelsShortPath`
- **Reusable:** no

### fillModelsSourceMenu
- **Does:** Builds the source model menu by adding the Make, Save, and Duplicate entries to the menu and tracking their positions in the menu index.
- **Uses:** `ModelsBrowser`, `ModelsMenu`, `ModelsMenuText.Source`, `table.insert`, `ModelsMenuIndex`, `ModelsMenu:add`, `ModelsMenu:redraw`
- **Reusable:** yes

### fillModelsControlMenu
- **Does:** Builds the control model menu by adding Run, Stop, Clear entries, plus empty separators and an All section with the same control entries, tracking each added line in the menu index.
- **Uses:** `ModelsBrowser`, `ModelsMenu`, `ModelsMenuText.Control`, `table.insert`, `ModelsMenuIndex`, `ModelsMenu:add`, `ModelsMenu:redraw`
- **Reusable:** yes

### ModelsCurrentPick
- **Does:** Renders the scene when the current model pick is Clear, Run, or Stop.
- **Uses:** `render`
- **Reusable:** yes

### Uses
- **Does:** nothing
- **Reusable:** yes

## Part 20 of 29

### ModelsBrowsersMenuPick
- **Does:** Routes a menu pick action for the models browser: it hides or shows model attribute groups depending on whether the pick is Save, Make, or Duplicate, and otherwise returns.
- **Uses:** `ModelsBrowser`, `CurModelsInfo`, `PickedModelsAttribute`, `ModelsInputGroup`, `ModelsourceGroup`, `ModelsValueGroup`, `ModelsTextureGroup`, `ModelsaveAsGroup`, `wtfFileBrowser`, `gSourceRequest`, `ValueListBrowser`, `MakeModels`, `ModelsCurrentPick`, `ModelsAllMenuPick`, `ModelsMenuIndex`, `item`, `io.flush`
- **Reusable:** no
- **Procedural:** no

### Models_menu_callback
- **Does:** Reads the selected menu item and its value from the FLTK menu widget, looks up adjacent menu indices, and dispatches the pick action based on the menu head and value.
- **Uses:** `ModelsBrowser`, `w:label()`, `w:value()`, `w:text()`, `ModelsMenuIndex`, `ModelsmenuHead`, `ModelsBrowsersMenuPick`, `ModelsCurrentPick`, `ModelsAllMenuPick`, `Fl:check()`, `io.flush`
- **Reusable:** no
- **Procedural:** no

### Models_MenuBarFill
- **Does:** Fills the models source and control menus when the models browser is active.
- **Uses:** `ModelsBrowser`, `fillModelsSourceMenu`, `fillModelsControlMenu`
- **Reusable:** no
- **Procedural:** no

### ModelsListBrowserCallback
- **Does:** Handles the models list browser widget: reads the selected model, resets object tables, sets the selected model, refreshes model info, updates the camera face object, and handles tool tip actions before rendering.
- **Uses:** `ModelsBrowser`, `w:value()`, `ModelsBrowserValueCatch`, `resetObjectTables`, `gObjName`, `gObjectNames`, `ig3d_SetSelection_s`, `gSelectedModels`, `CurModelsInfo`, `gObjectNum`, `camera_faceObj`, `gModelsToolTipPicked`, `PickedModelsAttribute`, `ModelsFieldValues`, `updateMaterialsTables`, `render`
- **Reusable:** no
- **Procedural:** no

## Part 21 of 29

### ModelsToolPick
- **Does:** Shows the appropriate models tool group based on the picked tooltip, and updates the FLTK UI after the selection.
- **Uses:** `ModelsBrowserValueCatch()`, `ModelsBrowserGroupsHide()`, `ModelsBonesGroup`, `ModelsMaterialsGroup`, `ModelsValueGroup`, `listWTFFiles()`, `fltk_update()`, global `gModelsToolTipPicked`
- **Reusable:** no
- **Procedural:** no

### modelsToolBtnCallback
- **Does:** Reads the tooltip of the clicked widget and passes it to ModelsToolPick to select the corresponding models tool group.
- **Uses:** `w:tooltip()`, `ModelsToolPick()`, global `gModelsToolTipPicked`
- **Reusable:** no
- **Procedural:** no

## Part 22 of 29

### Top level
- **Does:** Creates the ModelsBrowser FLTK double window and its supporting group, buttons and resize/color/labelsize settings; contains the ModelswtfAddObjectClicked function below.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `ModelsBrowser`, `mainttoolsgroup`, `modelstool1` through `modelstool7`, `ModelsBrowser:callback`, `ModelsBrowser:resize`, `ModelsBrowser:color`, `ModelsBrowser:labelsize`, `Fl_Group:current`, `Fl_Group:current():parent()`.
- **Reusable:** no

### ModelswtfAddObjectClicked
- **Does:** Adds a newly selected WTF file as a new 3D object to the scene, records its position, rotation, size and collision/HUD flags, then refreshes the models list browser.
- **Uses:** `wtfFileBrowser`, `gModelsBrowserFiles`, `gObjects`, `gObjectPositions`, `gObjectRotations`, `gObjectSizes`, `gObjectColls`, `gObjectHUDs`, `updateModelsListBrowser`, `make(ig3d_object, ...)`, `setObjectInfo(gObjects[n].cObj, IG3D_POSITION, ...)`, `gameroot`, `Data/WTF`, `gDropObject`, `gDropx`, `gDropy`, `gDropz`, `gDroprx`, `gDropry`, `gDroprz`, `gDropsx`, `gDropsy`, `gDropsz`, `gModelsBrowserPath`, `table.insert`.
- **Reusable:** no
- **Procedural:** no

## Part 23 of 29

### ModelswtfAddObjectClicked (continued)
- **Does:** Builds the Models menu bar, save-as group with source name input and save button, texture group with preview box and file browser, and value group with value list browser, wiring their callbacks and resizing/labeling them.
- **Uses:** `fltk:Fl_Menu_Bar`, `fltk:Fl_Group`, `fltk:Fl_Input`, `fltk:Fl_Button`, `fltk:Fl_Box`, `fltk:Fl_Browser`, `gLabelTable`, `ModelsMenu`, `ModelsSaveAsGroup`, `ModelsTextureGroup`, `pngPreviewGroup`, `pngPreviewBox`, `pngFileBrowser`, `ModelsValueGroup`, `ModelsValueListBrowser`, `Models_menu_callback`, `ModelsSaveButtonClick`, `pngLoad`, `browserControlClicked`, `ModelsValueListCallback`, `Fl_Group:current`, `table.insert`
- **Reusable:** no
- **Procedural:** no

## Part 24 of 29

### ModelswtfAddObjectClicked (continued)
- **Does:** Builds the Models input group and its child widgets, wires their callbacks, and resizes them to the group layout.
- **Uses:** `fltk:` widget constructors and styling calls (`resize`, `box`, `color`, `label`, `callback`, `labelsize`, `textsize`, `align`, `when`, `minimum`, `maximum`, `step`, `down_box`), `gLabelTable` (initialized if nil, entries appended and referenced by index), `ModelsAttListBrowser`, `ModelsNameInput`, `ModelsBoolBtn`, `ModelsValInputA`, `ModelsValInputB`, `ModelsValInputC`, and `Fl_Group:current` update.
- **Reusable:** no
- **Procedural:** no

## Part 25 of 29

### ModelswtfAddObjectClicked (continued)
- **Does:** Builds the Models browser UI groups and value inputs, wiring their callbacks and resizing them into the Models root group.
- **Uses:** `fltk:Fl_Group`, `fltk:Fl_Value_Input`, `fltk:Fl_Browser`, `gLabelTable`, `table.insert`, `Fl_Group:current`, `ModelsValInput`, `ModelsListBrowserCallback`, `ModelsBonesBrowserCallback`, `ModelsMaterialsBrowserCallback`, `runButton`
- **Reusable:** no
- **Procedural:** no

## Part 26 of 29

### ModelswtfAddObjectClicked (continued)
- **Does:** Builds the materials browser UI widgets for the models materials add object flow, including the browser panels, input group, name field, boolean button, and value inputs, and wires their callbacks to the shared material handling functions.
- **Uses:** `fltk:` widget constructors and configuration calls (`Fl_Browser`, `Fl_Group`, `Fl_Input`, `Fl_Check_Button`, `Fl_Value_Input`, plus `label`, `callback`, `resize`, `box`, `color`, `labelsize`, `align`, `when`, `textsize`, `minimum`, `step`, `down_box`), the global `gLabelTable` (initialized and populated with labels), and the callback functions `ModelsMaterialsAttributesBrowserCallback`, `RenameModelsMaterials`, `changeModelsMaterialsBool`, `ModelsMaterialsValInput`.
- **Reusable:** no
- **Procedural:** no

## Part 27 of 29

### ModelswtfAddObjectClicked (continued)
- **Does:** Builds the source group UI for adding WTF models, including label-styled value inputs, replace buttons, and a model source browser, and wires their click callbacks.
- **Uses:** `gLabelTable`, `fltk:Fl_Group`, `fltk:Fl_Value_Input`, `fltk:Fl_Button`, `fltk:Fl_Browser`, `ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `ModelsSourcebrowserControlClicked`, and the `Data/`-based WTF source path context for the browser.
- **Reusable:** no
- **Procedural:** no

## Part 28 of 29

### Top level
- **Does:** Builds the ModelsBrowser UI, wires its buttons and icon tools, and runs the initial model list and menu setup steps.
- **Uses:** `gLabelTable`, `gModelsBrowserButtons`, `gModelsBrowserIcons`, `gObjects`, `ModelsBrowser`, `Models_MenuBarFill`, `listWTFFiles`, `ModelsBrowserGroupsHide`, `resetObjectTables`, `updateModelsListBrowser`, `ModelswtfAddObjectClicked`, `ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `fltk:Fl_Button`, `fltk:Fl_Group`, `fltk.fl_register_images`, `Fl_Shared_Image.get`, `Fl_Group:current`, `gameroot`, `Data/` paths (`Data/Icons/ModelsBrowser/Models_*`), `modelstool1` through `modelstool6`, `image` widget calls.
- **Reusable:** no
- **Procedural:** no

## Part 29 of 29

### Top level
- **Does:** Sets up the ModelsBrowser UI icons and buttons, attaches tooltips to the buttons, triggers redraws and visibility changes for the six model tool buttons, then runs the FLTK application.
- **Uses:** `modelstool1` through `modelstool6` (engine tool objects), `gModelsBrowserIcons[6]`, `gModelsBrowserButtons[1]` through `gModelsBrowserButtons[6]`, `modelstool:tooltip`, `modelstool:redraw`, `modelstool:when`, `Fl:run()`.
- **Reusable:** no
- **Procedural:** no
