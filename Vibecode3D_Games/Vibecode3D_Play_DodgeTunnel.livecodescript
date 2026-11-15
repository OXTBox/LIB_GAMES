######################################################################################
## CARD SCRIPT: "Play.DodgeTunnel"   DODGE TUNNEL  (11 14 2026)
## You fly down a square tunnel; cubes come at you from its four corners. The owner's idea,
## Spark's level numbers (LIB_SPARK/arcade/out/973_Dodge_Tunnel), script by Claude.
## CONTROLS  Arrows (or WASD): slide left/right, climb/drop    Space: a quick dash
##           (a short burst you can't be hit in, then a rest)    Escape: pause
## RULES     a cube that reaches you where you are costs a life. Each wave sends more cubes,
##           faster; survive the wave to score it. 5 waves.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sShip, sX, sY, sCube, sCubeN, sRing, sWaveLeft, sNextCube, sTicks, sDash, sDashRest
local sLevel, sLives, sScore, sOver, sSpeed, sHurt, sKeysWas, sTestKeys, sHUDWas

constant kShipZ = 300
constant kFarZ = 3600
constant kHalf = 180           -- the tunnel's half width and half height
constant kRingGap = 300
constant kMove = 9

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
   Dodge.StartLevel 1
end Game.OnStart

-- Spark's table: cube speed | cubes in the wave
on Dodge.StartLevel pLevel
   local tRow, i
   put pLevel into sLevel
   put line pLevel of ("1.8,6" & cr & "2.0,9" & cr & "2.2,12" & cr & "2.4,14" & cr & "2.6,18") into tRow
   put (item 1 of tRow) * 14 into sSpeed
   put item 2 of tRow into sWaveLeft
   Scene.ClearAll
   Mesh.Define "Dodge.Ship", Mesh.Transform(MeshPyramid(4, 22, 44), 1.5708, 0, 0, 0, 0, 0, 1)
   Mesh.Define "Dodge.Cube", MeshBox(70, 70, 70)
   Mesh.Define "Dodge.Ring", Dodge.RingMesh()
   put empty into sRing
   repeat with i = 0 to kFarZ div kRingGap
      put kShipZ + i * kRingGap into sRing[i]["z"]
      put Entity.Spawn("Dodge.Ring", 0, 0, sRing[i]["z"], "0,170,255") into sRing[i]["key"]
   end repeat
   put 0 into sX
   put 0 into sY
   put Entity.Spawn("Dodge.Ship", 0, 0, kShipZ, "white") into sShip
   put empty into sCube
   put 0 into sCubeN
   put 30 into sNextCube
   put 0 into sTicks
   put 0 into sDash
   put 0 into sDashRest
   put 0 into sHurt
   put empty into sHUDWas
end Dodge.StartLevel

-- the tunnel's square frame (wire lines only)
function Dodge.RingMesh
   local tM, h
   put Mesh.New() into tM
   put kHalf + 40 into h
   Mesh.AddVertex tM, -h, -h, 0
   Mesh.AddVertex tM, h, -h, 0
   Mesh.AddVertex tM, h, h, 0
   Mesh.AddVertex tM, -h, h, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 4, 1
   return tM
end Dodge.RingMesh

function Dodge.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Dodge.Keys

on Dodge.TestKeys pKeys
   put pKeys into sTestKeys
end Dodge.TestKeys

on Game.OnUpdate
   local tKeys, tK, tC, tZ
   put Dodge.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Dodge.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   add 1 to sTicks
   if 65361 is among the items of tKeys or 97 is among the items of tKeys then subtract kMove from sX
   if 65363 is among the items of tKeys or 100 is among the items of tKeys then add kMove to sX
   if 65362 is among the items of tKeys or 119 is among the items of tKeys then subtract kMove from sY
   if 65364 is among the items of tKeys or 115 is among the items of tKeys then add kMove to sY
   put max(-kHalf + 20, min(kHalf - 20, sX)) into sX
   put max(-kHalf + 20, min(kHalf - 20, sY)) into sY
   if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) and sDashRest <= 0 then
      put 10 into sDash
      put 60 into sDashRest
   end if
   put tKeys into sKeysWas
   if sDash > 0 then subtract 1 from sDash
   if sDashRest > 0 then subtract 1 from sDashRest
   if sHurt > 0 then subtract 1 from sHurt
   SetObjectPosition sShip, sX, sY, kShipZ
   SetObjectRotation sShip, 1.5708, 0, sTicks / 8 * (sDash > 0)
   -- the tunnel rushes past
   repeat for each key tK in sRing
      subtract sSpeed from sRing[tK]["z"]
   end repeat
   repeat for each key tK in sRing
      if sRing[tK]["z"] < kShipZ - 200 then add (kFarZ div kRingGap + 1) * kRingGap to sRing[tK]["z"]
      SetObjectPosition sRing[tK]["key"], 0, 0, sRing[tK]["z"]
   end repeat
   -- the wave: cubes from the corners, aimed at a point near where you are now
   subtract 1 from sNextCube
   if sNextCube <= 0 and sWaveLeft > 0 then
      Dodge.Launch
      subtract 1 from sWaveLeft
      put max(10, 34 - sLevel * 4) + random(12) into sNextCube
   end if
   repeat for each key tC in sCube
      subtract sSpeed * 1.4 from sCube[tC]["z"]
      put sCube[tC]["z"] into tZ
      -- slide from the corner toward the aim point as it comes
      put (kFarZ - (tZ - kShipZ)) / kFarZ into tK
      put sCube[tC]["x0"] + (sCube[tC]["ax"] - sCube[tC]["x0"]) * min(1, tK * 1.3) into sCube[tC]["x"]
      put sCube[tC]["y0"] + (sCube[tC]["ay"] - sCube[tC]["y0"]) * min(1, tK * 1.3) into sCube[tC]["y"]
      SetObjectPosition sCube[tC]["key"], sCube[tC]["x"], sCube[tC]["y"], tZ
      SetObjectRotation sCube[tC]["key"], sTicks / 20, sTicks / 15, 0
      if abs(tZ - kShipZ) < 40 and sDash <= 0 and sHurt <= 0 \
            and abs(sCube[tC]["x"] - sX) < 55 and abs(sCube[tC]["y"] - sY) < 55 then
         subtract 1 from sLives
         put 30 into sHurt
         FX.Sparks sX, sY, kShipZ, 18, "red"
         put empty into sHUDWas
         if sLives <= 0 then put true into sOver
      end if
      if tZ < kShipZ - 150 then
         Entity.Kill sCube[tC]["key"]
         delete variable sCube[tC]
         add 10 to sScore
         put empty into sHUDWas
      end if
   end repeat
   -- wave over: the next one
   if sWaveLeft <= 0 and the number of lines of the keys of sCube is 0 and not sOver then
      add 100 * sLevel to sScore
      if sLevel >= 5 then
         put true into sOver
      else
         Dodge.StartLevel sLevel + 1
      end if
   end if
   Dodge.ShowHUD
end Game.OnUpdate

on Dodge.Launch
   local tCorner, tColor
   put random(4) into tCorner
   add 1 to sCubeN
   put (item tCorner of "-1,1,1,-1") * kHalf into sCube[sCubeN]["x0"]
   put (item tCorner of "-1,-1,1,1") * kHalf into sCube[sCubeN]["y0"]
   put max(-kHalf + 35, min(kHalf - 35, sX + random(120) - 60)) into sCube[sCubeN]["ax"]
   put max(-kHalf + 35, min(kHalf - 35, sY + random(120) - 60)) into sCube[sCubeN]["ay"]
   put sCube[sCubeN]["x0"] into sCube[sCubeN]["x"]
   put sCube[sCubeN]["y0"] into sCube[sCubeN]["y"]
   put kShipZ + kFarZ into sCube[sCubeN]["z"]
   set the itemDel to "|"
   put item tCorner of "255,80,80|255,200,0|0,255,120|255,0,255" into tColor
   set the itemDel to comma
   put Entity.Spawn("Dodge.Cube", sCube[sCubeN]["x"], sCube[sCubeN]["y"], kShipZ + kFarZ, tColor) into sCube[sCubeN]["key"]
end Dodge.Launch

on Dodge.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & (sDashRest <= 0) into tWords
   if tWords is sHUDWas then exit Dodge.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Dodge.Score", "SCORE" && sScore && "  LIVES" && sLives && "  WAVE" && sLevel, 20, 40, 14
   HUD.Remove "Dodge.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Dodge.Msg", "THROUGH THE TUNNEL.  SPACE TO FLY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Dodge.Msg", "GAME OVER.  SPACE TO FLY AGAIN", 250, 300, 16
   else if sDashRest <= 0 then
      HUD.Set "Dodge.Msg", "DASH READY", 20, 70, 12
   end if
end Dodge.ShowHUD

function Dodge.State
   return sLevel & "|" & sLives & "|" & sScore & "|at " & sX & "," & sY & "|left " & sWaveLeft & "|cubes " & the number of lines of the keys of sCube & "|" & sOver
end Dodge.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
