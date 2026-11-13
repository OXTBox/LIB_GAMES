<!-- Spark first-look of Data/Scripts/Functions/string_functions.lua (model spark-x2.6-4b, 2026-11-12 15:33). DRAFT for Claude to review. -->

## string_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable string, text, and table helper functions for working with text content, delimited strings, and formatted output in the iGame3D engine. It contains no setup or widget code, only standalone helper functions that support other scripts.
- **Depends on:** `Data/` folder paths used for file loading via `dofile` and `loadLevel`; globals such as `MaxLines` (set to 100) and `boxnumber` used by the `GLText` function; engine constants like `IG3D_TEXT` referenced in `GLText`.
- **Provides:** Global string helper functions including `getlinecount`, `getlineof`, `itemDel`, `numberofitems`, `item`, `fileNameFromPath`, `fileShortNameFromPath`, `listitems`, `deleteItems`, `unixpath`, `tableindex`, `tabletostring`, `numberoflines`, `removeLines`, `extractVectorFromString`, `extractWords`, `put`, `quoted`, `replaceText`, `hello`, `todaysdate`, `xzPoints`, `escapechars`, `es`, `commaSep`, `commaDelItems`, `getthe`, and `GLText`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or loaded).
- **Procedural:** generates text content from input strings, delimiters, and numeric values via string manipulation, line counting, and formatting rules (e.g., `getlinecount`, `getlineof`, `removeLines`, `tabletostring`, `extractVectorFromString`, `extractWords`, `hello`, `todaysdate`, `xzPoints`, `escapechars`, `commaSep`); no asset files are generated.
- **Glossary:**
  - `IG3D_TEXT - iGame3D constant naming the text property being read or set on objects.`
  - `getText_boxInfo - iGame3D call used to read text box configuration (text, lines, etc.).`
  - `setText_boxInfo - iGame3D call used to update text box configuration (text, lines, etc.).`
  - `MaxLines - global set to 100, the maximum allowed lines for text boxes.`
  - `dofile - iGame3D function used to load Lua code from a file path.`
  - `loadLevel - iGame3D function used to switch to a level folder.`
- **Keep / port / drop:** keep - reusable string and text helper functions that support other scripts in the engine.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Defines the global string helper constants used by the string functions below.
- **Uses:** nothing
- **Reusable:** yes

### getlinecount
- **Does:** Counts the number of lines in a string by appending a newline if missing, then counting the newline matches.
- **Uses:** nothing
- **Reusable:** yes

### getlineof
- **Does:** Returns the content of the n-th line of a string by appending a newline if missing, then extracting the substring before each newline match.
- **Uses:** nothing
- **Reusable:** yes

### itemDel
- **Does:** Returns the configured item delimiter, defaulting to a comma if no delimiter is provided.
- **Uses:** nothing
- **Reusable:** yes

### numberofitems
- **Does:** Counts the number of items in a delimited string using the given delimiter, defaulting to a comma.
- **Uses:** nothing
- **Reusable:** yes

### item
- **Does:** Returns the n-th item of a delimited string using the given delimiter, handling negative indices for the last item.
- **Uses:** nothing
- **Reusable:** yes

### fileNameFromPath
- **Does:** Returns the file name portion of a path by extracting the last item of the path using the slash delimiter.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 5

### fileShortNameFromPath
- **Does:** Extracts the short file name from a full file path by stripping the last five characters of the path segment after the final slash, returning "untitled" when the segment has no dot or is missing.
- **Uses:** nothing
- **Reusable:** yes
- **Reusable reason:** Pure string manipulation on file paths.

### listitems
- **Does:** Prints the string items of a given string split by a delimiter as a newline-separated list, returning an empty string if the item count cannot be determined.
- **Uses:** `numberofitems`, `item`
- **Reusable:** yes
- **Reusable reason:** Pure string and data processing function.

### deleteItems
- **Does:** Deletes the items between the start and end indices of a string split by a delimiter, returning the remaining items joined by the delimiter (empty string if no items remain).
- **Uses:** `numberofitems`, `item`
- **Reusable:** yes
- **Reusable reason:** Pure string and data processing function.

### unixpath
- **Does:** Replaces every space in a path string with a backslash-space pair to fix spaces in file paths using unix backslash separators.
- **Uses:** nothing
- **Reusable:** yes
- **Reusable reason:** Pure string manipulation function.

### tableindex
- **Does:** Prints the keys and values of a table as a formatted string, appending a delimiter between values when one is provided, and trimming the trailing delimiter if one was provided.
- **Uses:** nothing
- **Reusable:** yes
- **Reusable reason:** Pure table and string processing function.

## Part 3 of 5

### Top level
- **Does:** The file contains no setup, global definitions, or widget/settings code outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### tabletostring
- **Does:** Converts a table into a string by joining its key-value pairs with a delimiter, then strips the trailing delimiter. If no delimiter is provided, it defaults to a newline character.
- **Uses:** nothing
- **Reusable:** yes

### numberoflines
- **Does:** Counts the number of lines in a given string by scanning for newline characters.
- **Uses:** nothing
- **Reusable:** yes

### removeLines
- **Does:** Removes a specified line number from a text string, returning the text with that line removed. It appends a newline to the input first, counts total lines, and builds the output by skipping the target line while preserving the rest.
- **Uses:** nothing
- **Reusable:** yes

### extractVectorFromString
- **Does:** Splits a string containing comma-separated values into three components (x, y, z) and returns them as a tuple.
- **Uses:** nothing
- **Reusable:** yes

### extractWords
- **Does:** Extracts all consecutive word characters from a string into a table of words.
- **Uses:** nothing
- **Reusable:** yes

## Part 4 of 5

### Top level
- **Does:** No setup, globals, widget definitions, or other top-level code appears outside the function definitions in this file.
- **Uses:** nothing
- **Reusable:** no

### put
- **Does:** Executes a string loaded from a constructed subresult string, prints the result, and returns the result.
- **Uses:** `loadstring`, `print`
- **Reusable:** no

### quoted
- **Does:** Wraps the given string in double quotes and returns the quoted string.
- **Uses:** nothing
- **Reusable:** yes

### replaceText
- **Does:** Replaces the given text within the source string using string.gsub and returns the modified string.
- **Uses:** `string.gsub`
- **Reusable:** yes

### hello
- **Does:** Prints a greeting prefixed with the current date, defaulting the greeting to "Hello " if no argument is provided.
- **Uses:** `os.date`, `print`
- **Reusable:** yes

### todaysdate
- **Does:** Returns today's date formatted as MMDDYY using the specified date format and current time.
- **Uses:** `os.date`, `os.time`
- **Reusable:** yes

### xzPoints
- **Does:** Returns a string containing the X coordinate of the given point followed by ",0.0," and the Y coordinate.
- **Uses:** nothing
- **Reusable:** yes

### escapechars
- **Does:** Maps specific English escape keywords to their corresponding Lua escape characters, returning the keyword unchanged if none match.
- **Uses:** nothing
- **Reusable:** yes

### es
- **Does:** Delegates to escapechars with the given word and returns its mapped escape character or the original word.
- **Uses:** `escapechars`
- **Reusable:** yes

### commaSep
- **Does:** Formats the three given numeric values separated by commas into a single string, prints the result, and returns the formatted string.
- **Uses:** `string.format`, `print`
- **Reusable:** yes

### commaDelItems
- **Does:** Calls commaSep with the three given arguments and returns the resulting comma-separated string.
- **Uses:** `commaSep`
- **Reusable:** yes

### getthe
- **Does:** Constructs a string referencing the `the` table with the given name, loads it, and prints the contents of the referenced table.
- **Uses:** `loadstring`, `listitems`
- **Reusable:** no

## Part 5 of 5

### GLText
- **Does:** Sets the text of a text box by reading the current text, appending the new text, trimming to the maximum allowed lines, and updating the text box; also clears the text when the text is `"clear"`.
- **Uses:** `getText_boxInfo`, `setText_boxInfo`, `IG3D_TEXT`, `removeLines`, `countLines`, `MaxLines` (global set to 100), `boxnumber`, `text`
- **Reusable:** yes - pure text box configuration logic that can be reused for text management in new engines.
- **Procedural:** no
