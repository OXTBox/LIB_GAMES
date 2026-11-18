######################################################################################
## CARD SCRIPT: "Play.CoastRoad"   COAST ROAD  (11 14 2026)
## A convertible on a sunny coast road: the sea on your left, palms on your right. Weave
## through traffic; at the end of every stage the road forks and you pick the route.
## Spark's concept and level numbers (LIB_SPARK/arcade/out/777_Coast_Road), script by Claude.
## CONTROLS  Left/Right (or A/D): steer    Space (or Up): accelerate    Escape: pause
## RULES     orange cars and slow red trucks share the road; touch one and you lose a life.
##           Green gates add time and give back a life. Blue cubes are 100 points. You
##           score as you drive, faster is more. The clock runs down: if it runs out, you
##           lose a life. At the purple fork keep LEFT for the shore (less traffic) or
##           RIGHT for the hills (busier, double points). Finish 5 stages to win.
######################################################################################

global bPaused, bPlaying

local sCar, sCarX, sSpeed, sTop, sDist, sStageLen, sRail, sThing, sThingN, sNextSpawn
local sLevel, sLives, sScore, sOver, sWon, sHurt, sTime, sRoute, sHills, sBusy, sForkUp
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kGroundY = 90       -- +Y is down
constant kCarZ = 280
constant kFarZ = 3400
constant kRailGap = 220
constant kLaneW = 140
constant kHalfW = 210        -- three lanes
constant kStageTime = 1500   -- steps on the clock at a stage start (about 50 seconds)

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put empty into sRoute
   put false into sHills
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Coast.Build
   Coast.StartLevel 1
end Game.OnStart

on Coast.Build
   local i, tM, tA
   Mesh.Define "Coast.Car", Coast.CarMesh()
   Mesh.Define "Coast.Slice", Coast.SliceMesh()
   Mesh.Define "Coast.Traffic", Mesh.Box(64, 36, 110)
   Mesh.Define "Coast.Truck", Mesh.Box(110, 90, 230)
   Mesh.Define "Coast.Bonus", Mesh.Box(50, 50, 50)
   Mesh.Define "Coast.Gate", Coast.GateMesh()
   Mesh.Define "Coast.Fork", Mesh.Box(40, 50, 900)
   Mesh.Define "Coast.Palm", Mesh.Pyramid(5, 50, 260)
   Mesh.Define "Coast.Trunk", Mesh.Prism(4, 8, 200)
   -- the sun: a ring of lines in the sky
   put Mesh.New() into tM
   repeat with i = 0 to 11
      put i * 3.14159 / 6 into tA
      Mesh.AddVertex tM, 900 * cos(tA), 900 * sin(tA), 0
   end repeat
   repeat with i = 1 to 12
      Mesh.AddLine tM, i, (i mod 12) + 1
   end repeat
   Mesh.Define "Coast.Sun", tM
   get Entity.Spawn("Coast.Sun", 3500, kGroundY - 3200, 12000, "255,220,60")
   Mesh.Define "Coast.Horizon", Mesh.Box(30000, 1, 1)
   get Entity.Spawn("Coast.Horizon", 0, kGroundY, 12000, "0,140,255")
   put Entity.Spawn("Coast.Car", 0, kGroundY - 16, kCarZ, "255,255,255") into sCar
   put empty into sRail
   repeat with i = 0 to kFarZ div kRailGap
      put kCarZ - 120 + i * kRailGap into sRail[i]["z"]
      put Entity.Spawn("Coast.Slice", 0, kGroundY, sRail[i]["z"], "190,190,200") into sRail[i]["key"]
   end repeat
end Coast.Build

-- one slice of the world: the road edges and lane dashes, sea ripples on the left
function Coast.SliceMesh
   local tM, i, tX
   put Mesh.New() into tM
   -- kerbs
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, -kHalfW, -18, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, -18, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   -- lane dashes (along the road)
   repeat with i = -1 to 1 step 2
      put i * kLaneW / 2 into tX
      Mesh.AddVertex tM, tX, 0, 0
      Mesh.AddVertex tM, tX, 0, 90
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   -- the road edge lines (along the road, the full slice)
   repeat with i = -1 to 1 step 2
      Mesh.AddVertex tM, i * kHalfW, 0, 0
      Mesh.AddVertex tM, i * kHalfW, 0, kRailGap
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   -- sea ripples
   repeat with i = 1 to 3
      put -kHalfW - 150 - i * 380 into tX
      Mesh.AddVertex tM, tX - 120, 30, 0
      Mesh.AddVertex tM, tX, 22, 0
      Mesh.AddVertex tM, tX + 120, 30, 0
      Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Coast.SliceMesh

function Coast.CarMesh
   local tM
   put Mesh.New() into tM
   Coast.AddBox tM, 0, 4, 0, 80, 22, 140
   -- the windscreen of a convertible: one frame, no roof
   Mesh.AddVertex tM, -36, -7, 10
   Mesh.AddVertex tM, -30, -32, 22
   Mesh.AddVertex tM, 30, -32, 22
   Mesh.AddVertex tM, 36, -7, 10
   Mesh.AddLine tM, 9, 10
   Mesh.AddLine tM, 10, 11
   Mesh.AddLine tM, 11, 12
   return tM
end Coast.CarMesh

on Coast.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Coast.AddBox

function Coast.GateMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -kHalfW - 30, 0, 0
   Mesh.AddVertex tM, -kHalfW - 30, -170, 0
   Mesh.AddVertex tM, kHalfW + 30, -170, 0
   Mesh.AddVertex tM, kHalfW + 30, 0, 0
   Mesh.AddVertex tM, -kHalfW - 30, -140, 0
   Mesh.AddVertex tM, kHalfW + 30, -140, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 5, 6
   return tM
end Coast.GateMesh

-- Spark's table: speed | traffic | lives
on Coast.StartLevel pLevel
   local tRow, tK
   put pLevel into sLevel
   put line pLevel of ("120,2,3" & cr & "130,3,3" & cr & "140,4,2" & cr & "150,5,2" & cr & "160,6,1") into tRow
   put (item 1 of tRow) / 4 into sTop                 -- top speed, world units a step
   put item 2 of tRow into sBusy
   if sHills then add 1 to sBusy
   if pLevel is 1 then put item 3 of tRow into sLives
   put 10000 + pLevel * 1500 into sStageLen
   put 0 into sDist
   put 0 into sCarX
   if pLevel is 1 then put sTop * 0.5 into sSpeed
   put 0 into sHurt
   put kStageTime into sTime
   put false into sForkUp
   repeat for each key tK in sThing
      Entity.Kill sThing[tK]["key"]
   end repeat
   put empty into sThing
   put 0 into sThingN
   put 300 into sNextSpawn
   put empty into sHUDWas
end Coast.StartLevel

function Coast.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Coast.Keys

on Coast.TestKeys pKeys
   put pKeys into sTestKeys
end Coast.TestKeys

on Coast.TestLives pN
   put pN into sLives
end Coast.TestLives

function Coast.Down pCode, pKeys
   return pCode is among the items of pKeys
end Coast.Down

on Game.OnUpdate
   local tKeys, tT, tZ, tX, tHit, tK, tRel
   put Coast.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Coast.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put empty into sRoute
         put false into sHills
         put false into sOver
         put false into sWon
         Coast.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- pedal and wheel
   if Coast.Down(32, tKeys) or Coast.Down(65362, tKeys) or Coast.Down(119, tKeys) then
      put min(sTop, sSpeed + 0.35) into sSpeed
   else
      put max(sTop * 0.35, sSpeed - 0.2) into sSpeed
   end if
   if Coast.Down(65361, tKeys) or Coast.Down(97, tKeys) then subtract 4 + sSpeed * 0.15 from sCarX
   if Coast.Down(65363, tKeys) or Coast.Down(100, tKeys) then add 4 + sSpeed * 0.15 to sCarX
   put tKeys into sKeysWas
   put max(-kHalfW + 30, min(kHalfW - 30, sCarX)) into sCarX
   Entity.SetPosition sCar, sCarX, kGroundY - 16, kCarZ
   Entity.SetRotation sCar, 0, 0, 0
   add sSpeed to sDist
   if sHills then
      add sSpeed / 5 to sScore
   else
      add sSpeed / 10 to sScore
   end if
   if sHurt > 0 then subtract 1 from sHurt
   subtract 1 from sTime
   if sTime <= 0 then
      put kStageTime div 2 into sTime
      Coast.Hurt
   end if
   -- the world rushes past
   repeat for each key tK in sRail
      subtract sSpeed from sRail[tK]["z"]
      if sRail[tK]["z"] < kCarZ - 260 then add (kFarZ div kRailGap + 1) * kRailGap to sRail[tK]["z"]
      Entity.SetPosition sRail[tK]["key"], 0, kGroundY, sRail[tK]["z"]
   end repeat
   -- new things ahead (none near the fork)
   if sDist >= sNextSpawn and sDist < sStageLen - 2600 then
      Coast.Spawn
      put sDist + max(220, 1700 / sBusy) + random(260) into sNextSpawn
   end if
   if not sForkUp and sDist >= sStageLen - kFarZ then Coast.SpawnFork
   -- things: each has its own speed along the road
   repeat for each key tT in sThing
      subtract sSpeed - sThing[tT]["v"] from sThing[tT]["z"]
      put sThing[tT]["z"] into tZ
      put sThing[tT]["x"] into tX
      if sThing[tT]["kind"] is "bonus" then Entity.SetRotation sThing[tT]["key"], 0, sTicks / 10, sTicks / 14
      Entity.SetPosition sThing[tT]["key"], tX, sThing[tT]["y"], tZ
      if sThing[tT]["kind"] is "trunk" then next repeat
      put false into tHit
      if abs(tZ - kCarZ) < (sThing[tT]["len"] + 140) / 2 and abs(tX - sCarX) < (sThing[tT]["w"] + 70) / 2 then
         switch sThing[tT]["kind"]
            case "bonus"
               add 100 to sScore
               FX.Sparks tX, kGroundY - 30, tZ, 8, "60,120,255"
               put true into tHit
               break
            case "gate"
               add 300 to sTime
               if sLives < 3 then add 1 to sLives
               FX.Sparks sCarX, kGroundY - 60, kCarZ, 12, "0,255,120"
               put true into tHit
               break
            case "palm"
               break
            default
               if sHurt <= 0 then
                  Coast.Hurt
                  put sThing[tT]["v"] * 0.7 into sSpeed
               end if
         end switch
         put empty into sHUDWas
      end if
      if tHit or tZ < kCarZ - 300 or tZ > kCarZ + kFarZ + 800 then
         Entity.Kill sThing[tT]["key"]
         delete variable sThing[tT]
      end if
   end repeat
   -- the end of the stage: which side of the fork are you on?
   if sDist >= sStageLen then
      add 250 * sLevel to sScore
      if sCarX < 0 then
         put sRoute & "L" into sRoute
         put false into sHills
      else
         put sRoute & "R" into sRoute
         put true into sHills
      end if
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
      else
         Coast.StartLevel sLevel + 1
      end if
   end if
   Coast.ShowHUD
end Game.OnUpdate

-- traffic, a truck, a blue bonus, a green gate, or palms at the roadside
on Coast.Spawn
   local tN, tLane, tX
   put random(3) into tLane
   put (tLane - 2) * kLaneW into tX
   put random(100) into tN
   if tN <= 50 then
      Coast.Add "car", "Coast.Traffic", tX, kGroundY - 18, sTop * (0.45 + random(20) / 100), 64, 110, Coast.Pick("255,140,0|255,170,40|240,110,20")
   else if tN <= 66 then
      Coast.Add "truck", "Coast.Truck", tX, kGroundY - 45, sTop * 0.35, 110, 230, "255,50,50"
   else if tN <= 80 then
      Coast.Add "bonus", "Coast.Bonus", tX, kGroundY - 40, 0, 50, 50, "60,120,255"
   else if tN <= 85 and sDist > sStageLen / 3 then
      Coast.Add "gate", "Coast.Gate", 0, kGroundY, 0, 2 * kHalfW, 30, "0,255,120"
   else
      put kHalfW + 120 + random(500) into tX
      Coast.Add "palm", "Coast.Palm", tX, kGroundY - 330, 0, 0, 0, "0,220,90"
      Coast.Add "trunk", "Coast.Trunk", tX, kGroundY - 100, 0, 0, 0, "200,140,60"
   end if
end Coast.Spawn

function Coast.Pick pList
   set the itemDel to "|"
   return item random(the number of items of pList) of pList
end Coast.Pick

on Coast.Add pKind, pMesh, pX, pY, pV, pW, pLen, pColor
   add 1 to sThingN
   put pKind into sThing[sThingN]["kind"]
   put pX into sThing[sThingN]["x"]
   put pY into sThing[sThingN]["y"]
   put pV into sThing[sThingN]["v"]
   put pW into sThing[sThingN]["w"]
   put pLen into sThing[sThingN]["len"]
   put kCarZ + kFarZ into sThing[sThingN]["z"]
   put Entity.Spawn(pMesh, pX, pY, kCarZ + kFarZ, pColor) into sThing[sThingN]["key"]
end Coast.Add

on Coast.SpawnFork
   put true into sForkUp
   Coast.Add "fork", "Coast.Fork", 0, kGroundY - 25, 0, 40, 900, "200,60,255"
   put sThing[sThingN]["z"] + 450 into sThing[sThingN]["z"]
   put empty into sHUDWas
end Coast.SpawnFork

on Coast.Hurt
   if sHurt > 0 then exit Coast.Hurt
   subtract 1 from sLives
   put 40 into sHurt
   FX.Sparks sCarX, kGroundY - 20, kCarZ, 18, "255,80,80"
   put empty into sHUDWas
   if sLives <= 0 then put true into sOver
end Coast.Hurt

on Coast.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & round(sScore) div 10 & "|" & sOver & "|" & sForkUp & "|" & sTime div 30 & "|" & sRoute into tWords
   if tWords is sHUDWas then exit Coast.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Coast.Score", "SCORE" && round(sScore) && "  LIVES" && sLives && "  STAGE" && sLevel & "/5  TIME" && sTime div 30, 20, 40, 14
   if sOver and sWon then
      put "COAST TO COAST! ROUTE" && sRoute & ".  SPACE TO DRIVE AGAIN" into tLine
   else if sOver then
      put "END OF THE ROAD.  SPACE TO DRIVE AGAIN" into tLine
   else if sForkUp then
      put "FORK AHEAD: LEFT FOR THE SHORE, RIGHT FOR THE HILLS" into tLine
   else if sHills then
      put "THE HILLS ROUTE (" & sRoute & "): DOUBLE POINTS" into tLine
   else if sRoute is not empty then
      put "THE SHORE ROUTE (" & sRoute & ")" into tLine
   else
      put "SPACE TO SPEED UP" into tLine
   end if
   HUD.Set "Coast.Msg", tLine, 20, 70, 12
end Coast.ShowHUD

function Coast.State
   return sLevel & "|" & sLives & "|" & round(sScore) & "|x " & round(sCarX) & "|v " & round(sSpeed) & "|d " & round(sDist) & "/" & sStageLen & "|things " & the number of lines of the keys of sThing & "|route " & sRoute & "|" & sOver
end Coast.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
