######################################################################################
## CARD SCRIPT: "Play.NeonDriftWastes"   NEON DRIFT WASTES  (11 14 2026)
## A casual endless drive through a vaporwave wasteland: a striped sunset, a wireframe grid
## rushing under you, broken pillars and antenna palms going by. Spark's concept and level
## numbers (LIB_SPARK/arcade/out/327_Neon_Drift_Wastes), script by Claude.
## CONTROLS  Left/Right (or A/D): change lane    Space: jump    Escape: pause
## RULES     teal cassettes are 100 points. Pink static walls: jump them or change lane.
##           Chrome pillars fall into a lane: only a lane change saves you. Cyan "chill"
##           cubes slow time for a while. A hit costs a life. The drive gets faster and
##           busier: 5 levels, every 1500 metres the next; after level 5 it just goes on.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sCar, sLane, sCarX, sJumpT, sCarY, sThing, sThingN, sRail, sSide, sDist, sNextSpawn
local sLevel, sLives, sScore, sOver, sSpeed, sBusy, sChill, sHurt, sKeysWas, sTestKeys, sHUDWas

constant kGroundY = 90       -- +Y is down: the ground is below the eye
constant kCarZ = 260
constant kFarZ = 3200
constant kLaneW = 150
constant kRailGap = 200

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   Neon.Build
   Neon.StartLevel 1
end Game.OnStart

-- the world that never changes: sun, horizon, lane edges
on Neon.Build
   local i, tW
   Mesh.Define "Neon.Car", Mesh.Transform(MeshPyramid(3, 34, 70), 1.5708, 0, 0, 0, 0, 0, 1)
   Mesh.Define "Neon.Rail", MeshBox(3 * kLaneW + 300, 1, 1)
   Mesh.Define "Neon.Edge", MeshBox(2, 2, kFarZ)
   Mesh.Define "Neon.Cassette", MeshBox(50, 30, 12)
   Mesh.Define "Neon.Wall", MeshBox(kLaneW - 20, 40, 20)
   Mesh.Define "Neon.Pillar", MeshPrism(6, 22, 160)
   Mesh.Define "Neon.Chill", MeshBox(40, 40, 40)
   Mesh.Define "Neon.Palm", MeshPyramid(4, 30, 220)
   Mesh.Define "Neon.Glitch", MeshBox(26, 26, 26)
   -- the sunset: stripes of a sun sitting on the horizon
   repeat with i = 1 to 7
      put round(2 * 3600 * sqrt(1 - ((i - 0.5) / 7) ^ 2)) into tW
      Mesh.Define "Neon.Sun" & i, MeshBox(tW, 300 - i * 25, 1)
      get Entity.Spawn("Neon.Sun" & i, 0, kGroundY - (i - 0.5) * 3600 / 7, 9000, Neon.SunColour(i))
   end repeat
   Mesh.Define "Neon.Horizon", MeshBox(12000, 1, 1)
   get Entity.Spawn("Neon.Horizon", 0, kGroundY, 9000, "magenta")
   put empty into sSide
   repeat with i = -2 to 2
      if i is 0 then next repeat
      get Entity.Spawn("Neon.Edge", i * kLaneW * 0.75 + Neon.Sign(i) * kLaneW * 0.25 * (abs(i) - 1), kGroundY, kCarZ + kFarZ / 2 - 200, "cyan")
   end repeat
end Neon.Build

function Neon.Sign pN
   if pN < 0 then return -1
   if pN > 0 then return 1
   return 0
end Neon.Sign

function Neon.SunColour pIdx
   set the itemDel to "|"
   return item pIdx of "255,230,80|255,190,90|255,150,110|255,120,140|240,90,170|210,70,190|170,60,210"
end Neon.SunColour

-- Spark's table: speed | things a wave
on Neon.StartLevel pLevel
   local tRow, i
   put pLevel into sLevel
   put line min(pLevel, 5) of ("1.2,5" & cr & "1.3,7" & cr & "1.4,9" & cr & "1.5,11" & cr & "1.6,13") into tRow
   put (item 1 of tRow) * 22 into sSpeed          -- world units a step
   put item 2 of tRow into sBusy
   if pLevel > 1 then exit Neon.StartLevel         -- the road goes on; only the pace changes
   put 0 into sDist
   put 2 into sLane
   put 0 into sCarX
   put 0 into sJumpT
   put kGroundY - 14 into sCarY
   put 0 into sChill
   put 0 into sHurt
   put empty into sThing
   put 0 into sThingN
   put 400 into sNextSpawn
   put Entity.Spawn("Neon.Car", 0, sCarY, kCarZ, "255,80,200") into sCar
   put empty into sRail
   repeat with i = 0 to kFarZ div kRailGap
      put Entity.Spawn("Neon.Rail", 0, kGroundY, kCarZ + i * kRailGap, "140,60,220") into sRail[i]["key"]
      put kCarZ + i * kRailGap into sRail[i]["z"]
   end repeat
   put empty into sHUDWas
end Neon.StartLevel

function Neon.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Neon.Keys

on Neon.TestKeys pKeys
   put pKeys into sTestKeys
end Neon.TestKeys

function Neon.Pressed pCode, pKeys
   return pCode is among the items of pKeys and not (pCode is among the items of sKeysWas)
end Neon.Pressed

on Game.OnUpdate
   local tKeys, tSpeed, tT, tX, tY, tZ, tK, tHit
   put Neon.Keys() into tKeys
   if sOver then
      if Neon.Pressed(32, tKeys) then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Scene.ClearAll
         Neon.Build
         Neon.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- lanes: one press, one lane
   if (Neon.Pressed(65361, tKeys) or Neon.Pressed(97, tKeys)) and sLane > 1 then subtract 1 from sLane
   if (Neon.Pressed(65363, tKeys) or Neon.Pressed(100, tKeys)) and sLane < 3 then add 1 to sLane
   if Neon.Pressed(32, tKeys) and sJumpT <= 0 then put 18 into sJumpT
   put tKeys into sKeysWas
   add ((sLane - 2) * kLaneW - sCarX) * 0.3 to sCarX             -- glide into the lane
   put kGroundY - 14 into sCarY
   if sJumpT > 0 then
      subtract 1 from sJumpT
      put kGroundY - 14 - 110 * sin(3.14159 * sJumpT / 18) into sCarY
   end if
   SetObjectPosition sCar, sCarX, sCarY, kCarZ
   SetObjectRotation sCar, 1.5708, 0, ((sLane - 2) * kLaneW - sCarX) / 300
   -- time: the chill cube halves it for a while
   put sSpeed into tSpeed
   if sChill > 0 then
      subtract 1 from sChill
      put sSpeed * 0.5 into tSpeed
   end if
   add tSpeed to sDist
   if sHurt > 0 then subtract 1 from sHurt
   -- the grid rushes under you
   repeat for each key tK in sRail
      subtract tSpeed from sRail[tK]["z"]
      if sRail[tK]["z"] < kCarZ - 150 then add (kFarZ div kRailGap + 1) * kRailGap to sRail[tK]["z"]
      SetObjectPosition sRail[tK]["key"], 0, kGroundY, sRail[tK]["z"]
   end repeat
   -- new things far ahead
   if sDist >= sNextSpawn then
      Neon.Spawn
      put sDist + max(160, 1400 / sBusy) + random(200) into sNextSpawn
   end if
   -- things come at you
   repeat for each key tT in sThing
      subtract tSpeed from sThing[tT]["z"]
      put sThing[tT]["z"] into tZ
      put sThing[tT]["x"] into tX
      put sThing[tT]["y"] into tY
      if sThing[tT]["kind"] is "pillar" and tZ < 1400 then
         put min(kGroundY - 80, tY + 9) into tY                    -- it falls into its lane
         put tY into sThing[tT]["y"]
      end if
      if sThing[tT]["kind"] is among the items of "cassette,chill" then
         SetObjectRotation sThing[tT]["key"], 0, sDist / 60, 0
      end if
      SetObjectPosition sThing[tT]["key"], tX, tY, tZ
      put false into tHit
      if abs(tZ - kCarZ) < 40 and abs(tX - sCarX) < kLaneW * 0.55 then
         switch sThing[tT]["kind"]
            case "cassette"
               add 100 to sScore
               FX.Sparks tX, tY, tZ, 8, "0,255,220"
               put true into tHit
               break
            case "chill"
               put 150 into sChill
               FX.Sparks tX, tY, tZ, 10, "cyan"
               put true into tHit
               break
            case "wall"
               if sCarY > kGroundY - 60 then put Neon.Hurt(tX, tZ) into tHit
               break
            case "pillar"
               put Neon.Hurt(tX, tZ) into tHit
               break
         end switch
         put empty into sHUDWas
      end if
      if tHit or tZ < kCarZ - 120 then
         Entity.Kill sThing[tT]["key"]
         delete variable sThing[tT]
      end if
   end repeat
   -- a new level every 1500 metres (100 units a metre)
   if sDist >= sLevel * 150000 and sLevel < 5 then Neon.StartLevel sLevel + 1
   Neon.ShowHUD
end Game.OnUpdate

-- one new thing in a random lane (or scenery at the sides)
on Neon.Spawn
   local tLane, tKind, tX, tY, tN, tColor, tMesh
   put random(3) into tLane
   put (tLane - 2) * kLaneW into tX
   put random(100) into tN
   if tN <= 35 then
      put "cassette,Neon.Cassette,0,255,220" into tKind
   else if tN <= 62 then
      put "wall,Neon.Wall,255,60,170" into tKind
   else if tN <= 80 and sLevel >= 2 then
      put "pillar,Neon.Pillar,200,200,230" into tKind
   else if tN <= 86 then
      put "chill,Neon.Chill,0,230,255" into tKind
   else
      put "palm,Neon.Palm,255,120,200" into tKind
      put (random(2) * 2 - 3) * (kLaneW * 2 + random(300)) into tX
   end if
   put item 1 of tKind into tN
   put item 2 of tKind into tMesh
   put item 3 to 5 of tKind into tColor
   switch tN
      case "pillar"
         put -420 into tY
         break
      case "wall"
         put kGroundY - 20 into tY
         break
      case "palm"
         put kGroundY - 110 into tY
         break
      default
         put kGroundY - 40 into tY
   end switch
   add 1 to sThingN
   put tN into sThing[sThingN]["kind"]
   put tX into sThing[sThingN]["x"]
   put tY into sThing[sThingN]["y"]
   put kCarZ + kFarZ into sThing[sThingN]["z"]
   put Entity.Spawn(tMesh, tX, tY, kCarZ + kFarZ, tColor) into sThing[sThingN]["key"]
   -- now and then a glitch cube floats by off the road
   if random(6) is 1 then
      add 1 to sThingN
      put "glitch" into sThing[sThingN]["kind"]
      put (random(2) * 2 - 3) * (kLaneW * 3 + random(400)) into sThing[sThingN]["x"]
      put -100 - random(250) into sThing[sThingN]["y"]
      put kCarZ + kFarZ into sThing[sThingN]["z"]
      put Entity.Spawn("Neon.Glitch", sThing[sThingN]["x"], sThing[sThingN]["y"], kCarZ + kFarZ, "0,255,180") into sThing[sThingN]["key"]
   end if
end Neon.Spawn

function Neon.Hurt pX, pZ
   if sHurt > 0 then return false
   subtract 1 from sLives
   put 30 into sHurt
   FX.Sparks sCarX, sCarY, kCarZ, 16, "255,60,170"
   if sLives <= 0 then put true into sOver
   return true
end Neon.Hurt

on Neon.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & (sChill > 0) into tWords
   if tWords is sHUDWas then exit Neon.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Neon.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 40, 14
   HUD.Remove "Neon.Msg"
   if sOver then
      HUD.Set "Neon.Msg", "SIGNAL LOST.  SPACE TO DRIVE AGAIN", 230, 300, 16
   else if sChill > 0 then
      HUD.Set "Neon.Msg", "CHILL", 410, 90, 16
   end if
end Neon.ShowHUD

function Neon.State
   return sLevel & "|" & sLives & "|" & sScore & "|lane " & sLane & "|dist " & round(sDist) & "|things " & the number of lines of the keys of sThing & "|" & sOver
end Neon.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
