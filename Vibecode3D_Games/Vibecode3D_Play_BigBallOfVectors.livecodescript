######################################################################################
## CARD SCRIPT: "Play.BigBallOfVectors"   BIG BALL OF VECTORS  (11 13 2026)
## The owner's concept (round two, 8 of 9): rogue AI agents are loose on the grid.
## Command the Security Polyhedron: crude at first, it gains sides and size with every
## catch. Don't touch the entanglement hazards, or the ball goes rogue itself.
## Teaches: forces, momentum, a growing shape.
## CONTROLS  Arrow keys: push the ball   Escape: stop
## RULES     roll over agents to catch them. An agent off the edge escapes and adds a
##           hazard. Touch a hazard: no control for two seconds. Catch the quota. 5 levels.
## RAIN      (p1-15, 23 Nov 2026; fixed the same night, owner: "the items we consume should be on the
##           board, the items that harm us are meant to fall from the sky") the HAZARDS rain down: a grey
##           ring (the Vector Toss shadow) shows where one will land, never on the ball and never on the
##           path the ball is rolling along (its momentum, kAhead frames); then it drops fast with a short
##           pink trail, lands on the ring, and drifts as before. It can't hurt you while it falls.
##           Agents (the ones you catch) just appear on the board, as before.
######################################################################################

global bPaused, bPlaying

local sBall, sX, sZ, sVX, sVZ, sR, sSides, sRogue, sAgent, sHaz, sSerial
local sRainPicks, sRainMinGap, sRainLanded, sRainNoMark
local sLevel, sQuota, sCaught, sEscaped, sAgentSpeed, sOver, sWon, sTicks, sTestKeys, sHUDWas

constant kEdge = 440
constant kPush = 0.9
constant kDrag = 0.94
constant kMaxEscapes = 8
constant kSafeR = 160        -- rain: no hazard lands within this (plus the ball's size) of the ball
constant kAhead = 17         -- rain: ... nor of where the ball's momentum carries it (frames of coasting)
constant kWarnTicks = 26     -- rain: frames the landing ring shows before the hazard drops
constant kFallTicks = 7      -- rain: frames of the fall itself (fast, like digital rain)
constant kDropH = 420        -- rain: how high above the floor it starts
constant kStagger = 9        -- rain: frames between the hazards of a level's first wave

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Camera.SetPosition 0, -420, -300
   Camera.SetLook 0, -atan2(420, 340)
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Ball.StartLevel 1
end Game.OnStart

-- level table: agent count | agent speed | hazard count | catch quota
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Ball.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Ball.StartLevel pLevel
   end if
end Ball.GoLevel

on Ball.StartLevel pLevel
   local tRow, n
   put pLevel into sLevel
   put line pLevel of ("4,3,1,5" & cr & "5,3.5,2,7" & cr & "6,4,3,9" & cr & "7,4.5,4,11" & cr & "8,5,5,13") into tRow
   put item 2 of tRow into sAgentSpeed
   put item 4 of tRow into sQuota
   put 0 into sCaught
   put 0 into sEscaped
   Scene.ClearAll
   Mesh.Define "Ball.Floor", Mesh.Grid(12, 12, 80)
   get Entity.Spawn("Ball.Floor", 0, 4, 0, "#0A280A")
   Mesh.Define "Ball.Agent", Mesh.Pyramid(4, 12, 26)
   Mesh.Define "Ball.Hazard", Mesh.Prism(5, 22, 8)
   Mesh.Define "Ball.Mark", Ball.RingMesh(16, 12)
   Mesh.Define "Ball.Trail", Ball.TrailMesh(70)
   put 0 into sX
   put 0 into sZ
   put 0 into sVX
   put 0 into sVZ
   put 3 into sSides
   put 22 into sR
   put 0 into sRogue
   put empty into sBall
   Ball.Reshape
   put empty into sAgent
   put empty into sHaz
   repeat with n = 1 to item 1 of tRow
      Ball.AddAgent
   end repeat
   repeat with n = 1 to item 3 of tRow
      Ball.AddHazard 12 + (n - 1) * kStagger      -- the hazards rain in one by one, not all at once
   end repeat
   put empty into sHUDWas
end Ball.StartLevel

-- the polyhedron: more sides and bigger with every catch
on Ball.Reshape
   if sBall is not empty then Entity.Kill sBall
   Mesh.Define "Ball.Poly", Mesh.Sphere(sR, max(2, sSides div 2), sSides)
   put Entity.Spawn("Ball.Poly", sX, -sR, sZ, "cyan") into sBall
end Ball.Reshape

-- an agent (the ones you catch) appears on the board
on Ball.AddAgent
   local a
   add 1 to sSerial
   put random(628) / 100 into a
   put (150 + random(200)) * sin(a) into sAgent[sSerial]["x"]
   put (150 + random(200)) * cos(a) into sAgent[sSerial]["z"]
   put random(628) / 100 into sAgent[sSerial]["dir"]
   put Entity.Spawn("Ball.Agent", sAgent[sSerial]["x"], 0, sAgent[sSerial]["z"], "#FF5050") into sAgent[sSerial]["key"]
end Ball.AddAgent

-- a new hazard rains in: a landing ring first (clear of the ball and of its path), then the drop.
-- sHaz[k]["drop"] counts down: above kFallTicks = only the ring shows; 1..kFallTicks = falling; 0 = drifts
on Ball.AddHazard pDelay
   add 1 to sSerial
   Ball.PickSpot sSerial
   put random(628) / 100 into sHaz[sSerial]["dir"]
   put kWarnTicks + kFallTicks + max(0, pDelay) into sHaz[sSerial]["drop"]
   put empty into sHaz[sSerial]["key"]
   put empty into sHaz[sSerial]["trail"]
   put Entity.Spawn("Ball.Mark", sHaz[sSerial]["x"], -1, sHaz[sSerial]["z"], "#5A6A80") into sHaz[sSerial]["mark"]
end Ball.AddHazard

-- how far a spot is from the ball's path: the line from the ball to where its momentum carries it
function Ball.PathGap pX, pZ
   local tAX, tAZ, tT, tL2
   put sVX * kAhead into tAX
   put sVZ * kAhead into tAZ
   put tAX * tAX + tAZ * tAZ into tL2
   if tL2 < 0.01 then return sqrt((pX - sX) ^ 2 + (pZ - sZ) ^ 2)
   put max(0, min(1, ((pX - sX) * tAX + (pZ - sZ) * tAZ) / tL2)) into tT
   return sqrt((pX - sX - tT * tAX) ^ 2 + (pZ - sZ - tT * tAZ) ^ 2)
end Ball.PathGap

-- a landing spot on the grid, kSafeR (+ the ball's size) clear of the ball and its path; else the best of 40 tries
on Ball.PickSpot pK
   local tX, tZ, n, tSafe, tFar, tGap, tBest, tBX, tBZ
   put kSafeR + sR into tSafe
   put kEdge - 50 into tFar
   put -1 into tBest
   repeat with n = 1 to 40
      put random(2 * tFar) - tFar into tX
      put random(2 * tFar) - tFar into tZ
      put Ball.PathGap(tX, tZ) into tGap
      if tGap > tBest then
         put tGap into tBest
         put tX into tBX
         put tZ into tBZ
      end if
      if tGap >= tSafe then exit repeat
   end repeat
   put tBX into sHaz[pK]["x"]
   put tBZ into sHaz[pK]["z"]
   add 1 to sRainPicks
   if sRainMinGap is empty then put 1e9 into sRainMinGap
   put min(sRainMinGap, tBest - tSafe) into sRainMinGap
end Ball.PickSpot

-- one frame of a hazard's rain; true while it is still on its way down (not playing yet)
function Ball.Rain pK
   local tY
   subtract 1 from sHaz[pK]["drop"]
   if sHaz[pK]["drop"] is kFallTicks then
      -- the ball rolled close to the ring (or now rolls toward it) while it warned: the ring moves away before the drop
      if Ball.PathGap(sHaz[pK]["x"], sHaz[pK]["z"]) < kSafeR + sR then
         Ball.PickSpot pK
         Entity.SetPosition sHaz[pK]["mark"], sHaz[pK]["x"], -1, sHaz[pK]["z"]
      end if
      put Entity.Spawn("Ball.Hazard", sHaz[pK]["x"], -kDropH, sHaz[pK]["z"], "#FF60D0") into sHaz[pK]["key"]
      put Entity.Spawn("Ball.Trail", sHaz[pK]["x"], -kDropH, sHaz[pK]["z"], "#C040A0") into sHaz[pK]["trail"]
   end if
   if sHaz[pK]["drop"] > kFallTicks then return true
   if sHaz[pK]["drop"] > 0 then
      put -kDropH * sHaz[pK]["drop"] / kFallTicks into tY
      Entity.SetPosition sHaz[pK]["key"], sHaz[pK]["x"], tY, sHaz[pK]["z"]
      Entity.SetPosition sHaz[pK]["trail"], sHaz[pK]["x"], tY, sHaz[pK]["z"]
      return true
   end if
   -- landed: the ring and the trail go, a small puff, then it drifts as before
   if sHaz[pK]["mark"] is empty then add 1 to sRainNoMark
   if sHaz[pK]["mark"] is not empty then Entity.Kill sHaz[pK]["mark"]
   if sHaz[pK]["trail"] is not empty then Entity.Kill sHaz[pK]["trail"]
   put empty into sHaz[pK]["mark"]
   put empty into sHaz[pK]["trail"]
   Entity.SetPosition sHaz[pK]["key"], sHaz[pK]["x"], -6, sHaz[pK]["z"]
   FX.Sparks sHaz[pK]["x"], -4, sHaz[pK]["z"], 5, "#FF60D0"
   add 1 to sRainLanded
   return false
end Ball.Rain

-- the landing ring (Vector Toss's shadow): a flat circle of lines
function Ball.RingMesh pR, pN
   local tM, i, tFirst, tA, tB
   put Mesh.New() into tM
   repeat with i = 0 to pN - 1
      Mesh.AddVertex tM, pR * cos(2 * pi * i / pN), 0, pR * sin(2 * pi * i / pN)
      put the result into tB
      if i is 0 then
         put tB into tFirst
      else
         Mesh.AddLine tM, tA, tB
      end if
      put tB into tA
   end repeat
   Mesh.AddLine tM, tA, tFirst
   return tM
end Ball.RingMesh

-- the short rain trail: one upright line above the falling agent (minus y is up)
function Ball.TrailMesh pLen
   local tM, tA, tB
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -14, 0
   put the result into tA
   Mesh.AddVertex tM, 0, -14 - pLen, 0
   put the result into tB
   Mesh.AddLine tM, tA, tB
   return tM
end Ball.TrailMesh

-- for tests: spawns | smallest gap outside the safe zone | landed | rings showing now | landed with no ring
-- | hazards on the ground that still have a ring (must be 0)
function Ball.RainState
   local tK, tRings, tStale
   put 0 into tRings
   put 0 into tStale
   repeat for each key tK in sHaz
      if sHaz[tK]["mark"] is not empty then
         add 1 to tRings
         if sHaz[tK]["drop"] <= 0 then add 1 to tStale
      end if
   end repeat
   return sRainPicks & "|" & round(sRainMinGap, 1) & "|" & sRainLanded & "|" & tRings & "|" & sRainNoMark & "|" & tStale
end Ball.RainState

-- for tests: the newest hazard's key, and one hazard's rain: frames left | ring showing | body showing
function Ball.LastHazard
   return sSerial
end Ball.LastHazard

function Ball.RainOf pK
   if pK is not among the keys of sHaz then return "gone"
   return sHaz[pK]["drop"] & "|" & (sHaz[pK]["mark"] is not empty) & "|" & (sHaz[pK]["key"] is not empty)
end Ball.RainOf

-- for tests: how many agents; one hazard's landing spot x|z; put the ball somewhere with a speed
function Ball.AgentCount
   return the number of lines of the keys of sAgent
end Ball.AgentCount

function Ball.HazSpot pK
   return sHaz[pK]["x"] & "|" & sHaz[pK]["z"]
end Ball.HazSpot

on Ball.TestPlace pX, pZ, pVX, pVZ
   put pX into sX
   put pZ into sZ
   put pVX into sVX
   put pVZ into sVZ
end Ball.TestPlace

on Ball.RainReset
   put 0 into sRainPicks
   put empty into sRainMinGap
   put 0 into sRainLanded
   put 0 into sRainNoMark
end Ball.RainReset


function Ball.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Ball.Keys

on Ball.TestKeys pKeys
   put pKeys into sTestKeys
end Ball.TestKeys

on Game.OnUpdate
   local tKeys, tK, d, dx, dz
   add 1 to sTicks
   put Ball.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and sTicks > 30 then Game.OnStart
      exit Game.OnUpdate
   end if
   -- pushing the ball (it has momentum); rogue = it rolls on its own
   if sRogue > 0 then
      subtract 1 from sRogue
      add (random(5) - 3) * 0.9 to sVX
      add (random(5) - 3) * 0.9 to sVZ
   else
      if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kPush from sVX
      if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kPush to sVX
      if (65362 is among the items of tKeys or 119 is among the items of tKeys) then add kPush to sVZ
      if (65364 is among the items of tKeys or 115 is among the items of tKeys) then subtract kPush from sVZ
   end if
   put sVX * kDrag into sVX
   put sVZ * kDrag into sVZ
   add sVX to sX
   add sVZ to sZ
   if abs(sX) > kEdge then
      put kEdge * sX / abs(sX) into sX
      put -sVX * 0.6 into sVX
   end if
   if abs(sZ) > kEdge then
      put kEdge * sZ / abs(sZ) into sZ
      put -sVZ * 0.6 into sVZ
   end if
   Entity.SetPosition sBall, sX, -sR, sZ
   Entity.SetRotation sBall, sZ / sR, 0, -sX / sR          -- it rolls
   -- agents wander, and run from the ball when it is near
   repeat for each key tK in sAgent
      put sAgent[tK]["x"] - sX into dx
      put sAgent[tK]["z"] - sZ into dz
      put sqrt(dx * dx + dz * dz) into d
      if d < sR + 10 then
         -- caught: the ball improves
         FX.Sparks sAgent[tK]["x"], -10, sAgent[tK]["z"], 10, "cyan"
         Entity.Kill sAgent[tK]["key"]
         delete variable sAgent[tK]
         Sound.Play "Pickup"
         add 1 to sCaught
         add 1 to sSides
         add 3 to sR
         Ball.Reshape
         put empty into sHUDWas
         if sCaught >= sQuota then
            if sLevel >= 5 then
               put true into sOver
               put true into sWon
               Sound.Play "Win"
               put 0 into sTicks
            else
               Sound.Play "Powerup"
               Ball.GoLevel sLevel + 1
            end if
            exit Game.OnUpdate
         end if
         Ball.AddAgent
         next repeat
      end if
      if d < 170 then
         put atan2(dx, dz) into sAgent[tK]["dir"]
      else if random(40) is 1 then
         add (random(200) - 100) / 100 to sAgent[tK]["dir"]
      end if
      add sAgentSpeed * sin(sAgent[tK]["dir"]) to sAgent[tK]["x"]
      add sAgentSpeed * cos(sAgent[tK]["dir"]) to sAgent[tK]["z"]
      if abs(sAgent[tK]["x"]) > kEdge + 30 or abs(sAgent[tK]["z"]) > kEdge + 30 then
         -- escaped off the grid: one more hazard
         Entity.Kill sAgent[tK]["key"]
         delete variable sAgent[tK]
         add 1 to sEscaped
         Sound.Play "Enemy"
         put empty into sHUDWas
         Ball.AddHazard
         Ball.AddAgent
         if sEscaped >= kMaxEscapes then
            Sound.Play "Lose"
            put true into sOver
            put 0 into sTicks
         end if
         next repeat
      end if
      Entity.SetPosition sAgent[tK]["key"], sAgent[tK]["x"], 0, sAgent[tK]["z"]
   end repeat
   -- hazards drift; touching one sends the ball rogue
   repeat for each key tK in sHaz
      if sHaz[tK]["drop"] > 0 then
         if Ball.Rain(tK) then next repeat     -- still warning or falling: it can't hurt you yet
      end if
      add 0.8 * sin(sHaz[tK]["dir"]) to sHaz[tK]["x"]
      add 0.8 * cos(sHaz[tK]["dir"]) to sHaz[tK]["z"]
      if abs(sHaz[tK]["x"]) > kEdge or abs(sHaz[tK]["z"]) > kEdge then add 3.14159 to sHaz[tK]["dir"]
      Entity.SetPosition sHaz[tK]["key"], sHaz[tK]["x"], -6, sHaz[tK]["z"]
      Entity.SetRotation sHaz[tK]["key"], 0, sTicks / 10, 0
      if sRogue <= 0 and abs(sHaz[tK]["x"] - sX) < sR + 16 and abs(sHaz[tK]["z"] - sZ) < sR + 16 then
         put 60 into sRogue
         Sound.Play "Hurt"
         FX.Sparks sX, -sR, sZ, 16, "#FF60D0"
         put empty into sHUDWas
      end if
   end repeat
   if sRogue is 1 then put empty into sHUDWas
   Ball.ShowHUD
end Game.OnUpdate

on Ball.ShowHUD
   local tWords
   put sLevel & "|" & sCaught & "|" & sEscaped & "|" & (sRogue > 1) & "|" & sOver into tWords
   if tWords is sHUDWas then exit Ball.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Ball.Score", "CAUGHT" && sCaught && "OF" && sQuota && "  ESCAPED" && sEscaped && "OF" && kMaxEscapes && "  SIDES" && sSides && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Ball.Msg"
   if sOver and sWon then
      HUD.Set "Ball.Msg", "THE GRID IS SECURE.  SPACE TO PLAY AGAIN", 190, 400, 16
   else if sOver then
      HUD.Set "Ball.Msg", "TOO MANY ESCAPED.  SPACE TO PLAY AGAIN", 200, 400, 16
   else if sRogue > 1 then
      HUD.Set "Ball.Msg", "ENTANGLED: THE BALL HAS GONE ROGUE", 220, 400, 16
   end if
end Ball.ShowHUD

function Ball.State
   return sLevel & "|" & sCaught & "/" & sQuota & "|" & sEscaped & "|" & round(sX) & "," & round(sZ) & "|" & sSides & "|" & sRogue & "|" & sOver
end Ball.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
