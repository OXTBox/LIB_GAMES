<!-- Spark first-look of Data/Scripts/core.lua (model spark-x2.6-4b, 2026-11-12 18:22). DRAFT for Claude to review. -->

## core.lua
- **Kind:** engine-core
- **Purpose:** This file provides the foundational global state, constants, and core object/camera/light management functions for the iGame3D Lua engine. It defines shared engine constants, initialises collision-related globals, and contains reusable helpers for visual object updates, creation, and idle/collision dispatch.
- **Depends on:** `Data/` folder paths for scripts and socket libraries; globals set elsewhere such as `game_func`, `coll_o_m`, `coll_o_o`, `coll_o_p`, `coll_p_p`, `coll_p_m`, `gObjects`, `gNumObjects`, `gNativeOS`, `camera`, `edit_func`, `murgaLua`; `Data/Scripts/LuaSocket/` folder for socket library files.
- **Provides:** Global state and constants (object/light counters, material structure, camera defaults, entity type and attribute constants, IG3D property identifiers, engine/FLUID constants); functions `updateFromVisualCamera`, `updateToVisualCamera`, `go`, `go_humanoid`, `updateToVisualObject`, `updateFromVisualObject`, `printObjectData`, `create`, `updateFromAllVisualObjects`, `updateAllVisualObjects`, `getObjectByItsID`, `game_idle`, `edit_idle`, `coll_obj_obj`, `coll_obj_mesh`, `coll_obj_prtcl`, `coll_prtcl_prtcl`, `coll_prtcl_mesh`, `fltk_update`, `luasocket_init`, and the `Fl:run` method; global `gNativeOS` set from `murgaLua.getHostOsName()`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named in this file).
- **Procedural:** none
- **Glossary:**
  - `IG3D_*` - Engine property and constant identifiers used to read or set object, camera, and light properties.
  - `ig3d_object` - The kind of object used for visual object creation and management.
  - `gObjects` - Global list of registered visual objects.
  - `gNumObjects` - Global counter for the number of registered visual objects.
  - `gNativeOS` - Global holding the host operating system name.
  - `game_func` - Global function called when the game idle is triggered.
  - `edit_func` - Global function called when the edit idle is triggered.
  - `coll_o_m` / `coll_o_o` / `coll_o_p` / `coll_p_p` / `coll_p_m` - Global collision dispatch functions for object and particle interactions.
- **Keep / port / drop:** keep - core engine reference and reusable object management helpers.

---

# Part notes

## Part 1 of 6

### Top level
- **Does:** Defines the core global state and constants for the iGame3D engine, including object and light counters/arrays, material structure, camera defaults, entity type and attribute constants.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 2 of 6

### Top level
- **Does:** Defines a fixed set of IG3D property and constant identifiers used throughout the engine's scripts.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 3 of 6

### Top level
- **Does:** Defines engine and FLUID constant values, then initialises several collision-related globals that the game must define.
- **Uses:** Nothing from the engine, globals `game_func`, `coll_o_m`, `coll_o_o`, `coll_o_p`, `coll_p_p`, `coll_p_m` (written as `nil`).
- **Reusable:** no
- **Procedural:** no

## Part 4 of 6

### Top level
- **Does:** No top-level code outside the defined functions; the file contains only the listed function definitions.
- **Uses:** nothing
- **Reusable:** no

### updateFromVisualCamera
- **Does:** Reads the current camera position and rotation from the visual camera into Lua variables.
- **Uses:** `getCameraInfo(IG3D_POSITION)`, `getCameraInfo(IG3D_ROTATION)`, globals `camera`
- **Reusable:** yes

### updateToVisualCamera
- **Does:** Writes the Lua camera variables back to the visual camera as position and rotation.
- **Uses:** `setCameraInfo(IG3D_POSITION, camera.x, camera.y, camera.z)`, `setCameraInfo(IG3D_ROTATION, camera.xang, camera.yang, camera.zang)`, globals `camera`
- **Reusable:** yes

### go
- **Does:** Applies a displacement based on the object's rotation matrix to set the object's impulse, moving the object in the direction of its rotation.
- **Uses:** `getObjectInfo(cObj, IG3D_ROTATION_MATRIX)`, `setObjectInfo(cObj, IG3D_IMPULSE, ...)`, globals `IG3D_*` constants
- **Reusable:** yes

### go_humanoid
- **Does:** Applies a displacement to the object's velocity, preserving the existing velocity component along the rotation axis while adjusting the other two velocity components.
- **Uses:** `getObjectInfo(cObj, IG3D_ROTATION_MATRIX)`, `getObjectInfo(cObj, IG3D_VELOCITY)`, `setObjectInfo(cObj, IG3D_VELOCITY, ...)`, globals `IG3D_*` constants
- **Reusable:** yes

### updateToVisualObject
- **Does:** Copies the Lua object data fields (name, position, rotation) into the underlying C object via setObjectInfo.
- **Uses:** `setObjectInfo(obj.cObj, IG3D_NAME, obj.name)`, `setObjectInfo(obj.cObj, IG3D_POSITION, obj.x, obj.y, obj.z)`, `setObjectInfo(obj.cObj, IG3D_ROTATION, obj.xang, obj.yang, obj.zang)`
- **Reusable:** yes

### updateFromVisualObject
- **Does:** Reads the underlying C object's name, position and rotation values into the Lua object data fields.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_NAME)`, `getObjectInfo(obj.cObj, IG3D_POSITION)`, `getObjectInfo(obj.cObj, IG3D_ROTATION)`
- **Reusable:** yes

### printObjectData
- **Does:** Updates the Lua object data from the C object, then prints the object's name, position and orientation to stdout.
- **Uses:** `updateFromVisualObject(obj)`, globals `IG3D_*` constants
- **Reusable:** yes

### create
- **Does:** Creates a new visual object from a model name and idle function, initializes its data, registers it in the global object list, and returns the new object.
- **Uses:** `make(ig3d_object, modelname)`, `updateFromVisualObject(myobj)`, `updateToVisualObject(myobj)`, globals `gNumObjects`, `gObjects`, `IG3D_*` constants
- **Reusable:** yes

### updateFromAllVisualObjects
- **Does:** Iterates through all registered visual objects and updates their Lua data from their underlying C objects.
- **Uses:** `updateFromVisualObject(gObjects[i])`, globals `gNumObjects`, `gObjects`
- **Reusable:** yes

## Part 5 of 6

### Top level
- **Does:** Sets the `gNativeOS` global to the host operating system name returned by `murgaLua.getHostOsName()`.
- **Uses:** `murgaLua.getHostOsName()`
- **Reusable:** yes

### updateAllVisualObjects
- **Does:** Iterates over all objects in `gObjects` and calls `updateToVisualObject` on each to set their visual object data.
- **Uses:** `gObjects`, `gNumObjects`
- **Reusable:** yes

### getObjectByItsID
- **Does:** Searches `gObjects` for the object whose `cObj` field matches the given `id`, returning that object or `nil` if no match is found or `id` is `nil`.
- **Uses:** `gObjects`, `gNumObjects`
- **Reusable:** yes

### game_idle
- **Does:** Calls the global `game_func` if it is not `nil`, otherwise does nothing.
- **Uses:** `game_func`
- **Reusable:** yes

### edit_idle
- **Does:** Calls the global `edit_func` if it is not `nil`, otherwise does nothing.
- **Uses:** `edit_func`
- **Reusable:** yes

### coll_obj_obj
- **Does:** Calls the global `coll_o_o` with the same arguments if it is not `nil`, otherwise does nothing.
- **Uses:** `coll_o_o`
- **Reusable:** yes

### coll_obj_mesh
- **Does:** Calls the global `coll_o_m` with the same arguments if it is not `nil`, otherwise does nothing.
- **Uses:** `coll_o_m`
- **Reusable:** yes

### coll_obj_prtcl
- **Does:** Calls the global `coll_o_p` with the same arguments if it is not `nil`, otherwise does nothing.
- **Uses:** `coll_o_p`
- **Reusable:** yes

### coll_prtcl_prtcl
- **Does:** Calls the global `coll_p_p` with the same arguments if it is not `nil`, otherwise does nothing.
- **Uses:** `coll_p_p`
- **Reusable:** yes

### coll_prtcl_mesh
- **Does:** Calls the global `coll_p_m` with the same arguments if it is not `nil`, otherwise does nothing.
- **Uses:** `coll_p_m`
- **Reusable:** yes

## Part 6 of 6

### Top level
- **Does:** Contains setup code and global-level calls outside the listed functions, including an iGame3D socket initialization call and a dofile import of the C++ to iGame3D Lua converter.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `dofile(...)`, `luasocket_init()`, `Fl:run()`
- **Reusable:** no

### fltk_update
- **Does:** Updates FLTK UI waits based on the native OS: on macOS it waits only if the "-" click check fails, otherwise it waits unconditionally; on other platforms it waits unconditionally.
- **Uses:** `gNativeOS`, `click("-")`, `Fl:wait(0)`
- **Reusable:** no

### luasocket_init
- **Does:** Loads the LuaSocket library files from the Data/Scripts/LuaSocket folder, then calls itself to initialize socket support.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `dofile(...)`, `Data/Scripts/LuaSocket/` paths
- **Reusable:** yes

### Fl:run
- **Does:** Defines the Fl:run method as a no-op that does nothing to avoid stalling iGame3D when called.
- **Uses:** nothing
- **Reusable:** yes

### Top level
- **Does:** Contains setup code and global-level calls outside the listed functions, including an iGame3D socket initialization call and a dofile import of the C++ to iGame3D Lua converter.
- **Uses:** `getSceneInfo(IG3D_ROOT)`, `dofile(...)`, `luasocket_init()`, `Fl:run()`
- **Reusable:** no
