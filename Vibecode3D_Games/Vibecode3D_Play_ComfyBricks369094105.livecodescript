######################################################################################
## CARD SCRIPT: "Play.ComfyBricks369094105"   COMFY BRICKS  (made in ComfyUI, seed 369094105)
## A brick breaker put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## Wall 6 x 10, levels: checker, checker, frame. Power-ups: wide 8%, multi 4%, multi 5%.
## CONTROLS  Arrows Move  Space Serves   Escape: stop
## RULES     break every brick to clear the level; 3 levels, 3 lives, a ball past the bat is a
##           life lost. Tough bricks (with a cross) take two hits.
######################################################################################

## PART common/vec: wire shapes, floor styles, keys and the mouse, shared by every kit but cpong.
## Flat on the play plane: x right, y down, z 0 (the kit puts things at z = 300, one unit a pixel).

local sVecTestKeys, sVecTestMouse

-- a wire line in a mesh
on Vec.Line @pM, pX1, pY1, pX2, pY2
   local tA
   Mesh.AddVertex pM, pX1, pY1, 0
   put the result into tA
   Mesh.AddVertex pM, pX2, pY2, 0
   Mesh.AddLine pM, tA, the result
end Vec.Line

-- a wire rectangle, corners x1,y1 and x2,y2
on Vec.Rect @pM, pX1, pY1, pX2, pY2
   Vec.Line pM, pX1, pY1, pX2, pY1
   Vec.Line pM, pX2, pY1, pX2, pY2
   Vec.Line pM, pX2, pY2, pX1, pY2
   Vec.Line pM, pX1, pY2, pX1, pY1
end Vec.Rect

-- a wire circle of pN sides
on Vec.Ring @pM, pX, pY, pR, pN
   local i, tA, tB
   repeat with i = 0 to pN - 1
      put i * 2 * pi / pN into tA
      put (i + 1) * 2 * pi / pN into tB
      Vec.Line pM, pX + pR * cos(tA), pY + pR * sin(tA), pX + pR * cos(tB), pY + pR * sin(tB)
   end repeat
end Vec.Ring

-- a closed outline through "x,y" points, one a line
on Vec.Outline @pM, pPoints
   local tPrev, tFirst, tP
   repeat for each line tP in pPoints
      if tFirst is empty then
         put tP into tFirst
      else
         Vec.Line pM, item 1 of tPrev, item 2 of tPrev, item 1 of tP, item 2 of tP
      end if
      put tP into tPrev
   end repeat
   if tFirst is not empty and tPrev is not tFirst then Vec.Line pM, item 1 of tPrev, item 2 of tPrev, item 1 of tFirst, item 2 of tFirst
end Vec.Outline

-- a shape about pSize across, centred on 0,0, pointing up (-y) when it points:
-- square diamond ring tri ship saucer crab bug rock star plus capsule
function Vec.Shape pShape, pSize
   local tM, h, q
   put Mesh.New() into tM
   put pSize / 2 into h
   put pSize / 4 into q
   switch pShape
      case "diamond"
         Vec.Outline tM, "0," & -h & cr & h & ",0" & cr & "0," & h & cr & -h & ",0"
         Vec.Line tM, 0, -h, 0, h
         break
      case "ring"
         Vec.Ring tM, 0, 0, h, 10
         break
      case "tri"
         Vec.Outline tM, "0," & -h & cr & h & "," & h & cr & -h & "," & h
         break
      case "ship"
         Vec.Outline tM, "0," & -h & cr & h & "," & h & cr & "0," & q & cr & -h & "," & h
         break
      case "saucer"
         Vec.Outline tM, -h & ",0" & cr & -q & "," & -q & cr & q & "," & -q & cr & h & ",0" & cr & q & "," & q & cr & -q & "," & q
         Vec.Line tM, -h, 0, h, 0
         Vec.Outline tM, -q & "," & -q & cr & "0," & -h & cr & q & "," & -q
         break
      case "crab"
         Vec.Rect tM, -q * 1.4, -q, q * 1.4, q
         Vec.Line tM, -q * 1.4, -q * 0.3, -h, -h
         Vec.Line tM, q * 1.4, -q * 0.3, h, -h
         Vec.Line tM, -q, q, -h, h
         Vec.Line tM, q, q, h, h
         Vec.Line tM, -q * 0.5, 0, -q * 0.5, -q * 0.4
         Vec.Line tM, q * 0.5, 0, q * 0.5, -q * 0.4
         break
      case "bug"
         Vec.Outline tM, "0," & -q & cr & q & ",0" & cr & "0," & h & cr & -q & ",0"
         Vec.Line tM, 0, -q, -q, -h
         Vec.Line tM, 0, -q, q, -h
         Vec.Line tM, -q, 0, -h, q * 0.5
         Vec.Line tM, q, 0, h, q * 0.5
         break
      case "rock"
         Vec.Outline tM, "0," & -h & cr & h * 0.7 & "," & -h * 0.8 & cr & h & "," & -q * 0.4 & cr & h * 0.8 & "," & h * 0.6 & cr & q * 0.2 & "," & h & cr & -h * 0.6 & "," & h * 0.8 & cr & -h & "," & q * 0.5 & cr & -h * 0.75 & "," & -h * 0.55 & cr & -q & "," & -h * 0.7
         break
      case "star"
         Vec.Star tM, h
         break
      case "plus"
         Vec.Outline tM, -q * 0.5 & "," & -h & cr & q * 0.5 & "," & -h & cr & q * 0.5 & "," & -q * 0.5 & cr & h & "," & -q * 0.5 & cr & h & "," & q * 0.5 & cr & q * 0.5 & "," & q * 0.5 & cr & q * 0.5 & "," & h & cr & -q * 0.5 & "," & h & cr & -q * 0.5 & "," & q * 0.5 & cr & -h & "," & q * 0.5 & cr & -h & "," & -q * 0.5 & cr & -q * 0.5 & "," & -q * 0.5
         break
      case "capsule"
         Vec.Rect tM, -h, -q, h, q
         Vec.Line tM, -q, -q, -q, q
         Vec.Line tM, q, -q, q, q
         break
      default
         Vec.Rect tM, -h, -h, h, h
   end switch
   return tM
end Vec.Shape

on Vec.Star @pM, pR
   local i, tA, tPts
   repeat with i = 0 to 9
      put -pi / 2 + i * pi / 5 into tA
      if i mod 2 = 0 then
         put pR * cos(tA) & "," & pR * sin(tA) & cr after tPts
      else
         put pR * 0.45 * cos(tA) & "," & pR * 0.45 * sin(tA) & cr after tPts
      end if
   end repeat
   delete the last char of tPts
   Vec.Outline pM, tPts
end Vec.Star

-- the floor under a play area pHW x pHH (half sizes): grid, rings, stars, dots, lanes or bare.
-- pStep is the spacing; nothing is added for bare.
on Vec.Decor @pM, pStyle, pHW, pHH, pStep
   local tX, tY, tS, i, tN
   put max(16, pStep) into tS
   switch pStyle
      case "grid"
         put 0 into tX
         repeat while tX < pHW
            Vec.Line pM, tX, -pHH, tX, pHH
            if tX > 0 then Vec.Line pM, -tX, -pHH, -tX, pHH
            add tS to tX
         end repeat
         put 0 into tY
         repeat while tY < pHH
            Vec.Line pM, -pHW, tY, pHW, tY
            if tY > 0 then Vec.Line pM, -pHW, -tY, pHW, -tY
            add tS to tY
         end repeat
         break
      case "rings"
         put tS into tX
         repeat while tX < min(pHW, pHH)
            Vec.Ring pM, 0, 0, tX, 28
            add tS to tX
         end repeat
         break
      case "stars"
         -- the same sky every time: a fixed walk, not the random numbers
         put round(pHW * pHH / (tS * tS) * 2) into tN
         repeat with i = 1 to tN
            put ((i * 7919) mod 1000) / 1000 * 2 * pHW - pHW into tX
            put ((i * 104729) mod 997) / 997 * 2 * pHH - pHH into tY
            Vec.Line pM, tX - 1.5, tY, tX + 1.5, tY
            if i mod 3 = 0 then Vec.Line pM, tX, tY - 1.5, tX, tY + 1.5
         end repeat
         break
      case "dots"
         put -pHW + tS / 2 into tX
         repeat while tX < pHW
            put -pHH + tS / 2 into tY
            repeat while tY < pHH
               Vec.Line pM, tX - 1, tY, tX + 1, tY
               add tS to tY
            end repeat
            add tS to tX
         end repeat
         break
      case "lanes"
         put -pHW + tS into tX
         repeat while tX < pHW - 1
            put -pHH into tY
            repeat while tY < pHH
               Vec.Line pM, tX, tY, tX, min(pHH, tY + tS / 3)
               add tS * 2 / 3 to tY
            end repeat
            add tS to tX
         end repeat
         break
   end switch
end Vec.Decor

-- keys: the keys held now (a test can set them with Vec.TestKeys)
function Vec.Keys
   if sVecTestKeys is not empty then return sVecTestKeys
   return the keysDown
end Vec.Keys

on Vec.TestKeys pKeys
   put pKeys into sVecTestKeys
end Vec.TestKeys

function Vec.AnyKey pList, pKeys
   local tK
   repeat for each item tK in pList
      if tK is among the items of pKeys then return true
   end repeat
   return false
end Vec.AnyKey

-- "dx,dy" (-1, 0 or 1 each) for a control: arrows or wasd
function Vec.Dir pCtrl, pKeys
   -- (a one-line if just before an else would take the else: so no else here)
   if pCtrl is "wasd" then return Vec.DirOf(pKeys, "97,65", "100,68", "119,87", "115,83")
   return Vec.DirOf(pKeys, "65361", "65363", "65362", "65364")
end Vec.Dir

function Vec.DirOf pKeys, pLeft, pRight, pUp, pDown
   local dx, dy
   put 0 into dx
   put 0 into dy
   if Vec.AnyKey(pLeft, pKeys) then subtract 1 from dx
   if Vec.AnyKey(pRight, pKeys) then add 1 to dx
   if Vec.AnyKey(pUp, pKeys) then subtract 1 from dy
   if Vec.AnyKey(pDown, pKeys) then add 1 to dy
   return dx & "," & dy
end Vec.DirOf

-- the fire key (Space, or Z / Enter with the arrows, F with wasd)
function Vec.Fire pCtrl, pKeys
   if 32 is among the items of pKeys then return true
   if pCtrl is "wasd" then return Vec.AnyKey("102,70", pKeys)
   return Vec.AnyKey("122,90,65293", pKeys)
end Vec.Fire

-- the mouse as "x,y" on the play plane (pZ deep), or empty: no mouse, or a test turned it off
function Vec.MousePoint pZ
   local tM, tP
   if sVecTestMouse is not empty then
      if sVecTestMouse is "none" then return empty
      return sVecTestMouse
   end if
   put Engine.Mouse() into tM
   if tM is empty then return empty
   put Engine.Info("projection") into tP
   if item 1 of tP is not a number or item 1 of tP <= 0 then return empty
   return ((item 1 of tM - item 2 of tP) * pZ / item 1 of tP) & "," & ((item 2 of tM - item 3 of tP) * pZ / item 1 of tP)
end Vec.MousePoint

on Vec.TestMouse pXY
   put pXY into sVecTestMouse
end Vec.TestMouse

-- a number between pLo and pHi
function Vec.Clamp pV, pLo, pHi
   return max(pLo, min(pHi, pV))
end Vec.Clamp

## PART core (CBRICK): a brick breaker. A bat at the bottom, a wall of bricks at the top, balls
## between; the bottom is open. Break every brick to clear the level. Power-ups fall from broken
## bricks when the chain has Power-Up nodes. The builder adds Brick.Config (the node settings).

global bPaused, bPlaying

local sCfg, sRow, sPow, sPowN
local sCell, sLeft, sBall, sBallN, sBat, sDrop, sDropSeq
local sLevel, sLives, sScore, sOver, sWonAll, sServeT, sHUDWas, sSpeedNow, sWideT, sSlowT, sTick, sMsg, sMsgT, sAuto

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Brick.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put false into sOver
   Brick.StartLevel 1
end Game.OnStart

on Brick.StartLevel pLevel
   local tM, tPattern
   put pLevel into sLevel
   put sCfg["ballSpeed"] * (1 + sCfg["levelGain"] * (pLevel - 1)) into sSpeedNow
   put 0 into sWideT
   put 0 into sSlowT
   put empty into sDrop
   put empty into sCell
   put empty into sBall
   Scene.ClearAll
   Particles.Clear
   put Mesh.New() into tM
   Vec.Decor tM, sCfg["floor"], sCfg["hw"], sCfg["hh"], sCfg["grid"]
   if tM["count"] > 0 then
      Mesh.Define "Brick.Floor", tM
      get Entity.Spawn("Brick.Floor", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   put Mesh.New() into tM
   Vec.Line tM, -sCfg["hw"], sCfg["hh"], -sCfg["hw"], -sCfg["hh"]
   Vec.Line tM, -sCfg["hw"], -sCfg["hh"], sCfg["hw"], -sCfg["hh"]
   Vec.Line tM, sCfg["hw"], -sCfg["hh"], sCfg["hw"], sCfg["hh"]
   Mesh.Define "Brick.Walls", tM
   get Entity.Spawn("Brick.Walls", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   -- the bricks: one mesh for plain ones, one with a cross for tough ones
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["bw"] / 2, -sCfg["bh"] / 2, sCfg["bw"] / 2, sCfg["bh"] / 2
   Mesh.Define "Brick.Plain", tM
   Vec.Line tM, -sCfg["bw"] / 2, -sCfg["bh"] / 2, sCfg["bw"] / 2, sCfg["bh"] / 2
   Vec.Line tM, -sCfg["bw"] / 2, sCfg["bh"] / 2, sCfg["bw"] / 2, -sCfg["bh"] / 2
   Mesh.Define "Brick.Tough", tM
   put item ((pLevel - 1) mod the number of items of sCfg["patterns"] + 1) of sCfg["patterns"] into tPattern
   Brick.BuildWall tPattern
   -- the bat, plain and wide
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["batHalf"], -6, sCfg["batHalf"], 6
   Mesh.Define "Brick.Bat", tM
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["batHalf"] * 1.6, -6, sCfg["batHalf"] * 1.6, 6
   Vec.Line tM, -sCfg["batHalf"] * 1.6, 0, sCfg["batHalf"] * 1.6, 0
   Mesh.Define "Brick.BatWide", tM
   put sCfg["batHalf"] into sBat["half"]
   put 0 into sBat["x"]
   put sCfg["hh"] - 30 into sBat["y"]
   put Entity.Spawn("Brick.Bat", 0, sCfg["cy"] + sBat["y"], kZ, sCfg["batColor"]) into sBat["key"]
   Mesh.Define "Brick.Ball", Vec.Shape(sCfg["ballShape"], sCfg["ballSize"])
   Mesh.Define "Brick.Drop", Vec.Shape("capsule", 22)
   put 0 into sBallN
   Brick.AddBall
   Brick.Serve
   Brick.Say "LEVEL" && pLevel & ": " & toUpper(tPattern), 60
end Brick.StartLevel

-- a brick wanted at row pR, column pC in this pattern?
function Brick.Wants pPattern, pR, pC
   local tRows, tCols, tMid
   put sCfg["rows"] into tRows
   put sCfg["cols"] into tCols
   put (tCols + 1) / 2 into tMid
   switch pPattern
      case "checker"
         return (pR + pC) mod 2 = 0
      case "pyramid"
         return abs(pC - tMid) < pR * tCols / (2 * tRows) + 0.5
      case "columns"
         return pC mod 3 is not 0
      case "frame"
         return pR = 1 or pR = tRows or pC = 1 or pC = tCols
      case "holes"
         return random(100) > 25
      default
         return true
   end switch
end Brick.Wants

on Brick.BuildWall pPattern
   local r, c, tX, tY, tHP, tKey
   put 0 into sLeft
   if pPattern is "holes" then set the randomSeed to sCfg["seed"] + sLevel
   repeat with r = 1 to sCfg["rows"]
      repeat with c = 1 to sCfg["cols"]
         if not Brick.Wants(pPattern, r, c) then next repeat
         put Brick.CellX(c) into tX
         put Brick.CellY(r) into tY
         if r <= sCfg["tough"] then
            put 2 into tHP
            put Entity.Spawn("Brick.Tough", tX, sCfg["cy"] + tY, kZ, sRow[r]) into tKey
         else
            put 1 into tHP
            put Entity.Spawn("Brick.Plain", tX, sCfg["cy"] + tY, kZ, sRow[r]) into tKey
         end if
         put tKey into sCell[r][c]["key"]
         put tHP into sCell[r][c]["hp"]
         add 1 to sLeft
      end repeat
   end repeat
end Brick.BuildWall

function Brick.CellX pC
   return -sCfg["hw"] + sCfg["side"] + (pC - 0.5) * sCfg["pitchX"]
end Brick.CellX

function Brick.CellY pR
   return -sCfg["hh"] + sCfg["top"] + (pR - 0.5) * sCfg["pitchY"]
end Brick.CellY

on Brick.AddBall
   if sBallN >= 3 then exit Brick.AddBall
   add 1 to sBallN
   put true into sBall[sBallN]["live"]
   put sBat["x"] into sBall[sBallN]["x"]
   put sBat["y"] - 6 - sCfg["ballSize"] / 2 into sBall[sBallN]["y"]
   put 0 into sBall[sBallN]["dx"]
   put 0 into sBall[sBallN]["dy"]
   put Entity.Spawn("Brick.Ball", sBall[sBallN]["x"], sCfg["cy"] + sBall[sBallN]["y"], kZ, sCfg["ballColor"]) into sBall[sBallN]["key"]
end Brick.AddBall

-- the ball rests on the bat until Space (or a while passes)
on Brick.Serve
   put sCfg["serveWait"] into sServeT
   put empty into sHUDWas
end Brick.Serve

on Brick.Launch
   local i, tA
   put 0 into sServeT
   repeat with i = 1 to sBallN
      if not sBall[i]["live"] then next repeat
      if sBall[i]["dy"] is not 0 then next repeat
      put (random(61) - 31) / 100 into tA
      put sSpeedNow * sin(tA) into sBall[i]["dx"]
      put -sSpeedNow * cos(tA) into sBall[i]["dy"]
   end repeat
end Brick.Launch

on Game.OnUpdate
   local tKeys, i, tLive
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put false into sOver
         Brick.StartLevel 1
      end if
      Brick.ShowHUD
      exit Game.OnUpdate
   end if
   Brick.MoveBat tKeys
   if sWideT > 0 then
      subtract 1 from sWideT
      if sWideT = 0 then
         Entity.SetMesh sBat["key"], "Brick.Bat"
         put sCfg["batHalf"] into sBat["half"]
      end if
   end if
   if sSlowT > 0 then subtract 1 from sSlowT
   if sServeT > 0 then
      subtract 1 from sServeT
      if Vec.Fire(sCfg["ctrl"], tKeys) or sServeT = 0 then Brick.Launch
   end if
   put 0 into tLive
   repeat with i = 1 to sBallN
      if not sBall[i]["live"] then next repeat
      Brick.MoveBall i
      if sBall[i]["live"] then add 1 to tLive
      if sOver or sLeft = 0 then exit repeat
   end repeat
   Brick.MoveDrops
   if sLeft = 0 and not sOver then
      add sCfg["levelBonus"] * sLevel to sScore
      if sLevel >= sCfg["levels"] then
         put true into sOver
         put true into sWonAll
      else
         Brick.StartLevel sLevel + 1
      end if
   else if tLive = 0 and not sOver then
      Brick.LoseLife
   end if
   if sMsgT > 0 then subtract 1 from sMsgT
   Brick.ShowHUD
end Game.OnUpdate

on Brick.MoveBat pKeys
   local tDir, tM, tRoom, i
   put sCfg["hw"] - sBat["half"] into tRoom
   if sAuto is true then
      Brick.AutoBat
   else if sCfg["ctrl"] is "mouse" then
      put Vec.MousePoint(kZ) into tM
      if tM is not empty then
         put item 1 of tM into sBat["x"]
      end if
   else
      put item 1 of Vec.Dir(sCfg["ctrl"], pKeys) into tDir
      add tDir * sCfg["batSpeed"] to sBat["x"]
   end if
   put Vec.Clamp(sBat["x"], -tRoom, tRoom) into sBat["x"]
   Entity.SetPosition sBat["key"], sBat["x"], sCfg["cy"] + sBat["y"], kZ
   -- a ball waiting on the bat rides along
   repeat with i = 1 to sBallN
      if sBall[i]["live"] and sBall[i]["dy"] = 0 then
         put sBat["x"] into sBall[i]["x"]
         Brick.PlaceBall i
      end if
   end repeat
end Brick.MoveBat

-- tests (and a demo): the bat follows the lowest ball coming down, aiming a little off centre
on Brick.TestAuto pOn
   put pOn into sAuto
end Brick.TestAuto

on Brick.AutoBat
   local i, tBest, tY, tTarget, r, c, tAim, tGo, tDX, tDY
   put -9999 into tY
   repeat with i = 1 to sBallN
      if sBall[i]["live"] and sBall[i]["dy"] > 0 and sBall[i]["y"] > tY then
         put sBall[i]["y"] into tY
         put i into tBest
      end if
   end repeat
   if tBest is empty then exit Brick.AutoBat
   -- aim: the lowest brick still standing (the first found), hit where the bounce sends the ball at it
   repeat with r = sCfg["rows"] down to 1
      repeat with c = 1 to sCfg["cols"]
         if sCell[r][c]["hp"] is a number and sCell[r][c]["hp"] > 0 then
            put c & "," & r into tAim
            exit repeat
         end if
      end repeat
      if tAim is not empty then exit repeat
   end repeat
   put 0 into tGo
   if tAim is not empty then
      put Brick.CellX(item 1 of tAim) - sBall[tBest]["x"] into tDX
      put sBat["y"] - Brick.CellY(item 2 of tAim) into tDY
      -- the bounce angle is (where it lands on the bat / half the bat) * 1.05, 0 straight up
      put Vec.Clamp(atan2(tDX, tDY) / 1.05, -0.9, 0.9) * sBat["half"] into tGo
   end if
   put sBall[tBest]["x"] - tGo into tTarget
   add Vec.Clamp(tTarget - sBat["x"], -sCfg["batSpeed"] * 1.5, sCfg["batSpeed"] * 1.5) to sBat["x"]
end Brick.AutoBat

on Brick.PlaceBall pB
   Entity.SetPosition sBall[pB]["key"], sBall[pB]["x"], sCfg["cy"] + sBall[pB]["y"], kZ
end Brick.PlaceBall

on Brick.MoveBall pB
   local tR, tF, tOff, tSp, tA
   if sBall[pB]["dy"] = 0 then exit Brick.MoveBall
   put sCfg["ballSize"] / 2 into tR
   put 1 into tF
   if sSlowT > 0 then put 0.65 into tF
   put sBall[pB]["x"] into sBall[pB]["px"]
   put sBall[pB]["y"] into sBall[pB]["py"]
   add sBall[pB]["dx"] * tF to sBall[pB]["x"]
   add sBall[pB]["dy"] * tF to sBall[pB]["y"]
   -- walls
   if sBall[pB]["x"] < -sCfg["hw"] + tR then
      put -sCfg["hw"] + tR into sBall[pB]["x"]
      put abs(sBall[pB]["dx"]) into sBall[pB]["dx"]
   end if
   if sBall[pB]["x"] > sCfg["hw"] - tR then
      put sCfg["hw"] - tR into sBall[pB]["x"]
      put -abs(sBall[pB]["dx"]) into sBall[pB]["dx"]
   end if
   if sBall[pB]["y"] < -sCfg["hh"] + tR then
      put -sCfg["hh"] + tR into sBall[pB]["y"]
      put abs(sBall[pB]["dy"]) into sBall[pB]["dy"]
   end if
   -- the bat: only a ball coming down, landing on its top; where it lands sets the angle
   if sBall[pB]["dy"] > 0 and sBall[pB]["y"] + tR >= sBat["y"] - 6 and sBall[pB]["py"] + tR <= sBat["y"] - 6 + 1 then
      put sBall[pB]["x"] - sBat["x"] into tOff
      if abs(tOff) <= sBat["half"] + tR then
         put min(sCfg["ballMax"], sqrt(sBall[pB]["dx"] ^ 2 + sBall[pB]["dy"] ^ 2) * sCfg["ballGain"]) into tSp
         put Vec.Clamp(tOff / sBat["half"], -1, 1) * 1.05 into tA
         put tSp * sin(tA) into sBall[pB]["dx"]
         put -tSp * cos(tA) into sBall[pB]["dy"]
         put sBat["y"] - 6 - tR into sBall[pB]["y"]
         FX.Sparks sBall[pB]["x"], sCfg["cy"] + sBall[pB]["y"] + tR, kZ, 4, sCfg["batColor"]
      end if
   end if
   Brick.HitBricks pB, tR
   if sBall[pB]["y"] > sCfg["hh"] + 40 then
      put false into sBall[pB]["live"]
      Entity.Kill sBall[pB]["key"]
      exit Brick.MoveBall
   end if
   Brick.PlaceBall pB
end Brick.MoveBall

-- the bricks the ball's box touches; the first one hit turns it round and the step ends
on Brick.HitBricks pB, pR
   local r, c, r1, r2, c1, c2, tX, tY, tHX, tHY, tWasX, tWasY
   put sCfg["bw"] / 2 into tHX
   put sCfg["bh"] / 2 into tHY
   put floor((sBall[pB]["x"] - pR + sCfg["hw"] - sCfg["side"]) / sCfg["pitchX"]) + 1 into c1
   put floor((sBall[pB]["x"] + pR + sCfg["hw"] - sCfg["side"]) / sCfg["pitchX"]) + 1 into c2
   put floor((sBall[pB]["y"] - pR + sCfg["hh"] - sCfg["top"]) / sCfg["pitchY"]) + 1 into r1
   put floor((sBall[pB]["y"] + pR + sCfg["hh"] - sCfg["top"]) / sCfg["pitchY"]) + 1 into r2
   repeat with r = max(1, r1) to min(sCfg["rows"], r2)
      repeat with c = max(1, c1) to min(sCfg["cols"], c2)
         if sCell[r][c]["hp"] is not a number or sCell[r][c]["hp"] <= 0 then next repeat
         put Brick.CellX(c) into tX
         put Brick.CellY(r) into tY
         if abs(sBall[pB]["x"] - tX) > tHX + pR or abs(sBall[pB]["y"] - tY) > tHY + pR then next repeat
         -- which face: where the ball was a step ago
         put abs(sBall[pB]["px"] - tX) <= tHX + pR into tWasX
         put abs(sBall[pB]["py"] - tY) <= tHY + pR into tWasY
         if tWasX or not tWasY then
            put -sBall[pB]["dy"] into sBall[pB]["dy"]
            put sBall[pB]["py"] into sBall[pB]["y"]
         else
            put -sBall[pB]["dx"] into sBall[pB]["dx"]
            put sBall[pB]["px"] into sBall[pB]["x"]
         end if
         Brick.HitOne r, c
         exit Brick.HitBricks
      end repeat
   end repeat
end Brick.HitBricks

on Brick.HitOne pR, pC
   local tX, tY
   subtract 1 from sCell[pR][pC]["hp"]
   put Brick.CellX(pC) into tX
   put sCfg["cy"] + Brick.CellY(pR) into tY
   if sCell[pR][pC]["hp"] > 0 then
      Entity.SetMesh sCell[pR][pC]["key"], "Brick.Plain"
      FX.Sparks tX, tY, kZ, 3, sRow[pR]
      add sCfg["points"] to sScore
      exit Brick.HitOne
   end if
   Entity.Kill sCell[pR][pC]["key"]
   FX.Sparks tX, tY, kZ, 10, sRow[pR]
   add sCfg["points"] * sLevel to sScore
   subtract 1 from sLeft
   Brick.MaybeDrop tX, tY
end Brick.HitOne

-- a power-up may fall from a broken brick: the first kind whose chance comes up
on Brick.MaybeDrop pX, pY
   local i, n
   repeat with i = 1 to sPowN
      if random(1000) <= sPow[i]["chance"] * 1000 then
         add 1 to sDropSeq
         put sDropSeq into n
         put sPow[i]["kind"] into sDrop[n]["kind"]
         put pX into sDrop[n]["x"]
         put pY - sCfg["cy"] into sDrop[n]["y"]
         put Entity.Spawn("Brick.Drop", pX, pY, kZ, sPow[i]["color"]) into sDrop[n]["key"]
         exit Brick.MaybeDrop
      end if
   end repeat
end Brick.MaybeDrop

on Brick.MoveDrops
   local n, tKeys
   put the keys of sDrop into tKeys
   repeat for each line n in tKeys
      add 2.5 to sDrop[n]["y"]
      if abs(sDrop[n]["y"] - sBat["y"]) < 12 and abs(sDrop[n]["x"] - sBat["x"]) < sBat["half"] + 11 then
         Brick.TakePower sDrop[n]["kind"]
         Entity.Kill sDrop[n]["key"]
         delete variable sDrop[n]
      else if sDrop[n]["y"] > sCfg["hh"] + 20 then
         Entity.Kill sDrop[n]["key"]
         delete variable sDrop[n]
      else
         Entity.SetPosition sDrop[n]["key"], sDrop[n]["x"], sCfg["cy"] + sDrop[n]["y"], kZ
      end if
   end repeat
end Brick.MoveDrops

on Brick.TakePower pKind
   local i, tFrom, tA
   switch pKind
      case "wide"
         put 600 into sWideT
         put sCfg["batHalf"] * 1.6 into sBat["half"]
         Entity.SetMesh sBat["key"], "Brick.BatWide"
         Brick.Say "WIDE BAT", 50
         break
      case "multi"
         put 0 into tFrom
         repeat with i = 1 to sBallN
            if sBall[i]["live"] and sBall[i]["dy"] is not 0 then put i into tFrom
         end repeat
         repeat 2
            if tFrom = 0 or sBallN >= 3 then exit repeat
            Brick.AddBall
            put sBall[tFrom]["x"] into sBall[sBallN]["x"]
            put sBall[tFrom]["y"] into sBall[sBallN]["y"]
            put (random(121) - 61) / 100 into tA
            put sSpeedNow * sin(tA) into sBall[sBallN]["dx"]
            put -sSpeedNow * cos(tA) into sBall[sBallN]["dy"]
         end repeat
         Brick.Say "MORE BALLS", 50
         break
      case "slow"
         put 420 into sSlowT
         Brick.Say "SLOW BALL", 50
         break
      case "life"
         add 1 to sLives
         Brick.Say "EXTRA LIFE", 50
         break
   end switch
   add 25 to sScore
   put empty into sHUDWas
end Brick.TakePower

on Brick.LoseLife
   local n
   subtract 1 from sLives
   repeat for each key n in sDrop
      Entity.Kill sDrop[n]["key"]
   end repeat
   put empty into sDrop
   if sLives <= 0 then
      put true into sOver
      put false into sWonAll
      exit Brick.LoseLife
   end if
   put 0 into sBallN
   put empty into sBall
   if sWideT > 0 then
      put 0 into sWideT
      Entity.SetMesh sBat["key"], "Brick.Bat"
      put sCfg["batHalf"] into sBat["half"]
   end if
   Brick.AddBall
   Brick.Serve
   Brick.Say "BALL LOST", 50
end Brick.LoseLife

on Brick.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Brick.Say

on Brick.ShowHUD
   local tWords
   put sLevel & "|" & sScore & "|" & sLives & "|" & (sServeT > 0) & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Brick.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Brick.Score", sCfg["title"] & "   SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel & "/" & sCfg["levels"], 20, 30, 14
   HUD.Remove "Brick.Msg"
   if sOver and sWonAll then
      HUD.Set "Brick.Msg", "EVERY WALL BROKEN. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Brick.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Brick.Msg", sMsg, 20, 56, 12
   else if sServeT > 0 then
      HUD.Set "Brick.Msg", sCfg["help"], 20, 56, 12
   end if
end Brick.ShowHUD

-- for tests: level|lives|score|bricks left|balls in play|serving|over|first live ball x,y,dx,dy
function Brick.State
   local i, tLive, tBall
   put 0 into tLive
   repeat with i = 1 to sBallN
      if sBall[i]["live"] then
         add 1 to tLive
         if tBall is empty then put round(sBall[i]["x"]) & "," & round(sBall[i]["y"]) & "," & round(sBall[i]["dx"], 2) & "," & round(sBall[i]["dy"], 2) into tBall
      end if
   end repeat
   return sLevel & "|" & sLives & "|" & sScore & "|" & sLeft & "|" & tLive & "|" & (sServeT > 0) & "|" & sOver & "|" & tBall
end Brick.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Brick.Config
   put empty into sCfg
   put empty into sRow
   put empty into sPow
   put "COMFY BRICKS" into sCfg["title"]
   put "ARROWS MOVE  SPACE SERVES" into sCfg["help"]
   put 94106 into sCfg["seed"]
   put 268 into sCfg["hw"]
   put 180 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put "dots" into sCfg["floor"]
   put 38 into sCfg["grid"]
   put "229,187,45" into sCfg["wallColor"]
   put "91,74,18" into sCfg["decoColor"]
   put 6 into sCfg["rows"]
   put 10 into sCfg["cols"]
   put 45.6 into sCfg["bw"]
   put 13 into sCfg["bh"]
   put 49.6 into sCfg["pitchX"]
   put 17 into sCfg["pitchY"]
   put 20 into sCfg["side"]
   put 50 into sCfg["top"]
   put 1 into sCfg["tough"]
   put "checker,checker,frame" into sCfg["patterns"]
   put "arrows" into sCfg["ctrl"]
   put 57 into sCfg["batHalf"]
   put 8.633 into sCfg["batSpeed"]
   put "50,195,255" into sCfg["batColor"]
   put 11 into sCfg["ballSize"]
   put 4.554 into sCfg["ballSpeed"]
   put 1.025 into sCfg["ballGain"]
   put 12.558 into sCfg["ballMax"]
   put "diamond" into sCfg["ballShape"]
   put "204,215,255" into sCfg["ballColor"]
   put 3 into sCfg["lives"]
   put 3 into sCfg["levels"]
   put 0.136 into sCfg["levelGain"]
   put 9 into sCfg["points"]
   put 180 into sCfg["levelBonus"]
   put 120 into sCfg["serveWait"]
   put "101,50,255" into sRow[1]
   put "90,79,255" into sRow[2]
   put "80,108,255" into sRow[3]
   put "70,137,255" into sRow[4]
   put "60,166,255" into sRow[5]
   put "50,195,255" into sRow[6]
   put 3 into sPowN
   put "wide" into sPow[1]["kind"]
   put 0.08 into sPow[1]["chance"]
   put "80,200,255" into sPow[1]["color"]
   put "multi" into sPow[2]["kind"]
   put 0.036 into sPow[2]["chance"]
   put "255,220,60" into sPow[2]["color"]
   put "multi" into sPow[3]["kind"]
   put 0.046 into sPow[3]["chance"]
   put "255,220,60" into sPow[3]["color"]
end Brick.Config
