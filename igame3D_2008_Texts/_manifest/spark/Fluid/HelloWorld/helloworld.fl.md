<!-- Spark first-look of Data/Fluid/HelloWorld/helloworld.fl (model spark-x2.6-4b, 2026-11-12 22:31). DRAFT for Claude to review. -->

## helloworld.fl
- **Kind:** ui-dialog
- **Purpose:** This file is a FLTK user interface designer source for the HelloWorld fluid UI, defining the window and group widgets used by the HelloWorld interface. It provides the window setup function and the window widget definition with its associated code block for the HelloWorld UI.
- **Depends on:** nothing
- **Provides:** `make_window` function and `awindow` widget with its associated code block for the HelloWorld FLTK UI.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:** FLTK window - a user interface window widget defined in the FLUID UI designer file; FLUID UI designer - the FLTK user interface designer that generates FLTK UI files; FLTK widget - a UI element such as a window or group defined with geometry and attributes in the FLUID file.
- **Keep / port / drop:** keep - it is a standard example UI file for the FLTK interface designer, useful as a reference for building new fluid UI files.

---

# Part notes

## Part 1 of 1

### make_window
- **Does:** Defines the `make_window` function that opens the FLTK window for the HelloWorld fluid UI file.
- **Uses:** `Fl_Window`, `Fl_Group` widget definitions with `xywh`, `label`, `open`, `type`, `visible`, `labelsize`, and `code`/`callback` blocks; `awindow` and `agroup` widget references.
- **Reusable:** no

### awindow
- **Does:** Defines the `awindow` widget, a FLTK window with a label and geometry, plus its associated code block that sets the label text and shows the window.
- **Uses:** `Fl_Window`, `label`, `xywh`, `open`, `type`, `visible`, `awindow:label`, `agroup:label`, `awindow:show`.
- **Reusable:** no

### Top level
- **Does:** Contains the file header metadata for the FLTK UI designer, the `make_window` function definition with its open block, and the `awindow` widget definition with its code block.
- **Uses:** `version`, `header_name`, `code_name`, `Function`, `code`, `callback` blocks, `Fl_Window`, `Fl_Group` widget attributes.
- **Reusable:** no
