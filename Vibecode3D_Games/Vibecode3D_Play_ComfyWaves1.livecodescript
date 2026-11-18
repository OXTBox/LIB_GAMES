######################################################################################
## CARD SCRIPT: "Play.ComfyWaves1"   COMFY WAVES  (made in ComfyUI, seed 1)
## A wave shooter put together by the Vibecode3D nodes from LIB_COMFY/parts: common/vec, core.
## Waves: block of crab 4x8; block of tri 5x10; block of diamond 3x6. Shields: 4.
## CONTROLS  Arrows Move  Space Fires   Escape: stop
## RULES     as many waves as you can (they come round faster); 3 ships. A bomb, a diver or the formation reaching you costs a ship.
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

## PART core (CWAVE): a wave shooter. Your ship at the bottom, a formation marching above;
## it steps down at each wall, drops bombs, and some leave it to dive at you. Shields soak up
## shots from both sides. Clear the wave for the next one. The builder adds Wave.Config.

global bPaused, bPlaying

local sCfg, sWave, sWaveN
local sShip, sShot, sShotSeq, sBomb, sBombSeq, sFoe, sFoeN, sAlive, sShield, sShieldTop, sShieldBottom
local sMarchX, sMarchDir, sMarchY, sRush
local sLevel, sLives, sScore, sOver, sWonAll, sHUDWas, sTick, sMsg, sMsgT, sCool, sDeadT, sAuto, sNow

constant kZ = 300

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Wave.Config
   put 0 into sScore
   put sCfg["lives"] into sLives
   put false into sOver
   Wave.StartLevel 1
end Game.OnStart

-- level n flies wave ((n - 1) mod waves) + 1; each time round the list it is faster
on Wave.StartLevel pLevel
   local tM, w, tRound
   put pLevel into sLevel
   put ((pLevel - 1) mod sWaveN) + 1 into w
   put (pLevel - 1) div sWaveN into tRound
   Scene.ClearAll
   Particles.Clear
   put empty into sShot
   put empty into sBomb
   put empty into sFoe
   put 0 into sCool
   put 0 into sDeadT
   put Mesh.New() into tM
   Vec.Decor tM, sCfg["floor"], sCfg["hw"], sCfg["hh"], sCfg["grid"]
   if tM["count"] > 0 then
      Mesh.Define "Wave.Floor", tM
      get Entity.Spawn("Wave.Floor", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["hw"], -sCfg["hh"], sCfg["hw"], sCfg["hh"]
   Mesh.Define "Wave.Frame", tM
   get Entity.Spawn("Wave.Frame", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   Mesh.Define "Wave.Ship", Vec.Shape(sCfg["shipShape"], sCfg["shipSize"])
   put Mesh.New() into tM
   Vec.Line tM, 0, -7, 0, 7
   Mesh.Define "Wave.Shot", tM
   put Mesh.New() into tM
   Vec.Outline tM, "0,-6" & cr & "4,0" & cr & "0,6" & cr & "-4,0"
   Mesh.Define "Wave.Bomb", tM
   put Mesh.New() into tM
   Vec.Rect tM, -sCfg["cell"] / 2, -sCfg["cell"] / 2, sCfg["cell"] / 2, sCfg["cell"] / 2
   Mesh.Define "Wave.Cell", tM
   Mesh.Define "Wave.Foe" & w, Vec.Shape(sWave[w]["shape"], sWave[w]["size"])
   put 0 into sShip["x"]
   put sCfg["hh"] - 30 into sShip["y"]
   put Entity.Spawn("Wave.Ship", 0, sCfg["cy"] + sShip["y"], kZ, sCfg["shipColor"]) into sShip["key"]
   Wave.BuildShields
   put sWave[w]["speed"] * (1 + sCfg["roundGain"] * tRound) into sNow["speed"]
   put sWave[w]["fire"] * (1 + sCfg["roundGain"] * tRound) into sNow["fire"]
   put sWave[w]["dive"] * (1 + sCfg["roundGain"] * tRound) into sNow["dive"]
   put w into sNow["wave"]
   Wave.BuildFormation w
   Wave.Say "WAVE" && pLevel & ": " & toUpper(sWave[w]["formation"]), 70
end Wave.StartLevel

-- where each foe sits in its formation (offsets from the formation's middle)
on Wave.BuildFormation pW
   local r, c, tRows, tCols, tSX, tSY, tX, tY, tWant, n, tMidC
   put sWave[pW]["rows"] into tRows
   put sWave[pW]["cols"] into tCols
   put sWave[pW]["size"] + sWave[pW]["gap"] into tSX
   put sWave[pW]["size"] * 0.9 + sWave[pW]["gap"] into tSY
   put (tCols + 1) / 2 into tMidC
   put 0 into n
   repeat with r = 1 to tRows
      repeat with c = 1 to tCols
         switch sWave[pW]["formation"]
            case "vee"
               -- two arms, wide at the top, meeting at the bottom row
               put abs(abs(c - tMidC) - (tRows - r) * (tCols - 1) / (2 * max(1, tRows - 1))) < 1 into tWant
               break
            case "diamond"
               put abs(c - tMidC) / tCols + abs(r - (tRows + 1) / 2) / tRows <= 0.5 into tWant
               break
            case "ragged"
               put (r * 7 + c * 3) mod 5 is not 0 into tWant
               break
            default
               put true into tWant
         end switch
         if not tWant then next repeat
         add 1 to n
         put (c - tMidC) * tSX into sFoe[n]["ox"]
         put (r - 1) * tSY into sFoe[n]["oy"]
         put "line" into sFoe[n]["mode"]
         put r into sFoe[n]["row"]
         put Entity.Spawn("Wave.Foe" & pW, 0, 0, kZ, sWave[pW]["color"][r]) into sFoe[n]["key"]
      end repeat
   end repeat
   put n into sFoeN
   put n into sAlive
   put 0 into sMarchX
   put 1 into sMarchDir
   put -sCfg["hh"] + 50 into sMarchY
   repeat with n = 1 to sFoeN
      put true into sFoe[n]["live"]
      Wave.PlaceFoe n
   end repeat
end Wave.BuildFormation

on Wave.BuildShields
   local s, r, c, tN, tX0, tY0, k
   put empty into sShield
   put 0 into k
   put sShip["y"] - 70 - sCfg["cell"] into sShieldTop
   put sShip["y"] - 70 + sCfg["shieldRows"] * sCfg["cell"] into sShieldBottom
   if sCfg["shields"] <= 0 then exit Wave.BuildShields
   repeat with s = 1 to sCfg["shields"]
      put -sCfg["hw"] + s * (2 * sCfg["hw"]) / (sCfg["shields"] + 1) into tX0
      put sShip["y"] - 70 into tY0
      repeat with r = 1 to sCfg["shieldRows"]
         repeat with c = 1 to sCfg["shieldCols"]
            add 1 to k
            put tX0 + (c - (sCfg["shieldCols"] + 1) / 2) * sCfg["cell"] into sShield[k]["x"]
            put tY0 + (r - 1) * sCfg["cell"] into sShield[k]["y"]
            put sCfg["shieldHits"] into sShield[k]["hp"]
            put Entity.Spawn("Wave.Cell", sShield[k]["x"], sCfg["cy"] + sShield[k]["y"], kZ, sCfg["shieldColor"]) into sShield[k]["key"]
         end repeat
      end repeat
   end repeat
end Wave.BuildShields

on Wave.PlaceFoe pN
   if sFoe[pN]["mode"] is "line" then
      put sMarchX + sFoe[pN]["ox"] into sFoe[pN]["x"]
      put sMarchY + sFoe[pN]["oy"] into sFoe[pN]["y"]
      if sWave[sNow["wave"]]["formation"] is "swarm" then
         add 10 * sin(sTick / 13 + pN) to sFoe[pN]["x"]
         add 6 * cos(sTick / 17 + pN * 2) to sFoe[pN]["y"]
      end if
   end if
   Entity.SetPosition sFoe[pN]["key"], sFoe[pN]["x"], sCfg["cy"] + sFoe[pN]["y"], kZ
end Wave.PlaceFoe

on Game.OnUpdate
   local tKeys
   add 1 to sTick
   put Vec.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 0 into sScore
         put sCfg["lives"] into sLives
         put false into sOver
         Wave.StartLevel 1
      end if
      Wave.ShowHUD
      exit Game.OnUpdate
   end if
   if sDeadT > 0 then
      subtract 1 from sDeadT
      if sDeadT = 0 then
         Wave.Respawn
      end if
   else
      Wave.MoveShip tKeys
   end if
   Wave.MoveShots
   Wave.March
   Wave.MoveBombs
   if sAlive = 0 and not sOver then
      add sCfg["waveBonus"] * sLevel to sScore
      if sCfg["levels"] > 0 and sLevel >= sCfg["levels"] then
         put true into sOver
         put true into sWonAll
      else
         Wave.StartLevel sLevel + 1
      end if
   end if
   if sMsgT > 0 then subtract 1 from sMsgT
   Wave.ShowHUD
end Game.OnUpdate

on Wave.MoveShip pKeys
   local tD, tFire, tTarget, tShots
   if sAuto is true then
      put Wave.AutoTarget() into tTarget
      put Wave.Dodge(tTarget) into tTarget
      put Vec.Clamp(tTarget - sShip["x"], -sCfg["shipSpeed"], sCfg["shipSpeed"]) into tD
      add tD to sShip["x"]
      put abs(tTarget - sShip["x"]) < 20 into tFire
   else
      put item 1 of Vec.Dir(sCfg["ctrl"], pKeys) into tD
      add tD * sCfg["shipSpeed"] to sShip["x"]
      put Vec.Fire(sCfg["ctrl"], pKeys) into tFire
   end if
   put Vec.Clamp(sShip["x"], -sCfg["hw"] + 20, sCfg["hw"] - 20) into sShip["x"]
   Entity.SetPosition sShip["key"], sShip["x"], sCfg["cy"] + sShip["y"], kZ
   if sCool > 0 then subtract 1 from sCool
   put Wave.Count(sShot) into tShots
   if tFire and sCool = 0 and tShots < sCfg["maxShots"] then
      add 1 to sShotSeq
      put sShip["x"] into sShot[sShotSeq]["x"]
      put sShip["y"] - sCfg["shipSize"] / 2 into sShot[sShotSeq]["y"]
      put Entity.Spawn("Wave.Shot", sShip["x"], sCfg["cy"] + sShot[sShotSeq]["y"], kZ, sCfg["shotColor"]) into sShot[sShotSeq]["key"]
      put sCfg["coolSteps"] into sCool
      Sound.Play "shot"
   end if
end Wave.MoveShip

-- tests and the demo: where to be to hit the lowest living foe, leading it by its march
function Wave.AutoTarget
   local n, tY, tX, tSpeed, tSteps
   put -9999 into tY
   put 0 into tX
   repeat with n = 1 to sFoeN
      if sFoe[n]["live"] and sFoe[n]["y"] > tY then
         put sFoe[n]["y"] into tY
         put sFoe[n]["x"] into tX
         if sFoe[n]["mode"] is "line" then
            put sNow["speed"] * (1 + sCfg["rush"] * (1 - sAlive / sFoeN)) into tSpeed
            put (sShip["y"] - sFoe[n]["y"]) / sCfg["shotSpeed"] into tSteps
            add sMarchDir * tSpeed * tSteps to tX
         end if
      end if
   end repeat
   return Vec.Clamp(tX, -sCfg["hw"] + 20, sCfg["hw"] - 20)
end Wave.AutoTarget

-- the autopilot steps aside from a bomb coming down on it
function Wave.Dodge pTarget
   local k, tNear
   put sCfg["shipSize"] + 10 into tNear
   repeat for each key k in sBomb
      if sBomb[k]["y"] > sShip["y"] - 160 and sBomb[k]["y"] < sShip["y"] and abs(sBomb[k]["x"] - sShip["x"]) < tNear then
         if sBomb[k]["x"] < sShip["x"] or sShip["x"] < -sCfg["hw"] + 60 then
            if sShip["x"] < sCfg["hw"] - 60 then return sBomb[k]["x"] + tNear * 1.5
         end if
         return sBomb[k]["x"] - tNear * 1.5
      end if
   end repeat
   return pTarget
end Wave.Dodge

on Wave.TestAuto pOn
   put pOn into sAuto
end Wave.TestAuto

on Wave.MoveShots
   local k, tKeys, n, tHalf
   put the keys of sShot into tKeys
   repeat for each line k in tKeys
      subtract sCfg["shotSpeed"] from sShot[k]["y"]
      if sShot[k]["y"] < -sCfg["hh"] then
         Wave.EndShot k
         next repeat
      end if
      if Wave.ShieldAt(sShot[k]["x"], sShot[k]["y"]) then
         Wave.EndShot k
         next repeat
      end if
      repeat with n = 1 to sFoeN
         if not sFoe[n]["live"] then next repeat
         put sWave[sNow["wave"]]["size"] / 2 + 2 into tHalf
         if abs(sFoe[n]["x"] - sShot[k]["x"]) <= tHalf and abs(sFoe[n]["y"] - sShot[k]["y"]) <= tHalf + 6 then
            Wave.KillFoe n
            Wave.EndShot k
            exit repeat
         end if
      end repeat
      if sShot[k] is an array then Entity.SetPosition sShot[k]["key"], sShot[k]["x"], sCfg["cy"] + sShot[k]["y"], kZ
   end repeat
end Wave.MoveShots

on Wave.EndShot pK
   Entity.Kill sShot[pK]["key"]
   delete variable sShot[pK]
end Wave.EndShot

on Wave.KillFoe pN
   put false into sFoe[pN]["live"]
   Entity.Kill sFoe[pN]["key"]
   FX.Sparks sFoe[pN]["x"], sCfg["cy"] + sFoe[pN]["y"], kZ, 12, sCfg["shotColor"]
   Sound.Play "boom"
   subtract 1 from sAlive
   if sFoe[pN]["mode"] is "dive" then
      add sWave[sNow["wave"]]["points"] * 3 to sScore
   else
      add sWave[sNow["wave"]]["points"] to sScore
   end if
end Wave.KillFoe

-- the formation marches; at a wall it steps down and turns; fewer left, faster it goes
on Wave.March
   local n, tMin, tMax, tSpeed, tDiveFrom
   if sAlive <= 0 then exit Wave.March
   put sNow["speed"] * (1 + sCfg["rush"] * (1 - sAlive / sFoeN)) into tSpeed
   add sMarchDir * tSpeed to sMarchX
   put 9999 into tMin
   put -9999 into tMax
   repeat with n = 1 to sFoeN
      if sFoe[n]["live"] and sFoe[n]["mode"] is "line" then
         put min(tMin, sMarchX + sFoe[n]["ox"]) into tMin
         put max(tMax, sMarchX + sFoe[n]["ox"]) into tMax
      end if
   end repeat
   if tMax + sWave[sNow["wave"]]["size"] / 2 > sCfg["hw"] - 10 and sMarchDir > 0 then
      put -1 into sMarchDir
      add sWave[sNow["wave"]]["drop"] to sMarchY
   else if tMin - sWave[sNow["wave"]]["size"] / 2 < -sCfg["hw"] + 10 and sMarchDir < 0 then
      put 1 into sMarchDir
      add sWave[sNow["wave"]]["drop"] to sMarchY
   end if
   repeat with n = 1 to sFoeN
      if not sFoe[n]["live"] then next repeat
      if sFoe[n]["mode"] is "dive" then
         Wave.Dive n
      else
         Wave.PlaceFoe n
         if random(100000) <= sNow["fire"] * 100000 then Wave.DropBomb sFoe[n]["x"], sFoe[n]["y"]
      end if
      if sFoe[n]["live"] and sFoe[n]["y"] >= sShip["y"] - 10 and sFoe[n]["mode"] is "line" then
         -- they reached you
         put 1 into sLives
         Wave.HitShip
         exit Wave.March
      end if
   end repeat
   -- one roll a step: does a foe (any one still in line) dive?
   if random(100000) <= sNow["dive"] * 100000 then
      put random(sFoeN) into n
      if sFoe[n]["live"] and sFoe[n]["mode"] is "line" then put n into tDiveFrom
   end if
   if tDiveFrom is not empty then
      put "dive" into sFoe[tDiveFrom]["mode"]
      put 0 into sFoe[tDiveFrom]["t"]
      put sFoe[tDiveFrom]["x"] into sFoe[tDiveFrom]["x0"]
   end if
end Wave.March

-- a diver swoops down at where the ship is, then comes back in at the top
on Wave.Dive pN
   local tSpeed
   add 1 to sFoe[pN]["t"]
   put sNow["speed"] * 2.2 + 2 into tSpeed
   add tSpeed to sFoe[pN]["y"]
   add Vec.Clamp((sShip["x"] - sFoe[pN]["x"]) * 0.04, -3, 3) + 3 * sin(sFoe[pN]["t"] / 8) to sFoe[pN]["x"]
   if sFoe[pN]["t"] mod 25 = 0 then Wave.DropBomb sFoe[pN]["x"], sFoe[pN]["y"]
   if sDeadT = 0 and abs(sFoe[pN]["x"] - sShip["x"]) < sCfg["shipSize"] / 2 + 6 and abs(sFoe[pN]["y"] - sShip["y"]) < sCfg["shipSize"] / 2 + 6 then
      Wave.KillFoe pN
      Wave.HitShip
      exit Wave.Dive
   end if
   if sFoe[pN]["y"] > sCfg["hh"] + 20 then
      put "line" into sFoe[pN]["mode"]
   end if
   Entity.SetPosition sFoe[pN]["key"], sFoe[pN]["x"], sCfg["cy"] + sFoe[pN]["y"], kZ
end Wave.Dive

on Wave.DropBomb pX, pY
   -- never more than a few in the air: 3, and one more each time round the waves
   if Wave.Count(sBomb) >= 3 + (sLevel - 1) div sWaveN then exit Wave.DropBomb
   add 1 to sBombSeq
   put pX into sBomb[sBombSeq]["x"]
   put pY + 8 into sBomb[sBombSeq]["y"]
   put Entity.Spawn("Wave.Bomb", pX, sCfg["cy"] + pY + 8, kZ, sCfg["bombColor"]) into sBomb[sBombSeq]["key"]
end Wave.DropBomb

on Wave.MoveBombs
   local k, tKeys
   put the keys of sBomb into tKeys
   repeat for each line k in tKeys
      add sCfg["bombSpeed"] to sBomb[k]["y"]
      if sBomb[k]["y"] > sCfg["hh"] or Wave.ShieldAt(sBomb[k]["x"], sBomb[k]["y"]) then
         Entity.Kill sBomb[k]["key"]
         delete variable sBomb[k]
         next repeat
      end if
      if sDeadT = 0 and abs(sBomb[k]["x"] - sShip["x"]) < sCfg["shipSize"] / 2 and abs(sBomb[k]["y"] - sShip["y"]) < sCfg["shipSize"] / 2 then
         Entity.Kill sBomb[k]["key"]
         delete variable sBomb[k]
         Wave.HitShip
         next repeat
      end if
      Entity.SetPosition sBomb[k]["key"], sBomb[k]["x"], sCfg["cy"] + sBomb[k]["y"], kZ
   end repeat
end Wave.MoveBombs

-- true when a shield cell is at x,y (and it takes the hit)
function Wave.ShieldAt pX, pY
   local k, tH
   if sShield is not an array or pY < sShieldTop or pY > sShieldBottom then return false
   put sCfg["cell"] / 2 + 1 into tH
   repeat for each key k in sShield
      if sShield[k]["hp"] <= 0 then next repeat
      if abs(sShield[k]["x"] - pX) <= tH and abs(sShield[k]["y"] - pY) <= tH + 3 then
         subtract 1 from sShield[k]["hp"]
         if sShield[k]["hp"] <= 0 then Entity.Kill sShield[k]["key"]
         return true
      end if
   end repeat
   return false
end Wave.ShieldAt

on Wave.HitShip
   FX.Sparks sShip["x"], sCfg["cy"] + sShip["y"], kZ, 30, sCfg["shipColor"]
   Sound.Play "boom"
   subtract 1 from sLives
   Entity.Kill sShip["key"]
   if sLives <= 0 then
      put true into sOver
      put false into sWonAll
      put empty into sHUDWas
      exit Wave.HitShip
   end if
   put 60 into sDeadT
   Wave.Say "SHIP LOST", 60
end Wave.HitShip

on Wave.Respawn
   local k, tKeys
   put the keys of sBomb into tKeys
   repeat for each line k in tKeys
      Entity.Kill sBomb[k]["key"]
   end repeat
   put empty into sBomb
   put 0 into sShip["x"]
   put Entity.Spawn("Wave.Ship", 0, sCfg["cy"] + sShip["y"], kZ, sCfg["shipColor"]) into sShip["key"]
end Wave.Respawn

on Wave.Say pText, pSteps
   put pText into sMsg
   put pSteps into sMsgT
   put empty into sHUDWas
end Wave.Say

on Wave.ShowHUD
   local tWords, tLevels
   put sLevel & "|" & sScore & "|" & sLives & "|" & sOver & "|" & (sMsgT > 0) into tWords
   if tWords is sHUDWas then exit Wave.ShowHUD
   put tWords into sHUDWas
   if sCfg["levels"] > 0 then
      put sLevel & "/" & sCfg["levels"] into tLevels
   else
      put sLevel into tLevels
   end if
   HUD.Set "Wave.Score", sCfg["title"] & "   SCORE" && sScore && "  SHIPS" && sLives && "  WAVE" && tLevels, 20, 30, 14
   HUD.Remove "Wave.Msg"
   if sOver and sWonAll then
      HUD.Set "Wave.Msg", "EVERY WAVE BEATEN. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Wave.Msg", "GAME OVER. SCORE" && sScore & ". SPACE TO PLAY AGAIN", 20, 56, 12
   else if sMsgT > 0 then
      HUD.Set "Wave.Msg", sMsg & "    " & sCfg["help"], 20, 56, 12
   end if
end Wave.ShowHUD

-- for tests: wave|ships|score|foes left|shots|bombs|over
function Wave.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sAlive & "|" & Wave.Count(sShot) & "|" & Wave.Count(sBomb) & "|" & sOver
end Wave.State

function Wave.Count pArr
   local tKeys
   if pArr is not an array then return 0
   put the keys of pArr into tKeys
   return the number of lines of tKeys
end Wave.Count

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

## PART config (generated by the Build node)
on Wave.Config
   put empty into sCfg
   put empty into sWave
   put "COMFY WAVES" into sCfg["title"]
   put "ARROWS MOVE  SPACE FIRES" into sCfg["help"]
   put 360 into sCfg["hw"]
   put 230 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put "stars" into sCfg["floor"]
   put 37 into sCfg["grid"]
   put "229,180,114" into sCfg["wallColor"]
   put "91,72,45" into sCfg["decoColor"]
   put "arrows" into sCfg["ctrl"]
   put "diamond" into sCfg["shipShape"]
   put 29 into sCfg["shipSize"]
   put 5.213 into sCfg["shipSpeed"]
   put 14 into sCfg["coolSteps"]
   put 10.127 into sCfg["shotSpeed"]
   put 2 into sCfg["maxShots"]
   put "255,233,204" into sCfg["shipColor"]
   put "255,255,255" into sCfg["shotColor"]
   put "204,125,20" into sCfg["bombColor"]
   put 4 into sCfg["bombSpeed"]
   put 4 into sCfg["shields"]
   put 6 into sCfg["shieldCols"]
   put 3 into sCfg["shieldRows"]
   put 9 into sCfg["cell"]
   put 2 into sCfg["shieldHits"]
   put "89,66,35" into sCfg["shieldColor"]
   put 3 into sCfg["lives"]
   put 0 into sCfg["levels"]
   put 0.275 into sCfg["roundGain"]
   put 1.935 into sCfg["rush"]
   put 100 into sCfg["waveBonus"]
   put 3 into sWaveN
   put "block" into sWave[1]["formation"]
   put "crab" into sWave[1]["shape"]
   put 4 into sWave[1]["rows"]
   put 8 into sWave[1]["cols"]
   put 27 into sWave[1]["size"]
   put 11 into sWave[1]["gap"]
   put 1.0 into sWave[1]["speed"]
   put 14 into sWave[1]["drop"]
   put 0.002 into sWave[1]["fire"]
   put 0.0 into sWave[1]["dive"]
   put 14 into sWave[1]["points"]
   put "204,125,20" into sWave[1]["color"][1]
   put "212,143,51" into sWave[1]["color"][2]
   put "220,161,82" into sWave[1]["color"][3]
   put "229,180,114" into sWave[1]["color"][4]
   put "block" into sWave[2]["formation"]
   put "tri" into sWave[2]["shape"]
   put 5 into sWave[2]["rows"]
   put 10 into sWave[2]["cols"]
   put 30 into sWave[2]["size"]
   put 9 into sWave[2]["gap"]
   put 1.461 into sWave[2]["speed"]
   put 14 into sWave[2]["drop"]
   put 0.004 into sWave[2]["fire"]
   put 0.001 into sWave[2]["dive"]
   put 25 into sWave[2]["points"]
   put "204,125,20" into sWave[2]["color"][1]
   put "210,138,43" into sWave[2]["color"][2]
   put "216,152,67" into sWave[2]["color"][3]
   put "222,166,90" into sWave[2]["color"][4]
   put "229,180,114" into sWave[2]["color"][5]
   put "block" into sWave[3]["formation"]
   put "diamond" into sWave[3]["shape"]
   put 3 into sWave[3]["rows"]
   put 6 into sWave[3]["cols"]
   put 21 into sWave[3]["size"]
   put 11 into sWave[3]["gap"]
   put 2.173 into sWave[3]["speed"]
   put 8 into sWave[3]["drop"]
   put 0.004 into sWave[3]["fire"]
   put 0.005 into sWave[3]["dive"]
   put 29 into sWave[3]["points"]
   put "204,125,20" into sWave[3]["color"][1]
   put "216,152,67" into sWave[3]["color"][2]
   put "229,180,114" into sWave[3]["color"][3]
end Wave.Config
