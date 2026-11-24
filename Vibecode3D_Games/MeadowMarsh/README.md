# Meadow Marsh

First playable, 23 Nov 2026 (bubble p1-28). Game: `../Vibecode3D_Play_MeadowMarsh.livecodescript`
(Engine 1, Vibecode3D / iGame3D XT; it uses only the engine contract, so the xRay bench should play it too).
Test: `OXT-BEYOND/tests/t74_meadow_marsh.txt` (16 checks, real Game Player, headless).

## What it is

Dead Days' world (iGame3D XT buildings, props, figures, the wire helpers) moved out into open country,
played with uDead's orders. You walk a **banner**; your little party of adventurers gathers round it.
The camera stands above and behind the banner: you are the hand over the party, not one of them.

| Keys | |
|---|---|
| W A S D | walk the banner |
| Q E, Left Right | turn the view; Up Down: camera nearer / further |
| click a foe | the nearest free adventurer attacks it (click again: the next one) |
| click the ground, food, a jewel, a prisoner | the nearest free one goes there and stays |
| right click | the same order for EVERYONE |
| F / H / R | follow the banner / hold where you stand (was Space in uDead) / rush the nearest foe |
| Z, I, Space | slow time, help, go on after a place is won or lost |

- **Warrior**: sword up close; war cry (sound wave, 20 mana) pushes back everyone in front.
- **Bowman**: arrows (free, the physical attack); fire arrow (15 mana).
- **Caster**: staff up close; fire ball (20 mana, splash); lightning strike when mana is high (35).
- **Foes**: goblins, goblin archers, goblin shamans (plasma ball); in the marsh skeletons, skeleton
  archers and the bog witch (ball lightning). The archers and casters are uDead's armed soldiers,
  reborn as bowmen and casters with their own emitters.
- **Mana** comes back by itself. **Food** heals and makes it come back four times as fast for 20 s.
  A **jewel** fills it at once and gives 30 to everyone within 8 m. Foes sometimes drop either.
- **Prisoners** in the camps join the party when an adventurer reaches them (uDead's growing horde,
  the friendly way).
- Two places: THE MEADOW (village in a hollow, three goblin camps on rolling hills) and THE MARSH
  (low, water slows you, a ruin with the bog witch). Then round again, foes 30% tougher each round.

## How the spells get into a 3-D world

LIB_EMITTERS draws on a flat 2-D stage. Each spell gets its own stretch of that stage (a "slot",
10000 px wide); the game remembers where the slot stands in the world (caster's place, ground
height, direction to the target). Every step the library moves its effects, and the game stands
their lines up on the upright plane from caster to target (72 px = 1 m, as the duel's figures).
Twelve pooled objects draw them (core colour + glow colour). Damage is the game's own: it lands
when the missile would arrive (distance / the power's speed), so it works without the library too.

## The tutorial this script already is ("Make your own MMO/RPG", part 1)

The script is in numbered sections, each one lesson for an intermediate xTalk scripter:

1. The engine calls us (Game.OnStart / OnUpdate / OnClick, the loading screen's GoLevel)
2. Tools and spells (finding libraries, playing on without them)
3. Who is who: one table of kinds (change a number, the game changes)
4. The places (a level is a list of calls)
5. Rolling hills: a height function, flattened where a village stands; the ground as tiles
6. Making things (figures with gear, buildings, lean trees)
7. The people (one array for both sides)
8. Each step: orders, modes, follow-the-banner places, wake-the-camp AI
9. Fighting: reach, mana, choosing weapon / spell / big spell, splash, push
10. Spells on screen (the 2-D library in a 3-D world)
11. Food, jewels, prisoners
12. Orders by mouse (screen to hills, screen to foe)
13. Winning, the camera, the HUD
14. Keys and test hooks (how to test a game with no screen)

## Toward Guild Wars 2 / Champions Online (later, one rung at a time)

1. **Now**: one party, orders, mana, spells, two places.
2. Levels and experience per adventurer; pick a spell when one levels up (LIB_POWERBAR slots).
3. Map pieces: dungeon (LIB_BIT cellmaps / Lean style), castle, more villages; a world map of places.
4. Events in the open (GW2 style): a village attacked, everyone nearby helps, a reward for all.
5. Loot and gear with numbers; a vendor in the village.
6. Saving the party (Documents/My Games/Vibecode3D, as the loading screen's last.state).
7. Other players: two parties in one world over a socket (OXT-Beyond does sockets headless).

## Owner's first look (23 Nov, night): MERGED

"That's fun... a great prototype." Camera height okay, spells look good, hills work great, speed good.
Open (later, not now): spells don't always face the camera (they stand on the caster-target plane;
a billboard turn toward the camera would fix it). He will go through the game in depth later.
