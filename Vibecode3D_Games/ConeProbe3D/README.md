# Cone Probe 3D

New game, 23 Nov 2026 (bubble p1-29). Game: `../Vibecode3D_Play_ConeProbe3D.livecodescript` (prefix `CP3.`).
Engine 1 (Vibecode3D, iGame3D XT); it uses only the engine contract, so the xRay bench should play it too.
Test: `OXT-BEYOND/tests/t76_coneprobe3d.txt` (28 checks, real Game Player, headless, both engines).

## What it is

**Probe vs Cone** with the same rules, seen in **third person**: the camera rides behind and above
Probe and turns with him, as in an MMO. Break the shield cubes round the Cone, pick up the key tokens
they drop to spell the password, then put the javelin into the Cone. Five levels.
The original flat game (`Vibecode3D_Play_ProbeVsCone.livecodescript`) is untouched.

| Keys | |
|---|---|
| W S, Up Down | run forward / back |
| A D, Left Right | turn (the camera turns with you) |
| Q E | step sideways |
| Space (or hold the mouse button) | charge the javelin; let go to throw it the way you face. The longer you hold (one second = full), the farther it flies. The dotted line on the ground shows how far. |
| 1 | power bar: quick throw (no charge) |
| 2 | power bar: dash, a quick dodge forward (3 s cooldown) |
| 3 | power bar: recall, the javelin flies back to your hand (8 s cooldown) |
| Escape | pause |

- **Shield**: rings of cubes round the Cone; every few seconds a gap is filled from the ring inside.
- **Energy pulse**: a wiggling strand between the standing cubes of the outer ring; it stops the javelin.
  Where a cube is gone the gap is open: aim for a cube or a gap.
- **Foes**: geometry shapes orbit the Cone; a touch costs a life; the javelin smashes them.
- **Your own javelin**: a fast loose one that hits you costs a life; walk over a still one to pick it up.
  It never comes to rest where you can't reach it (it slides out from the shield).

## How it's made (for intermediate xTalk scripters)

**A flat game stood up.** Probe vs Cone works on a flat plan: x across, y toward the player. This game
keeps that plan for all its rules (collisions, the pulse, ricochets are the same maths) and only turns
it into the world when it draws: `CP3.Put id, x, y, height` puts an object at world x = x, z = -y,
y = -height (in the engine, up is negative y). Meshes that never move (the arena, the bumpers, the
pulse) are built with the same rule by `CP3.Vert` / `CP3.Line`, at the world's origin.

**Turning a mesh to face the way you go.** Probe's mesh is built facing +x. The engine turns a mesh
about y so that +x points along (cos a, -sin a) in the world, which on the plan is (cos a, sin a): so
`Entity.SetRotation id, 0, sHead, 0` with the plan heading is all it takes.

**The camera.** `CP3.Camera` stands 150 units behind Probe (along his heading, on the plan) and 75 up,
and looks at a point 80 units in front of him. `Camera.SetLook` takes the yaw (0 looks along +z,
positive turns right) and the pitch (positive looks up), both from atan2 of the look direction. The
camera's own heading `sCamA` follows Probe's at 35% a step, so a turn shows as a turn (at most about
7 degrees late) and settles straight behind when he stops.

**Hold to charge.** While Space is held `sCharge` grows from 0 to 1 in 30 steps; letting go throws.
The charge sets the speed (55% to 115% of the level's speed) and the flying time (10 to 60 steps). In
flight the javelin rises and falls (its height is only for the eye); when the time is up it lands,
skids and stops. Probe's arm draws back in four stages as the charge grows (four meshes, swapped with
`Entity.SetMesh` only when the stage changes).

**LIB_POWERBAR.** The bar is one page of three slots (javelin, dash, recall) with cooldowns:
`PowerBar.New / Set / SetInfo`, then `PowerBar.Draw` puts the widget on the card. `CP3.Use thing`
selects the slot and `PowerBar.Fire`s it (true when it fired and the cooldown started); each step
`PowerBar.Step` runs the cooldowns and `PowerBar.Refresh` (every third step) draws the cooldown pies.
The game finds the library with `Game.FindFile`; without it the game keeps its own cooldowns and
plays on.

**Few objects.** Each object costs about 0.15 ms a frame to draw, so a whole ring of shield cubes is
ONE object whose mesh is built again only when a cube breaks or moves (`CP3.RedrawRings`). Level 4
(three rings, five foes) steps and draws in about 13 ms.

**The loading screen.** `CP3.GoLevel n` goes through LIB_LOADING_SCREEN when the Game Player has it
(else straight to `CP3.StartLevel n`); `CP3.Player()` tells the screen where to start its reveal.

**Test hooks** (section 11 of the script): `CP3.TestKeys`, `CP3.TestPlace x, y, level, heading`,
`CP3.TestSpear`, `CP3.CamInfo()`, `CP3.TestBar()`, `CP3.TestQuiet` (no orbiters). The test plays
the game with no window and no mouse.

## Notes

- 23 Nov 2026: first playable (branch `coneprobe3d`, made from Probe vs Cone on `probecone-pulse`).
  Not yet seen on screen. Open choices left plain: camera 150 back / 75 up; one second to full charge;
  dash and recall added as slots 2 and 3 so the bar has more than one thing on it.
