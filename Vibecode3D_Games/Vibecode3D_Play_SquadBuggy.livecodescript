######################################################################################
## CARD SCRIPT: "Play.SquadBuggy"   SQUAD BUGGY  (11 14 2026)
## An armoured buggy over rolling hills, seen from the side, three soldiers riding on the
## back and a gunner at the mounted gun. They shoot the nearest enemy by themselves; you
## drive. Reach each green flag and hold it. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/809_Squad_Buggy), script by Claude.
## CONTROLS  Right/Left (or D/A): drive on / back up    Space: stop (stop beside a fallen
##           soldier to pick him up)    Escape: pause
## RULES     an enemy that reaches the buggy is run down, but the bump throws a soldier
##           off. An enemy that reaches a fallen soldier takes him. Lose all three
##           soldiers: a life, and back to the last flag with a fresh squad. At a flag,
##           stay near it for 20 seconds while they come from both sides. 3 flags a
##           level, 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sBuggy, sWheel, sX, sV, sMan, sEnemy, sEnemyN, sShot, sShotN, sFlag, sFlagN, sFlagX
local sHold, sSlice, sNextEnemy, sLastFlagX, sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT
local sBonus, sESpeed, sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kBase = 230
constant kBuggyX = -120      -- the buggy stays here on the screen
constant kSeg = 40
constant kSlices = 26
constant kFlagGap = 2400
constant kHoldSteps = 600    -- 20 seconds

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Squad.StartLevel 1
end Game.OnStart

-- Spark's table: buggy speed | flags | lives | bonus
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
   Mesh.Define "Squad.Shot", MeshBox(8, 2, 2)
   Mesh.Define "Squad.Flag", Squad.FlagMesh()
   put empty into sSlice
   repeat with i = 0 to kSlices
      put empty into sSlice[i]["type"]
   end repeat
   put Entity.Spawn("Squad.Buggy", kBuggyX, kBase, kZ, "0,230,255") into sBuggy
   repeat with i = 1 to 2
      put Entity.Spawn("Squad.Wheel", kBuggyX, kBase, kZ, "0,230,255") into sWheel[i]
   end repeat
   put Entity.Spawn("Squad.Flag", 0, kBase, kZ + 2, "0,255,100") into sFlag
   put 0 into sLastFlagX
   put 1 into sFlagX
   Squad.Restart 0
   put "LEVEL" && pLevel & ": REACH THE GREEN FLAG" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Squad.StartLevel

-- (re)start at a course point with a full squad
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
   put 0 into sHold
   put 60 into sNextEnemy
end Squad.Restart

-- the hills
function Squad.H pX
   return 70 + 45 * sin(pX / 420) + 22 * sin(pX / 170 + 1) + 10 * sin(pX / 61)
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
      Mesh.AddVertex tM, 14, 12, 0
      Mesh.AddVertex tM, 20, 12, 0
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

on Game.OnUpdate
   local tKeys, tMove, tStop, i, tG, tAng, tOn
   put Squad.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Squad.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Squad.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put tKeys into sKeysWas
   put 0 into tMove
   put Squad.Down(32, tKeys) into tStop
   if not tStop then
      if Squad.Down(65363, tKeys) or Squad.Down(100, tKeys) then put sV into tMove
      if Squad.Down(65361, tKeys) or Squad.Down(97, tKeys) then put -sV * 0.6 into tMove
   end if
   put max(0, sX + tMove) into sX
   -- the buggy rides the hills
   put Squad.H(sX) into tG
   put atan((Squad.H(sX + 30) - Squad.H(sX - 30)) / 60) into tAng
   SetObjectPosition sBuggy, kBuggyX, kBase - tG - 18, kZ
   SetObjectRotation sBuggy, 0, 0, -tAng
   SetObjectPosition sWheel[1], kBuggyX - 28, kBase - Squad.H(sX - 28) - 12, kZ - 10
   SetObjectPosition sWheel[2], kBuggyX + 30, kBase - Squad.H(sX + 30) - 12, kZ - 10
   SetObjectRotation sWheel[1], 0, 0, sX / 12
   SetObjectRotation sWheel[2], 0, 0, sX / 12
   -- the squad: riding, or lying where they fell
   repeat with i = 1 to 4
      if sMan[i]["state"] is "on" then
         if i is 4 then
            SetObjectPosition sMan[i]["key"], kBuggyX + 26, kBase - tG - 56 - 3 * tAng * 16, kZ - 2
         else
            SetObjectPosition sMan[i]["key"], kBuggyX - 30 + (i - 1) * 16, kBase - tG - 48 - (i - 1) * tAng * 16, kZ - 2
         end if
      else if sMan[i]["state"] is "down" then
         SetObjectPosition sMan[i]["key"], Squad.SX(sMan[i]["x"]), kBase - Squad.H(sMan[i]["x"]) - 4, kZ - 4
         -- stopped beside him: he climbs back on
         if tStop and abs(sMan[i]["x"] - sX) < 50 then
            Entity.Kill sMan[i]["key"]
            put Entity.Spawn("Squad.Sit", kBuggyX, kBase, kZ, "255,150,0") into sMan[i]["key"]
            put "on" into sMan[i]["state"]
            Squad.Say "SOLDIER BACK ON BOARD"
         end if
      end if
   end repeat
   Squad.Ground
   Squad.Enemies
   if sOver then exit Game.OnUpdate
   Squad.Shoot
   Squad.Shots
   Squad.Flags
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Squad.ShowHUD
end Game.OnUpdate

on Squad.Ground
   local i, tIdx, tName, tFirst
   put sX div kSeg - 12 into tFirst
   repeat with i = 0 to kSlices
      put tFirst + i into tIdx
      put Squad.SliceName(Squad.H((tIdx + 1) * kSeg) - Squad.H(tIdx * kSeg)) into tName
      if tName is not sSlice[i]["type"] then
         if sSlice[i]["key"] is not empty then Entity.Kill sSlice[i]["key"]
         put Entity.Spawn(tName, 0, kBase, kZ, "120,200,90") into sSlice[i]["key"]
         put tName into sSlice[i]["type"]
      end if
      SetObjectPosition sSlice[i]["key"], Squad.SX(tIdx * kSeg), kBase - Squad.H(tIdx * kSeg), kZ
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
         put sX + 640 into sEnemy[sEnemyN]["x"]
      else
         put sX - 320 into sEnemy[sEnemyN]["x"]
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
         SetObjectRotation sEnemy[tK]["key"], 0, 3.14159, 0
      else
         subtract sESpeed from sEnemy[tK]["x"]
         SetObjectRotation sEnemy[tK]["key"], 0, 0, 0
      end if
      put sEnemy[tK]["x"] into tEX
      SetObjectPosition sEnemy[tK]["key"], Squad.SX(tEX), kBase - Squad.H(tEX) - 2 * abs(sin(sTicks / 3 + tK)), kZ
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
      -- it reaches the buggy: run down, and the bump throws a soldier off
      if abs(tEX - sX) < 40 then
         FX.Sparks Squad.SX(tEX), kBase - Squad.H(tEX) - 20, kZ, 10, "200,80,255"
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
         add 25 to sScore
         Squad.ThrowOff
         next repeat
      end if
      if abs(tEX - sX) > 900 then
         Entity.Kill sEnemy[tK]["key"]
         delete variable sEnemy[tK]
      end if
   end repeat
end Squad.Enemies

on Squad.ThrowOff
   local i, tOn
   put empty into tOn
   repeat with i = 1 to 3
      if sMan[i]["state"] is "on" then put i & comma after tOn
   end repeat
   if tOn is empty then exit Squad.ThrowOff
   if random(100) > 45 + sLevel * 8 then exit Squad.ThrowOff       -- not every bump
   put item random(the number of items of tOn) of tOn into i
   put "down" into sMan[i]["state"]
   put sX - 60 - random(40) into sMan[i]["x"]
   Entity.Kill sMan[i]["key"]
   put Entity.Spawn("Squad.Down", Squad.SX(sMan[i]["x"]), kBase, kZ - 4, "255,150,0") into sMan[i]["key"]
   Squad.Say "MAN OVERBOARD! STOP BESIDE HIM (SPACE)"
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

-- everyone on board (and the gunner) fires at the nearest enemy in range
on Squad.Shoot
   local i, tK, tBest, tD, tTarget, tRange, tWait
   repeat with i = 1 to 4
      if sMan[i]["state"] is not "on" then next repeat
      if sMan[i]["wait"] > 0 then
         subtract 1 from sMan[i]["wait"]
         next repeat
      end if
      put 400 into tRange
      if i is 4 then put 520 into tRange
      put tRange into tBest
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
      if i is 4 then put 10 into sMan[i]["wait"]
      add 1 to sShotN
      put sX + (i - 2.5) * 16 into sShot[sShotN]["x"]
      put Squad.H(sX) + 40 into sShot[sShotN]["h"]
      put tTarget into sShot[sShotN]["target"]
      put Entity.Spawn("Squad.Shot", Squad.SX(sShot[sShotN]["x"]), kBase - sShot[sShotN]["h"], kZ, "255,255,120") into sShot[sShotN]["key"]
   end repeat
end Squad.Shoot

-- shots fly at their target; it may already be gone
on Squad.Shots
   local tS, tT, tDX, tDH, tD, tHit
   repeat for each key tS in sShot
      put sShot[tS]["target"] into tT
      put false into tHit
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
            SetObjectPosition sShot[tS]["key"], Squad.SX(sShot[tS]["x"]), kBase - sShot[tS]["h"], kZ
            SetObjectRotation sShot[tS]["key"], 0, 0, -atan2(tDH, tDX)
         end if
      end if
      if tHit then
         Entity.Kill sShot[tS]["key"]
         delete variable sShot[tS]
      end if
   end repeat
end Squad.Shots

-- the flag: reach it, then stay near it while the clock runs
on Squad.Flags
   local tFX
   put sLastFlagX + kFlagGap into tFX
   SetObjectPosition sFlag, Squad.SX(tFX), kBase - Squad.H(tFX), kZ + 2
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
                  Squad.StartLevel sLevel + 1
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
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & tOn & "|" & sFlagX & "|" & sHold div 30 & "|" & sMsg into tWords
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
end Squad.ShowHUD

function Squad.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "|flag " & sFlagX & "|hold " & sHold & "|enemies " & the number of lines of the keys of sEnemy & "|" & sOver into tS
   repeat with i = 1 to 3
      put "|m" & i && sMan[i]["state"] after tS
   end repeat
   return tS
end Squad.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
