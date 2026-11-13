<!-- Spark first-look of Data/Scripts/Functions/debug_functions.lua (model spark-x2.6-4b, 2026-11-12 06:38). DRAFT for Claude to review. -->

## debug_functions.lua
- **Kind:** library
- **Purpose:** This file provides generic debugging helpers for inspecting and printing the Lua call stack. It exposes two functions that use only host debug functions to capture and display stack information, making it useful for troubleshooting engine code. The helpers are designed to be reusable across different engine scripts without depending on specific game assets or engine-specific calls.
- **Depends on:** `debug.getinfo` (host debug library), `print` (built-in), `string.format` (built-in); no `dofile` loads, `Data/` paths, or globals set elsewhere.
- **Provides:** `d` (prints the active stack trace of the `print` function by capturing its debug info and iterating over the returned table), `traceback` (walks the Lua call stack using `debug.getinfo`, printing each frame as a C or Lua function with source file and line, then stops when no more frames are found).
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` assets are named or required).
- **Procedural:** none (no assets are generated from numbers or rules; it only inspects existing code execution state).
- **Glossary:**
  - stack trace - the sequence of Lua function calls that led to the current execution point, used to inspect execution flow.
  - debug info - host debug library data that describes the current execution context, including function and line details.
  - C function - a native compiled function in the host environment, distinct from Lua functions in the engine.
  - Lua function - a function defined inside Lua code in the engine, distinct from C functions.
- **Keep:** keep - it is a generic, reusable debugging helper using only host debug functions, useful as a reference for stack inspection in new engine code.

---

# Part notes

## Part 1 of 1

### d
- **Does:** Prints the active stack trace of the `print` function by capturing its debug info and iterating over the returned table.
- **Uses:** `print` (built-in), `debug.getinfo` (host debug library), no engine calls, globals, or `Data/` paths.
- **Reusable:** yes - it is a generic stack inspection helper using only host debug functions.

### traceback
- **Does:** Walks the Lua call stack using `debug.getinfo`, printing each frame as either a C function or a Lua function with its source file and current line, then stops when no more frames are found.
- **Uses:** `debug.getinfo` (host debug library), `print`, `string.format` (built-ins), no engine calls, globals, or `Data/` paths.
- **Reusable:** yes - it is a generic stack trace generator using only host debug functions.
