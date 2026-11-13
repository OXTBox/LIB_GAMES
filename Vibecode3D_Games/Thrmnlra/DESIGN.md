# GLRBAL THRMNLRA RWA (working title "Thrmnlra")

The owner's idea, read 2026-11-12. Original text: `~/projects/LIB_LLMOUT/LIB_GAMES/games_to_Make_input.txt` (read and acted on).

A typing war game. A terminal that types like a friend texting in a movie, and always spells
everything mostly wrong. A NORAD-style big board. Missiles you can only stop by typing.

## The idea, in order

1. **Login:** a black screen, monochrome text typed live: "GREETINGS, WOULD YOU LIKE TO
   PLAY A GAME?" YES / NO, and the answer is blasted into bits by 1983-arcade lasers.
   "HOW ABOUT GLRBAL THRMNLRA RWA? [O]KAY / [Q]UIPT": whatever you choose, it starts.
2. **The machine talks:** red alert, drones, "first strike response", sector AA]A8FA544895.
3. **The countdown:** "YOU HRVE 42153261 MINUTES" scrolling down to zero, with a tease
   upward first, typos throughout (Monkeys, mutants).
4. **The big board:** DEFCON 4 → 1, misspelled. LAUNCH MISSILES? YES / NO. As soon as a key
   goes down: LARNCHING MIZSILES... Black screen, the title, fade out.
5. **The map:** a vector world, red against blue. Green areas are the resource all life
   needs; harming it means extinction. It is mixed in among the combat systems, command
   centres and cult ritual sites.
6. **Play is typing.** STANDBY FOR FINAL ORDERS. Choose targets from a two-column list like
   an arcade high-score table (BITMON, HELIX, DELTA9ER, FOXTROZERO, 8O08S, SQUAREPANTS, LUKE,
   FRE3PISZA), in a console too small for the job, like an MMO chat window. Each name typed
   right lights a battery on your side, and the next word fires it. Each wrong letter makes
   someone launch a missile of unknown power. After a fail-safe point you must type a long,
   funny thing correctly, and every typo releases another MIRV payload from each child MIRV.
7. It goes on until nothing is left. "Strange game." Fade to black, back to GREETINGS.

**Look:** lines tracking across the screen; interceptions and countermeasures made from the
most basic symbols and lines. The world is a simple, subdued mesh grid. Borders, resources
and wasteland are overlay geometry cut to fit (the overlays are what's contested). The grid
turns vibrant when threatened, pulses at the last-minute red alert, then boom: particles.

## The owner's notes while playing the prototype (2026-11-12)

- "That first key is way too hard. Remember we should choose targets first." The recall key
  has moved out of the intro: you choose targets first, the first key is short (HALT), and
  only later do keys get long and change halfway.
- "Can put text labels at the target loc or in the terminal as list to choose from, by
  typing the name." Both are done: the list in the console, and each name at its site on
  the map.

- "Advance the game frame every keystroke to give the player a chance, and for them to sense
  that their mistyped key triggered the enemy alert, and launch on the second typo." The world
  clock can run by keystroke (Cue `Thrm.Clock mode=keys`, 0.3 s per key). Typos alternate:
  alert (the site flashes, ALERT tag), then launch from that site.
- "Dashes property for trails": trails are dashed screen-space lines (`kTrailDashes` 2,5,10,20).
- At "HOW ABOUT ...?" typing WHAT / HUH / WTF / HELP (trailing ? optional) goes to a boot-camp
  trainer: the sergeant's speech, "WHAT IS YOUR NAME, SOLDIER?", "DID YOU SAY <misspelled>?"
  YES/NO, "THAT'S WHAT I THOUGHT YOU SAID", then the player follows the drill words, and each
  misspelling shows its consequence on the map (and gets yelled at). Then on to the Map.
- "No numbers in the target list": they read as menu keys. Removed.

- "It stops taking input after a while": a stray key blocked YES/NO (fixed); recall keys had
  real-time timeouts (removed; default none); keys typed while nothing listens now show
  STAND BY; the sequencer keeps a key log (Seq.KeyLog()).
- "We should get first strike, the enemy caught off guard, the player given a guilt trip...
  a chance to stop the missiles before the enemy is alerted (when missiles cross midway)...
  MISSILES OUTBOUND: M123, M345, MZ98 - type asset name to recall or detonate (Missile
  Command)." Built: your armed batteries fire first ("FIRST STRIKE AWAY. THE ENEMY WAS
  ASLEEP."), each missile has an asset name riding beside it, flights are slow (8 s). Typing a
  name before any missile crosses midway RECALLS it; recall all -> Peace.seq ("NOBODY WILL EVER
  KNOW WHAT YOU ALMOST DID." ... "STRANGE GAME."). Once one crosses midway, or a typo wakes
  them: "ENEMY ALERTED. YOU DID THIS. NOW YOU HAVE TO SEE IT THROUGH." and they launch back;
  names then DETONATE in the air, destroying enemy missiles within kBlast (90 units). A
  missile that lands: "<SITE> IS GONE. THERE WERE PEOPLE THERE."

- Trainer: before the drill, "NEVER, UNDER ANY CIRCUMSTANCES, ARE YOU TO TYPE LAUNCH UNLESS GIVEN
  DIRECT ORDERS. DO I MAKE MYSELF CLEAR?" (either answer) "DAMN STRAIGHT. NOW TYPE WHAT I TELL
  YOU TO TYPE." Drill: AIM ARM LOCK TARGET CONFIRM, then "TYPE: LAUNCH" called like the rest:
  "a Simon says situation". No direct order was given, so don't: hold off 6 s and he
  approves; type it and one of your missiles really launches and the enemy is alerted. Then
  the missile screen. Typing LAUNCH any time before the drill skips the tutorial
  (Hotword clip, background) with the Sarge's disapproval.

- "The Sarge: a stick figure from wide angle and the MCP grid face for angry close-ups."
  WIDE: a giant stick figure at the back of the map in the TRON fists-on-hips idle (Amazing
  Couple's PROMPT idle, LIB_MOCAP Animazoo_hands_on_hips). CLOSE-UP: his own angry 48x26 grid
  face (Data/Faces: campaign hat, V brows, shouting mouth in two frames), built like the
  LIB_MCP face card, cut in on his big lines (Cue Thrm.CloseUp) and on every typo yell.
- "Make the game world larger; take the targeting text out of the console; the player is
  stuck looking DOWN... important updating stuff should stay toward the top to lift the
  head." The console is now 4 rows at the TOP (input line sticky at its bottom); the target
  names are only on the map; MISSILES OUTBOUND is a fixed line at the top of the map;
  titles flash mid-screen; the camera is closer so the world fills the screen.

## Built (prototype, 2026-11-12)

- `Data/Sequences/Intro.seq`: steps 1-4 (login, countdown, big board, launch, title).
- `Data/Sequences/Map.seq`: the map, targets (list + map labels), your batteries fire at
  them, the enemy answers, the easy key HALT, then a long key that changes halfway.
- `Data/Sequences/Trainer.seq`: boot camp (branch from the Intro).
- `Data/Sequences/Peace.seq`: the ending when every missile was recalled in time.
- Game clip kinds: `Countdown`, `Targets`, `RecallKey`, `Drill`, `Outbound`. The shared ones are in `../Sequencer/Clips`.

## Next

- The fail-safe and MIRV rule: a typo during a long key splits each warhead.
- "The next word fires that battery": per-battery words after targeting.
- Interceptions and countermeasures; nations, resources and wasteland as overlays; the
  extinction ending and "Strange game".
- Trails are entities and cost frame rate (about 15-20 FPS in a full salvo). One trail mesh
  per missile would be cheaper.
