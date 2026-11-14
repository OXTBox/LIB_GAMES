<!-- Spark first-look of Data/Fluid/BodyPaint/BodyPaint.fl (model spark-x2.6-4b, 2026-11-12 19:40). DRAFT for Claude to review. -->

## BodyPaint.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLUID (FLTK UI designer) source for the Body Paint window, which opens via `BodyPaint:show()` and defines the window widgets, mouse interaction logic, and legacy paint function wiring for the Body Paint tool.
- **Depends on:** `BodyPaint:show()` (FLUID window entry point), `get(ig3d_material, -1, j)`, `setMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value(), make(ig3d_texture, (os.time()..(j))..".png",512,512))`, `setMaterialInfo(m, IG3D_TRANSPARENT, true)`, `loadTexture(w:value())`, `getSceneInfo(IG3D_EXACT_COLLISION_DATA, getSceneInfo(IG3D_MOUSE_LINE))`, `getMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value())`, `pencilTexture:value()`, `drawToTexture(...)`, `click("-")`, `setLightInfo(1, IG3D_POSITION, 0,0,15,1)`, globals `bodypaintUnit`, `bodyPaintOld`, `bodyPaint`, `game_func`, `IG3D_ADD`, `IG3D_CLAMP`, `IG3D_TEXTURE`, `IG3D_TRANSPARENT`, `IG3D_POSITION`, widget value references `w` and `pencilTexture`, and paths `Data/Images/Decals/bloodpencil1.png`.
- **Provides:** `make_window`, `createWhiteMeshTextures`, `loadThePencil`, `bodyPaint`, and the `bodyPaintOld`/`game_func` legacy function assignments that wire the Body Paint UI to the engine.
- **Assets it needs:** `Data/Images/Decals/bloodpencil1.png` (exact file name).
- **Procedural:** yes - generates white mesh textures for all materials by iterating materials and assigning new 512x512 textures with transparency enabled, using `bodypaintUnit:value()` and `os.time()` for naming.
- **Glossary:**
  - `IG3D_TEXTURE` - engine property constant naming the texture property being read or set on objects.
  - `IG3D_TRANSPARENT` - engine property constant naming the transparency property being read or set on objects.
  - `IG3D_POSITION` - engine property constant naming the position property being read or set on objects.
  - `make(ig3d_texture, ...)` - engine call that creates a texture object with the given dimensions.
  - `setMaterialInfo` - engine call that sets properties on a material object.
  - `getSceneInfo` - engine call that retrieves scene information for a specified scene data type.
  - `loadTexture` - engine call that loads a texture into the current texture context.
  - `drawToTexture` - engine call that draws a texture onto a target texture.
- **Keep / port / drop:** keep - core UI logic for the Body Paint tool that other engine files reference.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Contains the FLUID file header and the `BodyPaint:show()` call that opens the Body Paint window.
- **Uses:** `BodyPaint:show()` (no other engine calls, globals or paths appear outside the function sections).

### make_window
- **Does:** Defines the `make_window` function with an empty `open` block, starting the FLUID window definition for Body Paint.
- **Uses:** nothing beyond the function definition itself.

### createWhiteMeshTextures
- **Does:** Creates white mesh textures for all materials by iterating through materials and assigning a new texture to each, setting transparency to true.
- **Uses:** `get(ig3d_material, -1, j)`, `setMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value(), make(ig3d_texture, (os.time()..(j))..".png",512,512))`, `setMaterialInfo(m, IG3D_TRANSPARENT, true)`, globals `bodypaintUnit`, `os.time()`.
- **Reusable:** yes - pure data/asset generation logic for material textures.

### loadThePencil
- **Does:** Loads the selected pencil texture into the current texture context.
- **Uses:** `loadTexture(w:value())`, global `w` (widget value reference).
- **Reusable:** yes - simple texture loading helper.

### bodyPaint
- **Does:** Handles the Body Paint mouse interaction: reads exact collision and mouse line scene info, draws the selected pencil texture onto the material texture if collision data exists, then calls the legacy body paint function.
- **Uses:** `getSceneInfo(IG3D_EXACT_COLLISION_DATA, getSceneInfo(IG3D_MOUSE_LINE))`, `getMaterialInfo(m, IG3D_TEXTURE, bodypaintUnit:value())`, `pencilTexture:value()`, `drawToTexture(...)`, `click("-")`, globals `bodyPaintOld`, `bodypaintUnit`, `IG3D_ADD`, `IG3D_CLAMP`.
- **Reusable:** no - engine-specific paint interaction logic tied to the Body Paint UI.

### Top level (continued)
- **Does:** Defines the legacy `bodyPaintOld=game_func` assignment, the `game_func=bodyPaint` assignment, and the `BodyPaint:show()` call that opens the window. Also contains the FLUID window definition for Body Paint with its widgets and the `setLightInfo(1, IG3D_POSITION, 0,0,15,1)` call.
- **Uses:** `game_func`, `BodyPaint:show()`, `setLightInfo(1, IG3D_POSITION, 0,0,15,1)`, widget definitions (`Fl_Window`, `Fl_Input`, `Fl_Button`, `Fl_Value_Input`) with paths `Data/Images/Decals/bloodpencil1.png` and `Data/Images/Decals/bloodpencil1.png`.
- **Reusable:** no - UI setup and window configuration code.
