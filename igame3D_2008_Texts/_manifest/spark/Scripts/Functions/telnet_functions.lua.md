<!-- Spark first-look of Data/Scripts/Functions/telnet_functions.lua (model spark-x2.6-4b, 2026-11-12 15:50). DRAFT for Claude to review. -->

## telnet_functions.lua
- **Kind:** network
- **Purpose:** This file configures and runs the iGame3D test program's telnet server, then provides the `ig3d_chatserver` handler that manages connected chat clients, their name submissions, and chat messages over the server socket.
- **Depends on:** `gTelnetServer`, `gameroot`, `Data/Levels/default/default_Globals.lua` (loaded via `dofile`), `socket` (TCP socket methods), `gTelnetServer:settimeout`, `gTelnetServer:accept`, and globals `connections`, `numConnections`, `default_escapekey`, `escape_to` set elsewhere.
- **Provides:** `ig3d_chatserver` (chat server connection handler), plus the top-level setup logic that initializes the telnet server and connection tracking variables.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (the file only configures and runs existing server/socket code; no assets are generated from numbers or rules).
- **Glossary:**
  - `gTelnetServer` - the iGame3D global holding the telnet server object used for network communication.
  - `ig3d_chatserver` - the chat server connection handler function that processes connected chat clients.
  - `socket` - the TCP socket library used for the telnet server's bind, accept, and client communication methods.
  - `connections` - a global tracking variable for connected chat clients.
  - `numConnections` - a global tracking variable for the count of connected chat clients.
  - `default_escapekey` - a function used to handle escape key interactions for chat clients.
  - `escape_to` - a function used to route escape key interactions to a target.
- **Keep / port / drop:** keep - it is a working, reusable example of telnet server setup and chat client handling for the iGame3D test program.

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** Sets up the iGame3D test program's telnet server when `gTelnetServer` is nil, flushes the output, loads the default level globals, prints the socket version, configures the server host and port, binds the server, sets its timeout, and initializes connection tracking variables.
- **Uses:** `gTelnetServer`, `io.flush()`, `dofile(gameroot.."Data/Levels/default/default_Globals.lua")`, `socket._VERSION`, `socket.bind`, `socket.settimeout`, `gTelnetServer:settimeout`, `numConnections`, `connections`
- **Reusable:** no
- **Procedural:** no

## Part 2 of 2

### Top level
- **Does:** The file contains no setup, global definitions, or widget/settings code outside the `ig3d_chatserver` function.
- **Uses:** nothing
- **Reusable:** no

### ig3d_chatserver
- **Does:** Starts the chat server connection handler, manages connected chat clients, and processes their name submission and chat messages.
- **Uses:** `gTelnetServer`, `gTelnetServer:accept()`, `connections`, `numConnections`, `default_escapekey()`, `escape_to()`, TCP socket methods (`settimeout`, `send`, `receive`, `close`), `print`
- **Reusable:** no

### Top level
- **Does:** No additional top-level code beyond the function definitions listed above.
- **Uses:** nothing
- **Reusable:** no
