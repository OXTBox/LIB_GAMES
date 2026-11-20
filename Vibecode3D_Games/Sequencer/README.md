# Sequencer: clips on a timeline for Vibecode3D games

A game's cutscenes, title screens, briefings and scripted moments are written as a
**sequence**: a cue sheet of **clips**, one per line, in a plain text file. A person (or
Spark, or Claude) can write and read it in plain words. Each line points at a clip
**kind**, a small `.livecodescript` file that does the drawing. A level plays a sequence
when it needs it, and the game card hears when it has ended.

First used by Thrmnlra (`../Thrmnlra/Data/Sequences/Intro.seq`, `Map.seq`).

## Words (taken from editing, film, theatre and games)

| Word | Means here | Where the word comes from |
|---|---|---|
| **Sequence** | one timeline, one `.seq` file (an intro, a briefing, an ending) | the timeline in Premiere and Resolve; Unreal's *Level Sequence* |
| **Clip** | one line: something that starts, runs for a while and ends | a clip on an editor's timeline |
| **Clip kind** | the code a clip runs: `Type`, `Ask`, `Title`... one `.livecodescript` each | Unity's *playable*, an effect in an editor |
| **Track** | a lane: `term` (typed screen), `board` (big text), `world` (the 3D map) | tracks in an editor |
| **Beat** | a line plus the `with` lines under it: things that happen together | a beat in screenwriting and storyboards |
| **Cue** | an instant event for the game itself (`Cue` clip: "standby... GO") | theatre cues, a stage manager's cue sheet |
| **Hold** | `hold=yes`: the clock stops until the player acts (answers, types the key) | a hold in theatre; what makes a game sequence interactive |
| **Fade / Cut** | `Fade` clip; `clear=yes` cuts to a clean screen | screenplay transitions: FADE OUT, CUT TO |

"Scene" is left alone on purpose: in this engine `Scene.*` already means the 3D objects
(`Scene.ClearAll`, `Scene.Register`).

## Where the files go

```
Vibecode3D_Games/
  Sequencer/sequencer.livecodescript   the player (behaviour of group "Sequencer" on a game card)
  Sequencer/Clips/<Kind>.livecodescript   shared kinds: Wait Type Ask Title Fade Cue Console
  <Game>/Data/Sequences/<Name>.seq     the game's sequences
  <Game>/Data/Clips/<Kind>.livecodescript   the game's own kinds (found first)
```

## A sequence file

```
when      | track | clip   | settings                              | what
0         | term  | Type   | text=>> GREETINGS...; cps=16; typos=0.05 | typed live, like a friend in a movie
+0.3      | term  | Ask    | options=YES,NO; var=play; blast=yes; hold=yes | the answer is shot into bits
+0        | world | Cue    | call=Thrm.World; mood=calm             | the big board
with      | board | Title  | items=DEFCON 4,DEFCON 3; every=0.9; id=defcon | counts down
with defcon +0.9 | world | Cue | call=Thrm.World; mood=alert     | the grid wakes up
```

- **when:** `0` / `12.5` / `1:05` are seconds on the sequence clock. `+0.5` means half a
  second after the beat above has ended. `with` / `with +0.9` means together with the line
  above (same beat), or a bit after it starts. `after <id> +1` and `with <id> +1` tie a
  line to another clip's `id=`.
- **track:** a lane, for reading now and for a visual timeline later.
- **clip:** the kind.
- **settings:** `key=value; key=value`. A bare word means `yes`. `id=` names the clip,
  and `hold=yes` stops the clock while it runs.
- **what:** the director's note, in plain words. The player ignores it.
- Settings can use sequence variables: `{name}` is a stored answer (`var=` of Ask or Input),
  and `{name:filter}` passes it through the card's `function Seq.Filter filter, value`.
  Thrmnlra's `garble` misspells it, always the same way.
- Any line can have `background=yes` (the sequence doesn't wait for it, and it is stopped
  when everything else is done) and `until=<id>` (it ends when clip `<id>` starts).
- A clip kind may also answer `Clip.Watch key`: it sees every key first, before the clip
  that takes it.
- A key that no clip takes shows STAND BY. `Seq.KeyLog()` lists the last 40 keys and which
  clip took each one. `Seq.Now()` says `name|Kind,Kind`: the sequence and the clips running
  (for tests).
- The card can jump too: `dispatch "Seq.Jump" to group "Sequencer" with "Strike"` (Thrmnlra
  does it when the launch codes fill up in the middle of a clip).
- `{@list:n}` puts in label n of a LIB_GENERICA list (the game's words: `{@game_events_text:1}`),
  once the game has loaded a set with `Gen.Load` (LIB_GENERICA: retheme by editing labels).
- Lines starting with `#` are comments, and the `when | track ...` header line is skipped.
  A `|` can't appear inside a setting.

## Shared clip kinds

| Kind | Settings |
|---|---|
| `Wait` | `dur` |
| `Console` | `x y w` (0..1 of the view), `rows`, `size`, `color`, `clear=yes`: where typed lines go |
| `Type` | `text`, `cps`, `typos` (slips that get backspaced), `linger`, `color`, `cursor=no` |
| `Ask` | `text`, `options=YES,NO`, `anykey=yes`, `var`, `blast=yes` (arcade lasers, letters fly apart), `words=WHAT,HUH` + `goto=<Sequence>`: a **branch** (typed in full, trailing `?` optional) |
| `Input` | `text`, `var`, `max`: free typing, ended by Return (a name) |
| `Hotword` | `words=LAUNCH`, `goto`, `say`, `clear=yes`, `var` (set to the word heard, so the next sequence knows): hears every key in the background (a shortcut or cheat word) and jumps. Use with `background=yes` and `until=<id>` |
| `Title` | `items` (one after another), `every`, `size`, `y`, `color`, `blink=yes`, `keep=yes`, `dur` |
| `Fade` | `dur`, `to`, `from`, `clear=yes` |
| `Cue` | `call=<card handler>` plus any settings (the handler gets them all as an array), `dur` |

## Writing a clip kind

A script-only stack named `Seq_Clip_<Kind>` (shared) or `<Game>_Clip_<Kind>` (game), with:

```
on Clip.Start pSet, pWhat    -- pSet = the settings array
on Clip.Step pT              -- seconds since it started; return "done" when finished
on Clip.Key pKey             -- a typed key ("return", "backspace" too); return "taken"
on Clip.Stop                 -- ended or skipped: leave the screen tidy
```

Each running clip is an invisible button inside the group "Sequencer", with the kind as
its **behaviour**. Its script locals are its own, and its calls go button → Sequencer →
card → engine. So a clip can call `Term.*`, `Seq.SetVar`, the game card's handlers
(`Thrm.Garble`) and the engine (`Entity.Spawn`). Tested 2026-11-12: a library loaded with
`start using` can't reach the engine, but a behaviour can.

## The terminal layer (`Term.*`, in the sequencer)

The engine HUD draws upper case only, in one colour. `Term` uses the same vector glyphs
plus `> < [ ] ? , ; ' " = _ % # * ( ) \`, in any colour, with fades and blasts:
`Term.Set id,text,x,y,size,color[,style]` (style words `bold`: each stroke twice, a pixel
apart; `wide`: letters spread by half a character; `Term.Width(text,size,style)`), `Term.Text`, `Term.Color`, `Term.Remove`, `Term.Clear`,
`Term.Print(text,color)` (console line, scrolls), `Term.Blast id`, `Term.SetFade`.

## On a game card

```
Thrm.Stage            -- makes group "Sequencer" (card-sized: a locked group clips its contents)
dispatch "Seq.Step" to group "Sequencer" with sStepMS / 1000      -- in Game.OnUpdate
on keyDown pKey  ->  dispatch "Seq.Key" to group "Sequencer" with pKey
on Seq.Ended pName   -- what comes next
```

See `Vibecode3D_Play_Thrmnlra.livecodescript`.

## Next

- A visual timeline (tracks as lanes, clips as bars) drawn from the same `.seq` file.
- Branches inside a sequence: jumping to `id=` markers (a jump to another sequence works: `Seq.Jump`).
- `Sequencer` as its own `LIB_` once a second game uses it.
