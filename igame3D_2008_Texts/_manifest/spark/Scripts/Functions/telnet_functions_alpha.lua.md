<!-- Spark first-look of Data/Scripts/Functions/telnet_functions_alpha.lua (model spark-x2.6-4b, 2026-11-12 15:50). DRAFT for Claude to review. -->

## telnet_functions_alpha.lua
- **Kind:** network
- **Purpose:** This file provides shared setup values for the Telnet server and defines the `ig3d_telnetserver` function, which manages a socket-based Telnet connection server. It starts the server when not already initialized, accepts connections, tracks connected users, sends welcome messages, and relays messages between connected users. The included header comment notes that it uses a time out of 0.0, a poor approach that only works for testing until threads are available.
- **Depends on:** globals set elsewhere for server configuration (`connections`, `numConnections`, `gTelnetServers`, `host`, `port`, `ack`); no file loads or `Data/` paths are referenced in the provided code.
- **Provides:** the `ig3d_telnetserver` function, along with shared setup values for the Telnet server.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` assets are named in the provided code).
- **Procedural:** none
- **Glossary:**
  - socket-based Telnet connection server - a server that uses socket calls to accept and relay Telnet connections between users
  - `ig3d_telnetserver` - the function that manages the Telnet server lifecycle, connection tracking, and message relaying
  - time out of 0.0 - a timeout value of 0.0 used in the server setup, described in the header comment as a poor approach that only works for testing until threads exist
- **Keep / port / drop:** keep - it is a functional network server implementation that a new engine could reuse for socket-based connection management

## telnet_functions_alpha.lua
- **Kind:** network
- **Purpose:** This file supplies shared setup values for the Telnet server and defines the `ig3d_telnetserver` function, which manages a socket-based Telnet connection server. It starts the server if it is not already initialized, accepts connections, tracks connected users, sends welcome messages, and relays received messages between connected users. The header comment notes that it uses a time out of 0.0, a poor approach that works for testing until threads are available.
- **Depends on:** globals set elsewhere for server configuration (`connections`, `numConnections`, `gTelnetServers`, `host`, `port`, `ack`); no file loads or `Data/` paths are referenced in the provided code.
- **Provides:** the `ig3d_telnetserver` function, along with shared setup values for the Telnet server.
- **Assets it needs:** none (no models, images, sounds, emitters, fonts, or `Data/` assets are named in the provided code).
- **Procedural:** none
- **Glossary:**
  - socket-based Telnet connection server - a server using socket calls to accept and relay Telnet connections between users
  - `ig3d_telnetserver` - the function managing the Telnet server lifecycle, connection tracking, and message relaying
  - time out of 0.0 - a timeout value of 0.0 used in server setup, noted in the header comment as a poor approach that only works for testing until threads exist
- **Keep / port / drop:** keep - it is a functional network server implementation that could be reused for socket-based connection management in a new engine

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Defines shared setup values for the Telnet server and the `ig3d_telnetserver` function, which manages a socket-based Telnet connection server.
- **Uses:** `io.flush()`, `socket._VERSION`, `socket.bind`, `socket.accept`, `settimeout`, `send`, `receive`, globals `connections`, `numConnections`, `gTelnetServers`, `host`, `port`, `ack`
- **Reusable:** no

### ig3d_telnetserver
- **Does:** Starts the Telnet server if it has not been initialized, accepts connections, tracks connected users, sends welcome messages, and relays received messages between connected users.
- **Uses:** `io.flush()`, `socket._VERSION`, `socket.bind`, `socket.accept`, `settimeout`, `send`, `receive`, globals `connections`, `numConnections`, `gTelnetServers`, `host`, `port`, `ack`
- **Reusable:** no
- **Procedural:** no
