######################################################################################
## CARD SCRIPT: "Play.BatDuel"   BAT DUEL  (11 13 2026)
## Two bats and a ball. You hold the left edge, the computer the right. Spark's concept
## and level numbers (LIB_SPARK/arcade/out/01_Bat_Duel), script corrected by Claude.
## CONTROLS  Up/Down arrows: move your bat    Space: serve    Escape: pause
## RULES     the ball bounces off the top, the bottom and the bats; where it meets a
##           bat sets its angle. Past a bat is a point. First to the level's points
##           wins the level; lose a level and you play it again. 5 levels.
######################################################################################

global bPaused, bPlaying

local sBatL, sBatR, sBall, sLY, sRY, sBX, sBY, sDX, sDY, sServe
local sLevel, sYou, sCpu, sSpeed, sCpuSpeed, sBatH, sToWin, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kBottom = 300
constant kBatX = 420
constant kBatSpeed = 11

on Game.OnStart
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put false into sOver
   Duel.StartLevel 1
end Game.OnStart

-- Spark's table: ball speed | computer bat speed | bat height | points to win
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Duel.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Duel.StartLevel pLevel
   end if
end Duel.GoLevel

on Duel.StartLevel pLevel
   local tRow
   put pLevel into sLevel
   put line pLevel of ("7,4,120,3" & cr & "8,5,110,3" & cr & "9,6,100,4" & cr & "10,7,90,4" & cr & "12,8.5,80,5") into tRow
   put item 1 of tRow into sSpeed
   put item 2 of tRow into sCpuSpeed
   put item 3 of tRow into sBatH
   put item 4 of tRow into sToWin
   put 0 into sYou
   put 0 into sCpu
   Scene.ClearAll
   Mesh.Define "Duel.Bat", Mesh.Box(14, sBatH, 14)
   Mesh.Define "Duel.Ball", Mesh.Box(16, 16, 16)
   Mesh.Define "Duel.Edge", Mesh.Box(kRight - kLeft, 4, 4)
   get Entity.Spawn("Duel.Edge", 0, kTop - 10, kZ, "#2E6F8E")
   get Entity.Spawn("Duel.Edge", 0, kBottom + 10, kZ, "#2E6F8E")
   put 0 into sLY
   put 0 into sRY
   put Entity.Spawn("Duel.Bat", -kBatX, 0, kZ, "cyan") into sBatL
   put Entity.Spawn("Duel.Bat", kBatX, 0, kZ, "orange") into sBatR
   put Entity.Spawn("Duel.Ball", 0, 0, kZ, "white") into sBall
   Duel.Serve 1
end Duel.StartLevel

-- the ball waits in the middle until Space; pDir: 1 toward the computer, -1 toward you
on Duel.Serve pDir
   put 0 into sBX
   put 0 into sBY
   put sSpeed * pDir into sDX
   put (random(5) - 3) * 1.2 into sDY
   put true into sServe
   put empty into sHUDWas
end Duel.Serve

function Duel.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Duel.Keys

on Duel.TestKeys pKeys
   put pKeys into sTestKeys
end Duel.TestKeys

on Game.OnUpdate
   local tKeys, tHalf, tAim
   put Duel.Keys() into tKeys
   put sBatH / 2 into tHalf
   if 65362 is among the items of tKeys then subtract kBatSpeed from sLY
   if 65364 is among the items of tKeys then add kBatSpeed to sLY
   put max(kTop + tHalf, min(kBottom - tHalf, sLY)) into sLY
   Entity.SetPosition sBatL, -kBatX, sLY, kZ
   if sOver then
      if 32 is among the items of tKeys then
         put false into sOver
         Duel.GoLevel 1
      end if
      exit Game.OnUpdate
   end if
   if sServe then
      if 32 is among the items of tKeys then put false into sServe
      Duel.ShowHUD
      exit Game.OnUpdate
   end if
   -- the computer follows the ball, only as fast as the level allows, and only when it comes
   put sBY into tAim
   if sDX < 0 then put 0 into tAim
   if tAim > sRY + 6 then add min(sCpuSpeed, tAim - sRY) to sRY
   if tAim < sRY - 6 then subtract min(sCpuSpeed, sRY - tAim) from sRY
   put max(kTop + tHalf, min(kBottom - tHalf, sRY)) into sRY
   Entity.SetPosition sBatR, kBatX, sRY, kZ
   -- the ball
   add sDX to sBX
   add sDY to sBY
   if sBY < kTop + 8 then
      put kTop + 8 into sBY
      put abs(sDY) into sDY
   end if
   if sBY > kBottom - 8 then
      put kBottom - 8 into sBY
      put -abs(sDY) into sDY
   end if
   if sDX < 0 and sBX <= -kBatX + 15 and sBX >= -kBatX - 12 and abs(sBY - sLY) <= tHalf + 8 then
      put abs(sDX) into sDX
      put (sBY - sLY) / tHalf * sSpeed * 0.9 into sDY
      FX.Sparks sBX, sBY, kZ, 5, "cyan"
   end if
   if sDX > 0 and sBX >= kBatX - 15 and sBX <= kBatX + 12 and abs(sBY - sRY) <= tHalf + 8 then
      put -abs(sDX) into sDX
      put (sBY - sRY) / tHalf * sSpeed * 0.9 into sDY
      FX.Sparks sBX, sBY, kZ, 5, "orange"
   end if
   Entity.SetPosition sBall, sBX, sBY, kZ
   if sBX > kRight + 20 then
      add 1 to sYou
      Duel.Point -1
   else if sBX < kLeft - 20 then
      add 1 to sCpu
      Duel.Point 1
   end if
   Duel.ShowHUD
end Game.OnUpdate

on Duel.Point pDir
   if sYou >= sToWin then
      if sLevel >= 5 then
         put true into sOver
      else
         Duel.GoLevel sLevel + 1
      end if
   else if sCpu >= sToWin then
      Duel.StartLevel sLevel
   else
      Duel.Serve pDir
   end if
   put empty into sHUDWas
end Duel.Point

on Duel.ShowHUD
   local tWords
   put sLevel & "|" & sYou & "|" & sCpu & "|" & sServe & "|" & sOver into tWords
   if tWords is sHUDWas then exit Duel.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Duel.Score", "YOU" && sYou && "  COMPUTER" && sCpu && "  LEVEL" && sLevel && "  FIRST TO" && sToWin, 20, 120, 14
   HUD.Remove "Duel.Msg"
   if sOver then
      HUD.Set "Duel.Msg", "YOU WON ALL FIVE.  SPACE TO PLAY AGAIN", 200, 260, 16
   else if sServe then
      HUD.Set "Duel.Msg", "SPACE TO SERVE", 320, 260, 16
   end if
end Duel.ShowHUD

function Duel.State
   return sLevel & "|" & sYou & "|" & sCpu & "|" & round(sBX) & "," & round(sBY) & "|" & sServe & "|" & sOver
end Duel.State

on Game.OnStop
   HUD.Clear
end Game.OnStop
