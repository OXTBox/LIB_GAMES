<!-- Spark first-look of Data/Scripts/iFly_Functions/iFly_math.lua (model spark-x2.6-4b, 2026-11-12 17:56). DRAFT for Claude to review. -->

## iFly_math.lua
- **Kind:** library
- **Purpose:** This file is a math helper library for iGame3D, providing vector and angle utility functions used by other scripts to perform 3D calculations. It also defines the global `SMALL_NUM` constant alongside the helper functions.
- **Depends on:** none (no file loads, `Data/` paths, or external globals are referenced in this file)
- **Provides:** Functions for direction and distance calculations (`direction_to_object`, `camera_face_object`, `distance_to_object`, `distance_object_to_object`, `distance_object_to_point`), matrix operations (`matrixMult`, `mat_det33`, `mat_inv33`), vector normalization (`normalized`), and vector/angle math helpers (`angle_delta`, `dot`, `cross`, `sgn`, `vecLength`), plus the global `SMALL_NUM` constant.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - 3D vector - a set of x, y, z coordinates used for spatial calculations
  - camera - the view object holding position and angle properties used for direction and distance math
  - object - a game entity with position coordinates used for distance and direction calculations
  - matrix - a 4x4 or 3x3 grid of numerical elements used for transformation math
  - angle - a degree value used for rotation and angle difference calculations
- **Keep / port / drop:** keep - reusable math library functions for 3D engine calculations

## iFly_math.lua
- **Kind:** library
- **Purpose:** This file is a math helper library for iGame3D, providing vector and angle utility functions used by other scripts to perform 3D calculations. It also defines the global `SMALL_NUM` constant alongside the helper functions.
- **Depends on:** none (no file loads, `Data/` paths, or external globals are referenced in this file)
- **Provides:** Functions for direction and distance calculations (`direction_to_object`, `camera_face_object`, `distance_to_object`, `distance_object_to_object`, `distance_object_to_point`), matrix operations (`matrixMult`, `mat_det33`, `mat_inv33`), vector normalization (`normalized`), and vector/angle math helpers (`angle_delta`, `dot`, `cross`, `sgn`, `vecLength`), plus the global `SMALL_NUM` constant.
- **Assets it needs:** none
- **Procedural:** none
- **Glossary:**
  - 3D vector - a set of x, y, z coordinates used for spatial calculations
  - camera - the view object holding position and angle properties used for direction and distance math
  - object - a game entity with position coordinates used for distance and direction calculations
  - matrix - a 4x4 or 3x3 grid of numerical elements used for transformation math
  - angle - a degree value used for rotation and angle difference calculations
- **Keep / port / drop:** keep - reusable math library functions for 3D engine calculations

---

# Part notes

## Part 1 of 2

### Top level
- **Does:** No setup, globals, widget definitions or other top-level code appears in this file.
- **Uses:** nothing
- **Reusable:** no

### direction_to_object
- **Does:** Computes the direction vector from the camera to a given object by subtracting the camera's coordinates from the object's coordinates.
- **Uses:** `camera.x`, `camera.y`, `camera.z`, `obj.x`, `obj.y`, `obj.z`
- **Reusable:** yes

### camera_face_object
- **Does:** Uses the direction vector to the object to set the camera's X, Y and Z angles so the camera faces the object.
- **Uses:** `direction_to_object`, `camera.xang`, `camera.yang`, `camera.zang`, `dirToAngles`
- **Reusable:** yes

### distance_to_object
- **Does:** Computes the straight-line distance from the camera to a given object using the object's and camera's coordinates.
- **Uses:** `camera.x`, `camera.y`, `camera.z`, `obj.x`, `obj.y`, `obj.z`, `math.sqrt`
- **Reusable:** yes

### distance_object_to_object
- **Does:** Computes the straight-line distance between two objects using their coordinates.
- **Uses:** `obj1.x`, `obj1.y`, `obj1.z`, `obj2.x`, `obj2.y`, `obj2.z`, `math.sqrt`
- **Reusable:** yes

### distance_object_to_point
- **Does:** Computes the straight-line distance from an object to a given point using the object's and point's coordinates.
- **Uses:** `obj1.x`, `obj1.y`, `obj1.z`, `x`, `y`, `z`, `math.sqrt`
- **Reusable:** yes

### matrixMult
- **Does:** Multiplies two 4x4 matrices represented by their individual element arguments and returns the resulting matrix elements.
- **Uses:** nothing
- **Reusable:** yes

### mat_det33
- **Does:** Computes the determinant of a 3x3 matrix from its nine element arguments.
- **Uses:** nothing
- **Reusable:** yes

### mat_inv33
- **Does:** Computes the inverse of a 3x3 matrix by first calculating its determinant and applying the inverse formula to the matrix elements.
- **Uses:** `mat_det33`
- **Reusable:** yes

### normalized
- **Does:** Normalizes a 3D vector by dividing each component by its Euclidean length, returning the normalized vector if the length is greater than zero.
- **Uses:** `math.sqrt`
- **Reusable:** yes

## Part 2 of 2

### Top level
- **Does:** Defines the vector and angle helper functions used by the math library, and sets the global `SMALL_NUM` constant.
- **Uses:** nothing
- **Reusable:** yes

### angle_delta
- **Does:** Computes the difference between two angles in degrees, normalizing the result to the range -180 to 180 degrees.
- **Uses:** nothing
- **Reusable:** yes

### dot
- **Does:** Computes the dot product of three-dimensional vectors given their x, y and z components.
- **Uses:** nothing
- **Reusable:** yes

### cross
- **Does:** Computes the cross product of two three-dimensional vectors given their x, y and z components, returning the resulting vector as three values.
- **Uses:** nothing
- **Reusable:** yes

### sgn
- **Does:** Returns 1.0 for a positive input, -1.0 for a negative input, and 0.0 for an input equal to zero.
- **Uses:** nothing
- **Reusable:** yes

### vecLength
- **Does:** Computes the length of a three-dimensional vector given its x, y and z components using the square root of the sum of their squares.
- **Uses:** nothing
- **Reusable:** yes
