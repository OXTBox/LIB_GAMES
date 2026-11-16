######################################################################################
## CARD SCRIPT: "Play.FareDash"   FARE DASH  (11 14 2026)
## A taxi in a neon city seen from above. Pick up the magenta fare, drive them to the
## yellow mark, beat the clock. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/634_Fare_Dash), script by Claude.
## CONTROLS  Arrows (or WASD): drive    Space: step on it    Escape: pause
## RULES     a delivery is 100 points plus a tip for the time it took, and 20 seconds on
##           the clock. Brushing past traffic without touching is a near miss: a 1.5x tip.
##           Hitting a car costs 3 seconds. Orange roadworks block streets. If the clock
##           runs out you lose a life and the fare. Deliver all the level's fares: next
##           level (5).
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sTaxi, sX, sY, sDirX, sDirY, sBlock, sBlockN, sCar, sFare, sDest, sRide, sRideT
local sClock, sDelivered, sNeed, sLevel, sLives, sScore, sOver, sWon, sTips, sMsg, sMsgT
local sSpeed, sKeysWas, sTestKeys, sHUDWas, sTicks, sBump

constant kZ = 300            -- the city plane (screen scale is 300/z: here 1 unit = 1 pixel)
constant kLeft = -440
constant kTop = -200
constant kStreet = 70
constant kCols = 5
constant kRows = 3
constant kTaxiR = 14         -- the taxi's half size for walls

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 3 into sLives
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Fare.StartLevel 1
end Game.OnStart

function Fare.BlockW
   return (880 - (kCols + 1) * kStreet) / kCols
end Fare.BlockW

function Fare.BlockH
   return (490 - (kRows + 1) * kStreet) / kRows
end Fare.BlockH

-- Spark's table: taxi speed | fares | lives
on Fare.StartLevel pLevel
   local tRow, i, j, tX, tY, tW, tH, tN, tColors
   put pLevel into sLevel
   put line pLevel of ("180,3,3" & cr & "190,3,3" & cr & "200,4,3" & cr & "210,4,2" & cr & "220,5,2") into tRow
   put (item 1 of tRow) / 45 into sSpeed
   put item 2 of tRow into sNeed
   if sLives > item 3 of tRow then put item 3 of tRow into sLives
   Scene.ClearAll
   Mesh.Define "Fare.Taxi", Fare.TaxiMesh()
   Mesh.Define "Fare.Car", Fare.CarMesh()
   Mesh.Define "Fare.Fare", MeshPyramid(6, 14, 26)
   Mesh.Define "Fare.Dest", Fare.RingMesh(26)
   Mesh.Define "Fare.Works", MeshBox(kStreet - 6, 14, 10)
   put Fare.BlockW() into tW
   put Fare.BlockH() into tH
   Mesh.Define "Fare.Block", Fare.BlockMesh(tW, tH)
   -- the city blocks
   put empty into sBlock
   put 0 into sBlockN
   put "255,0,200|0,220,255|170,80,255|255,60,120|0,255,170" into tColors
   set the itemDel to "|"
   repeat with j = 1 to kRows
      repeat with i = 1 to kCols
         put kLeft + kStreet + (i - 1) * (tW + kStreet) + tW / 2 into tX
         put kTop + kStreet + (j - 1) * (tH + kStreet) + tH / 2 into tY
         Fare.AddBlock tX, tY, tW / 2, tH / 2
         get Entity.Spawn("Fare.Block", tX, tY, kZ, item ((i + j) mod 5) + 1 of tColors)
      end repeat
   end repeat
   set the itemDel to comma
   -- the city edge
   Fare.AddBlock 0, kTop - 50, 600, 50
   Fare.AddBlock 0, kTop + 490 + 50, 600, 50
   Fare.AddBlock kLeft - 50, kTop + 245, 50, 400
   Fare.AddBlock -kLeft + 50, kTop + 245, 50, 400
   Mesh.Define "Fare.Edge", MeshBox(880, 490, 2)
   get Entity.Spawn("Fare.Edge", 0, kTop + 245, kZ + 5, "80,80,120")
   -- roadworks: one less street each level after the first
   repeat with tN = 1 to pLevel - 1
      put random(kCols - 1) into i
      put random(kRows) into j
      -- across a vertical street, between two blocks of a row
      put kLeft + i * (tW + kStreet) + kStreet / 2 into tX
      put kTop + kStreet + (j - 1) * (tH + kStreet) + tH / 2 into tY
      Fare.AddBlock tX, tY, kStreet / 2, 7
      get Entity.Spawn("Fare.Works", tX, tY, kZ, "255,150,0")
   end repeat
   -- traffic: cars that run along the streets
   put empty into sCar
   repeat with i = 1 to 2 + pLevel
      Fare.AddCar i
   end repeat
   put 0 into sX
   put kTop + kStreet / 2 into sY
   put kLeft + kStreet / 2 into sX
   put 1 into sDirX
   put 0 into sDirY
   put Entity.Spawn("Fare.Taxi", sX, sY, kZ, "255,230,0") into sTaxi
   put Entity.Spawn("Fare.Fare", 0, -900, kZ, "255,0,255") into sFare["key"]
   put Entity.Spawn("Fare.Dest", 0, -900, kZ, "255,255,0") into sDest["key"]
   put 0 into sDelivered
   put 0 into sBump
   put 1350 into sClock                            -- 45 seconds
   Fare.NewFare
   put "LEVEL" && pLevel & ": DELIVER" && sNeed && "FARES" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Fare.StartLevel

on Fare.AddBlock pX, pY, pHW, pHH
   add 1 to sBlockN
   put pX - pHW & "," & pY - pHH & "," & pX + pHW & "," & pY + pHH into sBlock[sBlockN]
end Fare.AddBlock

-- the middle of a street: horizontal street pRow (0..kRows) or vertical street pCol (0..kCols)
function Fare.HStreetY pRow
   return kTop + kStreet / 2 + pRow * (Fare.BlockH() + kStreet)
end Fare.HStreetY

function Fare.VStreetX pCol
   return kLeft + kStreet / 2 + pCol * (Fare.BlockW() + kStreet)
end Fare.VStreetX

on Fare.AddCar pN
   local tCol
   if pN mod 2 is 1 then
      put "h" into sCar[pN]["axis"]
      put random(kCols * 100) * 880 / (kCols * 100) + kLeft into sCar[pN]["x"]
      put Fare.HStreetY(random(kRows + 1) - 1) + (random(2) * 2 - 3) * 14 into sCar[pN]["y"]
      put (random(2) * 2 - 3) * (1.6 + sLevel * 0.3) into sCar[pN]["v"]
   else
      put "v" into sCar[pN]["axis"]
      put Fare.VStreetX(random(kCols + 1) - 1) + (random(2) * 2 - 3) * 14 into sCar[pN]["x"]
      put kTop + random(490) into sCar[pN]["y"]
      put (random(2) * 2 - 3) * (1.6 + sLevel * 0.3) into sCar[pN]["v"]
   end if
   put 0 into sCar[pN]["near"]
   set the itemDel to "|"
   put item random(3) of "0,255,120|255,80,80|120,160,255" into tCol
   set the itemDel to comma
   put Entity.Spawn("Fare.Car", sCar[pN]["x"], sCar[pN]["y"], kZ, tCol) into sCar[pN]["key"]
   if sCar[pN]["axis"] is "v" then SetObjectRotation sCar[pN]["key"], 0, 0, 1.5708
end Fare.AddCar

function Fare.TaxiMesh
   local tM
   put Mesh.New() into tM
   Fare.AddBox tM, 0, 0, 0, 40, 22, 12
   Fare.AddBox tM, -2, 0, -6, 18, 16, 6
   Fare.AddBox tM, -2, 0, -12, 8, 6, 6                -- the roof light
   return tM
end Fare.TaxiMesh

function Fare.CarMesh
   local tM
   put Mesh.New() into tM
   Fare.AddBox tM, 0, 0, 0, 36, 20, 12
   Fare.AddBox tM, 2, 0, -6, 16, 14, 6
   return tM
end Fare.CarMesh

function Fare.BlockMesh pW, pH
   local tM, i
   put Mesh.New() into tM
   Fare.AddBox tM, 0, 0, 0, pW, pH, 20
   -- rooftops: a few windows
   repeat with i = 1 to 3
      Fare.AddBox tM, -pW / 2 + i * pW / 4, 0, -12, pW / 8, pH / 3, 2
   end repeat
   return tM
end Fare.BlockMesh

function Fare.RingMesh pR
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 11
      put i * 3.14159 / 6 into tA
      Mesh.AddVertex tM, pR * cos(tA), pR * sin(tA), 0
   end repeat
   repeat with i = 1 to 12
      Mesh.AddLine tM, i, (i mod 12) + 1
   end repeat
   Mesh.AddVertex tM, 0, -8, 0
   Mesh.AddVertex tM, 0, 8, 0
   Mesh.AddVertex tM, -8, 0, 0
   Mesh.AddVertex tM, 8, 0, 0
   Mesh.AddLine tM, 13, 14
   Mesh.AddLine tM, 15, 16
   return tM
end Fare.RingMesh

on Fare.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Fare.AddBox

-- a random kerb spot on some street, far enough from pAwayX,pAwayY
function Fare.Spot pAwayX, pAwayY
   local tX, tY, tTries
   repeat with tTries = 1 to 40
      if random(2) is 1 then
         put Fare.HStreetY(random(kRows + 1) - 1) into tY
         put kLeft + 40 + random(800) into tX
      else
         put Fare.VStreetX(random(kCols + 1) - 1) into tX
         put kTop + 40 + random(410) into tY
      end if
      if not Fare.Solid(tX, tY, 10) and abs(tX - pAwayX) + abs(tY - pAwayY) > 380 then exit repeat
   end repeat
   return tX & "," & tY
end Fare.Spot

on Fare.NewFare
   local tP
   put Fare.Spot(sX, sY) into tP
   put item 1 of tP into sFare["x"]
   put item 2 of tP into sFare["y"]
   SetObjectPosition sFare["key"], sFare["x"], sFare["y"], kZ - 10
   SetObjectPosition sDest["key"], 0, -900, kZ
   put false into sRide
end Fare.NewFare

function Fare.Solid pX, pY, pR
   local tK, tB
   repeat for each key tK in sBlock
      put sBlock[tK] into tB
      if pX + pR > item 1 of tB and pX - pR < item 3 of tB and pY + pR > item 2 of tB and pY - pR < item 4 of tB then return true
   end repeat
   return false
end Fare.Solid

function Fare.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Fare.Keys

on Fare.TestKeys pKeys
   put pKeys into sTestKeys
end Fare.TestKeys

-- for tests: put the taxi at the fare (1) or at the destination (2)
on Fare.TestJump pWhere
   if pWhere is 1 then
      put sFare["x"] into sX
      put sFare["y"] into sY
   else
      put sDest["x"] into sX
      put sDest["y"] into sY
   end if
end Fare.TestJump

function Fare.Down pCode, pKeys
   return pCode is among the items of pKeys
end Fare.Down

on Game.OnUpdate
   local tKeys, tDX, tDY, tV, tNX, tNY, tK, tGap, tTip
   put Fare.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Fare.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Fare.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put tKeys into sKeysWas
   -- steering: the arrows point the taxi, it keeps rolling that way
   put 0 into tDX
   put 0 into tDY
   if Fare.Down(65361, tKeys) or Fare.Down(97, tKeys) then put -1 into tDX
   if Fare.Down(65363, tKeys) or Fare.Down(100, tKeys) then put 1 into tDX
   if Fare.Down(65362, tKeys) or Fare.Down(119, tKeys) then put -1 into tDY
   if Fare.Down(65364, tKeys) or Fare.Down(115, tKeys) then put 1 into tDY
   put sSpeed into tV
   if tDX is 0 and tDY is 0 then
      put 0 into tV                                 -- no arrow, no motion
   else
      put tDX into sDirX
      put tDY into sDirY
      if tDX is not 0 and tDY is not 0 then put tV * 0.72 into tV
   end if
   if Fare.Down(32, tKeys) then put tV * 1.7 into tV
   if sBump > 0 then
      subtract 1 from sBump
      put tV * 0.3 into tV
   end if
   -- move one axis at a time so the taxi slides along the walls
   put sX + sDirX * tV into tNX
   if not Fare.Solid(tNX, sY, kTaxiR) then put tNX into sX
   put sY + sDirY * tV into tNY
   if not Fare.Solid(sX, tNY, kTaxiR) then put tNY into sY
   SetObjectPosition sTaxi, sX, sY, kZ
   SetObjectRotation sTaxi, 0, 0, atan2(sDirY, sDirX)
   -- traffic
   put 0 into tTip
   repeat for each key tK in sCar
      if sCar[tK]["axis"] is "h" then
         add sCar[tK]["v"] to sCar[tK]["x"]
         if sCar[tK]["x"] > -kLeft + 30 then put kLeft - 30 into sCar[tK]["x"]
         if sCar[tK]["x"] < kLeft - 30 then
            put -kLeft + 30 into sCar[tK]["x"]
         end if
      else
         add sCar[tK]["v"] to sCar[tK]["y"]
         if sCar[tK]["y"] > kTop + 520 then put kTop - 30 into sCar[tK]["y"]
         if sCar[tK]["y"] < kTop - 30 then put kTop + 520 into sCar[tK]["y"]
      end if
      SetObjectPosition sCar[tK]["key"], sCar[tK]["x"], sCar[tK]["y"], kZ
      put max(abs(sCar[tK]["x"] - sX), abs(sCar[tK]["y"] - sY)) into tGap
      if tGap < 26 and sBump <= 0 then
         -- a crash: three seconds lost
         subtract 90 from sClock
         put 12 into sBump
         put 40 into sCar[tK]["near"]
         FX.Sparks sX, sY, kZ, 12, "255,80,80"
         put "CRASH! -3 SECONDS" into sMsg
         put 30 into sMsgT
      else if tGap < 44 and sCar[tK]["near"] <= 0 and tV > 0 then
         -- a near miss
         put 40 into sCar[tK]["near"]
         put round(25 * 1.5) into tTip
      end if
      if sCar[tK]["near"] > 0 then subtract 1 from sCar[tK]["near"]
   end repeat
   if tTip > 0 then
      add tTip to sScore
      add tTip to sTips
      FX.Sparks sX, sY, kZ, 6, "255,150,0"
      put "NEAR MISS! TIP" && tTip into sMsg
      put 30 into sMsgT
   end if
   -- the fare
   if not sRide then
      SetObjectRotation sFare["key"], 0, 0, sTicks / 10
      if abs(sFare["x"] - sX) < 26 and abs(sFare["y"] - sY) < 26 then
         put true into sRide
         put 0 into sRideT
         get Fare.Spot(sX, sY)
         put item 1 of it into sDest["x"]
         put item 2 of it into sDest["y"]
         SetObjectPosition sFare["key"], 0, -900, kZ
         SetObjectPosition sDest["key"], sDest["x"], sDest["y"], kZ - 2
         FX.Sparks sX, sY, kZ, 8, "255,0,255"
         put "TAKE ME TO THE YELLOW MARK!" into sMsg
         put 40 into sMsgT
      end if
   else
      add 1 to sRideT
      SetObjectRotation sDest["key"], 0, 0, sTicks / 12
      if abs(sDest["x"] - sX) < 30 and abs(sDest["y"] - sY) < 30 then
         add 1 to sDelivered
         add 100 + max(0, 300 - sRideT) div 3 to sScore
         add 600 to sClock
         FX.Sparks sX, sY, kZ, 16, "255,255,0"
         put "DELIVERED! +20 SECONDS" into sMsg
         put 40 into sMsgT
         if sDelivered >= sNeed then
            add 250 * sLevel + sClock div 30 * 5 to sScore
            if sLevel >= 5 then
               put true into sWon
               put true into sOver
            else
               Fare.StartLevel sLevel + 1
            end if
            exit Game.OnUpdate
         end if
         Fare.NewFare
      end if
   end if
   -- the clock
   subtract 1 from sClock
   if sClock <= 0 then
      subtract 1 from sLives
      FX.Sparks sX, sY, kZ, 20, "255,80,80"
      if sLives <= 0 then
         put true into sOver
      else
         put 1350 into sClock
         Fare.NewFare
         put "OUT OF TIME! THE FARE WALKED" into sMsg
         put 60 into sMsgT
      end if
   end if
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Fare.ShowHUD
end Game.OnUpdate

on Fare.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & sClock div 30 & "|" & sDelivered & "|" & sMsg & "|" & sRide into tWords
   if tWords is sHUDWas then exit Fare.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Fare.Score", "SCORE" && sScore && " LIVES" && sLives && " LEVEL" && sLevel && " FARES" && sDelivered & "/" & sNeed && " CLOCK" && max(0, sClock div 30), 20, 40, 14
   if sOver and sWon then
      put "TOP CABBIE OF NEON CITY!  SPACE TO DRIVE AGAIN" into tLine
   else if sOver then
      put "OFF DUTY.  SPACE TO DRIVE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else if sRide then
      put "TO THE YELLOW MARK" into tLine
   else
      put "PICK UP THE MAGENTA FARE" into tLine
   end if
   HUD.Set "Fare.Msg", tLine, 20, 70, 12
end Fare.ShowHUD

function Fare.State
   return sLevel & "|" & sLives & "|" & sScore & "|at " & round(sX) & "," & round(sY) & "|ride " & sRide & "|fares " & sDelivered & "/" & sNeed & "|clock " & sClock & "|" & sOver
end Fare.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
