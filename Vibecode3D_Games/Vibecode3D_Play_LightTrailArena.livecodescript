######################################################################################
## CARD SCRIPT: "Play.LightTrailArena"   LIGHT TRAIL ARENA  (11 14 2026)
## Light bikes on a top-down grid. Every bike leaves a glowing wall behind it. Turn at
## right angles, box the rival bikes in, and don't touch any wall. The arena shrinks
## every round. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/897_Light_Trail_Arena), script by Claude.
## CONTROLS  Arrows (or WASD): turn    Space: use a speed boost    Escape: pause
## CAMERA    the straight top-down view is the game. Hold the right button and drag to swing
##           the camera into 3D (it stops at the set angles on the way); let go and it comes
##           back. C: the next set angle (round to top-down again), hold 1-4 for one of them,
##           0: top-down. The camera never changes the play.
## RULES     10 points for every 10 cells you ride. Two yellow BITS are always out: ride
##           past one (beside it counts) for 20 points and one boost to spend (Space:
##           double speed for a few seconds), and the walls near it break, so a bit in a
##           trap is a way out. The rivals hunt the bits too (a bit speeds a rival up). A
##           bit's ring is its clock: one tick a second, it flashes at the end, then it
##           moves. Touching any wall or trail costs a life and the round starts over.
##           When every rival has crashed you win the round: the next arena is smaller
##           and has one more rival. 5 rounds.
## (owner's notes of 15 Nov 3:18: bigger reach, walls break, rivals hunt, two bits, a timer;
##  8:08 PM: 3D camera on the right button and set angles, top-down stays the default)
######################################################################################

global bPaused, bPlaying
global gCameraYaw, gCameraPitch, gNoMouse, gViewBottom

local sBike, sBikeN, sGrid, sCols, sRows, sSegN, sBoost, sBoosts, sBit, sCellsRidden
local sSeg, sLenDef, sRivalBits, sTestHold, sChunk, sChunkN
local sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT, sEndT, sX0, sY0
local sKeysWas, sTestKeys, sHUDWas, sTicks
local sCamT, sCamS, sCamGoT, sCamGoS, sCamDrag, sCamH0, sCamV0, sCamT0, sCamS0
local sCamPick, sCamHeld, sCamCycle, sCamFlat, sCamUsed, sCamHUDWas, sTestCamMouse

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kCell = 10
constant kCY = 45            -- the arena's middle on screen
constant kPiece = 4          -- cells in a trail piece before it is drawn
constant kBits = 2           -- bits out at once
constant kBitLife = 360      -- steps a bit stays (12 seconds), then it moves
constant kReach = 1          -- a bike this many cells away (beside it) takes the bit
constant kBreakR = 5         -- taking a bit breaks the trail cells this near it
constant kCamSets = 4        -- set camera angles (Light.CamSet)
constant kChunk = 12         -- straight runs drawn together as one object (p1-22: few objects = fast frames)

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put 0 into sSegN
   put 0 into sBoosts
   put 0 into sRivalBits
   Light.CamReset
   Light.StartLevel 1
end Game.OnStart

-- Spark's table: rivals = the round number. The arena shrinks each round.
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Light.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Light.StartLevel pLevel
   end if
end Light.GoLevel

on Light.StartLevel pLevel
   local i, tW, tH, tColors
   put pLevel into sLevel
   Scene.ClearAll
   put 86 - (pLevel - 1) * 6 into sCols
   put 48 - (pLevel - 1) * 4 into sRows
   put -sCols * kCell / 2 into sX0
   put kCY - sRows * kCell / 2 into sY0
   put sCols * kCell into tW
   put sRows * kCell into tH
   Mesh.Define "Light.Arena" & pLevel, Light.ArenaMesh(tW, tH, false)
   get Entity.Spawn("Light.Arena" & pLevel, 0, kCY, kZ, "0,255,255")
   Mesh.Define "Light.Floor" & pLevel, Light.ArenaMesh(tW, tH, true)
   get Entity.Spawn("Light.Floor" & pLevel, 0, kCY, kZ, "0,60,80")
   Mesh.Define "Light.Bike", Light.BikeMesh()
   Mesh.Define "Light.Boost", Mesh.Pyramid(4, 10, 14)
   Mesh.Define "Light.Piece", Light.LineMesh(kPiece * kCell)
   Mesh.Define "Light.Dot", Light.LineMesh(6)
   repeat with i = 0 to 12
      Mesh.Define "Light.Ring" & i, Light.RingMesh(i)
   end repeat
   put empty into sLenDef
   put empty into sSeg
   put empty into sChunk
   put 0 into sChunkN
   -- the grid: walls all round
   put empty into sGrid
   repeat with i = 0 to sCols + 1
      put 9 into sGrid[i & "," & 0]
      put 9 into sGrid[i & "," & (sRows + 1)]
   end repeat
   repeat with i = 0 to sRows + 1
      put 9 into sGrid[0 & "," & i]
      put 9 into sGrid[(sCols + 1) & "," & i]
   end repeat
   -- bikes: you (1) start low left heading right; rivals spread out
   put empty into sBike
   put 1 + pLevel into sBikeN
   put "255,255,255|255,60,200|255,150,0|0,255,100|160,100,255|255,255,0" into tColors
   set the itemDel to "|"
   repeat with i = 1 to sBikeN
      put item i of tColors into sBike[i]["color"]
   end repeat
   set the itemDel to comma
   repeat with i = 1 to sBikeN
      switch i mod 4
         case 1
            Light.PlaceBike i, 6 + (i div 4) * 4, sRows - 4 - (i div 4) * 6, 1, 0
            break
         case 2
            Light.PlaceBike i, sCols - 5 - (i div 4) * 4, 5 + (i div 4) * 6, -1, 0
            break
         case 3
            Light.PlaceBike i, sCols - 5, sRows - 6, 0, -1
            break
         case 0
            Light.PlaceBike i, 6, 6, 0, 1
            break
      end switch
   end repeat
   put 0 into sBoost
   put 0 into sCellsRidden
   put empty into sBit
   repeat with i = 1 to kBits
      Light.NewBit i
   end repeat
   put 0 into sEndT
   put "ROUND" && pLevel & ":" && pLevel && "RIVAL" & Light.S(pLevel) into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Light.StartLevel

function Light.S pN
   if pN is 1 then return empty
   return "S"
end Light.S

on Light.PlaceBike pB, pCX, pCY, pDX, pDY
   put pCX into sBike[pB]["cx"]
   put pCY into sBike[pB]["cy"]
   put pDX into sBike[pB]["dx"]
   put pDY into sBike[pB]["dy"]
   put pDX into sBike[pB]["wantx"]
   put pDY into sBike[pB]["wanty"]
   put 0 into sBike[pB]["sub"]
   put true into sBike[pB]["alive"]
   put pCX into sBike[pB]["segx"]
   put pCY into sBike[pB]["segy"]
   put empty into sBike[pB]["pieces"]
   put 0 into sBike[pB]["run"]
   put 0 into sBike[pB]["boost"]
   put pB into sGrid[pCX & "," & pCY]
   put Entity.Spawn("Light.Bike", Light.PX(pCX), Light.PY(pCY), kZ, sBike[pB]["color"]) into sBike[pB]["key"]
   Entity.SetRotation sBike[pB]["key"], 0, 0, atan2(pDY, pDX)
end Light.PlaceBike

function Light.PX pCX
   return sX0 + (pCX - 0.5) * kCell
end Light.PX

function Light.PY pCY
   return sY0 + (pCY - 0.5) * kCell
end Light.PY

function Light.ArenaMesh pW, pH, pFloor
   local tM, i
   put Mesh.New() into tM
   if pFloor then
      Light.FloorGrid tM, pW, pH
      return tM
   end if
   Mesh.AddVertex tM, -pW / 2, -pH / 2, 0
   Mesh.AddVertex tM, pW / 2, -pH / 2, 0
   Mesh.AddVertex tM, pW / 2, pH / 2, 0
   Mesh.AddVertex tM, -pW / 2, pH / 2, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 4, 1
   return tM
end Light.ArenaMesh

-- a faint floor grid every 8 cells
on Light.FloorGrid @tM, pW, pH
   local i
   repeat with i = 1 to trunc(pW / (8 * kCell))
      Mesh.AddVertex tM, -pW / 2 + i * 8 * kCell, -pH / 2, 20
      Mesh.AddVertex tM, -pW / 2 + i * 8 * kCell, pH / 2, 20
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   repeat with i = 1 to trunc(pH / (8 * kCell))
      Mesh.AddVertex tM, -pW / 2, -pH / 2 + i * 8 * kCell, 20
      Mesh.AddVertex tM, pW / 2, -pH / 2 + i * 8 * kCell, 20
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
end Light.FloorGrid

function Light.BikeMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 12, 0, 0
   Mesh.AddVertex tM, -8, -6, 0
   Mesh.AddVertex tM, -8, 6, 0
   Mesh.AddVertex tM, 0, 0, -8
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 1
   Mesh.AddLine tM, 1, 4
   Mesh.AddLine tM, 2, 4
   Mesh.AddLine tM, 3, 4
   return tM
end Light.BikeMesh

-- a straight trail of pLen units along +x (it is turned to fit)
function Light.LineMesh pLen
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, 0, 0
   Mesh.AddVertex tM, pLen, 0, 0
   Mesh.AddVertex tM, 0, 0, -6
   Mesh.AddVertex tM, pLen, 0, -6
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   return tM
end Light.LineMesh

-- a bit's clock: pN ticks of twelve round it
function Light.RingMesh pN
   local tM, j, tA
   put Mesh.New() into tM
   repeat with j = 1 to pN
      put (j - 1) * 3.14159 / 6 - 1.5708 into tA
      Mesh.AddVertex tM, 14 * cos(tA), 14 * sin(tA), 0
      put tA + 0.4 into tA
      Mesh.AddVertex tM, 14 * cos(tA), 14 * sin(tA), 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   if pN is 0 then
      Mesh.AddVertex tM, 0, 0, 0
      Mesh.AddVertex tM, 0, 0, 0
      Mesh.AddLine tM, 1, 2
   end if
   return tM
end Light.RingMesh

-- bit pWhich (re)appears on an open cell, away from the other bits and the bikes
on Light.NewBit pWhich
   local tCX, tCY, tTries, tOK, j
   if sBit[pWhich]["key"] is not empty then Entity.Kill sBit[pWhich]["key"]
   if sBit[pWhich]["ring"] is not empty then Entity.Kill sBit[pWhich]["ring"]
   repeat with tTries = 1 to 80
      put 3 + random(sCols - 6) into tCX
      put 3 + random(sRows - 6) into tCY
      put sGrid[tCX & "," & tCY] is empty into tOK
      repeat with j = 1 to kBits
         if j is not pWhich and sBit[j]["cx"] is not empty and abs(sBit[j]["cx"] - tCX) + abs(sBit[j]["cy"] - tCY) < 16 then put false into tOK
      end repeat
      repeat with j = 1 to sBikeN
         if sBike[j]["alive"] and abs(sBike[j]["cx"] - tCX) + abs(sBike[j]["cy"] - tCY) < 6 then put false into tOK
      end repeat
      if tOK then exit repeat
   end repeat
   Light.PutBit pWhich, tCX, tCY
end Light.NewBit

on Light.PutBit pWhich, pCX, pCY
   if sBit[pWhich]["key"] is not empty then Entity.Kill sBit[pWhich]["key"]
   if sBit[pWhich]["ring"] is not empty then Entity.Kill sBit[pWhich]["ring"]
   put pCX into sBit[pWhich]["cx"]
   put pCY into sBit[pWhich]["cy"]
   put kBitLife into sBit[pWhich]["t"]
   put 12 into sBit[pWhich]["ticks"]
   put Entity.Spawn("Light.Boost", Light.PX(pCX), Light.PY(pCY), kZ, "255,255,0") into sBit[pWhich]["key"]
   put Entity.Spawn("Light.Ring12", Light.PX(pCX), Light.PY(pCY), kZ, "255,220,0") into sBit[pWhich]["ring"]
end Light.PutBit

-- the bits spin, their clocks run down, the last three seconds flash, then they move
on Light.Bits
   local i, tTicks
   repeat with i = 1 to kBits
      subtract 1 from sBit[i]["t"]
      if sBit[i]["t"] <= 0 then
         FX.Sparks Light.PX(sBit[i]["cx"]), Light.PY(sBit[i]["cy"]), kZ, 6, "120,120,0"
         Light.NewBit i
         next repeat
      end if
      put ceiling(sBit[i]["t"] / 30) into tTicks
      if tTicks is not sBit[i]["ticks"] then
         Entity.Kill sBit[i]["ring"]
         put Entity.Spawn("Light.Ring" & tTicks, Light.PX(sBit[i]["cx"]), Light.PY(sBit[i]["cy"]), kZ, "255,220,0") into sBit[i]["ring"]
         put tTicks into sBit[i]["ticks"]
      end if
      if sBit[i]["t"] < 90 and (sTicks div 4) mod 2 is 0 then
         Entity.SetPosition sBit[i]["key"], 0, -900, kZ
      else
         Entity.SetPosition sBit[i]["key"], Light.PX(sBit[i]["cx"]), Light.PY(sBit[i]["cy"]), kZ
      end if
      Entity.SetRotation sBit[i]["key"], 0, 0, sTicks / 6
   end repeat
end Light.Bits

-- pB took bit pWhich: the walls near it break; you get points and a boost, a rival gets speed
on Light.TakeBit pB, pWhich
   local tCX, tCY
   put sBit[pWhich]["cx"] into tCX
   put sBit[pWhich]["cy"] into tCY
   FX.Sparks Light.PX(tCX), Light.PY(tCY), kZ, 24, "255,255,0"
   Light.Break tCX, tCY
   if pB is 1 then
      add 20 to sScore
      Sound.Play "Pickup"
      add 1 to sBoosts
      Light.Say "BIT! THE WALLS NEAR IT BREAK.  +1 BOOST"
   else
      add 1 to sRivalBits
      put 150 into sBike[pB]["boost"]
      Light.Say "A RIVAL GRABBED A BIT!"
   end if
   Light.NewBit pWhich
end Light.TakeBit

on Light.Say pText
   put pText into sMsg
   put 45 into sMsgT
   put empty into sHUDWas
end Light.Say

-- the trail cells near pCX,pCY go (the arena's edge and the bikes stay); the trails
-- there are redrawn from what is left
on Light.Break pCX, pCY
   local i, tX, tY, tHeads, tBroke
   repeat with i = 1 to sBikeN
      if sBike[i]["alive"] then
         Light.CloseSegment i
         put sBike[i]["cx"] & "," & sBike[i]["cy"] & cr after tHeads
      end if
   end repeat
   put false into tBroke
   repeat with tX = max(1, pCX - kBreakR) to min(sCols, pCX + kBreakR)
      repeat with tY = max(1, pCY - kBreakR) to min(sRows, pCY + kBreakR)
         if sGrid[tX & "," & tY] is empty or sGrid[tX & "," & tY] is 9 then next repeat
         if (tX & "," & tY) is among the lines of tHeads then next repeat
         put empty into sGrid[tX & "," & tY]
         put true into tBroke
      end repeat
   end repeat
   if not tBroke then exit Light.Break
   local tChunks
   repeat for each key i in sSeg
      if Light.SegNear(i, pCX, pCY) then put true into tChunks[sSeg[i]["chunk"]]
   end repeat
   repeat for each key i in tChunks
      Light.DrawChunk i
   end repeat
end Light.Break

function Light.SegNear pN, pCX, pCY
   local tX1, tY1, tX2, tY2
   put sSeg[pN]["ex"] into tX2
   put sSeg[pN]["ey"] into tY2
   put tX2 - sSeg[pN]["dx"] * sSeg[pN]["len"] into tX1
   put tY2 - sSeg[pN]["dy"] * sSeg[pN]["len"] into tY1
   if max(tX1, tX2) < pCX - kBreakR or min(tX1, tX2) > pCX + kBreakR then return false
   if max(tY1, tY2) < pCY - kBreakR or min(tY1, tY2) > pCY + kBreakR then return false
   return true
end Light.SegNear

-- a chunk (up to kChunk straight trails of one bike) is ONE object: one mesh of the runs of its
-- cells still standing, in screen units, the object at 0,0. Before 23 Nov every run was its own
-- object, and the engine's cost is mostly per object (p1-22: the frame rate fell as trails grew)
on Light.DrawChunk pC
   local tM, n, tB
   Entity.Kill sChunk[pC]["key"]
   put empty into sChunk[pC]["key"]
   put Mesh.New() into tM
   repeat for each line n in sChunk[pC]["segs"]
      Light.SegInto tM, n
   end repeat
   if tM["count"] is 0 then exit Light.DrawChunk
   Mesh.Define "Light.Chunk" & pC, tM
   put sChunk[pC]["b"] into tB
   put Entity.Spawn("Light.Chunk" & pC, 0, 0, kZ, sBike[tB]["color"]) into sChunk[pC]["key"]
end Light.DrawChunk

-- a straight trail's runs of standing cells into mesh pM
on Light.SegInto @pM, pN
   local k, tRun, tB, tCX, tCY, tDX, tDY
   put sSeg[pN]["b"] into tB
   put sSeg[pN]["dx"] into tDX
   put sSeg[pN]["dy"] into tDY
   put -1 into tRun
   repeat with k = sSeg[pN]["len"] down to -1
      put sSeg[pN]["ex"] - tDX * k into tCX
      put sSeg[pN]["ey"] - tDY * k into tCY
      if k >= 0 and sGrid[tCX & "," & tCY] is tB then
         if tRun < 0 then
            put k into tRun
         end if
      else if tRun >= 0 then
         -- cells tRun down to k + 1 stand
         Light.RunInto pM, pN, tRun, k + 1
         put -1 into tRun
      end if
   end repeat
end Light.SegInto

-- one run as the trail's two lines (floor and top, as Light.LineMesh); one cell = a short dash
on Light.RunInto @pM, pN, pFrom, pTo
   local tX1, tY1, tX2, tY2, tDX, tDY, tC
   put sSeg[pN]["dx"] into tDX
   put sSeg[pN]["dy"] into tDY
   put Light.PX(sSeg[pN]["ex"] - tDX * pFrom) into tX1
   put Light.PY(sSeg[pN]["ey"] - tDY * pFrom) into tY1
   if pFrom is pTo then
      put tX1 + 3 * tDX into tX2
      put tY1 + 3 * tDY into tY2
      subtract 3 * tDX from tX1
      subtract 3 * tDY from tY1
   else
      put tX1 + tDX * (pFrom - pTo) * kCell into tX2
      put tY1 + tDY * (pFrom - pTo) * kCell into tY2
   end if
   put pM["count"] into tC
   Mesh.AddVertex pM, tX1, tY1, 0
   Mesh.AddVertex pM, tX2, tY2, 0
   Mesh.AddVertex pM, tX1, tY1, -6
   Mesh.AddVertex pM, tX2, tY2, -6
   Mesh.AddLine pM, tC + 1, tC + 2
   Mesh.AddLine pM, tC + 3, tC + 4
end Light.RunInto

-- one trail mesh for each length, made when first needed
function Light.LenName pLen
   if sLenDef[pLen] is empty then
      Mesh.Define "Light.Len" & pLen, Light.LineMesh(pLen * kCell)
      put true into sLenDef[pLen]
   end if
   return "Light.Len" & pLen
end Light.LenName

-- the nearest bit to bike pB, as "cx,cy"
function Light.NearBit pB
   local i, tD, tBest, tOut
   put 1e9 into tBest
   repeat with i = 1 to kBits
      put abs(sBit[i]["cx"] - sBike[pB]["cx"]) + abs(sBit[i]["cy"] - sBike[pB]["cy"]) into tD
      if tD < tBest then
         put tD into tBest
         put sBit[i]["cx"] & "," & sBit[i]["cy"] into tOut
      end if
   end repeat
   return tOut
end Light.NearBit

function Light.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Light.Keys

on Light.TestKeys pKeys
   put pKeys into sTestKeys
end Light.TestKeys

function Light.Down pCode, pKeys
   return pCode is among the items of pKeys
end Light.Down

on Game.OnUpdate
   local tKeys, i, tAlive, tSteps
   put Light.Keys() into tKeys
   add 1 to sTicks
   Light.Camera tKeys
   if sOver then
      if Light.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         put 0 into sBoosts
         Light.GoLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   if sEndT > 0 then
      subtract 1 from sEndT
      if sEndT is 0 then Light.EndRound
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- turns: right angles only, never straight back
   if (Light.Down(65361, tKeys) or Light.Down(97, tKeys)) and sBike[1]["dx"] is not 1 then Light.Want 1, -1, 0
   if (Light.Down(65363, tKeys) or Light.Down(100, tKeys)) and sBike[1]["dx"] is not -1 then Light.Want 1, 1, 0
   if (Light.Down(65362, tKeys) or Light.Down(119, tKeys)) and sBike[1]["dy"] is not 1 then Light.Want 1, 0, -1
   if (Light.Down(65364, tKeys) or Light.Down(115, tKeys)) and sBike[1]["dy"] is not -1 then Light.Want 1, 0, 1
   if Light.Down(32, tKeys) and not (32 is among the items of sKeysWas) and sBoosts > 0 and sBoost <= 0 then
      subtract 1 from sBoosts
      put 120 into sBoost
      Sound.Play "Zap"
      put empty into sHUDWas
   end if
   put tKeys into sKeysWas
   -- each bike moves a cell every few steps: 2 cells a step for you on a boost
   repeat with i = 1 to sBikeN
      if not sBike[i]["alive"] then next repeat
      if i > 1 then Light.Think i
      if i is 1 and sTestHold is true then next repeat
      put 0.5 into tSteps
      if i is 1 and sBoost > 0 then put 1 into tSteps
      if i > 1 then
         put 0.42 + sLevel * 0.02 into tSteps
         if sBike[i]["boost"] > 0 then
            subtract 1 from sBike[i]["boost"]
            put tSteps * 1.6 into tSteps
         end if
      end if
      add tSteps to sBike[i]["sub"]
      repeat while sBike[i]["sub"] >= 1 and sBike[i]["alive"]
         subtract 1 from sBike[i]["sub"]
         Light.Step i
      end repeat
      if sBike[i]["alive"] then
         Entity.SetPosition sBike[i]["key"], Light.PX(sBike[i]["cx"]) + sBike[i]["dx"] * sBike[i]["sub"] * kCell, Light.PY(sBike[i]["cy"]) + sBike[i]["dy"] * sBike[i]["sub"] * kCell, kZ
      end if
   end repeat
   if sBoost > 0 then
      subtract 1 from sBoost
      if sBoost is 0 then put empty into sHUDWas
   end if
   Light.Bits
   -- the round's end
   put 0 into tAlive
   repeat with i = 2 to sBikeN
      if sBike[i]["alive"] then add 1 to tAlive
   end repeat
   if not sBike[1]["alive"] then
      put 45 into sEndT
      put "CRASHED!" into sMsg
      put 45 into sMsgT
   else if tAlive is 0 then
      put 45 into sEndT
      put "ARENA CLEARED!" into sMsg
      put 45 into sMsgT
   end if
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Light.ShowHUD
end Game.OnUpdate

on Light.Want pB, pDX, pDY
   put pDX into sBike[pB]["wantx"]
   put pDY into sBike[pB]["wanty"]
end Light.Want

-- one cell forward: turn first if one is waiting, then check the cell
on Light.Step pB
   local tNX, tNY, tCell, tI
   if sBike[pB]["wantx"] is not sBike[pB]["dx"] or sBike[pB]["wanty"] is not sBike[pB]["dy"] then
      Light.CloseSegment pB
      put sBike[pB]["wantx"] into sBike[pB]["dx"]
      put sBike[pB]["wanty"] into sBike[pB]["dy"]
      Entity.SetRotation sBike[pB]["key"], 0, 0, atan2(sBike[pB]["dy"], sBike[pB]["dx"])
      if pB is 1 then Sound.Play "Blip"
   end if
   put sBike[pB]["cx"] + sBike[pB]["dx"] into tNX
   put sBike[pB]["cy"] + sBike[pB]["dy"] into tNY
   put tNX & "," & tNY into tCell
   if sGrid[tCell] is not empty then
      Light.Crash pB
      exit Light.Step
   end if
   put pB into sGrid[tCell]
   put tNX into sBike[pB]["cx"]
   put tNY into sBike[pB]["cy"]
   add 1 to sBike[pB]["run"]
   -- every few cells, a piece of trail appears
   if sBike[pB]["run"] mod kPiece is 0 then Light.AddPiece pB
   if pB is 1 then
      add 1 to sCellsRidden
      if sCellsRidden mod 10 is 0 then
         add 10 to sScore
         put empty into sHUDWas
      end if
   end if
   -- any bike beside a bit takes it
   repeat with tI = 1 to kBits
      if abs(tNX - sBit[tI]["cx"]) <= kReach and abs(tNY - sBit[tI]["cy"]) <= kReach then
         Light.TakeBit pB, tI
         exit repeat
      end if
   end repeat
end Light.Step

on Light.AddPiece pB
   local tSX, tSY, tKey, tLen
   -- ONE line from the run's start to here, made longer each time (p1-22: one object, not one a piece)
   put sBike[pB]["run"] into tLen
   repeat for each line tKey in sBike[pB]["pieces"]
      Entity.Kill tKey
   end repeat
   put Light.PX(sBike[pB]["cx"] - sBike[pB]["dx"] * tLen) into tSX
   put Light.PY(sBike[pB]["cy"] - sBike[pB]["dy"] * tLen) into tSY
   put Entity.Spawn(Light.LenName(tLen), tSX, tSY, kZ, sBike[pB]["color"]) into tKey
   Entity.SetRotation tKey, 0, 0, atan2(sBike[pB]["dy"], sBike[pB]["dx"])
   put tKey into sBike[pB]["pieces"]
end Light.AddPiece

-- a turn: the run becomes a straight trail in the bike's newest chunk
on Light.CloseSegment pB
   local tLen, tKey, tLine, tC
   put sBike[pB]["run"] into tLen
   repeat for each line tKey in sBike[pB]["pieces"]
      Entity.Kill tKey
   end repeat
   put empty into sBike[pB]["pieces"]
   put 0 into sBike[pB]["run"]
   if tLen <= 0 then exit Light.CloseSegment
   add 1 to sSegN
   put pB into sSeg[sSegN]["b"]
   put sBike[pB]["cx"] into sSeg[sSegN]["ex"]
   put sBike[pB]["cy"] into sSeg[sSegN]["ey"]
   put sBike[pB]["dx"] into sSeg[sSegN]["dx"]
   put sBike[pB]["dy"] into sSeg[sSegN]["dy"]
   put tLen into sSeg[sSegN]["len"]
   put sBike[pB]["chunk"] into tC
   if tC is empty or the number of lines of sChunk[tC]["segs"] >= kChunk then
      add 1 to sChunkN
      put sChunkN into tC
      put pB into sChunk[tC]["b"]
      put tC into sBike[pB]["chunk"]
   end if
   put tC into sSeg[sSegN]["chunk"]
   put sSegN & cr after sChunk[tC]["segs"]
   Light.DrawChunk tC
end Light.CloseSegment

-- the rivals look a few cells ahead and turn toward the more open side
on Light.Think pB
   local tAhead, tL, tR, tLX, tLY, tRX, tRY, tT, tBX, tBY, tPL, tPR
   put Light.Free(pB, sBike[pB]["dx"], sBike[pB]["dy"], 6) into tAhead
   put sBike[pB]["dy"] into tLX
   put -sBike[pB]["dx"] into tLY
   put -sBike[pB]["dy"] into tRX
   put sBike[pB]["dx"] into tRY
   -- hunting: once the nearest bit is level or behind, turn toward it if that way is open
   put Light.NearBit(pB) into tT
   if tT is not empty and tAhead >= 3 and random(100) <= 60 + sLevel * 8 then
      put item 1 of tT - sBike[pB]["cx"] into tBX
      put item 2 of tT - sBike[pB]["cy"] into tBY
      if sBike[pB]["dx"] * tBX + sBike[pB]["dy"] * tBY <= 0 then
         put tLX * tBX + tLY * tBY into tPL
         put tRX * tBX + tRY * tBY into tPR
         if tPL > 0 and Light.Free(pB, tLX, tLY, 4) >= 4 then
            Light.Want pB, tLX, tLY
            exit Light.Think
         end if
         if tPR > 0 and Light.Free(pB, tRX, tRY, 4) >= 4 then
            Light.Want pB, tRX, tRY
            exit Light.Think
         end if
      else
         exit Light.Think
      end if
   end if
   if tAhead >= 6 and random(40) > 1 then exit Light.Think
   put Light.Free(pB, tLX, tLY, 30) into tL
   put Light.Free(pB, tRX, tRY, 30) into tR
   if tAhead >= 6 and max(tL, tR) < 10 then exit Light.Think
   if tAhead > max(tL, tR) and tAhead > 2 then exit Light.Think
   if tL > tR or (tL is tR and random(2) is 1) then
      Light.Want pB, tLX, tLY
   else
      Light.Want pB, tRX, tRY
   end if
end Light.Think

function Light.Free pB, pDX, pDY, pMax
   local i
   repeat with i = 1 to pMax
      if sGrid[(sBike[pB]["cx"] + pDX * i) & "," & (sBike[pB]["cy"] + pDY * i)] is not empty then return i - 1
   end repeat
   return pMax
end Light.Free

on Light.Crash pB
   put false into sBike[pB]["alive"]
   Light.CloseSegment pB
   FX.Sparks Light.PX(sBike[pB]["cx"]), Light.PY(sBike[pB]["cy"]), kZ, 22, sBike[pB]["color"]
   Entity.SetPosition sBike[pB]["key"], 0, -900, kZ
   if pB is 1 then Sound.Play "PlayerCrash"
   if pB > 1 then
      add 100 * sLevel to sScore
      Sound.Play "Explode"
      put empty into sHUDWas
   end if
end Light.Crash

on Light.EndRound
   if sBike[1]["alive"] then
      add 250 * sLevel to sScore
      Sound.Play "Win"
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
         put empty into sHUDWas
         Light.ShowHUD
      else
         Sound.Play "Warp"
         Light.GoLevel sLevel + 1
      end if
   else
      subtract 1 from sLives
      if sLives <= 0 then
         put true into sOver
         Sound.Play "Lose"
         put empty into sHUDWas
         Light.ShowHUD
      else
         Light.StartLevel sLevel
      end if
   end if
end Light.EndRound

on Light.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & sBoosts & "|" & (sBoost > 0) & "|" & sMsg into tWords
   if tWords is sHUDWas then exit Light.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Light.Score", "SCORE" && sScore && " LIVES" && sLives && " ROUND" && sLevel & "/5  BOOSTS" && sBoosts, 20, 30, 14
   if sOver and sWon and sScore > 500 then
      put "MASTER OF THE GRID!  SPACE TO RIDE AGAIN" into tLine
   else if sOver and sWon then
      put "LAST ARENA SURVIVED (500 POINTS TO MASTER IT).  SPACE" into tLine
   else if sOver then
      put "GAME OVER.  SPACE TO RIDE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else if sBoost > 0 then
      put "BOOST!" into tLine
   else
      put "ARROWS: TURN.  RIDE BY A YELLOW BIT: ITS WALLS BREAK, +1 BOOST (SPACE)" into tLine
   end if
   HUD.Set "Light.Msg", tLine, 20, 56, 12
end Light.ShowHUD

-------------------------------------------------------------------- the camera
-- Top-down (tilt 0) is the engine's own plain camera. Tilted, the camera sits on a sphere
-- round the arena's middle and looks back at it: tilt from straight down, spin round the
-- arena (0 = from the bottom of the screen). Look-at as in the iGame3D editor remake.

on Light.CamReset
   put 0 into sCamT
   put 0 into sCamS
   put 0 into sCamGoT
   put 0 into sCamGoS
   put false into sCamDrag
   put 0 into sCamPick
   put 0 into sCamHeld
   put 0 into sCamCycle
   put true into sCamFlat
   put empty into sCamHUDWas
end Light.CamReset

-- the set angles: tilt, spin, name
function Light.CamSet pN
   switch pN
      case 1
         return "1.0,0,LOW SOUTH"
      case 2
         return "0.62,0.6,SOUTH EAST"
      case 3
         return "0.62,-0.6,SOUTH WEST"
      case 4
         return "1.22,0.25,DOWN ON THE FLOOR"
   end switch
   return "0,0,TOP DOWN"
end Light.CamSet

on Light.CamGoal pN
   put item 1 of Light.CamSet(pN) into sCamGoT
   put item 2 of Light.CamSet(pN) into sCamGoS
   put pN into sCamPick
   if pN > 0 then put true into sCamUsed
end Light.CamGoal

-- the right button, the C, 0 and 1-4 keys; then the camera eases to its goal
on Light.Camera pKeys
   local tM, tT, tS, tN, i, tSet
   put Light.RightMouse() into tM
   if tM is not empty then
      if not sCamDrag then
         put true into sCamDrag
         put true into sCamUsed
         put item 1 of tM into sCamH0
         put item 2 of tM into sCamV0
         put sCamT into sCamT0
         put sCamS into sCamS0
      end if
      -- drag down to tilt, sideways to swing round
      put max(0, min(1.3, sCamT0 + (item 2 of tM - sCamV0) * 0.006)) into tT
      put max(-1.3, min(1.3, sCamS0 - (item 1 of tM - sCamH0) * 0.006)) into tS
      put 0 into sCamPick
      repeat with i = 1 to kCamSets
         put Light.CamSet(i) into tSet
         if abs(tT - item 1 of tSet) < 0.09 and abs(tS - item 2 of tSet) < 0.14 then
            -- it stops at a set angle on the way
            put item 1 of tSet into tT
            put item 2 of tSet into tS
            put i into sCamPick
         end if
      end repeat
      put tT into sCamT
      put tS into sCamS
      put tT into sCamGoT
      put tS into sCamGoS
   else
      if sCamDrag then
         -- let go: back to top-down
         put false into sCamDrag
         put 0 into sCamCycle
         Light.CamGoal 0
      end if
      if (Light.Down(99, pKeys) or Light.Down(67, pKeys)) and not (99 is among the items of sKeysWas or 67 is among the items of sKeysWas) then
         put (sCamCycle + 1) mod (kCamSets + 1) into sCamCycle
         put 0 into sCamHeld
         Light.CamGoal sCamCycle
      end if
      if Light.Down(48, pKeys) then
         put 0 into sCamCycle
         put 0 into sCamHeld
         Light.CamGoal 0
      end if
      put 0 into tN
      repeat with i = 1 to kCamSets
         if Light.Down(48 + i, pKeys) then put i into tN
      end repeat
      if tN > 0 then
         put tN into sCamHeld
         Light.CamGoal tN
      else if sCamHeld > 0 then
         -- a number key let go: back to top-down
         put 0 into sCamHeld
         put 0 into sCamCycle
         Light.CamGoal 0
      end if
      add (sCamGoT - sCamT) * 0.12 to sCamT
      add (sCamGoS - sCamS) * 0.12 to sCamS
      if abs(sCamGoT - sCamT) < 0.002 then put sCamGoT into sCamT
      if abs(sCamGoS - sCamS) < 0.002 then put sCamGoS into sCamS
   end if
   Light.ApplyCam
   Light.CamHUD
end Light.Camera

on Light.ApplyCam
   local tW, tR, tPY, tOX, tOY, tOZ
   if sCamT is 0 or sCamT < 0.002 then
      put 0 into sCamT
      if sCamFlat then exit Light.ApplyCam
      -- exactly the plain top-down camera
      Camera.SetPosition 0, 0, 0
      Camera.SetLook 0, 0
      put true into sCamFlat
      exit Light.ApplyCam
   end if
   put false into sCamFlat
   -- tilting, the pivot moves to the arena's middle and the camera backs off a little
   put min(1, sCamT / 0.35) into tW
   put kZ * (1 + 0.5 * tW) into tR
   put kCY * tW into tPY
   put tR * sin(sCamT) * sin(sCamS) into tOX
   put tR * sin(sCamT) * cos(sCamS) into tOY
   put -tR * cos(sCamT) into tOZ
   Camera.SetPosition tOX, tPY + tOY, kZ + tOZ
   Camera.SetLook atan2(-tOX, -tOZ), -atan2(-tOY, sqrt(tOX ^ 2 + tOZ ^ 2))
end Light.ApplyCam

on Light.CamHUD
   local tLine
   if sCamT is 0 and sCamGoT is 0 then
      if sCamUsed is true then
         put empty into tLine
      else
         put "RIGHT DRAG, C OR HOLD 1 TO 4: SEE THE ARENA IN 3D" into tLine
      end if
   else if sCamPick > 0 then
      put "VIEW:" && item 3 of Light.CamSet(sCamPick) & ".  C: NEXT   0: TOP DOWN" into tLine
   else
      put "VIEW: FREE.  LET GO FOR TOP DOWN" into tLine
   end if
   if tLine is sCamHUDWas then exit Light.CamHUD
   put tLine into sCamHUDWas
   if tLine is empty then
      HUD.Remove "Light.Cam"
   else
      HUD.Set "Light.Cam", tLine, 20, gViewBottom - 30, 11
   end if
end Light.CamHUD

-- the right button's point "h,v" while it is down, or empty
function Light.RightMouse
   local tErr
   if sTestCamMouse is not empty then
      if sTestCamMouse is "up" then return empty
      return sTestCamMouse
   end if
   if gNoMouse is true then return empty
   try
      if mouse(3) is "down" then return the mouseH & comma & the mouseV
   catch tErr
   end try
   return empty
end Light.RightMouse

-- tilt, spin, set angle, yaw, pitch (for the tests)
function Light.CamState
   return round(sCamT, 3) & comma & round(sCamS, 3) & comma & sCamPick & comma & round(gCameraYaw, 3) & comma & round(gCameraPitch, 3)
end Light.CamState

on Light.TestCamMouse pH, pV
   if pH is empty then
      put "up" into sTestCamMouse
   else
      put pH & comma & pV into sTestCamMouse
   end if
end Light.TestCamMouse

function Light.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|boosts " & sBoosts & "|" & sOver into tS
   repeat with i = 1 to sBikeN
      put "|bike" & i && sBike[i]["cx"] & "," & sBike[i]["cy"] && sBike[i]["alive"] after tS
   end repeat
   put "|bits" after tS
   repeat with i = 1 to kBits
      put " " & sBit[i]["cx"] & "," & sBit[i]["cy"] & "," & round(sBit[i]["t"] / 30) after tS
   end repeat
   put "|rival bits " & sRivalBits after tS
   return tS
end Light.State

-- test hooks: a bit put here, its clock, a wall cell, your bike held still, a cell's owner
on Light.TestBit pWhich, pCX, pCY
   Light.PutBit pWhich, pCX, pCY
end Light.TestBit

on Light.TestBitTime pWhich, pT
   put pT into sBit[pWhich]["t"]
end Light.TestBitTime

on Light.TestWall pCX, pCY, pOwner
   put pOwner into sGrid[pCX & "," & pCY]
end Light.TestWall

on Light.TestHold pFlag
   put pFlag into sTestHold
end Light.TestHold

on Light.TestPlace pB, pCX, pCY, pDX, pDY
   put empty into sGrid[sBike[pB]["cx"] & "," & sBike[pB]["cy"]]
   Entity.Kill sBike[pB]["key"]
   Light.PlaceBike pB, pCX, pCY, pDX, pDY
end Light.TestPlace

function Light.Cell pCX, pCY
   return sGrid[pCX & "," & pCY]
end Light.Cell

function Light.Size
   return sCols & "," & sRows
end Light.Size

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
