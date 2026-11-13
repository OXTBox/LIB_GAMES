<!-- Spark folder manifest of Data/Scripts/LuaSocket/socket (model spark-x2.6-4b, 2026-11-12 14:32). DRAFT. -->

# Data/Scripts/LuaSocket/socket
- **Role:** This folder provides socket-related networking utilities for the iGame3D engine, built on the LuaSocket library and organized into separate modules for different protocol types.
- **Entry point:** none
- **Files:** ftp.lua - FTP protocol socket module, http.lua - HTTP protocol socket module, smtp.lua - SMTP protocol socket module, tp.lua - TCP protocol socket module, url.lua - URL protocol socket module
- **Shared with other folders:** Needs the engine's Data folder path setup and shared globals (such as gObjects) for path construction and global state access; other folders use these socket modules for network communication tasks.
- **Procedure candidates:** The socket modules contain code that performs network connection, protocol handling, and data transfer operations directly, so these networking procedures are already implemented in the code rather than stored as standalone files.
- **Glossary:** socket - A network communication interface used for client-server data exchange; ftp.lua - Module implementing FTP protocol socket functionality; http.lua - Module implementing HTTP protocol socket functionality; smtp.lua - Module implementing SMTP protocol socket functionality; tp.lua - Module implementing TCP protocol socket functionality; url.lua - Module implementing URL protocol socket functionality
- **Verdict:** keep - The folder contains complete, self-contained networking modules for the engine's socket needs, with no missing dependencies or redundant content that would hinder reuse in a new engine.
