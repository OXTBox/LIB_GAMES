######################################################################################
## CARD SCRIPT: "Play.SoftLanding"   SOFT LANDING  (11 13 2026)
## Bring the lander down on the pad. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/10_Soft_Landing), script corrected by Claude.
## CONTROLS  Up: main engine    Left/Right: side thrusters    Space: next try    Escape: pause
## RULES     gravity pulls all the time; every burn uses fuel. Touch the yellow pad
##           slower than the level's limit to land. Rock, or too fast, is a crash;
##           three landers. 5 levels: stronger gravity, less fuel, a narrower pad.
######################################################################################

global bPaused, bPlaying

local sLander, sX, sY, sVX, sVY, sFuel, sGround, sPadCol, sPadW
local sLevel, sLives, sScore, sGravity, sMaxSpeed, sState, sTestKeys, sHUDWas, sSpaceWas

constant kZ = 600
constant kLeft = -450
constant kTop = -300
constant kBottom = 300
constant kCols = 18
constant kColW = 50
constant kThrust = 0.16
constant kSide = 0.07

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   Land.StartLevel 1
end Game.OnStart

-- Spark's table: gravity | fuel | pad width (columns) | max landing speed
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Land.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Land.StartLevel pLevel
   end if
end Land.GoLevel

on Land.StartLevel pLevel
   local tRow, tC, tH
   put pLevel into sLevel
   put line pLevel of ("0.05,400,3,2.4" & cr & "0.06,360,3,2.2" & cr & "0.07,320,2,2.0" & cr & "0.08,280,2,1.8" & cr & "0.09,240,1,1.6") into tRow
   put item 1 of tRow into sGravity
   put item 2 of tRow into sFuel
   put item 3 of tRow into sPadW
   put item 4 of tRow into sMaxSpeed
   Scene.ClearAll
   Mesh.Define "Land.Lander", Mesh.Pyramid(4, 16, 26)
   -- rough ground: a column of rock every 50 units, the pad flat and low
   put 4 + (pLevel * 5) mod (kCols - 8) into sPadCol
   put empty into sGround
   repeat with tC = 1 to kCols
      put 40 + ((tC * 37 + pLevel * 53) mod 7) * 22 into tH
      if tC >= sPadCol and tC < sPadCol + sPadW then put 30 into tH
      put kBottom - tH into sGround[tC]
      Mesh.Define "Land.Rock" & tC, Mesh.Box(kColW, tH, 20)
      if tC >= sPadCol and tC < sPadCol + sPadW then
         get Entity.Spawn("Land.Rock" & tC, kLeft + (tC - 0.5) * kColW, kBottom - tH / 2, kZ, "yellow")
      else
         get Entity.Spawn("Land.Rock" & tC, kLeft + (tC - 0.5) * kColW, kBottom - tH / 2, kZ, "#8A5A2A")
      end if
   end repeat
   put -300 + pLevel * 40 into sX
   put kTop + 40 into sY
   put 1.2 into sVX
   put 0 into sVY
   put "fly" into sState
   put Entity.Spawn("Land.Lander", sX, sY, kZ, "white") into sLander
   put empty into sHUDWas
   Sound.Play "Warp"
end Land.StartLevel

function Land.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Land.Keys

on Land.TestKeys pKeys
   put pKeys into sTestKeys
end Land.TestKeys

on Game.OnUpdate
   local tKeys, tC, tSpace, tPress
   put Land.Keys() into tKeys
   put (32 is among the items of tKeys) into tSpace
   put (tSpace and sSpaceWas is not true) into tPress
   put tSpace into sSpaceWas
   if sState is not "fly" then
      if tPress then
         Sound.Play "Select"
         if sState is "landed" then
            if sLevel >= 5 then
               put 3 into sLives
               put 0 into sScore
               Land.GoLevel 1
            else
               Land.GoLevel sLevel + 1
            end if
         else if sLives <= 0 then
            put 3 into sLives
            put 0 into sScore
            Land.GoLevel 1
         else
            Land.StartLevel sLevel
         end if
      end if
      exit Game.OnUpdate
   end if
   add sGravity to sVY
   if sFuel > 0 then
      if (65362 is among the items of tKeys or 119 is among the items of tKeys) then
         subtract kThrust from sVY
         subtract 2 from sFuel
         if random(2) = 1 then FX.Sparks sX, sY + 18, kZ, 1, "orange"
      end if
      if (65361 is among the items of tKeys or 97 is among the items of tKeys) then
         subtract kSide from sVX
         subtract 1 from sFuel
      end if
      if (65363 is among the items of tKeys or 100 is among the items of tKeys) then
         add kSide to sVX
         subtract 1 from sFuel
      end if
      if sFuel mod 20 = 0 then put empty into sHUDWas
   end if
   add sVX to sX
   add sVY to sY
   if sX < kLeft + 10 then
      put kLeft + 10 into sX
      put 0 into sVX
   end if
   if sX > -kLeft - 10 then
      put -kLeft - 10 into sX
      put 0 into sVX
   end if
   if sY < kTop then put kTop into sY
   Entity.SetPosition sLander, sX, sY, kZ
   put max(1, min(kCols, trunc((sX - kLeft) / kColW) + 1)) into tC
   if sY + 13 >= sGround[tC] then
      if tC >= sPadCol and tC < sPadCol + sPadW and sVY <= sMaxSpeed and abs(sVX) <= sMaxSpeed then
         put "landed" into sState
         Sound.Play "Thud"
         Sound.Play "Win"
         add 100 + max(0, sFuel) to sScore
      else
         put "crashed" into sState
         subtract 1 from sLives
         FX.Sparks sX, sY, kZ, 20, "red"
         Sound.Play "Explode"
         if sLives <= 0 then
            Sound.Play "Lose"
         else
            Sound.Play "PlayerCrash"
         end if
      end if
      put empty into sHUDWas
   end if
   Land.ShowHUD
end Game.OnUpdate

on Land.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sFuel div 20 & "|" & sState into tWords
   if tWords is sHUDWas then exit Land.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Land.Score", "SCORE" && sScore && "  LANDERS" && sLives && "  LEVEL" && sLevel && "  FUEL" && max(0, sFuel), 20, 120, 14
   HUD.Remove "Land.Msg"
   if sState is "landed" and sLevel >= 5 then
      HUD.Set "Land.Msg", "FIVE SOFT LANDINGS.  SPACE TO PLAY AGAIN", 200, 200, 16
   else if sState is "landed" then
      HUD.Set "Land.Msg", "DOWN SAFE.  SPACE FOR THE NEXT ONE", 230, 200, 16
   else if sState is "crashed" and sLives <= 0 then
      HUD.Set "Land.Msg", "NO LANDERS LEFT.  SPACE TO PLAY AGAIN", 210, 200, 16
   else if sState is "crashed" then
      HUD.Set "Land.Msg", "CRASHED.  SPACE TO TRY AGAIN", 260, 200, 16
   end if
end Land.ShowHUD

function Land.State
   return sLevel & "|" & sLives & "|" & sScore & "|at " & round(sX) & "," & round(sY) & "|v " & round(sVX, 1) & "," & round(sVY, 1) & "|fuel " & sFuel & "|pad col " & sPadCol & "|" & sState
end Land.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
