######################################################################################
## CARD SCRIPT: "Play.WallBreaker"   WALL BREAKER  (11 13 2026)
## A bat, a ball, rows of bricks. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/02_Wall_Breaker), script corrected by Claude.
## CONTROLS  Left/Right arrows: move the bat    Space: launch    Escape: pause
## RULES     knock out every brick to finish the level. Red bricks take two hits.
##           The ball past the bat costs a life; three lives. 5 levels.
######################################################################################

global bPaused, bPlaying

local sBat, sBall, sBatX, sBatW, sBX, sBY, sDX, sDY, sStuck, sSpeed
local sBrick, sBricksLeft, sLevel, sLives, sScore, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kBottom = 300
constant kBatY = 270
constant kBatSpeed = 15
constant kCols = 10
constant kBrickW = 84
constant kBrickH = 26

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
   Wall.StartLevel 1
end Game.OnStart

-- Spark's table: ball speed | bat width | brick rows | (lives are kept across levels)
on Wall.StartLevel pLevel
   local tRow, tRows, tR, tC, tN, tStrong, tColor
   put pLevel into sLevel
   put line pLevel of ("7,150,3" & cr & "8,140,4" & cr & "9,130,5" & cr & "10,120,6" & cr & "11,110,7") into tRow
   put item 1 of tRow into sSpeed
   put item 2 of tRow into sBatW
   put item 3 of tRow into tRows
   Scene.ClearAll
   Mesh.Define "Wall.Bat", Mesh.Box(sBatW, 14, 14)
   Mesh.Define "Wall.Ball", Mesh.Box(14, 14, 14)
   Mesh.Define "Wall.Brick", Mesh.Box(kBrickW - 6, kBrickH - 6, 14)
   put empty into sBrick
   put 0 into sBricksLeft
   repeat with tR = 1 to tRows
      repeat with tC = 1 to kCols
         put (tR - 1) * kCols + tC into tN
         -- from level 3 the top rows are strong: two hits
         put (pLevel >= 3 and tR <= pLevel - 2) into tStrong
         put "yellow" into tColor
         if tR mod 2 = 0 then put "green" into tColor
         if tStrong then put "red" into tColor
         put kLeft + 30 + (tC - 0.5) * kBrickW into sBrick[tN]["x"]
         put kTop + 50 + (tR - 0.5) * kBrickH into sBrick[tN]["y"]
         put 1 into sBrick[tN]["hits"]
         if tStrong then put 2 into sBrick[tN]["hits"]
         put Entity.Spawn("Wall.Brick", sBrick[tN]["x"], sBrick[tN]["y"], kZ, tColor) into sBrick[tN]["key"]
         add 1 to sBricksLeft
      end repeat
   end repeat
   put 0 into sBatX
   put Entity.Spawn("Wall.Bat", 0, kBatY, kZ, "cyan") into sBat
   put Entity.Spawn("Wall.Ball", 0, kBatY - 16, kZ, "white") into sBall
   put true into sStuck
   put empty into sHUDWas
end Wall.StartLevel

function Wall.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Wall.Keys

on Wall.TestKeys pKeys
   put pKeys into sTestKeys
end Wall.TestKeys

on Game.OnUpdate
   local tKeys, tHalf, tN, tHitX, tHitY
   put Wall.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Wall.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   put sBatW / 2 into tHalf
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kBatSpeed from sBatX
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kBatSpeed to sBatX
   put max(kLeft + tHalf, min(kRight - tHalf, sBatX)) into sBatX
   Entity.SetPosition sBat, sBatX, kBatY, kZ
   if sStuck then
      put sBatX into sBX
      put kBatY - 16 into sBY
      if 32 is among the items of tKeys then
         put false into sStuck
         put sSpeed * 0.5 into sDX
         put -sSpeed into sDY
      end if
      Entity.SetPosition sBall, sBX, sBY, kZ
      Wall.ShowHUD
      exit Game.OnUpdate
   end if
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
   -- the bat: where the ball lands on it sets the angle
   if sDY > 0 and sBY >= kBatY - 14 and sBY <= kBatY + 6 and abs(sBX - sBatX) <= tHalf + 7 then
      put (sBX - sBatX) / tHalf * sSpeed * 0.9 into sDX
      put -sSpeed into sDY
   end if
   -- bricks: at most one a step
   repeat for each key tN in sBrick
      put abs(sBX - sBrick[tN]["x"]) into tHitX
      put abs(sBY - sBrick[tN]["y"]) into tHitY
      if tHitX <= kBrickW / 2 + 4 and tHitY <= kBrickH / 2 + 4 then
         if tHitX / kBrickW > tHitY / kBrickH then
            put -sDX into sDX
         else
            put -sDY into sDY
         end if
         subtract 1 from sBrick[tN]["hits"]
         FX.Sparks sBrick[tN]["x"], sBrick[tN]["y"], kZ, 5, "yellow"
         if sBrick[tN]["hits"] <= 0 then
            Entity.Kill sBrick[tN]["key"]
            delete variable sBrick[tN]
            subtract 1 from sBricksLeft
            add 10 to sScore
         end if
         put empty into sHUDWas
         exit repeat
      end if
   end repeat
   Entity.SetPosition sBall, sBX, sBY, kZ
   if sBricksLeft <= 0 then
      if sLevel >= 5 then
         put true into sOver
      else
         Wall.StartLevel sLevel + 1
      end if
   else if sBY > kBottom + 20 then
      subtract 1 from sLives
      put true into sStuck
      put empty into sHUDWas
      if sLives <= 0 then put true into sOver
   end if
   Wall.ShowHUD
end Game.OnUpdate

on Wall.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sStuck & "|" & sOver into tWords
   if tWords is sHUDWas then exit Wall.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Wall.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Wall.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Wall.Msg", "EVERY WALL IS DOWN.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Wall.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   else if sStuck then
      HUD.Set "Wall.Msg", "SPACE TO LAUNCH", 320, 300, 16
   end if
end Wall.ShowHUD

function Wall.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sBricksLeft & "|" & round(sBX) & "," & round(sBY) & "|" & sStuck & "|" & sOver
end Wall.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
