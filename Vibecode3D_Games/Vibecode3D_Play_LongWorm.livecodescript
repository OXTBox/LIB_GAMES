######################################################################################
## CARD SCRIPT: "Play.LongWorm"   LONG WORM  (11 13 2026)
## A worm on a grid that never stops. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/03_Long_Worm), script corrected by Claude.
## CONTROLS  arrows: turn    Space: start again after the end    Escape: pause
## RULES     each food makes the worm one cell longer. A wall or your own body costs
##           a life; three lives. Eat the level's food to move on. 5 levels.
######################################################################################

global bPaused, bPlaying

local sBody, sKeys, sLen, sDC, sDR, sWantC, sWantR, sGrow, sFood, sFoodKey, sWall
local sLevel, sLives, sEaten, sNeed, sEvery, sTick, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kCols = 30
constant kRows = 20
constant kCell = 30

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put false into sOver
   Worm.StartLevel 1
end Game.OnStart

function Worm.X pC
   return (pC - (kCols + 1) / 2) * kCell
end Worm.X

function Worm.Y pR
   return (pR - (kRows + 1) / 2) * kCell
end Worm.Y

-- Spark's table: steps per move | food to finish | start length | wall blocks
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Worm.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Worm.StartLevel pLevel
   end if
end Worm.GoLevel

on Worm.StartLevel pLevel
   local tRow, tN, tC, tR, tWalls
   put pLevel into sLevel
   put line pLevel of ("7,5,3,0" & cr & "6,6,3,4" & cr & "5,7,4,8" & cr & "4,8,4,12" & cr & "3,10,5,16") into tRow
   put item 1 of tRow into sEvery
   put item 2 of tRow into sNeed
   put item 3 of tRow into sLen
   put item 4 of tRow into tWalls
   Scene.ClearAll
   Mesh.Define "Worm.Seg", Mesh.Box(kCell - 6, kCell - 6, 14)
   Mesh.Define "Worm.Food", Mesh.Box(14, 14, 14)
   Mesh.Define "Worm.Wall", Mesh.Box(kCell - 2, kCell - 2, 20)
   Mesh.Define "Worm.Rim", Mesh.Box(kCols * kCell + 8, kRows * kCell + 8, 4)
   get Entity.Spawn("Worm.Rim", 0, 0, kZ, "#2E6F8E")
   -- walls: the same places every time for a level, never on the worm's row
   put empty into sWall
   repeat with tN = 1 to tWalls
      put 4 + (tN * 7 + pLevel * 3) mod (kCols - 8) into tC
      put 2 + (tN * 5 + pLevel) mod (kRows - 4) into tR
      if tR = 10 then add 1 to tR
      put true into sWall[tC & comma & tR]
      get Entity.Spawn("Worm.Wall", Worm.X(tC), Worm.Y(tR), kZ, "red")
   end repeat
   -- the worm: head first, on row 10, heading right
   put empty into sBody
   put empty into sKeys
   repeat with tN = 1 to sLen
      put (6 - tN) & comma & 10 into line tN of sBody
      put Entity.Spawn("Worm.Seg", Worm.X(6 - tN), Worm.Y(10), kZ, "green") into line tN of sKeys
   end repeat
   put 1 into sDC
   put 0 into sDR
   put 1 into sWantC
   put 0 into sWantR
   put 0 into sGrow
   put 0 into sEaten
   put 0 into sTick
   put Entity.Spawn("Worm.Food", 0, 0, kZ, "yellow") into sFoodKey
   Worm.PlaceFood
   put empty into sHUDWas
end Worm.StartLevel

on Worm.PlaceFood
   local tTry, tC, tR
   repeat with tTry = 1 to 200
      put random(kCols) into tC
      put random(kRows) into tR
      if sWall[tC & comma & tR] is true then next repeat
      if (tC & comma & tR) is among the lines of sBody then next repeat
      exit repeat
   end repeat
   put tC & comma & tR into sFood
   Entity.SetPosition sFoodKey, Worm.X(tC), Worm.Y(tR), kZ
end Worm.PlaceFood

function Worm.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Worm.Keys

on Worm.TestKeys pKeys
   put pKeys into sTestKeys
end Worm.TestKeys

on Game.OnUpdate
   local tKeys, tC, tR, tHead, tTail
   put Worm.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put false into sOver
         Worm.GoLevel 1
      end if
      exit Game.OnUpdate
   end if
   -- a turn is remembered until the next move; never straight back
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) and sDC = 0 then
      put -1 into sWantC
      put 0 into sWantR
   end if
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) and sDC = 0 then
      put 1 into sWantC
      put 0 into sWantR
   end if
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) and sDR = 0 then
      put 0 into sWantC
      put -1 into sWantR
   end if
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) and sDR = 0 then
      put 0 into sWantC
      put 1 into sWantR
   end if
   add 1 to sTick
   if sTick < sEvery then exit Game.OnUpdate
   put 0 into sTick
   put sWantC into sDC
   put sWantR into sDR
   put item 1 of line 1 of sBody + sDC into tC
   put item 2 of line 1 of sBody + sDR into tR
   put tC & comma & tR into tHead
   if tC < 1 or tC > kCols or tR < 1 or tR > kRows or sWall[tHead] is true or tHead is among the lines of sBody then
      subtract 1 from sLives
      FX.Sparks Worm.X(tC), Worm.Y(tR), kZ, 12, "red"
      if sLives <= 0 then
         put true into sOver
         put empty into sHUDWas
      else
         Worm.StartLevel sLevel
      end if
      Worm.ShowHUD
      exit Game.OnUpdate
   end if
   if sGrow > 0 then
      -- longer: a new piece at the head
      subtract 1 from sGrow
      put tHead & cr before sBody
      put Entity.Spawn("Worm.Seg", Worm.X(tC), Worm.Y(tR), kZ, "green") & cr before sKeys
   else
      -- the same length: the tail piece becomes the head
      put the last line of sKeys into tTail
      delete the last line of sBody
      delete the last line of sKeys
      put tHead & cr before sBody
      put tTail & cr before sKeys
      Entity.SetPosition tTail, Worm.X(tC), Worm.Y(tR), kZ
   end if
   if tHead is sFood then
      add 1 to sEaten
      add 1 to sGrow
      put empty into sHUDWas
      if sEaten >= sNeed then
         if sLevel >= 5 then
            put true into sOver
         else
            Worm.GoLevel sLevel + 1
         end if
      else
         Worm.PlaceFood
      end if
   end if
   Worm.ShowHUD
end Game.OnUpdate

on Worm.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sEaten & "|" & sOver into tWords
   if tWords is sHUDWas then exit Worm.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Worm.Score", "FOOD" && sEaten & "/" & sNeed && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Worm.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Worm.Msg", "THE WORM IS FULL.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Worm.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Worm.ShowHUD

function Worm.State
   return sLevel & "|" & sLives & "|" & sEaten & "/" & sNeed & "|head " & line 1 of sBody & "|len " & the number of lines of sBody & "|food " & sFood & "|" & sOver
end Worm.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
