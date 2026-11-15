######################################################################################
## CARD SCRIPT: "Play.LightTrailArena"   LIGHT TRAIL ARENA  (11 14 2026)
## Light bikes on a top-down grid. Every bike leaves a glowing wall behind it. Turn at
## right angles, box the rival bikes in, and don't touch any wall. The arena shrinks
## every round. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/897_Light_Trail_Arena), script by Claude.
## CONTROLS  Arrows (or WASD): turn    Space: use a speed boost    Escape: pause
## RULES     10 points for every 10 cells you ride. A yellow boost is 20 points and one
##           boost to spend (Space: double speed for a few seconds). Touching any wall
##           or trail costs a life and the round starts over. When every rival has
##           crashed you win the round: the next arena is smaller and has one more rival.
##           5 rounds.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sBike, sBikeN, sGrid, sCols, sRows, sSegN, sBoost, sBoosts, sPickup, sCellsRidden
local sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT, sEndT, sX0, sY0
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kCell = 10
constant kCY = 45            -- the arena's middle on screen
constant kPiece = 4          -- cells in a trail piece before it is drawn

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
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
   Light.StartLevel 1
end Game.OnStart

-- Spark's table: rivals = the round number. The arena shrinks each round.
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
   Mesh.Define "Light.Boost", MeshPyramid(4, 10, 14)
   Mesh.Define "Light.Piece", Light.LineMesh(kPiece * kCell)
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
   put empty into sPickup
   Light.NewPickup
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
   put pB into sGrid[pCX & "," & pCY]
   put Entity.Spawn("Light.Bike", Light.PX(pCX), Light.PY(pCY), kZ, sBike[pB]["color"]) into sBike[pB]["key"]
   SetObjectRotation sBike[pB]["key"], 0, 0, atan2(pDY, pDX)
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

on Light.NewPickup
   local tCX, tCY, tTries
   if sPickup["key"] is not empty then Entity.Kill sPickup["key"]
   repeat with tTries = 1 to 60
      put 3 + random(sCols - 6) into tCX
      put 3 + random(sRows - 6) into tCY
      if sGrid[tCX & "," & tCY] is empty then exit repeat
   end repeat
   put tCX into sPickup["cx"]
   put tCY into sPickup["cy"]
   put Entity.Spawn("Light.Boost", Light.PX(tCX), Light.PY(tCY), kZ, "255,255,0") into sPickup["key"]
end Light.NewPickup

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
   if sOver then
      if Light.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         put 0 into sBoosts
         Light.StartLevel 1
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
      put empty into sHUDWas
   end if
   put tKeys into sKeysWas
   -- each bike moves a cell every few steps: 2 cells a step for you on a boost
   repeat with i = 1 to sBikeN
      if not sBike[i]["alive"] then next repeat
      if i > 1 then Light.Think i
      put 0.5 into tSteps
      if i is 1 and sBoost > 0 then put 1 into tSteps
      if i > 1 then put 0.42 + sLevel * 0.02 into tSteps
      add tSteps to sBike[i]["sub"]
      repeat while sBike[i]["sub"] >= 1 and sBike[i]["alive"]
         subtract 1 from sBike[i]["sub"]
         Light.Step i
      end repeat
      if sBike[i]["alive"] then
         SetObjectPosition sBike[i]["key"], Light.PX(sBike[i]["cx"]) + sBike[i]["dx"] * sBike[i]["sub"] * kCell, Light.PY(sBike[i]["cy"]) + sBike[i]["dy"] * sBike[i]["sub"] * kCell, kZ
      end if
   end repeat
   if sBoost > 0 then
      subtract 1 from sBoost
      if sBoost is 0 then put empty into sHUDWas
   end if
   SetObjectRotation sPickup["key"], 0, 0, sTicks / 6
   -- the round's end
   put 0 into tAlive
   repeat with i = 2 to sBikeN
      if sBike[i]["alive"] then add 1 to tAlive
   end repeat
   if not sBike[1]["alive"] then
      put 45 into sEndT
      put "DEREZZED!" into sMsg
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
   local tNX, tNY, tCell
   if sBike[pB]["wantx"] is not sBike[pB]["dx"] or sBike[pB]["wanty"] is not sBike[pB]["dy"] then
      Light.CloseSegment pB
      put sBike[pB]["wantx"] into sBike[pB]["dx"]
      put sBike[pB]["wanty"] into sBike[pB]["dy"]
      SetObjectRotation sBike[pB]["key"], 0, 0, atan2(sBike[pB]["dy"], sBike[pB]["dx"])
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
      if tNX is sPickup["cx"] and tNY is sPickup["cy"] then
         add 20 to sScore
         add 1 to sBoosts
         FX.Sparks Light.PX(tNX), Light.PY(tNY), kZ, 10, "255,255,0"
         Light.NewPickup
         put empty into sHUDWas
      end if
   end if
end Light.Step

on Light.AddPiece pB
   local tSX, tSY, tKey
   -- the piece runs from kPiece cells back to here
   put Light.PX(sBike[pB]["cx"] - sBike[pB]["dx"] * kPiece) into tSX
   put Light.PY(sBike[pB]["cy"] - sBike[pB]["dy"] * kPiece) into tSY
   put Entity.Spawn("Light.Piece", tSX, tSY, kZ, sBike[pB]["color"]) into tKey
   SetObjectRotation tKey, 0, 0, atan2(sBike[pB]["dy"], sBike[pB]["dx"])
   put tKey & cr after sBike[pB]["pieces"]
end Light.AddPiece

-- a turn: the run's pieces become one long line
on Light.CloseSegment pB
   local tLen, tKey, tLine, tSX, tSY
   put sBike[pB]["run"] into tLen
   repeat for each line tKey in sBike[pB]["pieces"]
      Entity.Kill tKey
   end repeat
   put empty into sBike[pB]["pieces"]
   put 0 into sBike[pB]["run"]
   if tLen <= 0 then exit Light.CloseSegment
   add 1 to sSegN
   Mesh.Define "Light.Seg" & sSegN, Light.LineMesh(tLen * kCell)
   put Light.PX(sBike[pB]["cx"] - sBike[pB]["dx"] * tLen) into tSX
   put Light.PY(sBike[pB]["cy"] - sBike[pB]["dy"] * tLen) into tSY
   put Entity.Spawn("Light.Seg" & sSegN, tSX, tSY, kZ, sBike[pB]["color"]) into tKey
   SetObjectRotation tKey, 0, 0, atan2(sBike[pB]["dy"], sBike[pB]["dx"])
end Light.CloseSegment

-- the rivals look a few cells ahead and turn toward the more open side
on Light.Think pB
   local tAhead, tL, tR, tLX, tLY, tRX, tRY
   put Light.Free(pB, sBike[pB]["dx"], sBike[pB]["dy"], 6) into tAhead
   if tAhead >= 6 and random(40) > 1 then exit Light.Think
   put sBike[pB]["dy"] into tLX
   put -sBike[pB]["dx"] into tLY
   put -sBike[pB]["dy"] into tRX
   put sBike[pB]["dx"] into tRY
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
   SetObjectPosition sBike[pB]["key"], 0, -900, kZ
   if pB > 1 then
      add 100 * sLevel to sScore
      put empty into sHUDWas
   end if
end Light.Crash

on Light.EndRound
   if sBike[1]["alive"] then
      add 250 * sLevel to sScore
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
         put empty into sHUDWas
         Light.ShowHUD
      else
         Light.StartLevel sLevel + 1
      end if
   else
      subtract 1 from sLives
      if sLives <= 0 then
         put true into sOver
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
      put "END OF LINE.  SPACE TO RIDE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else if sBoost > 0 then
      put "BOOST!" into tLine
   else
      put "TURN WITH THE ARROWS.  YELLOW = BOOST" into tLine
   end if
   HUD.Set "Light.Msg", tLine, 20, 56, 12
end Light.ShowHUD

function Light.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|boosts " & sBoosts & "|" & sOver into tS
   repeat with i = 1 to sBikeN
      put "|bike" & i && sBike[i]["cx"] & "," & sBike[i]["cy"] && sBike[i]["alive"] after tS
   end repeat
   return tS
end Light.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
