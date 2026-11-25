######################################################################################
## CARD SCRIPT: "Play.BankShotBounce"   BANK SHOT BOUNCE  (11 19 2026)
## The owner's idea (GAME_IDEAS.txt, 18 Nov), worked out by Spark (LIB_SPARK/arcade/out/
## 285_Bank_Shot_Bounce: 1_concept.md, 2_levels.md), written by Claude on 19 Nov 2026 for
## Vibecode3D (XT) and xt3d (xRay). TABLE PHYSICS BY JIM HURLEY: the ball-to-ball collision
## (resetVel), cushions, cloth and pockets are his, as rewritten in the Nine Ball game (from
## Scott Rossi's "nine ball" stack); the bumpers, the blocks and the sliding pockets are new.
## Notes and what changed from Spark's concept: BankShotBounce/README.md.
## CONTROLS  Mouse: hold the button and drag BACK from your (white) ball, like a slingshot;
##           the ball goes the other way; the longer the pull, the harder; let go to shoot.
##           Keys: Left/Right (or A/D) aim, Shift = fine aim, Up/Down (or W/S) pull harder or
##           softer, Space (or Enter) shoots. C: the 3D view or straight down. R: the level again.
## RULES     sink the numbered balls IN ORDER (the lowest first): ball number x 10 points.
##           A ball sunk out of order comes back to its spot (no points). Sinking your own
##           ball costs a life (it comes back to its spot). All numbered balls down = the
##           level's bonus and the next table. No lives left: Space plays the table again.
## TABLES    1 plain, 2 slick felt, 3 a bumper in the middle, 4 the side pockets slide along
##           the rails, 5 an hourglass table on sticky felt (Spark's 5 levels: balls 3 to 7,
##           lives 3 3 2 2 1, bonus 100 to 300).
######################################################################################

global bPaused, bPlaying, gNoMouse, gViewBottom

-- the table, in Jim Hurley's numbers (820 x 480, y down, 0,0 top left)
local sX, sY, sVX, sVY, sOnTable, sBall, sRotX, sRotZ, sScored, sHome
local sMode, sLevel, sLives, sScore, sScoreAtStart, sNext, sCount, sMsg, sFriction, sShots
local sSunkNow, sRespot, sScratch, sBumpers, sBlocks, sSlide, sPockets, sPocketEnt, sLevelName
local sAim, sPower, sDot, sDrag, sMouseWas, sKeysWas, sTestKeys, sTestMouse, sHUDWas
local sTicks, sLabelsOn, sTopView, sBonus, sAimWas

constant kW = 820             -- the table (Hurley: the width of the stack)
constant kH = 480
constant kR = 20              -- ball radius
constant kCushion = 20        -- Hurley's tCushion
constant kStop = 0.2          -- AllStopped: every speed below this
constant kPocketR = 46        -- a ball whose centre comes this near a pocket point drops
constant kCorners = "22,20 798,20 798,460 22,460"
constant kSides = "410,6 410,474"
constant kSteps = 3           -- Hurley steps a frame
constant kMaxPower = 16       -- a 400 pixel pull
constant kPull = 5            -- yellow dots: the pull behind the ball
constant kDots = 16           -- and white ones: where it goes, one cushion bounce shown
constant kHeadSpot = "205,240"
constant kLevels = 5
constant kBumpKick = 1.15     -- a bumper sends a ball off a little faster (at most kMaxPower)

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put true into sTopView
   BS.Camera
   put 0 into sTicks
   put empty into sKeysWas
   put false into sMouseWas
   put "title" into sMode
   put 0 into sScore
   put 0 into sScoreAtStart
   BS.Table 1
   BS.HideAim
   BS.Labels false
   put "title" into sMode
   put empty into sHUDWas
   BS.ShowHUD
end Game.OnStart

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows aim; a focused menu or field must never get them
on arrowKey pKey
end arrowKey

------------------------------------------------------------------ table <-> world

function BS.WX pTX
   return pTX - kW / 2
end BS.WX

function BS.WZ pTY
   return kH / 2 - pTY
end BS.WZ

on BS.Camera
   if sTopView then
      Camera.SetPosition 0, -950, -50
      Camera.SetLook 0, -atan2(950, 50)
   else
      Camera.SetPosition 0, -430, -330
      Camera.SetLook 0, -atan2(430, 330)
   end if
end BS.Camera

------------------------------------------------------------------ the five tables

-- "name|balls|lives|bonus|felt|ball spots|bumpers x,y,r|blocks x1,y1,x2,y2|sliding pockets"
-- balls, lives and bonus are Spark's level table; the rest follows its notes and the idea
function BS.LevelData pLevel
   switch pLevel
      case 1
         return "PLAIN TABLE|3|3|100|0.991|600,240 600,140 600,340|||false"
      case 2
         return "SLICK FELT|4|3|150|0.994|560,240 660,150 660,330 300,100|||false"
      case 3
         return "A BUMPER IN THE MIDDLE|5|2|200|0.991|600,240 600,120 220,380 600,360 220,100|410,240,34||false"
      case 4
         return "SLIDING POCKETS|6|2|250|0.991|520,240 620,170 620,310 700,240 410,120 410,360|||true"
      case 5
         return "HOURGLASS ON STICKY FELT|7|1|300|0.986|560,240 640,180 640,300 720,240 700,100 250,100 250,380||360,20,460,150 360,330,460,460|false"
   end switch
   return empty
end BS.LevelData

function BS.Field pData, pN
   set the itemDelimiter to "|"
   return item pN of pData
end BS.Field

-- build table pLevel: felt, rails, pockets, bumpers, blocks, the balls on their spots
on BS.Table pLevel
   local i, tD, tXY, tW, tN
   put pLevel into sLevel
   put BS.LevelData(pLevel) into tD
   put BS.Field(tD, 1) into sLevelName
   put BS.Field(tD, 2) into sCount
   put BS.Field(tD, 3) into sLives
   put BS.Field(tD, 4) into sBonus
   put BS.Field(tD, 5) into sFriction
   put BS.Field(tD, 7) into sBumpers
   put BS.Field(tD, 8) into sBlocks
   put (BS.Field(tD, 9) is "true") into sSlide
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   put empty into sDot
   put empty into sHUDWas
   put false into sLabelsOn
   put empty into sPocketEnt
   Mesh.Define "BS.Felt", Mesh.Box(kW - 2 * kCushion, 2, kH - 2 * kCushion)
   Mesh.Define "BS.RailLong", Mesh.Box(kW, 14, kCushion)
   Mesh.Define "BS.RailShort", Mesh.Box(kCushion, 14, kH - 2 * kCushion)
   Mesh.Define "BS.Pocket", Mesh.Prism(8, 30, 1)
   Mesh.Define "BS.Ball", Mesh.Sphere(kR, 3, 6)
   Mesh.Define "BS.Dot", Mesh.Box(5, 5, 5)
   get Entity.Spawn("BS.Felt", 0, 1, 0, BS.FeltColor())
   get Entity.Spawn("BS.RailLong", 0, -7, BS.WZ(kCushion / 2), "#6B4A8A")
   get Entity.Spawn("BS.RailLong", 0, -7, BS.WZ(kH - kCushion / 2), "#6B4A8A")
   get Entity.Spawn("BS.RailShort", BS.WX(kCushion / 2), -7, 0, "#6B4A8A")
   get Entity.Spawn("BS.RailShort", BS.WX(kW - kCushion / 2), -7, 0, "#6B4A8A")
   -- the pockets: four corners; the two side pockets unless blocks stand there
   put kCorners into sPockets
   if sBlocks is empty then put space & kSides after sPockets
   put 0 into tN
   repeat for each word tXY in sPockets
      add 1 to tN
      put Entity.Spawn("BS.Pocket", BS.WX(item 1 of tXY), -2, BS.WZ(item 2 of tXY), "#D0D0D0") into sPocketEnt[tN]
   end repeat
   -- bumpers (Spark: orange) and blocks (the odd shapes: rail wood)
   repeat for each word tW in sBumpers
      Mesh.Define "BS.Bumper" & item 3 of tW, Mesh.Prism(12, item 3 of tW, 18)
      get Entity.Spawn("BS.Bumper" & item 3 of tW, BS.WX(item 1 of tW), -9, BS.WZ(item 2 of tW), "#FF8C1A")
   end repeat
   repeat for each word tW in sBlocks
      Mesh.Define "BS.Block" & tN, Mesh.Box(item 3 of tW - item 1 of tW, 14, item 4 of tW - item 2 of tW)
      get Entity.Spawn("BS.Block" & tN, BS.WX((item 1 of tW + item 3 of tW) / 2), -7, BS.WZ((item 2 of tW + item 4 of tW) / 2), "#6B4A8A")
      add 1 to tN
   end repeat
   put empty into sBall
   repeat with i = 0 to 7
      put 0 into sVX[i]
      put 0 into sVY[i]
      put 0 into sRotX[i]
      put 0 into sRotZ[i]
      put false into sScored[i]
      put (i <= sCount) into sOnTable[i]
      if i is 0 then
         put kHeadSpot into sHome[i]
      else
         put word i of BS.Field(tD, 6) into sHome[i]
      end if
      if not sOnTable[i] then next repeat
      put item 1 of sHome[i] into sX[i]
      put item 2 of sHome[i] into sY[i]
      put Entity.Spawn("BS.Ball", BS.WX(sX[i]), -kR, BS.WZ(sY[i]), BS.Color(i)) into sBall[i]
   end repeat
   put 1 into sNext
   put 0 into sShots
   put empty into sSunkNow
   put empty into sRespot
   put false into sScratch
   put 8 into sPower
   put 0 into sAim
   put false into sDrag
   put sScore into sScoreAtStart
   put "aim" into sMode
   put "TABLE" && sLevel & ":" && sLevelName into sMsg
   BS.AimAtNext
   BS.ShowAim
   put empty into sHUDWas
end BS.Table

function BS.FeltColor
   if sFriction > 0.992 then return "#2A8FB8"     -- slick: icy blue
   if sFriction < 0.99 then return "#6E7A2A"      -- sticky: mossy
   return "#1E7A3C"
end BS.FeltColor

-- your ball white; the numbered balls in Spark's blue, a shade a number
function BS.Color pBall
   return item pBall + 1 of "white,#FFD21F,#2F6BFF,#FF3030,#A040FF,#FF8C1A,#20C040,#B03020"
end BS.Color

------------------------------------------------------------------ Jim Hurley's physics

-- Hurley's resetVel (as in Nine Ball): an equal-mass elastic collision. The parts of the
-- velocities along the line joining the centres are swapped, the parts across it kept.
function BS.ResetVel pX1, pY1, pX2, pY2, pVX1, pVY1, pVX2, pVY2
   local tCa, tVa, tVa2, tV, tV2, tVrA, tVrA2, tVR, tVT, tVR2, tVT2
   put BS.LineAngle(pX1, pY1, pX2, pY2) into tCa
   put BS.LineAngle(pX1, pY1, pX1 + pVX1, pY1 + pVY1) into tVa
   put BS.LineAngle(pX2, pY2, pX2 + pVX2, pY2 + pVY2) into tVa2
   put sqrt(pVX2 * pVX2 + pVY2 * pVY2) into tV2
   put sqrt(pVX1 * pVX1 + pVY1 * pVY1) into tV
   put tVa - tCa into tVrA
   put tVa2 - tCa into tVrA2
   put tV * cos(tVrA) into tVR2
   put tV * sin(tVrA) into tVT
   put tV2 * cos(tVrA2) into tVR
   put tV2 * sin(tVrA2) into tVT2
   return (tVR * cos(tCa) - tVT * sin(tCa)) & comma & (tVR * sin(tCa) + tVT * cos(tCa)) & comma & \
         (tVR2 * cos(tCa) - tVT2 * sin(tCa)) & comma & (tVR2 * sin(tCa) + tVT2 * cos(tCa))
end BS.ResetVel

-- Hurley's theLineAngle
function BS.LineAngle pX1, pY1, pX2, pY2
   return atan2(pY2 - pY1, pX2 - pX1)
end BS.LineAngle

-- Hurley's theDist
function BS.Dist pX1, pY1, pX2, pY2
   return sqrt((pX1 - pX2) ^ 2 + (pY1 - pY2) ^ 2)
end BS.Dist

function BS.InPocket pX, pY
   local tXY
   repeat for each word tXY in sPockets
      if BS.Dist(pX, pY, item 1 of tXY, item 2 of tXY) < kPocketR then return true
   end repeat
   return false
end BS.InPocket

-- one pass of Hurley's doMove over every ball on the table, + bumpers and blocks
on BS.Step
   local i, j, tJ, tS, tSMin, tNew, tSafe, tA
   repeat with i = 0 to sCount
      if not sOnTable[i] then next repeat
      if BS.InPocket(sX[i], sY[i]) then
         BS.Sink i
         next repeat
      end if
      add sVX[i] to sX[i]
      add sVY[i] to sY[i]
      put empty into tJ
      put 2 * kR into tSMin
      repeat with j = i + 1 to sCount
         if not sOnTable[j] then next repeat
         put BS.Dist(sX[i], sY[i], sX[j], sY[j]) into tS
         if tS < tSMin then
            put tS into tSMin
            put j into tJ
         end if
      end repeat
      if tJ is not empty then
         subtract sVX[i] from sX[i]
         subtract sVY[i] from sY[i]
         subtract sVX[tJ] from sX[tJ]
         subtract sVY[tJ] from sY[tJ]
         put BS.ResetVel(sX[i], sY[i], sX[tJ], sY[tJ], sVX[i], sVY[i], sVX[tJ], sVY[tJ]) into tNew
         put item 1 of tNew into sVX[i]
         put item 2 of tNew into sVY[i]
         put item 3 of tNew into sVX[tJ]
         put item 4 of tNew into sVY[tJ]
         Sound.Play "Hit"
         put 0 into tSafe
         repeat while BS.Dist(sX[i], sY[i], sX[tJ], sY[tJ]) <= 2 * kR and tSafe < 60
            put atan2(sY[i] - sY[tJ], sX[i] - sX[tJ]) into tA
            add cos(tA) to sX[i]
            add sin(tA) to sY[i]
            add 1 to tSafe
         end repeat
      end if
      -- the cushions: step back and turn round (Hurley)
      if sX[i] - kCushion < kR or sX[i] + kR + kCushion > kW then
         subtract sVX[i] from sX[i]
         multiply sVX[i] by -1
         Sound.Play "Bounce"
      end if
      if sY[i] - kCushion < kR or sY[i] + kR + kCushion > kH then
         subtract sVY[i] from sY[i]
         multiply sVY[i] by -1
         Sound.Play "Bounce"
      end if
      BS.Bumpers i
      BS.Blocks i
      -- the cloth
      multiply sVX[i] by sFriction
      multiply sVY[i] by sFriction
   end repeat
end BS.Step

-- reflect ball pBall's speed off a surface whose outward normal is pNX,pNY (unit length)
on BS.Reflect pBall, pNX, pNY, pKick
   local tDot, tSp
   put sVX[pBall] * pNX + sVY[pBall] * pNY into tDot
   if tDot >= 0 then exit BS.Reflect      -- already going away
   subtract 2 * tDot * pNX from sVX[pBall]
   subtract 2 * tDot * pNY from sVY[pBall]
   if pKick is a number then
      put sqrt(sVX[pBall] ^ 2 + sVY[pBall] ^ 2) into tSp
      if tSp * pKick > kMaxPower then put kMaxPower / max(tSp, 0.001) into pKick
      multiply sVX[pBall] by pKick
      multiply sVY[pBall] by pKick
   end if
end BS.Reflect

-- round bumpers: push the ball out to touch, bounce, a little kick
on BS.Bumpers pBall
   local tW, tD, tNX, tNY, tBX, tBY, tBR
   repeat for each word tW in sBumpers
      put item 1 of tW into tBX
      put item 2 of tW into tBY
      put item 3 of tW into tBR
      put BS.Dist(sX[pBall], sY[pBall], tBX, tBY) into tD
      if tD >= kR + tBR then next repeat
      if tD < 0.001 then
         put 1 into tNX
         put 0 into tNY
      else
         put (sX[pBall] - tBX) / tD into tNX
         put (sY[pBall] - tBY) / tD into tNY
      end if
      put tBX + tNX * (kR + tBR + 0.5) into sX[pBall]
      put tBY + tNY * (kR + tBR + 0.5) into sY[pBall]
      BS.Reflect pBall, tNX, tNY, kBumpKick
      Sound.Play "Blip"
      FX.Sparks BS.WX(tBX + tNX * tBR), -kR, BS.WZ(tBY + tNY * tBR), 4, "#FF8C1A"
   end repeat
end BS.Bumpers

-- the blocks (odd table shapes): the nearest point of the box to the ball's centre
on BS.Blocks pBall
   local tW, tCX, tCY, tD, tNX, tNY, tL, tR, tT, tB
   repeat for each word tW in sBlocks
      put item 1 of tW into tL
      put item 2 of tW into tT
      put item 3 of tW into tR
      put item 4 of tW into tB
      put max(tL, min(tR, sX[pBall])) into tCX
      put max(tT, min(tB, sY[pBall])) into tCY
      put BS.Dist(sX[pBall], sY[pBall], tCX, tCY) into tD
      if tD >= kR then next repeat
      if tD < 0.001 then
         -- the centre got inside: out by the nearest side
         put min(sX[pBall] - tL, tR - sX[pBall], sY[pBall] - tT, tB - sY[pBall]) into tD
         put 0 into tNX
         put 0 into tNY
         if tD is sX[pBall] - tL then
            put -1 into tNX
            put tL - kR into sX[pBall]
         else if tD is tR - sX[pBall] then
            put 1 into tNX
            put tR + kR into sX[pBall]
         else if tD is sY[pBall] - tT then
            put -1 into tNY
            put tT - kR into sY[pBall]
         else
            put 1 into tNY
            put tB + kR into sY[pBall]
         end if
      else
         put (sX[pBall] - tCX) / tD into tNX
         put (sY[pBall] - tCY) / tD into tNY
         put tCX + tNX * (kR + 0.01) into sX[pBall]
         put tCY + tNY * (kR + 0.01) into sY[pBall]
      end if
      BS.Reflect pBall, tNX, tNY
      Sound.Play "Thud"
   end repeat
end BS.Blocks

-- Hurley's AllStopped
function BS.AllStopped
   local i
   repeat with i = 0 to sCount
      if not sOnTable[i] then next repeat
      if abs(sVX[i]) > kStop or abs(sVY[i]) > kStop then return false
   end repeat
   return true
end BS.AllStopped

-- a ball drops: in order = points; out of order = back on its spot after the shot
on BS.Sink pBall
   local tXY, tBest, tD, tPX, tPY
   put false into sOnTable[pBall]
   put 0 into sVX[pBall]
   put 0 into sVY[pBall]
   put pBall & comma after sSunkNow
   if pBall is 0 then
      put true into sScratch
      Sound.Play "Hurt"
   else if pBall is sNext then
      put true into sScored[pBall]
      Sound.Play "Pickup"
      add pBall * 10 to sScore
      put BS.NextBall() into sNext
   else
      put pBall & comma after sRespot
      Sound.Play "Thud"
   end if
   put 9999 into tBest
   repeat for each word tXY in sPockets
      put BS.Dist(sX[pBall], sY[pBall], item 1 of tXY, item 2 of tXY) into tD
      if tD < tBest then
         put tD into tBest
         put item 1 of tXY into tPX
         put item 2 of tXY into tPY
      end if
   end repeat
   if sBall[pBall] is not empty then Entity.Kill sBall[pBall]
   put empty into sBall[pBall]
   FX.Sparks BS.WX(tPX), -kR, BS.WZ(tPY), 8, BS.Color(pBall)
end BS.Sink

-- the lowest numbered ball not yet scored (empty = the table is clear)
function BS.NextBall
   local i
   repeat with i = 1 to sCount
      if not sScored[i] then return i
   end repeat
   return empty
end BS.NextBall

-- is table point pX,pY free for ball pBall (no ball, bumper or block there)?
function BS.Free pBall, pX, pY
   local j, tW
   repeat with j = 0 to sCount
      if j is pBall or not sOnTable[j] then next repeat
      if BS.Dist(pX, pY, sX[j], sY[j]) <= 2 * kR then return false
   end repeat
   repeat for each word tW in sBumpers
      if BS.Dist(pX, pY, item 1 of tW, item 2 of tW) <= kR + item 3 of tW then return false
   end repeat
   repeat for each word tW in sBlocks
      if pX > item 1 of tW - kR and pX < item 3 of tW + kR and pY > item 2 of tW - kR and pY < item 4 of tW + kR then return false
   end repeat
   return true
end BS.Free

-- put a ball back on its spot; if the spot is taken, along the table until it is free
on BS.Spot pBall
   local tX, tY
   put item 1 of sHome[pBall] into tX
   put item 2 of sHome[pBall] into tY
   repeat 60 times
      if BS.Free(pBall, tX, tY) then exit repeat
      add 2 * kR + 2 to tX
      if tX > kW - kCushion - kR - 1 then
         put kCushion + kR + 1 into tX
         add 2 * kR + 2 to tY
         if tY > kH - kCushion - kR - 1 then put kCushion + kR + 1 into tY
      end if
   end repeat
   put tX into sX[pBall]
   put tY into sY[pBall]
   put 0 into sVX[pBall]
   put 0 into sVY[pBall]
   put true into sOnTable[pBall]
   if sBall[pBall] is empty then put Entity.Spawn("BS.Ball", BS.WX(tX), -kR, BS.WZ(tY), BS.Color(pBall)) into sBall[pBall]
end BS.Spot

------------------------------------------------------------------ the shot and the rules

on BS.Shoot pAngle, pPower
   local i
   if sMode is not "aim" or not sOnTable[0] then exit BS.Shoot
   put max(0, min(kMaxPower, pPower)) into pPower
   repeat with i = 1 to sCount
      put 0 into sVX[i]
      put 0 into sVY[i]
   end repeat
   put pPower * cos(pAngle) into sVX[0]
   put pPower * sin(pAngle) into sVY[0]
   put empty into sSunkNow
   put empty into sRespot
   put false into sScratch
   put empty into sMsg
   add 1 to sShots
   put false into sDrag
   BS.HideAim
   BS.Labels false
   put "moving" into sMode
   Sound.Play "Shoot"
end BS.Shoot

-- every ball has stopped: lives, spots, the next table
on BS.EndShot
   local i, tGood
   repeat with i = 0 to sCount
      put 0 into sVX[i]
      put 0 into sVY[i]
   end repeat
   put 0 into tGood
   repeat for each item i in sSunkNow
      if i is not 0 and sScored[i] then add 1 to tGood
   end repeat
   if sNext is empty then
      add sBonus to sScore
      if sLevel >= kLevels then
         put "won" into sMode
         Sound.Play "Win"
         put "EVERY TABLE CLEARED!  SCORE" && sScore into sMsg
      else
         put "clear" into sMode
         Sound.Play "Win"
         put "TABLE" && sLevel && "CLEAR!  BONUS" && sBonus into sMsg
      end if
      BS.Labels false
      put empty into sHUDWas
      BS.ShowHUD
      exit BS.EndShot
   end if
   repeat for each item i in sRespot
      BS.Spot i
   end repeat
   if sScratch then
      subtract 1 from sLives
      if sLives <= 0 then
         put 0 into sLives
         put "over" into sMode
         Sound.Play "Lose"
         put "YOUR BALL WENT DOWN. NO LIVES LEFT" into sMsg
         BS.Labels false
         put empty into sHUDWas
         BS.ShowHUD
         exit BS.EndShot
      end if
      BS.Spot 0
      put "YOUR BALL WENT DOWN: A LIFE LOST" into sMsg
   else if sRespot is not empty then
      put "OUT OF ORDER: BACK ON ITS SPOT. SINK THE" && sNext && "FIRST" into sMsg
   else if tGood > 1 then
      put tGood && "IN ORDER IN ONE SHOT!" into sMsg
   else if tGood is 1 then
      put "IN!  NOW THE" && sNext into sMsg
   end if
   put "aim" into sMode
   BS.AimAtNext
   BS.MoveEntities
   BS.ShowAim
   put empty into sHUDWas
end BS.EndShot

on BS.AimAtNext
   if sNext is empty or not sOnTable[0] or not sOnTable[sNext] then exit BS.AimAtNext
   put BS.LineAngle(sX[0], sY[0], sX[sNext], sY[sNext]) into sAim
end BS.AimAtNext

-- the side pockets of table 4 slide along the long rails (opposite ways)
on BS.MovePockets
   local tS, tX1, tX2
   if not sSlide then exit BS.MovePockets
   put sin(sTicks * 0.025) into tS
   put round(410 + 290 * tS, 1) into tX1
   put round(410 - 290 * tS, 1) into tX2
   put kCorners && tX1 & ",6" && tX2 & ",474" into sPockets
   if sPocketEnt[5] is not empty then Entity.SetPosition sPocketEnt[5], BS.WX(tX1), -2, BS.WZ(6)
   if sPocketEnt[6] is not empty then Entity.SetPosition sPocketEnt[6], BS.WX(tX2), -2, BS.WZ(474)
end BS.MovePockets

------------------------------------------------------------------ input

function BS.Keys
   if sTestKeys is not empty then
      if sTestKeys is 0 then return empty
      return sTestKeys
   end if
   return the keysDown
end BS.Keys

-- a test holds keys: "0" = none; empty = the real keyboard again
on BS.TestKeys pKeys
   put pKeys into sTestKeys
end BS.TestKeys

-- a test moves the mouse on the table: "tableX,tableY,down" ("" = no mouse)
on BS.TestMouse pTXYDown
   put pTXYDown into sTestMouse
   if pTXYDown is empty then put "none" into sTestMouse
end BS.TestMouse

-- "tableX,tableY,down": where the mouse points on the table, or empty
function BS.MouseTable
   local tM, tT, tErr
   if sTestMouse is "none" then return empty
   if sTestMouse is not empty then return sTestMouse
   if sTestKeys is not empty then return empty   -- a test drives: never the owner's mouse
   if gNoMouse is true then return empty
   try
      put Engine.Mouse() into tM
   catch tErr
      return empty
   end try
   if tM is empty then return empty
   put BS.ScreenToTable(item 1 of tM, item 2 of tM) into tT
   if tT is empty then return empty
   return tT & comma & (item 3 of tM)
end BS.MouseTable

-- screen pixels -> the table point under them (Newton's method on Camera.WorldToScreen,
-- as in Nine Ball; both engines have it). A pull can go past the rails, so wide starts.
function BS.ScreenToTable pSX, pSY
   local tStarts, tStart, tT
   if pSX is not a number or pSY is not a number then return empty
   put "410,240 410,60 410,420 100,240 720,240" into tStarts
   if sOnTable[0] then put sX[0] & comma & sY[0] && tStarts into tStarts
   repeat for each word tStart in tStarts
      put BS.Newton(pSX, pSY, item 1 of tStart, item 2 of tStart) into tT
      if tT is not empty then return tT
   end repeat
   return empty
end BS.ScreenToTable

function BS.Newton pSX, pSY, pX, pY
   local tN, tS0, tSA, tSB, a11, a12, a21, a22, tDet, tEX, tEY, tErr
   repeat with tN = 1 to 8
      try
         put Camera.WorldToScreen(BS.WX(pX), -kR, BS.WZ(pY)) into tS0
         put Camera.WorldToScreen(BS.WX(pX + 10), -kR, BS.WZ(pY)) into tSA
         put Camera.WorldToScreen(BS.WX(pX), -kR, BS.WZ(pY + 10)) into tSB
      catch tErr
         return empty
      end try
      if tS0 is empty or tSA is empty or tSB is empty then return empty
      put pSX - item 1 of tS0 into tEX
      put pSY - item 2 of tS0 into tEY
      if abs(tEX) < 0.25 and abs(tEY) < 0.25 then return round(pX, 2) & comma & round(pY, 2)
      put (item 1 of tSA - item 1 of tS0) / 10 into a11
      put (item 2 of tSA - item 2 of tS0) / 10 into a21
      put (item 1 of tSB - item 1 of tS0) / 10 into a12
      put (item 2 of tSB - item 2 of tS0) / 10 into a22
      put a11 * a22 - a12 * a21 into tDet
      if abs(tDet) < 0.000001 then return empty
      add (a22 * tEX - a12 * tEY) / tDet to pX
      add (a11 * tEY - a21 * tEX) / tDet to pY
      put max(-kW, min(2 * kW, pX)) into pX
      put max(-kH, min(2 * kH, pY)) into pY
   end repeat
   if abs(tEX) < 2 and abs(tEY) < 2 then return round(pX, 2) & comma & round(pY, 2)
   return empty
end BS.Newton

function BS.Pressed pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys and tC is not among the items of sKeysWas then return true
   end repeat
   return false
end BS.Pressed

function BS.Held pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys then return true
   end repeat
   return false
end BS.Held

------------------------------------------------------------------ the frame

on Game.OnUpdate
   local tKeys, tM, tDown, tClick, tStep, tTurn, tGo
   add 1 to sTicks
   put BS.Keys() into tKeys
   put BS.MouseTable() into tM
   put (item 3 of tM is "true") into tDown
   put tDown and not sMouseWas into tClick
   put BS.Pressed(tKeys, "32,65293,65421") or tClick into tGo
   BS.MovePockets
   if BS.Pressed(tKeys, "114,82") and sMode is not "title" then   -- R: this table again
      put sScoreAtStart into sScore
      BS.Table sLevel
   else if BS.Pressed(tKeys, "99,67") then      -- C: the other view
      put not sTopView into sTopView
      BS.Camera
      if sLabelsOn then BS.Labels true
      put empty into sHUDWas
   end if
   if sMode is "title" then
      if tGo then
         put 0 into sScore
         BS.Table 1
         put true into sMouseWas
      end if
   else if sMode is "clear" then
      if tGo then
         BS.Table sLevel + 1
         put true into sMouseWas
      end if
   else if sMode is "over" then
      if tGo then
         put sScoreAtStart into sScore
         BS.Table sLevel
         put true into sMouseWas
      end if
   else if sMode is "won" then
      if tGo then
         put 0 into sScore
         BS.Table 1
         put true into sMouseWas
      end if
   else if sMode is "moving" then
      repeat with tStep = 1 to kSteps
         if BS.AllStopped() then
            BS.EndShot
            exit repeat
         end if
         BS.Step
      end repeat
      if sMode is "moving" then
         BS.MoveEntities
      end if
   else
      -- aiming: the keys
      put 0.02 into tTurn
      if BS.Held(tKeys, "65505,65506") then put 0.004 into tTurn
      if BS.Held(tKeys, "65361,97,65") then subtract tTurn from sAim
      if BS.Held(tKeys, "65363,100,68") then add tTurn to sAim
      if BS.Held(tKeys, "65362,119,87") then put min(kMaxPower, sPower + 0.2) into sPower
      if BS.Held(tKeys, "65364,115,83") then put max(0.5, sPower - 0.2) into sPower
      -- aiming: the slingshot pull. The ball goes AWAY from the mouse.
      if tDown and item 1 of tM is a number and sOnTable[0] then
         put true into sDrag
         if BS.Dist(sX[0], sY[0], item 1 of tM, item 2 of tM) > 2 then
            put BS.LineAngle(item 1 of tM, item 2 of tM, sX[0], sY[0]) into sAim
            put min(kMaxPower, BS.Dist(sX[0], sY[0], item 1 of tM, item 2 of tM) / 25) into sPower
         end if
      end if
      if sDrag and not tDown then
         put false into sDrag
         if sPower >= 0.5 then
            BS.Shoot sAim, sPower
         end if
      else if BS.Pressed(tKeys, "32,65293,65421") then
         BS.Shoot sAim, sPower
      end if
      if sMode is "aim" then BS.ShowAim
   end if
   put tKeys into sKeysWas
   put tDown into sMouseWas
   BS.ShowHUD
end Game.OnUpdate

on BS.MoveEntities
   local i
   repeat with i = 0 to sCount
      if not sOnTable[i] or sBall[i] is empty then next repeat
      add sVY[i] * kSteps / kR to sRotX[i]
      subtract sVX[i] * kSteps / kR from sRotZ[i]
      Entity.SetPosition sBall[i], BS.WX(sX[i]), -kR, BS.WZ(sY[i])
      Entity.SetRotation sBall[i], sRotX[i], 0, sRotZ[i]
   end repeat
end BS.MoveEntities

-- the aim: yellow dots = the pull behind the ball (the slingshot band); white dots = where
-- it goes, bounced once or more off the outer cushions (a bank shot guide; it does not
-- see balls, bumpers or blocks)
on BS.ShowAim
   local n, tX, tY, tLen, tD, tColor, tDX, tDY, tLo, tHiX, tHiY, tStep
   if not sOnTable[0] then exit BS.ShowAim
   -- nothing changed since the last frame: the dots stay where they are
   if sDot is not empty and sAimWas is (sAim & comma & sPower & comma & sX[0] & comma & sY[0]) then exit BS.ShowAim
   put sAim & comma & sPower & comma & sX[0] & comma & sY[0] into sAimWas
   if sDot is empty then
      repeat with n = 1 to kDots
         put "white" into tColor
         if n <= kPull then put "#FFE040" into tColor
         put Entity.Spawn("BS.Dot", BS.WX(sX[0]), -kR, BS.WZ(sY[0]), tColor) into sDot[n]
      end repeat
      BS.Labels true
   end if
   put sPower * 25 into tLen
   put cos(sAim) into tDX
   put sin(sAim) into tDY
   repeat with n = 1 to kPull
      put kR + (tLen - kR) * n / kPull into tD
      Entity.SetPosition sDot[n], BS.WX(sX[0] - tD * tDX), -kR, BS.WZ(sY[0] - tD * tDY)
   end repeat
   -- the guide: steps of 35 from the ball, mirrored at the cushions
   put kCushion + kR into tLo
   put kW - kCushion - kR into tHiX
   put kH - kCushion - kR into tHiY
   put sX[0] into tX
   put sY[0] into tY
   put 35 into tStep
   repeat with n = kPull + 1 to kDots
      add tStep * tDX to tX
      add tStep * tDY to tY
      if tX < tLo then
         put 2 * tLo - tX into tX
         multiply tDX by -1
      else if tX > tHiX then
         put 2 * tHiX - tX into tX
         multiply tDX by -1
      end if
      if tY < tLo then
         put 2 * tLo - tY into tY
         multiply tDY by -1
      else if tY > tHiY then
         put 2 * tHiY - tY into tY
         multiply tDY by -1
      end if
      Entity.SetPosition sDot[n], BS.WX(tX), -kR, BS.WZ(tY)
   end repeat
end BS.ShowAim

on BS.HideAim
   local n
   repeat for each key n in sDot
      Entity.Kill sDot[n]
   end repeat
   put empty into sDot
end BS.HideAim

-- the numbers over the balls (only while they stand still); the next one says so
on BS.Labels pOn
   local i, tS, tText, tErr, tShift
   repeat with i = 1 to 7
      HUD.Remove "BS.N" & i
   end repeat
   put pOn into sLabelsOn
   if not pOn then exit BS.Labels
   repeat with i = 1 to sCount
      if not sOnTable[i] then next repeat
      try
         put Camera.WorldToScreen(BS.WX(sX[i]), -2 * kR - 6, BS.WZ(sY[i])) into tS
      catch tErr
         put empty into tS
      end try
      put i into tText
      put 4 into tShift
      if i is sNext then
         put ">" & i & "<" into tText
         put 10 into tShift
      end if
      if tS is not empty then HUD.Set "BS.N" & i, tText, round(item 1 of tS) - tShift, round(item 2 of tS) - 6, 11
   end repeat
end BS.Labels

------------------------------------------------------------------ the HUD

on BS.ShowHUD
   local tWords, tBottom
   put gViewBottom into tBottom
   if tBottom is not a number or tBottom < 300 then put 600 into tBottom
   put sMode & "|" & sLevel & "|" & sLives & "|" & sScore & "|" & sNext & "|" & round(sPower, 1) & "|" & sMsg & "|" & sTopView into tWords
   if tWords is sHUDWas then exit BS.ShowHUD
   put tWords into sHUDWas
   HUD.Remove "BS.Title"
   HUD.Remove "BS.Credit1"
   HUD.Remove "BS.Credit2"
   HUD.Remove "BS.Credit3"
   HUD.Remove "BS.Start"
   HUD.Set "BS.Credit", "BANK SHOT BOUNCE - TABLE PHYSICS BY JIM HURLEY (FROM SCOTT ROSSI'S NINE BALL)", 20, tBottom - 28, 10
   if sMode is "title" then
      HUD.Set "BS.Title", "BANK SHOT BOUNCE", 200, 150, 30
      HUD.Set "BS.Credit1", "SINK THE NUMBERED BALLS IN ORDER - KEEP YOUR WHITE BALL OUT", 150, 210, 12
      HUD.Set "BS.Credit2", "TABLE PHYSICS BY JIM HURLEY", 230, 235, 14
      HUD.Set "BS.Credit3", "FIVE TABLES: PLAIN, SLICK, BUMPER, SLIDING POCKETS, HOURGLASS", 150, 260, 11
      HUD.Set "BS.Start", "SPACE OR CLICK TO PLAY", 250, 300, 14
      HUD.Remove "BS.Turn"
      HUD.Remove "BS.Msg"
      HUD.Remove "BS.Help"
      exit BS.ShowHUD
   end if
   HUD.Set "BS.Turn", "TABLE" && sLevel && "  LIVES" && sLives && "  SCORE" && sScore && "  NEXT:" && BS.Or(sNext, "-") && "  PULL" && round(sPower, 1), 20, 100, 14
   if sMsg is empty then
      HUD.Remove "BS.Msg"
   else
      HUD.Set "BS.Msg", sMsg, 20, 125, 12
   end if
   if sMode is "clear" then
      HUD.Set "BS.Start", "SPACE OR CLICK: THE NEXT TABLE", 240, 300, 14
   else if sMode is "over" then
      HUD.Set "BS.Start", "SPACE OR CLICK: THIS TABLE AGAIN", 240, 300, 14
   else if sMode is "won" then
      HUD.Set "BS.Start", "SPACE OR CLICK: FROM THE FIRST TABLE", 240, 300, 14
   end if
   HUD.Set "BS.Help", "DRAG BACK FROM YOUR BALL - OR ARROWS AIM  UP/DOWN PULL  SPACE SHOOTS  C VIEW  R TABLE AGAIN", 20, tBottom - 46, 9
end BS.ShowHUD

function BS.Or pA, pB
   if pA is empty then return pB
   return pA
end BS.Or

------------------------------------------------------------------ for tests

-- "mode|table|lives|score|next|on table|sunk last shot|your ball x,y|msg"
function BS.State pWhat
   local i, tOn
   repeat with i = 0 to sCount
      if sOnTable[i] then put i & comma after tOn
   end repeat
   switch pWhat
      case "mode"
         return sMode
      case "aim"
         return round(sAim, 4) & comma & round(sPower, 2)
      case "energy"
         return BS.Energy()
      case "pockets"
         return sPockets
      case "felt"
         return sFriction
      case "ball0"
         return round(sX[0], 1) & comma & round(sY[0], 1)
      case "speed0"
         return round(sqrt(sVX[0] ^ 2 + sVY[0] ^ 2), 3)
   end switch
   return sMode & "|" & sLevel & "|" & sLives & "|" & sScore & "|" & sNext & "|" & char 1 to -2 of tOn & "|" & \
         char 1 to -2 of sSunkNow & "|" & round(sX[0]) & comma & round(sY[0]) & "|" & sMsg
end BS.State

function BS.Energy
   local i, tE
   put 0 into tE
   repeat with i = 0 to sCount
      if sOnTable[i] then add (sVX[i] ^ 2 + sVY[i] ^ 2) / 2 to tE
   end repeat
   return tE
end BS.Energy

-- a test's own layout on table pLevel: "ball:x,y ball:x,y ..." (only these balls stay)
on BS.TestTable pLevel, pLayout
   local i, tW
   BS.Table pLevel
   BS.HideAim
   repeat with i = 0 to sCount
      put false into sOnTable[i]
      if sBall[i] is not empty then Entity.Kill sBall[i]
      put empty into sBall[i]
   end repeat
   repeat for each word tW in pLayout
      put char 1 to offset(":", tW) - 1 of tW into i
      put char offset(":", tW) + 1 to -1 of tW into sHome[i]
      BS.Spot i
   end repeat
   -- balls left off the layout count as already sunk in order
   repeat with i = 1 to sCount
      if not sOnTable[i] then put true into sScored[i]
   end repeat
   put BS.NextBall() into sNext
   put "aim" into sMode
   put empty into sMsg
   put empty into sHUDWas
end BS.TestTable

on BS.TestLives pN
   put pN into sLives
end BS.TestLives

-- set the pockets' clock (table 4 slides with it)
on BS.TestTicks pN
   put pN into sTicks
   BS.MovePockets
end BS.TestTicks

-- one line a ball on the table: "ball,x,y"
function BS.TestPositions
   local i, tOut
   repeat with i = 0 to sCount
      if sOnTable[i] then put i & comma & sX[i] & comma & sY[i] & cr after tOut
   end repeat
   return char 1 to -2 of tOut
end BS.TestPositions
