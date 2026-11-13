<!-- Spark folder manifest of Data/Fluid/ClassesBrowser (model spark-x2.6-4b, 2026-11-12 21:03). DRAFT. -->

# Data/Fluid/ClassesBrowser
- **Role:** This folder holds the FLTK user interface for browsing and managing entity classes, WTF model assets, and game type settings inside the iGame3D engine. It provides a window that lists and filters entity classes, navigates the WTF model folder, renders generated previews, and wires the browser controls to their actions.
- **Entry point:** ClassesBrowser.lua - defines the ClassesBrowser UI component, shared class/entity tables, WTF browsing and preview logic, and the FLTK event loop setup for the class browser widgets.
- **Files:** ClassesBrowser.fl - FLTK user interface definition for the ClassesBrowser window, its widgets, and the setup code that shows the browser and populates the class list. ClassesBrowser.lua - Lua implementation of the ClassesBrowser UI component, supporting class/entity configuration tables, WTF asset browsing and preview logic, and the FLTK event loop setup.
- **Shared with other folders:** Needs `gDefaultEntityClasses`, `RTSENTITIES`, `gHumanNames`, `humans`, `cars`, `zombies`, `Characters`, `Characters.name`, `Characters.wif`, `Characters.anims`, `Characters.velocity`, `zombieAnims`, `guns`, `buildings`, `walls`, `gObjects`, `gDropObject`, `gameroot`, `Data/` paths (`Data/WTF/`, `Data/Images/Colors/white.png`), and engine calls such as `make`, `loadMesh`, `loadLevel`, `ig3d_CreateDirectory_s`, `ig3d_SetWindowBounds_4i`, `createWTFPreviewPNG`, `goDirsUp`. Others take the generated WTF preview PNG assets and the entity class tables it defines.
- **Procedure candidates:** Generated WTF preview PNG assets created for selected WTF files or folders via `createWTFPreviewPNG`; creation of the Entities subfolder in the Scripts folder when a new game type is selected; WTF file listing and filtering via `lfs.dir` and `lfs.attributes` over the `Data/WTF/` folder.
- **Glossary:**
  - `ClassesBrowser` - the FLTK UI window that provides the class browsing and management interface for entity classes, WTF model files, and game type settings.
  - `WTF file` - iGame3D 3D model files in the `Data/WTF/` folder, loaded with `make(ig3d_object, "file.wtf")`.
  - `WTF preview PNG` - generated PNG assets created for selected WTF files or folders to display previews.
  - `entity class` - a predefined set of entity types (humans, cars, zombies, etc.) managed by `gDefaultEntityClasses`.
  - `game type` - a selected value that triggers scanning of the Scripts folder and folder creation for a new game.
  - `WTF browser` - FLTK browser widget used to list and select WTF files and folders.
- **Verdict:** keep - it is a complete reference for the iGame3D FLTK UI pattern for browsing model assets and managing entity classes, with reusable browsing, preview, and class configuration logic.
