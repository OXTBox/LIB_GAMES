######################################################################################
## CARD SCRIPT: "Play.JaiAlaiBlock"   JAI ALAI BLOCK  (11 13 2026)
## The owner's concept (round two, 2 of 9): a little runner with a scoop hurls a ball at
## a ceiling of blocks. What it hits comes loose and falls: catch the ball, dodge the rest.
## Teaches: a grid and its destruction.
## CONTROLS  Left/Right arrows: run   Space: throw (Left/Right held = angled)   Escape: stop
## RULES     catch the returning ball in the scoop. The ball on the floor, or a block on
##           your head, costs a life. Red blocks take two hits. Clear the ceiling. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sMan, sScoop, sBall, sManX, sBX, sBY, sDX, sDY, sHeld, sSpeed, sFall
local sBlock, sLeft, sLoose, sLevel, sLives, sScore, sOver, sTestKeys, sHUDWas, sSerial

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kFloor = 290
constant kManY = 262
constant kRun = 13
constant kCols = 10
constant kBW = 84
constant kBH = 30

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
   Jai.StartLevel 1
end Game.OnStart

-- level table: ball speed | block rows | fall speed | (lives carry over)
on Jai.StartLevel pLevel
   local tRow, tR, tC, tN, tStrong, tColor
   put pLevel into sLevel
   put line pLevel of ("9,2,4" & cr & "10,3,5" & cr & "11,3,6" & cr & "12,4,7" & cr & "13,5,8") into tRow
   put item 1 of tRow into sSpeed
   put item 3 of tRow into sFall
   Scene.ClearAll
   Mesh.Define "Jai.Man", MeshBox(22, 44, 12)
   Mesh.Define "Jai.Scoop", MeshPrism(3, 20, 10)
   Mesh.Define "Jai.Ball", MeshBox(14, 14, 14)
   Mesh.Define "Jai.Block", MeshBox(kBW - 8, kBH - 8, 16)
   put empty into sBlock
   put empty into sLoose
   put 0 into sLeft
   repeat with tR = 1 to item 2 of tRow
      repeat with tC = 1 to kCols
         put (tR - 1) * kCols + tC into tN
         put (pLevel >= 3 and tR is 1) into tStrong
         put "yellow" into tColor
         if tR mod 2 = 0 then put "#40FF80" into tColor
         if tStrong then put "red" into tColor
         put kLeft + 30 + (tC - 0.5) * kBW into sBlock[tN]["x"]
         put kTop + 20 + (tR - 0.5) * kBH into sBlock[tN]["y"]
         put 1 into sBlock[tN]["hits"]
         if tStrong then put 2 into sBlock[tN]["hits"]
         put tColor into sBlock[tN]["color"]
         put Entity.Spawn("Jai.Block", sBlock[tN]["x"], sBlock[tN]["y"], kZ, tColor) into sBlock[tN]["key"]
         add 1 to sLeft
      end repeat
   end repeat
   put 0 into sManX
   put Entity.Spawn("Jai.Man", 0, kManY, kZ, "cyan") into sMan
   put Entity.Spawn("Jai.Scoop", 0, kManY - 34, kZ, "cyan") into sScoop
   put Entity.Spawn("Jai.Ball", 0, kManY - 44, kZ, "white") into sBall
   put true into sHeld
   put empty into sHUDWas
end Jai.StartLevel

function Jai.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Jai.Keys

on Jai.TestKeys pKeys
   put pKeys into sTestKeys
end Jai.TestKeys

on Game.OnUpdate
   local tKeys, tN, tK, tLean
   put Jai.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Jai.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   put 0 into tLean
   if 65361 is among the items of tKeys then
      subtract kRun from sManX
      put -1 into tLean
   end if
   if 65363 is among the items of tKeys then
      add kRun to sManX
      put 1 into tLean
   end if
   put max(kLeft + 20, min(kRight - 20, sManX)) into sManX
   SetObjectPosition sMan, sManX, kManY, kZ
   SetObjectPosition sScoop, sManX, kManY - 34, kZ
   if sHeld then
      put sManX into sBX
      put kManY - 44 into sBY
      if 32 is among the items of tKeys then
         put false into sHeld
         put tLean * sSpeed * 0.6 into sDX
         put -sSpeed into sDY
      end if
   else
      add sDX to sBX
      add sDY to sBY
      if sBX < kLeft + 7 then
         put kLeft + 7 into sBX
         put abs(sDX) into sDX
      end if
      if sBX > kRight - 7 then
         put kRight - 7 into sBX
         put -abs(sDX) into sDX
      end if
      if sBY < kTop + 7 then
         put kTop + 7 into sBY
         put abs(sDY) into sDY
      end if
      -- the ceiling: a block that is hit comes loose and falls
      repeat for each key tN in sBlock
         if abs(sBX - sBlock[tN]["x"]) <= kBW / 2 + 4 and abs(sBY - sBlock[tN]["y"]) <= kBH / 2 + 6 then
            put abs(sDY) into sDY
            subtract 1 from sBlock[tN]["hits"]
            FX.Sparks sBlock[tN]["x"], sBlock[tN]["y"], kZ, 5, "yellow"
            if sBlock[tN]["hits"] <= 0 then
               add 1 to sSerial
               put sBlock[tN] into sLoose[sSerial]
               delete variable sBlock[tN]
               subtract 1 from sLeft
               add 10 to sScore
            end if
            put empty into sHUDWas
            exit repeat
         end if
      end repeat
      -- back in the scoop, or on the floor
      if sDY > 0 and sBY >= kManY - 50 and sBY <= kManY - 20 and abs(sBX - sManX) <= 30 then
         put true into sHeld
         add 5 to sScore
         put empty into sHUDWas
      else if sBY > kFloor then
         Jai.LoseLife
      end if
   end if
   SetObjectPosition sBall, sBX, sBY, kZ
   -- loose blocks fall: on your head costs a life, on the floor they are gone
   repeat for each key tK in sLoose
      add sFall to sLoose[tK]["y"]
      SetObjectPosition sLoose[tK]["key"], sLoose[tK]["x"], sLoose[tK]["y"], kZ
      if sLoose[tK]["y"] >= kManY - 30 and abs(sLoose[tK]["x"] - sManX) <= kBW / 2 + 6 and sLoose[tK]["y"] <= kManY + 20 then
         Entity.Kill sLoose[tK]["key"]
         delete variable sLoose[tK]
         Jai.LoseLife
      else if sLoose[tK]["y"] > kFloor + 20 then
         Entity.Kill sLoose[tK]["key"]
         delete variable sLoose[tK]
      end if
   end repeat
   if sLeft <= 0 and not sOver then
      if sLevel >= 5 then
         put true into sOver
      else
         Jai.StartLevel sLevel + 1
      end if
   end if
   Jai.ShowHUD
end Game.OnUpdate

on Jai.LoseLife
   subtract 1 from sLives
   put true into sHeld
   put empty into sHUDWas
   FX.Sparks sManX, kManY, kZ, 12, "red"
   if sLives <= 0 then put true into sOver
end Jai.LoseLife

on Jai.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sHeld & "|" & sOver into tWords
   if tWords is sHUDWas then exit Jai.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Jai.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Jai.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Jai.Msg", "THE CEILING IS DOWN.  SPACE TO PLAY AGAIN", 190, 400, 16
   else if sOver then
      HUD.Set "Jai.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 400, 16
   else if sHeld then
      HUD.Set "Jai.Msg", "SPACE TO THROW", 320, 400, 16
   end if
end Jai.ShowHUD

function Jai.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sLeft & "|" & round(sBX) & "," & round(sBY) & "|" & sHeld & "|" & sOver
end Jai.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
