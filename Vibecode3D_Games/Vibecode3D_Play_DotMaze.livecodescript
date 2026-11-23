######################################################################################
## CARD SCRIPT: "Play.DotMaze"   DOT MAZE  (11 13 2026)
## Collect every dot in the maze while the chasers hunt you. Spark's concept and level
## numbers (LIB_SPARK/arcade/out/08_Dot_Maze), script corrected by Claude. The maze is
## our own.
## CONTROLS  arrows: choose a direction (you keep going until a wall)    Escape: pause
## RULES     a chaser on you costs a life; three lives. All dots: the next level,
##           with more and faster chasers. 5 levels.
######################################################################################

global bPaused, bPlaying

local sMaze, sDot, sDots, sYou, sC, sR, sDC, sDR, sWantC, sWantR, sT
local sChaser, sLevel, sLives, sScore, sYouEvery, sChaseEvery, sOver, sTestKeys, sHUDWas

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

-- Spark's table: chasers | chaser steps a move | your steps a move
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Maze.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Maze.StartLevel pLevel
   end if
end Maze.GoLevel

on Maze.StartLevel pLevel
   local tRow, tR, tC, tN, tAt
   put pLevel into sLevel
   put line pLevel of ("2,9,6" & cr & "2,8,6" & cr & "3,8,6" & cr & "3,7,5" & cr & "4,6,5") into tRow
   put item 2 of tRow into sChaseEvery
   put item 3 of tRow into sYouEvery
   Scene.ClearAll
   Mesh.Define "Maze.Wall", Mesh.Box(kCell - 4, kCell - 4, 16)
   Mesh.Define "Maze.Dot", Mesh.Box(6, 6, 6)
   Mesh.Define "Maze.You", Mesh.Prism(8, 14, 12)
   Mesh.Define "Maze.Chaser", Mesh.Pyramid(4, 16, 22)
   put empty into sDot
   put 0 into sDots
   repeat with tR = 1 to kRows
      repeat with tC = 1 to kCols
         if char tC of line tR of sMaze is "#" then
            get Entity.Spawn("Maze.Wall", Maze.X(tC), Maze.Y(tR), kZ, "#3F6FB0")
         else if char tC of line tR of sMaze is "." then
            put Entity.Spawn("Maze.Dot", Maze.X(tC), Maze.Y(tR), kZ, "yellow") into sDot[tC & comma & tR]
            add 1 to sDots
         end if
      end repeat
   end repeat
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
   put Maze.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Maze.GoLevel 1
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
         Entity.Kill sDot[sC & comma & sR]
         delete variable sDot[sC & comma & sR]
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
         Maze.GoLevel sLevel + 1
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
   return sLevel & "|" & sLives & "|" & sScore & "|dots " & sDots & "|you " & sC & "," & sR & "|chaser1 " & sChaser[1]["c"] & "," & sChaser[1]["r"] & "|" & sOver
end Maze.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
