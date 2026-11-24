######################################################################################
## CARD SCRIPT: "Play.ProbeVsCone"   PROBE VS CONE  (11 13 2026)
## The owner's concept (round two, 9 of 9): a small runner throws a logic-probe spear at a
## boss (the Cone) guarded by rings of shield cubes. A hit cube breaks and drops a key
## token; collect the tokens to assemble the password. Every few seconds the shield
## updates: cubes from an inner ring move out to fill the gaps of the ring outside it.
## A spear that breaks a cube returns to the hand; one that misses bounces off the walls
## and is dangerous until it lies still and is picked up.
## Teaches: aiming, bouncing, a shield that repairs itself.
## CONTROLS  Arrows or WASD: run   aim with the mouse, or Q / E to sweep the aim
##           click or Space: throw   (the dotted line shows the first ricochet)
##           (no mouse: it throws the way you last ran)   Escape: stop
## RULES     geometry foes orbit the Cone fast, swinging out at you: a touch costs a life;
##           a spear smashes them (they come back) and ricochets. Walls and the four bumper
##           bars bank the spear: the first three bounces keep it lively.
##           A fast loose spear that hits you costs a life. Hit the Cone with the
##           password complete. 5 levels.
##           (23 Nov 2026, p1-23) an energy pulse wiggles between the standing cubes of the outer
##           ring: it stops the spear (it drops back loose). Where a cube is gone the gap is open.
##           A loose spear never rests where you can't reach it: it slides out from the shield.
######################################################################################

global bPaused, bPlaying
global gNoMouse        -- true while an AI tests: aim by facing, never read the mouse

local sPX, sPY, sPlayer, sBoss, sRing, sRings, sSpear, sTok, sTokN, sPass, sGot
local sLevel, sLives, sUpdate, sSpeed, sNextUpdate, sOver, sWon, sTicks, sTestKeys, sKeysWas
local sArm, sHeld, sOrb, sOrbN, sBump, sAimAng, sAimMode, sMouseWas, sRay
local sHUDWas, sMsg, sMsgUntil, sSafe, sFaceX, sFaceY, sAimX, sAimY, sAim
local sPulse

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
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 5 into sLives
   put empty into sAimMode          -- mouse aim unless an AI test switched the mouse off
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Probe.StartLevel
end Game.OnStart

-- level table: shield rings | update seconds | spear speed | orbiters | orbit speed (lives carry)
function Probe.Row pLevel
   return line pLevel of ("1,6,10,2,0.035" & cr & "2,5,11,3,0.04" & cr & "2,4,12,4,0.045" & cr & "3,4,13,5,0.05" & cr & "3,3,14,6,0.056")
end Probe.Row

-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Probe.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Probe.StartLevel pLevel
   end if
end Probe.GoLevel

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
   Mesh.Define "Probe.Cone", Mesh.Pyramid(12, 34, 70)
   put Entity.Spawn("Probe.Cone", kBossX, kBossY, kZ, "#B060FF") into sBoss
   -- the shield: ring k has 6 + 4k slots, all filled
   Mesh.Define "Probe.Cube", Mesh.Box(20, 20, 20)
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
   Mesh.Define "Probe.Token", Mesh.Sphere(7, 2, 4)
   -- the runner and the spear
   Mesh.Define "Probe.Man", Probe.ManMesh()
   Mesh.Define "Probe.Spear", Mesh.Box(30, 4, 4)
   put 0 into sPX
   put 230 into sPY
   put Entity.Spawn("Probe.Man", sPX, sPY, kZ, "#40E0FF") into sPlayer
   -- the throwing arm and the spear in its hand follow the aim
   Mesh.Define "Probe.Arm", Probe.ArmMesh()
   Mesh.Define "Probe.Held", Probe.HeldMesh()
   put Entity.Spawn("Probe.Arm", sPX, sPY - 20, kZ, "#40E0FF") into sArm
   put Entity.Spawn("Probe.Held", sPX, sPY - 20, kZ, "#40E0FF") into sHeld
   Mesh.Define "Probe.Aim", Probe.AimMesh()
   put Entity.Spawn("Probe.Aim", sPX, sPY - 65, kZ, "#FFE060") into sAim
   put 0 into sFaceX
   put -1 into sFaceY
   put 0 into sAimX
   put -1 into sAimY
   put empty into sSpear
   put "hand" into sSpear["state"]
   Probe.MakeBumpers
   Probe.MakeOrbiters item 4 of tRow, item 5 of tRow
   if sAimMode is empty then
      put "mouse" into sAimMode
      if gNoMouse is true then put "face" into sAimMode
   end if
   put -pi / 2 into sAimAng
   Mesh.Define "Probe.Ray", Mesh.New()
   put Entity.Spawn("Probe.Ray", 0, 0, kZ, "#806020") into sRay
   Probe.DrawPulse
   put Entity.Spawn("Probe.Pulse", 0, 0, kZ, "#80B0FF") into sPulse
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
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 3, 5
   Mesh.AddLine tM, 2, 6
   return tM
end Probe.ManMesh

-- the throwing arm: shoulder at 0,0, upper arm and forearm reaching along +x
function Probe.ArmMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, 0, 0
   Mesh.AddVertex tM, 8, 3, 0
   Mesh.AddVertex tM, 16, 0, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   return tM
end Probe.ArmMesh

-- the spear in the hand: from behind the hand to well in front of it
function Probe.HeldMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 4, 0, 0
   Mesh.AddVertex tM, 40, 0, 0
   Mesh.AddVertex tM, 34, -3, 0
   Mesh.AddVertex tM, 34, 3, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 2, 4
   return tM
end Probe.HeldMesh

function Probe.Radius k
   return 55 + 42 * k
end Probe.Radius

on Probe.PutCube k, i
   local a
   put (i - 1) / sRing[k]["n"] * 2 * pi into a
   put kBossX + Probe.Radius(k) * sin(a) into sRing[k][i]["x"]
   put kBossY - Probe.Radius(k) * cos(a) into sRing[k][i]["y"]
   if sRing[k][i]["key"] is empty then put Entity.Spawn("Probe.Cube", sRing[k][i]["x"], sRing[k][i]["y"], kZ, item k of "#FF60D0,#FF9040,#FFE060") into sRing[k][i]["key"]
   Entity.SetPosition sRing[k][i]["key"], sRing[k][i]["x"], sRing[k][i]["y"], kZ
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
   Entity.SetPosition sPlayer, sPX, sPY, kZ
   Probe.AimAt
   if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Probe.Throw
   put tKeys into sKeysWas
   if sTicks >= sNextUpdate then
      put sTicks + sUpdate into sNextUpdate
      Probe.Update
   end if
   if sSafe > 0 then subtract 1 from sSafe
   Probe.MoveSpear
   Probe.MoveOrbiters
   Probe.Tokens
   Entity.SetRotation sBoss, 0, sTicks / 30, 0
   Probe.ShowHUD
end Game.OnUpdate

-------------------------------------------------------------------- the spear

-- the aim: toward the mouse pointer over the arena; without a mouse, the way you last ran
on Probe.AimAt
   local tM, tW, dx, dy, d, tKeys
   put Probe.Keys() into tKeys
   -- Q / E sweep the aim round the full circle; moving the mouse takes it back
   if 113 is among the items of tKeys then
      subtract 0.06 from sAimAng
      put "keys" into sAimMode
   end if
   if 101 is among the items of tKeys then
      add 0.06 to sAimAng
      put "keys" into sAimMode
   end if
   if gNoMouse is not true then
      put item 1 to 2 of Engine.Mouse() into tM
      if sMouseWas is not empty and tM is not sMouseWas then put "mouse" into sAimMode
      put tM into sMouseWas
   end if
   if sAimMode is "mouse" and gNoMouse is not true then
      put Probe.ScreenToWorld(item 1 of tM, item 2 of tM) into tW
      if tW is not empty then
         put item 1 of tW - sPX into dx
         put item 2 of tW - (sPY - 20) into dy
         if dx * dx + dy * dy > 1 then put atan2(dy, dx) into sAimAng
      end if
   else if sAimMode is "face" and (sFaceX is not 0 or sFaceY is not 0) then
      put atan2(sFaceY, sFaceX) into sAimAng
   end if
   put cos(sAimAng) into sAimX
   put sin(sAimAng) into sAimY
   if sTicks mod 2 is 0 then Probe.DrawRay
   if sTicks mod 2 is 1 then Probe.DrawPulse
   -- the aim line, in front of the runner
   Entity.SetPosition sAim, sPX + sAimX * 62, sPY - 20 + sAimY * 62, kZ
   Entity.SetRotation sAim, 0, 0, sAimAng
   Entity.SetPosition sArm, sPX, sPY - 20, kZ
   Entity.SetRotation sArm, 0, 0, sAimAng
   -- the spear rides in the hand while it's there; otherwise it's parked out of sight
   if sSpear["state"] is "hand" then
      Entity.SetPosition sHeld, sPX, sPY - 20, kZ
   else
      Entity.SetPosition sHeld, 0, -5000, kZ
   end if
   Entity.SetRotation sHeld, 0, 0, sAimAng
end Probe.AimAt

-- the dotted preview: straight to the first wall or bumper, then the first ricochet
on Probe.DrawRay
   local tM, x, y, vx, vy, n, tHit, tLeg, tR
   put Mesh.New() into tM
   if sSpear["state"] is "hand" then
      put sPX into x
      put sPY - 20 into y
      put sAimX * 10 into vx
      put sAimY * 10 into vy
      repeat with tLeg = 1 to 2
         repeat with n = 1 to 90
            add vx to x
            add vy to y
            if tLeg is 2 and n > 14 then exit repeat
            if n mod 3 is 0 then
               Mesh.AddVertex tM, x, y, 0
               Mesh.AddVertex tM, x + vx * 0.4, y + vy * 0.4, 0
               Mesh.AddLine tM, tM["count"] - 1, tM["count"]
            end if
            put Probe.Reflect(x, y, vx, vy) into tR
            if tR is not empty then
               put item 1 of tR into vx
               put item 2 of tR into vy
               exit repeat
            end if
         end repeat
      end repeat
   end if
   Mesh.Define "Probe.Ray", tM
end Probe.DrawRay

-- a ricochet off the walls or a bumper: the new "vx,vy", or empty when nothing is hit
function Probe.Reflect x, y, vx, vy
   local b, tAX, tAY, tBX, tBY, nx, ny, tLen, tS, tT, tDot
   if x < kLeft and vx < 0 or x > kRight and vx > 0 then return -vx & comma & vy
   if y < kTop and vy < 0 or y > kBottom and vy > 0 then return vx & comma & -vy
   repeat for each key b in sBump
      put item 1 of sBump[b] into tAX
      put item 2 of sBump[b] into tAY
      put item 3 of sBump[b] into tBX
      put item 4 of sBump[b] into tBY
      put sqrt((tBX - tAX) ^ 2 + (tBY - tAY) ^ 2) into tLen
      put -(tBY - tAY) / tLen into nx
      put (tBX - tAX) / tLen into ny
      put (x - tAX) * nx + (y - tAY) * ny into tS
      put ((x - tAX) * (tBX - tAX) + (y - tAY) * (tBY - tAY)) / tLen into tT
      if abs(tS) < 9 and tT >= -4 and tT <= tLen + 4 then
         put vx * nx + vy * ny into tDot
         if tDot * tS < 0 then return (vx - 2 * tDot * nx) & comma & (vy - 2 * tDot * ny)
      end if
   end repeat
   return empty
end Probe.Reflect

-- four angled bars that bank the spear
on Probe.MakeBumpers
   local b, tM
   put empty into sBump
   put "-330,-120,-250,-200" into sBump[1]
   put "330,-120,250,-200" into sBump[2]
   put "-330,150,-250,90" into sBump[3]
   put "330,150,250,90" into sBump[4]
   put Mesh.New() into tM
   repeat for each key b in sBump
      Mesh.AddVertex tM, item 1 of sBump[b], item 2 of sBump[b], 0
      Mesh.AddVertex tM, item 3 of sBump[b], item 4 of sBump[b], 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      Mesh.AddVertex tM, item 1 of sBump[b], item 2 of sBump[b], 6
      Mesh.AddVertex tM, item 3 of sBump[b], item 4 of sBump[b], 6
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   Mesh.Define "Probe.Bumpers", tM
   get Entity.Spawn("Probe.Bumpers", 0, 0, kZ, "#40E0FF")
end Probe.MakeBumpers

-------------------------------------------------------------------- the energy pulse
-- one wiggling ring of energy between the standing cubes of the outer ring (p1-23, 23 Nov 2026).
-- Only between two neighbours that both stand: where a cube is gone the gap stays open.

-- cube i of the outer ring and its neighbour: "ax,ay,bx,by", or empty when either is gone
function Probe.PulseLink i
   local k, j
   put max(1, sRings) into k
   if sRing[k]["n"] is empty or sRing[k]["n"] < 2 then return empty
   put i mod sRing[k]["n"] + 1 into j
   if sRing[k][i]["key"] is empty or sRing[k][j]["key"] is empty then return empty
   return sRing[k][i]["x"] & comma & sRing[k][i]["y"] & comma & sRing[k][j]["x"] & comma & sRing[k][j]["y"]
end Probe.PulseLink

-- the drawn ring: each link in six wiggling pieces, from cube edge to cube edge (cheap: about 100 lines)
on Probe.DrawPulse
   local tM, k, i, tL, tAX, tAY, tBX, tBY, tLen, ux, uy, j, f, w, x, y
   put Mesh.New() into tM
   put max(1, sRings) into k
   repeat with i = 1 to sRing[k]["n"]
      put Probe.PulseLink(i) into tL
      if tL is empty then next repeat
      put item 1 of tL into tAX
      put item 2 of tL into tAY
      put item 3 of tL into tBX
      put item 4 of tL into tBY
      put sqrt((tBX - tAX) ^ 2 + (tBY - tAY) ^ 2) into tLen
      if tLen < 30 then next repeat
      put (tBX - tAX) / tLen into ux
      put (tBY - tAY) / tLen into uy
      repeat with j = 0 to 6
         put (12 + (tLen - 24) * j / 6) into f
         put 0 into w
         if j > 0 and j < 6 then put 5 * sin(sTicks * 0.45 + j * 1.9 + i * 0.7) into w
         put tAX + ux * f - uy * w into x
         put tAY + uy * f + ux * w into y
         Mesh.AddVertex tM, x, y, 0
         if j > 0 then Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      end repeat
   end repeat
   Mesh.Define "Probe.Pulse", tM
end Probe.DrawPulse

-- does the move from x0,y0 to x1,y1 cross a pulse link (away from its two cubes)?
-- the link's unit normal "nx,ny", or empty
function Probe.PulseHit x0, y0, x1, y1
   local k, R, d0, d1, i, tL, tAX, tAY, tBX, tBY, ex, ey, rx, ry, tDen, t, u, tLen
   put max(1, sRings) into k
   put Probe.Radius(k) into R
   put sqrt((x0 - kBossX) ^ 2 + (y0 - kBossY) ^ 2) into d0
   put sqrt((x1 - kBossX) ^ 2 + (y1 - kBossY) ^ 2) into d1
   if min(d0, d1) > R + 4 or max(d0, d1) < R * 0.9 then return empty
   put x1 - x0 into rx
   put y1 - y0 into ry
   repeat with i = 1 to sRing[k]["n"]
      put Probe.PulseLink(i) into tL
      if tL is empty then next repeat
      put item 1 of tL into tAX
      put item 2 of tL into tAY
      put item 3 of tL - tAX into ex
      put item 4 of tL - tAY into ey
      put rx * ey - ry * ex into tDen
      if abs(tDen) < 0.0001 then next repeat
      -- t along the move, u along the link
      put ((tAX - x0) * ey - (tAY - y0) * ex) / tDen into t
      put ((tAX - x0) * ry - (tAY - y0) * rx) / tDen into u
      put sqrt(ex * ex + ey * ey) into tLen
      if t >= 0 and t <= 1 and u * tLen > 16 and u * tLen < tLen - 16 then
         return (-ey / tLen) & comma & (ex / tLen)
      end if
   end repeat
   return empty
end Probe.PulseHit

-- could the runner stand near enough to pick the spear up at x,y?
function Probe.Reachable x, y
   local tPX, tPY
   put max(kLeft + 12, min(kRight - 12, x)) into tPX
   put max(kTop + 30, min(kBottom - 8, y + 10)) into tPY
   if abs(tPX - x) >= 16 or abs(tPY - 10 - y) >= 22 then return false
   return sqrt((tPX - kBossX) ^ 2 + (tPY - kBossY) ^ 2) > Probe.Radius(max(1, sRings)) + 26
end Probe.Reachable

-- an unreachable resting spear slides out from the Cone; under the top wall it slides sideways
on Probe.NudgeSpear
   local dx, dy, d, tS
   put sSpear["x"] - kBossX into dx
   put sSpear["y"] - kBossY into dy
   if abs(dx) < 1 then put 1 into dx
   put sqrt(dx * dx + dy * dy) into d
   add dx / d * 3 to sSpear["x"]
   add dy / d * 3 to sSpear["y"]
   if sSpear["y"] < kTop + 4 then
      put kTop + 4 into sSpear["y"]
      put 1 into tS
      if dx < 0 then put -1 into tS
      add 3 * tS to sSpear["x"]
   end if
   put max(kTop + 4, min(kBottom - 4, sSpear["y"])) into sSpear["y"]
   put max(kLeft + 4, min(kRight - 4, sSpear["x"])) into sSpear["x"]
end Probe.NudgeSpear

-- for tests: put the spear in flight (or loose) at x,y with speed vx,vy
on Probe.TestSpear x, y, vx, vy, pState
   if sSpear["key"] is empty or sSpear["state"] is "hand" then put Entity.Spawn("Probe.Spear", x, y, kZ, "#40E0FF") into sSpear["key"]
   put x into sSpear["x"]
   put y into sSpear["y"]
   put vx into sSpear["vx"]
   put vy into sSpear["vy"]
   if pState is empty then put "flying" into pState
   put pState into sSpear["state"]
   put 0 into sSpear["bounces"]
end Probe.TestSpear

-- for tests: "x,y,vx,vy,state" of the spear
function Probe.TestSpearInfo
   return sSpear["x"] & comma & sSpear["y"] & comma & sSpear["vx"] & comma & sSpear["vy"] & comma & sSpear["state"]
end Probe.TestSpearInfo

-- for tests: "ring,count,x,y of cube i" / break cube i of the outer ring / the runner's place
function Probe.TestCube i
   local k
   put max(1, sRings) into k
   return k & comma & sRing[k]["n"] & comma & sRing[k][i]["x"] & comma & sRing[k][i]["y"] & comma & (sRing[k][i]["key"] is not empty)
end Probe.TestCube

on Probe.TestBreak i
   local k
   put max(1, sRings) into k
   if sRing[k][i]["key"] is not empty then Entity.Kill sRing[k][i]["key"]
   put empty into sRing[k][i]["key"]
end Probe.TestBreak

on Probe.TestPlace x, y, pLevel
   if pLevel is not empty and pLevel is not sLevel then
      put pLevel into sLevel
      Probe.StartLevel
   end if
   put x into sPX
   put y into sPY
   put 999999 into sNextUpdate          -- no shield update in the middle of a test
   put 5 into sLives
   put false into sOver
end Probe.TestPlace

-------------------------------------------------------------------- the orbiters

-- geometry foes circling the Cone: each swings in and out, some the other way round
on Probe.MakeOrbiters pCount, pSpeed
   local n, tShape
   put empty into sOrb
   put pCount into sOrbN
   Mesh.Define "Probe.Tetra", Mesh.Pyramid(3, 16, 26)
   Mesh.Define "Probe.Octa", Mesh.Sphere(15, 2, 4)
   Mesh.Define "Probe.Box", Mesh.Box(22, 22, 22)
   repeat with n = 1 to pCount
      put item (n - 1) mod 3 + 1 of "Probe.Tetra,Probe.Octa,Probe.Box" into sOrb[n]["mesh"]
      put n * 2 * pi / pCount into sOrb[n]["a"]
      put pSpeed * (1 + (n mod 3) * 0.25) into sOrb[n]["w"]
      if n mod 2 is 0 then put -sOrb[n]["w"] into sOrb[n]["w"]
      put Probe.Radius(max(1, sRings)) + 50 + (n mod 2) * 25 into sOrb[n]["r"]
      put 50 + (n mod 3) * 15 into sOrb[n]["swing"]
      put n * 1.7 into sOrb[n]["phase"]
      put 0 into sOrb[n]["deadUntil"]
      Probe.OrbSpawn n
   end repeat
end Probe.MakeOrbiters

on Probe.OrbSpawn n
   put Entity.Spawn(sOrb[n]["mesh"], 0, 0, kZ - 3, item (n - 1) mod 3 + 1 of "#FF5050,#FFB000,#FF60D0") into sOrb[n]["key"]
end Probe.OrbSpawn

on Probe.MoveOrbiters
   local n, r, dx, dy, d, tN
   repeat with n = 1 to sOrbN
      if sOrb[n]["key"] is empty then
         if sTicks >= sOrb[n]["deadUntil"] then Probe.OrbSpawn n
         next repeat
      end if
      add sOrb[n]["w"] to sOrb[n]["a"]
      put sOrb[n]["r"] + sOrb[n]["swing"] * sin(sTicks / 40 + sOrb[n]["phase"]) into r
      put min(r, kBossY - kTop - 18) into r          -- never out past the top of the arena
      put kBossX + r * cos(sOrb[n]["a"]) into sOrb[n]["x"]
      put kBossY + r * sin(sOrb[n]["a"]) into sOrb[n]["y"]
      Entity.SetPosition sOrb[n]["key"], sOrb[n]["x"], sOrb[n]["y"], kZ - 3
      Entity.SetRotation sOrb[n]["key"], sTicks / 6, sTicks / 9, 0
      -- the spear smashes it and ricochets off
      if sSpear["state"] is "flying" or sSpear["state"] is "loose" then
         put sSpear["x"] - sOrb[n]["x"] into dx
         put sSpear["y"] - sOrb[n]["y"] into dy
         put sqrt(dx * dx + dy * dy) into d
         if d < 20 and d > 0.01 then
            FX.Sparks sOrb[n]["x"], sOrb[n]["y"], kZ, 16, "#FF5050"
            Entity.Kill sOrb[n]["key"]
            put empty into sOrb[n]["key"]
            put sTicks + 180 into sOrb[n]["deadUntil"]
            put (sSpear["vx"] * dx + sSpear["vy"] * dy) / d into tN
            if tN < 0 then
               subtract 2 * tN * dx / d from sSpear["vx"]
               subtract 2 * tN * dy / d from sSpear["vy"]
            end if
            Probe.Say "SMASHED", 1
            next repeat
         end if
      end if
      -- a touch costs a life
      if sSafe <= 0 and abs(sOrb[n]["x"] - sPX) < 20 and abs(sOrb[n]["y"] - (sPY - 12)) < 24 then Probe.LoseLife
   end repeat
end Probe.MoveOrbiters

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
   put 0 into sSpear["bounces"]
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
   local tX0, tY0, tN
   put sSpear["x"] into tX0
   put sSpear["y"] into tY0
   add sSpear["vx"] to sSpear["x"]
   add sSpear["vy"] to sSpear["y"]
   -- the energy pulse: the spear stops short of it and drops back, loose and slow
   put Probe.PulseHit(tX0, tY0, sSpear["x"], sSpear["y"]) into tN
   if tN is not empty then
      put tX0 into sSpear["x"]
      put tY0 into sSpear["y"]
      put sSpear["vx"] * item 1 of tN + sSpear["vy"] * item 2 of tN into tV
      put (sSpear["vx"] - 2 * tV * item 1 of tN) * 0.3 into sSpear["vx"]
      put (sSpear["vy"] - 2 * tV * item 2 of tN) * 0.3 into sSpear["vy"]
      put "loose" into sSpear["state"]
      FX.Sparks sSpear["x"], sSpear["y"], kZ, 6, "#80B0FF"
      if sMsg is empty then Probe.Say "ENERGY PULSE: AIM FOR A CUBE OR A GAP", 1
   end if
   -- ricochets off walls and bumpers: the first three keep the spear lively
   get Probe.Reflect(sSpear["x"], sSpear["y"], sSpear["vx"], sSpear["vy"])
   if it is not empty then
      put item 1 of it into sSpear["vx"]
      put item 2 of it into sSpear["vy"]
      put max(kLeft, min(kRight, sSpear["x"])) into sSpear["x"]
      put max(kTop, min(kBottom, sSpear["y"])) into sSpear["y"]
      add 1 to sSpear["bounces"]
      FX.Sparks sSpear["x"], sSpear["y"], kZ, 4, "#40E0FF"
      if sSpear["bounces"] > 3 then
         put sSpear["vx"] * 0.75 into sSpear["vx"]
         put sSpear["vy"] * 0.75 into sSpear["vy"]
         put "loose" into sSpear["state"]
      end if
   end if
   if sSpear["state"] is "loose" then
      put sSpear["vx"] * 0.985 into sSpear["vx"]
      put sSpear["vy"] * 0.985 into sSpear["vy"]
   end if
   put sqrt(sSpear["vx"] ^ 2 + sSpear["vy"] ^ 2) into tV
   -- shield cubes: one breaks, drops a key, and the spear comes home
   -- (a spear barely moving, or sliding out to reach, breaks nothing: no free keys)
   repeat with k = 1 to sRings
      if tV < 2 then exit repeat
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
   -- the Cone (only a spear coming at it: one inside its box going away is left to fly out)
   if abs(sSpear["x"] - kBossX) < 22 and abs(sSpear["y"] - kBossY) < 30 and tV > 1 and sSpear["vx"] * (kBossX - sSpear["x"]) + sSpear["vy"] * (kBossY - sSpear["y"]) > 0 then
      if the number of chars of sGot >= the number of chars of sPass then
         FX.Sparks kBossX, kBossY, kZ, 60, "#B060FF"
         Entity.Kill sSpear["key"]
         put "hand" into sSpear["state"]
         if sLevel >= 5 then
            put true into sOver
            put true into sWon
         else
            add 1 to sLevel
            Probe.GoLevel sLevel
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
      -- slowing down where the runner can't reach (at the Cone, inside the shield, under the top
      -- wall over the Cone): it stops and slides out to the nearest place he can reach
      if tV < 2 and not Probe.Reachable(sSpear["x"], sSpear["y"]) then
         put 0 into sSpear["vx"]
         put 0 into sSpear["vy"]
         Probe.NudgeSpear
      else if tV < 0.3 then
         put 0 into sSpear["vx"]
         put 0 into sSpear["vy"]
      end if
   end if
   Probe.PlaceSpear
end Probe.MoveSpear

on Probe.PlaceSpear
   Entity.SetPosition sSpear["key"], sSpear["x"], sSpear["y"], kZ
   Entity.SetRotation sSpear["key"], 0, 0, atan2(sSpear["vy"], sSpear["vx"])
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
      Entity.SetPosition sTok[t]["key"], sTok[t]["x"], sTok[t]["y"], kZ - 2
      Entity.SetRotation sTok[t]["key"], 0, sTicks / 8, 0
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
