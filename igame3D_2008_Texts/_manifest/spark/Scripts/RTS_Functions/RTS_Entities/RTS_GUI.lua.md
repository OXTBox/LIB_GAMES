<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_GUI.lua (model spark-x2.6-4b, 2026-11-12 14:34). DRAFT for Claude to review. -->

## RTS_GUI.lua
- **Kind:** library
- **Purpose:** This file configures the RTS_console global by assigning it to the first text box found in the gTextboxes collection. It provides a simple setup step for the RTS game's console UI.
- **Depends on:** Global `gTextboxes` (set elsewhere in the engine), global `RTS_console` (defined elsewhere in the engine).
- **Provides:** Global `RTS_console`, set to the first text box in `gTextboxes`.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `gTextboxes` - A global collection of text boxes used by the RTS UI.
  - `RTS_console` - A global variable holding the console text box for the RTS game.
- **Keep / port / drop:** keep
- **Reason:** It is a short, exact reference for how the RTS console text box is assigned, useful for reusing UI setup in a new engine.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the RTS_console global to the first text box in gTextboxes.
- **Uses:** Global `gTextboxes`, global `RTS_console`.
- **Reusable:** no
- **Procedural:** no
