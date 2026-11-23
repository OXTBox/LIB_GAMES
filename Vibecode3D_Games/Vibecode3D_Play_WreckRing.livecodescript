######################################################################################
## CARD SCRIPT: "Play.WreckRing"   WRECK RING  (11 14 2026)
## A demolition arena seen from above: a lava pit in the middle, ramps around it,
## power-ups on the floor. Every car drives on by itself; you steer. Ram the others
## until yours is the last car moving. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/792_Wreck_Ring), script by Claude.
## CONTROLS  Left/Right (or A/D): steer    Space (or Up): boost    Escape: pause
## RULES     hitting a car nose-first hurts it far more than you. Walls hurt a little,
##           lava a lot (jump it from a grey ramp: landing on a car crushes it).
##           Cyan rocket +20 health and a burst of speed, green repair +50, orange mine
##           -30. Health 0: wrecked. Last car moving wins the round and the next arena
##           has more cars (5 rounds). Wrecked yourself: a life, and the round again.
######################################################################################

global bPaused, bPlaying

local sCar, sCarN, sPow, sPowN, sRamp, sNextPow, sLevel, sLives, sScore, sOver, sWon
local sBase, sMsg, sMsgT, sEndT, sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 380            -- screen scale 300/z: 0.79 px a unit
constant kCY = 40            -- the arena's middle
constant kR = 330            -- the arena wall
constant kLavaR = 70
constant kCarR = 20

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
   Wreck.StartLevel 1
end Game.OnStart

-- Spark's table: speed | cars
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Wreck.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Wreck.StartLevel pLevel
   end if
end Wreck.GoLevel

on Wreck.StartLevel pLevel
   local tRow, i, tA, tN
   put pLevel into sLevel
   put line pLevel of ("100,2" & cr & "110,2" & cr & "120,3" & cr & "130,3" & cr & "140,4") into tRow
   put (item 1 of tRow) / 33 into sBase
   Scene.ClearAll
   Mesh.Define "Wreck.Car", Wreck.CarMesh()
   Mesh.Define "Wreck.Wall", Wreck.RingMesh(kR + 12, 24, 0)
   Mesh.Define "Wreck.Lava", Wreck.RingMesh(kLavaR, 12, 14)
   Mesh.Define "Wreck.Ramp", Wreck.RampMesh()
   Mesh.Define "Wreck.Rocket", Mesh.Pyramid(3, 12, 30)
   Mesh.Define "Wreck.Repair", Wreck.CrossMesh()
   Mesh.Define "Wreck.Mine", Mesh.Pyramid(6, 16, 10)
   get Entity.Spawn("Wreck.Wall", 0, kCY, kZ, "180,180,200")
   get Entity.Spawn("Wreck.Lava", 0, kCY, kZ + 1, "255,60,0")
   -- ramps: on the ring around the pit, pointing at it
   put empty into sRamp
   repeat with i = 1 to 4
      put i * 3.14159 / 2 + 0.785 into tA
      put 190 * cos(tA) into sRamp[i]["x"]
      put kCY + 190 * sin(tA) into sRamp[i]["y"]
      put Entity.Spawn("Wreck.Ramp", sRamp[i]["x"], sRamp[i]["y"], kZ, "150,150,170") into sRamp[i]["key"]
      Entity.SetRotation sRamp[i]["key"], 0, 0, tA + 3.14159
   end repeat
   -- the cars: you are car 1
   put empty into sCar
   put 1 + item 2 of tRow into sCarN
   repeat with i = 1 to sCarN
      put i * 2 * 3.14159 / sCarN into tA
      put 260 * cos(tA) into sCar[i]["x"]
      put kCY + 260 * sin(tA) into sCar[i]["y"]
      put tA + 3.14159 / 2 into sCar[i]["ang"]
      put 0 into sCar[i]["vx"]
      put 0 into sCar[i]["vy"]
      put 100 into sCar[i]["hp"]
      put 0 into sCar[i]["air"]
      put 0 into sCar[i]["boost"]
      put 0 into sCar[i]["hit"]
      put true into sCar[i]["alive"]
      if i is 1 then
         put Entity.Spawn("Wreck.Car", sCar[i]["x"], sCar[i]["y"], kZ, "0,230,255") into sCar[i]["key"]
      else
         set the itemDel to "|"
         put Entity.Spawn("Wreck.Car", sCar[i]["x"], sCar[i]["y"], kZ, item i - 1 of "255,60,60|255,200,0|200,80,255|80,255,80") into sCar[i]["key"]
         set the itemDel to comma
      end if
   end repeat
   put empty into sPow
   put 0 into sPowN
   put 60 into sNextPow
   put 0 into sEndT
   put "ROUND" && pLevel & ": BE THE LAST CAR MOVING" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Wreck.StartLevel

function Wreck.CarMesh
   local tM
   put Mesh.New() into tM
   Wreck.AddBox tM, 0, 0, 0, 40, 24, 12
   Wreck.AddBox tM, -4, 0, -7, 16, 18, 4
   Wreck.AddBox tM, 22, 0, 0, 6, 28, 8              -- the ram bar at the nose
   return tM
end Wreck.CarMesh

function Wreck.RingMesh pR, pN, pZig
   local tM, i, tA, tR
   put Mesh.New() into tM
   repeat with i = 0 to pN - 1
      put i * 2 * 3.14159 / pN into tA
      put pR + pZig * (i mod 2) into tR
      Mesh.AddVertex tM, tR * cos(tA), tR * sin(tA), 0
   end repeat
   repeat with i = 1 to pN
      Mesh.AddLine tM, i, (i mod pN) + 1
   end repeat
   if pZig > 0 then
      repeat with i = 0 to 5
         put i * 3.14159 / 3 into tA
         Mesh.AddVertex tM, pR * 0.5 * cos(tA), pR * 0.5 * sin(tA), 0
      end repeat
      repeat with i = 1 to 6
         Mesh.AddLine tM, pN + i, pN + (i mod 6) + 1
      end repeat
   end if
   return tM
end Wreck.RingMesh

-- a ramp: a wedge with an arrow on it (it points along +x before turning)
function Wreck.RampMesh
   local tM
   put Mesh.New() into tM
   Wreck.AddBox tM, 0, 0, 0, 50, 46, 4
   Mesh.AddVertex tM, -16, -12, -4
   Mesh.AddVertex tM, 14, 0, -4
   Mesh.AddVertex tM, -16, 12, -4
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   return tM
end Wreck.RampMesh

function Wreck.CrossMesh
   local tM
   put Mesh.New() into tM
   Wreck.AddBox tM, 0, 0, 0, 30, 10, 8
   Wreck.AddBox tM, 0, 0, 0, 10, 30, 8
   return tM
end Wreck.CrossMesh

on Wreck.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Wreck.AddBox

function Wreck.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Wreck.Keys

on Wreck.TestKeys pKeys
   put pKeys into sTestKeys
end Wreck.TestKeys

on Wreck.TestHP pN
   put pN into sCar[1]["hp"]
end Wreck.TestHP

function Wreck.Down pCode, pKeys
   return pCode is among the items of pKeys
end Wreck.Down

on Game.OnUpdate
   local tKeys, i, tTurn, tBoost, tAlive, tLast
   put Wreck.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Wreck.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Wreck.GoLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put tKeys into sKeysWas
   -- the round is decided: a short pause, then on
   if sEndT > 0 then
      subtract 1 from sEndT
      if sEndT is 0 then Wreck.EndRound
      Wreck.Draw
      exit Game.OnUpdate
   end if
   -- you
   put 0 into tTurn
   if Wreck.Down(65361, tKeys) or Wreck.Down(97, tKeys) then put -1 into tTurn
   if Wreck.Down(65363, tKeys) or Wreck.Down(100, tKeys) then put 1 into tTurn
   put Wreck.Down(32, tKeys) or Wreck.Down(65362, tKeys) or Wreck.Down(119, tKeys) into tBoost
   if sCar[1]["alive"] then Wreck.Drive 1, tTurn, tBoost
   -- the others
   repeat with i = 2 to sCarN
      if sCar[i]["alive"] then Wreck.Think i
   end repeat
   Wreck.Bumps
   Wreck.PowerUps
   -- who is still moving?
   put 0 into tAlive
   repeat with i = 1 to sCarN
      if sCar[i]["alive"] then
         add 1 to tAlive
         put i into tLast
      end if
   end repeat
   if not sCar[1]["alive"] then
      put 50 into sEndT
      put "WRECKED!" into sMsg
      put 50 into sMsgT
   else if tAlive is 1 then
      put 50 into sEndT
      put "LAST CAR MOVING!" into sMsg
      put 50 into sMsgT
   end if
   Wreck.Draw
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Wreck.ShowHUD
end Game.OnUpdate

-- every car rolls on by itself; pTurn steers, pBoost speeds it up
on Wreck.Drive pC, pTurn, pBoost
   local tV, tD
   if sCar[pC]["air"] > 0 then
      -- in the air: no steering, no lava
      subtract 1 from sCar[pC]["air"]
      if sCar[pC]["air"] is 0 then
         Wreck.Land pC
      end if
   else
      add pTurn * 0.09 to sCar[pC]["ang"]
   end if
   put sBase into tV
   if pBoost then put sBase * 1.6 into tV
   if sCar[pC]["boost"] > 0 then
      subtract 1 from sCar[pC]["boost"]
      put sBase * 2.2 into tV
   end if
   -- velocity eases toward where the car points (so bumps carry it off a while)
   put sCar[pC]["vx"] * 0.85 + cos(sCar[pC]["ang"]) * tV * 0.15 into sCar[pC]["vx"]
   put sCar[pC]["vy"] * 0.85 + sin(sCar[pC]["ang"]) * tV * 0.15 into sCar[pC]["vy"]
   add sCar[pC]["vx"] to sCar[pC]["x"]
   add sCar[pC]["vy"] to sCar[pC]["y"]
   if sCar[pC]["hit"] > 0 then subtract 1 from sCar[pC]["hit"]
   -- the wall
   put sqrt(sCar[pC]["x"] ^ 2 + (sCar[pC]["y"] - kCY) ^ 2) into tD
   if tD > kR - kCarR then
      put sCar[pC]["x"] * (kR - kCarR) / tD into sCar[pC]["x"]
      put kCY + (sCar[pC]["y"] - kCY) * (kR - kCarR) / tD into sCar[pC]["y"]
      put -sCar[pC]["x"] / tD * 4 into sCar[pC]["vx"]
      put -(sCar[pC]["y"] - kCY) / tD * 4 into sCar[pC]["vy"]
      add 2.2 to sCar[pC]["ang"]
      Wreck.Damage pC, 3
   end if
   -- the lava burns
   if tD < kLavaR and sCar[pC]["air"] <= 0 then
      Wreck.Damage pC, 1.5
      if sTicks mod 4 is 0 then FX.Sparks sCar[pC]["x"], sCar[pC]["y"], kZ, 3, "255,100,0"
   end if
   -- ramps launch you over the pit
   if sCar[pC]["air"] <= 0 then
      repeat for each key tD in sRamp
         if abs(sRamp[tD]["x"] - sCar[pC]["x"]) < 26 and abs(sRamp[tD]["y"] - sCar[pC]["y"]) < 26 then
            put 28 into sCar[pC]["air"]
            put sCar[pC]["vx"] * 1.8 into sCar[pC]["vx"]
            put sCar[pC]["vy"] * 1.8 into sCar[pC]["vy"]
            exit repeat
         end if
      end repeat
   end if
end Wreck.Drive

-- the others: chase the nearest car, fetch a repair when hurt, steer off the lava
on Wreck.Think pC
   local tBest, tBD, j, tD, tTX, tTY, tWant, tDiff, tPit
   put 999999 into tBD
   repeat with j = 1 to sCarN
      if j is pC or not sCar[j]["alive"] then next repeat
      put (sCar[j]["x"] - sCar[pC]["x"]) ^ 2 + (sCar[j]["y"] - sCar[pC]["y"]) ^ 2 into tD
      if tD < tBD then
         put tD into tBD
         put sCar[j]["x"] into tTX
         put sCar[j]["y"] into tTY
      end if
   end repeat
   if sCar[pC]["hp"] < 40 then
      repeat for each key j in sPow
         if sPow[j]["kind"] is "repair" then
            put sPow[j]["x"] into tTX
            put sPow[j]["y"] into tTY
         end if
      end repeat
   end if
   if tTX is empty then
      put 0 into tTX
      put kCY into tTY
   end if
   put atan2(tTY - sCar[pC]["y"], tTX - sCar[pC]["x"]) into tWant
   -- the pit: if the way ahead runs near it, aim to one side
   put sqrt(sCar[pC]["x"] ^ 2 + (sCar[pC]["y"] - kCY) ^ 2) into tPit
   if tPit < kLavaR + 70 and sCar[pC]["air"] <= 0 then
      put atan2(sCar[pC]["y"] - kCY, sCar[pC]["x"]) into tWant
   end if
   put tWant - sCar[pC]["ang"] into tDiff
   repeat while tDiff > 3.14159
      subtract 6.28318 from tDiff
   end repeat
   repeat while tDiff < -3.14159
      add 6.28318 to tDiff
   end repeat
   Wreck.Drive pC, max(-1, min(1, tDiff * (0.5 + sLevel * 0.12))), sLevel >= 3 and abs(tDiff) < 0.3 and random(4) is 1
end Wreck.Think

-- car against car: the one hit side-on takes the damage
on Wreck.Bumps
   local i, j, tDX, tDY, tD, tNX, tNY, tHitI, tHitJ, tSpeed
   repeat with i = 1 to sCarN - 1
      if not sCar[i]["alive"] or sCar[i]["air"] > 0 then next repeat
      repeat with j = i + 1 to sCarN
         if not sCar[j]["alive"] or sCar[j]["air"] > 0 then next repeat
         put sCar[j]["x"] - sCar[i]["x"] into tDX
         put sCar[j]["y"] - sCar[i]["y"] into tDY
         put sqrt(tDX ^ 2 + tDY ^ 2) into tD
         if tD >= 2 * kCarR or tD is 0 then next repeat
         put tDX / tD into tNX
         put tDY / tD into tNY
         -- how squarely each nose points at the other
         put cos(sCar[i]["ang"]) * tNX + sin(sCar[i]["ang"]) * tNY into tHitI
         put -(cos(sCar[j]["ang"]) * tNX + sin(sCar[j]["ang"]) * tNY) into tHitJ
         put sqrt((sCar[i]["vx"] - sCar[j]["vx"]) ^ 2 + (sCar[i]["vy"] - sCar[j]["vy"]) ^ 2) into tSpeed
         if sCar[i]["hit"] <= 0 and sCar[j]["hit"] <= 0 then
            Wreck.Damage j, 4 + tSpeed * 3 * max(0.2, tHitI)
            Wreck.Damage i, 4 + tSpeed * 3 * max(0.2, tHitJ)
            put 10 into sCar[i]["hit"]
            put 10 into sCar[j]["hit"]
            FX.Sparks (sCar[i]["x"] + sCar[j]["x"]) / 2, (sCar[i]["y"] + sCar[j]["y"]) / 2, kZ, 10, "255,220,120"
            if i is 1 then add round(tSpeed * 10 * max(0.2, tHitI)) to sScore
         end if
         -- push apart
         put sCar[i]["x"] - tNX * (2 * kCarR - tD) / 2 into sCar[i]["x"]
         put sCar[i]["y"] - tNY * (2 * kCarR - tD) / 2 into sCar[i]["y"]
         put sCar[j]["x"] + tNX * (2 * kCarR - tD) / 2 into sCar[j]["x"]
         put sCar[j]["y"] + tNY * (2 * kCarR - tD) / 2 into sCar[j]["y"]
         subtract tNX * 3 from sCar[i]["vx"]
         subtract tNY * 3 from sCar[i]["vy"]
         add tNX * 3 to sCar[j]["vx"]
         add tNY * 3 to sCar[j]["vy"]
      end repeat
   end repeat
end Wreck.Bumps

-- landing from a ramp jump on top of a car crushes it
on Wreck.Land pC
   local j
   repeat with j = 1 to sCarN
      if j is pC or not sCar[j]["alive"] then next repeat
      if abs(sCar[j]["x"] - sCar[pC]["x"]) < 34 and abs(sCar[j]["y"] - sCar[pC]["y"]) < 34 then
         Wreck.Damage j, 40
         FX.Sparks sCar[j]["x"], sCar[j]["y"], kZ, 16, "255,255,255"
         if pC is 1 then
            add 200 to sScore
            put "CRUSHED!" into sMsg
            put 30 into sMsgT
         end if
      end if
   end repeat
end Wreck.Land

on Wreck.Damage pC, pN
   subtract pN from sCar[pC]["hp"]
   if sCar[pC]["hp"] <= 0 and sCar[pC]["alive"] then
      put 0 into sCar[pC]["hp"]
      put false into sCar[pC]["alive"]
      FX.Sparks sCar[pC]["x"], sCar[pC]["y"], kZ, 26, "255,120,40"
      Entity.SetRotation sCar[pC]["key"], 0.5, 0.4, sCar[pC]["ang"]
      if pC > 1 then add 300 * sLevel to sScore
   end if
   put empty into sHUDWas
end Wreck.Damage

on Wreck.PowerUps
   local tK, tA, tD, tKind, i
   subtract 1 from sNextPow
   if sNextPow <= 0 and the number of lines of the keys of sPow < 4 then
      put 70 + random(60) into sNextPow
      put random(100) into i
      if i <= 35 then
         put "rocket,Wreck.Rocket,0,230,255" into tKind
      else if i <= 65 then
         put "repair,Wreck.Repair,0,255,100" into tKind
      else
         put "mine,Wreck.Mine,255,150,0" into tKind
      end if
      put random(628) / 100 into tA
      put kLavaR + 50 + random(kR - kLavaR - 90) into tD
      add 1 to sPowN
      put item 1 of tKind into sPow[sPowN]["kind"]
      put tD * cos(tA) into sPow[sPowN]["x"]
      put kCY + tD * sin(tA) into sPow[sPowN]["y"]
      put Entity.Spawn(item 2 of tKind, sPow[sPowN]["x"], sPow[sPowN]["y"], kZ, item 3 to 5 of tKind) into sPow[sPowN]["key"]
   end if
   repeat for each key tK in sPow
      Entity.SetRotation sPow[tK]["key"], 0, 0, sTicks / 10
      repeat with i = 1 to sCarN
         if not sCar[i]["alive"] or sCar[i]["air"] > 0 then next repeat
         if abs(sPow[tK]["x"] - sCar[i]["x"]) < 26 and abs(sPow[tK]["y"] - sCar[i]["y"]) < 26 then
            switch sPow[tK]["kind"]
               case "rocket"
                  put min(100, sCar[i]["hp"] + 20) into sCar[i]["hp"]
                  put 45 into sCar[i]["boost"]
                  break
               case "repair"
                  put min(100, sCar[i]["hp"] + 50) into sCar[i]["hp"]
                  break
               case "mine"
                  Wreck.Damage i, 30
                  FX.Sparks sPow[tK]["x"], sPow[tK]["y"], kZ, 20, "255,150,0"
                  break
            end switch
            if i is 1 and sPow[tK]["kind"] is not "mine" then add 50 to sScore
            put empty into sHUDWas
            Entity.Kill sPow[tK]["key"]
            delete variable sPow[tK]
            exit repeat
         end if
      end repeat
   end repeat
end Wreck.PowerUps

on Wreck.Draw
   local i, tLift
   repeat with i = 1 to sCarN
      put 0 into tLift
      if sCar[i]["air"] > 0 then put 80 * sin(3.14159 * sCar[i]["air"] / 28) into tLift
      Entity.SetPosition sCar[i]["key"], sCar[i]["x"], sCar[i]["y"], kZ - tLift
      if sCar[i]["alive"] then Entity.SetRotation sCar[i]["key"], 0, 0, sCar[i]["ang"]
   end repeat
end Wreck.Draw

on Wreck.EndRound
   if sCar[1]["alive"] then
      add 1000 * sLevel to sScore
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
         put empty into sHUDWas
         Wreck.ShowHUD
      else
         Wreck.GoLevel sLevel + 1
      end if
   else
      subtract 1 from sLives
      if sLives <= 0 then
         put true into sOver
         put empty into sHUDWas
         Wreck.ShowHUD
      else
         Wreck.StartLevel sLevel
      end if
   end if
end Wreck.EndRound

on Wreck.ShowHUD
   local tWords, tLine, i, tOthers
   put empty into tOthers
   repeat with i = 2 to sCarN
      put "  " & round(sCar[i]["hp"]) after tOthers
   end repeat
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & round(sCar[1]["hp"]) & "|" & tOthers & "|" & sMsg into tWords
   if tWords is sHUDWas then exit Wreck.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Wreck.Score", "SCORE" && sScore && " LIVES" && sLives && " ROUND" && sLevel & "/5  HEALTH" && round(sCar[1]["hp"]), 20, 40, 14
   if sOver and sWon then
      put "CHAMPION OF THE WRECK RING!  SPACE TO PLAY AGAIN" into tLine
   else if sOver then
      put "SCRAPPED.  SPACE TO PLAY AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else
      put "THE OTHERS:" & tOthers into tLine
   end if
   HUD.Set "Wreck.Msg", tLine, 20, 70, 12
end Wreck.ShowHUD

function Wreck.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver into tS
   repeat with i = 1 to sCarN
      put "|car" & i && round(sCar[i]["x"]) & "," & round(sCar[i]["y"]) && "hp" && round(sCar[i]["hp"]) && sCar[i]["alive"] after tS
   end repeat
   return tS
end Wreck.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
