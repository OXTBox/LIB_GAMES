######################################################################################
## CARD SCRIPT: "Play.LanternLadders"   LANTERN AND LADDERS  (11 23 2026)
## Side view, Shaft Descent upside down: climb UP a dark tower by ladders and ledges.
## Your lantern lights only the ground round you; the dark hides the gaps, the bats and
## the stones that drop down the shaft. The oil in the lantern runs down; the light
## shrinks with it. Flasks of oil on the ledges fill it. The green door at the top = next.
## Teaches: a light over the view (a gradient graphic), ladders, a following camera.
## CONTROLS  Left/Right: walk   Up/Down: climb a ladder   Shift: run (burns more oil)   Space: jump   Escape: stop
## RULES     a bat, a falling stone, or the oil running out, costs a life (back to the bottom). 5 levels.
######################################################################################
-- The torch (p1-31): one graphic "LL.Torch" ABOVE the game view, like the loading screen's veil
-- (LIB_LOADING_SCREEN): black at the edges, clear round the player, a radial fillGradient whose
-- middle follows the player's screen place (Camera.WorldToScreen), with a small random blendLevel
-- flicker. Per frame it costs at most four property sets (from, to, via, blendLevel), and none
-- when nothing changed. The words (HUD) are a field above the torch, or the dark would hide them.
-- Game.OnStop takes both away. Test: OXT-BEYOND/tests/t76_lantern_ladders.txt.

global bPaused, bPlaying
global gViewLeft, gViewTop, gViewRight, gViewBottom

local sX, sY, sVX, sVY, sOnGround, sOnLadder, sLadRow, sPlayer, sRows, sLadX, sRowCount
local sBat, sBatCount, sRock, sRockCount, sFlask, sFlaskCount, sExitX, sExitKey
local sLevel, sLives, sOil, sOilMax, sOver, sWon, sTicks, sTestKeys, sJumpWas, sRunning
local sHUDWas, sCamY, sMsg, sMsgUntil, sBest, sHazards, sCoyote
local sTorchCard, sTorchWas, sBlend, sRadius, sJitter

constant kZ = 600
constant kHalfW = 330          -- the tower runs from -330 to 330
constant kRowGap = 130         -- height between ledges (a jump reaches 110: ladders are the way up)
constant kThick = 12
constant kWalk = 4.2
constant kRunTimes = 1.7       -- Shift: 1.7x the speed, 2x the oil (as Shaft Descent's run)
constant kClimb = 3
constant kJump = -10.5
constant kGravity = 0.5
constant kFallMax = 13
constant kPW = 16
constant kPH = 34
constant kTorchMin = 70        -- the light's radius in pixels: empty lamp .. full lamp
constant kTorchMax = 180
constant kFlicker = 8          -- the torch's blendLevel stays within 0 .. kFlicker (0 = black)
constant kFlaskOil = 15        -- seconds of oil in a flask

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   if sHazards is empty then put true into sHazards
   put the long id of this card into sTorchCard
   LL.TorchMake
   LL.StartLevel
end Game.OnStart

-- level table: ledges | bats | falling stones | oil seconds | bat speed
function LL.Row pLevel
   return line pLevel of ("6,1,1,40,1.4" & cr & "8,2,2,45,1.7" & cr & "10,3,3,50,2.0" & cr & "12,4,4,55,2.3" & cr & "14,5,5,60,2.6")
end LL.Row

-- a level change through the loading screen (LIB_LOADING_SCREEN) when the host has it; else at once
on LL.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      LL.StartLevel pLevel
   end if
end LL.GoLevel

on LL.StartLevel pLevel
   local tRow, r, y, tGap, tTry, n, tSeg, x1, tH, tFound
   if pLevel is an integer and pLevel >= 1 and pLevel <= 5 then put pLevel into sLevel
   put LL.Row(sLevel) into tRow
   put item 1 of tRow into sRowCount
   put item 4 of tRow * 30 into sOilMax
   Scene.ClearAll
   set the randomSeed to 7171 + sLevel * 613
   put empty into sRows
   put empty into sLadX
   -- the tower walls
   put sRowCount * kRowGap + 300 into tH
   Mesh.Define "LL.Wall", Mesh.Box(10, tH, 30)
   get Entity.Spawn("LL.Wall", -kHalfW - 6, 100 - tH / 2, kZ, "#3A2A1C")
   get Entity.Spawn("LL.Wall", kHalfW + 6, 100 - tH / 2, kZ, "#3A2A1C")
   -- the ladders first: ladder r goes from ledge r-1 up to ledge r, never straight above the last
   put 0 into sLadX[0]
   repeat with r = 1 to sRowCount
      repeat with tTry = 1 to 20
         put (random(11) - 6) * 50 into sLadX[r]
         if abs(sLadX[r] - sLadX[r - 1]) >= 150 then exit repeat
      end repeat
   end repeat
   put (random(9) - 5) * 60 into sExitX
   put sExitX into sLadX[sRowCount + 1]
   -- the floor (whole) and the ledges, each with one gap away from both its ladders
   LL.Platform 0, -kHalfW, kHalfW
   Mesh.Define "LL.Ladder", LL.LadderMesh()
   repeat with r = 1 to sRowCount
      put empty into tGap
      if r < sRowCount then
         repeat with tTry = 1 to 30
            put (random(11) - 6) * 50 into tGap
            if abs(tGap - sLadX[r]) >= 100 and abs(tGap - sLadX[r + 1]) >= 100 then exit repeat
            put empty into tGap
         end repeat
      end if
      if tGap is empty then
         LL.Platform r, -kHalfW, kHalfW
      else
         if tGap - 40 + kHalfW > 10 then LL.Platform r, -kHalfW, tGap - 40
         if kHalfW - tGap - 40 > 10 then LL.Platform r, tGap + 40, kHalfW
      end if
      get Entity.Spawn("LL.Ladder", sLadX[r], LL.Top(r - 1) - kRowGap / 2, kZ, "#C08040")
   end repeat
   -- the green door at the top
   Mesh.Define "LL.Door", LL.DoorMesh()
   put Entity.Spawn("LL.Door", sExitX, LL.Top(sRowCount), kZ, "#40FF80") into sExitKey
   -- oil flasks on the ledges, one every second ledge, never at a gap
   put empty into sFlask
   put 0 into sFlaskCount
   Mesh.Define "LL.Flask", Mesh.Box(10, 16, 10)
   repeat with r = 1 to sRowCount - 1 step 2
      put random(500) - 250 into x1
      put false into tFound
      repeat for each line tSeg in sRows[r]
         if x1 > item 1 of tSeg + 10 and x1 < item 2 of tSeg - 10 then put true into tFound
      end repeat
      if not tFound then next repeat
      add 1 to sFlaskCount
      put x1 into sFlask[sFlaskCount]["x"]
      put LL.Top(r) - 8 into sFlask[sFlaskCount]["y"]
      put false into sFlask[sFlaskCount]["taken"]
      put Entity.Spawn("LL.Flask", x1, sFlask[sFlaskCount]["y"], kZ, "#FFC040") into sFlask[sFlaskCount]["key"]
   end repeat
   -- bats flit between the ledges (never on the floor's row)
   put empty into sBat
   put item 2 of tRow into sBatCount
   Mesh.Define "LL.Bat", LL.BatMesh()
   repeat with n = 1 to sBatCount
      put 2 + (n * 5) mod max(1, sRowCount - 2) into r
      put LL.Top(r) - 64 into sBat[n]["y"]
      put random(500) - 250 into sBat[n]["x"]
      put item 5 of tRow into sBat[n]["v"]
      if random(2) is 1 then put -item 5 of tRow into sBat[n]["v"]
      put Entity.Spawn("LL.Bat", sBat[n]["x"], sBat[n]["y"], kZ, "#B060FF") into sBat[n]["key"]
   end repeat
   -- stones that drop down the shaft from above (they pass the ledges)
   put empty into sRock
   put item 3 of tRow into sRockCount
   Mesh.Define "LL.Rock", Mesh.Sphere(8, 2, 5)
   repeat with n = 1 to sRockCount
      put Entity.Spawn("LL.Rock", 0, 99999, kZ, "#A0A0A0") into sRock[n]["key"]
   end repeat
   -- the climber: a stick figure with a lantern in the hand
   Mesh.Define "LL.Climber", LL.ClimberMesh()
   put Entity.Spawn("LL.Climber", 0, 0, kZ, "#FFE0A0") into sPlayer
   set the randomSeed to the milliseconds
   LL.Respawn
   put empty into sHUDWas
end LL.StartLevel

-- the top of ledge r (r 0 = the floor); up is negative y
function LL.Top r
   return -r * kRowGap - kThick / 2
end LL.Top

on LL.Platform r, x1, x2
   local n
   put the number of lines of sRows[r] + 1 into n
   put x1 & comma & x2 & cr after sRows[r]
   Mesh.Define "LL.P" & r & "_" & n, Mesh.Box(x2 - x1, kThick, 26)
   get Entity.Spawn("LL.P" & r & "_" & n, (x1 + x2) / 2, -r * kRowGap, kZ, "#8A5A2A")
end LL.Platform

function LL.LadderMesh
   local tM, k, y
   put Mesh.New() into tM
   Mesh.AddVertex tM, -10, -kRowGap / 2, 0
   Mesh.AddVertex tM, -10, kRowGap / 2, 0
   Mesh.AddVertex tM, 10, -kRowGap / 2, 0
   Mesh.AddVertex tM, 10, kRowGap / 2, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   repeat with k = 1 to 6
      put -kRowGap / 2 + k * kRowGap / 7 into y
      Mesh.AddVertex tM, -10, y, 0
      Mesh.AddVertex tM, 10, y, 0
      Mesh.AddLine tM, 3 + k * 2, 4 + k * 2
   end repeat
   return tM
end LL.LadderMesh

function LL.DoorMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -22, 0, 0
   Mesh.AddVertex tM, -22, -56, 0
   Mesh.AddVertex tM, 22, -56, 0
   Mesh.AddVertex tM, 22, 0, 0
   Mesh.AddVertex tM, 0, -66, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 5
   Mesh.AddLine tM, 5, 3
   Mesh.AddLine tM, 3, 4
   return tM
end LL.DoorMesh

function LL.BatMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -18, -6, 0
   Mesh.AddVertex tM, -8, 2, 0
   Mesh.AddVertex tM, 0, -2, 0
   Mesh.AddVertex tM, 8, 2, 0
   Mesh.AddVertex tM, 18, -6, 0
   Mesh.AddVertex tM, 0, 6, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 4, 5
   Mesh.AddLine tM, 3, 6
   return tM
end LL.BatMesh

function LL.ClimberMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -34, 0       -- 1 head top
   Mesh.AddVertex tM, 0, -26, 0       -- 2 neck
   Mesh.AddVertex tM, 0, -12, 0       -- 3 hip
   Mesh.AddVertex tM, -8, 0, 0        -- 4 foot
   Mesh.AddVertex tM, 8, 0, 0         -- 5 foot
   Mesh.AddVertex tM, -10, -16, 0     -- 6 hand
   Mesh.AddVertex tM, 12, -22, 0      -- 7 hand with the lantern
   Mesh.AddVertex tM, 12, -14, 0      -- 8 lantern bottom
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 3, 5
   Mesh.AddLine tM, 2, 6
   Mesh.AddLine tM, 2, 7
   Mesh.AddLine tM, 7, 8
   return tM
end LL.ClimberMesh

on LL.Respawn
   local n
   put 0 into sX
   put LL.Top(0) into sY
   put 0 into sVX
   put 0 into sVY
   put true into sOnGround
   put false into sOnLadder
   put 0 into sLadRow
   put sOilMax into sOil
   put sY - 60 into sCamY
   put 0 into sBest
   repeat with n = 1 to sRockCount
      put 30 + n * 50 into sRock[n]["wait"]
      put 99999 into sRock[n]["y"]
   end repeat
   LL.Say "UP THE DARK TOWER: FIND THE GREEN DOOR", 3
end LL.Respawn

function LL.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end LL.Keys

on LL.TestKeys pKeys
   put pKeys into sTestKeys
end LL.TestKeys

-- tests: put the climber on ledge r at x, standing
on LL.TestPlace pX, pRow
   put pX into sX
   put LL.Top(pRow) into sY
   put 0 into sVX
   put 0 into sVY
   put true into sOnGround
   put false into sOnLadder
end LL.TestPlace

-- tests: false = no bats, no stones (a quiet climb)
on LL.TestHazards pOn
   put (pOn is not false) into sHazards
end LL.TestHazards

on Game.OnUpdate
   local tKeys, tJump, tUp, tDown, tLeft, tRight, tSpeed, tOldY, r, tSeg, n, tMoving
   add 1 to sTicks
   put LL.Keys() into tKeys
   put (32 is among the items of tKeys) into tJump
   if sOver then
      if tJump and not sJumpWas then Game.OnStart
      put tJump into sJumpWas
      LL.Torch
      exit Game.OnUpdate
   end if
   put (65361 is among the items of tKeys or 97 is among the items of tKeys) into tLeft
   put (65363 is among the items of tKeys or 100 is among the items of tKeys) into tRight
   put (65362 is among the items of tKeys or 119 is among the items of tKeys) into tUp
   put (65364 is among the items of tKeys or 115 is among the items of tKeys) into tDown
   put (tLeft or tRight or tUp or tDown) into tMoving
   put tMoving and (65505 is among the items of tKeys or 65506 is among the items of tKeys) into sRunning
   put kWalk into tSpeed
   if sRunning then put kWalk * kRunTimes into tSpeed
   put sY into tOldY
   -- grab a ladder: Up at its foot (or on it), Down at its top
   if not sOnLadder and (tUp or tDown) then LL.GrabLadder tUp
   if sOnLadder then
      put 0 into sVX
      put 0 into sVY
      if tUp then subtract kClimb * (tSpeed / kWalk) from sY
      if tDown then add kClimb * (tSpeed / kWalk) to sY
      put sLadX[sLadRow] into sX
      if sY <= LL.Top(sLadRow) then
         -- off the top onto the ledge
         put LL.Top(sLadRow) into sY
         put false into sOnLadder
         put true into sOnGround
      else if sY >= LL.Top(sLadRow - 1) then
         put LL.Top(sLadRow - 1) into sY
         put false into sOnLadder
         put true into sOnGround
      else if tJump and not sJumpWas and (tLeft or tRight) then
         -- jump off sideways
         put false into sOnLadder
         put -5 into sVY
         if tLeft then put -tSpeed into sVX
         if tRight then put tSpeed into sVX
      end if
      put tJump into sJumpWas
   else
      if tLeft then
         put max(-tSpeed, sVX - 0.9) into sVX
      else if tRight then
         put min(tSpeed, sVX + 0.9) into sVX
      else
         put sVX * 0.6 into sVX
      end if
      -- a jump: on the ground, or up to 5 frames after stepping off an edge (kind in the dark)
      if sOnGround then put 0 into sCoyote
      if tJump and not sJumpWas and sCoyote <= 5 and sVY >= 0 then
         put kJump into sVY
         put 99 into sCoyote
      end if
      add 1 to sCoyote
      if not tJump and sVY < -3 then put -3 into sVY
      put tJump into sJumpWas
      put min(kFallMax, sVY + kGravity) into sVY
      add sVX to sX
      put max(-kHalfW + kPW, min(kHalfW - kPW, sX)) into sX
      add sVY to sY
      -- landing: feet cross the top of a ledge this step, while over its span
      put false into sOnGround
      if sVY >= 0 then
         put round(-sY / kRowGap) into r
         if r >= 0 and r <= sRowCount and tOldY <= LL.Top(r) + 0.01 and sY >= LL.Top(r) then
            repeat for each line tSeg in sRows[r]
               if sX + kPW * 0.5 > item 1 of tSeg and sX - kPW * 0.5 < item 2 of tSeg then
                  put LL.Top(r) into sY
                  put 0 into sVY
                  put true into sOnGround
                  exit repeat
               end if
            end repeat
         end if
      end if
      -- the head bumps the underside of the ledge above
      if sVY < 0 then
         put round(-(sY - kPH) / kRowGap) into r
         if r >= 1 and r <= sRowCount and tOldY - kPH >= -r * kRowGap + kThick / 2 and sY - kPH < -r * kRowGap + kThick / 2 then
            repeat for each line tSeg in sRows[r]
               if sX > item 1 of tSeg and sX < item 2 of tSeg then
                  put -r * kRowGap + kThick / 2 + kPH into sY
                  put 1 into sVY
                  exit repeat
               end if
            end repeat
         end if
      end if
   end if
   Entity.SetPosition sPlayer, sX, sY, kZ
   Entity.SetRotation sPlayer, 0, 0, sVX / 30
   -- the camera follows, the climber low on the screen (the way is up)
   put sCamY + (sY - 60 - sCamY) * 0.15 into sCamY
   Camera.SetPosition 0, sCamY, 0
   -- oil: one a frame, two while running
   if sRunning then
      subtract 2 from sOil
   else
      subtract 1 from sOil
   end if
   if sOil <= 0 then
      LL.LoseLife "THE LANTERN WENT OUT"
      LL.Torch
      exit Game.OnUpdate
   end if
   -- flasks
   repeat with n = 1 to sFlaskCount
      if sFlask[n]["taken"] then next repeat
      if abs(sFlask[n]["x"] - sX) < 20 and abs(sFlask[n]["y"] - (sY - 10)) < 26 then
         put true into sFlask[n]["taken"]
         put min(sOilMax, sOil + kFlaskOil * 30) into sOil
         Entity.Kill sFlask[n]["key"]
         FX.Sparks sFlask[n]["x"], sFlask[n]["y"], kZ, 14, "#FFC040"
         LL.Say "OIL", 1
      end if
   end repeat
   if sHazards then
      -- bats
      repeat with n = 1 to sBatCount
         add sBat[n]["v"] to sBat[n]["x"]
         if abs(sBat[n]["x"]) > kHalfW - 24 then put -sBat[n]["v"] into sBat[n]["v"]
         Entity.SetPosition sBat[n]["key"], sBat[n]["x"], sBat[n]["y"] + 10 * sin(sTicks / 7 + n), kZ
         if abs(sBat[n]["x"] - sX) < 24 and abs(sBat[n]["y"] - (sY - kPH / 2)) < 30 then
            LL.LoseLife "A BAT GOT YOU"
            LL.Torch
            exit Game.OnUpdate
         end if
      end repeat
      -- stones: wait, then drop from above the view, near you
      repeat with n = 1 to sRockCount
         if sRock[n]["wait"] > 0 then
            subtract 1 from sRock[n]["wait"]
            if sRock[n]["wait"] is 0 then
               put max(-kHalfW + 12, min(kHalfW - 12, sX + random(241) - 121)) into sRock[n]["x"]
               put sCamY - 340 into sRock[n]["y"]
               put 3 + random(3) into sRock[n]["v"]
            end if
            next repeat
         end if
         add sRock[n]["v"] to sRock[n]["y"]
         Entity.SetPosition sRock[n]["key"], sRock[n]["x"], sRock[n]["y"], kZ
         if abs(sRock[n]["x"] - sX) < 16 and sRock[n]["y"] > sY - kPH - 6 and sRock[n]["y"] < sY + 4 then
            LL.LoseLife "A FALLING STONE"
            LL.Torch
            exit Game.OnUpdate
         end if
         if sRock[n]["y"] > sCamY + 360 then
            put 20 + random(80) into sRock[n]["wait"]
            Entity.SetPosition sRock[n]["key"], 0, 99999, kZ
         end if
      end repeat
   end if
   put max(sBest, round(-sY / kRowGap)) into sBest
   -- the door at the top
   if sOnGround and abs(sY - LL.Top(sRowCount)) < 2 and abs(sX - sExitX) < 30 then
      FX.Sparks sX, sY, kZ, 30, "#40FF80"
      if sLevel >= 5 then
         put true into sOver
         put true into sWon
      else
         add 1 to sLevel
         LL.GoLevel sLevel
      end if
   end if
   LL.Torch
   LL.ShowHUD
end Game.OnUpdate

-- Up at a ladder's foot or anywhere on it; Down at its top
on LL.GrabLadder pUp
   local r
   repeat with r = 1 to sRowCount
      if abs(sX - sLadX[r]) > 18 then next repeat
      if pUp and sY <= LL.Top(r - 1) + 0.5 and sY > LL.Top(r) + 0.5 then
         put r into sLadRow
         put true into sOnLadder
         exit LL.GrabLadder
      end if
      if not pUp and sY >= LL.Top(r) - 0.5 and sY < LL.Top(r - 1) - 0.5 then
         put r into sLadRow
         put true into sOnLadder
         exit LL.GrabLadder
      end if
   end repeat
end LL.GrabLadder

on LL.LoseLife pWhy
   FX.Sparks sX, sY, kZ, 30, "#FFE0A0"
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      LL.Say pWhy, 999
      LL.ShowHUD
      exit LL.LoseLife
   end if
   LL.Respawn
   LL.Say pWhy & ".  BACK TO THE BOTTOM", 3
end LL.LoseLife

on LL.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end LL.Say

-------------------------------------------------------------------- the torch

-- the dark over the view: made once (kept on a restart), just above the picture (the engine's line
-- graphics VB_n, or the bench's image "view"), so the host's menu, labels and the loading screen
-- stay above it
on LL.TorchMake
   local tRect, tLayer, tRamp, tG
   if sTorchCard is empty then put the long id of this card into sTorchCard
   put LL.ViewRect() into tRect
   if there is not a graphic "LL.Torch" of sTorchCard then
      lock messages
      reset the templateGraphic
      set the backgroundColor of the templateGraphic to "0,0,0"
      set the foregroundColor of the templateGraphic to "0,0,0"
      create graphic "LL.Torch" in sTorchCard
      put the long id of graphic "LL.Torch" of sTorchCard into tG
      set the style of tG to "rectangle"
      set the filled of tG to true
      set the opaque of tG to true
      set the lineSize of tG to 0
      set the traversalOn of tG to false
      set the rect of tG to tRect
      put "0.00000,255,150,40,36" & cr & "0.40000,60,30,0,40" & cr & "0.75000,0,0,0,200" & cr & "1.00000,0,0,0,255" into tRamp
      set the fillGradient["type"] of tG to "radial"
      set the fillGradient["ramp"] of tG to tRamp
      set the fillGradient["quality"] of tG to "normal"
      reset the templateGraphic
      -- the words, above the dark
      reset the templateField
      set the foregroundColor of the templateField to "255,190,90"
      set the backgroundColor of the templateField to "0,0,0"
      create field "LL.Hud" in sTorchCard
      set the rect of field "LL.Hud" of sTorchCard to item 1 of tRect + 12, item 2 of tRect + 8, item 1 of tRect + 620, item 2 of tRect + 48
      set the opaque of field "LL.Hud" of sTorchCard to false
      set the showBorder of field "LL.Hud" of sTorchCard to false
      set the lockText of field "LL.Hud" of sTorchCard to true
      set the traversalOn of field "LL.Hud" of sTorchCard to false
      set the dontWrap of field "LL.Hud" of sTorchCard to true
      set the textFont of field "LL.Hud" of sTorchCard to "Courier New"
      set the textSize of field "LL.Hud" of sTorchCard to 13
      reset the templateField
      put LL.PictureLayer() + 1 into tLayer
      set the layer of graphic "LL.Torch" of sTorchCard to tLayer
      set the layer of field "LL.Hud" of sTorchCard to tLayer + 1
      unlock messages
   end if
   put empty into sTorchWas
   put 0 into sBlend
   put 0 into sJitter
   set the blendLevel of graphic "LL.Torch" of sTorchCard to 0
end LL.TorchMake

-- the highest layer of the picture itself (0 when the engine has drawn nothing yet: its pool
-- graphics are made at layer 1 later, so they go under the torch by themselves)
function LL.PictureLayer
   local tTop, i, tName
   put 0 into tTop
   repeat with i = 1 to the number of controls of sTorchCard
      put the short name of control i of sTorchCard into tName
      if tName begins with "VB_" or (tName is "view" and word 1 of the name of control i of sTorchCard is "image") then put max(tTop, i) into tTop
   end repeat
   return tTop
end LL.PictureLayer

function LL.ViewRect
   if gViewRight is a number and gViewBottom is a number and gViewRight > gViewLeft then
      return gViewLeft & comma & gViewTop & comma & gViewRight & comma & gViewBottom
   end if
   return the rect of this card
end LL.ViewRect

-- every frame: the light's middle on the player's lantern, its size by the oil, the flicker
on LL.Torch
   local tP, tR, tKey, tG
   if sTorchCard is empty or there is not a graphic "LL.Torch" of sTorchCard then exit LL.Torch
   put the long id of graphic "LL.Torch" of sTorchCard into tG
   if sTicks mod 3 is 0 then
      put random(kFlicker + 1) - 1 into sBlend
      put random(7) - 4 into sJitter
   end if
   put Camera.WorldToScreen(sX + 12, sY - 20, kZ) into tP
   put kTorchMin + (kTorchMax - kTorchMin) * max(0, sOil) / max(1, sOilMax) into tR
   put round(tR + sJitter) into sRadius
   if tP is empty then put "-9999,-9999" into tP
   put round(item 1 of tP) into item 1 of tP
   put round(item 2 of tP) into item 2 of tP
   put tP & comma & sRadius into tKey
   lock screen
   if tKey is not sTorchWas then
      put tKey into sTorchWas
      set the fillGradient["from"] of tG to item 1 to 2 of tP
      set the fillGradient["to"] of tG to (item 1 of tP + sRadius) & comma & item 2 of tP
      set the fillGradient["via"] of tG to item 1 of tP & comma & (item 2 of tP - sRadius)
   end if
   if the blendLevel of tG is not sBlend then set the blendLevel of tG to sBlend
   unlock screen
end LL.Torch

-- "exists|from x,y|radius|blendLevel|layer above the picture"
function LL.TorchState
   local tG
   if sTorchCard is empty or there is not a graphic "LL.Torch" of sTorchCard then return false
   put the long id of graphic "LL.Torch" of sTorchCard into tG
   return true & "|" & the fillGradient["from"] of tG & "|" & sRadius & "|" & the blendLevel of tG & "|" & (the layer of tG > LL.PictureLayer())
end LL.TorchState

-- where the lantern shows on the screen (the torch's middle should be here)
function LL.LanternScreen
   return Camera.WorldToScreen(sX + 12, sY - 20, kZ)
end LL.LanternScreen

on LL.TorchRemove
   if sTorchCard is empty then exit LL.TorchRemove
   lock messages
   if there is a graphic "LL.Torch" of sTorchCard then delete graphic "LL.Torch" of sTorchCard
   if there is a field "LL.Hud" of sTorchCard then delete field "LL.Hud" of sTorchCard
   unlock messages
end LL.TorchRemove

-------------------------------------------------------------------- the words

on LL.ShowHUD
   local tWords, tOil, tText
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sOil div 30 into tOil
   put sLevel & "|" & sLives & "|" & tOil & "|" & sBest & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit LL.ShowHUD
   put tWords into sHUDWas
   put "OIL" && tOil && "  LIVES" && sLives && "  LEVEL" && sLevel && "  LEDGE" && sBest && "OF" && sRowCount into tText
   if sOver and sWon then
      put return & "THE TOP OF THE LAST TOWER.  SPACE TO PLAY AGAIN" after tText
   else if sOver then
      put return & sMsg & ".  SPACE TO PLAY AGAIN" after tText
   else if sMsg is not empty then
      put return & sMsg after tText
   end if
   if sTorchCard is not empty and there is a field "LL.Hud" of sTorchCard then
      lock messages
      put tText into field "LL.Hud" of sTorchCard
      unlock messages
   end if
end LL.ShowHUD

function LL.HelpLine
   return "ARROWS = WALK AND CLIMB   SHIFT = RUN (MORE OIL)   SPACE = JUMP"
end LL.HelpLine

-- "level|lives|x,y|on ground|on ladder|oil frames|best ledge|over|running"
function LL.State
   return sLevel & "|" & sLives & "|" & round(sX) & "," & round(sY) & "|" & sOnGround & "|" & sOnLadder & "|" & sOil & "|" & sBest & "|" & sOver & "|" & sRunning
end LL.State

-- ladder r's x (r 1 = from the floor to ledge 1)
function LL.LadderX r
   return sLadX[r]
end LL.LadderX

-- true when ledge r has floor under x (tests, a bot)
function LL.Solid pX, r
   local tSeg
   repeat for each line tSeg in sRows[r]
      if pX > item 1 of tSeg and pX < item 2 of tSeg then return true
   end repeat
   return false
end LL.Solid

-- "door x,ledges": where the green door is
function LL.Exit
   return sExitX & comma & sRowCount
end LL.Exit

function LL.Player
   return sPlayer
end LL.Player

on Game.OnStop
   LL.TorchRemove
   HUD.Clear
   Camera.Reset
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
