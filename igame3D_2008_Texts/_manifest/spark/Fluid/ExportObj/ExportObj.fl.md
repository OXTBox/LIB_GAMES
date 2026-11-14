<!-- Spark first-look of Data/Fluid/ExportObj/ExportObj.fl (model spark-x2.6-4b, 2026-11-12 22:30). DRAFT for Claude to review. -->

## ExportObj.fl
- **Kind:** exporter
- **Purpose:** This file defines the ExportObj FLTK user interface window for exporting meshes as OBJ files, including the window layout, an ExportObj button wired to a save callback, and a choice widget for selecting an import type. It saves the selected mesh using the engine's OBJ export function and opens the generated OBJ file.
- **Depends on:** `fastFilePaths`, `ig3d_SaveMeshAsOBJ_sf`, `lastLoadedFile`, FLTK widget names and calls (`Fl_Window`, `Fl_Button`, `Fl_Choice`, `xywh`, `label`, `callback`, `labelsize`, `down_box`, `textsize`, `type`, `when`), and the `code`/`open`/`selected` block markers.
- **Provides:** The `objExport` FLTK window widget, the `save_asOBJ` callback, and the ExportObj UI layout for exporting meshes as OBJ files.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `objExport` - The FLTK window name for the ExportObj user interface.
  - `ig3d_SaveMeshAsOBJ_sf` - Engine call that saves a mesh as an OBJ file.
  - `fastFilePaths` - Engine call that builds file paths for the specified asset type.
  - `lastLoadedFile` - Global holding the name of the last loaded file used to build export paths.
  - `OBJ` - Asset type used by `fastFilePaths` for OBJ file paths.
- **Keep / port / drop:** keep
- **Reason:** It is a complete, working UI example for exporting meshes as OBJ files that a new engine can reuse as a reference.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the FLTK window `objExport` for the ExportObj fluid file, including its label, geometry, buttons and choice widget, and wires the `save_asOBJ` callback to the ExportObj button.
- **Uses:** `fastFilePaths("OBJ", lastLoadedFile..".obj")`, `ig3d_SaveMeshAsOBJ_sf(objsaveFile, 100)`, `objExport:show()`, FLTK widget names and calls (`Fl_Window`, `Fl_Button`, `Fl_Choice`, `xywh`, `labelsize`, `down_box`, `textsize`, `type`, `when`, `callback`), and the `code`/`open`/`selected` block markers.
- **Reusable:** no

### make_window
- **Does:** Opens the `objExport` FLTK window with the ExportObj UI layout: an `objExport` window labeled `objExport open`, a `save_asOBJ` selected callback block, an ExportObj button, an ObjChoice choice widget, and a `objExport:show()` call.
- **Uses:** `objExport:show()`, FLTK widget definitions (`Fl_Window`, `Fl_Button`, `Fl_Choice`, `xywh`, `label`, `callback`, `labelsize`, `down_box`, `textsize`, `type`, `when`), and the `code`/`open`/`selected` block markers.
- **Reusable:** no

### save_asOBJ
- **Does:** Saves the selected mesh as an OBJ file using the last loaded file name, then opens the OBJ file with the engine's OBJ save function.
- **Uses:** `fastFilePaths("OBJ", lastLoadedFile..".obj")`, `ig3d_SaveMeshAsOBJ_sf(objsaveFile, 100)`, and the `code`/`selected` block markers.
- **Reusable:** no

### objExport
- **Does:** Defines the `objExport` FLTK window widget for the ExportObj fluid file, including its label, geometry, visible state, ExportObj button with callback, and ObjChoice choice widget.
- **Uses:** `objExport` (window name), `ExportObj` (button label), `ObjChoice` (choice widget name), `Import WTF` (choice label), FLTK widget calls (`Fl_Window`, `Fl_Button`, `Fl_Choice`, `xywh`, `label`, `callback`, `labelsize`, `down_box`, `textsize`, `type`, `when`), and the `code`/`open`/`selected` block markers.
- **Reusable:** no
