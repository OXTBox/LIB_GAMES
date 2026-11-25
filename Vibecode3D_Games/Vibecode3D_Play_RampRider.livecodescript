######################################################################################
## CARD SCRIPT: "Play.RampRider"   RAMP RIDER  (11 14 2026)
## A dirt bike on a motocross course seen from the side: ramps, tabletops, whoops and mud.
## Tilt the bike in the air so it lands at the slope of the ground. Turbo gives speed
## and air but heats the engine. Three riders race you on the lanes behind. Spark's
## concept and level numbers (LIB_SPARK/arcade/out/871_Ramp_Rider), script by Claude.
## CONTROLS  Left/Right (or A/D): tilt back / forward    Space: turbo    Escape: pause
## RULES     land with the bike near the slope of the ground: points for the height of the
##           jump. Land badly: you tumble, a life. Turbo burns fuel (yellow cans refill it)
##           and heats the engine; too hot and it stops to cool. Mud slows you. Finish
##           first for the full bonus; last place costs a life. 5 courses.
######################################################################################

global bPaused, bPlaying

local sBike, sX, sY, sVX, sVY, sAng, sAir, sPeak, sSlope, sH, sMud, sPts, sSlice, sCan
local sRider, sHeat, sFuel, sCool, sTumble, sTop, sTurbo, sRiderTop, sBonus, sPlace, sFinish
local sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT, sDone, sDoneT
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kBase = 230         -- height 0 on the screen
constant kBikeX = -220       -- the bike stays here on the screen
constant kSeg = 40           -- course points every 40 units
constant kSlices = 28
constant kGrav = 0.45

on Game.OnStart
   focus on nothing
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Ramp.StartLevel 1
end Game.OnStart

-- Spark's table: bike speed | lives | bonus
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Ramp.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Ramp.StartLevel pLevel
   end if
end Ramp.GoLevel

on Ramp.StartLevel pLevel
   local tRow, i, tColors
   put pLevel into sLevel
   put line pLevel of ("220,3,100" & cr & "240,3,150" & cr & "260,2,200" & cr & "280,2,250" & cr & "300,1,300") into tRow
   put (item 1 of tRow) / 36 into sTop
   put sTop * 1.35 into sTurbo
   put (item 1 of tRow) * 0.84 / 36 into sRiderTop
   put item 3 of tRow into sBonus
   if pLevel is 1 or sLives > item 2 of tRow then put item 2 of tRow into sLives
   Scene.ClearAll
   Mesh.Define "Ramp.Bike", Ramp.BikeMesh()
   Mesh.Define "Ramp.Mud", Ramp.MudMesh()
   Mesh.Define "Ramp.Can", Mesh.Box(16, 22, 10)
   Mesh.Define "Ramp.Flag", Ramp.FlagMesh()
   Ramp.MakeCourse
   put empty into sSlice
   repeat with i = 0 to kSlices
      put empty into sSlice[i]["type"]
   end repeat
   put Entity.Spawn("Ramp.Flag", 0, kBase, kZ + 1, "255,255,255") into sFinish
   -- you, and three riders on the lanes behind
   put 0 into sX
   put 0 into sY
   put 0 into sVX
   put 0 into sVY
   put 0 into sAng
   put false into sAir
   put 0 into sSlope
   put 0 into sHeat
   put 100 into sFuel
   put 0 into sCool
   put 0 into sTumble
   put Entity.Spawn("Ramp.Bike", kBikeX, kBase, kZ, "255,150,0") into sBike
   put "60,140,255|0,220,100|190,90,255" into tColors
   set the itemDel to "|"
   repeat with i = 1 to 3
      put 0 into sRider[i]["x"]
      put 0 into sRider[i]["y"]
      put 0 into sRider[i]["vy"]
      put false into sRider[i]["air"]
      put sRiderTop * (0.9 + i * 0.05) into sRider[i]["top"]
      put Entity.Spawn("Ramp.Bike", kBikeX, kBase, kZ + i * 70, item i of tColors) into sRider[i]["key"]
   end repeat
   set the itemDel to comma
   put 0 into sDone
   put 0 into sDoneT
   Sound.Play "Warp"
   put "COURSE" && pLevel & ": GO!" into sMsg
   put 50 into sMsgT
   put empty into sHUDWas
end Ramp.StartLevel

-- the course: heights every kSeg, mud flags, fuel cans; the same each time for a level
on Ramp.MakeCourse
   local i, tN, tH, tKind, tLen, j, tUp
   set the randomSeed to 8700 + sLevel
   put empty into sH
   put empty into sMud
   put empty into sCan
   put 0 into i
   repeat with j = 0 to 7
      put 0 into sH[j]
   end repeat
   put 8 into i
   put 280 + sLevel * 20 into sPts                    -- course length in points
   repeat while i < sPts - 12
      put random(100) into tN
      if tN <= 30 then
         -- a ramp: up, a lip, then down the far side
         put 2 + random(2) into tLen
         put 20 + random(2) * 10 into tUp
         Ramp.Run i, tLen, tUp
         add tLen to i
         Ramp.Run i, 1, 0
         add 1 to i
         Ramp.Run i, tLen + 2, -tUp * tLen / (tLen + 2)
         add tLen + 2 to i
      else if tN <= 48 then
         -- a tabletop: up, a long top, down
         Ramp.Run i, 3, 30
         add 3 to i
         Ramp.Run i, 4 + random(3), 0
         add 4 + random(3) to i
         Ramp.Run i, 3, -30
         add 3 to i
      else if tN <= 62 then
         -- a double: up, a gap of flat floor, a landing slope down
         Ramp.Run i, 3, 30
         add 3 to i
         Ramp.Run i, 1, -90
         add 1 to i
         Ramp.Run i, 3 + random(2), 0
         add 3 + random(2) to i
         Ramp.Run i, 2, 20
         add 2 to i
         Ramp.Run i, 2, -20
         add 2 to i
      else if tN <= 74 then
         -- whoops
         repeat 3 + random(2) times
            Ramp.Run i, 1, 20
            add 1 to i
            Ramp.Run i, 1, -20
            add 1 to i
         end repeat
      else if tN <= 86 then
         -- mud
         put 4 + random(4) into tLen
         Ramp.Run i, tLen, 0
         repeat with j = i to i + tLen - 1
            put true into sMud[j]
         end repeat
         add tLen to i
      else
         Ramp.Run i, 4 + random(4), 0
         add 4 + random(4) to i
      end if
      if random(5) is 1 then put true into sCan[i]
      Ramp.Run i, 3, 0
      add 3 to i
   end repeat
   repeat with j = i to sPts + kSlices + 4
      put sH[i] into sH[j]
   end repeat
   set the randomSeed to the milliseconds
end Ramp.MakeCourse

-- pN points from point pAt, each pDY higher (never below 0)
on Ramp.Run pAt, pN, pDY
   local j
   repeat with j = 1 to pN
      put max(0, sH[pAt + j - 1] + pDY) into sH[pAt + j]
   end repeat
end Ramp.Run

-- the ground's height at course distance pX
function Ramp.H pX
   local tI, tF
   if pX < 0 then return 0
   put pX div kSeg into tI
   put (pX mod kSeg) / kSeg into tF
   return sH[tI] + (sH[tI + 1] - sH[tI]) * tF
end Ramp.H

function Ramp.BikeMesh
   local tM, i, tA, tC
   put Mesh.New() into tM
   -- two wheels
   repeat with tC = -1 to 1 step 2
      repeat with i = 0 to 7
         put i * 3.14159 / 4 into tA
         Mesh.AddVertex tM, tC * 20 + 11 * cos(tA), -11 + 11 * sin(tA), 0
      end repeat
      repeat with i = 1 to 8
         Mesh.AddLine tM, tM["count"] - 8 + i, tM["count"] - 8 + (i mod 8) + 1
      end repeat
   end repeat
   -- frame, seat, bars, rider
   Ramp.Poly tM, "-20,-11|0,-26|20,-11"
   Ramp.Poly tM, "-14,-28|6,-28"
   Ramp.Poly tM, "14,-26|18,-38"
   Ramp.Poly tM, "-4,-28|0,-48|16,-38"
   Ramp.Poly tM, "0,-48|0,-58|8,-58|8,-50|0,-50"
   return tM
end Ramp.BikeMesh

on Ramp.Poly @pM, pPts
   local tP, tN
   put 0 into tN
   replace "|" with cr in pPts
   repeat for each line tP in pPts
      Mesh.AddVertex pM, item 1 of tP, item 2 of tP, 0
      add 1 to tN
      if tN > 1 then Mesh.AddLine pM, pM["count"] - 1, pM["count"]
   end repeat
end Ramp.Poly

function Ramp.MudMesh
   local tM, i
   put Mesh.New() into tM
   repeat with i = 0 to 4
      Mesh.AddVertex tM, i * 10, -3 * (i mod 2), 0
      if i > 0 then Mesh.AddLine tM, i, i + 1
   end repeat
   return tM
end Ramp.MudMesh

function Ramp.FlagMesh
   local tM
   put Mesh.New() into tM
   Ramp.Poly tM, "0,0|0,-140|50,-125|0,-110"
   Ramp.Poly tM, "0,0|0,40"
   return tM
end Ramp.FlagMesh

-- a ground slice mesh for a given rise (one kind per rise, made when first needed)
function Ramp.SliceName pDY, pMud
   local tName, tM
   if pMud then return "Ramp.Mud"
   put "Ramp.G" & round(pDY) into tName
   if not (tName is among the lines of the keys of sSlice["defined"]) then
      put Mesh.New() into tM
      Mesh.AddVertex tM, 0, 0, 0
      Mesh.AddVertex tM, kSeg, -pDY, 0
      Mesh.AddVertex tM, 10, 10, 0
      Mesh.AddVertex tM, 16, 10, 0
      Mesh.AddLine tM, 1, 2
      Mesh.AddLine tM, 3, 4
      Mesh.Define tName, tM
      put true into sSlice["defined"][tName]
   end if
   return tName
end Ramp.SliceName

function Ramp.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Ramp.Keys

on Ramp.TestKeys pKeys
   put pKeys into sTestKeys
end Ramp.TestKeys

on Ramp.TestLives pN
   put pN into sLives
end Ramp.TestLives

function Ramp.Down pCode, pKeys
   return pCode is among the items of pKeys
end Ramp.Down

on Game.OnUpdate
   local tKeys, tWant, tG, tNewSlope, tIdx, tMud, i, tK, tType, tSX, tDiff
   put Ramp.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Ramp.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Ramp.GoLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put tKeys into sKeysWas
   if sDoneT > 0 then
      subtract 1 from sDoneT
      if sDoneT is 0 then Ramp.Result
      Ramp.ShowHUD
      exit Game.OnUpdate
   end if
   put sX div kSeg into tIdx
   put sMud[tIdx] is true and not sAir into tMud
   -- engine: turbo heats it and burns fuel; too hot and it stops to cool
   put sTop into tWant
   if sCool > 0 then
      subtract 1 from sCool
      put sTop * 0.25 into tWant
      if sCool is 0 then
         put 40 into sHeat
      end if
   else if Ramp.Down(32, tKeys) and sFuel > 0 then
      put sTurbo into tWant
      add 1.1 to sHeat
      subtract 0.35 from sFuel
      if sHeat >= 100 then
         put 75 into sCool
         Sound.Play "Zap"
         Ramp.Say "OVERHEATED! COOLING DOWN"
      end if
   else
      put max(0, sHeat - 0.5) into sHeat
   end if
   if tMud then put tWant * 0.5 into tWant
   if sTumble > 0 then
      subtract 1 from sTumble
      put 0 into tWant
      put sVX * 0.8 into sVX
      add 0.4 to sAng
      if sTumble is 0 then put 0 into sAng
   end if
   if not sAir then add (tWant - sVX) * 0.06 to sVX
   add sVX to sX
   -- the ground and the air
   put Ramp.H(sX) into tG
   if sAir then
      subtract kGrav from sVY
      add sVY to sY
      put max(sPeak, sY - tG) into sPeak
      subtract 0.012 from sAng                               -- the nose drops by itself, slowly
      if Ramp.Down(65361, tKeys) or Ramp.Down(97, tKeys) then add 0.06 to sAng
      if Ramp.Down(65363, tKeys) or Ramp.Down(100, tKeys) then subtract 0.06 from sAng
      if sY <= tG then
         Ramp.Land tG
      end if
   else
      put (Ramp.H(sX + max(1, sVX)) - tG) / max(1, sVX) into tNewSlope
      -- over a lip (the ground falls away faster than the bike): into the air
      if sSlope - tNewSlope > 0.35 and sSlope > 0.2 and sVX > 2 then
         put true into sAir
         Sound.Play "Jump"
         put sVX * sSlope into sVY
         put tG into sY
         put 0 into sPeak
      else
         put tG into sY
         put tNewSlope into sSlope
         if sTumble <= 0 then put atan(sSlope) into sAng
      end if
   end if
   if sHeat > 0 and not Ramp.Down(32, tKeys) and sCool <= 0 then put max(0, sHeat - 0.1) into sHeat
   Entity.SetPosition sBike, kBikeX, kBase - sY, kZ
   Entity.SetRotation sBike, 0, 0, -sAng
   if tMud and sTicks mod 3 is 0 then FX.Sparks kBikeX - 20, kBase - sY, kZ, 2, "140,90,40"
   -- fuel cans
   if sCan[tIdx] is true then
      put false into sCan[tIdx]
      put min(100, sFuel + 40) into sFuel
      Sound.Play "Pickup"
      add 50 to sScore
      Ramp.Say "FUEL +40"
   end if
   Ramp.DrawGround
   Ramp.Riders
   if sX >= sPts * kSeg and sDone is 0 then Ramp.CrossLine 0
   Entity.SetPosition sFinish, kBikeX + sPts * kSeg - sX, kBase - Ramp.H(sPts * kSeg), kZ + 1
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Ramp.ShowHUD
end Game.OnUpdate

-- landing: the bike's angle against the ground's
on Ramp.Land pG
   local tSlope, tDiff
   put false into sAir
   put pG into sY
   put (Ramp.H(sX + 20) - Ramp.H(sX - 20)) / 40 into tSlope
   put abs(sAng - atan(tSlope)) into tDiff
   if tDiff < 0.6 then
      add round(sPeak) to sScore
      Sound.Play "Thud"
      if sPeak > 40 then Ramp.Say "CLEAN LANDING +" & round(sPeak)
      put tSlope into sSlope
      put sVY * tSlope * 0.2 + sVX into sVX              -- a good landing on a down slope keeps speed
   else
      FX.Sparks kBikeX, kBase - sY, kZ, 20, "255,120,40"
      Sound.Play "PlayerCrash"
      subtract 1 from sLives
      put 40 into sTumble
      put sVX * 0.3 into sVX
      put empty into sHUDWas
      if sLives <= 0 then
         put true into sOver
         Ramp.Say "TUMBLED OUT OF THE RACE"
      else
         Ramp.Say "TUMBLE! LAND AT THE SLOPE"
      end if
   end if
   put 0 into sVY
end Ramp.Land

on Ramp.DrawGround
   local i, tIdx, tName, tFirst
   put sX div kSeg - 6 into tFirst
   repeat with i = 0 to kSlices
      put tFirst + i into tIdx
      if tIdx < 0 then
         put Ramp.SliceName(0, false) into tName
      else
         put Ramp.SliceName(sH[tIdx + 1] - sH[tIdx], sMud[tIdx] is true) into tName
      end if
      if tName is not sSlice[i]["type"] then
         if sSlice[i]["key"] is not empty then Entity.Kill sSlice[i]["key"]
         if tName is "Ramp.Mud" then
            put Entity.Spawn(tName, 0, kBase, kZ, "160,100,40") into sSlice[i]["key"]
         else
            put Entity.Spawn(tName, 0, kBase, kZ, "220,200,160") into sSlice[i]["key"]
         end if
         put tName into sSlice[i]["type"]
      end if
      Entity.SetPosition sSlice[i]["key"], kBikeX + tIdx * kSeg - sX, kBase - sH[max(0, tIdx)], kZ
   end repeat
end Ramp.DrawGround

-- the riders: steady speed, they fly off the lips too, they never fall
on Ramp.Riders
   local i, tG, tS0, tS1, tZ
   repeat with i = 1 to 3
      add sRider[i]["top"] * (0.95 + 0.05 * sin(sTicks / 40 + i)) to sRider[i]["x"]
      put Ramp.H(sRider[i]["x"]) into tG
      if sRider[i]["air"] then
         subtract kGrav from sRider[i]["vy"]
         add sRider[i]["vy"] to sRider[i]["y"]
         if sRider[i]["y"] <= tG then
            put false into sRider[i]["air"]
            put tG into sRider[i]["y"]
         end if
      else
         put (tG - Ramp.H(sRider[i]["x"] - sRider[i]["top"])) / sRider[i]["top"] into tS0
         put (Ramp.H(sRider[i]["x"] + sRider[i]["top"]) - tG) / sRider[i]["top"] into tS1
         if tS0 - tS1 > 0.35 and tS0 > 0.2 then
            put true into sRider[i]["air"]
            put sRider[i]["top"] * tS0 into sRider[i]["vy"]
         end if
         put tG into sRider[i]["y"]
      end if
      put kZ + i * 70 into tZ
      -- the lanes behind are further away: place them so they line up with your ground
      Entity.SetPosition sRider[i]["key"], (kBikeX + sRider[i]["x"] - sX) * tZ / kZ, (kBase - sRider[i]["y"]) * tZ / kZ - i * 14, tZ
      if sRider[i]["air"] then
         Entity.SetRotation sRider[i]["key"], 0, 0, 0.15
      else
         Entity.SetRotation sRider[i]["key"], 0, 0, -atan((Ramp.H(sRider[i]["x"] + 20) - Ramp.H(sRider[i]["x"] - 20)) / 40)
      end if
      if sRider[i]["x"] >= sPts * kSeg and sRider[i]["done"] is empty then
         put true into sRider[i]["done"]
         add 1 to sDone
      end if
   end repeat
end Ramp.Riders

on Ramp.CrossLine
   put sDone + 1 into sPlace
   put 1 into sDone
   put 60 into sDoneT
   if sPlace is 1 then
      Sound.Play "Win"
   else
      Sound.Play "Blip"
   end if
   Ramp.Say "FINISHED IN PLACE" && sPlace
end Ramp.CrossLine

on Ramp.Result
   add sBonus * (5 - sPlace) to sScore
   if sPlace is 4 then
      subtract 1 from sLives
      if sLives <= 0 then
         Sound.Play "Lose"
         put true into sOver
         put empty into sHUDWas
         exit Ramp.Result
      end if
      Ramp.StartLevel sLevel
   else if sPlace > 1 then
      Ramp.StartLevel sLevel
   else if sLevel >= 5 then
      put true into sWon
      put true into sOver
      put empty into sHUDWas
   else
      Ramp.GoLevel sLevel + 1
   end if
end Ramp.Result

on Ramp.Say pText
   put pText into sMsg
   put 45 into sMsgT
   put empty into sHUDWas
end Ramp.Say

on Ramp.ShowHUD
   local tWords, tLine, tBar
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & round(sHeat / 10) & "|" & round(sFuel / 10) & "|" & sMsg & "|" & round(100 * sX / (sPts * kSeg)) into tWords
   if tWords is sHUDWas then exit Ramp.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Ramp.Score", "SCORE" && sScore && " LIVES" && sLives && " COURSE" && sLevel & "/5  PROGRESS" && min(100, round(100 * sX / (sPts * kSeg))), 20, 40, 14
   if sOver and sWon then
      put "RAMP CHAMPION!  SPACE TO RIDE AGAIN" into tLine
   else if sOver then
      put "GAME OVER.  SPACE TO RIDE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else
      put "HEAT" && round(sHeat) && "  FUEL" && round(sFuel) into tLine
   end if
   HUD.Set "Ramp.Msg", tLine, 20, 70, 12
end Ramp.ShowHUD

function Ramp.State
   local i, tS
   put sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "/" & sPts * kSeg & "|y " & round(sY) & "|air " & sAir & "|ang " & round(sAng, 2) & "|heat " & round(sHeat) & "|fuel " & round(sFuel) & "|" & sOver into tS
   repeat with i = 1 to 3
      put "|r" & i && round(sRider[i]["x"]) after tS
   end repeat
   return tS
end Ramp.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
