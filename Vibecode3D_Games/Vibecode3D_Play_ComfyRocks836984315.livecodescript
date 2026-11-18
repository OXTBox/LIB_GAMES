######################################################################################
## CARD SCRIPT: "Play.ComfyRocks836984315"   COMFY ROCKS  (made in ComfyUI, seed 836984315)
## A rock blaster put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## 4 rocks to start, 1 more each level, a saucer now and then.
## CONTROLS  Arrows: Left Right Turn, Up Thrusts  Space Fires   Escape: stop
## RULES     shoot every rock to clear the level: big ones split in two, then two again. 3 ships, one more every 10116 points.
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

## PART core (CROCK): a rock blaster. Your ship turns, thrusts and drifts; space wraps round at the
## edges. Shoot the rocks: a big one splits in two middle ones, a middle one in two small ones.
## Clear them all for the next level (one more rock each time). A saucer may cross and shoot.
## The builder adds Rocks.Config.

global bPaused, bPlaying

local sCfg
local sMe, sShot, sShotSeq, sRock, sRockSeq, sUfo, sUfoShot, sUfoSeq
local sCool, sDeadT, sSafeT, sNextLife, sFlameKey
local sLevel, sLives, sScore, sOver, sHUDWas, sTick, sMsg, sMsgT, sAuto

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Rocks.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put sCfg["extraLife"] into sNextLife
   put false into sOver
   Rocks.StartLevel 1
end Game.OnStart

on Rocks.StartLevel pLevel
   local tM, i, tA, tR
   put pLevel into sLevel
   Scene.ClearAll
   Particles.Clear
   put empty into sShot
   put empty into sRock
   put empty into sUfo
   put empty into sUfoShot
   put 0 into sCool
   put 0 into sDeadT
   put Mesh.New() into tM
   Vec.Decor tM, sCfg["floor"], sCfg["hw"], sCfg["hh"], sCfg["grid"]
   if tM["count"] > 0 then
      Mesh.Define "Rocks.Sky", tM
      get Entity.Spawn("Rocks.Sky", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["hw"], -sCfg["hh"], sCfg["hw"], sCfg["hh"]
   Mesh.Define "Rocks.Frame", tM
   get Entity.Spawn("Rocks.Frame", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   Mesh.Define "Rocks.Me", Vec.Shape(sCfg["shipShape"], sCfg["shipSize"])
   put Mesh.New() into tM
   Vec.Outline tM, -sCfg["shipSize"] * 0.15 & "," & sCfg["shipSize"] * 0.3 & cr & "0," & sCfg["shipSize"] * 0.8 & cr & sCfg["shipSize"] * 0.15 & "," & sCfg["shipSize"] * 0.3
   Mesh.Define "Rocks.Flame", tM
   put Mesh.New() into tM
   Vec.Line tM, -1.5, 0, 1.5, 0
   Vec.Line tM, 0, -1.5, 0, 1.5
   Mesh.Define "Rocks.Shot", tM
   repeat with i = 1 to 3
      Mesh.Define "Rocks.Rock" & i, Rocks.RockMesh(i)
   end repeat
   Mesh.Define "Rocks.Ufo", Vec.Shape("saucer", 34)
   Rocks.NewShip
   repeat with i = 1 to sCfg["rocks"] + sCfg["moreEach"] * (pLevel - 1)
      -- start round the edge, away from the ship
      put random(628) / 100 into tA
      put min(sCfg["hw"], sCfg["hh"]) * 0.9 into tR
      Rocks.AddRock 3, tR * cos(tA) * sCfg["hw"] / min(sCfg["hw"], sCfg["hh"]), tR * sin(tA)
   end repeat
   Rocks.Say "LEVEL" && pLevel, 60
end Rocks.StartLevel

-- three sizes of rock: each a lumpy ring, a little different
function Rocks.RockMesh pSize
   local tM, i, tN, tA, tR, tPts
   put Mesh.New() into tM
   put 10 into tN
   repeat with i = 0 to tN - 1
      put i * 2 * pi / tN into tA
      put sCfg["rockSize"] * pSize / 3 * (0.75 + ((i * 37 + pSize * 11) mod 10) / 30) into tR
      put tR * cos(tA) & "," & tR * sin(tA) & cr after tPts
   end repeat
   delete the last char of tPts
   Vec.Outline tM, tPts
   return tM
end Rocks.RockMesh

on Rocks.AddRock pSize, pX, pY
   local tA, tSp
   add 1 to sRockSeq
   put pSize into sRock[sRockSeq]["size"]
   put pX into sRock[sRockSeq]["x"]
   put pY into sRock[sRockSeq]["y"]
   put random(628) / 100 into tA
   put sCfg["rockSpeed"] * (1 + sCfg["levelGain"] * (sLevel - 1)) * (1 + (3 - pSize) * 0.45) * (0.6 + random(80) / 100) into tSp
   put tSp * cos(tA) into sRock[sRockSeq]["vx"]
   put tSp * sin(tA) into sRock[sRockSeq]["vy"]
   put Entity.Spawn("Rocks.Rock" & pSize, pX, sCfg["cy"] + pY, kZ, sCfg["rockColor"]) into sRock[sRockSeq]["key"]
   Entity.SetRotationSpeed sRock[sRockSeq]["key"], 0, 0, (random(41) - 21) / 400
end Rocks.AddRock

on Rocks.NewShip
   put 0 into sMe["x"]
   put 0 into sMe["y"]
   put 0 into sMe["vx"]
   put 0 into sMe["vy"]
   put 0 into sMe["a"]
   put 90 into sSafeT
   put Entity.Spawn("Rocks.Me", 0, sCfg["cy"], kZ, sCfg["shipColor"]) into sMe["key"]
   put empty into sFlameKey
end Rocks.NewShip

on Game.OnUpdate
   local tKeys, tTurn, tThrust, tFire
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put sCfg["extraLife"] into sNextLife
         put false into sOver
         Rocks.StartLevel 1
      end if
      Rocks.ShowHUD
      exit Game.OnUpdate
   end if
   put 0 into tTurn
   put 0 into tThrust
   put false into tFire
   if sDeadT > 0 then
      subtract 1 from sDeadT
      if sDeadT = 0 then
         Rocks.NewShip
      end if
   else if sAuto is true then
      Rocks.Autopilot tTurn, tThrust, tFire
   else
      put item 1 of Vec.Dir(sCfg["ctrl"], tKeys) into tTurn
      if item 2 of Vec.Dir(sCfg["ctrl"], tKeys) < 0 then put 1 into tThrust
      put Vec.Fire(sCfg["ctrl"], tKeys) into tFire
   end if
   if sDeadT = 0 then Rocks.MoveShip tTurn, tThrust, tFire
   Rocks.MoveShots
   Rocks.MoveRocks
   Rocks.Saucer
   if sSafeT > 0 then subtract 1 from sSafeT
   if Rocks.Count(sRock) = 0 and not sOver then
      add 100 * sLevel to sScore
      Rocks.StartLevel sLevel + 1
   end if
   if sScore >= sNextLife and sCfg["extraLife"] > 0 then
      add 1 to sLives
      add sCfg["extraLife"] to sNextLife
      Rocks.Say "EXTRA SHIP", 50
   end if
   if sMsgT > 0 then subtract 1 from sMsgT
   Rocks.ShowHUD
end Game.OnUpdate

-- space wraps round: off one edge, on at the other
function Rocks.WrapX pX
   if pX < -sCfg["hw"] then return pX + sCfg["hw"] * 2
   if pX > sCfg["hw"] then return pX - sCfg["hw"] * 2
   return pX
end Rocks.WrapX

function Rocks.WrapY pY
   if pY < -sCfg["hh"] then return pY + sCfg["hh"] * 2
   if pY > sCfg["hh"] then return pY - sCfg["hh"] * 2
   return pY
end Rocks.WrapY

on Rocks.MoveShip pTurn, pThrust, pFire
   local tSp
   add pTurn * sCfg["turn"] to sMe["a"]
   if pThrust > 0 then
      add sin(sMe["a"]) * sCfg["thrust"] to sMe["vx"]
      subtract cos(sMe["a"]) * sCfg["thrust"] from sMe["vy"]
   end if
   put sMe["vx"] * sCfg["drag"] into sMe["vx"]
   put sMe["vy"] * sCfg["drag"] into sMe["vy"]
   put sqrt(sMe["vx"] ^ 2 + sMe["vy"] ^ 2) into tSp
   if tSp > sCfg["topSpeed"] then
      put sMe["vx"] * sCfg["topSpeed"] / tSp into sMe["vx"]
      put sMe["vy"] * sCfg["topSpeed"] / tSp into sMe["vy"]
   end if
   add sMe["vx"] to sMe["x"]
   add sMe["vy"] to sMe["y"]
   put Rocks.WrapX(sMe["x"]) into sMe["x"]
   put Rocks.WrapY(sMe["y"]) into sMe["y"]
   Entity.SetPosition sMe["key"], sMe["x"], sCfg["cy"] + sMe["y"], kZ
   Entity.SetRotation sMe["key"], 0, 0, sMe["a"]
   Rocks.Flame pThrust > 0
   if sCool > 0 then subtract 1 from sCool
   if pFire and sCool = 0 and Rocks.Count(sShot) < sCfg["maxShots"] then
      add 1 to sShotSeq
      put sMe["x"] + sin(sMe["a"]) * sCfg["shipSize"] / 2 into sShot[sShotSeq]["x"]
      put sMe["y"] - cos(sMe["a"]) * sCfg["shipSize"] / 2 into sShot[sShotSeq]["y"]
      put sMe["vx"] + sin(sMe["a"]) * sCfg["shotSpeed"] into sShot[sShotSeq]["vx"]
      put sMe["vy"] - cos(sMe["a"]) * sCfg["shotSpeed"] into sShot[sShotSeq]["vy"]
      put sCfg["shotLife"] into sShot[sShotSeq]["life"]
      put Entity.Spawn("Rocks.Shot", sShot[sShotSeq]["x"], sCfg["cy"] + sShot[sShotSeq]["y"], kZ, sCfg["shotColor"]) into sShot[sShotSeq]["key"]
      put sCfg["cool"] into sCool
      Sound.Play "shot"
   end if
end Rocks.MoveShip

on Rocks.Flame pOn
   if pOn then
      if sFlameKey is empty then put Entity.Spawn("Rocks.Flame", sMe["x"], sCfg["cy"] + sMe["y"], kZ, sCfg["flameColor"]) into sFlameKey
      Entity.SetPosition sFlameKey, sMe["x"], sCfg["cy"] + sMe["y"], kZ
      Entity.SetRotation sFlameKey, 0, 0, sMe["a"]
   else if sFlameKey is not empty then
      Entity.Kill sFlameKey
      put empty into sFlameKey
   end if
end Rocks.Flame

on Rocks.MoveShots
   local k, tKeys, r, tRocks, tHit
   put the keys of sShot into tKeys
   repeat for each line k in tKeys
      add sShot[k]["vx"] to sShot[k]["x"]
      add sShot[k]["vy"] to sShot[k]["y"]
      put Rocks.WrapX(sShot[k]["x"]) into sShot[k]["x"]
      put Rocks.WrapY(sShot[k]["y"]) into sShot[k]["y"]
      subtract 1 from sShot[k]["life"]
      put empty into tHit
      put the keys of sRock into tRocks
      repeat for each line r in tRocks
         if (sRock[r]["x"] - sShot[k]["x"]) ^ 2 + (sRock[r]["y"] - sShot[k]["y"]) ^ 2 < (sCfg["rockSize"] * sRock[r]["size"] / 3) ^ 2 then
            put r into tHit
            exit repeat
         end if
      end repeat
      if tHit is not empty then
         Rocks.Break tHit
         Rocks.EndShot k
         next repeat
      end if
      if sUfo["key"] is not empty and abs(sUfo["x"] - sShot[k]["x"]) < 18 and abs(sUfo["y"] - sShot[k]["y"]) < 10 then
         Rocks.UfoDown
         add sCfg["ufoPoints"] to sScore
         Rocks.EndShot k
         next repeat
      end if
      if sShot[k]["life"] <= 0 then
         Rocks.EndShot k
      else
         Entity.SetPosition sShot[k]["key"], sShot[k]["x"], sCfg["cy"] + sShot[k]["y"], kZ
      end if
   end repeat
end Rocks.MoveShots

on Rocks.EndShot pK
   Entity.Kill sShot[pK]["key"]
   delete variable sShot[pK]
end Rocks.EndShot

-- a rock breaks: points by size; a big or middle one leaves two smaller ones
on Rocks.Break pR
   local tSize, tX, tY
   put sRock[pR]["size"] into tSize
   put sRock[pR]["x"] into tX
   put sRock[pR]["y"] into tY
   Entity.Kill sRock[pR]["key"]
   delete variable sRock[pR]
   FX.Sparks tX, sCfg["cy"] + tY, kZ, 6 + tSize * 4, sCfg["rockColor"]
   Sound.Play "boom"
   add sCfg["points"] * (4 - tSize) to sScore
   if tSize > 1 then
      Rocks.AddRock tSize - 1, tX, tY
      Rocks.AddRock tSize - 1, tX, tY
   end if
end Rocks.Break

on Rocks.MoveRocks
   local r, tRocks, tR
   put the keys of sRock into tRocks
   repeat for each line r in tRocks
      add sRock[r]["vx"] to sRock[r]["x"]
      add sRock[r]["vy"] to sRock[r]["y"]
      put Rocks.WrapX(sRock[r]["x"]) into sRock[r]["x"]
      put Rocks.WrapY(sRock[r]["y"]) into sRock[r]["y"]
      Entity.SetPosition sRock[r]["key"], sRock[r]["x"], sCfg["cy"] + sRock[r]["y"], kZ
      put sCfg["rockSize"] * sRock[r]["size"] / 3 + sCfg["shipSize"] * 0.35 into tR
      if sDeadT = 0 and sSafeT = 0 and (sRock[r]["x"] - sMe["x"]) ^ 2 + (sRock[r]["y"] - sMe["y"]) ^ 2 < tR ^ 2 then
         Rocks.Break r
         Rocks.ShipDown
         if sOver then exit repeat
      end if
   end repeat
end Rocks.MoveRocks

-- the saucer: now and then it crosses, drifting, and shoots at you
on Rocks.Saucer
   local k, tKeys, tA
   if sCfg["ufoChance"] > 0 and sUfo["key"] is empty and random(100000) <= sCfg["ufoChance"] * 100000 then
      put -sCfg["hw"] into sUfo["x"]
      put (random(2001) - 1001) / 1000 * sCfg["hh"] * 0.7 into sUfo["y"]
      put 2 + sLevel * 0.2 into sUfo["vx"]
      if random(2) = 1 then
         put sCfg["hw"] into sUfo["x"]
         put -sUfo["vx"] into sUfo["vx"]
      end if
      put Entity.Spawn("Rocks.Ufo", sUfo["x"], sCfg["cy"] + sUfo["y"], kZ, sCfg["ufoColor"]) into sUfo["key"]
   end if
   if sUfo["key"] is not empty then
      add sUfo["vx"] to sUfo["x"]
      add 1.5 * sin(sTick / 20) to sUfo["y"]
      if abs(sUfo["x"]) > sCfg["hw"] + 20 then
         Entity.Kill sUfo["key"]
         put empty into sUfo
      else
         Entity.SetPosition sUfo["key"], sUfo["x"], sCfg["cy"] + sUfo["y"], kZ
         if sTick mod 50 = 0 and sDeadT = 0 then
            put atan2(sMe["y"] - sUfo["y"], sMe["x"] - sUfo["x"]) + (random(41) - 21) / 100 into tA
            add 1 to sUfoSeq
            put sUfo["x"] into sUfoShot[sUfoSeq]["x"]
            put sUfo["y"] into sUfoShot[sUfoSeq]["y"]
            put 5 * cos(tA) into sUfoShot[sUfoSeq]["vx"]
            put 5 * sin(tA) into sUfoShot[sUfoSeq]["vy"]
            put 90 into sUfoShot[sUfoSeq]["life"]
            put Entity.Spawn("Rocks.Shot", sUfo["x"], sCfg["cy"] + sUfo["y"], kZ, sCfg["ufoColor"]) into sUfoShot[sUfoSeq]["key"]
         end if
      end if
   end if
   put the keys of sUfoShot into tKeys
   repeat for each line k in tKeys
      add sUfoShot[k]["vx"] to sUfoShot[k]["x"]
      add sUfoShot[k]["vy"] to sUfoShot[k]["y"]
      subtract 1 from sUfoShot[k]["life"]
      if sDeadT = 0 and sSafeT = 0 and abs(sUfoShot[k]["x"] - sMe["x"]) < sCfg["shipSize"] / 2 and abs(sUfoShot[k]["y"] - sMe["y"]) < sCfg["shipSize"] / 2 then
         put 0 into sUfoShot[k]["life"]
         Rocks.ShipDown
      end if
      if sUfoShot[k]["life"] <= 0 or abs(sUfoShot[k]["x"]) > sCfg["hw"] or abs(sUfoShot[k]["y"]) > sCfg["hh"] then
         Entity.Kill sUfoShot[k]["key"]
         delete variable sUfoShot[k]
      else
         Entity.SetPosition sUfoShot[k]["key"], sUfoShot[k]["x"], sCfg["cy"] + sUfoShot[k]["y"], kZ
      end if
   end repeat
end Rocks.Saucer

on Rocks.UfoDown
   FX.Sparks sUfo["x"], sCfg["cy"] + sUfo["y"], kZ, 20, sCfg["ufoColor"]
   Entity.Kill sUfo["key"]
   put empty into sUfo
end Rocks.UfoDown

on Rocks.ShipDown
   Rocks.Flame false
   FX.Sparks sMe["x"], sCfg["cy"] + sMe["y"], kZ, 30, sCfg["shipColor"]
   Sound.Play "boom"
   Entity.Kill sMe["key"]
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      exit Rocks.ShipDown
   end if
   put 70 into sDeadT
   Rocks.Say "SHIP LOST", 60
end Rocks.ShipDown

-- tests and the demo: turn to the nearest rock (leading it a little), fire when lined up,
-- thrust away when one comes too close
on Rocks.Autopilot @pTurn, @pThrust, @pFire
   local r, tBest, tD, tTX, tTY, tWant, tDiff
   put 99999 into tBest
   repeat for each key r in sRock
      put sqrt((sRock[r]["x"] - sMe["x"]) ^ 2 + (sRock[r]["y"] - sMe["y"]) ^ 2) into tD
      if tD < tBest then
         put tD into tBest
         put sRock[r]["x"] + sRock[r]["vx"] * tD / sCfg["shotSpeed"] into tTX
         put sRock[r]["y"] + sRock[r]["vy"] * tD / sCfg["shotSpeed"] into tTY
      end if
   end repeat
   if tTX is empty then exit Rocks.Autopilot
   -- the heading that points at x,y: 0 is up (-y), growing clockwise
   put atan2(tTX - sMe["x"], -(tTY - sMe["y"])) into tWant
   put tWant - sMe["a"] into tDiff
   repeat while tDiff > pi
      subtract 2 * pi from tDiff
   end repeat
   repeat while tDiff < -pi
      add 2 * pi to tDiff
   end repeat
   if tDiff > sCfg["turn"] then put 1 into pTurn
   if tDiff < -sCfg["turn"] then put -1 into pTurn
   put abs(tDiff) < 0.2 into pFire
   if tBest < sCfg["rockSize"] * 1.6 and abs(tDiff) > 2 then put 1 into pThrust
end Rocks.Autopilot

on Rocks.TestAuto pOn
   put pOn into sAuto
end Rocks.TestAuto

function Rocks.Count pArr
   local tKeys
   if pArr is not an array then return 0
   put the keys of pArr into tKeys
   return the number of lines of tKeys
end Rocks.Count

on Rocks.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Rocks.Say

on Rocks.ShowHUD
   local tWords
   put sLevel & "|" & sScore & "|" & sLives & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Rocks.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Rocks.Score", sCfg["title"] & "   SCORE" && sScore && "  SHIPS" && sLives && "  LEVEL" && sLevel, 20, 30, 14
   HUD.Remove "Rocks.Msg"
   if sOver then
      HUD.Set "Rocks.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Rocks.Msg", sMsg & "    " & sCfg["help"], 20, 56, 12
   end if
end Rocks.ShowHUD

-- for tests: level|ships|score|rocks|shots|over
function Rocks.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & Rocks.Count(sRock) & "|" & Rocks.Count(sShot) & "|" & sOver
end Rocks.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Rocks.Config
   put empty into sCfg
   put "COMFY ROCKS" into sCfg["title"]
   put "ARROWS: LEFT RIGHT TURN, UP THRUSTS  SPACE FIRES" into sCfg["help"]
   put 339 into sCfg["hw"]
   put 227 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put "stars" into sCfg["floor"]
   put 56 into sCfg["grid"]
   put "229,217,114" into sCfg["wallColor"]
   put "91,86,45" into sCfg["decoColor"]
   put "arrows" into sCfg["ctrl"]
   put "diamond" into sCfg["shipShape"]
   put 26 into sCfg["shipSize"]
   put 0.205 into sCfg["thrust"]
   put 0.07 into sCfg["turn"]
   put 1.0 into sCfg["drag"]
   put 7.078 into sCfg["topSpeed"]
   put 10 into sCfg["cool"]
   put 8.631 into sCfg["shotSpeed"]
   put 60 into sCfg["shotLife"]
   put 4 into sCfg["maxShots"]
   put "255,249,204" into sCfg["shipColor"]
   put "255,255,255" into sCfg["shotColor"]
   put "255,160,40" into sCfg["flameColor"]
   put 4 into sCfg["rocks"]
   put 1 into sCfg["moreEach"]
   put 47 into sCfg["rockSize"]
   put 1.223 into sCfg["rockSpeed"]
   put 23 into sCfg["points"]
   put "229,217,114" into sCfg["rockColor"]
   put 0.002 into sCfg["ufoChance"]
   put 420 into sCfg["ufoPoints"]
   put "204,184,20" into sCfg["ufoColor"]
   put 3 into sCfg["lives"]
   put 0.14 into sCfg["levelGain"]
   put 10116 into sCfg["extraLife"]
end Rocks.Config
