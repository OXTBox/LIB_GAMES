######################################################################################
## CARD SCRIPT: "Play.CityShield"   CITY SHIELD  (11 13 2026)
## Streaks fall on six city blocks; your bursts stop them. Spark's concept and level
## numbers (LIB_SPARK/arcade/out/11_City_Shield), script corrected by Claude.
## CONTROLS  arrows: move the aiming cross    Space: fire a burst there    Escape: pause
## RULES     a burst grows for a second and destroys every streak inside it. Bursts
##           are counted: each level gives so many. A streak that lands takes its city
##           block. Survive the level's streaks to move on; no blocks left ends the
##           game. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sCross, sAX, sAY, sCity, sStreak, sStreakN, sToCome, sNextAt, sBurst, sBurstN, sBursts
local sLevel, sScore, sSpeed, sRadius, sT, sOver, sWon, sTestKeys, sHUDWas, sSpaceWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kGround = 270
constant kAimSpeed = 12

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put false into sOver
   put false into sWon
   put empty into sCity
   City.StartLevel 1
end Game.OnStart

-- Spark's table: streaks | streak speed | bursts allowed | burst radius
on City.StartLevel pLevel
   local tRow, tN
   put pLevel into sLevel
   put line pLevel of ("10,1.6,16,70" & cr & "14,2.0,20,65" & cr & "18,2.4,24,60" & cr & "22,2.8,27,55" & cr & "26,3.3,30,50") into tRow
   put item 1 of tRow into sToCome
   put item 2 of tRow into sSpeed
   put item 3 of tRow into sBursts
   put item 4 of tRow into sRadius
   Scene.ClearAll
   Mesh.Define "City.Block", MeshBox(70, 40, 20)
   Mesh.Define "City.Streak", MeshBox(6, 18, 6)
   Mesh.Define "City.Cross", MeshPrism(4, 14, 4)
   Mesh.Define "City.Burst", MeshPrism(12, 10, 4)
   -- the blocks still standing carry over from level to level
   repeat with tN = 1 to 6
      if pLevel = 1 then put true into sCity[tN]["up"]
      put (tN - 3.5) * 140 into sCity[tN]["x"]
      put empty into sCity[tN]["key"]
      if sCity[tN]["up"] then put Entity.Spawn("City.Block", sCity[tN]["x"], kGround - 20, kZ, "cyan") into sCity[tN]["key"]
   end repeat
   put empty into sStreak
   put 0 into sStreakN
   put empty into sBurst
   put 0 into sBurstN
   put 0 into sT
   put 30 into sNextAt
   put 0 into sAX
   put 0 into sAY
   put Entity.Spawn("City.Cross", 0, 0, kZ, "white") into sCross
   put empty into sHUDWas
end City.StartLevel

function City.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end City.Keys

on City.TestKeys pKeys
   put pKeys into sTestKeys
end City.TestKeys

on Game.OnUpdate
   local tKeys, tSpace, tN, tB, tTo, tD, tDX, tDY, tR, tHit, tUp, tList
   put City.Keys() into tKeys
   put (32 is among the items of tKeys) into tSpace
   if sOver then
      if tSpace and sSpaceWas is not true then
         put 0 into sScore
         put false into sOver
         put false into sWon
         City.StartLevel 1
      end if
      put tSpace into sSpaceWas
      exit Game.OnUpdate
   end if
   if 65361 is among the items of tKeys then subtract kAimSpeed from sAX
   if 65363 is among the items of tKeys then add kAimSpeed to sAX
   if 65362 is among the items of tKeys then subtract kAimSpeed from sAY
   if 65364 is among the items of tKeys then add kAimSpeed to sAY
   put max(kLeft, min(kRight, sAX)) into sAX
   put max(kTop, min(kGround - 60, sAY)) into sAY
   SetObjectPosition sCross, sAX, sAY, kZ
   if tSpace and sSpaceWas is not true and sBursts > 0 then
      subtract 1 from sBursts
      add 1 to sBurstN
      put sAX into sBurst[sBurstN]["x"]
      put sAY into sBurst[sBurstN]["y"]
      put 0 into sBurst[sBurstN]["age"]
      put Entity.Spawn("City.Burst", sAX, sAY, kZ, "orange") into sBurst[sBurstN]["key"]
      put empty into sHUDWas
   end if
   put tSpace into sSpaceWas
   add 1 to sT
   -- a new streak now and then, aimed at a block still standing
   if sToCome > 0 and sT >= sNextAt then
      put empty into tList
      repeat with tN = 1 to 6
         if sCity[tN]["up"] then put tN & cr after tList
      end repeat
      if tList is not empty then
         put line random(the number of lines of tList) of tList into tTo
         subtract 1 from sToCome
         add 1 to sStreakN
         put random(kRight - kLeft) + kLeft into sStreak[sStreakN]["x"]
         put kTop - 10 into sStreak[sStreakN]["y"]
         put tTo into sStreak[sStreakN]["to"]
         put sCity[tTo]["x"] - sStreak[sStreakN]["x"] into tDX
         put kGround - 20 - (kTop - 10) into tDY
         put sqrt(tDX * tDX + tDY * tDY) into tD
         put tDX / tD * sSpeed into sStreak[sStreakN]["vx"]
         put tDY / tD * sSpeed into sStreak[sStreakN]["vy"]
         put Entity.Spawn("City.Streak", sStreak[sStreakN]["x"], sStreak[sStreakN]["y"], kZ, "red") into sStreak[sStreakN]["key"]
         put sT + 25 + random(max(10, 70 - sLevel * 10)) into sNextAt
         put empty into sHUDWas
      end if
   end if
   -- bursts grow for 30 steps, then go
   repeat for each key tB in sBurst
      add 1 to sBurst[tB]["age"]
      if sBurst[tB]["age"] > 30 then
         Entity.Kill sBurst[tB]["key"]
         delete variable sBurst[tB]
      else if sBurst[tB]["age"] mod 6 = 0 then
         FX.Sparks sBurst[tB]["x"], sBurst[tB]["y"], kZ, 6, "orange"
      end if
   end repeat
   repeat for each key tN in sStreak
      add sStreak[tN]["vx"] to sStreak[tN]["x"]
      add sStreak[tN]["vy"] to sStreak[tN]["y"]
      SetObjectPosition sStreak[tN]["key"], sStreak[tN]["x"], sStreak[tN]["y"], kZ
      put false into tHit
      repeat for each key tB in sBurst
         put sRadius * min(1, sBurst[tB]["age"] / 15) into tR
         put sStreak[tN]["x"] - sBurst[tB]["x"] into tDX
         put sStreak[tN]["y"] - sBurst[tB]["y"] into tDY
         if tDX * tDX + tDY * tDY <= tR * tR then
            put true into tHit
            add 25 to sScore
            FX.Sparks sStreak[tN]["x"], sStreak[tN]["y"], kZ, 8, "yellow"
            exit repeat
         end if
      end repeat
      if not tHit and sStreak[tN]["y"] >= kGround - 30 then
         put true into tHit
         put sStreak[tN]["to"] into tTo
         if sCity[tTo]["up"] then
            put false into sCity[tTo]["up"]
            Entity.Kill sCity[tTo]["key"]
            FX.Sparks sCity[tTo]["x"], kGround - 20, kZ, 20, "red"
         end if
      end if
      if tHit then
         Entity.Kill sStreak[tN]["key"]
         delete variable sStreak[tN]
         put empty into sHUDWas
      end if
   end repeat
   put 0 into tUp
   repeat with tN = 1 to 6
      if sCity[tN]["up"] then add 1 to tUp
   end repeat
   if tUp = 0 then
      put true into sOver
      put empty into sHUDWas
   else if sToCome <= 0 and the number of lines of the keys of sStreak = 0 then
      add tUp * 100 + sBursts * 5 to sScore
      if sLevel >= 5 then
         put true into sOver
         put true into sWon
         put empty into sHUDWas
      else
         City.StartLevel sLevel + 1
      end if
   end if
   City.ShowHUD
end Game.OnUpdate

on City.ShowHUD
   local tWords
   put sLevel & "|" & sScore & "|" & sBursts & "|" & sToCome & "|" & sOver into tWords
   if tWords is sHUDWas then exit City.ShowHUD
   put tWords into sHUDWas
   HUD.Set "City.Score", "SCORE" && sScore && "  BURSTS" && sBursts && "  STREAKS TO COME" && sToCome && "  LEVEL" && sLevel, 20, 20, 14
   HUD.Remove "City.Msg"
   if sOver and sWon then
      HUD.Set "City.Msg", "THE CITY STANDS.  SPACE TO PLAY AGAIN", 210, 200, 16
   else if sOver then
      HUD.Set "City.Msg", "THE CITY IS GONE.  SPACE TO PLAY AGAIN", 210, 200, 16
   end if
end City.ShowHUD

function City.State
   local tN, tUp
   put 0 into tUp
   repeat with tN = 1 to 6
      if sCity[tN]["up"] then add 1 to tUp
   end repeat
   return sLevel & "|" & sScore & "|blocks " & tUp & "|bursts " & sBursts & "|to come " & sToCome & "|in the air " & the number of lines of the keys of sStreak & "|" & sOver
end City.State

on Game.OnStop
   HUD.Clear
end Game.OnStop
