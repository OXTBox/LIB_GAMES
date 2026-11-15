######################################################################################
## CARD SCRIPT: "Play.CraterCrawler"   CRATER CRAWLER  (11 14 2026)
## A six-wheel moon rover rolls on across a cratered course, seen from the side, past
## lettered posts A to Z. Jump the craters and the boulders, shoot the saucers before
## their bombs blow new craters in front of you. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/773_Crater_Crawler), script by Claude.
## CONTROLS  Space: jump    Up (or X): fire (one shot up, one ahead)
##           Right/Left (or D/A): roll faster/slower (never stop, never back)
##           Escape: pause
## RULES     falling in a crater, running into a boulder or a bomb: a life, and you go
##           back to the last letter. A crater or boulder jumped: 50. A boulder shot: 100.
##           A saucer: 200. Each letter reached inside 30 seconds earns a time bonus.
##           Five letters a level (the last level runs to Z).
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sRover, sWheel, sDist, sSpeed, sY, sVY, sAir, sSlice, sCourse, sCourseN, sRock, sSaucer
local sShot, sShotN, sBomb, sBombN, sPost, sLetter, sLastLetterD, sSectionT, sLetters
local sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT, sHurt, sMount, sFireWait
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kGroundY = 190      -- the ground line
constant kRoverX = -260      -- where the rover stays on screen
constant kSliceW = 60
constant kSlices = 17
constant kSection = 1800     -- between letters

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
   put "ABCDE,FGHIJ,KLMNO,PQRST,UVWXYZ" into sLetters
   Crater.StartLevel 1
end Game.OnStart

-- Spark's table: rover speed | hazard count | lives
on Crater.StartLevel pLevel
   local tRow, i, tLast
   put pLevel into sLevel
   put line pLevel of ("120,3,3" & cr & "120,4,3" & cr & "120,5,3" & cr & "130,6,2" & cr & "140,7,2") into tRow
   put (item 1 of tRow) / 30 into sSpeed
   if sLives > item 3 of tRow then put item 3 of tRow into sLives
   Scene.ClearAll
   Mesh.Define "Crater.Rover", Crater.RoverMesh()
   Mesh.Define "Crater.Wheel", Crater.WheelMesh()
   Mesh.Define "Crater.Flat", Crater.FlatMesh()
   Mesh.Define "Crater.Hole", Crater.HoleMesh()
   Mesh.Define "Crater.Rock", MeshPyramid(5, 26, 34)
   Mesh.Define "Crater.Saucer", Crater.SaucerMesh()
   Mesh.Define "Crater.Shot", MeshBox(6, 6, 6)
   Mesh.Define "Crater.Bomb", MeshBox(10, 10, 10)
   Mesh.Define "Crater.Post", Crater.PostMesh()
   Mesh.Define "Crater.Mount", Crater.SkylineMesh()
   -- far mountains, slow
   repeat with i = 1 to 3
      put Entity.Spawn("Crater.Mount", 0, kGroundY * 2, kZ * 2, "80,80,140") into sMount[i]
   end repeat
   -- the course: flat ground, craters, rocks; a letter post every section
   put item pLevel of sLetters into sLetter
   put length(sLetter) * kSection into sCourseN
   Crater.MakeCourse item 2 of tRow
   put empty into sSlice
   repeat with i = 0 to kSlices
      put "flat" into sSlice[i]["type"]
      put Entity.Spawn("Crater.Flat", 0, kGroundY, kZ, "170,170,190") into sSlice[i]["key"]
   end repeat
   put Entity.Spawn("Crater.Rover", kRoverX, kGroundY - 26, kZ, "0,230,255") into sRover
   repeat with i = 1 to 6
      put Entity.Spawn("Crater.Wheel", kRoverX, kGroundY - 8, kZ, "0,230,255") into sWheel[i]
   end repeat
   put empty into sSaucer
   put empty into sShot
   put 0 into sShotN
   put empty into sBomb
   put 0 into sBombN
   put empty into sPost
   put 0 into sLastLetterD
   Crater.Respawn 0
   put "POINT" && char 1 of sLetter & ": ROLL OUT" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Crater.StartLevel

-- the slice types, one per kSliceW of course; rocks sit on flat slices
on Crater.MakeCourse pCount
   local i, tN, tGap, tChance
   put empty into sCourse
   put empty into sRock
   put 0 into tGap
   put 6 + pCount * 2 into tChance                       -- percent a slice
   repeat with i = 0 to sCourseN div kSliceW + kSlices + 2
      put "flat" into sCourse[i]
      if i mod (kSection div kSliceW) < 4 then next repeat   -- calm ground at each letter
      if tGap > 0 then
         subtract 1 from tGap
         next repeat
      end if
      put random(100) into tN
      if tN <= tChance then
         put "hole" into sCourse[i]
         if sLevel >= 3 and random(3) is 1 then
            put "hole" into sCourse[i + 1]
            put 4 into tGap
         else
            put 3 into tGap
         end if
      else if tN <= tChance * 2 then
         put i * kSliceW + kSliceW / 2 into sRock[i]["x"]
         put 3 into tGap
      end if
   end repeat
end Crater.MakeCourse

function Crater.RoverMesh
   local tM
   put Mesh.New() into tM
   Crater.AddBox tM, 0, 0, 0, 84, 18, 30
   Crater.AddBox tM, -14, -16, 0, 34, 14, 22
   Mesh.AddVertex tM, 14, -9, 0
   Mesh.AddVertex tM, 28, -30, 0
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]          -- the antenna
   return tM
end Crater.RoverMesh

-- a jagged moon skyline, 1400 wide, its foot at 0
function Crater.SkylineMesh
   local tM, i
   put Mesh.New() into tM
   repeat with i = 0 to 14
      if i is 0 or i is 14 then
         Mesh.AddVertex tM, -700 + i * 100, -20, 0              -- the ends meet the next copy
      else
         Mesh.AddVertex tM, -700 + i * 100, -((i * 37) mod 5) * 60 - (i mod 2) * 90 - 20, 0
      end if
      if i > 0 then Mesh.AddLine tM, i, i + 1
   end repeat
   return tM
end Crater.SkylineMesh

function Crater.WheelMesh
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 7
      put i * 3.14159 / 4 into tA
      Mesh.AddVertex tM, 9 * cos(tA), 9 * sin(tA), 0
   end repeat
   repeat with i = 1 to 8
      Mesh.AddLine tM, i, (i mod 8) + 1
   end repeat
   Mesh.AddLine tM, 1, 5
   return tM
end Crater.WheelMesh

function Crater.FlatMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, 0, 0
   Mesh.AddVertex tM, kSliceW, 0, 0
   Mesh.AddVertex tM, 20, 14, 0
   Mesh.AddVertex tM, 26, 14, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   return tM
end Crater.FlatMesh

-- a crater: the rim, the bowl
function Crater.HoleMesh
   local tM, i
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, 0, 0
   Mesh.AddVertex tM, 8, -6, 0
   Mesh.AddVertex tM, 18, 30, 0
   Mesh.AddVertex tM, 42, 30, 0
   Mesh.AddVertex tM, 52, -6, 0
   Mesh.AddVertex tM, kSliceW, 0, 0
   repeat with i = 1 to 5
      Mesh.AddLine tM, i, i + 1
   end repeat
   return tM
end Crater.HoleMesh

function Crater.SaucerMesh
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 9
      put i * 3.14159 / 5 into tA
      Mesh.AddVertex tM, 30 * cos(tA), 0, 30 * sin(tA)
   end repeat
   repeat with i = 1 to 10
      Mesh.AddLine tM, i, (i mod 10) + 1
   end repeat
   Mesh.AddVertex tM, 0, -14, 0
   repeat with i = 1 to 10 step 3
      Mesh.AddLine tM, i, 11
   end repeat
   return tM
end Crater.SaucerMesh

-- a letter post: a pole and a flag box
function Crater.PostMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, 0, 0
   Mesh.AddVertex tM, 0, -110, 0
   Mesh.AddLine tM, 1, 2
   Crater.AddBox tM, 22, -96, 0, 44, 28, 2
   return tM
end Crater.PostMesh

on Crater.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Crater.AddBox

-- back to a point (the start or the last letter)
on Crater.Respawn pD
   local tK
   put pD into sDist
   put 0 into sVY
   put 0 into sAir
   put kGroundY into sY
   put 0 into sSectionT
   put 50 into sHurt
   put 0 into sFireWait
   repeat for each key tK in sSaucer
      Entity.Kill sSaucer[tK]["key"]
   end repeat
   put empty into sSaucer
   repeat for each key tK in sBomb
      Entity.Kill sBomb[tK]["key"]
   end repeat
   put empty into sBomb
   repeat for each key tK in sRock
      if sRock[tK]["key"] is not empty then
         Entity.Kill sRock[tK]["key"]
         put empty into sRock[tK]["key"]
      end if
   end repeat
   repeat for each key tK in sPost
      Entity.Kill sPost[tK]
   end repeat
   put empty into sPost
end Crater.Respawn

-- screen x of a course distance
function Crater.SX pD
   return kRoverX + (pD - sDist)
end Crater.SX

function Crater.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Crater.Keys

on Crater.TestKeys pKeys
   put pKeys into sTestKeys
end Crater.TestKeys

on Crater.TestLives pN
   put pN into sLives
end Crater.TestLives

function Crater.Down pCode, pKeys
   return pCode is among the items of pKeys
end Crater.Down

on Game.OnUpdate
   local tKeys, tV, i, tD, tIdx, tFrac, tK, tSX, tUnder, tHole
   put Crater.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Crater.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Crater.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- pace: never stop, never back
   put sSpeed into tV
   if Crater.Down(65363, tKeys) or Crater.Down(100, tKeys) then put sSpeed * 1.5 into tV
   if Crater.Down(65361, tKeys) or Crater.Down(97, tKeys) then put sSpeed * 0.6 into tV
   if Crater.Down(32, tKeys) and not (32 is among the items of sKeysWas) and sAir <= 0 then
      put -9.5 into sVY
      put 1 into sAir
   end if
   if sFireWait > 0 then subtract 1 from sFireWait
   if (Crater.Down(65362, tKeys) or Crater.Down(120, tKeys) or Crater.Down(119, tKeys)) and sFireWait <= 0 then
      Crater.Fire 0, -12
      Crater.Fire 14, 0
      put 9 into sFireWait
   end if
   put tKeys into sKeysWas
   add tV to sDist
   add 1 to sSectionT
   if sHurt > 0 then subtract 1 from sHurt
   -- the jump
   if sAir > 0 then
      add sVY to sY
      add 0.6 to sVY
      if sY >= kGroundY then
         put kGroundY into sY
         put 0 into sVY
         put 0 into sAir
      end if
   end if
   -- the ground under the rover: a crater swallows you
   put sDist div kSliceW into tIdx
   put sDist mod kSliceW into tFrac
   if sAir <= 0 and sCourse[tIdx] is "hole" and tFrac > 14 and tFrac < 46 then
      Crater.Lose "INTO A CRATER!"
      exit Game.OnUpdate
   end if
   -- jumped clean over a crater or rock: points
   if sAir > 0 and sCourse[tIdx] is "hole" and tFrac >= 30 and tFrac < 30 + tV then add 50 to sScore
   -- the ground slices
   put sDist - (sDist mod kSliceW) - 2 * kSliceW into tD
   repeat with i = 0 to kSlices
      put (tD div kSliceW) + i into tIdx
      put sCourse[tIdx] into tHole
      if tHole is empty then put "flat" into tHole
      if tHole is not sSlice[i]["type"] then
         Entity.Kill sSlice[i]["key"]
         if tHole is "hole" then
            put Entity.Spawn("Crater.Hole", 0, kGroundY, kZ, "170,170,190") into sSlice[i]["key"]
         else
            put Entity.Spawn("Crater.Flat", 0, kGroundY, kZ, "170,170,190") into sSlice[i]["key"]
         end if
         put tHole into sSlice[i]["type"]
      end if
      SetObjectPosition sSlice[i]["key"], Crater.SX(tIdx * kSliceW), kGroundY, kZ
      -- rocks come into view with their slice
      if sRock[tIdx]["x"] is not empty and sRock[tIdx]["key"] is empty and not sRock[tIdx]["gone"] then
         put Entity.Spawn("Crater.Rock", Crater.SX(sRock[tIdx]["x"]), kGroundY - 17, kZ, "255,150,0") into sRock[tIdx]["key"]
      end if
   end repeat
   -- rocks
   repeat for each key tK in sRock
      if sRock[tK]["key"] is empty then next repeat
      put Crater.SX(sRock[tK]["x"]) into tSX
      if tSX < -520 then
         Entity.Kill sRock[tK]["key"]
         put empty into sRock[tK]["key"]
         put true into sRock[tK]["gone"]
         next repeat
      end if
      SetObjectPosition sRock[tK]["key"], tSX, kGroundY - 17, kZ
      if abs(tSX - kRoverX) < 50 then
         if sY > kGroundY - 40 then
            Crater.Lose "HIT A BOULDER!"
            exit Game.OnUpdate
         else if not sRock[tK]["jumped"] then
            put true into sRock[tK]["jumped"]
            add 50 to sScore
         end if
      end if
   end repeat
   -- the rover and its wheels
   SetObjectPosition sRover, kRoverX, sY - 26, kZ
   repeat with i = 1 to 6
      put sY - 8 into tD
      if sAir <= 0 and (sTicks + i) mod 8 < 2 then subtract 2 from tD
      SetObjectPosition sWheel[i], kRoverX - 36 + (i - 1) * 14.4, tD, kZ - 16 + (i mod 2) * 32
      SetObjectRotation sWheel[i], 0, 0, -sDist / 9
   end repeat
   Crater.Mountains
   Crater.Saucers
   Crater.Shots
   Crater.Bombs
   if sOver then exit Game.OnUpdate
   Crater.Posts
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Crater.ShowHUD
end Game.OnUpdate

on Crater.Mountains
   local i
   repeat with i = 1 to 3
      SetObjectPosition sMount[i], ((i * 1400 - sDist / 2) mod 4200) - 2100, kGroundY * 2, kZ * 2
   end repeat
end Crater.Mountains

-- the letter posts: one at the end of each section
on Crater.Posts
   local tN, tSX
   put sDist div kSection + 1 into tN
   if tN <= length(sLetter) then
      put Crater.SX(tN * kSection) into tSX
      if tSX < 520 and sPost[tN] is empty then
         put Entity.Spawn("Crater.Post", tSX, kGroundY, kZ + 4, "0,255,120") into sPost[tN]
      end if
      if sPost[tN] is not empty then SetObjectPosition sPost[tN], tSX, kGroundY, kZ + 4
   end if
   if sPost[tN - 1] is not empty then SetObjectPosition sPost[tN - 1], Crater.SX((tN - 1) * kSection), kGroundY, kZ + 4
   -- passing a letter
   if (tN - 1) * kSection > sLastLetterD then
      put (tN - 1) * kSection into sLastLetterD
      add max(0, 900 - sSectionT) div 3 + 100 to sScore
      Crater.Say "POINT" && char tN - 1 of sLetter & "!"
      put 0 into sSectionT
      if tN - 1 >= length(sLetter) then
         if sLevel >= 5 then
            put true into sWon
            put true into sOver
            put empty into sHUDWas
            Crater.ShowHUD
         else
            Crater.StartLevel sLevel + 1
         end if
      end if
   end if
end Crater.Posts

-- saucers: from level 1 one at a time, more later; they hover ahead and drop bombs
on Crater.Saucers
   local tK, tN
   put the number of lines of the keys of sSaucer into tN
   if tN < 1 + sLevel div 2 and random(120) is 1 and sDist > 400 then
      put sTicks & random(99) into tK
      put 500 into sSaucer[tK]["x"]
      put -120 - random(100) into sSaucer[tK]["y"]
      put 30 + random(40) into sSaucer[tK]["wait"]
      put Entity.Spawn("Crater.Saucer", 500, sSaucer[tK]["y"], kZ, "255,0,255") into sSaucer[tK]["key"]
   end if
   repeat for each key tK in sSaucer
      -- drift toward a spot ahead of the rover, wobbling
      add (kRoverX + 160 + 120 * sin(sTicks / 30 + tK) - sSaucer[tK]["x"]) * 0.03 to sSaucer[tK]["x"]
      put sSaucer[tK]["y"] + 1.5 * sin(sTicks / 9) into sSaucer[tK]["y"]
      SetObjectPosition sSaucer[tK]["key"], sSaucer[tK]["x"], sSaucer[tK]["y"], kZ
      SetObjectRotation sSaucer[tK]["key"], 0, sTicks / 8, 0
      subtract 1 from sSaucer[tK]["wait"]
      if sSaucer[tK]["wait"] <= 0 then
         put max(25, 80 - sLevel * 10) + random(40) into sSaucer[tK]["wait"]
         add 1 to sBombN
         put sSaucer[tK]["x"] into sBomb[sBombN]["x"]
         put sSaucer[tK]["y"] + 14 into sBomb[sBombN]["y"]
         put Entity.Spawn("Crater.Bomb", sBomb[sBombN]["x"], sBomb[sBombN]["y"], kZ, "255,40,40") into sBomb[sBombN]["key"]
      end if
   end repeat
end Crater.Saucers

on Crater.Fire pVX, pVY
   add 1 to sShotN
   put kRoverX + 20 + pVX into sShot[sShotN]["x"]
   put sY - 40 into sShot[sShotN]["y"]
   put pVX into sShot[sShotN]["vx"]
   put pVY into sShot[sShotN]["vy"]
   put Entity.Spawn("Crater.Shot", sShot[sShotN]["x"], sShot[sShotN]["y"], kZ, "255,255,120") into sShot[sShotN]["key"]
end Crater.Fire

on Crater.Shots
   local tS, tK, tHit
   repeat for each key tS in sShot
      add sShot[tS]["vx"] to sShot[tS]["x"]
      add sShot[tS]["vy"] to sShot[tS]["y"]
      put false into tHit
      if sShot[tS]["vx"] is 0 then
         repeat for each key tK in sSaucer
            if abs(sSaucer[tK]["x"] - sShot[tS]["x"]) < 32 and abs(sSaucer[tK]["y"] - sShot[tS]["y"]) < 16 then
               FX.Sparks sSaucer[tK]["x"], sSaucer[tK]["y"], kZ, 18, "255,0,255"
               Entity.Kill sSaucer[tK]["key"]
               delete variable sSaucer[tK]
               add 200 to sScore
               put true into tHit
               exit repeat
            end if
         end repeat
      else
         -- the forward shot at ground level breaks boulders
         put kGroundY - 18 into sShot[tS]["y"]
         repeat for each key tK in sRock
            if sRock[tK]["key"] is not empty and abs(Crater.SX(sRock[tK]["x"]) - sShot[tS]["x"]) < 24 then
               FX.Sparks sShot[tS]["x"], kGroundY - 17, kZ, 14, "255,150,0"
               Entity.Kill sRock[tK]["key"]
               put empty into sRock[tK]["key"]
               put true into sRock[tK]["gone"]
               add 100 to sScore
               put true into tHit
               exit repeat
            end if
         end repeat
      end if
      if tHit or sShot[tS]["y"] < -320 or sShot[tS]["x"] > 470 or sShot[tS]["x"] > kRoverX + 420 then
         Entity.Kill sShot[tS]["key"]
         delete variable sShot[tS]
      else
         SetObjectPosition sShot[tS]["key"], sShot[tS]["x"], sShot[tS]["y"], kZ
      end if
   end repeat
end Crater.Shots

-- bombs fall; on the ground they blow a new crater (if it's ahead of you)
on Crater.Bombs
   local tB, tIdx
   repeat for each key tB in sBomb
      add 4 + sLevel * 0.5 to sBomb[tB]["y"]
      subtract 0.5 from sBomb[tB]["x"]
      SetObjectPosition sBomb[tB]["key"], sBomb[tB]["x"], sBomb[tB]["y"], kZ
      if abs(sBomb[tB]["x"] - kRoverX) < 44 and abs(sBomb[tB]["y"] - (sY - 20)) < 24 then
         Entity.Kill sBomb[tB]["key"]
         delete variable sBomb[tB]
         Crater.Lose "BOMBED!"
         exit Crater.Bombs
      end if
      if sBomb[tB]["y"] >= kGroundY then
         FX.Sparks sBomb[tB]["x"], kGroundY, kZ, 12, "255,120,40"
         put (sBomb[tB]["x"] - kRoverX + sDist) div kSliceW into tIdx
         if sBomb[tB]["x"] > kRoverX + 90 and sCourse[tIdx - 1] is not "hole" and sCourse[tIdx + 1] is not "hole" and sRock[tIdx]["x"] is empty then put "hole" into sCourse[tIdx]
         Entity.Kill sBomb[tB]["key"]
         delete variable sBomb[tB]
      end if
   end repeat
end Crater.Bombs

on Crater.Lose pWhy
   if sHurt > 0 then exit Crater.Lose
   subtract 1 from sLives
   FX.Sparks kRoverX, sY - 20, kZ, 26, "255,80,80"
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Crater.Say pWhy
      Crater.ShowHUD
      exit Crater.Lose
   end if
   Crater.Respawn sLastLetterD
   Crater.Say pWhy && "BACK TO THE LAST POINT"
end Crater.Lose

on Crater.Say pText
   put pText into sMsg
   put 50 into sMsgT
   put empty into sHUDWas
end Crater.Say

on Crater.ShowHUD
   local tWords, tLine, tN
   put min(length(sLetter), sDist div kSection + 1) into tN
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & tN & "|" & sSectionT div 30 & "|" & sMsg into tWords
   if tWords is sHUDWas then exit Crater.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Crater.Score", "SCORE" && sScore && " LIVES" && sLives && " NEXT POINT" && char tN of sLetter && " TIME" && sSectionT div 30, 20, 40, 14
   if sOver and sWon then
      put "POINT Z! THE CRATER COURSE IS YOURS.  SPACE TO RUN AGAIN" into tLine
   else if sOver then
      put sMsg && "GAME OVER.  SPACE TO RUN AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else
      put "SPACE JUMP   UP FIRE" into tLine
   end if
   HUD.Set "Crater.Msg", tLine, 20, 70, 12
end Crater.ShowHUD

function Crater.State
   return sLevel & "|" & sLives & "|" & sScore & "|d " & round(sDist) & "/" & sCourseN & "|y " & round(sY) & "|saucers " & the number of lines of the keys of sSaucer & "|bombs " & the number of lines of the keys of sBomb & "|" & sOver
end Crater.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
