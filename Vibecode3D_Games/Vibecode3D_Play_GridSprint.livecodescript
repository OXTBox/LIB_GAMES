######################################################################################
## CARD SCRIPT: "Play.GridSprint"   GRID SPRINT  (11 14 2026)
## A wireframe road curves away to the horizon. Drive one qualifying lap alone: your time
## sets your place on the grid. Then race seven rivals over two laps. Spark's concept and
## level numbers (LIB_SPARK/arcade/out/124_Grid_Sprint), script by Claude.
## CONTROLS  Left/Right (or A/D): steer    Up (or W): gas    Down (or S): brake
##           Shift (or G): low/high gear    Space: start the race    Escape: pause
## RULES     low gear pulls hard but tops out early; high gear is twice as fast but slow
##           to wind up. Curves push you to the outside. Red signs stand just off the
##           road on the curves: hit one and you spin out, lose a life and restart at the
##           last green gate. The gate timer runs down; each gate fills it again; if it
##           runs out you lose a life. Finish first to go to the next level (5 levels).
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sCar, sRail, sSlice, sSign, sSignPool, sRival, sGate, sMount
local sDist, sOff, sSpeed, sGear, sHeading, sSpin, sCheckDist, sTime, sPhase, sPhaseT
local sCurve, sSecN, sLapLen, sLap, sPlace, sQualT
local sLevel, sLives, sScore, sKeysWas, sTestKeys, sHUDWas, sTicks

constant kGroundY = 90       -- +Y is down: the road is below the eye
constant kCarZ = 320
constant kGap = 200          -- road slices
constant kSlices = 18
constant kHalfW = 180        -- the road's half width
constant kSec = 1600         -- one track section
constant kStartLine = 2000   -- where the finish gate stands on the track
constant kLaps = 2
constant kLowTop = 20
constant kHighTop = 40

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 0 into sTicks
   Grid.StartLevel 1
end Game.OnStart

-- Spark's table: rival speed | curves | lives
on Grid.StartLevel pLevel
   local tRow, i
   put pLevel into sLevel
   put line pLevel of ("120,1,3" & cr & "140,2,3" & cr & "160,3,3" & cr & "180,4,2" & cr & "200,5,2") into tRow
   if pLevel is 1 or sLives > item 3 of tRow or sLives is empty then put item 3 of tRow into sLives
   Scene.ClearAll
   Grid.BuildTrack item 2 of tRow
   Mesh.Define "Grid.Car", Grid.CarMesh()
   Mesh.Define "Grid.Rail", Grid.RailMesh()
   Mesh.Define "Grid.Sign", MeshBox(40, 60, 6)
   Mesh.Define "Grid.Rival", MeshBox(80, 40, 120)
   Mesh.Define "Grid.Gate", Grid.GateMesh()
   Mesh.Define "Grid.Mount", MeshPyramid(4, 3200, 1600)
   put empty into sRail
   repeat with i = 0 to kSlices
      put Entity.Spawn("Grid.Rail", 0, kGroundY, kCarZ + i * kGap, "255,190,0") into sRail[i]
   end repeat
   repeat with i = 1 to 5
      put Entity.Spawn("Grid.Mount", i * 3000, kGroundY - 800, 12000, "80,90,160") into sMount[i]
   end repeat
   repeat with i = 1 to 8
      put Entity.Spawn("Grid.Sign", 0, kGroundY - 30, -3000, "255,60,60") into sSignPool[i]
   end repeat
   put Entity.Spawn("Grid.Gate", 0, kGroundY, -3000, "0,255,120") into sGate
   put Entity.Spawn("Grid.Car", 0, kGroundY - 17, kCarZ, "0,230,255") into sCar
   put empty into sRival
   repeat with i = 1 to 7
      put Entity.Spawn("Grid.Rival", 0, kGroundY - 20, -3000, "255,140,0") into sRival[i]["key"]
   end repeat
   put 0 into sHeading
   Grid.Begin "qual"
end Grid.StartLevel

-- the track: sections of curve, the same every time for a level
on Grid.BuildTrack pCurves
   local i, tN, tMag, tPick
   put 8 + pCurves * 2 into sSecN
   put sSecN * kSec into sLapLen
   put empty into sCurve
   repeat with i = 1 to sSecN
      put 0 into sCurve[i]
   end repeat
   set the randomSeed to 4100 + sLevel
   put 0.9 + sLevel * 0.55 into tMag
   put 0 into tN
   repeat while tN < pCurves * 2
      put 2 + random(sSecN - 3) into tPick       -- never the first two or the last section
      if sCurve[tPick] is not 0 then next repeat
      put tMag * (random(2) * 2 - 3) * (0.7 + random(6) / 10) into sCurve[tPick]
      add 1 to tN
   end repeat
   -- red signs on the outside of every curve
   put empty into sSign
   put 0 into tN
   repeat with i = 1 to sSecN
      if sCurve[i] is 0 then next repeat
      repeat with tPick = 0 to 3
         add 1 to tN
         put (i - 1) * kSec + 200 + tPick * 400 into sSign[tN]["d"]
         if sCurve[i] > 0 then
            put -(kHalfW + 55) into sSign[tN]["off"]
         else
            put kHalfW + 55 into sSign[tN]["off"]
         end if
      end repeat
   end repeat
   set the randomSeed to the milliseconds
end Grid.BuildTrack

function Grid.CurveAt pD
   local tD
   put pD mod sLapLen into tD
   if tD < 0 then add sLapLen to tD
   return sCurve[tD div kSec + 1]
end Grid.CurveAt

-- a road slice: the line across and a kerb post at each end
function Grid.RailMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddVertex tM, -kHalfW, -22, 0
   Mesh.AddVertex tM, kHalfW, -22, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 1, 3
   Mesh.AddLine tM, 2, 4
   return tM
end Grid.RailMesh

-- the car: a low body and a cabin, seen from behind
function Grid.CarMesh
   local tM
   put Mesh.New() into tM
   Grid.AddBox tM, 0, 5, 0, 100, 24, 150
   Grid.AddBox tM, 0, -16, 10, 70, 18, 70
   return tM
end Grid.CarMesh

on Grid.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i, tSX, tSY, tSZ
   put pM["count"] into tB
   repeat with i = 0 to 7
      put (i mod 2) * 2 - 1 into tSX
      put ((i div 2) mod 2) * 2 - 1 into tSY
      put (i div 4) * 2 - 1 into tSZ
      Mesh.AddVertex pM, pX + tSX * pW / 2, pY + tSY * pH / 2, pZ + tSZ * pD / 2
   end repeat
   Mesh.AddLine pM, tB + 1, tB + 2
   Mesh.AddLine pM, tB + 3, tB + 4
   Mesh.AddLine pM, tB + 5, tB + 6
   Mesh.AddLine pM, tB + 7, tB + 8
   Mesh.AddLine pM, tB + 1, tB + 3
   Mesh.AddLine pM, tB + 2, tB + 4
   Mesh.AddLine pM, tB + 5, tB + 7
   Mesh.AddLine pM, tB + 6, tB + 8
   Mesh.AddLine pM, tB + 1, tB + 5
   Mesh.AddLine pM, tB + 2, tB + 6
   Mesh.AddLine pM, tB + 3, tB + 7
   Mesh.AddLine pM, tB + 4, tB + 8
end Grid.AddBox

function Grid.GateMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -kHalfW - 20, 0, 0
   Mesh.AddVertex tM, -kHalfW - 20, -150, 0
   Mesh.AddVertex tM, kHalfW + 20, -150, 0
   Mesh.AddVertex tM, kHalfW + 20, 0, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   return tM
end Grid.GateMesh

-- "qual": a lap alone.  "grid": waiting for Space.  "race": two laps.  "done", "over".
on Grid.Begin pPhase
   local i, tSlot
   put pPhase into sPhase
   put 0 into sPhaseT
   put empty into sHUDWas
   switch pPhase
      case "qual"
         put kStartLine - 1200 into sDist
         put 14 into sSpeed
         put 0 into sOff
         put "low" into sGear
         put 0 into sSpin
         put sDist into sCheckDist
         put Grid.FullTime() into sTime
         repeat with i = 1 to 7
            put -99999 into sRival[i]["d"]
         end repeat
         break
      case "grid"
         put kStartLine - (sPlace - 1) * 260 - 150 into sDist
         put 0 into sSpeed
         put 0 into sOff
         put "low" into sGear
         put 0 into sSpin
         put sDist into sCheckDist
         put Grid.FullTime() into sTime
         put 0 into sLap
         -- the rivals take the other seven slots
         put 0 into tSlot
         repeat with i = 1 to 7
            add 1 to tSlot
            if tSlot is sPlace then add 1 to tSlot
            put kStartLine - (tSlot - 1) * 260 - 150 into sRival[i]["d"]
            put ((tSlot mod 2) * 2 - 1) * 70 into sRival[i]["off"]
            put (100 + sLevel * 20) / 6 * (0.78 + i * 0.03) into sRival[i]["top"]
            put 0 into sRival[i]["v"]
         end repeat
         break
   end switch
end Grid.Begin

function Grid.FullTime
   return 300 - sLevel * 10
end Grid.FullTime

function Grid.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Grid.Keys

on Grid.TestKeys pKeys
   put pKeys into sTestKeys
end Grid.TestKeys

function Grid.Down pCode, pKeys
   return pCode is among the items of pKeys
end Grid.Down

function Grid.Pressed pCode, pKeys
   return pCode is among the items of pKeys and not (pCode is among the items of sKeysWas)
end Grid.Pressed

on Game.OnUpdate
   local tKeys
   put Grid.Keys() into tKeys
   add 1 to sTicks
   add 1 to sPhaseT
   switch sPhase
      case "over"
         if Grid.Pressed(32, tKeys) then
            put 0 into sScore
            put empty into sLives
            Grid.StartLevel 1
         end if
         break
      case "done"
         if Grid.Pressed(32, tKeys) then
            if sPlace is 1 and sLevel < 5 then
               Grid.StartLevel sLevel + 1
            else if sPlace is 1 then
               Grid.StartLevel 1
            else
               Grid.StartLevel sLevel
            end if
         end if
         break
      case "grid"
         Grid.Rivals false
         if Grid.Pressed(32, tKeys) then Grid.Begin "race"
         break
      default
         Grid.Drive tKeys
         if sPhase is "race" then Grid.Rivals true
   end switch
   put tKeys into sKeysWas
   Grid.DrawRoad
   Grid.ShowHUD
end Game.OnUpdate

on Grid.Drive pKeys
   local tC, tSteer, tWas
   -- gears and pedals
   if Grid.Pressed(65505, pKeys) or Grid.Pressed(65506, pKeys) or Grid.Pressed(103, pKeys) then
      if sGear is "low" then
         put "high" into sGear
      else
         put "low" into sGear
      end if
   end if
   if sSpin > 0 then
      subtract 1 from sSpin
      put sSpeed * 0.85 into sSpeed
   else if Grid.Down(65362, pKeys) or Grid.Down(119, pKeys) then
      if sGear is "low" then
         if sSpeed < kLowTop then
            put min(kLowTop, sSpeed + 0.9) into sSpeed
         else
            put max(kLowTop, sSpeed - 0.5) into sSpeed
         end if
      else
         if sSpeed < 14 then
            add 0.12 to sSpeed                   -- high gear bogs down from a stand
         else
            add 0.3 to sSpeed
         end if
         put min(kHighTop, sSpeed) into sSpeed
      end if
   else if Grid.Down(65364, pKeys) or Grid.Down(115, pKeys) then
      put max(0, sSpeed - 1.5) into sSpeed
   else
      put max(0, sSpeed - 0.15) into sSpeed
   end if
   -- steering, and the curve pushing you out
   put 3 + sSpeed * 0.12 into tSteer
   if sSpin <= 0 then
      if Grid.Down(65361, pKeys) or Grid.Down(97, pKeys) then subtract tSteer from sOff
      if Grid.Down(65363, pKeys) or Grid.Down(100, pKeys) then add tSteer to sOff
   end if
   put Grid.CurveAt(sDist) into tC
   subtract tC * sSpeed * 0.022 from sOff
   add tC * sSpeed * 0.0004 to sHeading
   put max(-kHalfW - 160, min(kHalfW + 160, sOff)) into sOff
   if abs(sOff) > kHalfW then put sSpeed * 0.96 into sSpeed     -- the dirt slows you
   -- move on
   put sDist into tWas
   add sSpeed to sDist
   if sSpin <= 0 then Grid.CheckSigns tWas
   -- gates: every quarter lap
   if (tWas - kStartLine) div (sLapLen / 4) < (sDist - kStartLine) div (sLapLen / 4) and tWas >= kStartLine - 10 then
      put Grid.FullTime() into sTime
      put sDist into sCheckDist
      FX.Sparks 0, kGroundY - 80, kCarZ + 200, 10, "0,255,120"
      if (sDist - kStartLine) div sLapLen > (tWas - kStartLine) div sLapLen then Grid.Lap
      put empty into sHUDWas
   else
      subtract 1 from sTime
      if sTime <= 0 then Grid.Crash "time"
   end if
end Grid.Drive

on Grid.CheckSigns pWas
   local tK, tD, tA, tB
   put pWas mod sLapLen into tA
   put tA + (sDist - pWas) into tB
   repeat for each key tK in sSign
      put sSign[tK]["d"] into tD
      if tD < tA then add sLapLen to tD
      if tD >= tA and tD < tB and abs(sOff - sSign[tK]["off"]) < 60 then
         Grid.Crash "sign"
         exit Grid.CheckSigns
      end if
   end repeat
end Grid.CheckSigns

on Grid.Crash pWhy
   FX.Sparks 0, kGroundY - 20, kCarZ, 20, "255,80,80"
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put "over" into sPhase
      exit Grid.Crash
   end if
   put sCheckDist into sDist
   put 0 into sOff
   put "low" into sGear
   put Grid.FullTime() into sTime
   if pWhy is "sign" then put 24 into sSpin
end Grid.Crash

on Grid.Lap
   local i, tAhead
   add 10 to sScore
   if sPhase is "qual" then
      -- the qualifying time sets your slot: 8th to 1st
      put sPhaseT into sQualT
      put 1 + max(0, min(7, (sQualT - round(sLapLen / 34)) div 25)) into sPlace
      Grid.Begin "grid"
      exit Grid.Lap
   end if
   add 1 to sLap
   if sLap >= kLaps then
      put 1 into sPlace
      repeat with i = 1 to 7
         if sRival[i]["d"] > sDist then add 1 to sPlace
      end repeat
      add (9 - sPlace) * 50 * sLevel to sScore
      put "done" into sPhase
      put empty into sHUDWas
   end if
end Grid.Lap

-- the seven rivals: they ignore curves and stay in their lines
on Grid.Rivals pMoving
   local i, tRel, tAhead
   put 0 into tAhead
   repeat with i = 1 to 7
      if pMoving then
         put min(sRival[i]["top"], sRival[i]["v"] + 0.4) into sRival[i]["v"]
         add sRival[i]["v"] to sRival[i]["d"]
      end if
      put sRival[i]["d"] - sDist into tRel
      -- bump: you run into the back of a rival
      if pMoving and tRel > 0 and tRel < 120 and abs(sRival[i]["off"] - sOff) < 85 then
         put sRival[i]["v"] * 0.6 into sSpeed
         put sRival[i]["d"] - 125 into sDist
         FX.Sparks 0, kGroundY - 30, kCarZ + 80, 6, "255,140,0"
         put sRival[i]["d"] - sDist into tRel
      end if
      if tRel > 0 then add 1 to tAhead
   end repeat
   if sPhase is "race" then
      if 1 + tAhead is not sPlace then put empty into sHUDWas
      put 1 + tAhead into sPlace
   end if
end Grid.Rivals

-- the road: each slice shifts by the curve ahead of it
on Grid.DrawRoad
   local i, tZ, tX, tDX, tFrac, tK, tRel, tN, tD, tA
   put sDist mod kGap into tFrac
   put 0 into tX
   put 0 into tDX
   repeat with i = 0 to kSlices
      put kCarZ - kGap + i * kGap - tFrac into tZ
      add Grid.CurveAt(sDist + tZ - kCarZ) to tDX
      add tDX to tX
      put tX - sOff into sSlice[i]
      SetObjectPosition sRail[i], tX - sOff, kGroundY, tZ
   end repeat
   -- the car (it spins when it hits a sign)
   if sSpin > 0 then
      SetObjectRotation sCar, 0, sSpin / 2.5, 0
   else
      SetObjectRotation sCar, 0, Grid.CurveAt(sDist) * -0.03, 0
   end if
   SetObjectPosition sCar, 0, kGroundY - 17, kCarZ
   -- far mountains slide as the road turns
   repeat with i = 1 to 5
      put ((i * 4400 - sHeading * 6000) mod 22000) - 11000 into tX
      SetObjectPosition sMount[i], tX, kGroundY - 800, 12000
   end repeat
   -- the nearest signs ahead, from the pool
   put 0 into tN
   put sDist mod sLapLen into tA
   repeat for each key tK in sSign
      put sSign[tK]["d"] - tA into tRel
      if tRel < -100 then add sLapLen to tRel
      if tRel > -100 and tRel < kSlices * kGap - 100 and tN < 8 then
         add 1 to tN
         SetObjectPosition sSignPool[tN], Grid.RoadX(tRel) + sSign[tK]["off"], kGroundY - 30, kCarZ + tRel
      end if
   end repeat
   repeat with i = tN + 1 to 8
      SetObjectPosition sSignPool[i], 0, kGroundY - 30, -3000
   end repeat
   -- the next gate
   put (sDist - kStartLine) mod (sLapLen / 4) into tD
   put sLapLen / 4 - tD into tRel
   if tRel < kSlices * kGap - 100 then
      SetObjectPosition sGate, Grid.RoadX(tRel), kGroundY, kCarZ + tRel
   else
      SetObjectPosition sGate, 0, kGroundY, -3000
   end if
   -- rivals in view
   repeat with i = 1 to 7
      put sRival[i]["d"] - sDist into tRel
      if tRel > -150 and tRel < kSlices * kGap - 100 then
         SetObjectPosition sRival[i]["key"], Grid.RoadX(tRel) + sRival[i]["off"], kGroundY - 20, kCarZ + tRel
      else
         SetObjectPosition sRival[i]["key"], 0, kGroundY - 20, -3000
      end if
   end repeat
end Grid.DrawRoad

-- where the road's middle is on screen, pRel ahead of the car
function Grid.RoadX pRel
   local tI, tF
   put (pRel + kGap + (sDist mod kGap)) / kGap into tF
   put max(0, min(kSlices - 1, trunc(tF))) into tI
   put max(0, min(1, tF - tI)) into tF
   return sSlice[tI] + (sSlice[tI + 1] - sSlice[tI]) * tF
end Grid.RoadX

on Grid.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sPhase & "|" & sGear & "|" & sPlace & "|" & sLap & "|" & (sTime div 30) into tWords
   if tWords is sHUDWas then exit Grid.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Grid.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 40, 14
   switch sPhase
      case "qual"
         put "QUALIFYING LAP   GEAR" && toUpper(sGear) && "  GATE TIME" && sTime div 30 into tLine
         break
      case "grid"
         put "ON THE GRID IN PLACE" && sPlace & "/8.   SPACE TO RACE" into tLine
         break
      case "race"
         put "PLACE" && sPlace & "/8   LAP" && min(kLaps, sLap + 1) & "/" & kLaps && "  GEAR" && toUpper(sGear) && "  GATE TIME" && sTime div 30 into tLine
         break
      case "done"
         if sPlace is 1 and sLevel is 5 then
            put "YOU WON THE GRID.  SPACE TO RACE AGAIN" into tLine
         else if sPlace is 1 then
            put "FIRST PLACE!  SPACE FOR THE NEXT TRACK" into tLine
         else
            put "FINISHED" && sPlace & "/8.  SPACE TO TRY AGAIN" into tLine
         end if
         break
      case "over"
         put "GAME OVER.  SPACE TO DRIVE AGAIN" into tLine
         break
   end switch
   HUD.Set "Grid.Msg", tLine, 20, 70, 12
end Grid.ShowHUD

function Grid.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sPhase & "|place " & sPlace & "|lap " & sLap & "|d " & round(sDist) & "|v " & round(sSpeed) & "|" & sGear & "|off " & round(sOff) & "|time " & sTime
end Grid.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
