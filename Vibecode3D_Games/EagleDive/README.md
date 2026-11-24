# Eagle Dive

First playable, 23 Nov 2026 (bubble p1-32: the play tester's idea of an eagle flight game, made our own way).
Game: `../Vibecode3D_Play_EagleDive.livecodescript` (Engine 1, Vibecode3D / iGame3D XT; it uses only the engine
contract, so the xRay bench should play it too). Test: `OXT-BEYOND/tests/t76_eagle_dive.txt` (real Game Player,
headless). Also in `t70_loading_rollout.txt`.

## What it is

You are an eagle over rolling wire hills and lakes. Fish swim just under the water (you see them through the
wire water) and now and then jump out in an arc. Fold your wings, dive, and skim the water through a fish to
catch it. Catch the place's number of fish before the sun sets (two minutes), then fly on.

| Keys | |
|---|---|
| Left Right, or A D | turn (the eagle banks) |
| Up or W | climb (slow, costs speed) |
| Down or S | nose down |
| Space, held | fold the wings and DIVE (fast); let go to pull up |
| Space after sunset | fly on to the next place (or try again) |
| Escape | pause (the Game Player's) |

- **Catching**: the talons hang half a metre under the eagle. Pass within 2.5 m of a fish that is swimming
  (0.8 m down) or jumping, and it is yours. Skimming the water over a fish is the sure way; a dive onto a
  jumping one is the pretty way ("A DIVING CATCH!").
- **Speed**: diving builds speed (up to 34 m/s); pulling up and climbing spend it; the wings bring you back
  to 14 m/s on the level. Touching the water slows you; a dive straight into it is a splash.
- **Hills** bump you up if you fly too low. Near the edge of the land the wind turns you back.
- **Places**: BLUE LAKE (one lake, 6 fish, catch 4), TWIN PONDS (two lakes, 7 fish, catch 5),
  THE BAY (a sea along one side and a pond, 8 fish, catch 6). Then round again with 20 s less daylight.

## How it's made (for an intermediate xTalk scripter)

The script is in numbered sections:

1. **The engine calls us**: `Game.OnStart` builds, `Game.OnUpdate` runs 30 times a second, `ED.StartLevel`
   is what the Game Player's level menu and the loading screen call; `ED.GoLevel` goes through the loading
   screen when it is loaded (`Loading.Go`), else straight to `ED.StartLevel`. `ED.Player()` tells the loading
   screen which object is the eagle. `on arrowKey` answers nothing, so arrows never turn the card.
2. **The places**: a place is a name, a list of lakes (`x,z,radius`), the number of fish and the goal.
3. **The land**: `ED.H(x, z)` is the height anywhere: three sine waves laid over each other, then each lake
   digs a bowl (`-4 + (h + 4) * d^4`, so the rim meets the hills). The water is at height 0: anything below
   is lake. The land is 25 tiles, ONE object each (every object costs the engine about 0.15 ms a frame,
   and tiles out of view are skipped). Each tile is a 5 x 5 net of points joined by lines that SHARE their
   points: the engine turns each point once a frame, so a net costs half what loose lines would.
4. **The water**: short dashes on level 0 wherever the land is under it, one object for all of it that drifts
   a little; a shore line found by walking out from each lake's middle until the land comes up.
5. **The eagle**: an array (`x y z yaw pitch bank speed`). `ED.Fly` turns the keys into where the nose wants
   to go, then gravity along the path (`-9.8 * sin(pitch)`), the wings pulling back to cruising speed, and a
   cost for pulling the nose up. `ED.DrawEagle` works out its dozen points every step (wings beating, or
   folded in a dive), turns them by bank, pitch and yaw itself, and defines the mesh again: one small mesh
   is cheaper than a turned object, and the engine turns objects about the world's axes, not the bird's.
6. **The fish**: each swims, turns at the shallows, jumps on a timer (`-0.8 + 3.6 * sin(pi * t)`), splashes
   in and out with `FX.Sparks`. `ED.Talons` checks the distance from the talons to each fish.
7. **Each step**: fly, swim, catch, the clock; at sunset Space goes on.
8. **The camera and the HUD**: behind and 3 m above the eagle, its turn following a little late, looking a
   few metres ahead. The HUD is set again only when its words change.
9. **Keys and test hooks**: `ED.TestKeys`, `ED.TestPlace`, `ED.TestFish`, `ED.TestFreeze`, `ED.State()`,
   `ED.Eagle()`: how a game is tested with no screen (see t76).
10. **A little wire**: `ED.Mesh`, `ED.Point`, `ED.Line` (metres, y up, into engine units, y down).

Headless: about 17 to 22 ms a frame (step and drawing) on both test engines.

## Ideas for later (not built)

- A nest on a hill to bring fish home to (more points the further you carry one).
- Wind gusts, other birds after the same fish, a bear on the shore.
- Dawn and dusk colours (the look presets).

## Notes

- 23 Nov 2026: first playable, branch `eagle-dive` (not yet seen on screen by the owner). Choice made for him:
  Up / W climbs (not the plane-stick way round); Space held dives.
