<!-- Spark folder manifest of Data/Fluid/3Dnetclient (model spark-x2.6-4b, 2026-11-12 19:11). DRAFT. -->

# Data/Fluid/3Dnetclient
- **Role:** This folder holds the FLTK user interface designer source for the 3DNetClient, a client that connects to a 3DNet server, runs the client-side game loop, gathers gameplay logic, and handles movement. It defines the client window, console text box, and the functions that drive the client connection and frame processing.
- **Entry point:** `3Dnetclient.fl`
- **Files:** `3Dnetclient.fl - FLTK user interface designer source for the 3DNetClient, defining the client window, console text box, and functions that drive the client connection and frame processing`
- **Shared with other folders:** Needs `Data/Levels/default/default_Globals.lua`, `Data/Scripts/Fly/iFly_math.lua`, and engine globals such as `gameroot`, `getSceneInfo`, `dofile`, `gObjects`, `gServerMode`, `sm_gameplay`, `sm_gathering`, `handle_gathering`, `handle_gameplay`, `connected`, `client`, `myID`, `game_func`, `toConsole`, `setSceneInfo`, `gSnapshotInterval`, `gNextFrameTime`, `gServerTimeStamp`, `lastFrame`, `buffers`, `curBuffer`, `gTestPing`, `gSpeed`, `cm_exit`, `cm_forward`, `cm_backward`, `cm_left`, `cm_right`, `cm_shoot`, `cm_mouse`, `cm_chat`, `cm_restart`, `cm_time`, `M_EPSILON`, `gNumFrames`, `gFrameHistorySize`, `srvr_exit`, `srvr_setObjectInfo`, `srvr_multiple`, `srvr_pos_and_rot`, `itemDel`, `getSceneInfo`, `IG3D_ROOT`, `IG3D_POSITION`, `IG3D_ROTATION`, `IG3D_COLOR`, `IG3D_SIZE`, `IG3D_TEXT`, `IG3D_ROOT`, `IG3D_RUN_IN_BACKGROUND`. Others take from it the client connection, frame processing, and movement handling logic provided by its functions.
- **Procedure candidates:** `handle_gathering`, `handle_gameplay`, `handle_server_message`, `handleMovementAndRotation`, `Client_loop`, `ig3d_doit`, `getObjectFrameForTime`, `getObjectFrameForTimeBestMatch`, `setupObjects`, `senddelayed`, `sendbufferedmessages`, `removeLines`, `toConsole`, `countLines`, `delitems`, `item`, `extractVectorFromString`, `sgn`, `copysign`, `quaternionFromMatrix`, `matrixFromQuaternion`, `slerp`, `quaternionMult` are functions that process client logic, frame handling, and math operations that could be produced by code rather than stored as files.
- **Glossary:**
  - `ig3d_object - an object kind used by engine make/get calls to create or query objects`
  - `IG3D_POSITION - engine constant naming the position property of an object`
  - `IG3D_TEXT - engine constant naming the text property of a text box`
  - `gServerMode - global setting that selects whether the client runs gathering or gameplay mode`
  - `sm_gameplay - server mode constant for gameplay mode`
  - `sm_gathering - server mode constant for gathering mode`
  - `handle_server_message - function that processes incoming server messages for object position and rotation updates`
  - `handle_gameplay - function that handles client input-driven movement and frame history updates`
- **Verdict:** keep - the core client logic and UI structure are reusable for other 3DNet clients, and the functions and globals it provides are central to client-side game loop and movement handling.
