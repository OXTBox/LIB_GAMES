<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_GUI.lua (model spark-x2.6-4b, 2026-11-12 14:38). DRAFT for Claude to review. -->

## UDG_GUI.lua
- **Kind:** library
- **Purpose:** This file defines the RTS_console global by assigning the first element of the gTextboxes table, providing a shared console output reference for the RTS_GUI script set. It contains no executable logic beyond this single assignment.
- **Depends on:** globals set elsewhere (gTextboxes), engine core calls (none)
- **Provides:** the RTS_console global
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - gTextboxes - A shared table of text boxes used by the game's UI system
  - RTS_console - A global console output reference for the RTS_GUI script set
- **Keep / port / drop:** keep - It is a small, stable reference for the console output global used by the RTS_GUI scripts.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the RTS_console global to the first element of the gTextboxes table.
- **Uses:** globals (gTextboxes), engine calls (none)
- **Reusable:** no
- **Procedural:** no
