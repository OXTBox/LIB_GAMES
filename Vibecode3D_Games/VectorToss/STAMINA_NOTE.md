# Vector Toss: HANG TIME correction, Stamina (the owner's note, 17 Nov 2026)

Built 19 Nov 2026 night (Opus helper), waiting for the owner to try it. What was built and the choices made are at the end of this note.

- **Stamina** is a property of the characters (PROMPT, GLAZE) and **persists to other games**.
- A **meter** shows it only when it matters to the gameplay.
- **Total and maximum: 100.**

## In Vector Toss

| What | Stamina |
|---|---|
| Every 3 catches in a row without a miss | +1 |
| Running during a turn (throwing or catching the ball) | -1 per turn. Only two things count: `bIsItPlayersTurn` and `bDidTheyRun`. The time spent running, the distance and the number of key presses don't add to the loss. |
| A jump | -2 per jump |
| A throw | -1.0 to -2.0, in tenths, by the strength of the throw |
| Crawling out of a hole | -5 |
| Running AND missing the ball | -1 |

## Notes for whoever builds it

- The hang now plays Harold Lloyd's clip from "Safety Last!" (frames 134-198). The owner: "seems to work okay, could use better data, I'll keep looking."
- Stamina persists across games, so it belongs to the character, not to Vector Toss. Keep it where every PROMPT & GLAZE game can read and write it (decide where when it is built).

## Built 19 Nov 2026 (night): what it does and the choices made

The rules table above is built exactly, with the owner's names `bIsItPlayersTurn` and
`bDidTheyRun` (kept per hero in the game script).

**Where stamina lives.** One small shared library every PROMPT & GLAZE game can use:
`LIB_GAMES/Vibecode3D_Games/PromptGlaze/stamina.livecodescript` (`Stamina.Get`, `Stamina.Set`,
`Stamina.Add`, a line a hero). It saves to one plain text file in the Data folder, the same
place LIB_DATA uses for everything (TTRPG Studio does the same):
`Documents/Data/Games/PROMPT_GLAZE/stamina.txt` (a line a hero: `PROMPT <tab> 87.5`). You can
open it and change a number by hand. The game finds both libraries with `Game.FindFile`, the
same way it finds its animation list. If the library is missing, the game still runs and
stamina only lasts for that match.

**Who spends it.** Both heroes: the one you play and the companion. Stamina belongs to the
character, and the companion is still PROMPT or GLAZE.

**What a "turn" is.** A hero's turn starts when the partner throws (catching it) and ends
with the hero's own throw. Running at any point in that turn costs -1 once, at the throw.
Running while the partner has the ball is not your turn and costs nothing.

**Smaller choices.** "Catches in a row" are the hero's own catches; a drop by that hero starts
the count again (picking a ball up off the floor is not a catch). An easy one (E) counts as
the softest throw (-1.0). The companion's throws use their own strength (PROMPT 1.0 to 1.5,
GLAZE 1.0 to 1.25). Running and missing: the ball lands on your floor in your turn after you
ran (-1, and the turn's -1 still comes at your throw). Crawling out: only the hang's climb out
(-5); a fall with no hang left costs points as before, not stamina. Stamina stays between
0 and 100 in tenths; a hero never seen before starts at 100.

**The meter.** A line of text under each hero's FALLS line: `STAMINA #########- 96.5  -1.5 THROW`.
It shows for 3 seconds after the stamina changes (with what changed it) and then goes away.
Below 25 it stays up and says TIRED. (`kStaminaShowMS`, `kStaminaLow` at the top of the script.)

**What low stamina does: nothing yet** (the note does not say). A gentle idea for you to
decide: below 25 the hero runs a little slower (say 90%) and jumps a little lower, so the
meter means something without ever stopping play. And something will have to give stamina
back (rest, food, a night's sleep) in some game, or it only goes down over many games.

**Tests.** `VectorToss/stamina_test.txt` checks every rule, the meter, saving and carrying over
(30 checks, all pass headless on OXT-Beyond and LiveCode 9.6.3, with a throw-away stamina file).
The old Vector Toss test (OXT-BEYOND t21, with the renamed-handler file added) still passes 41/41.
Not tried in a real window yet. Note: running t21 headless now writes a stamina file in the
WSL home's Documents/Data (not your Windows Documents).
