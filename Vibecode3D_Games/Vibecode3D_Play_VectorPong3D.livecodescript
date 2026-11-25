######################################################################################
## CARD SCRIPT: "Play.VectorPong3D"   VECTOR PONG 3D  (11 13 2026)
## The owner's concept (round two, 1 of 9): a tennis court in depth, seen from behind
## your bat. Angle shots off the walls and the ceiling; floating blocks bounce the ball.
## Teaches: 3D input and bounce physics.
## CONTROLS  Arrow keys: move the bat (left/right/up/down)   Space: serve   Escape: stop
## RULES     the ball past a bat is a point for the other side. Where the ball meets
##           your bat sets its angle. 5 levels: faster ball, quicker computer, more blocks.
######################################################################################

global bPaused, bPlaying

local sBat, sCpu, sBall, sBatX, sBatY, sCpuX, sCpuY, sBX, sBY, sBZ, sDX, sDY, sDZ
local sSpeed, sCpuSpeed, sWin, sBlocks, sMine, sTheirs, sLevel, sServe, sOver, sTestKeys, sHUDWas

constant kW = 300          -- half width of the court
constant kH = 200          -- half height
constant kNear = 240       -- your bat's depth
constant kFar = 1500       -- the computer's
constant kBatW = 60        -- half sizes of a bat
constant kBatH = 45
constant kBatSpeed = 13

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put false into sOver
   Pong.StartLevel 1
end Game.OnStart

-- level table: ball speed | computer bat speed | obstacle blocks | points to win
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Pong.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Pong.StartLevel pLevel
   end if
end Pong.GoLevel

on Pong.StartLevel pLevel
   local tRow, n, tKey
   put pLevel into sLevel
   put line pLevel of ("16,5,0,3" & cr & "19,6,1,3" & cr & "22,7,2,4" & cr & "25,8,3,4" & cr & "28,10,4,5") into tRow
   put item 1 of tRow into sSpeed
   put item 2 of tRow into sCpuSpeed
   put item 4 of tRow into sWin
   put 0 into sMine
   put 0 into sTheirs
   Scene.ClearAll
   Pong.MakeCourt
   get Entity.Spawn("Pong.Court", 0, 0, 0, "#2060A0")
   Mesh.Define "Pong.Bat", Mesh.Box(kBatW * 2, kBatH * 2, 6)
   Mesh.Define "Pong.Ball", Mesh.Box(22, 22, 22)
   Mesh.Define "Pong.Block", Mesh.Box(110, 90, 60)
   put Entity.Spawn("Pong.Bat", 0, 0, kNear, "cyan") into sBat
   put Entity.Spawn("Pong.Bat", 0, 0, kFar, "#FF5050") into sCpu
   put Entity.Spawn("Pong.Ball", 0, 0, kNear + 30, "white") into sBall
   -- floating blocks in mid-court: x, y, z
   put empty into sBlocks
   repeat with n = 1 to item 3 of tRow
      put item n of "-150,150,0,-170,170" into sBlocks[n]["x"]
      put item n of "-70,60,0,90,-100" into sBlocks[n]["y"]
      put item n of "800,1000,600,1150,700" into sBlocks[n]["z"]
      put Entity.Spawn("Pong.Block", sBlocks[n]["x"], sBlocks[n]["y"], sBlocks[n]["z"], "yellow") into tKey
   end repeat
   put 0 into sBatX
   put 0 into sBatY
   put 0 into sCpuX
   put 0 into sCpuY
   put true into sServe
   put empty into sHUDWas
end Pong.StartLevel

-- the court: rectangles at five depths and the four long edges, as wire lines
on Pong.MakeCourt
   local tM, n, z, tBase
   put Mesh.New() into tM
   repeat with n = 0 to 4
      put kNear + n * (kFar - kNear) / 4 into z
      Mesh.AddVertex tM, -kW, -kH, z
      Mesh.AddVertex tM, kW, -kH, z
      Mesh.AddVertex tM, kW, kH, z
      Mesh.AddVertex tM, -kW, kH, z
      put n * 4 into tBase
      Mesh.AddLine tM, tBase + 1, tBase + 2
      Mesh.AddLine tM, tBase + 2, tBase + 3
      Mesh.AddLine tM, tBase + 3, tBase + 4
      Mesh.AddLine tM, tBase + 4, tBase + 1
   end repeat
   repeat with n = 1 to 4
      Mesh.AddLine tM, n, 16 + n
   end repeat
   Mesh.Define "Pong.Court", tM
end Pong.MakeCourt

function Pong.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Pong.Keys

on Pong.TestKeys pKeys
   put pKeys into sTestKeys
end Pong.TestKeys

on Game.OnUpdate
   local tKeys, n, tWant
   put Pong.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put false into sOver
         Pong.GoLevel 1
      end if
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kBatSpeed from sBatX
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kBatSpeed to sBatX
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then subtract kBatSpeed from sBatY
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then add kBatSpeed to sBatY
   put max(-kW + kBatW, min(kW - kBatW, sBatX)) into sBatX
   put max(-kH + kBatH, min(kH - kBatH, sBatY)) into sBatY
   Entity.SetPosition sBat, sBatX, sBatY, kNear
   if sServe then
      put sBatX into sBX
      put sBatY into sBY
      put kNear + 30 into sBZ
      if 32 is among the items of tKeys then
         put false into sServe
         Sound.Play "Throw"
         put sSpeed * 0.25 into sDX
         put -sSpeed * 0.2 into sDY
         put sSpeed into sDZ
      end if
      Entity.SetPosition sBall, sBX, sBY, sBZ
      Pong.ShowHUD
      exit Game.OnUpdate
   end if
   add sDX to sBX
   add sDY to sBY
   add sDZ to sBZ
   -- side walls, floor and ceiling (a wall bounce sounds once per frame)
   if sBX < -kW + 11 then
      put -kW + 11 into sBX
      put abs(sDX) into sDX
      Sound.Play "Bounce"
   end if
   if sBX > kW - 11 then
      put kW - 11 into sBX
      put -abs(sDX) into sDX
      Sound.Play "Bounce"
   end if
   if sBY < -kH + 11 then
      put -kH + 11 into sBY
      put abs(sDY) into sDY
      Sound.Play "Bounce"
   end if
   if sBY > kH - 11 then
      put kH - 11 into sBY
      put -abs(sDY) into sDY
      Sound.Play "Bounce"
   end if
   -- floating blocks: the ball turns back when it runs into one
   repeat for each key n in sBlocks
      if abs(sBX - sBlocks[n]["x"]) < 66 and abs(sBY - sBlocks[n]["y"]) < 56 and abs(sBZ - sBlocks[n]["z"]) < 41 then
         put -sDZ into sDZ
         add sDZ * 2 to sBZ
         Sound.Play "Thud"
         FX.Sparks sBX, sBY, sBZ, 6, "yellow"
      end if
   end repeat
   -- the computer follows the ball, only so fast
   put sBX - sCpuX into tWant
   add max(-sCpuSpeed, min(sCpuSpeed, tWant)) to sCpuX
   put sBY - sCpuY into tWant
   add max(-sCpuSpeed, min(sCpuSpeed, tWant)) to sCpuY
   Entity.SetPosition sCpu, sCpuX, sCpuY, kFar
   -- your bat: where the ball meets it sets the angle
   if sDZ < 0 and sBZ <= kNear + 14 then
      if abs(sBX - sBatX) <= kBatW + 11 and abs(sBY - sBatY) <= kBatH + 11 then
         put kNear + 14 into sBZ
         put abs(sDZ) into sDZ
         put (sBX - sBatX) / kBatW * sSpeed * 0.55 into sDX
         put (sBY - sBatY) / kBatH * sSpeed * 0.45 into sDY
         FX.Sparks sBX, sBY, sBZ, 5, "cyan"
         Sound.Play "Hit"
      else if sBZ < kNear - 40 then
         add 1 to sTheirs
         Sound.Play "Hurt"
         Pong.Point
      end if
   end if
   if sDZ > 0 and sBZ >= kFar - 14 then
      if abs(sBX - sCpuX) <= kBatW + 11 and abs(sBY - sCpuY) <= kBatH + 11 then
         put kFar - 14 into sBZ
         put -abs(sDZ) into sDZ
         put (sBX - sCpuX) / kBatW * sSpeed * 0.5 into sDX
         put (sBY - sCpuY) / kBatH * sSpeed * 0.4 into sDY
         Sound.Play "Blip"
      else if sBZ > kFar + 40 then
         add 1 to sMine
         Sound.Play "Pickup"
         Pong.Point
      end if
   end if
   Entity.SetPosition sBall, sBX, sBY, sBZ
   Pong.ShowHUD
end Game.OnUpdate

on Pong.Point
   put true into sServe
   put empty into sHUDWas
   if sMine >= sWin then
      if sLevel >= 5 then
         put true into sOver
         Sound.Play "Win"
      else
         Sound.Play "Warp"
         Pong.GoLevel sLevel + 1
      end if
   else if sTheirs >= sWin then
      put true into sOver
      Sound.Play "Lose"
   end if
end Pong.Point

on Pong.ShowHUD
   local tWords
   put sLevel & "|" & sMine & "|" & sTheirs & "|" & sServe & "|" & sOver into tWords
   if tWords is sHUDWas then exit Pong.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Pong.Score", "YOU" && sMine && "  THEM" && sTheirs && "  FIRST TO" && sWin && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Pong.Msg"
   if sOver and sMine >= sWin then
      HUD.Set "Pong.Msg", "COURT CLEARED.  SPACE TO PLAY AGAIN", 200, 400, 16
   else if sOver then
      HUD.Set "Pong.Msg", "MATCH LOST.  SPACE TO PLAY AGAIN", 230, 400, 16
   else if sServe then
      HUD.Set "Pong.Msg", "SPACE TO SERVE", 320, 400, 16
   end if
end Pong.ShowHUD

function Pong.State
   return sLevel & "|" & sMine & "|" & sTheirs & "|" & round(sBX) & "," & round(sBY) & "," & round(sBZ) & "|" & sServe & "|" & sOver
end Pong.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
