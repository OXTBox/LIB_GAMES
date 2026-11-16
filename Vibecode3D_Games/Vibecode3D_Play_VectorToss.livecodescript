######################################################################################
## CARD SCRIPT: "Play.VectorToss"   VECTOR TOSS  (Opus 15 Nov 2026)  PHASE 1: CORE
## PROMPT (cyan) and GLAZE (magenta) face each other across a deep arena, one in each half,
## and toss a ball of vectors back and forth. You play one; the other is your companion.
## First it is only play: slow roof throws (up, the roof, down), nothing to lose. (Walls, breaking floor tiles
## and hang time come in the next phases: LIB_ig3d/GDD_OUTLINE_A88.md.)
## CONTROLS  mouse        a ghost ball on the floor shows where your throw comes down. Hold
##                        the button for power, let go: the ball goes up, hits the ROOF and
##                        comes down on the ghost. Aim past a side bound to bank it off it.
##           W A S D / arrows  run (while you aim)    SPACE  jump (catch higher)
##           C  swap to the companion    E  an easy one    TAB  landing ring on or off
## SCORING   a catch is worth one point for the roof and one for each side bound the ball
##           struck. A ball that touches your floor first is a drop, not a catch.
## LEVELS    (phase 2) every 10 catches a level: from level 2 a wall rises in each half, in
##           front of its hero, and closes in towards the centre level by level. A bounce
##           off the INSIDE of a wall +1, and from one wall's inside straight to the other's
##           +2 more. Heroes can't walk through a wall: SPACE jumps it, into the middle.
## HAZARDS   (phase 3) from level 2 a dropped ball cracks the floor tile it hits; a second
##           hit breaks it (from level 4 one hit does): a hole down into nothing. Step in
##           and you fall. A HANG catches the edge and climbs you out (each hero starts
##           with one, +1 every 10 points); with none, the fall costs 3 points and you come
##           back at your spot. A ball that falls in is a drop. Each new level mends the floor.
## THE END   a hero's third fatal fall (no hang to catch it) ends the game. ENTER or R: again.
## BANTER    the heroes talk: VectorToss/banter.txt (event, who, then "P line | G line").
## MOVES     Animations/VectorToss.anims.txt (throw, lob, catch), cut from LIB_MOCAP clips
##           with the editor's Window > Inspector > Animation page.
## NEEDS     ../LIB_MOCAP/library (clips) and ../LIB_MOCAP/livecode/anim_list.livecodescript
######################################################################################

global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch
global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPaused, bPlaying
global gNoMouse

constant kM = 30              -- engine units a metre: the heroes are about 52 tall
constant kHalfW = 360         -- the arena runs x -360..360 (PROMPT's half is x < 0)
constant kHalfD = 160         -- and z -160..160 (deep: room to run)
constant kTop = 300           -- the ceiling (top bound) height
constant kTile = 40           -- floor tiles (phase 3 breaks them)
constant kMid = 22            -- heroes keep this far from the centre line
constant kHeroR = 12          -- a hero's body, for the bounds
constant kRunSpeed = 5.2      -- units a step
constant kBallR = 8
constant kGrav = 0.16         -- units a step a step (owner: slower ball, high arcs)
constant kBounce = 0.62       -- floor bounce keeps this much of the fall
constant kFloorDrag = 0.86    -- each floor bounce keeps this much of the run
constant kRollDrag = 0.95     -- rolling, a step
constant kBackLoss = 0.85     -- the back bounds
constant kRollV = 0.8         -- slower falls than this stop bouncing and roll
constant kCatchR = 22         -- catch reach around a hero, across the floor
constant kReach = 78          -- and up
constant kHandH = 44          -- the ball sits here while held
constant kRoofPower = 3.2     -- full power adds this much upward speed: off the roof faster
constant kHeroGrav = 0.3      -- the heroes' jumps
constant kJumpV = 4.6         -- a jump peaks about 35 high: the walls stay lower
constant kLevelCatches = 10   -- catches a level
constant kFallCost = 3        -- points a fall costs with no hang left
constant kMaxFalls = 3        -- the third fatal fall (no hang) ends the game
constant kHangEvery = 10      -- a new hang every this many points
constant kAIWait = 40         -- the companion holds the ball this many steps
constant kCamUp = 230         -- camera height
constant kCamBack = 170       -- behind the front bound
constant kPromptColor = "#40E0FF"
constant kGlazeColor = "#FF60D0"
constant kBallColor = "#FFFFFF"
-- LIB_MOCAP clips (library/<name>/<name>_stick.txt); the throw, lob and catch come from the
-- game's animation list
constant kPromptIdle = "Animazoo_hands_on_hips"
constant kGlazeIdle = "Animazoo_talking_gesturing"
constant kRun = "Animazoo_Running_-_Jog"
constant kMaxIdleFrames = 300
constant kActs = "throw,lob,catch,jump"

local sStepMS = 33, sTicks = 0, sError
local sClip          -- [key][frames|fps|travel]; meshes "VT.<key>.<n>"; keys idleP idleG run throw lob catch
local sHero          -- [PROMPT|GLAZE][key|x|z|yaw|speed|mdx|mdz|anim|frame|act|side|idle|score|catches|color]
local sActive        -- the hero you play
local sBall          -- [key|shadow|state (held|loose)|by|x|h|z|vx|vh|vz|air|age|thrower|crossed|banks|tops|backs|floors|peak|touched|easy|hit]
local sCharging, sPower, sAimX, sAimZ, sLandX, sLandZ, sShowLand, sTestAim, sTestMouse
local sLevel, sLevelCatches, sTosses   -- tosses finished this level: the instructions stay for two
local sWallX, sWallH, sWallXTo, sWallHTo, sWall, sWallMesh   -- the walls: x of each (+/-), height
local sGhostKey, sGhostAt, sOver
local sTile, sTileKey   -- [col,row]: hits left (empty = whole, 0 = a hole); its crack / hole entity
local sKeyWas, sTestKeys, sTestAuto
local sRally, sBestRally, sPlayerDrops, sHoldUntil
local sPlan          -- the companion's plan: [name][at|x|z]
local sGhost, sMark
local sMsg, sMsgUntil
local sBanter, sLastEx, sTalk, sTalkNext, sTalkClearAt, sLastTalk, sSaid

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   put Engine.Info("stepMS") into sStepMS
   if sStepMS is not a number then put 33 into sStepMS
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sTicks
   put empty into sError
   put empty into sTestKeys
   put empty into sKeyWas
   put empty into sSaid
   VT.LoadClips
   if sError is not empty then
      HUD.Set "VT.Err", sError, gViewLeft + 20, gViewTop + 120, 14
      exit Game.OnStart
   end if
   VT.LoadBanter
   VT.NewMatch
end Game.OnStart

on Game.OnUpdate
   if sError is not empty then exit Game.OnUpdate
   add 1 to sTicks
   if sOver then
      VT.OverKeys
      exit Game.OnUpdate
   end if
   VT.Levels
   VT.Controls
   VT.Companion
   VT.BallStep
   VT.Animate "PROMPT"
   VT.Animate "GLAZE"
   VT.Preview
   VT.TalkTick
   VT.ShowHUD
end Game.OnUpdate

on Game.OnClick pX,pY,pButton
end Game.OnClick

on Game.OnKill pKey,pX,pY,pZ
end Game.OnKill

on Game.OnPause
end Game.OnPause

on Game.OnResume
end Game.OnResume

on Game.OnStop
   HUD.Clear
end Game.OnStop

on Collision.Hit pA,pB
end Collision.Hit

-------------------------------------------------------------------- loading

-- idles and the run straight from LIB_MOCAP; throw, lob and catch through the game's
-- animation list (name TAB clip TAB in TAB out TAB loop), so the owner re-cuts them in the
-- Inspector without touching this script
on VT.LoadClips
   local tFile, tLib, tList, tA, tName
   put empty into sClip
   VT.LoadClip "idleP", kPromptIdle, 1, kMaxIdleFrames
   VT.LoadClip "idleG", kGlazeIdle, 1, kMaxIdleFrames
   VT.LoadClip "run", kRun, empty, empty
   if sError is not empty then exit VT.LoadClips
   put VT.FindFile("LIB_MOCAP/livecode/anim_list.livecodescript") into tLib
   put VT.FindFile("LIB_GAMES/Vibecode3D_Games/Animations/VectorToss.anims.txt") into tList
   if tLib is empty or tList is empty then exit VT.LoadClips      -- no list: idles stand in
   start using stack tLib
   put Anims.Read(tList) into tA
   repeat for each item tName in kActs
      if tA[tName]["clip"] is empty then next repeat
      VT.LoadClip tName, tA[tName]["clip"], tA[tName]["in"], tA[tName]["out"]
      put empty into sError     -- a missing act clip only costs that move
   end repeat
end VT.LoadClips

-- frames pFrom..pTo of a stick clip as engine meshes "VT.<key>.<n>"; empty pFrom: the clip's
-- own cycle when it has one (walks, runs), else up to kMaxIdleFrames
on VT.LoadClip pKey, pName, pFrom, pTo
   local tFile, tText, tLine, tEdges, tFrame, tKept, tM, tV, i, tJoints, tE, tA, tB
   put VT.FindFile("LIB_MOCAP/library/" & pName & "/" & pName & "_stick.txt") into tFile
   if tFile is empty then
      put "VECTOR TOSS: NO CLIP " & toUpper(pName) & " IN LIB_MOCAP/LIBRARY" into sError
      exit VT.LoadClip
   end if
   put textDecode(url ("binfile:" & tFile), "UTF-8") into tText
   replace numToCodepoint(13) with empty in tText
   if pFrom is empty then
      put 1 into pFrom
      put kMaxIdleFrames into pTo
      put lineOffset(return & "cycle,", return & tText) into i
      if i > 0 then
         set the itemDel to comma
         put item 2 of line i of tText into pFrom
         put item 3 of line i of tText into pTo
      end if
   end if
   put 0 into tFrame
   put 0 into tKept
   repeat for each line tLine in tText
      if tLine is empty or char 1 of tLine is "#" then next repeat
      set the itemDel to comma
      switch item 1 of tLine
         case "fps"
            put item 2 of tLine into sClip[pKey]["fps"]
            break
         case "travel"
            if sClip[pKey]["travel"] is empty then put item 2 of tLine into sClip[pKey]["travel"]
            break
         case "cycle_travel"
            put item 2 of tLine into sClip[pKey]["travel"]
            break
         case "joints"
            put item 2 of tLine into tJoints
            break
         case "edges"
            put item 2 of tLine into tEdges
            break
         default
            if char 1 of tLine is "-" or char 1 of tLine is a number then
               add 1 to tFrame
               if tFrame < pFrom or tFrame > pTo then next repeat
               add 1 to tKept
               put tLine into tV
               split tV by comma
               put Mesh.New() into tM
               repeat with i = 0 to tJoints - 1
                  Mesh.AddVertex tM, tV[3 * i + 1] * kM, -tV[3 * i + 2] * kM, tV[3 * i + 3] * kM
               end repeat
               repeat for each word tE in tEdges
                  set the itemDel to "-"
                  put item 1 of tE + 1 into tA
                  put item 2 of tE + 1 into tB
                  set the itemDel to comma
                  Mesh.AddLine tM, tA, tB
               end repeat
               Mesh.Define "VT." & pKey & "." & tKept, tM
            end if
      end switch
   end repeat
   put tKept into sClip[pKey]["frames"]
   if tKept < 1 then put "VECTOR TOSS: CLIP " & toUpper(pName) & " HAS NO FRAMES " & pFrom & "-" & pTo into sError
   if sClip[pKey]["fps"] is not a number then put 30 into sClip[pKey]["fps"]
   if sClip[pKey]["travel"] is not a number then put 0 into sClip[pKey]["travel"]
end VT.LoadClip

-------------------------------------------------------------------- the arena

on VT.NewMatch
   local tName
   Scene.ClearAll
   HUD.Clear
   VT.BuildArena
   VT.Spawn "PROMPT", kPromptColor, -1, "idleP"
   VT.Spawn "GLAZE", kGlazeColor, 1, "idleG"
   put "PROMPT" into sActive
   Mesh.Define "VT.Ball", MeshSphere(kBallR, 4, 7)
   Mesh.Define "VT.Shadow", VT.RingMesh(kBallR + 2, 12)
   Mesh.Define "VT.Dot", VT.DotMesh()
   Mesh.Define "VT.Mark", VT.RingMesh(14, 16)
   put empty into sBall
   put Entity.Spawn("VT.Ball", 0, -kHandH, 0, kBallColor) into sBall["key"]
   SetObjectRotationSpeed sBall["key"], 0.03, 0.05, 0
   put Entity.Spawn("VT.Shadow", 0, -1, 0, "#5A6A80") into sBall["shadow"]
   put Entity.Spawn("VT.Ball", 0, 0, -100000, "#506070") into sGhost
   put Entity.Spawn("VT.Mark", 0, 0, -100000, "#FFD040") into sMark
   put 0 into sRally
   put false into sOver
   put 0 into sBestRally
   put 0 into sPlayerDrops
   put false into sCharging
   put 0 into sPower
   put true into sShowLand
   put 1 into sLevel
   put 0 into sLevelCatches
   put 0 into sTosses
   put 0 into sWallH
   put 0 into sWallHTo
   put kHalfW into sWallX
   put kHalfW into sWallXTo
   put empty into sWallMesh
   put empty into sGhostKey
   put Entity.Spawn("VT.Ball", 0, 0, -100000, "#8090FF") into sWall[-1]
   put Entity.Spawn("VT.Ball", 0, 0, -100000, "#8090FF") into sWall[1]
   put empty into sTile
   put empty into sTileKey
   Mesh.Define "VT.Crack", VT.CrackMesh()
   Mesh.Define "VT.Hole", VT.HoleMesh()
   put empty into sPlan
   put empty into sTalk
   put 0 into sLastTalk
   VT.GiveBall "PROMPT"
   VT.Camera
   VT.Say "start", "*", 100
end VT.NewMatch

-- the floor in tiles (each half tinted its hero's colour), the bounds as a wire box,
-- the centre line
on VT.BuildArena
   local tM, x, z, tA, tB, tSide, tX0, tX1, tY
   repeat for each item tSide in "-1,1"
      put Mesh.New() into tM
      if tSide < 0 then
         put -kHalfW into tX0
         put 0 into tX1
      else
         put 0 into tX0
         put kHalfW into tX1
      end if
      repeat with x = tX0 to tX1 step kTile
         put VT.Line(tM, x, 0, -kHalfD, x, 0, kHalfD) into tA
      end repeat
      repeat with z = -kHalfD to kHalfD step kTile
         put VT.Line(tM, tX0, 0, z, tX1, 0, z) into tA
      end repeat
      Mesh.Define "VT.Floor" & tSide, tM
   end repeat
   get Entity.Spawn("VT.Floor-1", 0, 0, 0, "#1F5A6A")
   get Entity.Spawn("VT.Floor1", 0, 0, 0, "#5A1F55")
   put Mesh.New() into tM
   repeat for each item tY in "0," & kTop
      put VT.Line(tM, -kHalfW, tY, -kHalfD, kHalfW, tY, -kHalfD) into tA
      put VT.Line(tM, kHalfW, tY, -kHalfD, kHalfW, tY, kHalfD) into tA
      put VT.Line(tM, kHalfW, tY, kHalfD, -kHalfW, tY, kHalfD) into tA
      put VT.Line(tM, -kHalfW, tY, kHalfD, -kHalfW, tY, -kHalfD) into tA
   end repeat
   repeat for each item x in -kHalfW & comma & kHalfW
      repeat for each item z in -kHalfD & comma & kHalfD
         put VT.Line(tM, x, 0, z, x, kTop, z) into tA
      end repeat
   end repeat
   Mesh.Define "VT.Bounds", tM
   get Entity.Spawn("VT.Bounds", 0, 0, 0, "#3A4A70")
   put Mesh.New() into tM
   put VT.Line(tM, 0, 0, -kHalfD, 0, 0, kHalfD) into tA
   Mesh.Define "VT.Centre", tM
   get Entity.Spawn("VT.Centre", 0, -1, 0, "#C0D0FF")
end VT.BuildArena

-- a fixed camera behind the front bound and up high: the whole arena, seen at an angle
on VT.Camera
   local tCX, tCY, tCZ, tLY
   put 0 into tCX
   put -kCamUp into tCY
   put -kHalfD - kCamBack into tCZ
   put -36 into tLY
   put 0 into gCameraYaw
   put -atan2(tLY - tCY, -tCZ) into gCameraPitch
   Engine.SetCam -tCX, -tCY, -tCZ
end VT.Camera

-------------------------------------------------------------------- heroes

on VT.Spawn pName, pColor, pSide, pIdle
   put Entity.Spawn("VT." & pIdle & ".1", pSide * kHalfW * 0.55, 0, 0, pColor) into sHero[pName]["key"]
   put pSide * kHalfW * 0.55 into sHero[pName]["x"]
   put 0 into sHero[pName]["z"]
   put pSide into sHero[pName]["side"]
   put -pSide * pi / 2 into sHero[pName]["yaw"]
   put pIdle into sHero[pName]["idle"]
   put "idle" into sHero[pName]["anim"]
   put random(max(1, sClip[pIdle]["frames"])) into sHero[pName]["frame"]
   put empty into sHero[pName]["act"]
   put 0 into sHero[pName]["speed"]
   put 0 into sHero[pName]["h"]
   put 0 into sHero[pName]["vh"]
   put empty into sHero[pName]["state"]
   put 1 into sHero[pName]["hangs"]
   put 0 into sHero[pName]["falls"]
   put false into sHero[pName]["last"]
   put kHangEvery into sHero[pName]["nextHang"]
   put 0 into sHero[pName]["score"]
   put 0 into sHero[pName]["catches"]
   put pColor into sHero[pName]["color"]
end VT.Spawn

function VT.Other pName
   if pName is "PROMPT" then return "GLAZE"
   return "PROMPT"
end VT.Other

-- whose half x is in
function VT.OwnerAt pX
   if pX < 0 then return "PROMPT"
   return "GLAZE"
end VT.OwnerAt

-- move a hero by dx,dz, kept inside its own half
on VT.Move pName, pDX, pDZ
   local tX, tZ, tSide
   if sHero[pName]["state"] is not empty then
      put 0 into pDX
      put 0 into pDZ
   end if
   put sHero[pName]["side"] into tSide
   put sHero[pName]["x"] + pDX into tX
   put sHero[pName]["z"] + pDZ into tZ
   if tSide < 0 then
      put max(-kHalfW + kHeroR, min(-kMid, tX)) into tX
   else
      put max(kMid, min(kHalfW - kHeroR, tX)) into tX
   end if
   put max(-kHalfD + kHeroR, min(kHalfD - kHeroR, tZ)) into tZ
   -- a wall stops you, unless you are over it
   if sWallH > 1 and sHero[pName]["h"] < sWallH then
      if abs(sHero[pName]["x"]) >= sWallX then
         put tSide * max(abs(tX), sWallX + kHeroR) into tX
      else
         put tSide * max(kMid, min(abs(tX), sWallX - kHeroR)) into tX
      end if
   end if
   put tX - sHero[pName]["x"] into sHero[pName]["mdx"]
   put tZ - sHero[pName]["z"] into sHero[pName]["mdz"]
   put sqrt(sHero[pName]["mdx"] ^ 2 + sHero[pName]["mdz"] ^ 2) into sHero[pName]["speed"]
   put tX into sHero[pName]["x"]
   put tZ into sHero[pName]["z"]
end VT.Move

on VT.MoveToward pName, pX, pZ, pSpeed
   local tDX, tDZ, tD
   put pX - sHero[pName]["x"] into tDX
   put pZ - sHero[pName]["z"] into tDZ
   put sqrt(tDX ^ 2 + tDZ ^ 2) into tD
   if tD < 2 then
      VT.Move pName, 0, 0
      exit VT.MoveToward
   end if
   if tD > pSpeed then
      put tDX * pSpeed / tD into tDX
      put tDZ * pSpeed / tD into tDZ
   end if
   VT.Move pName, tDX, tDZ
end VT.MoveToward

-- you: run with the keys while the mouse aims; hold the button for power, let go to throw
on VT.Controls
   local tKeys, tDX, tDZ, tName, tHolds, tDown
   put VT.Keys() into tKeys
   put sActive into tName
   if VT.Pressed(tKeys, "99,67") then
      VT.Swap
      put sActive into tName
   end if
   if VT.Pressed(tKeys, "65289") then put not sShowLand into sShowLand
   if sTestAuto is true then
      put tKeys into sKeyWas
      exit VT.Controls
   end if
   if VT.Pressed(tKeys, "32") then VT.Jump tName
   put 0 into tDX
   put 0 into tDZ
   if 65361 is among the items of tKeys or 97 is among the items of tKeys or 65 is among the items of tKeys then put -1 into tDX
   if 65363 is among the items of tKeys or 100 is among the items of tKeys or 68 is among the items of tKeys then put 1 into tDX
   if 65362 is among the items of tKeys or 119 is among the items of tKeys or 87 is among the items of tKeys then put 1 into tDZ
   if 65364 is among the items of tKeys or 115 is among the items of tKeys or 83 is among the items of tKeys then put -1 into tDZ
   if tDX is not 0 and tDZ is not 0 then
      VT.Move tName, tDX * kRunSpeed * 0.7071, tDZ * kRunSpeed * 0.7071
   else
      VT.Move tName, tDX * kRunSpeed, tDZ * kRunSpeed
   end if
   put (sBall["state"] is "held" and sBall["by"] is tName) into tHolds
   if tHolds then
      VT.Aim tName
      put VT.MouseDown() into tDown
      if tDown then
         if not sCharging then
            put true into sCharging
            put 0 into sPower
         end if
         put min(1, sPower + 0.025) into sPower
      else if sCharging then
         put false into sCharging
         VT.RoofThrow tName, sAimX, sAimZ, sPower
         put 0 into sPower
      end if
      if sBall["by"] is tName and VT.Pressed(tKeys, "101,69") then
         VT.EasyOne tName
      end if
   else
      put false into sCharging
   end if
   put tKeys into sKeyWas
end VT.Controls

on VT.Jump pName
   if sHero[pName]["h"] is not 0 or sHero[pName]["state"] is not empty then exit VT.Jump
   put kJumpV into sHero[pName]["vh"]
   put 0.01 into sHero[pName]["h"]
   VT.Act pName, "jump"
end VT.Jump

-- where the mouse points on the floor, kept on the partner's half; past a side bound is
-- fine (the throw banks off it)
on VT.Aim pName
   local tXZ, tSide, tX, tZ
   put VT.MouseFloor() into tXZ
   if the number of words of tXZ < 2 then exit VT.Aim
   put word 1 of tXZ into tX
   put word 2 of tXZ into tZ
   put -sHero[pName]["side"] into tSide
   if tX * tSide < kMid * 2 then put tSide * kMid * 2 into tX
   put max(-kHalfW + kBallR + 2, min(kHalfW - kBallR - 2, tX)) into tX
   put max(-3 * kHalfD, min(3 * kHalfD, tZ)) into tZ
   put tX into sAimX
   put tZ into sAimZ
end VT.Aim

function VT.MouseFloor
   if sTestAim is not empty then return sTestAim
   if gNoMouse is true then return empty
   try
      return Engine.ScreenToFloor(the mouseH, the mouseV, 0)
   catch tErr
      return empty
   end try
end VT.MouseFloor

function VT.MouseDown
   if sTestMouse is not empty then return sTestMouse is true
   if gNoMouse is true then return false
   return the mouse is "down"
end VT.MouseDown

-- a key (any of pCodes) went down this step
function VT.Pressed pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys and tC is not among the items of sKeyWas then return true
   end repeat
   return false
end VT.Pressed

on VT.Swap
   put VT.Other(sActive) into sActive
   put false into sCharging
   put empty into sPlan
   VT.Message "YOU ARE " & sActive
   VT.Say "swap", sActive, 60
end VT.Swap

-------------------------------------------------------------------- the ball

-- the hand: in front of the hero, towards the other half
function VT.HandX pName
   return sHero[pName]["x"] - sHero[pName]["side"] * 12
end VT.HandX

on VT.GiveBall pName
   put "held" into sBall["state"]
   put pName into sBall["by"]
   put VT.HandX(pName) into sBall["x"]
   put kHandH into sBall["h"]
   put sHero[pName]["z"] into sBall["z"]
   -- the ghost starts on the partner
   put sHero[VT.Other(pName)]["x"] into sAimX
   put sHero[VT.Other(pName)]["z"] into sAimZ
   put false into sCharging
   put 0 into sPower
   put sTicks + kAIWait into sHoldUntil
   put empty into sPlan
end VT.GiveBall

-- a throw's velocity from power (0..1), arc (radians up) and sideways aim (radians)
-- how many steps a roof throw with upward speed pVH stays up (until it first touches the
-- floor): the same vertical steps as VT.Advance
function VT.RoofSteps pVH
   local tH, n
   put kHandH into tH
   put 0 into n
   repeat 600 times
      add 1 to n
      subtract kGrav from pVH
      add pVH to tH
      if tH > kTop - kBallR then
         put 2 * (kTop - kBallR) - tH into tH
         put -abs(pVH) into pVH
      end if
      if tH <= kBallR then exit repeat
   end repeat
   return n
end VT.RoofSteps

-- the upward speed of a roof throw at power 0..1: always enough to reach the roof
function VT.RoofVH pPower
   return sqrt(2 * kGrav * (kTop - kBallR - kHandH)) + 0.5 + pPower * kRoofPower
end VT.RoofVH

-- the velocity "vx,vh,vz" that takes the ball from pName's hand off the roof and down on
-- x,z (a z past a side bound banks off it)
function VT.RoofVelocity pName, pX, pZ, pPower
   local tVH, n
   put VT.RoofVH(pPower) into tVH
   put VT.RoofSteps(tVH) into n
   return ((pX - VT.HandX(pName)) / n) & comma & tVH & comma & ((pZ - sHero[pName]["z"]) / n)
end VT.RoofVelocity

-- a z past a side bound folded back the way the ball bounces
function VT.Fold pZ
   local tLim
   put kHalfD - kBallR into tLim
   repeat 4 times
      if pZ > tLim then
         put 2 * tLim - pZ into pZ
      else if pZ < -tLim then
         put -2 * tLim - pZ into pZ
      end if
   end repeat
   return pZ
end VT.Fold

on VT.RoofThrow pName, pX, pZ, pPower
   VT.Launch pName, VT.RoofVelocity(pName, pX, pZ, pPower), false
   VT.Act pName, "throw"
end VT.RoofThrow

-- the ball leaves pName's hand with velocity "vx,vh,vz"
on VT.Launch pName, pVel, pEasy
   put "loose" into sBall["state"]
   put pName into sBall["thrower"]
   put empty into sBall["by"]
   put VT.HandX(pName) into sBall["x"]
   put kHandH + sHero[pName]["h"] into sBall["h"]
   put sHero[pName]["z"] into sBall["z"]
   set the itemDel to comma
   put item 1 of pVel into sBall["vx"]
   put item 2 of pVel into sBall["vh"]
   put item 3 of pVel into sBall["vz"]
   put true into sBall["air"]
   put false into sBall["crossed"]
   put 0 into sBall["age"]
   put 0 into sBall["banks"]
   put 0 into sBall["tops"]
   put 0 into sBall["backs"]
   put 0 into sBall["inside"]
   put 0 into sBall["pingpong"]
   put empty into sBall["lastWall"]
   put 0 into sBall["floors"]
   put kHandH into sBall["peak"]
   put empty into sBall["touched"]
   put (pEasy is true) into sBall["easy"]
   put empty into sPlan
   VT.PredictLand
end VT.Launch

-- where the loose ball first comes down (the landing ring)
on VT.PredictLand
   local tB, i
   put sBall into tB
   put empty into sLandX
   if tB["touched"] is not empty then exit VT.PredictLand
   repeat with i = 1 to 400
      VT.Advance tB
      if tB["floors"] > sBall["floors"] then
         put tB["x"] into sLandX
         put tB["z"] into sLandZ
         exit repeat
      end if
   end repeat
end VT.PredictLand

-- an easy one: a slow lob that comes down right on the partner's hands
on VT.EasyOne pName
   local tOther, tT, tVX, tVH, tVZ
   put VT.Other(pName) into tOther
   put 70 into tT
   put (VT.HandX(tOther) - VT.HandX(pName)) / tT into tVX
   put (sHero[tOther]["z"] - sHero[pName]["z"]) / tT into tVZ
   put (kHandH - kHandH + kGrav * tT * (tT + 1) / 2) / tT into tVH
   VT.Launch pName, tVX & comma & tVH & comma & tVZ, true
   VT.Act pName, "lob"
   VT.Say "easy", pName, 100
end VT.EasyOne

-- one step of the ball's flight, for the real ball and for every prediction alike.
-- pB["hit"]: side, top, back or floor when it struck one this step
on VT.Advance @pB
   local tAir, tLimZ, tLimX, tOldX, tW
   put pB["air"] into tAir
   put empty into pB["hit"]
   put pB["x"] into tOldX
   subtract kGrav from pB["vh"]
   add pB["vx"] to pB["x"]
   add pB["vh"] to pB["h"]
   add pB["vz"] to pB["z"]
   add 1 to pB["age"]
   put kHalfD - kBallR into tLimZ
   if pB["z"] > tLimZ then
      put 2 * tLimZ - pB["z"] into pB["z"]
      put -abs(pB["vz"]) into pB["vz"]
      add 1 to pB["banks"]
      put "side" into pB["hit"]
   else if pB["z"] < -tLimZ then
      put -2 * tLimZ - pB["z"] into pB["z"]
      put abs(pB["vz"]) into pB["vz"]
      add 1 to pB["banks"]
      put "side" into pB["hit"]
   end if
   put kHalfW - kBallR into tLimX
   if pB["x"] > tLimX then
      put 2 * tLimX - pB["x"] into pB["x"]
      put -abs(pB["vx"]) * kBackLoss into pB["vx"]
      add 1 to pB["backs"]
      put "back" into pB["hit"]
   else if pB["x"] < -tLimX then
      put -2 * tLimX - pB["x"] into pB["x"]
      put abs(pB["vx"]) * kBackLoss into pB["vx"]
      add 1 to pB["backs"]
      put "back" into pB["hit"]
   end if
   -- the walls: a ball crossing one below its top bounces back
   if sWallH > 1 and pB["h"] < sWallH + kBallR then
      repeat for each item tW in "-1,1"
         if (tOldX - tW * sWallX) * (pB["x"] - tW * sWallX) < 0 then
            put 2 * tW * sWallX - pB["x"] into pB["x"]
            put -pB["vx"] * 0.9 into pB["vx"]
            put "wall" into pB["hit"]
            if abs(tOldX) < sWallX then
               -- the inside face: +1, and +2 more straight from the other wall's inside
               add 1 to pB["inside"]
               if pB["lastWall"] is -tW then add 1 to pB["pingpong"]
               put tW into pB["lastWall"]
            end if
            exit repeat
         end if
      end repeat
   end if
   if pB["h"] > kTop - kBallR then
      put 2 * (kTop - kBallR) - pB["h"] into pB["h"]
      put -abs(pB["vh"]) into pB["vh"]
      add 1 to pB["tops"]
      put "top" into pB["hit"]
   end if
   if pB["h"] <= kBallR and pB["h"] > kBallR - 12 and VT.Solid(pB["x"], pB["z"]) then
      put kBallR into pB["h"]
      if pB["vh"] < -kRollV then
         put -pB["vh"] * kBounce into pB["vh"]
         multiply pB["vx"] by kFloorDrag
         multiply pB["vz"] by kFloorDrag
      else
         put 0 into pB["vh"]
         multiply pB["vx"] by kRollDrag
         multiply pB["vz"] by kRollDrag
      end if
      if tAir then
         add 1 to pB["floors"]
         put "floor" into pB["hit"]
      end if
      put false into pB["air"]
   else
      put true into pB["air"]
   end if
   put max(pB["peak"], pB["h"]) into pB["peak"]
end VT.Advance

on VT.BallStep
   local tName, tOwner
   if sBall["state"] is "held" then
      put sBall["by"] into tName
      put VT.HandX(tName) into sBall["x"]
      put kHandH + sHero[tName]["h"] into sBall["h"]
      put sHero[tName]["z"] into sBall["z"]
   else
      VT.Advance sBall
      if sBall["hit"] is not empty and sBall["hit"] is not "floor" then VT.PredictLand
      if sBall["x"] * sHero[sBall["thrower"]]["side"] < 0 then put true into sBall["crossed"]
      if sBall["hit"] is "floor" and sBall["touched"] is empty then
         put VT.OwnerAt(sBall["x"]) into tOwner
         put tOwner into sBall["touched"]
         put empty into sLandX
         if tOwner is sBall["thrower"] and not sBall["crossed"] then
            put 0 into sRally
            add 1 to sTosses
            VT.Say "wild", tOwner, 70
         else
            VT.Drop tOwner
            VT.HitTile sBall["x"], sBall["z"]
         end if
      end if
      if sBall["h"] < -160 then
         VT.BallLost
         exit VT.BallStep
      end if
      if sBall["age"] > 3 then
         repeat for each item tName in "PROMPT,GLAZE"
            if VT.CanCatch(tName) then
               VT.Catch tName
               exit repeat
            end if
         end repeat
      end if
   end if
   SetObjectPosition sBall["key"], sBall["x"], -sBall["h"], sBall["z"]
   SetObjectPosition sBall["shadow"], sBall["x"], -1, sBall["z"]
end VT.BallStep

function VT.CanCatch pName
   if sBall["h"] > kReach + sHero[pName]["h"] or sBall["h"] < sHero[pName]["h"] - 6 then return false
   if (sBall["x"] - sHero[pName]["x"]) ^ 2 + (sBall["z"] - sHero[pName]["z"]) ^ 2 > kCatchR ^ 2 then return false
   if pName is sBall["thrower"] and not sBall["crossed"] and sBall["touched"] is empty then return false
   -- the companion lets a ball go by when it waits for it after a bounce, worth more
   if (pName is not sActive or sTestAuto is true) and sBall["touched"] is empty and sPlan[pName]["score"] > sBall["banks"] + sBall["tops"] then return false
   return true
end VT.CanCatch

-- what a catch is worth: a bounce off a side bound or the ceiling +1 each, a high lob +1
-- what a catch is worth: the roof +1, each side bound +1
-- what a catch is worth: the roof +1, each side bound +1, each wall inside +1, wall to wall +2
function VT.CatchPoints
   if sBall["easy"] then return 0
   return sBall["banks"] + sBall["tops"] + sBall["inside"] + 2 * sBall["pingpong"]
end VT.CatchPoints

function VT.CatchWhy
   local tWhy
   if sBall["easy"] then return "EASY ONES ARE FREE"
   if sBall["tops"] > 0 then put "ROOF  " after tWhy
   if sBall["banks"] > 0 then put "SIDES " & sBall["banks"] & "  " after tWhy
   if sBall["inside"] > 0 then put "WALL " & sBall["inside"] & "  " after tWhy
   if sBall["pingpong"] > 0 then put "WALL TO WALL " & sBall["pingpong"] after tWhy
   if tWhy is empty then return "NO ROOF, NO POINTS"
   return word 1 to -1 of tWhy
end VT.CatchWhy

on VT.Catch pName
   local tP, tWas
   put sBall["easy"] into tWas
   if sBall["touched"] is not empty then
      -- a pick-up from the floor: no points, no rally
      VT.GiveBall pName
      exit VT.Catch
   end if
   put VT.CatchPoints() into tP
   add tP to sHero[pName]["score"]
   repeat while sHero[pName]["score"] >= sHero[pName]["nextHang"]
      add 1 to sHero[pName]["hangs"]
      add kHangEvery to sHero[pName]["nextHang"]
   end repeat
   add 1 to sHero[pName]["catches"]
   add 1 to sTosses
   add 1 to sLevelCatches
   add 1 to sRally
   put max(sBestRally, sRally) into sBestRally
   if pName is sActive then put 0 into sPlayerDrops
   VT.Act pName, "catch"
   VT.Message pName & "  +" & tP & "   " & VT.CatchWhy()
   VT.GiveBall pName
   if tWas then
      VT.Say "easy_caught", pName, 80
   else if sRally is 5 or (sRally > 0 and sRally mod 10 is 0) then
      VT.Say "rally", "*", 100
   else if tP >= 3 then
      VT.Say "catch_big", pName, 90
   else if tP is 0 then
      VT.Say "catch_flat", pName, 45
   else
      VT.Say "catch_good", pName, 35
   end if
end VT.Catch

on VT.Drop pName
   add 1 to sTosses
   put 0 into sRally
   if pName is sActive then add 1 to sPlayerDrops
   VT.Message pName & " DROPPED IT"
   VT.Say "drop", pName, 60
end VT.Drop

-------------------------------------------------------------------- the companion

-- the hero you don't play: catches, picks up, throws; sTestAuto: both heroes play themselves
on VT.Companion
   local tName
   repeat for each item tName in "PROMPT,GLAZE"
      if tName is sActive and sTestAuto is not true then next repeat
      VT.Think tName
   end repeat
end VT.Companion

on VT.Think pName
   local tHomeX, tSpeed
   if pName is "PROMPT" then
      put kRunSpeed into tSpeed
   else
      put kRunSpeed * 0.92 into tSpeed
   end if
   put sHero[pName]["side"] * kHalfW * 0.55 into tHomeX
   if sBall["state"] is "held" then
      if sBall["by"] is pName then
         VT.Move pName, 0, 0
         if sTicks >= sHoldUntil and (sTalk is empty or sTicks >= sHoldUntil + 90) then
            VT.AIThrow pName
         end if
      else
         VT.MoveToward pName, tHomeX, sHero[pName]["z"] * 0.97, tSpeed * 0.5
      end if
      exit VT.Think
   end if
   -- the ball is loose: is it coming to my half?
   if sBall["age"] < 5 then
      VT.Move pName, 0, 0
      exit VT.Think
   end if
   if sPlan[pName]["at"] is empty or sBall["hit"] is not empty or sTicks - sPlan[pName]["at"] >= 8 then
      VT.Plan pName, tSpeed
      put sTicks into sPlan[pName]["at"]
   end if
   if sPlan[pName]["x"] is a number then
      VT.MoveToward pName, sPlan[pName]["x"], sPlan[pName]["z"], tSpeed
      if sHero[pName]["h"] is 0 and sHero[pName]["speed"] > 0.5 and not VT.Solid(sHero[pName]["x"] + sHero[pName]["mdx"] * 4, sHero[pName]["z"] + sHero[pName]["mdz"] * 4) then
         VT.Jump pName
      end if
      if sWallH > 1 and sHero[pName]["h"] is 0 and abs(abs(sHero[pName]["x"]) - sWallX) < kHeroR + 3 and \
            (abs(sPlan[pName]["x"]) - sWallX) * (abs(sHero[pName]["x"]) - sWallX) < 0 then
         VT.Jump pName
      end if
   else
      VT.MoveToward pName, tHomeX, 0, tSpeed * 0.5
   end if
end VT.Think

-- where pName should stand. A ball in the air: of the points on its half where the ball can
-- be caught and it can get to in time, the one after the most bounces (the catcher gets the
-- points), the earliest of those. A ball already down: the first point it can reach. If
-- none, where the ball first comes down on its half.
on VT.Plan pName, pSpeed
   local tB, i, tD, tBest, tLand, tScore, tBestScore, tDown, tFloors
   put sBall into tB
   put empty into sPlan[pName]["x"]
   put empty into sPlan[pName]["z"]
   put empty into sPlan[pName]["score"]
   put (sBall["touched"] is not empty) into tDown
   put -1 into tBestScore
   put tB["floors"] into tFloors
   repeat with i = 1 to 400
      if i > 1 then VT.Advance tB
      if tB["x"] * sHero[pName]["side"] <= 0 then next repeat
      if not tDown and tB["floors"] > tFloors then
         -- it touches my floor here: nothing later is a catch
         if tLand is empty then put tB["x"] & comma & tB["z"] into tLand
         exit repeat
      end if
      if tB["h"] <= kReach - 8 and tB["h"] > 6 then
         put sqrt((tB["x"] - sHero[pName]["x"]) ^ 2 + (tB["z"] - sHero[pName]["z"]) ^ 2) - kCatchR * 0.6 into tD
         if tD <= pSpeed * i then
            put tB["banks"] + tB["tops"] into tScore
            if tScore > tBestScore then
               put tScore into tBestScore
               put tB["x"] & comma & tB["z"] into tBest
            end if
            if tDown then exit repeat
         end if
         if tLand is empty then put tB["x"] & comma & tB["z"] into tLand
      end if
      if not tB["air"] and abs(tB["vx"]) + abs(tB["vz"]) < 0.2 then
         if tBest is empty then put tB["x"] & comma & tB["z"] into tBest
         exit repeat
      end if
   end repeat
   if tBest is empty then put tLand into tBest
   if tBest is empty then exit VT.Plan
   set the itemDel to comma
   put item 1 of tBest into sPlan[pName]["x"]
   put item 2 of tBest into sPlan[pName]["z"]
   if tBestScore >= 0 then put tBestScore into sPlan[pName]["score"]
end VT.Plan

-- the companion's throw: its own style, tried out first so the partner can catch it.
-- PROMPT throws lower and harder and likes the sides; GLAZE lobs sky high. After two drops in a row by
-- the player, an easy one (no points, all heart).
-- the companion's throw: off the roof, down near the partner. PROMPT throws harder and
-- likes banking off the sides; GLAZE throws soft and sweet. Every throw is tried out first
-- so the partner can catch it. After two drops in a row by the player, an easy one.
on VT.AIThrow pName
   local tTry, tOther, tPower, tX, tZ, tR, tN, tVel, tGot, tPick, tBank, tLim
   put VT.Other(pName) into tOther
   if pName is not sActive and sPlayerDrops >= 2 and sTestAuto is not true then
      put 0 into sPlayerDrops
      VT.EasyOne pName
      exit VT.AIThrow
   end if
   put kHalfD - kBallR into tLim
   repeat with tTry = 1 to 24
      if pName is "PROMPT" then
         put random(50) / 100 into tPower
         put random(100) <= 50 into tBank
      else
         put random(25) / 100 into tPower
         put random(100) <= 20 into tBank
      end if
      put VT.RoofSteps(VT.RoofVH(tPower)) into tN
      -- somewhere the partner can run to in time, a little less as the rally grows
      put tN * kRunSpeed * (0.25 + min(0.35, sRally * 0.02)) into tR
      put sHero[tOther]["x"] + (random(201) - 101) / 100 * tR into tX
      put sHero[tOther]["z"] + (random(201) - 101) / 100 * tR into tZ
      put max(kMid * 2, min(kHalfW - 20, tX * sHero[tOther]["side"])) * sHero[tOther]["side"] into tX
      put max(-tLim + 4, min(tLim - 4, tZ)) into tZ
      if tBank then
         if tZ > 0 then
            put 2 * tLim - tZ into tZ
         else
            put -2 * tLim - tZ into tZ
         end if
      end if
      put VT.RoofVelocity(pName, tX, tZ, tPower) into tVel
      put VT.Catchable(pName, tVel) into tGot
      if tGot is empty then next repeat
      put tVel into tPick
      exit repeat
   end repeat
   if tPick is empty then
      VT.EasyOne pName
      exit VT.AIThrow
   end if
   VT.Launch pName, tPick, false
   VT.Act pName, "throw"
end VT.AIThrow

-- can the partner catch a throw from pName with velocity pVel? Empty: no; else its banks.
-- A fair throw comes down to catching height on the partner's half before touching it,
-- somewhere the partner can run to in time
function VT.Catchable pName, pVel
   local tB, i, tOther, tD
   put VT.Other(pName) into tOther
   put VT.HandX(pName) into tB["x"]
   put kHandH into tB["h"]
   put sHero[pName]["z"] into tB["z"]
   set the itemDel to comma
   put item 1 of pVel into tB["vx"]
   put item 2 of pVel into tB["vh"]
   put item 3 of pVel into tB["vz"]
   put true into tB["air"]
   put 0 into tB["banks"]
   put 0 into tB["tops"]
   put 0 into tB["floors"]
   put kHandH into tB["peak"]
   repeat with i = 1 to 400
      VT.Advance tB
      if tB["floors"] > 0 then return empty
      if tB["x"] * sHero[tOther]["side"] > kMid and tB["h"] <= kReach - 14 and tB["h"] > 12 then
         put sqrt((tB["x"] - sHero[tOther]["x"]) ^ 2 + (tB["z"] - sHero[tOther]["z"]) ^ 2) into tD
         if tD <= kRunSpeed * 0.8 * i + kCatchR * 0.5 then return tB["banks"] + tB["tops"]
      end if
   end repeat
   return empty
end VT.Catchable

-------------------------------------------------------------------- the aim preview

-- while you hold the ball: dots along the throw's path until it first touches the floor,
-- and a ring where it lands
-- the ghost ball where your throw will come down (while you hold the ball); the landing
-- ring under it, and under where a loose ball will first come down (TAB: on or off)
-- the ghost ball where your throw will come down (while you hold the ball); the landing
-- ring under it, and under where a loose ball will first come down (TAB: on or off)
on VT.Preview
   local tLX, tLZ, tXZ
   if sBall["state"] is "held" and sBall["by"] is sActive and sTestAuto is not true and sAimX is a number then
      put VT.GhostLand() into tXZ
      put item 1 of tXZ into tLX
      put item 2 of tXZ into tLZ
      SetObjectPosition sGhost, tLX, -kBallR, tLZ
   else
      SetObjectPosition sGhost, 0, 0, -100000
      if sBall["state"] is "loose" and sShowLand and sLandX is a number then
         put sLandX into tLX
         put sLandZ into tLZ
      end if
   end if
   if tLX is empty then
      SetObjectPosition sMark, 0, 0, -100000
   else
      SetObjectPosition sMark, tLX, -1, tLZ
   end if
end VT.Preview

-- where your throw really comes down: with no walls, the aim folded off the sides; with
-- walls, the flight played out (kept until the aim, the power or the walls change)
function VT.GhostLand
   local tKey, tB, tVel, i
   if sWallH <= 1 then return sAimX & comma & VT.Fold(sAimZ)
   put round(sAimX) & "," & round(sAimZ) & "," & round(sPower * 20) & "," & round(sWallX) & "," & round(sWallH) & "," & round(sHero[sActive]["x"] / 4) & "," & round(sHero[sActive]["z"] / 4) into tKey
   if tKey is sGhostKey then return sGhostAt
   put VT.RoofVelocity(sActive, sAimX, sAimZ, sPower) into tVel
   put VT.HandX(sActive) into tB["x"]
   put kHandH into tB["h"]
   put sHero[sActive]["z"] into tB["z"]
   put item 1 of tVel into tB["vx"]
   put item 2 of tVel into tB["vh"]
   put item 3 of tVel into tB["vz"]
   put true into tB["air"]
   put 0 into tB["floors"]
   repeat with i = 1 to 400
      VT.Advance tB
      if tB["floors"] > 0 then exit repeat
   end repeat
   put tKey into sGhostKey
   put tB["x"] & comma & tB["z"] into sGhostAt
   return sGhostAt
end VT.GhostLand

-------------------------------------------------------------------- animation

-- a one-shot move (throw, lob, catch) plays over whatever the hero was doing
on VT.Act pName, pAct
   if sClip[pAct]["frames"] is not a number or sClip[pAct]["frames"] < 1 then exit VT.Act
   put pAct into sHero[pName]["act"]
   put 1 into sHero[pName]["frame"]
end VT.Act

on VT.Animate pName
   local tKey, tClip, tN, tE, tWant, tRunStep
   put sHero[pName]["key"] into tKey
   if sHero[pName]["act"] is not empty then
      put sHero[pName]["act"] into tClip
      add sClip[tClip]["fps"] * sStepMS / 1000 to sHero[pName]["frame"]
      if sHero[pName]["frame"] >= sClip[tClip]["frames"] + 1 then
         put empty into sHero[pName]["act"]
         put 1 into sHero[pName]["frame"]
         put "idle" into sHero[pName]["anim"]
      end if
   end if
   if sHero[pName]["act"] is empty then
      if sHero[pName]["speed"] > 0.3 then
         if sHero[pName]["anim"] is not "run" then
            put "run" into sHero[pName]["anim"]
            put 1 into sHero[pName]["frame"]
         end if
         put "run" into tClip
         put max(0.5, sClip["run"]["travel"] * kM * sStepMS / 1000) into tRunStep
         add sHero[pName]["speed"] / tRunStep * sClip["run"]["fps"] * sStepMS / 1000 to sHero[pName]["frame"]
      else
         if sHero[pName]["anim"] is not "idle" then
            put "idle" into sHero[pName]["anim"]
            put 1 into sHero[pName]["frame"]
         end if
         put sHero[pName]["idle"] into tClip
         add sClip[tClip]["fps"] * sStepMS / 1000 to sHero[pName]["frame"]
      end if
      put sClip[tClip]["frames"] into tN
      repeat while sHero[pName]["frame"] >= tN + 1
         subtract tN from sHero[pName]["frame"]
      end repeat
   end if
   -- facing: where you run; otherwise the other half (or along the aim while holding)
   if sHero[pName]["speed"] > 0.3 and sHero[pName]["act"] is empty then
      put atan2(sHero[pName]["mdx"], sHero[pName]["mdz"]) into tWant
   else if sBall["state"] is "held" and sBall["by"] is pName and pName is sActive and sAimX is a number then
      put atan2(sAimX - sHero[pName]["x"], VT.Fold(sAimZ) - sHero[pName]["z"]) into tWant
   else
      put -sHero[pName]["side"] * pi / 2 into tWant
   end if
   put VT.TurnToward(sHero[pName]["yaw"], tWant, 0.25) into sHero[pName]["yaw"]
   VT.SetMesh tKey, "VT." & tClip & "." & max(1, trunc(sHero[pName]["frame"]))
   VT.HeroFall pName
   if sHero[pName]["state"] is "hang" and sClip["catch"]["frames"] >= 12 then VT.SetMesh tKey, "VT.catch.12"
   if sHero[pName]["state"] is "hang" then
      -- dangling: a little sway and swing, nothing under the feet
      SetObjectPosition tKey, sHero[pName]["x"] + sin(sTicks * 0.17) * 3, -(sHero[pName]["h"] - abs(sin(sTicks * 0.085)) * 2), sHero[pName]["z"]
      put VT.Euler(sHero[pName]["yaw"], sin(sTicks * 0.17) * 0.14) into tE
   else
      SetObjectPosition tKey, sHero[pName]["x"], -sHero[pName]["h"], sHero[pName]["z"]
      put VT.Euler(sHero[pName]["yaw"], 0) into tE
   end if
   SetObjectRotation tKey, item 1 of tE, item 2 of tE, item 3 of tE
end VT.Animate

function VT.TurnToward pFrom, pTo, pRate
   local tD
   put pTo - pFrom into tD
   repeat while tD > pi
      subtract 2 * pi from tD
   end repeat
   repeat while tD < -pi
      add 2 * pi to tD
   end repeat
   if abs(tD) <= pRate then return pTo
   if tD > 0 then return pFrom + pRate
   return pFrom - pRate
end VT.TurnToward

-------------------------------------------------------------------- banter
-- VectorToss/banter.txt: event TAB who TAB "P line | G line | ..."; who is PROMPT, GLAZE
-- or * (either). P and G say who speaks each turn. Events: start level crack fall hang over catch_good catch_big
-- catch_flat drop wild easy easy_caught rally swap idle. The HUD letters: A-Z 0-9 and
-- : - + . ! / ? , '  (anything else is skipped).

on VT.LoadBanter
   local tFile, tText, tLine, n
   put empty into sBanter
   put VT.FindFile("LIB_GAMES/Vibecode3D_Games/VectorToss/banter.txt") into tFile
   if tFile is not empty then
      put textDecode(url ("binfile:" & tFile), "UTF-8") into tText
      replace numToCodepoint(13) with empty in tText
   end if
   if tText is empty then put VT.DefaultBanter() into tText
   set the itemDel to tab
   repeat for each line tLine in tText
      if tLine is empty or char 1 of tLine is "#" or the number of items of tLine < 3 then next repeat
      put the number of lines of sBanter[item 1 of tLine] + 1 into n
      put item 2 of tLine & tab & item 3 of tLine into line n of sBanter[item 1 of tLine]
   end repeat
end VT.LoadBanter

function VT.DefaultBanter
   return "start" & tab & "*" & tab & "P Ball. Floor. Each other. Catch it before the floor does. | G You make everything sound like a chore list." & return & \
         "catch_flat" & tab & "*" & tab & "P Flat throws score nothing. | G Then I'll throw you a curvy one." & return & \
         "drop" & tab & "*" & tab & "G Down it goes. | P Lucky the floor holds."
end VT.DefaultBanter

-- start an exchange for pEvent about pWho (a hero, or * for either), pChance percent of the
-- time; a fresh exchange waits for the one already playing
on VT.Say pEvent, pWho, pChance
   local tPick, tLine, n, tTurn, tList
   if sTalk is not empty and pEvent is not among the items of "start,level,fall" then exit VT.Say
   if random(100) > pChance then exit VT.Say
   set the itemDel to tab
   repeat for each line tLine in sBanter[pEvent]
      if item 1 of tLine is "*" or item 1 of tLine is pWho or pWho is "*" then put item 2 of tLine & return after tList
   end repeat
   if tList is empty then exit VT.Say
   put the number of lines of tList into n
   put random(n) into tPick
   if n > 1 and line tPick of tList is sLastEx[pEvent] then put tPick mod n + 1 into tPick
   put line tPick of tList into sLastEx[pEvent]
   put empty into sTalk
   set the itemDel to "|"
   repeat for each item tTurn in line tPick of tList
      put word 1 to -1 of tTurn into tTurn
      if word 1 of tTurn is "P" then
         put "PROMPT" & tab & word 2 to -1 of tTurn & return after sTalk
      else if word 1 of tTurn is "G" then
         put "GLAZE" & tab & word 2 to -1 of tTurn & return after sTalk
      end if
   end repeat
   put sTicks into sTalkNext
   VT.Bubble "PROMPT", empty
   VT.Bubble "GLAZE", empty
   put pEvent & ":" & pWho & " " after sSaid
end VT.Say

on VT.TalkTick
   local tTurn
   if sTalk is not empty and sTicks >= sTalkNext then
      put line 1 of sTalk into tTurn
      delete line 1 of sTalk
      set the itemDel to tab
      VT.Bubble item 1 of tTurn, item 2 of tTurn
      put sTicks + round((1300 + 60 * the number of chars of item 2 of tTurn) / sStepMS) into sTalkNext
      put sTalkNext + round(1200 / sStepMS) into sTalkClearAt
      put sTicks into sLastTalk
   else if sTalk is empty and sTalkClearAt is a number and sTicks >= sTalkClearAt then
      VT.Bubble "PROMPT", empty
      VT.Bubble "GLAZE", empty
      put empty into sTalkClearAt
      put sTicks into sLastTalk
   end if
   if sTalk is empty and sTalkClearAt is empty and sTicks - sLastTalk > round(16000 / sStepMS) then
      put sTicks into sLastTalk
      VT.Say "idle", "*", 100
   end if
end VT.TalkTick

-- a speech bubble under the speaker's score: PROMPT's on the left, GLAZE's on the right
on VT.Bubble pName, pText
   local tLines, tWord, tLine, i, tX, tLong, tSize
   put 13 into tSize
   repeat for each word tWord in pText
      if the number of chars of (tLine && tWord) > 26 and tLine is not empty then
         put tLine & return after tLines
         put tWord into tLine
      else if tLine is empty then
         put tWord into tLine
      else
         put tLine && tWord into tLine
      end if
   end repeat
   if tLine is not empty then put tLine after tLines
   put 0 into tLong
   repeat for each line tLine in tLines
      put max(tLong, the number of chars of tLine) into tLong
   end repeat
   repeat with i = 1 to 4
      if i > the number of lines of tLines then
         HUD.Remove "VT.Say." & pName & "." & i
         next repeat
      end if
      if pName is "PROMPT" then
         put gViewLeft + 20 into tX
      else
         put gViewRight - 20 - tLong * tSize into tX
      end if
      HUD.Set "VT.Say." & pName & "." & i, line i of tLines, tX, gViewTop + 66 + (i - 1) * (tSize + 7), tSize
   end repeat
end VT.Bubble

-------------------------------------------------------------------- levels and walls

-- every kLevelCatches catches a level; from level 2 the walls rise, then close in
on VT.Levels
   if sLevelCatches >= kLevelCatches then VT.SetLevel sLevel + 1, false
   -- the walls move towards where the level wants them
   if sWallH is not sWallHTo or sWallX is not sWallXTo then
      if abs(sWallHTo - sWallH) <= 0.4 then
         put sWallHTo into sWallH
      else
         add 0.4 * VT.Sign(sWallHTo - sWallH) to sWallH
      end if
      if abs(sWallXTo - sWallX) <= 1 then
         put sWallXTo into sWallX
      else
         add VT.Sign(sWallXTo - sWallX) to sWallX
      end if
      VT.ShowWalls
   end if
end VT.Levels

function VT.Sign pN
   if pN < 0 then return -1
   return 1
end VT.Sign

-- level pLevel: where the walls stand and how tall (pSnap: at once, for tests)
on VT.SetLevel pLevel, pSnap
   VT.MendFloor
   put pLevel into sLevel
   put 0 into sLevelCatches
   put 0 into sTosses
   if pLevel <= 1 then
      put 0 into sWallHTo
      put kHalfW into sWallXTo
   else
      put min(32, 10 + 7 * pLevel) into sWallHTo
      put max(70, 190 - 35 * pLevel) into sWallXTo
      if sWallX >= kHalfW then put sWallXTo into sWallX    -- a new wall rises where it stands
   end if
   if pSnap then
      put sWallHTo into sWallH
      put sWallXTo into sWallX
   end if
   VT.ShowWalls
   if pLevel > 1 then
      VT.Message "LEVEL " & pLevel
      put empty into sTalk
      VT.Say "level", "*", 100
   end if
end VT.SetLevel

-- the walls drawn at their height (one mesh a 2 units of height, made when first needed)
on VT.ShowWalls
   local tH, tName, tSide
   put 2 * round(sWallH / 2) into tH
   if tH < 2 then
      SetObjectPosition sWall[-1], 0, 0, -100000
      SetObjectPosition sWall[1], 0, 0, -100000
      exit VT.ShowWalls
   end if
   put "VT.Wall." & tH into tName
   if sWallMesh[tH] is empty then
      Mesh.Define tName, VT.WallMesh(tH)
      put true into sWallMesh[tH]
   end if
   repeat for each item tSide in "-1,1"
      VT.SetMesh sWall[tSide], tName
      SetObjectPosition sWall[tSide], tSide * sWallX, 0, 0
   end repeat
end VT.ShowWalls

-- a wall across the arena, pH tall: its outline and an upright every tile
function VT.WallMesh pH
   local tM, z, tA
   put Mesh.New() into tM
   put VT.Line(tM, 0, 0, -kHalfD, 0, 0, kHalfD) into tA
   put VT.Line(tM, 0, pH, -kHalfD, 0, pH, kHalfD) into tA
   repeat with z = -kHalfD to kHalfD step kTile
      put VT.Line(tM, 0, 0, z, 0, pH, z) into tA
   end repeat
   return tM
end VT.WallMesh

-- tests: go to a level now, walls in place
on VT.TestLevel pLevel
   VT.SetLevel pLevel, true
end VT.TestLevel

function VT.WallState
   return sLevel & "," & round(sWallX) & "," & round(sWallH)
end VT.WallState

function VT.BallField pKey
   return sBall[pKey]
end VT.BallField

-- tests: the player's ball leaves the hand with this velocity
on VT.TestLaunch pVX, pVH, pVZ
   VT.Launch sActive, pVX & comma & pVH & comma & pVZ, false
end VT.TestLaunch

-------------------------------------------------------------------- the floor breaks (phase 3)

function VT.TileOf pX, pZ
   return (trunc((pX + kHalfW) / kTile) + 1) & "," & (trunc((pZ + kHalfD) / kTile) + 1)
end VT.TileOf

-- is there floor under x,z?
function VT.Solid pX, pZ
   if abs(pX) >= kHalfW or abs(pZ) >= kHalfD then return true
   return sTile[VT.TileOf(pX, pZ)] is not 0
end VT.Solid

-- a dropped ball hits the floor at x,z: from level 2 it cracks, then breaks
on VT.HitTile pX, pZ
   local tT, tLeft, tC, tR, tX, tZ
   if sLevel < 2 then exit VT.HitTile
   put VT.TileOf(pX, pZ) into tT
   if sTile[tT] is 0 then exit VT.HitTile
   put sTile[tT] into tLeft
   if tLeft is empty then
      if sLevel >= 4 then
         put 1 into tLeft
      else
         put 2 into tLeft
      end if
   end if
   subtract 1 from tLeft
   put tLeft into sTile[tT]
   set the itemDel to comma
   put item 1 of tT into tC
   put item 2 of tT into tR
   put -kHalfW + (tC - 0.5) * kTile into tX
   put -kHalfD + (tR - 0.5) * kTile into tZ
   if sTileKey[tT] is not empty then Entity.Kill sTileKey[tT]
   if tLeft is 0 then
      put Entity.Spawn("VT.Hole", tX, 0, tZ, "#FF5030") into sTileKey[tT]
      VT.Message "THE FLOOR BROKE"
      VT.Say "crack", "*", 50
   else
      put Entity.Spawn("VT.Crack", tX, -1, tZ, "#C08030") into sTileKey[tT]
   end if
end VT.HitTile

on VT.MendFloor
   local tT
   repeat for each key tT in sTileKey
      if sTileKey[tT] is not empty then Entity.Kill sTileKey[tT]
   end repeat
   put empty into sTileKey
   put empty into sTile
end VT.MendFloor

-- the ball fell through: a drop for whoever's half it fell in; they get it back
on VT.BallLost
   local tOwner
   put VT.OwnerAt(sBall["x"]) into tOwner
   if sBall["touched"] is empty then VT.Drop tOwner
   VT.Message "THE PIT TOOK THE BALL"
   VT.GiveBall tOwner
end VT.BallLost

-- jumps, falls into holes, hangs and climbing out
on VT.HeroFall pName
   local tSpot
   switch sHero[pName]["state"]
      case "hang"
         subtract 1 from sHero[pName]["timer"]
         if sHero[pName]["timer"] <= 0 then
            -- climb out onto the nearest whole tile
            put VT.SafeSpot(pName) into tSpot
            put item 1 of tSpot into sHero[pName]["x"]
            put item 2 of tSpot into sHero[pName]["z"]
            put empty into sHero[pName]["state"]
            put 0.01 into sHero[pName]["h"]
            put 3 into sHero[pName]["vh"]
            VT.Act pName, "jump"
         end if
         break
      case "fall"
         subtract kHeroGrav from sHero[pName]["vh"]
         add sHero[pName]["vh"] to sHero[pName]["h"]
         if sHero[pName]["h"] < -48 and sHero[pName]["hangs"] > 0 and sHero[pName]["last"] is not true then
            subtract 1 from sHero[pName]["hangs"]
            put "hang" into sHero[pName]["state"]
            put -56 into sHero[pName]["h"]
            put 0 into sHero[pName]["vh"]
            put round(1500 / sStepMS) into sHero[pName]["timer"]
            put empty into sHero[pName]["act"]
            VT.Message pName & " HANGS ON"
            VT.Say "hang", pName, 80
         else if sHero[pName]["h"] < -160 and sHero[pName]["last"] is not true then
            -- no hang caught it: a fatal fall (climbing out never counts)
            put true into sHero[pName]["last"]
            add 1 to sHero[pName]["falls"]
            if sHero[pName]["falls"] >= kMaxFalls then
               VT.GameOver pName
            end if
         else if sHero[pName]["h"] < -420 then
            VT.Respawn pName
         end if
         break
      default
         if sHero[pName]["h"] is not 0 or sHero[pName]["vh"] is not 0 then
            subtract kHeroGrav from sHero[pName]["vh"]
            add sHero[pName]["vh"] to sHero[pName]["h"]
            if sHero[pName]["h"] <= 0 then
               if VT.Solid(sHero[pName]["x"], sHero[pName]["z"]) then
                  put 0 into sHero[pName]["h"]
                  put 0 into sHero[pName]["vh"]
               else
                  VT.StartFall pName
               end if
            end if
         else if not VT.Solid(sHero[pName]["x"], sHero[pName]["z"]) then
            VT.StartFall pName
         end if
   end switch
end VT.HeroFall

on VT.StartFall pName
   put false into sHero[pName]["last"]
   put "fall" into sHero[pName]["state"]
   put min(0, sHero[pName]["vh"]) into sHero[pName]["vh"]
   put -0.01 into sHero[pName]["h"]
   put 0 into sHero[pName]["speed"]
end VT.StartFall

-- out of hangs: the fall costs points, back at your spot
on VT.Respawn pName
   local tSpot
   put max(0, sHero[pName]["score"] - kFallCost) into sHero[pName]["score"]
   put sHero[pName]["side"] * kHalfW * 0.55 into sHero[pName]["x"]
   put 0 into sHero[pName]["z"]
   put VT.SafeSpot(pName) into tSpot
   put item 1 of tSpot into sHero[pName]["x"]
   put item 2 of tSpot into sHero[pName]["z"]
   put empty into sHero[pName]["state"]
   put 0 into sHero[pName]["h"]
   put 0 into sHero[pName]["vh"]
   VT.Message pName & " FELL   -" & kFallCost
   VT.Say "fall", pName, 100
end VT.Respawn

-- the middle of the nearest whole tile on pName's half, behind its wall
function VT.SafeSpot pName
   local tC, tR, tX, tZ, tD, tBest, tBestD, tSide
   put sHero[pName]["side"] into tSide
   put 1e9 into tBestD
   repeat with tC = 1 to round(2 * kHalfW / kTile)
      put -kHalfW + (tC - 0.5) * kTile into tX
      if tX * tSide < kMid + kHeroR then next repeat
      if sWallH > 1 and abs(tX) < sWallX + kHeroR then next repeat
      repeat with tR = 1 to round(2 * kHalfD / kTile)
         if sTile[tC & "," & tR] is 0 then next repeat
         put -kHalfD + (tR - 0.5) * kTile into tZ
         put (tX - sHero[pName]["x"]) ^ 2 + (tZ - sHero[pName]["z"]) ^ 2 into tD
         if tD < tBestD then
            put tD into tBestD
            put tX & comma & tZ into tBest
         end if
      end repeat
   end repeat
   if tBest is empty then return (tSide * kHalfW * 0.55) & comma & 0
   return tBest
end VT.SafeSpot

-- the third fall: the end
on VT.GameOver pName
   local tMid
   put true into sOver
   put (gViewLeft + gViewRight) / 2 into tMid
   HUD.Remove "VT.Intro1"
   HUD.Remove "VT.Intro2"
   HUD.Remove "VT.Intro3"
   HUD.Set "VT.Over1", "GAME OVER", tMid - 90, gViewTop + 190, 20
   HUD.Set "VT.Over2", pName & " FELL " & kMaxFalls & " TIMES   LEVEL " & sLevel & "   BEST RALLY " & sBestRally, tMid - (30 + the number of chars of (pName & sLevel & sBestRally)) * 6, gViewTop + 226, 12
   HUD.Set "VT.Over3", "PROMPT " & sHero["PROMPT"]["score"] & "   GLAZE " & sHero["GLAZE"]["score"] & "   TOGETHER " & (sHero["PROMPT"]["score"] + sHero["GLAZE"]["score"]), tMid - 200, gViewTop + 248, 12
   HUD.Set "VT.Over4", "ENTER OR R: PLAY AGAIN", tMid - 132, gViewTop + 280, 12
   put empty into sTalk
   VT.Say "over", pName, 100
   VT.TalkTick
end VT.GameOver

-- after the end: ENTER or R starts again
on VT.OverKeys
   local tKeys, tK
   put VT.Keys() into tKeys
   if VT.Pressed(tKeys, "65293,65421,114,82") then
      repeat for each item tK in "VT.Over1,VT.Over2,VT.Over3,VT.Over4"
         HUD.Remove tK
      end repeat
      VT.NewMatch
   else
      VT.TalkTick
   end if
   put tKeys into sKeyWas
end VT.OverKeys

function VT.Over
   return sOver
end VT.Over

-- the falls so far, under each score
function VT.FallsText pName
   return "FALLS " & sHero[pName]["falls"] & " OF " & kMaxFalls
end VT.FallsText

-- the hangs left, as lives triangles
function VT.Hangs pName
   local tOut
   repeat min(5, sHero[pName]["hangs"]) times
      put "^" after tOut
   end repeat
   return tOut
end VT.Hangs

-- a crack across a tile
function VT.CrackMesh
   local tM, tA, k
   put kTile / 2 - 3 into k
   put Mesh.New() into tM
   put VT.Line(tM, -k, 0, -k * 0.6, -k * 0.2, 0, 0) into tA
   put VT.Line(tM, -k * 0.2, 0, 0, k * 0.3, 0, -k * 0.4) into tA
   put VT.Line(tM, k * 0.3, 0, -k * 0.4, k, 0, k * 0.5) into tA
   put VT.Line(tM, -k * 0.2, 0, 0, 0, 0, k) into tA
   return tM
end VT.CrackMesh

-- a hole: a shallow box, the tile's edge and 5 units down (owner: tall pit walls cluttered
-- the view and drew below the arena)
function VT.HoleMesh
   local tM, tA, k, tY
   put kTile / 2 - 1 into k
   put Mesh.New() into tM
   repeat for each item tY in "0,-5"
      put VT.Line(tM, -k, tY, -k, k, tY, -k) into tA
      put VT.Line(tM, k, tY, -k, k, tY, k) into tA
      put VT.Line(tM, k, tY, k, -k, tY, k) into tA
      put VT.Line(tM, -k, tY, k, -k, tY, -k) into tA
   end repeat
   put VT.Line(tM, -k, 0, -k, -k, -5, -k) into tA
   put VT.Line(tM, k, 0, -k, k, -5, -k) into tA
   put VT.Line(tM, k, 0, k, k, -5, k) into tA
   put VT.Line(tM, -k, 0, k, -k, -5, k) into tA
   return tM
end VT.HoleMesh

-- tests
on VT.TestHitTile pX, pZ
   VT.HitTile pX, pZ
end VT.TestHitTile

function VT.SolidAt pX, pZ
   return VT.Solid(pX, pZ)
end VT.SolidAt

function VT.HeroField pName, pKey
   return sHero[pName][pKey]
end VT.HeroField

on VT.TestHangs pName, pN
   put pN into sHero[pName]["hangs"]
end VT.TestHangs

on VT.TestPlaceBall pX, pH, pZ
   put "loose" into sBall["state"]
   put pX into sBall["x"]
   put pH into sBall["h"]
   put pZ into sBall["z"]
   put 0 into sBall["vx"]
   put 0 into sBall["vh"]
   put 0 into sBall["vz"]
   put 10 into sBall["age"]
   put true into sBall["air"]
   put empty into sBall["touched"]
   put sActive into sBall["thrower"]
   put true into sBall["crossed"]
end VT.TestPlaceBall

-------------------------------------------------------------------- HUD

on VT.Message pText
   put pText into sMsg
   put sTicks + round(4500 / sStepMS) into sMsgUntil
end VT.Message

on VT.ShowHUD
   local tBar, i, tScoreG
   HUD.Set "VT.P", "PROMPT " & sHero["PROMPT"]["score"] & " " & VT.Hangs("PROMPT"), gViewLeft + 20, gViewTop + 16, 20
   put VT.Hangs("GLAZE") & " GLAZE " & sHero["GLAZE"]["score"] into tScoreG
   HUD.Set "VT.PF", VT.FallsText("PROMPT"), gViewLeft + 20, gViewTop + 42, 11
   HUD.Set "VT.GF", VT.FallsText("GLAZE"), gViewRight - 20 - the number of chars of VT.FallsText("GLAZE") * 11, gViewTop + 42, 11
   HUD.Set "VT.G", tScoreG, gViewRight - 20 - the number of chars of tScoreG * 20, gViewTop + 16, 20
   HUD.Set "VT.Rally", "LEVEL " & sLevel & "   RALLY " & sRally & "  BEST " & sBestRally, gViewRight - 20 - (34 + the number of chars of (sRally & sBestRally & sLevel)) * 12, gViewBottom - 54, 12
   if sMsgUntil is a number and sTicks < sMsgUntil then
      HUD.Set "VT.Msg", sMsg, (gViewLeft + gViewRight) / 2 - the number of chars of sMsg * 7, gViewBottom - 84, 14
   else
      HUD.Remove "VT.Msg"
   end if
   HUD.Set "VT.Who", "YOU: " & sActive & "   C: SWAP", gViewLeft + 20, gViewBottom - 54, 12
   if sBall["state"] is "held" and sBall["by"] is sActive then
      if sCharging then
         repeat with i = 1 to 16
            if i <= round(sPower * 16) then
               put "+" after tBar
            else
               put "-" after tBar
            end if
         end repeat
         HUD.Set "VT.Help", "POWER " & tBar & "   LET GO: THROW", gViewLeft + 20, gViewBottom - 30, 12
      else
         HUD.Set "VT.Help", "MOUSE: AIM THE GHOST BALL   HOLD THE BUTTON, LET GO: THROW   E: AN EASY ONE", gViewLeft + 20, gViewBottom - 30, 12
      end if
   else
      HUD.Set "VT.Help", "RUN UNDER THE BALL: WATCH ITS SHADOW   W A S D: RUN   SPACE: JUMP   TAB: LANDING RING", gViewLeft + 20, gViewBottom - 30, 12
   end if
   -- the level's instructions stay until two tosses have come down
   if sTosses < 2 then
      VT.Intro
   else
      HUD.Remove "VT.Intro1"
      HUD.Remove "VT.Intro2"
      HUD.Remove "VT.Intro3"
   end if
end VT.ShowHUD

on VT.Intro
   local tA, tB, tC, tMid
   if sLevel <= 1 then
      put "LEVEL 1: PLAY CATCH" into tA
      put "THROW IT OFF THE ROOF: +1   OFF A SIDE TOO: +1 EACH" into tB
      put "AIM PAST A SIDE TO BANK IT   A BALL ON YOUR FLOOR IS A DROP" into tC
   else
      if sLevel is 2 then
         put "LEVEL 2: THE WALLS RISE" into tA
      else
         put "LEVEL " & sLevel & ": THE WALLS CLOSE IN" into tA
      end if
      put "OFF THE INSIDE OF A WALL: +1   WALL TO WALL: +2 MORE" into tB
      put "SPACE: JUMP A WALL TO REACH THE MIDDLE" into tC
   end if
   put (gViewLeft + gViewRight) / 2 into tMid
   HUD.Set "VT.Intro1", tA, tMid - the number of chars of tA * 10, gViewTop + 200, 20
   HUD.Set "VT.Intro2", tB, tMid - the number of chars of tB * 6, gViewTop + 236, 12
   HUD.Set "VT.Intro3", tC, tMid - the number of chars of tC * 6, gViewTop + 256, 12
end VT.Intro

-------------------------------------------------------------------- helpers

function VT.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end VT.Keys

-- tests: hold these keys (0 = none)
on VT.TestKeys pKeys
   put pKeys into sTestKeys
end VT.TestKeys

-- tests: both heroes play themselves
on VT.TestAuto pOn
   put pOn into sTestAuto
end VT.TestAuto

-- tests: put a hero at x,z
on VT.TestPlace pName, pX, pZ
   put pX into sHero[pName]["x"]
   put pZ into sHero[pName]["z"]
   if sBall["state"] is "held" and sBall["by"] is pName then VT.GiveBall pName
end VT.TestPlace

-- tests: the player throws now
-- tests: the player throws off the roof onto x,z now
on VT.TestRoofThrow pX, pZ, pPower
   VT.RoofThrow sActive, pX, pZ, pPower
end VT.TestRoofThrow

-- tests: the mouse points at floor "x z" / the button is down (true/false); empty: the real mouse
on VT.TestAim pXZ
   put pXZ into sTestAim
end VT.TestAim

on VT.TestMouse pDown
   put pDown into sTestMouse
end VT.TestMouse

function VT.HeroH pName
   return sHero[pName]["h"]
end VT.HeroH

-- active | PROMPT score,catches,x,z | GLAZE ... | ball state,by,x,h,z,banks | rally,best | said
function VT.State
   return sActive & "|" & sHero["PROMPT"]["score"] & "," & sHero["PROMPT"]["catches"] & "," & round(sHero["PROMPT"]["x"]) & "," & round(sHero["PROMPT"]["z"]) & \
         "|" & sHero["GLAZE"]["score"] & "," & sHero["GLAZE"]["catches"] & "," & round(sHero["GLAZE"]["x"]) & "," & round(sHero["GLAZE"]["z"]) & \
         "|" & sBall["state"] & "," & sBall["by"] & "," & round(sBall["x"]) & "," & round(sBall["h"]) & "," & round(sBall["z"]) & "," & sBall["banks"] & \
         "|" & sRally & "," & sBestRally & "|" & sSaid
end VT.State

function VT.ClipFrames pKey
   return sClip[pKey]["frames"]
end VT.ClipFrames

-- swap the mesh an object is drawn with (from Antack)
on VT.SetMesh pKey, pMesh
   local tOut, tLine
   if gObjectTransforms[pKey]["mesh"] is pMesh then exit VT.SetMesh
   repeat for each line tLine in gSceneObjects
      if word 2 of tLine is pKey then put pMesh into word 1 of tLine
      put tLine & cr after tOut
   end repeat
   delete the last char of tOut
   put tOut into gSceneObjects
   put pMesh into gObjectTransforms[pKey]["mesh"]
end VT.SetMesh

-- engine rotation angles for a heading (from Antack.Euler; up is -Y)
function VT.Euler pYaw, pPitch
   local tSY, tCY, tSP, tCP
   put sin(pYaw) into tSY
   put cos(pYaw) into tCY
   put sin(pPitch) into tSP
   put cos(pPitch) into tCP
   return atan2(tSP, tCY * tCP) & comma & asin(max(-1, min(1, tSY * tCP))) & comma & atan2(-tSY * tSP, tCY)
end VT.Euler

-- a line from x1,h1,z1 to x2,h2,z2 (heights up) into a wire mesh
function VT.Line @pMesh, pX1, pH1, pZ1, pX2, pH2, pZ2
   local tA, tB
   Mesh.AddVertex pMesh, pX1, -pH1, pZ1
   put the result into tA
   Mesh.AddVertex pMesh, pX2, -pH2, pZ2
   put the result into tB
   Mesh.AddLine pMesh, tA, tB
   return tB
end VT.Line

-- a flat ring on the floor
function VT.RingMesh pR, pN
   local tM, i, tFirst, tA, tB
   put Mesh.New() into tM
   repeat with i = 0 to pN - 1
      Mesh.AddVertex tM, pR * cos(2 * pi * i / pN), 0, pR * sin(2 * pi * i / pN)
      put the result into tB
      if i is 0 then
         put tB into tFirst
      else
         Mesh.AddLine tM, tA, tB
      end if
      put tB into tA
   end repeat
   Mesh.AddLine tM, tA, tFirst
   return tM
end VT.RingMesh

-- a little three-way cross for the aim dots
function VT.DotMesh
   local tM, tA
   put Mesh.New() into tM
   put VT.Line(tM, -2, 0, 0, 2, 0, 0) into tA
   put VT.Line(tM, 0, -2, 0, 0, 2, 0) into tA
   put VT.Line(tM, 0, 0, -2, 0, 0, 2) into tA
   return tM
end VT.DotMesh

-- where a file is (install/LAYOUT.md 5.1): this script's own folder first
-- (LIB_GAMES/Vibecode3D_Games/X/... is <script folder>/X/...), then Vibecode3D Common beside
-- it, then the folders above this stack, and last the owner's projects through WSL (his PC
-- only; the global bNoWSL, a test hook, turns that last one off)
function VT.FindFile pRelPath
   local tPath, tTry, tShort, tDir, tErr
   global bNoWSL
   put pRelPath into tShort
   if tShort begins with "LIB_GAMES/Vibecode3D_Games/" then delete char 1 to 27 of tShort
   set the itemDel to "/"
   -- the script's file, as the launcher or the game player set it on the stack
   put empty into tDir
   try
      put the uScriptFile of (the long owner of me) into tDir
   catch tErr
      put empty into tDir
   end try
   replace "\" with "/" in tDir
   if tDir contains "/" then
      delete item -1 of tDir
      put tDir & "/" & tShort into tTry
      if there is a file tTry then return tTry
      put item 1 to -2 of tDir & "/Vibecode3D Common/" into tTry
      if there is a file (tTry & pRelPath) then return tTry & pRelPath
      if there is a file (tTry & tShort) then return tTry & tShort
   end if
   put the effective filename of this stack into tPath
   replace "\" with "/" in tPath
   repeat 6 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      put tPath & "/" & pRelPath into tTry
      if there is a file tTry then return tTry
   end repeat
   if bNoWSL is true then return empty
   put "//wsl$/Ubuntu/home/igame3d/projects/" & pRelPath into tTry
   if there is a file tTry then return tTry
   put "/home/igame3d/projects/" & pRelPath into tTry
   if there is a file tTry then return tTry
   return empty
end VT.FindFile

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
