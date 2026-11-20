######################################################################################
## CARD SCRIPT: "Play.PhotonBall"   PHOTON BALL  (Opus 20 Nov 2026)  STEP 1: HAND-PLACED
## Vector Toss's arena made dangerous: a copy of Vector Toss (which stays as it is) where the
## floor breaks more every match. PROMPT (cyan) and GLAZE (magenta) still toss a ball of vectors
## off the roof, one in each half; you play one, the other is your companion.
## CONTROLS  mouse        aim the ghost ball, hold the button for power, let go: off the roof
##           W A S D / arrows  run    SPACE  jump (onto a ledge, over a hole)
##           hanging in a hole: SPACE, W or UP climbs out (before your grip gives)
##           C  swap to the companion    E  an easy one    TAB  landing ring on or off
## MATCHES   every 10 catches a new match: the floor is mended and the rule gets worse.
##           1  the ball breaks the square where it first comes down
##           2  every bounce breaks the square under it
##           3  every bounce breaks the square under it and cracks the eight around it
##           4+ every bounce punches a hole under it; the squares around crack, break or fall
##           A BROKEN square holds you while you stand on it. Match 1: it falls apart a few
##           seconds after you step off. From match 2: a moment after you step on. Land on one
##           from a jump: you smash through it, no hang can catch you.
## LLOYD     fall into a hole and you grab the edge (Harold Lloyd's moves, LIB_MOCAP cuts:
##           climb = take hold, hang, recover = haul yourself out). Each hero has hangs (one,
##           +1 every 10 points). STAMINA counts: a tired hero holds on for less time (1.5 s at
##           0, 5 s at 100) and climbs out slower (40% speed at 0).
## WALLS     PhotonBall/walls.cellmap (cellmap height glyphs + slopes, LIB_BIT CELLMAP_V3): ledges
##           that never break (jump up, or walk the ramps), kicker slopes that throw a ball back,
##           a pillar the ball banks off, and flat emblems: the STAR on the far wall is +1 for a
##           bank off it; your own letter on your back wall MENDS a square when a ball hits it.
##           The camera side stays open. Format: PhotonBall/README.md.
## SCORING   a catch: +1 the roof, +1 each side bound, +1 each STAR. A ball on your floor is a drop.
## THE END   a hero's third fatal fall ends the game. ENTER or R: again.
## STAMINA   the hero's own (PromptGlaze/stamina.livecodescript), Vector Toss's rules
##           (VectorToss/STAMINA_NOTE.md), carried over between PROMPT & GLAZE games.
## BANTER    PhotonBall/banter.txt     MOVES  Animations/PhotonBall.anims.txt
## CREDIT    climb, hang and recover are Harold Lloyd's, from the public-domain 1923 film
##           "Safety Last!" (Hal Roach Studios), captured by the owner (LIB_BVH/Harold_Lloyd).
## NEEDS     ../LIB_MOCAP/library (clips) and ../LIB_MOCAP/livecode/anim_list.livecodescript
######################################################################################

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
constant kMatchCatches = 10   -- catches a match (each new match: the floor mended, a worse rule)
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
constant kActs = "throw,lob,catch,jump,climb,hang,recover"
constant kStaminaShowMS = 3000  -- the stamina meter stays this long after a change
constant kStaminaLow = 25       -- and stays up while stamina is below this
constant kCrumbleOffMS = 2500   -- match 1: a broken square you stood on falls this long after you step off
constant kCrumbleOnMS = 1500    -- match 2 on: it falls this long after you step on it
constant kGripMinMS = 1500      -- how long a hero can hang at stamina 0 ...
constant kGripMaxMS = 5000      -- ... and at 100
constant kClimbMinRate = 0.4    -- climbing out plays at this speed at stamina 0 (1 at 100)
constant kAIHangMS = 900        -- the companion climbs out after hanging this long
constant kSmashV = 2            -- landing faster than this on a broken square smashes through it
constant kWallFile = "LIB_GAMES/Vibecode3D_Games/PhotonBall/walls.cellmap"
-- the match rules as lists (LIB_COMFY's dangerous mode rewrites these three lines; these values
-- are the hand-made game): match n plays item n, the last item repeats for every match after it
constant kMatchRules = "1,2,3,4"  -- the floor rule (1-4, see MATCHES above) of match 1, 2, 3...
constant kMatchOffMS = ""         -- per match: ms a broken square falls after you step off (empty: kCrumbleOffMS)
constant kMatchOnMS = ""          -- per match: ms it falls after you step on, rule 2 on (empty: kCrumbleOnMS)

local sStepMS = 33, sTicks = 0, sError
local sClip          -- [key][frames|fps|travel]; meshes "PB.<key>.<n>"; keys idleP idleG run throw lob catch
local sHero          -- [PROMPT|GLAZE][key|x|z|yaw|speed|mdx|mdz|anim|frame|act|side|idle|score|catches|color]
local sActive        -- the hero you play
local sBall          -- [key|shadow|state (held|loose)|by|x|h|z|vx|vh|vz|air|age|thrower|crossed|banks|tops|backs|floors|peak|touched|easy|hit]
local sCharging, sPower, sAimX, sAimZ, sLandX, sLandZ, sShowLand, sTestAim, sTestMouse
local sMatch, sMatchCatches, sTosses   -- tosses finished this level: the instructions stay for two
local sMap          -- the walls file: [cols|rows|cell|hu|step|file|problem], [floor][row][col], [slope][row][col], [design][row][col]
local sFeat         -- ["col,row"] of an arena cell with a feature: block or slope (never breaks)
local sBlocks       -- lines x0,x1,z0,z1,top: the extruded blocks (ledges, the pillar)
local sFeatTop      -- the highest feature top (engine units): lower than this the ball checks them
local sEmblem       -- [n][char|wall|from|to|key]: emblems flat on the walls; [count]
local sStepUp       -- a hero walks up this much (the map's step); more needs a jump
local sCrumble      -- ["col,row"]: the tick a broken square falls apart
local sTileTint     -- ["col,row"]: its blink colour now
local sGhostKey, sGhostAt, sOver
local sTile, sTileKey   -- [col,row]: hits left (empty = whole, 0 = a hole); its crack / hole entity
local sKeyWas, sTestKeys, sTestAuto, sTestFreeze
local sRally, sBestRally, sPlayerDrops, sHoldUntil
local sPlan          -- the companion's plan: [name][at|x|z]
local sGhost, sMark
local sMsg, sMsgUntil
local sBanter, sLastEx, sTalk, sTalkNext, sTalkClearAt, sLastTalk, sSaid
local sStaminaOK     -- true when the shared stamina library is in use (else stamina lives in sHero only)

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
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
   PB.LoadClips
   if sError is not empty then
      HUD.Set "PB.Err", sError, gViewLeft + 20, gViewTop + 120, 14
      exit Game.OnStart
   end if
   PB.LoadWalls
   PB.LoadBanter
   PB.LoadStamina
   PB.NewMatch
end Game.OnStart

on Game.OnUpdate
   if sError is not empty then exit Game.OnUpdate
   add 1 to sTicks
   if sOver then
      PB.OverKeys
      exit Game.OnUpdate
   end if
   PB.Matches
   PB.Controls
   PB.Companion
   PB.BallStep
   PB.Animate "PROMPT"
   PB.Animate "GLAZE"
   PB.FloorTick
   PB.Preview
   PB.TalkTick
   PB.ShowHUD
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
on PB.LoadClips
   local tFile, tLib, tList, tA, tName
   put empty into sClip
   PB.LoadClip "idleP", kPromptIdle, 1, kMaxIdleFrames
   PB.LoadClip "idleG", kGlazeIdle, 1, kMaxIdleFrames
   PB.LoadClip "run", kRun, empty, empty
   if sError is not empty then exit PB.LoadClips
   put Game.FindFile("LIB_MOCAP/livecode/anim_list.livecodescript") into tLib
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/Animations/PhotonBall.anims.txt") into tList
   if tLib is empty or tList is empty then exit PB.LoadClips      -- no list: idles stand in
   start using stack tLib
   put Anims.Read(tList) into tA
   repeat for each item tName in kActs
      if tA[tName]["clip"] is empty then next repeat
      PB.LoadClip tName, tA[tName]["clip"], tA[tName]["in"], tA[tName]["out"]
      put empty into sError     -- a missing act clip only costs that move
   end repeat
end PB.LoadClips

-- frames pFrom..pTo of a stick clip as engine meshes "PB.<key>.<n>"; empty pFrom: the clip's
-- own cycle when it has one (walks, runs), else up to kMaxIdleFrames
on PB.LoadClip pKey, pName, pFrom, pTo
   local tFile, tText, tLine, tEdges, tFrame, tKept, tM, tV, i, tJoints, tE, tA, tB
   put Game.FindFile("LIB_MOCAP/library/" & pName & "/" & pName & "_stick.txt") into tFile
   if tFile is empty then
      put "PHOTON BALL: NO CLIP " & toUpper(pName) & " IN LIB_MOCAP/LIBRARY" into sError
      exit PB.LoadClip
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
               Mesh.Define "PB." & pKey & "." & tKept, tM
            end if
      end switch
   end repeat
   put tKept into sClip[pKey]["frames"]
   if tKept < 1 then put "PHOTON BALL: CLIP " & toUpper(pName) & " HAS NO FRAMES " & pFrom & "-" & pTo into sError
   if sClip[pKey]["fps"] is not a number then put 30 into sClip[pKey]["fps"]
   if sClip[pKey]["travel"] is not a number then put 0 into sClip[pKey]["travel"]
end PB.LoadClip

-------------------------------------------------------------------- the arena

on PB.NewMatch
   local tName
   Scene.ClearAll
   HUD.Clear
   PB.BuildArena
   PB.Spawn "PROMPT", kPromptColor, -1, "idleP"
   PB.Spawn "GLAZE", kGlazeColor, 1, "idleG"
   put "PROMPT" into sActive
   Mesh.Define "PB.Ball", Mesh.Sphere(kBallR, 4, 7)
   Mesh.Define "PB.Shadow", PB.RingMesh(kBallR + 2, 12)
   Mesh.Define "PB.Dot", PB.DotMesh()
   Mesh.Define "PB.Mark", PB.RingMesh(14, 16)
   put empty into sBall
   put Entity.Spawn("PB.Ball", 0, -kHandH, 0, kBallColor) into sBall["key"]
   Entity.SetRotationSpeed sBall["key"], 0.03, 0.05, 0
   put Entity.Spawn("PB.Shadow", 0, -1, 0, "#5A6A80") into sBall["shadow"]
   put Entity.Spawn("PB.Ball", 0, 0, -100000, "#506070") into sGhost
   put Entity.Spawn("PB.Mark", 0, 0, -100000, "#FFD040") into sMark
   put 0 into sRally
   put false into sOver
   put 0 into sBestRally
   put 0 into sPlayerDrops
   put false into sCharging
   put 0 into sPower
   put true into sShowLand
   put 1 into sMatch
   put 0 into sMatchCatches
   put 0 into sTosses
   put empty into sGhostKey
   put empty into sTile
   put empty into sTileKey
   put empty into sCrumble
   put empty into sTileTint
   Mesh.Define "PB.Crack", PB.CrackMesh()
   Mesh.Define "PB.Broken", PB.BrokenMesh()
   Mesh.Define "PB.Hole", PB.HoleMesh()
   put empty into sPlan
   put empty into sTalk
   put 0 into sLastTalk
   PB.GiveBall "PROMPT"
   PB.Camera
   PB.Say "start", "*", 100
end PB.NewMatch

-- the floor in tiles (each half tinted its hero's colour), the bounds as a wire box,
-- the centre line
on PB.BuildArena
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
         put PB.Line(tM, x, 0, -kHalfD, x, 0, kHalfD) into tA
      end repeat
      repeat with z = -kHalfD to kHalfD step kTile
         put PB.Line(tM, tX0, 0, z, tX1, 0, z) into tA
      end repeat
      Mesh.Define "PB.Floor" & tSide, tM
   end repeat
   get Entity.Spawn("PB.Floor-1", 0, 0, 0, "#1F5A6A")
   get Entity.Spawn("PB.Floor1", 0, 0, 0, "#5A1F55")
   put Mesh.New() into tM
   repeat for each item tY in "0," & kTop
      put PB.Line(tM, -kHalfW, tY, -kHalfD, kHalfW, tY, -kHalfD) into tA
      put PB.Line(tM, kHalfW, tY, -kHalfD, kHalfW, tY, kHalfD) into tA
      put PB.Line(tM, kHalfW, tY, kHalfD, -kHalfW, tY, kHalfD) into tA
      put PB.Line(tM, -kHalfW, tY, kHalfD, -kHalfW, tY, -kHalfD) into tA
   end repeat
   repeat for each item x in -kHalfW & comma & kHalfW
      repeat for each item z in -kHalfD & comma & kHalfD
         put PB.Line(tM, x, 0, z, x, kTop, z) into tA
      end repeat
   end repeat
   Mesh.Define "PB.Bounds", tM
   get Entity.Spawn("PB.Bounds", 0, 0, 0, "#3A4A70")
   put Mesh.New() into tM
   put PB.Line(tM, 0, 0, -kHalfD, 0, 0, kHalfD) into tA
   Mesh.Define "PB.Centre", tM
   get Entity.Spawn("PB.Centre", 0, -1, 0, "#C0D0FF")
   PB.BuildFeatures
end PB.BuildArena

-- a fixed camera behind the front bound and up high: the whole arena, seen at an angle
on PB.Camera
   local tCX, tCY, tCZ, tLY
   put 0 into tCX
   put -kCamUp into tCY
   put -kHalfD - kCamBack into tCZ
   put -36 into tLY
   Camera.SetLook 0, -atan2(tLY - tCY, -tCZ)
   Camera.SetPosition tCX, tCY, tCZ
end PB.Camera

-------------------------------------------------------------------- heroes

on PB.Spawn pName, pColor, pSide, pIdle
   put Entity.Spawn("PB." & pIdle & ".1", pSide * kHalfW * 0.55, 0, 0, pColor) into sHero[pName]["key"]
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
   put 0 into sHero[pName]["g"]
   put empty into sHero[pName]["onTile"]
   put false into sHero[pName]["nohang"]
   put 0 into sHero[pName]["score"]
   put 0 into sHero[pName]["catches"]
   put pColor into sHero[pName]["color"]
   -- stamina (the hero's own, from the shared store): see PB.StaminaAdd
   put PB.StaminaGet(pName) into sHero[pName]["stamina"]
   put 0 into sHero[pName]["streak"]
   put false into sHero[pName]["bIsItPlayersTurn"]
   put false into sHero[pName]["bDidTheyRun"]
   put empty into sHero[pName]["staminaWhy"]
   put 0 into sHero[pName]["staminaUntil"]
end PB.Spawn

function PB.Other pName
   if pName is "PROMPT" then return "GLAZE"
   return "PROMPT"
end PB.Other

-- whose half x is in
function PB.OwnerAt pX
   if pX < 0 then return "PROMPT"
   return "GLAZE"
end PB.OwnerAt

-- move a hero by dx,dz, kept inside its own half
on PB.Move pName, pDX, pDZ
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
   -- a ledge or the pillar stops you unless you are up level with it (jump, or walk a ramp);
   -- slide along it when only one way is blocked
   if PB.Blocked(tX, tZ, sHero[pName]["h"]) then
      if not PB.Blocked(tX, sHero[pName]["z"], sHero[pName]["h"]) then
         put sHero[pName]["z"] into tZ
      else if not PB.Blocked(sHero[pName]["x"], tZ, sHero[pName]["h"]) then
         put sHero[pName]["x"] into tX
      else
         put sHero[pName]["x"] into tX
         put sHero[pName]["z"] into tZ
      end if
   end if
   put tX - sHero[pName]["x"] into sHero[pName]["mdx"]
   put tZ - sHero[pName]["z"] into sHero[pName]["mdz"]
   put sqrt(sHero[pName]["mdx"] ^ 2 + sHero[pName]["mdz"] ^ 2) into sHero[pName]["speed"]
   put tX into sHero[pName]["x"]
   put tZ into sHero[pName]["z"]
   -- stamina: running in your turn counts once a turn, however far or long
   if sHero[pName]["bIsItPlayersTurn"] is true and sHero[pName]["speed"] > 0.5 then
      put true into sHero[pName]["bDidTheyRun"]
   end if
end PB.Move

on PB.MoveToward pName, pX, pZ, pSpeed
   local tDX, tDZ, tD
   put pX - sHero[pName]["x"] into tDX
   put pZ - sHero[pName]["z"] into tDZ
   put sqrt(tDX ^ 2 + tDZ ^ 2) into tD
   if tD < 2 then
      PB.Move pName, 0, 0
      exit PB.MoveToward
   end if
   if tD > pSpeed then
      put tDX * pSpeed / tD into tDX
      put tDZ * pSpeed / tD into tDZ
   end if
   PB.Move pName, tDX, tDZ
end PB.MoveToward

-- you: run with the keys while the mouse aims; hold the button for power, let go to throw
on PB.Controls
   local tKeys, tDX, tDZ, tName, tHolds, tDown
   put PB.Keys() into tKeys
   put sActive into tName
   if PB.Pressed(tKeys, "99,67") then
      PB.Swap
      put sActive into tName
   end if
   if PB.Pressed(tKeys, "65289") then put not sShowLand into sShowLand
   if sTestAuto is true then
      put tKeys into sKeyWas
      exit PB.Controls
   end if
   if sHero[tName]["state"] is among the items of "grab,hang" and PB.Pressed(tKeys, "32,119,87,65362") then
      PB.ClimbOut tName
   else if PB.Pressed(tKeys, "32") then
      PB.Jump tName
   end if
   put 0 into tDX
   put 0 into tDZ
   if 65361 is among the items of tKeys or 97 is among the items of tKeys or 65 is among the items of tKeys then put -1 into tDX
   if 65363 is among the items of tKeys or 100 is among the items of tKeys or 68 is among the items of tKeys then put 1 into tDX
   if 65362 is among the items of tKeys or 119 is among the items of tKeys or 87 is among the items of tKeys then put 1 into tDZ
   if 65364 is among the items of tKeys or 115 is among the items of tKeys or 83 is among the items of tKeys then put -1 into tDZ
   if tDX is not 0 and tDZ is not 0 then
      PB.Move tName, tDX * kRunSpeed * 0.7071, tDZ * kRunSpeed * 0.7071
   else
      PB.Move tName, tDX * kRunSpeed, tDZ * kRunSpeed
   end if
   put (sBall["state"] is "held" and sBall["by"] is tName) into tHolds
   if tHolds then
      PB.Aim tName
      put PB.MouseDown() into tDown
      if tDown then
         if not sCharging then
            put true into sCharging
            put 0 into sPower
         end if
         put min(1, sPower + 0.025) into sPower
      else if sCharging then
         put false into sCharging
         PB.RoofThrow tName, sAimX, sAimZ, sPower
         put 0 into sPower
      end if
      if sBall["by"] is tName and PB.Pressed(tKeys, "101,69") then
         PB.EasyOne tName
      end if
   else
      put false into sCharging
   end if
   put tKeys into sKeyWas
end PB.Controls

on PB.Jump pName
   if not PB.OnGround(pName) then exit PB.Jump
   put kJumpV into sHero[pName]["vh"]
   add 0.01 to sHero[pName]["h"]
   PB.Act pName, "jump"
   PB.StaminaAdd pName, -2, "JUMP"
end PB.Jump

-- where the mouse points on the floor, kept on the partner's half; past a side bound is
-- fine (the throw banks off it)
on PB.Aim pName
   local tXZ, tSide, tX, tZ
   put PB.MouseFloor() into tXZ
   if the number of words of tXZ < 2 then exit PB.Aim
   put word 1 of tXZ into tX
   put word 2 of tXZ into tZ
   put -sHero[pName]["side"] into tSide
   if tX * tSide < kMid * 2 then put tSide * kMid * 2 into tX
   put max(-kHalfW + kBallR + 2, min(kHalfW - kBallR - 2, tX)) into tX
   put max(-3 * kHalfD, min(3 * kHalfD, tZ)) into tZ
   put tX into sAimX
   put tZ into sAimZ
end PB.Aim

function PB.MouseFloor
   if sTestAim is not empty then return sTestAim
   if gNoMouse is true then return empty
   local tM
   put Engine.Mouse() into tM
   if tM is empty then return empty
   try
      return Camera.ScreenToFloor(item 1 of tM, item 2 of tM, 0)
   catch tErr
      return empty
   end try
end PB.MouseFloor

function PB.MouseDown
   if sTestMouse is not empty then return sTestMouse is true
   if gNoMouse is true then return false
   return the mouse is "down"
end PB.MouseDown

-- a key (any of pCodes) went down this step
function PB.Pressed pKeys, pCodes
   local tC
   repeat for each item tC in pCodes
      if tC is among the items of pKeys and tC is not among the items of sKeyWas then return true
   end repeat
   return false
end PB.Pressed

on PB.Swap
   put PB.Other(sActive) into sActive
   put false into sCharging
   put empty into sPlan
   PB.Message "YOU ARE " & sActive
   PB.Say "swap", sActive, 60
end PB.Swap

-------------------------------------------------------------------- the ball

-- the hand: in front of the hero, towards the other half
function PB.HandX pName
   return sHero[pName]["x"] - sHero[pName]["side"] * 12
end PB.HandX

on PB.GiveBall pName
   put "held" into sBall["state"]
   put pName into sBall["by"]
   put PB.HandX(pName) into sBall["x"]
   put kHandH into sBall["h"]
   put sHero[pName]["z"] into sBall["z"]
   -- the ghost starts on the partner
   put sHero[PB.Other(pName)]["x"] into sAimX
   put sHero[PB.Other(pName)]["z"] into sAimZ
   put false into sCharging
   put 0 into sPower
   put sTicks + kAIWait into sHoldUntil
   put empty into sPlan
   PB.TurnStart pName
end PB.GiveBall

-- a throw's velocity from power (0..1), arc (radians up) and sideways aim (radians)
-- how many steps a roof throw with upward speed pVH stays up (until it first touches the
-- floor): the same vertical steps as PB.Advance
function PB.RoofSteps pVH
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
end PB.RoofSteps

-- the upward speed of a roof throw at power 0..1: always enough to reach the roof
function PB.RoofVH pPower
   return sqrt(2 * kGrav * (kTop - kBallR - kHandH)) + 0.5 + pPower * kRoofPower
end PB.RoofVH

-- the velocity "vx,vh,vz" that takes the ball from pName's hand off the roof and down on
-- x,z (a z past a side bound banks off it)
function PB.RoofVelocity pName, pX, pZ, pPower
   local tVH, n
   put PB.RoofVH(pPower) into tVH
   put PB.RoofSteps(tVH) into n
   return ((pX - PB.HandX(pName)) / n) & comma & tVH & comma & ((pZ - sHero[pName]["z"]) / n)
end PB.RoofVelocity

-- a z past a side bound folded back the way the ball bounces
function PB.Fold pZ
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
end PB.Fold

on PB.RoofThrow pName, pX, pZ, pPower
   PB.StaminaThrow pName, pPower
   PB.Launch pName, PB.RoofVelocity(pName, pX, pZ, pPower), false
   PB.Act pName, "throw"
end PB.RoofThrow

-- the ball leaves pName's hand with velocity "vx,vh,vz"
on PB.Launch pName, pVel, pEasy
   put "loose" into sBall["state"]
   put pName into sBall["thrower"]
   put empty into sBall["by"]
   put PB.HandX(pName) into sBall["x"]
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
   put 0 into sBall["stars"]
   put empty into sBall["mended"]
   put empty into sBall["emblem"]
   put 0 into sBall["floors"]
   put kHandH into sBall["peak"]
   put empty into sBall["touched"]
   put (pEasy is true) into sBall["easy"]
   put empty into sPlan
   PB.PredictLand
   -- the thrower's turn is over; the partner's begins (catching it)
   PB.TurnEnd pName
   PB.TurnStart PB.Other(pName)
end PB.Launch

-- where the loose ball first comes down (the landing ring)
on PB.PredictLand
   local tB, i
   put sBall into tB
   put empty into sLandX
   if tB["touched"] is not empty then exit PB.PredictLand
   repeat with i = 1 to 400
      PB.Advance tB
      if tB["floors"] > sBall["floors"] then
         put tB["x"] into sLandX
         put tB["z"] into sLandZ
         exit repeat
      end if
   end repeat
end PB.PredictLand

-- an easy one: a slow lob that comes down right on the partner's hands
on PB.EasyOne pName
   local tOther, tT, tVX, tVH, tVZ
   put PB.Other(pName) into tOther
   put 70 into tT
   put (PB.HandX(tOther) - PB.HandX(pName)) / tT into tVX
   put (sHero[tOther]["z"] - sHero[pName]["z"]) / tT into tVZ
   put (kHandH - kHandH + kGrav * tT * (tT + 1) / 2) / tT into tVH
   PB.StaminaThrow pName, 0
   PB.Launch pName, tVX & comma & tVH & comma & tVZ, true
   PB.Act pName, "lob"
   PB.Say "easy", pName, 100
end PB.EasyOne

-- one step of the ball's flight, for the real ball and for every prediction alike.
-- pB["hit"]: side, top, back, block or floor when it struck one this step; pB["emblem"]: the
-- emblem it struck (n), its "stars" count the far wall's star emblems
on PB.Advance @pB
   local tAir, tLimZ, tLimX, tG, tN
   put pB["air"] into tAir
   put empty into pB["hit"]
   put empty into pB["emblem"]
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
      if sEmblem["count"] > 0 then
         PB.EmblemHit pB, "far", pB["x"]
      end if
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
      if sEmblem["count"] > 0 then
         PB.EmblemHit pB, "1", pB["z"]
      end if
   else if pB["x"] < -tLimX then
      put -2 * tLimX - pB["x"] into pB["x"]
      put abs(pB["vx"]) * kBackLoss into pB["vx"]
      add 1 to pB["backs"]
      put "back" into pB["hit"]
      if sEmblem["count"] > 0 then PB.EmblemHit pB, "-1", pB["z"]
   end if
   if pB["h"] > kTop - kBallR then
      put 2 * (kTop - kBallR) - pB["h"] into pB["h"]
      put -abs(pB["vh"]) into pB["vh"]
      add 1 to pB["tops"]
      put "top" into pB["hit"]
   end if
   -- the floor, a ledge's top or a ramp: the ground under the ball
   put 0 into tG
   if pB["h"] < sFeatTop + kBallR + 1 then
      put PB.GroundAt(pB["x"], pB["z"]) into tG
      -- the side of a ledge or the pillar sends it back
      if sBlocks is not empty then PB.BlockSides pB
   end if
   if pB["h"] <= tG + kBallR and pB["h"] > tG + kBallR - 16 and (tG > 0 or PB.Solid(pB["x"], pB["z"])) then
      put tG + kBallR into pB["h"]
      PB.Rebound pB, PB.Normal(pB["x"], pB["z"])
      if tAir then
         add 1 to pB["floors"]
         put "floor" into pB["hit"]
      end if
      put false into pB["air"]
   else
      put true into pB["air"]
   end if
   put max(pB["peak"], pB["h"]) into pB["peak"]
end PB.Advance

-- bounce off the ground whose normal is "nx,ny,nz" (flat: 0,1,0): a fast fall bounces back
-- (kBounce) and loses some run (kFloorDrag); a slow one rolls (kRollDrag). On a ramp what is left
-- runs along the slope, so gravity rolls the ball down it
on PB.Rebound @pB, pN
   local tNX, tNY, tNZ, tVN
   set the itemDel to comma
   put item 1 of pN into tNX
   put item 2 of pN into tNY
   put item 3 of pN into tNZ
   put pB["vx"] * tNX + pB["vh"] * tNY + pB["vz"] * tNZ into tVN
   if tVN >= 0 then exit PB.Rebound
   -- take the part into the ground away
   subtract tVN * tNX from pB["vx"]
   subtract tVN * tNY from pB["vh"]
   subtract tVN * tNZ from pB["vz"]
   if -tVN > kRollV then
      multiply pB["vx"] by kFloorDrag
      multiply pB["vh"] by kFloorDrag
      multiply pB["vz"] by kFloorDrag
      -- and give it back, smaller, the other way
      subtract kBounce * tVN * tNX from pB["vx"]
      subtract kBounce * tVN * tNY from pB["vh"]
      subtract kBounce * tVN * tNZ from pB["vz"]
   else
      multiply pB["vx"] by kRollDrag
      multiply pB["vh"] by kRollDrag
      multiply pB["vz"] by kRollDrag
      if tNY >= 0.999 then put 0 into pB["vh"]
   end if
end PB.Rebound

-- a ball low enough to meet a block's side (not resting on its top): pushed out of the side it
-- is least inside, that speed turned back (a bank off a ledge or the pillar)
on PB.BlockSides @pB
   local tLine, tX0, tX1, tZ0, tZ1, tTop, tCX, tCZ, tHX, tHZ, tPX, tPZ
   set the itemDel to comma
   repeat for each line tLine in sBlocks
      put item 5 of tLine into tTop
      if pB["h"] >= tTop then next repeat
      put item 1 of tLine into tX0
      put item 2 of tLine into tX1
      put item 3 of tLine into tZ0
      put item 4 of tLine into tZ1
      if pB["x"] <= tX0 - kBallR or pB["x"] >= tX1 + kBallR or pB["z"] <= tZ0 - kBallR or pB["z"] >= tZ1 + kBallR then next repeat
      -- over the top already (coming down on it): the ground takes it
      if pB["h"] > tTop - 4 and pB["x"] > tX0 and pB["x"] < tX1 and pB["z"] > tZ0 and pB["z"] < tZ1 then next repeat
      put (tX0 + tX1) / 2 into tCX
      put (tZ0 + tZ1) / 2 into tCZ
      put (tX1 - tX0) / 2 + kBallR into tHX
      put (tZ1 - tZ0) / 2 + kBallR into tHZ
      put tHX - abs(pB["x"] - tCX) into tPX
      put tHZ - abs(pB["z"] - tCZ) into tPZ
      if tPX < tPZ then
         put tCX + PB.Sign(pB["x"] - tCX) * tHX into pB["x"]
         put PB.Sign(pB["x"] - tCX) * abs(pB["vx"]) * 0.9 into pB["vx"]
      else
         put tCZ + PB.Sign(pB["z"] - tCZ) * tHZ into pB["z"]
         put PB.Sign(pB["z"] - tCZ) * abs(pB["vz"]) * 0.9 into pB["vz"]
      end if
      put "block" into pB["hit"]
   end repeat
end PB.BlockSides

on PB.BallStep
   local tName, tOwner, tFirst
   if sBall["state"] is "held" then
      put sBall["by"] into tName
      put PB.HandX(tName) into sBall["x"]
      put kHandH + sHero[tName]["h"] into sBall["h"]
      put sHero[tName]["z"] into sBall["z"]
   else
      PB.Advance sBall
      if sBall["hit"] is not empty and sBall["hit"] is not "floor" then PB.PredictLand
      if sBall["emblem"] is not empty then PB.EmblemStruck sBall["emblem"]
      if sBall["x"] * sHero[sBall["thrower"]]["side"] < 0 then put true into sBall["crossed"]
      if sBall["hit"] is "floor" then
         put (sBall["touched"] is empty) into tFirst
         if tFirst then
            put PB.OwnerAt(sBall["x"]) into tOwner
            put tOwner into sBall["touched"]
            put empty into sLandX
            if tOwner is sBall["thrower"] and not sBall["crossed"] then
               put 0 into sRally
               add 1 to sTosses
               PB.Say "wild", tOwner, 70
            else
               PB.Drop tOwner
            end if
         end if
         -- this match's rule: what the bounce does to the floor
         PB.Bounce sBall["x"], sBall["z"], tFirst
      end if
      if sBall["h"] < -160 then
         PB.BallLost
         exit PB.BallStep
      end if
      if sBall["age"] > 3 then
         repeat for each item tName in "PROMPT,GLAZE"
            if PB.CanCatch(tName) then
               PB.Catch tName
               exit repeat
            end if
         end repeat
      end if
   end if
   Entity.SetPosition sBall["key"], sBall["x"], -sBall["h"], sBall["z"]
   Entity.SetPosition sBall["shadow"], sBall["x"], -1, sBall["z"]
end PB.BallStep

function PB.CanCatch pName
   if sHero[pName]["state"] is not empty then return false
   if sBall["h"] > kReach + sHero[pName]["h"] or sBall["h"] < sHero[pName]["h"] - 6 then return false
   if (sBall["x"] - sHero[pName]["x"]) ^ 2 + (sBall["z"] - sHero[pName]["z"]) ^ 2 > kCatchR ^ 2 then return false
   if pName is sBall["thrower"] and not sBall["crossed"] and sBall["touched"] is empty then return false
   -- the companion lets a ball go by when it waits for it after a bounce, worth more
   if (pName is not sActive or sTestAuto is true) and sBall["touched"] is empty and sPlan[pName]["score"] > sBall["banks"] + sBall["tops"] then return false
   return true
end PB.CanCatch

-- what a catch is worth: the roof +1, each side bound +1, each bank off the far wall's star +1
function PB.CatchPoints
   if sBall["easy"] then return 0
   return sBall["banks"] + sBall["tops"] + sBall["stars"]
end PB.CatchPoints

function PB.CatchWhy
   local tWhy
   if sBall["easy"] then return "EASY ONES ARE FREE"
   if sBall["tops"] > 0 then put "ROOF  " after tWhy
   if sBall["banks"] > 0 then put "SIDES " & sBall["banks"] & "  " after tWhy
   if sBall["stars"] > 0 then put "STAR " & sBall["stars"] after tWhy
   if tWhy is empty then return "NO ROOF, NO POINTS"
   return word 1 to -1 of tWhy
end PB.CatchWhy

on PB.Catch pName
   local tP, tWas
   put sBall["easy"] into tWas
   if sBall["touched"] is not empty then
      -- a pick-up from the floor: no points, no rally
      PB.GiveBall pName
      exit PB.Catch
   end if
   put PB.CatchPoints() into tP
   add tP to sHero[pName]["score"]
   repeat while sHero[pName]["score"] >= sHero[pName]["nextHang"]
      add 1 to sHero[pName]["hangs"]
      add kHangEvery to sHero[pName]["nextHang"]
   end repeat
   add 1 to sHero[pName]["catches"]
   add 1 to sTosses
   add 1 to sMatchCatches
   add 1 to sRally
   put max(sBestRally, sRally) into sBestRally
   if pName is sActive then put 0 into sPlayerDrops
   -- stamina: every 3 catches in a row without a miss +1
   add 1 to sHero[pName]["streak"]
   if sHero[pName]["streak"] mod 3 is 0 then PB.StaminaAdd pName, 1, "3 CATCHES IN A ROW"
   PB.Act pName, "catch"
   PB.Message pName & "  +" & tP & "   " & PB.CatchWhy()
   PB.GiveBall pName
   if tWas then
      PB.Say "easy_caught", pName, 80
   else if sRally is 5 or (sRally > 0 and sRally mod 10 is 0) then
      PB.Say "rally", "*", 100
   else if tP >= 3 then
      PB.Say "catch_big", pName, 90
   else if tP is 0 then
      PB.Say "catch_flat", pName, 45
   else
      PB.Say "catch_good", pName, 35
   end if
end PB.Catch

on PB.Drop pName
   add 1 to sTosses
   put 0 into sRally
   if pName is sActive then add 1 to sPlayerDrops
   -- stamina: a miss ends the catches in a row; running and missing -1
   put 0 into sHero[pName]["streak"]
   if sHero[pName]["bIsItPlayersTurn"] is true and sHero[pName]["bDidTheyRun"] is true then
      PB.StaminaAdd pName, -1, "RAN AND MISSED"
   end if
   PB.Message pName & " DROPPED IT"
   PB.Say "drop", pName, 60
end PB.Drop

-------------------------------------------------------------------- the companion

-- the hero you don't play: catches, picks up, throws; sTestAuto: both heroes play themselves
on PB.Companion
   local tName
   if sTestFreeze is true then exit PB.Companion
   repeat for each item tName in "PROMPT,GLAZE"
      if tName is sActive and sTestAuto is not true then next repeat
      PB.Think tName
   end repeat
end PB.Companion

on PB.Think pName
   local tHomeX, tSpeed, tSafe
   if pName is "PROMPT" then
      put kRunSpeed into tSpeed
   else
      put kRunSpeed * 0.92 into tSpeed
   end if
   put sHero[pName]["side"] * kHalfW * 0.55 into tHomeX
   if sHero[pName]["state"] is not empty then exit PB.Think
   if sBall["state"] is "held" then
      -- never wait on a broken square: it is going to fall
      if PB.OnGround(pName) and sHero[pName]["g"] <= 0 and PB.TileLevel(PB.TileOf(sHero[pName]["x"], sHero[pName]["z"])) >= 2 then
         put PB.SafeSpot(pName) into tSafe
         PB.MoveToward pName, item 1 of tSafe, item 2 of tSafe, tSpeed
         exit PB.Think
      end if
      if sBall["by"] is pName then
         PB.Move pName, 0, 0
         if sTicks >= sHoldUntil and (sTalk is empty or sTicks >= sHoldUntil + 90) then
            PB.AIThrow pName
         end if
      else
         PB.MoveToward pName, tHomeX, sHero[pName]["z"] * 0.97, tSpeed * 0.5
      end if
      exit PB.Think
   end if
   -- the ball is loose: is it coming to my half?
   if sBall["age"] < 5 then
      PB.Move pName, 0, 0
      exit PB.Think
   end if
   if sPlan[pName]["at"] is empty or sBall["hit"] is not empty or sTicks - sPlan[pName]["at"] >= 8 then
      PB.Plan pName, tSpeed
      put sTicks into sPlan[pName]["at"]
   end if
   if sPlan[pName]["x"] is a number then
      PB.MoveToward pName, sPlan[pName]["x"], sPlan[pName]["z"], tSpeed
      -- a hole ahead: jump it, but only onto a whole square (landing on a broken one smashes
      -- through); else stop at the edge
      if PB.OnGround(pName) and sHero[pName]["g"] <= 0 and sHero[pName]["speed"] > 0.5 and not PB.Solid(sHero[pName]["x"] + sHero[pName]["mdx"] * 4, sHero[pName]["z"] + sHero[pName]["mdz"] * 4) then
         if PB.SafeLanding(sHero[pName]["x"] + sHero[pName]["mdx"] * 31, sHero[pName]["z"] + sHero[pName]["mdz"] * 31) then
            PB.Jump pName
         else
            put sHero[pName]["x"] - sHero[pName]["mdx"] into sHero[pName]["x"]
            put sHero[pName]["z"] - sHero[pName]["mdz"] into sHero[pName]["z"]
            put 0 into sHero[pName]["speed"]
         end if
      end if
   else
      PB.MoveToward pName, tHomeX, 0, tSpeed * 0.5
   end if
end PB.Think

-- where pName should stand. A ball in the air: of the points on its half where the ball can
-- be caught and it can get to in time, the one after the most bounces (the catcher gets the
-- points), the earliest of those. A ball already down: the first point it can reach. If
-- none, where the ball first comes down on its half.
on PB.Plan pName, pSpeed
   local tB, i, tD, tBest, tLand, tScore, tBestScore, tDown, tFloors
   put sBall into tB
   put empty into sPlan[pName]["x"]
   put empty into sPlan[pName]["z"]
   put empty into sPlan[pName]["score"]
   put (sBall["touched"] is not empty) into tDown
   put -1 into tBestScore
   put tB["floors"] into tFloors
   repeat with i = 1 to 400
      if i > 1 then PB.Advance tB
      if tB["x"] * sHero[pName]["side"] <= 0 then next repeat
      if not tDown and tB["floors"] > tFloors then
         -- it touches my floor here: nothing later is a catch
         if tLand is empty then put tB["x"] & comma & tB["z"] into tLand
         exit repeat
      end if
      if tB["h"] <= kReach - 8 and tB["h"] > 6 then
         put sqrt((tB["x"] - sHero[pName]["x"]) ^ 2 + (tB["z"] - sHero[pName]["z"]) ^ 2) - kCatchR * 0.6 into tD
         if tD <= pSpeed * i then
            put tB["banks"] + tB["tops"] + tB["stars"] into tScore
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
   if tBest is empty then exit PB.Plan
   set the itemDel to comma
   put item 1 of tBest into sPlan[pName]["x"]
   put item 2 of tBest into sPlan[pName]["z"]
   if tBestScore >= 0 then put tBestScore into sPlan[pName]["score"]
end PB.Plan

-- the companion's throw: its own style, tried out first so the partner can catch it.
-- PROMPT throws lower and harder and likes the sides; GLAZE lobs sky high. After two drops in a row by
-- the player, an easy one (no points, all heart).
-- the companion's throw: off the roof, down near the partner. PROMPT throws harder and
-- likes banking off the sides; GLAZE throws soft and sweet. Every throw is tried out first
-- so the partner can catch it. After two drops in a row by the player, an easy one.
on PB.AIThrow pName
   local tTry, tOther, tPower, tX, tZ, tR, tN, tVel, tGot, tPick, tBank, tLim
   put PB.Other(pName) into tOther
   if pName is not sActive and sPlayerDrops >= 2 and sTestAuto is not true then
      put 0 into sPlayerDrops
      PB.EasyOne pName
      exit PB.AIThrow
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
      put PB.RoofSteps(PB.RoofVH(tPower)) into tN
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
      put PB.RoofVelocity(pName, tX, tZ, tPower) into tVel
      put PB.Catchable(pName, tVel) into tGot
      if tGot is empty then next repeat
      put tVel into tPick
      exit repeat
   end repeat
   if tPick is empty then
      PB.EasyOne pName
      exit PB.AIThrow
   end if
   PB.StaminaThrow pName, tPower
   PB.Launch pName, tPick, false
   PB.Act pName, "throw"
end PB.AIThrow

-- can the partner catch a throw from pName with velocity pVel? Empty: no; else its banks.
-- A fair throw comes down to catching height on the partner's half before touching it,
-- somewhere the partner can run to in time
function PB.Catchable pName, pVel
   local tB, i, tOther, tD
   put PB.Other(pName) into tOther
   put PB.HandX(pName) into tB["x"]
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
      PB.Advance tB
      if tB["floors"] > 0 then return empty
      if tB["x"] * sHero[tOther]["side"] > kMid and tB["h"] <= kReach - 14 and tB["h"] > 12 then
         put sqrt((tB["x"] - sHero[tOther]["x"]) ^ 2 + (tB["z"] - sHero[tOther]["z"]) ^ 2) into tD
         if tD <= kRunSpeed * 0.8 * i + kCatchR * 0.5 then return tB["banks"] + tB["tops"]
      end if
   end repeat
   return empty
end PB.Catchable

-------------------------------------------------------------------- the aim preview

-- while you hold the ball: dots along the throw's path until it first touches the floor,
-- and a ring where it lands
-- the ghost ball where your throw will come down (while you hold the ball); the landing
-- ring under it, and under where a loose ball will first come down (TAB: on or off)
-- the ghost ball where your throw will come down (while you hold the ball); the landing
-- ring under it, and under where a loose ball will first come down (TAB: on or off)
on PB.Preview
   local tLX, tLZ, tXZ
   if sBall["state"] is "held" and sBall["by"] is sActive and sTestAuto is not true and sAimX is a number then
      put PB.GhostLand() into tXZ
      put item 1 of tXZ into tLX
      put item 2 of tXZ into tLZ
      Entity.SetPosition sGhost, tLX, -kBallR, tLZ
   else
      Entity.SetPosition sGhost, 0, 0, -100000
      if sBall["state"] is "loose" and sShowLand and sLandX is a number then
         put sLandX into tLX
         put sLandZ into tLZ
      end if
   end if
   if tLX is empty then
      Entity.SetPosition sMark, 0, 0, -100000
   else
      Entity.SetPosition sMark, tLX, -1, tLZ
   end if
end PB.Preview

-- where your throw really comes down: with no walls, the aim folded off the sides; with
-- walls, the flight played out (kept until the aim, the power or the walls change)
function PB.GhostLand
   local tKey, tB, tVel, i
   if sBlocks is empty and sFeat is empty then return sAimX & comma & PB.Fold(sAimZ)
   put round(sAimX) & "," & round(sAimZ) & "," & round(sPower * 20) & "," & round(sHero[sActive]["x"] / 4) & "," & round(sHero[sActive]["z"] / 4) & "," & round(sHero[sActive]["h"]) into tKey
   if tKey is sGhostKey then return sGhostAt
   put PB.RoofVelocity(sActive, sAimX, sAimZ, sPower) into tVel
   put PB.HandX(sActive) into tB["x"]
   put kHandH into tB["h"]
   put sHero[sActive]["z"] into tB["z"]
   put item 1 of tVel into tB["vx"]
   put item 2 of tVel into tB["vh"]
   put item 3 of tVel into tB["vz"]
   put true into tB["air"]
   put 0 into tB["floors"]
   repeat with i = 1 to 400
      PB.Advance tB
      if tB["floors"] > 0 then exit repeat
   end repeat
   put tKey into sGhostKey
   put tB["x"] & comma & tB["z"] into sGhostAt
   return sGhostAt
end PB.GhostLand

-------------------------------------------------------------------- animation

-- a one-shot move (throw, lob, catch) plays over whatever the hero was doing
on PB.Act pName, pAct
   if sClip[pAct]["frames"] is not a number or sClip[pAct]["frames"] < 1 then exit PB.Act
   put pAct into sHero[pName]["act"]
   put 1 into sHero[pName]["frame"]
end PB.Act

on PB.Animate pName
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
   -- facing: the edge while hanging; where you run; otherwise the other half (or along the aim)
   if sHero[pName]["state"] is among the items of "grab,hang,recover" then
      put sHero[pName]["hangYaw"] into tWant
   else if sHero[pName]["speed"] > 0.3 and sHero[pName]["act"] is empty then
      put atan2(sHero[pName]["mdx"], sHero[pName]["mdz"]) into tWant
   else if sBall["state"] is "held" and sBall["by"] is pName and pName is sActive and sAimX is a number then
      put atan2(sAimX - sHero[pName]["x"], PB.Fold(sAimZ) - sHero[pName]["z"]) into tWant
   else
      put -sHero[pName]["side"] * pi / 2 into tWant
   end if
   put PB.TurnToward(sHero[pName]["yaw"], tWant, 0.25) into sHero[pName]["yaw"]
   PB.SetMesh tKey, "PB." & tClip & "." & max(1, trunc(sHero[pName]["frame"]))
   PB.HeroFall pName
   if sHero[pName]["state"] is among the items of "grab,hang,recover" then PB.HangPose pName, tKey
   if sHero[pName]["state"] is "hang" then
      -- dangling: a little sway and swing, nothing under the feet
      Entity.SetPosition tKey, sHero[pName]["x"] + sin(sTicks * 0.17) * 3, -(sHero[pName]["h"] - abs(sin(sTicks * 0.085)) * 2), sHero[pName]["z"]
      put PB.Euler(sHero[pName]["yaw"], sin(sTicks * 0.17) * 0.14) into tE
   else
      Entity.SetPosition tKey, sHero[pName]["x"], -sHero[pName]["h"], sHero[pName]["z"]
      put PB.Euler(sHero[pName]["yaw"], 0) into tE
   end if
   Entity.SetRotation tKey, item 1 of tE, item 2 of tE, item 3 of tE
end PB.Animate

-- Harold Lloyd's three moves from the list: grab (the clip "climb": reaching up, taking hold of
-- the edge), hang (looped), recover (hauling himself out). The frame is kept by PB.HeroFall,
-- which times the moves; without a clip, the catch's reach-high frame stands in
on PB.HangPose pName, pKey
   local tClip, tN
   switch sHero[pName]["state"]
      case "grab"
         put "climb" into tClip
         break
      case "hang"
         put "hang" into tClip
         break
      default
         put "recover" into tClip
   end switch
   put sClip[tClip]["frames"] into tN
   if tN is a number and tN >= 1 then
      PB.SetMesh pKey, "PB." & tClip & "." & max(1, min(tN, trunc(sHero[pName]["hangFrame"])))
   else if sClip["catch"]["frames"] >= 12 then
      PB.SetMesh pKey, "PB.catch.12"
   end if
end PB.HangPose

function PB.TurnToward pFrom, pTo, pRate
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
end PB.TurnToward

-------------------------------------------------------------------- banter
-- PhotonBall/banter.txt: event TAB who TAB "P line | G line | ..."; who is PROMPT, GLAZE
-- or * (either). P and G say who speaks each turn. Events: start level crack fall hang over catch_good catch_big
-- catch_flat drop wild easy easy_caught rally swap idle. The HUD letters: A-Z 0-9 and
-- : - + . ! / ? , '  (anything else is skipped).

on PB.LoadBanter
   local tFile, tText, tLine, n
   put empty into sBanter
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/PhotonBall/banter.txt") into tFile
   if tFile is not empty then
      put textDecode(url ("binfile:" & tFile), "UTF-8") into tText
      replace numToCodepoint(13) with empty in tText
   end if
   if tText is empty then put PB.DefaultBanter() into tText
   set the itemDel to tab
   repeat for each line tLine in tText
      if tLine is empty or char 1 of tLine is "#" or the number of items of tLine < 3 then next repeat
      put the number of lines of sBanter[item 1 of tLine] + 1 into n
      put item 2 of tLine & tab & item 3 of tLine into line n of sBanter[item 1 of tLine]
   end repeat
end PB.LoadBanter

function PB.DefaultBanter
   return "start" & tab & "*" & tab & "P Ball. Floor. Each other. Catch it before the floor does. | G You make everything sound like a chore list." & return & \
         "catch_flat" & tab & "*" & tab & "P Flat throws score nothing. | G Then I'll throw you a curvy one." & return & \
         "drop" & tab & "*" & tab & "G Down it goes. | P Lucky the floor holds."
end PB.DefaultBanter

-- start an exchange for pEvent about pWho (a hero, or * for either), pChance percent of the
-- time; a fresh exchange waits for the one already playing
on PB.Say pEvent, pWho, pChance
   local tPick, tLine, n, tTurn, tList
   if sTalk is not empty and pEvent is not among the items of "start,level,fall" then exit PB.Say
   if random(100) > pChance then exit PB.Say
   set the itemDel to tab
   repeat for each line tLine in sBanter[pEvent]
      if item 1 of tLine is "*" or item 1 of tLine is pWho or pWho is "*" then put item 2 of tLine & return after tList
   end repeat
   if tList is empty then exit PB.Say
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
   PB.Bubble "PROMPT", empty
   PB.Bubble "GLAZE", empty
   put pEvent & ":" & pWho & " " after sSaid
end PB.Say

on PB.TalkTick
   local tTurn
   if sTalk is not empty and sTicks >= sTalkNext then
      put line 1 of sTalk into tTurn
      delete line 1 of sTalk
      set the itemDel to tab
      PB.Bubble item 1 of tTurn, item 2 of tTurn
      put sTicks + round((1300 + 60 * the number of chars of item 2 of tTurn) / sStepMS) into sTalkNext
      put sTalkNext + round(1200 / sStepMS) into sTalkClearAt
      put sTicks into sLastTalk
   else if sTalk is empty and sTalkClearAt is a number and sTicks >= sTalkClearAt then
      PB.Bubble "PROMPT", empty
      PB.Bubble "GLAZE", empty
      put empty into sTalkClearAt
      put sTicks into sLastTalk
   end if
   if sTalk is empty and sTalkClearAt is empty and sTicks - sLastTalk > round(16000 / sStepMS) then
      put sTicks into sLastTalk
      PB.Say "idle", "*", 100
   end if
end PB.TalkTick

-- a speech bubble under the speaker's score: PROMPT's on the left, GLAZE's on the right
on PB.Bubble pName, pText
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
         HUD.Remove "PB.Say." & pName & "." & i
         next repeat
      end if
      if pName is "PROMPT" then
         put gViewLeft + 20 into tX
      else
         put gViewRight - 20 - tLong * tSize into tX
      end if
      -- under the stamina meter's line (Vector Toss draws them over each other)
      HUD.Set "PB.Say." & pName & "." & i, line i of tLines, tX, gViewTop + 80 + (i - 1) * (tSize + 7), tSize
   end repeat
end PB.Bubble

-------------------------------------------------------------------- matches

-- every kMatchCatches catches a new match: the floor is mended and the rule gets worse
on PB.Matches
   if sMatchCatches >= kMatchCatches then PB.SetMatch sMatch + 1
end PB.Matches

function PB.Sign pN
   if pN < 0 then return -1
   return 1
end PB.Sign

-- the floor rule of this match, 1..4 (match 5 on keeps rule 4)
function PB.Rule
   local tR
   put PB.MatchItem(kMatchRules) into tR
   if tR is not an integer then return max(1, min(4, PB.MatchNo()))
   return max(1, min(4, tR))
end PB.Rule

-- this match's number (1 before the first match is set)
function PB.MatchNo
   if sMatch is an integer and sMatch >= 1 then return sMatch
   return 1
end PB.MatchNo

-- item n of a per-match list for match n (the last item for every match after); empty list: empty
function PB.MatchItem pList
   local tN
   set the itemDelimiter to comma
   put the number of items of pList into tN
   if tN < 1 then return empty
   return word 1 of item min(PB.MatchNo(), tN) of pList
end PB.MatchItem

-- ms a broken square takes to fall this match: pKind "off" (stepped off) or "on" (stepped on, rule 2 on)
function PB.CrumbleMS pKind
   local tV
   if pKind is "on" then
      put PB.MatchItem(kMatchOnMS) into tV
      if tV is a number and tV > 0 then return tV
      return kCrumbleOnMS
   end if
   put PB.MatchItem(kMatchOffMS) into tV
   if tV is a number and tV > 0 then return tV
   return kCrumbleOffMS
end PB.CrumbleMS

-- tests: the rule lists and this match's crumble times
function PB.RulesInfo
   return kMatchRules & "|" & kMatchOffMS & "|" & kMatchOnMS & "|" & kMatchCatches & "|" & PB.CrumbleMS("off") & "," & PB.CrumbleMS("on")
end PB.RulesInfo

function PB.RuleName
   switch PB.Rule()
      case 1
         return "THE BALL BREAKS A SQUARE"
      case 2
         return "EVERY BOUNCE BREAKS THE GROUND"
      case 3
         return "EVERY BOUNCE CRACKS THE SQUARES AROUND IT"
      default
         return "EVERY BOUNCE PUNCHES HOLES"
   end switch
end PB.RuleName

-- match pMatch: the floor mended, the new rule told
on PB.SetMatch pMatch
   local tName
   PB.MendFloor
   -- the floor comes back under anyone hanging: they climb out
   repeat for each item tName in "PROMPT,GLAZE"
      if sHero[tName]["state"] is among the items of "grab,hang" then PB.ClimbOut tName
   end repeat
   put pMatch into sMatch
   put 0 into sMatchCatches
   put 0 into sTosses
   if pMatch > 1 then
      PB.Message "MATCH " & pMatch & ": " & PB.RuleName()
      put empty into sTalk
      PB.Say "match" & PB.Rule(), "*", 100
   end if
end PB.SetMatch

-- tests: go to a match now
on PB.TestMatch pMatch
   PB.SetMatch pMatch
end PB.TestMatch

-- match, rule, catches this match
function PB.MatchState
   return sMatch & "," & PB.Rule() & "," & sMatchCatches
end PB.MatchState

function PB.BallField pKey
   return sBall[pKey]
end PB.BallField

-- tests: the player's ball leaves the hand with this velocity
on PB.TestLaunch pVX, pVH, pVZ
   PB.Launch sActive, pVX & comma & pVH & comma & pVZ, false
end PB.TestLaunch

-------------------------------------------------------------------- the walls (PhotonBall/walls.cellmap)

-- The walls are a cellmap (LIB_BIT editor/CELLMAP_V2.md + V3) one cell bigger than the arena on
-- every side: 20 x 10 cells of 40, so the arena's 18 x 8 floor squares are cells 2..19 x 2..9,
-- column 1 the west wall (PROMPT's back), column 20 the east wall (GLAZE's back), row 10 the far
-- wall and row 1 the camera side (left open). The game reads [map] cols rows cell wallH step,
-- [design] (emblem letters on the wall cells), [floor] (hu) and [slope]. Floor 1 is the arena
-- floor; an arena cell higher than 1 is a block (a ledge, the pillar), a cell in [slope] a ramp.
-- A missing or wrong file: a plain arena (Vector Toss's), and the problem said on screen.
on PB.LoadWalls
   local tFile, tText, tFrom
   put empty into sMap
   put PB.WallsText() into tText
   if tText is not empty then
      put "embedded" into tFrom
   else
      put Game.FindFile(kWallFile) into tFile
      if tFile is not empty then put textDecode(url ("binfile:" & tFile), "UTF-8") into tText
      if tText is not empty then put "file" into tFrom
   end if
   if tText is empty then
      put "NO WALLS FILE: A PLAIN ARENA" into sMap["problem"]
   else
      PB.ReadWalls tText
   end if
   put tFrom into sMap["from"]
   PB.MakeFeatures
end PB.LoadWalls

-- the walls as a whole cellmap text, read before the file: empty here (the game reads kWallFile).
-- LIB_COMFY's dangerous mode replaces this handler with the walls it made, so a built game
-- carries its own walls wherever it is copied (one file, nothing to find)
function PB.WallsText
   return empty
end PB.WallsText

-- tests: where the walls came from (embedded, file, or empty: none)
function PB.WallsFrom
   return sMap["from"]
end PB.WallsFrom

-- tests: walls from this text (empty: none), and a new game on them
on PB.TestWalls pText
   put empty into sMap
   if pText is not empty then PB.ReadWalls pText
   PB.MakeFeatures
   PB.NewMatch
end PB.TestWalls

on PB.ReadWalls pText
   local tLine, tSec, tRow, c, tW, tCell, tR, i, tCols, tRows
   replace numToCodepoint(13) with empty in pText
   set the itemDel to tab
   repeat for each line tLine in pText
      if char 1 of tLine is "[" and char -1 of tLine is "]" then
         put char 2 to -2 of tLine into tSec
         put 0 into tRow
         next repeat
      end if
      if char 1 of tLine is "#" and (tSec is empty or tSec is "map") then next repeat
      switch tSec
         case "map"
            if the number of items of tLine >= 2 then put item 2 of tLine into sMap["meta"][item 1 of tLine]
            break
         case "design"
            add 1 to tRow
            repeat with c = 1 to the number of chars of tLine
               put char c of tLine into sMap["design"][tRow][c]
            end repeat
            break
         case "floor"
            add 1 to tRow
            put 0 into c
            repeat for each word tW in tLine
               add 1 to c
               put tW into sMap["floor"][tRow][c]
            end repeat
            break
         case "slope"
            put item 1 of tLine into tCell
            put item 2 of tLine into tW
            put offset(",", tCell) into i
            if i < 2 or the number of words of tW is not 4 then break
            put char i + 1 to -1 of tCell into tR
            put char 1 to i - 1 of tCell into c
            put (word 1 of tW + 0) & comma & (word 2 of tW + 0) & comma & (word 3 of tW + 0) & comma & (word 4 of tW + 0) into sMap["slope"][tR][c]
            break
      end switch
   end repeat
   put sMap["meta"]["cols"] into tCols
   put sMap["meta"]["rows"] into tRows
   if tCols is not round(2 * kHalfW / kTile) + 2 or tRows is not round(2 * kHalfD / kTile) + 2 or sMap["meta"]["cell"] is not kTile then
      put empty into sMap
      put "WALLS FILE IS NOT 20 X 10 CELLS OF 40: A PLAIN ARENA" into sMap["problem"]
      exit PB.ReadWalls
   end if
   put tCols into sMap["cols"]
   put tRows into sMap["rows"]
   if sMap["meta"]["wallH"] is a number then
      put sMap["meta"]["wallH"] / 100 into sMap["hu"]
   else
      put 1 into sMap["hu"]
   end if
   if sMap["meta"]["step"] is a number then
      put sMap["meta"]["step"] into sMap["step"]
   else
      put 30 into sMap["step"]
   end if
end PB.ReadWalls

-- the blocks, ramps and emblems the map holds
on PB.MakeFeatures
   local c, r, tF, tTop, tX0, tZ0, tS
   put empty into sFeat
   put empty into sBlocks
   put 0 into sFeatTop
   put empty into sEmblem
   put 0 into sEmblem["count"]
   put 15 into sStepUp
   if sMap["cols"] is not a number then exit PB.MakeFeatures
   put sMap["step"] * sMap["hu"] into sStepUp
   repeat with r = 2 to sMap["rows"] - 1
      repeat with c = 2 to sMap["cols"] - 1
         put sMap["floor"][r][c] into tF
         if tF is not a number then put 1 into tF
         put (c - 1 - sMap["cols"] / 2) * kTile into tX0
         put (r - 1 - sMap["rows"] / 2) * kTile into tZ0
         put sMap["slope"][r][c] into tS
         if tS is not empty then
            put "slope" into sFeat[c & comma & r]
            set the itemDel to comma
            put max(sFeatTop, (tF - 1 + max(item 1 of tS, item 2 of tS, item 3 of tS, item 4 of tS)) * sMap["hu"]) into sFeatTop
         else if tF > 1 then
            put "block" into sFeat[c & comma & r]
            put (tF - 1) * sMap["hu"] into tTop
            put tX0 & comma & (tX0 + kTile) & comma & tZ0 & comma & (tZ0 + kTile) & comma & tTop & return after sBlocks
            put max(sFeatTop, tTop) into sFeatTop
         end if
      end repeat
   end repeat
   if char -1 of sBlocks is return then delete char -1 of sBlocks
   PB.FindEmblems
end PB.MakeFeatures

-- emblems: a letter (not # . or a space) on a wall cell; next cells with the same letter are one
-- emblem. Far wall: from/to are x; the back walls (-1 west, 1 east): z
on PB.FindEmblems
   local c, r, tCols, tRows
   put sMap["cols"] into tCols
   put sMap["rows"] into tRows
   repeat with c = 2 to tCols - 1
      PB.EmblemCell "far", sMap["design"][tRows][c], (c - 1 - tCols / 2) * kTile
   end repeat
   PB.EmblemCell "far", empty, 0
   repeat with r = 2 to tRows - 1
      PB.EmblemCell "-1", sMap["design"][r][1], (r - 1 - tRows / 2) * kTile
   end repeat
   PB.EmblemCell "-1", empty, 0
   repeat with r = 2 to tRows - 1
      PB.EmblemCell "1", sMap["design"][r][tCols], (r - 1 - tRows / 2) * kTile
   end repeat
   PB.EmblemCell "1", empty, 0
end PB.FindEmblems

on PB.EmblemCell pWall, pChar, pFrom
   local n
   put sEmblem["count"] into n
   if pChar is empty or pChar is among the items of "#,., " or pChar is space then
      put empty into sEmblem["open"]
      exit PB.EmblemCell
   end if
   if sEmblem["open"] is n and n > 0 and sEmblem[n]["char"] is pChar and sEmblem[n]["wall"] is pWall and sEmblem[n]["to"] is pFrom then
      put pFrom + kTile into sEmblem[n]["to"]
      exit PB.EmblemCell
   end if
   add 1 to n
   put n into sEmblem["count"]
   put n into sEmblem["open"]
   put pChar into sEmblem[n]["char"]
   put pWall into sEmblem[n]["wall"]
   put pFrom into sEmblem[n]["from"]
   put pFrom + kTile into sEmblem[n]["to"]
   switch pWall
      case "far"
         put "#FFD040" into sEmblem[n]["color"]
         break
      case "-1"
         put kPromptColor into sEmblem[n]["color"]
         break
      default
         put kGlazeColor into sEmblem[n]["color"]
   end switch
end PB.EmblemCell

-- the ball struck wall pWall at pPos (x on the far wall, z on a back wall): which emblem?
on PB.EmblemHit @pB, pWall, pPos
   local i
   repeat with i = 1 to sEmblem["count"]
      if sEmblem[i]["wall"] is pWall and pPos >= sEmblem[i]["from"] and pPos < sEmblem[i]["to"] then
         put i into pB["emblem"]
         if pWall is "far" then add 1 to pB["stars"]
         exit repeat
      end if
   end repeat
end PB.EmblemHit

-- the real ball struck emblem pN: it flashes; a back wall's emblem mends a square of its hero's
-- half (once a throw)
on PB.EmblemStruck pN
   local tName
   if sEmblem[pN]["key"] is not empty then
      Entity.SetColor sEmblem[pN]["key"], "#FFFFFF"
      put sTicks + 8 into sEmblem[pN]["flash"]
   end if
   if sEmblem[pN]["wall"] is "far" then
      PB.Message "STAR +1"
      exit PB.EmblemStruck
   end if
   if sBall["mended"] is not empty then exit PB.EmblemStruck
   put true into sBall["mended"]
   if sEmblem[pN]["wall"] < 0 then
      put "PROMPT" into tName
   else
      put "GLAZE" into tName
   end if
   PB.MendOne tName
end PB.EmblemStruck

-- mend the worst square on pName's half (a hole first, then broken, then cracked), the one
-- nearest the hero
on PB.MendOne pName
   local tT, tLevel, tBest, tBestLevel, tBestD, tD, tX, tZ
   put 0 into tBestLevel
   put 1e9 into tBestD
   set the itemDel to comma
   repeat for each key tT in sTile
      put PB.TileLevel(tT) into tLevel
      put -kHalfW + (item 1 of tT - 0.5) * kTile into tX
      put -kHalfD + (item 2 of tT - 0.5) * kTile into tZ
      if tX * sHero[pName]["side"] <= 0 or tLevel < 1 then next repeat
      put (tX - sHero[pName]["x"]) ^ 2 + (tZ - sHero[pName]["z"]) ^ 2 into tD
      if tLevel > tBestLevel or (tLevel is tBestLevel and tD < tBestD) then
         put tLevel into tBestLevel
         put tD into tBestD
         put tT into tBest
      end if
   end repeat
   if tBest is empty then exit PB.MendOne
   PB.SetTile tBest, 0
   PB.Message pName & "'S EMBLEM MENDS A SQUARE"
   PB.Say "mend", pName, 60
end PB.MendOne

-- the walls' features drawn: ledges and the pillar as wire blocks, ramps with their slope
-- hatched, emblems flat on the walls (each its own object: it flashes when struck)
on PB.BuildFeatures
   local tLow, tTall, tRamp, tLine, tA, tK, c, r, i, tN
   put Mesh.New() into tLow
   put Mesh.New() into tTall
   put Mesh.New() into tRamp
   put 0 into tN
   set the itemDel to comma
   repeat for each line tLine in sBlocks
      if item 5 of tLine <= kJumpV * kJumpV / (2 * kHeroGrav) then
         PB.BoxLines tLow, item 1 of tLine, item 2 of tLine, item 3 of tLine, item 4 of tLine, item 5 of tLine
      else
         PB.BoxLines tTall, item 1 of tLine, item 2 of tLine, item 3 of tLine, item 4 of tLine, item 5 of tLine
      end if
   end repeat
   repeat for each key tK in sFeat
      if sFeat[tK] is not "slope" then next repeat
      PB.RampLines tRamp, item 1 of tK, item 2 of tK
   end repeat
   if PB.HasLines(tLow) then
      Mesh.Define "PB.Ledges", tLow
      get Entity.Spawn("PB.Ledges", 0, 0, 0, "#50E0A0")
   end if
   if PB.HasLines(tTall) then
      Mesh.Define "PB.Pillars", tTall
      get Entity.Spawn("PB.Pillars", 0, 0, 0, "#8090FF")
   end if
   if PB.HasLines(tRamp) then
      Mesh.Define "PB.Ramps", tRamp
      get Entity.Spawn("PB.Ramps", 0, 0, 0, "#C080FF")
   end if
   repeat with i = 1 to sEmblem["count"]
      Mesh.Define "PB.Emblem." & i, PB.EmblemMesh(i)
      put Entity.Spawn("PB.Emblem." & i, 0, 0, 0, sEmblem[i]["color"]) into sEmblem[i]["key"]
      put empty into sEmblem[i]["flash"]
   end repeat
end PB.BuildFeatures

-- a mesh with something in it (the engine and its stand-ins both count vertices)
function PB.HasLines pMesh
   return pMesh["count"] > 0
end PB.HasLines

-- a block's wire: its top and the four uprights
on PB.BoxLines @pM, pX0, pX1, pZ0, pZ1, pTop
   local tA
   put PB.Line(pM, pX0, pTop, pZ0, pX1, pTop, pZ0) into tA
   put PB.Line(pM, pX1, pTop, pZ0, pX1, pTop, pZ1) into tA
   put PB.Line(pM, pX1, pTop, pZ1, pX0, pTop, pZ1) into tA
   put PB.Line(pM, pX0, pTop, pZ1, pX0, pTop, pZ0) into tA
   put PB.Line(pM, pX0, 0, pZ0, pX0, pTop, pZ0) into tA
   put PB.Line(pM, pX1, 0, pZ0, pX1, pTop, pZ0) into tA
   put PB.Line(pM, pX1, 0, pZ1, pX1, pTop, pZ1) into tA
   put PB.Line(pM, pX0, 0, pZ1, pX0, pTop, pZ1) into tA
end PB.BoxLines

-- a ramp cell: its four sloped edges, three lines across it, uprights under the raised corners
on PB.RampLines @pM, pC, pR
   local tX0, tX1, tZ0, tZ1, tNW, tNE, tSE, tSW, tA, u, tH0, tH1
   put (pC - 1 - sMap["cols"] / 2) * kTile into tX0
   put tX0 + kTile into tX1
   put (pR - 1 - sMap["rows"] / 2) * kTile into tZ0
   put tZ0 + kTile into tZ1
   put PB.GroundAt(tX0 + 0.01, tZ0 + 0.01) into tNW
   put PB.GroundAt(tX1 - 0.01, tZ0 + 0.01) into tNE
   put PB.GroundAt(tX1 - 0.01, tZ1 - 0.01) into tSE
   put PB.GroundAt(tX0 + 0.01, tZ1 - 0.01) into tSW
   put PB.Line(pM, tX0, tNW, tZ0, tX1, tNE, tZ0) into tA
   put PB.Line(pM, tX1, tNE, tZ0, tX1, tSE, tZ1) into tA
   put PB.Line(pM, tX1, tSE, tZ1, tX0, tSW, tZ1) into tA
   put PB.Line(pM, tX0, tSW, tZ1, tX0, tNW, tZ0) into tA
   repeat for each item u in "0.25,0.5,0.75"
      if abs(tNW - tNE) + abs(tSW - tSE) >= abs(tNW - tSW) + abs(tNE - tSE) then
         -- it rises along x: lines across at constant x
         put tNW + (tNE - tNW) * u into tH0
         put tSW + (tSE - tSW) * u into tH1
         put PB.Line(pM, tX0 + kTile * u, tH0, tZ0, tX0 + kTile * u, tH1, tZ1) into tA
      else
         put tNW + (tSW - tNW) * u into tH0
         put tNE + (tSE - tNE) * u into tH1
         put PB.Line(pM, tX0, tH0, tZ0 + kTile * u, tX1, tH1, tZ0 + kTile * u) into tA
      end if
   end repeat
   if tNW > 1 then put PB.Line(pM, tX0, 0, tZ0, tX0, tNW, tZ0) into tA
   if tNE > 1 then put PB.Line(pM, tX1, 0, tZ0, tX1, tNE, tZ0) into tA
   if tSE > 1 then put PB.Line(pM, tX1, 0, tZ1, tX1, tSE, tZ1) into tA
   if tSW > 1 then put PB.Line(pM, tX0, 0, tZ1, tX0, tSW, tZ1) into tA
end PB.RampLines

-- an emblem: its letter drawn flat on the wall face (64 high, about 100 up), between two
-- uprights floor to roof that mark where on the wall it counts (at any height)
function PB.EmblemMesh pN
   local tM, tA, tLine, tFrom, tTo, tW, tWall, x1, y1, x2, y2, tP1, tP2, tSize, tMid
   put Mesh.New() into tM
   put sEmblem[pN]["from"] into tFrom
   put sEmblem[pN]["to"] into tTo
   put sEmblem[pN]["wall"] into tWall
   put min(64, (tTo - tFrom) * 0.8) into tSize
   put (tFrom + tTo) / 2 into tMid
   set the itemDel to comma
   repeat for each line tLine in PB.GlyphStrokes(sEmblem[pN]["char"]) & return & "0,0,0,1" & return & "1,0,1,1" & return & "0,1,1,1" & return & "0,0,1,0"
      if tLine is empty then next repeat
      put tMid + (item 1 of tLine - 0.5) * tSize into x1
      put 68 + item 2 of tLine * tSize into y1
      put tMid + (item 3 of tLine - 0.5) * tSize into x2
      put 68 + item 4 of tLine * tSize into y2
      -- along the wall seen from the arena: the far wall left to right is +x; the west wall
      -- runs +z, the east wall -z
      switch tWall
         case "far"
            put PB.Line(tM, x1, y1, kHalfD - 1, x2, y2, kHalfD - 1) into tA
            break
         case "-1"
            put PB.Line(tM, -kHalfW + 1, y1, x1, -kHalfW + 1, y2, x2) into tA
            break
         default
            put PB.Line(tM, kHalfW - 1, y1, 2 * tMid - x1, kHalfW - 1, y2, 2 * tMid - x2) into tA
      end switch
   end repeat
   -- the strip
   repeat for each item tP1 in tFrom & comma & tTo
      switch tWall
         case "far"
            put PB.Line(tM, tP1, 0, kHalfD - 1, tP1, kTop, kHalfD - 1) into tA
            break
         case "-1"
            put PB.Line(tM, -kHalfW + 1, 0, tP1, -kHalfW + 1, kTop, tP1) into tA
            break
         default
            put PB.Line(tM, kHalfW - 1, 0, tP1, kHalfW - 1, kTop, tP1) into tA
      end switch
   end repeat
   return tM
end PB.EmblemMesh

-- the strokes of an emblem letter in a unit square (x right, y up), a line each "x1,y1,x2,y2";
-- a letter not here is a diamond
function PB.GlyphStrokes pChar
   switch pChar
      case "*"
         return "0.5,0,0.5,1" & return & "0,0.5,1,0.5" & return & "0.15,0.15,0.85,0.85" & return & "0.15,0.85,0.85,0.15"
      case "P"
         return "0.25,0,0.25,1" & return & "0.25,1,0.7,1" & return & "0.7,1,0.85,0.85" & return & "0.85,0.85,0.85,0.65" & return & \
               "0.85,0.65,0.7,0.5" & return & "0.7,0.5,0.25,0.5"
      case "G"
         return "0.85,0.85,0.7,1" & return & "0.7,1,0.3,1" & return & "0.3,1,0.15,0.85" & return & "0.15,0.85,0.15,0.15" & return & \
               "0.15,0.15,0.3,0" & return & "0.3,0,0.7,0" & return & "0.7,0,0.85,0.15" & return & "0.85,0.15,0.85,0.5" & return & "0.85,0.5,0.5,0.5"
      default
         return "0.5,0.05,0.95,0.5" & return & "0.95,0.5,0.5,0.95" & return & "0.5,0.95,0.05,0.5" & return & "0.05,0.5,0.5,0.05"
   end switch
end PB.GlyphStrokes

-------------------------------------------------------------------- the ground

function PB.FloorDiv pN
   if pN < 0 and trunc(pN) is not pN then return trunc(pN) - 1
   return trunc(pN)
end PB.FloorDiv

-- "col,row" of the walls map under x,z (the same cell as CellMap.CellAt)
function PB.CellOf pX, pZ
   return (PB.FloorDiv(pX / kTile) + round(kHalfW / kTile) + 2) & comma & (PB.FloorDiv(pZ / kTile) + round(kHalfD / kTile) + 2)
end PB.CellOf

-- the ground (engine units up) at x,z: 0 on the floor, a block's top, a ramp's height there
-- (the cell's corners blended as CellMap.RiseAt does)
function PB.GroundAt pX, pZ
   local tKey, tC, tR, tF, tS, u, v
   if sFeat is empty then return 0
   put PB.CellOf(pX, pZ) into tKey
   if sFeat[tKey] is empty then return 0
   set the itemDel to comma
   put item 1 of tKey into tC
   put item 2 of tKey into tR
   put sMap["floor"][tR][tC] into tF
   if tF is not a number then put 1 into tF
   put sMap["slope"][tR][tC] into tS
   if tS is empty then return (tF - 1) * sMap["hu"]
   put pX / kTile - PB.FloorDiv(pX / kTile) into u
   put pZ / kTile - PB.FloorDiv(pZ / kTile) into v
   return (tF - 1 + item 1 of tS * (1 - u) * (1 - v) + item 2 of tS * u * (1 - v) + item 3 of tS * u * v + item 4 of tS * (1 - u) * v) * sMap["hu"]
end PB.GroundAt

-- the ground's normal "nx,ny,nz" at x,z (flat: 0,1,0)
function PB.Normal pX, pZ
   local tKey, tS, u, v, tGX, tGZ, tL
   if sFeat is empty then return "0,1,0"
   put PB.CellOf(pX, pZ) into tKey
   if sFeat[tKey] is not "slope" then return "0,1,0"
   set the itemDel to comma
   put sMap["slope"][item 2 of tKey][item 1 of tKey] into tS
   put pX / kTile - PB.FloorDiv(pX / kTile) into u
   put pZ / kTile - PB.FloorDiv(pZ / kTile) into v
   put ((item 2 of tS - item 1 of tS) * (1 - v) + (item 3 of tS - item 4 of tS) * v) * sMap["hu"] / kTile into tGX
   put ((item 4 of tS - item 1 of tS) * (1 - u) + (item 3 of tS - item 2 of tS) * u) * sMap["hu"] / kTile into tGZ
   put sqrt(tGX ^ 2 + 1 + tGZ ^ 2) into tL
   return (-tGX / tL) & comma & (1 / tL) & comma & (-tGZ / tL)
end PB.Normal

-- the highest ground under a hero's feet at x,z (its middle and four points round it)
function PB.FootGround pX, pZ
   local k
   if sFeat is empty then return 0
   put kHeroR * 0.7 into k
   return max(PB.GroundAt(pX, pZ), PB.GroundAt(pX - k, pZ), PB.GroundAt(pX + k, pZ), PB.GroundAt(pX, pZ - k), PB.GroundAt(pX, pZ + k))
end PB.FootGround

-- a hero at height pH cannot go to x,z: the ground there is more than a step up
function PB.Blocked pX, pZ, pH
   return PB.FootGround(pX, pZ) > pH + sStepUp
end PB.Blocked

function PB.OnGround pName
   return sHero[pName]["state"] is empty and sHero[pName]["vh"] is 0 and sHero[pName]["h"] <= sHero[pName]["g"] + 0.5
end PB.OnGround

-------------------------------------------------------------------- the floor breaks

-- floor squares: [col,row] col 1..18 west to east, row 1..8 camera side to far wall. sTile:
-- empty whole, cracked, broken, hole. A square under a ledge or a ramp never breaks.
function PB.TileOf pX, pZ
   return (trunc((pX + kHalfW) / kTile) + 1) & "," & (trunc((pZ + kHalfD) / kTile) + 1)
end PB.TileOf

-- is there floor under x,z?
function PB.Solid pX, pZ
   if abs(pX) >= kHalfW or abs(pZ) >= kHalfD then return true
   return sTile[PB.TileOf(pX, pZ)] is not "hole"
end PB.Solid

-- 0 whole, 1 cracked, 2 broken, 3 hole
function PB.TileLevel pT
   switch sTile[pT]
      case "cracked"
         return 1
      case "broken"
         return 2
      case "hole"
         return 3
   end switch
   return 0
end PB.TileLevel

-- a square under a ledge or a ramp
function PB.FeatTile pT
   set the itemDel to comma
   return sFeat[(item 1 of pT + 1) & comma & (item 2 of pT + 1)] is not empty
end PB.FeatTile

-- a square at level pLevel (0 mends it), drawn
on PB.SetTile pT, pLevel
   local tC, tR, tX, tZ
   if PB.FeatTile(pT) then exit PB.SetTile
   set the itemDel to comma
   put item 1 of pT into tC
   put item 2 of pT into tR
   if tC < 1 or tR < 1 or tC > round(2 * kHalfW / kTile) or tR > round(2 * kHalfD / kTile) then exit PB.SetTile
   if sTileKey[pT] is not empty then Entity.Kill sTileKey[pT]
   delete variable sTileKey[pT]
   delete variable sTileTint[pT]
   if pLevel is not 2 then delete variable sCrumble[pT]
   put -kHalfW + (tC - 0.5) * kTile into tX
   put -kHalfD + (tR - 0.5) * kTile into tZ
   switch pLevel
      case 1
         put "cracked" into sTile[pT]
         put Entity.Spawn("PB.Crack", tX, -1, tZ, "#C08030") into sTileKey[pT]
         break
      case 2
         put "broken" into sTile[pT]
         put Entity.Spawn("PB.Broken", tX, -1, tZ, "#FF9040") into sTileKey[pT]
         break
      case 3
         put "hole" into sTile[pT]
         put Entity.Spawn("PB.Hole", tX, 0, tZ, "#FF5030") into sTileKey[pT]
         break
      default
         delete variable sTile[pT]
   end switch
end PB.SetTile

on PB.AtLeast pT, pLevel
   if PB.TileLevel(pT) < pLevel then PB.SetTile pT, pLevel
end PB.AtLeast

-- the eight squares round col,row one step worse, never past pCap
on PB.Around pC, pR, pCap
   local dc, dr, tT
   repeat with dc = -1 to 1
      repeat with dr = -1 to 1
         if dc is 0 and dr is 0 then next repeat
         put (pC + dc) & comma & (pR + dr) into tT
         if PB.TileLevel(tT) < pCap then PB.SetTile tT, PB.TileLevel(tT) + 1
      end repeat
   end repeat
end PB.Around

-- the ball bounced on the floor at x,z (pFirst: its first touch this throw): this match's rule
--   1 the first touch breaks that square        2 every bounce breaks the square
--   3 and cracks the eight round it (a cracked one breaks)
--   4 every bounce punches a hole; the eight round it a step worse (crack, break, hole)
on PB.Bounce pX, pZ, pFirst
   local tT, tWas, tNow
   if abs(pX) >= kHalfW or abs(pZ) >= kHalfD then exit PB.Bounce
   if PB.GroundAt(pX, pZ) > 0 then exit PB.Bounce
   put PB.TileOf(pX, pZ) into tT
   if PB.FeatTile(tT) or not PB.Solid(pX, pZ) then exit PB.Bounce
   put PB.TileLevel(tT) into tWas
   set the itemDel to comma
   switch PB.Rule()
      case 1
         if pFirst then PB.AtLeast tT, 2
         break
      case 2
         PB.AtLeast tT, 2
         break
      case 3
         PB.AtLeast tT, 2
         PB.Around item 1 of tT, item 2 of tT, 2
         break
      default
         PB.AtLeast tT, 3
         PB.Around item 1 of tT, item 2 of tT, 3
   end switch
   put PB.TileLevel(tT) into tNow
   if tNow > tWas then
      if tNow is 3 then
         PB.Message "THE BALL PUNCHED A HOLE"
      else if not (sMsgUntil is a number and sTicks < sMsgUntil) then
         PB.Message "THE FLOOR BREAKS"
      end if
      PB.Say "crack", "*", 30
   end if
end PB.Bounce

-- each step: a broken square someone stepped off (match 1) or onto (match 2 on) falls apart
-- when its time comes, blinking until then; struck emblems stop flashing
on PB.FloorTick
   local tName, tNow, tWas, tT, tKeys, tLeft, tTint, i
   repeat for each item tName in "PROMPT,GLAZE"
      put empty into tNow
      if sHero[tName]["state"] is empty and sHero[tName]["g"] <= 0 and sHero[tName]["h"] <= 0.5 then put PB.TileOf(sHero[tName]["x"], sHero[tName]["z"]) into tNow
      put sHero[tName]["onTile"] into tWas
      if tWas is not empty and tWas is not tNow and sTile[tWas] is "broken" and sCrumble[tWas] is empty then
         put sTicks + round(PB.CrumbleMS("off") / sStepMS) into sCrumble[tWas]
      end if
      if tNow is not empty and sTile[tNow] is "broken" and sCrumble[tNow] is empty and PB.Rule() >= 2 then
         put sTicks + round(PB.CrumbleMS("on") / sStepMS) into sCrumble[tNow]
         PB.Message "IT CRUMBLES UNDER " & tName
      end if
      put tNow into sHero[tName]["onTile"]
   end repeat
   put the keys of sCrumble into tKeys
   repeat for each line tT in tKeys
      put sCrumble[tT] - sTicks into tLeft
      if tLeft <= 0 then
         PB.SetTile tT, 3
         PB.Say "crumble", "*", 40
      else if sTileKey[tT] is not empty then
         if tLeft mod 6 < 3 then
            put "#FFFFFF" into tTint
         else
            put "#FF9040" into tTint
         end if
         if sTileTint[tT] is not tTint then
            Entity.SetColor sTileKey[tT], tTint
            put tTint into sTileTint[tT]
         end if
      end if
   end repeat
   repeat with i = 1 to sEmblem["count"]
      if sEmblem[i]["flash"] is a number and sTicks >= sEmblem[i]["flash"] then
         Entity.SetColor sEmblem[i]["key"], sEmblem[i]["color"]
         put empty into sEmblem[i]["flash"]
      end if
   end repeat
end PB.FloorTick

on PB.MendFloor
   local tT
   repeat for each key tT in sTileKey
      if sTileKey[tT] is not empty then Entity.Kill sTileKey[tT]
   end repeat
   put empty into sTileKey
   put empty into sTile
   put empty into sCrumble
   put empty into sTileTint
end PB.MendFloor

-- the ball fell through: a drop for whoever's half it fell in; they get it back
on PB.BallLost
   local tOwner
   put PB.OwnerAt(sBall["x"]) into tOwner
   if sBall["touched"] is empty then PB.Drop tOwner
   PB.Message "THE PIT TOOK THE BALL"
   PB.GiveBall tOwner
end PB.BallLost

-------------------------------------------------------------------- falling, hanging, climbing out

-- how long a hero can hang (steps) and how fast it climbs out, by its stamina
function PB.GripSteps pName
   local tS
   put max(0, min(100, sHero[pName]["stamina"])) into tS
   return round((kGripMinMS + (kGripMaxMS - kGripMinMS) * tS / 100) / sStepMS)
end PB.GripSteps

function PB.ClimbRate pName
   local tS
   put max(0, min(100, sHero[pName]["stamina"])) into tS
   return kClimbMinRate + (1 - kClimbMinRate) * tS / 100
end PB.ClimbRate

-- jumps, ledges, ramps, falls into holes, Harold Lloyd's grab, hang and climb out
on PB.HeroFall pName
   local tG, tLandV, tN, tF, tFPS, tSpot
   switch sHero[pName]["state"]
      case "grab"
         put sClip["climb"]["fps"] into tFPS
         if tFPS is not a number then put 30 into tFPS
         add tFPS * sStepMS / 1000 to sHero[pName]["hangFrame"]
         if sClip["climb"]["frames"] is not a number or sHero[pName]["hangFrame"] >= sClip["climb"]["frames"] + 1 then
            put "hang" into sHero[pName]["state"]
            put 1 into sHero[pName]["hangFrame"]
            put 0 into sHero[pName]["hangT"]
         end if
         break
      case "hang"
         add 1 to sHero[pName]["hangT"]
         put sClip["hang"]["fps"] into tFPS
         if tFPS is not a number then put 30 into tFPS
         add tFPS * sStepMS / 1000 to sHero[pName]["hangFrame"]
         put sClip["hang"]["frames"] into tN
         if tN is a number and tN >= 1 and sHero[pName]["hangFrame"] >= tN + 1 then subtract tN from sHero[pName]["hangFrame"]
         if (pName is not sActive or sTestAuto is true) and sHero[pName]["hangT"] >= round(kAIHangMS / sStepMS) then
            PB.ClimbOut pName
         else if sHero[pName]["hangT"] >= sHero[pName]["grip"] then
            PB.LoseGrip pName
         end if
         break
      case "recover"
         put sClip["recover"]["frames"] into tN
         put sClip["recover"]["fps"] into tFPS
         if tFPS is not a number then put 30 into tFPS
         if tN is not a number or tN < 2 then put 30 into tN
         add tFPS * sStepMS / 1000 * sHero[pName]["climbRate"] to sHero[pName]["hangFrame"]
         put min(1, (sHero[pName]["hangFrame"] - 1) / tN) into tF
         put sHero[pName]["fromX"] + (sHero[pName]["toX"] - sHero[pName]["fromX"]) * tF into sHero[pName]["x"]
         put sHero[pName]["fromZ"] + (sHero[pName]["toZ"] - sHero[pName]["fromZ"]) * tF into sHero[pName]["z"]
         put -56 * (1 - tF) into sHero[pName]["h"]
         if tF >= 1 then
            if PB.TileLevel(PB.TileOf(sHero[pName]["toX"], sHero[pName]["toZ"])) >= 3 then
               put PB.SafeSpot(pName) into tSpot
               put item 1 of tSpot into sHero[pName]["x"]
               put item 2 of tSpot into sHero[pName]["z"]
            end if
            put empty into sHero[pName]["state"]
            put 0 into sHero[pName]["h"]
            put 0 into sHero[pName]["vh"]
            put 0 into sHero[pName]["g"]
            PB.StaminaAdd pName, -5, "CLIMBED OUT"
         end if
         break
      case "fall"
         subtract kHeroGrav from sHero[pName]["vh"]
         add sHero[pName]["vh"] to sHero[pName]["h"]
         if sHero[pName]["h"] < -48 and sHero[pName]["hangs"] > 0 and sHero[pName]["last"] is not true and sHero[pName]["nohang"] is not true then
            PB.Grab pName
         else if sHero[pName]["h"] < -160 and sHero[pName]["last"] is not true then
            -- no hang caught it: a fatal fall (climbing out never counts)
            put true into sHero[pName]["last"]
            add 1 to sHero[pName]["falls"]
            if sHero[pName]["falls"] >= kMaxFalls then
               PB.GameOver pName
            end if
         else if sHero[pName]["h"] < -420 then
            PB.Respawn pName
         end if
         break
      default
         put PB.FootGround(sHero[pName]["x"], sHero[pName]["z"]) into tG
         put tG into sHero[pName]["g"]
         if sHero[pName]["vh"] is not 0 or sHero[pName]["h"] > tG + 0.01 then
            if sHero[pName]["vh"] is 0 and sHero[pName]["h"] - tG <= sStepUp then
               -- walking down a ramp or off a low step
               put tG into sHero[pName]["h"]
            else
               subtract kHeroGrav from sHero[pName]["vh"]
               add sHero[pName]["vh"] to sHero[pName]["h"]
               if sHero[pName]["h"] <= tG then
                  if tG > 0 or PB.Solid(sHero[pName]["x"], sHero[pName]["z"]) then
                     put sHero[pName]["vh"] into tLandV
                     put tG into sHero[pName]["h"]
                     put 0 into sHero[pName]["vh"]
                     if tG <= 0 and -tLandV > kSmashV and sTile[PB.TileOf(sHero[pName]["x"], sHero[pName]["z"])] is "broken" then
                        PB.Smash pName
                     end if
                  else
                     PB.StartFall pName
                  end if
               end if
            end if
         else
            put tG into sHero[pName]["h"]
            if tG <= 0 and not PB.Solid(sHero[pName]["x"], sHero[pName]["z"]) then PB.StartFall pName
         end if
   end switch
end PB.HeroFall

on PB.StartFall pName
   put false into sHero[pName]["last"]
   put false into sHero[pName]["nohang"]
   put "fall" into sHero[pName]["state"]
   put min(0, sHero[pName]["vh"]) into sHero[pName]["vh"]
   put min(-0.01, sHero[pName]["h"]) into sHero[pName]["h"]
   put 0 into sHero[pName]["speed"]
   put empty into sHero[pName]["onTile"]
end PB.StartFall

-- landed from a jump on a broken square: through it, and no hang can catch you
on PB.Smash pName
   PB.SetTile PB.TileOf(sHero[pName]["x"], sHero[pName]["z"]), 3
   PB.StartFall pName
   put true into sHero[pName]["nohang"]
   PB.Message pName & " SMASHED THROUGH"
   PB.Say "smash", pName, 100
end PB.Smash

-- caught the edge: Lloyd reaches up and takes hold (then hangs), facing the floor he will
-- climb out onto
on PB.Grab pName
   local tSafe, tT, tCX, tCZ, tDX, tDZ
   subtract 1 from sHero[pName]["hangs"]
   put PB.SafeSpot(pName) into tSafe
   set the itemDel to comma
   put item 1 of tSafe into sHero[pName]["toX"]
   put item 2 of tSafe into sHero[pName]["toZ"]
   put PB.TileOf(sHero[pName]["x"], sHero[pName]["z"]) into tT
   put -kHalfW + (item 1 of tT - 0.5) * kTile into tCX
   put -kHalfD + (item 2 of tT - 0.5) * kTile into tCZ
   put sHero[pName]["toX"] - tCX into tDX
   put sHero[pName]["toZ"] - tCZ into tDZ
   -- hang from the hole's edge nearest the way out
   if abs(tDX) >= abs(tDZ) then
      put tCX + PB.Sign(tDX) * (kTile / 2 - 6) into sHero[pName]["x"]
      put tCZ into sHero[pName]["z"]
   else
      put tCX into sHero[pName]["x"]
      put tCZ + PB.Sign(tDZ) * (kTile / 2 - 6) into sHero[pName]["z"]
   end if
   put sHero[pName]["x"] into sHero[pName]["fromX"]
   put sHero[pName]["z"] into sHero[pName]["fromZ"]
   put atan2(sHero[pName]["toX"] - sHero[pName]["x"], sHero[pName]["toZ"] - sHero[pName]["z"]) into sHero[pName]["hangYaw"]
   put "grab" into sHero[pName]["state"]
   put 1 into sHero[pName]["hangFrame"]
   put 0 into sHero[pName]["hangT"]
   put -56 into sHero[pName]["h"]
   put 0 into sHero[pName]["vh"]
   put empty into sHero[pName]["act"]
   put PB.GripSteps(pName) into sHero[pName]["grip"]
   put PB.ClimbRate(pName) into sHero[pName]["climbRate"]
   PB.Message pName & " HANGS ON"
   PB.Say "hang", pName, 80
end PB.Grab

-- climb out (the player's SPACE / W / UP while hanging or still taking hold; the companion's
-- own time)
on PB.ClimbOut pName
   local tSafe
   if sHero[pName]["state"] is not "hang" and sHero[pName]["state"] is not "grab" then exit PB.ClimbOut
   if PB.TileLevel(PB.TileOf(sHero[pName]["toX"], sHero[pName]["toZ"])) >= 2 then
      put PB.SafeSpot(pName) into tSafe
      put item 1 of tSafe into sHero[pName]["toX"]
      put item 2 of tSafe into sHero[pName]["toZ"]
   end if
   put sHero[pName]["x"] into sHero[pName]["fromX"]
   put sHero[pName]["z"] into sHero[pName]["fromZ"]
   put PB.ClimbRate(pName) into sHero[pName]["climbRate"]
   put "recover" into sHero[pName]["state"]
   put 1 into sHero[pName]["hangFrame"]
end PB.ClimbOut

-- held on too long: the grip gives, down into the dark
on PB.LoseGrip pName
   put "fall" into sHero[pName]["state"]
   put false into sHero[pName]["last"]
   put true into sHero[pName]["nohang"]
   put 0 into sHero[pName]["vh"]
   PB.Message pName & " LOST THE GRIP"
   PB.Say "grip", pName, 100
end PB.LoseGrip

-- out of hangs: the fall costs points, back at your spot
on PB.Respawn pName
   local tSpot
   put max(0, sHero[pName]["score"] - kFallCost) into sHero[pName]["score"]
   put sHero[pName]["side"] * kHalfW * 0.55 into sHero[pName]["x"]
   put 0 into sHero[pName]["z"]
   put PB.SafeSpot(pName) into tSpot
   put item 1 of tSpot into sHero[pName]["x"]
   put item 2 of tSpot into sHero[pName]["z"]
   put empty into sHero[pName]["state"]
   put 0 into sHero[pName]["h"]
   put 0 into sHero[pName]["vh"]
   put 0 into sHero[pName]["g"]
   put false into sHero[pName]["nohang"]
   PB.Message pName & " FELL   -" & kFallCost
   PB.Say "fall", pName, 100
end PB.Respawn

-- the middle of the nearest whole (or only cracked) square on pName's half, not under a ledge
function PB.SafeSpot pName
   local tC, tR, tX, tZ, tD, tBest, tBestD, tSide
   put sHero[pName]["side"] into tSide
   put 1e9 into tBestD
   repeat with tC = 1 to round(2 * kHalfW / kTile)
      put -kHalfW + (tC - 0.5) * kTile into tX
      if tX * tSide < kMid + kHeroR then next repeat
      repeat with tR = 1 to round(2 * kHalfD / kTile)
         if PB.TileLevel(tC & "," & tR) >= 2 or PB.FeatTile(tC & "," & tR) then next repeat
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
end PB.SafeSpot

-- would a jump land safely at x,z: inside, floor there, not a broken square
function PB.SafeLanding pX, pZ
   if abs(pX) >= kHalfW or abs(pZ) >= kHalfD then return false
   if PB.GroundAt(pX, pZ) > 0 then return true
   return PB.TileLevel(PB.TileOf(pX, pZ)) < 2
end PB.SafeLanding

-- the third fall: the end
on PB.GameOver pName
   local tMid
   put true into sOver
   put (gViewLeft + gViewRight) / 2 into tMid
   HUD.Remove "PB.Intro1"
   HUD.Remove "PB.Intro2"
   HUD.Remove "PB.Intro3"
   HUD.Set "PB.Over1", "GAME OVER", tMid - 90, gViewTop + 190, 20
   HUD.Set "PB.Over2", pName & " FELL " & kMaxFalls & " TIMES   MATCH " & sMatch & "   BEST RALLY " & sBestRally, tMid - (30 + the number of chars of (pName & sMatch & sBestRally)) * 6, gViewTop + 226, 12
   HUD.Set "PB.Over3", "PROMPT " & sHero["PROMPT"]["score"] & "   GLAZE " & sHero["GLAZE"]["score"] & "   TOGETHER " & (sHero["PROMPT"]["score"] + sHero["GLAZE"]["score"]), tMid - 200, gViewTop + 248, 12
   HUD.Set "PB.Over4", "ENTER OR R: PLAY AGAIN", tMid - 132, gViewTop + 280, 12
   put empty into sTalk
   PB.Say "over", pName, 100
   PB.TalkTick
end PB.GameOver

-- after the end: ENTER or R starts again
on PB.OverKeys
   local tKeys, tK
   put PB.Keys() into tKeys
   if PB.Pressed(tKeys, "65293,65421,114,82") then
      repeat for each item tK in "PB.Over1,PB.Over2,PB.Over3,PB.Over4"
         HUD.Remove tK
      end repeat
      PB.NewMatch
   else
      PB.TalkTick
   end if
   put tKeys into sKeyWas
end PB.OverKeys

function PB.Over
   return sOver
end PB.Over

-- the falls so far, under each score
function PB.FallsText pName
   return "FALLS " & sHero[pName]["falls"] & " OF " & kMaxFalls
end PB.FallsText

-- the hangs left, as lives triangles
function PB.Hangs pName
   local tOut
   repeat min(5, sHero[pName]["hangs"]) times
      put "^" after tOut
   end repeat
   return tOut
end PB.Hangs

-- a crack across a tile
function PB.CrackMesh
   local tM, tA, k
   put kTile / 2 - 3 into k
   put Mesh.New() into tM
   put PB.Line(tM, -k, 0, -k * 0.6, -k * 0.2, 0, 0) into tA
   put PB.Line(tM, -k * 0.2, 0, 0, k * 0.3, 0, -k * 0.4) into tA
   put PB.Line(tM, k * 0.3, 0, -k * 0.4, k, 0, k * 0.5) into tA
   put PB.Line(tM, -k * 0.2, 0, 0, 0, 0, k) into tA
   return tM
end PB.CrackMesh

-- a broken square: the crack, more cracks, and its edge (it holds you, for now)
function PB.BrokenMesh
   local tM, tA, k
   put PB.CrackMesh() into tM
   put kTile / 2 - 3 into k
   put PB.Line(tM, -k, 0, k * 0.7, k * 0.1, 0, -k * 0.1) into tA
   put PB.Line(tM, k * 0.1, 0, -k * 0.1, k * 0.6, 0, -k) into tA
   put PB.Line(tM, -k * 0.6, 0, -k, -k * 0.5, 0, -k * 0.2) into tA
   put PB.Line(tM, -k, 0, -k, k, 0, -k) into tA
   put PB.Line(tM, k, 0, -k, k, 0, k) into tA
   put PB.Line(tM, k, 0, k, -k, 0, k) into tA
   put PB.Line(tM, -k, 0, k, -k, 0, -k) into tA
   return tM
end PB.BrokenMesh

-- a hole: a shallow box, the tile's edge and 5 units down (owner: tall pit walls cluttered
-- the view and drew below the arena)
function PB.HoleMesh
   local tM, tA, k, tY
   put kTile / 2 - 1 into k
   put Mesh.New() into tM
   repeat for each item tY in "0,-5"
      put PB.Line(tM, -k, tY, -k, k, tY, -k) into tA
      put PB.Line(tM, k, tY, -k, k, tY, k) into tA
      put PB.Line(tM, k, tY, k, -k, tY, k) into tA
      put PB.Line(tM, -k, tY, k, -k, tY, -k) into tA
   end repeat
   put PB.Line(tM, -k, 0, -k, -k, -5, -k) into tA
   put PB.Line(tM, k, 0, -k, k, -5, -k) into tA
   put PB.Line(tM, k, 0, k, k, -5, k) into tA
   put PB.Line(tM, -k, 0, k, -k, -5, k) into tA
   return tM
end PB.HoleMesh

-- tests
-- tests: the ball bounces at x,z now (pFirst: its first touch), under this match's rule
on PB.TestBounce pX, pZ, pFirst
   PB.Bounce pX, pZ, (pFirst is true)
end PB.TestBounce

-- tests: the square under x,z at level 0 whole, 1 cracked, 2 broken, 3 hole
on PB.TestTile pX, pZ, pLevel
   PB.SetTile PB.TileOf(pX, pZ), pLevel
end PB.TestTile

-- tests: the square under x,z: its level, and when it falls apart (empty: not timed)
function PB.TileAt pX, pZ
   return PB.TileLevel(PB.TileOf(pX, pZ)) & "," & sCrumble[PB.TileOf(pX, pZ)]
end PB.TileAt

-- tests: the walls as read: problem | blocks | ramps | emblems (char wall from to; ...) | step up
function PB.WallsInfo
   local tK, tRamps, i, tE
   repeat for each key tK in sFeat
      if sFeat[tK] is "slope" then add 1 to tRamps
   end repeat
   repeat with i = 1 to sEmblem["count"]
      put sEmblem[i]["char"] & " " & sEmblem[i]["wall"] & " " & sEmblem[i]["from"] & " " & sEmblem[i]["to"] & ";" after tE
   end repeat
   return sMap["problem"] & "|" & the number of lines of sBlocks & "|" & (tRamps + 0) & "|" & tE & "|" & sStepUp
end PB.WallsInfo

-- tests: the hero at x,z standing on the ground there (nothing under way)
on PB.TestStand pName, pX, pZ
   put pX into sHero[pName]["x"]
   put pZ into sHero[pName]["z"]
   put empty into sHero[pName]["state"]
   put 0 into sHero[pName]["vh"]
   put PB.FootGround(pX, pZ) into sHero[pName]["g"]
   put sHero[pName]["g"] into sHero[pName]["h"]
end PB.TestStand

-- tests: the companion stands still (true) or plays (false)
on PB.TestFreeze pOn
   put (pOn is true) into sTestFreeze
end PB.TestFreeze

-- tests: a loose ball at x,h,z with this velocity, thrown by the player and over the middle
on PB.TestBall pX, pH, pZ, pVX, pVH, pVZ
   PB.TestPlaceBall pX, pH, pZ
   put pVX into sBall["vx"]
   put pVH into sBall["vh"]
   put pVZ into sBall["vz"]
   put 0 into sBall["banks"]
   put 0 into sBall["tops"]
   put 0 into sBall["backs"]
   put 0 into sBall["stars"]
   put 0 into sBall["floors"]
   put empty into sBall["mended"]
   put empty into sBall["emblem"]
end PB.TestBall

-- tests: a hole opens under pName (engine_play.sh "!PB.TestDrop:PROMPT")
on PB.TestDrop pName
   PB.SetTile PB.TileOf(sHero[pName]["x"], sHero[pName]["z"]), 3
end PB.TestDrop

-- tests: the steps of the clock (to time crumbling squares)
function PB.Ticks
   return sTicks
end PB.Ticks

-- tests: lives (hangs) for engine_play.sh "!PB.TestLives:9": both heroes
on PB.TestLives pN
   put pN into sHero["PROMPT"]["hangs"]
   put pN into sHero["GLAZE"]["hangs"]
end PB.TestLives

function PB.SolidAt pX, pZ
   return PB.Solid(pX, pZ)
end PB.SolidAt

function PB.HeroField pName, pKey
   return sHero[pName][pKey]
end PB.HeroField

function PB.ClipField pKey, pField
   return sClip[pKey][pField]
end PB.ClipField

on PB.TestHangs pName, pN
   put pN into sHero[pName]["hangs"]
end PB.TestHangs

on PB.TestPlaceBall pX, pH, pZ
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
end PB.TestPlaceBall

-------------------------------------------------------------------- stamina

-- the owner's rules of 17 Nov (VectorToss/STAMINA_NOTE.md). Stamina is the hero's, kept
-- by the shared PromptGlaze/stamina.livecodescript (Stamina.Get/Set/Add) so it carries over
-- to every PROMPT & GLAZE game. Both heroes spend it, the one you play and the companion.
-- A hero's TURN: from the partner's throw (catching it) until its own throw. Running in a
-- turn costs -1 once, at its end; only bIsItPlayersTurn and bDidTheyRun count.
on PB.LoadStamina
   local tLib
   put false into sStaminaOK
   put Game.FindFile("LIB_DATA/livecode/lib_data.livecodescript") into tLib
   if tLib is not empty and not ("LIB_DATA" is among the lines of the stacksInUse) then start using stack tLib
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/PromptGlaze/stamina.livecodescript") into tLib
   if tLib is empty then exit PB.LoadStamina     -- no store: stamina for this match only
   if not ("PGStamina" is among the lines of the stacksInUse) then start using stack tLib
   put ("PGStamina" is among the lines of the stacksInUse) into sStaminaOK
end PB.LoadStamina

function PB.StaminaGet pName
   if sStaminaOK is true then return Stamina.Get(pName)
   if sHero[pName]["stamina"] is a number then return sHero[pName]["stamina"]
   return 100
end PB.StaminaGet

-- add pDelta (minus takes) to pName's stamina, 0..100, saved in the shared store; the meter
-- shows it and why for a while
on PB.StaminaAdd pName, pDelta, pWhy
   local tNew, tSign
   if pDelta is not a number or pDelta is 0 then exit PB.StaminaAdd
   if sStaminaOK is true then
      put Stamina.Add(pName, pDelta) into tNew
   else
      put max(0, min(100, round(PB.StaminaGet(pName) + pDelta, 1))) into tNew
   end if
   put tNew into sHero[pName]["stamina"]
   if pDelta > 0 then put "+" into tSign
   if sHero[pName]["staminaAt"] is sTicks and sHero[pName]["staminaWhy"] is not empty then
      put "   " & tSign & pDelta & " " & pWhy after sHero[pName]["staminaWhy"]
   else
      put tSign & pDelta & " " & pWhy into sHero[pName]["staminaWhy"]
   end if
   put sTicks into sHero[pName]["staminaAt"]
   put sTicks + round(kStaminaShowMS / sStepMS) into sHero[pName]["staminaUntil"]
end PB.StaminaAdd

-- a throw: -1.0 (softest) to -2.0 (full power), in tenths
on PB.StaminaThrow pName, pPower
   if pPower is not a number then put 0 into pPower
   put max(0, min(1, pPower)) into pPower
   PB.StaminaAdd pName, -(1 + round(pPower * 10) / 10), "THROW"
end PB.StaminaThrow

on PB.TurnStart pName
   if sHero[pName]["bIsItPlayersTurn"] is true then exit PB.TurnStart
   put true into sHero[pName]["bIsItPlayersTurn"]
   put false into sHero[pName]["bDidTheyRun"]
end PB.TurnStart

on PB.TurnEnd pName
   if sHero[pName]["bIsItPlayersTurn"] is true and sHero[pName]["bDidTheyRun"] is true then
      PB.StaminaAdd pName, -1, "RAN THIS TURN"
   end if
   put false into sHero[pName]["bIsItPlayersTurn"]
   put false into sHero[pName]["bDidTheyRun"]
end PB.TurnEnd

-- the meter under the falls: only for a while after a change, or while stamina is low
on PB.ShowStamina pName
   local tS, tBar, i, tText, tLow
   put "PB.Stam" & char 1 of pName into tS
   put sHero[pName]["stamina"] < kStaminaLow into tLow
   if not tLow and not (sHero[pName]["staminaUntil"] is a number and sTicks < sHero[pName]["staminaUntil"]) then
      HUD.Remove tS
      exit PB.ShowStamina
   end if
   repeat with i = 1 to 10
      if i <= trunc((sHero[pName]["stamina"] + 0.001) / 10) then
         put "#" after tBar
      else
         put "-" after tBar
      end if
   end repeat
   put "STAMINA " & tBar & " " & sHero[pName]["stamina"] into tText
   if tLow then put "  TIRED" after tText
   if sTicks < sHero[pName]["staminaUntil"] and sHero[pName]["staminaWhy"] is not empty then
      put "   " & sHero[pName]["staminaWhy"] after tText
   end if
   if sHero[pName]["side"] < 0 then
      HUD.Set tS, tText, gViewLeft + 20, gViewTop + 60, 11
   else
      HUD.Set tS, tText, gViewRight - 20 - the number of chars of tText * 11, gViewTop + 60, 11
   end if
end PB.ShowStamina

-- tests: a hero's stamina / set it
function PB.Stamina pName
   return sHero[pName]["stamina"]
end PB.Stamina

on PB.TestStamina pName, pValue
   if sStaminaOK is true then Stamina.Set pName, pValue
   put PB.StaminaGet(pName) into sHero[pName]["stamina"]
   if sStaminaOK is not true then put max(0, min(100, pValue)) into sHero[pName]["stamina"]
end PB.TestStamina

-------------------------------------------------------------------- HUD

on PB.Message pText
   put pText into sMsg
   put sTicks + round(4500 / sStepMS) into sMsgUntil
end PB.Message

on PB.ShowHUD
   local tBar, i, tScoreG
   HUD.Set "PB.P", "PROMPT " & sHero["PROMPT"]["score"] & " " & PB.Hangs("PROMPT"), gViewLeft + 20, gViewTop + 16, 20
   put PB.Hangs("GLAZE") & " GLAZE " & sHero["GLAZE"]["score"] into tScoreG
   HUD.Set "PB.PF", PB.FallsText("PROMPT"), gViewLeft + 20, gViewTop + 42, 11
   HUD.Set "PB.GF", PB.FallsText("GLAZE"), gViewRight - 20 - the number of chars of PB.FallsText("GLAZE") * 11, gViewTop + 42, 11
   HUD.Set "PB.G", tScoreG, gViewRight - 20 - the number of chars of tScoreG * 20, gViewTop + 16, 20
   HUD.Set "PB.Rally", "MATCH " & sMatch & "   RALLY " & sRally & "  BEST " & sBestRally, gViewRight - 20 - (34 + the number of chars of (sRally & sBestRally & sMatch)) * 12, gViewBottom - 54, 12
   if sMsgUntil is a number and sTicks < sMsgUntil then
      HUD.Set "PB.Msg", sMsg, (gViewLeft + gViewRight) / 2 - the number of chars of sMsg * 7, gViewBottom - 84, 14
   else
      HUD.Remove "PB.Msg"
   end if
   PB.ShowStamina "PROMPT"
   PB.ShowStamina "GLAZE"
   HUD.Set "PB.Who", "YOU: " & sActive & "   C: SWAP", gViewLeft + 20, gViewBottom - 54, 12
   if sHero[sActive]["state"] is "hang" then
      repeat with i = 1 to 10
         if i <= round(10 * (1 - sHero[sActive]["hangT"] / max(1, sHero[sActive]["grip"]))) then
            put "#" after tBar
         else
            put "-" after tBar
         end if
      end repeat
      HUD.Set "PB.Help", "HANGING: SPACE, W OR UP TO CLIMB OUT   GRIP " & tBar, gViewLeft + 20, gViewBottom - 30, 12
   else if sBall["state"] is "held" and sBall["by"] is sActive then
      if sCharging then
         repeat with i = 1 to 16
            if i <= round(sPower * 16) then
               put "+" after tBar
            else
               put "-" after tBar
            end if
         end repeat
         HUD.Set "PB.Help", "POWER " & tBar & "   LET GO: THROW", gViewLeft + 20, gViewBottom - 30, 12
      else
         HUD.Set "PB.Help", "MOUSE: AIM THE GHOST BALL   HOLD THE BUTTON, LET GO: THROW   E: AN EASY ONE", gViewLeft + 20, gViewBottom - 30, 12
      end if
   else
      HUD.Set "PB.Help", "W A S D: RUN   SPACE: JUMP   GREEN LEDGES NEVER BREAK", gViewLeft + 20, gViewBottom - 30, 12
   end if
   -- the level's instructions stay until two tosses have come down
   if sTosses < 2 then
      PB.Intro
   else
      HUD.Remove "PB.Intro1"
      HUD.Remove "PB.Intro2"
      HUD.Remove "PB.Intro3"
   end if
end PB.ShowHUD

on PB.Intro
   local tA, tB, tC, tMid
   put "MATCH " & sMatch & ": " & PB.RuleName() into tA
   switch PB.Rule()
      case 1
         put "WHERE THE BALL FIRST COMES DOWN THE SQUARE BREAKS" into tB
         put "STEP OFF A BROKEN SQUARE: IT FALLS. JUMP ON ONE: YOU FALL THROUGH" into tC
         break
      case 2
         put "A BROKEN SQUARE FALLS A MOMENT AFTER YOU STEP ON IT" into tB
         put "THE GREEN LEDGES NEVER BREAK: JUMP UP OR TAKE THE RAMP" into tC
         break
      case 3
         put "A CRACKED SQUARE HIT AGAIN BREAKS" into tB
         put "THE STAR ON THE FAR WALL: +1   YOUR LETTER MENDS A SQUARE" into tC
         break
      default
         put "HANGING IN A HOLE: SPACE OR W CLIMBS OUT, BEFORE THE GRIP GOES" into tB
         put "TIRED HEROES HANG LESS AND CLIMB SLOWER" into tC
   end switch
   if sMap["problem"] is not empty then put sMap["problem"] into tC
   put (gViewLeft + gViewRight) / 2 into tMid
   HUD.Set "PB.Intro1", tA, tMid - the number of chars of tA * 10, gViewTop + 200, 20
   HUD.Set "PB.Intro2", tB, tMid - the number of chars of tB * 6, gViewTop + 236, 12
   HUD.Set "PB.Intro3", tC, tMid - the number of chars of tC * 6, gViewTop + 256, 12
end PB.Intro

-------------------------------------------------------------------- helpers

function PB.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end PB.Keys

-- tests: hold these keys (0 = none)
on PB.TestKeys pKeys
   put pKeys into sTestKeys
end PB.TestKeys

-- tests: both heroes play themselves
on PB.TestAuto pOn
   put pOn into sTestAuto
end PB.TestAuto

-- tests: put a hero at x,z
on PB.TestPlace pName, pX, pZ
   put pX into sHero[pName]["x"]
   put pZ into sHero[pName]["z"]
   if sBall["state"] is "held" and sBall["by"] is pName then PB.GiveBall pName
end PB.TestPlace

-- tests: the player throws now
-- tests: the player throws off the roof onto x,z now
on PB.TestRoofThrow pX, pZ, pPower
   PB.RoofThrow sActive, pX, pZ, pPower
end PB.TestRoofThrow

-- tests: the mouse points at floor "x z" / the button is down (true/false); empty: the real mouse
on PB.TestAim pXZ
   put pXZ into sTestAim
end PB.TestAim

on PB.TestMouse pDown
   put pDown into sTestMouse
end PB.TestMouse

function PB.HeroH pName
   return sHero[pName]["h"]
end PB.HeroH

-- active | PROMPT score,catches,x,z | GLAZE ... | ball state,by,x,h,z,banks | rally,best | said
-- | PROMPT state, GLAZE state, PROMPT h, GLAZE h | match,rule,catches
function PB.State
   return sActive & "|" & sHero["PROMPT"]["score"] & "," & sHero["PROMPT"]["catches"] & "," & round(sHero["PROMPT"]["x"]) & "," & round(sHero["PROMPT"]["z"]) & \
         "|" & sHero["GLAZE"]["score"] & "," & sHero["GLAZE"]["catches"] & "," & round(sHero["GLAZE"]["x"]) & "," & round(sHero["GLAZE"]["z"]) & \
         "|" & sBall["state"] & "," & sBall["by"] & "," & round(sBall["x"]) & "," & round(sBall["h"]) & "," & round(sBall["z"]) & "," & sBall["banks"] & \
         "|" & sRally & "," & sBestRally & "|" & sSaid & \
         "|" & sHero["PROMPT"]["state"] & "," & sHero["GLAZE"]["state"] & "," & round(sHero["PROMPT"]["h"]) & "," & round(sHero["GLAZE"]["h"]) & "|" & PB.MatchState()
end PB.State

function PB.ClipFrames pKey
   return sClip[pKey]["frames"]
end PB.ClipFrames

-- swap the mesh an object is drawn with (from Antack)
on PB.SetMesh pKey, pMesh
   local tRadius
   if Entity.Get(pKey, "mesh") is pMesh then exit PB.SetMesh
   -- Entity.SetMesh takes the new mesh's radius; this game keeps the old one
   put Entity.Get(pKey, "radius") into tRadius
   Entity.SetMesh pKey, pMesh
   if tRadius is a number then Entity.Set pKey, "radius", tRadius
end PB.SetMesh

-- engine rotation angles for a heading (from Antack.Euler; up is -Y)
function PB.Euler pYaw, pPitch
   local tSY, tCY, tSP, tCP
   put sin(pYaw) into tSY
   put cos(pYaw) into tCY
   put sin(pPitch) into tSP
   put cos(pPitch) into tCP
   return atan2(tSP, tCY * tCP) & comma & asin(max(-1, min(1, tSY * tCP))) & comma & atan2(-tSY * tSP, tCY)
end PB.Euler

-- a line from x1,h1,z1 to x2,h2,z2 (heights up) into a wire mesh
function PB.Line @pMesh, pX1, pH1, pZ1, pX2, pH2, pZ2
   local tA, tB
   Mesh.AddVertex pMesh, pX1, -pH1, pZ1
   put the result into tA
   Mesh.AddVertex pMesh, pX2, -pH2, pZ2
   put the result into tB
   Mesh.AddLine pMesh, tA, tB
   return tB
end PB.Line

-- a flat ring on the floor
function PB.RingMesh pR, pN
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
end PB.RingMesh

-- a little three-way cross for the aim dots
function PB.DotMesh
   local tM, tA
   put Mesh.New() into tM
   put PB.Line(tM, -2, 0, 0, 2, 0, 0) into tA
   put PB.Line(tM, 0, -2, 0, 0, 2, 0) into tA
   put PB.Line(tM, 0, 0, -2, 0, 0, 2) into tA
   return tM
end PB.DotMesh

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
