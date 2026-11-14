<!-- Spark first-look of Data/Fluid/CameraBrowser/script.fl (model spark-x2.6-4b, 2026-11-12 20:19). DRAFT for Claude to review. -->

## script.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface designer data file for the iGame3D CameraBrowser fluid UI, defining the camera browser window, its groups, value inputs, menus, and callback logic for browsing and editing cameras. It is part of the Fluid folder's FLUID UI designer output and drives camera browsing interactions in the engine.
- **Depends on:** `gameroot`, `time()`, `getlineof`, `getSceneInfo`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `fltk.fl_register_images`, `Data/` paths (`gameroot.."Data/Levels/"`, `Data/WTF/`, `gameroot.."Data/Help/scripting.txt"`), `gCameras`, `gNumCameras`, `gSelectedCamera`, `gAttributePicked`, `gCameraVals`, `gCurSel`, `gCameraFieldValues`, `gCameraFileValues`, `gCameraFileAttributes`, `gLastBrowserControlClick`, `gCameraBrowserFiles`, `gCameraBrowserFileList`, `gCameraFilesShortNames`, `gCameraSource`, `gCameraSourcePath`, `gCatchCameraPath`, `gSourceRequest`, `gCameraNewName`, `gNewCameraValueItems`, `gCameraValueItems`, `gOldInfo`, `gLastCameraSourceSelection`, `gLastCameraSourceBrowserControlClick`, `gLastSourceDirectory`, `gCameraShortPath`, `gCameraNum`, `gCameraInfoAttributes`, `gCameraDetailsInfo`, `gNumHelpedAttributes`, `gCameraGetInfoTable`, `gCameraToolTipPicked`, `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gRed`, `gGreen`, `gBlue`, `gSelectedMaterialValues`, `gSelectedMaterialData`, `gselCameraMaterialsList`, `gCameraMaterialsValueItems`, `gNewCameraMaterialsValueItems`, `gChangeMaterial`, `MatString`, `MaterialsUpdate`, `gSelectedCamera`, `gSelectedMaterial`, `gObjName`, `gFoundAttributes`, `gSelCameraData`, `gCameraAttributes`, `gCameraNames`, `gCameraPositions`, `gCameraRotations`, `gCameraMatrix`, `gCameraNames`, `gCameraInfoAttributes`, `gCameraAttVars`, `gCameraGetInfoTable`, `gSelCameraData`, `gCameraAttributes`, `gCameraValues`, `gCameraInfoAttributes`, `gCameraMaterialsValueItems`, `gSelectedMaterialAttributes`, `gSelectedMaterialValues`, `gSelectedMaterialData`, `gselCameraMaterialsList`, `gSelectedCameraInfo`, `CurCameraInfo`, `ig3d_GetCameraInfo__s`, `ig3d_GetCamerasList__s()`, `ig3d_GetCameraMaterialInfo_s_s`, `ig3d_GetCameraMaterialsList_s_s`, `ig3d_SetCameraInfo_2s`, `ig3d_SetCameraMaterialInfo_sis`, `ig3d_SetSelection_s`, `ig3d_GetLevelName__s`, `loadstring`, `loadLevel`, `lfs.dir`, `lfs.attributes`, `string.sub`, `string.char`, `string.gmatch`, `string.find`, `string.lower`, `string.upper`, `string.match`, `string.len`, `string.gsub`, `io.open`, `table.insert`, `table.insert`, `numberofitems`, `item`, `getlinecount`, `getlineof`, `getlineof`, `whichCommand`, `whichElement`, `changeCameraVal`, `changeCameraBool`, `changeCameraMaterialsVal`, `changeCameraMaterialsBool`, `updateCameraListBrowser`, `updateCameraAttributesTables`, `updateCameraAttributesTables`, `updateMaterialsTables`, `updateMaterialBrowsers`, `PickedCameraAttribute`, `PickedMaterialsAttribute`, `CameraBrowserValueCatch`, `CameraBrowserGroupsHide`, `CameraBrowserWindowUpdate`, `CameraBrowser`, `CameraBrowser:make_current()`, `CameraBrowserValueCatch()`, `CameraBrowserGroupsHide()`, `CameraBrowserWindowUpdate()`, `CameraBrowserGroupsHide()`, `CameraBrowser == nil` check, `CameraBrowserValueCatch()`, `CurCameraInfo()`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fltk_update`, `fl

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 21

### Top level
- **Does:** Defines the FLTK user interface designer data file for the Fluid folder, setting its version and file type headers.
- **Uses:** `version`, `header_name`, `code_name` (data file metadata only).
- **Reusable:** no
- **Procedural:** no

## Part 2 of 21

### Top level
- **Does:** Establishes the initial state and shared globals for the CameraBrowser Fluid UI, including camera-related data structures, path variables, and UI state flags.
- **Uses:** `gameroot`, `time()`, `getlineof`, `getSceneInfo`, `IG3D_FOG`, `IG3D_BACKGROUND_COLOR`, `fltk.fl_register_images` (commented out), `Data/` paths (`gameroot.."Data/Levels/"`), `gCameras`, `gNumCameras`, `gSelectedCamera`, `gAttributePicked`, `gCameraVals`, `gCurSel`, `gCameraFieldValues`, `gCameraFileValues`, `gCameraFileAttributes`, `gLastBrowserControlClick`, `gCameraBrowserFiles`, `gCameraBrowserFileList`, `gCameraFilesShortNames`, `gCameraSource`, `gCameraSourcePath`, `gCatchCameraPath`, `gSourceRequest`, `gCameraNewName`, `gNewCameraValueItems`, `gCameraValueItems`, `gOldInfo`, `gLastCameraSourceSelection`, `gLastCameraSourceBrowserControlClick`, `gLastSourceDirectory`, `gCameraShortPath`, `gCameraNum`, `gCameraInfoAttributes`, `gCameraDetailsInfo`, `gNumHelpedAttributes`, `gCameraGetInfoTable`, `gCameraToolTipPicked`, `colorAttributes`, `gColorEditMode`, `gColorAttribute`, `gColorTargets`, `gfogEnabled`, `gFogRed`, `gFogGreen`, `gFogBlue`, `gFogstart`, `gFogend`, `gRed`, `gBlue`, `gGreen`, `Alpha`, `choosr`, `choosg`, `choosb`, `quote`
- **Reusable:** no

### make_window
- **Does:** Defines the main window widget for the CameraBrowser UI with fixed dimensions and default open state.
- **Uses:** `Fl_Window`, `xywh`, `type`, `hide`, `open`
- **Reusable:** yes

### CameraBrowser code block
- **Does:** Initializes the CameraBrowser UI state variables, sets up camera data structures and path references, and defines the color attribute and fog-related global defaults.
- **Uses:** `gSelector`, `storedSingleSelect`, `CameraFileList`, `gSelectedCamera`, `gAttributePicked`, `gCameraVals`, `gCurSel`, `gCameraFieldValues`, `gCameraFileValues`, `gCameraFileAttributes`, `gLastBrowserControlClick`, `gCameraBrowserFiles`, `gCameraBrowserFileList`, `gCameraFilesShortNames`, `gCameraSource`, `gCameraSourcePath`, `gCatchCameraPath`, `gSourceRequest`, `gCameraNewName`, `gNewCameraValueItems`, `gCameraValueItems`, `gOldInfo`, `gLastCameraSourceSelection`, `gLastCameraSourceBrowserControlClick`, `gLastSourceDirectory`, `gCameraShortPath`, `gCameraNum`, `gCameraInfoAttributes`, `gCameraDetailsInfo`, `gNumHelpedAttributes`, `gCameraGetInfoTable`, `gCameraToolTipPicked`,

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 3 of 21

### Top level
- **Does:** Contains the file's top-level structure, including the trailing `end} {}` fragment after `MaxOfOne` and the opening of the `listWTFFiles` code block that is not fully shown in the provided code.
- **Uses:** nothing
- **Reusable:** no

### MaxOfOne
- **Does:** Returns 1 when the input value is greater than or equal to 1, otherwise returns nothing. The commented-out branches for nil input and values between 0 and 0.00004 are present but not active.
- **Uses:** nothing
- **Reusable:** yes - pure numeric comparison logic.

### executeTable
- **Does:** Iterates over a table `w`, loading each element as a Lua string with `loadstring`, and if the load succeeds, executes the resulting function. If the load fails, it shows a FLTK message with the error text.
- **Uses:** `loadstring`, `fltk.fl_message`, table indexing (`w[i]`)
- **Reusable:** yes - pure string and table execution logic.

### CameraBrowserGroupsHide
- **Does:** Hides camera browser UI groups based on the currently selected camera tool tip and camera count, and resets camera value inputs when groups are hidden.
- **Uses:** `gCameraToolTipPicked`, `gNumCameras`, widget methods `hide()`, `value()`, `show()`, and global widget references such as `CameraSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `CameraTextureGroup`, `CameraSaveAsGroup`, `CameraInputGroup`, `CameraValueGroup`, `CameraValInputA` through `CameraValInputD`, `CameraBoolBtn`, `CameraNameInput`, `CameraBonesGroup`, `CameraMaterialsGroup`, `CameraMaterialsInputGroup`, `CameraMaterialsValInputA` through `CameraMaterialsValInputD`, `CameraMaterialsBoolBtn`, `CameraMaterialsNameInput`
- **Reusable:** no

### listWTFFiles
- **Does:** Not shown in the provided code; only its opening marker is present.
- **Uses:** nothing
- **Reusable:** no

## Part 4 of 21

### Top level
- **Does:** Contains the file-level code blocks and function definitions for the Fluid/CameraBrowser script, including the `listWTFFiles` and `resetCameraTables` functions and the `CameraBrowserValueCatch` code block.
- **Uses:** `gCameraBrowserFiles`, `wtfFileBrowser`, `CameraSourceGroup`, `gCameraBrowserPath`, `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`, `ig3d_GetCameraInfo__s`, `gCameras`, `gCameraNames`, `gCameraPositions`, `gCameraRotations`, `gCameraMatrix`
- **Reusable:** no
- **Procedural:** no

### listWTFFiles
- **Does:** Lists WTF files and directories under the camera browser path, populates the camera browser files table and the WTF file browser widget.
- **Uses:** `gCameraBrowserFiles`, `wtfFileBrowser`, `CameraSourceGroup`, `gCameraBrowserPath`, `lfs.dir`, `lfs.attributes`, `string.sub`, `table.insert`
- **Reusable:** yes
- **Procedural:** no

### resetCameraTables
- **Does:** Resets the camera info table by reading the current camera info, and initializes the camera tables if they are nil.
- **Uses:** `ig3d_GetCameraInfo__s`, `gCameras`, `gCameraNames`, `gCameraPositions`, `gCameraRotations`, `gCameraMatrix`
- **Reusable:** yes
- **Procedural:** no

### CameraBrowserValueCatch
- **Does:** Contains an unfinished code block for the CameraBrowserValueCatch function.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 5 of 21

### CameraBrowserValueCatch
- **Does:** Collects widget values into CameraFieldValues, normalizes the first camera value, rebuilds the camera value item list from the camera value widgets, and rebuilds the camera materials value item list from the materials value widgets.
- **Uses:** Engine calls `:value()` on `CameraListBrowser`, `CameraAttListBrowser`, `wtfFileBrowser`, `CameraBoolBtn`, `CameraValInputA`, `CameraNameInput`, `CameraMaterialsBrowser`, `CameraMaterialsAttributesBrowser`, `CameraMaterialsBoolBtn`, `CameraValInputA` through `CameraValInputB`/`CameraValInputC`/`CameraValInputD`, `CameraMaterialsValInputA` through `CameraMaterialsValInputD`; globals `CameraFieldValues`, `gCameraValueItems`, `gNewCameraValueItems`, `gCameraMaterialsValueItems`, `gNewCameraMaterialsValueItems`, `curValBool`, `gCameraValueItems`; UI update call `fltk_update()`.
- **Reusable:** no
- **Procedural:** no

## Part 6 of 21

### parseHelpForCameraAttributes
- **Does:** Parses the camera attribute help text from `Data/Help/scripting.txt`, extracts the `IG3D_` property names for the `getCameraInfo` command, and appends any new ones to the `gFoundAttributes` table.
- **Uses:** Engine globals `CameraBrowserValueCatch`, `gFoundAttributes`, `gameroot`; file path `gameroot.."Data/Help/scripting.txt"`; string and table functions (`string.char`, `string.gmatch`, `string.sub`, `string.find`, `string.lower`, `table.insert`); `io.open` for reading the help file.
- **Reusable:** yes - the extraction logic for `IG3D_` property names from help text is reusable for other commands.
- **Procedural:** no

### Top level
- **Does:** No top-level code outside the `parseHelpForCameraAttributes` function; the function body is the only code in this section.
- **Uses:** nothing beyond the function's own uses listed above.
- **Reusable:** no
- **Procedural:** no

## Part 7 of 21

### Top level
- **Does:** Contains the file-level code block for `showCameraColorChooser`, which is not part of either `parseCameraAttributesTable` or `updateCameraAttributesTables`.
- **Uses:** nothing
- **Reusable:** no

### parseCameraAttributesTable
- **Does:** Parses the camera attributes table by iterating over `gFoundAttributes`, building attribute name tables, extracting model info strings, and assembling command strings for retrieving camera info.
- **Uses:** `gFoundAttributes`, `tText`, `gCameraDetailsInfo`, `gCameraInfoAttributes`, `gCameraAttVars`, `gCameraGetInfoTable`, `whichCommand`, `whichElement`, `string.upper`, `string.match`, `string.find`, `string.sub`, `string.gmatch`, `string.len`, `table.insert`
- **Reusable:** no

### updateCameraAttributesTables
- **Does:** Updates the camera details info table by executing the stored info retrieval commands, then builds the selected camera data and camera attributes tables from the results.
- **Uses:** `gCameraGetInfoTable`, `gCameraDetailsInfo`, `gSelCameraData`, `gCameraAttributes`, `gFoundAttributes`, `executeTable`, `tostring`, `string.sub`, `table.insert`
- **Reusable:** no

### showCameraColorChooser
- **Does:** Contains the file-level code block for `showCameraColorChooser`, which is not part of either `parseCameraAttributesTable` or `updateCameraAttributesTables`.
- **Uses:** nothing
- **Reusable:** no

## Part 8 of 21

### showCameraColorChooser
- **Does:** Opens a color chooser for the selected material attribute, applies the chosen color to the camera, updates the camera material value inputs, and triggers the camera browser value catch.
- **Uses:** `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gRed`, `gGreen`, `gBlue`, `fltk.fl_color_chooser`, `Fl:set_color`, `CameraMaterialsValInputA`, `CameraMaterialsValInputB`, `CameraMaterialsValInputC`, `CameraBrowserValueCatch`, `gNewCameraMaterialsValueItems`, `changeCameraMaterialsVal`
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Defines the `showCameraColorChooser` function and includes the `CameraBrowserWindowUpdate` code block following it.
- **Uses:** `gSelectedMaterialAttributes`, `gSelectedMaterialAttribute`, `gRed`, `gGreen`, `gBlue`, `fltk.fl_color_chooser`, `Fl:set_color`, `CameraMaterialsValInputA`, `CameraMaterialsValInputB`, `CameraMaterialsValInputC`, `CameraBrowserValueCatch`, `gNewCameraMaterialsValueItems`, `changeCameraMaterialsVal`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 21

### CameraBrowserWindowUpdate
- **Does:** Updates the CameraBrowser window based on the requested argument, refreshing camera lists, camera attributes, and selected camera values, then triggers the UI update.
- **Uses:** Engine calls (`CameraBrowser:make_current()`, `CameraBrowserValueCatch()`, `CameraBrowserGroupsHide()`, `fltk_update()`), globals (`CameraBrowser`, `gCameraFilesShortNames`, `gCameraAttributes`, `gSelCameraData`, `gCameraNames`, `gSelectedCamera`, `gCameraourcePath`, `gSourceRequest`, `gOldInfo`, `gSelectedCameraInfo`), widget calls (`wtfFileBrowser:value()`, `wtfFileBrowser:clear()`, `wtfFileBrowser:add()`, `SourceNameInput:value()`, `SourceNameInput:redraw()`, `CameraAttListBrowser:clear()`, `CameraAttListBrowser:add()`, `CameraAttListBrowser:value()`, `CameraAttListBrowser:select()`, `CameraValueListBrowser:clear()`, `CameraValueListBrowser:add()`, `CameraValueListBrowser:value()`, `CameraValueListBrowser:select()`, `CameraListBrowser:clear()`, `CameraListBrowser:add()`, `CameraListBrowser:select()`, `CameraListBrowser:value()`, `CameraListBrowser:selected()`, `CameraFieldValues`), and `Data/` paths (`Data/WTF/`).
- **Reusable:** yes - it is a UI update handler that reuses the same browser refresh logic for camera-related UI elements.
- **Procedural:** no

### Top level
- **Does:** Contains the trailing `code {-- updateCameraListBrowser` block marker for the FLUID UI file, with no additional top-level executable setup, globals, or widget definitions beyond the function above.
- **Uses:** nothing
- **Reusable:** no

## Part 10 of 21

### Top level
- **Does:** No top-level code outside the two functions; the file begins directly with the function definitions.
- **Uses:** nothing
- **Reusable:** no

### updateCameraListBrowser
- **Does:** Reads the camera list from the engine, parses its lines into a shared camera name table, then refreshes the camera browser window.
- **Uses:** `ig3d_GetCamerasList__s()`, `getlinecount`, `getlineof`, `string.len`, `table.insert`, `CameraBrowserValueCatch`, `CameraBrowserWindowUpdate`, `gCameraNames`
- **Reusable:** no

### CurCameraInfo
- **Does:** Reads the selected camera's info from the engine, clears and repopulates the camera value list browser with the info's lines, then returns the selected camera info.
- **Uses:** `ig3d_GetCameraInfo__s()`, `getlinecount`, `getlineof`, `CameraValueListBrowser:clear`, `CameraValueListBrowser:add`, `gSelectedCameraInfo`, `gCameraAttributes`
- **Reusable:** no

## Part 11 of 21

### Top level
- **Does:** Contains no standalone setup, global definitions, or widget-level code outside the four listed functions; the only code present belongs to the function sections below.
- **Uses:** nothing
- **Reusable:** no

### changeCameraVal
- **Does:** Updates the selected camera's field value, writes the updated values to the camera info string, and applies the changes to the selected camera object.
- **Uses:** `CameraBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `gSelectedCameraInfo`, `gSelCameraData`, `gCameraValues`, `gObjName`, `ig3d_SetCameraInfo_2s`, `gCameraInfoAttributes`, `gCameraNum`, `CurCameraInfo`
- **Reusable:** no

### CameraValInput
- **Does:** Reads the new camera value items, joins them into a string, and passes the resulting value to changeCameraVal.
- **Uses:** `CameraBrowser`, `CameraBrowserValueCatch`, `gNewCameraValueItems`, `changeCameraVal`
- **Reusable:** no

### changeCameraBool
- **Does:** Sets the selected camera's field value to true or false based on the widget value, loads the corresponding setCameraInfo code string, executes it, and refreshes the UI.
- **Uses:** `CameraBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `gSelectedCameraInfo`, `gSelCameraData`, `gCameraInfoAttributes`, `loadstring`, `CurCameraInfo`, `fltk_update`
- **Reusable:** no

### PickCameraDetails
- **Does:** Shows the appropriate camera detail group based on the selected camera attribute type.
- **Uses:** `CameraBrowserValueCatch`, `gCameraAttributes`, `CameraFieldValues`, `CameraBonesGroup`, `CameraMaterialsGroup`, `listWTFFiles`
- **Reusable:** no

## Part 12 of 21

### PickedCameraAttribute
- **Does:** Opens the camera browser UI, updates the camera source selection when the source list is requested, and shows/hides camera attribute input widgets based on the selected camera attribute index and value type.
- **Uses:** `CameraBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `gSelectedCameraInfo`, `CurCameraInfo`, `CameraBrowserGroupsHide`, `CameraNameInput`, `CameraBrowserWindowUpdate`, `gSourceRequest`, `wtfFileBrowser`, `CameraSourceGroup`, `CameraValueGroup`, `CameraInputGroup`, `CameraNameInput`, `CameraValInputA`–`D`, `CameraBoolBtn`, `gCameraToolTipPicked`, `gSelCameraData`, `gCameraAttributes`, `gCameraValueItems`, `numberofitems`, `item`, `fltk_update`.
- **Reusable:** no
- **Procedural:** no

## Part 13 of 21

### Top level
- **Does:** Contains the file's top-level structure, including the continuation of the camera rename function and the `updateMaterialsTables` function body, plus the start of the `updateMaterialBrowsers` code block.
- **Uses:** `nName`, `changeCameraVal`, `updateCameraListBrowser`, `PickedCameraAttribute`, `CameraFieldValues`, `gSelectedMaterialAttributes`, `gSelectedMaterialValues`, `gSelectedMaterialData`, `gselCameraMaterialsList`, `cMatList`, `mcount`, `getlinecount`, `getlineof`, `string.len`, `string.find`, `string.sub`, `ig3d_GetCameraMaterialsList_s_s`, `ig3d_GetCameraMaterialInfo_s_s`, `gObjName`, `CameraMaterialsBrowser`, `gSelectedMaterial`.
- **Reusable:** no

### RenameCamera
- **Does:** Renames the selected camera by reading the current value from the camera widget, updating the camera value, refreshing the camera list browser, and applying the picked camera attribute.
- **Uses:** `w:value()`, `tostring`, `changeCameraVal`, `updateCameraListBrowser`, `PickedCameraAttribute`, `CameraFieldValues`.
- **Reusable:** no

### updateMaterialsTables
- **Does:** Populates the selected material attribute, value, and raw data tables by reading camera material list and material info output, splitting each info line into attribute and value pairs, and handling the first two lines specially.
- **Uses:** `gSelectedMaterialAttributes`, `gSelectedMaterialValues`, `gSelectedMaterialData`, `gselCameraMaterialsList`, `CameraFieldValues`, `ig3d_GetCameraMaterialsList_s_s`, `ig3d_GetCameraMaterialInfo_s_s`, `gObjName`, `getlinecount`, `getlineof`, `string.len`, `string.find`, `string.sub`, `CameraMaterialsBrowser`, `gSelectedMaterial`.
- **Reusable:** no

### updateMaterialBrowsers
- **Does:** Not defined in this code section; only the start of the code block for this function is present.
- **Uses:** nothing
- **Reusable:** no

## Part 14 of 21

### Top level
- **Does:** Contains the file-level code blocks and function definitions for the Fluid/CameraBrowser script, including the `changeCameraMaterialsVal` function and the trailing `CameraMaterialsValInput` code block header.
- **Uses:** `CameraBrowser`, `CameraFieldValues`, `gSelectedMaterialData`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gselCameraMaterialsList`, `gSelectedCameraInfo`, `CurCameraInfo()`, `ig3d_SetCameraMaterialInfo_sis`, `fltk_update`, `updateMaterialBrowsers`, `CameraBrowserValueCatch()`, `CameraBrowserGroupsHide()`, `updateMaterialsTables()`, and browser widget calls (`clear`, `add`, `select`, `value`, `selected`).
- **Reusable:** no

### updateMaterialBrowsers
- **Does:** Rebuilds the material browser UI state by clearing the three material browser widgets, then repopulates them from the selected material values, attributes, and camera material list, and applies the selected field values to the browser widgets.
- **Uses:** `CameraBrowserValueCatch()`, `CameraBrowserGroupsHide()`, `updateMaterialsTables()`, `CameraMaterialsAttributesBrowser:clear()`, `CameraMaterialsValuesBrowser:clear()`, `CameraMaterialsBrowser:clear()`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gselCameraMaterialsList`, `CameraFieldValues`, and browser widget calls (`add`, `select`, `value`, `selected`).
- **Reusable:** yes

### changeCameraMaterialsVal
- **Does:** Sets the selected material value for the current camera line, builds a material string from the selected material values, updates the camera material info via the engine call, prints the material string, and refreshes the material browsers and UI.
- **Uses:** `CameraBrowser`, `CameraFieldValues`, `gSelectedMaterialData`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gSelectedCameraInfo`, `CurCameraInfo()`, `ig3d_SetCameraMaterialInfo_sis`, `updateMaterialBrowsers()`, `fltk_update()`, and browser widget calls (`clear`, `add`, `select`, `value`, `selected`).
- **Reusable:** yes

### CameraMaterialsValInput
- **Does:** Contains the code block header for the `CameraMaterialsValInput` function, which is not defined in this part of the code.
- **Uses:** nothing
- **Reusable:** no

## Part 15 of 21

### CameraMaterialsValInput
- **Does:** Returns early if CameraBrowser is nil, calls CameraBrowserValueCatch, builds a comma-separated string from the gNewCameraMaterialsValueItems array, and passes that string to changeCameraMaterialsVal.
- **Uses:** Engine calls `CameraBrowserValueCatch`, `changeCameraMaterialsVal`; globals `CameraBrowser`, `gNewCameraMaterialsValueItems`; no files or Data/ paths.
- **Reusable:** no

### Top level
- **Does:** Defines the function CameraMaterialsValInput with a trailing empty block, and includes a code block labeled PickedCameraMaterialsAttribute.
- **Uses:** nothing beyond the function definition and code block label shown.
- **Reusable:** no

## Part 16 of 21

### PickedMaterialsAttribute
- **Does:** Shows or hides camera material browser UI groups based on the picked material attribute, populates material value inputs from the selected material, and updates boolean and numeric material value widgets accordingly.
- **Uses:** Engine calls `CameraBrowser == nil` check, `CameraBrowserValueCatch()`, `CurCameraInfo()`, `fltk_update()`; globals `CameraBrowser`, `CameraBrowserGroupsHide`, `CameraFieldValues`, `gSelectedCameraInfo`, `gSelectedMaterialValues`, `gSelectedMaterialAttributes`, `gCameraMaterialsValueItems`, `gRed`, `gGreen`, `gBlue`, `CameraMaterialsGroup`, `CameraMaterialsInputGroup`, `CameraMaterialsNameInput`, `CameraMaterialsValInputA`–`D`, `CameraMaterialsBoolBtn`; functions `CurCameraInfo()`, `numberofitems()`, `item()`, `string.find()`, `tostring()`, `tonumber()`; file `script.fl` (Fluid/CameraBrowser).
- **Reusable:** yes - UI attribute handling logic that can be adapted for other material browser attributes.

### Top level
- **Does:** No top-level code outside the `PickedMaterialsAttribute` function; the only top-level content is the trailing FLUID file marker for the `changeCameraMaterialsBool` callback.
- **Uses:** nothing beyond the file's own structure.
- **Reusable:** no

## Part 17 of 21

### Top level
- **Does:** Contains no standalone setup, global definitions, or widget-level code outside the listed functions; the file continues from earlier parts with no additional top-level statements shown.
- **Uses:** nothing
- **Reusable:** no

### changeCameraMaterialsBool
- **Does:** Changes the boolean value of the camera material attribute selected by the current line, updates the material string, calls the engine camera material info setter, and refreshes the FLTK UI.
- **Uses:** `CameraBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `gChangeMaterial`, `gSelectedMaterialAttributes`, `gSelectedMaterialValues`, `MatString`, `MaterialsUpdate`, `ig3d_SetCameraMaterialInfo_sis`, `gSelectedCamera`, `fltk_update`
- **Reusable:** yes

### CameraAttPicked
- **Does:** Validates the picked camera attribute value, selects it in the camera value list browser, sets the selected value, catches the camera value change, and triggers picking the camera attribute.
- **Uses:** `CameraBrowser`, `w:value()`, `CameraValueListBrowser`, `CameraFieldValues`, `PickedCameraAttribute`
- **Reusable:** yes

### CameraMaterialsAttributesBrowserCallback
- **Does:** Sets the selected material attribute, selects and sets its value in the material attribute and value browsers, updates material browsers, triggers picking the material attribute, and shows the camera color chooser if the attribute is colorful.
- **Uses:** `w:value()`, `gSelectedMaterialAttribute`, `CameraMaterialsAttributesBrowser`, `CameraMaterialsValuesBrowser`, `updateMaterialBrowsers`, `PickedMaterialsAttribute`, `colorfulMaterialAtt`, `showCameraColorChooser`
- **Reusable:** yes

### CameraMaterialsBrowserCallback
- **Does:** Sets the selected material and updates the material browsers.
- **Uses:** `w:value()`, `gSelectedMaterial`, `updateMaterialBrowsers`
- **Reusable:** yes

### CameraBonesBrowserCallback
- **Does:** Contains only an empty function body with no implementation.
- **Uses:** nothing
- **Reusable:** no

### CameraValueListCallback
- **Does:** Validates the picked value, selects it in the camera attribute list browser, sets the selected value, catches the camera value change, and triggers picking the camera attribute.
- **Uses:** `CameraBrowser`, `w:value()`, `CameraAttListBrowser`, `CameraFieldValues`, `PickedCameraAttribute`
- **Reusable:** yes

### CameraSourceBrowserControlDoubleClicked
- **Does:** No code is shown for this function in the provided source.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 18 of 21

### Top level
- **Does:** Contains only the continuation of the file's function definitions and the opening of the `ReplaceAllWTFSourceBtnClick` section; no setup, globals, or widget definitions are present.
- **Uses:** nothing
- **Reusable:** no

### CameraSourceBrowserControlDoubleClicked
- **Does:** Handles double-clicking a camera source browser entry. If the selected entry points to a directory, it navigates up or into the directory, refreshes the WTF file list, and updates the last source directory when entering a subdirectory.
- **Uses:** `gCameraBrowserFiles`, `gCameraBrowserPath`, `gLastSourceDirectory`, `goDirsUp`, `listWTFFiles`
- **Reusable:** no

### CameraSourcebrowserControlClicked
- **Does:** Handles single-clicking a camera source browser entry. If the entry is a file, it updates the WTF preview box, sets the WTF replacement file path, and shows the replacement buttons. It also tracks click timing and selection state to trigger the double-click handler when a click repeats within 0.4 seconds.
- **Uses:** `gCameraBrowserFiles`, `gLastSourceDirectory`, `gWTFReplacementFile`, `gCameraShortPath`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `time`, `gLastCameraSourceBrowserControlClick`, `gLastCameraSourceSelection`, `CameraSourceBrowserControlDoubleClicked`
- **Reusable:** no

### ReplaceWTFSourceBtnClick
- **Does:** Reads the current level script file, extracts the `gCameraWTFs` and `gCameraNames` table definitions, replaces the camera WTF source table with the newly set replacement file, writes the updated script file, and reloads the current level.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s`, `io.open`, `string.find`, `string.sub`, `loadstring`, `gCameraWTFs`, `gCameraNum`, `gWTFReplacementFile`, `loadLevel`
- **Reusable:** no

### ReplaceAllWTFSourceBtnClick
- **Does:** Defines the `ReplaceAllWTFSourceBtnClick` function; no body code is present in this section.
- **Uses:** nothing
- **Reusable:** no

## Part 19 of 21

### Top level
- **Does:** Defines shared camera menu state tables and the camera menu text labels used by the camera browser functions.
- **Uses:** `CameraMenuIndex`, `CameraMenuText`, `CameraMenuText.Source`, `CameraMenuText.Control`
- **Reusable:** yes

### ReplaceAllWTFSourceBtnClick
- **Does:** Opens the current level's load script.lua, replaces every occurrence of the camera short path with the WTF replacement file, writes the modified script back, then loads the current level again.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s`, `io.open`, `string.gmatch`, `string.gsub`, `gWTFReplacementFile`, `loadLevel`, `gCameraShortPath`
- **Reusable:** no

### fillCameraSourceMenu
- **Does:** Fills the camera source menu with the Make, Save, and Duplicate source options, plus an empty trailing entry, and marks the menu for redraw.
- **Uses:** `CameraBrowser`, `CameraMenu`, `CameraMenuIndex`, `CameraMenuText.Source`, `table.insert`, `CameraMenu:add`, `CameraMenu:redraw`
- **Reusable:** yes

### fillCameraControlMenu
- **Does:** Fills the camera control menu with the Run, Stop, and Clear options, an empty trailing entry, the All/Run, All/Stop, and All/Clear options, and marks the menu for redraw.
- **Uses:** `CameraBrowser`, `CameraMenu`, `CameraMenuIndex`, `CameraMenuText.Control`, `table.insert`, `CameraMenu:add`, `CameraMenu:redraw`
- **Reusable:** yes

### CameraCurrentPick
- **Does:** Renders the scene when the camera control pick is Clear, Run, or Stop.
- **Uses:** `render`
- **Reusable:** yes

### Top level
- **Does:** Defines the shared camera menu state tables and the camera menu text labels used by the camera browser functions.
- **Uses:** `CameraMenuIndex`, `CameraMenuText`, `CameraMenuText.Source`, `CameraMenuText.Control`
- **Reusable:** yes

### ReplaceAllWTFSourceBtnClick
- **Does:** Opens the current level's load script.lua, replaces every occurrence of the camera short path with the WTF replacement file, writes the modified script back, then loads the current level again.
- **Uses:** `gameroot`, `ig3d_GetLevelName__s`, `io.open`, `string.gmatch`, `string.gsub`, `gWTFReplacementFile`, `loadLevel`, `gCameraShortPath`
- **Reusable:** no

### fillCameraSourceMenu
- **Does:** Fills the camera source menu with the Make, Save, and Duplicate source options, plus an empty trailing entry, and marks the menu for redraw.
- **Uses:** `CameraBrowser`, `CameraMenu`, `CameraMenuIndex`, `CameraMenuText.Source`, `table.insert`, `CameraMenu:add`, `CameraMenu:redraw`
- **Reusable:** yes

### fillCameraControlMenu
- **Does:** Fills the camera control menu with the Run, Stop, and Clear options, an empty trailing entry, the All/Run, All/Stop, and All/Clear options, and marks the menu for redraw.
- **Uses:** `CameraBrowser`, `CameraMenu`, `CameraMenuIndex`, `CameraMenuText.Control`, `table.insert`, `CameraMenu:add`, `CameraMenu:redraw`
- **Reusable:** yes

### CameraCurrentPick
- **Does:** Renders the scene when the camera control pick is Clear, Run, or Stop.
- **Uses:** `render`
- **Reusable:** yes

## Part 20 of 21

### Top level
- **Does:** Contains no setup, globals or widget definitions outside the three listed functions; the only code outside functions is a trailing `code {-- CameraToolPick` marker with no body.
- **Uses:** nothing
- **Reusable:** no

### CameraBrowsersMenuPick
- **Does:** Handles the "Save", "Make", and "Duplicate" actions of the camera browser pick menu, hiding or showing camera attribute groups, setting the source request and clearing the value list when making a camera.
- **Uses:** `CameraBrowser`, `CurCameraInfo`, `PickedCameraAttribute`, `CameraInputGroup`, `CameraourceGroup`, `CameraValueGroup`, `CameraTextureGroup`, `CameraaveAsGroup`, `wtfFileBrowser`, `gSourceRequest`, `ValueListBrowser`, `MakeCamera`, `render`
- **Reusable:** no

### Camera_menu_callback
- **Does:** Reads the selected menu value and text from the camera menu widget, looks up adjacent menu indices, dispatches the pick action based on the selected menu head, and clears/handles the "All/Clear" and "Current/Clear" entries.
- **Uses:** `CameraBrowser`, `w:label()`, `w:value()`, `w:text()`, `CameraMenuIndex`, `CameramenuHead`, `CameraBrowsersMenuPick`, `CameraCurrentPick`, `CameraAllMenuPick`, `Fl:check()`, `io.flush()`
- **Reusable:** no

### Camera_MenuBarFill
- **Does:** Fills the camera source menu and camera control menu when the camera browser is active.
- **Uses:** `CameraBrowser`, `fillCameraSourceMenu`, `fillCameraControlMenu`
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Handles the camera list browser widget, resets camera tables, selects the picked camera object, updates camera info, sets the camera face object, and renders the result.
- **Uses:** `CameraBrowser`, `w:value()`, `CameraBrowserValueCatch`, `resetCameraTables`, `gObjName`, `gCameraNames`, `ig3d_SetSelection_s`, `gSelectedCamera`, `CurCameraInfo`, `gCameraNum`, `camera_faceObj`, `gCameraToolTipPicked`, `CameraFieldValues`, `updateMaterialsTables`, `render`
- **Reusable:** no

## Part 21 of 21

### Top level
- **Does:** Contains the file-level structure and the three function definitions for the CameraBrowser Fluid/CameraBrowser part.
- **Uses:** `CameraBrowserValueCatch`, `CameraBrowserGroupsHide`, `CameraBonesGroup`, `CameraMaterialsGroup`, `listWTFFiles`, `CameraValueGroup`, `fltk_update`, `gCameraToolTipPicked`, `gCameraBrowserFiles`, `gCameras`, `gDropCamera`, `gCameraBrowserPath`, `make`, `updateCameraListBrowser`, `wtfFileBrowser`, `gameroot`, `Data/WTF/`
- **Reusable:** no

### CameraToolPick
- **Does:** Shows the appropriate camera tool group based on the picked tooltip value, then refreshes the UI.
- **Uses:** `CameraBrowserValueCatch`, `CameraBrowserGroupsHide`, `CameraBonesGroup`, `CameraMaterialsGroup`, `listWTFFiles`, `CameraValueGroup`, `gCameraToolTipPicked`, `fltk_update`
- **Reusable:** no

### cameraToolBtnCallback
- **Does:** Captures the tooltip value from the clicked button and passes it to CameraToolPick.
- **Uses:** `w:tooltip`, `gCameraToolTipPicked`, `CameraToolPick`
- **Reusable:** no

### CamerawtfAddCameraClicked
- **Does:** Adds a new camera object from a selected WTF file when the file is not a directory, updates the camera list browser, and sets the drop camera path.
- **Uses:** `wtfFileBrowser:value`, `gCameraToolTipPicked`, `gCameraBrowserFiles`, `gCameras`, `gDropCamera`, `gCameraBrowserPath`, `make`, `updateCameraListBrowser`, `gameroot`, `Data/WTF/`
- **Reusable:** no
- **Procedural:** no
