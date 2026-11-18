######################################################################################
## CARD SCRIPT: "Play.uDead"   UDEAD  (11 13 2026)
## The owner's uDeadGame (iGame3D, uDevGames 2008; Lua by Tobias Opfermann and Bill
## Griffin) as a vector game. You are the uncanny intelligence of a horde of hungry
## dead: you walk among them unseen and tell them where to go and whom to eat.
## Devour every living person on the level to move on.
## The maps are generated: the highway hotel, the warehouse, the alley to the office
## building, the container yard, the arcade, then round again, harder each time.
## (Legacy: the 30 maps of 2009, converted by tools/udg_to_udead.py into
## uDead/udead_levels.txt, play with  uDead.Legacy true .)  Design: uDead/DESIGN.md.
##
## CONTROLS  mouse: look     W A S D: move     arrows: turn (when the mouse is not held)
##           click: send the nearest free zombie to that spot, or at that person or door;
##                  more clicks send more zombies
##           F follow me   H or Space hold   R rush (everyone hunts the nearest living)
##           Z zombie time (slow motion)   I help   L hide the HUD   Escape pause
##           J (cheat) the living drop dead
## RULES     the living wake when they see or hear the dead. Unarmed ones run, some
##           fight with pipes and batons, some shoot, soldiers throw grenades, snipers
##           reach far. Anyone the dead kill gets up as one of them. A zombie shot down
##           gets up once more; a head shot or a second death is final. The freshly
##           dead are frail and fall for good.
##           No living left: you win the level. No dead left: you lost it.
######################################################################################

global gCameraYaw, gCameraPitch
global CenterX, CenterY
global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPaused, bPlaying
global gNoMouse        -- true while an AI tests: never grab or move the owner's mouse

constant kM = 30               -- engine units a metre
constant kCellM = 0.5          -- metres a grid cell (as in the data file)
constant kWallH = 2.0          -- wall height, metres
constant kEye = 1.15           -- camera height, metres
constant kChunk = 16           -- cells a wall chunk (8 m)
constant kSeeChunks = 26       -- metres: wall chunks further than this are not drawn
constant kPlayerSpeed = 4.2    -- metres a second
constant kMouseSens = 0.0035
constant kTurn = 0.055         -- radians a step with the arrow keys
constant kFieldMS = 7          -- milliseconds a step spent on distance maps

constant kZWalk = 1.15         -- zombie speeds, metres a second
constant kZRush = 2.1
constant kBiteReach = 0.95
constant kBiteDelay = 0.5      -- seconds from reaching to killing
constant kEatTime = 3.0
constant kRiseZombie = 10      -- seconds a shot-down zombie lies
constant kRiseHuman = 8        -- seconds until the freshly killed get up
constant kFleeSpeed = 2.3
constant kSeekSpeed = 1.5
constant kSight = 14           -- metres the living see
constant kHearing = 3
constant kShotHeard = 12
constant kGunRange = 14
constant kSniperRange = 30
constant kBlast = 2.0          -- grenade radius, metres
constant kNoiseCrowd = 4       -- this many of the dead within kNoiseNear make noise
constant kNoiseNear = 1.6
constant kNoiseHeard = 8       -- metres the noise wakes the living
constant kBloodMax = 70        -- blood marks kept on the ground
constant kReload = 2.2         -- seconds a reload takes; the shooter stands still
constant kMags = 2             -- spare magazines a shooter carries
constant kCrates = 3           -- ammo crates a level
constant kCrateRefills = 3     -- refills a crate holds

local sStepMS = 33, sTicks = 0, sError
local sData, sLevelNames, sLevel = 1, sName, sNext, sHard, sWinText, sLoseText, sLegacy
local sGenWalls, sGenBars, sGenCast, sGenArms, sGenDoor, sGenUsed, sGenReach, sGenStart, sGenRooms
local sCols, sRows, sPass, sDoorAt, sDoor, sDoorCount
local sChunkList, sChunkAt, sChunkKey
local sE, sIds, sNextId, sZ, sH             -- everyone; ids of the walking dead and the living
local sPX, sPZ, sMouseReady, sTestKeys, sKeyWas
local sState, sNow, sSpeed, sMode, sHideHUD, sHelp, sTip, sTipAt
local sField, sJob, sJobName, sJobD, sJobQ, sJobHead, sJobTail, sJobDoors
local sAmmo, sAmmoN, sFx, sFxN, sBlood, sStrobeAt, sStrobeOn, sNoiseAt, sEase
local sNades, sNextCheck, sCountZ, sCountH, sHUDWas, sMsg, sMsgUntil, sNextLevelAt

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   put Engine.Info("stepMS") into sStepMS
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put empty into sError
   put empty into sHUDWas
   put empty into sKeyWas
   put false into sMouseReady
   if sLegacy is true and sData is empty then uDead.LoadData
   if sError is not empty then
      HUD.Set "uDead.Err", sError, gViewLeft + 20, gViewTop + 120, 14
      exit Game.OnStart
   end if
   uDead.MakeMeshes
   if sLevel is not a number or sLevel < 1 then put 1 into sLevel
   if sLegacy is true and sLevel > the number of lines of sLevelNames then put 1 into sLevel
   uDead.StartLevel sLevel
   if gNoMouse is not true then set the lockCursor to true
end Game.OnStart

on Game.OnUpdate
   local tDT
   if sError is not empty then exit Game.OnUpdate
   add 1 to sTicks
   uDead.Keys
   uDead.Look
   uDead.MovePlayer
   uDead.Camera
   if sNextLevelAt is not empty and sTicks >= sNextLevelAt then
      put empty into sNextLevelAt
      uDead.StartLevel sLevel
      exit Game.OnUpdate
   end if
   if sState is "play" then
      put sStepMS / 1000 * sSpeed into tDT
      add tDT to sNow
      uDead.Lists
      uDead.FieldWork
      uDead.Zombies tDT
      uDead.Humans tDT
      uDead.Grenades
      uDead.Risers
      uDead.FxStep
      uDead.Signals
      if sNow >= sNextCheck then
         put sNow + 2.5 into sNextCheck
         uDead.CheckEnd
      end if
   end if
   if sTicks mod 12 = 1 then uDead.ShowChunks
   uDead.ShowHUD
end Game.OnUpdate

on Game.OnClick pX,pY,pButton
   if sError is not empty then exit Game.OnClick
   if sState is "play" then uDead.Command
end Game.OnClick

on Game.OnKill pKey,pX,pY,pZ
end Game.OnKill

on Game.OnPause
   set the lockCursor to false
   put false into sMouseReady
end Game.OnPause

on Game.OnResume
   if gNoMouse is not true then set the lockCursor to true
   put false into sMouseReady
end Game.OnResume

on Game.OnStop
   set the lockCursor to false
   HUD.Clear
end Game.OnStop

on Collision.Hit pA,pB
end Collision.Hit

-------------------------------------------------------------------- data

on uDead.LoadData
   local tFile, tLine
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/uDead/udead_levels.txt") into tFile
   if tFile is empty then
      put "UDEAD: LEVELS FILE NOT FOUND (LIB_GAMES/VIBECODE3D_GAMES/UDEAD)" into sError
      exit uDead.LoadData
   end if
   put URL ("file:" & tFile) into sData
   put empty into sLevelNames
   repeat for each line tLine in sData
      if char 1 to 6 of tLine is "LEVEL " then put word 2 of tLine & cr after sLevelNames
   end repeat
   delete the last char of sLevelNames
   if sLevelNames is empty then put "UDEAD: NO LEVELS IN THE LEVELS FILE" into sError
end uDead.LoadData

-- the words of a message from the original: its line breaks become spaces, upper case
function uDead.Words pText
   replace "\n" with " " in pText
   replace "\" & quote with quote in pText
   replace "  " with " " in pText
   replace "  " with " " in pText
   return toUpper(word 1 to -1 of pText)
end uDead.Words

-- start a level: a generated one, or (legacy) one of the 2009 maps
on uDead.StartLevel pIndex
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   put empty into sHUDWas
   put pIndex into sLevel
   put empty into sPass
   put empty into sDoorAt
   put empty into sDoor
   put 0 into sDoorCount
   put empty into sE
   put empty into sIds
   put 0 into sNextId
   put empty into sField
   put empty into sJob
   put empty into sJobName
   put empty into sNades
   put empty into sFx
   put empty into sBlood
   put 0 into sStrobeAt
   put 0 into sNoiseAt
   -- the first level is a cake walk, the second easier than before (the owner, 11 13 2026)
   put item min(pIndex, 3) of "0.35,0.65,1" into sEase
   put empty into sChunkKey
   put empty into sMsg
   put empty into sGenWalls
   put empty into sGenBars
   put empty into sGenCast
   put "0 0 0" into sGenArms
   if sLegacy is true then
      uDead.ReadLevel pIndex
   else
      uDead.Generate pIndex
   end if
   uDead.BuildWalls sGenWalls
   uDead.BuildBarriers sGenBars
   uDead.BuildCast sGenCast, sGenArms
   uDead.PlaceCrates
   put 0 into sNow
   put 1 into sSpeed
   put "HOLD" into sMode
   put 2.5 into sNextCheck
   put "play" into sState
   -- the distance maps everyone steers by: H = to the nearest living, Z = to the nearest dead
   -- (doors shut), P = to you. "every" is seconds between refreshes.
   put 1.5 into sJob["H"]["every"]
   put 0 into sJob["H"]["at"]
   put 1.5 into sJob["Z"]["every"]
   put 0 into sJob["Z"]["at"]
   put 1.0 into sJob["P"]["every"]
   put 0 into sJob["P"]["at"]
   -- A = to the nearest ammo crate (made once, again when a crate runs dry)
   put 0 into sJob["A"]["every"]
   put 0 into sJob["A"]["at"]
   uDead.Lists
   uDead.Count
   uDead.Camera
   uDead.ShowChunks
   uDead.Say sName & "  " & sCountH & " LIVING", 4
end uDead.StartLevel

-- generated maps (false, the default) or the 2009 ones (true); restarts at level 1
on uDead.Legacy pOn
   put (pOn is true) into sLegacy
   if sLegacy and sData is empty then uDead.LoadData
   put 1 into sLevel
   put sTicks + 1 into sNextLevelAt
end uDead.Legacy

-- legacy: read one level's block from the data file
on uDead.ReadLevel pIndex
   local tBlock, tStart, tEnd, tN, tLine, tR, tC, tI
   put line pIndex of sLevelNames into sName
   put lineOffset(cr & "LEVEL " & sName & cr, cr & sData & cr) into tStart
   put lineOffset("END", sData, tStart) into tEnd
   put line tStart to tStart + tEnd of sData into tBlock
   put 1 into tN
   repeat while tN <= the number of lines of tBlock
      put line tN of tBlock into tLine
      switch word 1 of tLine
         case "NEXT"
            put word 2 of tLine into sNext
            break
         case "HARD"
            put (word 2 of tLine is "true") into sHard
            break
         case "WIN"
            put uDead.Words(word 2 to -1 of tLine) into sWinText
            break
         case "LOSE"
            put uDead.Words(word 2 to -1 of tLine) into sLoseText
            break
         case "ARMS"
            put word 2 to 4 of tLine into sGenArms
            break
         case "GRID"
            put word 2 of tLine into sCols
            put word 3 of tLine into sRows
            repeat with tR = 0 to sRows - 1
               put line tN + 1 + tR of tBlock into tLine
               put tR * sCols into tI
               repeat with tC = 1 to sCols
                  if char tC of tLine is "0" then put true into sPass[tI + tC - 1]
               end repeat
            end repeat
            add sRows to tN
            break
         case "WALLS"
            put line tN + 1 to tN + word 2 of tLine of tBlock into sGenWalls
            add word 2 of tLine to tN
            break
         case "CAST"
            put line tN + 1 to tN + word 2 of tLine of tBlock into sGenCast
            add word 2 of tLine to tN
            break
         case "BARRIERS"
            put line tN + 1 to tN + word 2 of tLine of tBlock into sGenBars
            add word 2 of tLine to tN
            break
      end switch
      add 1 to tN
   end repeat
end uDead.ReadLevel

-------------------------------------------------------------------- generated maps

-- Level n is place (n-1) mod 5 of the owner's five, on round (n-1) div 5. A level number
-- always makes the same map (its own random seed), so a level can be learned and tested.
-- Each round adds people and guns; from round 3 the living are awake from the start.
on uDead.Generate pIndex
   local tPlace, tRound, tZ, tPeople, tPistols, tRifles, tMelee, tPolice, tSoldiers, tSnipers, tN, tSpot, tRole
   put (pIndex - 1) mod 5 + 1 into tPlace
   put (pIndex - 1) div 5 into tRound
   set the randomSeed to 20090 + pIndex * 7919
   put empty into sGenDoor
   put empty into sGenUsed
   put empty into sGenRooms
   put empty into tSnipers
   put 0 into tPolice
   put 0 into tSoldiers
   put 0 into tRifles
   switch tPlace
      case 1
         put "THE HIGHWAY HOTEL" into sName
         uDead.GenHotel
         put 3 into tZ
         put 10 into tPeople
         put 2 into tPistols
         put 3 into tMelee
         break
      case 2
         put "THE WAREHOUSE" into sName
         uDead.GenWarehouse
         put 4 into tZ
         put 13 into tPeople
         put 4 into tPistols
         put 5 into tMelee
         break
      case 3
         put "THE ALLEY" into sName
         put uDead.GenAlley() into tSnipers
         put 6 into tZ
         put 9 into tPeople
         put 5 into tPistols
         put 2 into tMelee
         put 2 into tPolice
         break
      case 4
         put "THE CONTAINER YARD" into sName
         uDead.GenYard
         put 6 into tZ
         put 14 into tPeople
         put 7 into tPistols
         put 2 into tRifles
         put 2 into tMelee
         put 2 into tPolice
         put 3 into tSoldiers
         break
      default
         put "THE ARCADE" into sName
         uDead.GenArcade
         put 7 into tZ
         put 18 into tPeople
         put 5 into tPistols
         put 6 into tMelee
         put 2 into tPolice
   end switch
   if tRound > 0 then put sName & "  ROUND " & (tRound + 1) into sName
   add tRound to tZ
   add tRound * 3 to tPeople
   add tRound * 2 to tPistols
   add tRound to tMelee
   if tPlace >= 3 then add tRound to tSoldiers
   if tSoldiers > 0 then add tRound to tRifles
   put (tRound >= 2) into sHard
   put "THE UNDEAD ARE VICTORIOUS!!  PRESS SPACE BAR TO CONTINUE." into sWinText
   put "THE UNDEAD HAVE BEEN DEFEATED!!  PRESS SPACE BAR TO RAISE THE DEAD." into sLoseText
   put tPistols && tRifles && tMelee into sGenArms
   put uDead.Outline() into sGenWalls
   -- who can be reached from where the dead start (doors and windows can be broken)
   uDead.GenFlood
   -- you and the dead, side by side at the start
   put "player|" & (item 1 of sGenStart + 0.5) * kCellM & "|" & (item 2 of sGenStart + 0.5) * kCellM & "|" & item 3 of sGenStart & "|-|you" & cr into sGenCast
   repeat with tN = 1 to tZ
      put uDead.GenSpot(0, 5) into tSpot
      put "zombie|" & item 1 of tSpot & "|" & item 2 of tSpot & "|" & item 3 of sGenStart & "|-|zombie" & cr after sGenCast
   end repeat
   -- the living: soldiers, police, then everyone else, away from the start
   repeat with tN = 1 to tPeople
      put "civilian" into tRole
      if tN <= tSoldiers then
         put "soldier" into tRole
      else if tN <= tSoldiers + tPolice then
         put "police" into tRole
      end if
      put uDead.GenSpot(22, 400) into tSpot
      put "human|" & item 1 of tSpot & "|" & item 2 of tSpot & "|" & random(360) & "|" & tRole & "|" & tRole & cr after sGenCast
   end repeat
   put sGenCast & tSnipers into sGenCast
   if the last char of sGenCast is cr then delete the last char of sGenCast
   set the randomSeed to the milliseconds
end uDead.Generate

-- an empty lot: open floor inside a solid rim (pSolid true: all solid, to be carved)
on uDead.GNew pCols, pRows, pSolid
   local tR, tC
   put pCols into sCols
   put pRows into sRows
   put empty into sPass
   if pSolid is true then exit uDead.GNew
   repeat with tR = 1 to sRows - 2
      repeat with tC = 1 to sCols - 2
         put true into sPass[tR * sCols + tC]
      end repeat
   end repeat
end uDead.GNew

-- make cells c1,r1 to c2,r2 solid (pOpen true: open floor); the rim always stays solid
on uDead.GBlock pC1, pR1, pC2, pR2, pOpen
   local tR, tC
   repeat with tR = max(1, pR1) to min(sRows - 2, pR2)
      repeat with tC = max(1, pC1) to min(sCols - 2, pC2)
         if pOpen is true then
            put true into sPass[tR * sCols + tC]
         else
            delete variable sPass[tR * sCols + tC]
         end if
      end repeat
   end repeat
end uDead.GBlock

-- a room: walls on the edge cells of the rectangle, floor inside
on uDead.GRoom pC1, pR1, pC2, pR2
   uDead.GBlock pC1, pR1, pC2, pR2, false
   uDead.GBlock pC1 + 1, pR1 + 1, pC2 - 1, pR2 - 1, true
   if (pC2 - pC1) * (pR2 - pR1) < 400 then put (pC1 + 1) & comma & (pR1 + 1) & comma & (pC2 - 1) & comma & (pR2 - 1) & cr after sGenRooms
end uDead.GRoom

-- a door or window: pLen cells from pC,pR along the row (pAlong true) or down the column
-- are opened in the wall and closed again by something the dead can break
on uDead.GDoor pC, pR, pLen, pAlong, pKind
   local tK, tC, tR, tCells
   repeat with tK = 0 to pLen - 1
      put pC into tC
      put pR into tR
      if pAlong then
         add tK to tC
      else
         add tK to tR
      end if
      put true into sPass[tR * sCols + tC]
      put true into sGenDoor[tR * sCols + tC]
      put tC & comma & tR & space after tCells
   end repeat
   put pKind & "|" & pKind & "|" & word 1 to -1 of tCells & cr after sGenBars
end uDead.GDoor

-- the outline between wall and floor as straight runs c1,r1,c2,r2 in cell corners
function uDead.Outline
   local tR, tC, tC0, tR0, tOut, tA, tB
   repeat with tR = 1 to sRows - 1
      put 0 into tC
      repeat while tC < sCols
         put (sPass[(tR - 1) * sCols + tC] is true) into tA
         put (sPass[tR * sCols + tC] is true) into tB
         if tA is not tB then
            put tC into tC0
            repeat while tC < sCols
               if (sPass[(tR - 1) * sCols + tC] is true) is (sPass[tR * sCols + tC] is true) then exit repeat
               add 1 to tC
            end repeat
            put tC0 & comma & tR & comma & tC & comma & tR & cr after tOut
         else
            add 1 to tC
         end if
      end repeat
   end repeat
   repeat with tC = 1 to sCols - 1
      put 0 into tR
      repeat while tR < sRows
         put (sPass[tR * sCols + tC - 1] is true) into tA
         put (sPass[tR * sCols + tC] is true) into tB
         if tA is not tB then
            put tR into tR0
            repeat while tR < sRows
               if (sPass[tR * sCols + tC - 1] is true) is (sPass[tR * sCols + tC] is true) then exit repeat
               add 1 to tR
            end repeat
            put tC & comma & tR0 & comma & tC & comma & tR & cr after tOut
         else
            add 1 to tR
         end if
      end repeat
   end repeat
   delete the last char of tOut
   return tOut
end uDead.Outline

-- every cell the dead can walk to from their start: sGenReach[cell] = steps
on uDead.GenFlood
   local tQ, tHead, tTail, tI, tN
   put empty into sGenReach
   put item 2 of sGenStart * sCols + item 1 of sGenStart into tI
   put 0 into sGenReach[tI]
   put tI into tQ[1]
   put 1 into tHead
   put 1 into tTail
   repeat while tHead <= tTail
      put tQ[tHead] into tI
      add 1 to tHead
      repeat for each item tN in (tI - 1) & comma & (tI + 1) & comma & (tI - sCols) & comma & (tI + sCols)
         if sGenReach[tN] is empty and sPass[tN] is true then
            put sGenReach[tI] + 1 into sGenReach[tN]
            add 1 to tTail
            put tN into tQ[tTail]
         end if
      end repeat
   end repeat
end uDead.GenFlood

-- a free place to stand, "x,z" in metres: reachable, not in a doorway, nobody on it or
-- next to it, and between pMin and pMax steps from the start
function uDead.GenSpot pMin, pMax
   local tTry, tC, tR, tI, tLow, tRoom
   put pMin into tLow
   repeat with tTry = 1 to 900
      if tTry mod 300 = 0 then put tLow div 2 into tLow       -- crowded: come closer
      put random(sCols - 2) into tC
      put random(sRows - 2) into tR
      if pMax >= 50 and sGenRooms is not empty and random(10) <= 6 then
         -- most of the living are indoors
         put line random(the number of lines of sGenRooms) of sGenRooms into tRoom
         put item 1 of tRoom + random(item 3 of tRoom - item 1 of tRoom + 1) - 1 into tC
         put item 2 of tRoom + random(item 4 of tRoom - item 2 of tRoom + 1) - 1 into tR
      end if
      if pMax < 50 then
         -- near the start: pick around it
         put item 1 of sGenStart + random(2 * pMax + 1) - pMax - 1 into tC
         put item 2 of sGenStart + random(2 * pMax + 1) - pMax - 1 into tR
      end if
      put tR * sCols + tC into tI
      if sGenReach[tI] is empty then next repeat
      if sGenReach[tI] < tLow or sGenReach[tI] > pMax then next repeat
      if sGenDoor[tI] is true or sGenUsed[tI] is true then next repeat
      if sGenUsed[tI - 1] is true or sGenUsed[tI + 1] is true then next repeat
      put true into sGenUsed[tI]
      return (tC + 0.5) * kCellM & comma & (tR + 0.5) * kCellM
   end repeat
   return (item 1 of sGenStart + 0.5) * kCellM & comma & (item 2 of sGenStart + 0.5) * kCellM
end uDead.GenSpot

-- 1. the semi-industrial highway hotel: a row of rooms, each with a door and a window,
-- the office, trucks on the lot. The dead come up from the highway.
on uDead.GenHotel
   local tN, tC, tR
   -- bigger than 2009's (the owner, 11 13 2026): rooms 7 m wide, doors 1.5 m,
   -- front windows twice the door and about 80% of the wall high
   uDead.GNew 128, 84
   repeat with tN = 0 to 7
      put 4 + tN * 15 into tC
      uDead.GRoom tC, 3, tC + 14, 18
      uDead.GDoor tC + 2, 18, 3, true, "door"
      uDead.GDoor tC + 7, 18, 6, true, "window"
   end repeat
   -- the office
   uDead.GRoom 94, 46, 120, 66
   uDead.GDoor 94, 55, 3, false, "door"
   uDead.GDoor 103, 46, 6, true, "window"
   uDead.GBlock 106, 56, 114, 57
   -- trucks and cars on the lot
   repeat with tN = 1 to 6
      put 8 + random(76) into tC
      put 24 + random(16) into tR
      if random(2) = 1 then
         uDead.GBlock tC, tR, tC + 3, tR + 8
      else
         uDead.GBlock tC, tR, tC + 7, tR + 3
      end if
   end repeat
   put "10,77,0" into sGenStart
   uDead.GBlock 6, 73, 16, 81, true
end uDead.GenHotel

-- 2. the warehouse: one big hall of shelving and crates, three offices down one side
on uDead.GenWarehouse
   local tC, tN, tR
   uDead.GNew 90, 72
   uDead.GRoom 10, 8, 80, 52
   repeat with tC = 16 to 58 step 7
      if random(6) > 1 then uDead.GBlock tC, 13, tC + 1, 26
      if random(6) > 1 then uDead.GBlock tC, 32, tC + 1, 47
   end repeat
   repeat with tN = 1 to 9
      put 13 + random(48) into tC
      put 10 + random(38) into tR
      uDead.GBlock tC, tR, tC + 1, tR + 1
   end repeat
   -- offices
   uDead.GRoom 66, 8, 80, 22
   uDead.GDoor 66, 14, 2, false, "door"
   uDead.GRoom 66, 22, 80, 37
   uDead.GDoor 66, 29, 2, false, "door"
   uDead.GRoom 66, 37, 80, 52
   uDead.GDoor 66, 44, 2, false, "door"
   -- the loading doors, a side door, a window
   uDead.GDoor 30, 52, 4, true, "door"
   uDead.GDoor 54, 52, 4, true, "door"
   uDead.GDoor 10, 30, 2, false, "door"
   uDead.GDoor 40, 8, 3, true, "window"
   uDead.GBlock 28, 48, 36, 51, true
   uDead.GBlock 52, 48, 60, 51, true
   put "44,62,180" into sGenStart
end uDead.GenWarehouse

-- 3. the alley behind the warehouse to the big office building: a long narrow run
-- between solid blocks, dumpsters to weave around, snipers behind windows on both sides,
-- the office at the far end. Returns the snipers' cast lines.
function uDead.GenAlley
   local tR, tSide, tSnipers, tN
   uDead.GNew 48, 124, true
   uDead.GBlock 8, 108, 40, 120, true          -- the yard you start in
   uDead.GBlock 20, 32, 27, 108, true          -- the alley
   put 0 into tSide
   repeat with tR = 96 to 40 step -14
      if tSide = 0 then
         uDead.GBlock 10, tR, 18, tR + 7, true
         uDead.GDoor 19, tR + 2, 3, false, "window"
         put "human|" & 13.5 * kCellM & "|" & (tR + 3.5) * kCellM & "|90|sniper|sniper" & cr after tSnipers
         uDead.GBlock 25, tR + 9, 27, tR + 11    -- a dumpster on the other side
      else
         uDead.GBlock 29, tR, 37, tR + 7, true
         uDead.GDoor 28, tR + 2, 3, false, "window"
         put "human|" & 34.5 * kCellM & "|" & (tR + 3.5) * kCellM & "|270|sniper|sniper" & cr after tSnipers
         uDead.GBlock 20, tR + 9, 22, tR + 11
      end if
      put 1 - tSide into tSide
   end repeat
   -- the office building
   uDead.GBlock 6, 4, 42, 30, true
   uDead.GBlock 20, 31, 27, 31, false
   uDead.GDoor 22, 31, 4, true, "door"
   uDead.GRoom 5, 3, 18, 14
   uDead.GDoor 11, 14, 2, true, "door"
   uDead.GRoom 30, 3, 43, 14
   uDead.GDoor 35, 14, 2, true, "door"
   uDead.GRoom 5, 18, 14, 31
   uDead.GDoor 14, 23, 2, false, "door"
   repeat with tN = 1 to 4
      uDead.GBlock 18 + tN * 4, 20, 19 + tN * 4, 22
   end repeat
   put "24,114,180" into sGenStart
   return tSnipers
end uDead.GenAlley

-- 4. the cargo container shipyard: open ground, containers in loose rows with lanes
-- between them, a guard hut. Soldiers work here.
on uDead.GenYard
   local tR, tC, tDC, tDR
   uDead.GNew 110, 84
   repeat with tR = 8 to 56 step 12
      repeat with tC = 10 to 78 step 17
         if random(10) <= 2 then next repeat
         put random(3) - 1 into tDC
         put random(3) - 1 into tDR
         if random(4) = 1 then
            uDead.GBlock tC + tDC, tR + tDR, tC + tDC + 4, tR + tDR + 8
         else
            uDead.GBlock tC + tDC, tR + tDR, tC + tDC + 11, tR + tDR + 4
            if random(3) = 1 then uDead.GBlock tC + tDC, tR + tDR + 5, tC + tDC + 11, tR + tDR + 6
         end if
      end repeat
   end repeat
   uDead.GRoom 94, 4, 106, 14
   uDead.GDoor 94, 8, 2, false, "door"
   uDead.GDoor 99, 14, 3, true, "window"
   uDead.GBlock 2, 70, 14, 81, true
   put "7,76,45" into sGenStart
end uDead.GenYard

-- 5. the video game arcade: a hall of cabinets in rows, a counter, three back rooms
on uDead.GenArcade
   local tR, tC
   uDead.GNew 80, 66
   uDead.GRoom 6, 6, 74, 50
   repeat with tR = 12 to 33 step 7
      repeat with tC = 11 to 56 step 5
         if random(7) > 1 then uDead.GBlock tC, tR, tC + 1, tR + 1
      end repeat
   end repeat
   uDead.GBlock 10, 44, 26, 45
   uDead.GRoom 62, 6, 74, 20
   uDead.GDoor 62, 12, 2, false, "door"
   uDead.GRoom 62, 20, 74, 35
   uDead.GDoor 62, 27, 2, false, "door"
   uDead.GRoom 62, 35, 74, 50
   uDead.GDoor 62, 42, 2, false, "door"
   uDead.GDoor 38, 50, 4, true, "door"
   uDead.GDoor 20, 50, 3, true, "window"
   uDead.GDoor 52, 50, 3, true, "window"
   uDead.GBlock 34, 46, 46, 49, true
   put "40,58,180" into sGenStart
end uDead.GenArcade

-------------------------------------------------------------------- building the level

function uDead.Vertex @pMesh, @pIndex, pX, pY, pZ
   local tKey
   put pX & "," & pY & "," & pZ into tKey
   if pIndex[tKey] is empty then
      Mesh.AddVertex pMesh, pX, pY, pZ
      put the result into pIndex[tKey]
   end if
   return pIndex[tKey]
end uDead.Vertex

-- a line between two points given in metres (up is positive here; the engine's Y is down)
on uDead.Line @pMesh, @pIndex, pX1, pY1, pZ1, pX2, pY2, pZ2
   local tA, tB
   put uDead.Vertex(pMesh, pIndex, pX1 * kM, -pY1 * kM, pZ1 * kM) into tA
   put uDead.Vertex(pMesh, pIndex, pX2 * kM, -pY2 * kM, pZ2 * kM) into tB
   Mesh.AddLine pMesh, tA, tB
end uDead.Line

-- the wall outline, cut into chunks so only the near ones are drawn.
-- pWalls: lines of c1,r1,c2,r2 in cell corners; each run is straight along a row or a column.
on uDead.BuildWalls pWalls
   local tSeg, tC1, tR1, tC2, tR2, tA, tB, tEnd, tCX, tCZ, tName, tMesh, tIdx, tOX, tOZ
   local tX1, tZ1, tX2, tZ2, tAlong
   put empty into sChunkList
   put empty into sChunkAt
   repeat for each line tSeg in pWalls
      put item 1 of tSeg into tC1
      put item 2 of tSeg into tR1
      put item 3 of tSeg into tC2
      put item 4 of tSeg into tR2
      put (tR1 = tR2) into tAlong               -- true: runs along a row (x changes)
      if tAlong then
         put tC1 into tA
         put tC2 into tEnd
      else
         put tR1 into tA
         put tR2 into tEnd
      end if
      repeat while tA < tEnd
         put min(tEnd, (tA div kChunk + 1) * kChunk) into tB
         if tAlong then
            put tA div kChunk into tCX
            put min(tR1, sRows - 1) div kChunk into tCZ
         else
            put min(tC1, sCols - 1) div kChunk into tCX
            put tA div kChunk into tCZ
         end if
         put "uDead.W" & tCX & "x" & tCZ into tName
         if tMesh[tName] is not an array then
            put Mesh.New() into tMesh[tName]
            put tName & cr after sChunkList
            put ((tCX + 0.5) * kChunk * kCellM) & comma & ((tCZ + 0.5) * kChunk * kCellM) into sChunkAt[tName]
         end if
         put item 1 of sChunkAt[tName] into tOX
         put item 2 of sChunkAt[tName] into tOZ
         if tAlong then
            put tA * kCellM - tOX into tX1
            put tB * kCellM - tOX into tX2
            put tR1 * kCellM - tOZ into tZ1
            put tZ1 into tZ2
         else
            put tC1 * kCellM - tOX into tX1
            put tX1 into tX2
            put tA * kCellM - tOZ into tZ1
            put tB * kCellM - tOZ into tZ2
         end if
         uDead.Line tMesh[tName], tIdx[tName], tX1, 0, tZ1, tX2, 0, tZ2
         uDead.Line tMesh[tName], tIdx[tName], tX1, kWallH, tZ1, tX2, kWallH, tZ2
         -- uprights at the true ends of the run only
         if tA is tC1 and tAlong or tA is tR1 and not tAlong then
            uDead.Line tMesh[tName], tIdx[tName], tX1, 0, tZ1, tX1, kWallH, tZ1
         end if
         if tB is tEnd then
            uDead.Line tMesh[tName], tIdx[tName], tX2, 0, tZ2, tX2, kWallH, tZ2
         end if
         put tB into tA
      end repeat
   end repeat
   delete the last char of sChunkList
   repeat for each line tName in sChunkList
      Mesh.Define tName, tMesh[tName]
   end repeat
end uDead.BuildWalls

-- show the wall chunks near you, drop the far ones
on uDead.ShowChunks
   local tName, tDX, tDZ, tNear
   repeat for each line tName in sChunkList
      put item 1 of sChunkAt[tName] - sPX into tDX
      put item 2 of sChunkAt[tName] - sPZ into tDZ
      put (tDX * tDX + tDZ * tDZ < kSeeChunks * kSeeChunks) into tNear
      if tNear and sChunkKey[tName] is empty then
         put Entity.Spawn(tName, item 1 of sChunkAt[tName] * kM, 0, item 2 of sChunkAt[tName] * kM, "#3F6FB0") into sChunkKey[tName]
      else if not tNear and sChunkKey[tName] is not empty then
         Entity.Kill sChunkKey[tName]
         put empty into sChunkKey[tName]
      end if
   end repeat
end uDead.ShowChunks

-- doors and windows: each closes a gap of cells until the dead break it
on uDead.BuildBarriers pBars
   local tLine, tCell, tI, tN, tSumC, tSumR, tAlong, tFirst, tLast
   set the itemDel to "|"
   repeat for each line tLine in pBars
      add 1 to sDoorCount
      put item 1 of tLine into sDoor[sDoorCount]["kind"]
      if item 1 of tLine is "window" then
         put 10 into sDoor[sDoorCount]["hp"]
      else
         put 60 into sDoor[sDoorCount]["hp"]
      end if
      put item 3 of tLine into sDoor[sDoorCount]["cells"]
   end repeat
   set the itemDel to comma
   repeat with tN = 1 to sDoorCount
      put 0 into tSumC
      put 0 into tSumR
      put word 1 of sDoor[tN]["cells"] into tFirst
      put word -1 of sDoor[tN]["cells"] into tLast
      repeat for each word tCell in sDoor[tN]["cells"]
         put item 2 of tCell * sCols + item 1 of tCell into tI
         put tN into sDoorAt[tI]
         add item 1 of tCell to tSumC
         add item 2 of tCell to tSumR
      end repeat
      put the number of words of sDoor[tN]["cells"] into tI
      put (tSumC / tI + 0.5) * kCellM into sDoor[tN]["x"]
      put (tSumR / tI + 0.5) * kCellM into sDoor[tN]["z"]
      put (item 2 of tFirst is item 2 of tLast) into tAlong
      Mesh.Define "uDead.D" & tN, uDead.DoorMesh((tI * kCellM) / 2, tAlong, sDoor[tN]["kind"])
      if sDoor[tN]["kind"] is "window" then
         put Entity.Spawn("uDead.D" & tN, sDoor[tN]["x"] * kM, 0, sDoor[tN]["z"] * kM, "#9FE8FF") into sDoor[tN]["key"]
      else
         put Entity.Spawn("uDead.D" & tN, sDoor[tN]["x"] * kM, 0, sDoor[tN]["z"] * kM, "#C08A3A") into sDoor[tN]["key"]
      end if
   end repeat
end uDead.BuildBarriers

function uDead.DoorMesh pHalf, pAlong, pKind
   local tM, tIdx, tX, tZ, tLow
   put Mesh.New() into tM
   if pAlong then
      put pHalf into tX
      put 0 into tZ
   else
      put 0 into tX
      put pHalf into tZ
   end if
   put 0 into tLow
   if pKind is "window" then put 0.4 into tLow
   uDead.Line tM, tIdx, -tX, tLow, -tZ, tX, tLow, tZ
   uDead.Line tM, tIdx, -tX, 1.9, -tZ, tX, 1.9, tZ
   uDead.Line tM, tIdx, -tX, tLow, -tZ, -tX, 1.9, -tZ
   uDead.Line tM, tIdx, tX, tLow, tZ, tX, 1.9, tZ
   uDead.Line tM, tIdx, -tX, tLow, -tZ, tX, 1.9, tZ
   if pKind is "window" then uDead.Line tM, tIdx, -tX, 1.9, -tZ, tX, tLow, tZ
   return tM
end uDead.DoorMesh

-- the figures: a standing person in two walking frames, the dead with arms out, and a body
on uDead.MakeMeshes
   Mesh.Define "uDead.H1", uDead.Figure(0.18, false, false)
   Mesh.Define "uDead.H2", uDead.Figure(-0.18, false, false)
   Mesh.Define "uDead.G1", uDead.Figure(0.18, false, true)
   Mesh.Define "uDead.G2", uDead.Figure(-0.18, false, true)
   Mesh.Define "uDead.Z1", uDead.Figure(0.14, true, false)
   Mesh.Define "uDead.Z2", uDead.Figure(-0.14, true, false)
   Mesh.Define "uDead.Body", uDead.BodyMesh()
   Mesh.Define "uDead.Nade", Mesh.Box(5, 5, 5)
   -- show, don't tell: rings on the ground (shots, noise) in six sizes, and a blood mark
   local tR
   repeat with tR = 1 to 6
      Mesh.Define "uDead.Ring" & tR, uDead.RingMesh(tR * 0.6)
   end repeat
   Mesh.Define "uDead.Blood", uDead.BloodMesh()
end uDead.MakeMeshes

function uDead.RingMesh pR
   local tM, tIdx, n, a1, a2
   put Mesh.New() into tM
   repeat with n = 0 to 15
      put n * 2 * pi / 16 into a1
      put (n + 1) * 2 * pi / 16 into a2
      uDead.Line tM, tIdx, pR * sin(a1), 0.03, pR * cos(a1), pR * sin(a2), 0.03, pR * cos(a2)
   end repeat
   return tM
end uDead.RingMesh

function uDead.BloodMesh
   local tM, tIdx
   put Mesh.New() into tM
   uDead.Line tM, tIdx, -0.12, 0.02, -0.05, 0.12, 0.02, 0.05
   uDead.Line tM, tIdx, -0.04, 0.02, 0.1, 0.05, 0.02, -0.1
   return tM
end uDead.BloodMesh

-------------------------------------------------------------------- ammo (the owner, 11 13 2026)

on uDead.PlaceCrates
   local n, tSpot
   put empty into sAmmo
   put 0 into sAmmoN
   if sLegacy is true then exit uDead.PlaceCrates      -- the 2009 maps: no crates
   Mesh.Define "uDead.Crate", Mesh.Box(0.6 * kM, 0.45 * kM, 0.4 * kM)
   repeat with n = 1 to kCrates
      put uDead.GenSpot(12, 400) into tSpot
      if tSpot is empty then next repeat
      add 1 to sAmmoN
      put item 1 of tSpot into sAmmo[sAmmoN]["x"]
      put item 2 of tSpot into sAmmo[sAmmoN]["z"]
      put kCrateRefills into sAmmo[sAmmoN]["left"]
      put Entity.Spawn("uDead.Crate", sAmmo[sAmmoN]["x"] * kM, -0.23 * kM, sAmmo[sAmmoN]["z"] * kM, "#E0C040") into sAmmo[sAmmoN]["key"]
   end repeat
end uDead.PlaceCrates

-- out of ammo: walk to the nearest crate; nothing left anywhere = drop the gun
on uDead.FetchAmmo pId, pDT
   local tC, tHow, tMoved
   put false into tMoved
   repeat for each key tC in sAmmo
      if sAmmo[tC]["left"] <= 0 then next repeat
      if sqrt((sAmmo[tC]["x"] - sE[pId]["x"]) ^ 2 + (sAmmo[tC]["z"] - sE[pId]["z"]) ^ 2) < 0.9 then
         subtract 1 from sAmmo[tC]["left"]
         put kMags into sE[pId]["mags"]
         put 0 into sE[pId]["shots"]
         put false into sE[pId]["noAmmo"]
         put sNow + 0.5 into sE[pId]["next"]
         uDead.Ring sAmmo[tC]["x"], sAmmo[tC]["z"], "#FFE040", 0.8
         if sAmmo[tC]["left"] <= 0 then
            Entity.Kill sAmmo[tC]["key"]
            put Entity.Spawn("uDead.Crate", sAmmo[tC]["x"] * kM, -0.23 * kM, sAmmo[tC]["z"] * kM, "#4A4A4A") into sAmmo[tC]["key"]
            put 0 into sJob["A"]["at"]
         end if
         uDead.Place pId, false
         exit uDead.FetchAmmo
      end if
   end repeat
   if sField["A"] is not an array then
      -- no crates (yet): the gun is useless now
      if sJob["A"]["at"] > sTicks * sStepMS / 1000 + 1000 or sAmmoN = 0 then
         put empty into sE[pId]["gun"]
         put false into sE[pId]["noAmmo"]
         uDead.Dress pId
      end if
      exit uDead.FetchAmmo
   end if
   put uDead.FieldStep(pId, "A", kSeekSpeed + 0.5, pDT, true, false) into tHow
   if tHow is empty then
      -- no way to a crate from here
      put empty into sE[pId]["gun"]
      put false into sE[pId]["noAmmo"]
      uDead.Dress pId
      exit uDead.FetchAmmo
   end if
   uDead.Place pId, (tHow is "moved")
end uDead.FetchAmmo

-------------------------------------------------------------------- effects (the owner, 11 13 2026: show, don't tell)

-- a ring that spreads across the ground: pColor, from where, over pSeconds
on uDead.Ring pX, pZ, pColor, pSeconds
   add 1 to sFxN
   put Entity.Spawn("uDead.Ring1", pX * kM, 0, pZ * kM, pColor) into sFx[sFxN]["key"]
   put sNow into sFx[sFxN]["born"]
   put pSeconds into sFx[sFxN]["life"]
end uDead.Ring

on uDead.FxStep
   local tK, tAge
   repeat for each key tK in sFx
      put (sNow - sFx[tK]["born"]) / sFx[tK]["life"] into tAge
      if tAge >= 1 or tAge < 0 then
         Entity.Kill sFx[tK]["key"]
         delete variable sFx[tK]
      else
         uDead.SetMesh sFx[tK]["key"], "uDead.Ring" & (trunc(tAge * 6) + 1)
      end if
   end repeat
end uDead.FxStep

-- the injured leave a trail
on uDead.Bleed pId
   local tKey
   if sE[pId]["hurt"] is not true or sE[pId]["state"] is not "alive" then exit uDead.Bleed
   if sNow < sE[pId]["bleedAt"] then exit uDead.Bleed
   put sNow + 0.45 into sE[pId]["bleedAt"]
   put Entity.Spawn("uDead.Blood", sE[pId]["x"] * kM, 0, sE[pId]["z"] * kM, "#B01010") into tKey
   Entity.SetRotation tKey, 0, random(314) / 100, 0
   put tKey & cr after sBlood
   if the number of lines of sBlood > kBloodMax then
      Entity.Kill line 1 of sBlood
      delete line 1 of sBlood
   end if
end uDead.Bleed

-- the targeted living strobe dark red to blood red; crowds of the dead make noise
on uDead.Signals
   local tId, tT, tTargets, tNear, tN, tOther, tCX, tCZ, tDone
   if sNow >= sStrobeAt then
      put sNow + 0.5 into sStrobeAt
      put not sStrobeOn into sStrobeOn
      repeat for each line tId in sZ
         if sE[tId]["state"] is not "alive" then next repeat
         if sE[tId]["order"] is "attack" then put true into tTargets[sE[tId]["target"]]
         if sE[tId]["beh"] is "RUSH" then
            put uDead.Nearest(tId, sH) into tNear
            if tNear is not empty and item 2 of tNear < 8 then put true into tTargets[item 1 of tNear]
         end if
      end repeat
      repeat for each line tId in sH
         if sE[tId]["state"] is not "alive" then next repeat
         if tTargets[tId] then
            put "#5A0000" into sE[tId]["tint"]
            if sStrobeOn then put "#E01818" into sE[tId]["tint"]
            uDead.Dress tId
         else if sE[tId]["tint"] is not empty then
            put empty into sE[tId]["tint"]
            uDead.Dress tId
         end if
      end repeat
   end if
   if sNow >= sNoiseAt then
      put sNow + 1.2 into sNoiseAt
      repeat for each line tId in sZ
         if sE[tId]["state"] is not "alive" or tDone[tId] then next repeat
         put 0 into tN
         put 0 into tCX
         put 0 into tCZ
         repeat for each line tOther in sZ
            if sE[tOther]["state"] is not "alive" then next repeat
            if uDead.Dist(tId, tOther) <= kNoiseNear then
               add 1 to tN
               add sE[tOther]["x"] to tCX
               add sE[tOther]["z"] to tCZ
               put true into tDone[tOther]
            end if
         end repeat
         if tN >= kNoiseCrowd then
            put tCX / tN into tCX
            put tCZ / tN into tCZ
            uDead.Ring tCX, tCZ, "#FFFFFF", 1.0
            repeat for each line tOther in sH
               if sqrt((sE[tOther]["x"] - tCX) ^ 2 + (sE[tOther]["z"] - tCZ) ^ 2) <= kNoiseHeard then put true into sE[tOther]["awake"]
            end repeat
         end if
      end repeat
   end if
end uDead.Signals

-- pStride: how far the left foot is forward (metres); the figure faces +Z
function uDead.Figure pStride, pDead, pGun
   local tM, tIdx
   put Mesh.New() into tM
   -- legs
   uDead.Line tM, tIdx, -0.1, 0.9, 0, -0.12, 0, pStride
   uDead.Line tM, tIdx, 0.1, 0.9, 0, 0.12, 0, -pStride
   -- spine, shoulders, hips
   uDead.Line tM, tIdx, 0, 0.9, 0, 0, 1.5, 0
   uDead.Line tM, tIdx, -0.22, 1.45, 0, 0.22, 1.45, 0
   uDead.Line tM, tIdx, -0.1, 0.9, 0, 0.1, 0.9, 0
   -- head: a diamond, so the facing reads from every side
   uDead.Line tM, tIdx, 0, 1.55, 0, -0.1, 1.68, 0
   uDead.Line tM, tIdx, -0.1, 1.68, 0, 0, 1.82, 0
   uDead.Line tM, tIdx, 0, 1.82, 0, 0.1, 1.68, 0
   uDead.Line tM, tIdx, 0.1, 1.68, 0, 0, 1.55, 0
   uDead.Line tM, tIdx, 0, 1.68, 0, 0, 1.68, 0.12
   if pDead then
      -- both arms straight out
      uDead.Line tM, tIdx, -0.22, 1.45, 0, -0.2, 1.4, 0.55
      uDead.Line tM, tIdx, 0.22, 1.45, 0, 0.2, 1.3, 0.5
   else if pGun then
      uDead.Line tM, tIdx, -0.22, 1.45, 0, -0.05, 1.35, 0.4
      uDead.Line tM, tIdx, 0.22, 1.45, 0, 0.05, 1.35, 0.4
      uDead.Line tM, tIdx, 0, 1.35, 0.4, 0, 1.38, 0.75
   else
      uDead.Line tM, tIdx, -0.22, 1.45, 0, -0.28, 0.95, -pStride / 2
      uDead.Line tM, tIdx, 0.22, 1.45, 0, 0.28, 0.95, pStride / 2
   end if
   return tM
end uDead.Figure

function uDead.BodyMesh
   local tM, tIdx
   put Mesh.New() into tM
   uDead.Line tM, tIdx, 0, 0.06, -0.9, 0, 0.06, 0.4
   uDead.Line tM, tIdx, -0.3, 0.06, 0.25, 0.3, 0.06, 0.3
   uDead.Line tM, tIdx, 0, 0.06, -0.9, -0.25, 0.06, -0.2
   uDead.Line tM, tIdx, 0, 0.06, -0.9, 0.2, 0.06, -0.1
   uDead.Line tM, tIdx, 0, 0.06, 0.4, -0.1, 0.06, 0.62
   uDead.Line tM, tIdx, -0.1, 0.06, 0.62, 0.1, 0.06, 0.62
   uDead.Line tM, tIdx, 0.1, 0.06, 0.62, 0, 0.06, 0.4
   return tM
end uDead.BodyMesh

-- the cast: kind|x|z|facing|role|model, then the level's weapons are handed out as the
-- original did: soldiers first, then police, then anyone; pipes and batons to the rest
on uDead.BuildCast pCast, pArms
   local tLine, tId, tGuns, tRifles, tMelee, tOrder, tLeft, tTries, tPick
   set the itemDel to "|"
   repeat for each line tLine in pCast
      if item 1 of tLine is "player" then
         put item 2 of tLine into sPX
         put item 3 of tLine into sPZ
         Camera.SetLook item 4 of tLine * pi / 180, 0
         next repeat
      end if
      add 1 to sNextId
      put sNextId into tId
      put tId & cr after sIds
      put item 2 of tLine into sE[tId]["x"]
      put item 3 of tLine into sE[tId]["z"]
      put item 4 of tLine * pi / 180 into sE[tId]["yaw"]
      put "alive" into sE[tId]["state"]
      put 0 into sE[tId]["busy"]
      put 0 into sE[tId]["next"]
      put 0 into sE[tId]["penalty"]
      put 1 into sE[tId]["frame"]
      if item 1 of tLine is "zombie" then
         put "z" into sE[tId]["kind"]
         put 499 + random(501) into sE[tId]["hp"]
         put 2 into sE[tId]["lives"]
         put "HOLD" into sE[tId]["beh"]
      else
         put "h" into sE[tId]["kind"]
         put 1 into sE[tId]["hp"]
         put item 5 of tLine into sE[tId]["role"]
         put sHard into sE[tId]["awake"]
         put 0 into sE[tId]["nades"]
         if item 5 of tLine is "sniper" then
            put "sniper" into sE[tId]["gun"]
            put 999 into sE[tId]["shots"]
         end if
      end if
   end repeat
   delete the last char of sIds
   set the itemDel to comma
   uDead.Lists
   -- guns
   put word 1 of pArms + word 2 of pArms into tGuns
   put word 2 of pArms into tRifles
   put word 3 of pArms into tMelee
   put empty into tOrder
   repeat for each item tPick in "soldier,police"
      repeat for each line tId in sH
         if sE[tId]["role"] is tPick then put tId & cr after tOrder
      end repeat
   end repeat
   put the number of lines of sH into tLeft
   put 0 into tTries
   repeat while the number of lines of tOrder < tLeft and tTries < 400
      add 1 to tTries
      put line random(tLeft) of sH into tId
      if sE[tId]["gun"] is empty and tId is not among the lines of tOrder then put tId & cr after tOrder
   end repeat
   repeat for each line tId in tOrder
      if tGuns <= 0 then exit repeat
      if sE[tId]["gun"] is not empty then next repeat
      subtract 1 from tGuns
      if tRifles > 0 and sE[tId]["role"] is "soldier" then
         subtract 1 from tRifles
         put "rifle" into sE[tId]["gun"]
         put 32 into sE[tId]["shots"]
         put kMags into sE[tId]["mags"]
      else
         put "pistol" into sE[tId]["gun"]
         put 8 into sE[tId]["shots"]
         put kMags into sE[tId]["mags"]
      end if
      if sE[tId]["role"] is "soldier" then put 2 into sE[tId]["nades"]
   end repeat
   repeat for each line tId in sH
      if tMelee <= 0 then exit repeat
      if sE[tId]["gun"] is empty then
         subtract 1 from tMelee
         put true into sE[tId]["melee"]
      end if
   end repeat
   repeat for each line tId in sIds
      uDead.Dress tId
   end repeat
end uDead.BuildCast

-- (re)make the figure of one of the cast for what it is now
on uDead.Dress pId
   local tMesh, tColor, tE
   if sE[pId]["key"] is not empty then Entity.Kill sE[pId]["key"]
   put empty into sE[pId]["key"]
   switch sE[pId]["state"]
      case "alive"
         if sE[pId]["kind"] is "z" then
            put "uDead.Z1" into tMesh
            put "#58E04A" into tColor
         else
            put "uDead.H1" into tMesh
            put "#F2F2F2" into tColor
            if sE[pId]["melee"] is true then put "#FFD040" into tColor
            if sE[pId]["gun"] is not empty then
               put "uDead.G1" into tMesh
               put "#FF9040" into tColor
               if sE[pId]["role"] is "police" then put "#5A9CFF" into tColor
               if sE[pId]["role"] is "soldier" then put "#D8C060" into tColor
               if sE[pId]["gun"] is "sniper" then put "#FF60D0" into tColor
            end if
         end if
         break
      case "down"
         put "uDead.Body" into tMesh
         put "#2F7A28" into tColor
         break
      case "corpse"
         put "uDead.Body" into tMesh
         put "#C03030" into tColor
         break
      default
         put "uDead.Body" into tMesh
         put "#4A4A4A" into tColor
   end switch
   if sE[pId]["tint"] is not empty and sE[pId]["state"] is "alive" then put sE[pId]["tint"] into tColor
   put tMesh into sE[pId]["mesh"]
   put Entity.Spawn(tMesh, sE[pId]["x"] * kM, 0, sE[pId]["z"] * kM, tColor) into sE[pId]["key"]
   put uDead.Euler(sE[pId]["yaw"]) into tE
   Entity.SetRotation sE[pId]["key"], item 1 of tE, item 2 of tE, item 3 of tE
end uDead.Dress

function uDead.Euler pYaw
   local sy, cy
   put sin(pYaw) into sy
   put cos(pYaw) into cy
   return atan2(0, cy) & comma & asin(max(-1, min(1, sy))) & comma & atan2(0, cy)
end uDead.Euler

on uDead.SetMesh pKey, pMesh
   local tRadius
   if Entity.Get(pKey, "mesh") is pMesh then exit uDead.SetMesh
   -- Entity.SetMesh takes the new mesh's radius; this game keeps the old one
   put Entity.Get(pKey, "radius") into tRadius
   Entity.SetMesh pKey, pMesh
   if tRadius is a number then Entity.Set pKey, "radius", tRadius
end uDead.SetMesh

-- put a figure where its record says, walking frame and all
on uDead.Place pId, pMoved
   local tE, tBase
   if pMoved and sE[pId]["kind"] is "z" then uDead.Bleed pId
   Entity.SetPosition sE[pId]["key"], sE[pId]["x"] * kM, 0, sE[pId]["z"] * kM
   put uDead.Euler(sE[pId]["yaw"]) into tE
   Entity.SetRotation sE[pId]["key"], item 1 of tE, item 2 of tE, item 3 of tE
   if pMoved and sTicks mod 8 = pId mod 8 then
      put 3 - sE[pId]["frame"] into sE[pId]["frame"]
      put char 1 to -2 of sE[pId]["mesh"] into tBase
      put tBase & sE[pId]["frame"] into sE[pId]["mesh"]
      uDead.SetMesh sE[pId]["key"], sE[pId]["mesh"]
   end if
end uDead.Place

-------------------------------------------------------------------- the grid

function uDead.CellOf pX, pZ
   return trunc(pZ / kCellM) * sCols + trunc(pX / kCellM)
end uDead.CellOf

-- open floor, and no shut door or window on it
function uDead.Free pCell
   if sPass[pCell] is not true then return false
   if sDoorAt[pCell] is not empty then return false
   return true
end uDead.Free

-- nothing solid between two points? Windows are glass: they do not block the view.
function uDead.Sees pX1, pZ1, pX2, pZ2
   local tDX, tDZ, tD, tN, tK, tI
   put pX2 - pX1 into tDX
   put pZ2 - pZ1 into tDZ
   put sqrt(tDX * tDX + tDZ * tDZ) into tD
   put trunc(tD / 0.3) + 1 into tN
   repeat with tK = 1 to tN - 1
      put trunc((pZ1 + tDZ * tK / tN) / kCellM) * sCols + trunc((pX1 + tDX * tK / tN) / kCellM) into tI
      if sPass[tI] is not true then return false
      if sDoorAt[tI] is not empty then
         if sDoor[sDoorAt[tI]]["kind"] is "door" then return false
      end if
   end repeat
   return true
end uDead.Sees

-------------------------------------------------------------------- distance maps

-- Every map is a flood from its sources over the open cells: each cell learns how many
-- steps it is from the nearest source. Walkers step to the neighbour with the smaller
-- number (or the larger one, to run away). One map is worked on at a time, a few
-- milliseconds a step, so a big level never stalls the game.
on uDead.FieldWork
   local tStop, tName, tBest, tBestAt, tI, tD, tN, tCount, tNowS
   put the milliseconds + kFieldMS into tStop
   put sTicks * sStepMS / 1000 into tNowS       -- the game's own clock, so a test run fast behaves the same
   if sJobName is empty then
      put empty into tBest
      repeat for each key tName in sJob
         if sJob[tName]["at"] <= tNowS then
            if tBest is empty or sJob[tName]["at"] < tBestAt then
               put tName into tBest
               put sJob[tName]["at"] into tBestAt
            end if
         end if
      end repeat
      if tBest is empty then exit uDead.FieldWork
      uDead.FieldBegin tBest
      if sJobName is empty then exit uDead.FieldWork
   end if
   put 0 into tCount
   repeat while sJobHead <= sJobTail
      put sJobQ[sJobHead] into tI
      add 1 to sJobHead
      put sJobD[tI] + 1 into tD
      repeat for each item tN in (tI - 1) & comma & (tI + 1) & comma & (tI - sCols) & comma & (tI + sCols)
         if sJobD[tN] is empty and sPass[tN] is true then
            if sJobDoors or sDoorAt[tN] is empty then
               put tD into sJobD[tN]
               add 1 to sJobTail
               put tN into sJobQ[sJobTail]
            end if
         end if
      end repeat
      add 1 to tCount
      if tCount mod 150 = 0 then
         if the milliseconds >= tStop then exit uDead.FieldWork
      end if
   end repeat
   -- finished
   put sJobD into sField[sJobName]
   if sJob[sJobName] is an array then
      if sJob[sJobName]["every"] > 0 then
         put tNowS + sJob[sJobName]["every"] into sJob[sJobName]["at"]
      else
         put tNowS + 100000 into sJob[sJobName]["at"]
      end if
   end if
   put empty into sJobName
   put empty into sJobD
   put empty into sJobQ
end uDead.FieldWork

-- start a flood: collect its sources. A map with no sources is simply emptied.
on uDead.FieldBegin pName
   local tId, tSources, tI
   put empty into sJobD
   put empty into sJobQ
   put 1 into sJobHead
   put 0 into sJobTail
   put true into sJobDoors          -- true: the flood passes shut doors (the dead break them)
   switch char 1 of pName
      case "H"
         repeat for each line tId in sH
            put uDead.CellOf(sE[tId]["x"], sE[tId]["z"]) & cr after tSources
         end repeat
         break
      case "Z"
         put false into sJobDoors
         repeat for each line tId in sZ
            put uDead.CellOf(sE[tId]["x"], sE[tId]["z"]) & cr after tSources
         end repeat
         break
      case "P"
         put uDead.CellOf(sPX, sPZ) into tSources
         break
      case "A"
         put false into sJobDoors
         repeat for each key tId in sAmmo
            if sAmmo[tId]["left"] > 0 then put uDead.CellOf(sAmmo[tId]["x"], sAmmo[tId]["z"]) & cr after tSources
         end repeat
         break
      case "O"
         put char 2 to -1 of pName into tId
         if sE[tId]["order"] is "goto" then
            put uDead.CellOf(sE[tId]["gx"], sE[tId]["gz"]) into tSources
         else if sE[tId]["order"] is "attack" and sE[sE[tId]["target"]]["state"] is "alive" then
            put uDead.CellOf(sE[sE[tId]["target"]]["x"], sE[sE[tId]["target"]]["z"]) into tSources
         else
            delete variable sJob[pName]
            delete variable sField[pName]
            exit uDead.FieldBegin
         end if
         break
   end switch
   repeat for each line tI in tSources
      if tI is empty then next repeat
      if sJobD[tI] is empty then
         put 0 into sJobD[tI]
         add 1 to sJobTail
         put tI into sJobQ[sJobTail]
      end if
   end repeat
   put pName into sJobName
end uDead.FieldBegin

-- one step along a map. pDown true: toward the sources; false: away from them.
-- Returns "moved", "door" & the door number when a shut door is in the way (the dead only),
-- "there" when no neighbour is better, or empty when the map does not cover this cell.
function uDead.FieldStep pId, pName, pSpeed, pDT, pDown, pBreaks
   local tI, tCur, tBest, tBestI, tN, tV, tC, tR, tDC, tDR, tTX, tTZ, tDX, tDZ, tD, tStep, tDoor
   put uDead.CellOf(sE[pId]["x"], sE[pId]["z"]) into tI
   put sField[pName][tI] into tCur
   if tCur is empty then return empty
   put tCur into tBest
   put empty into tBestI
   repeat for each word tN in "1,0 -1,0 0,1 0,-1 1,1 1,-1 -1,1 -1,-1"
      put item 1 of tN into tDC
      put item 2 of tN into tDR
      put tI + tDR * sCols + tDC into tC
      put sField[pName][tC] into tV
      if tV is empty then next repeat
      if tDC is not 0 and tDR is not 0 then
         -- never cut a wall corner
         if sPass[tI + tDC] is not true or sPass[tI + tDR * sCols] is not true then next repeat
         if sDoorAt[tI + tDC] is not empty or sDoorAt[tI + tDR * sCols] is not empty or sDoorAt[tC] is not empty then next repeat
      end if
      if not pBreaks and sDoorAt[tC] is not empty then next repeat
      if pDown and tV < tBest or not pDown and tV > tBest then
         put tV into tBest
         put tC into tBestI
      end if
   end repeat
   if tBestI is empty then return "there"
   if sDoorAt[tBestI] is not empty then return "door" & sDoorAt[tBestI]
   put (tBestI mod sCols + 0.5) * kCellM into tTX
   put (tBestI div sCols + 0.5) * kCellM into tTZ
   put tTX - sE[pId]["x"] into tDX
   put tTZ - sE[pId]["z"] into tDZ
   put sqrt(tDX * tDX + tDZ * tDZ) into tD
   if tD < 0.001 then return "moved"
   put min(tD, pSpeed * pDT) into tStep
   add tDX / tD * tStep to sE[pId]["x"]
   add tDZ / tD * tStep to sE[pId]["z"]
   put atan2(tDX, tDZ) into sE[pId]["yaw"]
   return "moved"
end uDead.FieldStep

-------------------------------------------------------------------- who is who

-- the walking dead and the living, as id lists, once a step
on uDead.Lists
   local tId
   put empty into sZ
   put empty into sH
   repeat for each line tId in sIds
      if sE[tId]["state"] is "alive" then
         if sE[tId]["kind"] is "z" then
            put tId & cr after sZ
         else
            put tId & cr after sH
         end if
      end if
   end repeat
   delete the last char of sZ
   delete the last char of sH
end uDead.Lists

-- the living; and the dead who walk or will get up again
on uDead.Count
   local tId
   put the number of lines of sH into sCountH
   put the number of lines of sZ into sCountZ
   repeat for each line tId in sIds
      if sE[tId]["state"] is "down" or sE[tId]["state"] is "corpse" then add 1 to sCountZ
   end repeat
end uDead.Count

function uDead.Dist pA, pB
   return sqrt((sE[pA]["x"] - sE[pB]["x"]) ^ 2 + (sE[pA]["z"] - sE[pB]["z"]) ^ 2)
end uDead.Dist

-- the nearest of a list of ids to one of the cast: "id,distance" (empty when the list is)
function uDead.Nearest pId, pList
   local tBest, tBestD, tOther, tD
   put empty into tBest
   repeat for each line tOther in pList
      put (sE[pId]["x"] - sE[tOther]["x"]) ^ 2 + (sE[pId]["z"] - sE[tOther]["z"]) ^ 2 into tD
      if tBest is empty or tD < tBestD then
         put tOther into tBest
         put tD into tBestD
      end if
   end repeat
   if tBest is empty then return empty
   return tBest & comma & sqrt(tBestD)
end uDead.Nearest

-------------------------------------------------------------------- the dead

on uDead.Zombies pDT
   local tId, tNear, tVictim, tD, tHow, tMoved, tSpeed, tField
   repeat for each line tId in sZ
      put max(0, sE[tId]["penalty"] - pDT * 100) into sE[tId]["penalty"]
      if sE[tId]["state"] is not "alive" then next repeat
      if sE[tId]["busy"] > sNow then next repeat           -- eating, or getting up
      if sE[tId]["rushAt"] is not empty then
         if sNow >= sE[tId]["rushAt"] then
            put empty into sE[tId]["rushAt"]
            put "RUSH" into sE[tId]["beh"]
            uDead.ClearOrder tId
         end if
      end if
      put false into tMoved
      put uDead.Nearest(tId, sH) into tNear
      put item 1 of tNear into tVictim
      put item 2 of tNear into tD
      if sE[tId]["order"] is "attack" then
         if sE[sE[tId]["target"]]["state"] is "alive" and sE[sE[tId]["target"]]["kind"] is "h" then
            put sE[tId]["target"] into tVictim
            put uDead.Dist(tId, tVictim) into tD
         else
            uDead.ClearOrder tId
         end if
      end if
      -- someone within reach: bite
      if tVictim is not empty and tD <= kBiteReach then
         if sE[tId]["biting"] is not tVictim then
            put tVictim into sE[tId]["biting"]
            put sNow + kBiteDelay into sE[tId]["biteAt"]
         else if sNow >= sE[tId]["biteAt"] then
            uDead.KillHuman tVictim
            put sNow + kEatTime into sE[tId]["busy"]
            put empty into sE[tId]["biting"]
            if sE[tId]["order"] is "attack" then uDead.ClearOrder tId
         end if
         put atan2(sE[tVictim]["x"] - sE[tId]["x"], sE[tVictim]["z"] - sE[tId]["z"]) into sE[tId]["yaw"]
         uDead.Place tId, false
         next repeat
      end if
      put empty into sE[tId]["biting"]
      -- where to?
      put empty into tField
      put kZWalk into tSpeed
      if sE[tId]["order"] is not empty then
         put "O" & tId into tField
         put kZRush into tSpeed
         if sE[tId]["order"] is "goto" then
            if abs(sE[tId]["x"] - sE[tId]["gx"]) + abs(sE[tId]["z"] - sE[tId]["gz"]) < 0.6 then
               uDead.ClearOrder tId
               put empty into tField
            end if
         end if
      else if sE[tId]["beh"] is "RUSH" then
         put "H" into tField
         put kZRush into tSpeed
      else if sE[tId]["beh"] is "FOLLOW" then
         if abs(sE[tId]["x"] - sPX) + abs(sE[tId]["z"] - sPZ) > 2.2 then put "P" into tField
         -- the living close by are too tempting
         if tVictim is not empty and tD < 3 then put "H" into tField
      end if
      if tField is not empty then
         put uDead.FieldStep(tId, tField, tSpeed, pDT, true, true) into tHow
         if tHow is "moved" then
            put true into tMoved
         else if char 1 to 4 of tHow is "door" then
            uDead.HitDoor char 5 to -1 of tHow, pDT
         end if
      end if
      uDead.Place tId, tMoved
   end repeat
   if sTicks mod 2 = 0 then uDead.Spread
end uDead.Zombies

-- the dead do not stand inside each other
on uDead.Spread
   local tA, tB, tDX, tDZ, tD, tPush, tNX, tNZ
   repeat for each line tA in sZ
      repeat for each line tB in sZ
         if tB <= tA then next repeat
         put sE[tB]["x"] - sE[tA]["x"] into tDX
         put sE[tB]["z"] - sE[tA]["z"] into tDZ
         if abs(tDX) > 0.45 or abs(tDZ) > 0.45 then next repeat
         put sqrt(tDX * tDX + tDZ * tDZ) into tD
         if tD >= 0.45 then next repeat
         if tD < 0.01 then
            put 0.05 * (tA mod 3 - 1) + 0.02 into tDX
            put 0.05 * (tB mod 3 - 1) + 0.02 into tDZ
            put 0.07 into tD
         end if
         put (0.45 - tD) * 0.25 into tPush
         put sE[tB]["x"] + tDX / tD * tPush into tNX
         put sE[tB]["z"] + tDZ / tD * tPush into tNZ
         if uDead.Free(uDead.CellOf(tNX, tNZ)) then
            put tNX into sE[tB]["x"]
            put tNZ into sE[tB]["z"]
         end if
      end repeat
   end repeat
end uDead.Spread

on uDead.ClearOrder pId
   put empty into sE[pId]["order"]
   put empty into sE[pId]["target"]
   delete variable sJob["O" & pId]
   delete variable sField["O" & pId]
end uDead.ClearOrder

on uDead.HitDoor pN, pDT
   local tCell
   if sDoor[pN]["hp"] <= 0 then exit uDead.HitDoor
   subtract 40 * pDT from sDoor[pN]["hp"]
   if sTicks mod 10 = 0 then FX.Sparks sDoor[pN]["x"] * kM, -1.0 * kM, sDoor[pN]["z"] * kM, 3, "#C08A3A"
   if sDoor[pN]["hp"] <= 0 then
      set the itemDel to comma
      repeat for each word tCell in sDoor[pN]["cells"]
         delete variable sDoorAt[item 2 of tCell * sCols + item 1 of tCell]
      end repeat
      FX.Sparks sDoor[pN]["x"] * kM, -1.0 * kM, sDoor[pN]["z"] * kM, 14, "#FFE0A0"
      Entity.Kill sDoor[pN]["key"]
      put empty into sDoor[pN]["key"]
   end if
end uDead.HitDoor

-- a living person dies: a body now, one of the dead soon
on uDead.KillHuman pId
   if sE[pId]["state"] is not "alive" then exit uDead.KillHuman
   put "corpse" into sE[pId]["state"]
   put sNow + kRiseHuman into sE[pId]["riseAt"]
   FX.Sparks sE[pId]["x"] * kM, -1.0 * kM, sE[pId]["z"] * kM, 12, "#E02020"
   uDead.Dress pId
   uDead.Lists
   uDead.Count
end uDead.KillHuman

-- a zombie takes damage; pFinal: a head shot, no getting up
on uDead.HurtZombie pId, pDamage, pFinal
   if sE[pId]["state"] is not "alive" then exit uDead.HurtZombie
   subtract pDamage from sE[pId]["hp"]
   FX.Sparks sE[pId]["x"] * kM, -1.2 * kM, sE[pId]["z"] * kM, 8, "#D01010"
   put true into sE[pId]["hurt"]
   if sE[pId]["hp"] > 0 then exit uDead.HurtZombie
   subtract 1 from sE[pId]["lives"]
   if pFinal then put 0 into sE[pId]["lives"]
   uDead.ClearOrder pId
   put empty into sE[pId]["biting"]
   if sE[pId]["lives"] > 0 then
      put "down" into sE[pId]["state"]
      put sNow + kRiseZombie into sE[pId]["riseAt"]
   else
      put "gone" into sE[pId]["state"]
   end if
   uDead.Dress pId
   uDead.Lists
   uDead.Count
end uDead.HurtZombie

-- the fallen get up
on uDead.Risers
   local tId, tChanged
   if sTicks mod 6 is not 0 then exit uDead.Risers
   put false into tChanged
   repeat for each line tId in sIds
      if sE[tId]["state"] is "down" or sE[tId]["state"] is "corpse" then
         if sNow >= sE[tId]["riseAt"] then
            if sE[tId]["state"] is "corpse" then
               put "z" into sE[tId]["kind"]
               put 1 into sE[tId]["lives"]
               put empty into sE[tId]["gun"]
               put true into sE[tId]["fresh"]
            end if
            put "alive" into sE[tId]["state"]
            if sE[tId]["fresh"] is true then
               put 249 + random(251) into sE[tId]["hp"]       -- the freshly dead are frail
            else
               put 349 + random(301) into sE[tId]["hp"]       -- second wind, not a full one
            end if
            put sMode into sE[tId]["beh"]
            put sNow + 0.8 into sE[tId]["busy"]
            put empty into sE[tId]["order"]
            put empty into sE[tId]["rushAt"]
            put 0 into sE[tId]["penalty"]
            uDead.Dress tId
            put true into tChanged
         end if
      end if
   end repeat
   if tChanged then
      uDead.Lists
      uDead.Count
   end if
end uDead.Risers

-------------------------------------------------------------------- the living

on uDead.Humans pDT
   local tId, tNear, tFoe, tD, tSees, tHow, tMoved, tRange, tCell, tV
   repeat for each line tId in sH
      if sE[tId]["state"] is not "alive" then next repeat
      -- senses, a few of the living each step
      if (sTicks + tId) mod 9 = 0 then
         put uDead.Nearest(tId, sZ) into tNear
         put item 1 of tNear into sE[tId]["foe"]
         put item 2 of tNear into sE[tId]["foeD"]
         put false into sE[tId]["sees"]
         if tNear is not empty then
            put kSight into tRange
            if sE[tId]["gun"] is "sniper" then put kSniperRange into tRange
            if item 2 of tNear <= tRange then
               put uDead.Sees(sE[tId]["x"], sE[tId]["z"], sE[item 1 of tNear]["x"], sE[item 1 of tNear]["z"]) into sE[tId]["sees"]
            end if
            if sE[tId]["sees"] or item 2 of tNear <= kHearing then put true into sE[tId]["awake"]
         end if
      end if
      if sE[tId]["awake"] is not true then next repeat
      if sE[tId]["reloadUntil"] > sNow then
         uDead.Place tId, false
         next repeat
      end if
      if sE[tId]["noAmmo"] is true then
         uDead.FetchAmmo tId, pDT
         next repeat
      end if
      put sE[tId]["foe"] into tFoe
      if tFoe is empty then next repeat
      if sE[tFoe]["state"] is not "alive" then next repeat
      put uDead.Dist(tId, tFoe) into tD
      put sE[tId]["sees"] into tSees
      put false into tMoved
      if sE[tId]["gun"] is not empty then
         put kGunRange into tRange
         if sE[tId]["gun"] is "sniper" then put kSniperRange into tRange
         if tSees and tD <= tRange then
            put atan2(sE[tFoe]["x"] - sE[tId]["x"], sE[tFoe]["z"] - sE[tId]["z"]) into sE[tId]["yaw"]
            uDead.Shoot tId, tFoe, tD
            -- too close: back off while shooting
            if tD < 4.5 and sE[tId]["gun"] is not "sniper" then
               get uDead.FieldStep(tId, "Z", 1.5, pDT, false, false)
               put atan2(sE[tFoe]["x"] - sE[tId]["x"], sE[tFoe]["z"] - sE[tId]["z"]) into sE[tId]["yaw"]
               put true into tMoved
            end if
         else if sE[tId]["gun"] is not "sniper" then
            -- seek and destroy
            put (uDead.FieldStep(tId, "Z", kSeekSpeed, pDT, true, false) is "moved") into tMoved
         end if
      else if sE[tId]["melee"] is true then
         if tD <= 1.1 then
            put atan2(sE[tFoe]["x"] - sE[tId]["x"], sE[tFoe]["z"] - sE[tId]["z"]) into sE[tId]["yaw"]
            if sNow >= sE[tId]["next"] then
               put sNow + 0.9 into sE[tId]["next"]
               uDead.HurtZombie tFoe, round((160 + random(120)) * sEase), false
            end if
         else if tD < 10 then
            put (uDead.FieldStep(tId, "Z", kSeekSpeed + 0.3, pDT, true, false) is "moved") into tMoved
         end if
      else
         -- unarmed: run while the dead are near, by the map of distances to them
         put sField["Z"][uDead.CellOf(sE[tId]["x"], sE[tId]["z"])] into tV
         if tV is not empty and tV < 20 then
            put (uDead.FieldStep(tId, "Z", kFleeSpeed, pDT, false, false) is "moved") into tMoved
         end if
      end if
      uDead.Place tId, tMoved
   end repeat
end uDead.Humans

on uDead.Shoot pId, pFoe, pD
   local tGun, tChance, tOther
   if sNow < sE[pId]["next"] then exit uDead.Shoot
   put sE[pId]["gun"] into tGun
   -- soldiers: a grenade when the range is right
   if sE[pId]["nades"] > 0 and pD > 3 and pD < 10 then
      subtract 1 from sE[pId]["nades"]
      put sNow + 1.2 into sE[pId]["next"]
      uDead.Throw sE[pId]["x"], sE[pId]["z"], sE[pFoe]["x"], sE[pFoe]["z"]
      exit uDead.Shoot
   end if
   if sE[pId]["shots"] <= 0 then
      -- out: reload from a spare magazine (standing still), or go and find ammo
      if tGun is not "sniper" and sE[pId]["mags"] <= 0 then
         put true into sE[pId]["noAmmo"]
         exit uDead.Shoot
      end if
      subtract 1 from sE[pId]["mags"]
      if tGun is "rifle" then
         put 16 + random(16) into sE[pId]["shots"]
      else
         put 4 + random(4) into sE[pId]["shots"]
      end if
      put sNow + kReload into sE[pId]["next"]
      put sNow + kReload into sE[pId]["reloadUntil"]
      uDead.Ring sE[pId]["x"], sE[pId]["z"], "#FFE040", kReload
      exit uDead.Shoot
   end if
   subtract 1 from sE[pId]["shots"]
   switch tGun
      case "rifle"
         put sNow + 0.1 into sE[pId]["next"]
         break
      case "sniper"
         put sNow + 0.8 + random(200) / 100 into sE[pId]["next"]
         break
      default
         put sNow + 0.4 + random(40) / 100 into sE[pId]["next"]
   end switch
   -- slower on the easy levels
   put sNow + (sE[pId]["next"] - sNow) / sEase into sE[pId]["next"]
   -- the muzzle flash, and a ring across the ground so you see where shots come from
   FX.Sparks (sE[pId]["x"] + sin(sE[pId]["yaw"]) * 0.8) * kM, -1.38 * kM, (sE[pId]["z"] + cos(sE[pId]["yaw"]) * 0.8) * kM, 10, "#FFF080"
   uDead.Ring sE[pId]["x"], sE[pId]["z"], "#FF9040", 0.6
   put max(0.25, 0.95 - pD * 0.04) into tChance
   if tGun is "sniper" then put 0.55 into tChance
   put tChance * sEase into tChance
   if random(1000) <= tChance * 1000 then
      if tGun is "rifle" then
         uDead.HurtZombie pFoe, round(95 * sEase), (random(100) <= 4 * sEase)
      else if tGun is "sniper" then
         uDead.HurtZombie pFoe, round(450 * sEase), (random(100) <= 25 * sEase)
      else
         uDead.HurtZombie pFoe, round(185 * sEase), (random(100) <= 8 * sEase)
      end if
   end if
   -- a shot wakes the neighbours
   if sTicks mod 3 = 0 then
      repeat for each line tOther in sH
         if sE[tOther]["awake"] is not true then
            if uDead.Dist(pId, tOther) <= kShotHeard then put true into sE[tOther]["awake"]
         end if
      end repeat
   end if
end uDead.Shoot

-------------------------------------------------------------------- grenades

on uDead.Throw pX, pZ, pTX, pTZ
   local tN
   put the number of lines of the keys of sNades + 1 into tN
   repeat while sNades[tN] is an array
      add 1 to tN
   end repeat
   put pX into sNades[tN]["x0"]
   put pZ into sNades[tN]["z0"]
   put pTX into sNades[tN]["x1"]
   put pTZ into sNades[tN]["z1"]
   put sNow into sNades[tN]["t0"]
   put Entity.Spawn("uDead.Nade", pX * kM, -1.4 * kM, pZ * kM, "#FF5030") into sNades[tN]["key"]
end uDead.Throw

on uDead.Grenades
   local tN, tT, tX, tZ, tUp, tId, tD
   repeat for each key tN in sNades
      put sNow - sNades[tN]["t0"] into tT
      if tT < 0.9 then
         -- in the air
         put sNades[tN]["x0"] + (sNades[tN]["x1"] - sNades[tN]["x0"]) * tT / 0.9 into tX
         put sNades[tN]["z0"] + (sNades[tN]["z1"] - sNades[tN]["z0"]) * tT / 0.9 into tZ
         put 1.4 * (1 - tT / 0.9) + 2.2 * (tT / 0.9) * (1 - tT / 0.9) + 0.08 into tUp
         Entity.SetPosition sNades[tN]["key"], tX * kM, -tUp * kM, tZ * kM
      else if tT >= 1.7 then
         put sNades[tN]["x1"] into tX
         put sNades[tN]["z1"] into tZ
         FX.Sparks tX * kM, -0.6 * kM, tZ * kM, 30, "#FF9020"
         FX.Sparks tX * kM, -1.2 * kM, tZ * kM, 16, "#FFF0A0"
         Entity.Kill sNades[tN]["key"]
         delete variable sNades[tN]
         repeat for each line tId in sIds
            if sE[tId]["state"] is not "alive" then next repeat
            put sqrt((sE[tId]["x"] - tX) ^ 2 + (sE[tId]["z"] - tZ) ^ 2) into tD
            if tD > kBlast then next repeat
            if sE[tId]["kind"] is "h" then
               uDead.KillHuman tId
            else
               uDead.HurtZombie tId, 5000, (random(2) = 1)
            end if
         end repeat
      end if
   end repeat
end uDead.Grenades

-------------------------------------------------------------------- you

-- the keys held down; uDead.TestKeys lets a test drive the game without a keyboard
function uDead.Down
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end uDead.Down

on uDead.TestKeys pKeys
   put pKeys into sTestKeys
end uDead.TestKeys

-- is a letter (either case) or a key code held?
function uDead.Held pKey, pKeys
   if pKey is a number then return (pKey is among the items of pKeys)
   if charToNum(toLower(pKey)) is among the items of pKeys then return true
   return (charToNum(toUpper(pKey)) is among the items of pKeys)
end uDead.Held

-- true once when a key goes down
function uDead.Pressed pKey, pKeys
   local tNow
   put uDead.Held(pKey, pKeys) into tNow
   if tNow and sKeyWas[pKey] is not true then
      put true into sKeyWas[pKey]
      return true
   end if
   put tNow into sKeyWas[pKey]
   return false
end uDead.Pressed

on uDead.Keys
   local tKeys, tId, tAny
   put uDead.Down() into tKeys
   if uDead.Pressed("l", tKeys) then
      put not (sHideHUD is true) into sHideHUD
      put empty into sHUDWas
   end if
   if uDead.Pressed("i", tKeys) then
      put not (sHelp is true) into sHelp
      put empty into sHUDWas
   end if
   if uDead.Pressed(32, tKeys) then
      if sState is "won" then
         if sLegacy is true and sLevel >= the number of lines of sLevelNames then
            put 1 into sLevel
         else
            add 1 to sLevel
         end if
         uDead.Say "LOADING", 2
         put sTicks + 2 into sNextLevelAt
         exit uDead.Keys
      else if sState is "lost" then
         uDead.Say "RAISING THE DEAD", 2
         put sTicks + 2 into sNextLevelAt
         exit uDead.Keys
      else
         uDead.SetMode "HOLD"
      end if
   end if
   if sState is not "play" then exit uDead.Keys
   if uDead.Pressed("h", tKeys) then uDead.SetMode "HOLD"
   if uDead.Pressed("f", tKeys) or uDead.Pressed("c", tKeys) then uDead.SetMode "FOLLOW"
   if uDead.Pressed("r", tKeys) then
      -- everyone not eating rushes, each after a moment of its own
      put "RUSH" into sMode
      repeat for each line tId in sZ
         put sNow + random(50) / 100 into sE[tId]["rushAt"]
      end repeat
      uDead.Say "RUSH", 1.5
   end if
   if uDead.Pressed("z", tKeys) then
      if sSpeed < 1 then
         put 1 into sSpeed
      else
         put 0.15 into sSpeed
      end if
      put empty into sHUDWas
   end if
   if uDead.Pressed("j", tKeys) then
      repeat for each line tId in sH
         uDead.KillHuman tId
      end repeat
   end if
end uDead.Keys

-- HOLD or FOLLOW: every zombie drops what it was told (unless it is eating)
on uDead.SetMode pMode
   local tId
   put pMode into sMode
   repeat for each line tId in sZ
      put pMode into sE[tId]["beh"]
      put empty into sE[tId]["rushAt"]
      uDead.ClearOrder tId
   end repeat
   uDead.Say pMode, 1.5
end uDead.SetMode

-- mouse look: how far the pointer moved from the centre, then put it back. Only while
-- this stack is the front window; the arrow keys always turn.
on uDead.Look
   local tKeys, tM, dx, dy
   put uDead.Down() into tKeys
   if uDead.Held(65361, tKeys) then subtract kTurn from gCameraYaw
   if uDead.Held(65363, tKeys) then add kTurn to gCameraYaw
   if uDead.Held(65362, tKeys) then put min(1.35, gCameraPitch + kTurn / 2) into gCameraPitch
   if uDead.Held(65364, tKeys) then put max(-1.35, gCameraPitch - kTurn / 2) into gCameraPitch
   if sTestKeys is not empty or gNoMouse is true then exit uDead.Look
   if the short name of the topStack is not the short name of this stack then
      put false into sMouseReady
      exit uDead.Look
   end if
   put the mouseLoc into tM
   if sMouseReady then
      put (item 1 of tM) - round(CenterX) into dx
      put (item 2 of tM) - round(CenterY) into dy
      if abs(dx) > 250 or abs(dy) > 250 then
         put 0 into dx
         put 0 into dy
      end if
      add dx * kMouseSens to gCameraYaw
      Camera.SetLook empty, max(-1.35, min(1.35, gCameraPitch - dy * kMouseSens))
   end if
   set the screenMouseLoc to globalLoc(round(CenterX) & comma & round(CenterY))
   put true into sMouseReady
end uDead.Look

on uDead.MovePlayer
   local tKeys, tFX, tFZ, tMX, tMZ, tD, tStep, tNX, tNZ
   put uDead.Down() into tKeys
   put sin(gCameraYaw) into tFX
   put cos(gCameraYaw) into tFZ
   put 0 into tMX
   put 0 into tMZ
   if uDead.Held("w", tKeys) then
      add tFX to tMX
      add tFZ to tMZ
   end if
   if uDead.Held("s", tKeys) then
      subtract tFX from tMX
      subtract tFZ from tMZ
   end if
   if uDead.Held("d", tKeys) then
      add tFZ to tMX
      subtract tFX from tMZ
   end if
   if uDead.Held("a", tKeys) then
      subtract tFZ from tMX
      add tFX to tMZ
   end if
   put sqrt(tMX * tMX + tMZ * tMZ) into tD
   if tD < 0.01 then exit uDead.MovePlayer
   put kPlayerSpeed * sStepMS / 1000 into tStep
   -- each axis on its own, so you slide along walls. Shut doors stop you too.
   put sPX + tMX / tD * tStep into tNX
   if uDead.Free(uDead.CellOf(tNX + 0.2 * uDead.Sign(tMX), sPZ)) then put tNX into sPX
   put sPZ + tMZ / tD * tStep into tNZ
   if uDead.Free(uDead.CellOf(sPX, tNZ + 0.2 * uDead.Sign(tMZ))) then put tNZ into sPZ
end uDead.MovePlayer

function uDead.Sign pV
   if pV < 0 then return -1
   return 1
end uDead.Sign

on uDead.Camera
   Camera.SetPosition sPX * kM, -kEye * kM, sPZ * kM
end uDead.Camera

-- tests: stand somewhere, look somewhere (metres from the map corner, radians)
on uDead.TestPlace pX, pZ, pYaw, pPitch
   put pX into sPX
   put pZ into sPZ
   if pYaw is a number then put pYaw into gCameraYaw
   if pPitch is a number then put pPitch into gCameraPitch
end uDead.TestPlace

on uDead.TestLevel pNumber
   put pNumber into sLevel
   put sTicks + 1 into sNextLevelAt
end uDead.TestLevel

-- test: every shooter (id gun shots mags reloading noAmmo) and the crates' refills left
-- test: empty every shooter's gun and magazines
on uDead.TestDry
   local tId
   repeat for each line tId in sH
      if sE[tId]["gun"] is not empty and sE[tId]["gun"] is not "sniper" then
         put 0 into sE[tId]["shots"]
         put 0 into sE[tId]["mags"]
         put true into sE[tId]["noAmmo"]
         put true into sE[tId]["awake"]
      end if
   end repeat
end uDead.TestDry

function uDead.AmmoState
   local tId, tOut, tC
   repeat for each line tId in sH
      if sE[tId]["gun"] is empty or sE[tId]["state"] is not "alive" then next repeat
      put tId && sE[tId]["gun"] && sE[tId]["shots"] && sE[tId]["mags"] && (sE[tId]["reloadUntil"] > sNow) && sE[tId]["noAmmo"] & cr after tOut
   end repeat
   repeat for each key tC in sAmmo
      put "crate" && tC && sAmmo[tC]["left"] & cr after tOut
   end repeat
   return tOut
end uDead.AmmoState

function uDead.State
   local tId, tOut
   put sName & "|" & sState & "|" & sMode & "|dead " & sCountZ & "|living " & sCountH & "|you " & round(sPX, 1) & "," & round(sPZ, 1) & "|t " & round(sNow, 1) into tOut
   repeat for each line tId in sIds
      put cr & tId && sE[tId]["kind"] && sE[tId]["state"] && round(sE[tId]["x"], 1) & "," & round(sE[tId]["z"], 1) && sE[tId]["beh"] && sE[tId]["order"] && sE[tId]["gun"] && sE[tId]["melee"] && sE[tId]["role"] && sE[tId]["awake"] after tOut
   end repeat
   return tOut
end uDead.State

-- tests: what one of the cast sees on a distance map: its own cell's number, then its 8 neighbours'
function uDead.Probe pId, pName
   local tI, tOut, tN
   put uDead.CellOf(sE[pId]["x"], sE[pId]["z"]) into tI
   put "cell " & tI & " = " & sField[pName][tI] & " |" into tOut
   repeat for each item tN in "-1,1," & (-sCols) & comma & sCols & comma & (-sCols - 1) & comma & (-sCols + 1) & comma & (sCols - 1) & comma & (sCols + 1)
      put space & sField[pName][tI + tN] & "/" & sPass[tI + tN] & "/" & sDoorAt[tI + tN] after tOut
   end repeat
   return tOut & " | job " & sJobName & " keys " & the keys of sJob & " cells " & the number of lines of the keys of sField[pName] & " busy " & sE[pId]["busy"] & " rushAt " & sE[pId]["rushAt"] & " now " & sNow
end uDead.Probe

-- tests: the level as a picture. # wall, D door, W window, Z dead, z down, h living, x body, P you
function uDead.Map
   local tR, tC, tI, tRow, tOut, tId, tMark, tCh
   repeat for each line tId in sIds
      put "h" into tCh
      if sE[tId]["kind"] is "z" then put "Z" into tCh
      if sE[tId]["state"] is "down" then put "z" into tCh
      if sE[tId]["state"] is "corpse" or sE[tId]["state"] is "gone" then put "x" into tCh
      put tCh into tMark[uDead.CellOf(sE[tId]["x"], sE[tId]["z"])]
   end repeat
   put "P" into tMark[uDead.CellOf(sPX, sPZ)]
   repeat with tR = 0 to sRows - 1
      put empty into tRow
      repeat with tC = 0 to sCols - 1
         put tR * sCols + tC into tI
         if tMark[tI] is not empty then
            put tMark[tI] after tRow
         else if sPass[tI] is not true then
            put "#" after tRow
         else if sDoorAt[tI] is not empty then
            put toUpper(char 1 of sDoor[sDoorAt[tI]]["kind"]) after tRow
         else
            put "." after tRow
         end if
      end repeat
      put tRow & cr after tOut
   end repeat
   return tOut
end uDead.Map

-------------------------------------------------------------------- orders

-- the click: whatever is under the crosshair. A living person: the nearest free zombie
-- attacks them. A door or window, a wall, the ground: the zombie goes there (breaking
-- the door on the way). More clicks send more zombies.
on uDead.Command
   local tDX, tDY, tDZ, tId, tVX, tVY, tVZ, tT, tPerp, tBest, tBestT, tK, tX, tY, tZ, tI, tLastX, tLastZ
   local tGX, tGZ, tHit, tZomb, tMax
   put sin(gCameraYaw) * cos(gCameraPitch) into tDX
   put sin(gCameraPitch) into tDY                 -- up is positive here
   put cos(gCameraYaw) * cos(gCameraPitch) into tDZ
   -- the living person nearest along the ray
   put empty into tBest
   repeat for each line tId in sH
      put sE[tId]["x"] - sPX into tVX
      put 0.95 - kEye into tVY
      put sE[tId]["z"] - sPZ into tVZ
      put tVX * tDX + tVY * tDY + tVZ * tDZ into tT
      if tT <= 0 then next repeat
      put tVX * tVX + tVY * tVY + tVZ * tVZ - tT * tT into tPerp
      if tPerp > 0.55 then next repeat             -- about 0.75 m off the line
      if tBest is empty or tT < tBestT then
         put tId into tBest
         put tT into tBestT
      end if
   end repeat
   -- walk the ray until it meets the floor, a wall or a shut door
   put 45 into tMax
   if tBest is not empty then put tBestT into tMax
   put empty into tHit
   put sPX into tLastX
   put sPZ into tLastZ
   repeat with tK = 1 to trunc(tMax / 0.25)
      put sPX + tDX * tK * 0.25 into tX
      put kEye + tDY * tK * 0.25 into tY
      put sPZ + tDZ * tK * 0.25 into tZ
      if tX < 0 or tZ < 0 or tX >= sCols * kCellM or tZ >= sRows * kCellM then exit repeat
      put uDead.CellOf(tX, tZ) into tI
      if tY <= 0 then
         if sPass[tI] is true then
            put tX into tLastX
            put tZ into tLastZ
         end if
         put "floor" into tHit
         exit repeat
      end if
      if sPass[tI] is not true and tY < kWallH then
         put "wall" into tHit
         exit repeat
      end if
      if sDoorAt[tI] is not empty and tY < 1.9 then
         put tX into tLastX
         put tZ into tLastZ
         put "door" into tHit
         exit repeat
      end if
      if sPass[tI] is true then
         put tX into tLastX
         put tZ into tLastZ
      end if
   end repeat
   if tHit is empty and tBest is empty then
      uDead.Say "NOTHING THERE", 1
      exit uDead.Command
   end if
   if tHit is empty and tBest is not empty then
      -- nothing in the way: attack
      put uDead.PickZombie(sE[tBest]["x"], sE[tBest]["z"]) into tZomb
      if tZomb is empty then
         uDead.Say "NO ZOMBIE FREE", 1
         exit uDead.Command
      end if
      put "attack" into sE[tZomb]["order"]
      put tBest into sE[tZomb]["target"]
      put empty into sE[tZomb]["rushAt"]
      put 1.2 into sJob["O" & tZomb]["every"]
      put 0 into sJob["O" & tZomb]["at"]
      delete variable sField["O" & tZomb]
      FX.Sparks sE[tBest]["x"] * kM, -1.9 * kM, sE[tBest]["z"] * kM, 8, "#FF3030"
      exit uDead.Command
   end if
   put tLastX into tGX
   put tLastZ into tGZ
   put uDead.PickZombie(tGX, tGZ) into tZomb
   if tZomb is empty then
      uDead.Say "NO ZOMBIE FREE", 1
      exit uDead.Command
   end if
   put "goto" into sE[tZomb]["order"]
   put tGX into sE[tZomb]["gx"]
   put tGZ into sE[tZomb]["gz"]
   put empty into sE[tZomb]["rushAt"]
   put 0 into sJob["O" & tZomb]["every"]
   put 0 into sJob["O" & tZomb]["at"]
   delete variable sField["O" & tZomb]
   FX.Sparks tGX * kM, -0.1 * kM, tGZ * kM, 8, "#58E04A"
end uDead.Command

-- the original's ranking: the nearest zombie, but one just picked (or eating) counts as
-- further away, so each click takes the next one
function uDead.PickZombie pX, pZ
   local tId, tD, tBest, tBestD
   put empty into tBest
   repeat for each line tId in sZ
      if sE[tId]["state"] is not "alive" then next repeat
      put sqrt((sE[tId]["x"] - pX) ^ 2 + (sE[tId]["z"] - pZ) ^ 2) + sE[tId]["penalty"] into tD
      if sE[tId]["busy"] > sNow then add 5 to tD
      if tBest is empty or tD < tBestD then
         put tId into tBest
         put tD into tBestD
      end if
   end repeat
   if tBest is not empty then put 200 into sE[tBest]["penalty"]
   return tBest
end uDead.PickZombie

-------------------------------------------------------------------- winning, losing, HUD

on uDead.CheckEnd
   uDead.Count
   if sState is not "play" then exit uDead.CheckEnd
   if sCountH = 0 then
      put "won" into sState
      put empty into sHUDWas
   else if sCountZ = 0 then
      put "lost" into sState
      put empty into sHUDWas
   end if
end uDead.CheckEnd

-- a short line in the middle of the screen, for pSeconds
on uDead.Say pText, pSeconds
   put toUpper(pText) into sMsg
   put sTicks + round(pSeconds * 1000 / sStepMS) into sMsgUntil
   put empty into sHUDWas
end uDead.Say

-- the HUD is only redrawn when its words change (vector text costs time)
on uDead.ShowHUD
   local tWords, tMid, tTips
   if sMsg is not empty and sTicks >= sMsgUntil then put empty into sMsg
   put sName & "|" & sState & "|" & sMode & "|" & sCountZ & "|" & sCountH & "|" & sSpeed & "|" & sMsg & "|" & sHelp & "|" & sHideHUD into tWords
   if tWords is sHUDWas then exit uDead.ShowHUD
   put tWords into sHUDWas
   HUD.Clear
   if sHideHUD is true and sState is "play" then exit uDead.ShowHUD
   HUD.Set "uDead.Cross", "+", CenterX - 5, CenterY - 8, 14
   HUD.Set "uDead.Title", "UDEAD  " & toUpper(sName) & "  LEVEL " & sLevel, gViewLeft + 20, gViewTop + 120, 12
   HUD.Set "uDead.Count", "DEAD " & sCountZ & "   LIVING " & sCountH, gViewLeft + 20, gViewTop + 142, 16
   if sSpeed < 1 then
      HUD.Set "uDead.Mode", "ORDERS " & sMode & "   ZOMBIE TIME", gViewLeft + 20, gViewTop + 168, 12
   else
      HUD.Set "uDead.Mode", "ORDERS " & sMode, gViewLeft + 20, gViewTop + 168, 12
   end if
   if sState is "won" then
      HUD.Set "uDead.End1", sWinText, gViewLeft + 20, CenterY - 70, 16
   else if sState is "lost" then
      HUD.Set "uDead.End1", sLoseText, gViewLeft + 20, CenterY - 70, 16
   else if sMsg is not empty then
      HUD.Set "uDead.Msg", sMsg, gViewLeft + 20, CenterY - 70, 18
   end if
   if sHelp is true then
      HUD.Set "uDead.H1", "MOUSE LOOK   W A S D MOVE   ARROWS TURN", gViewLeft + 20, gViewBottom - 150, 11
      HUD.Set "uDead.H2", "CLICK THE GROUND: THE NEAREST ZOMBIE GOES THERE", gViewLeft + 20, gViewBottom - 130, 11
      HUD.Set "uDead.H3", "CLICK A PERSON: A ZOMBIE ATTACKS.  CLICK AGAIN FOR MORE ZOMBIES", gViewLeft + 20, gViewBottom - 110, 11
      HUD.Set "uDead.H4", "F FOLLOW ME   H OR SPACE HOLD   R RUSH   Z ZOMBIE TIME", gViewLeft + 20, gViewBottom - 90, 11
      HUD.Set "uDead.H5", "WHITE RUN  YELLOW FIGHT  ORANGE BLUE SHOOT  TAN SOLDIERS THROW  PINK SNIPERS", gViewLeft + 20, gViewBottom - 70, 11
      HUD.Set "uDead.H6", "RED BODIES GET UP AS YOUR DEAD.  L HUD   ESCAPE PAUSE", gViewLeft + 20, gViewBottom - 50, 11
   else
      HUD.Set "uDead.Help", "CLICK SEND   F FOLLOW   H HOLD   R RUSH   Z SLOW   I HELP", gViewLeft + 20, gViewBottom - 30, 11
   end if
end uDead.ShowHUD

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
