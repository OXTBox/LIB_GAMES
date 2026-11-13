# uDead: design notes

Friday, November 13, 2026. Written by Claude (Fable 5.2) while recreating the owner's
uDeadGame (iGame3D, uDevGames 2008, source in `iGame3d_To_Recreate/iGame3D_uDeadGame2009-master`,
not in git) as the Vibecode3D game card `Vibecode3D_Play_uDead.livecodescript`.

## 1. How the original plays (followed along its script path)

`Data/Levels/default/load script.lua` → `UDG_IntroCredits` → `UDG_MainMenu` → the levels. Each
level's `load script.lua` places its objects (the "auto-script" lists), loads
`Scripts/UDG_Functions/UDG_Init.lua`, sets `game_func = handle_udg` and defines
`udg_check_game_end_condition()`, which names the next level.

| Part | In the original | Where |
|---|---|---|
| You | an unseen box at eye height; mouse look, W A S D; the camera sits 0.65 m above it | `udg_handle_camera` (UDG_Game.lua) |
| Click | a ray from the crosshair. On a living person, door or window: the best-ranked zombie attacks it. On the ground or scenery: that zombie walks there | `udg_handle_target_click_selection` |
| Which zombie | the nearest, but one just picked counts 200 further (fading 100 a second) and one eating counts 5 further, so each click takes the next zombie | `pick_highest_ranked_zombie` |
| H / Space | all zombies hold | UDG_Keyboard.lua |
| F (or C) | all zombies follow you | same |
| R | rush: each zombie, after its own delay of 0 to 0.5 s, hunts the nearest living | `udg_delayed_rush`, `zombie_rush_behaviour` |
| Z | "zombie time": the scene runs at 0.1 speed | `bulletTimeKey` |
| J | cheat: the living drop dead | UDG_Keyboard.lua |
| The living | health 1. Asleep until they see a zombie (awake from the start on HARD levels). Then: with a gun they shoot and "seek and destroy"; with a pipe or baton they fight; unarmed they run to a safe place, or stand and cry | UDG_Init.lua, RTS_Behaviours.lua |
| Guns | handed out at the start: soldiers first, then police, then anyone. Pistol: 8 shots, a shot every 0.4 to 0.8 s. Rifle: 32 shots, every 0.1 s | UDG_Gun.lua |
| Grenades | soldiers carry 2 and throw at 3 to 10 m; everything within 2 m dies | UDG_Grenade.lua, `gunned_civilian_behaviour` |
| Snipers | people standing high: range 30 to 40 m, never move | `udg_sniper_humans` |
| Zombies | health 500 to 1000 | UDG_Zombie.lua |
| Dying | the living who die join team zombie and get up after a few seconds. A zombie shot down gets up again unless its death count is used up or it was a head shot | `handle_health` (RTS_AI.lua), `handle_UDGAI` |
| Doors, windows | doors have 60 health, windows 10; zombies break them | UDG_Door.lua, UDG_Window.lua |
| Winning | checked every 2.5 s: no living left → Space loads the next level; no zombies left → Space restarts | `handle_udg` |

Play order found by following each level's "next": LivingInn → PonchoCo → SnipersAlley →
Gauntlet → Village → Neighborhood → Arcade → Cargo → NeighborhoodTwo → VillageTwo →
GauntletTwo → SnipersAlleyTwo → PonchoCoTwo → LivingInnTwo → ArcadeTwo, then the same 15 with
`Hard` in the name. That is 30 levels (the read-me says 32).

## 2. What the vector game keeps, and what it changes

Kept: everything in the table above, with the same keys.

Changed:
- **Maps are generated** (the owner, 2026-11-13: "create new procedural maps ... the old maps can
  be legacy"). Level n is place ((n-1) mod 5) of the owner's five, round ((n-1) div 5):

  | Place | Map | Cast on round 1 |
  |---|---|---|
  | The highway hotel | a row of 8 rooms (door + window each), the office, trucks on the lot | 3 dead, 10 living, 2 pistols, 3 pipes |
  | The warehouse | one hall of shelving and crates, three offices, loading doors | 4 dead, 13 living, 4 pistols, 5 pipes |
  | The alley | a long narrow run past dumpsters, snipers behind windows on both sides, the office building at the end | 6 dead, 9 living + 5 snipers, 5 pistols, 2 police |
  | The container yard | containers in loose rows with lanes, a guard hut | 6 dead, 14 living, 3 soldiers (grenades), 2 police, 7 pistols, 2 rifles |
  | The arcade | rows of cabinets, a counter, three back rooms | 7 dead, 18 living, 5 pistols, 6 pipes, 2 police |

  Each round adds 1 zombie, 3 people, 2 pistols, 1 pipe (and a soldier and a rifle from the alley
  on). From round 3 the living are awake from the start (the original's HARD). A level number
  always gives the same map (its own random seed).
- **Legacy maps:** `tools/udg_to_udead.py` turns the 30 original levels into
  `udead_levels.txt` (the level mesh cut at body height into a 0.5 m grid; cast, doors, windows,
  weapon counts from the load scripts). `uDead.Legacy true` plays them. The flat grid has no
  stairs or roofs: people the dead could not reach are brought down to the nearest floor.
- **Finding the way:** the original runs A* per walker. One A* search on these maps costs about
  120 ms in xTalk, so everyone steers by shared distance maps instead (to the nearest living, to
  the nearest dead, to you, to each order's goal), each flooded a few milliseconds a step.
- **No rag dolls, sound, music or blood decals** yet. People are stick figures: green the dead,
  white unarmed, yellow with a pipe, orange / blue (police) / tan (soldiers) with guns, pink snipers.
- **Balance is mine, not the original's** (its bullet damage is in the C engine): pistol 185 a hit,
  rifle 95, sniper 450, pipes 160 to 280; the freshly dead have 250 to 500 health and one life.
  Tuned so that pressing R and waiting wins the hotel but loses the warehouse, yard and arcade.

## 3. Tested, and not

Tested without a window (`tools/headless_play.sh`, engine calls stubbed): every place generates;
ground clicks send different zombies; follow, hold, rush, zombie time; doors and windows break;
the killed get up as zombies; winning and losing; levels 1 to 5, 8, 9 and 14. The rules cost 1.5 to 3.5 ms
a step.

**Not tested: anything on screen.** The game has not yet run in the Vibecode3D window: how the
walls and figures look, frame rate with drawing, mouse look, whether the crosshair click feels
right, the HUD layout. Nobody has played it, so "is it fun?" is open.

## 4. Next

Play it and tune (speeds, damage, level sizes); sounds; a walk cycle from LIB_MOCAP for the
figures; the intro texts of the original as a Sequencer clip; the legacy maps on screen.
