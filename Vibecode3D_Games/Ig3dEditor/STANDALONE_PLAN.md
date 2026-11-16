# iGame3D Editor: the standalone edition

Monday, November 16, 2026. Draft 1 (Claude, Opus 5.5), from the owner's decision: hold off
shipping the editor; make an edition stripped of everything external, with the external Data
path kept as a template filled only with things we own or generate, a very light download that
still shows what the editor can do. The owner decides; the checklist is his to mark.

## Names (owner, 16 Nov)

Shipped on itch.io under the owner's **xAction** handle.

| Core | without Box2D | with Box2D |
|---|---|---|
| Vibecode3D (xTalk renderer) | **iGame3D XT** (this standalone edition) | **iGame3D Box2DXT** |
| xt3d (raylib) | **iGame3D xRay** | **iGame3D xRayBox** |

## Two editions

| Edition | Branch (LIB_GAMES and LIB_ig3d) | What it is |
|---|---|---|
| **We know it works** | `ig3d-editor-works` (= `editor-tools` / `v3d-editor-tools` on 16 Nov) | the editor as you run it: the 2008 Data folder, LIB_MOCAP clips, the LIB_ig3d tool windows, all read from the projects folder. Frozen: fixes only |
| **Standalone** | `ig3d-editor-standalone` (starts from the same commits) | needs nothing outside its install; ships a template Data folder; can still be pointed at a full Data folder |

The installer holds the editor back (LIB_PUBLIC `vibe-install`, `HOLD` in vibeinstall.py)
until the standalone edition is ready. The 2008 Data folder itself (never in git before) is
committed to `ig3d-editor-works` (5a62a5d): the Lua, levels and models wait there for the
return to Lua (Defold, LOVE, a Lua external).

## The owner's decisions (16 Nov, 6:58 AM)

Per group in `ASSET_CHECKLIST.tsv`; what every group held, name by name, in `INVENTORY.md` and
`INVENTORY.tsv` (made by `tools/inventory.py`: 1,394 files, each model's vertices, edges, size).

| Decision | Groups |
|---|---|
| **generate** (procedurally, seeded by the inventoried names) | every WTF group but those below; Levels; AquaChar (from the Aquarius font bitmap) |
| **replace** | Characters: our stick figure (glb/gltf), the scripts keeping role names (civilian_001, soldier_001) |
| **convert** | Scripts and Exporters: the same functions and hooks as editable xTalk files (Python later, its own stack). The editor's data is internal and static; the files are there to read, edit and apply, by the user or their LLM. iGame3D has always been about exposing source and editing files in a text editor |
| **keep** | Help (legacy documentation, linked from the new docs); OBJ: the cube / theBox only |
| **hold** | Emitters, until there is a particle system |
| **remove** | Fluid (only the 2008 Lua calls .fl files), Shaders (until a shader library), Armor, Bump_mesh, PathSources, Clothing (a character customizer later: LIB_Taylor) |
| **motion clips** | only what the working games use (today 10: 4 iGame3D, 6 Animazoo) + ours (Video, proc); Animazoo and CMU (FreeBVH) credited |

Rights: the owner's position is that the iGame3D library is GPL-compatible and used for
teaching and research; only what's needed ships. Generated stand-ins get plain names (a few
2008 models carry third-party character names; they stay in the works branch only).

## Workstreams

| | Work | First result |
|---|---|---|
| A | **Generators** seeded by name: buildings with window rules by kind (warehouse: big, above head height; shop: knee to above head; home: hip to above head, or smaller; military: well above head) and uDead's breakable doors and windows on every one; then dungeon parts (arches, columns, walls, arched bridges), furniture, street, foliage, vehicles, weapons, containers, a vector skybox | a building generator + a street of each kind |
| B | **Aquarius**: AquaChar from LIB_BIT's Aquarius font (LIB_BIT inside the editor); the Aquarius level from its bitmap, 256 models from one file, timed | **done 16 Nov** (below) |
| C | **Stick-figure characters** with role names, replacing every WTF character reference | one glTF figure + the name map |
| D | **Scripts as files**: the Lua functions the editor calls, as xTalk files with the same hooks | the list of hooks, then the first files |
| E | **DeadDays**, a new game (third-person shooter), generated: a small city, police station, a park with an alien/ancient temple; zombies, a robot that hunts them; weapons found on the map. Police station door -> the station map; its upstairs office -> the park; the temple ends it: "To be continued" (it won best story) | its own branch in LIB_GAMES, a concept page first |
| F | The editor itself: steps 3-6 below | |


## What it reaches outside itself today (review, 16 Nov)

| Reaches | Through | Used for | Size |
|---|---|---|---|
| `LIB_GAMES/igame3D_2008_Texts` (not in git) | `Ig.DataRoot` | Library > Models (WTF), Levels, Emitters, Scripts; a model on the floor (`Ig.WTFMesh`) | 68 MB, 1,669 files (WTF alone 53 MB) |
| `LIB_ig3d/livecode/v3d_inspector, v3d_skins, v3d_models` (only on LIB_ig3d branch `v3d-editor-tools`) | `Ig.Projects` + `Ig.OpenTool` | Window > Inspector, Edit > Replace With Model..., the drag preview | 3 scripts |
| `LIB_MOCAP/library` | the Inspector's Animation page | clip preview | 271 MB (938 iGame3D clips, 41 Animazoo, 19 FreeBVH, ours) |
| `LIB_GAMES/Vibecode3D_Games/Animations`, `Skins` | Inspector, Skins | a game's animation list, saved skins | small |
| `//wsl$/.../projects` | both, last | the owner's PC only | |

Not needed any more: the 2007 PNG icons (Unicode symbols replaced them) and Images/Sounds
(the editor already leaves them out).

## The target

```
vibeapps\common\iGame3D Editor\
    Vibecode3D_Play_Ig3dEditor.livecodescript   game.txt   Play iGame3D Editor.cmd
    Tools\        v3d_inspector, v3d_skins, v3d_models   (internalized: no LIB_ig3d needed)
    Data\         the 2008 Data folder's layout, as a template:
        Emitters\  Levels\  Scripts\  Shaders\  Fluid\  Help\  OBJ\
        WTF\<the same 33 group folders>\
        each folder: README.txt (what goes here, the file format) + only what the checklist
        marks own / free / generate
        Clips\     a few motion clips (ours, generated, or marked own)
```

- **Light:** aim for under 2 MB for the whole folder (today's needs: 68 MB + 271 MB).
- **Still capable:** Library > Set Data Folder... points the editor at any full 2008-style Data
  folder (yours, on your PC), remembered in the player's Data folder (LIB_DATA). Lookup order:
  the chosen folder, then `Data\` beside the script, then Vibecode3D Common, then the walk up.
  wsl$ never in this edition.
- **Shows what it can do:** each wired tool has something to act on with the template alone:
  primitives and vertex tools on generated meshes, a generated demo level, a generated emitter,
  the Inspector on a procedural clip, Replace With Model with generated models.
- **Generated, not shipped, where possible:** a small generator (Python, in the branch) writes
  the template's meshes, emitter, level and clip from code, so most of the Data folder is
  rebuilt rather than stored.

## B, done (16 Nov)

- **One bitmap:** `Data/Text/Aquarius.pbm`, a plain PBM (128 x 128, 16 x 16 glyphs of 8 x 8,
  16.7 KB, opens in any text editor or paint program), made by `tools/aquarius_bitmap.py` from
  the bitmaps in your 2008 converter (`AquariusCharactersPMB.lua`). The same bitmap is built into
  the editor script (`kAquaHex`, 4 KB) for when the file isn't there; edit the file and the
  models change. It replaces 256 .wtf files (3.0 MB).
- **LIB_BIT's Aquarius font agrees on 251 of 255 glyphs.** It lacks the descenders of g (103)
  and j (106), and 138 and 148 differ by one pixel; the 2008 bitmaps are kept.
- **In the editor:** Library > Text lists the 256 characters (click one: it stands in the middle,
  bigger); the first line lays all 256 on the floor, one floor square each, as the 2008 aquatext
  level did. Each model is the outline of its lit pixels, raised a little: a vector glyph.
- **Speed** (test t33, the real engine from the V: install, headless, no screen): 256 models,
  15,102 vertices, 23,655 lines; made in **304 ms**, placed in **32 ms**, the first frame drawn
  in **395 ms**. On a screen the drawing time is what to watch.

## Steps

| # | Step | Who |
|---|---|---|
| 0 | Two branches in each repo; the installer holds the editor back | done 16 Nov |
| 1 | Mark `ASSET_CHECKLIST.tsv` (beside this file) | done by the owner 16 Nov |
| 2 | Generator + template: README per folder, generated meshes/emitter/level/clip, the marked owned files copied | Claude |
| 3 | Internalize the tool windows (`Tools\`), `Ig.DataRoot` / `Ig.Projects` in the order above, Set Data Folder... | Claude |
| 4 | Every wired tool has a demo on the template; tools not wired yet say so | Claude |
| 5 | Better to look at: the toolbar and Library panel in LIB_THEME's dark palette, a grid floor with axes, model previews in the list, the status line kept short | Claude, your taste decides |
| 6 | Headless test (t33): the folder alone on V:, every tool opens, every Library list fills, nothing reaches outside; size check | Claude |
| 7 | Ship: remove `Ig3dEditor` from HOLD | owner |

## Questions for the owner

1. (answered 16 Nov: the checklist)
2. (answered 16 Nov: the names below)
3. (answered: keep Help as legacy documentation)
4. Which workstream first? My suggestion: B (Aquarius: small, shows LIB_BIT, gives a speed
   number), then A (buildings), then E (DeadDays) on top of A and C.
