# Nine Ball

**Scott Rossi's nine ball, with Jim Hurley's table physics**, rewritten for both engines:
Vibecode3D (XT, the Game Player) and xt3d (xRay, the games bench).
Game: `../Vibecode3D_Play_NineBall.livecodescript` (prefix `NB.`). Rewritten by Claude, 19 Nov 2026.

## Credits

- **Scott Rossi**: the original "nine ball" stack (from his collection): the table, the rack,
  dragging out from the cue ball to aim and set the power, the aim line and its long extension.
- **Jim Hurley** (jhurley@infs.net, the stack's About box): the physics: equal-mass elastic
  collisions (`resetVel`), cushions, the cloth (`tableFriction`), pockets, the scratch.
- Both names are in the script header, on the title screen and on a credit line under every game.

Source (read only, never changed): `LIB_GENERICA/Data/Example/scriptBlocks/Math.txt` (resetVel,
theLineAngle, theDist), `Update.txt` (startStroke, doInit, doMove, AllStopped), `Mouse.txt` (button
Ball0's drag). The whole stack harvest: `XTJSON/Scott_Rossi_nine_ball/`.

## Kept as Hurley wrote it

- Table 820 x 480, ball radius 20, cushion 20, pocket capture radius 48 (the 96-wide pocket ovals at
  the same six places), friction 0.991 a step, stopped = every speed under 0.2.
- One step = his `doMove` pass: each ball in turn is pocket-checked, moved, checked against the
  nearest overlapping ball numbered after it; on a hit both step back one move, `resetVel` swaps the
  parts of the velocities along the line of centres; then the cushions (step back, turn round), then
  the cloth. Momentum and energy are kept exactly by the collision (test t60).
- Rossi's stroke: speed = drag length / 25, toward the point you drag to.
- A scratched cue ball goes back to Hurley's `tLeftSpot` (205,240) when everything stops.

## Changed (and why)

- **Three Hurley steps a frame** (his loop ran every millisecond; at 30 frames a second one step a
  frame was far too slow).
- **A sunk ball leaves the table.** In the original it was sent off screen and kept rolling and
  bouncing there with the others.
- **Still overlapping after a hit:** the ball is eased off along the line of centres; Hurley stepped
  it back 1,1 diagonally, which could push it through a rail.
- **Power capped at 16** (a 400 pixel drag). The original had no cap.
- **Rack:** Rossi's diamond places, with the 9 in the middle (as nine ball is racked); his stack
  had the 5 in the middle and the 9 at the back.
- **Nine ball rules added** (the original had none; it counted shots and hits): two players in turn;
  hit the lowest ball first; a ball sunk on a fair shot = shoot again; the 9 on a fair shot wins
  (combinations count); a foul (wrong ball first, nothing hit, scratch) gives the table over; a 9 sunk
  on a foul goes back on the foot spot (507,240). Left out: ball in hand anywhere, the rail rule,
  three fouls, pushing out. After a foul that is not a scratch the cue ball stays where it stopped.
- **The mouse:** hold the button anywhere and drag (the 3D view has no button to press on): the cue
  ball goes toward the mouse. The screen point is turned into a table point with the engine's
  `Camera.WorldToScreen` (Newton's method), so it works the same on both engines.
- **Keys** for when there is no mouse (`gNoMouse`): Left/Right aim, Shift fine aim, Up/Down power,
  Space shoots. C switches to a straight-down view and back. R racks again.
- Left out: the impact circles ("scatCross", a preference), the hits/shots/percent fields,
  the What's Inside text, sound.

## Tests

- `OXT-BEYOND/tests/t60_nine_ball.txt`: stand-in engine, 58 checks: collision keeps momentum and
  energy, the cloth (0.991 a step), a straight shot pockets, lowest ball first, shoot again, foul,
  scratch, the 9 wins, the 9 back on a foul, keys, the mouse drag, screen -> table, a full break.
- `OXT-BEYOND/tests/t60b_nine_ball_xray.txt`: the xt3d edition of the engine (no window): the frame
  has the table, 10 balls, 6 pockets, aim dots and HUD lines; the mouse aim on the real camera math.
- Run: `cd ~/projects/OXT-BEYOND/tests && flock /tmp/oxt_headless.lock python3 -I oxt_headless.py --engine both t60_nine_ball.txt t60b_nine_ball_xray.txt`
- Real engine (Game Player library): `tools/engine_play.sh NineBall NB "0:10 32:2 0:120"`: about 18-20 fps.
