# igame3D_2008_Texts — Manifest

Written 2026-11-12 by Claude after a survey of the whole folder. Tools and Spark output live in
`_manifest/` so nothing in the original tree is touched.

```
_manifest/
  MANIFEST.md                 this file (hand-written, Claude)
  WTF_INDEX.md, wtf_index.json  every model: verts/bones/materials/animations/textures (generated)
  spark_manifest_prompt.md    Spark's prompts: SYSTEM / PART / FILE / FOLDER
  tools/wtf_index.py          python3 -I _manifest/tools/wtf_index.py
  tools/spark_manifest.py     python3 -I _manifest/tools/spark_manifest.py --plan | --folder X
  spark/<folder>/<file>.md    Spark drafts per code file   (created by the run)
  spark/<folder>/_FOLDER.md   Spark draft per folder        (created by the run)
```

## 1. What this folder is

It is the **`Data/` folder of iGame3D** (2008–2009, Mac/Win, Lua 5.1 via murgaLua + FLTK, Newton
physics, OpenGL ARB shaders). The engine finds its root by checking for
`<root>/Data/Scripts/core.lua`; `alternateRoot.txt` (`Z:/iGame3D031508win//`) overrides the root,
and `game script.lua` is the bootstrap that does that check and then
`loadLevel("Data/Levels/default")`.

"Texts" = the text-format part of the Data folder only. **Absent** here but referenced by the
code (counts are references in .lua/.fl): `Sounds/` 897, `FontPngs/` 178, `Images/` 146
(+ 492 textures named by WTF materials — all missing), `WIF/` 18, `BVH/` 14, `Icons/` 10, `PNG/` 2.
So this copy is complete for **code, models (geometry), emitters, shaders, UI, docs**, and
missing **all bitmaps and audio** except ~25 PNGs in a few levels.

Size: 121 MB on disk, of which ~56 MB is `.svn` metadata (953 `.svn-base` copies, 1 per file).
Real content ~65 MB, of which 53 MB is WTF models.

## 2. Top-level layout (the "Data folder" pattern)

| Folder | Files | Size | Holds | Loaded by |
|---|---|---|---|---|
| `Scripts/` | 2 + 12 subdirs (~130 .lua) | 1.3 MB | Lua libraries. `core.lua` = engine core tables (gObjects, gLights...). `Functions/` = the standard library (`<topic>_functions.lua`) | `dofile(gameroot.."Data/Scripts/...")` |
| `Levels/` | 30 level folders | 2.6 MB | One folder per game/demo. Entry is always `load script.lua` (73 of them incl. Fluid tools); may hold `*_Globals.lua`, its own `.wtf`, `.png`, `Textures/` | `loadLevel("Data/Levels/X")` |
| `Fluid/` | 50 tool folders | 3.1 MB | FLTK dialogs and editor tools: `X.fl` (FLUID UI, Lua code inside `code {}` blocks) + `X.lua` | `dofile(...".fl")` from the main UI |
| `WTF/` | 33 category folders, 768 models | 53 MB | 3D models, text format "iGame3D Mdl" | `make(ig3d_object, "Cat/name.wtf")` |
| `Emitters/` | 75 .emt | 336 KB | Particle emitter presets (`key=value`) | `Data/Emitters/...` (227 refs) |
| `Shaders/` | 11 shader folders | 612 KB | ARB vp/fp (`VertexProgram`, `FragmentProgram`, `_ATI`), 3 GLSL `.vs/.fs` + ShaderBuilder `.sbproj` | material `shader=` |
| `OBJ/` | 25 .obj + .mtl | 3.8 MB | Wavefront exports, named by unix timestamp (Mar 2008) | import/convert |
| `Exporters/` | 6 | 124 KB | Blender 2.33 `WTF_Export.py`, Cheetah3D `C3D2WTF_exporter.js` + `.jas` sample, Mac PPC plug-ins `wtf_export.p`/`wtf_import.p` (binary) | external apps |
| `Help/` | 17 | 564 KB | **The API docs**: `reference.txt` (191 `func:` entries in 38 sections), `scripting.txt`, `materials.txt`, `particles.txt`, `faq/`; `.html` built from them by `texttohtml.lex` → `lex.yy.c` | in-app help |
| `Users/` | empty | — | per-user saves (none kept) | |

**Rule to repeat in future projects** (what made this layout work, and what cluttered it):

1. One `Data/` root, found at runtime by a marker file (`Scripts/core.lua`), overridable by a
   one-line text file. Every path in code is *root-relative* (`"Data/WTF/Cubes/cube.wtf"`).
2. Split by **kind**: code (`Scripts/`), playable units (`Levels/<name>/load script.lua`),
   tools/UI (`Fluid/<tool>/`), assets by type (`WTF/`, `Images/`, `Sounds/`, `Emitters/`, `Shaders/`).
3. Assets subdivided by **category** (WTF/Characters, WTF/Weapons, WTF/Houses...) — that list is
   the seed of an asset vocabulary (§6).
4. A level folder is self-contained: entry script + optional globals + level-only assets.
5. What went wrong (avoid): duplicate/iteration copies side by side (`Fluid/Mappers`: Mapper,
   Mapper2..5, MapperA/B, `DungeonMapper worksok.fl`, `...fullishbroke.fl`); `kopie`/`copy`
   files; two spellings (`Data/WTF/` 177 refs vs `Data/Wtf/` 48 — breaks on case-sensitive
   disks); `.DS_Store`, `.svn`; generated files (`lex.yy.c`, `.html`) next to sources;
   assets named by timestamp (`OBJ/1205112340.obj`); binary plug-ins next to text.
   → In new projects: `versions/` or git instead of copies, one case-exact folder name,
   generated output in `build/`, and a `MANIFEST.md` per folder.

## 3. File formats

- **.wtf — "iGame3D Mdl"** (text). Line 1 magic, line 2 `0`, `#Author/#Date/#Notes/#PNG`, then
  sections each followed by a count: `#Bones` → `#Vertices` (x,y,z,boneIndex) → `#Paths` →
  `#Groups` → `#BoneOrientations` → `#Edges` → `#Materials` (name, count, `key=value`: smooth,
  color, ambient, diffuse, specular, shininess, emission, blend, lux, depth, wire, morph,
  `texture=<unit>,Data/Images/...png`, `shader=`) → `#Animations` (named skeletal clips).
  Fully documented in `Help/materials.txt`; exporters in `Exporters/` show the writer side.
  768 models; 321 have bones, 22 have animations (e.g. `Characters/bobette.wtf`: Walk, Sit, Stand...);
  biggest `Houses/estate21K.wtf` (11,357 verts). `WTF/AquaChar/` = 256 `chrNN.wtf` — a 3D font
  (one model per character code) — a prime **procedure** candidate.
- **.lua** — 248 files, 70,535 lines. Line endings mixed (59 files are classic-Mac CR only).
- **.fl** — 90 FLUID files, 40,957 lines: UI widgets (`Fl_Window`, `xywh {x y w h}`) with Lua in
  `code {...}` and `callback {...}`.
- **Levels/Antack*/*.txt** — 57 files in an older command script (`get "obj"` / `hud true` /
  `tex 1,"GUI02.png"` / `col 1,r,g,b,a`), CR line endings; plus numeric pose lists.
- **.emt** — one `key=value` per field: model, amount, emission rate, life, fade, area, size,
  size variance, lux, weight, move/explode/scale/rotate (bool,amount), anim, speed, destroy.
  Format in `Help/particles.txt`.
- **Shaders** — ARB assembly with ATI variants (Tobias Opfermann, 2008), GLSL in 3 folders.

## 4. Code map

`Levels/default/load script.lua` → `default_Globals.lua` → `dofile`s the standard library
`Scripts/Functions/<topic>_functions.lua` in two lists:
- core: string, file, math, fltk, keyboard, mouse, camera, object, scene, physics, material,
  textBox, help, particle
- editor UI: collect, animation, main_tool, edit_mode, dialog, screenshot, uv, bone,
  mesh_editor, mesh_tool, mesh_tag, path, GLwindow, material, particlesbrowser
→ then `Fluid/UI_MAIN_TOOLS/UI_MAIN_TOOLS.fl` (the editor) → menus in `Scripts/Functions/Menus/`.

Game frameworks (each = `X_Functions/` library + `Levels/X` + often `Fluid/RNDX` generator):
- **RTS** `Scripts/RTS_Functions` (AI, A* pathing, orders, senses, tasks, weapons, vehicles;
  `RTS_Entities/`: Human, Zombie, Car, Gun, Door, Building, Window, Teams, GUI, BloodPencil) + `Fluid/RNDRTS`, `TRON_RTS`
- **UDG** `Scripts/UDG_Functions` — near-copy of RTS with melee, level exits, scenery, editor
  (compare before porting; likely one framework in two generations) + `Fluid/RNDUDG`, `UDG_Options`, `UDGMapper`
- **FPS** `Scripts/FPS_Functions` + `Levels/FPS` + `Fluid/RNDFPS`
- **iFly** `Scripts/iFly_Functions` + `Levels/iFly` (screens Title/Briefing/Options/...) + `Fluid/RNDIFLY`
- Others: `Levels/Warhammer` (German, XML regiments, network play), `NXTpbLuaSim` (LEGO NXT sim),
  `Tank`, `Car`, `Bike`, `UFO`, `Tronish`, `BobetteSoccer`, `SquigLand`, `RPG`, `Recognizer`,
  `BrickFun`, `Antack*` (old-format GUI/fight levels), `HelloWorld`, tests.

Converters `Scripts/Convert`: BVH→WIF→WTF, Aquarius characters, Dungeon (DSB) maps, C++→iGame3D Lua.
Examples `Scripts/Examples`: BVH parsers, bone builders, UV fun, character utilities.
Network: `Scripts/LuaSocket` (third-party, not sent to Spark), `Fluid/telnet*`, `3Dnet*`.
Tools in `Fluid/`: browsers (Models, WTF, PNG, XPM, BVH, WIF, Particle, Camera, Classes, Textbox,
Universal), editors (mesh, animation, keyboard, script, AutoBones, BodyPaint, Lights, Colors),
mappers (Dungeon*, PBM, ZGS_Maker), `murgacompiler`, `console`, `ExportObj`.

Engine API style: `make/get(ig3d_<type>, ...)`, `get|set<Object|Scene|Camera|Light|Bone|Material>Info(x, IG3D_<FIELD>, ...)`
(setObjectInfo 796 uses, setLightInfo 556, getObjectInfo 454 ...), 118 distinct `IG3D_` constants,
plus the older `ig3d_Verb_typesig(...)` names in `Help/reference.txt` (suffix encodes arg types:
`_2s6f` = 2 strings, 6 floats).

## 5. Spark pass (code → per-file and per-folder drafts)

`python3 -I _manifest/tools/spark_manifest.py --plan` → **~2,450 requests** over 167 folders
(Fluid/Mappers 344, Scripts/Functions 165, Scripts/Convert 131, RTS 103 ...). At a 4B model's
pace that is an overnight-plus job; it is resumable (finished files are skipped, `.partial` kept).
Sent: .lua, .fl, .py, .js, shaders, Levels/*.txt, .emt (batched per folder). Not sent: WTF/OBJ
(→ `wtf_index.py`), Help (Claude reads it directly), LuaSocket, binaries, png/html.

Suggested order: `Levels/HelloWorld` (3 requests, smoke test) → `Levels/default` →
`Scripts/Functions` → `Scripts/RTS_Functions` → `Fluid/UI_MAIN_TOOLS` → rest. Skip or run last
`Fluid/Mappers` (mostly iteration copies — diff them first).

**Review (2026-11-12, first 60 drafts).** `python3 -I _manifest/tools/check_drafts.py` → `REVIEW.md`:
every name a draft mentions is checked against the real source. 44 of 60 drafts clean; no
draft missed a function. Spot-read against source: descriptions are accurate. The errors are
almost all in **Glossary** lines, padded with the prompt's own background examples
(`loadLevel` in 7 drafts that never call it, `IG3D_POSITION`, `ig3d_object`, `gObjects`), plus Lua
built-ins (`dofile`, `loadstring`, `print`) called "engine calls" and one misspelling
(`gNSWallWallWTF`). Cause: the prompt's templates listed those names as examples. Fixed in
`spark_manifest_prompt.md` (v1 kept as `spark/.prompt_v1_2026-11-12.md`); applies from the next
start of `START_SPARK.bat`. **Rule for the glossary merge:** accept a term only if
`check_drafts.py` finds it in that file's source; treat "engine call" labels as unverified
until matched against `Help/reference.txt`.

**Review 2 (2026-11-12 evening, 105 drafts: Scripts/Convert, Examples, FPS, Functions, RTS, UDG).**
89 of 105 clean. Spot-read RTS_AI, debug_functions, xpm_functions and the Functions folder note
against source: function lists complete and descriptions accurate.
- *Correction to review 1:* `gObjects`, `loadLevel`, `ig3d_object`, `IG3D_POSITION`,
  `getObjectInfo`/`setObjectInfo` are real engine-wide names (each in 46–87 scripts). The checker
  now lists names found in any other Data/ script under **Elsewhere**. They are real but not
  counted as errors, and file names (`x.lua`) are not checked at all. Only true inventions stay
  under **Unseen**.
- Real name errors (7): misspellings `gNSWallWallWTF`→`gNSWallWTF`,
  `XPMreadColorLines`→`XPMReadColorLines`, `getObjectModelPath_s_s`→`ig3d_GetObjectModelPath_s_s`,
  `gParticleBrowser`→`ParticleBrowser*`; inventions `uoffv`, `bone_name`; `HelloWorld` is the folder name.
- **Token limit:** `Scripts/Functions/_FOLDER.md` (47 files) stopped mid-glossary at the fixed
  2,000-token folder budget. Its last file lines had also degraded to filler ("provides UV-related
  helper functions"), and it invented a duplicate `file_functions.lua` and called BVH "binary"
  (BVH is a text format). Deleted for regeneration. `spark_manifest.py` now gives folder notes
  `1000 + 80 × files` tokens (capped by `--max-tokens`) and stamps any reply that hits the limit
  with `<!-- CUT OFF ... -->`. The checker flags cut-off drafts and accepts the `**Keep:**` label variant.
  `mesh_editor_functions.lua.md` has no verdict line, and `RTS_Zombie.lua.md` ends in a dangling
  "Note:"; both are otherwise fine.
- For GAD: `RTS_AI.lua` has a senses → perceived-priority → `mind` memory → task loop
  (`handle_object_eyes/ears`, `sort_perceived_objects_by_priority`, `do_task`). This is
  a ready model for agents that *detect* before they act.

**Review 3 (2026-11-12, 17:30, 120 drafts, during the Scripts run).** The 13 new RTS drafts
read well against source (RTS_Weapons checked line by line: every function right). Two new
faults, both fixed in prompt v3 + runner (v2 kept as `spark/.prompt_v2_2026-11-12.md`; they apply
when run_spark.sh starts its next python process, i.e. the "everything else" phase):
- **Self-talk** in 7 drafts: Spark argued with the PART rules inside its answer ("Wait, the
  instructions say... Let me correct") and wrote sections twice; in RTS_astar it ran out of
  tokens doing so. Trigger: the `Top level` rule, which Spark had to judge itself, and long
  functions cut into several parts being labelled "top-level code only". Now the runner decides
  (`lua_toplevel`: Lua block depth) and tells Spark: HAS / has NO code outside functions, or
  "middle of long function X: one `### X (continued)` section". `ask()` retries once on self-talk
  and stamps `<!-- SELF-TALK -->` if it repeats. The 7 drafts moved to `superseded/prompt_v2/`
  (kept as bad examples); the next phase redoes them because it skips only finished files.
- **Padded Depends on** in 49 file summaries: prompt background (`Data/` 35, `dofile` 15,
  `loadLevel` 13, `gObjects` 9) listed though the code never uses it. The FILE prompt now says
  copy Depends on from the part notes' Uses lines; `fit()` keeps Uses lines when shrinking notes.
  Not rerun (descriptions are fine): **glossary merge rule — ignore a Depends-on name the
  checker marks padded.**
- `check_drafts.py` now flags **self-talk** and **padded Depends on** (negations such as
  "no `Data/` paths" are skipped); `--help` prints its usage instead of running.

**Status 2026-11-13 00:10 and prompt v4.** 225 drafts, 179 clean; 42% of the requests done.
The v3 fixes held: 4 self-talk answers, all fixed by the automatic retry; the 7 set-aside
drafts were redone. New fault: folder notes ran out of tokens in the "Shared with other
folders" list (4 notes, plus one file note). Prompt v4 (v3 kept as `spark/.prompt_v3_2026-11-13.md`)
caps the Files, Shared and Procedure lines. Also, the owner: `.fl` FLUID files duplicate the
`.lua` beside them in murgaLua iGame3D, so they are listed but no longer sent. That leaves 897
requests instead of 1,413 (about 10 hours). The 5 cut-off drafts went to `superseded/prompt_v3/`
and the run was restarted (resumable). `Scripts/Functions/_FOLDER.md`, cut off twice before,
now comes out complete. `Fluid/Mappers` (17 .lua, all dated 2009-01-13) reviewed by Claude by function sets:
three lines of one tool family. Dungeon draw: Dungeon3D = DungeonDraw -> DungeonDraw3D ->
DungeonDraw3Dn ~ **DungeonDraw3D8** (final: `resestGrid` fixed, wall copy + quad mesh), side
branch DungeonMagicDraw. Dungeon mapper: MapperB < DungoneMap < DungeonMapperNOBSD ->
DungeonMapperworks (= the functions of `Scripts/Functions/dungeon_functions.lua`; the final tool
is `Fluid/DungeonMapper/DungeonMapper1226830pm.lua`) and **DungeonMapperNaked** (the window
alone, loading the library). Mapper: **Mapper** (colour cycling) -> Mapper2 < **Mapper3**
(drag drawing); Mapper4 < **Mapper5** (button-list browser), MapperA a cut of it. Spark reads
only the 5 in bold (`ONLY` in spark_manifest.py), about 30 requests instead of 125.

## 6. Glossary seed (Claude, to be grown from Spark's Glossary lines)

- **Data root / gameroot** — folder holding `Data/`; all paths relative to it. `IG3D_ROOT` scene info.
- **level** — folder with `load script.lua`; `loadLevel` runs it; `saveLevel` writes it.
- **WTF** — iGame3D model file ("iGame3D Mdl"). **WIF** — intermediate model/animation format (BVH→WIF→WTF).
- **BVH** — motion-capture skeleton animation. **bone / BoneOrientations** — skeleton in a WTF.
- **mesh** (the level's static geometry) vs **object/entity** (placed instance of a WTF).
- **mesh tag** — named vertex group. **path** — spline an entity can follow (`PathSources/`).
- **emitter (.emt)** — particle preset. **lux** — unlit/full-bright flag. **hud** — screen-space object.
- **material** — multi-line `key=value` block (Help/materials.txt). **morph** — vertex morph material flag.
- **Fluid / .fl** — FLTK UI designer file. **murgaLua** — the Lua+FLTK runtime.
- **RTS / UDG / FPS / iFly** — the four game frameworks; **RND\*** — random level generators for them.
- **AquaChar** — 3D font, one WTF per character. **Antack** — early game, old command-script levels.
- **PBM / XPM** — bitmap formats used as map sources for Mappers (image → level).

## 7. Procedure-first candidates (stop carrying gigabytes)

Already procedural in the code (port these, drop their output files):
- `Fluid/RND*` level generators, `Fluid/Mappers`, `DungeonMapper`, `PBMMapper` (image/grid → 3D level),
  `ZGS_Maker`, `Scripts/Convert/DSB_Dungeons.lua`, `object_functions.lua: createBlockarray`.
- `Fluid/AutoBones` (auto-rig), `BodyPaint`, `cubemap`, `Colors`.

Assets that are trivially procedural (keep a recipe, not a file):
- `WTF/Cubes`, `Shapes`, `Spheres`, `Floors`, `Walls` (`10ftwall`, `40ftwall`...), `Building_parts`
  (stairs, balustrade), `Street/road*`, `Skybox`, `Billboards/square`, `Reticule/crosshair`,
  `DungeonPack` tiles, `Bump_mesh`; the 256-file `AquaChar` font (extrude glyphs);
  all 75 `.emt` (a parameter table per effect: explosion, fireball, glow, pulsar...).
- Size names in files are a hint: `road780x3k`, `stairs1x3x3`, `floor180x180` = parameters.

Keep as files (hand-made, not worth regenerating): Characters (13 MB, rigged/animated),
Vehicles, Houses/Buildings detail models, Animals, Furniture, Weapons — but index them
(WTF_INDEX.md) and convert the keepers to glTF once, then archive the rest.

## 8. Next steps (for xt3d / Vibecode3D)

1. Spark run (§5) → Claude reviews each `_FOLDER.md`, fixes errors, merges Glossary lines into
   one `GLOSSARY.md` (term, meaning, iGame3D name, xt3d/Vibecode3D name).
2. Extract `Help/reference.txt` + `scripting.txt` (`func:` / `docs:` records) into an API table
   deterministically — the authoritative glossary for engine calls.
3. Build `PROCEDURES.md`: for each procedural candidate, inputs → output, source file, and the
   xt3d/Vibecode3D equivalent to write. Assets get a status: *procedure* / *file (glTF)* / *drop*.
4. Archive: once 1–3 are done, `.svn` (56 MB), Mapper copies and OBJ timestamps can go to cold storage.
