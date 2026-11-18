######################################################################################
## CARD SCRIPT: "Play.SkyRaiders"   SKY RAIDERS  (11 13 2026)
## Rows of raiders march down the sky; one cannon holds the ground. Spark's concept and
## level numbers (LIB_SPARK/arcade/out/04_Sky_Raiders), script corrected by Claude.
## CONTROLS  Left/Right arrows: slide the cannon    Space: fire    Escape: pause
## RULES     one shot of yours in the air at a time. Raiders step down at each edge and
##           speed up as their numbers fall. Red raiders take two hits. Shields soak up
##           shots from both sides. A hit on the cannon costs a life; raiders reaching
##           the ground end the game. Clear the sky to move on. 5 levels.
######################################################################################

global bPaused, bPlaying

local sCannon, sCX, sShot, sShotX, sShotY, sR, sLeftCount, sDir, sOffX, sOffY, sMarch
local sBomb, sBombN, sShield, sLevel, sLives, sScore, sSpeed, sBombChance, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kBottom = 300
constant kCannonY = 270
constant kCannonSpeed = 11
constant kShotSpeed = 16
constant kCols = 8
constant kGapX = 70
constant kGapY = 44

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   Raid.StartLevel 1
end Game.OnStart

-- Spark's table: raider rows | raider speed | raider shot chance (in 1000 a step) | shields
on Raid.StartLevel pLevel
   local tRow, tRows, tShields, tR, tC, tN, tTough, tColor
   put pLevel into sLevel
   put line pLevel of ("3,1.5,12,4" & cr & "4,1.8,16,4" & cr & "4,2.2,20,3" & cr & "5,2.6,26,2" & cr & "5,3.0,34,1") into tRow
   put item 1 of tRow into tRows
   put item 2 of tRow into sSpeed
   put item 3 of tRow into sBombChance
   put item 4 of tRow into tShields
   Scene.ClearAll
   Mesh.Define "Raid.Raider", Mesh.Box(40, 24, 14)
   Mesh.Define "Raid.Cannon", Mesh.Pyramid(4, 26, 30)
   Mesh.Define "Raid.Shot", Mesh.Box(4, 16, 4)
   Mesh.Define "Raid.Bomb", Mesh.Box(6, 12, 6)
   Mesh.Define "Raid.Shield", Mesh.Box(70, 20, 14)
   put empty into sR
   put 0 into sLeftCount
   repeat with tR = 1 to tRows
      repeat with tC = 1 to kCols
         put (tR - 1) * kCols + tC into tN
         put (pLevel >= 3 and tR = 1) into tTough
         put "green" into tColor
         if tR mod 2 = 0 then put "magenta" into tColor
         if tTough then put "red" into tColor
         put (tC - (kCols + 1) / 2) * kGapX into sR[tN]["x"]
         put kTop + 40 + (tR - 1) * kGapY into sR[tN]["y"]
         put 1 into sR[tN]["hits"]
         if tTough then put 2 into sR[tN]["hits"]
         put Entity.Spawn("Raid.Raider", sR[tN]["x"], sR[tN]["y"], kZ, tColor) into sR[tN]["key"]
         add 1 to sLeftCount
      end repeat
   end repeat
   put empty into sShield
   repeat with tN = 1 to tShields
      put (tN - (tShields + 1) / 2) * 200 into sShield[tN]["x"]
      put 4 into sShield[tN]["hits"]
      put Entity.Spawn("Raid.Shield", sShield[tN]["x"], 200, kZ, "cyan") into sShield[tN]["key"]
   end repeat
   put 1 into sDir
   put 0 into sOffX
   put 0 into sOffY
   put 0 into sCX
   put empty into sShot
   put empty into sBomb
   put 0 into sBombN
   put Entity.Spawn("Raid.Cannon", 0, kCannonY, kZ, "white") into sCannon
   put empty into sHUDWas
end Raid.StartLevel

function Raid.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Raid.Keys

on Raid.TestKeys pKeys
   put pKeys into sTestKeys
end Raid.TestKeys

on Game.OnUpdate
   local tKeys, tN, tX, tY, tMinX, tMaxX, tMaxY, tStep, tB, tHit, tPick, tList
   put Raid.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Raid.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kCannonSpeed from sCX
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kCannonSpeed to sCX
   put max(kLeft + 20, min(kRight - 20, sCX)) into sCX
   Entity.SetPosition sCannon, sCX, kCannonY, kZ
   if 32 is among the items of tKeys and sShot is empty then
      put sCX into sShotX
      put kCannonY - 24 into sShotY
      put Entity.Spawn("Raid.Shot", sShotX, sShotY, kZ, "yellow") into sShot
   end if
   -- the march: faster as fewer are left; a step down and a turn at each edge
   put sSpeed * (1 + (kCols * 5 - sLeftCount) / 20) into tStep
   add tStep * sDir to sOffX
   put 9999 into tMinX
   put -9999 into tMaxX
   put -9999 into tMaxY
   repeat for each key tN in sR
      put sR[tN]["x"] + sOffX into tX
      put sR[tN]["y"] + sOffY into tY
      put min(tMinX, tX) into tMinX
      put max(tMaxX, tX) into tMaxX
      put max(tMaxY, tY) into tMaxY
      Entity.SetPosition sR[tN]["key"], tX, tY, kZ
   end repeat
   if sDir > 0 and tMaxX > kRight - 30 or sDir < 0 and tMinX < kLeft + 30 then
      put -sDir into sDir
      add 18 to sOffY
   end if
   if tMaxY > kCannonY - 30 then
      put true into sOver
      put 0 into sLives
      put empty into sHUDWas
   end if
   -- your shot
   if sShot is not empty then
      subtract kShotSpeed from sShotY
      Entity.SetPosition sShot, sShotX, sShotY, kZ
      put false into tHit
      repeat for each key tN in sR
         if abs(sShotX - sR[tN]["x"] - sOffX) <= 24 and abs(sShotY - sR[tN]["y"] - sOffY) <= 18 then
            put true into tHit
            subtract 1 from sR[tN]["hits"]
            FX.Sparks sShotX, sShotY, kZ, 6, "yellow"
            if sR[tN]["hits"] <= 0 then
               Entity.Kill sR[tN]["key"]
               delete variable sR[tN]
               subtract 1 from sLeftCount
               add 10 to sScore
               put empty into sHUDWas
            end if
            exit repeat
         end if
      end repeat
      if not tHit then put Raid.HitShield(sShotX, sShotY) into tHit
      if tHit or sShotY < kTop - 10 then
         Entity.Kill sShot
         put empty into sShot
      end if
   end if
   -- their shots: a random raider drops one
   if sLeftCount > 0 and random(1000) <= sBombChance then
      put the keys of sR into tList
      put line random(the number of lines of tList) of tList into tPick
      add 1 to sBombN
      put sR[tPick]["x"] + sOffX into sBomb[sBombN]["x"]
      put sR[tPick]["y"] + sOffY + 16 into sBomb[sBombN]["y"]
      put Entity.Spawn("Raid.Bomb", sBomb[sBombN]["x"], sBomb[sBombN]["y"], kZ, "orange") into sBomb[sBombN]["key"]
   end if
   repeat for each key tB in sBomb
      add 6 + sLevel to sBomb[tB]["y"]
      Entity.SetPosition sBomb[tB]["key"], sBomb[tB]["x"], sBomb[tB]["y"], kZ
      put Raid.HitShield(sBomb[tB]["x"], sBomb[tB]["y"]) into tHit
      if not tHit and abs(sBomb[tB]["x"] - sCX) <= 22 and abs(sBomb[tB]["y"] - kCannonY) <= 16 then
         put true into tHit
         subtract 1 from sLives
         FX.Sparks sCX, kCannonY, kZ, 14, "red"
         put empty into sHUDWas
         if sLives <= 0 then put true into sOver
      end if
      if tHit or sBomb[tB]["y"] > kBottom + 10 then
         Entity.Kill sBomb[tB]["key"]
         delete variable sBomb[tB]
      end if
   end repeat
   if sLeftCount <= 0 then
      if sLevel >= 5 then
         put true into sOver
      else
         Raid.StartLevel sLevel + 1
      end if
   end if
   Raid.ShowHUD
end Game.OnUpdate

-- a shot at x,y lands on a shield? The shield takes the damage.
function Raid.HitShield pX, pY
   local tN
   repeat for each key tN in sShield
      if abs(pX - sShield[tN]["x"]) <= 37 and abs(pY - 200) <= 14 then
         subtract 1 from sShield[tN]["hits"]
         if sShield[tN]["hits"] <= 0 then
            Entity.Kill sShield[tN]["key"]
            delete variable sShield[tN]
         end if
         return true
      end if
   end repeat
   return false
end Raid.HitShield

on Raid.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Raid.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Raid.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Raid.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Raid.Msg", "THE SKY IS CLEAR.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Raid.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Raid.ShowHUD

function Raid.State
   return sLevel & "|" & sLives & "|" & sScore & "|left " & sLeftCount & "|off " & round(sOffX) & "," & sOffY & "|" & sOver
end Raid.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
