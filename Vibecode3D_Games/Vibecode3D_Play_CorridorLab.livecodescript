######################################################################################
## CARD SCRIPT: "Play.CorridorLab"   CORRIDOR LAB  (11 23 2026)
## Our own first-person corridor shooter, drawn by a raycaster in plain xTalk (LIB_RAYCAST).
## Dedicated to the memory of Scott McDonald (The LiveCode Lab): his raycaster joined rays into
## wall polygons, and level 1 is his own map. Three looks: his solid walls, Vibecode3D glass, lines.
## CONTROLS  W/S or Up/Down: walk   Left/Right: turn   A/D: step aside   Shift: run   Space: fire
##           E: open a door (walking into one opens it too)   V: the look   C: rays   Escape: pause
## RULES     reach the green exit pad. Grunts walk at you, spitters spit. A key opens gold doors.
##           3 levels. Health, ammo and the key carry on to the next level.
## NEEDS     ../LIB_RAYCAST/livecode/lib_raycast.livecodescript, found by Game.FindFile.
######################################################################################
-- Engine 1 (Vibecode3D, pure xTalk) card; the engine draws nothing here: the game draws its own
-- polygons in a group "CL.View" just above the engine's picture, so the host's menu and the
-- loading screen stay above it. Test: OXT-BEYOND/tests/t77_corridor_lab.txt.

global bPaused, bPlaying
global gViewLeft, gViewTop, gViewRight, gViewBottom

local sCard, sG, sGWas, sMap, sLevel, sX, sY, sA, sHP, sAmmo, sKeys, sKills, sOver, sWon, sT
local sMon, sItem, sOrb, sOrbN, sDoor, sLook, sLookPicked, sRays, sTestKeys, sKeyWas
local sFire, sFlash, sHurt, sBob, sMsg, sMsgUntil, sHUDWas, sSeen, sCover, sCoverT
local sStartHP, sStartAmmo, sStartKeys, sFPS, sFPSN, sFPSAt, sDrawMS, sBump

constant kFOV = 66
constant kFaces = 60
constant kSprites = 16
constant kWalk = 0.075
constant kTurn = 4
constant kRadius = 0.25
constant kSolid = "#BRGDLd"
constant kRayList = "80,120,160,240"
constant kLooks = "solid,glass,lines"

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   if not CL.LoadRaycast() then
      HUD.Set "CL.Err", "CORRIDOR LAB needs LIB_RAYCAST/livecode/lib_raycast.livecodescript", 20, 200, 14
      exit Game.OnStart
   end if
   put 120 into sRays
   put empty into sLook
   put false into sLookPicked
   put empty into sKeyWas
   put empty into sMap
   put 100 into sHP
   put 30 into sAmmo
   put 0 into sKeys
   put 0 into sKills
   CL.MakeView
   CL.CoverShow
end Game.OnStart

function CL.LoadRaycast
   local tLib, tErr
   if "lib_raycast" is among the lines of the stacksInUse then return true
   try
      put Game.FindFile("LIB_RAYCAST/livecode/lib_raycast.livecodescript") into tLib
   catch tErr
      put empty into tLib
   end try
   if tLib is empty then return false
   start using stack tLib
   return ("lib_raycast" is among the lines of the stacksInUse)
end CL.LoadRaycast

-------------------------------------------------------------------- the dedication

on CL.CoverShow
   put true into sCover
   put 0 into sCoverT
   set the text of field "CL.Words" of sCard to CL.Dedication()
   set the visible of graphic "CL.Cover" of sCard to true
   set the visible of field "CL.Words" of sCard to true
end CL.CoverShow

function CL.Dedication
   return "IN MEMORY OF" & cr & cr & "SCOTT McDONALD" & cr & "The LiveCode Lab" & cr & cr & \
         "He wrote the only book of LiveCode games ever published," & cr & \
         "and gave everyone his LiveCode raycaster." & cr & \
         "Its walls are the first walls of this lab," & cr & \
         "and level 1 is his map." & cr & cr & cr & "any key"
end CL.Dedication

on CL.CoverTick pKeys
   -- the host's own loading screen first (it would turn our Loading.Go away while it runs)
   if "LIB_LOADING" is among the lines of the stacksInUse then
      if Loading.Busy() then exit CL.CoverTick
   end if
   add 1 to sCoverT
   if (sCoverT > 30 and pKeys is not empty and pKeys is not 0) or sCoverT > 150 then
      put false into sCover
      set the visible of graphic "CL.Cover" of sCard to false
      set the visible of field "CL.Words" of sCard to false
      put pKeys into sKeyWas          -- the key that closed it does not also fire
      CL.GoLevel 1
   end if
end CL.CoverTick

-------------------------------------------------------------------- levels

on CL.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      CL.StartLevel pLevel
   end if
end CL.GoLevel

on CL.StartLevel pLevel
   local tR, tC, tLine, tCh, tN
   if sCard is empty then CL.MakeView
   if sCover then
      put false into sCover
      set the visible of graphic "CL.Cover" of sCard to false
      set the visible of field "CL.Words" of sCard to false
   end if
   put pLevel into sLevel
   put CL.Map(pLevel) into sMap
   put empty into sMon
   put empty into sItem
   put empty into sOrb
   put 0 into sOrbN
   put empty into sDoor
   put 0 into tN
   put 0 into tR
   repeat for each line tLine in sMap
      add 1 to tR
      put 0 into tC
      repeat for each char tCh in tLine
         add 1 to tC
         switch tCh
            case "P"
               put tC - 0.5 into sX
               put tR - 0.5 into sY
               put space into char tC of line tR of sMap
               break
            case "m"
            case "s"
               add 1 to tN
               put tC - 0.5 into sMon[tN]["x"]
               put tR - 0.5 into sMon[tN]["y"]
               put tCh into sMon[tN]["kind"]
               if tCh is "m" then
                  put 30 into sMon[tN]["hp"]
               else
                  put 20 into sMon[tN]["hp"]
               end if
               put false into sMon[tN]["awake"]
               put random(20) into sMon[tN]["cool"]
               put 0 into sMon[tN]["hurt"]
               put 0 into sMon[tN]["dying"]
               put false into sMon[tN]["dead"]
               put random(30) into sMon[tN]["step"]
               put space into char tC of line tR of sMap
               break
            case "h"
            case "a"
            case "k"
               put tCh into sItem[tC & comma & tR]
               put space into char tC of line tR of sMap
               break
         end switch
      end repeat
   end repeat
   Ray.SetSolid kSolid
   Ray.SetMap sMap
   put CL.OpenWay(sX, sY) into sA
   if sLevel is 1 and sStartHP is empty then
      put 100 into sHP
      put 30 into sAmmo
      put 0 into sKeys
   end if
   put max(sHP, 50) into sHP
   put sHP into sStartHP
   put sAmmo into sStartAmmo
   put sKeys into sStartKeys
   put false into sOver
   put false into sWon
   put 0 into sT
   put 0 into sFire
   put 0 into sFlash
   put 0 into sHurt
   put 0 into sBump
   put empty into sHUDWas
   if not sLookPicked then
      if sLevel is 1 then
         put "solid" into sLook
      else
         put "glass" into sLook
      end if
   end if
   CL.Say item sLevel of "SCOTT'S LAB,THE GOLD DOOR,THE GLASS HALL" & "   (E OPENS DOORS, V CHANGES THE LOOK)", 4
   CL.Draw
   CL.ShowHUD
end CL.StartLevel

-- face the longest open way from the start
function CL.OpenWay pX, pY
   local tBest, tBestD, tA, tHit
   put 0 into tBest
   put -1 into tBestD
   repeat for each item tA in "0,90,180,270"
      put Ray.Cast(pX, pY, tA, 30) into tHit
      if tHit is not empty and item 1 of tHit > tBestD then
         put item 1 of tHit into tBestD
         put tA into tBest
      end if
   end repeat
   return tBest
end CL.OpenWay

-------------------------------------------------------------------- the frame

function CL.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end CL.Keys

on CL.TestKeys pKeys
   put pKeys into sTestKeys
end CL.TestKeys

-- the item after pNow in pList (round to the first)
function CL.NextItem pList, pNow
   local tN
   repeat with tN = 1 to the number of items of pList
      if item tN of pList is pNow then return item (tN mod the number of items of pList) + 1 of pList
   end repeat
   return item 1 of pList
end CL.NextItem

-- a key just pressed (down now, not down last frame)
function CL.Pressed pKey, pKeys
   return (pKey is among the items of pKeys) and not (pKey is among the items of sKeyWas)
end CL.Pressed

on Game.OnUpdate
   local tKeys, tMove, tSide, tSpeed, tDX, tDY, tA, tHit, tCell, tWas
   if sCard is empty then exit Game.OnUpdate
   CL.CountFPS
   put CL.Keys() into tKeys
   if sCover then
      CL.CoverTick tKeys
      exit Game.OnUpdate
   end if
   if sMap is empty then exit Game.OnUpdate
   add 1 to sT
   -- V the look, C the rays
   if CL.Pressed(118, tKeys) then
      put CL.NextItem(kLooks, sLook) into sLook
      put true into sLookPicked
      put empty into sHUDWas
   end if
   if CL.Pressed(99, tKeys) then
      put CL.NextItem(kRayList, sRays) into sRays
      put empty into sHUDWas
   end if
   if sOver then
      if CL.Pressed(32, tKeys) then
         if sWon then
            put empty into sStartHP
            put 0 into sKills
            CL.GoLevel 1
         else
            put sStartHP into sHP
            put max(sStartAmmo, 20) into sAmmo
            put sStartKeys into sKeys
            put 100 into sHP
            CL.StartLevel sLevel
         end if
      end if
      put tKeys into sKeyWas
      CL.Draw
      CL.ShowHUD
      exit Game.OnUpdate
   end if
   -- turning and walking
   if 65361 is among the items of tKeys then subtract kTurn from sA
   if 65363 is among the items of tKeys then add kTurn to sA
   put sA mod 360 into sA
   if sA < 0 then add 360 to sA
   put 0 into tMove
   put 0 into tSide
   if 65362 is among the items of tKeys or 119 is among the items of tKeys then add 1 to tMove
   if 65364 is among the items of tKeys or 115 is among the items of tKeys then subtract 1 from tMove
   if 97 is among the items of tKeys then subtract 1 from tSide
   if 100 is among the items of tKeys then add 1 to tSide
   put kWalk into tSpeed
   if 65505 is among the items of tKeys or 65506 is among the items of tKeys then put kWalk * 1.7 into tSpeed
   if tMove is not 0 or tSide is not 0 then
      put sA * pi / 180 into tA
      put (cos(tA) * tMove - sin(tA) * tSide) * tSpeed into tDX
      put (sin(tA) * tMove + cos(tA) * tSide) * tSpeed into tDY
      Ray.Move sX, sY, tDX, tDY, kRadius
      add 0.35 to sBob
      -- walking into a plain door opens it
      if tMove > 0 then
         put Ray.Cast(sX, sY, sA, 2) into tHit
         if tHit is not empty and item 1 of tHit < 0.45 and item 5 of tHit is "D" then CL.OpenDoor item 2 of tHit, item 3 of tHit
      end if
   end if
   -- E: the door ahead
   if CL.Pressed(101, tKeys) then
      put Ray.Cast(sX, sY, sA, 3) into tHit
      if tHit is not empty and item 1 of tHit < 1.6 then
         if item 5 of tHit is "D" then
            CL.OpenDoor item 2 of tHit, item 3 of tHit
         else if item 5 of tHit is "L" then
            if sKeys > 0 then
               CL.OpenDoor item 2 of tHit, item 3 of tHit
               CL.Say "THE KEY TURNS.", 2
            else
               CL.Say "A GOLD DOOR. FIND THE KEY.", 2
            end if
         end if
      end if
   end if
   -- Space: fire
   if sFire > 0 then subtract 1 from sFire
   if sFlash > 0 then subtract 1 from sFlash
   if 32 is among the items of tKeys and sFire is 0 then CL.Fire
   CL.Doors
   CL.Pickups
   CL.Monsters
   CL.Orbs
   if sHurt > 0 then subtract 1 from sHurt
   -- the exit pad
   put Ray.Cell(trunc(sX) + 1, trunc(sY) + 1) into tCell
   if tCell is "X" and not sOver then
      if sLevel >= 3 then
         put true into sOver
         put true into sWon
         put empty into sHUDWas
      else
         put tKeys into sKeyWas
         CL.GoLevel sLevel + 1
         exit Game.OnUpdate
      end if
   end if
   put tKeys into sKeyWas
   CL.Draw
   CL.ShowHUD
end Game.OnUpdate

-------------------------------------------------------------------- doors, things, monsters

on CL.OpenDoor pC, pR
   Ray.SetCell pC, pR, "d"
   put 10 into sDoor[pC & comma & pR]
end CL.OpenDoor

on CL.Doors
   local tK
   repeat for each key tK in sDoor
      subtract 1 from sDoor[tK]
      if sDoor[tK] <= 0 then
         Ray.SetCell item 1 of tK, item 2 of tK, space
         delete variable sDoor[tK]
      end if
   end repeat
end CL.Doors

on CL.Pickups
   local tK
   put trunc(sX) + 1 & comma & trunc(sY) + 1 into tK
   if sItem[tK] is empty then exit CL.Pickups
   switch sItem[tK]
      case "h"
         if sHP >= 100 then exit CL.Pickups
         put min(100, sHP + 25) into sHP
         CL.Say "HEALTH +25", 1
         break
      case "a"
         add 12 to sAmmo
         CL.Say "AMMO +12", 1
         break
      case "k"
         add 1 to sKeys
         CL.Say "A GOLD KEY.", 2
         break
   end switch
   delete variable sItem[tK]
   put empty into sHUDWas
end CL.Pickups

on CL.Fire
   local tBest, tBestD, tN, tCX
   if sAmmo <= 0 then
      CL.Say "NO AMMO.", 1
      put 12 into sFire
      exit CL.Fire
   end if
   subtract 1 from sAmmo
   put 9 into sFire
   put 3 into sFlash
   put empty into sHUDWas
   put CL.ViewW() / 2 into tCX
   put empty into tBest
   repeat for each key tN in sSeen
      if item 1 of sSeen[tN] <= tCX and item 2 of sSeen[tN] >= tCX then
         if tBest is empty or item 3 of sSeen[tN] < tBestD then
            put tN into tBest
            put item 3 of sSeen[tN] into tBestD
         end if
      end if
   end repeat
   if tBest is empty then exit CL.Fire
   subtract 15 from sMon[tBest]["hp"]
   put 4 into sMon[tBest]["hurt"]
   put true into sMon[tBest]["awake"]
   if sMon[tBest]["hp"] <= 0 then
      put true into sMon[tBest]["dead"]
      put 10 into sMon[tBest]["dying"]
      add 1 to sKills
   end if
end CL.Fire

on CL.Hurt pN
   if sOver then exit CL.Hurt
   subtract pN from sHP
   put 6 into sHurt
   put empty into sHUDWas
   if sHP <= 0 then
      put 0 into sHP
      put true into sOver
      put false into sWon
   end if
end CL.Hurt

on CL.Monsters
   local tN, tDX, tDY, tD, tSp, tMX, tMY
   repeat for each key tN in sMon
      if sMon[tN]["dead"] then
         if sMon[tN]["dying"] > 0 then subtract 1 from sMon[tN]["dying"]
         next repeat
      end if
      if sMon[tN]["hurt"] > 0 then subtract 1 from sMon[tN]["hurt"]
      if sMon[tN]["cool"] > 0 then subtract 1 from sMon[tN]["cool"]
      put sX - sMon[tN]["x"] into tDX
      put sY - sMon[tN]["y"] into tDY
      put sqrt(tDX * tDX + tDY * tDY) into tD
      if not sMon[tN]["awake"] then
         if tD < 9 and (sT + tN) mod 8 is 0 then
            if Ray.Sees(sMon[tN]["x"], sMon[tN]["y"], sX, sY) then put true into sMon[tN]["awake"]
         end if
         next repeat
      end if
      if tD < 0.01 then next repeat
      put sMon[tN]["x"] into tMX
      put sMon[tN]["y"] into tMY
      if sMon[tN]["kind"] is "m" then
         if tD > 0.65 then
            put 0.035 into tSp
            Ray.Move tMX, tMY, tDX / tD * tSp, tDY / tD * tSp, 0.3
            add 1 to sMon[tN]["step"]
         else if sMon[tN]["cool"] <= 0 then
            CL.Hurt 10
            put 24 into sMon[tN]["cool"]
         end if
      else
         if tD > 4.5 then
            Ray.Move tMX, tMY, tDX / tD * 0.025, tDY / tD * 0.025, 0.3
         else if tD < 2.5 then
            Ray.Move tMX, tMY, -tDX / tD * 0.025, -tDY / tD * 0.025, 0.3
         end if
         add 1 to sMon[tN]["step"]
         if sMon[tN]["cool"] <= 0 and tD < 12 then
            if Ray.Sees(tMX, tMY, sX, sY) then
               add 1 to sOrbN
               put tMX into sOrb[sOrbN]["x"]
               put tMY into sOrb[sOrbN]["y"]
               put tDX / tD * 0.12 into sOrb[sOrbN]["vx"]
               put tDY / tD * 0.12 into sOrb[sOrbN]["vy"]
               put 200 into sOrb[sOrbN]["life"]
            end if
            put 75 into sMon[tN]["cool"]
         end if
      end if
      put tMX into sMon[tN]["x"]
      put tMY into sMon[tN]["y"]
   end repeat
end CL.Monsters

on CL.Orbs
   local tN, tDX, tDY
   repeat for each key tN in sOrb
      add sOrb[tN]["vx"] to sOrb[tN]["x"]
      add sOrb[tN]["vy"] to sOrb[tN]["y"]
      subtract 1 from sOrb[tN]["life"]
      put sX - sOrb[tN]["x"] into tDX
      put sY - sOrb[tN]["y"] into tDY
      if tDX * tDX + tDY * tDY < 0.35 * 0.35 then
         CL.Hurt 12
         delete variable sOrb[tN]
      else if Ray.SolidAt(sOrb[tN]["x"], sOrb[tN]["y"]) or sOrb[tN]["life"] <= 0 then
         delete variable sOrb[tN]
      end if
   end repeat
end CL.Orbs

-------------------------------------------------------------------- the view (our own graphics)

function CL.ViewRect
   if gViewRight is a number and gViewBottom is a number and gViewRight > gViewLeft then
      return gViewLeft & comma & gViewTop & comma & gViewRight & comma & gViewBottom
   end if
   return the rect of sCard
end CL.ViewRect

function CL.ViewW
   local tR
   put CL.ViewRect() into tR
   return item 3 of tR - item 1 of tR
end CL.ViewW

-- the highest layer of the engine's own picture (VB_n line graphics, or the bench's image "view")
function CL.PictureLayer
   local tTop, i, tName
   put 0 into tTop
   repeat with i = 1 to the number of controls of sCard
      put the short name of control i of sCard into tName
      if tName begins with "VB_" or (tName is "view" and word 1 of the name of control i of sCard is "image") then put max(tTop, i) into tTop
   end repeat
   return tTop
end CL.PictureLayer

-- one pool of graphics, made once; template colours set before every create (house rule)
on CL.MakeView
   local tR, tN, tName
   put the long id of me into sCard
   if word 1 of sCard is not "card" then put the long id of this card into sCard
   if there is a group "CL.View" of sCard then delete group "CL.View" of sCard
   put empty into sG
   put empty into sGWas
   put CL.ViewRect() into tR
   lock messages
   lock screen
   reset the templateGroup
   create group "CL.View"
   set the margins of group "CL.View" of sCard to 0
   set the showBorder of group "CL.View" of sCard to false
   reset the templateGraphic
   set the backgroundColor of the templateGraphic to "0,0,0"
   set the foregroundColor of the templateGraphic to "0,0,0"
   set the lineSize of the templateGraphic to 0
   set the opaque of the templateGraphic to true
   set the style of the templateGraphic to "rectangle"
   set the rect of the templateGraphic to tR
   CL.NewGraphic "CL.Back"
   set the backgroundColor of the templateGraphic to "56,56,64"
   CL.NewGraphic "CL.Sky"
   set the backgroundColor of the templateGraphic to "90,82,72"
   CL.NewGraphic "CL.Floor"
   set the fillGradient["type"] of graphic "CL.Floor" of sCard to "linear"
   set the style of the templateGraphic to "line"
   set the opaque of the templateGraphic to false
   set the lineSize of the templateGraphic to 1
   set the foregroundColor of the templateGraphic to "31,63,111"
   CL.NewGraphic "CL.Grid"
   set the style of the templateGraphic to "polygon"
   set the opaque of the templateGraphic to true
   set the lineSize of the templateGraphic to 0
   set the backgroundColor of the templateGraphic to "160,160,160"
   repeat with tN = 1 to kFaces
      CL.NewGraphic "CL.F" & tN
   end repeat
   set the style of the templateGraphic to "line"
   set the opaque of the templateGraphic to false
   set the lineSize of the templateGraphic to 1
   set the foregroundColor of the templateGraphic to "63,111,176"
   CL.NewGraphic "CL.EdgeFar"
   set the foregroundColor of the templateGraphic to "150,225,255"
   CL.NewGraphic "CL.EdgeNear"
   set the style of the templateGraphic to "polygon"
   set the opaque of the templateGraphic to true
   set the lineSize of the templateGraphic to 2
   set the backgroundColor of the templateGraphic to "200,40,40"
   set the foregroundColor of the templateGraphic to "200,40,40"
   repeat with tN = 1 to kSprites
      CL.NewGraphic "CL.S" & tN
   end repeat
   set the backgroundColor of the templateGraphic to "90,90,104"
   set the foregroundColor of the templateGraphic to "150,225,255"
   CL.NewGraphic "CL.Gun"
   set the backgroundColor of the templateGraphic to "255,230,90"
   set the foregroundColor of the templateGraphic to "255,230,90"
   CL.NewGraphic "CL.Flash"
   set the style of the templateGraphic to "line"
   set the opaque of the templateGraphic to false
   set the lineSize of the templateGraphic to 1
   set the foregroundColor of the templateGraphic to "255,255,255"
   CL.NewGraphic "CL.Cross"
   set the style of the templateGraphic to "rectangle"
   set the opaque of the templateGraphic to true
   set the lineSize of the templateGraphic to 0
   set the backgroundColor of the templateGraphic to "200,0,0"
   CL.NewGraphic "CL.Red"
   set the blendLevel of graphic "CL.Red" of sCard to 60
   set the backgroundColor of the templateGraphic to "0,0,0"
   CL.NewGraphic "CL.Cover"
   reset the templateGraphic
   -- the words: the HUD line, the message, the dedication
   reset the templateField
   set the foregroundColor of the templateField to "150,225,255"
   set the backgroundColor of the templateField to "0,0,0"
   set the opaque of the templateField to false
   set the showBorder of the templateField to false
   set the lockText of the templateField to true
   set the traversalOn of the templateField to false
   set the dontWrap of the templateField to true
   set the textFont of the templateField to "Courier New"
   set the textSize of the templateField to 13
   create field "CL.Hud" in group "CL.View" of sCard
   set the rect of field "CL.Hud" of sCard to item 1 of tR + 10, item 4 of tR - 30, item 3 of tR - 10, item 4 of tR - 6
   create field "CL.Msg" in group "CL.View" of sCard
   set the rect of field "CL.Msg" of sCard to item 1 of tR + 10, item 2 of tR + 40, item 3 of tR - 10, item 2 of tR + 64
   set the textAlign of field "CL.Msg" of sCard to "center"
   set the foregroundColor of the templateField to "220,220,220"
   set the textSize of the templateField to 15
   set the dontWrap of the templateField to false
   create field "CL.Words" in group "CL.View" of sCard
   set the rect of field "CL.Words" of sCard to item 1 of tR + 20, item 2 of tR + (item 4 of tR - item 2 of tR) / 2 - 150, item 3 of tR - 20, item 2 of tR + (item 4 of tR - item 2 of tR) / 2 + 170
   set the textAlign of field "CL.Words" of sCard to "center"
   set the visible of field "CL.Words" of sCard to false
   reset the templateField
   set the visible of graphic "CL.Cover" of sCard to false
   set the visible of graphic "CL.Red" of sCard to false
   set the layer of group "CL.View" of sCard to CL.PictureLayer() + 1
   unlock screen
   unlock messages
end CL.MakeView

on CL.NewGraphic pName
   create graphic pName in group "CL.View" of sCard
   put the long id of graphic pName of sCard into sG[pName]
end CL.NewGraphic

-- set only what changed (setting a property costs even when the value is the same)
on CL.Pts pName, pPoints
   if sGWas[pName]["p"] is pPoints then exit CL.Pts
   put pPoints into sGWas[pName]["p"]
   set the points of sG[pName] to pPoints
end CL.Pts

on CL.Fill pName, pRGB
   if sGWas[pName]["c"] is pRGB then exit CL.Fill
   put pRGB into sGWas[pName]["c"]
   set the backgroundColor of sG[pName] to pRGB
   set the foregroundColor of sG[pName] to pRGB
end CL.Fill

on CL.Blend pName, pLevel
   if sGWas[pName]["b"] is pLevel then exit CL.Blend
   put pLevel into sGWas[pName]["b"]
   set the blendLevel of sG[pName] to pLevel
end CL.Blend

on CL.Opaque pName, pOn
   if sGWas[pName]["o"] is pOn then exit CL.Opaque
   put pOn into sGWas[pName]["o"]
   set the opaque of sG[pName] to pOn
end CL.Opaque

on CL.Vis pName, pOn
   if sGWas[pName]["v"] is pOn then exit CL.Vis
   put pOn into sGWas[pName]["v"]
   set the visible of sG[pName] to pOn
end CL.Vis

function CL.WallRGB pCh
   switch pCh
      case "G"
         return "76,255,0"          -- Scott's green
      case "B"
         return "70,110,190"
      case "R"
         return "170,70,55"
      case "D"
         return "158,158,107"       -- Scott's door
      case "L"
         return "225,180,40"
      case "d"
         return "255,255,210"
   end switch
   return "160,160,160"             -- Scott's wall grey
end CL.WallRGB

function CL.Shade pRGB, pF
   return round(item 1 of pRGB * pF) & comma & round(item 2 of pRGB * pF) & comma & round(item 3 of pRGB * pF)
end CL.Shade

on CL.Draw
   local tR, tL, tT, tW, tH, tFaces, tF, tN, tSkip, tPts, tNear, tFar, tEdge, tRGB, tShade, tMS
   local tXL, tXR, tTL, tBL, tTR, tBR
   if sCard is empty or sMap is empty then exit CL.Draw
   put the milliseconds into tMS
   put CL.ViewRect() into tR
   put item 1 of tR into tL
   put item 2 of tR into tT
   put item 3 of tR - tL into tW
   put item 4 of tR - tT into tH
   lock screen
   Ray.Camera sX, sY, sA, kFOV, tW, tH, sRays, 0.5
   -- the room's back: Scott's flat ceiling and floor, or black with a floor grid
   if sLook is "solid" then
      CL.Vis "CL.Sky", true
      CL.Vis "CL.Floor", true
      CL.Vis "CL.Grid", false
      if sGWas["CL.Sky"]["r"] is not tR then
         put tR into sGWas["CL.Sky"]["r"]
         set the rect of sG["CL.Sky"] to tL, tT, tL + tW, tT + tH div 2
         set the rect of sG["CL.Floor"] to tL, tT + tH div 2, tL + tW, tT + tH
         set the fillGradient["from"] of sG["CL.Floor"] to (tL + tW div 2) & comma & (tT + tH div 2)
         set the fillGradient["to"] of sG["CL.Floor"] to (tL + tW div 2) & comma & (tT + tH)
         set the fillGradient["via"] of sG["CL.Floor"] to (tL + tW) & comma & (tT + tH div 2)
         set the fillGradient["ramp"] of sG["CL.Floor"] to "0.00000,30,28,26,255" & cr & "1.00000,110,100,88,255"
      end if
   else
      CL.Vis "CL.Sky", false
      CL.Vis "CL.Floor", false
      CL.Vis "CL.Grid", true
      CL.Pts "CL.Grid", CL.Offset(Ray.FloorGrid(7), tL, tT)
   end if
   -- the walls, far first; past kFaces the farthest go
   put Ray.Faces() into tFaces
   put max(0, the number of lines of tFaces - kFaces) into tSkip
   put 0 into tN
   put empty into tNear
   put empty into tFar
   set the itemDelimiter to "|"
   repeat for each line tF in tFaces
      if tSkip > 0 then
         subtract 1 from tSkip
         next repeat
      end if
      add 1 to tN
      put item 2 of tF + tL into tXL
      put item 3 of tF + tL into tXR
      put item 4 of tF + tT into tTL
      put item 5 of tF + tT into tBL
      put item 6 of tF + tT into tTR
      put item 7 of tF + tT into tBR
      if sLook is not "lines" then
         put CL.WallRGB(item 8 of tF) into tRGB
         if sLook is "solid" then
            put max(0.22, 1 - item 1 of tF * 0.07) into tShade
            if item 11 of tF is 1 then multiply tShade by 0.78
            put round(tShade * 20) / 20 into tShade
            set the itemDelimiter to comma
            CL.Fill "CL.F" & tN, CL.Shade(tRGB, tShade)
            set the itemDelimiter to "|"
            CL.Blend "CL.F" & tN, 0
         else
            CL.Fill "CL.F" & tN, tRGB
            CL.Blend "CL.F" & tN, min(92, 72 + round(item 1 of tF * 2))
         end if
         CL.Pts "CL.F" & tN, tXL & comma & tTL & cr & tXR & comma & tTR & cr & tXR & comma & tBR & cr & tXL & comma & tBL & cr & tXL & comma & tTL
         CL.Vis "CL.F" & tN, true
      end if
      if sLook is not "solid" then
         -- top and bottom edges, and the uprights only at real corners (the Lean idea)
         put tXL & comma & tTL & cr & tXR & comma & tTR & cr & cr & tXL & comma & tBL & cr & tXR & comma & tBR & cr & cr into tEdge
         if item 9 of tF then put tXL & comma & tTL & cr & tXL & comma & tBL & cr & cr after tEdge
         if item 10 of tF then put tXR & comma & tTR & cr & tXR & comma & tBR & cr & cr after tEdge
         if item 1 of tF < 4 then
            put tEdge after tNear
         else
            put tEdge after tFar
         end if
      end if
   end repeat
   set the itemDelimiter to comma
   if sLook is "lines" then put 0 into tN
   repeat with tF = tN + 1 to kFaces
      CL.Vis "CL.F" & tF, false
   end repeat
   CL.Pts "CL.EdgeNear", tNear
   CL.Pts "CL.EdgeFar", tFar
   CL.Vis "CL.EdgeNear", (sLook is not "solid")
   CL.Vis "CL.EdgeFar", (sLook is not "solid")
   CL.DrawSprites tL, tT, tW, tH
   CL.DrawGun tL, tT, tW, tH
   if sHurt > 0 then
      if sGWas["CL.Red"]["r"] is not tR then
         put tR into sGWas["CL.Red"]["r"]
         set the rect of sG["CL.Red"] to tR
      end if
   end if
   CL.Vis "CL.Red", (sHurt > 0)
   unlock screen
   put the milliseconds - tMS into sDrawMS
end CL.Draw

-- line-graphic points moved by the view's corner (empty lines kept: they split segments)
function CL.Offset pPoints, pL, pT
   local tOut, tP
   repeat for each line tP in pPoints
      if tP is empty then
         put cr after tOut
      else
         put (item 1 of tP + pL) & comma & (item 2 of tP + pT) & cr after tOut
      end if
   end repeat
   return tOut
end CL.Offset

-- the shapes: one "u,v" a line, u across (cells), v up from the floor (cells)
function CL.Shape pKind, pStep
   local tW
   switch pKind
      case "m"
         put (pStep div 6) mod 2 * 0.06 - 0.03 into tW
         return (-0.22 + tW) & ",0" & cr & "-0.16,0.34" & cr & "-0.3,0.46" & cr & "-0.2,0.6" & cr & "-0.16,0.76" & cr & "-0.07,0.65" & cr & "0.07,0.65" & cr & "0.16,0.76" & cr & "0.2,0.6" & cr & "0.3,0.46" & cr & "0.16,0.34" & cr & (0.22 - tW) & ",0" & cr & "0.08,0" & cr & "0,0.2" & cr & "-0.08,0" & cr & (-0.22 + tW) & ",0"
      case "s"
         put sin(pStep / 6) * 0.05 into tW
         return "0," & 0.26 + tW & cr & "0.1," & 0.45 + tW & cr & "0.3," & 0.55 + tW & cr & "0.1," & 0.65 + tW & cr & "0," & 0.86 + tW & cr & "-0.1," & 0.65 + tW & cr & "-0.3," & 0.55 + tW & cr & "-0.1," & 0.45 + tW & cr & "0," & 0.26 + tW
      case "o"
         return "0,0.4" & cr & "0.08,0.5" & cr & "0,0.6" & cr & "-0.08,0.5" & cr & "0,0.4"
      case "h"
         return "-0.04,0" & cr & "0.04,0" & cr & "0.04,0.1" & cr & "0.12,0.1" & cr & "0.12,0.18" & cr & "0.04,0.18" & cr & "0.04,0.26" & cr & "-0.04,0.26" & cr & "-0.04,0.18" & cr & "-0.12,0.18" & cr & "-0.12,0.1" & cr & "-0.04,0.1" & cr & "-0.04,0"
      case "a"
         return "-0.1,0" & cr & "0.1,0" & cr & "0.1,0.14" & cr & "-0.1,0.14" & cr & "-0.1,0"
      case "k"
         return "-0.02,0.04" & cr & "0.02,0.04" & cr & "0.02,0.2" & cr & "0.08,0.26" & cr & "0,0.34" & cr & "-0.08,0.26" & cr & "-0.02,0.2" & cr & "-0.02,0.04"
   end switch
   return "-0.1,0" & cr & "0.1,0" & cr & "0,0.2" & cr & "-0.1,0"
end CL.Shape

function CL.ShapeRGB pKind, pHurt
   if pHurt > 0 then return "255,255,255"
   switch pKind
      case "m"
         return "200,40,40"
      case "s"
         return "170,60,220"
      case "o"
         return "255,150,40"
      case "h"
         return "60,230,90"
      case "a"
         return "240,220,60"
      case "k"
         return "255,200,0"
      case "X"
         return "0," & 160 + round(sin(sT / 5) * 90) & ",120"
   end switch
   return "255,255,255"
end CL.ShapeRGB

on CL.DrawSprites pL, pT, pW, pH
   local tList, tK, tP, tLine, tN, tKind, tID, tSX, tFY, tD, tS, tHalf, tVis, tPts, tU, tPt, tHurt, tStep, tFrom
   local tC, tR, tCh, tSquash
   put empty into sSeen
   put empty into tList
   -- monsters, things, orbs and the exit pads: "depth|kind|id|x|y"
   repeat for each key tK in sMon
      if sMon[tK]["dead"] and sMon[tK]["dying"] <= 0 then next repeat
      put CL.Near(sMon[tK]["x"], sMon[tK]["y"], sMon[tK]["kind"], "m" & tK) after tList
   end repeat
   repeat for each key tK in sItem
      put CL.Near(item 1 of tK - 0.5, item 2 of tK - 0.5, sItem[tK], "i" & tK) after tList
   end repeat
   repeat for each key tK in sOrb
      put CL.Near(sOrb[tK]["x"], sOrb[tK]["y"], "o", "o" & tK) after tList
   end repeat
   put 0 into tR
   repeat for each line tLine in sMap
      add 1 to tR
      put offset("X", tLine) into tC
      if tC > 0 then put CL.Near(tC - 0.5, tR - 0.5, "X", "x" & tC) after tList
   end repeat
   set the itemDelimiter to "|"
   sort lines of tList numeric descending by item 1 of each
   put max(0, the number of lines of tList - kSprites) into tFrom
   put 0 into tN
   repeat for each line tLine in tList
      if tFrom > 0 then
         subtract 1 from tFrom
         next repeat
      end if
      set the itemDelimiter to "|"
      put item 1 of tLine into tD
      put item 2 of tLine into tKind
      put item 3 of tLine into tID
      put item 4 of tLine into tSX
      put item 5 of tLine into tFY
      set the itemDelimiter to comma
      put Ray.Scale(tD) into tS
      if tKind is "X" then
         put CL.PadPoints(char 2 to -1 of tID) into tPts
         if tPts is empty then next repeat
         put Ray.Visible(CL.MinX(tPts), CL.MaxX(tPts), tD) into tVis
      else
         put 0.32 * tS into tHalf
         put Ray.Visible(tSX - tHalf, tSX + tHalf, tD) into tVis
      end if
      if tVis is empty then next repeat
      put 0 into tHurt
      put 0 into tStep
      put 1 into tSquash
      if char 1 of tID is "m" then
         put sMon[char 2 to -1 of tID]["hurt"] into tHurt
         put sMon[char 2 to -1 of tID]["step"] into tStep
         if sMon[char 2 to -1 of tID]["dead"] then put sMon[char 2 to -1 of tID]["dying"] / 10 into tSquash
         if not sMon[char 2 to -1 of tID]["dead"] then put tVis & comma & tD into sSeen[char 2 to -1 of tID]
      end if
      if tKind is not "X" then
         put empty into tPts
         repeat for each line tU in CL.Shape(tKind, tStep)
            put round(tSX + item 1 of tU * tS) & comma & round(tFY - item 2 of tU * tS * tSquash) & cr after tPts
         end repeat
      end if
      put Ray.ClipX(tPts, item 1 of tVis, item 2 of tVis) into tPts
      if the number of lines of tPts < 3 then next repeat
      add 1 to tN
      CL.Pts "CL.S" & tN, CL.Offset(tPts & line 1 of tPts, pL, pT)
      CL.Fill "CL.S" & tN, CL.ShapeRGB(tKind, tHurt)
      CL.Opaque "CL.S" & tN, (sLook is not "lines")
      CL.Vis "CL.S" & tN, true
   end repeat
   set the itemDelimiter to comma
   repeat with tK = tN + 1 to kSprites
      CL.Vis "CL.S" & tK, false
   end repeat
end CL.DrawSprites

-- "depth|kind|id|screen x|floor y" for a thing in front of the eye, else nothing
function CL.Near pX, pY, pKind, pID
   local tP
   put Ray.Project(pX, pY, 0) into tP
   if tP is empty or item 3 of tP > 24 then return empty
   return item 3 of tP & "|" & pKind & "|" & pID & "|" & item 1 of tP & "|" & item 2 of tP & cr
end CL.Near

-- the exit pad: a square on the floor of column pC's X cell (its row found in the map)
function CL.PadPoints pC
   local tR, tLine, tOut, tP, tCorner
   put 0 into tR
   repeat for each line tLine in sMap
      add 1 to tR
      if char pC of tLine is "X" then exit repeat
   end repeat
   repeat for each item tCorner in "0.15 0.15,0.85 0.15,0.85 0.85,0.15 0.85"
      put Ray.Project(pC - 1 + word 1 of tCorner, tR - 1 + word 2 of tCorner, 0.01) into tP
      if tP is empty then return empty
      put item 1 to 2 of tP & cr after tOut
   end repeat
   return tOut
end CL.PadPoints

function CL.MinX pPts
   local tM, tP
   put 1e9 into tM
   repeat for each line tP in pPts
      if tP is not empty then put min(tM, item 1 of tP) into tM
   end repeat
   return tM
end CL.MinX

function CL.MaxX pPts
   local tM, tP
   put -1e9 into tM
   repeat for each line tP in pPts
      if tP is not empty then put max(tM, item 1 of tP) into tM
   end repeat
   return tM
end CL.MaxX

on CL.DrawGun pL, pT, pW, pH
   local tCX, tBY, tBX, tPts, tU, tLines
   put pL + pW div 2 + round(sin(sBob) * 8) into tCX
   put pT + pH + round(abs(cos(sBob)) * 5) into tBY
   if sFire > 6 then add 10 to tBY
   put "-26,0 -20,-52 -11,-74 11,-74 20,-52 26,0 -26,0" into tLines
   put empty into tPts
   repeat for each word tU in tLines
      put (tCX + item 1 of tU) & comma & (tBY + item 2 of tU) & cr after tPts
   end repeat
   CL.Pts "CL.Gun", tPts
   CL.Opaque "CL.Gun", (sLook is "solid")
   CL.Vis "CL.Gun", true
   if sFlash > 0 then
      put empty into tPts
      repeat for each word tU in "0,-104 7,-86 22,-84 10,-74 14,-60 0,-68 -14,-60 -10,-74 -22,-84 -7,-86 0,-104"
         put (tCX + item 1 of tU) & comma & (tBY + item 2 of tU) & cr after tPts
      end repeat
      CL.Pts "CL.Flash", tPts
   end if
   CL.Vis "CL.Flash", (sFlash > 0)
   put pL + pW div 2 into tCX
   put pT + pH div 2 into tBY
   CL.Pts "CL.Cross", (tCX - 6) & comma & tBY & cr & (tCX - 2) & comma & tBY & cr & cr & (tCX + 2) & comma & tBY & cr & (tCX + 6) & comma & tBY & cr & cr & tCX & comma & (tBY - 6) & cr & tCX & comma & (tBY - 2) & cr & cr & tCX & comma & (tBY + 2) & cr & tCX & comma & (tBY + 6)
   CL.Vis "CL.Cross", true
end CL.DrawGun

-------------------------------------------------------------------- words

on CL.Say pText, pSeconds
   put pText into sMsg
   put sT + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end CL.Say

on CL.CountFPS
   add 1 to sFPSN
   if sFPSAt is empty then put the milliseconds into sFPSAt
   if the milliseconds - sFPSAt >= 1000 then
      put round(sFPSN * 1000 / (the milliseconds - sFPSAt)) into sFPS
      put 0 into sFPSN
      put the milliseconds into sFPSAt
      put empty into sHUDWas
   end if
end CL.CountFPS

on CL.ShowHUD
   local tWords, tMsg
   put empty into tMsg
   if sOver and sWon then
      put "THE LAB IS CLEAR. " & sKills & " DOWN.  SPACE TO PLAY AGAIN" into tMsg
   else if sOver then
      put "YOU FELL.  SPACE TO TRY THIS LEVEL AGAIN" into tMsg
   else if sT < sMsgUntil then
      put sMsg into tMsg
   end if
   put "HEALTH " & sHP & "   AMMO " & sAmmo & "   KEYS " & sKeys & "   DOWN " & sKills & "   LEVEL " & sLevel & "   LOOK " & toUpper(sLook) & "   RAYS " & sRays & "   FPS " & sFPS into tWords
   if tWords & tMsg is sHUDWas then exit CL.ShowHUD
   put tWords & tMsg into sHUDWas
   set the text of field "CL.Hud" of sCard to tWords
   set the text of field "CL.Msg" of sCard to tMsg
end CL.ShowHUD

function CL.State
   return "fps " & sFPS & "|" & sLevel & "|" & round(sX, 2) & "," & round(sY, 2) & "," & sA & "|hp " & sHP & "|ammo " & sAmmo & "|keys " & sKeys & "|down " & sKills & "|" & sLook & "|rays " & sRays & "|over " & sOver & "|won " & sWon & "|draw ms " & sDrawMS & "|cover " & sCover
end CL.State

-- tests: put the player somewhere, set the look, see the monsters
on CL.TestPlace pX, pY, pA
   put pX into sX
   put pY into sY
   put pA into sA
end CL.TestPlace

on CL.TestLook pLook, pRays
   put pLook into sLook
   put true into sLookPicked
   if pRays is a number then put pRays into sRays
end CL.TestLook

function CL.TestMonsters
   local tK, tOut
   repeat for each key tK in sMon
      put tK & ":" & sMon[tK]["kind"] & "," & round(sMon[tK]["x"], 2) & "," & round(sMon[tK]["y"], 2) & "," & sMon[tK]["hp"] & "," & sMon[tK]["awake"] & "," & sMon[tK]["dead"] & cr after tOut
   end repeat
   return tOut
end CL.TestMonsters

function CL.TestSeen
   local tK, tOut
   repeat for each key tK in sSeen
      put tK & ":" & sSeen[tK] & cr after tOut
   end repeat
   return tOut
end CL.TestSeen

on Game.OnStop
   if sCard is not empty and there is a group "CL.View" of sCard then
      lock messages
      delete group "CL.View" of sCard
      unlock messages
   end if
   put empty into sCard
   put empty into sMap
   HUD.Clear
   Camera.Reset
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey

-------------------------------------------------------------------- the maps
-- # wall  G green  B blue  R red  D door  L gold door  P you  m grunt  s spitter
-- h health  a ammo  k key  X exit pad.  Level 1 is Scott McDonald's own map from his raycaster
-- (1/2/3 walls, 4 doors, 5 spiders, 6 the exit, 7 his green wall), a closing row added.
function CL.Map pLevel
   local tMap
   switch pLevel
      case 1
         put "########################################################" & cr after tMap
         put "#P             #  a ####################        #      #" & cr after tMap
         put "#   a     # m  # m  D m                # h  m   #      #" & cr after tMap
         put "#         #    #    ################## # m      #  m   #" & cr after tMap
         put "#######   #    #    #     #          # #        #      #" & cr after tMap
         put "#         #         #     #     #    # D        #a   m #" & cr after tMap
         put "# ##########################    #    # ##########      #" & cr after tMap
         put "# #            # #      m  ###########  a       ####D###" & cr after tMap
         put "# #   mh   #   ###   #   a   #  m        #  m          #" & cr after tMap
         put "# #        #         ####  ######################      #" & cr after tMap
         put "# ######## ###########  ######## a  #          m       #" & cr after tMap
         put "#   m      #       ######m          # ####  h      m   #" & cr after tMap
         put "############       #mm    m      m  # #  ####          #" & cr after tMap
         put "#                  GXm   #      h     #     ####       #" & cr after tMap
         put "#                  #G##################        #########" & cr after tMap
         put "########################################################" & cr after tMap
         break
      case 2
         put "########################" & cr after tMap
         put "#P   #      R      #   #" & cr after tMap
         put "#    #  m   R  a   L k #" & cr after tMap
         put "#    D      R      #   #" & cr after tMap
         put "##D###RRRRDRR#######D###" & cr after tMap
         put "#    #      #    s     #" & cr after tMap
         put "# h  #  s   D          #" & cr after tMap
         put "#    #      #  RRRRR   #" & cr after tMap
         put "#  m D  a   #  R   R m #" & cr after tMap
         put "#    #      #  R h R   #" & cr after tMap
         put "######DRRRRR#  RR RR   #" & cr after tMap
         put "#      m           s   #" & cr after tMap
         put "#  a        RRDRR      #" & cr after tMap
         put "#           R   R   m  #" & cr after tMap
         put "#     s     R X R      #" & cr after tMap
         put "########################" & cr after tMap
         break
      case 3
         put "##############################" & cr after tMap
         put "#P     B         B           #" & cr after tMap
         put "#      B    m    B    s      #" & cr after tMap
         put "#  a   D         D           #" & cr after tMap
         put "#      B    h    B     m     #" & cr after tMap
         put "#BBBDBBB  BBBBB  BBBBDBBBBBBB#" & cr after tMap
         put "#         B   B              #" & cr after tMap
         put "#   m     B k B     s   a    #" & cr after tMap
         put "#         BBDBB              #" & cr after tMap
         put "#  s                  m      #" & cr after tMap
         put "#BBBBBBDBBBBB  BBBBBBBBLBBBBB#" & cr after tMap
         put "#          B    B            #" & cr after tMap
         put "#  m    a  D  s D   m   h    #" & cr after tMap
         put "#          B    B            #" & cr after tMap
         put "#   h      BBBBBB    s   X   #" & cr after tMap
         put "##############################" & cr after tMap
         break
   end switch
   return tMap
end CL.Map
