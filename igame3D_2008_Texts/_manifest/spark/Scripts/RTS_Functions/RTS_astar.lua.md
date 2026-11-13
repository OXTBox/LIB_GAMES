<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_astar.lua (model spark-x2.6-4b, 2026-11-12 21:02). DRAFT for Claude to review. -->

## RTS_astar.lua
- **Kind:** library
- **Purpose:** This file provides A* pathfinding and grid-based path generation utilities for the iGame3D engine, including simple list and heap data structures, node grid construction, path expansion, and A* search helpers used by game pathfinding code.
- **Depends on:** `SimpleList` metatables and `SimpleMinHeap` metatables, `getObjectInfo`, `setObjectInfo`, `IG3D_POSITION`, `IG3D_BOUNDS`, `IG3D_ROTATION_MATRIX`, `IG3D_BOUNDS`, `ig3d_SetMode_i`, `lineCollision`, `flagNode`, `getNearestNodeOfPosition`, `getSurroundingNodesOfPosition`, `getNearestOutsideNode`, `getNearestOutsideNode2`, `normalized`, `dot`, `vecLength`, `math.sqrt`, `math.floor`, `math.ceil`, `math.min`, `math.max`, `math.abs`, `time()`, `gMaxAStarPasses`, `gObjects`, `gGridSize`, `gXOffset`, `gZOffset`, `gNumRowVertices`, `gNumColumnVertices`, `gNumObjects`, `gObjects`, `Data/` folder paths (via `dofile`/`loadLevel` referenced in background context), `NoPathFound`, `PathFound`, `crazyJumpBackTime`
- **Provides:** `SimpleList:create`, `SimpleList:add`, `SimpleList:isEmpty`, `SimpleList:contains`, `SimpleList:cleanup`, `SimpleMinHeap:create`, `SimpleMinHeap:insert`, `SimpleMinHeap:extractMin`, `SimpleMinHeap:heapify`, `SimpleMinHeap:contains`, `SimpleMinHeap:changeKey`, `SimpleMinHeap:isEmpty`, `SimpleMinHeap:cleanup`, `pointInObjectBoundingBox`, `a_star`, `squareOf`, `astar_g`, `astar_c`, `astar_h`, `expandNode`, `pick_best_matching_floor`, `maybe_add_successor_primitive_nodes`, `maybe_add_successor`, `createNodeGrid`, `getNearestNodeOfPosition`, `getSurroundingNodesOfPosition`, `flagNode`, `flagNodeExtended`, `maybe_step_forward`, `mrnd`, `getNearestOutsideNode`, `getNearestOutsideNode2`, `drawSuccessors`, `checkPathForDuplicates`, `generateAStarPathBetweenPositions`, `crazyJumpBack`, `setupAStarGrid`
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this code)
- **Procedural:** yes - generates A* node grids, path nodes, and A* search state from numeric inputs and object bounds, including `createNodeGrid`, `generateAStarPathBetweenPositions`, and `setupAStarGrid`
- **Glossary:**
  - A* pathfinding - algorithm that finds the shortest path between two nodes by expanding nodes and tracking open/closed node lists
  - SimpleList - lightweight Lua list type with add, isEmpty, contains, cleanup methods for managing node collections
  - SimpleMinHeap - lightweight Lua min-heap type with insert, extractMin, heapify, contains, changeKey, isEmpty, cleanup methods for priority-based node management
  - Node grid - 3D grid of nodes built from object bounds and collision floors used for pathfinding
  - ig3d_SetMode_i - engine call that sets the engine mode to a specific value (used to trigger jump-back behavior)
  - IG3D_POSITION - engine constant naming the position property being read or set on objects
  - flagNode - function that updates node collision flags based on object bounds and time
- **Keep / port / drop:** keep - core A* and grid pathfinding logic is reusable for new 3D engine pathfinding implementations

## RTS_astar.lua
- **Kind:** library
- **Purpose:** This file contains the A* pathfinding and grid-based path generation libraries for the iGame3D engine, providing data structures, node grid construction, path expansion, and A* search helpers used by game pathfinding code.
- **Depends on:** `SimpleList` metatables and `SimpleMinHeap` metatables, `getObjectInfo`, `setObjectInfo`, `IG3D_POSITION`, `IG3D_BOUNDS`, `IG3D_ROTATION_MATRIX`, `lineCollision`, `flagNode`, `getNearestNodeOfPosition`, `getSurroundingNodesOfPosition`, `getNearestOutsideNode`, `getNearestOutsideNode2`, `normalized`, `dot`, `vecLength`, `math.sqrt`, `math.floor`, `math.ceil`, `math.min`, `math.max`, `math.abs`, `time()`, `gMaxAStarPasses`, `gObjects`, `gGridSize`, `gXOffset`, `gZOffset`, `gNumRowVertices`, `gNumColumnVertices`, `gNumObjects`, `NoPathFound`, `PathFound`, `crazyJumpBackTime`, `ig3d_SetMode_i`
- **Provides:** `SimpleList:create`, `SimpleList:add`, `SimpleList:isEmpty`, `SimpleList:contains`, `SimpleList:cleanup`, `SimpleMinHeap:create`, `SimpleMinHeap:insert`, `SimpleMinHeap:extractMin`, `SimpleMinHeap:heapify`, `SimpleMinHeap:contains`, `SimpleMinHeap:changeKey`, `SimpleMinHeap:isEmpty`, `SimpleMinHeap:cleanup`, `pointInObjectBoundingBox`, `a_star`, `squareOf`, `astar_g`, `astar_c`, `astar_h`, `expandNode`, `pick_best_matching_floor`, `maybe_add_successor_primitive_nodes`, `maybe_add_successor`, `createNodeGrid`, `getNearestNodeOfPosition`, `getSurroundingNodesOfPosition`, `flagNode`, `flagNodeExtended`, `maybe_step_forward`, `mrnd`, `getNearestOutsideNode`, `getNearestOutsideNode2`, `drawSuccessors`, `checkPathForDuplicates`, `generateAStarPathBetweenPositions`, `crazyJumpBack`, `setupAStarGrid`
- **Assets it needs:** none (no model, image, sound, emitter, or font file names are named in this code)
- **Procedural:** yes - generates A* node grids, path nodes, and A* search state from numeric inputs and object bounds, including `createNodeGrid`, `generateAStarPathBetweenPositions`, and `setupAStarGrid`
- **Glossary:**
  - A* pathfinding - algorithm that finds the shortest path between two nodes by expanding nodes and tracking open/closed node lists
  - Simple

<!-- CUT OFF: reached max_tokens (1500); delete this file and rerun -->

---

# Part notes

## Part 1 of 15

### Top level
- **Does:** Declares the shared `gMaxAStarPasses` global and the base metatables for `SimpleList` and `SimpleMinHeap`.
- **Uses:** nothing
- **Reusable:** no

### SimpleList:create
- **Does:** Creates a new `SimpleList` instance with an empty internal list table and the `SimpleList_mt` metatable.
- **Uses:** nothing
- **Reusable:** yes

### SimpleList:add
- **Does:** Adds a node to the list, marking the node's `icl` field as true to indicate it is in the closed list.
- **Uses:** nothing
- **Reusable:** yes

### SimpleList:isEmpty
- **Does:** Returns true when the list contains no nodes.
- **Uses:** nothing
- **Reusable:** yes

### SimpleList:contains
- **Does:** Returns the value of the node's `icl` field, used to check whether a node is in the closed list.
- **Uses:** nothing
- **Reusable:** yes

### SimpleList:cleanup
- **Does:** Removes all nodes from the list, clearing each node's `heapEntry` and `icl` fields before removing it.
- **Uses:** nothing
- **Reusable:** yes

### SimpleMinHeap:create
- **Does:** Creates a new `SimpleMinHeap` instance with an empty internal heap table and the `SimpleMinHeap_mt` metatable.
- **Uses:** nothing
- **Reusable:** yes

### SimpleMinHeap:insert
- **Does:** Inserts a node into the heap as a priority entry, records the node's heap position, then heapifies the heap.
- **Uses:** nothing
- **Reusable:** yes

### SimpleMinHeap:extractMin
- **Does:** Removes and returns the minimum priority node from the heap, moves the last heap entry to the first position, removes it, then heapifies the heap.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 15

### SimpleMinHeap:heapify
- **Does:** Heapifies the heap in place by repeatedly swapping entries so the minimum is at the root, first moving the minimum up to the root, then moving each node down to its smallest child until no further swap is needed.
- **Uses:** nothing
- **Reusable:** yes - pure heap data manipulation, no engine calls or external inputs.

### SimpleMinHeap:contains
- **Does:** Returns true when the given heap entry is present in the heap, false otherwise.
- **Uses:** nothing
- **Reusable:** yes - pure data membership check.

### SimpleMinHeap:changeKey
- **Does:** Finds the heap entry matching the given node identifier and updates its key value, then re-heapifies the heap at that entry's index to restore the min-heap property.
- **Uses:** nothing
- **Reusable:** yes - pure heap data manipulation, no engine calls or external inputs.

### SimpleMinHeap:isEmpty
- **Does:** Returns true when the heap contains no entries, false otherwise.
- **Uses:** nothing
- **Reusable:** yes - pure heap data check.

### SimpleMinHeap:cleanup
- **Does:** Removes every entry from the heap, clearing each entry's `icl` flag and `heapEntry` field before deleting it from the heap table.
- **Uses:** nothing
- **Reusable:** yes - pure heap data manipulation, no engine calls or external inputs.

## Part 3 of 15

### Top level
- **Does:** Declares two module-level constants used by the A* functions to signal path outcomes.
- **Uses:** nothing
- **Reusable:** yes

### pointInObjectBoundingBox
- **Does:** Rotates a given world-space point into the object's local coordinate system, then checks whether it falls inside the object's oriented bounding box; returns true only if the rotated point lies within the box's bounds.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_BOUNDS)`, `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`, `IG3D_BOUNDS`, `IG3D_ROTATION_MATRIX`
- **Reusable:** no

### a_star
- **Does:** Runs A* pathfinding between a start node and a destination node, maintaining an open list and closed list of nodes, and returns `PathFound` when the destination is reached or `NoPathFound` when no path exists.
- **Uses:** `SimpleMinHeap:create()`, `SimpleList:create()`, `openlist`, `closedlist`, `expandNode`, `openlist:extractMin()`, `openlist:cleanup()`, `closedlist:add()`, `openlist:isEmpty()`, `NoPathFound`, `PathFound`
- **Reusable:** no

### squareOf
- **Does:** Computes the square of a given numeric value.
- **Uses:** nothing
- **Reusable:** yes

### astar_g
- **Does:** Returns the stored f value of a node's heap entry, or 0 if the node has no heap entry.
- **Uses:** `node.heapEntry`, `f`
- **Reusable:** yes

## Part 4 of 15

### astar_c
- **Does:** Computes the cost of moving from one node to the next, using the x and z coordinates of the two nodes and the square root of their squared distance difference.
- **Uses:** `math.sqrt`, `squareOf` (engine math helpers referenced by the code).
- **Reusable:** yes - pure coordinate distance calculation.

### astar_h
- **Does:** Computes the cost of moving from a node to a destination node, using the x and z coordinates of both nodes and the square root of their squared distance difference.
- **Uses:** `math.sqrt`, `squareOf` (engine math helpers referenced by the code).
- **Reusable:** yes - pure coordinate distance calculation.

### expandNode
- **Does:** Expands the A* search by iterating over each successor of the current node, updating successor flags, recalculating path costs, and inserting or updating successors in the open list.
- **Uses:** `flagNode`, `closedlist:contains`, `openlist:contains`, `openlist:changeKey`, `openlist:insert`, `astar_g`, `astar_c`, `astar_h` (functions and lists referenced by the code).
- **Reusable:** no - depends on A* search state and node structures.

## Part 5 of 15

### pick_best_matching_floor
- **Does:** Finds the node in `node` whose `y` value is closest to the given `y`, then returns that node.
- **Uses:** nothing
- **Reusable:** yes

### maybe_add_successor_primitive_nodes
- **Does:** Checks whether two nodes can be connected as successors by testing line collisions on the nodes and on the nodes offset to the side of the node-to-node direction, then adds `node2` to `node1.successors` if all checks pass.
- **Uses:** nothing
- **Reusable:** no

### maybe_add_successor
- **Does:** Iterates over every pair of nodes from `nodes1` and `nodes2`, calling `maybe_add_successor_primitive_nodes` for each pair.
- **Uses:** nothing
- **Reusable:** no

## Part 6 of 15

### createNodeGrid
- **Does:** Builds a 3D node grid by computing collision-floor nodes for each grid cell, then connects adjacent nodes with successors.
- **Uses:** `lineCollision`, `flagNode`, `maybe_add_successor`, local tables `grid`, `floors`, `a`
- **Reusable:** no
- **Procedural:** yes

## Part 7 of 15

### getNearestNodeOfPosition
- **Does:** Finds the nearest node in the grid to a given position by testing four surrounding grid cells and returning the closest one.
- **Uses:** `math.floor`, `math.ceil`, `math.min`, `math.max`, `vecLength`, `pick_best_matching_floor`, globals `grid`, `gXOffset`, `gGridSize`, `gNumRowVertices`, `gNumColumnVertices`
- **Reusable:** yes - pure grid lookup and distance comparison logic, reusable for any grid-based node search.

### getSurroundingNodesOfPosition
- **Does:** Collects the nodes from the four surrounding grid cells of a given position into a table and returns that table.
- **Uses:** `math.floor`, `math.ceil`, `math.min`, `math.max`, `pick_best_matching_floor`, globals `grid`, `gXOffset`, `gGridSize`, `gNumRowVertices`, `gNumColumnVertices`
- **Reusable:** yes - pure grid lookup logic, reusable for any grid-based surrounding node collection.

## Part 8 of 15

### flagNode
- **Does:** Checks whether a node is inside a blocking object, reflagging the node only when its flag time has passed or is unset.
- **Uses:** `time()`, `gNumObjects`, `gObjects`, `getObjectInfo`, `IG3D_POSITION`, `IG3D_BOUNDS`, `pointInObjectBoundingBox`, `nd.flagTime`, `nd.inside`, `nd.x`, `nd.y`, `nd.z`
- **Reusable:** yes
- **Procedural:** no

### flagNodeExtended
- **Does:** Calls flagNode to update node flags, then computes a line collision result for the node and forces the result to true when the node has no successors.
- **Uses:** `flagNode`, `lineCollision`, `nd.insideE`, `nd.successors`, `nd.x`, `nd.y`, `nd.z`, `x`, `y`, `z`
- **Reusable:** no
- **Procedural:** no

### maybe_step_forward
- **Does:** Advances a path pointer forward while the next node does not collide with the current position, returning the final path node when no further advancement is possible.
- **Uses:** `lineCollision`, `pth.next`, `pth.x`, `pth.y`, `pth.z`, `x`, `y`, `z`
- **Reusable:** yes
- **Procedural:** no

### mrnd
- **Does:** Returns the nearest integer to a given value, rounding up when the fractional part is at least 0.5 and truncating otherwise.
- **Uses:** `math.floor`, `math.ceil`, `math.abs`, `n`
- **Reusable:** yes
- **Procedural:** no

## Part 9 of 15

### getNearestOutsideNode
- **Does:** Moves from a starting node toward a given position in the xz plane, stepping through nodes, and returns the first node outside the starting node that is not the starting node itself, or nil if the direction is senseless.
- **Uses:** `getNearestNodeOfPosition`, `flagNode`, `normalized`, `dot`, node fields (`x`, `z`, `inside`, `successors`), parameters `nd`, `x`, `y`, `z`.
- **Reusable:** yes - pure node traversal and vector math logic.

### getNearestOutsideNode2
- **Does:** Moves from a starting node toward a given position in the xz plane, stepping through nodes, and returns the first node outside the starting node that is not the starting node itself, or nil if the loop never terminates.
- **Uses:** `getNearestNodeOfPosition`, `flagNode`, node fields (`x`, `z`, `inside`), parameters `nd`, `x`, `y`, `z`.
- **Reusable:** yes - pure node traversal and vector math logic.

### drawSuccessors
- **Does:** Recursively draws the successor nodes of a node at the given position, drawing each successor's xz position and connecting it to the parent, with depth limiting the recursion to at most 5 levels.
- **Uses:** `getNearestNodeOfPosition`, node fields (`x`, `z`, `successors`), parameters `x`, `y`, `z`, `depth`.
- **Reusable:** yes - pure graph traversal and rendering logic.

## Part 10 of 15

### checkPathForDuplicates
- **Does:** Walks a path step by step, skipping consecutive steps that share the same x and z coordinates, and returns false when the path ends.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 11 of 15

### generateAStarPathBetweenPositions
- **Does:** Computes a path between two positions, first checking for line-of-sight and free movement, then falling back to A* node expansion and flagging surrounding nodes when a star path is needed.
- **Uses:** Engine calls `getSurroundingNodesOfPosition`, `flagNodeExtended`; globals `gGridSize`, `normalized`, `lineCollision`, `cross`, `vecLength`, `getObjectInfo` (commented out); `Data/` paths none; `IG3D_POSITION` (commented out).
- **Reusable:** no
- **Procedural:** yes - generates a path through grid nodes based on position inputs and node data.

### <function name>
- **Does:** one or two sentences.
- **Uses:** the engine calls, globals, files and `Data/` paths it reads or writes, copied exactly from this code. "nothing" if it is pure.
- **Reusable:** yes / no / with changes - a few words why (pure math, string and data functions are the most reusable).
- **Procedural:** only if it GENERATES an asset from numbers or rules (geometry, a level layout, a texture, a terrain, a maze, an animation) - creating or setting up one object, widget or text box is NOT procedural. Otherwise leave this line out.

## Part 12 of 15

### generateAStarPathBetweenPositions (continued)

- **Does:** Continues the A* path generation by selecting the nearest outside nodes for the start and end positions, computing normalized direction vectors, and preparing the start/destination nodes for the A* search, including a fallback call to `getNearestOutsideNode2` when no outside node was found for the start.
- **Uses:** `getSurroundingNodesOfPosition`, `flagNodeExtended`, `vecLength`, `normalized`, `getNearestOutsideNode2`, local variables `nds`, `dst1`–`dst4`, `nearestToStart`, `nearestToEnd`, `startNode`, `destinationNode`, `aStarSuccessful`, `a_star`
- **Reusable:** no
- **Procedural:** no

## Part 13 of 15

### generateAStarPathBetweenPositions (continued)

- **Does:** After A* succeeds, builds the path node chain from the start node to the destination node, trims or adjusts the path head and tail to match the requested start and end points, and returns the path head; if A* fails, builds a fallback path head pointing at the destination node.
- **Uses:** `aStarSuccessful`, `gMaxAStarPasses`, `getNearestOutsideNode`, `a_star`, `nds`, `startNode`, `destinationNode`, `x1`, `y1`, `z1`, `x2`, `y2`, `z2`, `target`, `playerBox`, `pth_head`, `pth_tail`, `pth`, `next`, `last`, `predecessor`
- **Reusable:** no
- **Procedural:** yes

## Part 14 of 15

### generateAStarPathBetweenPositions (continued)
- **Does:** Returns the head of the generated path after the A* path generation section completes.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

## Part 15 of 15

### crazyJumpBack
- **Does:** Checks whether the current time exceeds `crazyJumpBackTime`, and if so sets the engine mode to `4` via `ig3d_SetMode_i`.
- **Uses:** `time()`, `crazyJumpBackTime`, `ig3d_SetMode_i(4)`
- **Reusable:** yes

### setupAStarGrid
- **Does:** Computes the A* grid dimensions, adaptive offsets and vertex counts from the mesh bounds, moves all objects out of the interesting area, creates the node grid, then restores the objects' original positions.
- **Uses:** `ig3d_GetMeshBounds__6f()`, `getObjectInfo`, `setObjectInfo`, `IG3D_POSITION`, `gGridSize`, `gNumRowVertices`, `gNumColumnVertices`, `gXOffset`, `gZOffset`, `gObjects`, `createNodeGrid`
- **Reusable:** no
- **Procedural:** yes
