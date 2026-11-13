<!-- Spark first-look of Data/Scripts/Functions/fltk_functions.lua (model spark-x2.6-4b, 2026-11-12 06:53). DRAFT for Claude to review. -->

## fltk_functions.lua
- **Kind:** ui-dialog
- **Purpose:** This file provides FLTK user interface helper functions and a global mouse coordinate assignment for the iGame3D engine. It handles window creation, event handling, and user confirmation flows using FLTK widgets and methods. The file supports the engine's FLTK-based dialog and window management needs.
- **Depends on:** FLTK event and window methods (`Fl:event_x()`, `Fl:event_y()`, `Fl:check()`, `Fl:event()`, `Fl:event_key()`, `fltk:Fl_Double_Window()`, `box()`, `callback()`, `show()`, `Fl:scheme()`, `Fl:run()`, `fltk.fl_choice()`, `window:hide()`, `io.flush()`, `print`), global table `event_constants`, and FLTK constants `fltk.FL_Escape`.
- **Provides:** Global mouse coordinate assignment; functions `wClose`, `fltk_event_status`, `flwait`, `quit_callback`, `newWindow`, `default_window_callback`.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or Data/ paths are named).
- **Procedural:** none
- **Glossary:**
  - FLTK - The user interface toolkit used by iGame3D for building dialogs and windows.
  - FL_Double_Window - A FLTK window type created by `fltk:Fl_Double_Window()` for displaying UI elements.
  - fltk_event_status - A helper that checks pending FLTK events and formats mouse/event details into text.
  - quit_callback - A callback that asks for user confirmation before hiding a window.
  - event_constants - A global table holding FLTK event type constants used by event handling functions.
- **Keep / port / drop:** keep - It contains reusable FLTK UI helper functions and callbacks that support the engine's window and event management.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Contains a global assignment for mouse coordinates read from FLTK event functions, outside any listed function.
- **Uses:** FLTK event functions `Fl:event_x()`, `Fl:event_y()`; no Data/ paths, engine calls or globals beyond these.
- **Reusable:** no

### wClose
- **Does:** Hides the given window and sets its reference to nil to release it.
- **Uses:** FLTK window method `hide()` on the passed window argument; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### fltk_event_status
- **Does:** Checks FLTK for pending events, reads current mouse coordinates and event type, builds formatted text strings for mouse position and event details, and returns the combined formatted text.
- **Uses:** FLTK methods `Fl:check()`, `Fl:event()`, `Fl:event_x()`, `Fl:event_y()`; global table `event_constants`; no engine calls, globals beyond these or Data/ paths.
- **Reusable:** yes

### flwait
- **Does:** Updates the FLTK interface state and ends the function.
- **Uses:** FLTK update method `fltk_update()`; no engine calls, globals or Data/ paths.
- **Reusable:** yes

### quit_callback
- **Does:** Asks the user a confirmation question via FLTK choice, and if the user confirms, hides the named window.
- **Uses:** FLTK choice method `fltk.fl_choice()`; FLTK window method `hide()` on the passed window name argument; no engine calls, globals beyond these or Data/ paths.
- **Reusable:** yes

### newWindow
- **Does:** Creates a FLTK double window with default size and scheme, applies default styling, attaches the quit callback, shows the window, runs the FLTK event loop, and returns the created window reference.
- **Uses:** FLTK window creation method `fltk:Fl_Double_Window()`, styling methods `box()`, `callback()`, `show()`, scheme method `Fl:scheme()`, event loop method `Fl:run()`; no engine calls, globals beyond these or Data/ paths.
- **Reusable:** yes

## Part 2 of 2

### default_window_callback
- **Does:** Handles the default window callback. If the event is 12 and the event key is the Escape key, it prints a message and flushes the output; otherwise it shows a confirmation choice dialog and hides the window if the user confirms.
- **Uses:** `fltk.fl_choice`, `window:hide()`, `io.flush()`, `print`, `Fl:event()`, `Fl:event_key()`, `fltk.FL_Escape`
- **Reusable:** no
- **Procedural:** no
