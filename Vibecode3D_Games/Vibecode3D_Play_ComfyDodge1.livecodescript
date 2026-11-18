######################################################################################
## CARD SCRIPT: "Play.ComfyDodge1"   COMFY DODGE  (made in ComfyUI, seed 1)
## A lane dodger put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## 5 lanes. Hazards: rock, bug (wobbling). Pickups: coin, coin.
## CONTROLS  Arrows Move  One Lane A Press   Escape: stop
## RULES     last 1234 steps to clear a level; 3 levels, each faster; 3 lives. Shield, slow time
##           and extra lives fall with the hazards.
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

## PART core (CDODGE): a lane dodger. You run along the bottom; hazards pour down the arena and
## pickups with them. Last the level's distance to go on; each level is faster. Hazard and
## Pickup kinds come from their nodes. The builder adds Dodge.Config.

global bPaused, bPlaying

local sCfg, sHaz, sHazN, sPick, sPickN
local sMe, sThing, sSeq, sDist, sSpeedNow, sShieldT, sSlowT, sLaneT, sScroll, sScrollStep, sFloorKey
local sLevel, sLives, sScore, sOver, sWonAll, sHUDWas, sTick, sMsg, sMsgT, sAuto, sHurtT

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Dodge.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put false into sOver
   Dodge.StartLevel 1
end Game.OnStart

on Dodge.StartLevel pLevel
   local tM, k, tLaneW
   put pLevel into sLevel
   Scene.ClearAll
   Particles.Clear
   put empty into sThing
   put 0 into sDist
   put 0 into sShieldT
   put 0 into sSlowT
   put 0 into sHurtT
   put 0 into sScroll
   put 1 + sCfg["levelGain"] * (pLevel - 1) into sSpeedNow
   -- the floor scrolls: a strip twice as tall as one floor step, moved down and wrapped
   put Mesh.New() into tM
   if sCfg["lanes"] > 1 then
      put sCfg["hw"] * 2 / sCfg["lanes"] into tLaneW
      Vec.Decor tM, "lanes", sCfg["hw"], sCfg["hh"] + tLaneW, tLaneW
      -- the dashes repeat every two thirds of a lane's width: scroll by that and wrap
      put max(16, tLaneW) * 2 / 3 into sScrollStep
   else
      Vec.Decor tM, sCfg["floor"], sCfg["hw"], sCfg["hh"] + sCfg["grid"], sCfg["grid"]
      put 0 into sScrollStep
      if sCfg["floor"] is among the items of "grid,dots" then put max(16, sCfg["grid"]) into sScrollStep
   end if
   if tM["count"] > 0 then
      Mesh.Define "Dodge.Floor", tM
      put Entity.Spawn("Dodge.Floor", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"]) into sFloorKey
   else
      put empty into sFloorKey
   end if
   put Mesh.New() into tM
   Vec.Line tM, -sCfg["hw"], -sCfg["hh"], -sCfg["hw"], sCfg["hh"]
   Vec.Line tM, sCfg["hw"], -sCfg["hh"], sCfg["hw"], sCfg["hh"]
   Mesh.Define "Dodge.Sides", tM
   get Entity.Spawn("Dodge.Sides", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   Mesh.Define "Dodge.Me", Vec.Shape(sCfg["meShape"], sCfg["meSize"])
   put Mesh.New() into tM
   Vec.Ring tM, 0, 0, sCfg["meSize"] * 0.8, 14
   Mesh.Define "Dodge.Bubble", tM
   repeat with k = 1 to sHazN
      Mesh.Define "Dodge.Haz" & k, Vec.Shape(sHaz[k]["shape"], sHaz[k]["size"])
   end repeat
   repeat with k = 1 to sPickN
      Mesh.Define "Dodge.Pick" & k, Vec.Shape(sPick[k]["shape"], 18)
   end repeat
   put sCfg["hh"] - 34 into sMe["y"]
   put Dodge.LaneX(round((sCfg["lanes"] + 1) / 2)) into sMe["x"]
   if sCfg["lanes"] <= 1 then put 0 into sMe["x"]
   put sMe["x"] into sMe["tx"]
   put Entity.Spawn("Dodge.Me", sMe["x"], sCfg["cy"] + sMe["y"], kZ, sCfg["meColor"]) into sMe["key"]
   put empty into sMe["bubble"]
   Dodge.Say "LEVEL" && pLevel & ": GO" && sCfg["distance"] && "STEPS", 70
end Dodge.StartLevel

function Dodge.LaneX pLane
   if sCfg["lanes"] <= 1 then return 0
   return -sCfg["hw"] + (pLane - 0.5) * sCfg["hw"] * 2 / sCfg["lanes"]
end Dodge.LaneX

function Dodge.LaneOf pX
   return Vec.Clamp(floor((pX + sCfg["hw"]) / (sCfg["hw"] * 2 / sCfg["lanes"])) + 1, 1, sCfg["lanes"])
end Dodge.LaneOf

on Game.OnUpdate
   local tKeys, tF
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put false into sOver
         Dodge.StartLevel 1
      end if
      Dodge.ShowHUD
      exit Game.OnUpdate
   end if
   put sSpeedNow into tF
   if sSlowT > 0 then
      subtract 1 from sSlowT
      put tF * 0.55 into tF
   end if
   Dodge.MoveMe tKeys
   Dodge.Spawn tF
   Dodge.MoveThings tF
   Dodge.ScrollFloor tF
   if sShieldT > 0 then subtract 1 from sShieldT
   if sHurtT > 0 then subtract 1 from sHurtT
   Dodge.Bubble
   add 1 to sDist
   if sTick mod 10 = 0 then add sLevel to sScore
   if sDist >= sCfg["distance"] and not sOver then
      add 100 * sLevel to sScore
      if sLevel >= sCfg["levels"] then
         put true into sOver
         put true into sWonAll
         put empty into sHUDWas
      else
         Dodge.StartLevel sLevel + 1
      end if
   end if
   if sMsgT > 0 then subtract 1 from sMsgT
   Dodge.ShowHUD
end Game.OnUpdate

-- lanes: a press moves one lane (held: one lane every few steps); free: slide
on Dodge.MoveMe pKeys
   local tD, tM, tLane
   if sAuto is true then
      put Dodge.AutoX() into tM
      if sCfg["lanes"] > 1 then
         put Dodge.LaneX(Dodge.LaneOf(tM)) into sMe["tx"]
      else
         put tM into sMe["tx"]
      end if
   else if sCfg["ctrl"] is "mouse" then
      put Vec.MousePoint(kZ) into tM
      if tM is not empty then
         if sCfg["lanes"] > 1 then
            put Dodge.LaneX(Dodge.LaneOf(item 1 of tM)) into sMe["tx"]
         else
            put item 1 of tM into sMe["tx"]
         end if
      end if
   else
      put item 1 of Vec.Dir(sCfg["ctrl"], pKeys) into tD
      if sCfg["lanes"] > 1 then
         if sLaneT > 0 then subtract 1 from sLaneT
         if tD = 0 then put 0 into sLaneT
         if tD is not 0 and sLaneT = 0 then
            put Vec.Clamp(Dodge.LaneOf(sMe["tx"]) + tD, 1, sCfg["lanes"]) into tLane
            put Dodge.LaneX(tLane) into sMe["tx"]
            put 8 into sLaneT
         end if
      else
         put sMe["x"] + tD * sCfg["meSpeed"] into sMe["tx"]
      end if
   end if
   put Vec.Clamp(sMe["tx"], -sCfg["hw"] + sCfg["meSize"] / 2, sCfg["hw"] - sCfg["meSize"] / 2) into sMe["tx"]
   add Vec.Clamp(sMe["tx"] - sMe["x"], -sCfg["meSpeed"], sCfg["meSpeed"]) to sMe["x"]
   Entity.SetPosition sMe["key"], sMe["x"], sCfg["cy"] + sMe["y"], kZ
   Entity.SetRotation sMe["key"], 0, 0, Vec.Clamp((sMe["tx"] - sMe["x"]) / 60, -0.4, 0.4)
end Dodge.MoveMe

-- each hazard and pickup kind rolls its own chance every step
on Dodge.Spawn pF
   local k, tX
   repeat with k = 1 to sHazN
      if random(100000) <= sHaz[k]["rate"] * pF * 100000 then
         if sCfg["lanes"] > 1 and sHaz[k]["inLane"] then
            put Dodge.LaneX(random(sCfg["lanes"])) into tX
         else
            put (random(2001) - 1001) / 1000 * (sCfg["hw"] - sHaz[k]["size"] / 2) into tX
         end if
         Dodge.AddThing "haz", k, tX, "Dodge.Haz" & k, sHaz[k]["color"], sHaz[k]["size"]
      end if
   end repeat
   repeat with k = 1 to sPickN
      if random(100000) <= sPick[k]["rate"] * 100000 then
         if sCfg["lanes"] > 1 then
            put Dodge.LaneX(random(sCfg["lanes"])) into tX
         else
            put (random(2001) - 1001) / 1000 * (sCfg["hw"] - 12) into tX
         end if
         Dodge.AddThing "pick", k, tX, "Dodge.Pick" & k, sPick[k]["color"], 18
      end if
   end repeat
end Dodge.Spawn

on Dodge.AddThing pWhat, pK, pX, pMesh, pColor, pSize
   add 1 to sSeq
   put pWhat into sThing[sSeq]["what"]
   put pK into sThing[sSeq]["k"]
   put pX into sThing[sSeq]["x"]
   put pX into sThing[sSeq]["x0"]
   put -sCfg["hh"] - pSize into sThing[sSeq]["y"]
   put pSize into sThing[sSeq]["size"]
   put random(628) / 100 into sThing[sSeq]["ph"]
   put Entity.Spawn(pMesh, pX, sCfg["cy"] + sThing[sSeq]["y"], kZ, pColor) into sThing[sSeq]["key"]
   if pWhat is "haz" and sHaz[pK]["spin"] then Entity.SetRotationSpeed sThing[sSeq]["key"], 0, 0, 0.05
end Dodge.AddThing

on Dodge.MoveThings pF
   local tSeq, tSeqs, k, tR, tSpeed
   put the keys of sThing into tSeqs
   repeat for each line tSeq in tSeqs
      put sThing[tSeq]["k"] into k
      if sThing[tSeq]["what"] is "haz" then
         put sHaz[k]["speed"] * pF into tSpeed
         if sHaz[k]["wobble"] > 0 then
            put sThing[tSeq]["x0"] + sHaz[k]["wobble"] * sin(sThing[tSeq]["y"] / 40 + sThing[tSeq]["ph"]) into sThing[tSeq]["x"]
         end if
      else
         put sCfg["pickSpeed"] * pF into tSpeed
      end if
      add tSpeed to sThing[tSeq]["y"]
      if sThing[tSeq]["y"] > sCfg["hh"] + sThing[tSeq]["size"] then
         if sThing[tSeq]["what"] is "haz" then add sHaz[k]["points"] to sScore
         Dodge.Drop tSeq
         next repeat
      end if
      put (sThing[tSeq]["size"] + sCfg["meSize"]) * 0.4 into tR
      if abs(sThing[tSeq]["x"] - sMe["x"]) < tR and abs(sThing[tSeq]["y"] - sMe["y"]) < tR then
         if sThing[tSeq]["what"] is "pick" then
            Dodge.Take k
            Dodge.Drop tSeq
            next repeat
         end if
         if sShieldT = 0 and sHurtT = 0 then
            FX.Sparks sThing[tSeq]["x"], sCfg["cy"] + sThing[tSeq]["y"], kZ, 20, sHaz[k]["color"]
            Dodge.Drop tSeq
            Dodge.Hurt
            if sOver then exit Dodge.MoveThings
            next repeat
         end if
      end if
      Entity.SetPosition sThing[tSeq]["key"], sThing[tSeq]["x"], sCfg["cy"] + sThing[tSeq]["y"], kZ
   end repeat
end Dodge.MoveThings

on Dodge.Drop pSeq
   Entity.Kill sThing[pSeq]["key"]
   delete variable sThing[pSeq]
end Dodge.Drop

on Dodge.Take pK
   FX.Sparks sMe["x"], sCfg["cy"] + sMe["y"], kZ, 8, sPick[pK]["color"]
   add sPick[pK]["points"] to sScore
   switch sPick[pK]["kind"]
      case "shield"
         put 300 into sShieldT
         Dodge.Say "SHIELD", 40
         break
      case "slow"
         put 240 into sSlowT
         Dodge.Say "SLOW TIME", 40
         break
      case "life"
         add 1 to sLives
         Dodge.Say "EXTRA LIFE", 40
         break
   end switch
   put empty into sHUDWas
end Dodge.Take

on Dodge.Hurt
   Sound.Play "boom"
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      put false into sWonAll
      exit Dodge.Hurt
   end if
   put 60 into sHurtT
   Dodge.Say "HIT", 40
end Dodge.Hurt

-- a ring round you while a shield (or the moment after a hit) protects you
on Dodge.Bubble
   if sShieldT > 0 or sHurtT > 0 then
      if sMe["bubble"] is empty then put Entity.Spawn("Dodge.Bubble", sMe["x"], sCfg["cy"] + sMe["y"], kZ, sCfg["meColor"]) into sMe["bubble"]
      Entity.SetPosition sMe["bubble"], sMe["x"], sCfg["cy"] + sMe["y"], kZ
   else if sMe["bubble"] is not empty then
      Entity.Kill sMe["bubble"]
      put empty into sMe["bubble"]
   end if
end Dodge.Bubble

on Dodge.ScrollFloor pF
   if sFloorKey is empty or sScrollStep <= 0 then exit Dodge.ScrollFloor
   add sCfg["scroll"] * pF to sScroll
   put sScroll mod sScrollStep into sScroll
   Entity.SetPosition sFloorKey, 0, sCfg["cy"] + sScroll - sScrollStep / 2, kZ + 1
end Dodge.ScrollFloor

-- tests and the demo: the x along the bottom with the most room from what is coming down
function Dodge.AutoX
   local tTry, tX, tBest, tBestScore, tSeq, tScore, dy, tGap
   put -99999 into tBestScore
   put sMe["x"] into tBest
   repeat with tTry = 0 to 20
      -- with lanes only the middles of the lanes are places to be
      if sCfg["lanes"] > 1 then
         if tTry >= sCfg["lanes"] then exit repeat
         put Dodge.LaneX(tTry + 1) into tX
      else
         put -sCfg["hw"] + sCfg["meSize"] + tTry * (sCfg["hw"] * 2 - sCfg["meSize"] * 2) / 20 into tX
      end if
      put 0 - abs(tX - sMe["x"]) / 50 into tScore
      repeat for each key tSeq in sThing
         put sMe["y"] - sThing[tSeq]["y"] into dy
         if dy < -20 or dy > 260 then next repeat
         put abs(sThing[tSeq]["x"] - tX) into tGap
         if sThing[tSeq]["what"] is "pick" then
            if tGap < 30 then
               add 3 to tScore
            end if
         else if tGap < (sThing[tSeq]["size"] + sCfg["meSize"]) * 0.6 + 10 then
            subtract 100 - dy / 4 from tScore
         end if
      end repeat
      if tScore > tBestScore then
         put tScore into tBestScore
         put tX into tBest
      end if
   end repeat
   return tBest
end Dodge.AutoX

on Dodge.TestAuto pOn
   put pOn into sAuto
end Dodge.TestAuto

on Dodge.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Dodge.Say

on Dodge.ShowHUD
   local tWords, tLeft
   put max(0, sCfg["distance"] - sDist) into tLeft
   put sLevel & "|" & sScore & "|" & sLives & "|" & (tLeft div 30) & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Dodge.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Dodge.Score", sCfg["title"] & "   SCORE" && sScore && "  LIVES" && sLives && "  TO GO" && tLeft && "  LEVEL" && sLevel & "/" & sCfg["levels"], 20, 30, 14
   HUD.Remove "Dodge.Msg"
   if sOver and sWonAll then
      HUD.Set "Dodge.Msg", "ALL THE WAY. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Dodge.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Dodge.Msg", sMsg & "    " & sCfg["help"], 20, 56, 12
   end if
end Dodge.ShowHUD

-- for tests: level|lives|score|distance|things falling|over|x
function Dodge.State
   local tN, tKeys
   put the keys of sThing into tKeys
   put the number of lines of tKeys into tN
   return sLevel & "|" & sLives & "|" & sScore & "|" & sDist & "|" & tN & "|" & sOver & "|" & round(sMe["x"])
end Dodge.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Dodge.Config
   put empty into sCfg
   put empty into sHaz
   put empty into sPick
   put "COMFY DODGE" into sCfg["title"]
   put "ARROWS MOVE  ONE LANE A PRESS" into sCfg["help"]
   put 300 into sCfg["hw"]
   put 230 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put "bare" into sCfg["floor"]
   put 50 into sCfg["grid"]
   put "229,180,114" into sCfg["wallColor"]
   put "91,72,45" into sCfg["decoColor"]
   put "arrows" into sCfg["ctrl"]
   put 5 into sCfg["lanes"]
   put "bug" into sCfg["meShape"]
   put 21 into sCfg["meSize"]
   put 10.919 into sCfg["meSpeed"]
   put "255,233,204" into sCfg["meColor"]
   put 3 into sCfg["lives"]
   put 3 into sCfg["levels"]
   put 1234 into sCfg["distance"]
   put 0.289 into sCfg["levelGain"]
   put 6.423 into sCfg["scroll"]
   put 3 into sCfg["pickSpeed"]
   put 2 into sHazN
   put 2 into sPickN
   put "rock" into sHaz[1]["shape"]
   put 36 into sHaz[1]["size"]
   put 4.845 into sHaz[1]["speed"]
   put 0.027 into sHaz[1]["rate"]
   put 0 into sHaz[1]["wobble"]
   put true into sHaz[1]["inLane"]
   put true into sHaz[1]["spin"]
   put 6 into sHaz[1]["points"]
   put "204,125,20" into sHaz[1]["color"]
   put "bug" into sHaz[2]["shape"]
   put 23 into sHaz[2]["size"]
   put 5.26 into sHaz[2]["speed"]
   put 0.009 into sHaz[2]["rate"]
   put 45 into sHaz[2]["wobble"]
   put false into sHaz[2]["inLane"]
   put false into sHaz[2]["spin"]
   put 10 into sHaz[2]["points"]
   put "204,125,20" into sHaz[2]["color"]
   put "coin" into sPick[1]["kind"]
   put "ring" into sPick[1]["shape"]
   put 0.008 into sPick[1]["rate"]
   put 30 into sPick[1]["points"]
   put "255,220,60" into sPick[1]["color"]
   put "coin" into sPick[2]["kind"]
   put "ring" into sPick[2]["shape"]
   put 0.002 into sPick[2]["rate"]
   put 11 into sPick[2]["points"]
   put "255,220,60" into sPick[2]["color"]
end Dodge.Config
