# Corridor Lab

Our own first-person corridor shooter (p1-33 "Make it run DOOM", the vector version).
Card script: `../Vibecode3D_Play_CorridorLab.livecodescript` (Engine 1, Vibecode3D). Walls come from
LIB_RAYCAST (`Ray.*`, plain xTalk); the game draws its own polygons over the engine's picture.

**In memory of Scott McDonald** (The LiveCode Lab). A black screen with the dedication comes
first. Level 1 is his own map from his LiveCode raycaster (public domain), turned into our
characters (his 1/2/3 walls = `#`, 4 doors = `D`, 5 spiders = grunts, 6 exit = `X`, 7 his green wall
= `G`), with a closing row and ten ammo/health boxes added.

## Looks (V)
- **solid**: Scott's look: filled walls shaded by distance, flat ceiling, floor gradient.
- **glass**: the Vibecode3D look: see-through walls, bright edges, a floor grid.
- **lines**: edges only, the plainest vectors. Uprights are drawn only at real corners.
Level 1 starts in solid, levels 2-3 in glass, until you press V; then your pick stays.
C changes the number of rays (80/120/160/240): fewer = faster; wall corners stay exact.

## Headless speed (OXT-Beyond, no window, 23 Nov 2026; painting is not counted)
solid 3.6 ms, glass 3.9, lines 3.9 a frame at 120 rays; glass 80/160/240 rays: 3.2/5.0/7.2 ms.
Real window (OXT-Beyond, 900x600, 23 Nov): solid 31 fps (5 ms draw), glass 31 fps at 120 rays.

Test: `OXT-BEYOND/tests/t77_corridor_lab.txt` (33 checks).

## Not yet
Doors open instantly-ish (10 frames glowing), no sliding animation. No sounds. Monsters do not
open doors or avoid each other. No mouse look. xRay (raylib) has no own draw of these polygons:
they are LiveCode graphics over its picture. The five-heights cellmap is not read yet (text grids).
