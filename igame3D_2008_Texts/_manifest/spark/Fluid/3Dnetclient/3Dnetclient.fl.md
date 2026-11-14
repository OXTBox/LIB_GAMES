<!-- Spark first-look of Data/Fluid/3Dnetclient/3Dnetclient.fl (model spark-x2.6-4b, 2026-11-12 19:11). DRAFT for Claude to review. -->

## 3Dnetclient.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK user interface designer source for the 3DNetClient, a client that connects to a 3DNet server and runs the client-side game loop, gathering or gameplay logic, and movement handling. It defines the client window, console text box, and the functions that drive the client connection and frame processing.
- **Depends on:** `Data/Levels/default/default_Globals.lua`, `Data/Scripts/Fly/iFly_math.lua`, engine globals (`gameroot`, `getSceneInfo`, `dofile`, `gObjects`, `gServerMode`, `sm_gameplay`, `sm_gathering`, `handle_gathering`, `handle_gameplay`, `connected`, `client`, `myID`, `game_func`, `toConsole`, `setSceneInfo`, `gSnapshotInterval`, `gNextFrameTime`, `gServerTimeStamp`, `lastFrame`, `buffers`, `curBuffer`, `gTestPing`, `gSpeed`, `cm_exit`, `cm_forward`, `cm_backward`, `cm_left`, `cm_right`, `cm_shoot`, `cm_mouse`, `cm_chat`, `cm_restart`, `cm_time`, `M_EPSILON`, `gNumFrames`, `gFrameHistorySize`, `srvr_exit`, `srvr_setObjectInfo`, `srvr_multiple`, `srvr_pos_and_rot`, `itemDel`, `getSceneInfo`, `IG3D_ROOT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_COLOR`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_ROOT`, `IG3D_RUN_IN_BACKGROUND`
- **Provides:** `make_window`, `senddelayed`, `sendbufferedmessages`, `removeLines`, `toConsole`, `countLines`, `delitems`, `item`, `setupObjects`, `extractVectorFromString`, `handle_gathering`, `getObjectFrameForTime`, `getObjectFrameForTimeBestMatch`, `handleMovementAndRotation`, `handle_server_message`, `sgn`, `copysign`, `quaternionFromMatrix`, `matrixFromQuaternion`, `slerp`, `quaternionMult`, `handle_gameplay`, `client_Text_box`, `ig3d_doit`, `3DNetClient`, `Client_loop`
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - `ig3d_object - an object kind used by engine make/get calls to create or query objects`
  - `IG3D_POSITION - engine constant naming the position property of an object`
  - `IG3D_TEXT - engine constant naming the text property of a text box`
  - `gServerMode - global setting that selects whether the client runs gathering or gameplay mode`
  - `sm_gameplay - server mode constant for gameplay mode`
  - `sm_gathering - server mode constant for gathering mode`
  - `handle_server_message - function that processes incoming server messages for object position and rotation updates`
  - `handle_gameplay - function that handles client input-driven movement and frame history updates`
- **Keep / port / drop:** keep - core client logic and UI structure that can be reused for other 3DNet clients

---

# Part notes

## Part 1 of 11

### Top level
- **Does:** Contains the file header and the `make_window` function body, which loads the default level globals and sets up the client UI function block.
- **Uses:** `gameroot`, `getSceneInfo(IG3D_ROOT)`, `dofile`, `Data/` path `Data/Levels/default/default_Globals.lua`, `--client_Functions` comment block.
- **Reusable:** no

### make_window
- **Does:** Defines the window creation function, which retrieves the scene root and loads the default level globals file to initialize the client.
- **Uses:** `gameroot=getSceneInfo(IG3D_ROOT)`, `dofile(gameroot.."Data/Levels/default/default_Globals.lua")`, `Data/` path `Data/Levels/default/default_Globals.lua`.
- **Reusable:** no

### senddelayed
- **Does:** Queues a delayed message by storing its timestamp and text in a buffer slot, then advances the current buffer index.
- **Uses:** `buffers`, `curBuffer`, `time()`, `gTestPing`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

### sendbufferedmessages
- **Does:** Iterates over the 64 message buffer slots, sends buffered text when its timestamp has passed, and clears the slot after sending.
- **Uses:** `buffers`, `curBuffer`, `time()`, `client:send`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

### removeLines
- **Does:** Removes trailing newline characters from the end of a text string by repeatedly stripping the last line segment.
- **Uses:** `string.sub`, `string.find`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

### toConsole
- **Does:** Appends text to the console text box, then trims trailing lines beyond the maximum allowed console line count.
- **Uses:** `getText_boxInfo(console, IG3D_TEXT)`, `setText_boxInfo(console, IG3D_TEXT, ...)`, `removeLines`, `countLines`, `gMaxLines`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

### countLines
- **Does:** Counts the number of newline characters in a text string by scanning for `\n` occurrences.
- **Uses:** `string.find`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

### delitems
- **Does:** Removes the first `n` occurrences of the `itemDel` marker from the start of a text string, returning the trimmed result or an empty string if the marker is missing.
- **Uses:** `itemDel`, `string.find`, `string.sub`, `Data/` path `Data/Levels/default/default_Globals.lua` (via loaded globals).
- **Reusable:** yes

## Part 2 of 11

### Top level
- **Does:** Contains no top-level code outside the four listed functions; the file consists solely of the function definitions shown.
- **Uses:** nothing
- **Reusable:** no

### item
- **Does:** Strips repeated occurrences of the delimiter `itemDel` from the input text, returning the text with all instances removed. If the count `n` is less than 1, it returns the input unchanged.
- **Uses:** nothing
- **Reusable:** yes

### setupObjects
- **Does:** Reads the object count from the first item of the input text, then iterates over each object, creating an `ig3d_object` named `avatarp1` for each, and populates per-object fields including position, collision, rotation, and animation state from the remaining text. It records the index of the object matching `myID` as `myObj`.
- **Uses:** `make(ig3d_object, "avatarp1")`, `setObjectInfo(obj, IG3D_POSITION, ...)`, `setObjectInfo(obj, IG3D_COLL, false)`, `getObjectInfo(obj, IG3D_POSITION)`, `getObjectInfo(obj, IG3D_ROTATION)`, `gObjects`, `myID`, `gNumObjects`, `time()`, `delitems`, `item`
- **Reusable:** no

### extractVectorFromString
- **Does:** Splits a comma-separated string into three components (x, y, z) using the first two commas as separators, returning the three substrings.
- **Uses:** nothing
- **Reusable:** yes

### handle_gathering
- **Does:** Receives a message from the client, logs it to the console if present, and when the message contains `SETUP` runs `setupObjects` on the remainder of the message and sets `gServerMode` to `sm_gameplay`. If the message is absent and the error code is `closed`, it logs that the server closed the connection.
- **Uses:** `client:receive()`, `toConsole`, `string.find`, `setupObjects`, `gServerMode`, `sm_gameplay`
- **Reusable:** no

## Part 3 of 11

### getObjectFrameForTime
- **Does:** Walks an object's frame history from the current frame backward, returning the first frame whose stamp matches the given time, or nil if none matches.
- **Uses:** gObjects (via gObjects[idx].curFrame), tostring, nil comparison
- **Reusable:** yes
- **Procedural:** no

### getObjectFrameForTimeBestMatch
- **Does:** Walks an object's frame history backward, returning the first frame whose stamp is at or before the given time and has no future frame, or the first frame whose future frame is at or after the given time, or nil if none matches.
- **Uses:** gObjects (via gObjects[idx].curFrame), tonumber, nil comparison
- **Reusable:** yes
- **Procedural:** no

### handleMovementAndRotation
- **Does:** Applies linear and angular velocity over a time parameter to a frame, updating position and quaternion components, then returns the updated position and quaternion values.
- **Uses:** frm, math.cos, math.sin, quaternionMult, 180/math.pi
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 11

### Top level
- **Does:** Contains no top-level code outside the `handle_server_message` function; the file’s only defined function is `handle_server_message`.
- **Uses:** nothing
- **Reusable:** no

### handle_server_message
- **Does:** Handles server messages by processing position/rotation updates for objects, recursively handling nested server commands, and applying movement and rotation corrections to object frames.
- **Uses:** `gServerTimeStamp`, `gObjects`, `item`, `delitems`, `tonumber`, `getObjectInfo`, `setObjectInfo`, `getObjectFrameForTimeBestMatch`, `toConsole`, `time`, `srvr_pos_and_rot`, `srvr_multiple`, `handleMovementAndRotation`, `quaternionFromMatrix`, `matrixFromQuaternion`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_ROTATION_MATRIX`, `getObjectFrameForTimeBestMatch`, `handle_server_message` (recursive call)
- **Reusable:** yes
- **Procedural:** no

## Part 5 of 11

### Top level
- **Does:** Contains no setup, globals, widget definitions, or other top-level code outside the three listed functions.
- **Uses:** nothing
- **Reusable:** no

### sgn
- **Does:** Returns 1 when the input value is greater than or equal to 0, otherwise returns -1.
- **Uses:** nothing
- **Reusable:** yes

### copysign
- **Does:** Multiplies the absolute value of the first argument by the sign returned by sgn of the second argument.
- **Uses:** sgn
- **Reusable:** yes

### quaternionFromMatrix
- **Does:** Computes the four components of a unit quaternion from the 16 elements of a 4x4 matrix, applying sign adjustments based on specific matrix elements, and returns the four quaternion components.
- **Uses:** math.max, math.sqrt, copysign
- **Reusable:** yes

### matrixFromQuaternion
- **Does:** Computes the 9 elements of a 3x3 matrix from the four components of a unit quaternion, returning the elements in row-major order, and includes a comment noting it returns a 3x3 matrix from a given unit quaternion.
- **Uses:** nothing
- **Reusable:** yes

## Part 6 of 11

### slerp
- **Does:** Interpolates between two 3D points using spherical linear interpolation, returning the interpolated point coordinates. It first normalizes the dot product of the two direction vectors, flips the quaternion if the dot product is negative, and returns the quaternion directly when the dot product is very close to 1.
- **Uses:** nothing
- **Reusable:** yes - pure math interpolation

### quaternionMult
- **Does:** Multiplies a quaternion by a 3D vector, returning the resulting 3D vector coordinates. It computes the four resulting components using the standard quaternion-vector multiplication formula.
- **Uses:** nothing
- **Reusable:** yes - pure math transformation

### Top level
- **Does:** Contains no setup, globals, widget definitions, or other top-level code outside the two function definitions.
- **Uses:** nothing
- **Reusable:** no

## Part 7 of 11

### handle_gameplay
- **Does:** Updates object positions and rotation for the current frame, then handles keyboard input to move the player forward, backward, left, and sends delayed commands to the server.
- **Uses:** Engine calls `getObjectInfo`, `setObjectInfo`, `quaternionFromMatrix`, `quaternionMult`, `matrixFromQuaternion`; globals `gObjects`, `gNumObjects`, `lastFrame`, `time`, `key`, `client`, `senddelayed`, `cm_time`, `cm_forward`, `cm_backward`, `cm_left`, `gSpeed`, `myObj`; constants `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_OMEGA`, `IG3D_VELOCITY`; math functions `math.pi`; no `Data/` paths.
- **Reusable:** yes - core movement and input handling logic that can be adapted to other game clients.
- **Procedural:** no

## Part 8 of 11

### Top level
- **Does:** Handles input-driven movement and frame history updates, then receives and processes server messages when a frame is created.
- **Uses:** `key`, `gObjects`, `myObj`, `gSpeed`, `senddelayed`, `time`, `client`, `createFrame`, `gNumObjects`, `getObjectInfo`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `IG3D_ROTATION`, `gFrameHistorySize`, `handle_server_message`, `lfs`-related globals not shown here.
- **Reusable:** no
- **Procedural:** no

## Part 9 of 11

### Top level
- **Does:** Ends a section of the file by sending previously saved messages.
- **Uses:** nothing
- **Reusable:** no
- **Procedural:** no

## Part 10 of 11

### Top level
- **Does:** Sets up the client init state, creates the console text box, configures the socket and camera, and defines shared mode constants.
- **Uses:** `make`, `setText_boxInfo`, `setCameraInfo`, `socket.tcp`, `settimeout`, `client_Text_box`, `gObjects`, `host`, `port`, `connected`, `gServerMode`, `sm_gathering`, `sm_gameplay`, `handle_gathering`, `handle_gameplay`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_COLOR`, `IG3D_SIZE`, `IG3D_TEXT`, `consoleWindow`
- **Reusable:** no

### client_Text_box
- **Does:** Creates a text box with a default font image, sets its position, color, size and text content, and limits the number of lines it can display.
- **Uses:** `make`, `setText_boxInfo`, `IG3D_POSITION`, `IG3D_COLOR`, `IG3D_SIZE`, `IG3D_TEXT`, `gMaxLines`, `host`
- **Reusable:** yes

### ig3d_doit
- **Does:** Checks whether the client is connected, then routes to the gathering or gameplay handler based on the current server mode.
- **Uses:** `connected`, `gServerMode`, `sm_gathering`, `handle_gathering`, `handle_gameplay`
- **Reusable:** no

## Part 11 of 11

### Top level
- **Does:** Defines the 3DNetClient FLTK window with its label and geometry, and contains the client loop code block that runs after the window is created.
- **Uses:** `Fl_Window`, `Fl_Button`, `code`, `callback`, `dofile`, `getSceneInfo`, `IG3D_ROOT`, `Data/Scripts/Fly/iFly_math.lua`, engine globals (`connected`, `client`, `myID`, `game_func`, `toConsole`, `setSceneInfo`, `gSnapshotInterval`, `gNextFrameTime`, `gServerTimeStamp`, `lastFrame`, `buffers`, `curBuffer`, `gTestPing`, `gSpeed`, `cm_exit`, `cm_forward`, `cm_backward`, `cm_left`, `cm_right`, `cm_shoot`, `cm_mouse`, `cm_chat`, `cm_restart`, `cm_time`, `M_EPSILON`, `gNumFrames`, `gFrameHistorySize`, `srvr_exit`, `srvr_setObjectInfo`, `srvr_multiple`, `srvr_pos_and_rot`, `itemDel`).
- **Reusable:** no
- **Procedural:** no

### 3DNetClient
- **Does:** Creates the 3DNetClient FLTK window with a "3D Net Client" label, an open/selected state, and a Double-type widget with fixed xywh geometry.
- **Uses:** `Fl_Window`, `label`, `open`, `selected`, `xywh`, `type`, `visible`.
- **Reusable:** no

### Client_loop
- **Does:** Executes the client connection and game loop logic: connects to the server, receives server data, sets up client timeout and sends a time message, logs connection status, configures scene info and frame tracking variables, and loads the iFly_math script.
- **Uses:** `client:connect`, `client:receive`, `client:settimeout`, `client:send`, `time`, `string.sub`, `string.find`, `tonumber`, `toConsole`, `setSceneInfo`, `IG3D_RUN_IN_BACKGROUND`, `dofile`, `getSceneInfo`, `IG3D_ROOT`, `Data/Scripts/Fly/iFly_math.lua`, engine globals (`connected`, `game_func`, `myID`, `gSnapshotInterval`, `gNextFrameTime`, `gServerTimeStamp`, `lastFrame`, `buffers`, `curBuffer`, `gTestPing`, `gSpeed`, `cm_exit`, `cm_forward`, `cm_backward`, `cm_left`, `cm_right`, `cm_shoot`, `cm_mouse`, `cm_chat`, `cm_restart`, `cm_time`, `M_EPSILON`, `gNumFrames`, `gFrameHistorySize`, `srvr_exit`, `srvr_setObjectInfo`, `srvr_multiple`, `srvr_pos_and_rot`, `itemDel`).
- **Reusable:** no
- **Procedural:** no
