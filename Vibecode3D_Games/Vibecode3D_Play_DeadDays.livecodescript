######################################################################################
## CARD SCRIPT: "Play.DeadDays"   DEAD DAYS  (16 Nov 2026)
## A third-person shooter. The dead are in the streets of a small city. A robot hunts them with
## you. Find the police station; inside, the stairs lead up to an office; from the office you
## are somewhere else: a park, and at its far end an alien or ancient temple. Reach its altar.
## Remade from the owner's 2008 iGame3D game (it won best story); every building, prop and
## person is made from its name by iGame3D XT's tools (LIB_EDITOR/iGame3D_XT/Tools).
## CONTROLS  W/S or Up/Down: walk    A/D or Left/Right: turn    Space: shoot
##           1 2 3: pistol, shotgun, rifle (once found)    Escape: pause
## RULES     the dead walk at you and hurt you up close; three hits from the pistol, one from
##           the shotgun up close, two from the rifle put one down. The robot shoots the
##           nearest of them. Weapons lie where you can find them: walk over one. 100 health,
##           3 lives; losing a life starts the place over. 3 places.
######################################################################################

global bPaused, bPlaying

local sMap, sP, sZ, sZN, sRobot, sWalls, sDoor, sGoal, sPick, sKeysWas, sTestKeys
local sLives, sScore, sOver, sWon, sMsg, sMsgT, sHUDWas, sTicks, sQuiet, sNextZ, sTools
local sStairs, sKills

constant kM = 10            -- engine units a metre (as iGame3D XT's tools)
constant kDT = 0.0333       -- seconds a step (30 a second)

on Game.OnStart
   focus on nothing
   Camera.Reset
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put 0 into sKills
   put false into sOver
   put false into sWon
   put 0 into sTicks
   put "pistol" into sP["weapons"]
   put "pistol" into sP["weapon"]
   DD.UseTools
   DD.StartMap 1
end Game.OnStart

-------------------------------------------------------------------- iGame3D XT's tools

-- Tools/v3d_buildings, v3d_props, v3d_figures: beside this script's folder in an install
-- (Vibecode3D Common/Tools), else LIB_EDITOR/iGame3D_XT/Tools above. Without them, boxes.
on DD.UseTools
   local tName, tFile
   put empty into sTools
   repeat for each item tName in "v3d_buildings,v3d_props,v3d_figures"
      if tName is among the lines of the stacksInUse then
         put true into sTools[tName]
         next repeat
      end if
      put DD.FindTool(tName & ".livecodescript") into tFile
      if tFile is not empty then
         start using stack tFile
         put true into sTools[tName]
      end if
   end repeat
end DD.UseTools

function DD.FindTool pFile
   local tDir, tErr, tPath, tTry
   set the itemDelimiter to "/"
   put empty into tDir
   try
      put the uScriptFile of (the long owner of me) into tDir
   catch tErr
      put empty into tDir
   end try
   replace "\" with "/" in tDir
   if tDir contains "/" then
      put item 1 to -3 of tDir & "/Vibecode3D Common/Tools/" & pFile into tTry
      if there is a file tTry then return tTry
   end if
   repeat for each line tPath in (tDir & cr & the effective filename of this stack)
      replace "\" with "/" in tPath
      repeat 8 times
         delete item -1 of tPath
         if tPath is empty then exit repeat
         put tPath & "/LIB_EDITOR/iGame3D_XT/Tools/" & pFile into tTry
         if there is a file tTry then return tTry
      end repeat
   end repeat
   return empty
end DD.FindTool

-------------------------------------------------------------------- the places

on DD.StartMap pMap
   local i
   put pMap into sMap
   Scene.ClearAll
   Particles.Clear
   put empty into sWalls
   put empty into sDoor
   put empty into sGoal
   put empty into sPick
   put empty into sZ
   put 0 into sZN
   put empty into sStairs
   put 0 into sP["y"]
   put 1 into sP["floor"]
   put 100 into sP["hp"]
   put 0 into sP["cool"]
   if sP["weapon"] is empty then put "pistol" into sP["weapon"]
   Mesh.Define "DD.Ground", DD.GroundMesh(pMap)
   get Entity.Spawn("DD.Ground", 0, 0, 0, "#1E3A1E")
   switch pMap
      case 1
         DD.City
         break
      case 2
         DD.Station
         break
      case 3
         DD.Park
         break
   end switch
   -- you, and the robot beside you
   DD.MakePerson "DD.You", "civilian", "#FFE070"
   put Entity.Spawn("DD.You", sP["x"] * kM, 0, sP["z"] * kM, "#FFE070") into sP["key"]
   DD.MakePerson "DD.Robot", "robot", "#80E0FF"
   put sP["x"] + 2 into sRobot["x"]
   put sP["z"] - 1 into sRobot["z"]
   put 30 into sRobot["cool"]
   put Entity.Spawn("DD.Robot", sRobot["x"] * kM, 0, sRobot["z"] * kM, "#80E0FF") into sRobot["key"]
   DD.MakePerson "DD.Dead", "zombie", "#80FF80"
   if not sQuiet then
      repeat with i = 1 to 6 + pMap * 2
         DD.AddZombie empty, empty
      end repeat
   end if
   put 240 into sNextZ
   switch pMap
      case 1
         DD.Say "DEAD DAYS. FIND THE POLICE STATION. THE ROBOT IS ON YOUR SIDE"
         break
      case 2
         DD.Say "THE POLICE STATION. THE STAIRS AT THE BACK GO UP TO THE OFFICE"
         break
      case 3
         DD.Say "WHERE IS THIS? A PARK, AND A TEMPLE AT THE FAR END. REACH ITS ALTAR"
         break
   end switch
   put empty into sHUDWas
   DD.Camera
end DD.StartMap

-- the city: a street of homes and shops, a warehouse, the police station at the east end
on DD.City
   local tX, k, tName, tB, tSide, tTurn, tZ
   put -70 into sP["x"]
   put 0 into sP["z"]
   put 1.5708 into sP["h"]            -- facing east (+x)
   put -80 into tX
   repeat with k = 1 to 12
      if k mod 2 is 1 then
         put 1 into tSide
      else
         put -1 into tSide
      end if
      if k is 11 then
         put "police_station" into tName
      else
         put item (k mod 4) + 1 of "home,shop,home,warehouse" & "_" & k into tName
      end if
      put DD.Building(tName) into tB
      if tSide is 1 then
         put 10 + tB["d"] / 2 into tZ
         put false into tTurn
      else
         put -10 - tB["d"] / 2 into tZ
         put true into tTurn
      end if
      if k mod 2 is 1 then add 4 to tX
      DD.PlaceBuilding tName, tB, tX + tB["w"] / 2, tZ, tTurn
      if tName is "police_station" then
         -- its front door: the first part (Bld.Doors puts a door first), on the street side
         put tX + tB["w"] / 2 + DD.Item(line 1 of tB["parts"], 2) & "," & tZ - tB["d"] / 2 & ",2" into sDoor
         DD.Prop "sign_board", tX + tB["w"] / 2 + 4, tZ - tB["d"] / 2 - 2, 0
      end if
      if k mod 2 is 0 then add max(tB["w"], 12) + 4 to tX
   end repeat
   -- the street
   repeat with k = 0 to 8
      DD.Prop "lamp_post", -75 + k * 20, -8, 0
   end repeat
   DD.Prop "car", -40, -5, 1.5708
   DD.Prop "car", 25, 5, -1.5708
   DD.Prop "road_block", 60, 0, 1.5708
   DD.Prop "crate", -55, 6, 0
   DD.Prop "barrel", 10, -6, 0
   DD.Prop "tree", -78, 9, 0
   -- weapons to find
   DD.AddPick "shotgun", -30, -6
   DD.AddPick "rifle", 35, 6
end DD.City

-- the police station inside: a hall with rooms; the stairs at the back right go up to the office
on DD.Station
   local k
   put 0 into sP["x"]
   put -9 into sP["z"]
   put 0 into sP["h"]                 -- facing in (+z)
   -- the outer walls (20 x 20 m) and the rooms
   DD.Wall -10, -10, 10, -9.6
   DD.Wall -10, 9.6, 10, 10
   DD.Wall -10, -10, -9.6, 10
   DD.Wall 9.6, -10, 10, 10
   DD.Wall -10, -2, -3, -1.7
   DD.Wall -10, 3, -3, 3.3
   DD.Wall 3, -2, 6, -1.7
   DD.Wall 2.8, -2, 3.1, 6
   repeat with k = 0 to 2
      DD.Prop "desk", -7, -6 + k * 5, 0
      DD.Prop "chair", -7, -5.2 + k * 5, 3.14159
   end repeat
   DD.Prop "bench", 0, -4, 0
   DD.Prop "cabinet", 8, -8, 0
   DD.Prop "safe", -9, 8.5, 0
   -- the stairs: x 6 to 9, from z 1 up to z 8 (3.5 m); the office floor above
   put "6,9,1,8,3.5" into sStairs
   DD.Prop "stairs", 7.5, 1.5, 3.14159
   -- the office, upstairs: its desk is the way out (to somewhere else)
   put "-6,6,1.6,2" into sGoal
   DD.PropUp "desk", -6, 6, 0, 3.5
   DD.PropUp "monitor", -6, 6, 0, 4.3
   DD.PropUp "office_chair", -6, 7, 0, 3.5
   DD.PropUp "bookshelf", -9, 6, 1.5708, 3.5
   DD.AddPick "rifle", -6, 6
end DD.Station

-- the park: trees, paths, benches; the temple at the north end, its altar the end
on DD.Park
   local k, tX, tZ
   put 0 into sP["x"]
   put -40 into sP["z"]
   put 0 into sP["h"]
   repeat with k = 1 to 26
      put ((k * 37) mod 80) - 40 into tX
      put ((k * 53) mod 60) - 35 into tZ
      if abs(tX) < 5 then add 8 to tX
      DD.Prop item (k mod 4) + 1 of "tree,pine,bush,dead_tree", tX, tZ, 0
      if k mod 4 < 2 then DD.Wall tX - 0.4, tZ - 0.4, tX + 0.4, tZ + 0.4
   end repeat
   repeat with k = 0 to 3
      DD.Prop "bench", -4, -30 + k * 14, 1.5708
      DD.Prop "lamp_post", 4, -30 + k * 14, 0
   end repeat
   DD.Prop "grave", 20, -20, 0
   DD.Prop "grave", 22, -20, 0
   -- the temple: four stepped blocks, an arch on top, the altar before it
   DD.Temple 0, 40
   put "0,31,2.5,3" into sGoal
   DD.Wall -12, 34, 12, 46
end DD.Park

on DD.Temple pX, pZ
   local tM, k, s
   put DD.Mesh() into tM
   repeat with k = 0 to 3
      put 12 - k * 2.5 into s
      DD.Box tM, 0, k * 2, 0, s * 2, 2, s * 2
   end repeat
   DD.Box tM, -2, 8, 0, 1, 4, 1
   DD.Box tM, 2, 8, 0, 1, 4, 1
   DD.Box tM, 0, 12, 0, 6, 1, 1.2
   -- the altar, in front
   DD.Box tM, 0, 0, -9, 2.4, 1.1, 1.2
   DD.Line tM, -0.8, 1.1, -9, 0, 2.2, -9
   DD.Line tM, 0.8, 1.1, -9, 0, 2.2, -9
   Mesh.Define "DD.Temple", tM
   get Entity.Spawn("DD.Temple", pX * kM, 0, pZ * kM, "#E080FF")
end DD.Temple

-------------------------------------------------------------------- making things

-- a building from iGame3D XT (or a box): returns its plan (w, d, parts)
function DD.Building pName
   local tB
   if sTools["v3d_buildings"] then return Bld.Make(pName)
   put 12 into tB["w"]
   put 10 into tB["d"]
   put "door|0|0|-5|1|2.1|x|60|1" into tB["parts"]
   return tB
end DD.Building

on DD.PlaceBuilding pName, pB, pX, pZ, pTurn
   local tKey, tF, tPart, tPX, tPZ
   if sTools["v3d_buildings"] then
      Mesh.Define "DD.B." & pName, pB["mesh"]
   else
      Mesh.Define "DD.B." & pName, Mesh.Box(pB["w"] * kM, 8 * kM, pB["d"] * kM)
   end if
   put Entity.Spawn("DD.B." & pName, pX * kM, 0, pZ * kM, "#7FA8C8") into tKey
   put 1 into tF
   if pTurn then
      Entity.SetRotation tKey, 0, 3.14159, 0
      put -1 into tF
   end if
   DD.Wall pX - pB["w"] / 2, pZ - pB["d"] / 2, pX + pB["w"] / 2, pZ + pB["d"] / 2
   if not sTools["v3d_buildings"] then exit DD.PlaceBuilding
   -- its doors and windows (the ground floor), boarded up
   set the itemDelimiter to "|"
   repeat for each line tPart in pB["parts"]
      if tPart is empty or item 9 of tPart > 1 then next repeat
      Mesh.Define Bld.PartName(item 1 of tPart, item 5 of tPart, item 6 of tPart, item 7 of tPart), Bld.PartMesh(item 1 of tPart, item 5 of tPart, item 6 of tPart, item 7 of tPart)
      put pX + tF * item 2 of tPart into tPX
      put pZ + tF * item 4 of tPart into tPZ
      get Entity.Spawn(Bld.PartName(item 1 of tPart, item 5 of tPart, item 6 of tPart, item 7 of tPart), tPX * kM, -(item 3 of tPart) * kM, tPZ * kM, "#C08A3A")
   end repeat
   set the itemDelimiter to comma
end DD.PlaceBuilding

on DD.Prop pName, pX, pZ, pRot
   DD.PropUp pName, pX, pZ, pRot, 0
end DD.Prop

on DD.PropUp pName, pX, pZ, pRot, pUp
   local tKey
   if sTools["v3d_props"] then
      Mesh.Define "DD.P." & pName, Prop.Make(pName)
   else
      Mesh.Define "DD.P." & pName, Mesh.Box(1 * kM, 1 * kM, 1 * kM)
   end if
   put Entity.Spawn("DD.P." & pName, pX * kM, -pUp * kM, pZ * kM, "#C0C0C0") into tKey
   if pRot is not 0 then Entity.SetRotation tKey, 0, pRot, 0
end DD.PropUp

on DD.MakePerson pMesh, pRole, pColor
   if sTools["v3d_figures"] then
      Mesh.Define pMesh, Fig.Make(pRole)
   else
      Mesh.Define pMesh, Mesh.Box(0.5 * kM, 1.8 * kM, 0.3 * kM)
   end if
end DD.MakePerson

-- a wall or anything solid: a rectangle on the ground (metres), on the floor being made
on DD.Wall pX1, pZ1, pX2, pZ2
   local tM
   put min(pX1, pX2) & "," & min(pZ1, pZ2) & "," & max(pX1, pX2) & "," & max(pZ1, pZ2) & cr after sWalls
   if sMap is 2 then
      -- the station's walls are drawn too (the city's buildings draw themselves)
      put DD.Mesh() into tM
      DD.Box tM, (pX1 + pX2) / 2, 0, (pZ1 + pZ2) / 2, abs(pX2 - pX1), 3.4, abs(pZ2 - pZ1)
      Mesh.Define "DD.W" & the number of lines of sWalls, tM
      get Entity.Spawn("DD.W" & the number of lines of sWalls, 0, 0, 0, "#7090B0")
   end if
end DD.Wall

on DD.AddPick pWeapon, pX, pZ
   local tKey
   if pWeapon is among the items of sP["weapons"] then exit DD.AddPick
   if sTools["v3d_props"] then
      Mesh.Define "DD.G." & pWeapon, Prop.Make(pWeapon)
   else
      Mesh.Define "DD.G." & pWeapon, Mesh.Box(1 * kM, 0.2 * kM, 0.2 * kM)
   end if
   put Entity.Spawn("DD.G." & pWeapon, pX * kM, 0, pZ * kM, "#FFFF60") into tKey
   put pWeapon & "," & pX & "," & pZ & "," & tKey & cr after sPick
end DD.AddPick

-- one of the dead, at x, z (empty: somewhere open, away from you)
on DD.AddZombie pX, pZ
   local tTries, tOK
   if pX is empty then
      repeat with tTries = 1 to 40
         put random(80) - 40 into pX
         if sMap is 1 then add sP["x"] to pX
         put random(30) - 15 into pZ
         if sMap is 3 then put random(70) - 35 into pZ
         if sMap is 2 then
            put random(18) - 9 into pX
            put random(10) - 4 into pZ
         end if
         put DD.Free(pX, pZ, 0.5) and (abs(pX - sP["x"]) + abs(pZ - sP["z"]) > 14) into tOK
         if tOK then exit repeat
      end repeat
      if not tOK then exit DD.AddZombie
   end if
   add 1 to sZN
   put pX into sZ[sZN]["x"]
   put pZ into sZ[sZN]["z"]
   put 3 into sZ[sZN]["hp"]
   put 0 into sZ[sZN]["bite"]
   put Entity.Spawn("DD.Dead", pX * kM, 0, pZ * kM, "#80FF80") into sZ[sZN]["key"]
end DD.AddZombie

-------------------------------------------------------------------- each step

on Game.OnUpdate
   local tKeys, tFwd, tTurn, tDX, tDZ, k, tN
   put DD.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if DD.Pressed(32, tKeys) then
         put tKeys into sKeysWas
         Game.OnStart
         exit Game.OnUpdate
      end if
      put tKeys into sKeysWas
      DD.ShowHUD
      exit Game.OnUpdate
   end if
   -- walk and turn
   put 0 into tFwd
   if DD.Down(119, tKeys) or DD.Down(65362, tKeys) then put 4.5 into tFwd
   if DD.Down(115, tKeys) or DD.Down(65364, tKeys) then put -2.5 into tFwd
   put 0 into tTurn
   if DD.Down(97, tKeys) or DD.Down(65361, tKeys) then put -2.6 into tTurn
   if DD.Down(100, tKeys) or DD.Down(65363, tKeys) then put 2.6 into tTurn
   add tTurn * kDT to sP["h"]
   put sin(sP["h"]) * tFwd * kDT into tDX
   put cos(sP["h"]) * tFwd * kDT into tDZ
   DD.MovePlayer tDX, tDZ
   -- weapons
   repeat with k = 1 to 3
      if DD.Pressed(48 + k, tKeys) and item k of "pistol,shotgun,rifle" is among the items of sP["weapons"] then
         put item k of "pistol,shotgun,rifle" into sP["weapon"]
         DD.Say toUpper(sP["weapon"])
      end if
   end repeat
   if sP["cool"] > 0 then subtract 1 from sP["cool"]
   if DD.Down(32, tKeys) and sP["cool"] <= 0 then DD.Shoot
   put tKeys into sKeysWas
   DD.Pickups
   DD.Dead
   if sOver then exit Game.OnUpdate
   DD.Robot
   -- more of them come
   subtract 1 from sNextZ
   if sNextZ <= 0 and not sQuiet then
      put 300 - sMap * 40 into sNextZ
      put 0 into tN
      repeat for each key k in sZ
         add 1 to tN
      end repeat
      if tN < 10 + sMap * 2 then DD.AddZombie empty, empty
   end if
   DD.Places
   if sOver then exit Game.OnUpdate
   Entity.SetPosition sP["key"], sP["x"] * kM, -sP["y"] * kM, sP["z"] * kM
   Entity.SetRotation sP["key"], 0, sP["h"] + 3.14159, 0
   DD.Camera
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   DD.ShowHUD
end Game.OnUpdate

-- walk, sliding along walls; on the station's stairs, climb
on DD.MovePlayer pDX, pDZ
   local tS
   if DD.Free(sP["x"] + pDX, sP["z"], 0.4) then add pDX to sP["x"]
   if DD.Free(sP["x"], sP["z"] + pDZ, 0.4) then add pDZ to sP["z"]
   if sStairs is not empty then
      put sStairs into tS
      if sP["x"] >= item 1 of tS and sP["x"] <= item 2 of tS and sP["z"] >= item 3 of tS and sP["z"] <= item 4 of tS then
         put (sP["z"] - item 3 of tS) / (item 4 of tS - item 3 of tS) * item 5 of tS into sP["y"]
      end if
      -- up: the office floor; walk back down the stairs to come down
      if sP["y"] >= item 5 of tS - 0.2 and sP["floor"] is 1 then
         put 2 into sP["floor"]
         DD.Say "UPSTAIRS: THE OFFICE"
      end if
      if sP["floor"] is 2 and sP["y"] < item 5 of tS - 0.5 then put 1 into sP["floor"]
      if sP["floor"] is 2 and not (sP["x"] >= item 1 of tS and sP["x"] <= item 2 of tS and sP["z"] >= item 3 of tS) then put item 5 of tS into sP["y"]
   end if
end DD.MovePlayer

-- nothing solid within pR of x, z (upstairs, only the outer walls count)
function DD.Free pX, pZ, pR
   local tW, k
   put 0 into k
   repeat for each line tW in sWalls
      add 1 to k
      if sP["floor"] is 2 and k > 4 then exit repeat
      if pX > item 1 of tW - pR and pX < item 3 of tW + pR and pZ > item 2 of tW - pR and pZ < item 4 of tW + pR then return false
   end repeat
   return true
end DD.Free

-- the weapon: the nearest of the dead in front of you, within its reach and spread
on DD.Shoot
   local tRange, tSpread, tDmg, k, tBest, tBestD, tA, tD, tDX, tDZ
   switch sP["weapon"]
      case "shotgun"
         put 9 into tRange
         put 0.35 into tSpread
         put 3 into tDmg
         put 22 into sP["cool"]
         break
      case "rifle"
         put 40 into tRange
         put 0.08 into tSpread
         put 2 into tDmg
         put 9 into sP["cool"]
         break
      default
         put 25 into tRange
         put 0.14 into tSpread
         put 1 into tDmg
         put 8 into sP["cool"]
   end switch
   FX.Sparks (sP["x"] + sin(sP["h"]) * 0.8) * kM, -(sP["y"] + 1.3) * kM, (sP["z"] + cos(sP["h"]) * 0.8) * kM, 4, "#FFF0A0"
   put empty into tBest
   put tRange into tBestD
   repeat for each key k in sZ
      put sZ[k]["x"] - sP["x"] into tDX
      put sZ[k]["z"] - sP["z"] into tDZ
      put sqrt(tDX ^ 2 + tDZ ^ 2) into tD
      if tD > tBestD or tD < 0.01 then next repeat
      put atan2(tDX, tDZ) - sP["h"] into tA
      put DD.Wrap(tA) into tA
      if abs(tA) <= tSpread + 0.6 / tD then
         put k into tBest
         put tD into tBestD
      end if
   end repeat
   if tBest is empty then exit DD.Shoot
   DD.HurtZombie tBest, tDmg, true
end DD.Shoot

function DD.Wrap pA
   repeat while pA > 3.14159
      subtract 6.28318 from pA
   end repeat
   repeat while pA < -3.14159
      add 6.28318 to pA
   end repeat
   return pA
end DD.Wrap

on DD.HurtZombie pK, pDmg, pYours
   subtract pDmg from sZ[pK]["hp"]
   FX.Sparks sZ[pK]["x"] * kM, -1.2 * kM, sZ[pK]["z"] * kM, 6, "#A0FF60"
   if sZ[pK]["hp"] > 0 then exit DD.HurtZombie
   Entity.Kill sZ[pK]["key"]
   delete variable sZ[pK]
   if pYours then
      add 10 to sScore
   else
      add 1 to sKills
   end if
   put empty into sHUDWas
end DD.HurtZombie

-- the dead walk at you; close up, they hurt
on DD.Dead
   local k, tDX, tDZ, tD, tSpeed, tNX, tNZ
   repeat for each key k in sZ
      put sP["x"] - sZ[k]["x"] into tDX
      put sP["z"] - sZ[k]["z"] into tDZ
      put sqrt(tDX ^ 2 + tDZ ^ 2) into tD
      put 1.3 + sMap * 0.15 into tSpeed
      if tD > 30 then put 0.4 into tSpeed
      if tD > 0.9 then
         put sZ[k]["x"] + tDX / tD * tSpeed * kDT into tNX
         put sZ[k]["z"] + tDZ / tD * tSpeed * kDT into tNZ
         if DD.Free(tNX, sZ[k]["z"], 0.4) then put tNX into sZ[k]["x"]
         if DD.Free(sZ[k]["x"], tNZ, 0.4) then
            put tNZ into sZ[k]["z"]
         end if
      else if sP["floor"] is 1 then
         subtract 12 * kDT from sP["hp"]
         if sTicks mod 15 is 0 then FX.Sparks sP["x"] * kM, -1.4 * kM, sP["z"] * kM, 5, "#FF4040"
      end if
      Entity.SetPosition sZ[k]["key"], sZ[k]["x"] * kM, 0, sZ[k]["z"] * kM
      Entity.SetRotation sZ[k]["key"], 0, atan2(tDX, tDZ) + 3.14159, 0
   end repeat
   if sP["hp"] <= 0 then
      subtract 1 from sLives
      if sLives <= 0 then
         put true into sOver
         DD.Say "THE DEAD TOOK YOU. SPACE TO TRY AGAIN"
      else
         DD.StartMap sMap
         DD.Say "YOU WENT DOWN. AGAIN, FROM HERE"
      end if
      put empty into sHUDWas
   end if
end DD.Dead

-- the robot: the nearest of the dead within 30 m, walk to 8 m of it, shoot; else stay near you
on DD.Robot
   local k, tBest, tBestD, tD, tTX, tTZ, tDX, tDZ
   put empty into tBest
   put 30 into tBestD
   repeat for each key k in sZ
      put sqrt((sZ[k]["x"] - sRobot["x"]) ^ 2 + (sZ[k]["z"] - sRobot["z"]) ^ 2) into tD
      if tD < tBestD then
         put k into tBest
         put tD into tBestD
      end if
   end repeat
   if tBest is empty then
      put sP["x"] - sin(sP["h"]) * 2 + cos(sP["h"]) * 2 into tTX
      put sP["z"] - cos(sP["h"]) * 2 - sin(sP["h"]) * 2 into tTZ
   else
      put sZ[tBest]["x"] into tTX
      put sZ[tBest]["z"] into tTZ
   end if
   put tTX - sRobot["x"] into tDX
   put tTZ - sRobot["z"] into tDZ
   put sqrt(tDX ^ 2 + tDZ ^ 2) into tD
   if tD > 8 or (tBest is empty and tD > 1) then
      if DD.Free(sRobot["x"] + tDX / tD * 3 * kDT, sRobot["z"], 0.4) then add tDX / tD * 3 * kDT to sRobot["x"]
      if DD.Free(sRobot["x"], sRobot["z"] + tDZ / tD * 3 * kDT, 0.4) then add tDZ / tD * 3 * kDT to sRobot["z"]
   end if
   if sRobot["cool"] > 0 then subtract 1 from sRobot["cool"]
   if sRobot["off"] is true then put 1 into sRobot["cool"]
   -- it helps, it doesn't win the game for you: a shot every 2 s, three to put one down
   if tBest is not empty and tBestD <= 12 and sRobot["cool"] <= 0 then
      put 60 into sRobot["cool"]
      FX.Sparks sRobot["x"] * kM, -1.5 * kM, sRobot["z"] * kM, 4, "#80E0FF"
      DD.HurtZombie tBest, 1, false
   end if
   if sP["floor"] is 2 then
      Entity.SetPosition sRobot["key"], sRobot["x"] * kM, -sP["y"] * kM, sRobot["z"] * kM
   else
      Entity.SetPosition sRobot["key"], sRobot["x"] * kM, 0, sRobot["z"] * kM
   end if
   if tD > 0.01 then Entity.SetRotation sRobot["key"], 0, atan2(tDX, tDZ) + 3.14159, 0
end DD.Robot

-- weapons lying about: walk over one
on DD.Pickups
   local tLine, tOut
   repeat for each line tLine in sPick
      if tLine is empty then next repeat
      if abs(item 2 of tLine - sP["x"]) < 1.5 and abs(item 3 of tLine - sP["z"]) < 1.5 and (abs(sP["y"]) < 0.5 or sMap is 2) then
         if not (item 1 of tLine is among the items of sP["weapons"]) then put comma & item 1 of tLine after sP["weapons"]
         put item 1 of tLine into sP["weapon"]
         Entity.Kill item 4 of tLine
         DD.Say "A" && toUpper(item 1 of tLine) & "! (" & item 1 of tLine & " is key" && itemOffset(item 1 of tLine, "pistol,shotgun,rifle") & ")"
      else
         put tLine & cr after tOut
      end if
   end repeat
   put tOut into sPick
end DD.Pickups

-- the door, the office, the altar
on DD.Places
   if sDoor is not empty and abs(item 1 of sDoor - sP["x"]) < item 3 of sDoor and abs(item 2 of sDoor - sP["z"]) < 2.5 then
      add 100 to sScore
      DD.StartMap 2
      exit DD.Places
   end if
   if sGoal is empty then exit DD.Places
   if sMap is 2 and sP["floor"] is not 2 then exit DD.Places
   if abs(item 1 of sGoal - sP["x"]) < item 3 of sGoal and abs(item 2 of sGoal - sP["z"]) < item 4 of sGoal then
      if sMap is 2 then
         add 200 to sScore
         DD.StartMap 3
         DD.Say "THE OFFICE... AND THEN YOU ARE SOMEWHERE ELSE"
      else
         add 500 to sScore
         put true into sWon
         put true into sOver
         DD.Say "TO BE CONTINUED..."
         put empty into sHUDWas
         DD.ShowHUD
      end if
   end if
end DD.Places

-------------------------------------------------------------------- the camera: behind and above you

on DD.Camera
   local tCX, tCY, tCZ, tTX, tTY, tTZ, tDX, tDY, tDZ
   put (sP["x"] - sin(sP["h"]) * 7) * kM into tCX
   put (sP["z"] - cos(sP["h"]) * 7) * kM into tCZ
   put -(sP["y"] + 4.2) * kM into tCY
   put (sP["x"] + sin(sP["h"]) * 3) * kM into tTX
   put (sP["z"] + cos(sP["h"]) * 3) * kM into tTZ
   put -(sP["y"] + 1.2) * kM into tTY
   put tTX - tCX into tDX
   put tTY - tCY into tDY
   put tTZ - tCZ into tDZ
   Camera.SetPosition tCX, tCY, tCZ
   Camera.SetLook atan2(tDX, tDZ), -atan2(tDY, sqrt(tDX ^ 2 + tDZ ^ 2))
end DD.Camera

-------------------------------------------------------------------- the HUD and the words

on DD.Say pText
   put pText into sMsg
   put 90 into sMsgT
   put empty into sHUDWas
end DD.Say

on DD.ShowHUD
   local tWords, tN, k, tLine
   put 0 into tN
   repeat for each key k in sZ
      add 1 to tN
   end repeat
   put sMap & "|" & round(sP["hp"]) & "|" & sLives & "|" & sScore & "|" & sP["weapon"] & "|" & tN & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit DD.ShowHUD
   put tWords into sHUDWas
   HUD.Set "DD.Score", item sMap of "THE CITY,THE POLICE STATION,THE PARK" & "   HEALTH" && round(sP["hp"]) & "   LIVES" && sLives & "   SCORE" && sScore & "   " & toUpper(sP["weapon"]) & "   THE DEAD" && tN, 20, 30, 14
   if sOver and sWon then
      put "TO BE CONTINUED...   SCORE" && sScore & ".  SPACE TO PLAY AGAIN" into tLine
   else if sOver then
      put "GAME OVER.  SPACE TO TRY AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else
      put "W/S: WALK   A/D: TURN   SPACE: SHOOT   1 2 3: WEAPON" into tLine
   end if
   HUD.Set "DD.Msg", tLine, 20, 56, 12
end DD.ShowHUD

function DD.State
   local tN, k
   put 0 into tN
   repeat for each key k in sZ
      add 1 to tN
   end repeat
   return sMap & "|hp " & round(sP["hp"]) & "|lives " & sLives & "|" & sScore & "|" & sP["weapon"] & "|at " & round(sP["x"], 1) & "," & round(sP["z"], 1) & "," & round(sP["y"], 1) & "|floor " & sP["floor"] & "|dead " & tN & "|robot " & sKills & "|" & sOver & "|" & sWon
end DD.State

-------------------------------------------------------------------- keys and test hooks

function DD.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end DD.Keys

function DD.Down pCode, pKeys
   return pCode is among the items of pKeys
end DD.Down

function DD.Pressed pCode, pKeys
   return pCode is among the items of pKeys and pCode is not among the items of sKeysWas
end DD.Pressed

on DD.TestKeys pKeys
   put pKeys into sTestKeys
end DD.TestKeys

on DD.TestPlace pX, pZ, pH
   put pX into sP["x"]
   put pZ into sP["z"]
   if pH is not empty then put pH into sP["h"]
end DD.TestPlace

-- the robot holds its fire (pFlag true), or not
on DD.TestRobot pOff
   put pOff into sRobot["off"]
end DD.TestRobot

-- no dead come by themselves (the tests add their own)
on DD.TestQuiet pFlag
   put pFlag into sQuiet
end DD.TestQuiet

on DD.TestZombie pX, pZ
   DD.AddZombie pX, pZ
end DD.TestZombie

on DD.TestMap pMap
   DD.StartMap pMap
end DD.TestMap

function DD.Door
   return sDoor
end DD.Door

function DD.Tools
   return sTools["v3d_buildings"] & "," & sTools["v3d_props"] & "," & sTools["v3d_figures"]
end DD.Tools

function DD.WallCount
   return the number of lines of sWalls
end DD.WallCount

function DD.Item pText, pN
   set the itemDelimiter to "|"
   return item pN of pText
end DD.Item

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

-------------------------------------------------------------------- a little wire for the temple and the walls

function DD.Mesh
   local tM
   put 0 into tM["count"]
   put empty into tM["faces"]
   put empty into tM["lines"]
   return tM
end DD.Mesh

on DD.Line @pM, pX1, pY1, pZ1, pX2, pY2, pZ2
   add 1 to pM["count"]
   put pX1 * kM into pM["vx"][pM["count"]]
   put -pY1 * kM into pM["vy"][pM["count"]]
   put pZ1 * kM into pM["vz"][pM["count"]]
   add 1 to pM["count"]
   put pX2 * kM into pM["vx"][pM["count"]]
   put -pY2 * kM into pM["vy"][pM["count"]]
   put pZ2 * kM into pM["vz"][pM["count"]]
   if pM["lines"] is empty then
      put pM["count"] - 1 && pM["count"] into pM["lines"]
   else
      put cr & pM["count"] - 1 && pM["count"] after pM["lines"]
   end if
end DD.Line

on DD.Box @pM, pX, pY, pZ, pW, pH, pD
   local x1, x2, z1, z2, y2
   put pX - pW / 2 into x1
   put pX + pW / 2 into x2
   put pZ - pD / 2 into z1
   put pZ + pD / 2 into z2
   put pY + pH into y2
   DD.Line pM, x1, pY, z1, x2, pY, z1
   DD.Line pM, x2, pY, z1, x2, pY, z2
   DD.Line pM, x2, pY, z2, x1, pY, z2
   DD.Line pM, x1, pY, z2, x1, pY, z1
   DD.Line pM, x1, y2, z1, x2, y2, z1
   DD.Line pM, x2, y2, z1, x2, y2, z2
   DD.Line pM, x2, y2, z2, x1, y2, z2
   DD.Line pM, x1, y2, z2, x1, y2, z1
   DD.Line pM, x1, pY, z1, x1, y2, z1
   DD.Line pM, x2, pY, z1, x2, y2, z1
   DD.Line pM, x2, pY, z2, x2, y2, z2
   DD.Line pM, x1, pY, z2, x1, y2, z2
end DD.Box

-- the ground: a grid, bigger for the city and the park
function DD.GroundMesh pMap
   local tM, k, tS, tN
   put DD.Mesh() into tM
   put 100 into tS
   put 20 into tN
   if pMap is 2 then
      put 10 into tS
      put 10 into tN
   end if
   repeat with k = 0 to tN
      DD.Line tM, -tS + k * tS * 2 / tN, 0, -tS, -tS + k * tS * 2 / tN, 0, tS
      DD.Line tM, -tS, 0, -tS + k * tS * 2 / tN, tS, 0, -tS + k * tS * 2 / tN
   end repeat
   return tM
end DD.GroundMesh
