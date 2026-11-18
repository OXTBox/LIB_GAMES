######################################################################################
## CARD SCRIPT: "Play.ComfyLander802252756"   COMFY LANDER  (made in ComfyUI, seed 802252756)
## A lander put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## A rotate craft, 909 fuel; ground of 26 segments with 3 pads; pull 0.031, 36% stronger each level.
## CONTROLS  Arrows: Up Burns, Left Right Turn   Escape: stop
## RULES     land on a pad, upright, slower than 1.5 down: narrow pads score up to three times.
##           3 levels, 3 craft; leftover fuel is points.
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

## PART core (CLAND): a lander. Gravity pulls you down onto rough ground; thrust burns fuel. Set
## down on a flat pad, slowly and upright, for points (narrow pads are worth more); anywhere else,
## or too fast, is a crash. Each level: new ground, stronger pull. The builder adds Lander.Config.

global bPaused, bPlaying

local sCfg, sGround, sGroundN, sPad, sPadN
local sMe, sFlameKey, sFuel, sGrav, sWind, sLanded, sWaitT
local sLevel, sLives, sScore, sOver, sWonAll, sHUDWas, sTick, sMsg, sMsgT, sAuto, sAutoPad

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Lander.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put false into sOver
   Lander.StartLevel 1
end Game.OnStart

on Lander.StartLevel pLevel
   local tM
   put pLevel into sLevel
   Scene.ClearAll
   Particles.Clear
   put sCfg["gravity"] * (1 + sCfg["levelGain"] * (pLevel - 1)) into sGrav
   put sCfg["wind"] * (pLevel - 1) / max(1, sCfg["levels"] - 1) into sWind
   put Mesh.New() into tM
   Vec.Decor tM, sCfg["floor"], sCfg["hw"], sCfg["hh"], sCfg["grid"]
   if tM["count"] > 0 then
      Mesh.Define "Lander.Sky", tM
      get Entity.Spawn("Lander.Sky", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   Lander.MakeGround
   Mesh.Define "Lander.Me", Lander.CraftMesh()
   put Mesh.New() into tM
   Vec.Outline tM, -sCfg["size"] * 0.2 & "," & sCfg["size"] * 0.45 & cr & "0," & sCfg["size"] * 1.1 & cr & sCfg["size"] * 0.2 & "," & sCfg["size"] * 0.45
   Mesh.Define "Lander.Flame", tM
   Lander.NewCraft
   Lander.Say "LEVEL" && pLevel & ": LAND ON A PAD", 80
end Lander.StartLevel

-- a craft: a box of a cabin on two legs, pointing up
function Lander.CraftMesh
   local tM, s
   put Mesh.New() into tM
   put sCfg["size"] / 2 into s
   Vec.Rect tM, -s * 0.6, -s * 0.8, s * 0.6, s * 0.2
   Vec.Line tM, -s * 0.6, s * 0.2, -s, s
   Vec.Line tM, s * 0.6, s * 0.2, s, s
   Vec.Line tM, -s * 1.2, s, -s * 0.8, s
   Vec.Line tM, s * 0.8, s, s * 1.2, s
   Vec.Line tM, 0, -s * 0.8, 0, -s * 1.1
   return tM
end Lander.CraftMesh

-- the ground: a walk of points across the arena with flat pads in it, 1 to 3 segments wide;
-- a narrow pad is worth more (times 3, 2 or 1)
on Lander.MakeGround
   local i, tN, tX, tY, tM, tPadM, tStep, k, tLow, tHigh, tStart, tSpan, tFlat, tTries, j, tFree
   set the randomSeed to sCfg["seed"] + sLevel * 101
   put empty into sGround
   put empty into sPad
   put empty into tFlat
   put sCfg["segments"] into tN
   put sCfg["hw"] * 2 / tN into tStep
   put sCfg["hh"] - 10 into tLow
   put sCfg["hh"] - sCfg["hills"] into tHigh
   put 0 into sPadN
   -- where the pads go: a start segment and a span, never touching another pad
   repeat with k = 1 to sCfg["pads"]
      repeat with tTries = 1 to 30
         put random(3) into tSpan
         put random(tN - tSpan - 1) + 1 into tStart
         put true into tFree
         repeat with j = tStart - 1 to tStart + tSpan
            if tFlat[j] is not empty then put false into tFree
         end repeat
         if tFree then exit repeat
      end repeat
      if not tFree then next repeat
      add 1 to sPadN
      repeat with j = tStart to tStart + tSpan - 1
         put sPadN into tFlat[j]
      end repeat
      put 4 - tSpan into sPad[sPadN]["times"]
   end repeat
   put Mesh.New() into tM
   put Mesh.New() into tPadM
   put -sCfg["hw"] into sGround[0]["x"]
   put tLow - random(max(1, round(tLow - tHigh))) into sGround[0]["y"]
   repeat with i = 1 to tN
      put -sCfg["hw"] + i * tStep into tX
      if tFlat[i] is not empty then
         put sGround[i - 1]["y"] into tY
         put tFlat[i] into k
         if sPad[k]["x1"] is empty then put sGround[i - 1]["x"] into sPad[k]["x1"]
         put tX into sPad[k]["x2"]
         put tY into sPad[k]["y"]
         Vec.Line tPadM, sGround[i - 1]["x"], tY, tX, tY
         Vec.Line tPadM, sGround[i - 1]["x"], tY + 3, tX, tY + 3
      else
         put Vec.Clamp(sGround[i - 1]["y"] + (random(201) - 101) / 100 * sCfg["rough"] * tStep, tHigh, tLow) into tY
         Vec.Line tM, sGround[i - 1]["x"], sGround[i - 1]["y"], tX, tY
      end if
      put tX into sGround[i]["x"]
      put tY into sGround[i]["y"]
   end repeat
   put tN into sGroundN
   Mesh.Define "Lander.Ground", tM
   get Entity.Spawn("Lander.Ground", 0, sCfg["cy"], kZ, sCfg["groundColor"])
   Mesh.Define "Lander.Pads", tPadM
   get Entity.Spawn("Lander.Pads", 0, sCfg["cy"], kZ, sCfg["padColor"])
end Lander.MakeGround

-- the ground's height under x (straight lines between the points)
function Lander.GroundY pX
   local i, tF
   repeat with i = 1 to sGroundN
      if pX <= sGround[i]["x"] then
         put (pX - sGround[i - 1]["x"]) / (sGround[i]["x"] - sGround[i - 1]["x"]) into tF
         return sGround[i - 1]["y"] + tF * (sGround[i]["y"] - sGround[i - 1]["y"])
      end if
   end repeat
   return sGround[sGroundN]["y"]
end Lander.GroundY

on Lander.NewCraft
   put (random(2001) - 1001) / 1000 * sCfg["hw"] * 0.6 into sMe["x"]
   put -sCfg["hh"] + 30 into sMe["y"]
   put sCfg["startVX"] * (random(3) - 2) into sMe["vx"]
   put 0 into sMe["vy"]
   put 0 into sMe["a"]
   put sCfg["fuel"] into sFuel
   put false into sLanded
   put 0 into sWaitT
   put empty into sAutoPad
   put Entity.Spawn("Lander.Me", sMe["x"], sCfg["cy"] + sMe["y"], kZ, sCfg["craftColor"]) into sMe["key"]
   put empty into sFlameKey
end Lander.NewCraft

on Game.OnUpdate
   local tKeys, tThrust, tTurn, tSide
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put false into sOver
         Lander.StartLevel 1
      end if
      Lander.ShowHUD
      exit Game.OnUpdate
   end if
   if sWaitT > 0 then
      subtract 1 from sWaitT
      if sWaitT = 0 then Lander.AfterWait
      Lander.ShowHUD
      exit Game.OnUpdate
   end if
   put 0 into tThrust
   put 0 into tTurn
   put 0 into tSide
   if sAuto is true then
      Lander.Autopilot tThrust, tTurn, tSide
   else
      -- up (or the fire key) burns; left and right turn the craft, or push it sideways
      if item 2 of Vec.Dir(sCfg["ctrl"], tKeys) < 0 or Vec.Fire(sCfg["ctrl"], tKeys) then put 1 into tThrust
      put item 1 of Vec.Dir(sCfg["ctrl"], tKeys) into tSide
      if sCfg["mode"] is "rotate" then
         put tSide into tTurn
         put 0 into tSide
      end if
   end if
   Lander.Fly tThrust, tTurn, tSide
   if sMsgT > 0 then subtract 1 from sMsgT
   Lander.ShowHUD
end Game.OnUpdate

on Lander.Fly pThrust, pTurn, pSide
   local tGround, tPad, k, tFoot
   if sFuel <= 0 then
      put 0 into pThrust
      put 0 into pSide
   end if
   add pTurn * sCfg["turn"] to sMe["a"]
   put Vec.Clamp(sMe["a"], -1.4, 1.4) into sMe["a"]
   if pThrust > 0 then
      add sin(sMe["a"]) * sCfg["thrust"] to sMe["vx"]
      subtract cos(sMe["a"]) * sCfg["thrust"] from sMe["vy"]
      subtract 1 from sFuel
   end if
   if pSide is not 0 then
      add pSide * sCfg["thrust"] * 0.5 to sMe["vx"]
      subtract 0.5 from sFuel
   end if
   add sGrav to sMe["vy"]
   add sWind to sMe["vx"]
   add sMe["vx"] to sMe["x"]
   add sMe["vy"] to sMe["y"]
   -- the sides: a wall of air pushes you back
   if abs(sMe["x"]) > sCfg["hw"] - sCfg["size"] then
      put Vec.Clamp(sMe["x"], -sCfg["hw"] + sCfg["size"], sCfg["hw"] - sCfg["size"]) into sMe["x"]
      put -sMe["vx"] * 0.3 into sMe["vx"]
   end if
   if sMe["y"] < -sCfg["hh"] + 10 then
      put -sCfg["hh"] + 10 into sMe["y"]
      put max(0, sMe["vy"]) into sMe["vy"]
   end if
   Entity.SetPosition sMe["key"], sMe["x"], sCfg["cy"] + sMe["y"], kZ
   Entity.SetRotation sMe["key"], 0, 0, sMe["a"]
   Lander.Flame pThrust > 0 or pSide is not 0
   -- the feet touch the ground?
   put sMe["y"] + sCfg["size"] / 2 into tFoot
   put Lander.GroundY(sMe["x"]) into tGround
   if tFoot < tGround then exit Lander.Fly
   put 0 into tPad
   -- on a pad: the middle of the craft over it, the legs may overhang a little
   repeat with k = 1 to sPadN
      if sMe["x"] - sCfg["size"] * 0.2 >= sPad[k]["x1"] and sMe["x"] + sCfg["size"] * 0.2 <= sPad[k]["x2"] then put k into tPad
   end repeat
   if tPad > 0 and sMe["vy"] <= sCfg["safe"] and abs(sMe["vx"]) <= sCfg["safe"] * 0.7 and abs(sMe["a"]) <= 0.25 then
      Lander.Landed tPad
   else
      Lander.Crash
   end if
end Lander.Fly

on Lander.Flame pOn
   if pOn then
      if sFlameKey is empty then put Entity.Spawn("Lander.Flame", sMe["x"], sCfg["cy"] + sMe["y"], kZ, sCfg["flameColor"]) into sFlameKey
      Entity.SetPosition sFlameKey, sMe["x"], sCfg["cy"] + sMe["y"], kZ
      Entity.SetRotation sFlameKey, 0, 0, sMe["a"]
   else if sFlameKey is not empty then
      Entity.Kill sFlameKey
      put empty into sFlameKey
   end if
end Lander.Flame

on Lander.Landed pPad
   local tGot
   Lander.Flame false
   put sPad[pPad]["y"] - sCfg["size"] / 2 into sMe["y"]
   put 0 into sMe["a"]
   Entity.SetPosition sMe["key"], sMe["x"], sCfg["cy"] + sMe["y"], kZ
   Entity.SetRotation sMe["key"], 0, 0, 0
   put sCfg["points"] * sPad[pPad]["times"] + round(sFuel) into tGot
   add tGot to sScore
   FX.Sparks sMe["x"], sCfg["cy"] + sPad[pPad]["y"], kZ, 12, sCfg["padColor"]
   put true into sLanded
   put 90 into sWaitT
   Lander.Say "LANDED. PAD X" & sPad[pPad]["times"] & ": +" & tGot, 90
end Lander.Landed

on Lander.Crash
   Lander.Flame false
   FX.Sparks sMe["x"], sCfg["cy"] + sMe["y"], kZ, 30, sCfg["craftColor"]
   Sound.Play "boom"
   Entity.Kill sMe["key"]
   subtract 1 from sLives
   put false into sLanded
   put 70 into sWaitT
   Lander.Say "CRASHED", 70
end Lander.Crash

on Lander.AfterWait
   if sLanded then
      if sLevel >= sCfg["levels"] then
         put true into sOver
         put true into sWonAll
         put empty into sHUDWas
      else
         Lander.StartLevel sLevel + 1
      end if
      exit Lander.AfterWait
   end if
   if sLives <= 0 then
      put true into sOver
      put false into sWonAll
      put empty into sHUDWas
      exit Lander.AfterWait
   end if
   Lander.NewCraft
end Lander.AfterWait

-- tests and the demo: pick the nearest pad, get over it, come down gently
on Lander.Autopilot @pThrust, @pTurn, @pSide
   local k, tBest, tD, tMid, dx, tWantVX, tWantVY, tAboveY, tAx, tWantA
   if sAutoPad is empty then
      put 99999 into tBest
      repeat with k = 1 to sPadN
         put abs((sPad[k]["x1"] + sPad[k]["x2"]) / 2 - sMe["x"]) into tD
         if tD < tBest then
            put tD into tBest
            put k into sAutoPad
         end if
      end repeat
   end if
   put (sPad[sAutoPad]["x1"] + sPad[sAutoPad]["x2"]) / 2 into tMid
   put tMid - sMe["x"] into dx
   put Vec.Clamp(dx / 40, -2, 2) into tWantVX
   put sPad[sAutoPad]["y"] - sCfg["size"] / 2 - sMe["y"] into tAboveY
   -- fall fast when high, slowly when low, hold height while not yet over the pad
   put Vec.Clamp(tAboveY / 60, 0.3, 2.5) into tWantVY
   if abs(dx) > (sPad[sAutoPad]["x2"] - sPad[sAutoPad]["x1"]) / 3 and tAboveY < 80 then put 0 into tWantVY
   put min(tWantVY, sCfg["safe"] * 0.6) into tWantVY
   if tAboveY > 60 then put Vec.Clamp(tAboveY / 60, 0.3, 2.5) into tWantVY
   if sCfg["mode"] is "rotate" then
      put Vec.Clamp((tWantVX - sMe["vx"]) * 0.6, -0.5, 0.5) into tWantA
      if tAboveY < 25 then put 0 into tWantA
      if sMe["a"] < tWantA - 0.03 then put 1 into pTurn
      if sMe["a"] > tWantA + 0.03 then put -1 into pTurn
      if sMe["vy"] > tWantVY or (abs(tWantA) > 0.2 and sMe["vy"] > tWantVY - 0.5) then put 1 into pThrust
      exit Lander.Autopilot
   end if
   if sMe["vx"] < tWantVX - 0.2 then put 1 into pSide
   if sMe["vx"] > tWantVX + 0.2 then put -1 into pSide
   if sMe["vy"] > tWantVY then put 1 into pThrust
end Lander.Autopilot

on Lander.TestAuto pOn
   put pOn into sAuto
end Lander.TestAuto

on Lander.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Lander.Say

on Lander.ShowHUD
   local tWords
   put sLevel & "|" & sScore & "|" & sLives & "|" & round(sFuel / 10) & "|" & round(sMe["vy"] * 4) & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Lander.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Lander.Score", sCfg["title"] & "   SCORE" && sScore && "  CRAFT" && sLives && "  FUEL" && max(0, round(sFuel)) && "  LEVEL" && sLevel & "/" & sCfg["levels"], 20, 30, 14
   HUD.Set "Lander.Speed", "DOWN" && round(sMe["vy"] * 10) / 10 && "  ACROSS" && round(sMe["vx"] * 10) / 10 && "  SAFE BELOW" && sCfg["safe"], 20, 78, 11
   HUD.Remove "Lander.Msg"
   if sOver and sWonAll then
      HUD.Set "Lander.Msg", "EVERY LEVEL LANDED. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Lander.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Lander.Msg", sMsg & "    " & sCfg["help"], 20, 56, 12
   end if
end Lander.ShowHUD

-- for tests: level|craft left|score|fuel|x,y|vx,vy|landed|over
function Lander.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & round(sFuel) & "|" & round(sMe["x"]) & "," & round(sMe["y"]) & "|" & round(sMe["vx"], 2) & "," & round(sMe["vy"], 2) & "|" & sLanded & "|" & sOver
end Lander.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Lander.Config
   put empty into sCfg
   put "COMFY LANDER" into sCfg["title"]
   put "ARROWS: UP BURNS, LEFT RIGHT TURN" into sCfg["help"]
   put 52757 into sCfg["seed"]
   put 390 into sCfg["hw"]
   put 230 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put "stars" into sCfg["floor"]
   put 60 into sCfg["grid"]
   put "229,211,45" into sCfg["wallColor"]
   put "91,84,18" into sCfg["decoColor"]
   put "rotate" into sCfg["mode"]
   put "arrows" into sCfg["ctrl"]
   put 0.185 into sCfg["thrust"]
   put 0.056 into sCfg["turn"]
   put 909 into sCfg["fuel"]
   put 19 into sCfg["size"]
   put "50,168,255" into sCfg["craftColor"]
   put "255,160,40" into sCfg["flameColor"]
   put 26 into sCfg["segments"]
   put 0.905 into sCfg["rough"]
   put 173 into sCfg["hills"]
   put 3 into sCfg["pads"]
   put "229,211,45" into sCfg["groundColor"]
   put "204,208,255" into sCfg["padColor"]
   put 3 into sCfg["lives"]
   put 3 into sCfg["levels"]
   put 0.031 into sCfg["gravity"]
   put 0.365 into sCfg["levelGain"]
   put 1.495 into sCfg["safe"]
   put 0 into sCfg["wind"]
   put 44 into sCfg["points"]
   put 0.786 into sCfg["startVX"]
end Lander.Config
