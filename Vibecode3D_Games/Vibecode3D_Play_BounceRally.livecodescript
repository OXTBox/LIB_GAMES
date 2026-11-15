######################################################################################
## CARD SCRIPT: "Play.BounceRally"   BOUNCE RALLY  (11 14 2026)
## A top-down rally: the road winds up the screen, you shove other cars off it and jump
## rivers and enemy cars. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/930_Bounce_Rally), script by Claude.
## CONTROLS  Arrows (or WASD): drive    Space: jump    Escape: pause
## RULES     bump a red road car sideways: if it goes off the road or into a green rock,
##           100 points. Land on a purple enemy car from a jump: 200 points. Blue water
##           must be jumped. Water, the ditch, rocks and enemy cars on the ground cost a
##           life. Reach the flag at the end of each stage; 5 stages.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sCar, sX, sY, sVX, sJump, sDist, sStageLen, sSlice, sThing, sThingN, sNextSpawn, sRivers
local sLevel, sLives, sScore, sOver, sWon, sHurt, sScroll, sBusy, sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 380            -- the play plane, seen from above (screen scale is 300/z: 0.8 px a unit)
constant kCarY = 170         -- where your car sits on the screen when centred
constant kHalfW = 210        -- the road's half width
constant kSliceGap = 60
constant kSlices = 13
constant kJumpSteps = 26

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Rally.Build
   Rally.StartLevel 1
end Game.OnStart

on Rally.Build
   local i, tM
   Mesh.Define "Rally.Car", Rally.CarMesh(40, 80)
   Mesh.Define "Rally.RoadCar", Rally.CarMesh(56, 96)
   Mesh.Define "Rally.Enemy", Rally.CarMesh(50, 90)
   Mesh.Define "Rally.Rock", MeshPyramid(5, 18, 20)
   Mesh.Define "Rally.Shadow", MeshBox(40, 80, 1)
   Mesh.Define "Rally.Slice", Rally.SliceMesh()
   Mesh.Define "Rally.Flag", Rally.FlagMesh()
   -- water: wavy lines right across the screen
   put Mesh.New() into tM
   repeat with i = 0 to 2
      Rally.Wave tM, -30 + i * 30
   end repeat
   Mesh.Define "Rally.Water", tM
   put empty into sSlice
   repeat with i = 0 to kSlices
      put Entity.Spawn("Rally.Slice", 0, 0, kZ, "200,200,210") into sSlice[i]
   end repeat
   put Entity.Spawn("Rally.Car", 0, kCarY, kZ, "60,140,255") into sCar
end Rally.Build

function Rally.CarMesh pW, pH
   local tM
   put Mesh.New() into tM
   Rally.AddBox tM, 0, 0, 0, pW, pH, 16
   Rally.AddBox tM, 0, pH * 0.08, -6, pW * 0.7, pH * 0.4, 8      -- the cab
   Rally.AddBox tM, -pW / 2 - 3, -pH * 0.3, 4, 8, 18, 8           -- wheels
   Rally.AddBox tM, pW / 2 + 3, -pH * 0.3, 4, 8, 18, 8
   Rally.AddBox tM, -pW / 2 - 3, pH * 0.3, 4, 8, 18, 8
   Rally.AddBox tM, pW / 2 + 3, pH * 0.3, 4, 8, 18, 8
   return tM
end Rally.CarMesh

on Rally.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Rally.AddBox

-- a slice of road: its two edges and a centre dash
function Rally.SliceMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, -kHalfW, kSliceGap, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, kSliceGap, 0
   Mesh.AddVertex tM, 0, 10, 0
   Mesh.AddVertex tM, 0, 35, 0
   Mesh.AddVertex tM, -kHalfW - 14, 20, 0
   Mesh.AddVertex tM, -kHalfW - 24, 30, 0
   Mesh.AddVertex tM, kHalfW + 14, 20, 0
   Mesh.AddVertex tM, kHalfW + 24, 30, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 5, 6
   Mesh.AddLine tM, 7, 8
   Mesh.AddLine tM, 9, 10
   return tM
end Rally.SliceMesh

on Rally.Wave @pM, pY
   local i, tB
   put pM["count"] into tB
   repeat with i = 0 to 24
      Mesh.AddVertex pM, -600 + i * 50, pY + (i mod 2) * 12, 0
      if i > 0 then Mesh.AddLine pM, tB + i, tB + i + 1
   end repeat
end Rally.Wave

function Rally.FlagMesh
   local tM, tB
   put Mesh.New() into tM
   repeat with tB = -1 to 1 step 2
      Mesh.AddVertex tM, tB * (kHalfW + 30), 0, 0
      Mesh.AddVertex tM, tB * (kHalfW + 30), -60, -40
   end repeat
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 2, 4
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddLine tM, 5, 6
   return tM
end Rally.FlagMesh

-- the road winds: its middle at distance pW
function Rally.RoadX pW
   return (60 + sLevel * 25) * sin(pW / 700) + 40 * sin(pW / 260)
end Rally.RoadX

-- Spark's table: scroll speed | targets | lives
on Rally.StartLevel pLevel
   local tRow, tK, i
   put pLevel into sLevel
   put line pLevel of ("120,3,3" & cr & "130,4,3" & cr & "140,5,2" & cr & "150,6,2" & cr & "160,7,1") into tRow
   put (item 1 of tRow) / 24 into sScroll
   put item 2 of tRow into sBusy
   if pLevel is 1 then put item 3 of tRow into sLives
   put 7000 + pLevel * 1000 into sStageLen
   put 0 into sDist
   put Rally.RoadX(0) into sX
   put kCarY into sY
   put 0 into sVX
   put 0 into sJump
   put 30 into sHurt
   repeat for each key tK in sThing
      Entity.Kill sThing[tK]["key"]
   end repeat
   put empty into sThing
   put 0 into sThingN
   put 500 into sNextSpawn
   -- rivers across the road: one more each stage
   repeat with i = 1 to sBusy - 2
      Rally.Add "water", "Rally.Water", 0, i * sStageLen / (sBusy - 1), "40,120,255"
   end repeat
   Rally.Add "flag", "Rally.Flag", 0, sStageLen, "255,255,255"
   put empty into sHUDWas
end Rally.StartLevel

on Rally.Add pKind, pMesh, pX, pW, pColor
   add 1 to sThingN
   put pKind into sThing[sThingN]["kind"]
   put pX into sThing[sThingN]["x"]
   put pW into sThing[sThingN]["w"]
   put 0 into sThing[sThingN]["vx"]
   put Entity.Spawn(pMesh, pX, -900, kZ, pColor) into sThing[sThingN]["key"]
end Rally.Add

-- screen y of a world distance
function Rally.ScreenY pW
   return kCarY - (pW - sDist)
end Rally.ScreenY

function Rally.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Rally.Keys

on Rally.TestKeys pKeys
   put pKeys into sTestKeys
end Rally.TestKeys

on Rally.TestLives pN
   put pN into sLives
end Rally.TestLives

function Rally.Down pCode, pKeys
   return pCode is among the items of pKeys
end Rally.Down

on Game.OnUpdate
   local tKeys, tT, tY, tX, tCX, tW, tInAir, tLand, i, tFrac
   put Rally.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Rally.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put false into sOver
         put false into sWon
         Rally.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- driving: the road scrolls; up/down change your pace a little
   put sScroll into tW
   if Rally.Down(65362, tKeys) or Rally.Down(119, tKeys) then put sScroll * 1.5 into tW
   if Rally.Down(65364, tKeys) or Rally.Down(115, tKeys) then put sScroll * 0.6 into tW
   add tW to sDist
   if Rally.Down(65361, tKeys) or Rally.Down(97, tKeys) then subtract 1.6 from sVX
   if Rally.Down(65363, tKeys) or Rally.Down(100, tKeys) then add 1.6 to sVX
   put sVX * 0.82 into sVX
   add sVX to sX
   if Rally.Down(32, tKeys) and not (32 is among the items of sKeysWas) and sJump <= 0 then put kJumpSteps into sJump
   put tKeys into sKeysWas
   put false into tLand
   put sJump > 0 into tInAir
   if sJump > 0 then
      subtract 1 from sJump
      if sJump is 0 then put true into tLand
   end if
   if sHurt > 0 then subtract 1 from sHurt
   -- the ditch
   put Rally.RoadX(sDist) into tCX
   if abs(sX - tCX) > kHalfW - 14 and not tInAir then
      Rally.Hurt "ditch"
      put tCX into sX
      put 0 into sVX
   end if
   put max(tCX - kHalfW - 40, min(tCX + kHalfW + 40, sX)) into sX
   -- your car rises toward the camera in a jump
   if tInAir then
      SetObjectPosition sCar, sX, kCarY, kZ - 90 * sin(3.14159 * sJump / kJumpSteps)
   else
      SetObjectPosition sCar, sX, kCarY, kZ
   end if
   SetObjectRotation sCar, 0, 0, sVX * 0.04
   -- the road
   put sDist mod kSliceGap into tFrac
   repeat with i = 0 to kSlices
      put sDist - 140 + i * kSliceGap - tFrac into tW
      SetObjectPosition sSlice[i], Rally.RoadX(tW), Rally.ScreenY(tW) - kSliceGap, kZ
   end repeat
   -- new cars ahead
   if sDist >= sNextSpawn and sDist < sStageLen - 600 then
      Rally.Spawn
      put sDist + max(140, 900 / sBusy) + random(220) into sNextSpawn
   end if
   Rally.Things tInAir, tLand
   if sDist >= sStageLen then
      add 500 * sLevel to sScore
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
      else
         Rally.StartLevel sLevel + 1
      end if
   end if
   Rally.ShowHUD
end Game.OnUpdate

-- a red road car, a purple enemy, or a rock
on Rally.Spawn
   local tN, tCX, tW
   put sDist + 640 into tW
   put Rally.RoadX(tW) into tCX
   put random(100) into tN
   if tN <= 55 then
      Rally.Add "car", "Rally.RoadCar", tCX + random(2 * kHalfW - 120) - kHalfW + 60, tW, "255,60,60"
      put sScroll * (0.35 + random(30) / 100) into sThing[sThingN]["v"]
   else if tN <= 75 and sLevel >= 2 or tN <= 68 then
      Rally.Add "enemy", "Rally.Enemy", tCX + random(2 * kHalfW - 120) - kHalfW + 60, tW, "200,60,255"
      put sScroll * 0.5 into sThing[sThingN]["v"]
   else
      Rally.Add "rock", "Rally.Rock", tCX + (random(2) * 2 - 3) * (kHalfW - 30 - random(60)), tW, "0,230,90"
      put 0 into sThing[sThingN]["v"]
   end if
end Rally.Spawn

on Rally.Things pInAir, pLand
   local tT, tR, tY, tDX, tDY, tCX, tGone, tW
   repeat for each key tT in sThing
      put false into tGone
      if sThing[tT]["kind"] is among the items of "car,enemy" then
         add sThing[tT]["v"] to sThing[tT]["w"]
         -- enemies lean toward you
         if sThing[tT]["kind"] is "enemy" and abs(sThing[tT]["w"] - sDist) < 400 then
            add Rally.Sign(sX - sThing[tT]["x"]) * 0.25 to sThing[tT]["vx"]
         end if
         add sThing[tT]["vx"] to sThing[tT]["x"]
         put sThing[tT]["vx"] * 0.93 into sThing[tT]["vx"]
         put Rally.RoadX(sThing[tT]["w"]) into tCX
         -- shoved off the road: a wreck
         if abs(sThing[tT]["x"] - tCX) > kHalfW + 10 then
            Rally.Wreck tT, 100
            next repeat
         end if
         -- or into a rock
         repeat for each key tR in sThing
            if sThing[tR]["kind"] is "rock" and abs(sThing[tR]["w"] - sThing[tT]["w"]) < 55 and abs(sThing[tR]["x"] - sThing[tT]["x"]) < 40 then
               Rally.Wreck tT, 100
               put true into tGone
               exit repeat
            end if
         end repeat
         if tGone then next repeat
         -- you and it
         put sThing[tT]["x"] - sX into tDX
         put sThing[tT]["w"] - sDist into tDY
         if abs(tDX) < 50 and abs(tDY) < 90 then
            if pLand and sThing[tT]["kind"] is "enemy" then
               Rally.Wreck tT, 200
               next repeat
            else if not pInAir then
               if sThing[tT]["kind"] is "car" then
                  -- the bump: it flies away from you, you bounce back a little
                  put Rally.Sign(tDX) * (6 + abs(sVX)) into sThing[tT]["vx"]
                  put -Rally.Sign(tDX) * 3 into sVX
                  put sX + tDX - Rally.Sign(tDX) * 52 into sThing[tT]["x"]
                  if abs(tDY) > 70 then
                     add Rally.Sign(tDY) * 8 to sThing[tT]["w"]
                  end if
               else
                  put Rally.Sign(tDX) * 4 into sThing[tT]["vx"]
                  put -Rally.Sign(tDX) * 9 into sVX
                  Rally.Hurt "enemy"
               end if
            end if
         end if
      else if sThing[tT]["kind"] is "rock" then
         if not pInAir and abs(sThing[tT]["x"] - sX) < 30 and abs(sThing[tT]["w"] - sDist) < 50 then
            Rally.Hurt "rock"
            Rally.Wreck tT, 0
            next repeat
         end if
      else if sThing[tT]["kind"] is "flag" then
         put Rally.RoadX(sThing[tT]["w"]) into sThing[tT]["x"]
      else if sThing[tT]["kind"] is "water" then
         put Rally.RoadX(sThing[tT]["w"]) into sThing[tT]["x"]
         if not pInAir and abs(sThing[tT]["w"] - sDist) < 60 and sHurt <= 0 then
            FX.Sparks sX, kCarY, kZ, 14, "40,120,255"
            Rally.Hurt "water"
            add 140 to sDist                      -- the current carries you over
         end if
      end if
      put Rally.ScreenY(sThing[tT]["w"]) into tY
      if tY > 420 then
         Entity.Kill sThing[tT]["key"]
         delete variable sThing[tT]
         next repeat
      end if
      if tY < -420 then
         SetObjectPosition sThing[tT]["key"], 0, -900, kZ
      else
         SetObjectPosition sThing[tT]["key"], sThing[tT]["x"], tY, kZ
      end if
   end repeat
end Rally.Things

function Rally.Sign pN
   if pN < 0 then return -1
   return 1
end Rally.Sign

on Rally.Wreck pT, pPoints
   add pPoints to sScore
   FX.Sparks sThing[pT]["x"], Rally.ScreenY(sThing[pT]["w"]), kZ, 14, "255,200,60"
   Entity.Kill sThing[pT]["key"]
   delete variable sThing[pT]
   put empty into sHUDWas
end Rally.Wreck

on Rally.Hurt pWhy
   if sHurt > 0 then exit Rally.Hurt
   subtract 1 from sLives
   put 45 into sHurt
   FX.Sparks sX, kCarY, kZ, 18, "255,80,80"
   put empty into sHUDWas
   if sLives <= 0 then put true into sOver
end Rally.Hurt

on Rally.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & (sHurt > 0) into tWords
   if tWords is sHUDWas then exit Rally.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Rally.Score", "SCORE" && sScore && "  LIVES" && sLives && "  STAGE" && sLevel & "/5", 20, 40, 14
   if sOver and sWon then
      put "RALLY CHAMPION!  SPACE TO RACE AGAIN" into tLine
   else if sOver then
      put "WRECKED.  SPACE TO RACE AGAIN" into tLine
   else
      put "SHOVE RED CARS OFF THE ROAD.  SPACE: JUMP" into tLine
   end if
   HUD.Set "Rally.Msg", tLine, 20, 70, 12
end Rally.ShowHUD

function Rally.State
   return sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "|d " & round(sDist) & "/" & sStageLen & "|jump " & sJump & "|things " & the number of lines of the keys of sThing & "|" & sOver
end Rally.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
