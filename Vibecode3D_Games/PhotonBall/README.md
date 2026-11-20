# Photon Ball

Thursday, November 20, 2026. Written by Claude (Opus 5.5) from the owner's plan
(`LIB_DEV/PriorityTube/PHOTON_BALL_PLAN.md`, step 1: hand-placed, no randomness).

Vector Toss's arena made dangerous and "a lot less casual". Vector Toss stays as it is; Photon
Ball is a copy of it (`../Vibecode3D_Play_PhotonBall.livecodescript`, prefix `PB.`). Engine 1
(Vibecode3D, pure xTalk); the xt3d games bench plays it too.

## How to play

| Key | What |
|---|---|
| mouse | aim the ghost ball; hold the button for power, let go: up, off the roof, down |
| W A S D / arrows | run |
| SPACE | jump (onto a ledge, over a hole) |
| SPACE, W or UP while hanging | climb out (before your grip gives) |
| C / E / TAB | swap to the companion / an easy one / landing ring |
| ENTER or R | after the end: again |

## The matches (every 10 catches: the floor mended, a worse rule)

| Match | Rule |
|---|---|
| 1 | The ball breaks the square where it **first** comes down. |
| 2 | **Every** bounce breaks the square under it. |
| 3 | Every bounce breaks the square under it and **cracks the eight round it** (a cracked square hit again breaks). |
| 4 and on | Every bounce **punches a hole** under it; the eight round it get a step worse (whole -> cracked -> broken -> hole). |

A **broken** square (orange, cracked across) holds you while you stand on it.
- Match 1: it falls apart 2.5 s after you step off it.
- Match 2 on: it falls apart 1.5 s after you step on it (it blinks white until then).
- Land on one from a jump (or off a ledge): you **smash through**, and no hang can catch you.

Falling into a hole: you grab the edge (Harold Lloyd's moves from "Safety Last!", 1923, cut from
the LIB_MOCAP clip as Dead Days cuts it: climb 1-44 = take hold, hang 132-182 looped, recover
45-108 = haul out). Each hero has hangs (one, +1 every 10 points; shown as `^`). The companion
climbs out by itself after 0.9 s; you press SPACE, W or UP.

**Stamina** (Vector Toss's rules, `../VectorToss/STAMINA_NOTE.md`) now DOES something in the
hole: the grip lasts 1.5 s at stamina 0 up to 5 s at 100, and climbing out plays at 40% speed at
0 up to full speed at 100 (both straight lines between). Climbing out still costs -5.

A third fatal fall (no hang caught it: out of hangs, lost the grip, or smashed through) ends the
game, as in Vector Toss.

## The walls (hand-placed, `walls.cellmap`)

Every wall but the camera side has features, chosen to matter in play:

| Where | What | Why |
|---|---|---|
| far wall, both halves | a 2-cell **ledge** 30 up (green), with a **ramp** up to it from the middle side | squares under ledges and ramps never break: a refuge when the floor goes. A hero jumps up (a jump peaks at 35) or walks the ramp. A ball banking low off the far wall meets the ledge's face 40 nearer: a shorter bank |
| far wall, middle | a **kicker** ramp (rises 45 to the wall) and the **star emblem** above it | a bank off the star scores +1 for the catch; a ball that comes down near the far wall is thrown back towards the camera instead of rolling to the wall |
| west wall (PROMPT's back) | a **kicker** slope near the camera corner, a **ledge** behind PROMPT, the **P** emblem between them | the kicker throws a ball rolling to the back back into play; the ledge is a refuge two steps from home; a ball striking P mends a square on PROMPT's half |
| east wall (GLAZE's back) | a **pillar** 90 up (no jump reaches it), a **ledge**, the **G** emblem between them | the ball banks off the pillar's face early; the floor in its lee is hard for the ball to reach; G mends a square on GLAZE's half |

Emblems are flat on the wall (no depth), the letter between two uprights that mark where on
the wall it counts (at any height). A struck emblem flashes white.
- **Far wall** emblem: +1 for each bank off it, counted when the ball is caught.
- **Back wall** emblem: once a throw, the ball striking it mends the worst square on that hero's
  half (a hole first, then broken, then cracked; the nearest to the hero of those).

## The wall layout format (for step 2: ComfyUI random mode must write this)

`walls.cellmap` is an ordinary **cellmap** (`LIB_BIT/editor/CELLMAP_V2.md`, slopes from
`CELLMAP_V3.md` section 2): it opens in the BitEditor, and `CellMap.Read` reads it (test t63
checks that the game's ground equals the library's `floor` + `RiseAt` at 12 points). UTF-8 text,
a tab between key and value.

```
# cellmap 3 - LIB_BIT/editor (format: editor/CELLMAP_V2.md + CELLMAP_V3.md)
[map]
name	photon_ball_walls
cols	20              must be 20 (the arena's 18 squares + a wall cell each side)
rows	10              must be 10 (8 squares + the camera side + the far wall)
cell	40              must be 40 (one floor square)
wallH	150             engine units for 100 hu: 1 hu = 1.5 units
unitPx	16
font	Aquarius
tags	tags_default
version	3
step	10              hu a hero walks up without a jump (10 hu = 15 units)
[design]            10 lines of 20 characters: the emblems' letters
[tags]              10 lines of 20 characters (# wall, . floor, space nothing); not read by the game
[floor]             10 lines of 20 numbers 0-255 (hu), right-aligned in 3, a space between
[slope]             col,row <tab> nw ne se sw   (hu each corner rises above the cell's floor)
```

**The grid.** Column 1 = x -400..-360 (the west wall, behind PROMPT), columns 2..19 = the arena's
18 squares from x -360 to 360, column 20 = the east wall (behind GLAZE). Row 1 = z -200..-160
(the **camera side**: all 0, nothing there), rows 2..9 = the arena's 8 rows from z -160 (near the
camera) to 160, row 10 = the far wall. This is exactly where `CellMap.CellAt` puts them (a map
is centred on 0,0; row numbers grow with z), so the editor's "north" (row 1) is the camera side.

**What the game reads.**

| Layer | Cells | Meaning |
|---|---|---|
| `[floor]` | arena (cols 2-19, rows 2-9) | 1 = plain floor (breaks). More than 1 and no slope = a **block** whose top is (floor - 1) x 1.5 units: 21 = a ledge 30 up (jumpable: a jump peaks at 35), 61 = a pillar 90 up. Blocks never break, stop heroes lower than their top less a step, and bounce the ball off their sides |
| `[slope]` | arena | a **ramp**: ground = (floor - 1 + rise) x 1.5, the rise blended between the four corners as `CellMap.RiseAt` does (nw = low x, low z; ne = high x, low z; se = high x, high z; sw = low x, high z). Ramps never break; heroes walk them; the ball bounces off the slope's normal and rolls downhill |
| `[design]` | wall cells: row 10 cols 2-19 (far), col 1 and col 20 rows 2-9 (back walls) | a character other than `#`, `.` or space is an **emblem**; neighbouring cells with the same character are one emblem. Far wall emblems: +1 a bank. Back wall emblems: mend a square of that hero's half. The game draws `*`, `P` and `G`; any other character is drawn as a diamond |
| everything else | | ignored by the game (wall cells' heights, tags, ceiling, links...). The arena's walls and roof stay Vector Toss's (x +-360, z +-160, roof 300) |

A missing file, or one that is not 20 x 10 cells of 40, plays the plain arena (Vector Toss's
floor) and says so in the intro.

**Things a generator should keep** (they are what makes a layout fair; the game does not refuse
others):
- Leave the heroes' home squares plain: x = +-198, z = 0 (columns 6 and 15, row 6).
- Keep features against the walls (rows 9, columns 2 and 19): the middle is for catching.
- Keep blocks and ramps off the centre line columns 10-11 except at row 9 (the heroes stop 22
  short of the middle).
- A ramp's high side should meet what it leads to (the ramp at 7,9 rises 20 hu on its west side
  to the ledge at 5-6,9 of floor 21).
- Steep is the cellmap's 60 hu between corners: steeper is still walkable here (the game uses
  the map's `step` only), but the BitEditor's checker will warn.

## Files

| File | What |
|---|---|
| `../Vibecode3D_Play_PhotonBall.livecodescript` | the game (card `Play.PhotonBall`) |
| `walls.cellmap` | the walls (above) |
| `banter.txt` | PROMPT and GLAZE talk (our own lines; events listed at its top) |
| `../Animations/PhotonBall.anims.txt` | throw, lob, catch, jump, climb, hang, recover |
| `OXT-BEYOND/tests/t63_photon_ball.txt` | headless test: 75 checks, both engines |
