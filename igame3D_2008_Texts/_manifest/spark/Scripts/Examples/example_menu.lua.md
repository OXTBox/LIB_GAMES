<!-- Spark first-look of Data/Scripts/Examples/example_menu.lua (model spark-x2.6-4b, 2026-11-12 15:06). DRAFT for Claude to review. -->

## example_menu.lua
- **Kind:** test/example
- **Purpose:** This file is a menu example that defines a callback function and builds a FLTK window, menu bar, and menu items with shortcuts, then displays the window to demonstrate menu interaction.
- **Depends on:** `fltk` user interface library, `menu_callback` function defined in the same file, FLTK widget objects created within the file.
- **Provides:** `menu_callback` function, which prints the text of a given FLTK widget and flushes the output stream.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none
- **Glossary:** FLTK - user interface library providing window, menu bar, and widget components; FL_MENU_TOGGLE - FLTK constant used to set menu bar toggle behavior; menu_callback - callback function that handles menu interaction by printing widget text and flushing output.
- **Keep / port / drop:** keep - serves as a reusable reference example of building a FLTK menu with shortcuts.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines the `menu_callback` function and creates the FLTK window, menu bar, and menu items with shortcuts, then shows the window.
- **Uses:** `fltk:Fl_Double_Window`, `fltk:Fl_Menu_Bar`, `fltk.FL_CTRL`, `fltk.FL_ALT`, `fltk.FL_MENU_TOGGLE`, `string.byte`, `io.flush`, `menuBar:callback`, `menuBar:add`, `menuBar:shortcut`, `menuBar:mode`, `menuBar:global`, `window:show`, `menu_callback`
- **Reusable:** yes
- **Procedural:** no

### menu_callback
- **Does:** Prints the text of the given FLTK widget and flushes the output stream.
- **Uses:** `w:text()`, `io.flush`
- **Reusable:** yes
- **Procedural:** no
