######################################################################################
## CARD SCRIPT: "Play.ConeProbe3D"   CONE PROBE 3D  (23 Nov 2026, p1-29)
## Probe vs Cone in THIRD PERSON: the camera rides behind and above Probe and turns with him,
## like an MMO. The rules are Probe vs Cone's: break the shield cubes round the Cone, collect the
## key tokens they drop to spell the password, then put the javelin into the Cone. An energy pulse
## joins the standing cubes of the outer ring: it stops a javelin; where a cube is gone the gap
## is open. Every few seconds the shield repairs itself from the ring inside.
## CONTROLS  W S or Up Down: run forward / back   A D or Left Right: turn
##           Q E: step sideways   Space (or hold the mouse button): charge the javelin,
##           let go to throw it along your facing; the longer you hold, the farther it flies
##           power bar: 1 quick throw   2 dash (dodge forward)   3 recall the javelin
##           Escape: pause
## RULES     geometry foes orbit the Cone: a touch costs a life; a javelin smashes them.
##           A fast loose javelin that hits you costs a life; walk over a still one to pick
##           it up. Hit the Cone with the password complete. 5 levels.
## TWO ENGINES  a game for Engine 1 (Vibecode3D, iGame3D XT); only engine contract calls, so
##           the xRay bench can play it. LIB_POWERBAR draws its bar when it is found.
## TUTORIAL  ConeProbe3D/README.md: how a flat game becomes a third-person one.
######################################################################################

global bPaused, bPlaying
global gNoMouse        -- true while an AI tests: never read the mouse

-- the game is worked out on a flat PLAN (x right, y toward the start, as Probe vs Cone);
-- CP3.Put stands it in the world: world x = x, world z = -y, world y = -height
local sPX, sPY, sHead, sPlayer, sManMesh, sStep, sBoss, sRing, sRings, sRingObj, sRingDirty
local sSpear, sTok, sTokN, sPass, sGot, sLevel, sLives, sUpdate, sSpeed, sNextUpdate
local sOver, sWon, sTicks, sTestKeys, sKeysWas, sOrb, sOrbN, sBump, sRay, sPulse
local sHUDWas, sMsg, sMsgUntil, sSafe, sCharge, sCharging, sMouseDown, sThrewAt, sDash
local sCamA, sBar, sCool

constant kLeft = -380
constant kRight = 380
constant kTop = -230
constant kBottom = 290
constant kBossX = 0
constant kBossY = -30
constant kRun = 4
constant kTurn = 0.07
constant kCamBack = 150
constant kCamUp = 75
constant kWords = "KEY,CODE,LOGIC,PROBES,CONEDOWN"
constant kBar = "CP3"

-------------------------------------------------------------------- 1. THE ENGINE CALLS US

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 5 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put -1000 into sThrewAt
   CP3.UseBar
   CP3.StartLevel 1
end Game.OnStart

on Game.OnStop
   HUD.Clear
   if sBar then PowerBar.Remove kBar
end Game.OnStop

-- a level change through the loading screen (LIB_LOADING_SCREEN) when the host has it
on CP3.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      CP3.StartLevel pLevel
   end if
end CP3.GoLevel

-- the loading screen starts its reveal at Probe
function CP3.Player
   return sPlayer
end CP3.Player

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey

-------------------------------------------------------------------- 2. THE POWER BAR (LIB_POWERBAR)
-- one page, three slots. Without the library the game keeps its own cooldowns and plays on.

on CP3.UseBar
   local tLib, tErr
   put false into sBar
   put empty into sCool
   if "lib_powerbar" is among the lines of the stacksInUse then
      put true into sBar
   else
      put Game.FindFile("LIB_POWERBAR/livecode/lib_powerbar.livecodescript") into tLib
      if tLib is not empty then
         try
            start using stack tLib
            put true into sBar
         catch tErr
            put false into sBar
         end try
      end if
   end if
   if not sBar then exit CP3.UseBar
   PowerBar.New kBar, 1, 3
   PowerBar.Set kBar, 1, 1, "javelin"
   PowerBar.Set kBar, 1, 2, "dash"
   PowerBar.Set kBar, 1, 3, "recall"
   PowerBar.SetInfo kBar, "javelin", "JAV", empty, 0.5
   PowerBar.SetInfo kBar, "dash", "DSH", empty, 3
   PowerBar.SetInfo kBar, "recall", "RCL", empty, 8
   try
      PowerBar.Draw kBar, 20, the height of this stack - 84, 44
   catch tErr
      -- no card to draw on (a test with no window): the bar still counts
   end try
end CP3.UseBar

function CP3.CoolOf pThing
   switch pThing
      case "javelin"
         return 0.5
      case "dash"
         return 3
   end switch
   return 8
end CP3.CoolOf

function CP3.SlotOf pThing
   return itemOffset(pThing, "javelin,dash,recall")
end CP3.SlotOf

function CP3.Ready pThing
   if sBar then return PowerBar.Ready(kBar, 1, CP3.SlotOf(pThing), empty)
   return not (sCool[pThing] > 0)
end CP3.Ready

-- use a slot: true when it fired (and its cooldown starts)
function CP3.Use pThing
   if sBar then
      PowerBar.Select kBar, CP3.SlotOf(pThing)
      return PowerBar.Fire(kBar, empty) is pThing
   end if
   if sCool[pThing] > 0 then return false
   put CP3.CoolOf(pThing) into sCool[pThing]
   return true
end CP3.Use

on CP3.BarStep
   local tK
   if sBar then
      get PowerBar.Step(kBar, 1 / 30, empty)
      if sTicks mod 3 is 0 then
         try
            PowerBar.Refresh kBar, empty
         catch tK
         end try
      end if
      exit CP3.BarStep
   end if
   repeat for each key tK in sCool
      put max(0, sCool[tK] - 1 / 30) into sCool[tK]
   end repeat
end CP3.BarStep

-------------------------------------------------------------------- 3. THE LEVEL

-- level table: shield rings | update seconds | javelin speed | orbiters | orbit speed (lives carry)
function CP3.Row pLevel
   return line pLevel of ("1,6,10,2,0.035" & cr & "2,5,11,3,0.04" & cr & "2,4,12,4,0.045" & cr & "3,4,13,5,0.05" & cr & "3,3,14,6,0.056")
end CP3.Row

on CP3.StartLevel pLevel
   local tRow, k, i, tName
   if pLevel is an integer and pLevel >= 1 and pLevel <= 5 then put pLevel into sLevel
   put CP3.Row(sLevel) into tRow
   put item 1 of tRow into sRings
   put item 2 of tRow * 30 into sUpdate
   put item 3 of tRow into sSpeed
   put item sLevel of kWords into sPass
   put empty into sGot
   Scene.ClearAll
   Mesh.Define "CP3.Arena", CP3.ArenaMesh()
   get Entity.Spawn("CP3.Arena", 0, 0, 0, "#1C4A2A")
   Mesh.Define "CP3.Cone", Mesh.Pyramid(12, 34, 70)
   put Entity.Spawn("CP3.Cone", kBossX, -35, -kBossY, "#B060FF") into sBoss
   -- the shield: ring k has 6 + 4k slots, all filled; each ring is ONE object (few objects, fast)
   put empty into sRing
   put empty into sRingObj
   repeat with k = 1 to sRings
      put 6 + 4 * k into sRing[k]["n"]
      repeat with i = 1 to sRing[k]["n"]
         CP3.PutCube k, i
      end repeat
      Mesh.Define "CP3.Ring" & k, CP3.RingMesh(k)
      put Entity.Spawn("CP3.Ring" & k, 0, 0, 0, item k of "#FF60D0,#FF9040,#FFE060") into sRingObj[k]
   end repeat
   put false into sRingDirty
   put empty into sTok
   put 0 into sTokN
   Mesh.Define "CP3.Token", Mesh.Sphere(7, 2, 4)
   Mesh.Define "CP3.Spear", CP3.SpearMesh()
   -- Probe, at the start, facing the Cone
   put 0 into sPX
   put 230 into sPY
   put -pi / 2 into sHead
   put sHead into sCamA
   put 0 into sStep
   put empty into sManMesh
   put CP3.ManName(0) into tName
   put Entity.Spawn(tName, sPX, 0, -sPY, "#40E0FF") into sPlayer
   put tName into sManMesh
   put empty into sSpear
   put "hand" into sSpear["state"]
   put 0 into sCharge
   put false into sCharging
   put 0 into sDash
   CP3.MakeBumpers
   CP3.MakeOrbiters item 4 of tRow, item 5 of tRow
   Mesh.Define "CP3.Ray", Mesh.New()
   put Entity.Spawn("CP3.Ray", 0, 0, 0, "#806020") into sRay
   CP3.DrawPulse
   put Entity.Spawn("CP3.Pulse", 0, 0, 0, "#80B0FF") into sPulse
   put sTicks + sUpdate into sNextUpdate
   put 0 into sSafe
   CP3.Place
   CP3.Camera
   CP3.Say "BREAK CUBES, COLLECT" && the number of chars of sPass && "KEYS, THEN HIT THE CONE", 4
   put empty into sHUDWas
end CP3.StartLevel

-------------------------------------------------------------------- 4. FROM PLAN TO WORLD

-- an object at plan x,y, pH units above the ground
on CP3.Put pId, pX, pY, pH
   Entity.SetPosition pId, pX, -pH, -pY
end CP3.Put

-- a point of a mesh that sits at the world's origin
on CP3.Vert @pM, pX, pY, pH
   Mesh.AddVertex pM, pX, -pH, -pY
end CP3.Vert

on CP3.Line @pM, pX1, pY1, pH1, pX2, pY2, pH2
   CP3.Vert pM, pX1, pY1, pH1
   CP3.Vert pM, pX2, pY2, pH2
   Mesh.AddLine pM, pM["count"] - 1, pM["count"]
end CP3.Line

-- the floor frame, low walls and a few ground lines (a sense of speed when you run)
function CP3.ArenaMesh
   local tM, x, y, tH
   put Mesh.New() into tM
   repeat for each item tH in "0,24"
      CP3.Line tM, kLeft, kTop, tH, kRight, kTop, tH
      CP3.Line tM, kRight, kTop, tH, kRight, kBottom, tH
      CP3.Line tM, kRight, kBottom, tH, kLeft, kBottom, tH
      CP3.Line tM, kLeft, kBottom, tH, kLeft, kTop, tH
   end repeat
   CP3.Line tM, kLeft, kTop, 0, kLeft, kTop, 24
   CP3.Line tM, kRight, kTop, 0, kRight, kTop, 24
   CP3.Line tM, kRight, kBottom, 0, kRight, kBottom, 24
   CP3.Line tM, kLeft, kBottom, 0, kLeft, kBottom, 24
   repeat with x = kLeft + 95 to kRight - 95 step 95
      CP3.Line tM, x, kTop, 0, x, kBottom, 0
   end repeat
   repeat with y = kTop + 104 to kBottom - 104 step 104
      CP3.Line tM, kLeft, y, 0, kRight, y, 0
   end repeat
   return tM
end CP3.ArenaMesh

-- Probe, facing +x (the engine turns +x to his heading): pLegs 0 stand, 1 and 2 the stride;
-- pHold 0 empty-handed, 1 to 4 the javelin held, drawn further back as it charges
function CP3.ManName pCharge
   local tLegs, tHold
   put 0 into tLegs
   if sStep > 0 then put 1 + (sStep div 6) mod 2 into tLegs
   put 0 into tHold
   if sSpear["state"] is "hand" then put 1 + min(3, trunc(pCharge * 4)) into tHold
   put "CP3.Man" & tLegs & tHold into tLegs
   if not Mesh.Has(tLegs) then Mesh.Define tLegs, CP3.ManMesh(char 8 of tLegs, char 9 of tLegs)
   return tLegs
end CP3.ManName

function CP3.ManMesh pLegs, pHold
   local tM, f, p, hx
   put Mesh.New() into tM
   -- legs: hip (0,-14,0) to the feet
   put item pLegs + 1 of "0,6,-6" into f
   Mesh.AddVertex tM, 0, -14, 0
   Mesh.AddVertex tM, f, 0, 3
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   Mesh.AddVertex tM, 0, -14, 0
   Mesh.AddVertex tM, -f, 0, -3
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   -- body, shoulders, head (a diamond seen from behind)
   Mesh.AddVertex tM, 0, -14, 0
   Mesh.AddVertex tM, 0, -26, 0
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   Mesh.AddVertex tM, 0, -25, -5
   Mesh.AddVertex tM, 0, -25, 5
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   Mesh.AddVertex tM, 0, -36, 0
   Mesh.AddVertex tM, 0, -31, 3
   Mesh.AddVertex tM, 0, -26, 0
   Mesh.AddVertex tM, 0, -31, -3
   Mesh.AddLine tM, tM["count"] - 3, tM["count"] - 2
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   Mesh.AddLine tM, tM["count"], tM["count"] - 3
   -- the other arm hangs
   Mesh.AddVertex tM, 0, -25, -5
   Mesh.AddVertex tM, 3, -15, -6
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   -- the throwing arm: with the javelin it reaches back as the charge grows
   if pHold is 0 then
      Mesh.AddVertex tM, 0, -25, 5
      Mesh.AddVertex tM, 4, -15, 6
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      return tM
   end if
   put (pHold - 1) * 5 into p
   put 8 - p into hx
   Mesh.AddVertex tM, 0, -25, 5
   Mesh.AddVertex tM, -2 - p / 2, -21, 7
   Mesh.AddVertex tM, hx, -28, 6
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   -- the javelin in the hand
   Mesh.AddVertex tM, hx - 14, -27, 6
   Mesh.AddVertex tM, hx + 28, -30, 6
   Mesh.AddVertex tM, hx + 22, -33, 6
   Mesh.AddVertex tM, hx + 22, -27, 6
   Mesh.AddLine tM, tM["count"] - 3, tM["count"] - 2
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 2, tM["count"]
   return tM
end CP3.ManMesh

-- the flying javelin: along +x, point at +16
function CP3.SpearMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -16, 0, 0
   Mesh.AddVertex tM, 16, 0, 0
   Mesh.AddVertex tM, 10, -3, 0
   Mesh.AddVertex tM, 10, 3, 0
   Mesh.AddVertex tM, 10, 0, 3
   Mesh.AddVertex tM, 10, 0, -3
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 2, 4
   Mesh.AddLine tM, 2, 5
   Mesh.AddLine tM, 2, 6
   return tM
end CP3.SpearMesh

-------------------------------------------------------------------- 5. THE SHIELD

function CP3.Radius k
   return 55 + 42 * k
end CP3.Radius

on CP3.PutCube k, i
   local a
   put (i - 1) / sRing[k]["n"] * 2 * pi into a
   put kBossX + CP3.Radius(k) * sin(a) into sRing[k][i]["x"]
   put kBossY - CP3.Radius(k) * cos(a) into sRing[k][i]["y"]
   put true into sRing[k][i]["up"]
   put true into sRingDirty
end CP3.PutCube

-- every standing cube of ring k as wire boxes in one mesh
function CP3.RingMesh k
   local tM, i, x, y, tH
   put Mesh.New() into tM
   repeat with i = 1 to sRing[k]["n"]
      if sRing[k][i]["up"] is not true then next repeat
      put sRing[k][i]["x"] into x
      put sRing[k][i]["y"] into y
      repeat for each item tH in "0,20"
         CP3.Line tM, x - 10, y - 10, tH, x + 10, y - 10, tH
         CP3.Line tM, x + 10, y - 10, tH, x + 10, y + 10, tH
         CP3.Line tM, x + 10, y + 10, tH, x - 10, y + 10, tH
         CP3.Line tM, x - 10, y + 10, tH, x - 10, y - 10, tH
      end repeat
      CP3.Line tM, x - 10, y - 10, 0, x - 10, y - 10, 20
      CP3.Line tM, x + 10, y - 10, 0, x + 10, y - 10, 20
      CP3.Line tM, x + 10, y + 10, 0, x + 10, y + 10, 20
      CP3.Line tM, x - 10, y + 10, 0, x - 10, y + 10, 20
   end repeat
   return tM
end CP3.RingMesh

-- the rings are drawn again only when a cube broke or moved
on CP3.RedrawRings
   local k
   if not sRingDirty then exit CP3.RedrawRings
   put false into sRingDirty
   repeat with k = 1 to sRings
      Mesh.Define "CP3.Ring" & k, CP3.RingMesh(k)
   end repeat
end CP3.RedrawRings

on CP3.BreakCube k, i
   put false into sRing[k][i]["up"]
   put true into sRingDirty
end CP3.BreakCube

-- the shield update: each gap in a ring is filled by a cube from the ring inside it
on CP3.Update
   local k, i, j, tFrom
   repeat with k = sRings down to 2
      repeat with i = 1 to sRing[k]["n"]
         if sRing[k][i]["up"] is true then next repeat
         put empty into tFrom
         repeat with j = 1 to sRing[k - 1]["n"]
            if sRing[k - 1][j]["up"] is true then
               put j into tFrom
               exit repeat
            end if
         end repeat
         if tFrom is empty then exit repeat
         CP3.BreakCube k - 1, tFrom
         CP3.PutCube k, i
         FX.Sparks sRing[k][i]["x"], -10, -sRing[k][i]["y"], 3, "#FFE060"
      end repeat
   end repeat
   CP3.Say "SHIELD UPDATE", 1
end CP3.Update

-------------------------------------------------------------------- 6. THE ENERGY PULSE
-- one wiggling strand between the standing cubes of the outer ring (Probe vs Cone's p1-23):
-- it stops the javelin; where a cube is gone the gap is open. Here it wiggles up and down.

function CP3.PulseLink i
   local k, j
   put max(1, sRings) into k
   if sRing[k]["n"] is empty or sRing[k]["n"] < 2 then return empty
   put i mod sRing[k]["n"] + 1 into j
   if sRing[k][i]["up"] is not true or sRing[k][j]["up"] is not true then return empty
   return sRing[k][i]["x"] & comma & sRing[k][i]["y"] & comma & sRing[k][j]["x"] & comma & sRing[k][j]["y"]
end CP3.PulseLink

on CP3.DrawPulse
   local tM, k, i, tL, tAX, tAY, tBX, tBY, tLen, ux, uy, j, f, w
   put Mesh.New() into tM
   put max(1, sRings) into k
   repeat with i = 1 to sRing[k]["n"]
      put CP3.PulseLink(i) into tL
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
         CP3.Vert tM, tAX + ux * f, tAY + uy * f, 10 + w
         if j > 0 then Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      end repeat
   end repeat
   Mesh.Define "CP3.Pulse", tM
end CP3.DrawPulse

-- does the move from x0,y0 to x1,y1 cross a pulse link (away from its two cubes)?
-- the link's unit normal "nx,ny", or empty
function CP3.PulseHit x0, y0, x1, y1
   local k, R, d0, d1, i, tL, tAX, tAY, ex, ey, rx, ry, tDen, t, u, tLen
   put max(1, sRings) into k
   put CP3.Radius(k) into R
   put sqrt((x0 - kBossX) ^ 2 + (y0 - kBossY) ^ 2) into d0
   put sqrt((x1 - kBossX) ^ 2 + (y1 - kBossY) ^ 2) into d1
   if min(d0, d1) > R + 4 or max(d0, d1) < R * 0.9 then return empty
   put x1 - x0 into rx
   put y1 - y0 into ry
   repeat with i = 1 to sRing[k]["n"]
      put CP3.PulseLink(i) into tL
      if tL is empty then next repeat
      put item 1 of tL into tAX
      put item 2 of tL into tAY
      put item 3 of tL - tAX into ex
      put item 4 of tL - tAY into ey
      put rx * ey - ry * ex into tDen
      if abs(tDen) < 0.0001 then next repeat
      put ((tAX - x0) * ey - (tAY - y0) * ex) / tDen into t
      put ((tAX - x0) * ry - (tAY - y0) * rx) / tDen into u
      put sqrt(ex * ex + ey * ey) into tLen
      if t >= 0 and t <= 1 and u * tLen > 16 and u * tLen < tLen - 16 then
         return (-ey / tLen) & comma & (ex / tLen)
      end if
   end repeat
   return empty
end CP3.PulseHit

-------------------------------------------------------------------- 7. EACH STEP

function CP3.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end CP3.Keys

function CP3.Down pCodes, pKeys
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys then return true
   end repeat
   return false
end CP3.Down

function CP3.Pressed pCodes, pKeys
   return CP3.Down(pCodes, pKeys) and not CP3.Down(pCodes, sKeysWas)
end CP3.Pressed

on Game.OnUpdate
   local tKeys, tFwd, tSide, nx, ny, tHold, tM
   add 1 to sTicks
   put CP3.Keys() into tKeys
   if sOver then
      if CP3.Pressed(32, tKeys) then Game.OnStart
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   CP3.BarStep
   -- turn (A D, Left Right), run (W S, Up Down), step sideways (Q E)
   if CP3.Down("97,65361", tKeys) then subtract kTurn from sHead
   if CP3.Down("100,65363", tKeys) then add kTurn to sHead
   put 0 into tFwd
   put 0 into tSide
   if CP3.Down("119,65362", tKeys) then put 1 into tFwd
   if CP3.Down("115,65364", tKeys) then put -0.6 into tFwd
   if CP3.Down(113, tKeys) then put -0.8 into tSide
   if CP3.Down(101, tKeys) then put 0.8 into tSide
   if sDash > 0 then
      subtract 1 from sDash
      put 3 into tFwd
   end if
   if tFwd is not 0 or tSide is not 0 then
      put sPX + (cos(sHead) * tFwd - sin(sHead) * tSide) * kRun into nx
      put sPY + (sin(sHead) * tFwd + cos(sHead) * tSide) * kRun into ny
      CP3.MoveTo nx, ny
      add 1 to sStep
   else
      put 0 into sStep
   end if
   -- the power bar: 1 quick throw, 2 dash, 3 recall
   if CP3.Pressed(49, tKeys) and sSpear["state"] is "hand" and CP3.Use("javelin") then CP3.Throw 0
   if CP3.Pressed(50, tKeys) then CP3.Dash
   if CP3.Pressed(51, tKeys) then CP3.Recall
   -- hold Space (or the mouse button) to charge, let go to throw
   put CP3.Down(32, tKeys) into tHold
   if gNoMouse is not true then
      put Engine.Mouse() into tM
      if item 3 of tM is true then put true into tHold
   end if
   if tHold then
      if sCharging then
         put min(1, sCharge + 1 / 30) into sCharge
      else if sSpear["state"] is "hand" and CP3.Ready("javelin") and not CP3.Down(32, sKeysWas) then
         put true into sCharging
         put 1 / 30 into sCharge
      end if
   else if sCharging then
      put false into sCharging
      if CP3.Use("javelin") then CP3.Throw sCharge
      put 0 into sCharge
   end if
   put tKeys into sKeysWas
   if sTicks >= sNextUpdate then
      put sTicks + sUpdate into sNextUpdate
      CP3.Update
   end if
   if sSafe > 0 then subtract 1 from sSafe
   CP3.MoveSpear
   CP3.MoveOrbiters
   CP3.Tokens
   CP3.RedrawRings
   if sTicks mod 2 is 0 then CP3.DrawRay
   if sTicks mod 2 is 1 then CP3.DrawPulse
   Entity.SetRotation sBoss, 0, sTicks / 30, 0
   CP3.Place
   CP3.Camera
   CP3.ShowHUD
end Game.OnUpdate

-- a step: walls stop him; the outer ring pushes him round it (he slides, never sticks)
on CP3.MoveTo nx, ny
   local d, R
   put max(kLeft + 12, min(kRight - 12, nx)) into nx
   put max(kTop + 12, min(kBottom - 12, ny)) into ny
   put CP3.Radius(max(1, sRings)) + 26 into R
   put sqrt((nx - kBossX) ^ 2 + (ny - kBossY) ^ 2) into d
   if d <= R then
      if d < 0.01 then put 0.01 into d
      put kBossX + (nx - kBossX) / d * (R + 0.01) into nx
      put kBossY + (ny - kBossY) / d * (R + 0.01) into ny
      if nx < kLeft + 12 or nx > kRight - 12 or ny < kTop + 12 or ny > kBottom - 12 then exit CP3.MoveTo
   end if
   put nx into sPX
   put ny into sPY
end CP3.MoveTo

on CP3.Place
   local tName
   put CP3.ManName(sCharge) into tName
   if tName is not sManMesh then
      Entity.SetMesh sPlayer, tName
      put tName into sManMesh
   end if
   CP3.Put sPlayer, sPX, sPY, 0
   Entity.SetRotation sPlayer, 0, sHead, 0
end CP3.Place

-- behind and above Probe, turning after him (a little late, so a turn feels like a turn)
on CP3.Camera
   local tCX, tCY, tTX, tTY, tDX, tDZ, tDH
   put sCamA + (sHead - sCamA) * 0.35 into sCamA
   put sPX - cos(sCamA) * kCamBack into tCX
   put sPY - sin(sCamA) * kCamBack into tCY
   put sPX + cos(sCamA) * 80 into tTX
   put sPY + sin(sCamA) * 80 into tTY
   put tTX - tCX into tDX
   put -(tTY - tCY) into tDZ
   put 15 - kCamUp into tDH
   Camera.SetPosition tCX, -kCamUp, -tCY
   Camera.SetLook atan2(tDX, tDZ), atan2(tDH, sqrt(tDX ^ 2 + tDZ ^ 2))
end CP3.Camera

-------------------------------------------------------------------- 8. THE JAVELIN

-- how fast and how long a throw of charge pC (0 a tap .. 1 full) flies
function CP3.ThrowSpeed pC
   return sSpeed * (0.55 + 0.6 * pC)
end CP3.ThrowSpeed

function CP3.FlyTime pC
   return round(10 + 50 * pC)
end CP3.FlyTime

on CP3.Throw pC
   if sSpear["state"] is not "hand" then exit CP3.Throw
   put sPX + cos(sHead) * 8 into sSpear["x"]
   put sPY + sin(sHead) * 8 into sSpear["y"]
   put cos(sHead) * CP3.ThrowSpeed(pC) into sSpear["vx"]
   put sin(sHead) * CP3.ThrowSpeed(pC) into sSpear["vy"]
   put "flying" into sSpear["state"]
   put 0 into sSpear["bounces"]
   put 0 into sSpear["fly"]
   put CP3.FlyTime(pC) into sSpear["flyT"]
   put pC into sSpear["c"]
   put 26 into sSpear["h"]
   put sTicks into sThrewAt
   put Entity.Spawn("CP3.Spear", sSpear["x"], -26, -sSpear["y"], "#40E0FF") into sSpear["key"]
end CP3.Throw

on CP3.Dash
   if sDash > 0 or not CP3.Use("dash") then exit CP3.Dash
   put 10 into sDash
   put max(sSafe, 12) into sSafe
   FX.Sparks sPX, -10, -sPY, 8, "#40E0FF"
end CP3.Dash

on CP3.Recall
   if sSpear["state"] is "hand" or sSpear["state"] is "return" then exit CP3.Recall
   if not CP3.Use("recall") then exit CP3.Recall
   put "return" into sSpear["state"]
   CP3.Say "RECALL", 1
end CP3.Recall

-- the dotted preview on the ground: as far as the charge would carry it, with the first ricochet
on CP3.DrawRay
   local tM, x, y, vx, vy, n, tR, tSteps, tC
   put Mesh.New() into tM
   if sSpear["state"] is "hand" then
      put sCharge into tC
      put CP3.FlyTime(tC) into tSteps
      put sPX + cos(sHead) * 8 into x
      put sPY + sin(sHead) * 8 into y
      put cos(sHead) * CP3.ThrowSpeed(tC) into vx
      put sin(sHead) * CP3.ThrowSpeed(tC) into vy
      repeat with n = 1 to tSteps
         add vx to x
         add vy to y
         if n mod 3 is 0 then CP3.Line tM, x, y, 2, x + vx * 0.4, y + vy * 0.4, 2
         put CP3.Reflect(x, y, vx, vy) into tR
         if tR is not empty then
            put item 1 of tR into vx
            put item 2 of tR into vy
         end if
      end repeat
   end if
   Mesh.Define "CP3.Ray", tM
end CP3.DrawRay

-- a ricochet off the walls or a bumper: the new "vx,vy", or empty when nothing is hit
function CP3.Reflect x, y, vx, vy
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
end CP3.Reflect

-- four angled low walls that bank the javelin
on CP3.MakeBumpers
   local b, tM, tAX, tAY, tBX, tBY
   put empty into sBump
   put "-330,-120,-250,-200" into sBump[1]
   put "330,-120,250,-200" into sBump[2]
   put "-330,150,-250,90" into sBump[3]
   put "330,150,250,90" into sBump[4]
   put Mesh.New() into tM
   repeat for each key b in sBump
      put item 1 of sBump[b] into tAX
      put item 2 of sBump[b] into tAY
      put item 3 of sBump[b] into tBX
      put item 4 of sBump[b] into tBY
      CP3.Line tM, tAX, tAY, 0, tBX, tBY, 0
      CP3.Line tM, tAX, tAY, 16, tBX, tBY, 16
      CP3.Line tM, tAX, tAY, 0, tAX, tAY, 16
      CP3.Line tM, tBX, tBY, 0, tBX, tBY, 16
   end repeat
   Mesh.Define "CP3.Bumpers", tM
   get Entity.Spawn("CP3.Bumpers", 0, 0, 0, "#40E0FF")
end CP3.MakeBumpers

-- could Probe stand near enough to pick the javelin up at x,y?
function CP3.Reachable x, y
   local tPX, tPY, d, R
   put CP3.Radius(max(1, sRings)) + 26 into R
   put max(kLeft + 12, min(kRight - 12, x)) into tPX
   put max(kTop + 12, min(kBottom - 12, y)) into tPY
   put sqrt((tPX - kBossX) ^ 2 + (tPY - kBossY) ^ 2) into d
   if d <= R then
      if d < 0.01 then return false
      put kBossX + (tPX - kBossX) / d * (R + 1) into tPX
      put kBossY + (tPY - kBossY) / d * (R + 1) into tPY
      put max(kLeft + 12, min(kRight - 12, tPX)) into tPX
      put max(kTop + 12, min(kBottom - 12, tPY)) into tPY
      if sqrt((tPX - kBossX) ^ 2 + (tPY - kBossY) ^ 2) <= R then return false
   end if
   return sqrt((tPX - x) ^ 2 + (tPY - y) ^ 2) < 18
end CP3.Reachable

-- an unreachable resting javelin slides out from the Cone; under the top wall it slides sideways
on CP3.NudgeSpear
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
end CP3.NudgeSpear

on CP3.MoveSpear
   local k, i, dx, dy, d, tV, tX0, tY0, tN, u
   if sSpear["state"] is "hand" then exit CP3.MoveSpear
   if sSpear["state"] is "return" then
      -- back to the hand, fast, through everything
      put sPX - sSpear["x"] into dx
      put sPY - sSpear["y"] into dy
      put sqrt(dx * dx + dy * dy) into d
      if d < 16 then
         Entity.Kill sSpear["key"]
         put "hand" into sSpear["state"]
         exit CP3.MoveSpear
      end if
      put dx / d * 16 into sSpear["vx"]
      put dy / d * 16 into sSpear["vy"]
      add sSpear["vx"] to sSpear["x"]
      add sSpear["vy"] to sSpear["y"]
      put 24 into sSpear["h"]
      CP3.PlaceSpear
      exit CP3.MoveSpear
   end if
   put sSpear["x"] into tX0
   put sSpear["y"] into tY0
   add sSpear["vx"] to sSpear["x"]
   add sSpear["vy"] to sSpear["y"]
   -- in flight it rises and falls; when its time is up it lands, skids and stops
   if sSpear["state"] is "flying" then
      add 1 to sSpear["fly"]
      put min(1, sSpear["fly"] / sSpear["flyT"]) into u
      put 26 * (1 - u) + (8 + 40 * sSpear["c"]) * 4 * u * (1 - u) + 2 * u into sSpear["h"]
      if u >= 1 then
         put sSpear["vx"] * 0.25 into sSpear["vx"]
         put sSpear["vy"] * 0.25 into sSpear["vy"]
         put "loose" into sSpear["state"]
         FX.Sparks sSpear["x"], -2, -sSpear["y"], 4, "#40E0FF"
      end if
   else
      put 2 into sSpear["h"]
   end if
   -- the energy pulse: the javelin stops short of it and drops back, loose and slow
   put CP3.PulseHit(tX0, tY0, sSpear["x"], sSpear["y"]) into tN
   if tN is not empty then
      put tX0 into sSpear["x"]
      put tY0 into sSpear["y"]
      put sSpear["vx"] * item 1 of tN + sSpear["vy"] * item 2 of tN into tV
      put (sSpear["vx"] - 2 * tV * item 1 of tN) * 0.3 into sSpear["vx"]
      put (sSpear["vy"] - 2 * tV * item 2 of tN) * 0.3 into sSpear["vy"]
      put "loose" into sSpear["state"]
      FX.Sparks sSpear["x"], -10, -sSpear["y"], 6, "#80B0FF"
      if sMsg is empty then CP3.Say "ENERGY PULSE: AIM FOR A CUBE OR A GAP", 1
   end if
   -- ricochets off walls and bumpers: the first three keep it lively
   get CP3.Reflect(sSpear["x"], sSpear["y"], sSpear["vx"], sSpear["vy"])
   if it is not empty then
      put item 1 of it into sSpear["vx"]
      put item 2 of it into sSpear["vy"]
      put max(kLeft, min(kRight, sSpear["x"])) into sSpear["x"]
      put max(kTop, min(kBottom, sSpear["y"])) into sSpear["y"]
      add 1 to sSpear["bounces"]
      FX.Sparks sSpear["x"], -sSpear["h"], -sSpear["y"], 4, "#40E0FF"
      if sSpear["bounces"] > 3 then
         put sSpear["vx"] * 0.75 into sSpear["vx"]
         put sSpear["vy"] * 0.75 into sSpear["vy"]
         put "loose" into sSpear["state"]
      end if
   end if
   if sSpear["state"] is "loose" then
      put sSpear["vx"] * 0.94 into sSpear["vx"]
      put sSpear["vy"] * 0.94 into sSpear["vy"]
   end if
   put sqrt(sSpear["vx"] ^ 2 + sSpear["vy"] ^ 2) into tV
   -- shield cubes: one breaks, drops a key, and the javelin comes home
   -- (a javelin barely moving, or sliding out to reach, breaks nothing: no free keys)
   repeat with k = 1 to sRings
      if tV < 2 then exit repeat
      repeat with i = 1 to sRing[k]["n"]
         if sRing[k][i]["up"] is not true then next repeat
         if abs(sRing[k][i]["x"] - sSpear["x"]) < 16 and abs(sRing[k][i]["y"] - sSpear["y"]) < 16 then
            CP3.BreakCube k, i
            FX.Sparks sRing[k][i]["x"], -10, -sRing[k][i]["y"], 10, "#FF60D0"
            CP3.DropToken sRing[k][i]["x"], sRing[k][i]["y"]
            put "return" into sSpear["state"]
            exit CP3.MoveSpear
         end if
      end repeat
   end repeat
   -- the Cone (only a javelin coming at it)
   if sqrt((sSpear["x"] - kBossX) ^ 2 + (sSpear["y"] - kBossY) ^ 2) < 26 and tV > 1 and sSpear["vx"] * (kBossX - sSpear["x"]) + sSpear["vy"] * (kBossY - sSpear["y"]) > 0 then
      if the number of chars of sGot >= the number of chars of sPass then
         FX.Sparks kBossX, -35, -kBossY, 60, "#B060FF"
         Entity.Kill sSpear["key"]
         put "hand" into sSpear["state"]
         if sLevel >= 5 then
            put true into sOver
            put true into sWon
         else
            add 1 to sLevel
            CP3.GoLevel sLevel
         end if
         exit CP3.MoveSpear
      end if
      put -sSpear["vx"] into sSpear["vx"]
      put -sSpear["vy"] * 0.9 into sSpear["vy"]
      put "loose" into sSpear["state"]
      CP3.Say "ACCESS DENIED: THE PASSWORD IS NOT COMPLETE", 2
   end if
   -- loose: dangerous while it moves fast; lying still it can be picked up
   if sSpear["state"] is "loose" then
      if sqrt((sSpear["x"] - sPX) ^ 2 + (sSpear["y"] - sPY) ^ 2) < 20 then
         if tV < 4 then
            Entity.Kill sSpear["key"]
            put "hand" into sSpear["state"]
            exit CP3.MoveSpear
         else if sSafe <= 0 then
            CP3.LoseLife
            exit CP3.MoveSpear
         end if
      end if
      if tV < 2 and not CP3.Reachable(sSpear["x"], sSpear["y"]) then
         put 0 into sSpear["vx"]
         put 0 into sSpear["vy"]
         CP3.NudgeSpear
      else if tV < 0.3 then
         put 0 into sSpear["vx"]
         put 0 into sSpear["vy"]
      end if
   end if
   CP3.PlaceSpear
end CP3.MoveSpear

on CP3.PlaceSpear
   CP3.Put sSpear["key"], sSpear["x"], sSpear["y"], sSpear["h"]
   if sSpear["vx"] is not 0 or sSpear["vy"] is not 0 then Entity.SetRotation sSpear["key"], 0, atan2(sSpear["vy"], sSpear["vx"]), 0
end CP3.PlaceSpear

on Game.OnClick pX, pY, pButton
   -- the mouse button is read while held (charge); a click too short for that is a quick throw
   if sOver or sCharging then exit Game.OnClick
   if sTicks - sThrewAt < 6 then exit Game.OnClick
   if sSpear["state"] is "hand" and CP3.Use("javelin") then CP3.Throw 0
end Game.OnClick

-------------------------------------------------------------------- 9. THE ORBITERS

on CP3.MakeOrbiters pCount, pSpeed
   local n
   put empty into sOrb
   put pCount into sOrbN
   Mesh.Define "CP3.Tetra", Mesh.Pyramid(3, 16, 26)
   Mesh.Define "CP3.Octa", Mesh.Sphere(15, 2, 4)
   Mesh.Define "CP3.Box", Mesh.Box(22, 22, 22)
   repeat with n = 1 to pCount
      put item (n - 1) mod 3 + 1 of "CP3.Tetra,CP3.Octa,CP3.Box" into sOrb[n]["mesh"]
      put n * 2 * pi / pCount into sOrb[n]["a"]
      put pSpeed * (1 + (n mod 3) * 0.25) into sOrb[n]["w"]
      if n mod 2 is 0 then put -sOrb[n]["w"] into sOrb[n]["w"]
      put CP3.Radius(max(1, sRings)) + 50 + (n mod 2) * 25 into sOrb[n]["r"]
      put 50 + (n mod 3) * 15 into sOrb[n]["swing"]
      put n * 1.7 into sOrb[n]["phase"]
      put 0 into sOrb[n]["deadUntil"]
      CP3.OrbSpawn n
   end repeat
end CP3.MakeOrbiters

on CP3.OrbSpawn n
   put Entity.Spawn(sOrb[n]["mesh"], 0, -5000, 0, item (n - 1) mod 3 + 1 of "#FF5050,#FFB000,#FF60D0") into sOrb[n]["key"]
end CP3.OrbSpawn

on CP3.MoveOrbiters
   local n, r, dx, dy, d, tN
   repeat with n = 1 to sOrbN
      if sOrb[n]["key"] is empty then
         if sTicks >= sOrb[n]["deadUntil"] then CP3.OrbSpawn n
         next repeat
      end if
      add sOrb[n]["w"] to sOrb[n]["a"]
      put sOrb[n]["r"] + sOrb[n]["swing"] * sin(sTicks / 40 + sOrb[n]["phase"]) into r
      put min(r, kBossY - kTop - 18) into r
      put kBossX + r * cos(sOrb[n]["a"]) into sOrb[n]["x"]
      put kBossY + r * sin(sOrb[n]["a"]) into sOrb[n]["y"]
      CP3.Put sOrb[n]["key"], sOrb[n]["x"], sOrb[n]["y"], 18 + 6 * sin(sTicks / 9 + n)
      Entity.SetRotation sOrb[n]["key"], sTicks / 6, sTicks / 9, 0
      if sSpear["state"] is "flying" or sSpear["state"] is "loose" then
         put sSpear["x"] - sOrb[n]["x"] into dx
         put sSpear["y"] - sOrb[n]["y"] into dy
         put sqrt(dx * dx + dy * dy) into d
         if d < 20 and d > 0.01 then
            FX.Sparks sOrb[n]["x"], -18, -sOrb[n]["y"], 16, "#FF5050"
            Entity.Kill sOrb[n]["key"]
            put empty into sOrb[n]["key"]
            put sTicks + 180 into sOrb[n]["deadUntil"]
            put (sSpear["vx"] * dx + sSpear["vy"] * dy) / d into tN
            if tN < 0 then
               subtract 2 * tN * dx / d from sSpear["vx"]
               subtract 2 * tN * dy / d from sSpear["vy"]
            end if
            CP3.Say "SMASHED", 1
            next repeat
         end if
      end if
      if sSafe <= 0 and sqrt((sOrb[n]["x"] - sPX) ^ 2 + (sOrb[n]["y"] - sPY) ^ 2) < 22 then CP3.LoseLife
   end repeat
end CP3.MoveOrbiters

-------------------------------------------------------------------- 10. KEYS, LIVES, THE HUD

on CP3.DropToken pX, pY
   add 1 to sTokN
   put pX into sTok[sTokN]["x"]
   put pY into sTok[sTokN]["y"]
   put Entity.Spawn("CP3.Token", pX, -8, -pY, "#FFE060") into sTok[sTokN]["key"]
end CP3.DropToken

-- tokens drift out from the shield to where Probe can reach them
on CP3.Tokens
   local t, dx, dy, d
   repeat for each key t in sTok
      put sTok[t]["x"] - kBossX into dx
      put sTok[t]["y"] - kBossY into dy
      put sqrt(dx * dx + dy * dy) into d
      if d < CP3.Radius(max(1, sRings)) + 40 then
         add dx / d * 1.5 to sTok[t]["x"]
         add dy / d * 1.5 to sTok[t]["y"]
         put max(kTop + 10, min(kBottom - 10, sTok[t]["y"])) into sTok[t]["y"]
         put max(kLeft + 10, min(kRight - 10, sTok[t]["x"])) into sTok[t]["x"]
      end if
      CP3.Put sTok[t]["key"], sTok[t]["x"], sTok[t]["y"], 8
      Entity.SetRotation sTok[t]["key"], 0, sTicks / 8, 0
      if sqrt((sTok[t]["x"] - sPX) ^ 2 + (sTok[t]["y"] - sPY) ^ 2) < 24 then
         Entity.Kill sTok[t]["key"]
         delete variable sTok[t]
         if the number of chars of sGot < the number of chars of sPass then
            put char (the number of chars of sGot + 1) of sPass after sGot
            FX.Sparks sPX, -20, -sPY, 8, "#FFE060"
            if sGot is sPass then CP3.Say "PASSWORD COMPLETE: HIT THE CONE", 3
         end if
         put empty into sHUDWas
      end if
   end repeat
end CP3.Tokens

on CP3.LoseLife
   FX.Sparks sPX, -16, -sPY, 30, "#40E0FF"
   subtract 1 from sLives
   put 60 into sSafe
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      CP3.Say "SPEARED BY YOUR OWN PROBE", 999
      exit CP3.LoseLife
   end if
   CP3.Say "OUCH: A MOVING JAVELIN IS DANGEROUS", 2
end CP3.LoseLife

on CP3.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end CP3.Say

on CP3.ShowHUD
   local tWords, tShow, tBar, n
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sGot into tShow
   repeat the number of chars of sPass - the number of chars of sGot times
      put "-" after tShow
   end repeat
   put empty into tBar
   if sCharging then
      repeat with n = 1 to 10
         if n <= round(sCharge * 10) then
            put "+" after tBar
         else
            put "-" after tBar
         end if
      end repeat
   end if
   put sLevel & "|" & sLives & "|" & tShow & "|" & sMsg & "|" & sOver & "|" & tBar into tWords
   if tWords is sHUDWas then exit CP3.ShowHUD
   put tWords into sHUDWas
   HUD.Set "CP3.Score", "PASSWORD" && tShow && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "CP3.Msg"
   if sOver and sWon then
      HUD.Set "CP3.Msg", "THE LAST CONE IS DOWN.  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sOver then
      HUD.Set "CP3.Msg", sMsg & ".  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sMsg is not empty then
      HUD.Set "CP3.Msg", sMsg, 20, 142, 14
   end if
   if tBar is empty then
      HUD.Remove "CP3.Charge"
   else
      HUD.Set "CP3.Charge", "THROW" && tBar, 20, 164, 14
   end if
end CP3.ShowHUD

function CP3.State
   return sLevel & "|" & sLives & "|" & sGot & "/" & sPass & "|" & round(sPX) & "," & round(sPY) & "|" & sSpear["state"] & "|" & sTokN & "|" & sOver
end CP3.State

-------------------------------------------------------------------- 11. TEST HOOKS (no screen needed)

on CP3.TestKeys pKeys
   put pKeys into sTestKeys
end CP3.TestKeys

-- Probe at x,y facing pHead (radians on the plan; -pi/2 = toward the Cone), on level pLevel
on CP3.TestPlace x, y, pLevel, pHead
   if pLevel is not empty and pLevel is not sLevel then CP3.StartLevel pLevel
   put x into sPX
   put y into sPY
   if pHead is a number then
      put pHead into sHead
      put pHead into sCamA
   end if
   put 999999 into sNextUpdate          -- no shield update in the middle of a test
   put 999999 into sSafe                -- and no lives lost
   put 5 into sLives
   put false into sOver
   put 0 into sCharge
   put false into sCharging
   if sSpear["state"] is not "hand" then
      Entity.Kill sSpear["key"]
      put "hand" into sSpear["state"]
   end if
end CP3.TestPlace

on CP3.TestSpear x, y, vx, vy, pState
   if sSpear["key"] is empty or sSpear["state"] is "hand" then put Entity.Spawn("CP3.Spear", x, -2, -y, "#40E0FF") into sSpear["key"]
   put x into sSpear["x"]
   put y into sSpear["y"]
   put vx into sSpear["vx"]
   put vy into sSpear["vy"]
   if pState is empty then put "flying" into pState
   put pState into sSpear["state"]
   put 0 into sSpear["bounces"]
   put 0 into sSpear["fly"]
   put 999 into sSpear["flyT"]
   put 0.5 into sSpear["c"]
   put 2 into sSpear["h"]
end CP3.TestSpear

function CP3.TestSpearInfo
   return sSpear["x"] & comma & sSpear["y"] & comma & sSpear["vx"] & comma & sSpear["vy"] & comma & sSpear["state"]
end CP3.TestSpearInfo

function CP3.TestCube i
   local k
   put max(1, sRings) into k
   return k & comma & sRing[k]["n"] & comma & sRing[k][i]["x"] & comma & sRing[k][i]["y"] & comma & (sRing[k][i]["up"] is true)
end CP3.TestCube

on CP3.TestBreak i
   CP3.BreakCube max(1, sRings), i
end CP3.TestBreak

-- "px,py,heading,camx,camy,camyaw": Probe and the camera on the plan
function CP3.CamInfo
   return sPX & comma & sPY & comma & sHead & comma & (sPX - cos(sCamA) * kCamBack) & comma & (sPY - sin(sCamA) * kCamBack) & comma & sCamA
end CP3.CamInfo

-- "bar in use,charge,charging"
function CP3.TestBar
   return sBar & comma & sCharge & comma & sCharging
end CP3.TestBar

-- no orbiters until the next level starts (a test of the javelin alone)
on CP3.TestQuiet
   local n
   repeat with n = 1 to sOrbN
      if sOrb[n]["key"] is not empty then Entity.Kill sOrb[n]["key"]
   end repeat
   put empty into sOrb
   put 0 into sOrbN
end CP3.TestQuiet
