######################################################################################
## CARD SCRIPT: "Play.NineBall"   NINE BALL  (11 19 2026)
## SCOTT ROSSI'S NINE BALL, WITH JIM HURLEY'S TABLE PHYSICS, rewritten for Vibecode3D (XT)
## and xt3d (xRay). The original stack "nine ball" is from Scott Rossi's collection; its
## physics (ball-to-ball collisions, cushions, friction, pockets, scratch) are Jim Hurley's
## (jhurley@infs.net, the stack's About box). Source: LIB_GENERICA/Data/Example scriptBlocks
## Math.txt (resetVel, theLineAngle, theDist), Update.txt (startStroke, doInit, doMove,
## AllStopped), Mouse.txt (the Ball0 drag-to-aim script). Claude rewrote it for the engines
## on 19 Nov 2026 and added the nine ball rules. Notes: NineBall/README.md.
## CONTROLS  Mouse: hold the button and drag out from the cue ball the way you want it to
##           go; the longer the drag, the harder (Scott Rossi's way); let go to shoot.
##           Keys: Left/Right (or A/D) aim, Shift = fine aim, Up/Down (or W/S) power,
##           Space shoots. C: straight-down view or the 3D view. R: a new rack.
## RULES     two players take turns (hot seat). Hit the LOWEST numbered ball first. A ball
##           sunk on a fair shot = shoot again. Sink the 9 on a fair shot (any way, a
##           combination too) and you win. A FOUL (wrong ball first, nothing hit, or the
##           cue ball sunk = scratch) gives the table to the other player; a 9 sunk on a
##           foul comes back to its spot; a scratched cue ball goes back to the spot.
######################################################################################

global bPaused, bPlaying, gNoMouse, gViewBottom

-- the table, in Jim Hurley's numbers (the original card: 820 x 480, y down, 0,0 top left)
local sX, sY, sVX, sVY, sOnTable, sBall, sRotX, sRotZ
local sMode, sTurn, sWinner, sFirstHit, sSunkNow, sLowestAtShot, sShots, sMsg, sFriction
local sAim, sPower, sDot, sDrag, sMouseWas, sKeysWas, sTestKeys, sTestMouse, sHUDWas
local sTicks, sLabelsOn, sTopView
local sClackTick, sRailTick   -- the frame a sound last played: once a frame

constant kW = 820             -- the table (Hurley: the width of the stack)
constant kH = 480             -- (the height of the stack)
constant kR = 20              -- ball radius (the ball buttons were 40 wide)
constant kCushion = 20        -- Hurley's tCushion
constant kFriction = 0.991    -- the card's tableFriction (Preferences slider: .99 to 1.00)
constant kStop = 0.2          -- AllStopped: every speed below this
constant kPocketR = 48        -- the pocket graphics were 96 wide ovals
constant kPockets = "24,19 795,21 797,457 22,459 382,5 383,473"
constant kSteps = 3           -- Hurley steps a frame (his loop ran every millisecond)
constant kMaxPower = 16       -- Rossi: speed = drag / 25; capped (a 400 pixel drag)
constant kDots = 16
constant kHeadSpot = "205,240"   -- Hurley's tLeftSpot: the card's middle less W/4
constant kFootSpot = "507,240"   -- where ball 1 stood in the rack
constant kCueStart = "215,240"   -- where the cue ball button stood
-- the rack: Rossi's Ball1..Ball9 places (dx 35, dy 20); slot 5 (the middle) holds the 9
constant kRack = "507,240 542,220 542,260 577,200 612,240 577,280 612,220 612,260 647,240"

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put false into sTopView
   NB.Camera
   put 0 into sTicks
   put kFriction into sFriction
   put empty into sKeysWas
   put false into sMouseWas
   put "title" into sMode
   put 1 into sTurn
   NB.Rack
   put empty into sHUDWas
   NB.ShowHUD
end Game.OnStart

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows aim; a focused menu or field must never get them
on arrowKey pKey
end arrowKey

------------------------------------------------------------------ table <-> world

-- table x (0..820, left to right) -> world X; table y (0..480, far to near) -> world Z
function NB.WX pTX
   return pTX - kW / 2
end NB.WX

function NB.WZ pTY
   return kH / 2 - pTY
end NB.WZ

on NB.Camera
   if sTopView then
      Camera.SetPosition 0, -760, -40
      Camera.SetLook 0, -atan2(760, 40)
   else
      Camera.SetPosition 0, -430, -330
      Camera.SetLook 0, -atan2(430, 330)
   end if
end NB.Camera

------------------------------------------------------------------ the table and the rack

on NB.Rack
   local i, tXY
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   put empty into sDot
   put empty into sHUDWas
   put false into sLabelsOn
   Mesh.Define "NB.Felt", Mesh.Box(kW - 2 * kCushion, 2, kH - 2 * kCushion)
   Mesh.Define "NB.RailLong", Mesh.Box(kW, 14, kCushion)
   Mesh.Define "NB.RailShort", Mesh.Box(kCushion, 14, kH - 2 * kCushion)
   Mesh.Define "NB.Pocket", Mesh.Prism(8, 30, 1)
   Mesh.Define "NB.Spot", Mesh.Prism(6, 4, 1)
   Mesh.Define "NB.Ball", Mesh.Sphere(kR, 3, 6)
   Mesh.Define "NB.Dot", Mesh.Box(5, 5, 5)
   get Entity.Spawn("NB.Felt", 0, 1, 0, "#1E7A3C")
   get Entity.Spawn("NB.RailLong", 0, -7, NB.WZ(kCushion / 2), "#8A5A2B")
   get Entity.Spawn("NB.RailLong", 0, -7, NB.WZ(kH - kCushion / 2), "#8A5A2B")
   get Entity.Spawn("NB.RailShort", NB.WX(kCushion / 2), -7, 0, "#8A5A2B")
   get Entity.Spawn("NB.RailShort", NB.WX(kW - kCushion / 2), -7, 0, "#8A5A2B")
   repeat for each word tXY in kPockets
      get Entity.Spawn("NB.Pocket", NB.WX(item 1 of tXY), -2, NB.WZ(item 2 of tXY), "#D0D0D0")
   end repeat
   get Entity.Spawn("NB.Spot", NB.WX(item 1 of kHeadSpot), -1, NB.WZ(item 2 of kHeadSpot), "white")
   get Entity.Spawn("NB.Spot", NB.WX(item 1 of kFootSpot), -1, NB.WZ(item 2 of kFootSpot), "white")
   repeat with i = 0 to 9
      put 0 into sVX[i]
      put 0 into sVY[i]
      put 0 into sRotX[i]
      put 0 into sRotZ[i]
      put true into sOnTable[i]
      if i is 0 then
         put kCueStart into tXY
      else
         put word i of kRack into tXY
      end if
      put item 1 of tXY into sX[i]
      put item 2 of tXY into sY[i]
      put Entity.Spawn("NB.Ball", NB.WX(sX[i]), -kR, NB.WZ(sY[i]), NB.Color(i)) into sBall[i]
   end repeat
   put empty into sWinner
   put empty into sSunkNow
   put empty into sFirstHit
   put 0 into sShots[1]
   put 0 into sShots[2]
   put 8 into sPower
   put 0 into sAim
   put false into sDrag
end NB.Rack

function NB.Color pBall
   return item pBall + 1 of "white,#FFD21F,#2F6BFF,#FF3030,#A040FF,#FF8C1A,#20C040,#B03020,#606060,#FFF0A0"
end NB.Color

on NB.NewGame
   Sound.Play "Select"
   NB.Rack
   put "aim" into sMode
   put empty into sMsg
   NB.AimAtLowest
   NB.ShowAim
   NB.ShowHUD
end NB.NewGame

------------------------------------------------------------------ Jim Hurley's physics

-- Hurley's resetVel: an equal-mass elastic collision. Both velocities are turned into the
-- frame of the line joining the centres; the parts along that line are swapped, the parts
-- across it are kept. Returns "vx1,vy1,vx2,vy2".
function NB.ResetVel pX1, pY1, pX2, pY2, pVX1, pVY1, pVX2, pVY2
   local tCa, tVa, tVa2, tV, tV2, tVrA, tVrA2, tVR, tVT, tVR2, tVT2
   put NB.LineAngle(pX1, pY1, pX2, pY2) into tCa
   put NB.LineAngle(pX1, pY1, pX1 + pVX1, pY1 + pVY1) into tVa
   put NB.LineAngle(pX2, pY2, pX2 + pVX2, pY2 + pVY2) into tVa2
   put sqrt(pVX2 * pVX2 + pVY2 * pVY2) into tV2
   put sqrt(pVX1 * pVX1 + pVY1 * pVY1) into tV
   -- angle of each velocity to the line joining centres
   put tVa - tCa into tVrA
   put tVa2 - tCa into tVrA2
   put tV * cos(tVrA) into tVR2     -- ball 1's push along the line goes to ball 2
   put tV * sin(tVrA) into tVT      -- ball 1 keeps its part across the line
   put tV2 * cos(tVrA2) into tVR    -- and ball 2's push along the line comes back
   put tV2 * sin(tVrA2) into tVT2
   return (tVR * cos(tCa) - tVT * sin(tCa)) & comma & (tVR * sin(tCa) + tVT * cos(tCa)) & comma & \
         (tVR2 * cos(tCa) - tVT2 * sin(tCa)) & comma & (tVR2 * sin(tCa) + tVT2 * cos(tCa))
end NB.ResetVel

-- Hurley's theLineAngle: the angle of the line from point 1 to point 2
function NB.LineAngle pX1, pY1, pX2, pY2
   return atan2(pY2 - pY1, pX2 - pX1)
end NB.LineAngle

-- Hurley's theDist
function NB.Dist pX1, pY1, pX2, pY2
   return sqrt((pX1 - pX2) ^ 2 + (pY1 - pY2) ^ 2)
end NB.Dist

function NB.InPocket pX, pY
   local tXY
   repeat for each word tXY in kPockets
      if NB.Dist(pX, pY, item 1 of tXY, item 2 of tXY) < kPocketR then return true
   end repeat
   return false
end NB.InPocket

-- one pass of Hurley's doMove over every ball on the table
on NB.Step
   local i, j, tJ, tS, tSMin, tNew, tSafe, tA
   repeat with i = 0 to 9
      if not sOnTable[i] then next repeat
      -- a ball whose centre is inside a pocket is sunk
      if NB.InPocket(sX[i], sY[i]) then
         NB.Sink i
         next repeat
      end if
      add sVX[i] to sX[i]
      add sVY[i] to sY[i]
      -- the nearest ball (numbered after this one) it now overlaps
      put empty into tJ
      put 2 * kR into tSMin
      repeat with j = i + 1 to 9
         if not sOnTable[j] then next repeat
         put NB.Dist(sX[i], sY[i], sX[j], sY[j]) into tS
         if tS < tSMin then
            put tS into tSMin
            put j into tJ
         end if
      end repeat
      if tJ is not empty then
         -- step both back, then the collision
         subtract sVX[i] from sX[i]
         subtract sVY[i] from sY[i]
         subtract sVX[tJ] from sX[tJ]
         subtract sVY[tJ] from sY[tJ]
         put NB.ResetVel(sX[i], sY[i], sX[tJ], sY[tJ], sVX[i], sVY[i], sVX[tJ], sVY[tJ]) into tNew
         put item 1 of tNew into sVX[i]
         put item 2 of tNew into sVY[i]
         put item 3 of tNew into sVX[tJ]
         put item 4 of tNew into sVY[tJ]
         if i is 0 and sFirstHit is empty then put tJ into sFirstHit
         if sClackTick is not sTicks then Sound.Play "Thud"
         put sTicks into sClackTick
         -- still overlapping: ease this ball off along the line of centres
         -- (Hurley stepped it back 1,1 diagonally; along the line it cannot go through a rail)
         put 0 into tSafe
         repeat while NB.Dist(sX[i], sY[i], sX[tJ], sY[tJ]) <= 2 * kR and tSafe < 60
            put atan2(sY[i] - sY[tJ], sX[i] - sX[tJ]) into tA
            add cos(tA) to sX[i]
            add sin(tA) to sY[i]
            add 1 to tSafe
         end repeat
      end if
      -- the cushions: step back and turn round
      if sX[i] - kCushion < kR or sX[i] + kR + kCushion > kW then
         subtract sVX[i] from sX[i]
         multiply sVX[i] by -1
         if sRailTick is not sTicks then Sound.Play "Bounce"
         put sTicks into sRailTick
      end if
      if sY[i] - kCushion < kR or sY[i] + kR + kCushion > kH then
         subtract sVY[i] from sY[i]
         multiply sVY[i] by -1
         if sRailTick is not sTicks then Sound.Play "Bounce"
         put sTicks into sRailTick
      end if
      -- the cloth
      multiply sVX[i] by sFriction
      multiply sVY[i] by sFriction
   end repeat
end NB.Step

-- Hurley's AllStopped: every ball on the table slower than kStop on both axes
function NB.AllStopped
   local i
   repeat with i = 0 to 9
      if not sOnTable[i] then next repeat
      if abs(sVX[i]) > kStop or abs(sVY[i]) > kStop then return false
   end repeat
   return true
end NB.AllStopped

on NB.Sink pBall
   local tXY, tBest, tD, tPX, tPY
   put false into sOnTable[pBall]
   put 0 into sVX[pBall]
   put 0 into sVY[pBall]
   put pBall & comma after sSunkNow
   if pBall is not 0 then Sound.Play "Pickup"
   -- sparks over the pocket it went in
   put 9999 into tBest
   repeat for each word tXY in kPockets
      put NB.Dist(sX[pBall], sY[pBall], item 1 of tXY, item 2 of tXY) into tD
      if tD < tBest then
         put tD into tBest
         put item 1 of tXY into tPX
         put item 2 of tXY into tPY
      end if
   end repeat
   if sBall[pBall] is not empty then Entity.Kill sBall[pBall]
   put empty into sBall[pBall]
   FX.Sparks NB.WX(tPX), -kR, NB.WZ(tPY), 8, NB.Color(pBall)
end NB.Sink

-- put a ball back on a spot; if the spot is taken, along the table until it is free
on NB.Spot pBall, pXY, pStep
   local tX, tY, j, tFree
   put item 1 of pXY into tX
   put item 2 of pXY into tY
   repeat 60 times
      put true into tFree
      repeat with j = 0 to 9
         if j is pBall or not sOnTable[j] then next repeat
         if NB.Dist(tX, tY, sX[j], sY[j]) <= 2 * kR then put false into tFree
      end repeat
      if tFree then exit repeat
      add pStep to tX
   end repeat
   put tX into sX[pBall]
   put tY into sY[pBall]
   put 0 into sVX[pBall]
   put 0 into sVY[pBall]
   put true into sOnTable[pBall]
   if sBall[pBall] is empty then put Entity.Spawn("NB.Ball", NB.WX(tX), -kR, NB.WZ(tY), NB.Color(pBall)) into sBall[pBall]
end NB.Spot

------------------------------------------------------------------ the shot and the rules

function NB.Lowest
   local i
   repeat with i = 1 to 9
      if sOnTable[i] then return i
   end repeat
   return empty
end NB.Lowest

-- Rossi's startStroke: the cue ball's speed, the rest at rest
on NB.Shoot pAngle, pPower
   local i
   if sMode is not "aim" or not sOnTable[0] then exit NB.Shoot
   put max(0, min(kMaxPower, pPower)) into pPower
   repeat with i = 1 to 9
      put 0 into sVX[i]
      put 0 into sVY[i]
   end repeat
   put pPower * cos(pAngle) into sVX[0]
   put pPower * sin(pAngle) into sVY[0]
   Sound.Play "Hit"
   put NB.Lowest() into sLowestAtShot
   put empty into sFirstHit
   put empty into sSunkNow
   put empty into sMsg
   add 1 to sShots[sTurn]
   put false into sDrag
   NB.HideAim
   NB.Labels false
   put "moving" into sMode
end NB.Shoot

-- every ball has stopped: who shoots next
on NB.EndShot
   local i, tFoul, tScratch, tNine, tObject
   repeat with i = 0 to 9
      put 0 into sVX[i]
      put 0 into sVY[i]
   end repeat
   put 0 is among the items of sSunkNow into tScratch
   put 9 is among the items of sSunkNow into tNine
   put false into tObject
   repeat for each item i in sSunkNow
      if i is not 0 and i is not 9 then put true into tObject
   end repeat
   put empty into tFoul
   if tScratch then
      put "SCRATCH" into tFoul
   else if sFirstHit is empty then
      put "NO BALL HIT" into tFoul
   else if sFirstHit is not sLowestAtShot then
      put "THE" && sFirstHit && "WAS HIT BEFORE THE" && sLowestAtShot into tFoul
   end if
   if tNine and tFoul is empty then
      put sTurn into sWinner
      put "over" into sMode
      put "PLAYER" && sTurn && "SINKS THE 9 AND WINS!" into sMsg
      Sound.Play "Win"
      NB.Labels true
      put empty into sHUDWas
      NB.ShowHUD
      exit NB.EndShot
   end if
   if tNine then NB.Spot 9, kFootSpot, 2 * kR + 2
   if tScratch then NB.Spot 0, kHeadSpot, -(2 * kR + 2)
   if tFoul is not empty then
      Sound.Play "Hurt"
      put 3 - sTurn into sTurn
      put "FOUL: " & tFoul & ". PLAYER" && sTurn && "TO SHOOT" into sMsg
      if tNine then
         put "FOUL: " & tFoul & ". THE 9 GOES BACK. PLAYER" && sTurn into sMsg
      end if
   else if tObject then
      put "PLAYER" && sTurn && "SHOOTS AGAIN" into sMsg
   else
      put 3 - sTurn into sTurn
      put "NOTHING SUNK. PLAYER" && sTurn && "TO SHOOT" into sMsg
   end if
   put "aim" into sMode
   NB.AimAtLowest
   NB.MoveEntities
   NB.ShowAim
   put empty into sHUDWas
end NB.EndShot

on NB.AimAtLowest
   local tL
   put NB.Lowest() into tL
   if tL is empty or not sOnTable[0] then exit NB.AimAtLowest
   put NB.LineAngle(sX[0], sY[0], sX[tL], sY[tL]) into sAim
end NB.AimAtLowest

------------------------------------------------------------------ input

function NB.Keys
   if sTestKeys is not empty then
      if sTestKeys is 0 then return empty
      return sTestKeys
   end if
   return the keysDown
end NB.Keys

-- a test holds keys: "0" = none; empty = the real keyboard again
on NB.TestKeys pKeys
   put pKeys into sTestKeys
end NB.TestKeys

-- a test moves the mouse on the table: "tableX,tableY,down" ("" = no mouse)
on NB.TestMouse pTXYDown
   put pTXYDown into sTestMouse
   if pTXYDown is empty then put "none" into sTestMouse
end NB.TestMouse

-- "tableX,tableY,down": where the mouse points on the table, or empty
function NB.MouseTable
   local tM, tT
   if sTestMouse is "none" then return empty
   if sTestMouse is not empty then return sTestMouse
   if sTestKeys is not empty then return empty   -- a test drives: never the owner's mouse
   if gNoMouse is true then return empty
   try
      put Engine.Mouse() into tM
   catch tErr
      return empty
   end try
   if tM is empty then return empty
   put NB.ScreenToTable(item 1 of tM, item 2 of tM) into tT
   if tT is empty then return empty
   return tT & comma & (item 3 of tM)
end NB.MouseTable

-- screen pixels -> the table point under them at the balls' height. Newton's method on
-- Camera.WorldToScreen, so it needs nothing more from the engine (both engines have it).
function NB.ScreenToTable pSX, pSY
   local tStarts, tStart, tT
   if pSX is not a number or pSY is not a number then return empty
   put "410,240 410,60 410,420 100,240 720,240" into tStarts
   if sOnTable[0] then put sX[0] & comma & sY[0] && tStarts into tStarts
   repeat for each word tStart in tStarts
      put NB.Newton(pSX, pSY, item 1 of tStart, item 2 of tStart) into tT
      if tT is not empty then return tT
   end repeat
   return empty
end NB.ScreenToTable

-- from the table point pX,pY toward the one that shows at pSX,pSY; empty if it gets lost
function NB.Newton pSX, pSY, pX, pY
   local tN, tS0, tSA, tSB, a11, a12, a21, a22, tDet, tEX, tEY, tErr
   repeat with tN = 1 to 8
      try
         put Camera.WorldToScreen(NB.WX(pX), -kR, NB.WZ(pY)) into tS0
         put Camera.WorldToScreen(NB.WX(pX + 10), -kR, NB.WZ(pY)) into tSA
         put Camera.WorldToScreen(NB.WX(pX), -kR, NB.WZ(pY + 10)) into tSB
      catch tErr
         return empty
      end try
      if tS0 is empty or tSA is empty or tSB is empty then return empty
      put pSX - item 1 of tS0 into tEX
      put pSY - item 2 of tS0 into tEY
      if abs(tEX) < 0.25 and abs(tEY) < 0.25 then return round(pX, 2) & comma & round(pY, 2)
      put (item 1 of tSA - item 1 of tS0) / 10 into a11
      put (item 2 of tSA - item 2 of tS0) / 10 into a21
      put (item 1 of tSB - item 1 of tS0) / 10 into a12
      put (item 2 of tSB - item 2 of tS0) / 10 into a22
      put a11 * a22 - a12 * a21 into tDet
      if abs(tDet) < 0.000001 then return empty
      add (a22 * tEX - a12 * tEY) / tDet to pX
      add (a11 * tEY - a21 * tEX) / tDet to pY
      put max(-kW, min(2 * kW, pX)) into pX
      put max(-kH, min(2 * kH, pY)) into pY
   end repeat
   if abs(tEX) < 2 and abs(tEY) < 2 then return round(pX, 2) & comma & round(pY, 2)
   return empty
end NB.Newton

function NB.Pressed pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys and tC is not among the items of sKeysWas then return true
   end repeat
   return false
end NB.Pressed

function NB.Held pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys then return true
   end repeat
   return false
end NB.Held

------------------------------------------------------------------ the frame

on Game.OnUpdate
   local tKeys, tM, tDown, tClick, tStep, tTurn
   add 1 to sTicks
   put NB.Keys() into tKeys
   put NB.MouseTable() into tM
   put (item 3 of tM is "true") into tDown
   put tDown and not sMouseWas into tClick
   if NB.Pressed(tKeys, "114,82") then          -- R: a new rack
      NB.NewGame
   else if NB.Pressed(tKeys, "99,67") then      -- C: the other view
      put not sTopView into sTopView
      NB.Camera
      if sLabelsOn then NB.Labels true
      put empty into sHUDWas
   end if
   if sMode is "title" or sMode is "over" then
      if NB.Pressed(tKeys, "32") or tClick then
         if sMode is "over" then put 3 - sWinner into sTurn   -- the loser breaks
         NB.NewGame
         put true into sMouseWas
      end if
   else if sMode is "moving" then
      repeat with tStep = 1 to kSteps
         if NB.AllStopped() then
            NB.EndShot
            exit repeat
         end if
         NB.Step
      end repeat
      NB.MoveEntities
   else
      -- aiming: the keys
      put 0.02 into tTurn
      if NB.Held(tKeys, "65505,65506") then put 0.004 into tTurn
      if NB.Held(tKeys, "65361,97,65") then subtract tTurn from sAim
      if NB.Held(tKeys, "65363,100,68") then add tTurn to sAim
      if NB.Held(tKeys, "65362,119,87") then put min(kMaxPower, sPower + 0.2) into sPower
      if NB.Held(tKeys, "65364,115,83") then put max(0.5, sPower - 0.2) into sPower
      -- aiming: Scott Rossi's drag (from the cue ball toward where the ball should go)
      if tDown and item 1 of tM is a number and sOnTable[0] then
         put true into sDrag
         if NB.Dist(sX[0], sY[0], item 1 of tM, item 2 of tM) > 2 then
            put NB.LineAngle(sX[0], sY[0], item 1 of tM, item 2 of tM) into sAim
            put min(kMaxPower, NB.Dist(sX[0], sY[0], item 1 of tM, item 2 of tM) / 25) into sPower
         end if
      end if
      if sDrag and not tDown then
         put false into sDrag
         if sPower >= 0.5 then
            NB.Shoot sAim, sPower
         end if
      else if NB.Pressed(tKeys, "32") then
         NB.Shoot sAim, sPower
      end if
      if sMode is "aim" then NB.ShowAim
   end if
   put tKeys into sKeysWas
   put tDown into sMouseWas
   NB.ShowHUD
end Game.OnUpdate

on NB.MoveEntities
   local i
   repeat with i = 0 to 9
      if not sOnTable[i] or sBall[i] is empty then next repeat
      -- rolling: turn the ball by the distance it went over its radius
      add sVY[i] * kSteps / kR to sRotX[i]
      subtract sVX[i] * kSteps / kR from sRotZ[i]
      Entity.SetPosition sBall[i], NB.WX(sX[i]), -kR, NB.WZ(sY[i])
      Entity.SetRotation sBall[i], sRotX[i], 0, sRotZ[i]
   end repeat
end NB.MoveEntities

-- Rossi's two lines as dots: "v" from the cue ball to the drag point (the power, yellow)
-- and "vExtension" on across the table (white), stopping at the cushion
on NB.ShowAim
   local n, tX, tY, tLen, tD, tColor, tC
   if not sOnTable[0] then exit NB.ShowAim
   if sDot is empty then
      repeat with n = 1 to kDots
         put "white" into tColor
         if n <= 5 then put "#FFE040" into tColor
         put Entity.Spawn("NB.Dot", NB.WX(sX[0]), -kR, NB.WZ(sY[0]), tColor) into sDot[n]
      end repeat
      NB.Labels true
   end if
   put sPower * 25 into tLen
   put cos(sAim) into tC
   repeat with n = 1 to kDots
      if n <= 5 then
         put kR + (tLen - kR) * n / 5 into tD
      else
         put max(tLen, kR) + (n - 5) * 50 into tD
      end if
      put sX[0] + tD * tC into tX
      put sY[0] + tD * sin(sAim) into tY
      put max(kCushion, min(kW - kCushion, tX)) into tX
      put max(kCushion, min(kH - kCushion, tY)) into tY
      Entity.SetPosition sDot[n], NB.WX(tX), -kR, NB.WZ(tY)
   end repeat
end NB.ShowAim

on NB.HideAim
   local n
   repeat for each key n in sDot
      Entity.Kill sDot[n]
   end repeat
   put empty into sDot
end NB.HideAim

-- the numbers over the balls (only while they stand still)
on NB.Labels pOn
   local i, tS
   repeat with i = 1 to 9
      HUD.Remove "NB.N" & i
   end repeat
   put pOn into sLabelsOn
   if not pOn then exit NB.Labels
   repeat with i = 1 to 9
      if not sOnTable[i] then next repeat
      try
         put Camera.WorldToScreen(NB.WX(sX[i]), -2 * kR - 6, NB.WZ(sY[i])) into tS
      catch tErr
         put empty into tS
      end try
      if tS is not empty then HUD.Set "NB.N" & i, i, round(item 1 of tS) - 4, round(item 2 of tS) - 6, 11
   end repeat
end NB.Labels

------------------------------------------------------------------ the HUD

on NB.ShowHUD
   local tWords, tBottom, tL
   put gViewBottom into tBottom
   if tBottom is not a number or tBottom < 300 then put 600 into tBottom
   put sMode & "|" & sTurn & "|" & round(sPower, 1) & "|" & sMsg & "|" & NB.Lowest() & "|" & sTopView into tWords
   if tWords is sHUDWas then exit NB.ShowHUD
   put tWords into sHUDWas
   HUD.Remove "NB.Title"
   HUD.Remove "NB.Credit1"
   HUD.Remove "NB.Credit2"
   HUD.Remove "NB.Credit3"
   HUD.Remove "NB.Start"
   HUD.Set "NB.Credit", "NINE BALL BY SCOTT ROSSI - TABLE PHYSICS BY JIM HURLEY", 20, tBottom - 28, 10
   if sMode is "title" then
      HUD.Set "NB.Title", "NINE BALL", 250, 150, 30
      HUD.Set "NB.Credit1", "A GAME BY SCOTT ROSSI", 240, 210, 14
      HUD.Set "NB.Credit2", "TABLE PHYSICS BY JIM HURLEY", 215, 235, 14
      HUD.Set "NB.Credit3", "REWRITTEN FOR VIBECODE3D AND XT3D", 210, 260, 11
      HUD.Set "NB.Start", "SPACE OR CLICK TO BREAK", 240, 300, 14
      HUD.Remove "NB.Turn"
      HUD.Remove "NB.Msg"
      HUD.Remove "NB.Help"
      exit NB.ShowHUD
   end if
   put NB.Lowest() into tL
   if sMode is "over" then
      HUD.Set "NB.Turn", "PLAYER" && sWinner && "WINS   SHOTS" && sShots[1] && "-" && sShots[2], 20, 100, 14
      HUD.Set "NB.Start", "SPACE OR CLICK: A NEW RACK", 240, 300, 14
   else
      HUD.Set "NB.Turn", "PLAYER" && sTurn & ":  HIT THE" && tL && "FIRST    POWER" && round(sPower, 1), 20, 100, 14
   end if
   if sMsg is empty then
      HUD.Remove "NB.Msg"
   else
      HUD.Set "NB.Msg", sMsg, 20, 125, 12
   end if
   HUD.Set "NB.Help", "DRAG FROM THE CUE BALL - OR ARROWS AIM  UP/DOWN POWER  SPACE SHOOTS  C VIEW  R RACK", 20, tBottom - 46, 9
end NB.ShowHUD

------------------------------------------------------------------ for tests

-- "mode|turn|winner|lowest|on table|sunk last shot|first hit|cue x,y|msg"
function NB.State pWhat
   local i, tOn
   repeat with i = 0 to 9
      if sOnTable[i] then put i & comma after tOn
   end repeat
   switch pWhat
      case "energy"
         return NB.Energy()
      case "momentum"
         return NB.Momentum()
      case "ball0"
      case "ball9"
         return round(sX[char 5 of pWhat], 1) & comma & round(sY[char 5 of pWhat], 1)
      case "turn"
         return sTurn
      case "mode"
         return sMode
      case "aim"
         return round(sAim, 4) & comma & round(sPower, 2)
   end switch
   return sMode & "|" & sTurn & "|" & sWinner & "|" & NB.Lowest() & "|" & char 1 to -2 of tOn & "|" & \
         char 1 to -2 of sSunkNow & "|" & sFirstHit & "|" & round(sX[0]) & comma & round(sY[0]) & "|" & sMsg
end NB.State

function NB.Energy
   local i, tE
   put 0 into tE
   repeat with i = 0 to 9
      if sOnTable[i] then add (sVX[i] ^ 2 + sVY[i] ^ 2) / 2 to tE
   end repeat
   return tE
end NB.Energy

function NB.Momentum
   local i, tPX, tPY
   put 0 into tPX
   put 0 into tPY
   repeat with i = 0 to 9
      if sOnTable[i] then
         add sVX[i] to tPX
         add sVY[i] to tPY
      end if
   end repeat
   return tPX & comma & tPY
end NB.Momentum

-- set up a table for a test: "ball:x,y ball:x,y ..." (only these balls on the table)
on NB.TestTable pLayout
   local i, tW
   NB.NewGame
   NB.HideAim
   repeat with i = 0 to 9
      put false into sOnTable[i]
      if sBall[i] is not empty then Entity.Kill sBall[i]
      put empty into sBall[i]
   end repeat
   repeat for each word tW in pLayout
      put char 1 to offset(":", tW) - 1 of tW into i
      NB.Spot i, char offset(":", tW) + 1 to -1 of tW, 0
   end repeat
   put "aim" into sMode
   put empty into sMsg
   put empty into sHUDWas
end NB.TestTable

on NB.TestTurn pTurn
   put pTurn into sTurn
end NB.TestTurn

-- one line a ball on the table: "ball,x,y"
function NB.TestPositions
   local i, tOut
   repeat with i = 0 to 9
      if sOnTable[i] then put i & comma & sX[i] & comma & sY[i] & cr after tOut
   end repeat
   return char 1 to -2 of tOut
end NB.TestPositions
