######################################################################################
## CARD SCRIPT: "Play.BlockCityHustle"   BLOCK CITY HUSTLE  (11 14 2026)
## A colourful city seen from above. Answer the ringing blue phone booth, fetch the orange
## package and drop it at the yellow mark. Borrow parked cars to go fast; every car you
## take and every job you do raises your heat, and heat brings red patrol cars. The purple
## paint shop clears your heat. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/841_Block_City_Hustle), script by Claude.
## CONTROLS  Arrows (or WASD): walk / drive    Space: take a parked car, answer a booth
##           Escape: pause
## RULES     heat is 0 to 5. From heat 2 the patrols come, one more for each step of heat.
##           A patrol catching you costs a life (and your heat). A car runs 15 seconds,
##           then you leave it. Finish the level's jobs: next level (5).
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sMe, sX, sY, sDirX, sDirY, sBlock, sBlockN, sParked, sPatrol, sBooth, sRinging
local sJob, sPkg, sDest, sShop, sInCar, sCarT, sCarKey, sHeat, sJobsDone, sNeed, sBonus
local sLevel, sLives, sScore, sOver, sWon, sMsg, sMsgT, sWalk, sHurt
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 300            -- screen scale 300/z: 1 unit = 1 pixel
constant kLeft = -440
constant kTop = -200
constant kStreet = 70
constant kCols = 5
constant kRows = 3
constant kR = 10             -- your half size for walls

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
   Hust.StartLevel 1
end Game.OnStart

function Hust.BlockW
   return (880 - (kCols + 1) * kStreet) / kCols
end Hust.BlockW

function Hust.BlockH
   return (490 - (kRows + 1) * kStreet) / kRows
end Hust.BlockH

function Hust.HStreetY pRow
   return kTop + kStreet / 2 + pRow * (Hust.BlockH() + kStreet)
end Hust.HStreetY

function Hust.VStreetX pCol
   return kLeft + kStreet / 2 + pCol * (Hust.BlockW() + kStreet)
end Hust.VStreetX

-- Spark's table: speed | jobs | lives | bonus
on Hust.StartLevel pLevel
   local tRow, i, j, tX, tY, tW, tH, tColors, tP
   put pLevel into sLevel
   put line pLevel of ("150,3,3,0" & cr & "150,4,3,500" & cr & "160,5,3,1000" & cr & "170,6,2,1500" & cr & "180,7,2,2000") into tRow
   put (item 1 of tRow) / 60 into sWalk
   put item 2 of tRow into sNeed
   put item 4 of tRow into sBonus
   if sLives > item 3 of tRow then put item 3 of tRow into sLives
   Scene.ClearAll
   put Hust.BlockW() into tW
   put Hust.BlockH() into tH
   Mesh.Define "Hust.Block", Hust.BlockMesh(tW, tH)
   Mesh.Define "Hust.Me", Hust.MeMesh()
   Mesh.Define "Hust.Car", Hust.CarMesh(36, 20)
   Mesh.Define "Hust.Patrol", Hust.CarMesh(40, 22)
   Mesh.Define "Hust.Booth", Hust.BoothMesh()
   Mesh.Define "Hust.Pkg", MeshBox(14, 14, 14)
   Mesh.Define "Hust.Ring", Hust.RingMesh(22)
   Mesh.Define "Hust.Shop", Hust.RingMesh(28)
   Mesh.Define "Hust.Edge", MeshBox(880, 490, 2)
   put empty into sBlock
   put 0 into sBlockN
   put "255,80,80|255,200,0|0,220,120|80,160,255|255,120,220" into tColors
   set the itemDel to "|"
   repeat with j = 1 to kRows
      repeat with i = 1 to kCols
         put kLeft + kStreet + (i - 1) * (tW + kStreet) + tW / 2 into tX
         put kTop + kStreet + (j - 1) * (tH + kStreet) + tH / 2 into tY
         Hust.AddBlock tX, tY, tW / 2, tH / 2
         get Entity.Spawn("Hust.Block", tX, tY, kZ, item ((i * 2 + j) mod 5) + 1 of tColors)
      end repeat
   end repeat
   set the itemDel to comma
   Hust.AddBlock 0, kTop - 50, 600, 50
   Hust.AddBlock 0, kTop + 540, 600, 50
   Hust.AddBlock kLeft - 50, kTop + 245, 50, 400
   Hust.AddBlock -kLeft + 50, kTop + 245, 50, 400
   get Entity.Spawn("Hust.Edge", 0, kTop + 245, kZ + 5, "80,80,120")
   -- phone booths at three street corners
   put empty into sBooth
   repeat with i = 1 to 3
      put Hust.VStreetX(item i of "1,3,4") & "," & Hust.HStreetY(item i of "0,2,1") into tP
      put item 1 of tP into sBooth[i]["x"]
      put item 2 of tP into sBooth[i]["y"]
      put Entity.Spawn("Hust.Booth", sBooth[i]["x"], sBooth[i]["y"], kZ, "60,120,255") into sBooth[i]["key"]
   end repeat
   -- parked cars
   put empty into sParked
   repeat with i = 1 to 4
      put Hust.Spot(9999, 9999) into tP
      put item 1 of tP into sParked[i]["x"]
      put item 2 of tP into sParked[i]["y"]
      put Entity.Spawn("Hust.Car", sParked[i]["x"], sParked[i]["y"], kZ, "0,200,200") into sParked[i]["key"]
   end repeat
   put Entity.Spawn("Hust.Shop", 0, 0, kZ, "200,80,255") into sShop["key"]
   Hust.MoveShop
   put Entity.Spawn("Hust.Pkg", 0, -900, kZ, "255,150,0") into sPkg["key"]
   put Entity.Spawn("Hust.Ring", 0, -900, kZ, "255,255,0") into sDest["key"]
   put empty into sPatrol
   put kLeft + kStreet / 2 into sX
   put Hust.HStreetY(kRows) into sY
   put 1 into sDirX
   put 0 into sDirY
   put Entity.Spawn("Hust.Me", sX, sY, kZ, "255,255,255") into sMe
   put false into sInCar
   put 0 into sHeat
   put 0 into sJobsDone
   put empty into sJob
   put 0 into sHurt
   put random(3) into sRinging
   put "LEVEL" && pLevel & ": ANSWER THE RINGING BOOTH" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Hust.StartLevel

on Hust.AddBlock pX, pY, pHW, pHH
   add 1 to sBlockN
   put pX - pHW & "," & pY - pHH & "," & pX + pHW & "," & pY + pHH into sBlock[sBlockN]
end Hust.AddBlock

function Hust.BlockMesh pW, pH
   local tM
   put Mesh.New() into tM
   Hust.AddBox tM, 0, 0, 0, pW, pH, 20
   Hust.AddBox tM, -pW / 5, -pH / 6, -14, pW / 3, pH / 3, 8
   Hust.AddBox tM, pW / 4, pH / 6, -12, pW / 5, pH / 4, 6
   return tM
end Hust.BlockMesh

function Hust.MeMesh
   local tM
   put Mesh.New() into tM
   Hust.AddBox tM, 0, 0, 0, 10, 14, 10
   Hust.AddBox tM, 0, 0, -8, 8, 8, 6
   return tM
end Hust.MeMesh

function Hust.CarMesh pW, pH
   local tM
   put Mesh.New() into tM
   Hust.AddBox tM, 0, 0, 0, pW, pH, 12
   Hust.AddBox tM, -2, 0, -6, pW * 0.45, pH * 0.75, 6
   return tM
end Hust.CarMesh

function Hust.BoothMesh
   local tM
   put Mesh.New() into tM
   Hust.AddBox tM, 0, 0, 0, 22, 22, 30
   Hust.AddBox tM, 0, 0, -18, 14, 14, 4
   return tM
end Hust.BoothMesh

function Hust.RingMesh pR
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 11
      put i * 3.14159 / 6 into tA
      Mesh.AddVertex tM, pR * cos(tA), pR * sin(tA), 0
   end repeat
   repeat with i = 1 to 12
      Mesh.AddLine tM, i, (i mod 12) + 1
   end repeat
   return tM
end Hust.RingMesh

on Hust.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Hust.AddBox

function Hust.Spot pAwayX, pAwayY
   local tX, tY, tTries
   repeat with tTries = 1 to 40
      if random(2) is 1 then
         put Hust.HStreetY(random(kRows + 1) - 1) into tY
         put kLeft + 40 + random(800) into tX
      else
         put Hust.VStreetX(random(kCols + 1) - 1) into tX
         put kTop + 40 + random(410) into tY
      end if
      if not Hust.Solid(tX, tY, 10) and abs(tX - pAwayX) + abs(tY - pAwayY) > 360 then exit repeat
   end repeat
   return tX & "," & tY
end Hust.Spot

function Hust.Solid pX, pY, pR
   local tK, tB
   repeat for each key tK in sBlock
      put sBlock[tK] into tB
      if pX + pR > item 1 of tB and pX - pR < item 3 of tB and pY + pR > item 2 of tB and pY - pR < item 4 of tB then return true
   end repeat
   return false
end Hust.Solid

on Hust.MoveShop
   get Hust.Spot(sX, sY)
   put item 1 of it into sShop["x"]
   put item 2 of it into sShop["y"]
   SetObjectPosition sShop["key"], sShop["x"], sShop["y"], kZ + 1
end Hust.MoveShop

function Hust.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Hust.Keys

on Hust.TestKeys pKeys
   put pKeys into sTestKeys
end Hust.TestKeys

-- for tests: 1 to the ringing booth, 2 to the package, 3 to the mark, 4 to a parked car, 5 heat 3
on Hust.TestJump pWhere
   switch pWhere
      case 1
         put sBooth[sRinging]["x"] into sX
         put sBooth[sRinging]["y"] into sY
         break
      case 2
         put sPkg["x"] into sX
         put sPkg["y"] into sY
         break
      case 3
         put sDest["x"] into sX
         put sDest["y"] into sY
         break
      case 4
         put sParked[1]["x"] into sX
         put sParked[1]["y"] into sY
         break
      case 5
         Hust.AddHeat 3
         break
   end switch
end Hust.TestJump

function Hust.Down pCode, pKeys
   return pCode is among the items of pKeys
end Hust.Down

on Game.OnUpdate
   local tKeys, tDX, tDY, tV, tNX, tNY, tK, tPress, tNear
   put Hust.Keys() into tKeys
   add 1 to sTicks
   put Hust.Down(32, tKeys) and not (32 is among the items of sKeysWas) into tPress
   put tKeys into sKeysWas
   if sOver then
      if tPress then
         put 0 into sScore
         put 3 into sLives
         put false into sOver
         put false into sWon
         Hust.StartLevel 1
      end if
      exit Game.OnUpdate
   end if
   put 0 into tDX
   put 0 into tDY
   if Hust.Down(65361, tKeys) or Hust.Down(97, tKeys) then put -1 into tDX
   if Hust.Down(65363, tKeys) or Hust.Down(100, tKeys) then put 1 into tDX
   if Hust.Down(65362, tKeys) or Hust.Down(119, tKeys) then put -1 into tDY
   if Hust.Down(65364, tKeys) or Hust.Down(115, tKeys) then put 1 into tDY
   put sWalk into tV
   if sInCar then put sWalk * 2.4 into tV
   if tDX is 0 and tDY is 0 then
      put 0 into tV
   else
      put tDX into sDirX
      put tDY into sDirY
      if tDX is not 0 and tDY is not 0 then put tV * 0.72 into tV
   end if
   put sX + sDirX * tV into tNX
   if not Hust.Solid(tNX, sY, kR) then put tNX into sX
   put sY + sDirY * tV into tNY
   if not Hust.Solid(sX, tNY, kR) then put tNY into sY
   if sInCar then
      SetObjectPosition sCarKey, sX, sY, kZ
      SetObjectRotation sCarKey, 0, 0, atan2(sDirY, sDirX)
      subtract 1 from sCarT
      if sCarT <= 0 then
         Hust.LeaveCar
      end if
   else
      SetObjectPosition sMe, sX, sY, kZ
   end if
   -- Space: take a parked car, or answer the ringing booth
   if tPress and not sInCar then
      put false into tNear
      repeat for each key tK in sParked
         if abs(sParked[tK]["x"] - sX) < 30 and abs(sParked[tK]["y"] - sY) < 30 then
            put true into sInCar
            put 450 into sCarT
            put sParked[tK]["key"] into sCarKey
            delete variable sParked[tK]
            SetObjectPosition sMe, 0, -900, kZ
            Hust.AddHeat 1
            Hust.Say "YOU TOOK A CAR. HEAT UP"
            put true into tNear
            exit repeat
         end if
      end repeat
      if not tNear and sJob is empty and abs(sBooth[sRinging]["x"] - sX) < 30 and abs(sBooth[sRinging]["y"] - sY) < 30 then Hust.StartJob
   end if
   -- the ringing booth bobs
   repeat for each key tK in sBooth
      if tK is sRinging and sJob is empty then
         SetObjectRotation sBooth[tK]["key"], 0, 0, 0.3 * sin(sTicks / 2)
      else
         SetObjectRotation sBooth[tK]["key"], 0, 0, 0
      end if
   end repeat
   -- the job
   if sJob is "fetch" then
      SetObjectRotation sPkg["key"], sTicks / 10, sTicks / 8, 0
      if abs(sPkg["x"] - sX) < 22 and abs(sPkg["y"] - sY) < 22 then
         put "drop" into sJob
         SetObjectPosition sPkg["key"], 0, -900, kZ
         get Hust.Spot(sX, sY)
         put item 1 of it into sDest["x"]
         put item 2 of it into sDest["y"]
         SetObjectPosition sDest["key"], sDest["x"], sDest["y"], kZ + 1
         Hust.Say "GOT IT. TO THE YELLOW MARK"
      end if
   else if sJob is "drop" then
      SetObjectRotation sDest["key"], 0, 0, sTicks / 12
      if abs(sDest["x"] - sX) < 26 and abs(sDest["y"] - sY) < 26 then Hust.JobDone
   end if
   -- the paint shop
   if sHeat > 0 and abs(sShop["x"] - sX) < 30 and abs(sShop["y"] - sY) < 30 then
      put 0 into sHeat
      Hust.Patrols
      FX.Sparks sX, sY, kZ, 16, "200,80,255"
      Hust.Say "FRESH PAINT. HEAT CLEARED"
      Hust.MoveShop
   end if
   SetObjectRotation sShop["key"], 0, 0, -sTicks / 15
   if sHurt > 0 then subtract 1 from sHurt
   Hust.Chase
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Hust.ShowHUD
end Game.OnUpdate

on Hust.Say pText
   put pText into sMsg
   put 50 into sMsgT
end Hust.Say

on Hust.LeaveCar
   local tN
   put false into sInCar
   put the number of lines of the keys of sParked + 100 + sTicks into tN
   put sX into sParked[tN]["x"]
   put sY into sParked[tN]["y"]
   put sCarKey into sParked[tN]["key"]
   SetObjectPosition sMe, sX, sY, kZ
   Hust.Say "THE CAR IS SPENT. ON FOOT"
end Hust.LeaveCar

on Hust.StartJob
   put "fetch" into sJob
   get Hust.Spot(sX, sY)
   put item 1 of it into sPkg["x"]
   put item 2 of it into sPkg["y"]
   SetObjectPosition sPkg["key"], sPkg["x"], sPkg["y"], kZ - 6
   Hust.Say "JOB: FETCH THE ORANGE PACKAGE"
end Hust.StartJob

on Hust.JobDone
   local tOld
   put empty into sJob
   SetObjectPosition sDest["key"], 0, -900, kZ
   add 1 to sJobsDone
   add 300 * sLevel to sScore
   FX.Sparks sX, sY, kZ, 16, "255,255,0"
   Hust.AddHeat 1
   if sJobsDone >= sNeed then
      add sBonus to sScore
      if sLevel >= 5 then
         put true into sWon
         put true into sOver
      else
         Hust.StartLevel sLevel + 1
      end if
      exit Hust.JobDone
   end if
   put sRinging into tOld
   repeat while sRinging is tOld
      put random(3) into sRinging
   end repeat
   Hust.Say "JOB DONE. ANOTHER BOOTH IS RINGING"
end Hust.JobDone

on Hust.AddHeat pN
   put min(5, sHeat + pN) into sHeat
   Hust.Patrols
end Hust.AddHeat

-- patrols: none below heat 2, then heat - 1 of them
on Hust.Patrols
   local tWant, tHave, tK, tP, tN
   put max(0, sHeat - 1) into tWant
   put the number of lines of the keys of sPatrol into tHave
   repeat for each key tK in sPatrol
      if tHave <= tWant then exit repeat
      Entity.Kill sPatrol[tK]["key"]
      delete variable sPatrol[tK]
      subtract 1 from tHave
   end repeat
   repeat while tHave < tWant
      add 1 to tHave
      put sTicks * 10 + tHave into tN
      put Hust.Spot(sX, sY) into tP
      put item 1 of tP into sPatrol[tN]["x"]
      put item 2 of tP into sPatrol[tN]["y"]
      put 0 into sPatrol[tN]["dx"]
      put 0 into sPatrol[tN]["dy"]
      put Entity.Spawn("Hust.Patrol", sPatrol[tN]["x"], sPatrol[tN]["y"], kZ, "255,40,40") into sPatrol[tN]["key"]
   end repeat
end Hust.Patrols

-- each patrol heads for you along the streets
on Hust.Chase
   local tK, tV, tDX, tDY, tPX, tPY, tTried, tWay
   put sWalk * (0.75 + sHeat * 0.12) into tV
   repeat for each key tK in sPatrol
      put sPatrol[tK]["x"] into tPX
      put sPatrol[tK]["y"] into tPY
      put sX - tPX into tDX
      put sY - tPY into tDY
      -- try the longer way first, then the other, then keep going
      if abs(tDX) > abs(tDY) then
         put Hust.Sgn(tDX) & ",0;0," & Hust.Sgn(tDY) & ";" & sPatrol[tK]["dx"] & "," & sPatrol[tK]["dy"] into tWay
      else
         put "0," & Hust.Sgn(tDY) & ";" & Hust.Sgn(tDX) & ",0;" & sPatrol[tK]["dx"] & "," & sPatrol[tK]["dy"] into tWay
      end if
      put false into tTried
      set the itemDel to ";"
      repeat for each item tTried in tWay
         set the itemDel to comma
         if (item 1 of tTried is not 0 or item 2 of tTried is not 0) and not Hust.Solid(tPX + item 1 of tTried * tV, tPY + item 2 of tTried * tV, 12) then
            put tPX + item 1 of tTried * tV into sPatrol[tK]["x"]
            put tPY + item 2 of tTried * tV into sPatrol[tK]["y"]
            put item 1 of tTried into sPatrol[tK]["dx"]
            put item 2 of tTried into sPatrol[tK]["dy"]
            exit repeat
         end if
         set the itemDel to ";"
      end repeat
      set the itemDel to comma
      SetObjectPosition sPatrol[tK]["key"], sPatrol[tK]["x"], sPatrol[tK]["y"], kZ
      SetObjectRotation sPatrol[tK]["key"], 0, 0, atan2(sPatrol[tK]["dy"], sPatrol[tK]["dx"])
      if abs(sPatrol[tK]["x"] - sX) < 22 and abs(sPatrol[tK]["y"] - sY) < 22 and sHurt <= 0 then
         Hust.Caught
         exit repeat
      end if
   end repeat
end Hust.Chase

function Hust.Sgn pN
   if pN < -1 then return -1
   if pN > 1 then return 1
   return 0
end Hust.Sgn

on Hust.Caught
   subtract 1 from sLives
   put 60 into sHurt
   FX.Sparks sX, sY, kZ, 20, "255,40,40"
   put 0 into sHeat
   Hust.Patrols
   if sInCar then Hust.LeaveCar
   if sLives <= 0 then
      put true into sOver
   else
      Hust.Say "BUSTED! HEAT CLEARED, A LIFE GONE"
   end if
end Hust.Caught

on Hust.ShowHUD
   local tWords, tLine
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & sHeat & "|" & sJobsDone & "|" & sMsg & "|" & sJob & "|" & sInCar & (sCarT div 30) into tWords
   if tWords is sHUDWas then exit Hust.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Hust.Score", "SCORE" && sScore && " LIVES" && sLives && " LEVEL" && sLevel && " JOBS" && sJobsDone & "/" & sNeed && " HEAT" && sHeat & "/5", 20, 40, 14
   if sOver and sWon then
      put "KING OF BLOCK CITY!  SPACE TO HUSTLE AGAIN" into tLine
   else if sOver then
      put "LOCKED UP.  SPACE TO HUSTLE AGAIN" into tLine
   else if sMsg is not empty then
      put sMsg into tLine
   else if sJob is "fetch" then
      put "FETCH THE ORANGE PACKAGE" into tLine
   else if sJob is "drop" then
      put "DROP IT AT THE YELLOW MARK" into tLine
   else
      put "ANSWER THE RINGING BLUE BOOTH (SPACE)" into tLine
   end if
   if sInCar then put tLine && "  CAR" && sCarT div 30 into tLine
   HUD.Set "Hust.Msg", tLine, 20, 70, 12
end Hust.ShowHUD

function Hust.State
   return sLevel & "|" & sLives & "|" & sScore & "|at " & round(sX) & "," & round(sY) & "|job " & sJob & "|jobs " & sJobsDone & "/" & sNeed & "|heat " & sHeat & "|patrols " & the number of lines of the keys of sPatrol & "|car " & sInCar & "|" & sOver
end Hust.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
