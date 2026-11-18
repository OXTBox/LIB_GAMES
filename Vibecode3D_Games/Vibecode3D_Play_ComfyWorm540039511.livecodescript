######################################################################################
## CARD SCRIPT: "Play.ComfyWorm540039511"   COMFY WORM  (made in ComfyUI, seed 540039511)
## A grid worm put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## Board 27 x 15 (wrapping edges, 6 box blocks). Food: plain x2, gold x1, plain x1.
## CONTROLS  Arrows Turn   Escape: stop
## RULES     eat 11 to clear level 1 (5 more each level); 3 levels, 3 lives. Your own body, a block
##            ends a life.
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

## PART core (CCOIL): a grid worm. The worm moves one cell every few steps; food makes it longer;
## its own body, the obstacles and (unless the edges wrap) the walls end a life. Eat enough to
## clear the level. Food kinds come from the Food nodes. The builder adds Coil.Config.

global bPaused, bPlaying

local sCfg, sFood, sFoodN
local sOcc, sBody, sKeys, sDir, sNextDir, sWait, sGrow, sStepNow, sSlowT, sEaten, sOnBoard, sSeq
local sLevel, sLives, sScore, sOver, sWonAll, sHUDWas, sTick, sMsg, sMsgT, sAuto, sDeadT

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Coil.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put false into sOver
   Coil.StartLevel 1
end Game.OnStart

function Coil.X pC
   return (pC - (sCfg["cols"] + 1) / 2) * sCfg["cell"]
end Coil.X

function Coil.Y pR
   return (pR - (sCfg["rows"] + 1) / 2) * sCfg["cell"]
end Coil.Y

on Coil.StartLevel pLevel
   local tM, tHW, tHH, k, i, tCell
   put pLevel into sLevel
   Scene.ClearAll
   Particles.Clear
   put empty into sOcc
   put empty into sOnBoard
   put 0 into sEaten
   put 0 into sSlowT
   put max(sCfg["minStep"], sCfg["stepFrames"] - sCfg["levelGain"] * (pLevel - 1)) into sStepNow
   put sCfg["cols"] * sCfg["cell"] / 2 into tHW
   put sCfg["rows"] * sCfg["cell"] / 2 into tHH
   put Mesh.New() into tM
   Vec.Decor tM, sCfg["floor"], tHW, tHH, sCfg["cell"]
   if tM["count"] > 0 then
      Mesh.Define "Coil.Floor", tM
      get Entity.Spawn("Coil.Floor", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   put Mesh.New() into tM
   Vec.Rect tM, -tHW, -tHH, tHW, tHH
   if sCfg["wrap"] then
      -- open edges: gaps in the middle of each side show the way through
      put Mesh.New() into tM
      Vec.Line tM, -tHW, -tHH, -tHW * 0.3, -tHH
      Vec.Line tM, tHW * 0.3, -tHH, tHW, -tHH
      Vec.Line tM, -tHW, tHH, -tHW * 0.3, tHH
      Vec.Line tM, tHW * 0.3, tHH, tHW, tHH
      Vec.Line tM, -tHW, -tHH, -tHW, -tHH * 0.3
      Vec.Line tM, -tHW, tHH * 0.3, -tHW, tHH
      Vec.Line tM, tHW, -tHH, tHW, -tHH * 0.3
      Vec.Line tM, tHW, tHH * 0.3, tHW, tHH
   end if
   Mesh.Define "Coil.Walls", tM
   get Entity.Spawn("Coil.Walls", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   put sCfg["cell"] - 3 into tCell
   put Mesh.New() into tM
   Vec.Rect tM, -tCell / 2, -tCell / 2, tCell / 2, tCell / 2
   Mesh.Define "Coil.Seg", tM
   Mesh.Define "Coil.Head", Vec.Shape(sCfg["headShape"], tCell + 2)
   put Mesh.New() into tM
   Vec.Rect tM, -tCell / 2, -tCell / 2, tCell / 2, tCell / 2
   Vec.Line tM, -tCell / 2, -tCell / 2, tCell / 2, tCell / 2
   Vec.Line tM, -tCell / 2, tCell / 2, tCell / 2, -tCell / 2
   Mesh.Define "Coil.Block", tM
   repeat with k = 1 to sFoodN
      Mesh.Define "Coil.Food" & k, Vec.Shape(sFood[k]["shape"], tCell)
   end repeat
   Coil.Obstacles
   Coil.PlaceWorm
   repeat with k = 1 to sFoodN
      repeat sFood[k]["count"]
         Coil.AddFood k
      end repeat
   end repeat
   Coil.Say "LEVEL" && pLevel & ": EAT" && Coil.Target(), 70
end Coil.StartLevel

function Coil.Target
   return sCfg["target"] + sCfg["targetGain"] * (sLevel - 1)
end Coil.Target

-- blocks on the board, more each level; never on the worm's start row
on Coil.Obstacles
   local n, c, r, tTries, tMid, i
   set the randomSeed to sCfg["seed"] + sLevel
   put sCfg["blocks"] + sCfg["blocksGain"] * (sLevel - 1) into n
   put round((sCfg["rows"] + 1) / 2) into tMid
   switch sCfg["blockStyle"]
      case "bars"
         repeat with i = 1 to min(n, sCfg["rows"] div 4)
            put i * 4 - 1 into r
            if r = tMid then next repeat
            repeat with c = 3 + (i mod 2) * 3 to sCfg["cols"] - 3 - ((i + 1) mod 2) * 3
               Coil.Block c, r
            end repeat
         end repeat
         break
      case "box"
         if n > 0 then
            repeat with c = 4 to sCfg["cols"] - 3
               if abs(c - (sCfg["cols"] + 1) / 2) < 2 then next repeat
               Coil.Block c, 3
               Coil.Block c, sCfg["rows"] - 2
            end repeat
            repeat with r = 4 to sCfg["rows"] - 3
               if abs(r - tMid) < 2 then next repeat
               Coil.Block 3, r
               Coil.Block sCfg["cols"] - 2, r
            end repeat
         end if
         break
      default
         repeat n
            put 0 into tTries
            repeat until tTries > 50
               add 1 to tTries
               put random(sCfg["cols"]) into c
               put random(sCfg["rows"]) into r
               if r = tMid or sOcc[c & "," & r] is not empty then next repeat
               Coil.Block c, r
               exit repeat
            end repeat
         end repeat
   end switch
end Coil.Obstacles

on Coil.Block pC, pR
   if pC < 1 or pR < 1 or pC > sCfg["cols"] or pR > sCfg["rows"] then exit Coil.Block
   if sOcc[pC & "," & pR] is not empty then exit Coil.Block
   put "x" into sOcc[pC & "," & pR]
   get Entity.Spawn("Coil.Block", Coil.X(pC), sCfg["cy"] + Coil.Y(pR), kZ, sCfg["blockColor"])
end Coil.Block

-- the worm starts in the middle row heading right, its tail to the left
on Coil.PlaceWorm
   local i, c, r, tKey
   put empty into sBody
   put empty into sKeys
   put round((sCfg["rows"] + 1) / 2) into r
   put max(sCfg["length"] + 1, round(sCfg["cols"] / 3)) into c
   repeat with i = 0 to sCfg["length"] - 1
      if sOcc[(c - i) & "," & r] is "x" then exit repeat
      put (c - i) & "," & r & cr after sBody
      if i = 0 then
         put Entity.Spawn("Coil.Head", Coil.X(c - i), sCfg["cy"] + Coil.Y(r), kZ, sCfg["wormColor"]) into tKey
      else
         put Entity.Spawn("Coil.Seg", Coil.X(c - i), sCfg["cy"] + Coil.Y(r), kZ, sCfg["wormColor"]) into tKey
      end if
      put tKey & cr after sKeys
      put "w" into sOcc[(c - i) & "," & r]
   end repeat
   delete the last char of sBody
   delete the last char of sKeys
   put "1,0" into sDir
   put "1,0" into sNextDir
   put 0 into sGrow
   put sStepNow into sWait
   Coil.TurnHead
end Coil.PlaceWorm

on Coil.AddFood pK
   local c, r, tTries
   repeat with tTries = 1 to 200
      put random(sCfg["cols"]) into c
      put random(sCfg["rows"]) into r
      if sOcc[c & "," & r] is empty then exit repeat
   end repeat
   if sOcc[c & "," & r] is not empty then exit Coil.AddFood
   add 1 to sSeq
   put "f" & sSeq into sOcc[c & "," & r]
   put pK into sOnBoard[sSeq]["kind"]
   put c & "," & r into sOnBoard[sSeq]["at"]
   put sFood[pK]["life"] into sOnBoard[sSeq]["life"]
   put Entity.Spawn("Coil.Food" & pK, Coil.X(c), sCfg["cy"] + Coil.Y(r), kZ, sFood[pK]["color"]) into sOnBoard[sSeq]["key"]
   if sFood[pK]["kind"] is "gold" then Entity.SetRotationSpeed sOnBoard[sSeq]["key"], 0, 0, 0.08
end Coil.AddFood

on Game.OnUpdate
   local tKeys, tD
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put false into sOver
         Coil.StartLevel 1
      end if
      Coil.ShowHUD
      exit Game.OnUpdate
   end if
   if sDeadT > 0 then
      subtract 1 from sDeadT
      if sDeadT = 0 then
         Coil.StartLevel sLevel
      end if
      Coil.ShowHUD
      exit Game.OnUpdate
   end if
   -- the next turn: never straight back
   if sAuto is true then
      put Coil.AutoDir() into tD
   else
      put Vec.Dir(sCfg["ctrl"], tKeys) into tD
      if item 1 of tD is not 0 and item 2 of tD is not 0 then put 0 into item 2 of tD
   end if
   if tD is not "0,0" and (item 1 of tD is not -item 1 of sDir or item 2 of tD is not -item 2 of sDir) then put tD into sNextDir
   Coil.FoodClock
   if sSlowT > 0 then subtract 1 from sSlowT
   subtract 1 from sWait
   if sWait <= 0 then
      put sStepNow into sWait
      if sSlowT > 0 then add 3 to sWait
      Coil.Step
   end if
   if sMsgT > 0 then subtract 1 from sMsgT
   Coil.ShowHUD
end Game.OnUpdate

-- the worm moves one cell
on Coil.Step
   local tHead, c, r, tWhat, tTail, tKey
   put sNextDir into sDir
   put line 1 of sBody into tHead
   put item 1 of tHead + item 1 of sDir into c
   put item 2 of tHead + item 2 of sDir into r
   if sCfg["wrap"] then
      put Coil.Wrap(c, sCfg["cols"]) into c
      put Coil.Wrap(r, sCfg["rows"]) into r
   else if c < 1 or r < 1 or c > sCfg["cols"] or r > sCfg["rows"] then
      Coil.Die
      exit Coil.Step
   end if
   put sOcc[c & "," & r] into tWhat
   -- the tail leaves its cell this step unless the worm is growing
   put the last line of sBody into tTail
   if tWhat is "x" or (tWhat is "w" and (c & "," & r is not tTail or sGrow > 0)) then
      Coil.Die
      exit Coil.Step
   end if
   if char 1 of tWhat is "f" then Coil.Eat char 2 to -1 of tWhat
   -- the old head becomes a body segment
   Entity.SetMesh line 1 of sKeys, "Coil.Seg"
   if sGrow > 0 then
      subtract 1 from sGrow
      put Entity.Spawn("Coil.Head", Coil.X(c), sCfg["cy"] + Coil.Y(r), kZ, sCfg["wormColor"]) into tKey
      put c & "," & r & cr before sBody
      put tKey & cr before sKeys
   else
      -- the tail's entity becomes the new head
      put the last line of sKeys into tKey
      if sOcc[tTail] is "w" then put empty into sOcc[tTail]
      delete the last line of sBody
      delete the last line of sKeys
      Entity.SetMesh tKey, "Coil.Head"
      Entity.SetPosition tKey, Coil.X(c), sCfg["cy"] + Coil.Y(r), kZ
      put c & "," & r & cr before sBody
      put tKey & cr before sKeys
   end if
   if the last char of sBody is cr then delete the last char of sBody
   if the last char of sKeys is cr then delete the last char of sKeys
   put "w" into sOcc[c & "," & r]
   Coil.TurnHead
   if sEaten >= Coil.Target() then Coil.LevelDone
end Coil.Step

-- the head points the way it goes. (One colour for the whole worm: an entity keeps the colour it
-- was spawned with, and the tail's entity is reused as the new head; the head shows by its shape.)
on Coil.TurnHead
   local tA
   switch sDir
      case "1,0"
         put pi / 2 into tA
         break
      case "-1,0"
         put -pi / 2 into tA
         break
      case "0,1"
         put pi into tA
         break
      default
         put 0 into tA
   end switch
   Entity.SetRotation line 1 of sKeys, 0, 0, tA
end Coil.TurnHead

on Coil.Eat pSeq
   local k, tAt
   put sOnBoard[pSeq]["kind"] into k
   put sOnBoard[pSeq]["at"] into tAt
   Entity.Kill sOnBoard[pSeq]["key"]
   delete variable sOnBoard[pSeq]
   put empty into sOcc[tAt]
   FX.Sparks Coil.X(item 1 of tAt), sCfg["cy"] + Coil.Y(item 2 of tAt), kZ, 8, sFood[k]["color"]
   add sFood[k]["points"] * sLevel to sScore
   add 1 to sEaten
   switch sFood[k]["kind"]
      case "shrink"
         Coil.Shrink 2
         break
      case "slow"
         put 240 into sSlowT
         add sFood[k]["grow"] to sGrow
         break
      default
         add sFood[k]["grow"] to sGrow
   end switch
   if sCfg["speedUp"] > 0 then put max(sCfg["minStep"], sStepNow - sCfg["speedUp"]) into sStepNow
   Coil.AddFood k
   put empty into sHUDWas
end Coil.Eat

on Coil.Shrink pN
   local tCell
   repeat pN
      if the number of lines of sBody <= 2 then exit repeat
      put the last line of sBody into tCell
      put empty into sOcc[tCell]
      Entity.Kill the last line of sKeys
      delete the last line of sBody
      delete the last line of sKeys
   end repeat
end Coil.Shrink

-- gold food does not wait: it moves elsewhere when its time is up
on Coil.FoodClock
   local tSeq, tSeqs, k
   put the keys of sOnBoard into tSeqs
   repeat for each line tSeq in tSeqs
      if sOnBoard[tSeq]["life"] is not a number or sOnBoard[tSeq]["life"] <= 0 then next repeat
      subtract 1 from sOnBoard[tSeq]["life"]
      if sOnBoard[tSeq]["life"] <= 0 then
         put sOnBoard[tSeq]["kind"] into k
         Entity.Kill sOnBoard[tSeq]["key"]
         put empty into sOcc[sOnBoard[tSeq]["at"]]
         delete variable sOnBoard[tSeq]
         Coil.AddFood k
      end if
   end repeat
end Coil.FoodClock

on Coil.Die
   FX.Sparks Coil.X(item 1 of line 1 of sBody), sCfg["cy"] + Coil.Y(item 2 of line 1 of sBody), kZ, 25, sCfg["wormColor"]
   Sound.Play "boom"
   subtract 1 from sLives
   if sLives <= 0 then
      put true into sOver
      put false into sWonAll
      put empty into sHUDWas
      exit Coil.Die
   end if
   put 45 into sDeadT
   Coil.Say "OUCH", 45
end Coil.Die

on Coil.LevelDone
   add 50 * sLevel to sScore
   if sLevel >= sCfg["levels"] then
      put true into sOver
      put true into sWonAll
      put empty into sHUDWas
      exit Coil.LevelDone
   end if
   Coil.StartLevel sLevel + 1
end Coil.LevelDone

-- tests and the demo: the first step of a shortest way to the nearest food (not shrinking food),
-- found breadth first; with no way to any, a step into the most open neighbour
function Coil.AutoDir
   local tHead, tQ, tHeadQ, tTailQ, tFrom, tCell, tD, c, r, tNext, tSeq, tGoal, tStep, tBest, tRoom, tMost
   put line 1 of sBody into tHead
   repeat for each key tSeq in sOnBoard
      if sFood[sOnBoard[tSeq]["kind"]]["kind"] is not "shrink" then put true into tGoal[sOnBoard[tSeq]["at"]]
   end repeat
   put 1 into tHeadQ
   put 1 into tTailQ
   put tHead into tQ[1]
   put "start" into tFrom[tHead]
   repeat while tHeadQ <= tTailQ
      put tQ[tHeadQ] into tCell
      add 1 to tHeadQ
      if tGoal[tCell] is true then
         -- walk back to the cell next to the head
         repeat while tFrom[tCell] is not tHead and tFrom[tCell] is not "start"
            put tFrom[tCell] into tCell
         end repeat
         return Coil.DirTo(tHead, tCell)
      end if
      repeat for each line tD in ("1,0" & cr & "-1,0" & cr & "0,1" & cr & "0,-1")
         put Coil.Wrap(item 1 of tCell + item 1 of tD, sCfg["cols"]) into c
         put Coil.Wrap(item 2 of tCell + item 2 of tD, sCfg["rows"]) into r
         if not sCfg["wrap"] and (item 1 of tCell + item 1 of tD is not c or item 2 of tCell + item 2 of tD is not r) then next repeat
         put c & "," & r into tNext
         if tFrom[tNext] is not empty then next repeat
         if not Coil.Free(c, r) then next repeat
         if tCell is tHead and item 1 of tD = -item 1 of sDir and item 2 of tD = -item 2 of sDir then next repeat
         put tCell into tFrom[tNext]
         add 1 to tTailQ
         put tNext into tQ[tTailQ]
      end repeat
   end repeat
   -- no way to food: the free neighbour with the most free cells around it
   put -1 into tMost
   repeat for each line tD in ("1,0" & cr & "-1,0" & cr & "0,1" & cr & "0,-1")
      if item 1 of tD = -item 1 of sDir and item 2 of tD = -item 2 of sDir then next repeat
      put Coil.Wrap(item 1 of tHead + item 1 of tD, sCfg["cols"]) into c
      put Coil.Wrap(item 2 of tHead + item 2 of tD, sCfg["rows"]) into r
      if not Coil.Free(c, r) then next repeat
      put 0 into tRoom
      repeat for each line tStep in ("1,0" & cr & "-1,0" & cr & "0,1" & cr & "0,-1")
         if Coil.Free(c + item 1 of tStep, r + item 2 of tStep) then add 1 to tRoom
      end repeat
      if tRoom > tMost then
         put tRoom into tMost
         put tD into tBest
      end if
   end repeat
   if tBest is empty then return sDir
   return tBest
end Coil.AutoDir

-- the heading from cell pA to the next cell pB (wrapping counts)
function Coil.DirTo pA, pB
   local dx, dy
   put item 1 of pB - item 1 of pA into dx
   put item 2 of pB - item 2 of pA into dy
   if dx > 1 then put -1 into dx
   if dx < -1 then put 1 into dx
   if dy > 1 then put -1 into dy
   if dy < -1 then put 1 into dy
   return dx & "," & dy
end Coil.DirTo

-- a cell number past an edge comes back in on the other side
function Coil.Wrap pN, pMax
   if pN < 1 then return pMax
   if pN > pMax then return 1
   return pN
end Coil.Wrap

function Coil.Free pC, pR
   if pC < 1 or pR < 1 or pC > sCfg["cols"] or pR > sCfg["rows"] then return sCfg["wrap"]
   return sOcc[pC & "," & pR] is empty or char 1 of sOcc[pC & "," & pR] is "f"
end Coil.Free

on Coil.TestAuto pOn
   put pOn into sAuto
end Coil.TestAuto

on Coil.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Coil.Say

on Coil.ShowHUD
   local tWords
   put sLevel & "|" & sScore & "|" & sLives & "|" & sEaten & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Coil.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Coil.Score", sCfg["title"] & "   SCORE" && sScore && "  LIVES" && sLives && "  EATEN" && sEaten & "/" & Coil.Target() && "  LEVEL" && sLevel & "/" & sCfg["levels"], 20, 30, 14
   HUD.Remove "Coil.Msg"
   if sOver and sWonAll then
      HUD.Set "Coil.Msg", "EVERY LEVEL EATEN. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Coil.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Coil.Msg", sMsg & "    " & sCfg["help"], 20, 56, 12
   end if
end Coil.ShowHUD

-- for tests: level|lives|score|eaten|length|over|head cell|heading|steps to the next move|food cells
function Coil.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sEaten & "|" & the number of lines of sBody & "|" & sOver & "|" & line 1 of sBody & "|" & sDir & "|" & sWait & "|" & Coil.FoodList()
end Coil.State

-- for tests: where the food is, "c,r" a word
function Coil.FoodList
   local tSeq, tOut
   repeat for each key tSeq in sOnBoard
      put sOnBoard[tSeq]["at"] & " " after tOut
   end repeat
   return word 1 to -1 of tOut
end Coil.FoodList

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Coil.Config
   put empty into sCfg
   put empty into sFood
   put "COMFY WORM" into sCfg["title"]
   put "ARROWS TURN" into sCfg["help"]
   put 39512 into sCfg["seed"]
   put 40 into sCfg["cy"]
   put 27 into sCfg["cols"]
   put 15 into sCfg["rows"]
   put 19 into sCfg["cell"]
   put true into sCfg["wrap"]
   put 6 into sCfg["blocks"]
   put "box" into sCfg["blockStyle"]
   put "grid" into sCfg["floor"]
   put "229,145,68" into sCfg["wallColor"]
   put "80,50,23" into sCfg["decoColor"]
   put "89,26,26" into sCfg["blockColor"]
   put "arrows" into sCfg["ctrl"]
   put 4 into sCfg["length"]
   put 5 into sCfg["stepFrames"]
   put 0.086 into sCfg["speedUp"]
   put 2 into sCfg["minStep"]
   put "tri" into sCfg["headShape"]
   put "255,222,50" into sCfg["wormColor"]
   put 3 into sCfg["lives"]
   put 3 into sCfg["levels"]
   put 11 into sCfg["target"]
   put 5 into sCfg["targetGain"]
   put 4 into sCfg["blocksGain"]
   put 1 into sCfg["levelGain"]
   put 3 into sFoodN
   put "plain" into sFood[1]["kind"]
   put 2 into sFood[1]["count"]
   put 8 into sFood[1]["points"]
   put 1 into sFood[1]["grow"]
   put 0 into sFood[1]["life"]
   put "diamond" into sFood[1]["shape"]
   put "255,240,200" into sFood[1]["color"]
   put "gold" into sFood[2]["kind"]
   put 1 into sFood[2]["count"]
   put 57 into sFood[2]["points"]
   put 3 into sFood[2]["grow"]
   put 276 into sFood[2]["life"]
   put "star" into sFood[2]["shape"]
   put "255,222,50" into sFood[2]["color"]
   put "plain" into sFood[3]["kind"]
   put 1 into sFood[3]["count"]
   put 22 into sFood[3]["points"]
   put 1 into sFood[3]["grow"]
   put 0 into sFood[3]["life"]
   put "ring" into sFood[3]["shape"]
   put "255,240,200" into sFood[3]["color"]
end Coil.Config
