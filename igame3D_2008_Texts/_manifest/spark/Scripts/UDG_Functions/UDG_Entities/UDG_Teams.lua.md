<!-- Spark first-look of Data/Scripts/UDG_Functions/UDG_Entities/UDG_Teams.lua (model spark-x2.6-4b, 2026-11-12 14:42). DRAFT for Claude to review. -->

## UDG_Teams.lua
- **Kind:** library
- **Purpose:** Defines global team identifiers that the UDG entities code uses to identify and manage teams within the game. The file serves as a shared configuration source for team-related entity logic, providing stable identifiers for team handling across the engine's UDG modules.
- **Depends on:** globals set elsewhere in the Scripts/UDG_Functions/UDG_Entities folder (no explicit `dofile` or `Data/` path loads are shown in this file).
- **Provides:** global team identifiers used by the UDG entities code.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or other named assets are referenced).
- **Procedural:** none
- **Glossary:**
  - team identifier - a global name used to identify a specific team in the game's entity system.
  - UDG entities - the set of game objects and logic organized under the UDG_Functions/UDG_Entities folder.
- **Keep / port / drop:** keep - it provides shared team identifiers needed by the UDG entities code for consistent team handling.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines global team identifiers used by the UDG entities code.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no
