######################################################################################
## CARD SCRIPT: "Play.PromptAndGlazeMaze"   PROMPT AND GLAZE MAZE  (11 13 2026)
## The owner's concept (round two, 5 of 9): two agents, PROMPT and GLAZE, collect every
## energy dot in a maze while patrols chase them. A powerup gives a polyhedron to throw: it
## bounces around corners and loses a side at every strike until it is gone. Thrown by
## GLAZE it charms patrols (they follow you, harmless, for a few seconds); thrown by PROMPT
## it de-rezzes them.
## Teaches: grid movement, chasing, a projectile that bounces.
## CONTROLS  Arrows: move   Space: throw (when you hold a polyhedron)   Tab: swap agents
## RULES     a patrol touching either agent costs a life. Collect every dot. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sDotsKey, sMap, sDots, sDotsLeft, sAgent, sActive, sFoe, sFoeCount, sPoly, sHeld
local sLevel, sLives, sScore, sFoeSpeed, sOver, sWon, sTicks, sTestKeys, sKeysWas, sHUDWas, sPause

constant kZ = 360
constant kCell = 40
constant kAgentSpeed = 0.125      -- cells a step
constant kMaze = "###################|#P.......#.......G#|#.##.###.#.###.##.#|#o...............o#|#.##.#.#####.#.##.#|#....#...#...#....#|####.###.#.###.####|#.......E E.......#|#.##.#.#####.#.##.#|#o.#.....E.....#.o#|##.#.#.#####.#.#.##|#....#...#...#....#|###################"
constant kNames = "PROMPT,GLAZE"
constant kColors = "#FF5050,#40FF80"

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 0 into sScore
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Maze.StartLevel
end Game.OnStart

-- level table: patrols | patrol speed (cells a step) | powerups | lives
function Maze.Row pLevel
   return line pLevel of ("3,0.0625,4,3" & cr & "4,0.0625,3,3" & cr & "4,0.125,3,3" & cr & "5,0.125,2,3" & cr & "6,0.125,2,3")
end Maze.Row

on Maze.StartLevel
   local tRow, r, c, tCh, tPow, tFoeN
   put Maze.Row(sLevel) into tRow
   if sLevel is 1 or sLives is empty then put item 4 of tRow into sLives
   put item 2 of tRow into sFoeSpeed
   Scene.ClearAll
   put empty into sMap
   put empty into sDots
   put empty into sDotsKey
   put 0 into sDotsLeft
   put empty into sFoe
   put 0 into sFoeCount
   put empty into sPoly
   put 0 into sHeld[1]
   put 0 into sHeld[2]
   put 1 into sActive
   put 0 into tPow
   put 0 into tFoeN
   set the itemDel to "|"
   repeat with r = 0 to 12
      repeat with c = 0 to 18
         put char c + 1 of item r + 1 of kMaze into tCh
         put (tCh is "#") into sMap[r][c]
         switch tCh
            case "."
               put "dot" into sDots[r][c]
               add 1 to sDotsLeft
               break
            case "o"
               add 1 to tPow
               if tPow <= item 3 of tRow then
                  put "power" into sDots[r][c]
               else
                  put "dot" into sDots[r][c]
               end if
               add 1 to sDotsLeft
               break
            case "P"
               Maze.SetAgent 1, c, r
               break
            case "G"
               Maze.SetAgent 2, c, r
               break
            case "E"
               put c & comma & r & cr after sFoe["starts"]
               break
         end switch
      end repeat
   end repeat
   set the itemDel to comma
   Maze.BuildWalls
   Maze.BuildDots
   Mesh.Define "Maze.Agent", MeshPyramid(4, 14, 26)
   Mesh.Define "Maze.Foe", MeshSphere(13, 2, 5)
   repeat with c = 1 to 2
      put Entity.Spawn("Maze.Agent", Maze.X(sAgent[c]["x"]), Maze.Y(sAgent[c]["y"]), kZ, item c of kColors) into sAgent[c]["key"]
   end repeat
   repeat with c = 1 to item 1 of tRow
      Maze.AddFoe c
   end repeat
   put empty into sHUDWas
   put 45 into sPause
end Maze.StartLevel

on Maze.SetAgent n, c, r
   put c into sAgent[n]["x"]
   put r into sAgent[n]["y"]
   put c into sAgent[n]["x0"]
   put r into sAgent[n]["y0"]
   put "0,0" into sAgent[n]["dir"]
   put "0,-1" into sAgent[n]["face"]
end Maze.SetAgent

on Maze.AddFoe n
   local tStart
   put line ((n - 1) mod the number of lines of sFoe["starts"]) + 1 of sFoe["starts"] into tStart
   add 1 to sFoeCount
   put item 1 of tStart into sFoe[n]["x"]
   put item 2 of tStart into sFoe[n]["y"]
   put "0,-1" into sFoe[n]["dir"]
   put 0 into sFoe[n]["charm"]
   put 0 into sFoe[n]["gone"]
   put Entity.Spawn("Maze.Foe", Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ, "#FFB000") into sFoe[n]["key"]
   put "#FFB000" into sFoe[n]["color"]
end Maze.AddFoe

function Maze.X c
   return (c - 9) * kCell
end Maze.X

function Maze.Y r
   return (r - 6) * kCell + 20
end Maze.Y

function Maze.Open c, r
   if r < 0 or r > 12 or c < 0 or c > 18 then return false
   return not sMap[r][c]
end Maze.Open

-- the walls: one mesh, an outline only where a wall meets an open cell
on Maze.BuildWalls
   local tM, r, c, x, y, h
   put Mesh.New() into tM
   put kCell / 2 into h
   repeat with r = 0 to 12
      repeat with c = 0 to 18
         if not sMap[r][c] then next repeat
         put Maze.X(c) into x
         put Maze.Y(r) into y
         if Maze.Open(c, r - 1) then Maze.Edge tM, x - h, y - h, x + h, y - h
         if Maze.Open(c, r + 1) then Maze.Edge tM, x - h, y + h, x + h, y + h
         if Maze.Open(c - 1, r) then Maze.Edge tM, x - h, y - h, x - h, y + h
         if Maze.Open(c + 1, r) then Maze.Edge tM, x + h, y - h, x + h, y + h
      end repeat
   end repeat
   Mesh.Define "Maze.Walls", tM
   get Entity.Spawn("Maze.Walls", 0, 0, kZ, "#4C8CFF")
end Maze.BuildWalls

on Maze.Edge @tM, x1, y1, x2, y2
   Mesh.AddVertex tM, x1, y1, 0
   Mesh.AddVertex tM, x2, y2, 0
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
end Maze.Edge

-- the dots: one mesh, rebuilt when one is eaten (a small diamond each; powerups bigger)
on Maze.BuildDots
   local tM, r, c, x, y, s, tFirst
   put Mesh.New() into tM
   repeat for each key r in sDots
      repeat for each key c in sDots[r]
         if sDots[r][c] is empty then next repeat
         put Maze.X(c) into x
         put Maze.Y(r) into y
         put 3 into s
         if sDots[r][c] is "power" then put 9 into s
         Mesh.AddVertex tM, x - s, y, 0
         put tM["count"] into tFirst
         Mesh.AddVertex tM, x, y - s, 0
         Mesh.AddVertex tM, x + s, y, 0
         Mesh.AddVertex tM, x, y + s, 0
         Mesh.AddLine tM, tFirst, tFirst + 1
         Mesh.AddLine tM, tFirst + 1, tFirst + 2
         Mesh.AddLine tM, tFirst + 2, tFirst + 3
         Mesh.AddLine tM, tFirst + 3, tFirst
      end repeat
   end repeat
   Mesh.Define "Maze.Dots", tM
   if sDotsKey is empty then put Entity.Spawn("Maze.Dots", 0, 0, kZ, "#40E0FF") into sDotsKey
end Maze.BuildDots

function Maze.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Maze.Keys

on Maze.TestKeys pKeys
   put pKeys into sTestKeys
end Maze.TestKeys

on Game.OnUpdate
   local tKeys, tWant, k, n
   add 1 to sTicks
   put Maze.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Game.OnStart
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- Tab swaps; Space throws (one press each)
   if 65289 is among the items of tKeys and not (65289 is among the items of sKeysWas) then
      put 3 - sActive into sActive
      put empty into sHUDWas
   end if
   if 32 is among the items of tKeys and not (32 is among the items of sKeysWas) then Maze.Throw
   put tKeys into sKeysWas
   if sPause > 0 then
      subtract 1 from sPause
      Maze.ShowHUD
      exit Game.OnUpdate
   end if
   put empty into tWant
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then put "-1,0" into tWant
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then put "1,0" into tWant
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then put "0,-1" into tWant
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then put "0,1" into tWant
   Maze.MoveAgent sActive, tWant
   repeat with n = 1 to sFoeCount
      Maze.MoveFoe n
   end repeat
   Maze.MovePoly
   Maze.Touches
   Maze.ShowHUD
end Game.OnUpdate

-- grid movement: a new direction is taken at a cell centre; walls stop you
on Maze.MoveAgent n, pWant
   local x, y, d
   put sAgent[n]["x"] into x
   put sAgent[n]["y"] into y
   if x = round(x) and y = round(y) then
      Maze.Eat n, x, y
      if pWant is not empty and Maze.Open(x + item 1 of pWant, y + item 2 of pWant) then put pWant into sAgent[n]["dir"]
      if pWant is empty then put "0,0" into sAgent[n]["dir"]
      put sAgent[n]["dir"] into d
      if not Maze.Open(x + item 1 of d, y + item 2 of d) then
         put "0,0" into sAgent[n]["dir"]
      end if
   else if pWant is not empty and item 1 of pWant = -item 1 of sAgent[n]["dir"] and item 2 of pWant = -item 2 of sAgent[n]["dir"] then
      put pWant into sAgent[n]["dir"]          -- turning back is allowed anywhere
   end if
   put sAgent[n]["dir"] into d
   if d is not "0,0" then put d into sAgent[n]["face"]
   add item 1 of d * kAgentSpeed to sAgent[n]["x"]
   add item 2 of d * kAgentSpeed to sAgent[n]["y"]
   SetObjectPosition sAgent[n]["key"], Maze.X(sAgent[n]["x"]), Maze.Y(sAgent[n]["y"]), kZ
   SetObjectRotation sAgent[n]["key"], 0, 0, atan2(item 1 of sAgent[n]["face"], -item 2 of sAgent[n]["face"])
end Maze.MoveAgent

on Maze.Eat n, x, y
   local tWhat
   put sDots[y][x] into tWhat
   if tWhat is empty then exit Maze.Eat
   put empty into sDots[y][x]
   subtract 1 from sDotsLeft
   if tWhat is "power" then
      add 1 to sHeld[n]
      add 50 to sScore
      FX.Sparks Maze.X(x), Maze.Y(y), kZ, 10, item n of kColors
   else
      add 10 to sScore
   end if
   Maze.BuildDots
   put empty into sHUDWas
   if sDotsLeft <= 0 then
      if sLevel >= 5 then
         put true into sOver
         put true into sWon
      else
         add 1 to sLevel
         Maze.StartLevel
      end if
   end if
end Maze.Eat

-- patrols: at each cell centre pick a way on (never straight back unless stuck), mostly
-- toward the nearest agent; charmed ones follow the active agent instead; de-rezzed wait
on Maze.MoveFoe n
   local x, y, tBest, tScore, tD, tGo, tTX, tTY, tAg
   if sFoe[n]["gone"] > 0 then
      subtract 1 from sFoe[n]["gone"]
      if sFoe[n]["gone"] is 0 then
         Maze.Recolor n, "#FFB000"
         put item 1 of line 1 of sFoe["starts"] into sFoe[n]["x"]
         put item 2 of line 1 of sFoe["starts"] into sFoe[n]["y"]
         SetObjectPosition sFoe[n]["key"], Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ
      end if
      exit Maze.MoveFoe
   end if
   if sFoe[n]["charm"] > 0 then
      subtract 1 from sFoe[n]["charm"]
      if sFoe[n]["charm"] is 0 then Maze.Recolor n, "#FFB000"
   end if
   put sFoe[n]["x"] into x
   put sFoe[n]["y"] into y
   if x = round(x) and y = round(y) then
      put 1 into tAg
      if abs(sAgent[2]["x"] - x) + abs(sAgent[2]["y"] - y) < abs(sAgent[1]["x"] - x) + abs(sAgent[1]["y"] - y) then put 2 into tAg
      if sFoe[n]["charm"] > 0 then put sActive into tAg
      put sAgent[tAg]["x"] into tTX
      put sAgent[tAg]["y"] into tTY
      put 1e9 into tBest
      repeat for each item tD in "1 0,-1 0,0 1,0 -1"
         if not Maze.Open(x + word 1 of tD, y + word 2 of tD) then next repeat
         if word 1 of tD = -item 1 of sFoe[n]["dir"] and word 2 of tD = -item 2 of sFoe[n]["dir"] then next repeat
         put abs(x + word 1 of tD - tTX) + abs(y + word 2 of tD - tTY) + random(3) into tScore
         if tScore < tBest then
            put tScore into tBest
            put word 1 of tD & comma & word 2 of tD into tGo
         end if
      end repeat
      if tGo is empty then put -item 1 of sFoe[n]["dir"] & comma & -item 2 of sFoe[n]["dir"] into tGo
      put tGo into sFoe[n]["dir"]
   end if
   add item 1 of sFoe[n]["dir"] * sFoeSpeed to sFoe[n]["x"]
   add item 2 of sFoe[n]["dir"] * sFoeSpeed to sFoe[n]["y"]
   SetObjectPosition sFoe[n]["key"], Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ
   SetObjectRotation sFoe[n]["key"], 0, sTicks / 12, 0
end Maze.MoveFoe

on Maze.Recolor n, pColor
   Entity.Kill sFoe[n]["key"]
   put pColor into sFoe[n]["color"]
   put Entity.Spawn("Maze.Foe", Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ, pColor) into sFoe[n]["key"]
end Maze.Recolor

-------------------------------------------------------------------- the polyhedron

on Maze.Throw
   local n
   put sActive into n
   if sHeld[n] <= 0 or sPoly is not empty then exit Maze.Throw
   subtract 1 from sHeld[n]
   put round(sAgent[n]["x"]) into sPoly["x"]
   put round(sAgent[n]["y"]) into sPoly["y"]
   put sAgent[n]["face"] into sPoly["dir"]
   put 7 into sPoly["sides"]
   put n into sPoly["by"]
   Maze.PolyMesh
   put empty into sHUDWas
end Maze.Throw

on Maze.PolyMesh
   if sPoly["key"] is not empty then Entity.Kill sPoly["key"]
   Mesh.Define "Maze.Poly", MeshSphere(15, 2, sPoly["sides"])
   put Entity.Spawn("Maze.Poly", Maze.X(sPoly["x"]), Maze.Y(sPoly["y"]), kZ - 2, "#FFE060") into sPoly["key"]
end Maze.PolyMesh

-- it flies fast; at a wall it turns the corner (or back) and loses a side
on Maze.MovePoly
   local x, y, d, tLeft, tRight
   if sPoly is empty then exit Maze.MovePoly
   put sPoly["x"] into x
   put sPoly["y"] into y
   put sPoly["dir"] into d
   if x = round(x) and y = round(y) and not Maze.Open(x + item 1 of d, y + item 2 of d) then
      put item 2 of d & comma & -item 1 of d into tLeft
      put -item 2 of d & comma & item 1 of d into tRight
      if Maze.Open(x + item 1 of tLeft, y + item 2 of tLeft) and (random(2) is 1 or not Maze.Open(x + item 1 of tRight, y + item 2 of tRight)) then
         put tLeft into sPoly["dir"]
      else if Maze.Open(x + item 1 of tRight, y + item 2 of tRight) then
         put tRight into sPoly["dir"]
      else
         put -item 1 of d & comma & -item 2 of d into sPoly["dir"]
      end if
      Maze.PolyStrike
      if sPoly is empty then exit Maze.MovePoly
   end if
   add item 1 of sPoly["dir"] * 0.25 to sPoly["x"]
   add item 2 of sPoly["dir"] * 0.25 to sPoly["y"]
   SetObjectPosition sPoly["key"], Maze.X(sPoly["x"]), Maze.Y(sPoly["y"]), kZ - 2
   SetObjectRotation sPoly["key"], sTicks / 5, sTicks / 7, 0
end Maze.MovePoly

on Maze.PolyStrike
   subtract 1 from sPoly["sides"]
   FX.Sparks Maze.X(sPoly["x"]), Maze.Y(sPoly["y"]), kZ, 5, "#FFE060"
   if sPoly["sides"] < 3 then
      Entity.Kill sPoly["key"]
      put empty into sPoly
   else
      Maze.PolyMesh
   end if
end Maze.PolyStrike

-------------------------------------------------------------------- who touches whom

on Maze.Touches
   local n, a
   repeat with n = 1 to sFoeCount
      if sFoe[n]["gone"] > 0 then next repeat
      -- the polyhedron: PROMPT de-rezzes, GLAZE charms
      if sPoly is not empty then
         if abs(sPoly["x"] - sFoe[n]["x"]) < 0.6 and abs(sPoly["y"] - sFoe[n]["y"]) < 0.6 then
            if sPoly["by"] is 1 then
               put 240 into sFoe[n]["gone"]
               FX.Sparks Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ, 20, "#FF5050"
               Maze.Recolor n, "#202020"
               add 100 to sScore
            else
               put 180 into sFoe[n]["charm"]
               Maze.Recolor n, "#40FF80"
               add 50 to sScore
            end if
            Maze.PolyStrike
            put empty into sHUDWas
            next repeat
         end if
      end if
      if sFoe[n]["charm"] > 0 then next repeat
      repeat with a = 1 to 2
         if abs(sAgent[a]["x"] - sFoe[n]["x"]) < 0.6 and abs(sAgent[a]["y"] - sFoe[n]["y"]) < 0.6 then
            Maze.LoseLife a
            exit Maze.Touches
         end if
      end repeat
   end repeat
end Maze.Touches

on Maze.LoseLife a
   local n
   FX.Sparks Maze.X(sAgent[a]["x"]), Maze.Y(sAgent[a]["y"]), kZ, 30, item a of kColors
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      exit Maze.LoseLife
   end if
   -- everyone back to the start; the dots stay eaten
   repeat with n = 1 to 2
      put sAgent[n]["x0"] into sAgent[n]["x"]
      put sAgent[n]["y0"] into sAgent[n]["y"]
      put "0,0" into sAgent[n]["dir"]
      SetObjectPosition sAgent[n]["key"], Maze.X(sAgent[n]["x"]), Maze.Y(sAgent[n]["y"]), kZ
   end repeat
   repeat with n = 1 to sFoeCount
      put item 1 of line ((n - 1) mod the number of lines of sFoe["starts"]) + 1 of sFoe["starts"] into sFoe[n]["x"]
      put item 2 of line ((n - 1) mod the number of lines of sFoe["starts"]) + 1 of sFoe["starts"] into sFoe[n]["y"]
      SetObjectPosition sFoe[n]["key"], Maze.X(sFoe[n]["x"]), Maze.Y(sFoe[n]["y"]), kZ
   end repeat
   put 45 into sPause
end Maze.LoseLife

on Maze.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sActive & "|" & sHeld[1] & "|" & sHeld[2] & "|" & sOver & "|" & (sPause > 0) into tWords
   if tWords is sHUDWas then exit Maze.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Maze.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  YOU:" && item sActive of kNames && "  THROWS" && sHeld[1] & "/" & sHeld[2], 20, 120, 12
   HUD.Remove "Maze.Msg"
   if sOver and sWon then
      HUD.Set "Maze.Msg", "EVERY DOT COLLECTED.  SPACE TO PLAY AGAIN", 20, 140, 14
   else if sOver then
      HUD.Set "Maze.Msg", "CAUGHT.  SPACE TO PLAY AGAIN", 20, 140, 14
   else if sPause > 0 then
      HUD.Set "Maze.Msg", "ARROWS MOVE   SPACE THROWS   TAB SWAPS PROMPT / GLAZE", 20, 140, 14
   end if
end Maze.ShowHUD

function Maze.State
   return sLevel & "|" & sLives & "|" & sScore & "|" & sDotsLeft & "|" & sActive & "|" & sAgent[sActive]["x"] & "," & sAgent[sActive]["y"] & "|" & sHeld[1] & "/" & sHeld[2] & "|" & (sPoly is not empty) & "|" & sOver
end Maze.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
