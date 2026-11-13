<!-- Spark first-look of Data/Scripts/Functions/math_functions.lua (model spark-x2.6-4b, 2026-11-12 07:04). DRAFT for Claude to review. -->

## math_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable numerical and geometric helper functions for 3D game engine scripting, covering quaternion and matrix math, vector operations, distance and angle calculations, and mesh geometry helpers. It contains no setup, globals, or UI code, making it a standalone library for other engine scripts to reuse.
- **Depends on:** globals `camera`, `direction_to_object`, `dirToAngles` set elsewhere in the engine; engine calls `ig3d_GetWindowBounds__4i()` and `ig3d_GetMeshBounds__6f()`, `ig3d_SetMeshPosition_3f()` for window and mesh bounds/position access.
- **Provides:** Functions including `insideRECT`, `rnd`, `formattedTime`, `copysign`, `quaternionFromMatrix`, `matrixFromQuaternion`, `slerp`, `quaternionMult`, `direction_to_object`, `camera_face_object`, `distance_to_object`, `distance_object_to_object`, `distance_object_to_point`, `matrixMult`, `matrixConcat`, `mat_det33`, `mat_inv33`, `normalized`, `angle_delta`, `dot`, `cross`, `sgn`, `vecLength`, `jiggle`, `GlRect`, `groundMesh`, `meshHWD`.
- **Assets it needs:** none (no models, images, sounds, emitters, or fonts are named or required).
- **Procedural:** Generates procedural values such as random numbers, jiggle values, and mesh center/height/width/depth calculations from numeric rules or engine calls, rather than loading asset files.
- **Glossary:**
  - `quaternion` - A four-component rotation representation used to represent 3D rotations in the engine.
  - `matrix` - A 3x3 or 4x4 numeric array used for 3D transformations in the engine.
  - `ig3d_GetWindowBounds__4i()` - Engine call that returns window bounds for UI calculations.
  - `ig3d_GetMeshBounds__6f()` - Engine call that returns mesh bounds for geometry calculations.
  - `ig3d_SetMeshPosition_3f()` - Engine call that sets a mesh position from three coordinate values.
  - `IG3D_POSITION` - Engine property constant naming position, used to read or set object position.
- **Keep / port / drop:** keep - reusable pure numerical and geometric helper library for engine scripts.

---

# Part notes

## Part 1 of 5

### Top level
- **Does:** Contains no setup, global definitions, or widget code outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### insideRECT
- **Does:** Returns true only when both the given x and y coordinates fall within the supplied rectangle bounds.
- **Uses:** nothing
- **Reusable:** yes

### rnd
- **Does:** Generates a random number between the given lowest and highest values, resetting the Lua random seed before each call.
- **Uses:** nothing
- **Reusable:** yes

### formattedTime
- **Does:** Formats a number as a `m:s` time string by dividing by 60, zero-padding seconds below 10, and concatenating the parts.
- **Uses:** nothing
- **Reusable:** yes

### copysign
- **Does:** Returns the absolute value of the destination value multiplied by the sign of the source value.
- **Uses:** nothing
- **Reusable:** yes

### quaternionFromMatrix
- **Does:** Converts a 4x4 matrix passed as individual component arguments into a quaternion, applying sign adjustments based on specific matrix components before returning the four components.
- **Uses:** nothing
- **Reusable:** yes

### matrixFromQuaternion
- **Does:** Converts a unit quaternion passed as individual component arguments into a 3x3 matrix, computing each matrix element from the quaternion components and returning the nine elements in row-major order.
- **Uses:** nothing
- **Reusable:** yes

## Part 2 of 5

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### slerp
- **Does:** Interpolates between two quaternions using spherical linear interpolation, returning the interpolated quaternion components.
- **Uses:** nothing
- **Reusable:** yes

### quaternionMult
- **Does:** Multiplies two quaternions together, returning the resulting quaternion components.
- **Uses:** nothing
- **Reusable:** yes

### direction_to_object
- **Does:** Computes the direction vector from the camera position to the given object by subtracting the camera coordinates from the object coordinates.
- **Uses:** globals `camera`
- **Reusable:** yes

### camera_face_object
- **Does:** Computes the direction from the camera to the given object, then converts those direction components into camera rotation angles.
- **Uses:** globals `camera`, `direction_to_object`, `dirToAngles`
- **Reusable:** yes

### distance_to_object
- **Does:** Computes the Euclidean distance between the camera position and the given object.
- **Uses:** globals `camera`
- **Reusable:** yes

### distance_object_to_object
- **Does:** Computes the Euclidean distance between two given objects.
- **Uses:** nothing
- **Reusable:** yes

### distance_object_to_point
- **Does:** Computes the Euclidean distance between a given object and a specified point.
- **Uses:** nothing
- **Reusable:** yes

## Part 3 of 5

### Top level
- **Does:** Contains only the four matrix functions defined in this file; no setup, globals, or other top-level code.
- **Uses:** nothing
- **Reusable:** yes - pure numerical matrix math functions, reusable across engine scripts.

### matrixMult
- **Does:** Multiplies two 4x4 matrices by taking the element-wise products of corresponding rows and columns, returning the resulting matrix entries.
- **Uses:** nothing
- **Reusable:** yes - pure numerical matrix math, reusable across engine scripts.

### matrixConcat
- **Does:** Multiplies two 4x4 matrices element-wise across all rows and columns, returning the full resulting matrix entries.
- **Uses:** nothing
- **Reusable:** yes - pure numerical matrix math, reusable across engine scripts.

### mat_det33
- **Does:** Computes the determinant of a 3x3 matrix using the standard cofactor expansion formula.
- **Uses:** nothing
- **Reusable:** yes - pure numerical matrix math, reusable across engine scripts.

### mat_inv33
- **Does:** Computes the inverse of a 3x3 matrix by first calculating its determinant, then applying the adjugate formula scaled by the reciprocal determinant.
- **Uses:** nothing
- **Reusable:** yes - pure numerical matrix math, reusable across engine scripts.

## Part 4 of 5

### Top level
- **Does:** No setup, globals, or widget definitions appear outside the listed functions.
- **Uses:** nothing
- **Reusable:** no

### normalized
- **Does:** Normalizes a 3D vector by dividing each component by its Euclidean length, returning the normalized components. If the vector length is zero, it returns the original components unchanged.
- **Uses:** nothing
- **Reusable:** yes

### angle_delta
- **Does:** Computes the difference between two angles in degrees, adjusting the result to fall within the range -180 to 180 degrees.
- **Uses:** nothing
- **Reusable:** yes

### dot
- **Does:** Computes the dot product of two 3D vectors by multiplying corresponding components and summing the results.
- **Uses:** nothing
- **Reusable:** yes

### cross
- **Does:** Computes the cross product of two 3D vectors, returning the resulting vector's x, y, and z components.
- **Uses:** nothing
- **Reusable:** yes

### sgn
- **Does:** Returns 1.0 for a positive input, -1.0 for a negative input, and 0.0 for an input equal to zero.
- **Uses:** nothing
- **Reusable:** yes

### vecLength
- **Does:** Computes the Euclidean length of a 3D vector by squaring each component, summing them, and taking the square root.
- **Uses:** nothing
- **Reusable:** yes

### jiggle
- **Does:** Generates a jiggle value by scaling a step value by -2 and adding a random value between 1 and 3 multiplied by a mod value.
- **Uses:** nothing
- **Reusable:** yes

### GlRect
- **Does:** Reads the window bounds from the engine, calculates the window width, height, and center coordinates, then returns the requested bounds or derived values based on the `getWhat` argument.
- **Uses:** `ig3d_GetWindowBounds__4i()`
- **Reusable:** no

### Procedural:
No section

## Part 5 of 5

### Top level
No code outside the two defined functions.

### groundMesh
- **Does:** Computes the center coordinates of a mesh bounds and sets the mesh position to those center values.
- **Uses:** Engine calls `ig3d_GetMeshBounds__6f()` and `ig3d_SetMeshPosition_3f()`; no files or globals.
- **Reusable:** yes - pure geometry math on mesh bounds.

### meshHWD
- **Does:** Calculates the height, width and depth differences from mesh bounds and returns them as a tuple.
- **Uses:** Engine call `ig3d_GetMeshBounds__6f()`; no files or globals.
- **Reusable:** yes - pure geometry math on mesh bounds.
