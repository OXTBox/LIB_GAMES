######################################################################################
## CARD SCRIPT: "Play.RockField"   ROCK FIELD  (11 13 2026)
## A ship among drifting rocks. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/06_Rock_Field), script corrected by Claude.
## CONTROLS  Left/Right arrows: turn    Up: thrust    Space: fire    Escape: pause
## RULES     a shot splits a big rock into small ones; small ones vanish. Everything
##           that leaves one edge comes back on the other. A rock on the ship costs a
##           life; three lives. Clear the field to move on. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sShip, sX, sY, sVX, sVY, sA, sSafe, sFireWas
local sRock, sRockN, sShot, sShotN, sLevel, sLives, sScore, sSplit, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kTop = -300
constant kBottom = 300
constant kTurn = 0.11
constant kThrust = 0.35
constant kShotSpeed = 14

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   Rock.StartLevel 1
end Game.OnStart

-- Spark's table: big rocks | rock speed | small rocks per split
on Rock.StartLevel pLevel
   local tRow, tN, tA
   put pLevel into sLevel
   put line pLevel of ("3,1.5,2" & cr & "4,1.9,2" & cr & "5,2.3,2" & cr & "5,2.7,3" & cr & "6,3.2,3") into tRow
   put item 3 of tRow into sSplit
   Scene.ClearAll
   Mesh.Define "Rock.Ship", MeshPyramid(3, 14, 30)
   Mesh.Define "Rock.Big", MeshPrism(7, 40, 20)
   Mesh.Define "Rock.Small", MeshPrism(5, 18, 14)
   Mesh.Define "Rock.Shot", MeshBox(5, 5, 5)
   put empty into sRock
   put 0 into sRockN
   repeat with tN = 1 to item 1 of tRow
      -- big rocks start on a ring, away from the ship
      put tN * 6.283 / item 1 of tRow + pLevel into tA
      Rock.Add true, cos(tA) * 300, sin(tA) * 220, item 2 of tRow
   end repeat
   put empty into sShot
   put 0 into sShotN
   put 0 into sX
   put 0 into sY
   put 0 into sVX
   put 0 into sVY
   put 0 into sA
   put 60 into sSafe
   put Entity.Spawn("Rock.Ship", 0, 0, kZ, "white") into sShip
   put empty into sHUDWas
end Rock.StartLevel

on Rock.Add pBig, pX, pY, pSpeed
   local tA
   add 1 to sRockN
   put random(628) / 100 into tA
   put pBig into sRock[sRockN]["big"]
   put pX into sRock[sRockN]["x"]
   put pY into sRock[sRockN]["y"]
   put cos(tA) * pSpeed into sRock[sRockN]["vx"]
   put sin(tA) * pSpeed into sRock[sRockN]["vy"]
   put pSpeed into sRock[sRockN]["speed"]
   if pBig then
      put Entity.Spawn("Rock.Big", pX, pY, kZ, "orange") into sRock[sRockN]["key"]
   else
      put Entity.Spawn("Rock.Small", pX, pY, kZ, "yellow") into sRock[sRockN]["key"]
   end if
   SetObjectRotationSpeed sRock[sRockN]["key"], 0, 0, (random(7) - 4) * 0.01
end Rock.Add

function Rock.Wrap pV, pLow, pHigh
   if pV < pLow then return pV + (pHigh - pLow)
   if pV > pHigh then return pV - (pHigh - pLow)
   return pV
end Rock.Wrap

function Rock.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Rock.Keys

on Rock.TestKeys pKeys
   put pKeys into sTestKeys
end Rock.TestKeys

on Game.OnUpdate
   local tKeys, tFire, tN, tS, tR, tHit, tK
   put Rock.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and sFireWas is not true then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Rock.StartLevel 1
      end if
      put (32 is among the items of tKeys) into sFireWas
      exit Game.OnUpdate
   end if
   -- the ship: its nose points along (sin a, -cos a); up the screen at a = 0
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kTurn from sA
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kTurn to sA
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then
      add sin(sA) * kThrust to sVX
      subtract cos(sA) * kThrust from sVY
   end if
   put sVX * 0.99 into sVX
   put sVY * 0.99 into sVY
   put Rock.Wrap(sX + sVX, kLeft, kRight) into sX
   put Rock.Wrap(sY + sVY, kTop, kBottom) into sY
   SetObjectPosition sShip, sX, sY, kZ
   SetObjectRotation sShip, 0, 0, sA
   put (32 is among the items of tKeys) into tFire
   if tFire and sFireWas is not true and the number of lines of the keys of sShot < 4 then
      add 1 to sShotN
      put sX + sin(sA) * 20 into sShot[sShotN]["x"]
      put sY - cos(sA) * 20 into sShot[sShotN]["y"]
      put sin(sA) * kShotSpeed into sShot[sShotN]["vx"]
      put -cos(sA) * kShotSpeed into sShot[sShotN]["vy"]
      put 40 into sShot[sShotN]["life"]
      put Entity.Spawn("Rock.Shot", sShot[sShotN]["x"], sShot[sShotN]["y"], kZ, "cyan") into sShot[sShotN]["key"]
   end if
   put tFire into sFireWas
   -- rocks drift
   repeat for each key tN in sRock
      put Rock.Wrap(sRock[tN]["x"] + sRock[tN]["vx"], kLeft, kRight) into sRock[tN]["x"]
      put Rock.Wrap(sRock[tN]["y"] + sRock[tN]["vy"], kTop, kBottom) into sRock[tN]["y"]
      SetObjectPosition sRock[tN]["key"], sRock[tN]["x"], sRock[tN]["y"], kZ
   end repeat
   -- shots fly, and split what they meet
   repeat for each key tS in sShot
      put Rock.Wrap(sShot[tS]["x"] + sShot[tS]["vx"], kLeft, kRight) into sShot[tS]["x"]
      put Rock.Wrap(sShot[tS]["y"] + sShot[tS]["vy"], kTop, kBottom) into sShot[tS]["y"]
      subtract 1 from sShot[tS]["life"]
      SetObjectPosition sShot[tS]["key"], sShot[tS]["x"], sShot[tS]["y"], kZ
      put false into tHit
      repeat for each key tN in sRock
         put 20 into tR
         if sRock[tN]["big"] then put 42 into tR
         if abs(sShot[tS]["x"] - sRock[tN]["x"]) <= tR and abs(sShot[tS]["y"] - sRock[tN]["y"]) <= tR then
            put true into tHit
            FX.Sparks sRock[tN]["x"], sRock[tN]["y"], kZ, 8, "orange"
            if sRock[tN]["big"] then
               add 20 to sScore
               repeat with tK = 1 to sSplit
                  Rock.Add false, sRock[tN]["x"], sRock[tN]["y"], sRock[tN]["speed"] * 1.5
               end repeat
            else
               add 50 to sScore
            end if
            Entity.Kill sRock[tN]["key"]
            delete variable sRock[tN]
            put empty into sHUDWas
            exit repeat
         end if
      end repeat
      if tHit or sShot[tS]["life"] <= 0 then
         Entity.Kill sShot[tS]["key"]
         delete variable sShot[tS]
      end if
   end repeat
   -- a rock on the ship (not in the first two seconds after a start)
   if sSafe > 0 then
      subtract 1 from sSafe
   else
      repeat for each key tN in sRock
         put 26 into tR
         if sRock[tN]["big"] then put 48 into tR
         if abs(sX - sRock[tN]["x"]) <= tR and abs(sY - sRock[tN]["y"]) <= tR then
            subtract 1 from sLives
            FX.Sparks sX, sY, kZ, 16, "red"
            put 0 into sX
            put 0 into sY
            put 0 into sVX
            put 0 into sVY
            put 60 into sSafe
            put empty into sHUDWas
            if sLives <= 0 then put true into sOver
            exit repeat
         end if
      end repeat
   end if
   if the number of lines of the keys of sRock = 0 then
      if sLevel >= 5 then
         put true into sOver
         put empty into sHUDWas
      else
         Rock.StartLevel sLevel + 1
      end if
   end if
   Rock.ShowHUD
end Game.OnUpdate

on Rock.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Rock.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Rock.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 20, 14
   HUD.Remove "Rock.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Rock.Msg", "THE FIELD IS CLEAR.  SPACE TO PLAY AGAIN", 200, 300, 16
   else if sOver then
      HUD.Set "Rock.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Rock.ShowHUD

function Rock.State
   return sLevel & "|" & sLives & "|" & sScore & "|rocks " & the number of lines of the keys of sRock & "|ship " & round(sX) & "," & round(sY) & "|" & sOver
end Rock.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
