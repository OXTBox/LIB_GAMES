######################################################################################
## CARD SCRIPT: "Play.EagleDive"   EAGLE DIVE  (23 Nov 2026, first playable)
## You are an eagle over wire hills and lakes. Fish swim under the water and jump now and
## then. Fold your wings, dive, and skim the water through a fish to catch it. Diving
## makes you fast; pulling up and climbing cost speed. Catch enough before the sun sets.
## 3 levels: Blue Lake, Twin Ponds, The Bay (then round again, less time).
##
## CONTROLS  Left Right or A D: turn    Up or W: climb    Down or S: nose down
##           Space (hold): fold the wings and DIVE    let go: pull up
##           Space (after sunset): next place / try again    Escape: pause
## RULES     A fish is caught when your talons pass close to it: skim the water over it,
##           or dive on one that jumps. Touching the water slows you; the hills bump you.
##           Climbing is slow and costs speed; a dive gives it back. The sun sets after
##           two minutes: catch the place's number of fish to fly on.
## TUTORIAL  Read in sections; EagleDive/README.md says what each one teaches.
## TWO ENGINES  a game for Engine 1 (Vibecode3D, iGame3D XT) using only the engine
##           contract (LIB_ig3d/ENGINE_CONTRACT.md), so the xRay bench can play it too.
######################################################################################

global bPaused, bPlaying, gNoMouse

constant kM = 10            -- engine units a metre
constant kDT = 0.0333       -- seconds a step (30 a second)
constant kEdge = 200        -- metres from the middle to the edge of the land
constant kTile = 80         -- the land is 5 x 5 tiles of 80 m (one object each)
constant kCruise = 14       -- metres a second, flapping on the level
constant kMinV = 6
constant kMaxV = 34
constant kReach = 2.5       -- metres from the talons to a fish: caught
constant kSkim = 0.4        -- the lowest the eagle flies over the water
constant kRound = 120       -- seconds of daylight

local sLevel, sRound, sName, sLakes, sGoal, sState, sTicks, sTime
local sE, sFlap, sFish, sFishN, sFreeze
local sWater, sCamYaw, sScore, sCaught
local sKeysWas, sTestKeys, sMsg, sMsgT, sHUDWas

-------------------------------------------------------------------- 1. THE ENGINE CALLS US

on Game.OnStart
   focus on nothing
   Camera.Reset
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 0 into sRound
   put false into sFreeze
   ED.StartLevel 1
end Game.OnStart

-- a new place, through the loading screen when the player has one
on ED.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      ED.StartLevel pLevel
   end if
end ED.GoLevel

-- the loading screen starts its reveal at the eagle
function ED.Player
   return sE["key"]
end ED.Player

function ED.Score
   return sScore
end ED.Score

on Game.OnStop
   HUD.Clear
   Camera.Reset
end Game.OnStop

on arrowKey pKey
end arrowKey

-------------------------------------------------------------------- 2. THE PLACES

-- a place is: its name, its lakes (x,z,radius in metres, one a line), how many fish swim,
-- and how many to catch before sunset
on ED.StartLevel pLevel
   if pLevel > 3 then
      add 1 to sRound
      put 1 into pLevel
   end if
   put pLevel into sLevel
   Sound.Play "Warp"
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   switch pLevel
      case 1
         put "BLUE LAKE" into sName
         put "0,0,95" into sLakes
         ED.Setup 6, 4
         break
      case 2
         put "TWIN PONDS" into sName
         put "-75,-45,70" & cr & "80,65,65" into sLakes
         ED.Setup 7, 5
         break
      case 3
         put "THE BAY" into sName
         put "0,270,215" & cr & "-110,-95,50" into sLakes
         ED.Setup 8, 6
         break
   end switch
   put "fly" into sState
   put 0 into sTicks
   put 0 into sCaught
   put max(60, kRound - sRound * 20) into sTime
   put empty into sKeysWas
   put empty into sMsg
   put 0 into sMsgT
   ED.BuildLand
   ED.BuildWater
   ED.MakeEagle
   ED.MakeFish
   put sE["yaw"] into sCamYaw
   ED.DrawEagle
   ED.Camera
   put empty into sHUDWas
   ED.Say "CATCH" && sGoal && "FISH BEFORE SUNSET. HOLD SPACE TO DIVE", 5
   ED.ShowHUD
end ED.StartLevel

on ED.Setup pFish, pGoal
   put pFish into sFishN
   put pGoal into sGoal
end ED.Setup

-------------------------------------------------------------------- 3. THE LAND: a height function

-- the height of the ground (metres, y up) anywhere: a few waves over each other, then every
-- lake digs a bowl. The water is at height 0, so a lake is wherever this goes below 0.
function ED.H pX, pZ
   local tH, tLine, tD
   put 7 + 4 * sin(pX * 0.021 + 1) * cos(pZ * 0.017) + 2.5 * sin((pX - pZ) * 0.013 + 2) + 1.2 * sin(pX * 0.05) * sin(pZ * 0.043) into tH
   repeat for each line tLine in sLakes
      put sqrt((pX - item 1 of tLine) ^ 2 + (pZ - item 2 of tLine) ^ 2) / item 3 of tLine into tD
      -- at the lake's middle 4 m deep, rising (as d^4) to the hills at its rim
      if tD < 1 then put -4 + (tH + 4) * tD ^ 4 into tH
   end repeat
   return tH
end ED.H

-- the land as 25 tiles, each ONE object: the engine pays for every object each frame
-- (about 0.15 ms), and skips the tiles out of view. Each tile is a 5 x 5 net of points
-- 20 m apart bent over the hills, joined by lines; a line under water is left out. The
-- lines SHARE their points (the engine turns each point once a frame, however many lines
-- meet there): half the work of loose lines. Two pines a tile to fly past.
on ED.BuildLand
   local tTX, tTZ, tM, i, j, x0, z0, tX, tZ, tH, tCX, tCZ, tAt, tI, tJ
   repeat with tTX = 0 to 4
      repeat with tTZ = 0 to 4
         put -kEdge + tTX * kTile into x0
         put -kEdge + tTZ * kTile into z0
         put x0 + kTile / 2 into tCX
         put z0 + kTile / 2 into tCZ
         put ED.Mesh() into tM
         put empty into tAt
         repeat with i = 0 to 4
            repeat with j = 0 to 4
               put ED.H(x0 + i * 20, z0 + j * 20) into tH[i][j]
            end repeat
         end repeat
         repeat with i = 0 to 4
            repeat with j = 0 to 4
               -- along x (the far tile in x closes the edge), and along z
               if i < 4 and (j < 4 or tTZ is 4) and (tH[i][j] > 0 or tH[i + 1][j] > 0) then
                  ED.Join tM, tAt, tH, x0, z0, tCX, tCZ, i, j, i + 1, j
               end if
               if j < 4 and (i < 4 or tTX is 4) and (tH[i][j] > 0 or tH[i][j + 1] > 0) then
                  ED.Join tM, tAt, tH, x0, z0, tCX, tCZ, i, j, i, j + 1
               end if
            end repeat
         end repeat
         repeat with i = 1 to 2
            put x0 + ((i * 31 + tTX * 17 + tTZ * 7) mod 70) + 5 into tX
            put z0 + ((i * 23 + tTZ * 13 + tTX * 11) mod 70) + 5 into tZ
            put ED.H(tX, tZ) into tI
            if tI > 1.5 then ED.Pine tM, tX - tCX, tI, tZ - tCZ
         end repeat
         if tM["count"] is 0 then next repeat
         Mesh.Define "ED.Land." & tTX & "." & tTZ, tM
         get Entity.Spawn("ED.Land." & tTX & "." & tTZ, tCX * kM, 0, tCZ * kM, "#2E8A46")
      end repeat
   end repeat
end ED.BuildLand

-- a line between two points of the net, each point made once (pAt remembers its number)
on ED.Join @pM, @pAt, @pH, pX0, pZ0, pCX, pCZ, pI1, pJ1, pI2, pJ2
   local tA, tB
   put ED.NetPoint(pM, pAt, pH, pX0, pZ0, pCX, pCZ, pI1, pJ1) into tA
   put ED.NetPoint(pM, pAt, pH, pX0, pZ0, pCX, pCZ, pI2, pJ2) into tB
   if pM["lines"] is empty then
      put tA && tB into pM["lines"]
   else
      put cr & tA && tB after pM["lines"]
   end if
end ED.Join

function ED.NetPoint @pM, @pAt, @pH, pX0, pZ0, pCX, pCZ, pCol, pRow
   if pAt[pCol][pRow] is not empty then return pAt[pCol][pRow]
   add 1 to pM["count"]
   put (pX0 + pCol * 20 - pCX) * kM into pM["vx"][pM["count"]]
   put -max(0, pH[pCol][pRow]) * kM into pM["vy"][pM["count"]]
   put (pZ0 + pRow * 20 - pCZ) * kM into pM["vz"][pM["count"]]
   put pM["count"] into pAt[pCol][pRow]
   return pM["count"]
end ED.NetPoint

on ED.Pine @pM, pX, pY, pZ
   local tB, k
   put pM["count"] into tB
   ED.Point pM, pX, pY + 7, pZ
   ED.Point pM, pX, pY, pZ
   ED.Point pM, pX - 1.6, pY + 2, pZ
   ED.Point pM, pX + 1.6, pY + 2, pZ
   ED.Point pM, pX, pY + 2, pZ - 1.6
   ED.Point pM, pX, pY + 2, pZ + 1.6
   -- the trunk and four branches, all from the top point
   repeat with k = 2 to 6
      if pM["lines"] is not empty then put cr after pM["lines"]
      put tB + 1 && tB + k after pM["lines"]
   end repeat
end ED.Pine

-------------------------------------------------------------------- 4. THE WATER

-- every lake as short dashes on the level 0 (one object for all the water, it drifts a
-- little each step), and a sandy shore line where the land meets it (one more object)
on ED.BuildWater
   local tLine, tM, tS, tX, tZ, tR, x1, x2, z1, z2, tRow, a, d, tPrev, tAt, tN
   put ED.Mesh() into tM
   put ED.Mesh() into tS
   repeat for each line tLine in sLakes
      put item 3 of tLine into tR
      put max(-kEdge + 4, item 1 of tLine - tR) into x1
      put min(kEdge - 4, item 1 of tLine + tR) into x2
      put max(-kEdge + 4, item 2 of tLine - tR) into z1
      put min(kEdge - 4, item 2 of tLine + tR) into z2
      put 0 into tRow
      repeat with tZ = z1 to z2 step 11
         add 1 to tRow
         repeat with tX = x1 + (tRow mod 2) * 6 to x2 step 13
            if ED.H(tX, tZ) < -0.4 then ED.Line tM, tX - 2.5, 0, tZ, tX + 2.5, 0, tZ
         end repeat
      end repeat
      -- the shore: walk out from the middle along 40 rays to where the land comes up
      put empty into tPrev
      repeat with a = 0 to 40
         put empty into tAt
         repeat with d = 0.5 to 1 step 0.02
            put item 1 of tLine + sin(a * 2 * pi / 40) * d * tR into tX
            put item 2 of tLine + cos(a * 2 * pi / 40) * d * tR into tZ
            if ED.H(tX, tZ) >= 0 then
               if abs(tX) <= kEdge and abs(tZ) <= kEdge then put tX & comma & tZ into tAt
               exit repeat
            end if
         end repeat
         if tAt is not empty and tPrev is not empty then ED.Line tS, item 1 of tPrev, 0.05, item 2 of tPrev, item 1 of tAt, 0.05, item 2 of tAt
         put tAt into tPrev
      end repeat
   end repeat
   put empty into sWater
   if tM["count"] > 0 then
      Mesh.Define "ED.Water", tM
      put Entity.Spawn("ED.Water", 0, 0, 0, "#3478FF") into sWater
   end if
   if tS["count"] > 0 then
      Mesh.Define "ED.Shore", tS
      get Entity.Spawn("ED.Shore", 0, 0, 0, "#C8B478")
   end if
end ED.BuildWater

-- true when the point is over water
function ED.Wet pX, pZ
   return ED.H(pX, pZ) < 0
end ED.Wet

-------------------------------------------------------------------- 5. THE EAGLE

-- the eagle is an array: x, y (up), z in metres, yaw (0 = along +z, right is +), pitch
-- (+ = nose up), bank (+ = right wing down), speed in metres a second
on ED.MakeEagle
   local tLine, tM
   put line 1 of sLakes into tLine
   -- start at the near side of the first lake, looking across it
   put item 1 of tLine into sE["x"]
   put max(-kEdge + 30, item 2 of tLine - item 3 of tLine - 20) into sE["z"]
   put max(22, ED.H(sE["x"], sE["z"]) + 14) into sE["y"]
   put 0 into sE["yaw"]
   put 0 into sE["pitch"]
   put 0 into sE["bank"]
   put kCruise into sE["v"]
   put false into sE["dive"]
   put 0 into sFlap
   put ED.Mesh() into tM
   ED.Line tM, 0, 0, -1, 0, 0, 1
   Mesh.Define "ED.Eagle", tM
   put Entity.Spawn("ED.Eagle", sE["x"] * kM, -sE["y"] * kM, sE["z"] * kM, "#F2E2BC") into sE["key"]
end ED.MakeEagle

-- one step of flight: keys set where the nose wants to go, then gravity and the wings
on ED.Fly pKeys
   local tTurn, tGoal, tWas, tA, tFwd, tH, tDist, tBack, tWasDive
   -- turning, with a bank to show it
   put 0 into tTurn
   if ED.Down(65361, pKeys) or ED.Down(97, pKeys) then subtract 1 from tTurn
   if ED.Down(65363, pKeys) or ED.Down(100, pKeys) then add 1 to tTurn
   -- near the edge of the land the wind turns you back toward the middle
   put sqrt(sE["x"] ^ 2 + sE["z"] ^ 2) into tDist
   if abs(sE["x"]) > kEdge - 20 or abs(sE["z"]) > kEdge - 20 then
      put ED.AngleTo(-sE["x"], -sE["z"]) - sE["yaw"] into tBack
      put atan2(sin(tBack), cos(tBack)) into tBack
      if abs(tBack) > 0.2 then put max(-1, min(1, tBack)) into tTurn
      if tDist > 0 and sMsgT is 0 then ED.Say "THE WIND TURNS YOU BACK", 1
   end if
   add tTurn * 1.15 * kDT to sE["yaw"]
   add (tTurn * 0.55 - sE["bank"]) * 0.12 to sE["bank"]
   -- the nose: Space dives, Up climbs, Down noses down, nothing glides level
   put sE["dive"] into tWasDive
   put ED.Down(32, pKeys) into sE["dive"]
   if sE["dive"] and not tWasDive and sState is "fly" then Sound.Play "Jump"
   put 0 into tGoal
   if ED.Down(65362, pKeys) or ED.Down(119, pKeys) then put 0.42 into tGoal
   if ED.Down(65364, pKeys) or ED.Down(115, pKeys) then put -0.42 into tGoal
   if sE["dive"] then put -1.05 into tGoal
   put sE["pitch"] into tWas
   if tGoal > sE["pitch"] then
      put min(tGoal, sE["pitch"] + 1.5 * kDT) into sE["pitch"]
   else
      put max(tGoal, sE["pitch"] - 1.8 * kDT) into sE["pitch"]
   end if
   -- speed: gravity along the path, the wings pull back toward cruising speed (not in a
   -- dive), and pulling the nose up costs speed (the dive's speed turns into height)
   put -9.8 * sin(sE["pitch"]) * 0.7 into tA
   -- wings folded, the eagle drops like a stone
   if sE["dive"] and sE["pitch"] < -0.3 then add 6 to tA
   if not sE["dive"] then
      if sE["v"] < kCruise then
         add (kCruise - sE["v"]) * 0.25 to tA
      else
         add (kCruise - sE["v"]) * 0.05 to tA
      end if
   end if
   add tA * kDT to sE["v"]
   if sE["pitch"] > tWas then subtract (sE["pitch"] - tWas) * sE["v"] * 0.3 from sE["v"]
   put max(kMinV, min(kMaxV, sE["v"])) into sE["v"]
   -- move
   put cos(sE["pitch"]) * sE["v"] * kDT into tFwd
   add sin(sE["yaw"]) * tFwd to sE["x"]
   add cos(sE["yaw"]) * tFwd to sE["z"]
   add sin(sE["pitch"]) * sE["v"] * kDT to sE["y"]
   put min(70, sE["y"]) into sE["y"]
   -- the ground and the water
   put ED.H(sE["x"], sE["z"]) into tH
   if tH < 0 then
      if sE["y"] < kSkim then
         if sE["pitch"] < -0.3 then
            -- a splash: the dive ends in the water
            FX.Sparks sE["x"] * kM, 0, sE["z"] * kM, 10, "#A0D0FF"
            Sound.Play "Thud"
            put sE["v"] * 0.85 into sE["v"]
         else
            put sE["v"] - 0.15 into sE["v"]  -- wet feet slow you
         end if
         put kSkim into sE["y"]
         put max(sE["pitch"], 0) into sE["pitch"]
         put max(kMinV, sE["v"]) into sE["v"]
      end if
   else if sE["y"] < tH + 1 then
      put tH + 1 into sE["y"]
      put max(sE["pitch"], 0.2) into sE["pitch"]
      put max(kMinV, sE["v"] * 0.92) into sE["v"]
      if sMsgT is 0 then ED.Say "TOO LOW!", 1
   end if
end ED.Fly

-- the angle to fly to go along dx, dz
function ED.AngleTo pDX, pDZ
   return atan2(pDX, pDZ)
end ED.AngleTo

-- the eagle is drawn as a few lines worked out every step: the wings beat (slow when
-- gliding, quick when climbing, folded in a dive), then the whole bird is turned by its
-- bank, pitch and yaw. One small mesh made again each step costs less than a turned object
-- would (the engine turns an object about the world's x axis, not the bird's own).
on ED.DrawEagle
   local tP, tF, tAmp, tTip, tM, k, tL, tCB, tSB, tCP, tSP, tCY, tSY, x, y, z, x1, y1, x2
   if sE["dive"] then
      put 0 into tAmp
   else if sE["pitch"] > 0.1 then
      add 0.42 to sFlap
      put 0.75 into tAmp
   else if sE["pitch"] < -0.15 then
      put 0.12 into tAmp
   else
      add 0.24 to sFlap
      put 0.45 into tAmp
   end if
   put sin(sFlap) * tAmp into tF
   -- points in the bird's own frame (metres, y up, nose along +z)
   put "0,0,1.1|0,0.05,0.75|0,0,-0.9|-0.45,0,-1.45|0.45,0,-1.45|0,0,-1.5" into tP
   if sE["dive"] then
      -- folded: the wings swept back along the body
      put "|-0.25,0.1,0.3|-0.7,0.25,-0.6|-0.9,0.3,-1.3|0.25,0.1,0.3|0.7,0.25,-0.6|0.9,0.3,-1.3" after tP
   else
      put "|-0.2,0,0.35|-1.1," & tF * 0.6 & ",0.15|-2.1," & tF * 1.4 & ",-0.35|0.2,0,0.35|1.1," & tF * 0.6 & ",0.15|2.1," & tF * 1.4 & ",-0.35" after tP
   end if
   -- lines: beak to head, head to tail, tail fan; each wing: shoulder, elbow, tip, back
   put "1 2,2 3,3 4,4 6,6 5,5 3,7 8,8 9,9 3,8 3,10 11,11 12,12 3,11 3" into tL
   put cos(sE["bank"]) into tCB
   put sin(sE["bank"]) into tSB
   put cos(sE["pitch"]) into tCP
   put sin(sE["pitch"]) into tSP
   put cos(sE["yaw"]) into tCY
   put sin(sE["yaw"]) into tSY
   put ED.Mesh() into tM
   replace "|" with cr in tP
   repeat for each line tF in tP
      put item 1 of tF * 1.2 into x
      put item 2 of tF * 1.2 into y
      put item 3 of tF * 1.2 into z
      -- bank (about the body), pitch (about the wings), yaw (about the up line)
      put x * tCB + y * tSB into x1
      put -x * tSB + y * tCB into y1
      put y1 * tCP + z * tSP into y
      put -y1 * tSP + z * tCP into z
      put x1 * tCY + z * tSY into x2
      put -x1 * tSY + z * tCY into z
      add 1 to tM["count"]
      put x2 * kM into tM["vx"][tM["count"]]
      put -y * kM into tM["vy"][tM["count"]]
      put z * kM into tM["vz"][tM["count"]]
   end repeat
   repeat for each item k in tL
      if tM["lines"] is empty then
         put k into tM["lines"]
      else
         put cr & k after tM["lines"]
      end if
   end repeat
   Mesh.Define "ED.Eagle", tM
   Entity.SetPosition sE["key"], sE["x"] * kM, -sE["y"] * kM, sE["z"] * kM
end ED.DrawEagle

-------------------------------------------------------------------- 6. THE FISH

-- a fish: a diamond and a tail. Each swims under the water (0.8 m down, still seen through
-- the wire water) and now and then jumps out in an arc: that is when a dive is easiest.
on ED.MakeFish
   local tM, i
   put ED.Mesh() into tM
   ED.Line tM, 0, 0, 0.8, -0.25, 0, 0
   ED.Line tM, -0.25, 0, 0, 0, 0, -0.65
   ED.Line tM, 0, 0, -0.65, 0.25, 0, 0
   ED.Line tM, 0.25, 0, 0, 0, 0, 0.8
   ED.Line tM, 0, 0, -0.65, -0.35, 0, -1.05
   ED.Line tM, 0, 0, -0.65, 0.35, 0, -1.05
   ED.Line tM, -0.35, 0, -1.05, 0.35, 0, -1.05
   ED.Line tM, 0, 0.2, 0.2, 0, 0, 0.8
   ED.Line tM, 0, 0.2, 0.2, 0, 0, -0.65
   Mesh.Define "ED.Fish", tM
   put empty into sFish
   repeat with i = 1 to sFishN
      ED.NewFish i
   end repeat
end ED.MakeFish

on ED.NewFish i
   local tAt
   put ED.FishPlace() into tAt
   put item 1 of tAt into sFish[i]["x"]
   put item 2 of tAt into sFish[i]["z"]
   put -0.8 into sFish[i]["y"]
   put random(628) / 100 into sFish[i]["yaw"]
   put 0 into sFish[i]["jump"]
   put 60 + random(150) into sFish[i]["wait"]
   put Entity.Spawn("ED.Fish", sFish[i]["x"] * kM, -sFish[i]["y"] * kM, sFish[i]["z"] * kM, "#FFB060") into sFish[i]["key"]
   Entity.SetRotation sFish[i]["key"], 0, sFish[i]["yaw"], 0
end ED.NewFish

-- somewhere in a lake at least 1.5 m deep, inside the land
function ED.FishPlace
   local tLine, k, tA, tD, tX, tZ
   repeat with k = 1 to 60
      put line random(the number of lines of sLakes) of sLakes into tLine
      put random(628) / 100 into tA
      put random(70) / 100 * item 3 of tLine into tD
      put item 1 of tLine + sin(tA) * tD into tX
      put item 2 of tLine + cos(tA) * tD into tZ
      if abs(tX) < kEdge - 25 and abs(tZ) < kEdge - 25 and ED.H(tX, tZ) < -1.5 then return tX & comma & tZ
   end repeat
   return item 1 of line 1 of sLakes & comma & item 2 of line 1 of sLakes
end ED.FishPlace

on ED.SwimFish
   local i, tNX, tNZ, tT
   repeat with i = 1 to sFishN
      if sFish[i]["key"] is empty then
         -- caught: a new one comes after a while
         subtract 1 from sFish[i]["wait"]
         if sFish[i]["wait"] <= 0 then ED.NewFish i
         next repeat
      end if
      if sFreeze then next repeat
      add (random(41) - 21) / 400 to sFish[i]["yaw"]
      put sFish[i]["x"] + sin(sFish[i]["yaw"]) * 1.3 * kDT into tNX
      put sFish[i]["z"] + cos(sFish[i]["yaw"]) * 1.3 * kDT into tNZ
      if ED.H(tNX, tNZ) > -1.2 or abs(tNX) > kEdge - 25 or abs(tNZ) > kEdge - 25 then
         add pi to sFish[i]["yaw"]
      else
         put tNX into sFish[i]["x"]
         put tNZ into sFish[i]["z"]
      end if
      -- the jump: 1.4 s up and down again, with a splash going out and coming in
      if sFish[i]["jump"] > 0 then
         add 1 to sFish[i]["jump"]
         put sFish[i]["jump"] / 42 into tT
         if tT >= 1 then
            put 0 into sFish[i]["jump"]
            put -0.8 into sFish[i]["y"]
            put 90 + random(180) into sFish[i]["wait"]
            FX.Sparks sFish[i]["x"] * kM, 0, sFish[i]["z"] * kM, 5, "#A0D0FF"
         else
            put -0.8 + 3.6 * sin(pi * tT) into sFish[i]["y"]
         end if
      else
         subtract 1 from sFish[i]["wait"]
         if sFish[i]["wait"] <= 0 then
            put 1 into sFish[i]["jump"]
            FX.Sparks sFish[i]["x"] * kM, 0, sFish[i]["z"] * kM, 5, "#A0D0FF"
         end if
      end if
      Entity.SetPosition sFish[i]["key"], sFish[i]["x"] * kM, -sFish[i]["y"] * kM, sFish[i]["z"] * kM
      Entity.SetRotation sFish[i]["key"], 0, sFish[i]["yaw"], 0
   end repeat
end ED.SwimFish

-- the talons hang half a metre under the eagle; close enough to a fish near the top: caught
on ED.Talons
   local i, tTX, tTY, tTZ
   put sE["x"] into tTX
   put sE["y"] - 0.5 into tTY
   put sE["z"] into tTZ
   if tTY > 4 then exit ED.Talons
   repeat with i = 1 to sFishN
      if sFish[i]["key"] is empty then next repeat
      if sFish[i]["y"] < -1.2 then next repeat
      if (sFish[i]["x"] - tTX) ^ 2 + (sFish[i]["y"] - tTY) ^ 2 + (sFish[i]["z"] - tTZ) ^ 2 < kReach ^ 2 then
         FX.Sparks sFish[i]["x"] * kM, -sFish[i]["y"] * kM, sFish[i]["z"] * kM, 14, "#FFE080"
         Entity.Kill sFish[i]["key"]
         put empty into sFish[i]["key"]
         put 90 into sFish[i]["wait"]
         add 1 to sCaught
         add 1 to sScore
         if sE["v"] > 20 then
            Sound.Play "Powerup"
         else
            Sound.Play "Pickup"
         end if
         if sE["v"] > 20 then
            ED.Say "A DIVING CATCH!  FISH" && sCaught, 2
         else
            ED.Say "GOT ONE!  FISH" && sCaught, 2
         end if
      end if
   end repeat
end ED.Talons

-------------------------------------------------------------------- 7. EACH STEP

on Game.OnUpdate
   local tKeys
   put ED.Keys() into tKeys
   add 1 to sTicks
   if sState is "fly" then
      ED.Fly tKeys
      ED.SwimFish
      ED.Talons
      subtract kDT from sTime
      if sTime <= 0 then
         ED.Sunset
      end if
   else if ED.Pressed(32, tKeys) then
      -- after sunset Space flies on (or tries again)
      put tKeys into sKeysWas
      if sCaught >= sGoal then
         ED.GoLevel sLevel + 1
      else
         ED.GoLevel sLevel
      end if
      exit Game.OnUpdate
   else
      -- gliding home at dusk
      ED.Fly empty
   end if
   put tKeys into sKeysWas
   ED.DrawEagle
   if sWater is not empty and sTicks mod 3 is 0 then Entity.SetPosition sWater, sin(sTicks * 0.02) * 8, 0, cos(sTicks * 0.015) * 6
   ED.Camera
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then put empty into sMsg
   end if
   ED.ShowHUD
end Game.OnUpdate

on ED.Sunset
   put 0 into sTime
   put "dusk" into sState
   if sCaught >= sGoal then
      Sound.Play "Win"
      ED.Say "SUNSET. WELL FISHED:" && sCaught && "FISH!  SPACE: FLY ON", 999
   else
      Sound.Play "Lose"
      ED.Say "SUNSET." && sCaught && "OF" && sGoal && "FISH.  SPACE: TRY AGAIN", 999
   end if
end ED.Sunset

-------------------------------------------------------------------- 8. THE CAMERA AND THE HUD

-- behind and a little above the eagle; its turn follows the eagle's a little late, so a
-- turn shows the bird from the side for a moment
on ED.Camera
   local tCX, tCY, tCZ, tTX, tTY, tTZ, tDX, tDY, tDZ, tD
   put atan2(sin(sE["yaw"] - sCamYaw), cos(sE["yaw"] - sCamYaw)) into tD
   add tD * 0.1 to sCamYaw
   put sE["x"] - sin(sCamYaw) * 11 into tCX
   put sE["z"] - cos(sCamYaw) * 11 into tCZ
   put sE["y"] + 3.2 into tCY
   put max(tCY, ED.H(tCX, tCZ) + 1.5) into tCY
   put max(tCY, 1) into tCY
   put sE["x"] + sin(sE["yaw"]) * 6 into tTX
   put sE["z"] + cos(sE["yaw"]) * 6 into tTZ
   put sE["y"] + 6 * sin(sE["pitch"]) * 0.6 into tTY
   put tTX - tCX into tDX
   put tTY - tCY into tDY
   put tTZ - tCZ into tDZ
   Camera.SetPosition tCX * kM, -tCY * kM, tCZ * kM
   Camera.SetLook atan2(tDX, tDZ), atan2(tDY, sqrt(tDX ^ 2 + tDZ ^ 2))
end ED.Camera

on ED.Say pText, pSeconds
   put pText into sMsg
   put round(pSeconds * 30) into sMsgT
end ED.Say

-- the HUD is drawn again only when its words change (the clock in whole seconds)
on ED.ShowHUD
   local tTop, tSec
   put max(0, ceiling(sTime)) into tSec
   put sName & "   FISH" && sCaught & "/" & sGoal & "   SUN" && tSec div 60 & ":" & char -2 to -1 of ("0" & tSec mod 60) & "   SCORE" && sScore into tTop
   if sMsg is not empty then
      put tTop & "|" & sMsg into tTop
   else
      put tTop & "|" & "ARROWS OR WASD: FLY   HOLD SPACE: DIVE   SKIM A FISH TO CATCH IT" into tTop
   end if
   put "|" & round(sE["v"]) & "|" & max(0, round(sE["y"])) after tTop
   if tTop is sHUDWas then exit ED.ShowHUD
   put tTop into sHUDWas
   set the itemDelimiter to "|"
   HUD.Set "ED.Top", item 1 of tTop, 20, 30, 14
   HUD.Set "ED.Msg", item 2 of tTop, 20, 54, 12
   HUD.Set "ED.Fly", "SPEED" && item 3 of tTop & "   HEIGHT" && item 4 of tTop, 20, 76, 11
   set the itemDelimiter to comma
end ED.ShowHUD

-------------------------------------------------------------------- 9. KEYS AND TEST HOOKS

function ED.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end ED.Keys

function ED.Down pCode, pKeys
   return pCode is among the items of pKeys
end ED.Down

function ED.Pressed pCode, pKeys
   return pCode is among the items of pKeys and pCode is not among the items of sKeysWas
end ED.Pressed

-- "0" = no keys held (empty = the real keyboard)
on ED.TestKeys pKeys
   put pKeys into sTestKeys
end ED.TestKeys

-- the fish stop swimming and jumping (a test places them)
on ED.TestFreeze pFlag
   put pFlag into sFreeze
end ED.TestFreeze

-- put the eagle somewhere, level, at cruising speed
on ED.TestPlace pX, pY, pZ, pYaw
   put pX into sE["x"]
   put pY into sE["y"]
   put pZ into sE["z"]
   put pYaw into sE["yaw"]
   put pYaw into sCamYaw
   put 0 into sE["pitch"]
   put 0 into sE["bank"]
   put kCruise into sE["v"]
   put false into sE["dive"]
end ED.TestPlace

-- put fish i at x, z (metres), y up (-0.8 = swimming), not jumping
on ED.TestFish i, pX, pZ, pY
   if sFish[i]["key"] is empty then ED.NewFish i
   put pX into sFish[i]["x"]
   put pZ into sFish[i]["z"]
   if pY is not a number then put -0.8 into pY
   put pY into sFish[i]["y"]
   put 0 into sFish[i]["jump"]
   put 999 into sFish[i]["wait"]
   Entity.SetPosition sFish[i]["key"], pX * kM, -pY * kM, pZ * kM
end ED.TestFish

-- every fish but i far away (out of reach) and still
on ED.TestFishAway i
   local k
   repeat with k = 1 to sFishN
      if k is i or sFish[k]["key"] is empty then next repeat
      ED.TestFish k, -kEdge + 5, -kEdge + 5 + k, -0.8
   end repeat
end ED.TestFishAway

-- a place again (empty: this one), as a test starts it: no loading screen
on ED.TestLevel pLevel
   if pLevel is not a number then put sLevel into pLevel
   ED.StartLevel pLevel
end ED.TestLevel

-- how many caught this round
on ED.TestSet pCaught
   put pCaught into sCaught
end ED.TestSet

on ED.TestTime pSeconds
   put pSeconds into sTime
end ED.TestTime

-- level|state|caught|goal|score|fish alive|time left
function ED.State
   local i, tN
   put 0 into tN
   repeat with i = 1 to sFishN
      if sFish[i]["key"] is not empty then add 1 to tN
   end repeat
   return sLevel & "|" & sState & "|" & sCaught & "|" & sGoal & "|" & sScore & "|" & tN & "|" & round(sTime, 1)
end ED.State

-- x,y,z,yaw,pitch,speed of the eagle
function ED.Eagle
   return round(sE["x"], 2) & comma & round(sE["y"], 2) & comma & round(sE["z"], 2) & comma & round(sE["yaw"], 3) & comma & round(sE["pitch"], 3) & comma & round(sE["v"], 2)
end ED.Eagle

function ED.Height pX, pZ
   return ED.H(pX, pZ)
end ED.Height

function ED.Lakes
   return sLakes
end ED.Lakes

-------------------------------------------------------------------- 10. A LITTLE WIRE

function ED.Mesh
   local tM
   put 0 into tM["count"]
   put empty into tM["faces"]
   put empty into tM["lines"]
   return tM
end ED.Mesh

-- one point in metres (y up) into a mesh in engine units (y down)
on ED.Point @pM, pX, pY, pZ
   add 1 to pM["count"]
   put pX * kM into pM["vx"][pM["count"]]
   put -pY * kM into pM["vy"][pM["count"]]
   put pZ * kM into pM["vz"][pM["count"]]
end ED.Point

-- a line in metres (y up) into a mesh in engine units (y down)
on ED.Line @pM, pX1, pY1, pZ1, pX2, pY2, pZ2
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
end ED.Line
