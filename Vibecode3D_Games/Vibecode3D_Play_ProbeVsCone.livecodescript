######################################################################################
## CARD SCRIPT: "Play.ProbeVsCone"   PROBE VS CONE  (11 13 2026)
## The owner's concept (round two, 9 of 9): a small runner throws a logic-probe spear at a
## boss (the Cone) guarded by rings of shield cubes. A hit cube breaks and drops a key
## token; collect the tokens to assemble the password. Every few seconds the shield
## updates: cubes from an inner ring move out to fill the gaps of the ring outside it.
## A spear that breaks a cube returns to the hand; one that misses bounces off the walls
## and is dangerous until it lies still and is picked up.
## Teaches: aiming, bouncing, a shield that repairs itself.
## CONTROLS  Arrows or WASD: run   aim with the mouse   click or Space: throw
##           (no mouse: it throws the way you last ran)   Escape: stop
## RULES     a moving loose spear that hits you costs a life. Hit the Cone with the
##           password complete. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying
global gNoMouse        -- true while an AI tests: aim by facing, never read the mouse

local sPX, sPY, sPlayer, sBoss, sRing, sRings, sSpear, sTok, sTokN, sPass, sGot
local sLevel, sLives, sUpdate, sSpeed, sNextUpdate, sOver, sWon, sTicks, sTestKeys, sKeysWas
local sHUDWas, sMsg, sMsgUntil, sSafe, sFaceX, sFaceY, sAimX, sAimY, sAim

constant kZ = 360
constant kLeft = -380
constant kRight = 380
constant kTop = -230
constant kBottom = 290
constant kBossX = 0
constant kBossY = -30
constant kRun = 4
constant kWords = "KEY,CODE,LOGIC,PROBES,CONEDOWN"

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Probe.StartLevel
end Game.OnStart

-- level table: shield rings | update seconds | spear speed | (lives carry)
function Probe.Row pLevel
   return line pLevel of ("1,6,9" & cr & "2,5,10" & cr & "2,4,11" & cr & "3,4,12" & cr & "3,3,13")
end Probe.Row

on Probe.StartLevel
   local tRow, k, i, n, tMesh
   put Probe.Row(sLevel) into tRow
   put item 1 of tRow into sRings
   put item 2 of tRow * 30 into sUpdate
   put item 3 of tRow into sSpeed
   put item sLevel of kWords into sPass
   put empty into sGot
   Scene.ClearAll
   -- the arena frame
   Mesh.Define "Probe.Arena", Probe.FrameMesh()
   get Entity.Spawn("Probe.Arena", 0, 0, kZ, "#1C4A2A")
   -- the Cone
   Mesh.Define "Probe.Cone", MeshPyramid(12, 34, 70)
   put Entity.Spawn("Probe.Cone", kBossX, kBossY, kZ, "#B060FF") into sBoss
   -- the shield: ring k has 6 + 4k slots, all filled
   Mesh.Define "Probe.Cube", MeshBox(20, 20, 20)
   put empty into sRing
   repeat with k = 1 to sRings
      put 6 + 4 * k into sRing[k]["n"]
      repeat with i = 1 to sRing[k]["n"]
         Probe.PutCube k, i
      end repeat
   end repeat
   -- the token list is filled as cubes break
   put empty into sTok
   put 0 into sTokN
   Mesh.Define "Probe.Token", MeshSphere(7, 2, 4)
   -- the runner and the spear
   Mesh.Define "Probe.Man", Probe.ManMesh()
   Mesh.Define "Probe.Spear", MeshBox(30, 4, 4)
   put 0 into sPX
   put 230 into sPY
   put Entity.Spawn("Probe.Man", sPX, sPY, kZ, "#40E0FF") into sPlayer
   -- the aim line: a dashed arrow
   Mesh.Define "Probe.Aim", Probe.AimMesh()
   put Entity.Spawn("Probe.Aim", sPX, sPY - 65, kZ, "#FFE060") into sAim
   put 0 into sFaceX
   put -1 into sFaceY
   put 0 into sAimX
   put -1 into sAimY
   put empty into sSpear
   put "hand" into sSpear["state"]
   put sTicks + sUpdate into sNextUpdate
   put 0 into sSafe
   Probe.Say "BREAK CUBES, COLLECT" && the number of chars of sPass && "KEYS, THEN HIT THE CONE", 4
   put empty into sHUDWas
end Probe.StartLevel

function Probe.AimMesh
   local tM, n
   put Mesh.New() into tM
   repeat with n = 0 to 2
      Mesh.AddVertex tM, -20 + n * 14, 0, 0
      Mesh.AddVertex tM, -13 + n * 14, 0, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   Mesh.AddVertex tM, 22, 0, 0
   Mesh.AddVertex tM, 14, -6, 0
   Mesh.AddVertex tM, 14, 6, 0
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 2, tM["count"]
   return tM
end Probe.AimMesh

function Probe.FrameMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, kLeft, kTop, 0
   Mesh.AddVertex tM, kRight, kTop, 0
   Mesh.AddVertex tM, kRight, kBottom, 0
   Mesh.AddVertex tM, kLeft, kBottom, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 4, 1
   return tM
end Probe.FrameMesh

function Probe.ManMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -28, 0
   Mesh.AddVertex tM, 0, -20, 0
   Mesh.AddVertex tM, 0, -8, 0
   Mesh.AddVertex tM, -7, 6, 0
   Mesh.AddVertex tM, 7, 6, 0
   Mesh.AddVertex tM, -9, -12, 0
   Mesh.AddVertex tM, 9, -24, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 3, 5
   Mesh.AddLine tM, 2, 6
   Mesh.AddLine tM, 2, 7
   return tM
end Probe.ManMesh

function Probe.Radius k
   return 55 + 42 * k
end Probe.Radius

on Probe.PutCube k, i
   local a
   put (i - 1) / sRing[k]["n"] * 2 * pi into a
   put kBossX + Probe.Radius(k) * sin(a) into sRing[k][i]["x"]
   put kBossY - Probe.Radius(k) * cos(a) into sRing[k][i]["y"]
   if sRing[k][i]["key"] is empty then put Entity.Spawn("Probe.Cube", sRing[k][i]["x"], sRing[k][i]["y"], kZ, item k of "#FF60D0,#FF9040,#FFE060") into sRing[k][i]["key"]
   SetObjectPosition sRing[k][i]["key"], sRing[k][i]["x"], sRing[k][i]["y"], kZ
end Probe.PutCube

-- the shield update: each gap in a ring is filled by a cube from the ring inside it
on Probe.Update
   local k, i, j, tFrom
   repeat with k = sRings down to 2
      repeat with i = 1 to sRing[k]["n"]
         if sRing[k][i]["key"] is not empty then next repeat
         put empty into tFrom
         repeat with j = 1 to sRing[k - 1]["n"]
            if sRing[k - 1][j]["key"] is not empty then
               put j into tFrom
               exit repeat
            end if
         end repeat
         if tFrom is empty then exit repeat
         put sRing[k - 1][tFrom]["key"] into sRing[k][i]["key"]
         put empty into sRing[k - 1][tFrom]["key"]
         Probe.PutCube k, i
         FX.Sparks sRing[k][i]["x"], sRing[k][i]["y"], kZ, 3, "#FFE060"
      end repeat
   end repeat
   Probe.Say "SHIELD UPDATE", 1
end Probe.Update

function Probe.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Probe.Keys

on Probe.TestKeys pKeys
   put pKeys into sTestKeys
end Probe.TestKeys

on Game.OnUpdate
   local tKeys, dx, dy, d, nx, ny
   add 1 to sTicks
   put Probe.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Game.OnStart
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- run; never inside the outer ring
   put sPX into nx
   put sPY into ny
   put 0 into dx
   put 0 into dy
   if 65361 is among the items of tKeys or 97 is among the items of tKeys then put -1 into dx
   if 65363 is among the items of tKeys or 100 is among the items of tKeys then put 1 into dx
   if 65362 is among the items of tKeys or 119 is among the items of tKeys then put -1 into dy
   if 65364 is among the items of tKeys or 115 is among the items of tKeys then put 1 into dy
   if dx is not 0 or dy is not 0 then
      put sqrt(dx * dx + dy * dy) into d
      put dx / d into sFaceX
      put dy / d into sFaceY
      add sFaceX * kRun to nx
      add sFaceY * kRun to ny
   end if
   put max(kLeft + 12, min(kRight - 12, nx)) into nx
   put max(kTop + 30, min(kBottom - 8, ny)) into ny
   if sqrt((nx - kBossX) ^ 2 + (ny - kBossY) ^ 2) > Probe.Radius(max(1, sRings)) + 26 then
      put nx into sPX
      put ny into sPY
   end if
   SetObjectPosition sPlayer, sPX, sPY, kZ
   Probe.AimAt
   if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Probe.Throw
   put tKeys into sKeysWas
   if sTicks >= sNextUpdate then
      put sTicks + sUpdate into sNextUpdate
      Probe.Update
   end if
   if sSafe > 0 then subtract 1 from sSafe
   Probe.MoveSpear
   Probe.Tokens
   SetObjectRotation sBoss, 0, sTicks / 30, 0
   Probe.ShowHUD
end Game.OnUpdate

-------------------------------------------------------------------- the spear

-- the aim: toward the mouse pointer over the arena; without a mouse, the way you last ran
on Probe.AimAt
   local tM, tW, dx, dy, d
   put sFaceX into dx
   put sFaceY into dy
   if gNoMouse is not true then
      put the mouseLoc into tM
      put Probe.ScreenToWorld(item 1 of tM, item 2 of tM) into tW
      if tW is not empty then
         put item 1 of tW - sPX into dx
         put item 2 of tW - (sPY - 20) into dy
      end if
   end if
   put sqrt(dx * dx + dy * dy) into d
   if d < 0.01 then exit Probe.AimAt
   put dx / d into sAimX
   put dy / d into sAimY
   -- the aim line, in front of the runner
   SetObjectPosition sAim, sPX + sAimX * 45, sPY - 20 + sAimY * 45, kZ
   SetObjectRotation sAim, 0, 0, atan2(sAimY, sAimX)
end Probe.AimAt

-- a screen point on the play plane (camera at the origin looking straight ahead)
function Probe.ScreenToWorld pX, pY
   local a, b, kx, ky
   put ProjectVertex(0, 0, kZ) into a
   put ProjectVertex(100, 100, kZ) into b
   if a is empty or b is empty then return empty
   put (word 1 of b - word 1 of a) / 100 into kx
   put (word 2 of b - word 2 of a) / 100 into ky
   if kx is 0 or ky is 0 then return empty
   return (pX - word 1 of a) / kx & comma & (pY - word 2 of a) / ky
end Probe.ScreenToWorld

on Game.OnClick pX, pY, pButton
   if sOver then exit Game.OnClick
   Probe.AimAt
   Probe.Throw
end Game.OnClick

on Probe.Throw
   if sSpear["state"] is not "hand" then exit Probe.Throw
   put sPX into sSpear["x"]
   put sPY - 20 into sSpear["y"]
   put sAimX * sSpeed into sSpear["vx"]
   put sAimY * sSpeed into sSpear["vy"]
   put "flying" into sSpear["state"]
   put Entity.Spawn("Probe.Spear", sSpear["x"], sSpear["y"], kZ, "#40E0FF") into sSpear["key"]
end Probe.Throw

on Probe.MoveSpear
   local k, i, dx, dy, d, tV
   if sSpear["state"] is "hand" then exit Probe.MoveSpear
   if sSpear["state"] is "return" then
      -- back to the hand, fast
      put sPX - sSpear["x"] into dx
      put sPY - 20 - sSpear["y"] into dy
      put sqrt(dx * dx + dy * dy) into d
      if d < 16 then
         Entity.Kill sSpear["key"]
         put "hand" into sSpear["state"]
         exit Probe.MoveSpear
      end if
      add dx / d * 16 to sSpear["x"]
      add dy / d * 16 to sSpear["y"]
      Probe.PlaceSpear
      exit Probe.MoveSpear
   end if
   add sSpear["vx"] to sSpear["x"]
   add sSpear["vy"] to sSpear["y"]
   -- walls: bounce, slower each time
   if sSpear["x"] < kLeft or sSpear["x"] > kRight then
      put -sSpear["vx"] * 0.8 into sSpear["vx"]
      put max(kLeft, min(kRight, sSpear["x"])) into sSpear["x"]
      put "loose" into sSpear["state"]
   end if
   if sSpear["y"] < kTop or sSpear["y"] > kBottom then
      put -sSpear["vy"] * 0.8 into sSpear["vy"]
      put max(kTop, min(kBottom, sSpear["y"])) into sSpear["y"]
      put "loose" into sSpear["state"]
   end if
   if sSpear["state"] is "loose" then
      put sSpear["vx"] * 0.985 into sSpear["vx"]
      put sSpear["vy"] * 0.985 into sSpear["vy"]
   end if
   put sqrt(sSpear["vx"] ^ 2 + sSpear["vy"] ^ 2) into tV
   -- shield cubes: one breaks, drops a key, and the spear comes home
   repeat with k = 1 to sRings
      repeat with i = 1 to sRing[k]["n"]
         if sRing[k][i]["key"] is empty then next repeat
         if abs(sRing[k][i]["x"] - sSpear["x"]) < 16 and abs(sRing[k][i]["y"] - sSpear["y"]) < 16 then
            Entity.Kill sRing[k][i]["key"]
            put empty into sRing[k][i]["key"]
            FX.Sparks sRing[k][i]["x"], sRing[k][i]["y"], kZ, 10, "#FF60D0"
            Probe.DropToken sRing[k][i]["x"], sRing[k][i]["y"]
            put "return" into sSpear["state"]
            exit Probe.MoveSpear
         end if
      end repeat
   end repeat
   -- the Cone
   if abs(sSpear["x"] - kBossX) < 22 and abs(sSpear["y"] - kBossY) < 30 and tV > 1 then
      if the number of chars of sGot >= the number of chars of sPass then
         FX.Sparks kBossX, kBossY, kZ, 60, "#B060FF"
         Entity.Kill sSpear["key"]
         put "hand" into sSpear["state"]
         if sLevel >= 5 then
            put true into sOver
            put true into sWon
         else
            add 1 to sLevel
            Probe.StartLevel
         end if
         exit Probe.MoveSpear
      end if
      -- no password: it glances off
      put -sSpear["vx"] into sSpear["vx"]
      put -sSpear["vy"] * 0.9 into sSpear["vy"]
      put "loose" into sSpear["state"]
      Probe.Say "ACCESS DENIED: THE PASSWORD IS NOT COMPLETE", 2
   end if
   -- loose: dangerous while it moves; lying still it can be picked up
   if sSpear["state"] is "loose" then
      if abs(sSpear["x"] - sPX) < 16 and abs(sSpear["y"] - (sPY - 10)) < 22 then
         if tV < 4 then
            Entity.Kill sSpear["key"]
            put "hand" into sSpear["state"]
            exit Probe.MoveSpear
         else if sSafe <= 0 then
            Probe.LoseLife
            exit Probe.MoveSpear
         end if
      end if
      if tV < 0.3 then
         put 0 into sSpear["vx"]
         put 0 into sSpear["vy"]
      end if
   end if
   Probe.PlaceSpear
end Probe.MoveSpear

on Probe.PlaceSpear
   SetObjectPosition sSpear["key"], sSpear["x"], sSpear["y"], kZ
   SetObjectRotation sSpear["key"], 0, 0, atan2(sSpear["vy"], sSpear["vx"])
end Probe.PlaceSpear

-------------------------------------------------------------------- keys

on Probe.DropToken pX, pY
   add 1 to sTokN
   put pX into sTok[sTokN]["x"]
   put pY into sTok[sTokN]["y"]
   put Entity.Spawn("Probe.Token", pX, pY, kZ - 2, "#FFE060") into sTok[sTokN]["key"]
end Probe.DropToken

-- tokens drift out from the shield to where the runner can reach them
on Probe.Tokens
   local t, dx, dy, d, tNeed
   repeat for each key t in sTok
      put sTok[t]["x"] - kBossX into dx
      put sTok[t]["y"] - kBossY into dy
      put sqrt(dx * dx + dy * dy) into d
      if d < Probe.Radius(max(1, sRings)) + 40 then
         add dx / d * 1.5 to sTok[t]["x"]
         add dy / d * 1.5 to sTok[t]["y"]
         put max(kTop + 10, min(kBottom - 10, sTok[t]["y"])) into sTok[t]["y"]
         put max(kLeft + 10, min(kRight - 10, sTok[t]["x"])) into sTok[t]["x"]
      end if
      SetObjectPosition sTok[t]["key"], sTok[t]["x"], sTok[t]["y"], kZ - 2
      SetObjectRotation sTok[t]["key"], 0, sTicks / 8, 0
      if abs(sTok[t]["x"] - sPX) < 20 and abs(sTok[t]["y"] - (sPY - 10)) < 26 then
         Entity.Kill sTok[t]["key"]
         delete variable sTok[t]
         if the number of chars of sGot < the number of chars of sPass then
            put char (the number of chars of sGot + 1) of sPass after sGot
            FX.Sparks sPX, sPY - 20, kZ, 8, "#FFE060"
            if sGot is sPass then Probe.Say "PASSWORD COMPLETE: HIT THE CONE", 3
         end if
         put empty into sHUDWas
      end if
   end repeat
end Probe.Tokens

on Probe.LoseLife
   FX.Sparks sPX, sPY, kZ, 30, "#40E0FF"
   subtract 1 from sLives
   put 60 into sSafe
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Probe.Say "SPEARED BY YOUR OWN PROBE", 999
      exit Probe.LoseLife
   end if
   Probe.Say "OUCH: A MOVING SPEAR IS DANGEROUS", 2
end Probe.LoseLife

on Probe.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end Probe.Say

on Probe.ShowHUD
   local tWords, tShow, n
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sGot into tShow
   repeat the number of chars of sPass - the number of chars of sGot times
      put "-" after tShow
   end repeat
   put sLevel & "|" & sLives & "|" & tShow & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit Probe.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Probe.Score", "PASSWORD" && tShow && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Probe.Msg"
   if sOver and sWon then
      HUD.Set "Probe.Msg", "THE LAST CONE IS DOWN.  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sOver then
      HUD.Set "Probe.Msg", sMsg & ".  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sMsg is not empty then
      HUD.Set "Probe.Msg", sMsg, 20, 142, 14
   end if
end Probe.ShowHUD

function Probe.State
   return sLevel & "|" & sLives & "|" & sGot & "/" & sPass & "|" & round(sPX) & "," & round(sPY) & "|" & sSpear["state"] & "|" & sTokN & "|" & sOver
end Probe.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
