######################################################################################
## CARD SCRIPT: "Play.BigBallOfVectors"   BIG BALL OF VECTORS  (11 13 2026)
## The owner's concept (round two, 8 of 9): rogue AI agents are loose on the grid.
## Command the Security Polyhedron: crude at first, it gains sides and size with every
## catch. Don't touch the entanglement hazards, or the ball goes rogue itself.
## Teaches: forces, momentum, a growing shape.
## CONTROLS  Arrow keys: push the ball   Escape: stop
## RULES     roll over agents to catch them. An agent off the edge escapes and adds a
##           hazard. Touch a hazard: no control for two seconds. Catch the quota. 5 levels.
######################################################################################

global bPaused, bPlaying

local sBall, sX, sZ, sVX, sVZ, sR, sSides, sRogue, sAgent, sHaz, sSerial
local sLevel, sQuota, sCaught, sEscaped, sAgentSpeed, sOver, sWon, sTicks, sTestKeys, sHUDWas

constant kEdge = 440
constant kPush = 0.9
constant kDrag = 0.94
constant kMaxEscapes = 8

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
      Ball.AddHazard
   end repeat
   put empty into sHUDWas
end Ball.StartLevel

-- the polyhedron: more sides and bigger with every catch
on Ball.Reshape
   if sBall is not empty then Entity.Kill sBall
   Mesh.Define "Ball.Poly", Mesh.Sphere(sR, max(2, sSides div 2), sSides)
   put Entity.Spawn("Ball.Poly", sX, -sR, sZ, "cyan") into sBall
end Ball.Reshape

on Ball.AddAgent
   local a
   add 1 to sSerial
   put random(628) / 100 into a
   put (150 + random(200)) * sin(a) into sAgent[sSerial]["x"]
   put (150 + random(200)) * cos(a) into sAgent[sSerial]["z"]
   put random(628) / 100 into sAgent[sSerial]["dir"]
   put Entity.Spawn("Ball.Agent", sAgent[sSerial]["x"], 0, sAgent[sSerial]["z"], "#FF5050") into sAgent[sSerial]["key"]
end Ball.AddAgent

on Ball.AddHazard
   add 1 to sSerial
   put random(700) - 350 into sHaz[sSerial]["x"]
   put random(700) - 350 into sHaz[sSerial]["z"]
   if abs(sHaz[sSerial]["x"]) < 90 and abs(sHaz[sSerial]["z"]) < 90 then add 180 to sHaz[sSerial]["x"]
   put random(628) / 100 into sHaz[sSerial]["dir"]
   put Entity.Spawn("Ball.Hazard", sHaz[sSerial]["x"], -6, sHaz[sSerial]["z"], "#FF60D0") into sHaz[sSerial]["key"]
end Ball.AddHazard

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
         add 1 to sCaught
         add 1 to sSides
         add 3 to sR
         Ball.Reshape
         put empty into sHUDWas
         if sCaught >= sQuota then
            if sLevel >= 5 then
               put true into sOver
               put true into sWon
               put 0 into sTicks
            else
               Ball.StartLevel sLevel + 1
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
         put empty into sHUDWas
         Ball.AddHazard
         Ball.AddAgent
         if sEscaped >= kMaxEscapes then
            put true into sOver
            put 0 into sTicks
         end if
         next repeat
      end if
      Entity.SetPosition sAgent[tK]["key"], sAgent[tK]["x"], 0, sAgent[tK]["z"]
   end repeat
   -- hazards drift; touching one sends the ball rogue
   repeat for each key tK in sHaz
      add 0.8 * sin(sHaz[tK]["dir"]) to sHaz[tK]["x"]
      add 0.8 * cos(sHaz[tK]["dir"]) to sHaz[tK]["z"]
      if abs(sHaz[tK]["x"]) > kEdge or abs(sHaz[tK]["z"]) > kEdge then add 3.14159 to sHaz[tK]["dir"]
      Entity.SetPosition sHaz[tK]["key"], sHaz[tK]["x"], -6, sHaz[tK]["z"]
      Entity.SetRotation sHaz[tK]["key"], 0, sTicks / 10, 0
      if sRogue <= 0 and abs(sHaz[tK]["x"] - sX) < sR + 16 and abs(sHaz[tK]["z"] - sZ) < sR + 16 then
         put 60 into sRogue
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
