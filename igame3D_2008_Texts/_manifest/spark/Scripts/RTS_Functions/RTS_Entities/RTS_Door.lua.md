<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Entities/RTS_Door.lua (model spark-x2.6-4b, 2026-11-12 14:33). DRAFT for Claude to review. -->

## RTS_Door.lua
- **Kind:** library
- **Purpose:** This file builds a `doors` table by scanning all game objects for names containing `door`, then configures each matched door object with gravity, mass, cast shadow settings, and door-specific state flags. It is a reusable library module for adding doors to an iGame3D game.
- **Depends on:** `gObjects` global, `getObjectInfo`, `setObjectInfo`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_CAST_SHADOW`, `gDoShadows`, `computeShadowModelName`, `doorsTeam` globals; no `Data/` file paths read or written.
- **Provides:** the `doors` table containing configured door objects, built by scanning and configuring matched objects.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named).
- **Procedural:** none (the file scans existing objects and configures their properties; it does not generate assets from numbers or rules).
- **Glossary:**
  - `gObjects` - global table holding all game objects, used to scan for door objects.
  - `getObjectInfo` / `setObjectInfo` - engine calls used to read and set object properties such as position, rotation, and flags.
  - `IG3D_*` constants - engine constants naming the properties being read or set on objects (e.g. `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`).
  - `gDoShadows` - global controlling whether objects cast shadows.
  - `computeShadowModelName` - function used to compute the shadow model name for objects.
  - `doorsTeam` - global used to configure door-specific state flags.
- **Keep / port / drop:** keep - it is a reusable library module for configuring doors in iGame3D.

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Builds a `doors` table by scanning all objects for names containing `door`, then configures each matched door object with gravity, mass, cast shadow settings, and door-specific state flags.
- **Uses:** `gObjects`, `getObjectInfo`, `setObjectInfo`, `IG3D_NAME`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_MASS`, `IG3D_CAST_SHADOW`, `gDoShadows`, `computeShadowModelName`, `doorsTeam`, `gDoShadows` globals; no `Data/` file paths read or written.
- **Reusable:** no
- **Procedural:** no
