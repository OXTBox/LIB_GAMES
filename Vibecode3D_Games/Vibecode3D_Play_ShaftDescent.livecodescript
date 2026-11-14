######################################################################################
## CARD SCRIPT: "Play.ShaftDescent"   SHAFT DESCENT  (11 13 2026)
## The owner's concept (round two, 6 of 9): side view. A runner descends a tall vertical
## shaft of platforms inside a vector world: run, jump with a real jump curve, drop through
## gaps, avoid patrol drones, reach the exit at the bottom before the air runs out. The
## camera follows down the shaft.
## Teaches: gravity, a jump curve, platforms, a following camera.
## CONTROLS  Left/Right: run   Space: jump   Escape: stop
## RULES     a drone, or the air running out, costs a life (back to the top). 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sX, sY, sVX, sVY, sOnGround, sPlayer, sRows, sDrone, sDroneCount, sExitY, sExitX
local sLevel, sLives, sAir, sAirMax, sDroneSpeed, sOver, sWon, sTicks, sTestKeys, sJumpWas
local sHUDWas, sCamY, sMsg, sMsgUntil, sBest

constant kZ = 600
constant kHalfW = 330          -- the shaft runs from -330 to 330
constant kRowGap = 130         -- height between platform rows
constant kThick = 12
constant kRun = 4.2
constant kJump = -10.5         -- the jump's starting speed (up is negative)
constant kGravity = 0.5
constant kFallMax = 13
constant kPW = 16              -- the runner's half width
constant kPH = 34              -- the runner's height

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Shaft.StartLevel
end Game.OnStart

-- level table: platform rows | drones | drone speed | air seconds
function Shaft.Row pLevel
   return line pLevel of ("10,2,1.5,45" & cr & "14,4,1.8,55" & cr & "18,6,2.1,65" & cr & "22,8,2.4,75" & cr & "26,10,2.8,85")
end Shaft.Row

on Shaft.StartLevel
   local tRow, r, y, tGap1, tGap2, tW, n, tSeg, x1, x2, tKey
   put Shaft.Row(sLevel) into tRow
   put item 3 of tRow into sDroneSpeed
   put item 4 of tRow into sAirMax
   Scene.ClearAll
   set the randomSeed to 4242 + sLevel * 977
   put empty into sRows
   -- the shaft walls, one tall frame
   put item 1 of tRow * kRowGap + 400 into tW
   Mesh.Define "Shaft.Wall", MeshBox(10, tW, 30)
   get Entity.Spawn("Shaft.Wall", -kHalfW - 6, tW / 2 - 300, kZ, "#1C4A2A")
   get Entity.Spawn("Shaft.Wall", kHalfW + 6, tW / 2 - 300, kZ, "#1C4A2A")
   -- rows of platforms, each with one or two gaps to drop through
   repeat with r = 1 to item 1 of tRow
      put r * kRowGap into y
      put random(5) - 3 into tGap1
      put tGap1 * 110 into tGap1
      put empty into tGap2
      if r mod 3 is 0 then put -tGap1 + (random(3) - 2) * 40 into tGap2
      -- segments between the gaps (gaps are 80 wide)
      put -kHalfW into x1
      repeat for each item tSeg in Shaft.Sorted(tGap1, tGap2)
         put tSeg - 40 into x2
         if x2 - x1 > 10 then Shaft.Platform r, x1, x2, y
         put tSeg + 40 into x1
      end repeat
      if kHalfW - x1 > 10 then Shaft.Platform r, x1, kHalfW, y
   end repeat
   -- the exit: on the floor at the bottom
   put (item 1 of tRow + 1) * kRowGap into sExitY
   Shaft.Platform item 1 of tRow + 1, -kHalfW, kHalfW, sExitY
   put (random(5) - 3) * 100 into sExitX
   Mesh.Define "Shaft.Exit", MeshBox(80, 40, 20)
   get Entity.Spawn("Shaft.Exit", sExitX, sExitY - 20 - kThick / 2, kZ, "#40FF80")
   -- drones patrol along rows (never the first)
   put empty into sDrone
   put item 2 of tRow into sDroneCount
   Mesh.Define "Shaft.Drone", MeshSphere(14, 2, 6)
   repeat with n = 1 to sDroneCount
      put 2 + (n * 7) mod (item 1 of tRow - 1) into r
      put r * kRowGap - 30 into sDrone[n]["y"]
      put random(500) - 250 into sDrone[n]["x"]
      put sDroneSpeed into sDrone[n]["v"]
      if random(2) is 1 then put -sDroneSpeed into sDrone[n]["v"]
      put Entity.Spawn("Shaft.Drone", sDrone[n]["x"], sDrone[n]["y"], kZ, "#FF5050") into sDrone[n]["key"]
   end repeat
   -- the runner: a stick figure
   Mesh.Define "Shaft.Runner", Shaft.RunnerMesh()
   put Entity.Spawn("Shaft.Runner", 0, 0, kZ, "#40E0FF") into sPlayer
   set the randomSeed to the milliseconds
   Shaft.Respawn
   put empty into sHUDWas
end Shaft.StartLevel

function Shaft.Sorted a, b
   if b is empty then return a
   if a < b then return a & comma & b
   return b & comma & a
end Shaft.Sorted

on Shaft.Platform r, x1, x2, y
   local n
   put the number of lines of sRows[r] + 1 into n
   put x1 & comma & x2 & cr after sRows[r]
   Mesh.Define "Shaft.P" & r & "_" & n, MeshBox(x2 - x1, kThick, 26)
   get Entity.Spawn("Shaft.P" & r & "_" & n, (x1 + x2) / 2, y, kZ, "#FFB000")
end Shaft.Platform

function Shaft.RunnerMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -34, 0       -- 1 head top
   Mesh.AddVertex tM, 0, -26, 0       -- 2 neck
   Mesh.AddVertex tM, 0, -12, 0       -- 3 hip
   Mesh.AddVertex tM, -8, 0, 0        -- 4 foot
   Mesh.AddVertex tM, 8, 0, 0         -- 5 foot
   Mesh.AddVertex tM, -10, -16, 0     -- 6 hand
   Mesh.AddVertex tM, 10, -20, 0      -- 7 hand
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 3, 5
   Mesh.AddLine tM, 2, 6
   Mesh.AddLine tM, 2, 7
   return tM
end Shaft.RunnerMesh

on Shaft.Respawn
   put 0 into sX
   put 0 into sY
   put 0 into sVX
   put 0 into sVY
   put false into sOnGround
   put sAirMax * 30 into sAir
   put 0 into sCamY
   put 0 into sBest
   Shaft.Say "DOWN THE SHAFT: REACH THE GREEN EXIT", 3
end Shaft.Respawn

function Shaft.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Shaft.Keys

on Shaft.TestKeys pKeys
   put pKeys into sTestKeys
end Shaft.TestKeys

on Game.OnUpdate
   local tKeys, tJump, tOldY, r, tSeg, n
   add 1 to sTicks
   put Shaft.Keys() into tKeys
   put (32 is among the items of tKeys) into tJump
   if sOver then
      if tJump and not sJumpWas then Game.OnStart
      put tJump into sJumpWas
      exit Game.OnUpdate
   end if
   -- run: quick to start, quick to stop
   if 65361 is among the items of tKeys then
      put max(-kRun, sVX - 0.9) into sVX
   else if 65363 is among the items of tKeys then
      put min(kRun, sVX + 0.9) into sVX
   else
      put sVX * 0.6 into sVX
   end if
   -- the jump: a real curve (a starting speed, then gravity); a short tap = a short hop
   if tJump and not sJumpWas and sOnGround then put kJump into sVY
   if not tJump and sVY < -3 then put -3 into sVY
   put tJump into sJumpWas
   put min(kFallMax, sVY + kGravity) into sVY
   put sY into tOldY
   add sVX to sX
   put max(-kHalfW + kPW, min(kHalfW - kPW, sX)) into sX
   add sVY to sY
   -- landing: feet cross the top of a platform this step, while over its span
   put false into sOnGround
   if sVY >= 0 then
      put round(sY / kRowGap) into r
      if r >= 1 and tOldY <= r * kRowGap - kThick / 2 + 0.01 and sY >= r * kRowGap - kThick / 2 then
         repeat for each line tSeg in sRows[r]
            if sX + kPW * 0.5 > item 1 of tSeg and sX - kPW * 0.5 < item 2 of tSeg then
               put r * kRowGap - kThick / 2 into sY
               put 0 into sVY
               put true into sOnGround
               exit repeat
            end if
         end repeat
      end if
   end if
   -- bumping the underside of a row while jumping
   if sVY < 0 then
      put round(sY / kRowGap) into r
      if r >= 1 and tOldY - kPH >= r * kRowGap + kThick / 2 and sY - kPH < r * kRowGap + kThick / 2 then
         repeat for each line tSeg in sRows[r]
            if sX > item 1 of tSeg and sX < item 2 of tSeg then
               put r * kRowGap + kThick / 2 + kPH into sY
               put 1 into sVY
               exit repeat
            end if
         end repeat
      end if
   end if
   SetObjectPosition sPlayer, sX, sY, kZ
   SetObjectRotation sPlayer, 0, 0, sVX / 30
   -- the camera follows, the runner a third of the way down the screen
   put sCamY + (sY + 60 - sCamY) * 0.15 into sCamY
   Engine.SetCam 0, -sCamY, 0
   -- drones patrol
   repeat with n = 1 to sDroneCount
      add sDrone[n]["v"] to sDrone[n]["x"]
      if abs(sDrone[n]["x"]) > kHalfW - 20 then put -sDrone[n]["v"] into sDrone[n]["v"]
      SetObjectPosition sDrone[n]["key"], sDrone[n]["x"], sDrone[n]["y"] + 6 * sin(sTicks / 9 + n), kZ
      SetObjectRotation sDrone[n]["key"], 0, sTicks / 10, 0
      if abs(sDrone[n]["x"] - sX) < 24 and abs(sDrone[n]["y"] - (sY - kPH / 2)) < 30 then
         Shaft.LoseLife "A DRONE GOT YOU"
         exit Game.OnUpdate
      end if
   end repeat
   -- air
   subtract 1 from sAir
   if sAir <= 0 then
      Shaft.LoseLife "OUT OF AIR"
      exit Game.OnUpdate
   end if
   put max(sBest, round(sY / kRowGap)) into sBest
   -- the exit
   if sOnGround and abs(sY - (sExitY - kThick / 2)) < 2 and abs(sX - sExitX) < 50 then
      FX.Sparks sX, sY, kZ, 30, "#40FF80"
      if sLevel >= 5 then
         put true into sOver
         put true into sWon
      else
         add 1 to sLevel
         Shaft.StartLevel
      end if
   end if
   Shaft.ShowHUD
end Game.OnUpdate

on Shaft.LoseLife pWhy
   FX.Sparks sX, sY, kZ, 30, "#40E0FF"
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Shaft.Say pWhy, 999
      Shaft.ShowHUD
      exit Shaft.LoseLife
   end if
   Shaft.Respawn
   Shaft.Say pWhy & ".  BACK TO THE TOP", 3
end Shaft.LoseLife

on Shaft.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end Shaft.Say

on Shaft.ShowHUD
   local tWords, tAir
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sAir div 30 into tAir
   put sLevel & "|" & sLives & "|" & tAir & "|" & sBest & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit Shaft.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Shaft.Score", "AIR" && tAir && "  LIVES" && sLives && "  LEVEL" && sLevel && "  DEPTH" && sBest && "OF" && item 1 of Shaft.Row(sLevel) + 1, 20, 120, 14
   HUD.Remove "Shaft.Msg"
   if sOver and sWon then
      HUD.Set "Shaft.Msg", "THE BOTTOM OF THE LAST SHAFT.  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sOver then
      HUD.Set "Shaft.Msg", sMsg & ".  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sMsg is not empty then
      HUD.Set "Shaft.Msg", sMsg, 20, 142, 14
   end if
end Shaft.ShowHUD

function Shaft.State
   return sLevel & "|" & sLives & "|" & round(sX) & "," & round(sY) & "|" & sOnGround & "|" & sAir div 30 & "|" & sBest & "|" & sOver
end Shaft.State

on Game.OnStop
   HUD.Clear
   Engine.ResetCamera
end Game.OnStop
