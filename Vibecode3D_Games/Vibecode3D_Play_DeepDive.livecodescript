######################################################################################
## CARD SCRIPT: "Play.DeepDive"   DEEP DIVE  (11 13 2026)
## A diver brings pearls up from the sea bed. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/12_Deep_Dive), script corrected by Claude.
## CONTROLS  arrows: swim    Space: play again after the end    Escape: pause
## RULES     air runs down under water and fills up at the surface. Touch a pearl to
##           take it. A fish, or no air, costs a life; three lives. All the pearls:
##           the next level, with more and faster fish and less air. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sDiver, sX, sY, sFish, sPearl, sPearls, sAir, sAirMax, sSafe
local sLevel, sLives, sScore, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kSurface = -240
constant kBed = 260
constant kSwim = 7

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   Dive.StartLevel 1
end Game.OnStart

-- Spark's table: fish | fish speed | pearls | air seconds
on Dive.StartLevel pLevel
   local tRow, tN, tDir
   put pLevel into sLevel
   put line pLevel of ("3,3,4,26" & cr & "4,3.6,5,24" & cr & "5,4.2,6,22" & cr & "6,4.8,7,20" & cr & "7,5.5,8,18") into tRow
   put item 4 of tRow * 30 into sAirMax
   Scene.ClearAll
   Mesh.Define "Dive.Diver", MeshBox(34, 16, 12)
   Mesh.Define "Dive.Fish", MeshPyramid(3, 14, 36)
   Mesh.Define "Dive.Pearl", MeshSphere(8, 4, 6)
   Mesh.Define "Dive.Line", MeshBox(kRight - kLeft, 3, 3)
   get Entity.Spawn("Dive.Line", 0, kSurface, kZ, "cyan")
   get Entity.Spawn("Dive.Line", 0, kBed + 14, kZ, "#8A5A2A")
   -- each fish keeps to its own depth and crosses again and again
   put empty into sFish
   repeat with tN = 1 to item 1 of tRow
      put 1 into tDir
      if tN mod 2 = 0 then put -1 into tDir
      put kSurface + 70 + (tN - 1) * ((kBed - kSurface - 130) / item 1 of tRow) into sFish[tN]["y"]
      put kLeft + ((tN * 211 + pLevel * 67) mod 900) into sFish[tN]["x"]
      put item 2 of tRow * tDir * (0.8 + (tN mod 3) * 0.2) into sFish[tN]["v"]
      put Entity.Spawn("Dive.Fish", sFish[tN]["x"], sFish[tN]["y"], kZ, "orange") into sFish[tN]["key"]
      SetObjectRotation sFish[tN]["key"], 0, 0, tDir * 1.5708
   end repeat
   put empty into sPearl
   put item 3 of tRow into sPearls
   repeat with tN = 1 to sPearls
      put kLeft + 60 + (tN - 0.5) * (780 / sPearls) + ((tN * 37 + pLevel * 11) mod 40) - 20 into sPearl[tN]["x"]
      put Entity.Spawn("Dive.Pearl", sPearl[tN]["x"], kBed, kZ, "white") into sPearl[tN]["key"]
   end repeat
   put Entity.Spawn("Dive.Diver", 0, kSurface, kZ, "yellow") into sDiver
   Dive.Up
end Dive.StartLevel

-- back at the surface with full air
on Dive.Up
   put 0 into sX
   put kSurface into sY
   put sAirMax into sAir
   put 30 into sSafe
   put empty into sHUDWas
end Dive.Up

function Dive.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Dive.Keys

on Dive.TestKeys pKeys
   put pKeys into sTestKeys
end Dive.TestKeys

on Game.OnUpdate
   local tKeys, tN
   put Dive.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Dive.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kSwim from sX
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kSwim to sX
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then subtract kSwim from sY
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then add kSwim to sY
   put max(kLeft + 20, min(kRight - 20, sX)) into sX
   put max(kSurface, min(kBed, sY)) into sY
   SetObjectPosition sDiver, sX, sY, kZ
   if sY <= kSurface + 4 then
      put min(sAirMax, sAir + 12) into sAir
   else
      subtract 1 from sAir
   end if
   if sAir mod 30 = 0 then put empty into sHUDWas
   if sSafe > 0 then subtract 1 from sSafe
   repeat for each key tN in sFish
      add sFish[tN]["v"] to sFish[tN]["x"]
      if sFish[tN]["x"] > kRight + 40 then put kLeft - 40 into sFish[tN]["x"]
      if sFish[tN]["x"] < kLeft - 40 then put kRight + 40 into sFish[tN]["x"]
      SetObjectPosition sFish[tN]["key"], sFish[tN]["x"], sFish[tN]["y"], kZ
      if sSafe = 0 and abs(sFish[tN]["x"] - sX) < 34 and abs(sFish[tN]["y"] - sY) < 20 then
         Dive.Hurt
         exit Game.OnUpdate
      end if
   end repeat
   if sAir <= 0 then
      Dive.Hurt
      exit Game.OnUpdate
   end if
   repeat for each key tN in sPearl
      if abs(sPearl[tN]["x"] - sX) < 26 and sY > kBed - 24 then
         Entity.Kill sPearl[tN]["key"]
         delete variable sPearl[tN]
         subtract 1 from sPearls
         add 50 to sScore
         put empty into sHUDWas
      end if
   end repeat
   if sPearls <= 0 then
      add sAir div 30 * 5 to sScore
      if sLevel >= 5 then
         put true into sOver
         put empty into sHUDWas
      else
         Dive.StartLevel sLevel + 1
      end if
   end if
   Dive.ShowHUD
end Game.OnUpdate

on Dive.Hurt
   subtract 1 from sLives
   FX.Sparks sX, sY, kZ, 12, "red"
   if sLives <= 0 then put true into sOver
   Dive.Up
   Dive.ShowHUD
end Dive.Hurt

on Dive.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sPearls & "|" & sAir div 30 & "|" & sOver into tWords
   if tWords is sHUDWas then exit Dive.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Dive.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  PEARLS LEFT" && sPearls && "  AIR" && max(0, sAir div 30), 20, 120, 14
   HUD.Remove "Dive.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Dive.Msg", "EVERY PEARL IS UP.  SPACE TO PLAY AGAIN", 210, 300, 16
   else if sOver then
      HUD.Set "Dive.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Dive.ShowHUD

function Dive.State
   return sLevel & "|" & sLives & "|" & sScore & "|pearls " & sPearls & "|at " & round(sX) & "," & round(sY) & "|air " & sAir div 30 & "|" & sOver
end Dive.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
