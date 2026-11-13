<!-- Spark first-look of Data/Fluid/Mappers/DungeonMapperNaked.lua (model spark-x2.6-4b, 2026-11-13 00:32). DRAFT for Claude to review. -->

## DungeonMapperNaked.lua
- **Kind:** tool
- **Purpose:** This file builds the DungeonMapper window and its browser and menu sub-windows, starts the map timer, and runs the FLTK application to drive the dungeon mapping tool. It is a top-level script that wires together the FLTK UI components and engine functions needed for the tool's interface and runtime behavior.
- **Depends on:** `dofile(gameroot.."Data/Scripts/Functions/dungeon_functions.lua")`, `gLabelTable`, `gObjects`, `gameroot`
- **Provides:** none
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:** 
  - `fltk:Fl_Double_Window - FLTK double-height window widget used to build the tool's main interface`
  - `fltk:Fl_Browser - FLTK browser widget used for the tool's sub-window content`
  - `fltk:Fl_Menu_Bar - FLTK menu bar widget used for the tool's sub-window controls`
  - `murgaLua.createFltkTimer - host engine function used to start the map timer`
  - `Fl:run - FLTK application entry point that launches the built UI`
- **Keep / port / drop:** keep (core reference for building FLTK-based tool windows in this engine)

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds the DungeonMapper window and its browser/menu sub-windows, starts the map timer, and runs the FLTK application.
- **Uses:** `dofile(gameroot.."Data/Scripts/Functions/dungeon_functions.lua")`, `fltk:Fl_Double_Window`, `fltk:Fl_Scroll`, `fltk:Fl_Group`, `fltk:Fl_Browser`, `fltk:Fl_Menu_Bar`, `murgaLua.createFltkTimer`, `Fl:run()`, and the globals `gLabelTable`, `gObjects`, `gameroot` referenced by the code.
- **Reusable:** no
- **Procedural:** no
