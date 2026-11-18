######################################################################################
## CARD SCRIPT: "Play.VectorBlobApocalypse"   VECTOR BLOB APOCALYPSE  (11 13 2026)
## The owner's concept (round two, 4 of 9): sit, spin and shoot. Jittery vector jelly
## blobs swarm in from every side; the big ones split when hit.
## Teaches: vector movement, aiming by angle, many objects at once.
## CONTROLS  Left/Right arrows: spin   Space: shoot (hold)   Escape: stop
## RULES     a blob that reaches you costs a life. Big blobs split into small ones.
##           Clear the wave to finish the level. 5 levels.
######################################################################################

global bPaused, bPlaying

local sGun, sAim, sBlob, sShot, sSerial, sLevel, sLives, sScore, sOver, sCool, sTicks
local sBlobSpeed, sSplit, sTestKeys, sHUDWas

constant kEdge = 430          -- blobs start this far out
constant kSpin = 0.09         -- radians a step
constant kShotSpeed = 22
constant kBigR = 34
constant kSmallR = 18

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   -- above the ground, looking down at an angle
   Camera.SetPosition 0, -420, -300
   Camera.SetLook 0, -atan2(420, 340)
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   put 0 into sTicks
   Blob.StartLevel 1
end Game.OnStart

-- level table: blob count | blob speed | split count | (lives carry over)
on Blob.StartLevel pLevel
   local tRow, n, a
   put pLevel into sLevel
   put line pLevel of ("5,1.6,2" & cr & "7,1.9,2" & cr & "8,2.2,3" & cr & "10,2.5,3" & cr & "12,2.9,3") into tRow
   put item 2 of tRow into sBlobSpeed
   put item 3 of tRow into sSplit
   Scene.ClearAll
   Mesh.Define "Blob.Floor", Mesh.Grid(12, 12, 80)
   get Entity.Spawn("Blob.Floor", 0, 4, 0, "#0A280A")
   Mesh.Define "Blob.Gun", Mesh.Pyramid(3, 18, 44)
   Mesh.Define "Blob.Big", Mesh.Sphere(kBigR, 3, 6)
   Mesh.Define "Blob.Small", Mesh.Sphere(kSmallR, 2, 5)
   Mesh.Define "Blob.Shot", Mesh.Box(6, 6, 16)
   put Entity.Spawn("Blob.Gun", 0, -12, 0, "cyan") into sGun
   put 0 into sAim
   put empty into sBlob
   put empty into sShot
   repeat with n = 1 to item 1 of tRow
      put (n / item 1 of tRow) * 2 * 3.14159 + random(100) / 200 into a
      Blob.Add kEdge * sin(a), kEdge * cos(a), "big"
   end repeat
   put 0 into sCool
   put empty into sHUDWas
end Blob.StartLevel

on Blob.Add pX, pZ, pKind
   add 1 to sSerial
   put pX into sBlob[sSerial]["x"]
   put pZ into sBlob[sSerial]["z"]
   put pKind into sBlob[sSerial]["kind"]
   if pKind is "big" then
      put Entity.Spawn("Blob.Big", pX, -kBigR, pZ, "#FF60D0") into sBlob[sSerial]["key"]
   else
      put Entity.Spawn("Blob.Small", pX, -kSmallR, pZ, "#FFB000") into sBlob[sSerial]["key"]
   end if
end Blob.Add

function Blob.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Blob.Keys

on Blob.TestKeys pKeys
   put pKeys into sTestKeys
end Blob.TestKeys

on Game.OnUpdate
   local tKeys, tK, tB, d, r, tGone, n, a, tLeft
   add 1 to sTicks
   put Blob.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys and sTicks > 30 then Game.OnStart
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kSpin from sAim
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kSpin to sAim
   Entity.SetRotation sGun, 1.5708, sAim, 0        -- the pyramid lies down and points along the aim
   -- shooting: one shot every 5 steps while Space is held
   if sCool > 0 then subtract 1 from sCool
   if 32 is among the items of tKeys and sCool <= 0 then
      add 1 to sSerial
      put 20 * sin(sAim) into sShot[sSerial]["x"]
      put 20 * cos(sAim) into sShot[sSerial]["z"]
      put kShotSpeed * sin(sAim) into sShot[sSerial]["dx"]
      put kShotSpeed * cos(sAim) into sShot[sSerial]["dz"]
      put Entity.Spawn("Blob.Shot", sShot[sSerial]["x"], -14, sShot[sSerial]["z"], "white") into sShot[sSerial]["key"]
      Entity.SetRotation sShot[sSerial]["key"], 0, sAim, 0
      put 5 into sCool
   end if
   -- shots fly; the first blob one touches is hit
   repeat for each key tK in sShot
      add sShot[tK]["dx"] to sShot[tK]["x"]
      add sShot[tK]["dz"] to sShot[tK]["z"]
      put false into tGone
      if abs(sShot[tK]["x"]) > 520 or abs(sShot[tK]["z"]) > 520 then put true into tGone
      repeat for each key tB in sBlob
         if tGone then exit repeat
         put kSmallR + 6 into r
         if sBlob[tB]["kind"] is "big" then put kBigR + 6 into r
         if abs(sShot[tK]["x"] - sBlob[tB]["x"]) < r and abs(sShot[tK]["z"] - sBlob[tB]["z"]) < r then
            put true into tGone
            FX.Sparks sBlob[tB]["x"], -20, sBlob[tB]["z"], 8, "#FF60D0"
            Entity.Kill sBlob[tB]["key"]
            if sBlob[tB]["kind"] is "big" then
               -- a big one splits
               repeat with n = 1 to sSplit
                  put n * 2.1 + sTicks into a
                  Blob.Add sBlob[tB]["x"] + 40 * sin(a), sBlob[tB]["z"] + 40 * cos(a), "small"
               end repeat
               add 10 to sScore
            else
               add 5 to sScore
            end if
            delete variable sBlob[tB]
            put empty into sHUDWas
         end if
      end repeat
      if tGone then
         Entity.Kill sShot[tK]["key"]
         delete variable sShot[tK]
      else
         Entity.SetPosition sShot[tK]["key"], sShot[tK]["x"], -14, sShot[tK]["z"]
      end if
   end repeat
   -- blobs jitter their way in
   put 0 into tLeft
   repeat for each key tB in sBlob
      add 1 to tLeft
      put sqrt(sBlob[tB]["x"] ^ 2 + sBlob[tB]["z"] ^ 2) into d
      if d < 30 then
         -- it got you
         FX.Sparks 0, -20, 0, 20, "red"
         Entity.Kill sBlob[tB]["key"]
         delete variable sBlob[tB]
         subtract 1 from sLives
         put empty into sHUDWas
         if sLives <= 0 then
            put true into sOver
            put 0 into sTicks
         end if
         next repeat
      end if
      subtract sBlob[tB]["x"] / d * sBlobSpeed - (random(9) - 5) * 0.8 from sBlob[tB]["x"]
      subtract sBlob[tB]["z"] / d * sBlobSpeed - (random(9) - 5) * 0.8 from sBlob[tB]["z"]
      put kSmallR into r
      if sBlob[tB]["kind"] is "big" then put kBigR into r
      Entity.SetPosition sBlob[tB]["key"], sBlob[tB]["x"], -r - 3 * sin((sTicks + tB * 7) / 4), sBlob[tB]["z"]
   end repeat
   if tLeft is 0 and not sOver then
      if sLevel >= 5 then
         put true into sOver
         put 0 into sTicks
      else
         Blob.StartLevel sLevel + 1
      end if
   end if
   Blob.ShowHUD
end Game.OnUpdate

on Blob.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sOver into tWords
   if tWords is sHUDWas then exit Blob.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Blob.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Blob.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Blob.Msg", "THE JELLY IS GONE.  SPACE TO PLAY AGAIN", 200, 400, 16
   else if sOver then
      HUD.Set "Blob.Msg", "ABSORBED.  SPACE TO PLAY AGAIN", 250, 400, 16
   end if
end Blob.ShowHUD

function Blob.State
   local tB, n
   put 0 into n
   repeat for each key tB in sBlob
      add 1 to n
   end repeat
   return sLevel & "|" & sLives & "|" & sScore & "|" & n & "|" & round(sAim, 2) & "|" & sOver
end Blob.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
