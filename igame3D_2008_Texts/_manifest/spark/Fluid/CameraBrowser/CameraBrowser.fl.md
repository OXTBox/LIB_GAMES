<!-- Spark first-look of Data/Fluid/CameraBrowser/CameraBrowser.fl (model spark-x2.6-4b, 2026-11-12 19:47). DRAFT for Claude to review. -->

## CameraBrowser.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface definition for the iGame3D CameraBrowser, a dialog that lets a programmer browse and edit camera sources, attributes, values, and materials through a set of FLTK widgets and callback handlers. It defines the window, its groups and controls, and the Lua callbacks that wire those widgets to the engine's camera data.
- **Depends on:** `Data/Levels/` path construction via `gameroot.."Data/Levels/"`, `Data/WTF/` path reference, `Data/Icons/ModelsBrowser/Models_` path reference, `Data/` folder code paths via `gameroot.."Data/<Folder>/<file>"`, engine calls (`ig3d_GetCameraInfo__s`, `CameraBrowser:make_current()`, `CameraBrowser:label("")`, `CameraBrowser:show()`, `CameraBrowser:make_current()`), globals (`gCameraToolTipPicked`, `gNumCameras`, `gCameraValueItems`, `gNewCameraValueItems`, `gCurrentCameraInfo`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gSelCameraData`, `gCamerasRotations`, `gSelectedCameraInfo`, `gSelectedCamera`, `gCameraFilesShortNames`, `gCameraAttributes`, `gCameraNames`, `gSourceRequest`, `gCameraourcePath`, `CameraFieldValues`, `CameraBrowser`, `CameraBrowserValueCatch`, `CurCameraInfo`, `CameraBrowserGroupsHide`, `CameraBrowserWindowUpdate`, `updateCameraListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraValueListBrowser`, `CameraListBrowser`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CurCameraInfo`, `CameraBrowserWindowUpdate`, `gSelectedCamera`, `w:value`, `CameraValueGroup`, `CameraBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`, `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`,

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 10

### make_window
- **Does:** Opens the CameraBrowser window, initializes its state variables, and sets up the camera-related data structures and default values used by the browser.
- **Uses:** `ig3d_GetCameraInfo__s()`, `getlineof`, `time()`, `gameroot`, `Data/` path construction via `gameroot.."Data/Levels/"`, and the FLUID UI designer constructs (`code`, `Function` blocks).
- **Reusable:** no
- **Procedural:** no

### Top level
- **Does:** Defines the FLUID data file header and the `make_window` function entry, which opens the CameraBrowser UI.
- **Uses:** `version`, `header_name`, `code_name`, `Function`, `code` blocks from the FLUID UI designer file structure.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 10

### CameraBrowserGroupsHide
- **Does:** Hides camera-related UI groups and input widgets based on the currently selected camera tool tip and camera count, showing only the relevant groups when a camera is selected for translation or materials.
- **Uses:** `gCameraToolTipPicked`, `gNumCameras`, widget methods `hide()`, `value()`, `show()` (CameraSourceGroup, ReplaceWTFSourceBtn, ReplaceAllWTFSourceBtn, CameraTextureGroup, CameraSaveAsGroup, CameraInputGroup, CameraValueGroup, CameraValInputA-D, CameraBoolBtn, CameraNameInput, CameraBonesGroup, CameraMaterialsGroup, CameraMaterialsInputGroup, CameraMaterialsValInputA-D, CameraMaterialsBoolBtn, CameraMaterialsNameInput)
- **Reusable:** no
- **Procedural:** no

## Part 3 of 10

### CameraBrowserValueCatch
- **Does:** Copies camera field values from the camera browser widgets, then rebuilds the camera value items list from the current value selection, finally updates the FLTK UI.
- **Uses:** `CameraFieldValues`, `CameraListBrowser`, `CameraAttListBrowser`, `CameraBoolBtn`, `CameraValInputA`, `CameraValInputB`, `CameraValInputC`, `CameraValInputD`, `CameraNameInput`, `gCameraValueItems`, `gNewCameraValueItems`, `fltk_update`
- **Reusable:** no
- **Procedural:** no

### CurCameraInfo
- **Does:** Reads the current camera info and its position and rotation lines, stores them in global variables, builds a selection data table from the position and camera rotations, and returns the full current camera info.
- **Uses:** `gCurrentCameraInfo`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gSelCameraData`, `gCamerasRotations`, `ig3d_GetCameraInfo__s`, `getlineof`
- **Reusable:** no
- **Procedural:** no

## Part 4 of 10

### PickedCameraAttribute
- **Does:** Selects the camera attribute to edit in the CameraBrowser, showing or hiding camera value and boolean input widgets based on the selected attribute and its value.
- **Uses:** Engine calls `CameraBrowser == nil`, `CameraBrowserValueCatch()`, `CurCameraInfo()`, `fltk_update()`; globals `CameraBrowserGroupsHide()`, `gSelectedCameraInfo`, `CameraFieldValues`, `gCameraValues`, `gSelCameraData`, `gCameraAttributes`, `gCameraValueItems`, `gCameraToolTipPicked`, `curVal`, `curValBool`, `curValF`, `sstr`, `CameraBrowserGroupsHide()`, `CameraValueGroup`, `CameraInputGroup`, `CameraNameInput`, `CameraValInputA`–`D`, `CameraBoolBtn`; no `Data/` paths.
- **Reusable:** with changes - widget show/hide logic tied to specific camera browser UI elements and attribute values.
- **Procedural:** no

## Part 5 of 10

### CameraBrowserWindowUpdate
- **Does:** Updates the CameraBrowser UI based on the requested argument, manages camera selection and attribute values, and refreshes the camera browser widgets.
- **Uses:** Engine calls (`CameraBrowser:make_current()`, `CameraBrowserValueCatch()`, `fltk_update()`), globals (`CameraBrowser`, `CameraFieldValues`, `gCameraFilesShortNames`, `gCameraAttributes`, `gSelCameraData`, `gCameraNames`, `gSelectedCamera`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gOldInfo`, `gSelectedCameraInfo`, `gSourceRequest`, `gCameraourcePath`, `gCameraFilesShortNames`, `gCameraAttributes`, `gSelCameraData`, `gCameraNames`, `gSelectedCamera`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gOldInfo`, `gSelectedCameraInfo`, `gSourceRequest`), widget calls (`wtfFileBrowser:value()`, `wtfFileBrowser:clear()`, `wtfFileBrowser:add()`, `SourceNameInput:value()`, `SourceNameInput:redraw()`, `CameraAttListBrowser:clear()`, `CameraAttListBrowser:add()`, `CameraAttListBrowser:redraw()`, `CameraAttListBrowser:value()`, `CameraAttListBrowser:select()`, `CameraValueListBrowser:clear()`, `CameraValueListBrowser:add()`, `CameraValueListBrowser:value()`, `CameraValueListBrowser:select()`, `CameraListBrowser:clear()`, `CameraListBrowser:add()`, `CameraListBrowser:select()`, `CameraListBrowser:value()`, `CameraListBrowser:selected()`, `CameraFieldValues[1] = EBLn`), and file/path references (`Data/WTF/`).
- **Reusable:** yes - the argument-driven UI update logic for camera browser widgets can be adapted to other camera-related UI flows.
- **Procedural:** no

### Top level
- **Does:** Contains the trailing `code {-- CameraValueListCallback` marker block that belongs to the file's UI callback definition, with no executable setup or global definitions preceding the function.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 6 of 10

### Top level
- **Does:** Contains the FLUID UI file structure for CameraBrowser, including widget definitions and code blocks for the camera list browser functions.
- **Uses:** nothing
- **Reusable:** no

### CameraValueListCallback
- **Does:** Validates the browser is initialized and the widget has a value, then sets and selects the camera attribute list browser value, triggers the camera value catch, and calls the picked camera attribute with CameraFieldValues[2].
- **Uses:** `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`
- **Reusable:** no

### CameraAttPicked
- **Does:** Validates the browser is initialized and the widget has a value, then sets and selects the camera value list browser value, triggers the camera value catch, and calls the picked camera attribute with CameraFieldValues[2].
- **Uses:** `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `CameraFieldValues`
- **Reusable:** no

### updateCameraListBrowser
- **Does:** Calls CurCameraInfo, updates the camera list browser window with the function name, and ends the code block.
- **Uses:** `CurCameraInfo`, `CameraBrowserWindowUpdate`
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Validates the browser is initialized, reads the widget value into n, sets the selected camera, calls CurCameraInfo, updates the camera list browser, shows the camera value group, and ends the code block.
- **Uses:** `CameraBrowser`, `w:value`, `gSelectedCamera`, `CurCameraInfo`, `updateCameraListBrowser`, `CameraValueGroup`
- **Reusable:** no

## Part 7 of 10

### Top level
- **Does:** Defines the CameraBrowser window and its widgets, including camera tool buttons, menu bar, save controls, and camera source browser controls.
- **Uses:** `Fl_Window`, `Fl_Group`, `Fl_Button`, `Fl_Menu_Bar`, `Fl_Input`, `Fl_Browser` FLTK UI constructs; widget attributes such as `xywh`, `callback`, `label`, `type`, `color`, `labelsize`, `align`, `visible`, `when`, `textsize`, `tooltip`; `code` and `callback` block markers.
- **Reusable:** no

### CameraBrowser
- **Does:** Provides the main camera browser interface for selecting and managing camera sources, with tool buttons, save options, and source browser controls.
- **Uses:** `Fl_Window CameraBrowser`, `Fl_Group mainttoolsgroup`, `Fl_Menu_Bar CameraMenu`, `Fl_Group CameraSaveAsGroup`, `Fl_Group CameraSourceGroup`, `Fl_Group ReplaceSourceGroup`, `Fl_Button cameratool1` through `cameratool7`, `Fl_Button PSaveControl`, `Fl_Input SourceNameInput`, `Fl_Button ReplaceWTFSourceBtn`, `Fl_Button ReplaceAllWTFSourceBtn`, `Fl_Browser wtfFileBrowser`, `Fl_Button MakeCameraWTFBtn`; widget attributes including `callback`, `xywh`, `label`, `type`, `color`, `labelsize`, `align`, `visible`, `when`, `textsize`, `tooltip`.
- **Reusable:** no

### Camera_menu_callback
- **Does:** Handles the callback for the CameraMenu menu bar widget.
- **Uses:** `Fl_Menu_Bar CameraMenu` widget; its `callback Camera_menu_callback` attribute.
- **Reusable:** no

### cameraToolBtnCallback
- **Does:** Handles the callback for the camera tool button widgets.
- **Uses:** `Fl_Button cameratool1` through `Fl_Button cameratool7` widgets; their `callback cameraToolBtnCallback` attribute.
- **Reusable:** no

### CameraSaveButtonClick
- **Does:** Handles the callback for the save-related input and button widgets.
- **Uses:** `Fl_Input SourceNameInput` and `Fl_Button PSaveControl` widgets; their `callback CameraSaveButtonClick` attribute.
- **Reusable:** no

### ReplaceWTFSourceBtnClick
- **Does:** Handles the callback for the replace WTF source button widget.
- **Uses:** `Fl_Button ReplaceWTFSourceBtn` widget; its `callback ReplaceWTFSourceBtnClick` attribute.
- **Reusable:** no

### ReplaceAllWTFSourceBtnClick
- **Does:** Handles the callback for the replace all WTF source button widget.
- **Uses:** `Fl_Button ReplaceAllWTFSourceBtn` widget; its `callback ReplaceAllWTFSourceBtnClick` attribute.
- **Reusable:** no

### CameraSourcebrowserControlClicked
- **Does:** Handles the callback for the camera source browser widget.
- **Uses:** `Fl_B

<!-- CUT OFF: reached max_tokens (700); delete this file and rerun -->

## Part 8 of 10

### Top level
- **Does:** Defines the top-level FLTK UI widgets for the CameraBrowser, including camera material browser groups, material input controls, and the camera texture preview group.
- **Uses:** FLTK UI constructs (`Fl_Button`, `Fl_Group`, `Fl_Browser`, `Fl_Input`, `Fl_Check_Button`, `Fl_Value_Input`, `Fl_Box`) with their exact widget names and layout properties; callback names (`ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `CameraMaterialsBrowserCallback`, `CameraMaterialsAttributesBrowserCallback`, `RenameCameraMaterials`, `changeCameraMaterialsBool`, `CameraMaterialsValInput`, `pngLoad`); `Data/` paths referenced via the `tooltip {make model}` block; `xywh`, `labelsize`, `color`, `box`, `align`, `when`, `type`, `minimum`, `step`, `textsize` widget properties.
- **Reusable:** no
- **Procedural:** no

## Part 9 of 10

### Top level
- **Does:** Defines the FLTK UI widgets for the CameraBrowser, including the camera list browser, camera input group with name, boolean, and x/y/z/a value inputs, camera root group, camera bones group, and camera value/attribute browsers, plus the final code block that resets the camera label, shows the browser, makes it current, and comments out several setup calls.
- **Uses:** FLTK UI widgets (`Fl_Browser`, `Fl_Group`, `Fl_Input`, `Fl_Check_Button`, `Fl_Value_Input`, `Fl_Window`-style group definitions) with their `xywh`, `label`, `callback`, `color`, `labelsize`, `textsize`, `type`, `when`, `minimum`, `maximum`, `step`, `align`, `box`, `EMBOSSED_BOX`, `DOWN_BOX` properties; the `code` block containing `CameraBrowser:label("")`, `CameraBrowser:show()`, `CameraBrowser:make_current()`, and commented-out calls `--resetCameraTables()`, `--updateCameraListBrowser()`, `--Camera_MenuBarFill()`.
- **Reusable:** no
- **Procedural:** no

## Part 10 of 10

### Top level
- **Does:** Sets up the CameraBrowser button icons, registers the shared images, and wires the camera tool buttons to their icons, tooltips and redraw/when handlers.
- **Uses:** `fltk.fl_register_images()`, `gameroot`, `Data/Icons/ModelsBrowser/Models_` paths, `Fl_Shared_Image.get(...)`, `gModelsBrowserButtons`, `gModelsBrowserIcons`, `cameratool1` through `cameratool6` widget calls (`image`, `tooltip`, `redraw`, `when`), and `updateCameraListBrowser()` call.
- **Reusable:** no
- **Procedural:** no
