######################################################################################
## CARD SCRIPT: "Play.FuelLine"   FUEL LINE  (11 14 2026)
## A highway race against your own fuel gauge. Grab green cans as you pass them, keep
## clear of oil and of traffic that swerves at you, and reach the finish line with fuel
## to spare. Spark's concept and level numbers (LIB_SPARK/arcade/out/293_Fuel_Line),
## script by Claude.
## CONTROLS  Left/Right (or A/D): steer    Up/Down (or W/S): faster/slower
##           Space: grab a fuel can (it must be right beside or under you)    Escape: pause
## RULES     the tank drains all the time, faster when you drive faster. A can is +50.
##           Orange oil spins you: a life. Blue traffic drifts lanes and sometimes swerves
##           at you on purpose: a life. Cross the white finish line with 10 fuel or more:
##           next race (5). An empty tank or no lives: game over.
######################################################################################

global bPaused, bPlaying

local sCar, sCarX, sSpeed, sDist, sRaceLen, sRail, sThing, sThingN, sNextSpawn, sFuel, sSpin
local sGauge, sLevel, sLives, sScore, sOver, sWon, sHurt, sBusy, sTop, sDrain, sMsg
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kGroundY = 90
constant kCarZ = 280
constant kFarZ = 3400
constant kRailGap = 220
constant kLaneW = 130
constant kHalfW = 260        -- four lanes

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Fuel.Build
   Fuel.StartLevel 1
end Game.OnStart

on Fuel.Build
   local i
   Mesh.Define "Fuel.Car", Fuel.CarMesh()
   Mesh.Define "Fuel.Slice", Fuel.SliceMesh()
   Mesh.Define "Fuel.Traffic", Mesh.Box(70, 50, 120)
   Mesh.Define "Fuel.Can", Mesh.Prism(6, 18, 40)
   Mesh.Define "Fuel.Oil", Mesh.Prism(9, 40, 2)
   Mesh.Define "Fuel.Finish", Fuel.FinishMesh()
   Mesh.Define "Fuel.Post", Mesh.Prism(4, 6, 120)
   Mesh.Define "Fuel.GaugeBar", Mesh.Box(4, 4, 1)
   Mesh.Define "Fuel.Horizon", Mesh.Box(30000, 1, 1)
   get Entity.Spawn("Fuel.Horizon", 0, kGroundY, 12000, "120,120,140")
   put Entity.Spawn("Fuel.Car", 0, kGroundY - 16, kCarZ, "255,220,0") into sCar
   put empty into sRail
   repeat with i = 0 to kFarZ div kRailGap
      put kCarZ - 120 + i * kRailGap into sRail[i]["z"]
      put Entity.Spawn("Fuel.Slice", 0, kGroundY, sRail[i]["z"], "170,170,190") into sRail[i]["key"]
   end repeat
end Fuel.Build

function Fuel.SliceMesh
   local tM, i
   put Mesh.New() into tM
   repeat with i = -1 to 1 step 2
      Mesh.AddVertex tM, i * kHalfW, 0, 0
      Mesh.AddVertex tM, i * kHalfW, 0, kRailGap
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      Mesh.AddVertex tM, i * kHalfW, -14, 0
      Mesh.AddLine tM, tM["count"] - 2, tM["count"]
   end repeat
   repeat with i = -1 to 1
      Mesh.AddVertex tM, i * kLaneW, 0, 0
      Mesh.AddVertex tM, i * kLaneW, 0, 80
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Fuel.SliceMesh

function Fuel.CarMesh
   local tM
   put Mesh.New() into tM
   Fuel.AddBox tM, 0, 4, 0, 76, 22, 140
   Fuel.AddBox tM, 0, -16, 12, 54, 18, 60
   Fuel.AddBox tM, 0, -10, -64, 86, 4, 14       -- a spoiler
   return tM
end Fuel.CarMesh

on Fuel.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Fuel.AddBox

-- the finish: a chequered band across the road between two posts
function Fuel.FinishMesh
   local tM, i
   put Mesh.New() into tM
   Fuel.AddBox tM, 0, -150, 0, 2 * kHalfW + 60, 30, 4
   repeat with i = 0 to 7
      Mesh.AddVertex tM, -kHalfW - 30 + i * (2 * kHalfW + 60) / 8, -165, 0
      Mesh.AddVertex tM, -kHalfW - 30 + (i + 1) * (2 * kHalfW + 60) / 8, -135, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   repeat with i = -1 to 1 step 2
      Mesh.AddVertex tM, i * (kHalfW + 30), 0, 0
      Mesh.AddVertex tM, i * (kHalfW + 30), -135, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Fuel.FinishMesh

-- Spark's table: speed | traffic | lives
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Fuel.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Fuel.StartLevel pLevel
   end if
end Fuel.GoLevel

on Fuel.StartLevel pLevel
   local tRow, tK
   put pLevel into sLevel
   put line pLevel of ("120,3,3" & cr & "130,4,3" & cr & "140,5,3" & cr & "150,6,2" & cr & "160,7,2") into tRow
   put (item 1 of tRow) / 4 into sTop
   put item 2 of tRow into sBusy
   if pLevel is 1 or sLives > item 3 of tRow then put item 3 of tRow into sLives
   put 0.06 + pLevel * 0.015 into sDrain
   put 13000 + pLevel * 2000 into sRaceLen
   put 0 into sDist
   put 0 into sCarX
   put sTop * 0.6 into sSpeed
   put 100 into sFuel
   put 0 into sSpin
   put 0 into sHurt
   repeat for each key tK in sThing
      Entity.Kill sThing[tK]["key"]
   end repeat
   put empty into sThing
   put 0 into sThingN
   put 400 into sNextSpawn
   put empty into sHUDWas
   put empty into sMsg
end Fuel.StartLevel

function Fuel.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Fuel.Keys

on Fuel.TestKeys pKeys
   put pKeys into sTestKeys
end Fuel.TestKeys

on Fuel.TestLives pN
   put pN into sLives
end Fuel.TestLives

on Fuel.TestDist pD
   put pD into sDist
end Fuel.TestDist

function Fuel.Down pCode, pKeys
   return pCode is among the items of pKeys
end Fuel.Down

on Game.OnUpdate
   local tKeys, tT, tZ, tX, tK, tGrab, tGone
   put Fuel.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Fuel.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put false into sOver
         put false into sWon
         Sound.Play "Select"
         Fuel.GoLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put Fuel.Down(32, tKeys) and not (32 is among the items of sKeysWas) into tGrab
   put tKeys into sKeysWas
   if sSpin > 0 then
      -- spinning on oil: no control
      subtract 1 from sSpin
      put sSpeed * 0.94 into sSpeed
      Entity.SetRotation sCar, 0, sSpin / 2, 0
   else
      if Fuel.Down(65362, tKeys) or Fuel.Down(119, tKeys) then put min(sTop, sSpeed + 0.4) into sSpeed
      if Fuel.Down(65364, tKeys) or Fuel.Down(115, tKeys) then put max(sTop * 0.3, sSpeed - 0.6) into sSpeed
      if Fuel.Down(65361, tKeys) or Fuel.Down(97, tKeys) then subtract 5 + sSpeed * 0.12 from sCarX
      if Fuel.Down(65363, tKeys) or Fuel.Down(100, tKeys) then add 5 + sSpeed * 0.12 to sCarX
      Entity.SetRotation sCar, 0, 0, 0
   end if
   put max(-kHalfW + 34, min(kHalfW - 34, sCarX)) into sCarX
   Entity.SetPosition sCar, sCarX, kGroundY - 16, kCarZ
   add sSpeed to sDist
   add sSpeed / 20 to sScore
   -- the tank drains, faster at speed
   subtract sDrain * (0.5 + sSpeed / sTop) from sFuel
   if sFuel <= 0 then
      put 0 into sFuel
      put "OUT OF FUEL" into sMsg
      put true into sOver
      Sound.Play "Lose"
   end if
   if sHurt > 0 then subtract 1 from sHurt
   repeat for each key tK in sRail
      subtract sSpeed from sRail[tK]["z"]
      if sRail[tK]["z"] < kCarZ - 260 then add (kFarZ div kRailGap + 1) * kRailGap to sRail[tK]["z"]
      Entity.SetPosition sRail[tK]["key"], 0, kGroundY, sRail[tK]["z"]
   end repeat
   if sDist >= sNextSpawn and sDist < sRaceLen - 1500 then
      Fuel.Spawn
      put sDist + max(200, 1600 / sBusy) + random(240) into sNextSpawn
   end if
   if sDist >= sRaceLen - kFarZ and sThing["finish"] is empty then
      put "finish" into sThing["finish"]["kind"]
      put 0 into sThing["finish"]["x"]
      put kGroundY into sThing["finish"]["y"]
      put 0 into sThing["finish"]["v"]
      put sRaceLen - sDist + kCarZ into sThing["finish"]["z"]
      put Entity.Spawn("Fuel.Finish", 0, kGroundY, sThing["finish"]["z"], "255,255,255") into sThing["finish"]["key"]
   end if
   repeat for each key tT in sThing
      put false into tGone
      subtract sSpeed - sThing[tT]["v"] from sThing[tT]["z"]
      put sThing[tT]["z"] into tZ
      if sThing[tT]["kind"] is "car" then
         -- traffic drifts lanes, and sometimes swerves at you when it is close ahead
         if sThing[tT]["swerve"] and tZ - kCarZ < 700 and tZ > kCarZ then
            add max(-4, min(4, (sCarX - sThing[tT]["x"]) * 0.05)) to sThing[tT]["x"]
         else
            add (sThing[tT]["tx"] - sThing[tT]["x"]) * 0.03 to sThing[tT]["x"]
            if random(140) is 1 then put (random(4) - 2.5) * kLaneW into sThing[tT]["tx"]
         end if
      end if
      put sThing[tT]["x"] into tX
      if sThing[tT]["kind"] is "can" then Entity.SetRotation sThing[tT]["key"], 0, sTicks / 8, 0
      Entity.SetPosition sThing[tT]["key"], tX, sThing[tT]["y"], tZ
      switch sThing[tT]["kind"]
         case "can"
            -- grab it with Space when it is beside you
            if tGrab and abs(tZ - kCarZ) < 110 and abs(tX - sCarX) < 120 then
               put min(150, sFuel + 50) into sFuel
               Sound.Play "Pickup"
               add 50 to sScore
               FX.Sparks tX, kGroundY - 30, tZ, 10, "0,255,100"
               put true into tGone
               put empty into sHUDWas
            end if
            break
         case "oil"
            if abs(tZ - kCarZ) < 60 and abs(tX - sCarX) < 60 and sSpin <= 0 and sHurt <= 0 then
               put 36 into sSpin
               Fuel.Hurt
            end if
            break
         case "car"
            if abs(tZ - kCarZ) < 120 and abs(tX - sCarX) < 70 and sHurt <= 0 then
               Fuel.Hurt
               put sThing[tT]["v"] * 0.7 into sSpeed
               put sCarX + Fuel.Sign(sCarX - tX) * 60 into sCarX
            end if
            break
         case "finish"
            if tZ <= kCarZ then
               if sFuel >= 10 then
                  add 500 * sLevel + round(sFuel) * 5 to sScore
                  if sLevel >= 5 then
                     put true into sWon
                     put true into sOver
                     put "CHAMPION OF THE FUEL LINE" into sMsg
                     Sound.Play "Win"
                  else
                     Sound.Play "Warp"
                     Fuel.GoLevel sLevel + 1
                  end if
               else
                  put "CROSSED THE LINE ON FUMES" into sMsg
                  put true into sOver
                  Sound.Play "Lose"
               end if
               exit Game.OnUpdate
            end if
            break
      end switch
      if tGone or tZ < kCarZ - 300 or tZ > kCarZ + kFarZ + 900 then
         Entity.Kill sThing[tT]["key"]
         delete variable sThing[tT]
      end if
   end repeat
   Fuel.ShowHUD
end Game.OnUpdate

on Fuel.Spawn
   local tN, tLane, tX
   put random(4) into tLane
   put (tLane - 2.5) * kLaneW into tX
   put random(100) into tN
   -- owner's game note 11 14 8:09 PM, "too much damn traffic": cars 45% -> 30% of what spawns,
   -- cans 30% -> 45% (fuel stays as easy to find), oil stays 25%; swerving cars 50% -> 35%
   if tN <= 30 then
      Fuel.Add "car", "Fuel.Traffic", tX, kGroundY - 25, sTop * (0.45 + random(25) / 100), "60,130,255"
      put tX into sThing[sThingN]["tx"]
      put random(100) <= 35 into sThing[sThingN]["swerve"]       -- was Spark's 0.5
   else if tN <= 75 then
      -- cans sit on the lane lines, between the traffic
      put (random(3) - 2) * kLaneW into tX
      Fuel.Add "can", "Fuel.Can", tX, kGroundY - 20, 0, "0,255,100"
   else
      Fuel.Add "oil", "Fuel.Oil", tX, kGroundY - 1, 0, "255,150,0"
   end if
end Fuel.Spawn

on Fuel.Add pKind, pMesh, pX, pY, pV, pColor
   add 1 to sThingN
   put pKind into sThing[sThingN]["kind"]
   put pX into sThing[sThingN]["x"]
   put pY into sThing[sThingN]["y"]
   put pV into sThing[sThingN]["v"]
   put kCarZ + kFarZ into sThing[sThingN]["z"]
   put Entity.Spawn(pMesh, pX, pY, kCarZ + kFarZ, pColor) into sThing[sThingN]["key"]
end Fuel.Add

function Fuel.Sign pN
   if pN < 0 then return -1
   return 1
end Fuel.Sign

on Fuel.Hurt
   if sHurt > 0 then exit Fuel.Hurt
   subtract 1 from sLives
   put 45 into sHurt
   FX.Sparks sCarX, kGroundY - 20, kCarZ, 16, "255,80,80"
   put empty into sHUDWas
   if sLives <= 0 then
      put "WRECKED" into sMsg
      put true into sOver
      Sound.Play "PlayerCrash"
   else
      Sound.Play "Hurt"
   end if
end Fuel.Hurt

on Fuel.ShowHUD
   local tWords, tLine, tBar
   put sLevel & "|" & sLives & "|" & round(sScore) div 10 & "|" & sOver & "|" & round(sFuel) & "|" & round((sRaceLen - sDist) / 1000) into tWords
   if tWords is sHUDWas then exit Fuel.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Fuel.Score", "SCORE" && round(sScore) && "  LIVES" && sLives && "  RACE" && sLevel & "/5  TO GO" && max(0, round((sRaceLen - sDist) / 100)) & "m", 20, 40, 14
   put empty into tBar
   repeat round(sFuel / 10) times
      put "=" after tBar
   end repeat
   if sOver and sWon then
      put sMsg & ".  SPACE TO RACE AGAIN" into tLine
   else if sOver then
      put sMsg & ".  SPACE TO RACE AGAIN" into tLine
   else if sFuel < 25 then
      put "FUEL" && round(sFuel) && tBar && " LOW! GRAB A CAN (SPACE)" into tLine
   else
      put "FUEL" && round(sFuel) && tBar into tLine
   end if
   HUD.Set "Fuel.Msg", tLine, 20, 70, 12
end Fuel.ShowHUD

function Fuel.State
   return sLevel & "|" & sLives & "|" & round(sScore) & "|x " & round(sCarX) & "|v " & round(sSpeed) & "|fuel " & round(sFuel) & "|d " & round(sDist) & "/" & sRaceLen & "|things " & the number of lines of the keys of sThing & "|" & sOver
end Fuel.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
