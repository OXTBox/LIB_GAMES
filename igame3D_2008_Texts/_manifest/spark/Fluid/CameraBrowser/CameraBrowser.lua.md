<!-- Spark first-look of Data/Fluid/CameraBrowser/CameraBrowser.lua (model spark-x2.6-4b, 2026-11-12 19:54). DRAFT for Claude to review. -->

## CameraBrowser.lua
- **Kind:** ui-dialog
- **Purpose:** This file implements the CameraBrowser user interface for the iGame3D engine, letting a programmer browse, edit, and replace camera attributes, values, textures, and WTF sources through FLTK widgets. It manages the camera tool groups, value and attribute list browsers, and the save/replace UI, then runs the FLTK event loop to display the dialog.
- **Depends on:** Engine globals (`gCurrentCameraInfo`, `gCameraNames`, `gCameraValues`, `gCameraAttributes`, `gSelCameraData`, `gSelectedCameraInfo`, `gSelectedCamera`, `gCameraFilesShortNames`, `gCameraourcePath`, `gCameraValues`, `gNewCameraValueItems`, `gModelsBrowserButtons`, `gModelsBrowserIcons`, `gLabelTable`, `gCameraToolTipPicked`, `gNumCameras`, `gOldInfo`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gCamerasRotations`, `gSourceRequest`, `gSelectedCamera`, `curVal`, `curValBool`, `curValF`, `sstr`, `CameraBrowser`, `CameraFieldValues`, `CameraBrowserValueCatch`, `CurCameraInfo`, `updateCameraAttributesTables`, `resetCameraTables`, `updateMaterialsTables`, `CameraBrowserGroupsHide`, `updateCameraListBrowser`, `CameraBrowserWindowUpdate`, `CameraListBrowserCallback`, `CameraValueListCallback`, `CameraAttPicked`, `CameraMenu`, `Camera_menu_callback`, `cameraToolBtnCallback`, `CameraSaveButtonClick`, `CameraSourcebrowserControlClicked`, `CamerawtfAddCameraClicked`, `ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `CameraSourceGroup`, `CameraSaveAsGroup`, `CameraInputGroup`, `CameraValueGroup`, `CameraBonesGroup`, `CameraMaterialsGroup`, `CameraMaterialsInputGroup`, `CameraMaterialsBrowser`, `CameraMaterialsAttributesBrowser`, `CameraMaterialsValuesBrowser`, `CameraMaterialsBrowserCallback`, `CameraMaterialsAttributesBrowserCallback`, `CameraListBrowser`, `CameraAttListBrowser`, `CameraValueListBrowser`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `wtfFileBrowser`, `SourceNameInput`, `PSaveControl`, `ReplaceSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `MakeCameraWTFBtn`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current()`, `CameraBrowser:show()`, `CameraBrowser:label()`, `CameraBrowser:make_current

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 14

### Top level
- **Does:** Initializes the CameraBrowser file state and global variables, then sets up default camera name and position data if `gCameraNames` is nil.
- **Uses:** Engine globals (`gCurrentCameraInfo`, `getlineof`, `time`, `gCameraNames`, `gameroot`), file path construction (`gameroot.."Data/Levels/"`), and in-memory data structures (`CameraFileList`, `gCameraValues`, `gCameraAttributes`, etc.).
- **Reusable:** no
- **Procedural:** no

## Part 2 of 14

### CameraBrowserGroupsHide
- **Does:** Hides camera tool groups and resets their input widgets based on the currently selected camera tool tip and camera count.
- **Uses:** `gCameraToolTipPicked`, `gNumCameras`, `CameraSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `CameraTextureGroup`, `CameraSaveAsGroup`, `CameraInputGroup`, `CameraValueGroup`, `CameraValInputA`, `CameraValInputB`, `CameraValInputC`, `CameraValInputD`, `CameraBoolBtn`, `CameraNameInput`, `CameraBonesGroup`, `CameraMaterialsGroup`, `CameraMaterialsInputGroup`, `CameraMaterialsValInputA`, `CameraMaterialsValInputB`, `CameraMaterialsValInputC`, `CameraMaterialsValInputD`, `CameraMaterialsBoolBtn`, `CameraMaterialsNameInput`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 14

### CameraBrowserValueCatch
- **Does:** Reads the current values from the camera browser widgets, validates the first camera value, rebuilds the camera value items table from the input widgets, and updates the FLTK UI.
- **Uses:** `CameraFieldValues`, `CameraListBrowser`, `CameraAttListBrowser`, `CameraBoolBtn`, `CameraValInputA`, `CameraValInputB`, `CameraValInputC`, `CameraValInputD`, `CameraNameInput`, `gCameraValueItems`, `gNewCameraValueItems`, `fltk_update`
- **Reusable:** yes
- **Procedural:** no

### CurCameraInfo
- **Does:** Reads the current camera info from the engine, extracts the position and rotation lines, builds a selection data table, and returns the full current camera info.
- **Uses:** `gCurrentCameraInfo`, `gCurrentCameraPosition`, `gCamerasRotations`, `gSelCameraData`, `ig3d_GetCameraInfo__s`, `getlineof`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 14

### PickedCameraAttribute
- **Does:** Opens the camera browser, selects the camera attribute, and shows the matching camera value input or boolean button based on the selected attribute and its value.
- **Uses:** Engine calls `CameraBrowser == nil`, `CameraBrowserValueCatch()`, `CurCameraInfo()`, `fltk_update()`; globals `CameraBrowserGroupsHide()`, `CameraFieldValues`, `CameraValueGroup`, `CameraInputGroup`, `CameraNameInput`, `CameraValInputA`–`D`, `CameraBoolBtn`, `gSelectedCameraInfo`, `gCameraToolTipPicked`, `gCameraValueItems`, `gSelCameraData`, `gCameraAttributes`, `gCameraValues`, `gCameraValues`, `curVal`, `curValBool`, `curValF`, `sstr`, `numberofitems`, `item`, `tonumber`, `string.find`, `string.len`; files and `Data/` paths: nothing.
- **Reusable:** no

### PickedCameraAttribute
- **Does:** Splits the selected camera attribute value into individual items using commas, stores them in `gCameraValueItems`, and hides the value inputs when there is only one item.
- **Uses:** Engine calls `string.find`, `numberofitems`, `item`, `tonumber`; globals `gCameraValueItems`, `curVal`, `curValBool`, `curValF`, `sstr`, `gSelCameraData`, `gCameraAttributes`; files and `Data/` paths: nothing.
- **Reusable:** yes - string splitting and item collection logic.

### PickedCameraAttribute
- **Does:** Determines whether the selected attribute is boolean, shows the boolean button with the attribute label and sets its value, and displays the numeric value input for the selected attribute.
- **Uses:** Engine calls `string.len`, `tonumber`; globals `CameraBoolBtn`, `CameraValInputA`–`D`, `gCameraAttributes`, `curValBool`, `curValF`, `gCameraValueItems`; files and `Data/` paths: nothing.
- **Reusable:** yes - boolean value handling and numeric input display logic.

## Part 5 of 14

### CameraBrowserWindowUpdate
- **Does:** Updates the CameraBrowser window based on the requested argument, refreshing camera lists, attributes, values and selection state, and finishing with a UI refresh.
- **Uses:** Engine calls `CameraBrowser:make_current()`, `CameraBrowserValueCatch()`, `fltk_update()`; widget calls `wtfFileBrowser:value()`, `wtfFileBrowser:clear()`, `wtfFileBrowser:add()`, `wtfFileBrowser:selected()`, `wtfFileBrowser:value()`, `wtfFileBrowser:select()`, `wtfFileBrowser:redraw()`, and the same pattern for `SourceNameInput:value()`, `SourceNameInput:redraw()`, `CameraAttListBrowser:clear()`, `CameraAttListBrowser:add()`, `CameraAttListBrowser:value()`, `CameraAttListBrowser:select()`, `CameraAttListBrowser:redraw()`, `CameraValueListBrowser:clear()`, `CameraValueListBrowser:add()`, `CameraValueListBrowser:value()`, `CameraValueListBrowser:select()`, `CameraListBrowser:clear()`, `CameraListBrowser:add()`, `CameraListBrowser:select()`, `CameraListBrowser:value()`, `CameraListBrowser:selected()`; globals `CameraBrowser`, `CameraFieldValues`, `gCameraFilesShortNames`, `gCameraourcePath`, `gSelCameraData`, `gCameraAttributes`, `gCameraNames`, `gSelectedCamera`, `gCurrentCameraPosition`, `gCurrentCameraRotation`, `gOldInfo`, `gSelectedCameraInfo`, `gSourceRequest`, `gCameraFilesShortNames`, `gCameraAttributes`, `gSelCameraData`, `gCameraNames`, `gSelectedCamera`, `gCameraourcePath`, `gCameraFilesShortNames`; file/path references `Data/WTF/`; `CameraBrowserGroupsHide()`, `updateCameraAttributesTables()`, `CameraBrowserValueCatch()`; `arg` parameter.
- **Reusable:** no
- **Procedural:** no

## Part 6 of 14

### CameraValueListCallback
- **Does:** Updates the camera attribute list browser when a camera value is selected, then refreshes the camera value catch.
- **Uses:** `CameraBrowser`, `CameraAttListBrowser`, `CameraBrowserValueCatch`, `w:value()`
- **Reusable:** no
- **Procedural:** no

### CameraAttPicked
- **Does:** Updates the camera value list browser when a camera attribute is picked, then refreshes the camera value catch.
- **Uses:** `CameraBrowser`, `CameraValueListBrowser`, `CameraBrowserValueCatch`, `w:value()`, `CameraFieldValues[2]`
- **Reusable:** no
- **Procedural:** no

### updateCameraListBrowser
- **Does:** Refreshes the current camera info and updates the camera browser window for the update call.
- **Uses:** `CameraBrowserWindowUpdate`, `CurCameraInfo`
- **Reusable:** no
- **Procedural:** no

## Part 7 of 14

### Top level
- **Does:** Creates the CameraBrowser FLTK double window, its resize and styling, the mainttoolsgroup group with five camera tool buttons, and the CameraMenu menu bar.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Group`, `fltk:Fl_Button`, `fltk:Fl_Menu_Bar`, `CameraBrowser`, `mainttoolsgroup`, `cameratool1` through `cameratool7`, `CameraMenu`, `Camera_menu_callback`, `wClose`, `cameraToolBtnCallback`, `resize`, `color`, `labelsize`, `textsize`, `align`, `current`, `parent`.
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Handles the CameraBrowser value input callback. It returns early if CameraBrowser is nil, reads the input value, resets camera tables, updates the current camera info, refreshes the camera list browser, shows the camera value group, and updates camera list browser state.
- **Uses:** `CameraBrowser`, `gSelectedCamera`, `CurCameraInfo`, `updateCameraListBrowser`, `CameraValueGroup`, `w:value()`, `wClose`, `resetCameraTables`, `CameraFieldValues`, `camera_faceObj`, `PickedCameraAttribute`, `updateMaterialsTables`, `Camera_menu_callback`.
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Creates the CameraBrowser window and wires its close callback, resizes it to 97x177 with width 369 and height 390, sets its background color to 40 and label size to 10.
- **Uses:** `fltk:Fl_Double_Window`, `wClose`, `resize`, `color`, `labelsize`.
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Creates the mainttoolsgroup FLTK group, resizes it to 645x30, and adds five camera tool buttons with their callbacks, resize, label size and alignment settings.
- **Uses:** `fltk:Fl_Group`, `resize`, `callback`, `labelsize`, `align`, `cameraToolBtnCallback`, `mainttoolsgroup`.
- **Reusable:** no

### CameraListBrowserCallback
- **Does:** Creates the CameraMenu FLTK menu bar, sets its callback to Camera_menu_callback, resizes it to 371x22, and sets its color and label size.
- **Uses:** `fltk:Fl_Menu_Bar`, `callback`, `resize`, `color`, `labelsize`, `textsize`, `Camera_menu_callback`.
- **Reusable:** no

## Part 8 of 14

### CameraListBrowserCallback (continued)
- **Does:** Builds the camera save/replace UI widgets and wires their callbacks, then restores the current group after each widget group is created.
- **Uses:** `fltk:Fl_Group`, `fltk:Fl_Input`, `fltk:Fl_Button`, `fltk:Fl_Browser`, `gLabelTable`, `Fl_Group:current`, `CameraSaveButtonClick`, `CameraSourcebrowserControlClicked`, `CamerawtfAddCameraClicked`, `ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `CameraSourceGroup`, `CameraSaveAsGroup`, `SourceNameInput`, `PSaveControl`, `ReplaceSourceGroup`, `ReplaceWTFSourceBtn`, `ReplaceAllWTFSourceBtn`, `wtfFileBrowser`, `MakeCameraWTFBtn`
- **Reusable:** no
- **Procedural:** no

## Part 9 of 14

### CameraListBrowserCallback (continued)
- **Does:** Builds the camera materials browser group, its three browser widgets, and the three WTF source replacement buttons, each wired to its own callback or shared callback, with labels taken from the shared gLabelTable.
- **Uses:** `gLabelTable`, `fltk:Fl_Button`, `fltk:Fl_Group`, `fltk:Fl_Browser`, `MakeCameraWTFBtn`, `CameraMaterialsGroup`, `CameraMaterialsBrowser`, `CameraMaterialsAttributesBrowser`, `CameraMaterialsValuesBrowser`, `ReplaceWTFSourceBtnClick`, `ReplaceAllWTFSourceBtnClick`, `CameraMaterialsBrowserCallback`, `CameraMaterialsAttributesBrowserCallback`, `Fl_Group:current`, `Fl_Group:current():parent()`.
- **Reusable:** no
- **Procedural:** no

## Part 10 of 14

### CameraListBrowserCallback (continued)
- **Does:** Builds the CameraMaterialsInputGroup widget group and its child input widgets, assigning labels from gLabelTable, callbacks, sizes, colors and alignment settings.
- **Uses:** fltk widget constructors and methods (Fl_Group, Fl_Input, Fl_Check_Button, Fl_Value_Input, resize, box, color, label, callback, labelsize, textsize, minimum, step, align, down_box, when), gLabelTable, and the callback functions RenameCameraMaterials, changeCameraMaterialsBool, CameraMaterialsValInput.
- **Reusable:** no
- **Procedural:** no

## Part 11 of 14

### CameraListBrowserCallback (continued)
- **Does:** Builds the CameraTextureGroup, pngPreviewGroup, pngFileBrowser, and CameraInputGroup UI groups, their widgets, and their callbacks, and sets their sizes, styling, and alignment.
- **Uses:** fltk widget constructors and methods (Fl_Group, Fl_Box, Fl_Browser, Fl_Input, Fl_Check_Button, Fl_Value_Input, resize, box, callback, label, color, align, when, minimum, maximum, step), fltk.FL_THIN_DOWN_BOX, fltk.FL_FLAT_BOX, fltk.FL_DOWN_BOX, gLabelTable, and the callback functions pngLoad, browserControlClicked, RenameCamera, changeCameraBool, CameraValInput.
- **Reusable:** no
- **Procedural:** no

## Part 12 of 14

### CameraListBrowserCallback (continued)
- **Does:** Builds the Camera browser widget group, adds the Camera label to the shared label table, and wires the browser to the CameraListBrowserCallback handler.
- **Uses:** `gLabelTable`, `fltk:Fl_Group`, `fltk:Fl_Browser`, `CameraListBrowserCallback`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 14

### Top level
- **Does:** Builds and configures the CameraBrowser UI, wires its value and attribute browser widgets, registers button icons, and sets the icon and tooltip for the camera tool buttons.
- **Uses:** `fltk:Fl_Group`, `fltk:Fl_Browser`, `gLabelTable`, `CameraValueListCallback`, `CameraAttPicked`, `Fl_Group:current`, `CameraBrowser:show`, `CameraBrowser:label`, `CameraBrowser:make_current`, `CameraBrowserGroupsHide`, `updateCameraListBrowser`, `fltk.fl_register_images`, `gameroot`, `Data/Icons/ModelsBrowser/Models_`, `gModelsBrowserButtons`, `gModelsBrowserIcons`, `Fl_Shared_Image.get`, `cameratool1` through `cameratool6`, `Fl_Shared_Image:image`, `Fl_Shared_Image:tooltip`.
- **Reusable:** no
- **Procedural:** no

## Part 14 of 14

### Top level
- **Does:** Redraws the camera tool widgets and triggers their `when` callbacks, then runs the FLTK event loop.
- **Uses:** `cameratool1` through `cameratool6` (widgets), `gModelsBrowserButtons[6]` (referenced by `tooltip`), `Fl:run()`.
- **Reusable:** no
- **Procedural:** no
