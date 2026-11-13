<!-- Spark folder manifest of Data/Scripts/LuaSocket (model spark-x2.6-4b, 2026-11-12 15:57). DRAFT. -->

# Data/Scripts/LuaSocket
- **Role:** This folder provides socket communication support for the iGame3D engine, built on the Lua 5.1 compatibility layer and the murgaLua host environment. It supplies the socket library and related utilities used by game scripts to exchange data over network sockets.
- **Entry point:** none
- **Files:** compat-5.1.lua - Lua 5.1 compatibility layer for the engine's Lua runtime; ltn12.lua - Lua 5.1 library type handler for the 12th (binary) socket type; mime.lua - MIME type handling for socket data; socket.lua - socket communication library for the engine.
- **Shared with other folders:** The folder depends on the engine's Lua runtime and murgaLua host environment for execution. Other game scripts take socket communication functions from this folder to connect to or exchange data with external systems.
- **Procedure candidates:** socket communication operations that are performed by the socket library code rather than stored as standalone files, such as opening, sending, and receiving socket data.
- **Glossary:**
  - LuaSocket: socket communication library provided in this folder for the engine.
  - compat-5.1.lua: compatibility code adapting the engine's Lua environment to Lua 5.1.
  - ltn12.lua: library type handler for binary socket data in Lua 5.1.
  - mime.lua: MIME type handling for socket data.
  - socket.lua: core socket communication library for the engine.
  - murgaLua: the host environment that runs the engine's Lua code.
  - Lua 5.1: the Lua version the engine scripts are written for.
- **Verdict:** keep
  Reason: The folder contains the core socket communication libraries required by the engine, with compatibility and MIME handling supporting the Lua 5.1 runtime. The code is directly reusable for new engine networking functionality without modification.
