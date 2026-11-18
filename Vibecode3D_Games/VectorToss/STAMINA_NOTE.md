# Vector Toss: HANG TIME correction, Stamina (the owner's note, 17 Nov 2026)

Not built yet: the owner said "no changes right now". Pick this up when Vector Toss work resumes.

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
