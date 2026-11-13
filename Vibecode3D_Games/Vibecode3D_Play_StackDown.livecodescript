######################################################################################
## CARD SCRIPT: "Play.StackDown"   STACK DOWN  (11 13 2026)
## Shapes of four blocks fall into a well. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/09_Stack_Down), script corrected by Claude.
## CONTROLS  Left/Right arrows: slide    Up: turn    Down: drop faster    Escape: pause
## RULES     a full row disappears and scores. Clear the level's rows to move on; the
##           next level starts with junk in the well and falls faster. The well filled
##           to the top ends the game. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sWell, sCellKey, sShape, sPC, sPR, sPieceKeys, sColor, sWas, sT, sEvery
local sLevel, sRows, sNeed, sScore, sPerRow, sOver, sWon, sTestKeys, sHUDWas

constant kZ = 600
constant kCols = 10
constant kRows = 18
constant kCell = 30

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put false into sOver
   put false into sWon
   Stack.StartLevel 1
end Game.OnStart

function Stack.X pC
   return (pC - (kCols + 1) / 2) * kCell
end Stack.X

function Stack.Y pR
   return (pR - (kRows + 1) / 2) * kCell
end Stack.Y

-- Spark's table: steps per drop | rows to finish | start junk rows | points per row
on Stack.StartLevel pLevel
   local tRow, tR, tC, tGap
   put pLevel into sLevel
   put line pLevel of ("20,4,0,100" & cr & "16,5,1,150" & cr & "12,6,2,200" & cr & "9,7,3,250" & cr & "6,8,4,300") into tRow
   put item 1 of tRow into sEvery
   put item 2 of tRow into sNeed
   put item 4 of tRow into sPerRow
   put 0 into sRows
   put empty into sWell
   -- junk rows at the bottom, each with one gap
   repeat with tR = kRows - item 3 of tRow + 1 to kRows
      put (tR * 3 + pLevel) mod kCols + 1 into tGap
      repeat with tC = 1 to kCols
         if tC is not tGap then put "#8A8A8A" into sWell[tC & comma & tR]
      end repeat
   end repeat
   Stack.Draw
   Stack.NewPiece
end Stack.StartLevel

-- redraw the whole well (only when something lands or a row goes)
on Stack.Draw
   local tAt
   Scene.ClearAll
   Mesh.Define "Stack.Block", MeshBox(kCell - 4, kCell - 4, 14)
   Mesh.Define "Stack.Well", MeshBox(kCols * kCell + 8, kRows * kCell + 8, 4)
   get Entity.Spawn("Stack.Well", 0, 0, kZ, "#2E6F8E")
   repeat for each key tAt in sWell
      get Entity.Spawn("Stack.Block", Stack.X(item 1 of tAt), Stack.Y(item 2 of tAt), kZ, sWell[tAt])
   end repeat
   put empty into sPieceKeys
   put empty into sHUDWas
end Stack.Draw

-- a shape is four cells as dc,dr around its turning point
on Stack.NewPiece
   local tN, tCell
   put random(7) into tN
   put line tN of ("-1,0 0,0 1,0 2,0" & cr & "0,0 1,0 0,1 1,1" & cr & "-1,0 0,0 1,0 0,1" & cr & \
         "-1,0 0,0 1,0 1,1" & cr & "-1,0 0,0 1,0 -1,1" & cr & "-1,0 0,0 0,1 1,1" & cr & "0,0 1,0 -1,1 0,1") into sShape
   put item tN of "cyan,yellow,magenta,orange,#5A9CFF,red,green" into sColor
   put 5 into sPC
   put 1 into sPR
   put 0 into sT
   if not Stack.Fits(sShape, sPC, sPR) then
      put true into sOver
      put empty into sHUDWas
      exit Stack.NewPiece
   end if
   put empty into sPieceKeys
   repeat for each word tCell in sShape
      put Entity.Spawn("Stack.Block", 0, 0, kZ, sColor) & cr after sPieceKeys
   end repeat
   Stack.ShowPiece
end Stack.NewPiece

on Stack.ShowPiece
   local tN, tCell
   put 0 into tN
   repeat for each word tCell in sShape
      add 1 to tN
      SetObjectPosition line tN of sPieceKeys, Stack.X(sPC + item 1 of tCell), Stack.Y(sPR + item 2 of tCell), kZ
   end repeat
end Stack.ShowPiece

function Stack.Fits pShape, pC, pR
   local tCell, tC, tR
   repeat for each word tCell in pShape
      put pC + item 1 of tCell into tC
      put pR + item 2 of tCell into tR
      if tC < 1 or tC > kCols or tR > kRows then return false
      if sWell[tC & comma & tR] is not empty then return false
   end repeat
   return true
end Stack.Fits

-- a quarter turn: dc,dr becomes -dr,dc
function Stack.Turned pShape
   local tCell, tOut
   repeat for each word tCell in pShape
      put (-(item 2 of tCell)) & comma & item 1 of tCell & space after tOut
   end repeat
   return word 1 to -1 of tOut
end Stack.Turned

function Stack.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Stack.Keys

on Stack.TestKeys pKeys
   put pKeys into sTestKeys
end Stack.TestKeys

-- true when a key goes down, and again every 5 steps while it is held
function Stack.Pressed pKey, pKeys
   if pKey is not among the items of pKeys then
      put 0 into sWas[pKey]
      return false
   end if
   add 1 to sWas[pKey]
   return (sWas[pKey] = 1 or sWas[pKey] > 8 and sWas[pKey] mod 4 = 0)
end Stack.Pressed

on Game.OnUpdate
   local tKeys, tTry, tFast
   put Stack.Keys() into tKeys
   if sOver then
      if Stack.Pressed(32, tKeys) then
         put 0 into sScore
         put false into sOver
         put false into sWon
         Stack.StartLevel 1
      end if
      Stack.ShowHUD
      exit Game.OnUpdate
   end if
   if Stack.Pressed(65361, tKeys) then
      if Stack.Fits(sShape, sPC - 1, sPR) then subtract 1 from sPC
   end if
   if Stack.Pressed(65363, tKeys) then
      if Stack.Fits(sShape, sPC + 1, sPR) then add 1 to sPC
   end if
   if Stack.Pressed(65362, tKeys) then
      put Stack.Turned(sShape) into tTry
      if Stack.Fits(tTry, sPC, sPR) then put tTry into sShape
   end if
   put (65364 is among the items of tKeys) into tFast
   add 1 to sT
   if sT >= sEvery or tFast and sT >= 2 then
      put 0 into sT
      if Stack.Fits(sShape, sPC, sPR + 1) then
         add 1 to sPR
      else
         Stack.Land
         exit Game.OnUpdate
      end if
   end if
   Stack.ShowPiece
   Stack.ShowHUD
end Game.OnUpdate

-- the shape becomes part of the well; full rows go, everything above moves down
on Stack.Land
   local tCell, tR, tC, tFull, tGone, tNew, tAt, tUp
   repeat for each word tCell in sShape
      put sColor into sWell[(sPC + item 1 of tCell) & comma & (sPR + item 2 of tCell)]
   end repeat
   put 0 into tGone
   put kRows into tR
   repeat while tR >= 1
      put true into tFull
      repeat with tC = 1 to kCols
         if sWell[tC & comma & tR] is empty then
            put false into tFull
            exit repeat
         end if
      end repeat
      if tFull then
         add 1 to tGone
         repeat with tUp = tR down to 1
            repeat with tC = 1 to kCols
               if tUp > 1 and sWell[tC & comma & (tUp - 1)] is not empty then
                  put sWell[tC & comma & (tUp - 1)] into sWell[tC & comma & tUp]
               else
                  delete variable sWell[tC & comma & tUp]
               end if
            end repeat
         end repeat
      else
         subtract 1 from tR
      end if
   end repeat
   add tGone * sPerRow to sScore
   add tGone to sRows
   Stack.Draw
   if sRows >= sNeed then
      if sLevel >= 5 then
         put true into sOver
         put true into sWon
      else
         Stack.StartLevel sLevel + 1
      end if
   else
      Stack.NewPiece
   end if
   Stack.ShowHUD
end Stack.Land

on Stack.ShowHUD
   local tWords
   put sLevel & "|" & sRows & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Stack.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Stack.Score", "SCORE" && sScore && "  ROWS" && sRows & "/" & sNeed && "  LEVEL" && sLevel, 20, 20, 14
   HUD.Remove "Stack.Msg"
   if sOver and sWon then
      HUD.Set "Stack.Msg", "THE WELL IS BEATEN.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Stack.Msg", "THE WELL IS FULL.  SPACE TO PLAY AGAIN", 220, 300, 16
   end if
end Stack.ShowHUD

function Stack.State
   return sLevel & "|rows " & sRows & "/" & sNeed & "|" & sScore & "|piece " & sPC & "," & sPR & "|blocks " & the number of lines of the keys of sWell & "|" & sOver
end Stack.State

on Game.OnStop
   HUD.Clear
end Game.OnStop
