<!-- Spark first-look of Data/Scripts/Functions/random_functions.lua (model spark-x2.6-4b, 2026-11-12 15:28). DRAFT for Claude to review. -->

## random_functions.lua
- **Kind:** library
- **Purpose:** This file provides reusable random number generation helpers for the iGame3D engine, including a rectangle boundary check, a random number generator, a three-value random generator, and a loop-based random output printer. It seeds the random number generator and runs a sample random output at load time.
- **Depends on:** none (no files loaded, no Data/ paths, no globals set elsewhere required)
- **Provides:** `insideRECT`, `rnd`, `getrandthree`, `threerandom`, `rndlist`
- **Assets it needs:** none
- **Procedural:** yes (generates random values and prints random output based on the seed and loop parameters instead of loading files)
- **Glossary:**
  - `rndlist - Prints a comma-separated string of three random values for each iteration of a loop that steps from 1 to the given number of steps in the given step size`
  - `getrandthree - Generates three random values, each calculated as a random number between 1 and 3 minus 2, and returns them as a tuple`
  - `threerandom - Converts the three values returned by getrandthree into a comma-separated string and returns it`
  - `rnd - Generates a random number between the given lowest and highest values`
  - `insideRECT - Returns true only when both the given x and y coordinates fall within the specified rectangle boundaries, otherwise returns nothing`
- **Keep / port / drop:** keep - reusable random number helpers that follow the engine's existing random generation pattern

---

# Part notes

## Part 1 of 1

### Top level
- **Does:** Sets the random seed and initial random number value, then defines the listed functions and calls `rndlist` with arguments 10 and 2.
- **Uses:** `math.randomseed`, `math.random`, `os.time`, `print`
- **Reusable:** no
- **Procedural:** no

### insideRECT
- **Does:** Returns true only when both the given x and y coordinates fall within the specified rectangle boundaries, otherwise returns nothing.
- **Uses:** nothing
- **Reusable:** yes
- **Procedural:** no

### rnd
- **Does:** Generates a random number between the given lowest and highest values.
- **Uses:** `math.random`
- **Reusable:** yes
- **Procedural:** no

### getrandthree
- **Does:** Generates three random values, each calculated as a random number between 1 and 3 minus 2, and returns them as a tuple.
- **Uses:** `math.random`
- **Reusable:** yes
- **Procedural:** no

### threerandom
- **Does:** Converts the three values returned by `getrandthree` into a comma-separated string and returns it.
- **Uses:** `commaDelItems`
- **Reusable:** yes
- **Procedural:** no

### rndlist
- **Does:** Prints a comma-separated string of three random values for each iteration of a loop that steps from 1 to the given number of steps in the given step size.
- **Uses:** `print`, `threerandom`
- **Reusable:** yes
- **Procedural:** yes

### Top level
- **Does:** Calls `rndlist` with arguments 10 and 2 to generate and print the listed random output.
- **Uses:** `rndlist`
- **Reusable:** no
- **Procedural:** yes
