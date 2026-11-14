######################################################################################
## CARD SCRIPT: "Play.VineRun"   VINE RUN  (11 13 2026)
## A runner crosses the jungle floor screen by screen. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/05_Vine_Run), script corrected by Claude.
## CONTROLS  Left/Right arrows: run    Space or Up: jump, grab a vine, let go    Escape: pause
## RULES     jump the pits and the rolling logs. A wide water pit has a vine: jump at
##           it to grab, ride the swing, press again to let go. Treasure scores.
##           Falling in or meeting a log costs a life; three lives. Leave each screen
##           on the right; the level's last screen ends it. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sRunner, sX, sY, sVY, sOnVine, sJumpWas
local sPit, sLog, sGem, sVineKey, sVineX, sVineT, sHasVine
local sLevel, sScreen, sScreens, sLives, sScore, sLogSpeed, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kGround = 200           -- y of the floor (down is positive)
constant kRunSpeed = 7
constant kJump = -15
constant kGravity = 1.0
constant kVineLen = 230
constant kVineTop = -120

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
   Vine.StartLevel 1
end Game.OnStart

-- Spark's table: pits | logs | log speed | treasures (a screen); screens grow with the level
on Vine.StartLevel pLevel
   put pLevel into sLevel
   put 2 + pLevel into sScreens
   put 1 into sScreen
   Vine.BuildScreen
end Vine.StartLevel

-- one screen: the same for a level and screen number every time
on Vine.BuildScreen
   local tRow, tPits, tLogs, tGems, tN, tX, tW, tSeed
   put line sLevel of ("1,1,4,3" & cr & "2,1,5,3" & cr & "2,2,6,4" & cr & "2,2,7,4" & cr & "3,3,8,5") into tRow
   put item 1 of tRow into tPits
   put item 2 of tRow into tLogs
   put item 3 of tRow into sLogSpeed
   put item 4 of tRow into tGems
   put sLevel * 31 + sScreen * 17 into tSeed
   Scene.ClearAll
   Mesh.Define "Vine.Runner", MeshBox(22, 46, 12)
   Mesh.Define "Vine.Log", MeshPrism(8, 16, 30)
   Mesh.Define "Vine.Gem", MeshPyramid(4, 12, 18)
   Mesh.Define "Vine.Rope", MeshBox(4, kVineLen, 4)
   -- the last pit of every second screen is water with a vine
   put (sScreen mod 2 = 0) into sHasVine
   put empty into sPit
   repeat with tN = 1 to tPits
      put -260 + (tN - 1) * (520 / tPits) + (tSeed * tN) mod 60 into tX
      put 70 into tW
      if sHasVine and tN = tPits then put 230 into tW
      put tX into sPit[tN]["x1"]
      put tX + tW into sPit[tN]["x2"]
      Mesh.Define "Vine.Pit" & tN, MeshBox(tW, 60, 30)
      if tW > 100 then
         get Entity.Spawn("Vine.Pit" & tN, tX + tW / 2, kGround + 30, kZ, "cyan")
         put tX + tW / 2 into sVineX
         put 0 into sVineT
         put Entity.Spawn("Vine.Rope", sVineX, kVineTop + kVineLen / 2, kZ, "green") into sVineKey
      else
         get Entity.Spawn("Vine.Pit" & tN, tX + tW / 2, kGround + 30, kZ, "#8A5A2A")
      end if
   end repeat
   -- the floor, in pieces between the pits
   Vine.Floor
   put empty into sLog
   repeat with tN = 1 to tLogs
      put kRight + tN * 260 into sLog[tN]["x"]
      put Entity.Spawn("Vine.Log", sLog[tN]["x"], kGround - 16, kZ, "orange") into sLog[tN]["key"]
   end repeat
   put empty into sGem
   repeat with tN = 1 to tGems
      put -350 + (tN * 173 + tSeed) mod 700 into sGem[tN]["x"]
      put kGround - 30 - ((tN + tSeed) mod 3) * 45 into sGem[tN]["y"]
      put Entity.Spawn("Vine.Gem", sGem[tN]["x"], sGem[tN]["y"], kZ, "yellow") into sGem[tN]["key"]
   end repeat
   put kLeft + 30 into sX
   put kGround into sY
   put 0 into sVY
   put false into sOnVine
   put Entity.Spawn("Vine.Runner", sX, sY - 23, kZ, "white") into sRunner
   put empty into sHUDWas
end Vine.BuildScreen

on Vine.Floor
   local tFrom, tN, tKeys, tW
   put kLeft into tFrom
   put the keys of sPit into tKeys
   sort lines of tKeys numeric
   repeat for each line tN in tKeys
      put sPit[tN]["x1"] - tFrom into tW
      if tW > 2 then
         Mesh.Define "Vine.Floor" & tN, MeshBox(tW, 6, 30)
         get Entity.Spawn("Vine.Floor" & tN, tFrom + tW / 2, kGround + 3, kZ, "green")
      end if
      put sPit[tN]["x2"] into tFrom
   end repeat
   put kRight - tFrom into tW
   Mesh.Define "Vine.FloorEnd", MeshBox(tW, 6, 30)
   get Entity.Spawn("Vine.FloorEnd", tFrom + tW / 2, kGround + 3, kZ, "green")
end Vine.Floor

function Vine.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Vine.Keys

on Vine.TestKeys pKeys
   put pKeys into sTestKeys
end Vine.TestKeys

function Vine.OverPit pX
   local tN
   repeat for each key tN in sPit
      if pX > sPit[tN]["x1"] + 6 and pX < sPit[tN]["x2"] - 6 then return true
   end repeat
   return false
end Vine.OverPit

on Game.OnUpdate
   local tKeys, tJump, tPress, tTipX, tTipY, tA, tN
   put Vine.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Vine.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   put (32 is among the items of tKeys or 65362 is among the items of tKeys) into tJump
   put (tJump and sJumpWas is not true) into tPress
   put tJump into sJumpWas
   -- the vine swings on its own
   if sHasVine then
      add 0.07 to sVineT
      put sin(sVineT) * 0.75 into tA
      put sVineX + sin(tA) * kVineLen into tTipX
      put kVineTop + cos(tA) * kVineLen into tTipY
      SetObjectPosition sVineKey, sVineX + sin(tA) * kVineLen / 2, kVineTop + cos(tA) * kVineLen / 2, kZ
      SetObjectRotation sVineKey, 0, 0, -tA
   end if
   if sOnVine then
      put tTipX into sX
      put tTipY + 30 into sY
      if tPress then
         put false into sOnVine
         put kJump * 0.8 into sVY
      end if
   else
      if 65361 is among the items of tKeys then subtract kRunSpeed from sX
      if 65363 is among the items of tKeys then add kRunSpeed to sX
      put max(kLeft + 12, sX) into sX
      if sY >= kGround and not Vine.OverPit(sX) then
         -- on the floor
         put kGround into sY
         put 0 into sVY
         if tPress then put kJump into sVY
      end if
      if sVY is not 0 or sY < kGround or Vine.OverPit(sX) then
         add kGravity to sVY
         add sVY to sY
         if sY >= kGround and not Vine.OverPit(sX) then
            put kGround into sY
            put 0 into sVY
         end if
      end if
      -- catch the vine in the air
      if sHasVine and sY < kGround and abs(sX - tTipX) < 34 and abs(sY - 30 - tTipY) < 50 and sVY >= -6 then
         put true into sOnVine
      end if
   end if
   SetObjectPosition sRunner, sX, sY - 23, kZ
   -- logs roll left and come round again
   repeat for each key tN in sLog
      subtract sLogSpeed from sLog[tN]["x"]
      if sLog[tN]["x"] < kLeft - 40 then put kRight + 40 + random(200) into sLog[tN]["x"]
      SetObjectPosition sLog[tN]["key"], sLog[tN]["x"], kGround - 16, kZ
      if not sOnVine and abs(sLog[tN]["x"] - sX) < 26 and sY > kGround - 30 then
         Vine.Hurt
         exit Game.OnUpdate
      end if
   end repeat
   repeat for each key tN in sGem
      if abs(sGem[tN]["x"] - sX) < 24 and abs(sGem[tN]["y"] - (sY - 23)) < 36 then
         Entity.Kill sGem[tN]["key"]
         delete variable sGem[tN]
         add 10 to sScore
         put empty into sHUDWas
      end if
   end repeat
   if sY > kGround + 70 then
      Vine.Hurt
      exit Game.OnUpdate
   end if
   if sX > kRight then
      add 25 to sScore
      if sScreen >= sScreens then
         if sLevel >= 5 then
            put true into sOver
            put empty into sHUDWas
         else
            Vine.StartLevel sLevel + 1
         end if
      else
         add 1 to sScreen
         Vine.BuildScreen
      end if
   end if
   Vine.ShowHUD
end Game.OnUpdate

on Vine.Hurt
   subtract 1 from sLives
   FX.Sparks sX, sY - 20, kZ, 12, "red"
   if sLives <= 0 then
      put true into sOver
      put empty into sHUDWas
      Vine.ShowHUD
   else
      Vine.BuildScreen
   end if
end Vine.Hurt

on Vine.ShowHUD
   local tWords
   put sLevel & "|" & sScreen & "|" & sLives & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Vine.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Vine.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  SCREEN" && sScreen & "/" & sScreens, 20, 20, 14
   HUD.Remove "Vine.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Vine.Msg", "OUT OF THE JUNGLE.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Vine.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Vine.ShowHUD

function Vine.State
   return sLevel & "|screen " & sScreen & "/" & sScreens & "|" & sLives & "|" & sScore & "|at " & round(sX) & "," & round(sY) & "|vine " & sOnVine & "|" & sOver
end Vine.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
