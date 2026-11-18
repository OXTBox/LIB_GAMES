######################################################################################
## CARD SCRIPT: "Play.TrenchRun"   TRENCH RUN  (11 13 2026)
## After the UPBGE template TrenchRun_Torus_IV (LIB_UPBGE/specs): there a torus turns past a
## fixed player; pillboxes on it fire seeking shots when the player is within 8; player
## shots knock them out. Here: a vector trench round the INSIDE of a giant ring, so the
## floor curves up ahead of you into a loop; the ring turns, you hold still and dodge.
## Teaches: a world that moves instead of the player, curved space, ring coordinates.
## CONTROLS  Left/Right or A/D: slide   Up/Down or W/S: climb/dive   Space: fire   Escape: stop
## RULES     pillboxes fire as they come near; a hit costs a shield. Every lap is faster
##           and the knocked-out pillboxes come back. Survive 5 laps.
######################################################################################

global bPaused, bPlaying

local sTheta, sSpin, sPX, sPH, sRing, sBox, sBoxN, sShot, sFoeShot, sSerial, sLap, sLapAt
local sShields, sScore, sOver, sWon, sTicks, sTestKeys, sKeysWas, sCool, sHUDWas, sMsg, sMsgUntil

constant kR = 900              -- the ring's radius (to the trench floor)
constant kCY = -840            -- the ring's centre is this high (y down): the floor is at y 60
constant kHalfW = 120          -- the trench is 240 wide
constant kWallH = 90           -- its walls
constant kSlices = 48          -- cross-sections drawn round the ring
constant kBoxes = 14

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sTheta
   put 0 into sPX
   put 35 into sPH
   put 1 into sLap
   put 0 into sLapAt
   put 5 into sShields
   put 0 into sScore
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put 0 into sCool
   put empty into sShot
   put empty into sFoeShot
   put 0 into sSerial
   Trench.SetSpeed
   Trench.BuildRing
   Trench.MakeBoxes
   Mesh.Define "Trench.Shot", Mesh.Box(4, 4, 18)
   Mesh.Define "Trench.FoeShot", Mesh.Sphere(5, 2, 4)
   Trench.Camera
   Trench.Say "THE TRENCH: SLIDE, CLIMB, FIRE.  SURVIVE 5 LAPS", 3
end Game.OnStart

on Trench.SetSpeed
   put 0.004 + sLap * 0.0015 into sSpin
end Trench.SetSpeed

-- a point in ring coordinates: angle round the ring (a), across (x), height above the floor (h)
function Trench.Y a, h
   return kCY + (kR - h) * cos(a)
end Trench.Y

function Trench.Z a, h
   return (kR - h) * sin(a)
end Trench.Z

-- the trench: floor, walls and wall tops, sliced round the ring (one mesh, turned as a whole)
on Trench.BuildRing
   local tM, k, a, tB
   put Mesh.New() into tM
   repeat with k = 0 to kSlices - 1
      put k * 2 * pi / kSlices into a
      put tM["count"] into tB
      -- a cross-section: wall top, wall foot, floor, wall foot, wall top (centre-relative)
      Mesh.AddVertex tM, -kHalfW - 30, (kR - kWallH) * cos(a), (kR - kWallH) * sin(a)
      Mesh.AddVertex tM, -kHalfW, kR * cos(a), kR * sin(a)
      Mesh.AddVertex tM, kHalfW, kR * cos(a), kR * sin(a)
      Mesh.AddVertex tM, kHalfW + 30, (kR - kWallH) * cos(a), (kR - kWallH) * sin(a)
      Mesh.AddLine tM, tB + 1, tB + 2
      Mesh.AddLine tM, tB + 2, tB + 3
      Mesh.AddLine tM, tB + 3, tB + 4
      -- along the ring to the next slice (4 rails)
      if k > 0 then
         Mesh.AddLine tM, tB - 3, tB + 1
         Mesh.AddLine tM, tB - 2, tB + 2
         Mesh.AddLine tM, tB - 1, tB + 3
         Mesh.AddLine tM, tB, tB + 4
      end if
   end repeat
   Mesh.AddLine tM, tM["count"] - 3, 1
   Mesh.AddLine tM, tM["count"] - 2, 2
   Mesh.AddLine tM, tM["count"] - 1, 3
   Mesh.AddLine tM, tM["count"], 4
   Mesh.Define "Trench.Ring", tM
   put Entity.Spawn("Trench.Ring", 0, kCY, 0, "#1C8A4A") into sRing
end Trench.BuildRing

-- pillboxes on the floor, spread round the ring (never right at the start)
on Trench.MakeBoxes
   local n
   Mesh.Define "Trench.Box", Mesh.Box(26, 22, 26)
   put empty into sBox
   put kBoxes into sBoxN
   repeat with n = 1 to kBoxes
      put 0.5 + (n - 1) * (2 * pi - 0.8) / kBoxes + random(10) / 100 into sBox[n]["a"]
      put item random(3) of "-75,0,75" into sBox[n]["x"]
      put 0 into sBox[n]["cool"]
      put Entity.Spawn("Trench.Box", sBox[n]["x"], 0, 0, "#FF5050") into sBox[n]["key"]
   end repeat
end Trench.MakeBoxes

on Trench.Camera
   Camera.SetPosition sPX, Trench.Y(0, sPH), 0
   Camera.SetLook 0, 0.12
end Trench.Camera

function Trench.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Trench.Keys

on Trench.TestKeys pKeys
   put pKeys into sTestKeys
end Trench.TestKeys

on Game.OnUpdate
   local tKeys
   add 1 to sTicks
   put Trench.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Game.OnStart
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- the player holds still; slide and climb inside the trench
   if 65361 is among the items of tKeys or 97 is among the items of tKeys then subtract 4 from sPX
   if 65363 is among the items of tKeys or 100 is among the items of tKeys then add 4 to sPX
   if 65362 is among the items of tKeys or 119 is among the items of tKeys then add 2.5 to sPH
   if 65364 is among the items of tKeys or 115 is among the items of tKeys then subtract 2.5 from sPH
   put max(-kHalfW + 15, min(kHalfW - 15, sPX)) into sPX
   put max(12, min(kWallH + 40, sPH)) into sPH
   if sCool > 0 then subtract 1 from sCool
   if 32 is among the items of tKeys and sCool <= 0 then Trench.Fire
   put tKeys into sKeysWas
   -- the ring turns towards you
   subtract sSpin from sTheta
   Entity.SetRotation sRing, sTheta, 0, 0
   if -sTheta - sLapAt >= 2 * pi then Trench.NextLap
   Trench.Camera
   Trench.MoveBoxes
   Trench.MoveShots
   Trench.ShowHUD
end Game.OnUpdate

on Trench.NextLap
   local n
   add 2 * pi to sLapAt
   add 1 to sLap
   if sLap > 5 then
      put true into sOver
      put true into sWon
      put empty into sHUDWas
      exit Trench.NextLap
   end if
   Trench.SetSpeed
   -- the knocked-out pillboxes are back
   repeat with n = 1 to sBoxN
      if sBox[n]["key"] is empty then put Entity.Spawn("Trench.Box", sBox[n]["x"], 0, 0, "#FF5050") into sBox[n]["key"]
   end repeat
   Trench.Say "LAP" && sLap & ": FASTER", 2
end Trench.NextLap

-- where a ring point is now (its angle plus the ring's turn)
on Trench.MoveBoxes
   local n, a, tA
   repeat with n = 1 to sBoxN
      if sBox[n]["key"] is empty then next repeat
      put sBox[n]["a"] + sTheta into a
      put a - 2 * pi * round(a / (2 * pi)) into tA          -- -pi..pi: 0 is where you are
      Entity.SetPosition sBox[n]["key"], sBox[n]["x"], Trench.Y(tA, 11), Trench.Z(tA, 11)
      Entity.SetRotation sBox[n]["key"], tA, 0, 0
      -- near and ahead: it fires at you
      if sBox[n]["cool"] > 0 then subtract 1 from sBox[n]["cool"]
      if tA > 0.2 and tA < 0.5 and sBox[n]["cool"] <= 0 then
         put 400 into sBox[n]["cool"]          -- once a pass
         Trench.FoeFire sBox[n]["x"], Trench.Y(tA, 20), Trench.Z(tA, 20)
      end if
   end repeat
end Trench.MoveBoxes

on Trench.FoeFire x, y, z
   local tTX, tTY, d
   add 1 to sSerial
   put x into sFoeShot[sSerial]["x"]
   put y into sFoeShot[sSerial]["y"]
   put z into sFoeShot[sSerial]["z"]
   -- aimed at you, with some scatter: still is risky, moving is safe
   put sPX + random(61) - 31 - x into tTX
   put Trench.Y(0, sPH) + random(41) - 21 - y into tTY
   put sqrt(tTX * tTX + tTY * tTY + z * z) into d
   put tTX / d * (4 + sLap) into sFoeShot[sSerial]["vx"]
   put tTY / d * (4 + sLap) into sFoeShot[sSerial]["vy"]
   put -z / d * (4 + sLap) into sFoeShot[sSerial]["vz"]
   put 140 into sFoeShot[sSerial]["life"]
   put Entity.Spawn("Trench.FoeShot", x, y, z, "#FFB000") into sFoeShot[sSerial]["key"]
end Trench.FoeFire

-- your shot runs along the ring ahead of you, dropping toward the floor
on Trench.Fire
   add 1 to sSerial
   put -sTheta into sShot[sSerial]["a"]
   put sPX into sShot[sSerial]["x"]
   put sPH into sShot[sSerial]["h"]
   put 60 into sShot[sSerial]["life"]
   put Entity.Spawn("Trench.Shot", sPX, Trench.Y(0, sPH), 0, "#40E0FF") into sShot[sSerial]["key"]
   put 7 into sCool
end Trench.Fire

on Trench.MoveShots
   local k, n, tA, tPY
   repeat for each key k in sShot
      add 0.02 to sShot[k]["a"]
      put max(8, sShot[k]["h"] - 0.9) into sShot[k]["h"]
      subtract 1 from sShot[k]["life"]
      put sShot[k]["a"] + sTheta into tA
      Entity.SetPosition sShot[k]["key"], sShot[k]["x"], Trench.Y(tA, sShot[k]["h"]), Trench.Z(tA, sShot[k]["h"])
      Entity.SetRotation sShot[k]["key"], tA, 0, 0
      repeat with n = 1 to sBoxN
         if sBox[n]["key"] is empty then next repeat
         if abs(sBox[n]["a"] - sShot[k]["a"] - 2 * pi * round((sBox[n]["a"] - sShot[k]["a"]) / (2 * pi))) * kR < 22 and abs(sBox[n]["x"] - sShot[k]["x"]) < 26 and sShot[k]["h"] < 40 then
            FX.Sparks sBox[n]["x"], Trench.Y(tA, 10), Trench.Z(tA, 10), 16, "#FF5050"
            Entity.Kill sBox[n]["key"]
            put empty into sBox[n]["key"]
            add 100 to sScore
            put 0 into sShot[k]["life"]
            put empty into sHUDWas
            exit repeat
         end if
      end repeat
      if sShot[k]["life"] <= 0 then
         Entity.Kill sShot[k]["key"]
         delete variable sShot[k]
      end if
   end repeat
   put Trench.Y(0, sPH) into tPY
   repeat for each key k in sFoeShot
      add sFoeShot[k]["vx"] to sFoeShot[k]["x"]
      add sFoeShot[k]["vy"] to sFoeShot[k]["y"]
      add sFoeShot[k]["vz"] to sFoeShot[k]["z"]
      subtract 1 from sFoeShot[k]["life"]
      Entity.SetPosition sFoeShot[k]["key"], sFoeShot[k]["x"], sFoeShot[k]["y"], sFoeShot[k]["z"]
      if abs(sFoeShot[k]["x"] - sPX) < 12 and abs(sFoeShot[k]["y"] - tPY) < 12 and abs(sFoeShot[k]["z"]) < 14 then
         put 0 into sFoeShot[k]["life"]
         subtract 1 from sShields
         FX.Sparks sPX, tPY + 10, 30, 20, "#FFB000"
         put empty into sHUDWas
         if sShields <= 0 then
            put true into sOver
            Trench.Say "SHIELDS GONE ON LAP" && sLap, 999
         else
            Trench.Say "HIT: SHIELDS" && sShields, 1
         end if
      end if
      if sFoeShot[k]["life"] <= 0 or sFoeShot[k]["z"] < -60 then
         Entity.Kill sFoeShot[k]["key"]
         delete variable sFoeShot[k]
      end if
   end repeat
end Trench.MoveShots

on Trench.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end Trench.Say

on Trench.ShowHUD
   local tWords
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sLap & "|" & sShields & "|" & sScore & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit Trench.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Trench.Score", "LAP" && min(sLap, 5) && "OF 5   SHIELDS" && sShields && "  SCORE" && sScore, 20, 120, 14
   HUD.Remove "Trench.Msg"
   if sOver and sWon then
      HUD.Set "Trench.Msg", "FIVE LAPS.  YOU MADE IT.  SPACE TO RUN AGAIN", 20, 142, 14
   else if sOver then
      HUD.Set "Trench.Msg", sMsg & ".  SPACE TO RUN AGAIN", 20, 142, 14
   else if sMsg is not empty then
      HUD.Set "Trench.Msg", sMsg, 20, 142, 14
   end if
end Trench.ShowHUD

function Trench.State
   local n, tAlive
   put 0 into tAlive
   repeat with n = 1 to sBoxN
      if sBox[n]["key"] is not empty then add 1 to tAlive
   end repeat
   return sLap & "|" & sShields & "|" & sScore & "|" & round(sPX) & "," & round(sPH) & "|" & tAlive & "|" & round(-sTheta, 2) & "|" & sOver
end Trench.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
