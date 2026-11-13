<!-- Spark first-look of Data/Scripts/Functions/xpm_functions.lua (model spark-x2.6-4b, 2026-11-12 15:56). DRAFT for Claude to review. -->

## xpm_functions.lua
- **Kind:** converter
- **Purpose:** This file provides functions for generating, reading, saving, and displaying XPM image files, including header line construction, random XPM image creation, XPM image parsing, and FLTK-based XPM image display. It supports the XPM image handling used by the game's image pipeline.
- **Depends on:** `Data/` folder paths for XPM files; globals such as `gObjects`, `testWindow`, `xpm_box`, `xpm_file`, `xpm_data`, `DoitButton`, `init_XPMHeaderLines`, `XPMLines`, `XPMPixelData`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMColorCodes`, `XPMEndOfFile`, `XPMreadText`, `XPMReadColorLines`, `createpixelTable`, `colorsText`, `XPMPixelStrings`, `XPMCodesHexOffset`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMColorCodes`, `XPMCodesHexOffset`, `XPMLines`, `XPMEndOfFile`, `Q`, `SPC`, `cCommentsStart`, `cCommentsEnd`, `math.random`, `string.char`, `string.sub`, `string.len`, `string.find`, `io.open`, `io.close`, `loadstring`, `fltk:Fl_XPM_Image`, `fltk:Fl_Double_Window`, `fltk:Fl_Box`, `fltk:Fl_Button`, `lfs.dir`, `murgaLua.`; `Scripts/Functions` folder for the file's own location.
- **Provides:** `init_AquaXPMHeaderLines`, `init_XPMHeaderLines`, `init_RandomXPM`, `save_XPM`, `read_XPMImage`, `dorandomImage`, `doImage`; globals `XPMColorCodes`, `XPMLines`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMNumberOfImageColors`, `XPMCharsPerPixel`, `XPMPixelData`, `XPMCodesHexOffset`, `XPMreadText`, `XPMReadColorLines`, `cCommentsStart`, `cCommentsEnd`, `Q`, `SPC`, `XPMEndOfFile`, `aCol`, `aRow`, `colorsText`, `XPMPixelStrings`, `createpixelTable`.
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this file).
- **Procedural:** yes - generates random XPM image headers and pixel content via `math.random` and `string.char`/`string.sub`, and generates XPM image files from pixel data or random values instead of loading pre-existing asset files.
- **Glossary:**
  - XPM - XML Pixel Map format used for image files in this engine.
  - XPM header lines - fixed metadata lines describing image name, width, height, and color count for an XPM file.
  - XPM image - an image file in XPM format handled by the engine's image pipeline.
  - FLTK - the user interface framework used for dialogs and image display widgets in this engine.
  - XPM image object - a FLTK widget created from an XPM image file for display.
  - XPMPixelData - table holding parsed pixel data for an XPM image.
- **Keep / port / drop:** keep - reusable XPM generation, parsing, and display logic for new engine image handling.

---

# Part notes

## Part 1 of 3

### Top level
- **Does:** Defines the global constants and tables used by the XPM header line functions, including comment markers, quote and space strings, XPM file metadata values, color code table, and temporary XPM line storage variables.
- **Uses:** `math.randomseed(os.time())`, `XPMColorCodes`, `XPMLines`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMNumberOfImageColors`, `XPMCharsPerPixel`, `XPMPixelData`, `XPMCodesHexOffset`, `XPMreadText`, `XPMReadColorLines`, `cCommentsStart`, `cCommentsEnd`, `Q`, `SPC`, `XPMEndOfFile`, `aCol`, `aRow`.
- **Reusable:** yes - the constant and table definitions are reusable for XPM-related code.

### init_AquaXPMHeaderLines
- **Does:** Builds the header lines for the Aquarius XPM image, storing them in the XPMLines table with fixed line content for the XPM header, width/height/color count/chars per pixel metadata, color definitions, and pixel section marker.
- **Uses:** `cCommentsStart`, `cCommentsEnd`, `Q`, `SPC`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMColorCodes`, `XPMCodesHexOffset`, `XPMLines`.
- **Reusable:** yes - the header line generation logic is reusable for Aquarius XPM image headers.

### init_XPMHeaderLines
- **Does:** Builds the header lines for the XPM image, storing them in the XPMLines table with the same fixed header content as the Aquarius variant, but using the existing XPMReadColorLines value for the color definitions line instead of generating color entries.
- **Uses:** `cCommentsStart`, `cCommentsEnd`, `Q`, `SPC`, `XPMimageName`, `XPMImageWidth`, `XPMImageHeight`, `XPMColorCodes`, `XPMCodesHexOffset`, `XPMReadColorLines`, `XPMLines`.
- **Reusable:** yes - the header line generation logic is reusable for XPM image headers.

## Part 2 of 3

### Top level
- **Does:** No top-level code outside the three function definitions is present in this file.
- **Uses:** nothing
- **Reusable:** no

### init_RandomXPM
- **Does:** Generates a random XPM image header and pixel line content, then appends the XPM end-of-file marker to the internal XPMLines list.
- **Uses:** `init_XPMHeaderLines`, `math.random`, `string.char`, `string.sub`, `#XPMLines`, `XPMLines`, `XPMColorCodes`, `XPMEndOfFile`, `Q`
- **Reusable:** no

### save_XPM
- **Does:** Resolves the shortest file name from the given name by stripping path segments and extension, stores it as XPMimageName, then writes all accumulated XPMLines to the file at the given name.
- **Uses:** `string.len`, `string.sub`, `XPMimageName`, `XPMLines`, `io.open`, `io.close`
- **Reusable:** yes

### read_XPMImage
- **Does:** Reads an XPM file, extracts the color line and pixel string content, parses the pixel data into a local XPMPixelData table via a generated Lua expression, and returns the resulting XPMPixelData table.
- **Uses:** `io.open`, `f:read`, `string.find`, `string.sub`, `loadstring`, `colorsText`, `XPMreadText`, `XPMreadColorLines`, `XPMPixelStrings`, `createpixelTable`, `XPMPixelData`
- **Reusable:** yes

### dorandomImage
- **Does:** Generates a random XPM file name, saves a random XPM image to that file, loads the saved image into a FLTK XPM image object, assigns it to the xpm_box widget, and redraws the xpm_box and testWindow.
- **Uses:** `math.random`, `save_XPM`, `fltk:Fl_XPM_Image`, `xpm_file`, `xpm_data`, `xpm_box:image`, `xpm_box:redraw`, `testWindow:redraw`
- **Reusable:** no

## Part 3 of 3

### Top level
- **Does:** Defines the `doImage` function and its associated UI setup, writing an XPM image file and displaying it in a FLTK window.
- **Uses:** `read_XPMImage`, `string.sub`, `string.len`, `math.random`, `io.open`, `fltk:Fl_XPM_Image`, `fltk:Fl_Double_Window`, `fltk:Fl_Box`, `fltk:Fl_Button`, `testWindow`, `xpm_box`, `xpm_box_label`, `DoitButton`, `init_XPMHeaderLines`, `XPMLines`, `XPMPixelData`, `XPMPixelData`, `XPMImageWidth`, `XPMImageHeight`, `XPMimageName`, `xpm_file`, `xpm_data`
- **Reusable:** no

### doImage
- **Does:** Reads an XPM image, converts its pixel data into XPM format lines, writes the generated XPM file, loads it as a FLTK image, and displays it in a new FLTK window.
- **Uses:** `read_XPMImage("/aquapacman.xpm")`, `string.sub`, `string.len`, `math.random`, `io.open`, `fltk:Fl_XPM_Image`, `fltk:Fl_Double_Window`, `fltk:Fl_Box`, `fltk:Fl_Button`, `init_XPMHeaderLines`, `XPMLines`, `XPMPixelData`, `XPMImageWidth`, `XPMImageHeight`, `XPMimageName`, `xpm_file`, `xpm_data`, `xpm_box`, `testWindow`, `DoitButton`
- **Reusable:** no
- **Procedural:** yes
