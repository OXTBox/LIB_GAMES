######################################################################################
## CARD SCRIPT: "Play.CrossTraffic"   CROSS TRAFFIC  (11 13 2026)
## A walker hops across lanes of traffic. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/07_Cross_Traffic), script corrected by Claude.
## CONTROLS  arrows: one hop a press    Space: play again after the end    Escape: pause
## RULES     reach the top strip to score, three times a level. A car, or the clock
##           running out, costs a life; three lives. 5 levels.
######################################################################################

global bPaused, bPlaying

local sWalker, sCol, sRow, sWas, sCar, sLanes, sLevel, sLives, sScore, sHome, sTime, sLimit
local sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kHop = 50               -- a lane, and a hop sideways
constant kCols = 17

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
   Cross.StartLevel 1
end Game.OnStart

function Cross.Y pRow
   -- row 0 is the start strip at the bottom; the home strip is row sLanes + 1
   return (sLanes + 1) * kHop / 2 - pRow * kHop
end Cross.Y

-- Spark's table: lanes | car speed | cars per lane | time limit (seconds)
on Cross.StartLevel pLevel
   local tRow, tLane, tN, tCars, tSpeed, tDir, tK
   put pLevel into sLevel
   put line pLevel of ("4,3,2,40" & cr & "5,3.6,2,40" & cr & "6,4.2,3,35" & cr & "7,5,3,35" & cr & "8,5.8,3,30") into tRow
   put item 1 of tRow into sLanes
   put item 4 of tRow into sLimit
   put item 3 of tRow into tCars
   put 0 into sHome
   Scene.ClearAll
   Mesh.Define "Cross.Walker", Mesh.Box(24, 30, 12)
   Mesh.Define "Cross.Car", Mesh.Box(70, 30, 16)
   Mesh.Define "Cross.Strip", Mesh.Box(kRight - kLeft, 4, 4)
   get Entity.Spawn("Cross.Strip", 0, Cross.Y(0) + kHop / 2, kZ, "green")
   get Entity.Spawn("Cross.Strip", 0, Cross.Y(sLanes + 1) - kHop / 2, kZ, "yellow")
   put empty into sCar
   put 0 into tK
   repeat with tLane = 1 to sLanes
      put 1 into tDir
      if tLane mod 2 = 0 then put -1 into tDir
      -- every lane its own pace
      put item 2 of tRow * (0.7 + ((tLane * 3 + pLevel) mod 5) * 0.15) into tSpeed
      repeat with tN = 1 to tCars
         add 1 to tK
         put tLane into sCar[tK]["lane"]
         put tSpeed * tDir into sCar[tK]["v"]
         put kLeft + (tN - 1) * (900 / tCars) + ((tLane * 97) mod 200) into sCar[tK]["x"]
         put Entity.Spawn("Cross.Car", sCar[tK]["x"], Cross.Y(tLane), kZ, item (tLane mod 3 + 1) of "red,orange,magenta") into sCar[tK]["key"]
      end repeat
   end repeat
   put Entity.Spawn("Cross.Walker", 0, Cross.Y(0), kZ, "white") into sWalker
   Cross.Home
end Cross.StartLevel

-- back to the start strip, the clock wound up
on Cross.Home
   put (kCols + 1) / 2 into sCol
   put 0 into sRow
   put sLimit * 30 into sTime
   put empty into sHUDWas
end Cross.Home

function Cross.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Cross.Keys

on Cross.TestKeys pKeys
   put pKeys into sTestKeys
end Cross.TestKeys

-- true once when a key goes down
function Cross.Pressed pKey, pKeys
   local tNow
   put (pKey is among the items of pKeys) into tNow
   if tNow and sWas[pKey] is not true then
      put true into sWas[pKey]
      return true
   end if
   put tNow into sWas[pKey]
   return false
end Cross.Pressed

on Game.OnUpdate
   local tKeys, tK, tX, tY
   put Cross.Keys() into tKeys
   if sOver then
      if Cross.Pressed(32, tKeys) then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Cross.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   if Cross.Pressed(65362, tKeys) then add 1 to sRow
   if Cross.Pressed(65364, tKeys) then put max(0, sRow - 1) into sRow
   if Cross.Pressed(65361, tKeys) then put max(1, sCol - 1) into sCol
   if Cross.Pressed(65363, tKeys) then put min(kCols, sCol + 1) into sCol
   put (sCol - (kCols + 1) / 2) * kHop into tX
   put Cross.Y(sRow) into tY
   Entity.SetPosition sWalker, tX, tY, kZ
   repeat for each key tK in sCar
      add sCar[tK]["v"] to sCar[tK]["x"]
      if sCar[tK]["x"] > kRight + 50 then put kLeft - 50 into sCar[tK]["x"]
      if sCar[tK]["x"] < kLeft - 50 then put kRight + 50 into sCar[tK]["x"]
      Entity.SetPosition sCar[tK]["key"], sCar[tK]["x"], Cross.Y(sCar[tK]["lane"]), kZ
      if sCar[tK]["lane"] = sRow and abs(sCar[tK]["x"] - tX) < 46 then
         Cross.Hurt tX, tY
         exit Game.OnUpdate
      end if
   end repeat
   subtract 1 from sTime
   if sTime mod 30 = 0 then put empty into sHUDWas
   if sTime <= 0 then
      Cross.Hurt tX, tY
      exit Game.OnUpdate
   end if
   if sRow > sLanes then
      add 1 to sHome
      add 50 + sTime div 30 to sScore
      if sHome >= 3 then
         if sLevel >= 5 then
            put true into sOver
            put empty into sHUDWas
         else
            Cross.StartLevel sLevel + 1
         end if
      else
         Cross.Home
      end if
   end if
   Cross.ShowHUD
end Game.OnUpdate

on Cross.Hurt pX, pY
   subtract 1 from sLives
   FX.Sparks pX, pY, kZ, 12, "red"
   if sLives <= 0 then put true into sOver
   Cross.Home
   Cross.ShowHUD
end Cross.Hurt

on Cross.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sHome & "|" & sTime div 30 & "|" & sOver into tWords
   if tWords is sHUDWas then exit Cross.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Cross.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  HOME" && sHome & "/3" && "  TIME" && sTime div 30, 20, 120, 14
   HUD.Remove "Cross.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Cross.Msg", "EVERY ROAD CROSSED.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Cross.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Cross.ShowHUD

function Cross.State
   return sLevel & "|" & sLives & "|" & sScore & "|home " & sHome & "|at " & sCol & "," & sRow & "|time " & sTime div 30 & "|" & sOver
end Cross.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
