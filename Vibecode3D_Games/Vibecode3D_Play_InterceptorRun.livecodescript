######################################################################################
## CARD SCRIPT: "Play.InterceptorRun"   INTERCEPTOR RUN  (11 14 2026)
## An armed agent car up a top-down highway: shoot or ram the red cars, spare the white
## ones, drive into the back of an orange supply truck for a special weapon, dodge the
## helicopter's bombs. At the end of the road is the water: your car becomes a boat.
## Spark's concept and level numbers (LIB_SPARK/arcade/out/478_Interceptor_Run),
## script by Claude.
## CONTROLS  Arrows (or WASD): drive    Space: gun    X (or Shift): special weapon
##           Escape: pause    mouse wheel (or + and -): zoom in on the car, and back out
## RULES     red car shot or rammed side-on: 150. White car hit: -200. Being run into
##           head-on, a bomb blast, or the road edge: a life. Supply trucks give, in turn,
##           MISSILES (8, heat seeking: they turn after the nearest red car or the
##           helicopter, blast a wide circle, and bring the helicopter down) and OIL (5 slicks behind you that
##           spin out red cars coming up from below). Reach the water: next level (5).
######################################################################################

global bPaused, bPlaying

local sCar, sBoat, sX, sVX, sDist, sStageLen, sSlice, sSliceWet, sThing, sThingN, sNextSpawn
local sShot, sShotN, sGunWait, sSpecial, sAmmo, sTruckN, sHeli, sHeliX, sBombWait, sWet
local sLevel, sLives, sScore, sOver, sWon, sHurt, sScroll, sKeysWas, sTestKeys, sHUDWas, sTicks
local sRotor, sHeliY, sZoom, sZoomF

constant kZ = 380            -- the play plane (screen scale is 300/z: 0.8 px a unit)
constant kCarY = 170
constant kHalfW = 230
constant kSliceGap = 60
constant kSlices = 13
constant kWaterLen = 1100
constant kZoomMax = 4        -- zoom steps (mouse wheel or + -); each brings the eye 15% nearer

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put 0 into sTruckN
   put 0 into sZoom
   put 0 into sZoomF
   Int.Build
   Int.StartLevel 1
end Game.OnStart

on Int.Build
   local i
   Mesh.Define "Int.Car", Int.CarMesh(44, 84)
   Mesh.Define "Int.Enemy", Int.CarMesh(46, 86)
   Mesh.Define "Int.Civ", Int.CarMesh(40, 76)
   Mesh.Define "Int.Truck", Int.TruckMesh()
   Mesh.Define "Int.Boat", Int.BoatMesh()
   Mesh.Define "Int.Heli", Int.HeliMesh()
   Mesh.Define "Int.Rotor", Int.RotorMesh()
   Mesh.Define "Int.Shot", Mesh.Box(4, 14, 4)
   Mesh.Define "Int.Missile", Mesh.Pyramid(3, 6, 22)
   Mesh.Define "Int.Bomb", Mesh.Box(12, 12, 12)
   Mesh.Define "Int.Oil", Mesh.Prism(7, 26, 2)
   Mesh.Define "Int.Slice", Int.SliceMesh(false)
   Mesh.Define "Int.Wave", Int.SliceMesh(true)
   put empty into sSlice
   repeat with i = 0 to kSlices
      put Entity.Spawn("Int.Slice", 0, 0, kZ, "200,200,210") into sSlice[i]
      put Entity.Spawn("Int.Wave", 0, -900, kZ, "40,140,255") into sSliceWet[i]
   end repeat
   put Entity.Spawn("Int.Car", 0, kCarY, kZ, "0,230,255") into sCar
   put Entity.Spawn("Int.Boat", 0, -900, kZ, "0,230,255") into sBoat
   put Entity.Spawn("Int.Heli", 0, -900, kZ - 60, "150,150,160") into sHeli
   put Entity.Spawn("Int.Rotor", 0, -900, kZ - 74, "200,200,210") into sRotor
end Int.Build

function Int.CarMesh pW, pH
   local tM
   put Mesh.New() into tM
   Int.AddBox tM, 0, 0, 0, pW, pH, 16
   Int.AddBox tM, 0, pH * 0.08, -6, pW * 0.7, pH * 0.4, 8
   Int.AddBox tM, -pW / 2 - 3, -pH * 0.3, 4, 8, 18, 8
   Int.AddBox tM, pW / 2 + 3, -pH * 0.3, 4, 8, 18, 8
   Int.AddBox tM, -pW / 2 - 3, pH * 0.3, 4, 8, 18, 8
   Int.AddBox tM, pW / 2 + 3, pH * 0.3, 4, 8, 18, 8
   return tM
end Int.CarMesh

function Int.TruckMesh
   local tM
   put Mesh.New() into tM
   Int.AddBox tM, 0, -40, 0, 50, 30, 18
   Int.AddBox tM, 0, 25, -4, 60, 100, 26
   return tM
end Int.TruckMesh

function Int.BoatMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -50, 0
   Mesh.AddVertex tM, 24, -10, 0
   Mesh.AddVertex tM, 24, 45, 0
   Mesh.AddVertex tM, -24, 45, 0
   Mesh.AddVertex tM, -24, -10, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 4, 5
   Mesh.AddLine tM, 5, 1
   Int.AddBox tM, 0, 15, -6, 30, 30, 10
   return tM
end Int.BoatMesh

function Int.HeliMesh
   local tM
   put Mesh.New() into tM
   Int.AddBox tM, 0, 0, 0, 34, 50, 20
   Int.AddBox tM, 0, 50, 0, 6, 50, 6
   return tM
end Int.HeliMesh

-- the rotor is its own thing: it spins, the body doesn't (owner, 16 Nov)
function Int.RotorMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -70, -70, 0
   Mesh.AddVertex tM, 70, 70, 0
   Mesh.AddVertex tM, -70, 70, 0
   Mesh.AddVertex tM, 70, -70, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   return tM
end Int.RotorMesh

on Int.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Int.AddBox

-- a slice of road (edges, lane dashes) or of water (ripples)
function Int.SliceMesh pWet
   local tM, i
   put Mesh.New() into tM
   if pWet then
      repeat with i = -2 to 2
         Mesh.AddVertex tM, i * 110 - 30, 20 + (i mod 2) * 20, 0
         Mesh.AddVertex tM, i * 110, 12 + (i mod 2) * 20, 0
         Mesh.AddVertex tM, i * 110 + 30, 20 + (i mod 2) * 20, 0
         Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
         Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      end repeat
      return tM
   end if
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, -kHalfW, kSliceGap, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, kSliceGap, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   repeat with i = -1 to 1 step 2
      Mesh.AddVertex tM, i * kHalfW / 3, 10, 0
      Mesh.AddVertex tM, i * kHalfW / 3, 35, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Int.SliceMesh

function Int.RoadX pW
   return (50 + sLevel * 20) * sin(pW / 900) + 30 * sin(pW / 330)
end Int.RoadX

-- Spark's table: scroll speed | enemies at once
on Int.StartLevel pLevel
   local tRow, tK
   put pLevel into sLevel
   put line pLevel of ("120,5" & cr & "140,5" & cr & "160,5" & cr & "180,5" & cr & "200,5") into tRow
   put (item 1 of tRow) / 24 into sScroll
   put 9000 + pLevel * 1500 into sStageLen
   put 0 into sDist
   put Int.RoadX(0) into sX
   put 0 into sVX
   put 30 into sHurt
   put 0 into sGunWait
   put false into sWet
   put 0 into sBombWait
   put -1 into sHeliX
   repeat for each key tK in sThing
      Entity.Kill sThing[tK]["key"]
   end repeat
   put empty into sThing
   put 0 into sThingN
   repeat for each key tK in sShot
      Entity.Kill sShot[tK]["key"]
   end repeat
   put empty into sShot
   put 0 into sShotN
   put 400 into sNextSpawn
   Entity.SetPosition sBoat, 0, -900, kZ
   put empty into sHUDWas
end Int.StartLevel

function Int.ScreenY pW
   return kCarY - (pW - sDist)
end Int.ScreenY

function Int.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Int.Keys

on Int.TestKeys pKeys
   put pKeys into sTestKeys
end Int.TestKeys

on Int.TestDist pD
   put pD into sDist
   put pD into sNextSpawn
end Int.TestDist

on Int.TestLives pN
   put pN into sLives
end Int.TestLives

function Int.Down pCode, pKeys
   return pCode is among the items of pKeys
end Int.Down

function Int.Pressed pCode, pKeys
   return pCode is among the items of pKeys and not (pCode is among the items of sKeysWas)
end Int.Pressed

on Game.OnUpdate
   local tKeys, tW, tCX, i, tFrac, tWetAt
   put Int.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Int.Pressed(32, tKeys) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         put 0 into sTruckN
         put empty into sSpecial
         Int.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   Int.Zoom tKeys
   put sScroll into tW
   if Int.Down(65362, tKeys) or Int.Down(119, tKeys) then put sScroll * 1.5 into tW
   if Int.Down(65364, tKeys) or Int.Down(115, tKeys) then put sScroll * 0.6 into tW
   add tW to sDist
   if Int.Down(65361, tKeys) or Int.Down(97, tKeys) then subtract 1.7 from sVX
   if Int.Down(65363, tKeys) or Int.Down(100, tKeys) then add 1.7 to sVX
   put sVX * 0.82 into sVX
   add sVX to sX
   -- weapons
   if sGunWait > 0 then subtract 1 from sGunWait
   if Int.Down(32, tKeys) and sGunWait <= 0 then
      Int.Fire "gun", sX, 0
      put 5 into sGunWait
   end if
   if (Int.Pressed(120, tKeys) or Int.Pressed(65505, tKeys) or Int.Pressed(65506, tKeys)) and sAmmo > 0 then
      subtract 1 from sAmmo
      if sSpecial is "missiles" then
         Int.Fire "missile", sX, 0
      else
         Int.AddThing "oil", "Int.Oil", sX, sDist - 70, 0, "255,150,0"
      end if
      if sAmmo <= 0 then put empty into sSpecial
      put empty into sHUDWas
   end if
   put tKeys into sKeysWas
   if sHurt > 0 then subtract 1 from sHurt
   -- the road's end is water: the car becomes a boat
   put sStageLen - kWaterLen into tWetAt
   if not sWet and sDist >= tWetAt then
      put true into sWet
      FX.Sparks sX, kCarY, kZ, 16, "40,140,255"
      Entity.SetPosition sCar, 0, -900, kZ
      put empty into sHUDWas
   end if
   put Int.RoadX(sDist) into tCX
   if abs(sX - tCX) > kHalfW - 16 and not sWet then
      Int.Hurt
      put tCX into sX
      put 0 into sVX
   end if
   put max(tCX - kHalfW - 40, min(tCX + kHalfW + 40, sX)) into sX
   if sWet then
      Entity.SetPosition sBoat, sX, kCarY + 6 * sin(sTicks / 5), kZ
      Entity.SetRotation sBoat, 0, 0, sVX * 0.05
   else
      Entity.SetPosition sCar, sX, kCarY, kZ
      Entity.SetRotation sCar, 0, 0, sVX * 0.04
   end if
   -- road slices, water slices past the road's end
   put sDist mod kSliceGap into tFrac
   repeat with i = 0 to kSlices
      put sDist - 140 + i * kSliceGap - tFrac into tW
      if tW < tWetAt then
         Entity.SetPosition sSlice[i], Int.RoadX(tW), Int.ScreenY(tW) - kSliceGap, kZ
         Entity.SetPosition sSliceWet[i], 0, -900, kZ
      else
         Entity.SetPosition sSlice[i], 0, -900, kZ
         Entity.SetPosition sSliceWet[i], Int.RoadX(tW), Int.ScreenY(tW) - kSliceGap, kZ
      end if
   end repeat
   if sDist >= sNextSpawn and sDist < tWetAt - 300 then
      Int.Spawn
      put sDist + max(110, 700 / (2 + sLevel)) + random(160) into sNextSpawn
   end if
   Int.Helicopter
   Int.Shots
   Int.Things
   if sDist >= sStageLen then
      add 500 * sLevel to sScore
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
      else
         Int.StartLevel sLevel + 1
      end if
   end if
   Int.ShowHUD
end Game.OnUpdate

on Int.Spawn
   local tN, tW, tCX, tX, tEnemies, tK
   put 0 into tEnemies
   repeat for each key tK in sThing
      if sThing[tK]["kind"] is "enemy" then add 1 to tEnemies
   end repeat
   put random(100) into tN
   put Int.RoadX(sDist + 600) into tCX
   put tCX + random(2 * kHalfW - 100) - kHalfW + 50 into tX
   if tN <= 45 and tEnemies < 5 then
      -- half come up from behind, faster than you
      if random(2) is 1 then
         Int.AddThing "enemy", "Int.Enemy", tX, sDist + 600, sScroll * 0.5, "255,60,60"
      else
         Int.AddThing "enemy", "Int.Enemy", tX, sDist - 270, sScroll * 1.4, "255,60,60"
      end if
   else if tN <= 80 then
      Int.AddThing "civ", "Int.Civ", tX, sDist + 600, sScroll * (0.4 + random(30) / 100), "235,235,235"
   else if tN <= 90 and sSpecial is empty then
      Int.AddThing "truck", "Int.Truck", tX, sDist + 600, sScroll * 0.55, "255,150,0"
   end if
   -- from level 2 the helicopter comes now and then
   if sLevel >= 2 and sHeliX < 0 and random(6) is 1 then
      put tCX into sHeliX
      put 0 into sBombWait
   end if
end Int.Spawn

on Int.AddThing pKind, pMesh, pX, pW, pV, pColor
   add 1 to sThingN
   put pKind into sThing[sThingN]["kind"]
   put pX into sThing[sThingN]["x"]
   put pW into sThing[sThingN]["w"]
   put pV into sThing[sThingN]["v"]
   put 0 into sThing[sThingN]["vx"]
   put 0 into sThing[sThingN]["spin"]
   put Entity.Spawn(pMesh, pX, Int.ScreenY(pW), kZ, pColor) into sThing[sThingN]["key"]
end Int.AddThing

on Int.Fire pKind, pX, pDummy
   add 1 to sShotN
   put pKind into sShot[sShotN]["kind"]
   put pX into sShot[sShotN]["x"]
   put kCarY - 50 into sShot[sShotN]["y"]
   put 0 into sShot[sShotN]["vx"]
   if pKind is "gun" then
      put Entity.Spawn("Int.Shot", pX, kCarY - 50, kZ, "255,255,120") into sShot[sShotN]["key"]
   else
      put Entity.Spawn("Int.Missile", pX, kCarY - 50, kZ, "255,120,255") into sShot[sShotN]["key"]
      Entity.SetRotation sShot[sShotN]["key"], -1.5708, 0, 0
   end if
end Int.Fire

-- the helicopter crosses above, dropping bombs where you are
on Int.Helicopter
   local tY
   if sHeliX < 0 then
      Entity.SetPosition sHeli, 0, -900, kZ - 60
      Entity.SetPosition sRotor, 0, -900, kZ - 74
      put empty into sHeliY
      exit Int.Helicopter
   end if
   add max(-3, min(3, (sX - sHeliX) * 0.03)) to sHeliX
   put -180 + 20 * sin(sTicks / 20) into tY
   put tY into sHeliY
   Entity.SetPosition sHeli, sHeliX, tY, kZ - 60
   Entity.SetPosition sRotor, sHeliX, tY, kZ - 74
   Entity.SetRotation sRotor, 0, 0, sTicks / 2
   subtract 1 from sBombWait
   if sBombWait <= 0 then
      Int.AddThing "bomb", "Int.Bomb", sHeliX, sDist + (kCarY - tY), 0, "255,40,40"
      put 40 into sThing[sThingN]["fuse"]
      put 70 - sLevel * 6 into sBombWait
   end if
   -- it leaves after a while
   if random(400) is 1 then put -1 into sHeliX
end Int.Helicopter

on Int.Shots
   local tS, tT, tHit, tR
   repeat for each key tS in sShot
      if sShot[tS]["kind"] is "gun" then
         subtract 18 from sShot[tS]["y"]
      else
         subtract 12 from sShot[tS]["y"]
         Int.Seek tS
         if tS is not among the keys of sShot then next repeat     -- it hit the helicopter
      end if
      put false into tHit
      repeat for each key tT in sThing
         if sThing[tT]["kind"] is not among the items of "enemy,civ" then next repeat
         if abs(Int.ScreenY(sThing[tT]["w"]) - sShot[tS]["y"]) < 44 and abs(sThing[tT]["x"] - sShot[tS]["x"]) < 26 then
            put true into tHit
            if sShot[tS]["kind"] is "missile" then
               -- a missile blasts a circle
               FX.Sparks sShot[tS]["x"], sShot[tS]["y"], kZ, 24, "255,120,255"
               repeat for each key tR in sThing
                  if sThing[tR]["kind"] is among the items of "enemy,civ" and abs(sThing[tR]["x"] - sShot[tS]["x"]) < 110 and abs(Int.ScreenY(sThing[tR]["w"]) - sShot[tS]["y"]) < 110 then Int.Destroy tR
               end repeat
            else
               Int.Destroy tT
            end if
            exit repeat
         end if
      end repeat
      if tHit or sShot[tS]["y"] < -330 then
         Entity.Kill sShot[tS]["key"]
         delete variable sShot[tS]
      else
         Entity.SetPosition sShot[tS]["key"], sShot[tS]["x"], sShot[tS]["y"], kZ
      end if
   end repeat
end Int.Shots

-- a missile seeks heat: it turns after the nearest red car ahead of it, or the helicopter
on Int.Seek pS
   local tT, tBest, tBestD, tD, tTX, tTY, tX, tY
   put sShot[pS]["x"] into tX
   put sShot[pS]["y"] into tY
   put 99999 into tBestD
   put empty into tBest
   repeat for each key tT in sThing
      if sThing[tT]["kind"] is not "enemy" then next repeat
      put Int.ScreenY(sThing[tT]["w"]) into tTY
      if tTY > tY + 20 then next repeat                -- behind it
      put abs(sThing[tT]["x"] - tX) + (tY - tTY) into tD
      if tD < tBestD then
         put tD into tBestD
         put sThing[tT]["x"] into tTX
         put "car" into tBest
      end if
   end repeat
   if sHeliX >= 0 and sHeliY is not empty and sHeliY < tY + 20 then
      put abs(sHeliX - tX) + (tY - sHeliY) into tD
      if tD < tBestD then
         put tD into tBestD
         put sHeliX into tTX
         put "heli" into tBest
      end if
   end if
   if tBest is not empty then
      add max(-1.2, min(1.2, (tTX - tX) * 0.05)) to sShot[pS]["vx"]
   end if
   put max(-9, min(9, sShot[pS]["vx"] * 0.9)) into sShot[pS]["vx"]
   add sShot[pS]["vx"] to sShot[pS]["x"]
   -- the helicopter: a missile brings it down
   if sHeliX >= 0 and sHeliY is not empty and abs(sShot[pS]["x"] - sHeliX) < 40 and abs(sShot[pS]["y"] - sHeliY) < 40 then
      FX.Sparks sHeliX, sHeliY, kZ - 60, 30, "255,120,255"
      add 500 to sScore
      put -1 into sHeliX
      put empty into sHeliY
      Entity.SetPosition sHeli, 0, -900, kZ - 60
      Entity.SetPosition sRotor, 0, -900, kZ - 74
      Entity.Kill sShot[pS]["key"]
      delete variable sShot[pS]
      put empty into sHUDWas
   end if
end Int.Seek

on Int.Destroy pT
   if sThing[pT]["kind"] is "civ" then
      subtract 200 from sScore
   else
      add 150 to sScore
   end if
   FX.Sparks sThing[pT]["x"], Int.ScreenY(sThing[pT]["w"]), kZ, 14, "255,200,60"
   Entity.Kill sThing[pT]["key"]
   delete variable sThing[pT]
   put empty into sHUDWas
end Int.Destroy

on Int.Things
   local tT, tR, tY, tDX, tDY, tCX
   repeat for each key tT in sThing
      if sThing[tT] is empty then next repeat     -- blown up by a missile this step
      switch sThing[tT]["kind"]
         case "enemy"
            if sThing[tT]["spin"] > 0 then
               subtract 1 from sThing[tT]["spin"]
               Entity.SetRotation sThing[tT]["key"], 0, 0, sThing[tT]["spin"] / 3
               if sThing[tT]["spin"] is 0 then
                  Int.Destroy tT
                  next repeat
               end if
            else if abs(sThing[tT]["w"] - sDist) < 350 then
               -- they come at you
               add max(-0.4, min(0.4, (sX - sThing[tT]["x"]) * 0.01)) to sThing[tT]["vx"]
            end if
            -- oil spins them out
            repeat for each key tR in sThing
               if sThing[tR]["kind"] is "oil" and abs(sThing[tR]["w"] - sThing[tT]["w"]) < 50 and abs(sThing[tR]["x"] - sThing[tT]["x"]) < 40 and sThing[tT]["spin"] is 0 then put 24 into sThing[tT]["spin"]
            end repeat
            break
         case "bomb"
            subtract 1 from sThing[tT]["fuse"]
            Entity.SetRotation sThing[tT]["key"], sTicks / 4, sTicks / 3, 0
            if sThing[tT]["fuse"] <= 0 then
               FX.Sparks sThing[tT]["x"], Int.ScreenY(sThing[tT]["w"]), kZ, 20, "255,80,40"
               if abs(sThing[tT]["x"] - sX) < 60 and abs(sThing[tT]["w"] - sDist) < 60 then Int.Hurt
               Entity.Kill sThing[tT]["key"]
               delete variable sThing[tT]
               next repeat
            end if
            break
      end switch
      add sThing[tT]["v"] to sThing[tT]["w"]
      add sThing[tT]["vx"] to sThing[tT]["x"]
      put sThing[tT]["vx"] * 0.92 into sThing[tT]["vx"]
      put Int.RoadX(sThing[tT]["w"]) into tCX
      if sThing[tT]["kind"] is among the items of "civ,truck" then
         put max(tCX - kHalfW + 30, min(tCX + kHalfW - 30, sThing[tT]["x"])) into sThing[tT]["x"]
      end if
      put sThing[tT]["x"] - sX into tDX
      put sThing[tT]["w"] - sDist into tDY
      if abs(tDX) < 46 and abs(tDY) < 86 and not sWet then
         switch sThing[tT]["kind"]
            case "enemy"
               if abs(sVX) > 2.5 and abs(tDY) < 60 then
                  Int.Destroy tT                     -- rammed from the side
                  next repeat
               end if
               Int.Hurt
               Int.Destroy tT
               next repeat
            case "civ"
               put Int.Sign(tDX) * 5 into sThing[tT]["vx"]
               put -Int.Sign(tDX) * 4 into sVX
               break
            case "truck"
               if tDY > 30 then
                  -- into its back: a weapon
                  add 1 to sTruckN
                  if sTruckN mod 2 is 1 then
                     put "missiles" into sSpecial
                     put 8 into sAmmo
                  else
                     put "oil" into sSpecial
                     put 5 into sAmmo
                  end if
                  add 100 to sScore
                  FX.Sparks sThing[tT]["x"], Int.ScreenY(sThing[tT]["w"]), kZ, 14, "255,150,0"
                  Entity.Kill sThing[tT]["key"]
                  delete variable sThing[tT]
                  put empty into sHUDWas
                  next repeat
               end if
               break
         end switch
      end if
      put Int.ScreenY(sThing[tT]["w"]) into tY
      if tY > 480 or tY < -700 or abs(sThing[tT]["x"] - tCX) > kHalfW + 80 then
         if sThing[tT]["kind"] is "enemy" and abs(sThing[tT]["x"] - tCX) > kHalfW + 80 then add 150 to sScore   -- off the road
         Entity.Kill sThing[tT]["key"]
         delete variable sThing[tT]
         next repeat
      end if
      Entity.SetPosition sThing[tT]["key"], sThing[tT]["x"], tY, kZ
   end repeat
end Int.Things

-- the eye comes nearer the car, a step at a time (mouse wheel, or + and -), and follows it
on Int.Zoom pKeys
   local tT, tX, tY
   if (Int.Pressed(61, pKeys) or Int.Pressed(43, pKeys) or Int.Pressed(65451, pKeys)) then Int.ZoomStep 1
   if (Int.Pressed(45, pKeys) or Int.Pressed(95, pKeys) or Int.Pressed(65453, pKeys)) then Int.ZoomStep -1
   put sZoomF + (sZoom * 0.15 - sZoomF) * 0.2 into sZoomF
   if abs(sZoomF - sZoom * 0.15) < 0.002 then put sZoom * 0.15 into sZoomF
   if sZoomF is 0 then
      Camera.SetPosition 0, 0, 0
      exit Int.Zoom
   end if
   put sZoomF / (kZoomMax * 0.15) into tT
   put sX * tT into tX
   put (kCarY - 60) * tT into tY
   Camera.SetPosition tX, tY, kZ * sZoomF
end Int.Zoom

on Int.ZoomStep pBy
   put max(0, min(kZoomMax, sZoom + pBy)) into sZoom
end Int.ZoomStep

-- the mouse wheel comes as a key: 65309 up (nearer), 65308 down (back out)
on rawKeyDown pKey
   if pKey is 65309 then
      Int.ZoomStep 1
      exit rawKeyDown
   end if
   if pKey is 65308 then
      Int.ZoomStep -1
      exit rawKeyDown
   end if
   pass rawKeyDown
end rawKeyDown

function Int.Zoomed
   return sZoom & "," & round(sZoomF, 3)
end Int.Zoomed

function Int.ShotX
   local tS, tOut
   repeat for each key tS in sShot
      put round(sShot[tS]["x"]) & "," after tOut
   end repeat
   return char 1 to -2 of tOut
end Int.ShotX

on Int.TestSpecial pKind, pAmmo
   put pKind into sSpecial
   put pAmmo into sAmmo
end Int.TestSpecial

on Int.TestHeli pX
   put pX into sHeliX
   put 999 into sBombWait
end Int.TestHeli

function Int.HeliX
   return sHeliX
end Int.HeliX

function Int.TestRotation pWhich
   if pWhich is "rotor" then return Entity.GetRotation(sRotor)
   return Entity.GetRotation(sHeli)
end Int.TestRotation

on Int.TestThing pKind, pX, pAhead
   if pKind is "enemy" then
      Int.AddThing "enemy", "Int.Enemy", pX, sDist + pAhead, sScroll, "255,60,60"
   else
      Int.AddThing "civ", "Int.Civ", pX, sDist + pAhead, sScroll, "235,235,235"
   end if
end Int.TestThing

function Int.Sign pN
   if pN < 0 then return -1
   return 1
end Int.Sign

on Int.Hurt
   if sHurt > 0 then exit Int.Hurt
   subtract 1 from sLives
   put 45 into sHurt
   FX.Sparks sX, kCarY, kZ, 18, "255,80,80"
   put empty into sHUDWas
   if sLives <= 0 then put true into sOver
end Int.Hurt

on Int.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & sSpecial & sAmmo & "|" & sWet into tWords
   if tWords is sHUDWas then exit Int.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Int.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel & "/5", 20, 40, 14
   if sOver and sWon then
      put "MISSION COMPLETE.  SPACE TO RUN AGAIN" into tLine
   else if sOver then
      put "INTERCEPTOR DOWN.  SPACE TO RUN AGAIN" into tLine
   else if sWet then
      put "WATER AHEAD: BOAT MODE" into tLine
   else if sSpecial is not empty then
      put "X:" && toUpper(sSpecial) && sAmmo into tLine
   else
      put "SPACE: GUN.  DRIVE INTO AN ORANGE TRUCK FOR A WEAPON" into tLine
   end if
   HUD.Set "Int.Msg", tLine, 20, 70, 12
end Int.ShowHUD

function Int.State
   return sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "|d " & round(sDist) & "/" & sStageLen & "|" & sSpecial & sAmmo & "|wet " & sWet & "|things " & the number of lines of the keys of sThing & "|" & sOver
end Int.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
