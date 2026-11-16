######################################################################################
## CARD SCRIPT: "Play.TabletopRacers"   TABLETOP RACERS  (11 14 2026)
## Tiny toy cars race down a giant kitchen table, seen from above. Steer round crumbs,
## rolling pencils and juice spills, beat the magenta rivals to the far edge of the
## table, and don't drive off the side. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/945_Tabletop_Racers), script by Claude.
## CONTROLS  Left/Right (or A/D): steer    Space (or Up): accelerate    Down: brake
##           Escape: pause
## RULES     10 points for every stretch of table you cover. A crumb or a pencil costs
##           2 seconds, a juice spill 5. Off the side of the table: a life. Get a long
##           way ahead of a rival and it drops out. Reach the far edge before the clock
##           runs out (if it does: a life, and try the table again). 5 tables.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sCar, sX, sW, sAng, sSpeed, sTableLen, sSlice, sThing, sThingN, sRival, sTime, sSpin
local sLevel, sLives, sScore, sOver, sWon, sMul, sMsg, sMsgT, sPassed, sNextScore
local sKeysWas, sTestKeys, sHUDWas, sTicks

constant kZ = 340            -- screen scale 300/z
constant kCarY = 200         -- where your car sits on the screen
constant kHalfW = 330        -- half the table's width
constant kSliceGap = 80
constant kSlices = 11
constant kTop = 9

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Table.Build
   Table.StartLevel 1
end Game.OnStart

on Table.Build
   local i
   Mesh.Define "Table.Car", Table.CarMesh()
   Mesh.Define "Table.Crumb", MeshPyramid(5, 9, 10)
   Mesh.Define "Table.Pencil", Table.PencilMesh()
   Mesh.Define "Table.Spill", Table.BlobMesh()
   Mesh.Define "Table.Slice", Table.SliceMesh()
   Mesh.Define "Table.Edge", Table.FinishMesh()
   Mesh.Define "Table.Plate", Table.RingMesh(70)
   put empty into sSlice
   repeat with i = 0 to kSlices
      put Entity.Spawn("Table.Slice", 0, 0, kZ, "170,120,70") into sSlice[i]
   end repeat
   put Entity.Spawn("Table.Car", 0, kCarY, kZ, "0,230,255") into sCar
end Table.Build

-- a toy car: body, cab, four big wheels
function Table.CarMesh
   local tM
   put Mesh.New() into tM
   Table.AddBox tM, 0, 0, 0, 20, 38, 10
   Table.AddBox tM, 0, 3, -6, 14, 14, 6
   Table.AddBox tM, -13, -11, 3, 6, 10, 10
   Table.AddBox tM, 13, -11, 3, 6, 10, 10
   Table.AddBox tM, -13, 11, 3, 6, 10, 10
   Table.AddBox tM, 13, 11, 3, 6, 10, 10
   return tM
end Table.CarMesh

function Table.PencilMesh
   local tM
   put Mesh.New() into tM
   Table.AddBox tM, 0, 0, 0, 120, 10, 10
   Mesh.AddVertex tM, 60, -5, 0
   Mesh.AddVertex tM, 78, 0, 0
   Mesh.AddVertex tM, 60, 5, 0
   Mesh.AddLine tM, tM["count"] - 2, tM["count"] - 1
   Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   return tM
end Table.PencilMesh

-- a juice spill: a lumpy ring
function Table.BlobMesh
   local tM, i, tA, tR
   put Mesh.New() into tM
   repeat with i = 0 to 9
      put i * 3.14159 / 5 into tA
      put 34 + 10 * sin(i * 2.3) into tR
      Mesh.AddVertex tM, tR * 1.3 * cos(tA), tR * 0.8 * sin(tA), 0
   end repeat
   repeat with i = 1 to 10
      Mesh.AddLine tM, i, (i mod 10) + 1
   end repeat
   return tM
end Table.BlobMesh

function Table.RingMesh pR
   local tM, i, tA
   put Mesh.New() into tM
   repeat with i = 0 to 15
      put i * 3.14159 / 8 into tA
      Mesh.AddVertex tM, pR * cos(tA), pR * sin(tA), 0
      Mesh.AddVertex tM, pR * 0.7 * cos(tA), pR * 0.7 * sin(tA), 0
   end repeat
   repeat with i = 0 to 15
      Mesh.AddLine tM, i * 2 + 1, ((i + 1) mod 16) * 2 + 1
      Mesh.AddLine tM, i * 2 + 2, ((i + 1) mod 16) * 2 + 2
   end repeat
   return tM
end Table.RingMesh

-- a slice of table: the edges and some wood grain
function Table.SliceMesh
   local tM, i
   put Mesh.New() into tM
   repeat with i = -1 to 1 step 2
      Mesh.AddVertex tM, i * kHalfW, 0, 0
      Mesh.AddVertex tM, i * kHalfW, kSliceGap, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
      Mesh.AddVertex tM, i * (kHalfW + 30), 0, 40
      Mesh.AddVertex tM, i * (kHalfW + 30), kSliceGap, 40
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   repeat with i = 1 to 4
      Mesh.AddVertex tM, -kHalfW + i * 130 + (i mod 2) * 20, 10, 0
      Mesh.AddVertex tM, -kHalfW + i * 130 + (i mod 2) * 20 + 8, 70, 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Table.SliceMesh

-- the far edge of the table: a chequered strip
function Table.FinishMesh
   local tM, i
   put Mesh.New() into tM
   Mesh.AddVertex tM, -kHalfW, 0, 0
   Mesh.AddVertex tM, kHalfW, 0, 0
   Mesh.AddVertex tM, -kHalfW, -20, 0
   Mesh.AddVertex tM, kHalfW, -20, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 3, 4
   repeat with i = 0 to 10
      Mesh.AddVertex tM, -kHalfW + i * 2 * kHalfW / 11, -20 * (i mod 2), 0
      Mesh.AddVertex tM, -kHalfW + (i + 1) * 2 * kHalfW / 11, -20 * ((i + 1) mod 2), 0
      Mesh.AddLine tM, tM["count"] - 1, tM["count"]
   end repeat
   return tM
end Table.FinishMesh

on Table.AddBox @pM, pX, pY, pZ, pW, pH, pD
   local tB, i
   put pM["count"] into tB
   repeat with i = 0 to 7
      Mesh.AddVertex pM, pX + ((i mod 2) * 2 - 1) * pW / 2, pY + (((i div 2) mod 2) * 2 - 1) * pH / 2, pZ + ((i div 4) * 2 - 1) * pD / 2
   end repeat
   repeat for each item i in "1 2,3 4,5 6,7 8,1 3,2 4,5 7,6 8,1 5,2 6,3 7,4 8"
      Mesh.AddLine pM, tB + word 1 of i, tB + word 2 of i
   end repeat
end Table.AddBox

-- Spark's table: speed | rivals | lives
on Table.StartLevel pLevel
   local tRow, tK, i, tW, tN
   put pLevel into sLevel
   put line pLevel of ("1.0,1,3" & cr & "1.2,2,3" & cr & "1.4,3,2" & cr & "1.6,4,2" & cr & "1.8,5,1") into tRow
   put item 1 of tRow into sMul
   if sLives is empty or pLevel is 1 or sLives > item 3 of tRow then put item 3 of tRow into sLives
   put 6000 + pLevel * 1000 into sTableLen
   repeat for each key tK in sThing
      Entity.Kill sThing[tK]["key"]
   end repeat
   put empty into sThing
   put 0 into sThingN
   -- the table's clutter, laid out once
   put 500 into tW
   repeat while tW < sTableLen - 300
      put random(100) into tN
      if tN <= 50 then
         Table.Add "crumb", "Table.Crumb", random(2 * kHalfW - 60) - kHalfW + 30, tW, "255,230,80"
      else if tN <= 72 then
         Table.Add "pencil", "Table.Pencil", random(2 * kHalfW - 200) - kHalfW + 100, tW, "255,150,0"
         put (random(2) * 2 - 3) * (1 + sMul) into sThing[sThingN]["vx"]
      else if tN <= 90 then
         Table.Add "spill", "Table.Spill", random(2 * kHalfW - 100) - kHalfW + 50, tW, "255,40,60"
      else
         Table.Add "plate", "Table.Plate", (random(2) * 2 - 3) * (kHalfW - 90), tW, "220,220,240"
      end if
      add max(90, 260 - pLevel * 30) + random(140) to tW
   end repeat
   Table.Add "finish", "Table.Edge", 0, sTableLen, "255,255,255"
   -- the rivals
   repeat for each key tK in sRival
      Entity.Kill sRival[tK]["key"]
   end repeat
   put empty into sRival
   repeat with i = 1 to item 2 of tRow
      put -kHalfW + i * 2 * kHalfW / (item 2 of tRow + 2) into sRival[i]["x"]
      put 0 into sRival[i]["w"]
      put (3.2 + random(10) / 10) * (0.85 + sMul * 0.15) into sRival[i]["v"]
      put true into sRival[i]["in"]
      put Entity.Spawn("Table.Car", sRival[i]["x"], kCarY, kZ, "255,0,255") into sRival[i]["key"]
   end repeat
   put kHalfW * 0.85 * (item 2 of tRow + 1) / (item 2 of tRow + 2) - kHalfW * 0.85 into sX
   put 0 into sX
   put 0 into sW
   put 0 into sAng
   put 0 into sSpeed
   put 0 into sSpin
   put 1800 into sTime
   put 0 into sPassed
   put 100 into sNextScore
   put "TABLE" && pLevel & ": RACE TO THE FAR EDGE" into sMsg
   put 60 into sMsgT
   put empty into sHUDWas
end Table.StartLevel

on Table.Add pKind, pMesh, pX, pW, pColor
   add 1 to sThingN
   put pKind into sThing[sThingN]["kind"]
   put pX into sThing[sThingN]["x"]
   put pW into sThing[sThingN]["w"]
   put 0 into sThing[sThingN]["vx"]
   put false into sThing[sThingN]["used"]
   put Entity.Spawn(pMesh, pX, -900, kZ, pColor) into sThing[sThingN]["key"]
end Table.Add

function Table.ScreenY pW
   return kCarY - (pW - sW)
end Table.ScreenY

function Table.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Table.Keys

on Table.TestKeys pKeys
   put pKeys into sTestKeys
end Table.TestKeys

on Table.TestW pW
   put pW into sW
end Table.TestW

function Table.Down pCode, pKeys
   return pCode is among the items of pKeys
end Table.Down

on Game.OnUpdate
   local tKeys, tFrac, i, tWW, tT, tY, tK, tHit, tHalf
   put Table.Keys() into tKeys
   add 1 to sTicks
   if sOver then
      if Table.Down(32, tKeys) and not (32 is among the items of sKeysWas) then
         put 0 into sScore
         put false into sOver
         put false into sWon
         put empty into sLives
         Table.StartLevel 1
      end if
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   put tKeys into sKeysWas
   -- steering: the car turns, and goes where it points
   if sSpin > 0 then
      subtract 1 from sSpin
      add 0.5 to sAng
      put sSpeed * 0.9 into sSpeed
   else
      if Table.Down(65361, tKeys) or Table.Down(97, tKeys) then subtract 0.07 from sAng
      if Table.Down(65363, tKeys) or Table.Down(100, tKeys) then add 0.07 to sAng
      put max(-1.2, min(1.2, sAng)) into sAng
      if Table.Down(32, tKeys) or Table.Down(65362, tKeys) or Table.Down(119, tKeys) then
         put min(6 * (0.8 + sMul * 0.2), sSpeed + 0.25) into sSpeed
      else if Table.Down(65364, tKeys) or Table.Down(115, tKeys) then
         put max(0, sSpeed - 0.5) into sSpeed
      else
         put max(0, sSpeed - 0.08) into sSpeed
      end if
   end if
   add sSpeed * sin(sAng) to sX
   add sSpeed * cos(sAng) to sW
   if sSpin <= 0 then put sAng * 0.98 into sAng           -- toy cars straighten up
   SetObjectPosition sCar, sX, kCarY, kZ
   SetObjectRotation sCar, 0, 0, sAng
   -- off the side of the table
   if abs(sX) > kHalfW then
      FX.Sparks sX, kCarY, kZ, 18, "255,80,80"
      Table.LoseLife "OFF THE TABLE!"
      put 0 into sX
      put 0 into sAng
      put 0 into sSpeed
      if sOver then exit Game.OnUpdate
   end if
   if sW >= sNextScore then
      add 10 to sScore
      add 100 to sNextScore
   end if
   -- the table scrolls under you
   put sW mod kSliceGap into tFrac
   repeat with i = 0 to kSlices
      put sW - 160 + i * kSliceGap - tFrac into tWW
      SetObjectPosition sSlice[i], 0, Table.ScreenY(tWW) - kSliceGap, kZ
   end repeat
   -- clutter
   repeat for each key tT in sThing
      put Table.ScreenY(sThing[tT]["w"]) into tY
      if tY > 420 or tY < -460 then
         SetObjectPosition sThing[tT]["key"], 0, -900, kZ
         next repeat
      end if
      if sThing[tT]["kind"] is "pencil" then
         add sThing[tT]["vx"] to sThing[tT]["x"]
         if abs(sThing[tT]["x"]) > kHalfW - 70 then put -sThing[tT]["vx"] into sThing[tT]["vx"]
         SetObjectRotation sThing[tT]["key"], sTicks / 4 * Table.Sgn(sThing[tT]["vx"]), 0, 0
      end if
      SetObjectPosition sThing[tT]["key"], sThing[tT]["x"], tY, kZ + 2
      put false into tHit
      switch sThing[tT]["kind"]
         case "crumb"
            put abs(sThing[tT]["x"] - sX) < 18 and abs(sThing[tT]["w"] - sW) < 24 into tHit
            break
         case "pencil"
            put abs(sThing[tT]["x"] - sX) < 70 and abs(sThing[tT]["w"] - sW) < 22 into tHit
            break
         case "spill"
            put abs(sThing[tT]["x"] - sX) < 44 and abs(sThing[tT]["w"] - sW) < 34 into tHit
            break
         case "plate"
            put abs(sThing[tT]["x"] - sX) < 72 and abs(sThing[tT]["w"] - sW) < 72 into tHit
            break
         case "finish"
            if sW >= sThing[tT]["w"] then
               Table.Finish
               exit Game.OnUpdate
            end if
            break
      end switch
      if tHit and not sThing[tT]["used"] then
         put true into sThing[tT]["used"]
         switch sThing[tT]["kind"]
            case "spill"
               subtract 150 from sTime
               put 24 into sSpin
               Table.Say "JUICE! -5 SECONDS"
               break
            default
               subtract 60 from sTime
               put sSpeed * 0.3 into sSpeed
               subtract 30 from sW                   -- bounced back
               Table.Say "BUMP! -2 SECONDS"
         end switch
         FX.Sparks sX, kCarY - 20, kZ, 8, "255,200,80"
      end if
      if not tHit then put false into sThing[tT]["used"]
   end repeat
   -- rivals race on; lead one far enough and it drops out
   repeat for each key tK in sRival
      if not sRival[tK]["in"] then next repeat
      add sRival[tK]["v"] to sRival[tK]["w"]
      add 1.2 * sin(sTicks / 20 + tK) to sRival[tK]["x"]
      if sRival[tK]["w"] >= sTableLen then
         Table.LoseLife "A RIVAL GOT THERE FIRST"
         if not sOver then Table.StartLevel sLevel
         exit Game.OnUpdate
      end if
      if sW - sRival[tK]["w"] > 300 then
         put false into sRival[tK]["in"]
         add 100 to sScore
         Table.Say "A RIVAL DROPS OUT! +100"
         SetObjectPosition sRival[tK]["key"], 0, -900, kZ
         next repeat
      end if
      SetObjectPosition sRival[tK]["key"], sRival[tK]["x"], Table.ScreenY(sRival[tK]["w"]), kZ
   end repeat
   subtract 1 from sTime
   if sTime <= 0 then
      Table.LoseLife "OUT OF TIME"
      if not sOver then Table.StartLevel sLevel
      exit Game.OnUpdate
   end if
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   Table.ShowHUD
end Game.OnUpdate

function Table.Sgn pN
   if pN < 0 then return -1
   return 1
end Table.Sgn

on Table.Say pText
   put pText into sMsg
   put 40 into sMsgT
end Table.Say

on Table.LoseLife pWhy
   subtract 1 from sLives
   Table.Say pWhy
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Table.ShowHUD
   end if
end Table.LoseLife

on Table.Finish
   add 500 * sLevel + sTime div 30 * 10 to sScore
   if sLevel >= 5 then
      put true into sWon
      put true into sOver
      put empty into sHUDWas
      Table.ShowHUD
   else
      Table.StartLevel sLevel + 1
   end if
end Table.Finish

on Table.ShowHUD
   local tWords, tLine, tLeft, tK
   put 0 into tLeft
   repeat for each key tK in sRival
      if sRival[tK]["in"] then add 1 to tLeft
   end repeat
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver & "|" & sTime div 30 & "|" & sMsg & "|" & tLeft into tWords
   if tWords is sHUDWas then exit Table.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Table.Score", "SCORE" && sScore && " LIVES" && sLives && " TABLE" && sLevel & "/5  TIME" && max(0, sTime div 30) && " RIVALS" && tLeft, 20, 40, 14
   if sOver and sWon then
      put "TABLETOP CHAMPION!  SPACE TO RACE AGAIN" into tLine
   else if sOver then
      put "GAME OVER.  SPACE TO RACE AGAIN" into tLine
   else
      put sMsg into tLine
   end if
   HUD.Set "Table.Msg", tLine, 20, 70, 12
end Table.ShowHUD

function Table.State
   return sLevel & "|" & sLives & "|" & sScore & "|x " & round(sX) & "|w " & round(sW) & "/" & sTableLen & "|v " & round(sSpeed, 1) & "|time " & sTime & "|" & sOver
end Table.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey
