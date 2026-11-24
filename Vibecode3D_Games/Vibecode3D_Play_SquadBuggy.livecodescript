######################################################################################
## CARD SCRIPT: "Play.SquadBuggy"   SQUAD BUGGY  (11 14 2026; owner's notes of 15 Nov)
## An armoured buggy over rolling hills, seen from the side, three soldiers riding on the
## back and you at the mounted gun. The soldiers shoot the walkers by themselves; you drive,
## jump and aim the gun. Reach each green flag and hold it. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/809_Squad_Buggy), script by Claude.
## CONTROLS  Right/Left (or D/A): drive on / back up    Space: jump (light gravity, it floats)
##           Mouse: the reticle aims the gun, click to fire    G / right button: grenade    Escape: pause
##           Stand still beside a fallen soldier to pick him up.
## RULES     a walker that reaches the buggy is run down (land on one to squash it), but the
##           bump throws a soldier off. A walker that reaches a fallen soldier takes him.
##           Bombers cross the sky and drop bombs: a bomb digs a crater in the hills (too
##           steep to drive out of: jump) and a hit throws a soldier off. Shoot the bombers,
##           and the bombs too. Lose all three soldiers: a life, and back to the last flag
##           with a fresh squad. At a flag, stay near it for 20 seconds while they come from
##           both sides. 3 flags a level, 5 levels.
##           Buildings and water towers stand along the course. While one is ahead of you,
##           snipers on its roof fire at the buggy (shoot them, or shoot their rounds down),
##           and that is when the bombers come in from BEHIND: two directions at once.
## (owner's notes of 15 Nov 8:16 PM: buildings, water towers, enemies on them ahead,
##  attack by air from behind)
## 23 Nov 2026 (p1-18): a WIDER VIEW: the camera stands kCamBack further back (and higher, so the
##  ground stays where it was on the screen): half as much land again on each side. How much a
##  bomb wrecks the land is one number, kWreck (0 = no craters, 1 = as before, 2 = twice as big);
##  Squad.SetWreck sets it while playing, and ComfyUI's Terrain node has it as the "wreck" knob.
## 23 Nov 2026 (owner: the wider view is there so OUR grenades can wreck the land ahead, or behind):
##  G (or the right mouse button) lobs a GRENADE in an arc to the ground under the reticle, ahead or
##  behind. It digs a crater as a bomb does (kWreck sizes it) and takes out walkers. Hold G to keep
##  lobbing (one every kNadeWait steps). Too near the buggy and its blast throws a soldier off too.
######################################################################################

global bPaused, bPlaying
global gNoMouse, gViewBottom

local sBuggy, sWheel, sX, sV, sMan, sEnemy, sEnemyN, sShot, sShotN, sFlag, sFlagN, sFlagX
local sHold, sSlice, sNextEnemy, sLastFlagX, sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT
local sBonus, sESpeed, sKeysWas, sTestKeys, sHUDWas, sTicks
local sY, sVY, sAir, sAng                    -- the buggy's height, climb, in the air, tilt
local sCrater, sCraterN, sFly, sFlyN, sBomb, sBombN, sNextFly
local sRet, sAimX, sAimH, sFireT, sTestAim, sTestMouse, sJumped, sFired
local sTower, sSnipe, sSnipeN, sNoSnipe, sBehind, sWarned  -- buildings, roof snipers
local sMove                                              -- how fast you drive this step
local sWreck, sCrR, sCrD                                 -- kWreck now, and a crater's width and depth
local sNade, sNadeN, sNadeT, sTestNade, sThrown          -- grenades in the air, their count, the wait

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kBase = 230
constant kBuggyX = -120      -- the buggy stays here on the screen
constant kSeg = 20
constant kSlices = 78       -- ground slices on the screen (52 before the wider view)
constant kSlicesBack = 32   -- and how many of them behind the buggy (24 before)
constant kCamBack = 150     -- WIDER VIEW: the camera this far back; 0 = the old close view
constant kFlagGap = 2400
constant kHoldSteps = 600    -- 20 seconds
constant kGrav = 0.18        -- lighter than earth: jumps float
constant kJumpV = 6.2        -- up to about 100 high, two seconds in the air
constant kCraterR = 52       -- a bomb's crater: half width
constant kCraterD = 38       -- and depth (craters on craters dig deeper, to 70)
constant kWreck = 1          -- how much a bomb wrecks the land: 0 none, 1 as made, 2 twice (ComfyUI "wreck")
constant kShotV = 22
constant kTowerGap = 1100    -- about this far between buildings and water towers
constant kSnipeRange = 620   -- snipers fire while their roof is this near ahead
constant kRoundV = 4.2       -- a sniper's round: slow enough to shoot down or dodge
constant kNadeWait = 20      -- grenades: steps between two lobs while G is held
constant kNadeFar = 900      -- grenades: farthest lob (ahead or behind)
constant kNadeR = 60         -- grenades: walkers this near the blast go

on Game.OnStart
   focus on nothing
   Camera.Reset
   Squad.View
   if sWreck is not a number then put kWreck into sWreck
   Squad.SetWreck sWreck
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put false into sJumped
   put false into sThrown
   put false into sFired
   put false into sNoSnipe
   Squad.StartLevel 1
end Game.OnStart

-- the wider view: the camera kCamBack behind the screen, and raised so the ground line stays put
on Squad.View
   Camera.SetPosition 0, kBase - kBase * (kZ + kCamBack) / kZ, -kCamBack
end Squad.View

-- how much a bomb wrecks the land: 0 = the land stays whole, 1 = as made, 2 = craters twice the size
-- (they still stack no deeper than 70, so a jump always gets out). Empty = back to kWreck.
on Squad.SetWreck pAmount
   if pAmount is not a number then put kWreck into pAmount
   put max(0, min(2, pAmount)) into sWreck
   put kCraterR * sWreck into sCrR
   put kCraterD * sWreck into sCrD
end Squad.SetWreck

function Squad.Wreck
   return sWreck
end Squad.Wreck

-- Spark's table: buggy speed | flags | lives | bonus
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Squad.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Squad.StartLevel pLevel
   end if
end Squad.GoLevel

on Squad.StartLevel pLevel
   local tRow, i
   put pLevel into sLevel
   put line pLevel of ("120,3,3,500" & cr & "130,3,3,750" & cr & "140,3,3,1000" & cr & "150,3,2,1250" & cr & "160,3,1,1500") into tRow
   put (item 1 of tRow) / 30 into sV
   put item 2 of tRow into sFlagN
   if sLives > item 3 of tRow then put item 3 of tRow into sLives
   put item 4 of tRow into sBonus
   put 1.6 + pLevel * 0.3 into sESpeed
   Scene.ClearAll
   Mesh.Define "Squad.Buggy", Squad.BuggyMesh()
   Mesh.Define "Squad.Wheel", Squad.WheelMesh()
   Mesh.Define "Squad.Sit", Squad.ManMesh("sit")
   Mesh.Define "Squad.Down", Squad.ManMesh("down")
   Mesh.Define "Squad.Gunner", Squad.ManMesh("gun")
   Mesh.Define "Squad.Enemy", Squad.ManMesh("walk")
   Mesh.Define "Squad.Shot", Mesh.Box(8, 2, 2)
   Mesh.Define "Squad.Flag", Squad.FlagMesh()
   Mesh.Define "Squad.Flyer", Squad.FlyerMesh()
   Mesh.Define "Squad.Bomb", Mesh.Box(6, 8, 6)
   Mesh.Define "Squad.Reticle", Squad.ReticleMesh()
   Mesh.Define "Squad.Sniper", Squad.ManMesh("aim")
   Mesh.Define "Squad.Round", Mesh.Box(5, 5, 5)
   put empty into sTower
   put empty into sSlice
   repeat with i = 0 to kSlices
      put empty into sSlice[i]["type"]
   end repeat
   put Entity.Spawn("Squad.Buggy", kBuggyX, kBase, kZ, "0,230,255") into sBuggy
   repeat with i = 1 to 2
      put Entity.Spawn("Squad.Wheel", kBuggyX, kBase, kZ, "0,230,255") into sWheel[i]
   end repeat
   put Entity.Spawn("Squad.Flag", 0, kBase, kZ + 2, "0,255,100") into sFlag
   put Entity.Spawn("Squad.Reticle", 0, -2000, kZ - 6, "255,255,80") into sRet
   put 0 into sLastFlagX
   put 1 into sFlagX
   Squad.Restart 0
   put "LEVEL" && pLevel & ": REACH THE GREEN FLAG" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Squad.StartLevel

-- (re)start at a course point with a full squad, the ground mended
on Squad.Restart pX
   local i, tK
   put pX into sX
   repeat for each key tK in sEnemy
      Entity.Kill sEnemy[tK]["key"]
   end repeat
   put empty into sEnemy
   put 0 into sEnemyN
   repeat for each key tK in sShot
      Entity.Kill sShot[tK]["key"]
   end repeat
   put empty into sShot
   put 0 into sShotN
   repeat for each key tK in sFly
      Entity.Kill sFly[tK]["key"]
   end repeat
   put empty into sFly
   put 0 into sFlyN
   repeat for each key tK in sBomb
      Entity.Kill sBomb[tK]["key"]
   end repeat
   put empty into sBomb
   put 0 into sBombN
   repeat for each key tK in sNade
      Entity.Kill sNade[tK]["key"]
   end repeat
   put empty into sNade
   put 0 into sNadeN
   put 0 into sNadeT
   put empty into sCrater
   put 0 into sCraterN
   repeat for each key tK in sTower
      if sTower[tK]["key"] is not empty then Entity.Kill sTower[tK]["key"]
   end repeat
   put empty into sTower
   repeat for each key tK in sSnipe
      Entity.Kill sSnipe[tK]["key"]
   end repeat
   put empty into sSnipe
   put 0 into sSnipeN
   put 0 into sBehind
   put false into sWarned
   repeat for each key tK in sMan
      if sMan[tK]["key"] is not empty then Entity.Kill sMan[tK]["key"]
   end repeat
   put empty into sMan
   -- three soldiers and the gunner (4); the gunner never falls
   repeat with i = 1 to 4
      put "on" into sMan[i]["state"]
      put 0 into sMan[i]["wait"]
      if i is 4 then
         put Entity.Spawn("Squad.Gunner", kBuggyX, kBase, kZ, "255,60,60") into sMan[i]["key"]
      else
         put Entity.Spawn("Squad.Sit", kBuggyX, kBase, kZ, "255,150,0") into sMan[i]["key"]
      end if
   end repeat
   put Squad.H(sX) into sY
   put 0 into sVY
   put false into sAir
   put 0 into sAng
   put 0 into sFireT
   put 0 into sHold
   put 60 into sNextEnemy
   put max(150, 270 - sLevel * 30) into sNextFly
end Squad.Restart

-- the hills before any bomb
function Squad.Hill pX
   return 70 + 45 * sin(pX / 420) + 22 * sin(pX / 170 + 1) + 10 * sin(pX / 61)
end Squad.Hill

-- the hills, less what the bombs dug out
function Squad.H pX
   local tH, tK, tD, tDig
   put Squad.Hill(pX) into tH
   put 0 into tDig
   repeat for each key tK in sCrater
      put abs(pX - sCrater[tK]) into tD
      if tD < sCrR then add sCrD * (1 - (tD / sCrR) ^ 2) to tDig
   end repeat
   return tH - min(70, tDig)
end Squad.H

function Squad.SX pX
   return kBuggyX + pX - sX
end Squad.SX

function Squad.BuggyMesh
   local tM
   put Mesh.New() into tM
   Squad.Poly tM, "-44,-14|-40,-30|26,-30|44,-18|44,-10|-44,-10|-44,-14"
   Squad.Poly tM, "20,-30|30,-44|46,-44"                    -- the gun mount
   Squad.Poly tM, "-36,-30|-36,-40|10,-40"                  -- the roll bar
   return tM
end Squad.BuggyMesh

function Squad.WheelMesh
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 7
      put i * 3.14159 / 4 into tA
      Mesh.AddVertex tM, 12 * cos(tA), 12 * sin(tA), 0
   end repeat
   repeat with i = 1 to 8
      Mesh.AddLine tM, i, (i mod 8) + 1
   end repeat
   Mesh.AddLine tM, 1, 5
   Mesh.AddLine tM, 3, 7
   return tM
end Squad.WheelMesh

-- little figures: sitting, lying down, at the gun, walking
function Squad.ManMesh pPose
   local tM
   put Mesh.New() into tM
   switch pPose
      case "sit"
         Squad.Poly tM, "0,0|0,-16|8,-16|8,-2"
         Squad.Poly tM, "0,-16|0,-26"
         Squad.Poly tM, "-3,-26|-3,-33|4,-33|4,-26|-3,-26"
         Squad.Poly tM, "0,-21|12,-24"
         break
      case "down"
         Squad.Poly tM, "-14,0|12,0"
         Squad.Poly tM, "12,-3|18,-3|18,3|12,3"
         Squad.Poly tM, "-14,0|-20,-6"
         break
      case "gun"
         Squad.Poly tM, "0,0|0,-24"
         Squad.Poly tM, "-4,-24|-4,-32|4,-32|4,-24|-4,-24"
         Squad.Poly tM, "0,-18|10,-20"
         Squad.Poly tM, "4,-22|26,-26"
         break
      case "aim"
         Squad.Poly tM, "-5,0|0,-14|5,0"
         Squad.Poly tM, "0,-14|0,-28"
         Squad.Poly tM, "-4,-28|-4,-36|4,-36|4,-28|-4,-28"
         Squad.Poly tM, "0,-23|-16,-26"
         Squad.Poly tM, "-16,-27|-22,-28"
         break
      case "walk"
         Squad.Poly tM, "-6,0|0,-14|6,0"
         Squad.Poly tM, "0,-14|0,-28"
         Squad.Poly tM, "-4,-28|-4,-36|4,-36|4,-28|-4,-28"
         Squad.Poly tM, "0,-24|-12,-22"
         break
   end switch
   return tM
end Squad.ManMesh

function Squad.FlagMesh
   local tM
   put Mesh.New() into tM
   Squad.Poly tM, "0,0|0,-120"
   Squad.Poly tM, "0,-120|44,-108|0,-96"
   return tM
end Squad.FlagMesh

-- a bomber, nose to the left (turned round when it flies right)
function Squad.FlyerMesh
   local tM
   put Mesh.New() into tM
   Squad.Poly tM, "-30,0|-18,-6|22,-6|30,-14|30,4|-18,6|-30,0"
   Squad.Poly tM, "-6,-6|6,-22|14,-22|8,-6"
   Squad.Poly tM, "-4,6|6,16|12,16|8,6"
   Squad.Poly tM, "-22,-2|-14,-2"
   return tM
end Squad.FlyerMesh

-- a building: pW wide, pH high, a parapet, rows of windows; it stands on 0,0 (its middle,
-- at the ground) and reaches 60 below so it never floats over a dip
function Squad.BuildingMesh pW, pH
   local tM, tX, tY, w
   put Mesh.New() into tM
   put pW / 2 into w
   Squad.Poly tM, -w & ",60|" & -w & "," & -pH & "|" & w & "," & -pH & "|" & w & ",60"
   Squad.Poly tM, -w - 4 & "," & -pH & "|" & -w - 4 & "," & -pH - 6 & "|" & w + 4 & "," & -pH - 6 & "|" & w + 4 & "," & -pH
   repeat with tY = 22 to pH - 20 step 26
      repeat with tX = -w + 10 to w - 22 step 22
         Squad.Poly tM, tX & "," & -tY & "|" & tX + 10 & "," & -tY & "|" & tX + 10 & "," & -tY - 12 & "|" & tX & "," & -tY - 12 & "|" & tX & "," & -tY
      end repeat
   end repeat
   return tM
end Squad.BuildingMesh

-- a water tower: four legs (two seen) with braces, the tank, a cone roof; it stands on 0,0
function Squad.TowerMesh pH
   local tM, tLeg
   put Mesh.New() into tM
   put pH - 50 into tLeg
   Squad.Poly tM, "-26,60|-20," & -tLeg
   Squad.Poly tM, "26,60|20," & -tLeg
   Squad.Poly tM, "-24," & -tLeg * 0.3 & "|22," & -tLeg * 0.7
   Squad.Poly tM, "24," & -tLeg * 0.3 & "|-22," & -tLeg * 0.7
   Squad.Poly tM, "-24," & -tLeg * 0.3 & "|24," & -tLeg * 0.3
   Squad.Poly tM, "-22," & -tLeg * 0.7 & "|22," & -tLeg * 0.7
   Squad.Poly tM, "-30," & -tLeg & "|30," & -tLeg & "|30," & -pH + 8 & "|-30," & -pH + 8 & "|-30," & -tLeg
   Squad.Poly tM, "-30," & -pH + 22 & "|30," & -pH + 22
   Squad.Poly tM, "-32," & -pH + 8 & "|0," & -pH - 6 & "|32," & -pH + 8
   return tM
end Squad.TowerMesh

-- the gun's sight: a ring with four ticks
function Squad.ReticleMesh
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 11
      put i * 3.14159 / 6 into tA
      Mesh.AddVertex tM, 12 * cos(tA), 12 * sin(tA), 0
   end repeat
   repeat with i = 1 to 12
      Mesh.AddLine tM, i, (i mod 12) + 1
   end repeat
   Squad.Poly tM, "-20,0|-7,0"
   Squad.Poly tM, "7,0|20,0"
   Squad.Poly tM, "0,-20|0,-7"
   Squad.Poly tM, "0,7|0,20"
   return tM
end Squad.ReticleMesh

on Squad.Poly @pM, pPts
   local tP, tN
   put 0 into tN
   replace "|" with cr in pPts
   repeat for each line tP in pPts
      Mesh.AddVertex pM, item 1 of tP, item 2 of tP, 0
      add 1 to tN
      if tN > 1 then Mesh.AddLine pM, pM["count"] - 1, pM["count"]
   end repeat
end Squad.Poly

function Squad.SliceName pDY
   local tName, tM
   put "Squad.G" & round(pDY) into tName
   if sSlice["defined"][tName] is empty then
      put Mesh.New() into tM
      Mesh.AddVertex tM, 0, 0, 0
      Mesh.AddVertex tM, kSeg, -round(pDY), 0
      Mesh.AddVertex tM, 8, 10, 0
      Mesh.AddVertex tM, 12, 10, 0
      Mesh.AddLine tM, 1, 2
      Mesh.AddLine tM, 3, 4
      Mesh.Define tName, tM
      put true into sSlice["defined"][tName]
   end if
   return tName
end Squad.SliceName

function Squad.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Squad.Keys

on Squad.TestKeys pKeys
   put pKeys into sTestKeys
end Squad.TestKeys

on Squad.TestLives pN
   put pN into sLives
end Squad.TestLives

function Squad.Down pCode, pKeys
   return pCode is among the items of pKeys
end Squad.Down

-- a key went down this step
function Squad.Pressed pCode, pKeys
   return pCode is among the items of pKeys and pCode is not among the items of sKeysWas
end Squad.Pressed

on Game.OnUpdate
   local tKeys, tMove, tJump, i
   put Squad.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Squad.Pressed(32, tKeys) or Squad.Pressed(65293, tKeys) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Squad.GoLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put Squad.Pressed(32, tKeys) into tJump
   put tKeys into sKeysWas
   put 0 into tMove
   if Squad.Down(65363, tKeys) or Squad.Down(100, tKeys) then put sV into tMove
   if Squad.Down(65361, tKeys) or Squad.Down(97, tKeys) then put -sV * 0.6 into tMove
   put tMove into sMove
   Squad.Drive tMove, tJump
   Squad.ShowBuggy
   -- the squad: riding, or lying where they fell
   repeat with i = 1 to 4
      if sMan[i]["state"] is "on" then
         if i is 4 then
            Entity.SetPosition sMan[i]["key"], kBuggyX + 26, kBase - sY - 56 - 3 * sAng * 16, kZ - 2
         else
            Entity.SetPosition sMan[i]["key"], kBuggyX - 30 + (i - 1) * 16, kBase - sY - 48 - (i - 1) * sAng * 16, kZ - 2
         end if
      else if sMan[i]["state"] is "down" then
         Entity.SetPosition sMan[i]["key"], Squad.SX(sMan[i]["x"]), kBase - Squad.H(sMan[i]["x"]) - 4, kZ - 4
         -- standing still beside him: he climbs back on
         if tMove is 0 and not sAir and abs(sMan[i]["x"] - sX) < 50 then
            Entity.Kill sMan[i]["key"]
            put Entity.Spawn("Squad.Sit", kBuggyX, kBase, kZ, "255,150,0") into sMan[i]["key"]
            put "on" into sMan[i]["state"]
            Squad.Say "SOLDIER BACK ON BOARD"
         end if
      end if
   end repeat
   Squad.Ground
   Squad.Towers
   Squad.Enemies
   if sOver then exit Game.OnUpdate
   Squad.Snipers
   if sOver then exit Game.OnUpdate
   Squad.Aim
   Squad.Flyers
   Squad.Bombs
   if sOver then exit Game.OnUpdate
   Squad.Shoot
   Squad.Shots
   Squad.Grenades tKeys
   if sOver then exit Game.OnUpdate
   Squad.Flags
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Squad.ShowHUD
end Game.OnUpdate

-- drive, jump and fall. On the ground the buggy can't climb a slope steeper than a crater
-- wall; driving off an edge (or the ground blown away under it) it falls, slowly
on Squad.Drive pMove, pJump
   local tNewX, tNewH, tGroundNow
   put Squad.H(sX) into tGroundNow
   if pJump and not sAir then
      put true into sAir
      put kJumpV into sVY
      put true into sJumped
   end if
   put max(0, sX + pMove) into tNewX
   if sAir then
      -- a crater wall in the way stops the buggy, not the fall
      if Squad.H(tNewX) <= sY + 4 then put tNewX into sX
      subtract kGrav from sVY
      add sVY to sY
      put Squad.H(sX) into tNewH
      if sY <= tNewH then
         put tNewH into sY
         put 0 into sVY
         put false into sAir
      end if
      put sAng * 0.96 into sAng
      exit Squad.Drive
   end if
   put Squad.H(tNewX) into tNewH
   if tNewH - tGroundNow > abs(pMove) * 0.9 + 0.5 then
      -- too steep to climb
      -- (kept up while you push at the wall)
      if sMsg is not "TOO STEEP! JUMP OUT WITH SPACE" or sMsgT < 10 then
         Squad.Say "TOO STEEP! JUMP OUT WITH SPACE"
      end if
   else
      put tNewX into sX
   end if
   put Squad.H(sX) into tNewH
   if tNewH < sY - (abs(pMove) * 0.6 + 2) then
      put true into sAir
      put 0 into sVY
   else
      put tNewH into sY
      put atan((Squad.H(sX + 30) - Squad.H(sX - 30)) / 60) into sAng
   end if
end Squad.Drive

on Squad.ShowBuggy
   Entity.SetPosition sBuggy, kBuggyX, kBase - sY - 18, kZ
   Entity.SetRotation sBuggy, 0, 0, -sAng
   if sAir then
      Entity.SetPosition sWheel[1], kBuggyX - 28, kBase - (sY - 28 * sin(sAng)) - 12, kZ - 10
      Entity.SetPosition sWheel[2], kBuggyX + 30, kBase - (sY + 30 * sin(sAng)) - 12, kZ - 10
   else
      Entity.SetPosition sWheel[1], kBuggyX - 28, kBase - Squad.H(sX - 28) - 12, kZ - 10
      Entity.SetPosition sWheel[2], kBuggyX + 30, kBase - Squad.H(sX + 30) - 12, kZ - 10
   end if
   Entity.SetRotation sWheel[1], 0, 0, sX / 12
   Entity.SetRotation sWheel[2], 0, 0, sX / 12
end Squad.ShowBuggy

on Squad.Ground
   local i, tIdx, tName, tFirst, tH, tH2
   put sX div kSeg - kSlicesBack into tFirst
   put Squad.H(tFirst * kSeg) into tH2
   repeat with i = 0 to kSlices
      put tFirst + i into tIdx
      put tH2 into tH
      put Squad.H((tIdx + 1) * kSeg) into tH2
      put Squad.SliceName(tH2 - tH) into tName
      if tName is not sSlice[i]["type"] then
         if sSlice[i]["key"] is not empty then Entity.Kill sSlice[i]["key"]
         put Entity.Spawn(tName, 0, kBase, kZ, "120,200,90") into sSlice[i]["key"]
         put tName into sSlice[i]["type"]
      end if
      Entity.SetPosition sSlice[i]["key"], Squad.SX(tIdx * kSeg), kBase - tH, kZ
   end repeat
end Squad.Ground

-- enemies walk in from the right (and from the left while you hold a flag)
on Squad.Enemies
   local tK, tSide, tTarget, i, tEX, tD, tBest
   subtract 1 from sNextEnemy
   if sNextEnemy <= 0 then
      put max(25, 90 - sLevel * 12) + random(40) into sNextEnemy
      if sHold > 0 then put sNextEnemy * 0.6 into sNextEnemy
      put 1 into tSide
      if sHold > 0 and random(2) is 1 then put -1 into tSide
      if sX < 300 then put 1 into tSide
      add 1 to sEnemyN
      if tSide is 1 then
         put sX + 640 + 2 * kCamBack into sEnemy[sEnemyN]["x"]
      else
         put sX - 320 - 2 * kCamBack into sEnemy[sEnemyN]["x"]
      end if
      put Entity.Spawn("Squad.Enemy", Squad.SX(sEnemy[sEnemyN]["x"]), kBase, kZ, "200,80,255") into sEnemy[sEnemyN]["key"]
   end if
   repeat for each key tK in sEnemy
      -- head for the buggy, or a fallen soldier if one is nearer
      put sX into tTarget
      put abs(sEnemy[tK]["x"] - sX) into tBest
      repeat with i = 1 to 3
         if sMan[i]["state"] is "down" and abs(sMan[i]["x"] - sEnemy[tK]["x"]) < tBest then
            put sMan[i]["x"] into tTarget
            put abs(sMan[i]["x"] - sEnemy[tK]["x"]) into tBest
         end if
      end repeat
      if tTarget > sEnemy[tK]["x"] then
         add sESpeed to sEnemy[tK]["x"]
         Entity.SetRotation sEnemy[tK]["key"], 0, 3.14159, 0
      else
         subtract sESpeed from sEnemy[tK]["x"]
         Entity.SetRotation sEnemy[tK]["key"], 0, 0, 0
      end if
      put sEnemy[tK]["x"] into tEX
      Entity.SetPosition sEnemy[tK]["key"], Squad.SX(tEX), kBase - Squad.H(tEX) - 2 * abs(sin(sTicks / 3 + tK)), kZ
      -- it reaches a fallen soldier
      repeat with i = 1 to 3
         if sMan[i]["state"] is "down" and abs(sMan[i]["x"] - tEX) < 12 then
            put "lost" into sMan[i]["state"]
            Entity.Kill sMan[i]["key"]
            put empty into sMan[i]["key"]
            FX.Sparks Squad.SX(tEX), kBase - Squad.H(tEX), kZ, 12, "255,80,80"
            Squad.Say "A SOLDIER IS LOST"
            Squad.CheckSquad
            if sOver then exit Squad.Enemies
         end if
      end repeat
      -- it reaches the buggy: run down (the bump throws a soldier off), or squashed from above
      if abs(tEX - sX) < 40 and sY - Squad.H(tEX) < 30 then
         FX.Sparks Squad.SX(tEX), kBase - Squad.H(tEX) - 20, kZ, 10, "200,80,255"
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
         if sAir then
            add 50 to sScore
            Squad.Say "SQUASHED!"
         else
            add 25 to sScore
            Squad.ThrowOff false
         end if
         next repeat
      end if
      if abs(tEX - sX) > 900 + 2 * kCamBack then
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
      end if
   end repeat
end Squad.Enemies

-- a soldier goes over the side: a bump does it some of the time, a bomb always
on Squad.ThrowOff pSure
   local i, tOn
   put empty into tOn
   repeat with i = 1 to 3
      if sMan[i]["state"] is "on" then put i & comma after tOn
   end repeat
   if tOn is empty then exit Squad.ThrowOff
   if pSure is not true and random(100) > 45 + sLevel * 8 then exit Squad.ThrowOff
   put item random(the number of items of tOn) of tOn into i
   put "down" into sMan[i]["state"]
   put sX - 60 - random(40) into sMan[i]["x"]
   Entity.Kill sMan[i]["key"]
   put Entity.Spawn("Squad.Down", Squad.SX(sMan[i]["x"]), kBase, kZ - 4, "255,150,0") into sMan[i]["key"]
   Squad.Say "MAN OVERBOARD! STOP BESIDE HIM"
end Squad.ThrowOff

on Squad.CheckSquad
   local i, tLeft
   put 0 into tLeft
   repeat with i = 1 to 3
      if sMan[i]["state"] is not "lost" then add 1 to tLeft
   end repeat
   if tLeft > 0 then exit Squad.CheckSquad
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Squad.Say "THE SQUAD IS GONE"
      Squad.ShowHUD
      exit Squad.CheckSquad
   end if
   Squad.Restart sLastFlagX
   Squad.Say "SQUAD LOST. A FRESH ONE AT THE LAST FLAG"
end Squad.CheckSquad

-- the soldiers on board fire at the nearest walker in range; the gun is yours
on Squad.Shoot
   local i, tK, tBest, tD, tTarget
   repeat with i = 1 to 3
      if sMan[i]["state"] is not "on" then next repeat
      if sMan[i]["wait"] > 0 then
         subtract 1 from sMan[i]["wait"]
         next repeat
      end if
      put 400 into tBest
      put empty into tTarget
      repeat for each key tK in sEnemy
         put abs(sEnemy[tK]["x"] - sX) into tD
         if tD < tBest then
            put tD into tBest
            put tK into tTarget
         end if
      end repeat
      if tTarget is empty then next repeat
      put 15 into sMan[i]["wait"]
      add 1 to sShotN
      put sX + (i - 2.5) * 16 into sShot[sShotN]["x"]
      put sY + 40 into sShot[sShotN]["h"]
      put tTarget into sShot[sShotN]["target"]
      put Entity.Spawn("Squad.Shot", Squad.SX(sShot[sShotN]["x"]), kBase - sShot[sShotN]["h"], kZ, "255,255,120") into sShot[sShotN]["key"]
   end repeat
end Squad.Shoot

-- the reticle follows the mouse; a click fires the gun at it
on Squad.Aim
   local tM
   put Squad.MousePoint() into tM
   if tM is empty then
      put empty into sAimX
      Entity.SetPosition sRet, 0, -2000, kZ - 6
   else
      put sX + item 1 of tM - kBuggyX into sAimX
      put kBase - item 2 of tM into sAimH
      Entity.SetPosition sRet, item 1 of tM * (kZ + kCamBack - 6) / (kZ + kCamBack), Squad.RetY(item 2 of tM), kZ - 6
      Entity.SetRotation sRet, 0, 0, sTicks / 25
   end if
   if sFireT > 0 then subtract 1 from sFireT
   if sAimX is not empty and sFireT <= 0 and Squad.MouseDown() then
      put 6 into sFireT
      Squad.Fire
   end if
end Squad.Aim

-- the reticle stands 6 nearer than the buggy: on the same screen point as y at the buggy's depth
function Squad.RetY pY
   local tCY
   put kBase - kBase * (kZ + kCamBack) / kZ into tCY
   return tCY + (pY - tCY) * (kZ + kCamBack - 6) / (kZ + kCamBack)
end Squad.RetY

-- the mouse as a point at the buggy's depth ("x,y" as entities are placed), or empty
function Squad.MousePoint
   local tP, tErr, tM
   if sTestAim is not empty then return sTestAim
   if gNoMouse is true then return empty
   try
      put Engine.Mouse() into tM
      if tM is empty then return empty
      return Squad.ScreenPoint(item 1 of tM, item 2 of tM)
   catch tErr
      return empty
   end try
end Squad.MousePoint

-- a screen pixel as a point at the buggy's depth ("x,y" as entities are placed), or empty. The camera
-- stands kCamBack back and raised (Squad.View): a pixel there is (kZ + kCamBack) / projection units
function Squad.ScreenPoint pMX, pMY
   local tP
   put Engine.Info("projection") into tP
   set the itemDelimiter to comma
   if item 3 of tP is not a number or item 1 of tP <= 0 or pMX is not a number or pMY is not a number then return empty
   return ((pMX - item 2 of tP) * (kZ + kCamBack) / item 1 of tP) & comma & \
         (kBase - kBase * (kZ + kCamBack) / kZ + (pMY - item 3 of tP) * (kZ + kCamBack) / item 1 of tP)
end Squad.ScreenPoint

function Squad.MouseDown
   local tErr
   if sTestMouse is not empty then return sTestMouse is true
   if gNoMouse is true then return false
   try
      return the mouse is "down"
   catch tErr
      return false
   end try
end Squad.MouseDown

-- a straight shot from the gun's muzzle toward the reticle
on Squad.Fire
   local tX, tH, tDX, tDH, tD
   put sX + 46 into tX
   put sY + 62 into tH
   put sAimX - tX into tDX
   put sAimH - tH into tDH
   put sqrt(tDX ^ 2 + tDH ^ 2) into tD
   if tD < 1 then exit Squad.Fire
   put true into sFired
   add 1 to sShotN
   put tX into sShot[sShotN]["x"]
   put tH into sShot[sShotN]["h"]
   put tDX / tD * kShotV into sShot[sShotN]["vx"]
   put tDH / tD * kShotV into sShot[sShotN]["vh"]
   put 40 into sShot[sShotN]["life"]
   put Entity.Spawn("Squad.Shot", Squad.SX(tX), kBase - tH, kZ, "255,255,255") into sShot[sShotN]["key"]
   Entity.SetRotation sShot[sShotN]["key"], 0, 0, -atan2(tDH, tDX)
end Squad.Fire

-- the soldiers' shots home on their walker (it may already be gone); the gun's fly straight
-- and hit bombers, bombs and walkers on the way
on Squad.Shots
   local tS, tT, tDX, tDH, tD, tHit, tK
   repeat for each key tS in sShot
      put false into tHit
      if sShot[tS]["vx"] is not empty then
         add sShot[tS]["vx"] to sShot[tS]["x"]
         add sShot[tS]["vh"] to sShot[tS]["h"]
         subtract 1 from sShot[tS]["life"]
         if sShot[tS]["life"] <= 0 or sShot[tS]["h"] < Squad.H(sShot[tS]["x"]) then put true into tHit
         repeat for each key tK in sFly
            if tHit then exit repeat
            if (sFly[tK]["x"] - sShot[tS]["x"]) ^ 2 + (sFly[tK]["h"] - sShot[tS]["h"]) ^ 2 < 900 then
               FX.Sparks Squad.SX(sFly[tK]["x"]), kBase - sFly[tK]["h"], kZ, 16, "255,60,120"
               Entity.Kill sFly[tK]["key"]
               delete variable sFly[tK]
               add 100 to sScore
               Squad.Say "BOMBER DOWN! +100"
               put true into tHit
            end if
         end repeat
         repeat for each key tK in sBomb
            if tHit then exit repeat
            if (sBomb[tK]["x"] - sShot[tS]["x"]) ^ 2 + (sBomb[tK]["h"] - sShot[tS]["h"]) ^ 2 < 400 then
               if sBomb[tK]["round"] is true then
                  FX.Sparks Squad.SX(sBomb[tK]["x"]), kBase - sBomb[tK]["h"], kZ, 6, "255,255,255"
               else
                  Squad.Blast sBomb[tK]["x"], sBomb[tK]["h"], false
               end if
               Entity.Kill sBomb[tK]["key"]
               delete variable sBomb[tK]
               add 20 to sScore
               put true into tHit
            end if
         end repeat
         repeat for each key tK in sSnipe
            if tHit then exit repeat
            if abs(sSnipe[tK]["x"] - sShot[tS]["x"]) < 14 and sShot[tS]["h"] - sSnipe[tK]["h"] < 40 and sShot[tS]["h"] - sSnipe[tK]["h"] > -6 then
               FX.Sparks Squad.SX(sSnipe[tK]["x"]), kBase - sSnipe[tK]["h"] - 18, kZ, 12, "200,80,255"
               Entity.Kill sSnipe[tK]["key"]
               delete variable sSnipe[tK]
               add 75 to sScore
               Squad.Say "SNIPER DOWN! +75"
               put true into tHit
            end if
         end repeat
         repeat for each key tK in sEnemy
            if tHit then exit repeat
            if abs(sEnemy[tK]["x"] - sShot[tS]["x"]) < 12 and sShot[tS]["h"] - Squad.H(sEnemy[tK]["x"]) < 38 then
               FX.Sparks Squad.SX(sEnemy[tK]["x"]), kBase - Squad.H(sEnemy[tK]["x"]) - 18, kZ, 8, "200,80,255"
               Entity.Kill sEnemy[tK]["key"]
               delete variable sEnemy[tK]
               add 50 to sScore
               put true into tHit
            end if
         end repeat
         if not tHit then
            Entity.SetPosition sShot[tS]["key"], Squad.SX(sShot[tS]["x"]), kBase - sShot[tS]["h"], kZ
         end if
      else
         put sShot[tS]["target"] into tT
         if sEnemy[tT] is empty then
            put true into tHit
         else
            put sEnemy[tT]["x"] - sShot[tS]["x"] into tDX
            put Squad.H(sEnemy[tT]["x"]) + 18 - sShot[tS]["h"] into tDH
            put sqrt(tDX ^ 2 + tDH ^ 2) into tD
            if tD < 22 then
               FX.Sparks Squad.SX(sEnemy[tT]["x"]), kBase - Squad.H(sEnemy[tT]["x"]) - 18, kZ, 8, "200,80,255"
               Entity.Kill sEnemy[tT]["key"]
               delete variable sEnemy[tT]
               add 50 to sScore
               put empty into sHUDWas
               put true into tHit
            else
               add tDX / tD * 20 to sShot[tS]["x"]
               add tDH / tD * 20 to sShot[tS]["h"]
               Entity.SetPosition sShot[tS]["key"], Squad.SX(sShot[tS]["x"]), kBase - sShot[tS]["h"], kZ
               Entity.SetRotation sShot[tS]["key"], 0, 0, -atan2(tDH, tDX)
            end if
         end if
      end if
      if tHit then
         Entity.Kill sShot[tS]["key"]
         delete variable sShot[tS]
      end if
   end repeat
end Squad.Shots

-------------------------------------------------------------------- grenades (ours)
-- G or the right mouse button: lob one toward the ground under the reticle (no reticle: straight
-- ahead). It flies an arc in the game's light gravity and goes off where it meets the ground.
on Squad.Grenades pKeys
   local tK, tDown, tErr
   if sNadeT > 0 then subtract 1 from sNadeT
   if sTestNade is not empty then
      put sTestNade is true into tDown
   else
      put Squad.Down(103, pKeys) or Squad.Down(71, pKeys) into tDown
      if not tDown and gNoMouse is not true then
         try
            put mouse(3) is "down" into tDown
         catch tErr
         end try
      end if
   end if
   if tDown and sNadeT <= 0 then
      put kNadeWait into sNadeT
      Squad.Lob
   end if
   repeat for each key tK in sNade
      subtract kGrav from sNade[tK]["vh"]
      add sNade[tK]["vx"] to sNade[tK]["x"]
      add sNade[tK]["vh"] to sNade[tK]["h"]
      if sNade[tK]["h"] <= Squad.H(sNade[tK]["x"]) and sNade[tK]["vh"] < 0 then
         Squad.NadeBlast sNade[tK]["x"]
         Entity.Kill sNade[tK]["key"]
         delete variable sNade[tK]
         if sOver then
            exit Squad.Grenades
         end if
      else
         Entity.SetPosition sNade[tK]["key"], Squad.SX(sNade[tK]["x"]), kBase - sNade[tK]["h"], kZ
         Entity.SetRotation sNade[tK]["key"], 0, 0, sTicks / 3
      end if
   end repeat
end Squad.Grenades

-- the throw: from the buggy's back, timed so it comes down on the ground at the aim point
on Squad.Lob
   local tX, tH, tTX, tTH, tT
   put sX into tX
   put sY + 50 into tH
   if sAimX is empty then
      put sX + 300 into tTX
   else
      put max(sX - kNadeFar, min(sX + kNadeFar, sAimX)) into tTX
   end if
   put Squad.H(tTX) into tTH
   put max(24, min(70, abs(tTX - tX) / 9 + 20)) into tT          -- flight steps: longer for far throws
   add 1 to sNadeN
   put tX into sNade[sNadeN]["x"]
   put tH into sNade[sNadeN]["h"]
   put (tTX - tX) / tT into sNade[sNadeN]["vx"]
   put (tTH - tH + 0.5 * kGrav * tT * tT) / tT into sNade[sNadeN]["vh"]
   put Entity.Spawn("Squad.Bomb", Squad.SX(tX), kBase - tH, kZ, "120,255,90") into sNade[sNadeN]["key"]
   put true into sThrown
end Squad.Lob

-- our grenade goes off on the ground: the bomb's blast (crater, walkers, the buggy if near) plus
-- walkers a little further out, and points for them
on Squad.NadeBlast pX
   local tK, tN
   put 0 into tN
   repeat for each key tK in sEnemy
      if abs(sEnemy[tK]["x"] - pX) < kNadeR then
         FX.Sparks Squad.SX(sEnemy[tK]["x"]), kBase - Squad.H(sEnemy[tK]["x"]) - 18, kZ, 8, "200,80,255"
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
         add 1 to tN
      end if
   end repeat
   if tN > 0 then
      add 50 * tN to sScore
      put empty into sHUDWas
   end if
   Squad.Blast pX, Squad.H(pX), true
   FX.Sparks Squad.SX(pX), kBase - Squad.H(pX), kZ, 10, "120,255,90"
end Squad.NadeBlast

-- bombers cross the sky (most from ahead), dropping bombs where the buggy is heading
on Squad.Flyers
   local tK, tT, tLand, tSide
   subtract 1 from sNextFly
   -- snipers up ahead: the bombers come soon, and from behind
   if Squad.SnipersAhead() > 0 and sNextFly > 120 and sNextFly < 1e8 then put 75 + random(45) into sNextFly
   if sNextFly <= 0 then
      put max(110, 300 - sLevel * 35) + random(90) into sNextFly
      if the number of lines of the keys of sFly < min(3, sLevel) or (Squad.SnipersAhead() > 0 and the number of lines of the keys of sFly < min(3, sLevel + 1)) then
         put 1 into tSide
         if random(10) <= 3 then put -1 into tSide
         if Squad.SnipersAhead() > 0 then
            put -1 into tSide
            add 1 to sBehind
            Squad.Say "BOMBERS BEHIND YOU!"
         end if
         if tSide is 1 then
            Squad.AddFlyer sX + 720 + 2 * kCamBack, -(2 + 0.3 * sLevel)
         else
            Squad.AddFlyer sX - 520 - kCamBack, sV + 1.5 + 0.3 * sLevel
         end if
      end if
   end if
   repeat for each key tK in sFly
      add sFly[tK]["vx"] to sFly[tK]["x"]
      put sFly[tK]["base"] + 6 * sin(sTicks / 10 + tK) into sFly[tK]["h"]
      Entity.SetPosition sFly[tK]["key"], Squad.SX(sFly[tK]["x"]), kBase - sFly[tK]["h"], kZ + 1
      if sFly[tK]["cool"] > 0 then subtract 1 from sFly[tK]["cool"]
      if sFly[tK]["bombs"] > 0 and sFly[tK]["cool"] <= 0 then
         -- where a bomb let go now lands, against where the buggy will be
         put sqrt(2 * max(1, sFly[tK]["h"] - Squad.H(sFly[tK]["x"])) / kGrav) into tT
         put sFly[tK]["x"] + sFly[tK]["vx"] * tT into tLand
         if abs(tLand - (sX + 0.5 * sV * tT)) < 50 or random(120) is 1 then
            Squad.AddBomb sFly[tK]["x"], sFly[tK]["h"] - 8, sFly[tK]["vx"]
            subtract 1 from sFly[tK]["bombs"]
            put 30 into sFly[tK]["cool"]
         end if
      end if
      if abs(sFly[tK]["x"] - sX) > 1000 + 2 * kCamBack then
         Entity.Kill sFly[tK]["key"]
         delete variable sFly[tK]
      end if
   end repeat
end Squad.Flyers

on Squad.AddFlyer pX, pVX
   add 1 to sFlyN
   put pX into sFly[sFlyN]["x"]
   put pVX into sFly[sFlyN]["vx"]
   put 300 + random(70) into sFly[sFlyN]["base"]
   put sFly[sFlyN]["base"] into sFly[sFlyN]["h"]
   put 2 + sLevel div 2 into sFly[sFlyN]["bombs"]
   put 0 into sFly[sFlyN]["cool"]
   put Entity.Spawn("Squad.Flyer", Squad.SX(pX), kBase - sFly[sFlyN]["h"], kZ + 1, "255,60,120") into sFly[sFlyN]["key"]
   if pVX > 0 then Entity.SetRotation sFly[sFlyN]["key"], 0, 3.14159, 0
end Squad.AddFlyer

on Squad.AddBomb pX, pH, pVX
   add 1 to sBombN
   put pX into sBomb[sBombN]["x"]
   put pH into sBomb[sBombN]["h"]
   put pVX into sBomb[sBombN]["vx"]
   put 0 into sBomb[sBombN]["vh"]
   put Entity.Spawn("Squad.Bomb", Squad.SX(pX), kBase - pH, kZ, "255,200,0") into sBomb[sBombN]["key"]
end Squad.AddBomb

-- bombs fall (lightly): on the buggy, or into the hills
on Squad.Bombs
   local tK
   repeat for each key tK in sBomb
      if sBomb[tK]["round"] is not true then subtract kGrav from sBomb[tK]["vh"]
      add sBomb[tK]["vx"] to sBomb[tK]["x"]
      add sBomb[tK]["vh"] to sBomb[tK]["h"]
      Entity.SetPosition sBomb[tK]["key"], Squad.SX(sBomb[tK]["x"]), kBase - sBomb[tK]["h"], kZ
      Entity.SetRotation sBomb[tK]["key"], 0, 0, sTicks / 4
      if sBomb[tK]["round"] is true then
         -- a sniper's round: it hits the buggy, the ground, or flies on out
         subtract 1 from sBomb[tK]["life"]
         if abs(sBomb[tK]["x"] - sX) < 40 and sBomb[tK]["h"] - sY < 50 and sBomb[tK]["h"] - sY > -6 then
            FX.Sparks Squad.SX(sBomb[tK]["x"]), kBase - sBomb[tK]["h"], kZ, 10, "255,255,255"
            Squad.ThrowOff true
            if sMsg is not "MAN OVERBOARD! STOP BESIDE HIM" then
               Squad.Say "SNIPER HIT!"
            end if
         else if sBomb[tK]["h"] <= Squad.H(sBomb[tK]["x"]) or sBomb[tK]["life"] <= 0 then
            FX.Sparks Squad.SX(sBomb[tK]["x"]), kBase - sBomb[tK]["h"], kZ, 4, "200,200,200"
         else
            next repeat
         end if
      else if abs(sBomb[tK]["x"] - sX) < 36 and sBomb[tK]["h"] - sY < 44 and sBomb[tK]["h"] - sY > -8 then
         Squad.Blast sBomb[tK]["x"], sBomb[tK]["h"], true
      else if sBomb[tK]["h"] <= Squad.H(sBomb[tK]["x"]) then
         Squad.Blast sBomb[tK]["x"], Squad.H(sBomb[tK]["x"]), true
      else
         next repeat
      end if
      Entity.Kill sBomb[tK]["key"]
      delete variable sBomb[tK]
      if sOver then exit Squad.Bombs
   end repeat
end Squad.Bombs

-- a bomb goes off: on the ground it digs a crater; walkers near it go, and the buggy near it
-- is bounced and loses a soldier over the side
on Squad.Blast pX, pH, pDig
   local tK
   FX.Sparks Squad.SX(pX), kBase - pH, kZ, 18, "255,160,40"
   if pDig and sCrR > 0 then
      add 1 to sCraterN
      put pX into sCrater[sCraterN]
      repeat for each key tK in sCrater
         if abs(sCrater[tK] - sX) > 1400 then delete variable sCrater[tK]
      end repeat
   end if
   repeat for each key tK in sEnemy
      if abs(sEnemy[tK]["x"] - pX) < 50 and pH - Squad.H(sEnemy[tK]["x"]) < 60 then
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
      end if
   end repeat
   if abs(pX - sX) < 60 and pH - sY < 60 and pH - sY > -20 then
      put true into sAir
      put max(sVY, 3) into sVY
      Squad.ThrowOff true
   end if
end Squad.Blast

-------------------------------------------------------------------- buildings and snipers
-- Where they stand is fixed by the course (the same every ride): about every kTowerGap,
-- never near a flag. Slot n's place and kind come from a sine hash of n.
function Squad.TowerSlot pN
   local tX, tR
   if pN < 1 then return empty
   put pN * kTowerGap + 700 + round(260 * sin(pN * 12.9898)) into tX
   if abs(tX - round(tX / kFlagGap) * kFlagGap) < 260 then return empty
   put abs(sin(pN * 78.233)) into tR
   if tR < 0.45 then return tX & ",w"
   return tX & ",b"
end Squad.TowerSlot

on Squad.MakeTower pTw, pX, pKind
   local tW, tH, tName
   put pX into sTower[pTw]["x"]
   put pKind into sTower[pTw]["kind"]
   if pKind is "w" then
      put 150 + (round(pX) mod 3) * 20 into tH
      put "Squad.Tower" & tH into tName
      if sTower["defined"][tName] is empty then Mesh.Define tName, Squad.TowerMesh(tH)
      put 28 into tW
   else
      put 90 + (round(pX) mod 4) * 18 into tH
      put 90 + (round(pX / 7) mod 3) * 22 into tW
      put "Squad.Bld" & tW & "x" & tH into tName
      if sTower["defined"][tName] is empty then Mesh.Define tName, Squad.BuildingMesh(tW, tH)
      put tW / 2 - 8 into tW
   end if
   put true into sTower["defined"][tName]
   put Squad.Hill(pX) into sTower[pTw]["ground"]
   put Squad.Hill(pX) + tH into sTower[pTw]["roof"]
   put tW into sTower[pTw]["half"]
   put Entity.Spawn(tName, Squad.SX(pX), kBase - sTower[pTw]["ground"], kZ + 2, "90,150,190") into sTower[pTw]["key"]
end Squad.MakeTower

-- pN snipers on roof pTw (none behind you, none when quiet)
on Squad.ManTower pTw, pN
   local i, tX
   repeat with i = 1 to pN
      add 1 to sSnipeN
      put sTower[pTw]["x"] + (i - (pN + 1) / 2) * sTower[pTw]["half"] into tX
      put tX into sSnipe[sSnipeN]["x"]
      put sTower[pTw]["roof"] into sSnipe[sSnipeN]["h"]
      put pTw into sSnipe[sSnipeN]["tower"]
      put 40 + random(50) into sSnipe[sSnipeN]["wait"]
      put Entity.Spawn("Squad.Sniper", Squad.SX(tX), kBase - sSnipe[sSnipeN]["h"], kZ + 1, "200,80,255") into sSnipe[sSnipeN]["key"]
   end repeat
end Squad.ManTower

-- buildings come into view ahead (manned), and go when far behind
on Squad.Towers
   local tN, tSlot, tI, tK
   repeat with tN = max(0, (sX - 600) div kTowerGap) to (sX + 900) div kTowerGap + 1
      put Squad.TowerSlot(tN) into tSlot
      if tSlot is empty then next repeat
      put "s" & tN into tI
      if tI is among the keys of sTower then next repeat
      if item 1 of tSlot < sX - 500 or item 1 of tSlot > sX + 850 then next repeat
      Squad.MakeTower tI, item 1 of tSlot, item 2 of tSlot
      if item 1 of tSlot > sX + 300 and not sNoSnipe then
         put 1 into tK
         if sLevel >= 3 then add 1 to tK
         if sLevel >= 5 then add 1 to tK
         Squad.ManTower tI, tK
      end if
   end repeat
   repeat for each key tK in sTower
      if tK is "defined" then next repeat
      if sTower[tK]["x"] < sX - 700 or sTower[tK]["x"] > sX + 1200 then
         Entity.Kill sTower[tK]["key"]
         delete variable sTower[tK]
         next repeat
      end if
      Entity.SetPosition sTower[tK]["key"], Squad.SX(sTower[tK]["x"]), kBase - sTower[tK]["ground"], kZ + 2
   end repeat
end Squad.Towers

-- snipers on a roof ahead aim at the buggy and fire slow rounds at where it will be
on Squad.Snipers
   local tK, tDX, tDH, tD, tT
   repeat for each key tK in sSnipe
      put sSnipe[tK]["x"] into tDX
      if tDX < sX - 700 or tDX > sX + 1200 then
         Entity.Kill sSnipe[tK]["key"]
         delete variable sSnipe[tK]
         next repeat
      end if
      Entity.SetPosition sSnipe[tK]["key"], Squad.SX(tDX), kBase - sSnipe[tK]["h"], kZ + 1
      if tDX - sX < 60 or tDX - sX > kSnipeRange then next repeat
      if not sWarned then
         put true into sWarned
         Squad.Say "SNIPERS ON THE ROOF AHEAD!"
      end if
      subtract 1 from sSnipe[tK]["wait"]
      if sSnipe[tK]["wait"] > 0 then next repeat
      put max(55, 120 - sLevel * 10) + random(50) into sSnipe[tK]["wait"]
      -- lead the buggy by how fast it is going
      put tDX - 28 into tDX
      put sSnipe[tK]["h"] + 26 into tDH
      put (sX + sMove * 0.8 * abs(tDX - sX) / kRoundV) - tDX into tT
      put (sY + 22) - tDH into tD
      put sqrt(tT ^ 2 + tD ^ 2) into tDH
      if tDH < 1 then next repeat
      Squad.AddBomb tDX, sSnipe[tK]["h"] + 26, tT / tDH * kRoundV
      put true into sBomb[sBombN]["round"]
      put tD / tDH * kRoundV into sBomb[sBombN]["vh"]
      put 220 into sBomb[sBombN]["life"]
      Entity.Kill sBomb[sBombN]["key"]
      put Entity.Spawn("Squad.Round", Squad.SX(tDX), kBase - sSnipe[tK]["h"] - 26, kZ, "255,255,255") into sBomb[sBombN]["key"]
   end repeat
end Squad.Snipers

-- snipers on a roof that is ahead and in range
function Squad.SnipersAhead
   local tK, tN
   put 0 into tN
   repeat for each key tK in sSnipe
      if sSnipe[tK]["x"] - sX >= 60 and sSnipe[tK]["x"] - sX <= kSnipeRange then add 1 to tN
   end repeat
   return tN
end Squad.SnipersAhead

function Squad.TowersNear
   local tK, tN
   put 0 into tN
   repeat for each key tK in sTower
      if tK is not "defined" then add 1 to tN
   end repeat
   return tN
end Squad.TowersNear

function Squad.Rounds
   local tK, tN
   put 0 into tN
   repeat for each key tK in sBomb
      if sBomb[tK]["round"] is true then add 1 to tN
   end repeat
   return tN
end Squad.Rounds

-- the flag: reach it, then stay near it while the clock runs
on Squad.Flags
   local tFX
   put sLastFlagX + kFlagGap into tFX
   Entity.SetPosition sFlag, Squad.SX(tFX), kBase - Squad.H(tFX), kZ + 2
   if sHold <= 0 and abs(sX - tFX) < 60 then
      put kHoldSteps into sHold
      add 200 to sScore
      Squad.Say "FLAG REACHED! HOLD IT FOR 20 SECONDS"
   end if
   if sHold > 0 then
      if abs(sX - tFX) > 150 then
         put 0 into sHold
         Squad.Say "YOU LEFT THE FLAG! GO BACK"
      else
         subtract 1 from sHold
         if sHold is 0 then
            add 300 * sLevel to sScore
            put tFX into sLastFlagX
            add 1 to sFlagX
            if sFlagX > sFlagN then
               add sBonus to sScore
               if sLevel >= 5 then
                  put true into sWon
                  put true into sOver
                  put empty into sHUDWas
                  Squad.ShowHUD
               else
                  Squad.GoLevel sLevel + 1
               end if
               exit Squad.Flags
            end if
            Squad.Say "FLAG HELD! ON TO THE NEXT"
         end if
      end if
   end if
end Squad.Flags

on Squad.Say pText
   put pText into sMsg
   put 50 into sMsgT
   put empty into sHUDWas
end Squad.Say

on Squad.ShowHUD
   local tWords, tLine, i, tOn
   put 0 into tOn
   repeat with i = 1 to 3
      if sMan[i]["state"] is "on" then add 1 to tOn
   end repeat
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & tOn & "|" & sFlagX & "|" & sHold div 30 & "|" & sMsg & "|" & (sJumped and sFired and sThrown) into tWords
   if tWords is sHUDWas then exit Squad.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Squad.Score", "SCORE" && sScore && " LIVES" && sLives && " LEVEL" && sLevel && " FLAG" && min(sFlagX, sFlagN) & "/" & sFlagN && " SQUAD" && tOn & "/3", 20, 40, 14
   if sOver and sWon then
      put "ALL FLAGS HELD. MISSION DONE!  SPACE TO RIDE AGAIN" into tLine
   else if sOver then
      put "GAME OVER.  SPACE TO RIDE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else if sHold > 0 then
      put "HOLD THE FLAG:" && sHold div 30 into tLine
   else
      put "DRIVE RIGHT TO THE GREEN FLAG" into tLine
   end if
   HUD.Set "Squad.Msg", tLine, 20, 70, 12
   -- the controls stay up until you have jumped and fired
   if sJumped and sFired and sThrown then
      HUD.Remove "Squad.Help"
   else
      HUD.Set "Squad.Help", "D: DRIVE   A: BACK UP   SPACE: JUMP   MOUSE: AIM   CLICK: FIRE   G: GRENADE", 20, gViewBottom - 30, 11
   end if
end Squad.ShowHUD

function Squad.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "|flag " & sFlagX & "|hold " & sHold & "|enemies " & the number of lines of the keys of sEnemy & "|" & sOver into tS
   repeat with i = 1 to 3
      put "|m" & i && sMan[i]["state"] after tS
   end repeat
   put "|air " & sAir & "|up " & round(sY - Squad.H(sX)) & "|bombers " & the number of lines of the keys of sFly & "|bombs " & the number of lines of the keys of sBomb & "|craters " & the number of lines of the keys of sCrater after tS
   put "|towers " & Squad.TowersNear() & "|snipers " & the number of lines of the keys of sSnipe & "|rounds " & Squad.Rounds() & "|behind " & sBehind & "|grenades " & the number of lines of the keys of sNade after tS
   return tS
end Squad.State

-- test hooks: the reticle (entity x,y), the button, a bomber or a bomb or a crater placed
-- relative to the buggy, the ground's height there
on Squad.TestAim pX, pY
   if pX is empty then
      put empty into sTestAim
   else
      put pX & comma & pY into sTestAim
   end if
end Squad.TestAim

on Squad.TestMouse pDown
   put pDown into sTestMouse
end Squad.TestMouse

on Squad.TestFlyer pDX, pH, pVX
   Squad.AddFlyer sX + pDX, pVX
   put pH into sFly[sFlyN]["base"]
   put pH into sFly[sFlyN]["h"]
   put 0 into sFly[sFlyN]["bombs"]
end Squad.TestFlyer

on Squad.TestBomb pDX, pUp
   Squad.AddBomb sX + pDX, Squad.H(sX + pDX) + pUp, 0
end Squad.TestBomb

on Squad.TestCrater pDX
   add 1 to sCraterN
   put sX + pDX into sCrater[sCraterN]
end Squad.TestCrater

-- grenade button for tests: true = G held (empty = the real keys and mouse)
on Squad.TestNade pDown
   put pDown into sTestNade
end Squad.TestNade

on Squad.TestQuiet
   put 1e9 into sNextEnemy
   put 1e9 into sNextFly
   put true into sNoSnipe
end Squad.TestQuiet

-- a building (pKind "b") or a water tower ("w") pDX ahead, with pN snipers on it
on Squad.TestTower pDX, pKind, pN
   local tI
   put "t" & (the number of lines of the keys of sTower + 1000) into tI
   Squad.MakeTower tI, sX + pDX, pKind
   put false into sNoSnipe
   Squad.ManTower tI, pN
end Squad.TestTower

on Squad.TestNoSnipe pFlag
   put pFlag into sNoSnipe
end Squad.TestNoSnipe

on Squad.TestFlyTimer pN
   put pN into sNextFly
end Squad.TestFlyTimer

-- the first sniper's place "x,h" (course x, height)
function Squad.SniperAt
   local tK
   repeat for each key tK in sSnipe
      return sSnipe[tK]["x"] & comma & sSnipe[tK]["h"]
   end repeat
   return empty
end Squad.SniperAt

-- the course x of the bomber that flies the furthest behind the buggy, or empty
function Squad.FlyerXs
   local tK, tOut
   repeat for each key tK in sFly
      put round(sFly[tK]["x"] - sX) & comma & round(sFly[tK]["vx"], 1) & cr after tOut
   end repeat
   return tOut
end Squad.FlyerXs

function Squad.GroundAt pDX
   return Squad.H(sX + pDX)
end Squad.GroundAt

function Squad.X
   return sX
end Squad.X

function Squad.ManX pWho
   return sMan[pWho]["x"]
end Squad.ManX

on Game.OnStop
   HUD.Clear
   Camera.Reset
end Game.OnStop

on arrowKey pKey
end arrowKey
