<!-- Spark first-look of Data/Fluid/3Dnetserver/3Dnetserver.fl (model spark-x2.6-4b, 2026-11-12 19:15). DRAFT for Claude to review. -->

## 3Dnetserver.fl
- **Kind:** ui-dialog
- **Purpose:** This file is the FLTK UI definition for the iGame3D 3Dnetserver, providing the window, gathering and gameplay handlers, server message handling, and the Start Server button wiring. It serves as the user interface layer for the 3Dnetserver game server, including connection, message, and game mode logic.
- **Depends on:** `gameroot` (from `getSceneInfo(IG3D_ROOT)`), `Data/Levels/default/default_Globals.lua` (loaded via `dofile`), engine calls `getSceneInfo`, `setText_boxInfo`, `setCameraInfo`, `setSceneInfo`, `make`, `getObjectInfo`, `setObjectInfo`, `loadLevel`, `get`, `sendall`, `sendallwithtime`, `sendbufferedmessages`, `setupObjects`, `default_escapekey`, `escape_to`, `handle_gathering`, `handle_gameplay`, `handle_client_message`, `server:accept`, `tcpsocket:send`, `gObjects`, `gParticleEmitters`, `gSoundEmitters`, `gGroups`, `gTextboxes`, `gloggedIn`, `gNumOBjects`, `gServerMode`, `sm_gameplay`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `numplayers`, `players`, `gMaxLines`, `gTestPing`, `gSpeed`, `gNextTime`, `gSnapshotInterval`, `gServerMode`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `Data/FontPngs/default32_1.png`, `sm_gathering`, `sm_gameplay`, message type lists `cm_exit` through `cm_time`, `srvr_exit` through `srvr_pos_and_rot`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `Data/` (engine path construction pattern), `gloggedIn`, `gNumOBjects`, `setupObjects`, `item`, `delitems`, `tonumber`, `make`, `setObjectInfo`, `players`, `IG3D_POSITION`, `setupObjects`, `tmp`, `players`, `numplayers`, `tcpsocket:send`, `t`, `players`, `numplayers`, `time()`, `gTestPing`, `players[j].client_time`, `players[j].server_time`, `players[j].buffers`, `players[j].curBuffer`, `players[j].tcpsocket`, `players`, `numplayers`, `time()`, `players[j].buffers`, `players[j].tcpsocket`, `getObjectInfo`, `setObjectInfo`, `output`, `item`, `passed`, `quaternionFromMatrix`, `quaternionMult`, `matrixFromQuaternion`, `time`, `sendallwithtime`, `sendbufferedmessages`, `gloggedIn`, `gObjects`, `gNumObjects`, `gNextTime`, `gSnapshotInterval`, `numplayers`, `players`, `srvr_multiple`, `srvr_pos_and_rot`, `default_escapekey`, `handle_gathering`, `handle_gameplay`, `escape_to`, `gServerMode`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`, `gServerMode`, `

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 8

### make_window
- **Does:** Opens the window for the 3Dnetserver FLTK UI, setting up the shared engine data and UI state.
- **Uses:** `gameroot=getSceneInfo(IG3D_ROOT)`, `dofile(gameroot.."Data/Levels/default/default_Globals.lua")`, globals `gObjects`, `gParticleEmitters`, `gSoundEmitters`, `gGroups`, `gTextboxes`, `gloggedIn`.
- **Reusable:** no
- **Procedural:** no

## Part 2 of 8

### Top level
- **Does:** Contains no setup, global declarations, or widget definitions outside the `handle_gathering` function; the only top-level content is the function definition itself.
- **Uses:** nothing
- **Reusable:** no

### handle_gathering
- **Does:** Handles player connection and disconnection, processes client text input, sends messages to all connected players, and starts the game by sending setup data to clients when the "n" button is clicked.
- **Uses:** `server:accept()`, `numplayers`, `players`, `toConsole`, `sendall`, `click`, `gloggedIn`, `gNumOBjects`, `setupObjects`, `gServerMode`, `sm_gameplay`, `time`, `item`, `gloggedIn`
- **Reusable:** no
- **Procedural:** no

## Part 3 of 8

### Top level
- **Does:** Contains no top-level setup, globals or widget definitions beyond the function definitions shown; the file continues from earlier parts of the 8-part set.
- **Uses:** nothing
- **Reusable:** no

### handle_client_message
- **Does:** Parses a client message to update player timing, movement direction and turn direction, and restarts the server level when the restart command is received.
- **Uses:** `players`, `item`, `delitems`, `tonumber`, `time`, `beep`, `numplayers`, `loadLevel`, `getObjectInfo`, `IG3D_POSITION`, `gSpeed`, `cm_time`, `cm_restart`, `cm_forward`, `cm_backward`, `cm_left`, `cm_right`, `mode`, `mess`, `pindex`, `text`
- **Reusable:** no

### sendall
- **Does:** Sends a message to every non-nil player socket in the server.
- **Uses:** `players`, `numplayers`, `tcpsocket:send`, `t`
- **Reusable:** yes

Note: The code includes a trailing `code {--3_Server_Send ...}` block with comments and a `function sendall(t)` definition; the top-level section covers the file-level context, and no additional top-level code beyond the function definitions is present.

## Part 4 of 8

### Top level
- **Does:** Contains the file-level code block for part 4 of 8, tagged as `--4_Server_Game`, with no top-level setup, globals, or widget definitions outside the two functions.
- **Uses:** nothing
- **Reusable:** no

### sendallwithtime
- **Does:** Iterates over all players, and for each player whose client time is not -1, computes a time offset `t` from the player's client time and server time plus the current engine time, then stores a buffered message with a computed timestamp and text in the player's buffer array, cycling the buffer index.
- **Uses:** `players`, `numplayers`, `time()`, `gTestPing`, `players[j].client_time`, `players[j].server_time`, `players[j].buffers`, `players[j].curBuffer`, `players[j].tcpsocket`
- **Reusable:** no

### sendbufferedmessages
- **Does:** Iterates over all players, then over each of the 64 buffer slots, and for each non-nil buffer sends its stored timestamped message over the player's TCP socket when the current engine time reaches the buffer's first timestamp, then clears the buffer slot.
- **Uses:** `players`, `numplayers`, `time()`, `players[j].buffers`, `players[j].tcpsocket`
- **Reusable:** no

## Part 5 of 8

### Top level
- **Does:** Contains no top-level setup, globals or widget definitions outside the `handle_gameplay` function; the only top-level content is the function definition and its body.
- **Uses:** nothing
- **Reusable:** no

### handle_gameplay
- **Does:** Runs game object movement and network traffic handling, then sends repeated position updates to the server.
- **Uses:** Engine calls `getObjectInfo`, `setObjectInfo`, `output`, `item`, `passed`, `quaternionFromMatrix`, `quaternionMult`, `matrixFromQuaternion`, `time`, `sendallwithtime`, `sendbufferedmessages`; globals `gloggedIn`, `gObjects`, `gNumObjects`, `gNextTime`, `gSnapshotInterval`, `numplayers`, `players`, `srvr_multiple`, `srvr_pos_and_rot`; file/path references `Data/` via the engine's path construction pattern.
- **Reusable:** no
- **Procedural:** no

## Part 6 of 8

### setupObjects
- **Does:** Reads the object count from the first item of the input table, then loops that many times to create one object per entry, storing each object in `gObjects` and linking it to the matching player entry.
- **Uses:** `item`, `delitems`, `tonumber`, `make`, `setObjectInfo`, `gNumObjects`, `gObjects`, `players`, `IG3D_POSITION`, `setupObjects` (function), `tmp` (input table)
- **Reusable:** no
- **Procedural:** yes

### Top level
- **Does:** Contains the trailing closing brace for `setupObjects` and the start of the FLUID file's code block for the `6_Server_Game_Loop` section.
- **Uses:** `setupObjects` (function), `code` (FLUID code block)

## Part 7 of 8

### Top level
- **Does:** Defines the shared setup for the Fly server part, including server mode constants, connection parameters, console text box, player tracking variables, camera and scene settings, message type lists, and the `game_func` assignment.
- **Uses:** Engine calls `make`, `setText_boxInfo`, `setCameraInfo`, `setSceneInfo`; globals `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`; file path `Data/FontPngs/default32_1.png`; constants `sm_gathering`, `sm_gameplay`, message type lists `cm_exit` through `cm_time`, `srvr_exit` through `srvr_pos_and_rot`.
- **Reusable:** yes - the server setup, message type definitions and UI console configuration are reusable for similar server scripts.

### ig3d_FlyServer
- **Does:** Runs the Fly server main logic each time it is called, handling gathering mode or gameplay mode, processing escape input, and delegating to the appropriate server mode handler.
- **Uses:** Engine calls `default_escapekey`, `handle_gathering`, `handle_gameplay`, `escape_to`; globals `gServerMode`.
- **Reusable:** no - this is the core server logic for the specific Fly game, tied to its mode handlers and input handling.

### ig3d_FlyServer (setup)
- **Does:** Configures the server connection, console text box, player tracking state, camera and scene settings, and message type lists used by the Fly server.
- **Uses:** Engine calls `make`, `setText_boxInfo`, `setCameraInfo`, `setSceneInfo`; globals `gServerMode`, `gMaxLines`, `gObjects`, `gSpeed`, `gNextTime`, `gTestPing`, `gSnapshotInterval`; file path `Data/FontPngs/default32_1.png`; constants `sm_gathering`, `sm_gameplay`, message type lists `cm_exit` through `cm_time`, `srvr_exit` through `srvr_pos_and_rot`.
- **Reusable:** yes - the server configuration, message type definitions and UI setup are reusable for similar server scripts.

## Part 8 of 8

### Top level
- **Does:** Defines the FLTK window `3DNetServer` with a label and a `Start Server` button, and assigns the button's callback to `serverstart`.
- **Uses:** `Fl_Window`, `Fl_Button`, `callback`, `xywh`, `label`, `selected`, `visible` (FLTK UI definitions in this file).
- **Reusable:** no

### 3DNetServer
- **Does:** Serves as the entry point for the 3D Net Server UI, wiring the `Start Server` button to the `serverstart` callback.
- **Uses:** `Fl_Window`, `Fl_Button`, `callback`, `xywh`, `label`, `selected`, `visible` (FLTK UI definitions in this file).
- **Reusable:** no
