<!-- Spark first-look of Data/Scripts/RTS_Functions/RTS_Vehicles.lua (model spark-x2.6-4b, 2026-11-12 20:56). DRAFT for Claude to review. -->

## RTS_Vehicles.lua
- **Kind:** engine-core
- **Purpose:** This file implements the core vehicle driving, sound, steering, and collision logic for the iGame3D RTS game. It computes engine pitch and steering values from object rotation and velocity, drives vehicles around using wheel torque and steering inputs, and handles vehicle state transitions such as getting stuck, flipping, and stepping out of a car.
- **Depends on:** `gObjects`, `isVehicle`, `driver`, `handle_car_sounds`, `drive_car_around`, `init_car`, `nearestCrossing`, `headingInWhatDirection`, `getNextCrossingPosition`, `correctCrossingPosition`, `tireTraces`, `ig3d_bone`, `ig3d_material`, `setSound_emitterInfo`, `setParticle_emitterInfo`, `setBoneInfo`, `setMaterialInfo`, `setObjectInfo`, `getObjectInfo`, `setCameraInfo`, `getCameraInfo`, `getSceneInfo`, `getBoneInfo`, `get`, `putObjectOnGround`, `Data/Images/Vehicles/Cmro_texbrake.png`, `Data/Images/Vehicles/Cmro_tex.png`
- **Provides:** `getEnginePitchForCar`, `handle_car_sounds`, `play_car_sounds`, `steer_aim`, `drive_car_around`, `init_car`, `nearestCrossing`, `headingInWhatDirection`, `getNextCrossingPosition`, `correctCrossingPosition`, `car_stuck`, `car_flipped`, `stepOutOfCar`
- **Assets it needs:** `Data/Images/Vehicles/Cmro_texbrake.png`, `Data/Images/Vehicles/Cmro_tex.png`
- **Procedural:** none
- **Glossary:**
  - `IG3D_ROTATION_MATRIX - object property holding the object's rotation matrix used for pitch, steering, and flip detection.`
  - `IG3D_VELOCITY - object property holding the object's velocity used for sound and steering calculations.`
  - `IG3D_POSITION - object property holding the object's position used for grid crossing and stuck tracking.`
  - `IG3D_TORQUE - wheel property value controlling wheel torque for driving.`
  - `IG3D_BRAKE - wheel property value controlling brake force for wheels.`
  - `IG3D_STEERING_ANGLE - wheel property value controlling steering angle for wheels.`
  - `IG3D_EMISSION - material property value controlling material emission.`
  - `IG3D_TEXTURE - material property value controlling material texture.`
- **Keep / port / drop:** keep - core vehicle logic that other vehicle files depend on and reuse for new vehicle implementations.

---

# Part notes

## Part 1 of 7

### getEnginePitchForCar
- **Does:** Computes the engine pitch for a car object from its rotation matrix and velocity, returning a pitch value.
- **Uses:** `getObjectInfo` (with `IG3D_ROTATION_MATRIX`, `IG3D_VELOCITY`), `dot`, `math.abs`, `math`
- **Reusable:** yes - pure math and data extraction on object info
- **Procedural:** no

### handle_car_sounds
- **Does:** Updates the car engine sound emitter and skid sound emitter settings based on the car object's rotation, velocity, and scene speed, and triggers tire trace particles when skidding.
- **Uses:** `getObjectInfo`, `setSound_emitterInfo`, `getCameraInfo`, `setCameraInfo`, `getBoneInfo`, `get`, `setParticle_emitterInfo`, `getSceneInfo`, `dot`, `vecLength`, `normalized`, `cross`, `math.abs`, `ig3d_bone`, `tireTraces`, `obj.engineSndEmt`, `obj.skidSndEmt`, `obj.cObj`
- **Reusable:** no
- **Procedural:** no

### play_car_sounds
- **Does:** Iterates over all game objects, and for vehicles with a driver, calls handle_car_sounds to update their sound settings.
- **Uses:** `gObjects`, `isVehicle`, `driver`, `handle_car_sounds`
- **Reusable:** no
- **Procedural:** no

## Part 2 of 7

### steer_aim
- **Does:** Sets the object's position, computes a steering value and a left steering value based on the object's rotation matrix and target offset, then returns a table with a time value and steering flags.
- **Uses:** `getObjectInfo`, `IG3D_POSITION`, `IG3D_ROTATION_MATRIX`, `normalized`, `dot`, `math.max`, `math.min`, `time`, `obj.cObj`
- **Reusable:** yes - pure math and data manipulation logic for steering calculations.
- **Procedural:** no

## Part 3 of 7

### drive_car_around
- **Does:** Drives a car by setting wheel torque, brake and steering values on its wheels and material, based on the forward/backward/brake/hand-brake/steer inputs.
- **Uses:** `get(ig3d_bone, obj.cObj, ...)`, `setBoneInfo`, `get(ig3d_material, obj.cObj, 6)`, `setMaterialInfo`, `IG3D_TORQUE`, `IG3D_BRAKE`, `IG3D_TEXTURE`, `IG3D_EMISSION`, `IG3D_STEERING_ANGLE`, `Data/Images/Vehicles/Cmro_texbrake.png`, `Data/Images/Vehicles/Cmro_tex.png`
- **Reusable:** yes
- **Procedural:** no

### init_car
- **Does:** Initializes a car by loading its four front and rear wheel bones and setting the rear wheels' brake values to 1.
- **Uses:** `get(ig3d_bone, obj.cObj, ...)`, `setBoneInfo`, `IG3D_BRAKE`
- **Reusable:** yes
- **Procedural:** no

## Part 4 of 7

### nearestCrossing
- **Does:** Computes the grid cell coordinates for a given position by dividing by the grid size, rounding the remainder up when it exceeds half the grid size, and returns the cell origin coordinates.
- **Uses:** `math.floor`, `math.abs`
- **Reusable:** yes - pure math calculation, deterministic for any input.

### headingInWhatDirection
- **Does:** Determines the heading direction of a vector by comparing the absolute differences in x and z components, returning one of the four cardinal directions.
- **Uses:** `math.abs`
- **Reusable:** yes - pure math calculation, deterministic for any input.

## Part 5 of 7

### getNextCrossingPosition
- **Does:** Computes the next crossing position by resolving the heading direction and adjusting the direction vector for the requested curve type, then returns the adjusted `dx`, `dy`, `dz`.
- **Uses:** `headingInWhatDirection(x,y,z,dx,dy,dz)`, `nearestCrossing(dx,dy,dz,64)`
- **Reusable:** yes - pure direction and vector adjustment logic based on heading and curve type.
- **Procedural:** no

### getNextCrossingPosition
- **Does:** Determines the heading direction of the given position and direction vector, then adjusts `dx`, `dy`, `dz` by 64 units according to the curve type for each of the four cardinal directions.
- **Uses:** `headingInWhatDirection(x,y,z,dx,dy,dz)`, `nearestCrossing(dx,dy,dz,64)`
- **Reusable:** yes - pure vector and direction calculation logic.
- **Procedural:** no

## Part 6 of 7

### correctCrossingPosition
- **Does:** Adjusts the `dx`, `dy`, `dz` displacement values based on the heading direction and curve type, then returns the adjusted displacement values.
- **Uses:** `headingInWhatDirection(x,y,z,dx,dy,dz)`
- **Reusable:** yes - pure math and data transformation logic for displacement calculation.

### car_stuck
- **Does:** Tracks whether a vehicle object is stuck by comparing its current position against a stored position, updating the stuck state and position tracking values over time.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_POSITION)`, `time()`, `obj.stuckCheck`, `obj.sx`, `obj.sy`, `obj.sz`, `obj.stuck`, `obj.cObj`
- **Reusable:** no - depends on object state and position tracking specific to vehicle objects.

### car_flipped
- **Does:** Reads the rotation matrix of the vehicle object and returns whether the rotation indicates the object is flipped.
- **Uses:** `getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)`, `dot(a21,a22,a23, 0,1,0)`
- **Reusable:** yes - pure math and data transformation logic for rotation state detection.

## Part 7 of 7

### stepOutOfCar
- **Does:** Marks a vehicle as out of car, resets its health and behaviour, applies collision and rotation/position settings, puts it on the ground, stops its emitters, clears its driver and vehicle references, and drives it around.
- **Uses:** `setObjectInfo`, `getObjectInfo`, `putObjectOnGround`, `setSound_emitterInfo`, `drive_car_around`, engine constants `IG3D_COLL`, `IG3D_ROTATION_MATRIX`, `IG3D_POSITION`, `IG3D_OMEGA`, `IG3D_GRAVITY_MULTIPLIER`, `IG3D_VEHICLE`, globals `obj`, `obj.vehicle`, `obj.cObj`
- **Reusable:** no
- **Procedural:** no
