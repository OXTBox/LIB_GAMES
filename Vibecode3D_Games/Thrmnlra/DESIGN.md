# GLRBAL THRMNLRA RWA (working title "Thrmnlra")

The owner's idea, read 2026-11-12. Original text: `~/projects/LIB_LLMOUT/Read/LIB_GAMES/games_to_Make_input.txt` (read and acted on).

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

## The redesign from the owner's notes of 13 Nov (built 19 Nov, branch thrmnlra-redesign)

His notes: `~/projects/LIB_LLMOUT/Read/LIB_GAMES/Game_Feedback_Thrmlnra.txt` ("Thrmnlra is
attacking the wrong sides?... Let's do it like this"). Each point, and what it became:

| His words | Now |
|---|---|
| attacking the wrong sides; targets on the right attack first while we type | OUR side is the LEFT, theirs the RIGHT, always. The old "choose 3 targets" list and first strike are gone: no one fires while you type the first round |
| player types "Launch"; Sarge: "Who told you to launch" | the Map opens with the Sarge's drill ARM, LOCK, then TYPE: LAUNCH (Simon says, no direct order). Type it: "WHO TOLD YOU TO LAUNCH?!". Typed LAUNCH in the Trainer already: straight to that line. Held off: the machine heard the Sarge call it and launches anyway ("LARNCH ORDER ACKNOWLEGDED") |
| "now look what you did!"; missiles into launch position just above their bases on the LEFT | `Thrm.Raise`: a missile rises over each of our 4 silos and waits there, its name beside it |
| Sarge: "Type: STOP RECALL ALL MISSILES!" | clip `Order`: typed letter for letter, spaces and ! too |
| "TYPE THE NAME OF THE ASSET TO RECALL" strobes three times Yellow, Orange, RED | `Thrm.Strobe` under the console, then it stays red; clip `Assets mode=recall` |
| TYPE: "RECALL THE BOMBERS!", each keypress advances toward first detonation | two bombers take off (`Thrm.Bombers`, small triangles) and move only by your keys: 34 keystrokes and they reach a city. Typed in time, they turn home |
| mistypes in the first round alert their silos, but they don't fire; all the player's fault | every typo of the round alerts one more enemy silo (ALERT blinks over it) and is counted |
| struck without being alert: that one-round disadvantage | a silo struck while asleep is gone; an alerted silo fires even if struck (it saw it coming) |
| TYPE: "STAND DOWN THE COMMAND" (if all the other goals were met without war); wakes OUR silos with each mistype | the last order of the Map; each typo wakes one of our silos (ARMED). Reached only while no war started. Typed: Peace.seq |
| "ENTER LAUNCH CODES: _ _ _ _ _ _ _ _" on the Big Board, upper middle, barely visible, brighter with every mistyped key, which fills it in whatever the key was | `Thrm.Codes` / `Thrm.CodeKey`: 8 letters, dark red at 14% growing to full red; every typo of the Map phases types its own key into it |
| Sarge turns around, sees the password: "What the hell have you done?" and the missiles go flying | full code: Strike.seq: he turns to the board (`Thrm.SargeTurn`), close-up, and every missile on a pad plus every woken silo flies left to right at their cities (none left: two from the command post) |
| STOP THE INCOMING MISSILES; TYPE THE NAME OF THE ENEMY ASSET TO DESTROY; [TAB] to cycle focus: bolder, brighter, AND advances the doom clock | `Assets mode=destroy`; Tab gives a name the focus (bold, wide, bright) and moves the clock two keys' worth |
| AFTER our attack strikes, THEN the enemies launch: more typos in round one, more of them; else a minimum of 3 nowhere near the struck targets | `Thrm.Counter` after our missiles land: one missile per first-round typo (3 to 10), from alerted silos, else the silos farthest from the craters, else submarines at the right edge |
| enemy missiles RIGHT TO LEFT; the keyboard only advances them | yes: clock by keys (0.25 s a key), 15+ s flights = about 60 keys |
| ITS WAR! YOU ARE TO LAUNCH YOUR MISSILE. TYPE LAUNCH, THAT IS A DIRECT ORDER; the keyboard misspells the input 2 times, never the same character; advancing enemy missiles at least two rounds | `Order sabotage=2`: two of your right keys show a wrong letter (two different positions, two different wrong letters); type it again and it takes. Each spoiled key is a round of 2 more enemy missiles (`Thrm.EnemyRound`). Then your one missile goes, you destroy the rounds, STRANGE GAME |
| advance the missiles slower | key step 0.3 -> 0.25 world s; their flights 15 s+; our strike 9 s |
| names: normal three or four letter words, jargon later | our missiles: OWL ELK FOX YAK EMU ANT BEE COW; theirs: SUN MUD FIG JAM ICE OAK RUG TEA PIE ZIP KEG HAT BOX CUP; cities 4 letters (LIMA OSLO BERN RIGA / ROME BAKU LYON NICE YORK). No word starts another |
| more room on the map; bases tiny, square, triangle, circle | camera higher (420/260), bases tiny: triangle = silo, square = command post, circle = city (meaning, value and risk read from them later) |
| the mesh of arcing lines... make it look global | the flat grid is now the top of a globe (`Thrm.GlobeMesh`): meridians bend toward the poles, the edges fall away; everything sits on that surface (`Thrm.Sag`) |
| explosions big, everything there goes BLACK after | a landing: 80 + 40 sparks; every base within 70 units is gone (no mesh), its name goes dark grey, a dim crater ring marks the place |
| city text hard to read: letter spacing half a character, bold | the Term layer got a style: `bold` (strokes doubled) and `wide` (half a character more a letter); city names and our missile names use both |
| targeting cities is what they did in the movie | our strike and their answer aim at cities first |

Choices I made where the notes left it open (change any):
- Holding off on LAUNCH still ends with the missiles raised (the machine heard the Sarge say it):
  the redesign starts from "player types Launch", and the codes trap needs the recall round.
- Peace is still possible: type everything with fewer than 8 typos (and the bombers home) and
  STAND DOWN ends it quietly. "Not enough to stop a war" is how it usually goes.
- The Trainer's drill lost its LAUNCH trap (it moved to the Map for everybody); its typos still
  show the old lesson on the map (first alerts a silo, second launches from it).
- The old clips Targets, Outbound and RecallKey are gone (in the history if wanted).
- Tab costs two keys' worth of clock.

## Built (prototype, 2026-11-12)

- `Data/Sequences/Intro.seq`: steps 1-4 (login, countdown, big board, launch, title).
- `Data/Sequences/Map.seq`: (12 Nov) targets, first strike, recall key; (19 Nov) replaced by the redesign above.
- `Data/Sequences/Strike.seq` (19 Nov): the war, after the codes fill up or a bomber gets through.
- `Data/Sequences/Trainer.seq`: boot camp (branch from the Intro).
- `Data/Sequences/Peace.seq`: the ending when every missile was recalled in time.
- Game clip kinds: `Countdown`, `Drill`, and since 19 Nov `Order`, `Assets`, `Flights` (`Targets`, `RecallKey`, `Outbound` retired). The shared ones are in `../Sequencer/Clips`.

## Next

- The fail-safe and MIRV rule: a typo during a long key splits each warhead.
- "The next word fires that battery": per-battery words after targeting.
- Interceptions and countermeasures; nations, resources and wasteland as overlays; the
  extinction ending and "Strange game".
- Trails are entities and cost frame rate (about 15-20 FPS in a full salvo). One trail mesh
  per missile would be cheaper.
