# Lantern and Ladders

New game, 23 Nov 2026 (bubble p1-31). Game: `../Vibecode3D_Play_LanternLadders.livecodescript` (prefix `LL.`).
Engine 1 (pure xTalk Vibecode3D, the Game Player); it uses only the engine contract plus one LiveCode
graphic above the view, the way the loading screen's veil does, so the xRay bench should play it too
(not seen there yet). Test: `OXT-BEYOND/tests/t76_lantern_ladders.txt` (24 checks, both headless engines).

## What it is

Shaft Descent upside down. You climb UP a dark tower by ladders and ledges. Your lantern lights only
the ground round you; the dark hides the gaps in the ledges, the bats and the stones that drop down
the shaft. The oil runs down (like Shaft Descent's air) and the light shrinks with it. Flasks of oil
on the ledges fill it (+15 s). The green door on the top ledge = the next tower. 5 towers, 3 lives;
a bat, a falling stone or an empty lamp sends you back to the bottom.

| Keys | |
|---|---|
| Left / Right (A D) | walk |
| Up / Down (W S) | climb a ladder (Up at its foot, Down at its top) |
| Shift (either) | run: 1.7x the speed, also on ladders; burns oil twice as fast |
| Space | jump (over the gaps; works a moment after stepping off an edge); Space + Left/Right jumps off a ladder |
| Escape | pause (Game Player) |

Ladders never stand straight above each other: every ledge is a walk in the dark, often over a gap.
A jump reaches 110 px; ledges are 130 apart, so ladders are the only way up.

## The torch (the trial)

One graphic `LL.Torch` over the whole view: a radial `fillGradient`, black at the edge, a faint warm
glow at the middle, clear round the player. Each frame its middle goes to the lantern's screen place
(`Camera.WorldToScreen`), its radius follows the oil (70..180 px) with a jitter of a few pixels, and
every third frame its `blendLevel` takes a random value 0..8 (the flicker). At most four property sets
a frame, none when nothing changed (about 0.7 ms a frame headless, the whole game step).
It sits just above the picture (the engine's line graphics, or the bench's image "view"), so the
Game Player's menu, labels and the loading screen stay above it. The words (oil, lives, level) are a
field `LL.Hud` above the torch, else the dark hides them. `Game.OnStop` removes both.

## Notes
- 23 Nov 2026: first playable (branch lantern-ladders). Not seen on screen yet: how dark is right, and
  whether the radial gradient's alpha looks the same on xRay, are the owner's call.
