######################################################################################
## CARD SCRIPT: "Play.FloppyFlynn"   FLOPPY FLYNN  (11 13 2026)
## The owner's concept (round two, 3 of 9): a blue two-legged vector ship with a bad
## ankle flaps through destructible terrain. A crash tears a part off instead of killing;
## with too few parts left it can't fly, and plummets.
## Teaches: gravity and scrolling.
## CONTROLS  Space: flap   Escape: stop
## RULES     fly through the gaps. Every crash costs a part and breaks the terrain it hit.
##           Under 3 parts the ship can't flap any more. Distance is the score. 5 levels.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sY, sVY, sParts, sPartKeys, sCols, sSerial, sNextX, sGapY, sDist, sLevel, sSafe
local sScroll, sGap, sGravity, sStartParts, sOver, sStarted, sFlapWas, sTestKeys, sHUDWas, sTicks

constant kZ = 600
constant kShipX = -220
constant kTop = -300
constant kFloor = 300
constant kColW = 70
constant kFlap = -11
-- the ship: free-floating parts, each "dx,dy,w,h": body, cabin, two legs (one bent), two arms, a foot
constant kShape = "0,0,60,16|0,-18,26,14|-18,22,10,30|20,18,10,22|-36,0,14,8|36,0,14,8|26,34,18,8"

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 1 into sLevel
   put 0 into sDist
   put false into sOver
   put false into sStarted
   put 0 into sTicks
   Flop.SetLevel
   Flop.NewShip
   Flop.NewTerrain
end Game.OnStart

-- level table: scroll speed | gap height | gravity | ship parts
on Flop.SetLevel
   local tRow
   put line sLevel of ("5,300,0.55,7" & cr & "6,270,0.6,7" & cr & "7,240,0.65,7" & cr & "8,215,0.7,7" & cr & "9,190,0.75,7") into tRow
   put item 1 of tRow into sScroll
   put item 2 of tRow into sGap
   put item 3 of tRow into sGravity
   put item 4 of tRow into sStartParts
   put empty into sHUDWas
end Flop.SetLevel

on Flop.NewShip
   local n, tPart
   put 0 into sY
   put 0 into sVY
   put empty into sPartKeys
   set the itemDel to "|"
   put the number of items of kShape into sParts
   repeat with n = 1 to sParts
      put item n of kShape into tPart
      set the itemDel to comma
      Mesh.Define "Flop.Part" & n, MeshBox(item 3 of tPart, item 4 of tPart, 10)
      put Entity.Spawn("Flop.Part" & n, kShipX + item 1 of tPart, sY + item 2 of tPart, kZ, "#4C8CFF") into sPartKeys[n]
      set the itemDel to "|"
   end repeat
   set the itemDel to comma
   put 0 into sSafe
end Flop.NewShip

on Flop.NewTerrain
   put empty into sCols
   put 0 into sSerial
   put 200 into sNextX
   put 0 into sGapY
   Mesh.Define "Flop.Rock", MeshBox(kColW - 8, 600, 14)
   repeat 14 times
      Flop.AddColumn
   end repeat
end Flop.NewTerrain

-- one column of terrain: a block above the gap and one below it
on Flop.AddColumn
   local tTopY, tBotY
   add 1 to sSerial
   put max(-140, min(140, sGapY + random(141) - 71)) into sGapY
   put sNextX into sCols[sSerial]["x"]
   put sGapY into sCols[sSerial]["gap"]
   put sGap into sCols[sSerial]["h"]
   put sGapY - sGap / 2 - 300 into tTopY
   put sGapY + sGap / 2 + 300 into tBotY
   put Entity.Spawn("Flop.Rock", sNextX, tTopY, kZ, "#40FF80") into sCols[sSerial]["top"]
   put Entity.Spawn("Flop.Rock", sNextX, tBotY, kZ, "#40FF80") into sCols[sSerial]["bot"]
   add kColW * 3 to sNextX
end Flop.AddColumn

function Flop.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Flop.Keys

on Flop.TestKeys pKeys
   put pKeys into sTestKeys
end Flop.TestKeys

on Game.OnUpdate
   local tKeys, tFlap, tK, n, tPart, tHit
   add 1 to sTicks
   put Flop.Keys() into tKeys
   put (32 is among the items of tKeys) into tFlap
   if sOver then
      if tFlap and not sFlapWas then Game.OnStart
      put tFlap into sFlapWas
      exit Game.OnUpdate
   end if
   if not sStarted then
      if tFlap then put true into sStarted
      Flop.ShowHUD
      put tFlap into sFlapWas
      exit Game.OnUpdate
   end if
   -- one flap per press; under 3 parts the ship can't fly
   if tFlap and not sFlapWas and sParts >= 3 then put kFlap into sVY
   put tFlap into sFlapWas
   add sGravity to sVY
   add sVY to sY
   if sY < kTop + 20 then
      put kTop + 20 into sY
      put 0 into sVY
   end if
   -- the terrain scrolls past
   put false into tHit
   repeat for each key tK in sCols
      subtract sScroll from sCols[tK]["x"]
      if sCols[tK]["top"] is not empty then
         SetObjectPosition sCols[tK]["top"], sCols[tK]["x"], sCols[tK]["gap"] - sCols[tK]["h"] / 2 - 300, kZ
         SetObjectPosition sCols[tK]["bot"], sCols[tK]["x"], sCols[tK]["gap"] + sCols[tK]["h"] / 2 + 300, kZ
         -- a crash: the ship is 40 high at most; outside the gap while inside the column
         if sSafe <= 0 and abs(sCols[tK]["x"] - kShipX) < kColW / 2 + 28 and abs(sY - sCols[tK]["gap"]) > sCols[tK]["h"] / 2 - 22 then
            put true into tHit
            -- the terrain it hit breaks away
            FX.Sparks sCols[tK]["x"], sY, kZ, 14, "#40FF80"
            Entity.Kill sCols[tK]["top"]
            Entity.Kill sCols[tK]["bot"]
            put empty into sCols[tK]["top"]
         end if
      end if
      if sCols[tK]["x"] < -520 then
         if sCols[tK]["top"] is not empty then
            Entity.Kill sCols[tK]["top"]
            Entity.Kill sCols[tK]["bot"]
         end if
         delete variable sCols[tK]
         add 1 to sDist
         put empty into sHUDWas
         Flop.AddColumn
         -- a new level every 12 columns
         if sDist mod 12 is 0 and sLevel < 5 then
            add 1 to sLevel
            Flop.SetLevel
         end if
      end if
   end repeat
   subtract sScroll from sNextX
   if sSafe > 0 then subtract 1 from sSafe
   if tHit then Flop.LosePart
   -- the parts ride with the ship, each wobbling a little (free-floating geometry)
   set the itemDel to "|"
   repeat for each key n in sPartKeys
      put item n of kShape into tPart
      set the itemDel to comma
      SetObjectPosition sPartKeys[n], kShipX + item 1 of tPart, sY + item 2 of tPart + 2 * sin((sTicks + n * 9) / 6), kZ
      set the itemDel to "|"
   end repeat
   set the itemDel to comma
   if sY > kFloor then
      put true into sOver
      FX.Sparks kShipX, kFloor, kZ, 30, "#4C8CFF"
      put empty into sHUDWas
   end if
   Flop.ShowHUD
end Game.OnUpdate

-- a crash tears the last part off; the ship is safe for half a second
on Flop.LosePart
   local tLast, n
   put 0 into tLast
   repeat for each key n in sPartKeys
      put max(tLast, n) into tLast
   end repeat
   if tLast > 0 then
      FX.Sparks kShipX, sY, kZ, 10, "#4C8CFF"
      Entity.Kill sPartKeys[tLast]
      delete variable sPartKeys[tLast]
      subtract 1 from sParts
   end if
   put 15 into sSafe
   put empty into sHUDWas
end Flop.LosePart

on Flop.ShowHUD
   local tWords
   put sLevel & "|" & sParts & "|" & sDist & "|" & sStarted & "|" & sOver into tWords
   if tWords is sHUDWas then exit Flop.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Flop.Score", "DISTANCE" && sDist && "  PARTS" && sParts && "  LEVEL" && sLevel, 20, 120, 14
   HUD.Remove "Flop.Msg"
   if sOver then
      HUD.Set "Flop.Msg", "FLYNN IS DOWN AT" && sDist & ".  SPACE TO FLY AGAIN", 210, 400, 16
   else if not sStarted then
      HUD.Set "Flop.Msg", "SPACE TO FLAP", 330, 400, 16
   else if sParts < 3 then
      HUD.Set "Flop.Msg", "TOO FEW PARTS TO FLY", 290, 400, 16
   end if
end Flop.ShowHUD

function Flop.State
   return sLevel & "|" & sParts & "|" & sDist & "|" & round(sY) & "|" & sStarted & "|" & sOver
end Flop.State

on Game.OnStop
   HUD.Clear
end Game.OnStop
