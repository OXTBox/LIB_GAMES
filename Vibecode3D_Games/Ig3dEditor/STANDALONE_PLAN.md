# iGame3D Editor: the standalone edition

Monday, November 16, 2026. Draft 1 (Claude, Opus 5.5), from the owner's decision: hold off
shipping the editor; make an edition stripped of everything external, with the external Data
path kept as a template filled only with things we own or generate, a very light download that
still shows what the editor can do. The owner decides; the checklist is his to mark.

## Two editions

| Edition | Branch (LIB_GAMES and LIB_ig3d) | What it is |
|---|---|---|
| **We know it works** | `ig3d-editor-works` (= `editor-tools` / `v3d-editor-tools` on 16 Nov) | the editor as you run it: the 2008 Data folder, LIB_MOCAP clips, the LIB_ig3d tool windows, all read from the projects folder. Frozen: fixes only |
| **Standalone** | `ig3d-editor-standalone` (starts from the same commits) | needs nothing outside its install; ships a template Data folder; can still be pointed at a full Data folder |

The installer holds the editor back (LIB_PUBLIC `vibe-install`, `HOLD` in vibeinstall.py)
until the standalone edition is ready.

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

## Steps

| # | Step | Who |
|---|---|---|
| 0 | Two branches in each repo; the installer holds the editor back | done 16 Nov |
| 1 | Mark `ASSET_CHECKLIST.tsv` (beside this file): own / free / generate / no for each group | owner |
| 2 | Generator + template: README per folder, generated meshes/emitter/level/clip, the marked owned files copied | Claude |
| 3 | Internalize the tool windows (`Tools\`), `Ig.DataRoot` / `Ig.Projects` in the order above, Set Data Folder... | Claude |
| 4 | Every wired tool has a demo on the template; tools not wired yet say so | Claude |
| 5 | Better to look at: the toolbar and Library panel in LIB_THEME's dark palette, a grid floor with axes, model previews in the list, the status line kept short | Claude, your taste decides |
| 6 | Headless test (t33): the folder alone on V:, every tool opens, every Library list fills, nothing reaches outside; size check | Claude |
| 7 | Ship: remove `Ig3dEditor` from HOLD | owner |

## Questions for the owner

1. Which asset groups are yours to ship (paid for, or made by you)? Mark the checklist; my
   guesses aren't in it on purpose.
2. Name: "iGame3D Editor" in public, or a new name for the standalone edition?
3. Help pages (2008 Help, 20 files): rewrite short new ones, or leave Help out?
