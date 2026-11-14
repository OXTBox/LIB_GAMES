<!-- Spark folder manifest of Data/Fluid/BodyPaint (model spark-x2.6-4b, 2026-11-12 19:42). DRAFT. -->

# Data/Fluid/BodyPaint
- **Role:** This folder holds the FLTK UI source and tool implementation for the Body Paint tool in the iGame3D engine, which lets users edit material textures on game objects through a double window and material texture controls. The Body Paint window is opened via `BodyPaint:show()` and wires the UI to engine calls for material, texture, and scene data during editing.
- **Entry point:** `BodyPaint:show()` (FLUID window entry point for the Body Paint UI)
- **Files:**
  - `BodyPaint.fl - FLUID (FLTK UI designer) source for the Body Paint window, defining window widgets, mouse interaction logic, and legacy paint function wiring`
  - `BodyPaint.lua - Lua tool implementation for the Body Paint tool, setting up the FLTK double window with material texture controls, handling material and scene data during editing, and running the FLTK event loop`
- **Shared with other folders:** Needs `Data/Images/Decals/bloodpencil1.png` (exact file name) for the pencil texture used in the Body Paint tool. Shares engine globals and calls such as `get(ig3d_material, -1, j)`, `setMaterialInfo`, `loadTexture`, `getSceneInfo`, `getMaterialInfo`, `drawToTexture`, `setLightInfo`, and property constants `IG3D_TEXTURE`, `IG3D_TRANSPARENT`, `IG3D_POSITION`, `IG3D_EXACT_COLLISION_DATA`, `IG3D_MOUSE_LINE`, `IG3D_ADD`, `IG3D_CLAMP` with other engine files.
- **Procedure candidates:** `createWhiteMeshTextures` generates white mesh textures for all materials by iterating materials and assigning new 512x512 PNG textures with transparency enabled, using `bodypaintUnit:value()` and `os.time()` for naming; `loadThePencil` loads the pencil texture used for texture drawing; `bodyPaint` and the `bodyPaintOld`/`game_func` legacy function assignments wire the Body Paint UI to the engine.
- **Glossary:**
  - `IG3D_TEXTURE - engine property constant naming the texture property being read or set on objects`
  - `IG3D_TRANSPARENT - engine property constant naming the transparency property being read or set on objects`
  - `IG3D_POSITION - engine property constant naming the position property being read or set on objects`
  - `IG3D_EXACT_COLLISION_DATA - engine property constant naming collision data retrieved from the scene`
  - `IG3D_MOUSE_LINE - engine property constant naming mouse line data retrieved from the scene`
  - `IG3D_ADD - engine property constant used to add texture data during drawing`
  - `IG3D_CLAMP - engine property constant used to clamp texture drawing parameters`
  - `make(ig3d_texture, ...) - engine call that creates a texture object with the given dimensions`
  - `setMaterialInfo - engine call that sets properties on a material object`
  - `getSceneInfo - engine call that retrieves scene information for a specified scene data type`
  - `loadTexture - engine call that loads a texture into the current texture context`
  - `drawToTexture - engine call that draws a texture onto a target texture`
- **Verdict:** keep - these files form the core, reusable UI and tool implementation for the Body Paint tool that other engine files reference, and the code already performs the texture generation and UI wiring logic directly.
