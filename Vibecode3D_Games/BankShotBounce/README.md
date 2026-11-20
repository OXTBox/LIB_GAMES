# Bank Shot Bounce

A billiards-style game for both engines: Vibecode3D (XT, the Game Player) and xt3d (xRay, the
games bench). Game: `../Vibecode3D_Play_BankShotBounce.livecodescript` (prefix `BS.`).

- **Idea:** the owner, `LIB_LLMIN/LIB_SPARK/GAME_IDEAS.txt` (18 Nov 2026).
- **Concept and levels:** Spark (the local model), 19 Nov 2026:
  `LIB_SPARK/arcade/out/285_Bank_Shot_Bounce/1_concept.md` and `2_levels.md`
  (LIB_SPARK branch `bank-shot-bounce`).
- **Table physics: Jim Hurley** (jhurley@infs.net), from Scott Rossi's "nine ball" stack, as
  rewritten in the Nine Ball game (LIB_GAMES branch `nine-ball`): the equal-mass collision
  (`resetVel`), the cushions, the cloth, the pockets, "every ball stopped". His name is in the
  script header, on the title screen and on the credit line.
- Written by Claude, 19 Nov 2026 (night).

## The game

Your white ball and numbered balls on a table seen from above. Drag BACK from your ball (a
slingshot) or aim with the keys. Sink the numbered balls in order: number x 10 points. A ball sunk
out of order comes back to its spot. Your own ball sunk = a life. All numbered balls down = the
table's bonus and the next table. Five tables:

| Table | Name | Balls | Lives | Bonus | What changes |
|---|---|---|---|---|---|
| 1 | Plain table | 3 | 3 | 100 | nothing: learn the pull |
| 2 | Slick felt | 4 | 3 | 150 | felt 0.994 a step (icy blue): balls run far |
| 3 | A bumper in the middle | 5 | 2 | 200 | an orange round bumper kicks balls off 15% faster |
| 4 | Sliding pockets | 6 | 2 | 250 | the two side pockets slide along the long rails, opposite ways |
| 5 | Hourglass on sticky felt | 7 | 1 | 300 | two blocks narrow the middle (no side pockets); felt 0.986 (mossy) |

Balls, lives and bonus are Spark's table as it wrote it. The table changes follow Spark's level
notes and the owner's idea (odd shapes, bumpers, sliding pockets, slick or sticky felt).

## Controls

- Mouse: hold the button and drag back from your ball; it goes the other way. The longer the pull,
  the harder (pull / 25, at most a 400 pixel pull). Let go to shoot.
- Keys: Left/Right or A/D aim (Shift: fine), Up/Down or W/S pull harder/softer, Space or Enter shoots.
- C: straight-down view <-> 3D view. R: this table again (score back to the table's start).
- Title, table clear, no lives, every table won: Space or a click goes on.

## What Claude changed from Spark's concept (and why)

- Spark's CONTROLS had Up = shoot and no way to set the pull from the keys: Up/Down set the pull,
  Space shoots (as in Nine Ball); the mouse slingshot is the owner's "drag back".
- Spark's rule "the main ball must be sunk before any numbered ball" was a mix-up (its own LOSE
  line says sinking your ball costs a life): left out.
- Spark: sinking your ball "ends the current level". Here it costs a life and your ball comes
  back to its spot; only the last life ends the table (Space plays it again).
- Out-of-order balls: the idea says "in order for points"; here they come back to their spot so
  they can still be sunk in order.
- Spark's "speed" column (120 everywhere) and its LAYOUTS pictures (the same maze picture five
  times) were not used: ball spots were placed by hand.
- Points: Spark said one point a ball; here the ball's number x 10, plus Spark's bonus.
- Lives are the table's own (Spark's column), not carried from table to table.

## Other choices

- Ball radius 20, table 820 x 480, three Hurley steps a frame: the same as Nine Ball.
- Pockets only catch balls while balls roll (a sliding pocket passing a still ball does not take it).
- The white aim dots show where your ball goes, bounced off the outer cushions (a bank-shot
  guide); they do not see balls, bumpers or blocks.
- The top view camera is higher than Nine Ball's (950): on the real engine the close top view
  ran at 12 fps, this one at about 21.

## Tests

- `OXT-BEYOND/tests/t61_bank_shot_bounce.txt`: stand-in engine, 75 checks.
- `OXT-BEYOND/tests/t61b_bank_shot_bounce_xray.txt`: the xt3d edition of the engine (no window), 12 checks.
- Run: `cd ~/projects/OXT-BEYOND/tests && flock /tmp/oxt_headless.lock python3 -I oxt_headless.py --engine both t61_bank_shot_bounce.txt t61b_bank_shot_bounce_xray.txt`
- Real engine: `tools/engine_play.sh BankShotBounce BS "0:5 32:2 0:10 32:2 0:120"` (about 21 fps).
