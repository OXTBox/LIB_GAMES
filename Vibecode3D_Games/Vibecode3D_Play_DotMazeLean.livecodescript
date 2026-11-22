######################################################################################
## CARD SCRIPT: "Play.DotMazeLean"   DOT MAZE LEAN  (11 21 2026)
## Dot Maze made lean: the walls are one outline drawing and the dots another, 30 fps
## (the original Dot Maze drew 256 boxes, 7 fps). Same rules and maze. Spark's concept and
## level numbers (LIB_SPARK/arcade/out/08_Dot_Maze); the steps are in DotMaze/PERF.md.
## CONTROLS  arrows: choose a direction (you keep going until a wall)    Escape: pause
## RULES     a chaser on you costs a life; three lives. All dots: the next level,
##           with more and faster chasers. 5 levels.
######################################################################################

global bPaused, bPlaying

local sMaze, sDot, sDots, sYou, sC, sR, sDC, sDR, sWantC, sWantR, sT
local sChaser, sLevel, sLives, sScore, sYouEvery, sChaseEvery, sOver, sTestKeys, sHUDWas
local sFPS, sFPSN, sFPSAt, sFPSWas

constant kZ = 600
constant kCell = 40
constant kCols = 19
constant kRows = 13

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   -- # wall, . dot, space: nothing. Symmetric left to right, every corridor joins up.
   put "###################" & cr & \
         "#........#........#" & cr & \
         "#.##.###.#.###.##.#" & cr & \
         "#.................#" & cr & \
         "#.##.#.#####.#.##.#" & cr & \
         "#....#...#...#....#" & cr & \
         "####.###   ###.####" & cr & \
         "#....#...#...#....#" & cr & \
         "#.##.#.#####.#.##.#" & cr & \
         "#.................#" & cr & \
         "#.##.###.#.###.##.#" & cr & \
         "#........#........#" & cr & \
         "###################" into sMaze
   Maze.StartLevel 1
end Game.OnStart

function Maze.X pC
   return (pC - (kCols + 1) / 2) * kCell
end Maze.X

function Maze.Y pR
   return (pR - (kRows + 1) / 2) * kCell
end Maze.Y

function Maze.Open pC, pR
   if pC < 1 or pC > kCols or pR < 1 or pR > kRows then return false
   return (char pC of line pR of sMaze is not "#")
end Maze.Open

-- PERF step 1: every wall is ONE mesh of loose lines (was one 12-edge box entity a cell, 136 of them).
-- Only the outline of each wall block is drawn, a straight run of edges as one line, at the front
-- (z -8) and the back (z +8) of where the boxes were, so the walls keep their depth.
function Maze.Wall pC, pR
   if pC < 1 or pC > kCols or pR < 1 or pR > kRows then return false
   return (char pC of line pR of sMaze is "#")
end Maze.Wall

-- corner i is the right edge of column i (0 = the left edge of column 1); likewise rows
function Maze.CornerX pN
   return (pN + 0.5 - (kCols + 1) / 2) * kCell
end Maze.CornerX

function Maze.CornerY pJ
   return (pJ + 0.5 - (kRows + 1) / 2) * kCell
end Maze.CornerY

command Maze.AddSeg @pMesh, pX1, pY1, pX2, pY2, pZ
   local tA
   Mesh.AddVertex pMesh, pX1, pY1, pZ
   put the result into tA
   Mesh.AddVertex pMesh, pX2, pY2, pZ
   Mesh.AddLine pMesh, tA, the result
end Maze.AddSeg

command Maze.BuildWalls
   local tMesh, tZs, tZ, tI, tJ, tStart, tOn
   put Mesh.New() into tMesh
   put "-8,8" into tZs
   repeat for each item tZ in tZs
      -- across: line j lies between row j and row j+1
      repeat with tJ = 0 to kRows
         put empty into tStart
         repeat with tI = 1 to kCols + 1
            put false into tOn
            if tI <= kCols then put (Maze.Wall(tI, tJ) is not Maze.Wall(tI, tJ + 1)) into tOn
            if tOn and tStart is empty then put tI - 1 into tStart
            if not tOn and tStart is not empty then
               Maze.AddSeg tMesh, Maze.CornerX(tStart), Maze.CornerY(tJ), Maze.CornerX(tI - 1), Maze.CornerY(tJ), tZ
               put empty into tStart
            end if
         end repeat
      end repeat
      -- down: line i lies between column i and column i+1
      repeat with tI = 0 to kCols
         put empty into tStart
         repeat with tJ = 1 to kRows + 1
            put false into tOn
            if tJ <= kRows then put (Maze.Wall(tI, tJ) is not Maze.Wall(tI + 1, tJ)) into tOn
            if tOn and tStart is empty then put tJ - 1 into tStart
            if not tOn and tStart is not empty then
               Maze.AddSeg tMesh, Maze.CornerX(tI), Maze.CornerY(tStart), Maze.CornerX(tI), Maze.CornerY(tJ - 1), tZ
               put empty into tStart
            end if
         end repeat
      end repeat
   end repeat
   Mesh.Define "Maze.Walls", tMesh
end Maze.BuildWalls

-- PERF step 2: every dot is in ONE mesh (was one 12-edge box entity a dot, 120 of them): a small
-- square of 4 lines a dot, the front of the old 6x6x6 box. Eating a dot builds the mesh again
-- (Mesh.Define replaces it; the one "Maze.Dots" object draws the new one).
command Maze.BuildDots
   local tMesh, tKey, tX, tY, tA
   put Mesh.New() into tMesh
   repeat for each key tKey in sDot
      put Maze.X(item 1 of tKey) into tX
      put Maze.Y(item 2 of tKey) into tY
      Mesh.AddVertex tMesh, tX - 3, tY - 3, -3
      put the result into tA
      Mesh.AddVertex tMesh, tX + 3, tY - 3, -3
      Mesh.AddVertex tMesh, tX + 3, tY + 3, -3
      Mesh.AddVertex tMesh, tX - 3, tY + 3, -3
      Mesh.AddLine tMesh, tA, tA + 1
      Mesh.AddLine tMesh, tA + 1, tA + 2
      Mesh.AddLine tMesh, tA + 2, tA + 3
      Mesh.AddLine tMesh, tA + 3, tA
   end repeat
   Mesh.Define "Maze.Dots", tMesh
end Maze.BuildDots

-- frames a second, counted by the game itself. The engine runs the game a fixed 30 steps a
-- second and draws once per tick; when drawing is slow it runs the missed steps back to back
-- (a few ms apart), while the Game Player waits 33 ms after each frame: a step 20 ms or more after
-- the last one starts a new frame.
command Maze.CountFPS
   local tNow
   put the milliseconds into tNow
   if sFPSAt is empty then put tNow into sFPSAt
   if tNow - sFPSWas >= 20 then add 1 to sFPSN
   put tNow into sFPSWas
   if tNow - sFPSAt >= 1000 then
      put round(sFPSN * 1000 / (tNow - sFPSAt)) into sFPS
      put 0 into sFPSN
      put tNow into sFPSAt
      HUD.Set "Maze.FPS", "FPS" && sFPS, 20, 150, 14
   end if
end Maze.CountFPS

function Maze.FPS
   return sFPS
end Maze.FPS

-- Spark's table: chasers | chaser steps a move | your steps a move
on Maze.StartLevel pLevel
   local tRow, tR, tC, tN, tAt
   put pLevel into sLevel
   put line pLevel of ("2,9,6" & cr & "2,8,6" & cr & "3,8,6" & cr & "3,7,5" & cr & "4,6,5") into tRow
   put item 2 of tRow into sChaseEvery
   put item 3 of tRow into sYouEvery
   Scene.ClearAll
   Maze.BuildWalls
   Mesh.Define "Maze.You", Mesh.Prism(8, 14, 12)
   Mesh.Define "Maze.Chaser", Mesh.Pyramid(4, 16, 22)
   put empty into sDot
   put 0 into sDots
   repeat with tR = 1 to kRows
      repeat with tC = 1 to kCols
         if char tC of line tR of sMaze is "." then
            put true into sDot[tC & comma & tR]
            add 1 to sDots
         end if
      end repeat
   end repeat
   get Entity.Spawn("Maze.Walls", 0, 0, kZ, "#3F6FB0")
   Maze.BuildDots
   get Entity.Spawn("Maze.Dots", 0, 0, kZ, "yellow")
   put Entity.Spawn("Maze.You", 0, 0, kZ, "white") into sYou
   put empty into sChaser
   repeat with tN = 1 to item 1 of tRow
      put item (tN * 2 - 1) of "2,2,18,2,2,12,18,12" into sChaser[tN]["c"]
      put item (tN * 2) of "2,2,18,2,2,12,18,12" into sChaser[tN]["r"]
      put 0 into sChaser[tN]["dc"]
      put 0 into sChaser[tN]["dr"]
      put Entity.Spawn("Maze.Chaser", 0, 0, kZ, item tN of "red,magenta,orange,green") into sChaser[tN]["key"]
   end repeat
   Maze.Reset
end Maze.StartLevel

-- you in the middle, the chasers in their corners
on Maze.Reset
   local tN
   put 10 into sC
   put 7 into sR
   put 0 into sDC
   put 0 into sDR
   put 0 into sWantC
   put 0 into sWantR
   put 0 into sT
   repeat for each key tN in sChaser
      put item (tN * 2 - 1) of "2,2,18,2,2,12,18,12" into sChaser[tN]["c"]
      put item (tN * 2) of "2,2,18,2,2,12,18,12" into sChaser[tN]["r"]
      Entity.SetPosition sChaser[tN]["key"], Maze.X(sChaser[tN]["c"]), Maze.Y(sChaser[tN]["r"]), kZ
   end repeat
   Entity.SetPosition sYou, Maze.X(sC), Maze.Y(sR), kZ
   put empty into sHUDWas
end Maze.Reset

function Maze.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Maze.Keys

on Maze.TestKeys pKeys
   put pKeys into sTestKeys
end Maze.TestKeys

on Game.OnUpdate
   local tKeys, tN, tBest, tBestD, tDir, tDC, tDR, tD
   Maze.CountFPS
   put Maze.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Maze.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then
      put -1 into sWantC
      put 0 into sWantR
   end if
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then
      put 1 into sWantC
      put 0 into sWantR
   end if
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then
      put 0 into sWantC
      put -1 into sWantR
   end if
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then
      put 0 into sWantC
      put 1 into sWantR
   end if
   add 1 to sT
   if sT mod sYouEvery = 0 then
      -- turn as soon as the way you want is open; else keep going
      if (sWantC is not 0 or sWantR is not 0) and Maze.Open(sC + sWantC, sR + sWantR) then
         put sWantC into sDC
         put sWantR into sDR
      end if
      if Maze.Open(sC + sDC, sR + sDR) then
         add sDC to sC
         add sDR to sR
      end if
      Entity.SetPosition sYou, Maze.X(sC), Maze.Y(sR), kZ
      if sDot[sC & comma & sR] is not empty then
         delete variable sDot[sC & comma & sR]
         Maze.BuildDots
         subtract 1 from sDots
         add 10 to sScore
         put empty into sHUDWas
      end if
   end if
   if sT mod sChaseEvery = 0 then
      repeat for each key tN in sChaser
         -- at each cell: the open way that brings it nearest to you, never straight back
         put empty into tBest
         repeat for each word tDir in "1,0 -1,0 0,1 0,-1"
            put item 1 of tDir into tDC
            put item 2 of tDir into tDR
            if tDC = -sChaser[tN]["dc"] and tDR = -sChaser[tN]["dr"] and (tDC is not 0 or tDR is not 0) then next repeat
            if not Maze.Open(sChaser[tN]["c"] + tDC, sChaser[tN]["r"] + tDR) then next repeat
            put abs(sChaser[tN]["c"] + tDC - sC) + abs(sChaser[tN]["r"] + tDR - sR) + random(3) - 1 into tD
            if tBest is empty or tD < tBestD then
               put tDir into tBest
               put tD into tBestD
            end if
         end repeat
         if tBest is empty then put (-sChaser[tN]["dc"]) & comma & (-sChaser[tN]["dr"]) into tBest
         put item 1 of tBest into sChaser[tN]["dc"]
         put item 2 of tBest into sChaser[tN]["dr"]
         add sChaser[tN]["dc"] to sChaser[tN]["c"]
         add sChaser[tN]["dr"] to sChaser[tN]["r"]
         Entity.SetPosition sChaser[tN]["key"], Maze.X(sChaser[tN]["c"]), Maze.Y(sChaser[tN]["r"]), kZ
      end repeat
   end if
   repeat for each key tN in sChaser
      if sChaser[tN]["c"] = sC and sChaser[tN]["r"] = sR then
         subtract 1 from sLives
         FX.Sparks Maze.X(sC), Maze.Y(sR), kZ, 12, "red"
         if sLives <= 0 then put true into sOver
         Maze.Reset
         exit repeat
      end if
   end repeat
   if sDots <= 0 then
      if sLevel >= 5 then
         put true into sOver
         put empty into sHUDWas
      else
         Maze.StartLevel sLevel + 1
      end if
   end if
   Maze.ShowHUD
end Game.OnUpdate

on Maze.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Maze.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Maze.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  DOTS" && sDots, 20, 120, 14
   HUD.Remove "Maze.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Maze.Msg", "EVERY DOT IS YOURS.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Maze.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Maze.ShowHUD

function Maze.State
   return "fps " & sFPS & "|" & sLevel & "|" & sLives & "|" & sScore & "|dots " & sDots & "|you " & sC & "," & sR & "|chaser1 " & sChaser[1]["c"] & "," & sChaser[1]["r"] & "|" & sOver
end Maze.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
