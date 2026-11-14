<!-- Spark first-look of Data/Fluid/BodyPaint/BodyPaint.lua (model spark-x2.6-4b, 2026-11-12 19:42). DRAFT for Claude to review. -->

## BodyPaint.lua
- **Kind:** tool
- **Purpose:** This file implements the BodyPaint tool for the iGame3D engine, setting up a FLTK double window with material texture controls, handling material and scene data during editing, and running the FLTK event loop. It provides the tool's main interaction logic for applying and editing material textures on game objects.
- **Depends on:** `loadTexture`, `setLightInfo`, `bodyPaintOld`, `game_func`, `gLabelTable`, `BodyPaint`, `pencilTexture`, `widget`, `bodypaintUnit`, `getSceneInfo`, `getMaterialInfo`, `drawToTexture`, `fltk` (FLTK UI calls), `IG3D_EXACT_COLLISION_DATA`, `IG3D_MOUSE_LINE`, `IG3D_ADD`, `IG3D_CLAMP`, `IG3D_POSITION`, `IG3D_TEXTURE`, `IG3D_TRANSPARENT`
- **Provides:** `createWhiteMeshTextures`, `loadThePencil`, `bodyPaint`, plus the BodyPaint tool window setup and callback wiring for material texture editing.
- **Assets it needs:** none named as exact file assets (texture generation uses `os.time()` and PNG dimensions; no specific model, image, sound, emitter, or font file names are listed).
- **Procedural:** yes — generates 512x512 PNG textures named with the current time and material index for each material during `createWhiteMeshTextures`.
- **Glossary:**
  - `IG3D_TEXTURE - The property constant identifying texture data on objects, used to set or read textures.`
  - `IG3D_TRANSPARENT - The property constant marking an object's texture as transparent.`
  - `IG3D_EXACT_COLLISION_DATA - A property constant naming collision data retrieved from the scene.`
  - `IG3D_MOUSE_LINE - A property constant naming mouse line data retrieved from the scene.`
  - `IG3D_ADD - A property constant used to add texture data during drawing.`
  - `IG3D_CLAMP - A property constant used to clamp texture drawing parameters.`
  - `bodyPaintUnit - A widget providing a unit value used for texture and material settings.`
  - `pencilTexture - A widget holding the pencil texture value used for texture drawing.`
- **Keep / port / drop:** keep — a complete, reusable tool implementation for material texture editing in the iGame3D engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets up the BodyPaint FLTK window and its controls, registers labels, wires callbacks, and runs the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `BodyPaint`, `pencilTexture`, `widget`, `bodypaintUnit`, `loadTexture`, `setLightInfo`, `Fl:run`, `bodyPaintOld`, `game_func`, `click`, `getSceneInfo`, `getMaterialInfo`, `drawToTexture`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_MOUSE_LINE`, `IG3D_ADD`, `IG3D_CLAMP`, `bodypaintUnit:value()`, `pencilTexture:value()`, `setLightInfo(1, IG3D_POSITION, 0,0,15,1)`
- **Reusable:** no

### createWhiteMeshTextures
- **Does:** Iterates over all materials, sets each material's texture to a newly generated 512x512 PNG named with the current time and material index, and marks the material transparent.
- **Uses:** `get(ig3d_material, -1, j)`, `setMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value(), make(ig3d_texture, (os.time()..(j))..".png",512,512))`, `setMaterialInfo(m, IG3D_TRANSPARENT, true)`, `bodypaintUnit:value()`, `os.time()`, `j`
- **Reusable:** yes

### loadThePencil
- **Does:** Loads the texture value from the pencil texture input widget into the texture loading function.
- **Uses:** `w:value()`, `loadTexture`
- **Reusable:** yes

### bodyPaint
- **Does:** Handles the minus click to read scene collision and mouse line data, draws the selected material's texture onto the pencil texture with add and clamp settings, then calls the previous bodyPaint implementation.
- **Uses:** `click("-")`, `getSceneInfo(IG3D_EXACT_COLLISION_DATA, getSceneInfo(IG3D_MOUSE_LINE))`, `result`, `getMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value())`, `pencilTexture:value()`, `u`, `v`, `IG3D_ADD`, `IG3D_CLAMP`, `drawToTexture`, `bodyPaintOld()`, `bodypaintUnit:value()`, `pencilTexture:value()`
- **Reusable:** no

### Top level
- **Does:** Creates the BodyPaint FLTK window and its associated controls, registers labels, wires callbacks, sets the light position, and starts the FLTK event loop.
- **Uses:** `fltk:Fl_Double_Window`, `gLabelTable`, `BodyPaint`, `pencilTexture`, `widget`, `bodypaintUnit`, `loadTexture`, `setLightInfo`, `Fl:run`, `bodyPaintOld`, `game_func`, `click`, `getSceneInfo`, `getMaterialInfo`, `drawToTexture`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_MOUSE_LINE`, `IG3D_ADD`, `IG3D_CLAMP`, `bodypaintUnit:value()`, `pencilTexture:value()`, `setLightInfo(1, IG3D_POSITION, 0,0,15,1)`
- **Reusable:** no
