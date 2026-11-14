<!-- Spark folder manifest of Data/Fluid/ExportObj (model spark-x2.6-4b, 2026-11-12 22:30). DRAFT. -->

# Data/Fluid/ExportObj
- **Role:** This folder holds the FLTK user interface for exporting meshes as OBJ files, providing a window layout, an export button wired to a save callback, and a choice widget for selecting an import type. It saves the selected mesh using the engine's OBJ export function and opens the generated OBJ file.
- **Entry point:** ExportObj.fl
- **Files:** ExportObj.fl - FLTK user interface window for exporting meshes as OBJ files, including the window layout, an ExportObj button wired to a save callback, and a choice widget for selecting an import type.
- **Shared with other folders:** Needs `fastFilePaths`, `ig3d_SaveMeshAsOBJ_sf`, and `lastLoadedFile` from the engine, plus FLTK widget names and calls (`Fl_Window`, `Fl_Button`, `Fl_Choice`, `xywh`, `label`, `callback`, `labelsize`, `down_box`, `textsize`, `type`, `when`) and the `code`/`open`/`selected` block markers.
- **Procedure candidates:** none
- **Glossary:**
  - `objExport` - The FLTK window name for the ExportObj user interface.
  - `ig3d_SaveMeshAsOBJ_sf` - Engine call that saves a mesh as an OBJ file.
  - `fastFilePaths` - Engine call that builds file paths for the specified asset type.
  - `lastLoadedFile` - Global holding the name of the last loaded file used to build export paths.
  - `OBJ` - Asset type used by `fastFilePaths` for OBJ file paths.
  - `save_asOBJ` - Callback that runs when the ExportObj button is clicked to save the selected mesh as OBJ and open the generated file.
- **Verdict:** keep - It is a complete, working UI example for exporting meshes as OBJ files that a new engine can reuse as a reference.
