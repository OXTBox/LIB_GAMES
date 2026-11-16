######################################################################################
## CARD SCRIPT: "Play.Amazing_Couple"   AMAZING COUPLE: PROMPT & GLAZE, third-person companions in a maze  (11 12 2026)
## Third person in a vector maze. PROMPT (cyan) and GLAZE (magenta) are minimal stick
## figures driven by LIB_MOCAP clips. You play one; the other follows you through the
## maze on its own (LIB_MAP path finding). TAB swaps who you play. Bring both to the
## gold beacon in the far corner and a new maze is built. Each hero has its own captured
## walk and idle (LIB_MOCAP library); Shift runs (a captured jog).
## CONTROLS  W / up arrow  walk        S / down arrow  step back     Shift  run
##           A D / left right arrows   turn                TAB  switch hero
## SKILLS    PROMPT gets the job done no matter what; GLAZE: barter, charm, influence.
##           Shown on screen, not used yet.
## THE BALL  (owner's notes, 11 14 2026) a Big Ball of Vectors polyhedron is loose in every
##           maze; in the first one it waits right up the hall. It hops and rolls and LOSES
##           A SIDE EVERY TIME IT LANDS. Walk into it to KICK it (harder when running);
##           F picks it up into your hands, F again kicks it straight. Q and E kick it at
##           an angle (owner's note 11 14: Q kicks from the ball's left so it goes right, E from
##           its right so it goes left), from the hands or when it is at your feet. The first
##           ball RESTS ON THE FLOOR until a hero touches it (owner: "put it on the floor for
##           their feet to interact with first"). A worn-out ball shatters and
##           a new one turns up in another room.
## MAZES     (owner's note, 11 14 2026: "make the maps procedurally ONCE") each maze is a
##           cellmap v2 file, LIB_BIT/editor/maps/amazing_couple_mazes/maze_NN.cellmap, made and
##           checked by LIB_GAMES/tools/couple_mazes.py. The walls are DRAWN from that file
##           (CellMap.LevelSegments) and BLOCK from that file (its heights), so what you see is
##           what stops you. Open one in the BitEditor to change it. No file: the old built maze.
## NEEDS     ../LIB_BIT (+ editor/livecode/lib_cellmap), ../LIB_MAP and ../LIB_MOCAP/library.
######################################################################################

global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch
global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPaused, bPlaying

constant kM = 30              -- engine units a metre: the heroes are about 48 tall
constant kCell = 76           -- maze cell, engine units (about 2.5 m corridors)
constant kWallH = 58          -- wall height (the heroes are about 52 tall)
constant kRooms = 6           -- maze size in rooms (the grid is 2 * kRooms + 1 square)
constant kTurn = 0.06         -- radians a step
constant kGap = 46            -- the follower stops this far behind
constant kCamBack = 105       -- camera distance behind the hero
constant kCamUp = 88          -- camera height
-- LIB_MOCAP clips (library/<name>/<name>_stick.txt); walks and runs loop their "cycle"
constant kPromptWalk = "Animazoo_gangster_walk"
constant kPromptIdle = "Animazoo_hands_on_hips"
constant kGlazeWalk = "Animazoo_walking_waving"
constant kGlazeIdle = "Animazoo_talking_gesturing"
constant kRun = "Animazoo_Running_-_Jog"
constant kMaxIdleFrames = 300   -- longer idles are cut to their first 10 seconds
constant kPromptColor = "#40E0FF"
constant kGlazeColor = "#FF60D0"
-- the ball (from Big Ball of Vectors): sides lost one per bounce
constant kBallSides = 16      -- a new ball's sides
constant kBallMinSides = 3    -- below this it shatters
constant kBallR = 11          -- radius, engine units
constant kBallHop = 4.6       -- upward speed at each bounce, units a step (peak about 90)
constant kBallGrav = 0.12     -- units a step a step
constant kBallRoll = 0.9      -- rolling speed along the corridors
constant kBallColor = "#FFFFFF"
constant kKickAngle = 0.6     -- radians off the hero's facing for a Q / E kick (about 35 degrees)

local sStepMS = 33, sTicks = 0
local sGrid, sCols, sRows, sLeft, sTop, sSeed, sMap, sTags, sMazeFile
constant kMazeFiles = 12      -- maze_01 .. maze_12, then round again
local sClip          -- [clip name][frames|fps|travel]; meshes "Couple.<clip>.<n>"
local sHero          -- [PROMPT|GLAZE][key|x|z|yaw|anim|frame|speed|color|path|pathTo|skills|walk|idle|run]
local sActive        -- "PROMPT" or "GLAZE"
local sKeyWas, sTestKeys, sError
local sCamX, sCamY, sCamZ, sBeacon, sExitCell, sNextMazeAt, sMsgUntil
local sBall          -- [key|x|z|h|vh|vx|vz|sides|state (loose|found)|by]
local sBallFound = 0, sBallLost = 0, sBallMsg, sBallMsgUntil

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   put Engine.Info("stepMS") into sStepMS
   if sStepMS is not a number then put 33 into sStepMS
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sTicks
   put empty into sError
   put empty into sTestKeys
   put 1 into sSeed
   put 0 into sBallFound
   put 0 into sBallLost
   Couple.LoadLibraries
   if sError is empty then Couple.LoadClips
   if sError is not empty then
      HUD.Set "Couple.Err", sError, gViewLeft + 20, gViewTop + 120, 14
      exit Game.OnStart
   end if
   Couple.NewMaze
end Game.OnStart

on Game.OnUpdate
   if sError is not empty then exit Game.OnUpdate
   add 1 to sTicks
   if sNextMazeAt is not empty and sTicks >= sNextMazeAt then
      add 1 to sSeed
      Couple.NewMaze
      exit Game.OnUpdate
   end if
   Couple.Controls
   Couple.Follow
   Couple.Animate "PROMPT"
   Couple.Animate "GLAZE"
   Couple.Camera false
   Couple.BallUpdate
   Couple.CheckExit
   Couple.ShowHUD
end Game.OnUpdate

on Game.OnClick pX,pY,pButton
end Game.OnClick

on Game.OnKill pKey,pX,pY,pZ
end Game.OnKill

on Game.OnPause
end Game.OnPause

on Game.OnResume
end Game.OnResume

on Game.OnStop
   HUD.Clear
end Game.OnStop

on Collision.Hit pA,pB
end Collision.Hit

-------------------------------------------------------------------- loading

on Couple.LoadLibraries
   local tLib, tName
   repeat for each item tName in "LIB_BIT/livecode/lib_bit.livecodescript,LIB_MAP/livecode/lib_map.livecodescript,LIB_BIT/editor/livecode/lib_cellmap.livecodescript"
      put Couple.FindFile(tName) into tLib
      if tLib is empty then
         put "COUPLE: NOT FOUND " & toUpper(tName) into sError
         exit Couple.LoadLibraries
      end if
      start using stack tLib
   end repeat
   put Couple.FindFile("LIB_BIT/editor/data/tags_default.txt") into tLib
   if tLib is not empty then put CellMap.TagsFromText(CellMap.ReadText(tLib)) into sTags
end Couple.LoadLibraries

-- walk and idle stick clips from LIB_MOCAP; one engine mesh per frame
-- every clip the heroes use, from LIB_MOCAP; one engine mesh per frame
on Couple.LoadClips
   local tName, tFile
   put empty into sClip
   repeat for each item tName in kPromptWalk & comma & kPromptIdle & comma & kGlazeWalk & comma & kGlazeIdle & comma & kRun
      if sClip[tName]["frames"] is a number then next repeat
      put Couple.FindFile("LIB_MOCAP/library/" & tName & "/" & tName & "_stick.txt") into tFile
      if tFile is empty then
         put "COUPLE: NO CLIP " & toUpper(tName) & " IN LIB_MOCAP/LIBRARY" into sError
         exit Couple.LoadClips
      end if
      Couple.LoadClip tName, URL ("file:" & tFile)
   end repeat
end Couple.LoadClips

-- a stick clip: only its cycle when it has one (walks, runs), else up to kMaxIdleFrames
on Couple.LoadClip pName, pText
   local tLine, tEdges, tFrame, tKept, tM, tV, i, tJoints, tE, tA, tB, tFrom, tTo
   put 0 into tFrame
   put 0 into tKept
   put 1 into tFrom
   put kMaxIdleFrames into tTo
   repeat for each line tLine in pText
      if tLine is empty or char 1 of tLine is "#" then next repeat
      set the itemDel to comma
      switch item 1 of tLine
         case "fps"
            put item 2 of tLine into sClip[pName]["fps"]
            break
         case "travel"
            if sClip[pName]["travel"] is empty then put item 2 of tLine into sClip[pName]["travel"]
            break
         case "cycle"
            put item 2 of tLine into tFrom
            put item 3 of tLine into tTo
            break
         case "cycle_travel"
            put item 2 of tLine into sClip[pName]["travel"]
            break
         case "joints"
            put item 2 of tLine into tJoints
            break
         case "edges"
            put item 2 of tLine into tEdges
            break
         default
            if char 1 of tLine is "-" or char 1 of tLine is a number then
               add 1 to tFrame
               if tFrame < tFrom or tFrame > tTo then next repeat
               add 1 to tKept
               put tLine into tV
               split tV by comma
               put Mesh.New() into tM
               repeat with i = 0 to tJoints - 1
                  Mesh.AddVertex tM, tV[3 * i + 1] * kM, -tV[3 * i + 2] * kM, tV[3 * i + 3] * kM
               end repeat
               repeat for each word tE in tEdges
                  set the itemDel to "-"
                  put item 1 of tE + 1 into tA
                  put item 2 of tE + 1 into tB
                  set the itemDel to comma
                  Mesh.AddLine tM, tA, tB
               end repeat
               Mesh.Define "Couple." & pName & "." & tKept, tM
            end if
      end switch
   end repeat
   put tKept into sClip[pName]["frames"]
   if sClip[pName]["fps"] is not a number then put 30 into sClip[pName]["fps"]
   if sClip[pName]["travel"] is not a number then put 0 into sClip[pName]["travel"]
end Couple.LoadClip

-------------------------------------------------------------------- the maze

on Couple.NewMaze
   local tSegs, tName, tC, tR
   Scene.ClearAll
   HUD.Clear
   put empty into sNextMazeAt
   put empty into sMsgUntil
   put "maze_" & format("%02d", ((sSeed - 1) mod kMazeFiles) + 1) & ".cellmap" into tName
   put Couple.FindFile("LIB_BIT/editor/maps/amazing_couple_mazes/" & tName) into sMazeFile
   if sMazeFile is not empty and sTags is an array then
      Couple.MazeFromFile
   else
      -- no file: the maze built here, as before
      put empty into sMazeFile
      put Bit.Maze(kRooms, kRooms, sSeed) into sGrid
      put the number of chars of line 1 of sGrid into sCols
      put the number of lines of sGrid into sRows
      Mesh.Define "Couple.Walls", Couple.SegmentsToMesh(Map.BlockEdges(sGrid, kCell, kWallH, false))
      Mesh.Define "Couple.Floor", Couple.SegmentsToMesh(Map.BlockEdges(Bit.Blank(sCols, sRows), kCell, 0, true))
   end if
   put -sCols * kCell / 2 into sLeft
   put sRows * kCell / 2 into sTop
   get Entity.Spawn("Couple.Floor", 0, 0, 0, "#1F4A5A")
   get Entity.Spawn("Couple.Walls", 0, 0, 0, "#7FA8FF")
   -- the beacon: far corner room
   put (2 * kRooms) & comma & (2 * kRooms) into sExitCell
   Mesh.Define "Couple.Beacon", Couple.BeaconMesh()
   put Entity.Spawn("Couple.Beacon", Couple.CellX(2 * kRooms), 0, Couple.CellZ(2 * kRooms), "#FFD040") into sBeacon
   SetObjectRotationSpeed sBeacon, 0, 0.05, 0
   -- the heroes, side by side in the first room, facing down the first corridor
   Couple.Spawn "PROMPT", kPromptColor, Couple.CellX(2) - 12, Couple.CellZ(2)
   Couple.Spawn "GLAZE", kGlazeColor, Couple.CellX(2) + 12, Couple.CellZ(2) - 20
   put "PROMPT" into sActive
   put Couple.FirstHeading() into sHero["PROMPT"]["yaw"]
   put sHero["PROMPT"]["yaw"] into sHero["GLAZE"]["yaw"]
   put empty into sBall          -- Scene.ClearAll took the old ball
   Couple.BallSpawn (sSeed is 1)   -- the first maze: right up the hall
   Couple.Camera true
end Couple.NewMaze

-- the maze from its file: the grid the heroes collide with comes from the file's heights
-- (a full wall is floor 100+), and the lines you see come from the same file
on Couple.MazeFromFile
   local tR, tC, tLine, tSeg, tE, tMesh, tIndex, tA, tB, tClass
   put CellMap.Read(sMazeFile) into sMap
   CellMap.Upgrade sMap
   put sMap["meta"]["cols"] into sCols
   put sMap["meta"]["rows"] into sRows
   put empty into sGrid
   repeat with tR = 1 to sRows
      put empty into tLine
      repeat with tC = 1 to sCols
         if sMap["floor"][tR][tC] >= 100 or sMap["floor"][tR][tC] <= 0 then
            put "1" after tLine
         else
            put "0" after tLine
         end if
      end repeat
      put tLine & return after sGrid
   end repeat
   delete the last char of sGrid
   put Mesh.New() into tMesh["wall"]
   put Mesh.New() into tMesh["floor"]
   repeat for each line tSeg in CellMap.LevelSegments(sMap, sTags, empty)
      put item 7 of tSeg into tClass
      if tClass is not "wall" then put "floor" into tClass
      put CellMap.SegToEngine(sMap, tSeg) into tE
      -- map space has y up; the engine has up = -Y
      put Couple.MeshPoint(tMesh[tClass], tIndex[tClass], item 1 of tE, -(item 2 of tE), item 3 of tE) into tA
      put Couple.MeshPoint(tMesh[tClass], tIndex[tClass], item 4 of tE, -(item 5 of tE), item 6 of tE) into tB
      Mesh.AddLine tMesh[tClass], tA, tB
   end repeat
   Mesh.Define "Couple.Walls", tMesh["wall"]
   Mesh.Define "Couple.Floor", tMesh["floor"]
end Couple.MazeFromFile

function Couple.MeshPoint @pMesh, @pIndex, pX, pY, pZ
   local tKey
   put pX & "," & pY & "," & pZ into tKey
   if pIndex[tKey] is empty then
      Mesh.AddVertex pMesh, pX, pY, pZ
      put the result into pIndex[tKey]
   end if
   return pIndex[tKey]
end Couple.MeshPoint

-- facing the open neighbour of the first room
function Couple.FirstHeading
   if Couple.Open(3, 2) then return pi / 2       -- east (+X)
   return 0                                       -- south (+Z)
end Couple.FirstHeading

function Couple.CellX pCol
   return sLeft + (pCol - 0.5) * kCell
end Couple.CellX

function Couple.CellZ pRow
   return -sTop + (pRow - 0.5) * kCell
end Couple.CellZ

function Couple.CellAt pX, pZ
   return (trunc((pX - sLeft) / kCell) + 1) & comma & (trunc((pZ + sTop) / kCell) + 1)
end Couple.CellAt

function Couple.Open pCol, pRow
   if pCol < 1 or pRow < 1 or pCol > sCols or pRow > sRows then return false
   return char pCol of line pRow of sGrid is "0"
end Couple.Open

-- a hero (a circle of radius 12) fits at x,z
function Couple.Fits pX, pZ
   local dx, dz, tCell
   repeat for each item dx in "-12,12"
      repeat for each item dz in "-12,12"
         put Couple.CellAt(pX + dx, pZ + dz) into tCell
         if not Couple.Open(item 1 of tCell, item 2 of tCell) then return false
      end repeat
   end repeat
   return true
end Couple.Fits

-- move a hero by dx,dz, sliding along walls; returns the distance moved
function Couple.TryMove pName, pDX, pDZ
   local tX, tZ, tMoved
   put sHero[pName]["x"] into tX
   put sHero[pName]["z"] into tZ
   if Couple.Fits(tX + pDX, tZ + pDZ) then
      add pDX to tX
      add pDZ to tZ
   else if Couple.Fits(tX + pDX, tZ) then
      add pDX to tX
   else if Couple.Fits(tX, tZ + pDZ) then
      add pDZ to tZ
   end if
   put sqrt((tX - sHero[pName]["x"]) ^ 2 + (tZ - sHero[pName]["z"]) ^ 2) into tMoved
   put tX into sHero[pName]["x"]
   put tZ into sHero[pName]["z"]
   return tMoved
end Couple.TryMove

-------------------------------------------------------------------- heroes

on Couple.Spawn pName, pColor, pX, pZ
   if pName is "PROMPT" then
      put kPromptWalk into sHero[pName]["walk"]
      put kPromptIdle into sHero[pName]["idle"]
      put "GETS THE JOB DONE NO MATTER WHAT" into sHero[pName]["skills"]
   else
      put kGlazeWalk into sHero[pName]["walk"]
      put kGlazeIdle into sHero[pName]["idle"]
      put "BARTER 9  CHARM 9  INFLUENCE 9" into sHero[pName]["skills"]
   end if
   put kRun into sHero[pName]["run"]
   put Entity.Spawn("Couple." & sHero[pName]["idle"] & ".1", pX, 0, pZ, pColor) into sHero[pName]["key"]
   put pX into sHero[pName]["x"]
   put pZ into sHero[pName]["z"]
   put 0 into sHero[pName]["yaw"]
   put "idle" into sHero[pName]["anim"]
   put random(sClip[sHero[pName]["idle"]]["frames"]) into sHero[pName]["frame"]
   put 0 into sHero[pName]["speed"]
   put pColor into sHero[pName]["color"]
   put empty into sHero[pName]["path"]
end Couple.Spawn

-- the walking speed the clip's feet were made for, in engine units a step
-- how far a hero's clip moves in one step, engine units (pWhich: walk or run)
function Couple.WalkStep pName, pWhich
   if pWhich is empty then put "walk" into pWhich
   return sClip[sHero[pName][pWhich]]["travel"] * kM * sStepMS / 1000
end Couple.WalkStep

on Couple.Controls
   local tKeys, tF, tTurn, tName, tDX, tDZ, tStep
   put Couple.Keys() into tKeys
   -- TAB, once per press
   if 65289 is among the items of tKeys or 9 is among the items of tKeys then
      if sKeyWas["tab"] is not true then Couple.Switch
      put true into sKeyWas["tab"]
   else
      put false into sKeyWas["tab"]
   end if
   put sActive into tName
   put 0 into tF
   put 0 into tTurn
   if 119 is among the items of tKeys or 87 is among the items of tKeys or 65362 is among the items of tKeys then add 1 to tF
   if 115 is among the items of tKeys or 83 is among the items of tKeys or 65364 is among the items of tKeys then subtract 0.5 from tF
   if 97 is among the items of tKeys or 65 is among the items of tKeys or 65361 is among the items of tKeys then subtract kTurn from tTurn
   if 100 is among the items of tKeys or 68 is among the items of tKeys or 65363 is among the items of tKeys then add kTurn to tTurn
   add tTurn to sHero[tName]["yaw"]
   -- Shift runs (forward only)
   if tF > 0 and (65505 is among the items of tKeys or 65506 is among the items of tKeys) then
      put Couple.WalkStep(tName, "run") * tF into tStep
   else
      put Couple.WalkStep(tName, "walk") * tF into tStep
   end if
   put sin(sHero[tName]["yaw"]) * tStep into tDX
   put cos(sHero[tName]["yaw"]) * tStep into tDZ
   put Couple.TryMove(tName, tDX, tDZ) into sHero[tName]["speed"]
   if tF < 0 then put -sHero[tName]["speed"] into sHero[tName]["speed"]
end Couple.Controls

on Couple.Switch
   if sActive is "PROMPT" then
      put "GLAZE" into sActive
   else
      put "PROMPT" into sActive
   end if
   put empty into sHero["PROMPT"]["path"]
   put empty into sHero["GLAZE"]["path"]
   put sTicks + 45 into sMsgUntil
end Couple.Switch

-- the hero you are not playing walks after the one you are: along a LIB_MAP path when
-- it is more than a room away, straight at you when close
on Couple.Follow
   local tMe, tLead, dx, dz, tDist, tMyCell, tLeadCell, tNext, tTX, tTZ, tStep, tMoved
   if sActive is "PROMPT" then
      put "GLAZE" into tMe
   else
      put "PROMPT" into tMe
   end if
   put sActive into tLead
   put sHero[tLead]["x"] - sHero[tMe]["x"] into dx
   put sHero[tLead]["z"] - sHero[tMe]["z"] into dz
   put sqrt(dx * dx + dz * dz) into tDist
   if tDist <= kGap then
      put 0 into sHero[tMe]["speed"]
      exit Couple.Follow
   end if
   put Couple.CellAt(sHero[tMe]["x"], sHero[tMe]["z"]) into tMyCell
   put Couple.CellAt(sHero[tLead]["x"], sHero[tLead]["z"]) into tLeadCell
   put sHero[tLead]["x"] into tTX
   put sHero[tLead]["z"] into tTZ
   if tMyCell is not tLeadCell and not Couple.Neighbours(tMyCell, tLeadCell) then
      if sHero[tMe]["pathTo"] is not tLeadCell or tMyCell is not among the lines of sHero[tMe]["path"] then
         put Map.FindPath(sGrid, tMyCell, tLeadCell, false) into sHero[tMe]["path"]
         put tLeadCell into sHero[tMe]["pathTo"]
      end if
      put lineOffset(tMyCell, sHero[tMe]["path"]) into tNext
      if tNext > 0 and tNext < the number of lines of sHero[tMe]["path"] then
         put line tNext + 1 of sHero[tMe]["path"] into tNext
         put Couple.CellX(item 1 of tNext) into tTX
         put Couple.CellZ(item 2 of tNext) into tTZ
      end if
      put tTX - sHero[tMe]["x"] into dx
      put tTZ - sHero[tMe]["z"] into dz
      put sqrt(dx * dx + dz * dz) into tDist
   end if
   if tDist < 0.01 then exit Couple.Follow
   -- walking, a little faster than the leader walks; running when more than two rooms behind
   if sqrt((sHero[tLead]["x"] - sHero[tMe]["x"]) ^ 2 + (sHero[tLead]["z"] - sHero[tMe]["z"]) ^ 2) > 2 * kCell then
      put Couple.WalkStep(tMe, "run") into tStep
   else
      put max(Couple.WalkStep(tMe, "walk"), Couple.WalkStep(tLead, "walk") * 1.1) into tStep
   end if
   put min(tStep, tDist) into tStep
   put Couple.TryMove(tMe, dx / tDist * tStep, dz / tDist * tStep) into tMoved
   put tMoved into sHero[tMe]["speed"]
   if tMoved > 0.1 then put Couple.TurnToward(sHero[tMe]["yaw"], atan2(dx, dz), 0.25) into sHero[tMe]["yaw"]
end Couple.Follow

function Couple.Neighbours pA, pB
   return abs(item 1 of pA - item 1 of pB) + abs(item 2 of pA - item 2 of pB) is 1
end Couple.Neighbours

function Couple.TurnToward pFrom, pTo, pRate
   local d
   put pTo - pFrom into d
   repeat while d > pi
      subtract 2 * pi from d
   end repeat
   repeat while d < -pi
      add 2 * pi to d
   end repeat
   return pFrom + d * pRate
end Couple.TurnToward

-- walking plays the walk clip at the speed the hero really moves (no skating);
-- standing plays the idle clip
-- standing: the hero's idle clip. Moving: walk or run, whichever was made for the speed
-- the hero really moves, played at that speed so the feet don't skate
on Couple.Animate pName
   local tSpeed, tWhich, tClip, tN, tKey, tE, tWalk, tRun
   put abs(sHero[pName]["speed"]) into tSpeed
   put Couple.WalkStep(pName, "walk") into tWalk
   put Couple.WalkStep(pName, "run") into tRun
   if tSpeed <= 0.2 then
      put "idle" into tWhich
   else if tSpeed > (tWalk + tRun) / 2 then
      put "run" into tWhich
   else
      put "walk" into tWhich
   end if
   put sHero[pName][tWhich] into tClip
   if tWhich is not sHero[pName]["anim"] then
      put tWhich into sHero[pName]["anim"]
      put 1 into sHero[pName]["frame"]
   end if
   put sClip[tClip]["frames"] into tN
   if tWhich is "idle" then
      add sClip[tClip]["fps"] * sStepMS / 1000 to sHero[pName]["frame"]
   else
      add sHero[pName]["speed"] / Couple.WalkStep(pName, tWhich) * sClip[tClip]["fps"] * sStepMS / 1000 to sHero[pName]["frame"]
   end if
   repeat while sHero[pName]["frame"] >= tN + 1
      subtract tN from sHero[pName]["frame"]
   end repeat
   repeat while sHero[pName]["frame"] < 1
      add tN to sHero[pName]["frame"]
   end repeat
   put sHero[pName]["key"] into tKey
   Couple.SetMesh tKey, "Couple." & tClip & "." & trunc(sHero[pName]["frame"])
   SetObjectPosition tKey, sHero[pName]["x"], 0, sHero[pName]["z"]
   put Couple.Euler(sHero[pName]["yaw"], 0) into tE
   SetObjectRotation tKey, item 1 of tE, item 2 of tE, item 3 of tE
end Couple.Animate

-------------------------------------------------------------------- the ball
-- A Big Ball of Vectors polyhedron loose in the maze: it hops (high enough to be seen over
-- the walls) and rolls along the corridors, and every landing costs it a side.

-- a new ball. pNearStart (the first maze): sitting still two cells up the first hall, so
-- the heroes meet it as soon as they walk (owner: players respond to a ball instantly).
-- Otherwise: a random room away from the first room and the beacon, rolling.
on Couple.BallSpawn pNearStart
   local tCol, tRow, tTries, a
   if sBall["key"] is not empty then Entity.Kill sBall["key"]
   if pNearStart is true then
      if Couple.Open(3, 2) then
         put 4 into tCol
         put 2 into tRow
      else
         put 2 into tCol
         put 4 into tRow
      end if
      put 0 into sBall["vx"]
      put 0 into sBall["vz"]
   else
      put 0 into tTries
      repeat
         add 1 to tTries
         put 2 * random(kRooms) into tCol
         put 2 * random(kRooms) into tRow
         if tCol & comma & tRow is sExitCell then next repeat
         if tCol + tRow > 6 or tTries > 50 then exit repeat
      end repeat
      put random(628) / 100 into a
      put kBallRoll * sin(a) into sBall["vx"]
      put kBallRoll * cos(a) into sBall["vz"]
   end if
   put Couple.CellX(tCol) into sBall["x"]
   put Couple.CellZ(tRow) into sBall["z"]
   put 0 into sBall["h"]
   put kBallHop into sBall["vh"]
   put kBallSides into sBall["sides"]
   put "loose" into sBall["state"]
   if pNearStart is true then
      -- the first ball sits still on the floor, whole, until a hero touches it
      put 0 into sBall["vh"]
      put "resting" into sBall["state"]
   end if
   put empty into sBall["by"]
   put false into sBall["met"]
   put 0 into sBall["cool"]
   put empty into sBall["key"]
   Couple.BallReshape
end Couple.BallSpawn

-- the polyhedron with the sides it has left (as Big Ball of Vectors builds it)
on Couple.BallReshape
   local tName
   if sBall["key"] is not empty then Entity.Kill sBall["key"]
   put "Couple.Ball." & sBall["sides"] into tName
   Mesh.Define tName, MeshSphere(kBallR, max(2, sBall["sides"] div 2), sBall["sides"])
   put Entity.Spawn(tName, sBall["x"], -(kBallR + sBall["h"]), sBall["z"], kBallColor) into sBall["key"]
   SetObjectRotationSpeed sBall["key"], 0.03, 0.05, 0
end Couple.BallReshape

on Couple.BallUpdate
   local tName, dx, dz, d, tX, tZ, tYaw, tSpeed, tKeys, tF, tQ, tE
   if sBall["key"] is empty then exit Couple.BallUpdate
   -- once a press: F picks the ball up when near it and kicks it straight when holding it;
   -- Q kicks it angled right, E angled left
   put Couple.Keys() into tKeys
   put (102 is among the items of tKeys or 70 is among the items of tKeys) into tF
   put (113 is among the items of tKeys or 81 is among the items of tKeys) into tQ
   put (101 is among the items of tKeys or 69 is among the items of tKeys) into tE
   if tF and sKeyWas["f"] is not true then Couple.BallUse
   if tQ and sKeyWas["q"] is not true then Couple.BallKickAngled kKickAngle
   if tE and sKeyWas["e"] is not true then Couple.BallKickAngled -kKickAngle
   put tF into sKeyWas["f"]
   put tQ into sKeyWas["q"]
   put tE into sKeyWas["e"]
   if sBall["state"] is "held" then
      -- in the hands of the hero holding it, at chest height in front
      put sBall["by"] into tName
      put sHero[tName]["yaw"] into tYaw
      put sHero[tName]["x"] + sin(tYaw) * 18 into sBall["x"]
      put sHero[tName]["z"] + cos(tYaw) * 18 into sBall["z"]
      SetObjectPosition sBall["key"], sBall["x"], -34, sBall["z"]
      exit Couple.BallUpdate
   end if
   -- resting on the floor (the first ball): still and whole until a hero touches it
   if sBall["state"] is "resting" then
      repeat for each item tName in "PROMPT,GLAZE"
         put sBall["x"] - sHero[tName]["x"] into dx
         put sBall["z"] - sHero[tName]["z"] into dz
         if dx * dx + dz * dz < 26 * 26 then
            put "loose" into sBall["state"]
            put kBallHop into sBall["vh"]       -- woken: it hops from here (no landing this step)
            exit repeat
         end if
      end repeat
      if sBall["state"] is "resting" then exit Couple.BallUpdate
   end if
   -- hop: every landing costs a side
   subtract kBallGrav from sBall["vh"]
   add sBall["vh"] to sBall["h"]
   if sBall["h"] <= 0 then
      put 0 into sBall["h"]
      put kBallHop into sBall["vh"]
      subtract 1 from sBall["sides"]
      if sBall["sides"] < kBallMinSides then
         -- worn out: it shatters, and a new one turns up somewhere else
         FX.Sparks sBall["x"], -kBallR, sBall["z"], 14, kBallColor
         add 1 to sBallLost
         Couple.BallSay "THE BALL WORE OUT  A NEW ONE IS LOOSE"
         Couple.BallSpawn false
         exit Couple.BallUpdate
      end if
      Couple.BallReshape
   end if
   -- roll; a kicked ball slows down to its rolling speed; walls turn it back
   put sqrt(sBall["vx"] ^ 2 + sBall["vz"] ^ 2) into tSpeed
   if tSpeed > kBallRoll then
      put sBall["vx"] * 0.97 into sBall["vx"]
      put sBall["vz"] * 0.97 into sBall["vz"]
   end if
   put sBall["x"] + sBall["vx"] into tX
   put sBall["z"] + sBall["vz"] into tZ
   if Couple.BallFits(tX, sBall["z"]) then
      put tX into sBall["x"]
   else
      put -sBall["vx"] into sBall["vx"]
   end if
   if Couple.BallFits(sBall["x"], tZ) then
      put tZ into sBall["z"]
   else
      put -sBall["vz"] into sBall["vz"]
   end if
   SetObjectPosition sBall["key"], sBall["x"], -(kBallR + sBall["h"]), sBall["z"]
   -- a hero walking into it kicks it the way the hero faces (harder when running)
   if sBall["cool"] > 0 then subtract 1 from sBall["cool"]
   repeat for each item tName in "PROMPT,GLAZE"
      put sBall["x"] - sHero[tName]["x"] into dx
      put sBall["z"] - sHero[tName]["z"] into dz
      put sqrt(dx * dx + dz * dz) into d
      if d < 26 and sBall["cool"] <= 0 then
         put sHero[tName]["yaw"] into tYaw
         if abs(sHero[tName]["speed"]) > 0.3 then
            put sin(tYaw) * (2.5 + abs(sHero[tName]["speed"]) * 1.5) into sBall["vx"]
            put cos(tYaw) * (2.5 + abs(sHero[tName]["speed"]) * 1.5) into sBall["vz"]
            put 3 into sBall["vh"]
         else if d > 0.01 then
            -- standing still: it just bumps off
            put dx / d * 1.2 into sBall["vx"]
            put dz / d * 1.2 into sBall["vz"]
         end if
         put 12 into sBall["cool"]
         Couple.BallMet tName, "KICKED"
         exit repeat
      end if
   end repeat
end Couple.BallUpdate

-- E: the hero you play picks the ball up when it is near, or kicks it when holding it
on Couple.BallUse
   local dx, dz, tYaw
   if sBall["key"] is empty then exit Couple.BallUse
   if sBall["state"] is "held" then
      if sBall["by"] is not sActive then exit Couple.BallUse
      put sHero[sActive]["yaw"] into tYaw
      put "loose" into sBall["state"]
      put sHero[sActive]["x"] + sin(tYaw) * 30 into sBall["x"]
      put sHero[sActive]["z"] + cos(tYaw) * 30 into sBall["z"]
      if not Couple.BallFits(sBall["x"], sBall["z"]) then
         put sHero[sActive]["x"] into sBall["x"]
         put sHero[sActive]["z"] into sBall["z"]
      end if
      put sin(tYaw) * 6 into sBall["vx"]
      put cos(tYaw) * 6 into sBall["vz"]
      put 22 into sBall["h"]
      put 2 into sBall["vh"]
      put 15 into sBall["cool"]
      Couple.BallSay sActive && "KICKED THE BALL"
      exit Couple.BallUse
   end if
   put sHero[sActive]["x"] - sBall["x"] into dx
   put sHero[sActive]["z"] - sBall["z"] into dz
   if dx * dx + dz * dz < 56 * 56 then          -- within reach: about two thirds of a cell
      put "held" into sBall["state"]
      put sActive into sBall["by"]
      Couple.BallMet sActive, "HAS"
   end if
end Couple.BallUse

-- Q / E: kick the ball at an angle, from the hands or when it is at the feet of the hero you
-- play. pTurn > 0 sends it to the hero's right (D turns right: yaw grows), < 0 to the left.
on Couple.BallKickAngled pTurn
   local dx, dz, tYaw
   if sBall["key"] is empty then exit Couple.BallKickAngled
   if sBall["state"] is "held" and sBall["by"] is not sActive then exit Couple.BallKickAngled
   if sBall["state"] is not "held" then
      put sHero[sActive]["x"] - sBall["x"] into dx
      put sHero[sActive]["z"] - sBall["z"] into dz
      if dx * dx + dz * dz >= 56 * 56 then exit Couple.BallKickAngled   -- out of reach
   end if
   put sHero[sActive]["yaw"] + pTurn into tYaw
   if sBall["state"] is "held" then
      put sHero[sActive]["x"] + sin(tYaw) * 30 into sBall["x"]
      put sHero[sActive]["z"] + cos(tYaw) * 30 into sBall["z"]
      if not Couple.BallFits(sBall["x"], sBall["z"]) then
         put sHero[sActive]["x"] into sBall["x"]
         put sHero[sActive]["z"] into sBall["z"]
      end if
      put 22 into sBall["h"]
   end if
   put "loose" into sBall["state"]
   put sin(tYaw) * 5 into sBall["vx"]
   put cos(tYaw) * 5 into sBall["vz"]
   put 3 into sBall["vh"]
   put 15 into sBall["cool"]
   Couple.BallMet sActive, "KICKED"
   if pTurn > 0 then
      Couple.BallSay sActive && "KICKED THE BALL RIGHT"
   else
      Couple.BallSay sActive && "KICKED THE BALL LEFT"
   end if
end Couple.BallKickAngled

-- the first touch of each ball counts it as found
on Couple.BallMet pName, pHow
   if sBall["met"] is not true then
      put true into sBall["met"]
      add 1 to sBallFound
      FX.Sparks sBall["x"], -kBallR - sBall["h"], sBall["z"], 14, sHero[pName]["color"]
   end if
   Couple.BallSay pName && pHow && "THE BALL  (" & sBall["sides"] && "SIDES LEFT)"
end Couple.BallMet

-- the ball (a circle of radius kBallR) fits at x,z
function Couple.BallFits pX, pZ
   local dx, dz, tCell
   repeat for each item dx in (-kBallR & comma & kBallR)
      repeat for each item dz in (-kBallR & comma & kBallR)
         put Couple.CellAt(pX + dx, pZ + dz) into tCell
         if not Couple.Open(item 1 of tCell, item 2 of tCell) then return false
      end repeat
   end repeat
   return true
end Couple.BallFits

on Couple.BallSay pText
   put pText into sBallMsg
   put sTicks + round(3000 / sStepMS) into sBallMsgUntil
end Couple.BallSay

-- tests: put the loose ball at the hero you play
on Couple.TestBallHere
   put sHero[sActive]["x"] into sBall["x"]
   put sHero[sActive]["z"] into sBall["z"]
   put 0 into sBall["h"]
end Couple.TestBallHere

-------------------------------------------------------------------- camera, beacon, HUD

-- behind and above the hero you play, looking at its chest; pSnap jumps there at once
on Couple.Camera pSnap
   local tH, tX, tZ, tCX, tCY, tCZ, tK, tLY
   put sHero[sActive]["yaw"] into tH
   put sHero[sActive]["x"] into tX
   put sHero[sActive]["z"] into tZ
   put tX - sin(tH) * kCamBack into tCX
   put -kCamUp into tCY
   put tZ - cos(tH) * kCamBack into tCZ
   if pSnap or sCamX is not a number then
      put tCX into sCamX
      put tCY into sCamY
      put tCZ into sCamZ
   else
      put 0.22 into tK
      put sCamX + (tCX - sCamX) * tK into sCamX
      put sCamY + (tCY - sCamY) * tK into sCamY
      put sCamZ + (tCZ - sCamZ) * tK into sCamZ
   end if
   put -1.0 * kM into tLY        -- chest height (up is -Y)
   put atan2(tX - sCamX, tZ - sCamZ) into gCameraYaw
   put -atan2(tLY - sCamY, sqrt((tX - sCamX) ^ 2 + (tZ - sCamZ) ^ 2)) into gCameraPitch
   Engine.SetCam -sCamX, -sCamY, -sCamZ
end Couple.Camera

on Couple.CheckExit
   local tA, tB
   if sNextMazeAt is not empty then exit Couple.CheckExit
   put Couple.CellAt(sHero["PROMPT"]["x"], sHero["PROMPT"]["z"]) into tA
   put Couple.CellAt(sHero["GLAZE"]["x"], sHero["GLAZE"]["z"]) into tB
   if tA is sExitCell and tB is sExitCell then
      put sTicks + round(2500 / sStepMS) into sNextMazeAt
      HUD.Set "Couple.Msg", "MAZE CLEARED  NEW MAZE COMING", gViewLeft + 20, gViewTop + 130, 18
   end if
end Couple.CheckExit

on Couple.ShowHUD
   local tOther
   if sActive is "PROMPT" then
      put "GLAZE" into tOther
   else
      put "PROMPT" into tOther
   end if
   HUD.Set "Couple.Who", "PLAYING " & sActive & "   (TAB: " & tOther & ")", gViewLeft + 20, gViewBottom - 78, 14
   HUD.Set "Couple.Skills", sHero[sActive]["skills"], gViewLeft + 20, gViewBottom - 56, 11
   HUD.Set "Couple.Help", "W S WALK   SHIFT RUN   A D TURN   F BALL   Q E ANGLED KICK   FIND THE GOLD BEACON", gViewLeft + 20, gViewBottom - 30, 11
   if sBall["state"] is "held" then
      HUD.Set "Couple.Ball", sBall["by"] && "HOLDS THE BALL (" & sBall["sides"] && "SIDES)   F: KICK IT   Q E: KICK RIGHT LEFT   FOUND" && sBallFound && "  WORN OUT" && sBallLost, gViewLeft + 20, gViewBottom - 100, 12
   else
      HUD.Set "Couple.Ball", "THE BALL IS LOOSE:" && sBall["sides"] && "SIDES LEFT   WALK INTO IT TO KICK, F TO PICK UP, Q E ANGLED   FOUND" && sBallFound && "  WORN OUT" && sBallLost, gViewLeft + 20, gViewBottom - 100, 12
   end if
   if sBallMsgUntil is a number and sTicks < sBallMsgUntil then
      HUD.Set "Couple.BallMsg", sBallMsg, gViewLeft + 20, gViewTop + 170, 16
   else
      HUD.Remove "Couple.BallMsg"
   end if
   if sMsgUntil is a number and sTicks < sMsgUntil then
      HUD.Set "Couple.Swap", sActive, gViewLeft + 20, gViewTop + 130, 24
   else
      HUD.Remove "Couple.Swap"
   end if
end Couple.ShowHUD

-------------------------------------------------------------------- helpers

-- the keys held down; Couple.TestKeys lets a test drive the game without a keyboard
function Couple.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Couple.Keys

on Couple.TestKeys pKeys
   put pKeys into sTestKeys
end Couple.TestKeys

-- tests: put the hero you play in room-grid cell pCol,pRow
on Couple.TestPlace pCol, pRow
   put Couple.CellX(pCol) into sHero[sActive]["x"]
   put Couple.CellZ(pRow) into sHero[sActive]["z"]
end Couple.TestPlace

function Couple.State
   return sActive & "|" & round(sHero["PROMPT"]["x"]) & "," & round(sHero["PROMPT"]["z"]) & "|" & \
         round(sHero["GLAZE"]["x"]) & "," & round(sHero["GLAZE"]["z"]) & "|" & sHero["PROMPT"]["anim"] & "," & sHero["GLAZE"]["anim"] & \
         "|" & Couple.CellAt(sHero["PROMPT"]["x"], sHero["PROMPT"]["z"]) & ";" & Couple.CellAt(sHero["GLAZE"]["x"], sHero["GLAZE"]["z"]) & \
         "|ball " & sBall["state"] & "," & sBall["sides"] & "," & round(sBall["x"]) & "," & round(sBall["z"]) & "," & sBallFound & "," & sBallLost
end Couple.State

-- swap the mesh an object is drawn with (from Antack)
on Couple.SetMesh pKey, pMesh
   local tOut, tLine
   if gObjectTransforms[pKey]["mesh"] is pMesh then exit Couple.SetMesh
   repeat for each line tLine in gSceneObjects
      if word 2 of tLine is pKey then put pMesh into word 1 of tLine
      put tLine & cr after tOut
   end repeat
   delete the last char of tOut
   put tOut into gSceneObjects
   put pMesh into gObjectTransforms[pKey]["mesh"]
end Couple.SetMesh

-- engine rotation angles for a heading (from Antack.Euler; up is -Y)
function Couple.Euler pYaw, pPitch
   local sy, cy, sp, cp
   put sin(pYaw) into sy
   put cos(pYaw) into cy
   put sin(pPitch) into sp
   put cos(pPitch) into cp
   return atan2(sp, cy * cp) & comma & asin(max(-1, min(1, sy * cp))) & comma & atan2(-sy * sp, cy)
end Couple.Euler

-- LIB_MAP segments (x1,y1,z1,x2,y2,z2; the picture's y runs north, z is height) as an
-- engine wire mesh: x stays, height goes up (-Y), north goes away (-Z)
function Couple.SegmentsToMesh pSegments
   local tMesh, tSeg, tIndex, tA, tB
   put Mesh.New() into tMesh
   set the itemDel to comma
   repeat for each line tSeg in pSegments
      if the number of items of tSeg < 6 then next repeat
      put Couple.Vertex(tMesh, tIndex, item 1 of tSeg, item 2 of tSeg, item 3 of tSeg) into tA
      put Couple.Vertex(tMesh, tIndex, item 4 of tSeg, item 5 of tSeg, item 6 of tSeg) into tB
      Mesh.AddLine tMesh, tA, tB
   end repeat
   return tMesh
end Couple.SegmentsToMesh

function Couple.Vertex @pMesh, @pIndex, pX, pY, pZ
   local tKey
   put pX & "," & pY & "," & pZ into tKey
   if pIndex[tKey] is empty then
      Mesh.AddVertex pMesh, pX, -pZ, -pY
      put the result into pIndex[tKey]
   end if
   return pIndex[tKey]
end Couple.Vertex

-- a gold diamond standing on the floor
function Couple.BeaconMesh
   local tM, tTop, tBot, tA, tB, tC, tD
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -64, 0
   put the result into tTop
   Mesh.AddVertex tM, 0, -4, 0
   put the result into tBot
   Mesh.AddVertex tM, 12, -34, 0
   put the result into tA
   Mesh.AddVertex tM, 0, -34, 12
   put the result into tB
   Mesh.AddVertex tM, -12, -34, 0
   put the result into tC
   Mesh.AddVertex tM, 0, -34, -12
   put the result into tD
   Mesh.AddLine tM, tA, tB
   Mesh.AddLine tM, tB, tC
   Mesh.AddLine tM, tC, tD
   Mesh.AddLine tM, tD, tA
   repeat for each item tB in tA & "," & (tA + 1) & "," & (tA + 2) & "," & (tA + 3)
      Mesh.AddLine tM, tTop, tB
      Mesh.AddLine tM, tBot, tB
   end repeat
   return tM
end Couple.BeaconMesh

-- where a file is (install/LAYOUT.md 5.1): this script's own folder first
-- (LIB_GAMES/Vibecode3D_Games/X/... is <script folder>/X/...), then Vibecode3D Common beside
-- it, then the folders above this stack, and last the owner's projects through WSL (his PC
-- only; the global bNoWSL, a test hook, turns that last one off)
function Couple.FindFile pRelPath
   local tPath, tTry, tShort, tDir, tErr
   global bNoWSL
   put pRelPath into tShort
   if tShort begins with "LIB_GAMES/Vibecode3D_Games/" then delete char 1 to 27 of tShort
   set the itemDel to "/"
   -- the script's file, as the launcher or the game player set it on the stack
   put empty into tDir
   try
      put the uScriptFile of (the long owner of me) into tDir
   catch tErr
      put empty into tDir
   end try
   replace "\" with "/" in tDir
   if tDir contains "/" then
      delete item -1 of tDir
      put tDir & "/" & tShort into tTry
      if there is a file tTry then return tTry
      put item 1 to -2 of tDir & "/Vibecode3D Common/" into tTry
      if there is a file (tTry & pRelPath) then return tTry & pRelPath
      if there is a file (tTry & tShort) then return tTry & tShort
   end if
   put the effective filename of this stack into tPath
   replace "\" with "/" in tPath
   repeat 6 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      put tPath & "/" & pRelPath into tTry
      if there is a file tTry then return tTry
   end repeat
   if bNoWSL is true then return empty
   put "//wsl$/Ubuntu/home/igame3d/projects/" & pRelPath into tTry
   if there is a file tTry then return tTry
   return empty
end Couple.FindFile

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
