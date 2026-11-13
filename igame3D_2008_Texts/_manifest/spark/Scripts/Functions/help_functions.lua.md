<!-- Spark first-look of Data/Scripts/Functions/help_functions.lua (model spark-x2.6-4b, 2026-11-12 06:54). DRAFT for Claude to review. -->

## help_functions.lua
- **Kind:** library
- **Purpose:** This file provides helper functions for generating and querying documentation tables for the iGame3D engine, including building reference and scripting help content and exposing a `getHelp`/`help` interface for retrieving help text. It reads predefined help files to construct reusable documentation structures and delegates help retrieval logic to a shared function.
- **Depends on:** `gameroot` global, `documentation` global (with `func`, `doc`, `vars`, `rtrns`, `found`, `outp` fields), `makeHelpTables()` function, `io.open` for reading help files, and the engine `print` call for output.
- **Provides:** `getHelp`, `help`, and the `makeHelpTables` function that builds documentation tables from help text files.
- **Assets it needs:** `gameroot.."Data/Help/reference.txt"`, `gameroot.."Data/Help/scripting.txt"` (read-only help text files).
- **Procedural:** none
- **Glossary:**
  - `documentation` - A global table storing structured help content for functions, variables, and reference data.
  - `getData` - A parameter passed to help functions that controls which type of help output is generated.
  - `tFilter` - A parameter passed to the `help` function that filters help content by type.
  - `makeHelpTables` - A function that reads help text files and builds documentation tables for engine functions.
- **Keep / port / drop:** keep - Serves as a reusable reference for building help documentation tables in new engine projects.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines empty tables for documentation metadata.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 2 of 3

### makeHelpTables
- **Does:** Reads the reference and scripting help text files, splits them into lines, and builds documentation tables for functions found in the text.
- **Uses:** Files `gameroot.."Data/Help/reference.txt"` and `gameroot.."Data/Help/scripting.txt"` (read-only via `io.open`), plus globals `gameroot`, `documentation` (with `func`, `doc`, `vars`, `rtrns` tables).
- **Reusable:** no - it depends on specific help file contents and the pre-existing `documentation` global structure.
- **Procedural:** no

## Part 3 of 3

### Top level
- **Does:** Defines the `getHelp` and `help` functions, invokes `makeHelpTables()`, and assigns `c` to `help`.
- **Uses:** Globals `documentation` (with `func`, `vars`, `doc`, `rtrns`, `found`, `outp` fields), engine calls `print` for output. No `Data/` paths or engine object calls.
- **Reusable:** no

### getHelp
- **Does:** Builds help documentation tables by filtering `documentation.func`, collecting matching function indices, and generating output entries based on the `getData` parameter.
- **Uses:** Globals `documentation` (fields `func`, `vars`, `doc`, `rtrns`, `found`, `outp`), engine call `print` for output. No `Data/` paths or engine object calls.
- **Reusable:** no

### help
- **Does:** Delegates all logic to `getHelp(tFilter, getData)` and returns its result.
- **Uses:** Engine call `getHelp` (same file's function). No `Data/` paths or engine object calls.
- **Reusable:** yes
- **Procedural:** no
