######################################################################################
## CARD SCRIPT: "Play.MeadowMarsh"   MEADOW MARSH  (23 Nov 2026, first playable)
## A little party of adventurers in open country: rolling hills, a village, goblin camps,
## and then the marsh with its ruin. You are the hand above them, the banner they gather
## round: you walk the banner, they follow, and you tell them where to go and whom to hit.
## Made from Dead Days (its iGame3D XT buildings, props and figures, its little wire helpers)
## and uDead (the horde's orders: click, F, R, hold). New: mana and spells (LIB_EMITTERS).
##
## CONTROLS  W A S D: walk the banner    Q E or Left Right: turn the view
##           Up Down: the camera nearer or further
##           click a foe: the nearest free adventurer attacks it (click again: the next one)
##           click the ground, food, a jewel or a prisoner: the nearest free one goes there
##           right click a foe: EVERYONE attacks it   right click the ground: everyone goes
##           F follow the banner   H hold where you stand   R rush (each the nearest foe)
##           Z slow time   I help   Space (after a level): go on / try again   Escape: pause
## RULES     Warriors hit hard up close; their war cry (mana) knocks back everyone in front.
##           Bowmen shoot arrows (free) and fire arrows (mana). Casters throw fire balls
##           and, with a lot of mana, lightning. Mana comes back slowly by itself; FOOD makes
##           it come back fast for a while (and heals), a JEWEL fills it at once (and shares
##           the rest with whoever stands near). Free the PRISONERS: they join you.
##           Clear every camp to win the place. Nobody left standing: try again.
## TUTORIAL  This script is meant to be read: "Make your own MMO/RPG", part 1.
##           MeadowMarsh/README.md says what each section teaches and what comes next.
## TWO ENGINES  this is a game for Engine 1 (Vibecode3D, iGame3D XT); it uses only the
##           engine contract (LIB_ig3d/ENGINE_CONTRACT.md), so the xRay bench can play it.
######################################################################################

global bPaused, bPlaying, gNoMouse

constant kM = 10            -- engine units a metre (as iGame3D XT's tools)
constant kDT = 0.0333       -- seconds a step (30 a second)
constant kEdge = 95         -- metres from the middle to the edge of the world
constant kPx = 72           -- LIB_EMITTERS pixels a metre (its duel figures: 130 px = 1.8 m)
constant kSlotW = 10000     -- each spell gets its own stretch of the emitter's flat world
constant kPool = 12         -- spells drawn at once

local sTools, sEmit, sLevel, sRound, sName, sState, sNow, sSpeed, sTicks, sQuiet
local sAmp, sWater, sFlat, sWalls, sCamps
local sE, sNextId, sMode, sHits, sPick, sPickN
local sBan, sYaw, sCamD, sKeysWas, sTestKeys
local sFr, sSlot, sPoolKey, sPoolColor, sPoolUsed, sLastFx, sK
local sScore, sMsg, sMsgT, sHUDWas, sHelp, sNextAt
local sSndHit, sSndHurt, sSndShot, sSndDie   -- the tick each sound last played: once a frame at most

-------------------------------------------------------------------- 1. THE ENGINE CALLS US

on Game.OnStart
   focus on nothing
   Camera.Reset
   HUD.Clear
   Collision.ClearRules
   put 0 into sScore
   put 0 into sRound
   put 1 into sSpeed
   put "FOLLOW" into sMode
   put 14 into sCamD
   MM.ReadKinds
   MM.UseTools
   MM.UseEmitters
   MM.StartLevel 1
end Game.OnStart

-- a new place, through the loading screen when the player has one
on MM.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      MM.StartLevel pLevel
   end if
end MM.GoLevel

-- the loading screen starts its reveal at the banner
function MM.Player
   return sBan["key"]
end MM.Player

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey pKey
end arrowKey

-------------------------------------------------------------------- 2. TOOLS AND SPELLS

-- iGame3D XT's makers of buildings, props and figures (as Dead Days finds them); without
-- them everything is a box and the game still plays
on MM.UseTools
   local tName, tFile
   put empty into sTools
   repeat for each item tName in "v3d_buildings,v3d_props,v3d_figures"
      if tName is among the lines of the stacksInUse then
         put true into sTools[tName]
         next repeat
      end if
      put MM.FindTool(tName & ".livecodescript") into tFile
      if tFile is not empty then
         start using stack tFile
         put true into sTools[tName]
      end if
   end repeat
end MM.UseTools

function MM.FindTool pFile
   local tDir, tErr, tPath, tTry
   set the itemDelimiter to "/"
   put empty into tDir
   try
      put the uScriptFile of (the long owner of me) into tDir
   catch tErr
      put empty into tDir
   end try
   replace "\" with "/" in tDir
   if tDir contains "/" then
      put item 1 to -3 of tDir & "/Vibecode3D Common/Tools/" & pFile into tTry
      if there is a file tTry then return tTry
   end if
   repeat for each line tPath in (tDir & cr & the effective filename of this stack)
      replace "\" with "/" in tPath
      repeat 8 times
         delete item -1 of tPath
         if tPath is empty then exit repeat
         put tPath & "/LIB_EDITOR/iGame3D_XT/Tools/" & pFile into tTry
         if there is a file tTry then return tTry
      end repeat
   end repeat
   set the itemDelimiter to comma
   return empty
end MM.FindTool

-- LIB_EMITTERS draws the spells. It works on a flat 2-D stage (x across, y down); each spell
-- here gets its own stretch of that stage (a slot), and its lines are stood up in the world
-- on the upright plane from the caster to the target (section 9). Without the library the
-- spells still hit, with sparks.
on MM.UseEmitters
   local tLib, tDir, tErr
   put false into sEmit
   if "lib_emitters" is among the lines of the stacksInUse then
      put true into sEmit
   else
      put Game.FindFile("LIB_EMITTERS/livecode/lib_emitters.livecodescript") into tLib
      if tLib is empty then exit MM.UseEmitters
      try
         start using stack tLib
         put true into sEmit
      catch tErr
         put false into sEmit
      end try
   end if
   if not sEmit then exit MM.UseEmitters
   if not Power.Exists("fire ball") then
      put Game.FindFile("LIB_EMITTERS/powers/params.tsv") into tDir
      set the itemDelimiter to "/"
      if tDir is not empty then Emit.SetFolder item 1 to -3 of tDir
      set the itemDelimiter to comma
      Emit.LoadAll empty
   end if
   if not Power.Exists("fire ball") then
      put false into sEmit
      exit MM.UseEmitters
   end if
   MM.MakePowers
   Emit.Reset
   Emit.Clear
   Emit.ClearTargets
   -- a stage as wide as every slot; the floor far below (the ground is ours, not its)
   Emit.SetStage -kSlotW, -1500, kSlotW * 60, 4000, 2000
end MM.UseEmitters

-- our own powers, made from the library's: an arrow is a plain fast bit with no glow
on MM.MakePowers
   if not Power.Exists("mm arrow") then
      Power.Copy "photon bit", "mm arrow"
      Power.Set "mm arrow", "colorCore", "#F0E0B0"
      Power.Set "mm arrow", "colorGlow", "#806040"
      Power.Set "mm arrow", "colorEdge", "#C0A070"
      Power.Set "mm arrow", "glowWidth", 0
      Power.Set "mm arrow", "trail", 3
      Power.Set "mm arrow", "speed", 900
      Power.Set "mm arrow", "gravity", 260
      Power.Set "mm arrow", "burstDots", 0
      Power.Set "mm arrow", "onHit", "none"
      Power.Set "mm arrow", "onEnd", "none"
   end if
   if not Power.Exists("mm fire arrow") then
      Power.Copy "photon bit", "mm fire arrow"
      Power.Set "mm fire arrow", "colorCore", "#FFF0A0"
      Power.Set "mm fire arrow", "colorGlow", "#FF6020"
      Power.Set "mm fire arrow", "colorEdge", "#FFB040"
      Power.Set "mm fire arrow", "trail", 8
      Power.Set "mm fire arrow", "speed", 800
      Power.Set "mm fire arrow", "gravity", 200
      Power.Set "mm fire arrow", "onHit", "fire burst"
      Power.Set "mm fire arrow", "onEnd", "none"
   end if
end MM.MakePowers

-------------------------------------------------------------------- 3. WHO IS WHO (the table)

-- One line a kind of adventurer or foe. Change a number here and the game changes:
-- this table is the first thing to play with.
--   kind | side | figure | size | colour | hp | speed m/s | reach m | damage | seconds between
--   | shot (a power: the attack is a missile) | mana | mana a second
--   | spell | its mana | its reach | its damage | seconds between | splash m
--   | spell 2 (a bigger one, when mana is high) | its mana | its damage
function MM.Kinds
   local t
   put "warrior|party|knight|1|#FFD070|120|3.6|1.7|12|1.0||40|1.5|sound wave|20|5|14|6|5|||" & cr into t
   put "bowman|party|bowman|1|#90FF80|70|3.8|18|8|1.3|mm arrow|50|2|mm fire arrow|15|20|20|3|0|||" & cr after t
   put "caster|party|caster|1|#C090FF|60|3.4|1.6|5|1.2||100|3|fire ball|20|16|26|2.2|2.5|lightning strike|35|44" & cr after t
   put "goblin|foe|goblin|0.8|#FF6A50|40|3.1|1.5|7|1.1||0|0||0|0|0|0|0|||" & cr after t
   put "goblin_archer|foe|goblin_bow|0.8|#FFA040|30|3.0|15|6|1.7|mm arrow|0|0||0|0|0|0|0|||" & cr after t
   put "goblin_shaman|foe|goblin_staff|0.85|#FF50D0|45|2.8|1.5|4|1.4||60|2.5|plasma ball|20|14|16|3|0|||" & cr after t
   put "skeleton|foe|skeleton|1|#E8E8D8|50|2.7|1.6|9|1.2||0|0||0|0|0|0|0|||" & cr after t
   put "skeleton_archer|foe|skeleton_bow|1|#D8D0A0|35|2.7|16|7|1.6|mm arrow|0|0||0|0|0|0|0|||" & cr after t
   put "bog_witch|foe|witch|1|#60FFD0|160|2.6|1.6|8|1.2||120|4|ball lightning|25|15|22|2.6|3|||" after t
   return t
end MM.Kinds

-- the table read once into an array: sK[kind][fact]
on MM.ReadKinds
   local tLine, tFacts, k
   put "kind|side|figure|size|color|hp|speed|reach|dmg|cool|shot|mp|regen|spell|cost|range|sdmg|scool|splash|spell2|cost2|sdmg2" into tFacts
   put empty into sK
   set the itemDelimiter to "|"
   repeat for each line tLine in MM.Kinds()
      repeat with k = 1 to 22
         put item k of tLine into sK[item 1 of tLine][item k of tFacts]
      end repeat
   end repeat
   set the itemDelimiter to comma
end MM.ReadKinds

-- one fact about a kind, by its name in the table's header
function MM.Kind pKind, pFact
   return sK[pKind][pFact]
end MM.Kind

-------------------------------------------------------------------- 4. THE PLACES

on MM.StartLevel pLevel
   local i
   if pLevel > 2 then
      -- round again, harder
      add 1 to sRound
      put 1 into pLevel
   end if
   put pLevel into sLevel
   Sound.Play "Warp"
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   put empty into sE
   put 0 into sNextId
   put empty into sHits
   put empty into sPick
   put 0 into sPickN
   put empty into sWalls
   put empty into sCamps
   put empty into sFlat
   put empty into sFr
   put 0 into sSlot
   put 0 into sNow
   put 0 into sTicks
   put empty into sNextAt
   put "play" into sState
   put "FOLLOW" into sMode
   if sEmit then
      Emit.Clear
      Emit.ClearTargets
   end if
   MM.MakeMeshes
   switch pLevel
      case 1
         MM.Meadow
         break
      case 2
         MM.Marsh
         break
   end switch
   MM.BuildGround
   MM.MakeBanner
   MM.MakePool
   put empty into sHUDWas
   MM.Camera
   MM.ShowHUD
end MM.StartLevel

-- THE MEADOW: a village in a hollow, goblin camps on the hills around it
on MM.Meadow
   put "THE MEADOW" into sName
   put 1.5 into sAmp
   put -99 into sWater
   put "-45,-40,22" & cr & "30,10,9" & cr & "-15,55,10" & cr & "55,62,9" into sFlat
   -- the village
   MM.PlaceBuilding "hovel", -55, -48, 0
   MM.PlaceBuilding "potionshop", -40, -55, 0
   MM.PlaceBuilding "m12shack", -58, -30, 1.5708
   MM.PlaceBuilding "weaponshop", -30, -32, 3.14159
   MM.Fence -66, -62, -22, -62
   MM.Prop "brazier", -45, -42, 0
   MM.Prop "barrel", -38, -45, 0
   MM.Prop "crate", -36, -44, 0.4
   MM.Trees 34, 1
   -- you start at the village well
   MM.Start -45, -38, 0.6
   MM.AddUnit "warrior", -46, -40
   MM.AddUnit "warrior", -43, -40
   MM.AddUnit "caster", -45, -42
   MM.AddUnit "bowman", -47, -42
   -- the camps: goblins round a fire; the prisoners are tied up beside them
   MM.Camp 30, 10, "goblin,goblin,goblin,goblin_archer"
   MM.Camp -15, 55, "goblin,goblin,goblin_archer,goblin_archer,goblin_shaman"
   MM.Camp 55, 62, "goblin,goblin,goblin,goblin_archer,goblin_shaman,goblin_shaman"
   MM.AddPick "captive", 33, 13
   MM.AddPick "captive", -12, 59
   -- food and jewels
   MM.AddPick "food", -40, -36
   MM.AddPick "food", 10, -10
   MM.AddPick "food", 20, 40
   MM.AddPick "jewel", -25, 30
   MM.AddPick "jewel", 45, 35
   MM.AddPick "jewel", 70, 75
   MM.Say "THE MEADOW. GOBLINS ON THE HILLS: CLEAR THE THREE CAMPS, FREE THE PRISONERS", 6
end MM.Meadow

-- THE MARSH: low and wet (water slows you), a ruin to the north, the bog witch in it
on MM.Marsh
   put "THE MARSH" into sName
   put 0.45 into sAmp
   put -0.35 into sWater
   put "0,-60,14" & cr & "0,62,16" into sFlat
   MM.PlaceBuilding "RuinedHouse584", -12, 70, 0
   MM.PlaceBuilding "middletower", 14, 72, 0
   MM.Prop "arch", 0, 58, 0
   MM.Prop "column", -6, 56, 0
   MM.Prop "column", 6, 56, 0
   MM.Prop "stone_block", 20, 50, 0.3
   MM.Prop "grave", -20, 40, 0
   MM.Prop "grave", -23, 41, 0.2
   MM.Trees 22, 2
   MM.Start 0, -62, 0
   MM.AddUnit "warrior", -1, -64
   MM.AddUnit "warrior", 2, -64
   MM.AddUnit "caster", 0, -66
   MM.AddUnit "bowman", -2, -66
   MM.AddUnit "caster", 2, -66
   MM.Camp -35, -10, "skeleton,skeleton,skeleton_archer,skeleton_archer"
   MM.Camp 35, 10, "skeleton,skeleton,skeleton,skeleton_archer"
   MM.Camp 0, 62, "skeleton,skeleton,skeleton_archer,skeleton_archer,bog_witch"
   MM.AddPick "captive", 38, 14
   MM.AddPick "food", 0, -45
   MM.AddPick "food", -30, 20
   MM.AddPick "food", 30, 35
   MM.AddPick "jewel", -40, -14
   MM.AddPick "jewel", 0, 30
   MM.AddPick "jewel", 25, 60
   MM.Say "THE MARSH. THE WATER SLOWS YOU. THE BOG WITCH WAITS IN THE RUIN", 6
end MM.Marsh

on MM.Start pX, pZ, pYaw
   put pX into sBan["x"]
   put pZ into sBan["z"]
   put pYaw into sYaw
end MM.Start

-- a camp: a fire and its goblins in a ring round it
on MM.Camp pX, pZ, pWho
   local tN, k, tA, tKind
   add 1 to sCamps["n"]
   put sCamps["n"] into tN
   put pX & comma & pZ & comma & false into sCamps[tN]
   MM.Prop "brazier", pX, pZ, 0
   if sQuiet is true then exit MM.Camp
   put 0 into k
   repeat for each item tKind in pWho
      add 1 to k
      put k * 6.28318 / the number of items of pWho into tA
      MM.AddUnit tKind, pX + sin(tA) * 4, pZ + cos(tA) * 4, tN
   end repeat
end MM.Camp

-- trees and bushes, scattered (never on the flat places)
on MM.Trees pCount, pSeed
   local k, tX, tZ, tKind, tTries
   repeat with k = 1 to pCount
      repeat with tTries = 1 to 8
         put ((k * 37 + pSeed * 11 + tTries * 53) mod 180) - 90 into tX
         put ((k * 61 + pSeed * 29 + tTries * 17) mod 180) - 90 into tZ
         if MM.Flatness(tX, tZ) > 0.9 then exit repeat
      end repeat
      if pSeed is 2 then
         put item (k mod 4) + 1 of "dead_tree,tall_grass,bush,tall_grass" into tKind
      else
         put item (k mod 4) + 1 of "tree,pine,bush,tree" into tKind
      end if
      MM.Prop tKind, tX, tZ, k
   end repeat
end MM.Trees

-------------------------------------------------------------------- 5. THE GROUND: rolling hills

-- the height of the ground (metres) anywhere: a few waves laid over each other, smoothed
-- flat where a village or a camp stands
function MM.H pX, pZ
   local tH
   put 2.4 * sin(pX * 0.045 + 1) * cos(pZ * 0.038) + 1.4 * sin((pX - pZ) * 0.021) + 0.6 * sin(pX * 0.11 + 2) * sin(pZ * 0.09) into tH
   return tH * sAmp * MM.Flatness(pX, pZ)
end MM.H

-- 1 out in the open, down to 0 in the middle of a flat place
function MM.Flatness pX, pZ
   local tF, tLine, tD
   put 1 into tF
   repeat for each line tLine in sFlat
      put sqrt((pX - item 1 of tLine) ^ 2 + (pZ - item 2 of tLine) ^ 2) / item 3 of tLine into tD
      if tD < 1 then put min(tF, tD * tD) into tF
   end repeat
   return tF
end MM.Flatness

function MM.Wet pX, pZ
   return MM.H(pX, pZ) < sWater
end MM.Wet

-- the ground as 25 tiles (40 m each, the engine skips the ones out of view): lines every
-- 20 m bent over the hills in 10 m steps, tufts of grass, and water where it is low
on MM.BuildGround
   local tTX, tTZ, tM, k, j, x0, z0, tX, tZ, tColor
   repeat with tTX = 0 to 4
      repeat with tTZ = 0 to 4
         put -100 + tTX * 40 into x0
         put -100 + tTZ * 40 into z0
         put MM.Mesh() into tM
         repeat with k = 0 to 1
            repeat with j = 0 to 3
               -- along x at z0 + k*20, and along z at x0 + k*20
               put z0 + k * 20 into tZ
               MM.Line tM, j * 10 - 20, MM.H(x0 + j * 10, tZ), k * 20 - 20, j * 10 - 10, MM.H(x0 + j * 10 + 10, tZ), k * 20 - 20
               put x0 + k * 20 into tX
               MM.Line tM, k * 20 - 20, MM.H(tX, z0 + j * 10), j * 10 - 20, k * 20 - 20, MM.H(tX, z0 + j * 10 + 10), j * 10 - 10
            end repeat
         end repeat
         -- grass tufts
         repeat with k = 1 to 3
            put x0 + ((k * 13 + tTX * 7 + tTZ * 3) mod 38) + 1 into tX
            put z0 + ((k * 29 + tTZ * 11 + tTX * 5) mod 38) + 1 into tZ
            MM.Line tM, tX - x0 - 20, MM.H(tX, tZ), tZ - z0 - 20, tX - x0 - 20 - 0.3, MM.H(tX, tZ) + 0.6, tZ - z0 - 20
            MM.Line tM, tX - x0 - 20, MM.H(tX, tZ), tZ - z0 - 20, tX - x0 - 20 + 0.3, MM.H(tX, tZ) + 0.5, tZ - z0 - 20
         end repeat
         put "#2E6A2E" into tColor
         if sLevel is 2 then put "#3A5A3A" into tColor
         Mesh.Define "MM.Ground." & tTX & "." & tTZ, tM
         get Entity.Spawn("MM.Ground." & tTX & "." & tTZ, (x0 + 20) * kM, 0, (z0 + 20) * kM, tColor)
      end repeat
   end repeat
   if sWater > -50 then MM.BuildWater
end MM.BuildGround

-- short level ripples wherever the ground is under the water line
on MM.BuildWater
   local tM, tX, tZ, tN
   put MM.Mesh() into tM
   put 0 into tN
   repeat with tX = -96 to 96 step 6
      repeat with tZ = -96 to 96 step 6
         if MM.H(tX, tZ) < sWater then
            MM.Line tM, tX - 1.5, sWater, tZ, tX + 1.5, sWater, tZ
            MM.Line tM, tX + 1.5, sWater, tZ + 2, tX + 3.5, sWater, tZ + 2
            add 1 to tN
         end if
      end repeat
   end repeat
   if tN is 0 then exit MM.BuildWater
   Mesh.Define "MM.Water", tM
   get Entity.Spawn("MM.Water", 0, 0, 0, "#3070FF")
end MM.BuildWater

-------------------------------------------------------------------- 6. MAKING THINGS

-- every figure: standing and two walking steps (Fig.Make's poses), with what each carries
on MM.MakeMeshes
   local tFig, tPose, tM, n
   repeat for each item tFig in "knight,bowman,caster,goblin,goblin_bow,goblin_staff,skeleton,skeleton_bow,witch,captive"
      put 0 into n
      repeat for each item tPose in ",walk1,walk2"
         put MM.FigureMesh(tFig, tPose) into tM
         Mesh.Define "MM.F." & tFig & "." & n, tM
         add 1 to n
      end repeat
   end repeat
   -- the bars over heads: 0 to 10 tenths of a metre-long line
   repeat with n = 0 to 10
      put MM.Mesh() into tM
      MM.Line tM, -0.5, 0, 0, -0.5 + n / 10, 0, 0
      MM.Line tM, -0.5, -0.06, 0, -0.5, 0.06, 0
      MM.Line tM, 0.5, -0.06, 0, 0.5, 0.06, 0
      Mesh.Define "MM.Bar." & n, tM
   end repeat
   -- food (a loaf), a jewel (a crystal), the empty spell
   put MM.Mesh() into tM
   MM.Box tM, 0, 0.1, 0, 0.6, 0.3, 0.35
   MM.Line tM, -0.15, 0.4, -0.17, -0.05, 0.4, 0.17
   MM.Line tM, 0.05, 0.4, -0.17, 0.15, 0.4, 0.17
   Mesh.Define "MM.Food", tM
   if sTools["v3d_props"] is true then
      Mesh.Define "MM.Jewel", Mesh.Transform(Prop.Make("crystal"), 0, 0, 0, 0, -0.5 * kM, 0, 0.6)
   else
      Mesh.Define "MM.Jewel", Mesh.Pyramid(4, 0.3 * kM, 0.8 * kM)
   end if
   Mesh.Define "MM.FxNone", MM.Mesh()
end MM.MakeMeshes

-- a figure: iGame3D XT's (Fig.Make) with a bow, a staff or a hat added
function MM.FigureMesh pFig, pPose
   local tBase, tSize, tM, tX
   if sTools["v3d_figures"] is not true then return Mesh.Box(0.5 * kM, 1.8 * kM, 0.3 * kM)
   put 1 into tSize
   switch pFig
      case "knight"
         put "knight" into tBase
         break
      case "goblin"
      case "goblin_bow"
      case "goblin_staff"
         put "orc" into tBase
         put 0.75 into tSize
         break
      case "skeleton"
      case "skeleton_bow"
         put "skeleton" into tBase
         break
      default
         put "civilian" into tBase
   end switch
   put Fig.Make(tBase, pPose) into tM
   put MM.Mesh() into tX
   if pFig ends with "bow" or pFig is "bowman" then
      -- a bow in the left hand, the quiver on the back
      MM.Line tX, -0.38, 1.55, -0.1, -0.5, 1.2, -0.25
      MM.Line tX, -0.5, 1.2, -0.25, -0.38, 0.85, -0.1
      MM.Line tX, -0.38, 1.55, -0.1, -0.38, 0.85, -0.1
      MM.Line tX, 0.12, 1.45, 0.15, -0.1, 0.95, 0.18
   end if
   if pFig is "caster" or pFig is "goblin_staff" or pFig is "witch" then
      -- a staff with a little orb, and (not the goblin) a pointed hat
      MM.Line tX, 0.3, 0.05, -0.1, 0.32, 1.95, -0.1
      MM.Box tX, 0.32, 1.95, -0.1, 0.14, 0.14, 0.14
      if pFig is not "goblin_staff" then
         MM.Line tX, -0.2, 1.68, 0, 0.2, 1.68, 0
         MM.Line tX, 0, 1.68, -0.2, 0, 1.68, 0.2
         MM.Line tX, -0.2, 1.68, 0, 0.02, 2.2, 0.05
         MM.Line tX, 0.2, 1.68, 0, 0.02, 2.2, 0.05
         MM.Line tX, 0, 1.68, -0.2, 0.02, 2.2, 0.05
         MM.Line tX, 0, 1.68, 0.2, 0.02, 2.2, 0.05
      end if
   end if
   if pFig is "captive" then
      -- tied to a post
      MM.Line tX, 0, 0, 0.3, 0, 1.9, 0.3
      MM.Line tX, -0.25, 1.1, 0.05, 0.25, 1.1, 0.05
   end if
   if pFig begins with "goblin" then
      -- big ears
      MM.Line tX, -0.12, 1.68, 0, -0.3, 1.8, 0
      MM.Line tX, 0.12, 1.68, 0, 0.3, 1.8, 0
   end if
   put Mesh.Merge(tM, tX) into tM
   if tSize is not 1 then put Mesh.Transform(tM, 0, 0, 0, 0, 0, 0, tSize) into tM
   return tM
end MM.FigureMesh

-- a building from iGame3D XT (or a box), sitting on the ground, solid
on MM.PlaceBuilding pName, pX, pZ, pTurn
   local tB, tKey, tW, tD
   if sTools["v3d_buildings"] is true then
      put Bld.Make(pName) into tB
      Mesh.Define "MM.B." & pName, tB["mesh"]
   else
      put 10 into tB["w"]
      put 8 into tB["d"]
      Mesh.Define "MM.B." & pName, Mesh.Box(10 * kM, 6 * kM, 8 * kM)
   end if
   put Entity.Spawn("MM.B." & pName, pX * kM, -MM.H(pX, pZ) * kM, pZ * kM, "#B8A070") into tKey
   if pTurn is not 0 then Entity.SetRotation tKey, 0, pTurn, 0
   put tB["w"] into tW
   put tB["d"] into tD
   if abs(sin(pTurn)) > 0.7 then
      put tB["d"] into tW
      put tB["w"] into tD
   end if
   MM.Wall pX - tW / 2, pZ - tD / 2, pX + tW / 2, pZ + tD / 2
end MM.PlaceBuilding

on MM.Prop pName, pX, pZ, pRot
   local tKey, tColor
   if not Mesh.Has("MM.P." & pName) then
      if pName is among the items of "tree,pine,bush,dead_tree,tall_grass" then
         Mesh.Define "MM.P." & pName, MM.Foliage(pName)
      else if sTools["v3d_props"] is true then
         Mesh.Define "MM.P." & pName, Prop.Make(pName)
      else
         Mesh.Define "MM.P." & pName, Mesh.Box(1 * kM, 1 * kM, 1 * kM)
      end if
   end if
   put "#C0C0C0" into tColor
   if pName is among the items of "tree,pine,bush,tall_grass" then put "#50C050" into tColor
   if pName is "dead_tree" then put "#8A7A5A" into tColor
   if pName is "brazier" then put "#FF8030" into tColor
   put Entity.Spawn("MM.P." & pName, pX * kM, -MM.H(pX, pZ) * kM, pZ * kM, tColor) into tKey
   if pRot is not 0 then Entity.SetRotation tKey, 0, pRot, 0
end MM.Prop

-- lean trees: a dozen lines each, so a wood costs little to draw (open country is all trees)
function MM.Foliage pName
   local tM, k, tAng, tR, tY
   put MM.Mesh() into tM
   switch pName
      case "tree"
         -- tAng trunk, two branches, tAng round crown of six points
         MM.Line tM, 0, 0, 0, 0, 2.2, 0
         MM.Line tM, 0, 1.6, 0, -0.6, 2.4, 0
         MM.Line tM, 0, 1.8, 0, 0.5, 2.5, 0.2
         repeat with k = 0 to 3
            put k * 1.5708 into tAng
            MM.Line tM, sin(tAng) * 1.6, 3.2, cos(tAng) * 1.6, sin(tAng + 1.5708) * 1.6, 3.2, cos(tAng + 1.5708) * 1.6
            MM.Line tM, sin(tAng) * 1.6, 3.2, cos(tAng) * 1.6, 0, 4.6, 0
            MM.Line tM, sin(tAng) * 1.6, 3.2, cos(tAng) * 1.6, 0, 2.2, 0
         end repeat
         break
      case "pine"
         MM.Line tM, 0, 0, 0, 0, 1, 0
         repeat with k = 0 to 2
            put 1.3 - k * 0.35 into tR
            put 1 + k * 1.1 into tY
            MM.Line tM, -tR, tY, 0, 0, tY + 1.6, 0
            MM.Line tM, tR, tY, 0, 0, tY + 1.6, 0
            MM.Line tM, 0, tY, -tR, 0, tY + 1.6, 0
            MM.Line tM, 0, tY, tR, 0, tY + 1.6, 0
            MM.Line tM, -tR, tY, 0, tR, tY, 0
         end repeat
         break
      case "bush"
         repeat with k = 0 to 4
            put k * 1.2566 into tAng
            MM.Line tM, 0, 0, 0, sin(tAng) * 0.8, 0.7, cos(tAng) * 0.8
            MM.Line tM, sin(tAng) * 0.8, 0.7, cos(tAng) * 0.8, sin(tAng + 1.2566) * 0.8, 0.7, cos(tAng + 1.2566) * 0.8
         end repeat
         break
      case "dead_tree"
         MM.Line tM, 0, 0, 0, 0.2, 2.6, 0
         MM.Line tM, 0.1, 1.4, 0, -0.8, 2.2, 0.3
         MM.Line tM, 0.15, 2, 0, 0.9, 2.8, -0.2
         MM.Line tM, 0.2, 2.6, 0, -0.2, 3.2, 0
         MM.Line tM, -0.8, 2.2, 0.3, -1.1, 2.5, 0.4
         break
      default
         -- tall grass
         repeat with k = -2 to 2
            MM.Line tM, k * 0.15, 0, 0, k * 0.3, 1.1 - abs(k) * 0.15, k * 0.08
         end repeat
   end switch
   return tM
end MM.Foliage

-- a fence of posts and rails along a line
on MM.Fence pX1, pZ1, pX2, pZ2
   local tM, k, tN, tX, tZ, tLX, tLZ
   put MM.Mesh() into tM
   put max(1, round(sqrt((pX2 - pX1) ^ 2 + (pZ2 - pZ1) ^ 2) / 2.5)) into tN
   repeat with k = 0 to tN
      put pX1 + (pX2 - pX1) * k / tN into tX
      put pZ1 + (pZ2 - pZ1) * k / tN into tZ
      MM.Line tM, tX, MM.H(tX, tZ), tZ, tX, MM.H(tX, tZ) + 1.1, tZ
      if k > 0 then
         MM.Line tM, tLX, MM.H(tLX, tLZ) + 0.9, tLZ, tX, MM.H(tX, tZ) + 0.9, tZ
         MM.Line tM, tLX, MM.H(tLX, tLZ) + 0.5, tLZ, tX, MM.H(tX, tZ) + 0.5, tZ
      end if
      put tX into tLX
      put tZ into tLZ
   end repeat
   Mesh.Define "MM.Fence" & the number of lines of sWalls, tM
   get Entity.Spawn("MM.Fence" & the number of lines of sWalls, 0, 0, 0, "#A08050")
end MM.Fence

-- something solid: a rectangle on the ground (metres)
on MM.Wall pX1, pZ1, pX2, pZ2
   put min(pX1, pX2) & "," & min(pZ1, pZ2) & "," & max(pX1, pX2) & "," & max(pZ1, pZ2) & cr after sWalls
end MM.Wall

function MM.Free pX, pZ, pR
   local tW
   if abs(pX) > kEdge or abs(pZ) > kEdge then return false
   repeat for each line tW in sWalls
      if pX > item 1 of tW - pR and pX < item 3 of tW + pR and pZ > item 2 of tW - pR and pZ < item 4 of tW + pR then return false
   end repeat
   return true
end MM.Free

-- the banner: the hand above the party. A pole, a flag and a ring on the ground
on MM.MakeBanner
   local tM, k, a1, a2
   put MM.Mesh() into tM
   MM.Line tM, 0, 0, 0, 0, 3.2, 0
   MM.Line tM, 0, 3.2, 0, 1.3, 2.8, 0
   MM.Line tM, 1.3, 2.8, 0, 0, 2.3, 0
   MM.Line tM, 0.3, 2.95, 0, 0.3, 2.5, 0
   repeat with k = 0 to 11
      put k * 6.28318 / 12 into a1
      put (k + 1) * 6.28318 / 12 into a2
      MM.Line tM, sin(a1) * 1.2, 0.05, cos(a1) * 1.2, sin(a2) * 1.2, 0.05, cos(a2) * 1.2
   end repeat
   Mesh.Define "MM.Banner", tM
   put Entity.Spawn("MM.Banner", sBan["x"] * kM, -MM.H(sBan["x"], sBan["z"]) * kM, sBan["z"] * kM, "#FFE070") into sBan["key"]
end MM.MakeBanner

-------------------------------------------------------------------- 7. THE PEOPLE

-- one adventurer or foe of a kind, at x, z (pCamp: the camp a foe belongs to)
on MM.AddUnit pKind, pX, pZ, pCamp
   local tId, tFig, tHard
   add 1 to sNextId
   put sNextId into tId
   put pKind into sE[tId]["kind"]
   put MM.Kind(pKind, "side") into sE[tId]["side"]
   put MM.Kind(pKind, "figure") into tFig
   if tFig is "witch" then put "witch" into tFig
   put tFig into sE[tId]["fig"]
   put pX into sE[tId]["x"]
   put pZ into sE[tId]["z"]
   put pX into sE[tId]["hx"]
   put pZ into sE[tId]["hz"]
   put 0 into sE[tId]["h"]
   put 1 + sRound * 0.3 into tHard
   if sE[tId]["side"] is "party" then put 1 into tHard
   put MM.Kind(pKind, "hp") * tHard into sE[tId]["hpMax"]
   put sE[tId]["hpMax"] into sE[tId]["hp"]
   put MM.Kind(pKind, "mp") into sE[tId]["mpMax"]
   put sE[tId]["mpMax"] into sE[tId]["mp"]
   put 0 into sE[tId]["cool"]
   put 0 into sE[tId]["scool"]
   put 0 into sE[tId]["fed"]
   put 0 into sE[tId]["picked"]
   put false into sE[tId]["moved"]
   put false into sE[tId]["stay"]
   put pCamp into sE[tId]["camp"]
   put false into sE[tId]["awake"]
   put empty into sE[tId]["order"]
   put "MM.F." & tFig & ".0" into sE[tId]["mesh"]
   put Entity.Spawn(sE[tId]["mesh"], pX * kM, -MM.H(pX, pZ) * kM, pZ * kM, MM.Kind(pKind, "color")) into sE[tId]["key"]
   put 10 into sE[tId]["hpB"]
   put Entity.Spawn("MM.Bar.10", pX * kM, -(MM.H(pX, pZ) + 2.4) * kM, pZ * kM, MM.BarColor(sE[tId]["side"])) into sE[tId]["hpKey"]
   if sE[tId]["mpMax"] > 0 and sE[tId]["side"] is "party" then
      put 10 into sE[tId]["mpB"]
      put Entity.Spawn("MM.Bar.10", pX * kM, -(MM.H(pX, pZ) + 2.55) * kM, pZ * kM, "#4080FF") into sE[tId]["mpKey"]
   end if
   return tId
end MM.AddUnit

function MM.BarColor pSide
   if pSide is "party" then return "#40FF40"
   return "#FF4040"
end MM.BarColor

-- the ids of one side (a line each)
function MM.Side pSide
   local tId, tOut
   repeat for each key tId in sE
      if sE[tId]["side"] is pSide then put tId & cr after tOut
   end repeat
   delete the last char of tOut
   return tOut
end MM.Side

function MM.Dist pA, pB
   return sqrt((sE[pA]["x"] - sE[pB]["x"]) ^ 2 + (sE[pA]["z"] - sE[pB]["z"]) ^ 2)
end MM.Dist

-- the nearest of pList to pId within pReach (empty: none)
function MM.Nearest pId, pList, pReach
   local tId, tD, tBest, tBestD
   put pReach into tBestD
   repeat for each line tId in pList
      put MM.Dist(pId, tId) into tD
      if tD < tBestD then
         put tD into tBestD
         put tId into tBest
      end if
   end repeat
   return tBest
end MM.Nearest

-------------------------------------------------------------------- 8. EACH STEP

on Game.OnUpdate
   local tKeys, tDT
   put MM.Keys() into tKeys
   add 1 to sTicks
   MM.Controls tKeys
   put tKeys into sKeysWas
   if sNextAt is not empty and sTicks >= sNextAt then
      put empty into sNextAt
      MM.GoLevel sLevel
      exit Game.OnUpdate
   end if
   if sState is "play" then
      put kDT * sSpeed into tDT
      add tDT to sNow
      MM.Party tDT
      MM.Foes tDT
      if sTicks mod 3 is 0 then MM.Spread
      MM.Arrivals
      MM.Pickups
      MM.Mana tDT
      if sTicks mod 30 is 0 then MM.CheckEnd
   end if
   MM.Place
   MM.FxDraw kDT * sSpeed
   MM.Camera
   if sMsgT > 0 then
      subtract 1 from sMsgT
      if sMsgT is 0 then
         put empty into sMsg
         put empty into sHUDWas
      end if
   end if
   MM.ShowHUD
end Game.OnUpdate

-- the banner walks where the view looks; the view turns; the orders
on MM.Controls pKeys
   local tFX, tFZ, tMX, tMZ, tD, tNX, tNZ
   if MM.Down(113, pKeys) or MM.Down(65361, pKeys) then subtract 1.8 * kDT from sYaw
   if MM.Down(101, pKeys) or MM.Down(65363, pKeys) then add 1.8 * kDT to sYaw
   if MM.Down(65362, pKeys) then put max(7, sCamD - 0.4) into sCamD
   if MM.Down(65364, pKeys) then put min(26, sCamD + 0.4) into sCamD
   put sin(sYaw) into tFX
   put cos(sYaw) into tFZ
   put 0 into tMX
   put 0 into tMZ
   if MM.Down(119, pKeys) then
      add tFX to tMX
      add tFZ to tMZ
   end if
   if MM.Down(115, pKeys) then
      subtract tFX from tMX
      subtract tFZ from tMZ
   end if
   if MM.Down(100, pKeys) then
      add tFZ to tMX
      subtract tFX from tMZ
   end if
   if MM.Down(97, pKeys) then
      subtract tFZ from tMX
      add tFX to tMZ
   end if
   put sqrt(tMX * tMX + tMZ * tMZ) into tD
   if tD > 0.01 then
      put sBan["x"] + tMX / tD * 7 * kDT into tNX
      put sBan["z"] + tMZ / tD * 7 * kDT into tNZ
      put max(-kEdge, min(kEdge, tNX)) into sBan["x"]
      put max(-kEdge, min(kEdge, tNZ)) into sBan["z"]
   end if
   -- the orders (as uDead's)
   if MM.Pressed(32, pKeys) and sState is not "play" then
      if sState is "won" then
         add 1 to sLevel
         MM.Say "ON TO THE NEXT PLACE", 2
      else
         MM.Say "AGAIN", 2
      end if
      put sTicks + 2 into sNextAt
      put "wait" into sState
   end if
   if MM.Pressed(105, pKeys) then
      put not (sHelp is true) into sHelp
      put empty into sHUDWas
   end if
   if sState is not "play" then exit MM.Controls
   if MM.Pressed(102, pKeys) then MM.SetMode "FOLLOW"
   if MM.Pressed(104, pKeys) then MM.SetMode "HOLD"
   if MM.Pressed(114, pKeys) then MM.SetMode "RUSH"
   if MM.Pressed(122, pKeys) then
      if sSpeed < 1 then
         put 1 into sSpeed
      else
         put 0.3 into sSpeed
      end if
      put empty into sHUDWas
   end if
end MM.Controls

-- FOLLOW, HOLD or RUSH: everyone drops what they were told
on MM.SetMode pMode
   local tId
   put pMode into sMode
   repeat for each line tId in MM.Side("party")
      put empty into sE[tId]["order"]
      put empty into sE[tId]["target"]
      put false into sE[tId]["stay"]
      put sE[tId]["x"] into sE[tId]["hx"]
      put sE[tId]["z"] into sE[tId]["hz"]
   end repeat
   Sound.Play "Select"
   MM.Say pMode, 1.5
end MM.SetMode

-- the adventurers: an order first (attack, go), then the mode; anyone in reach gets hit
on MM.Party pDT
   local tId, tFoes, tT, tAX, tAZ, tSlot, tN, tAggro, tOX, tOZ
   put MM.Side("foe") into tFoes
   put 0 into tSlot
   put the number of lines of MM.Side("party") into tN
   repeat for each line tId in MM.Side("party")
      add 1 to tSlot
      put empty into tT
      -- where this one belongs: its place round the banner, or where it holds
      if sMode is "FOLLOW" and sE[tId]["order"] is empty and sE[tId]["stay"] is not true then
         MM.SlotAt tSlot, tAX, tAZ
         put tAX into sE[tId]["hx"]
         put tAZ into sE[tId]["hz"]
      end if
      put sE[tId]["hx"] into tAX
      put sE[tId]["hz"] into tAZ
      if sE[tId]["order"] is "attack" then
         put sE[tId]["target"] into tT
         if sE[tT]["side"] is not "foe" then
            -- it fell: back to what the mode says
            put empty into sE[tId]["order"]
            put sE[tId]["x"] into sE[tId]["hx"]
            put sE[tId]["z"] into sE[tId]["hz"]
            put empty into tT
         end if
      end if
      if sE[tId]["order"] is "go" then
         if MM.MoveTo(tId, sE[tId]["gx"], sE[tId]["gz"], 0.6, pDT) then
            -- there: it stays (until F, H or R)
            put empty into sE[tId]["order"]
            put true into sE[tId]["stay"]
            put sE[tId]["gx"] into sE[tId]["hx"]
            put sE[tId]["gz"] into sE[tId]["hz"]
         end if
         next repeat
      end if
      if tT is empty and sMode is "RUSH" then put MM.Nearest(tId, tFoes, 80) into tT
      if tT is empty then
         -- in reach: a bowman or caster as far as it shoots, a warrior 7 m (never far from its place)
         put max(7, MM.Kind(sE[tId]["kind"], "reach")) into tAggro
         put max(tAggro, MM.Kind(sE[tId]["kind"], "range")) into tAggro
         put MM.Nearest(tId, tFoes, tAggro) into tT
         if tT is not empty and MM.Kind(sE[tId]["kind"], "reach") < 3 then
            if sqrt((sE[tT]["x"] - tAX) ^ 2 + (sE[tT]["z"] - tAZ) ^ 2) > 12 then put empty into tT
         end if
      end if
      if tT is not empty then
         MM.Engage tId, tT, pDT
      else
         get MM.MoveTo(tId, tAX, tAZ, 0.8, pDT)
      end if
   end repeat
end MM.Party

-- place n round the banner: two by two behind it
on MM.SlotAt pN, @pX, @pZ
   local tRow, tSide, tR, tF
   put (pN + 1) div 2 into tRow
   if pN mod 2 is 1 then
      put -1 into tSide
   else
      put 1 into tSide
   end if
   put tSide * (1.4 + tRow * 0.5) into tR
   put -1.5 - tRow * 1.6 into tF
   put sBan["x"] + sin(sYaw) * tF + cos(sYaw) * tR into pX
   put sBan["z"] + cos(sYaw) * tF - sin(sYaw) * tR into pZ
end MM.SlotAt

-- the foes: asleep round their fire until one of you comes near; then the nearest of you
on MM.Foes pDT
   local tId, tParty, tT, tC
   put MM.Side("party") into tParty
   repeat for each line tId in MM.Side("foe")
      if sE[tId]["awake"] is not true then
         put MM.Nearest(tId, tParty, 13) into tT
         if tT is not empty then MM.Wake tId
      end if
      if sE[tId]["awake"] is not true then
         -- a little wander round home
         if sTicks mod 90 is tId mod 90 then
            put sE[tId]["hx"] + random(5) - 3 into sE[tId]["gx"]
            put sE[tId]["hz"] + random(5) - 3 into sE[tId]["gz"]
         end if
         if sE[tId]["gx"] is a number then get MM.MoveTo(tId, sE[tId]["gx"], sE[tId]["gz"], 0.5, pDT * 0.4)
         next repeat
      end if
      put sE[tId]["target"] into tT
      if sE[tT]["side"] is not "party" or sTicks mod 30 is tId mod 30 then
         put MM.Nearest(tId, tParty, 30) into tT
         put tT into sE[tId]["target"]
      end if
      if tT is empty then
         -- nobody near: back home, asleep
         if MM.MoveTo(tId, sE[tId]["hx"], sE[tId]["hz"], 1, pDT) then put false into sE[tId]["awake"]
         next repeat
      end if
      MM.Engage tId, tT, pDT
   end repeat
end MM.Foes

-- one wakes: the whole camp wakes
on MM.Wake pId
   local tId
   put true into sE[pId]["awake"]
   if sE[pId]["camp"] is empty then exit MM.Wake
   repeat for each line tId in MM.Side("foe")
      if sE[tId]["camp"] is sE[pId]["camp"] then put true into sE[tId]["awake"]
   end repeat
end MM.Wake

-- walk towards x, z; true when there (within pNear)
function MM.MoveTo pId, pX, pZ, pNear, pDT
   local tDX, tDZ, tD, tSpeed, tNX, tNZ
   put pX - sE[pId]["x"] into tDX
   put pZ - sE[pId]["z"] into tDZ
   put sqrt(tDX * tDX + tDZ * tDZ) into tD
   if tD <= pNear then return true
   put MM.Kind(sE[pId]["kind"], "speed") into tSpeed
   if sE[pId]["side"] is "party" and tD > 6 then put tSpeed * 1.3 into tSpeed
   if MM.Wet(sE[pId]["x"], sE[pId]["z"]) then put tSpeed * 0.55 into tSpeed
   put min(tD, tSpeed * pDT) into tSpeed
   put sE[pId]["x"] + tDX / tD * tSpeed into tNX
   put sE[pId]["z"] + tDZ / tD * tSpeed into tNZ
   if MM.Free(tNX, sE[pId]["z"], 0.4) then put tNX into sE[pId]["x"]
   if MM.Free(sE[pId]["x"], tNZ, 0.4) then put tNZ into sE[pId]["z"]
   put atan2(tDX, tDZ) into sE[pId]["h"]
   put true into sE[pId]["moved"]
   return false
end MM.MoveTo

-- nobody stands inside anybody: close ones step apart a little
on MM.Spread
   local tIds, tA, tB, tDX, tDZ, tD
   put the keys of sE into tIds
   repeat for each line tA in tIds
      repeat for each line tB in tIds
         if tB <= tA then next repeat
         put sE[tB]["x"] - sE[tA]["x"] into tDX
         put sE[tB]["z"] - sE[tA]["z"] into tDZ
         if abs(tDX) > 0.9 or abs(tDZ) > 0.9 then next repeat
         put sqrt(tDX * tDX + tDZ * tDZ) into tD
         if tD >= 0.9 then next repeat
         if tD < 0.01 then
            put 0.5 into tDX
            put 0.01 into tD
         end if
         put (0.9 - tD) / 2 / tD into tD
         if MM.Free(sE[tA]["x"] - tDX * tD, sE[tA]["z"] - tDZ * tD, 0.3) then
            subtract tDX * tD from sE[tA]["x"]
            subtract tDZ * tD from sE[tA]["z"]
         end if
         if MM.Free(sE[tB]["x"] + tDX * tD, sE[tB]["z"] + tDZ * tD, 0.3) then
            add tDX * tD to sE[tB]["x"]
            add tDZ * tD to sE[tB]["z"]
         end if
      end repeat
   end repeat
end MM.Spread

-- every figure, bar and the banner where it is now; a walking figure steps
on MM.Place
   local tId, tH, tMesh, tB
   repeat for each key tId in sE
      put MM.H(sE[tId]["x"], sE[tId]["z"]) into tH
      Entity.SetPosition sE[tId]["key"], sE[tId]["x"] * kM, -tH * kM, sE[tId]["z"] * kM
      Entity.SetRotation sE[tId]["key"], 0, sE[tId]["h"] + 3.14159, 0
      if sE[tId]["moved"] is true then
         put "MM.F." & sE[tId]["fig"] & "." & ((sTicks div 7) mod 2) + 1 into tMesh
      else
         put "MM.F." & sE[tId]["fig"] & ".0" into tMesh
      end if
      put false into sE[tId]["moved"]
      if tMesh is not sE[tId]["mesh"] then
         Entity.SetMesh sE[tId]["key"], tMesh
         put tMesh into sE[tId]["mesh"]
      end if
      put max(0, min(10, round(sE[tId]["hp"] / sE[tId]["hpMax"] * 10))) into tB
      if tB is not sE[tId]["hpB"] then
         Entity.SetMesh sE[tId]["hpKey"], "MM.Bar." & tB
         put tB into sE[tId]["hpB"]
      end if
      Entity.SetPosition sE[tId]["hpKey"], sE[tId]["x"] * kM, -(tH + 2.4) * kM, sE[tId]["z"] * kM
      Entity.SetRotation sE[tId]["hpKey"], 0, sYaw, 0
      if sE[tId]["mpKey"] is not empty then
         put max(0, min(10, round(sE[tId]["mp"] / sE[tId]["mpMax"] * 10))) into tB
         if tB is not sE[tId]["mpB"] then
            Entity.SetMesh sE[tId]["mpKey"], "MM.Bar." & tB
            put tB into sE[tId]["mpB"]
         end if
         Entity.SetPosition sE[tId]["mpKey"], sE[tId]["x"] * kM, -(tH + 2.55) * kM, sE[tId]["z"] * kM
         Entity.SetRotation sE[tId]["mpKey"], 0, sYaw, 0
      end if
   end repeat
   Entity.SetPosition sBan["key"], sBan["x"] * kM, -MM.H(sBan["x"], sBan["z"]) * kM, sBan["z"] * kM
   Entity.SetRotation sBan["key"], 0, sYaw + 1.5708, 0
end MM.Place

-------------------------------------------------------------------- 9. FIGHTING: reach, mana, spells

-- close in on pT until in reach of something this one can do, then do it
on MM.Engage pId, pT, pDT
   local tKind, tD, tReach, tUse, tDX, tDZ
   put sE[pId]["kind"] into tKind
   put MM.Dist(pId, pT) into tD
   put MM.Choose(pId, tD) into tUse
   -- how near it must be: its spell's reach when it can cast, else its weapon's
   put MM.Kind(tKind, "reach") into tReach
   if tUse is "spell" or tUse is "spell2" then put MM.Kind(tKind, "range") into tReach
   if tD > tReach then
      get MM.MoveTo(pId, sE[pT]["x"], sE[pT]["z"], tReach * 0.85, pDT)
      exit MM.Engage
   end if
   -- a bowman too close steps back
   if tReach > 6 and tD < 3 and sE[pId]["side"] is "foe" then
      put sE[pId]["x"] - sE[pT]["x"] into tDX
      put sE[pId]["z"] - sE[pT]["z"] into tDZ
      get MM.MoveTo(pId, sE[pId]["x"] + tDX, sE[pId]["z"] + tDZ, 0.1, pDT * 0.6)
   end if
   put atan2(sE[pT]["x"] - sE[pId]["x"], sE[pT]["z"] - sE[pId]["z"]) into sE[pId]["h"]
   if sE[pId]["cool"] > sNow then exit MM.Engage
   MM.Attack pId, pT, tUse
end MM.Engage

-- what to do at distance pD: spell2 (big, mana high), spell, or the weapon
function MM.Choose pId, pD
   local tKind
   put sE[pId]["kind"] into tKind
   if sE[pId]["scool"] > sNow then return "weapon"
   if MM.Kind(tKind, "spell2") is not empty and sE[pId]["mp"] >= max(MM.Kind(tKind, "cost2"), sE[pId]["mpMax"] * 0.7) and pD <= MM.Kind(tKind, "range") + 2 then return "spell2"
   if MM.Kind(tKind, "spell") is not empty and sE[pId]["mp"] >= MM.Kind(tKind, "cost") and pD <= MM.Kind(tKind, "range") + 4 then return "spell"
   return "weapon"
end MM.Choose

-- the blow, the shot or the spell; the damage lands when the missile arrives (section 10)
on MM.Attack pId, pT, pUse
   local tKind, tPower, tDmg, tSplash, tDelay, tColor
   put sE[pId]["kind"] into tKind
   put MM.Kind(tKind, "cool") into tDelay
   put sNow + tDelay into sE[pId]["cool"]
   put 0 into tSplash
   switch pUse
      case "spell2"
         put MM.Kind(tKind, "spell2") into tPower
         put MM.Kind(tKind, "sdmg2") into tDmg
         subtract MM.Kind(tKind, "cost2") from sE[pId]["mp"]
         put sNow + MM.Kind(tKind, "scool") into sE[pId]["scool"]
         break
      case "spell"
         put MM.Kind(tKind, "spell") into tPower
         put MM.Kind(tKind, "sdmg") into tDmg
         put MM.Kind(tKind, "splash") into tSplash
         subtract MM.Kind(tKind, "cost") from sE[pId]["mp"]
         put sNow + MM.Kind(tKind, "scool") into sE[pId]["scool"]
         break
      default
         put MM.Kind(tKind, "shot") into tPower
         put MM.Kind(tKind, "dmg") into tDmg
   end switch
   if tPower is empty then
      -- a blow: it lands now
      put MM.Kind(tKind, "color") into tColor
      FX.Sparks sE[pT]["x"] * kM, -(MM.H(sE[pT]["x"], sE[pT]["z"]) + 1.2) * kM, sE[pT]["z"] * kM, 5, tColor
      MM.Hurt pT, tDmg, pId
      exit MM.Attack
   end if
   if sSndShot is not sTicks then
      if pUse is "spell" or pUse is "spell2" then
         Sound.Play "Zap"
      else
         Sound.Play "Shoot"
      end if
   end if
   put sTicks into sSndShot
   if MM.PowerForm(tPower) is "wave" then
      -- a war cry: everyone of the other side in front, within the spell's reach
      MM.Cry pId, tPower, tDmg, MM.Kind(tKind, "range")
      exit MM.Attack
   end if
   put MM.FxFire(tPower, pId, pT) into tDelay
   put sNow + tDelay & tab & pT & tab & tDmg & tab & tSplash & tab & pId & tab & tPower & tab & sLastFx & cr after sHits
end MM.Attack

-- a wave in front: every foe within pReach and in front of the caster is hit and pushed back
on MM.Cry pId, pPower, pDmg, pReach
   local tT, tA, tDX, tDZ, tD, tOther
   get MM.FxFire(pPower, pId, sE[pId]["target"])
   if sE[pId]["side"] is "party" then
      put "foe" into tOther
   else
      put "party" into tOther
   end if
   repeat for each line tT in MM.Side(tOther)
      put sE[tT]["x"] - sE[pId]["x"] into tDX
      put sE[tT]["z"] - sE[pId]["z"] into tDZ
      put sqrt(tDX * tDX + tDZ * tDZ) into tD
      if tD > pReach or tD < 0.01 then next repeat
      put abs(MM.Wrap(atan2(tDX, tDZ) - sE[pId]["h"])) into tA
      if tA > 1.1 then next repeat
      put sNow + 0.2 + tD / 20 & tab & tT & tab & pDmg & tab & 0 & tab & pId & tab & "push" & tab & empty & cr after sHits
   end repeat
end MM.Cry

function MM.Wrap pA
   repeat while pA > 3.14159
      subtract 6.28318 from pA
   end repeat
   repeat while pA < -3.14159
      add 6.28318 to pA
   end repeat
   return pA
end MM.Wrap

-- the missiles and spells that arrive now: their damage (and splash) lands
on MM.Arrivals
   local tLine, tKeep, tT, tX, tZ, tOther2, tPower
   if sHits is empty then exit MM.Arrivals
   set the itemDelimiter to tab
   repeat for each line tLine in sHits
      if item 1 of tLine > sNow then
         put tLine & cr after tKeep
         next repeat
      end if
      put item 2 of tLine into tT
      put item 6 of tLine into tPower
      if sEmit and item 7 of tLine is not empty then MM.FxLand item 7 of tLine, tPower
      if sE[tT]["side"] is empty then next repeat
      put sE[tT]["x"] into tX
      put sE[tT]["z"] into tZ
      if not sEmit then FX.Sparks tX * kM, -(MM.H(tX, tZ) + 1.2) * kM, tZ * kM, 6, "#FFE080"
      if tPower is "push" then MM.Push tT, item 5 of tLine, 1.5
      MM.Hurt tT, item 3 of tLine, item 5 of tLine
      if item 4 of tLine > 0 then
         -- the splash: others of its side near it, half as hard
         repeat for each line tOther2 in MM.Side(sE[tT]["side"])
            if tOther2 is tT then next repeat
            if sqrt((sE[tOther2]["x"] - tX) ^ 2 + (sE[tOther2]["z"] - tZ) ^ 2) <= item 4 of tLine then MM.Hurt tOther2, round(item 3 of tLine / 2), item 5 of tLine
         end repeat
      end if
   end repeat
   set the itemDelimiter to comma
   put tKeep into sHits
end MM.Arrivals

-- pushed away from pFrom by pMetres (not into walls)
on MM.Push pId, pFrom, pMetres
   local tDX, tDZ, tD
   if sE[pFrom]["x"] is empty then exit MM.Push
   put sE[pId]["x"] - sE[pFrom]["x"] into tDX
   put sE[pId]["z"] - sE[pFrom]["z"] into tDZ
   put max(0.01, sqrt(tDX * tDX + tDZ * tDZ)) into tD
   if MM.Free(sE[pId]["x"] + tDX / tD * pMetres, sE[pId]["z"] + tDZ / tD * pMetres, 0.4) then
      add tDX / tD * pMetres to sE[pId]["x"]
      add tDZ / tD * pMetres to sE[pId]["z"]
   end if
end MM.Push

on MM.Hurt pId, pDmg, pBy
   if sE[pId]["side"] is empty then exit MM.Hurt
   subtract pDmg from sE[pId]["hp"]
   if sE[pId]["side"] is "foe" then
      if sSndHit is not sTicks then
         Sound.Play "Hit"
      end if
      put sTicks into sSndHit
   else
      if sSndHurt is not sTicks then
         Sound.Play "Hurt"
      end if
      put sTicks into sSndHurt
   end if
   if sE[pId]["side"] is "foe" and sE[pId]["awake"] is not true then MM.Wake pId
   if sE[pId]["side"] is "foe" and sE[pBy]["side"] is "party" then put pBy into sE[pId]["target"]
   if sE[pId]["hp"] > 0 then exit MM.Hurt
   MM.Die pId
end MM.Hurt

-- down: gone, and a foe may leave food or a jewel behind
on MM.Die pId
   local tX, tZ, tKind
   put sE[pId]["x"] into tX
   put sE[pId]["z"] into tZ
   put sE[pId]["kind"] into tKind
   FX.Sparks tX * kM, -(MM.H(tX, tZ) + 1) * kM, tZ * kM, 12, MM.Kind(tKind, "color")
   Entity.Kill sE[pId]["key"]
   Entity.Kill sE[pId]["hpKey"]
   if sE[pId]["mpKey"] is not empty then Entity.Kill sE[pId]["mpKey"]
   if sSndDie is not sTicks then
      if sE[pId]["side"] is "foe" then
         Sound.Play "Explode"
      else
         Sound.Play "PlayerCrash"
      end if
   end if
   put sTicks into sSndDie
   if sE[pId]["side"] is "foe" then
      add 10 + MM.Kind(tKind, "hp") div 5 to sScore
      if tKind is "bog_witch" then
         MM.AddPick "jewel", tX, tZ
      else if random(100) <= 25 then
         MM.AddPick "food", tX, tZ
      else if random(100) <= 12 then
         MM.AddPick "jewel", tX, tZ
      end if
   else
      MM.Say "THE" && toUpper(tKind) && "FELL", 2.5
      MM.Prop "grave", tX, tZ, 0
   end if
   delete variable sE[pId]
   put empty into sHUDWas
end MM.Die

-- mana comes back by itself; fed, four times as fast
on MM.Mana pDT
   local tId, tRegen
   repeat for each key tId in sE
      if sE[tId]["mpMax"] <= 0 then next repeat
      put MM.Kind(sE[tId]["kind"], "regen") into tRegen
      if sE[tId]["fed"] > sNow then put tRegen * 4 into tRegen
      put min(sE[tId]["mpMax"], sE[tId]["mp"] + tRegen * pDT) into sE[tId]["mp"]
   end repeat
end MM.Mana

-------------------------------------------------------------------- 10. SPELLS ON SCREEN (LIB_EMITTERS)

-- fire pPower from pFrom at pTo. The library thinks in a flat picture: x along the way from
-- caster to target, y down. Our slot keeps where that picture stands in the world: the
-- caster's place and ground height, and the direction. Returns the seconds until it lands
-- (sLastFx: the effect's id and where it lands, for MM.FxLand).
function MM.FxFire pPower, pFrom, pTo
   local tOX, tOZ, tOY, tTX, tTZ, tTY, tD, tDX, tDZ, tBX, tFrom, tTo, tId, tSpeed, tForm, tFly
   put sE[pFrom]["x"] into tOX
   put sE[pFrom]["z"] into tOZ
   put MM.H(tOX, tOZ) into tOY
   if sE[pTo]["x"] is a number then
      put sE[pTo]["x"] into tTX
      put sE[pTo]["z"] into tTZ
   else
      put tOX + sin(sE[pFrom]["h"]) * 5 into tTX
      put tOZ + cos(sE[pFrom]["h"]) * 5 into tTZ
   end if
   put MM.H(tTX, tTZ) + 1.1 into tTY
   put tTX - tOX into tDX
   put tTZ - tOZ into tDZ
   put max(0.1, sqrt(tDX * tDX + tDZ * tDZ)) into tD
   put empty into sLastFx
   if not sEmit then return tD / 25
   put sSlot mod 40 + 1 into sSlot
   put tOX & comma & tOZ & comma & tOY & comma & tDX / tD & comma & tDZ / tD into sFr[sSlot]
   put sSlot * kSlotW into tBX
   put tBX & comma & round(-1.4 * kPx) into tFrom
   put round(tBX + tD * kPx) & comma & round(-(tTY - tOY) * kPx) into tTo
   put Emit.Fire(pPower, tFrom, tTo, sE[pFrom]["side"], empty, false) into tId
   put MM.PowerForm(pPower) into tForm
   put 0.15 into tFly
   if tForm is "bit" or tForm is "ball" then
      put max(40, Power.Get(pPower, "speed")) into tSpeed
      put sqrt((tD * kPx) ^ 2 + ((tTY - tOY - 1.4) * kPx) ^ 2) / tSpeed into tFly
   end if
   put tId & comma & tTo into sLastFx
   return tFly
end MM.FxFire

function MM.PowerForm pPower
   if not sEmit then
      if pPower is "sound wave" then return "wave"
      return "ball"
   end if
   return Power.Get(pPower, "form")
end MM.PowerForm

-- a missile arrives: it goes, and its own hit effect (if any) goes off where it landed
on MM.FxLand pInfo, pPower
   local tId, tOn
   put item 1 of pInfo into tId
   if tId is empty then exit MM.FxLand
   if MM.PowerForm(pPower) is among the items of "bit,ball" and Emit.Alive(tId) then
      Emit.Kill tId
      put Power.Get(pPower, "onHit") into tOn
      if tOn is not empty and tOn is not "none" then get Emit.Fire(tOn, item 2 to 3 of pInfo, item 2 to 3 of pInfo, "land", empty, false, 1)
   end if
end MM.FxLand

-- the pool: kPool pairs of objects (the core lines, the glow lines) made once a level
on MM.MakePool
   local i
   put empty into sPoolKey
   put empty into sPoolColor
   put empty into sPoolUsed
   if not sEmit then exit MM.MakePool
   repeat with i = 1 to kPool
      Mesh.Define "MM.FxC" & i, MM.Mesh()
      Mesh.Define "MM.FxG" & i, MM.Mesh()
      put Entity.Spawn("MM.FxC" & i, 0, 0, 0, "#FFFFFF") into sPoolKey[i]["c"]
      put Entity.Spawn("MM.FxG" & i, 0, 0, 0, "#40E0FF") into sPoolKey[i]["g"]
   end repeat
end MM.MakePool

-- each step: the library moves its effects, and we stand their lines up in the world
on MM.FxDraw pDT
   local tIds, tId, tG, tP, i, tSlot, tFr, tC, tW, tLayer, tFirst
   if not sEmit then exit MM.FxDraw
   Emit.Step pDT
   put 0 into i
   put Emit.Ids() into tIds
   repeat for each line tId in tIds
      if i >= kPool then exit repeat
      put Emit.Lines(tId) into tG
      if tG is not an array then next repeat
      -- which slot: from where the effect started in the flat picture
      put item 1 of Emit.Info(tId, "from") into tFirst
      if tFirst is not a number then next repeat
      put trunc((tFirst + kSlotW / 2) / kSlotW) into tSlot
      put sFr[tSlot] into tFr
      if tFr is empty then next repeat
      add 1 to i
      put Emit.Info(tId, "p") into tP
      put MM.Mesh() into tC
      put MM.Mesh() into tW
      MM.FxLines tC, tG["core"], tSlot, tFr, 120
      MM.FxLines tW, tG["back"], tSlot, tFr, 60
      MM.FxLines tW, tG["fill"], tSlot, tFr, 60
      MM.FxDots tW, tG["dots"], tSlot, tFr, 30
      Mesh.Define "MM.FxC" & i, tC
      Mesh.Define "MM.FxG" & i, tW
      Entity.SetPosition sPoolKey[i]["c"], item 1 of tFr * kM, -(item 3 of tFr) * kM, item 2 of tFr * kM
      Entity.SetPosition sPoolKey[i]["g"], item 1 of tFr * kM, -(item 3 of tFr) * kM, item 2 of tFr * kM
      MM.PoolColor i, "c", tP["colorCore"]
      MM.PoolColor i, "g", tP["colorGlow"]
      put true into sPoolUsed[i]
   end repeat
   -- the rest of the pool draws nothing
   repeat with i = i + 1 to kPool
      if sPoolUsed[i] is true then
         Mesh.Define "MM.FxC" & i, MM.Mesh()
         Mesh.Define "MM.FxG" & i, MM.Mesh()
         put false into sPoolUsed[i]
      end if
   end repeat
end MM.FxDraw

on MM.PoolColor pSlotN, pPart, pColor
   if pColor is empty or pColor is sPoolColor[pSlotN][pPart] then exit MM.PoolColor
   Entity.SetColor sPoolKey[pSlotN][pPart], pColor
   put pColor into sPoolColor[pSlotN][pPart]
end MM.PoolColor

-- the library's points ("x,y" a line, an empty line between polylines) as world lines:
-- along = (x - the slot's start) / kPx metres from the caster in the direction, up = -y / kPx
on MM.FxLines @pM, pPoints, pSlot, pFr, pMax
   local tLine, tHave, tX1, tY1, tX2, tY2, tN, tBX, tDX, tDZ
   if pPoints is empty then exit MM.FxLines
   put pSlot * kSlotW into tBX
   put item 4 of pFr into tDX
   put item 5 of pFr into tDZ
   put false into tHave
   put 0 into tN
   repeat for each line tLine in pPoints
      if tLine is empty then
         put false into tHave
         next repeat
      end if
      put (item 1 of tLine - tBX) / kPx into tX2
      put -(item 2 of tLine) / kPx into tY2
      if tHave then
         MM.Line pM, tDX * tX1, tY1, tDZ * tX1, tDX * tX2, tY2, tDZ * tX2
         add 1 to tN
         if tN >= pMax then exit repeat
      end if
      put tX2 into tX1
      put tY2 into tY1
      put true into tHave
   end repeat
end MM.FxLines

-- sparks of the effect: a tiny cross for some of its dots
on MM.FxDots @pM, pPoints, pSlot, pFr, pMax
   local tLine, tN, tBX, tA, tY, tStep, k
   if pPoints is empty then exit MM.FxDots
   put pSlot * kSlotW into tBX
   put max(1, the number of lines of pPoints div pMax) into tStep
   put 0 into k
   put 0 into tN
   repeat for each line tLine in pPoints
      add 1 to k
      if tLine is empty or k mod tStep is not 0 then next repeat
      put (item 1 of tLine - tBX) / kPx into tA
      put -(item 2 of tLine) / kPx into tY
      MM.Line pM, item 4 of pFr * tA - 0.06, tY, item 5 of pFr * tA, item 4 of pFr * tA + 0.06, tY, item 5 of pFr * tA
      add 1 to tN
      if tN >= pMax then exit repeat
   end repeat
end MM.FxDots

-------------------------------------------------------------------- 11. FOOD, JEWELS, PRISONERS

on MM.AddPick pKind, pX, pZ
   local tKey
   add 1 to sPickN
   switch pKind
      case "food"
         put Entity.Spawn("MM.Food", pX * kM, -(MM.H(pX, pZ) + 0.1) * kM, pZ * kM, "#FFB060") into tKey
         break
      case "jewel"
         put Entity.Spawn("MM.Jewel", pX * kM, -(MM.H(pX, pZ) + 0.6) * kM, pZ * kM, "#40FFFF") into tKey
         Entity.SetRotationSpeed tKey, 0, 0.05, 0
         break
      case "captive"
         put Entity.Spawn("MM.F.captive.0", pX * kM, -MM.H(pX, pZ) * kM, pZ * kM, "#FFFFFF") into tKey
         break
   end switch
   put pKind & comma & pX & comma & pZ & comma & tKey into sPick[sPickN]
end MM.AddPick

-- an adventurer who walks over something takes it
on MM.Pickups
   local tN, tId, tKind, tX, tZ, tOther2, tNew
   repeat for each key tN in sPick
      put item 1 of sPick[tN] into tKind
      put item 2 of sPick[tN] into tX
      put item 3 of sPick[tN] into tZ
      repeat for each line tId in MM.Side("party")
         if abs(sE[tId]["x"] - tX) > 1.4 or abs(sE[tId]["z"] - tZ) > 1.4 then next repeat
         switch tKind
            case "food"
               put min(sE[tId]["hpMax"], sE[tId]["hp"] + 25) into sE[tId]["hp"]
               Sound.Play "Pickup"
               put sNow + 20 into sE[tId]["fed"]
               MM.Say "FOOD: THE" && toUpper(sE[tId]["kind"]) && "IS FED, MANA COMES BACK FAST", 2.5
               break
            case "jewel"
               put sE[tId]["mpMax"] into sE[tId]["mp"]
               repeat for each line tOther2 in MM.Side("party")
                  if MM.Dist(tId, tOther2) <= 8 then put min(sE[tOther2]["mpMax"], sE[tOther2]["mp"] + 30) into sE[tOther2]["mp"]
               end repeat
               add 25 to sScore
               Sound.Play "Pickup"
               MM.Say "A JEWEL: MANA FOR EVERYONE NEAR", 2.5
               break
            case "captive"
               MM.AddUnit item random(3) of "warrior,bowman,caster", tX, tZ
               put the result into tNew
               add 50 to sScore
               Sound.Play "Powerup"
               MM.Say "FREED! A" && toUpper(sE[tNew]["kind"]) && "JOINS YOU", 3
               break
         end switch
         FX.Sparks tX * kM, -(MM.H(tX, tZ) + 0.8) * kM, tZ * kM, 10, "#FFFFFF"
         Entity.Kill item 4 of sPick[tN]
         delete variable sPick[tN]
         exit repeat
      end repeat
   end repeat
end MM.Pickups

-------------------------------------------------------------------- 12. ORDERS BY MOUSE (uDead's)

-- left: one adventurer (the nearest free), right: everyone. On a foe: attack it; anywhere
-- else: go there (onto food, a jewel or a prisoner too)
on Game.OnClick pX, pY, pButton
   local tFoe, tPlace
   if sState is not "play" then exit Game.OnClick
   put MM.FoeAt(pX, pY) into tFoe
   if tFoe is not empty then
      if pButton is 3 then
         MM.OrderAll "attack", tFoe
      else
         MM.OrderAttack tFoe
      end if
      exit Game.OnClick
   end if
   put MM.GroundAt(pX, pY) into tPlace
   if tPlace is empty then
      MM.Say "NOTHING THERE", 1
      exit Game.OnClick
   end if
   if pButton is 3 then
      MM.OrderAll "go", tPlace
   else
      MM.OrderGo item 1 of tPlace, item 2 of tPlace
   end if
end Game.OnClick

-- the foe whose middle shows within 30 pixels of the click (the nearest one)
function MM.FoeAt pX, pY
   local tId, tS, tD, tBest, tBestD
   put 30 into tBestD
   repeat for each line tId in MM.Side("foe")
      put Camera.WorldToScreen(sE[tId]["x"] * kM, -(MM.H(sE[tId]["x"], sE[tId]["z"]) + 1) * kM, sE[tId]["z"] * kM) into tS
      if tS is empty then next repeat
      put sqrt((item 1 of tS - pX) ^ 2 + (item 2 of tS - pY) ^ 2) into tD
      if tD < tBestD then
         put tD into tBestD
         put tId into tBest
      end if
   end repeat
   return tBest
end MM.FoeAt

-- the place on the hills under the click: the engine finds it on a flat floor; three
-- times, each at the height of the ground it found the time before
function MM.GroundAt pX, pY
   local tH, tP, k, tGX, tGZ
   put MM.H(sBan["x"], sBan["z"]) into tH
   repeat with k = 1 to 3
      put Camera.ScreenToFloor(pX, pY, -tH * kM) into tP
      if tP is empty then return empty
      put word 1 of tP / kM into tGX
      put word 2 of tP / kM into tGZ
      put MM.H(tGX, tGZ) into tH
   end repeat
   if abs(tGX) > kEdge or abs(tGZ) > kEdge then return empty
   return tGX & comma & tGZ
end MM.GroundAt

on MM.OrderAttack pFoe
   local tId
   put MM.PickFree(sE[pFoe]["x"], sE[pFoe]["z"]) into tId
   if tId is empty then
      MM.Say "NOBODY FREE", 1
      exit MM.OrderAttack
   end if
   put "attack" into sE[tId]["order"]
   put pFoe into sE[tId]["target"]
   Sound.Play "Select"
   FX.Sparks sE[pFoe]["x"] * kM, -(MM.H(sE[pFoe]["x"], sE[pFoe]["z"]) + 2.2) * kM, sE[pFoe]["z"] * kM, 8, "#FF3030"
end MM.OrderAttack

on MM.OrderGo pX, pZ
   local tId
   put MM.PickFree(pX, pZ) into tId
   if tId is empty then
      MM.Say "NOBODY FREE", 1
      exit MM.OrderGo
   end if
   put "go" into sE[tId]["order"]
   put pX into sE[tId]["gx"]
   put pZ into sE[tId]["gz"]
   Sound.Play "Select"
   FX.Sparks pX * kM, -(MM.H(pX, pZ) + 0.1) * kM, pZ * kM, 8, "#58E04A"
end MM.OrderGo

-- everyone: at the one foe, or to the place (spread out round it)
on MM.OrderAll pOrder, pWhat
   local tId, k, tA
   put 0 into k
   repeat for each line tId in MM.Side("party")
      add 1 to k
      put pOrder into sE[tId]["order"]
      if pOrder is "attack" then
         put pWhat into sE[tId]["target"]
      else
         put k * 2.4 into tA
         put item 1 of pWhat + sin(tA) * min(k, 3) * 0.9 into sE[tId]["gx"]
         put item 2 of pWhat + cos(tA) * min(k, 3) * 0.9 into sE[tId]["gz"]
      end if
   end repeat
   if pOrder is "attack" then
      MM.Say "EVERYONE: AT IT", 1.5
   else
      MM.Say "EVERYONE: THERE", 1.5
   end if
end MM.OrderAll

-- uDead's ranking: the nearest adventurer, but one just picked counts as further away, so
-- each click takes the next one
function MM.PickFree pX, pZ
   local tId, tD, tBest, tBestD
   repeat for each line tId in MM.Side("party")
      put sqrt((sE[tId]["x"] - pX) ^ 2 + (sE[tId]["z"] - pZ) ^ 2) into tD
      if sE[tId]["picked"] > sNow then add 200 to tD
      if tBest is empty or tD < tBestD then
         put tId into tBest
         put tD into tBestD
      end if
   end repeat
   if tBest is not empty then put sNow + 3 into sE[tBest]["picked"]
   return tBest
end MM.PickFree

-------------------------------------------------------------------- 13. WINNING, THE CAMERA, THE HUD

on MM.CheckEnd
   if MM.Side("party") is empty then
      put "lost" into sState
      Sound.Play "Lose"
      MM.Say "THE PARTY IS GONE. SPACE TO TRY AGAIN", 999
   else if MM.Side("foe") is empty then
      put "won" into sState
      Sound.Play "Win"
      add 200 to sScore
      if sLevel is 1 then
         MM.Say "THE MEADOW IS SAFE!  SPACE: ON TO THE MARSH", 999
      else
         MM.Say "THE MARSH IS QUIET. TO BE CONTINUED...  SPACE: ROUND AGAIN, HARDER", 999
      end if
   end if
end MM.CheckEnd

-- above and behind the banner: the hand over the party
on MM.Camera
   local tH, tCX, tCY, tCZ, tTX, tTY, tTZ, tDX, tDY, tDZ
   put MM.H(sBan["x"], sBan["z"]) into tH
   put sBan["x"] - sin(sYaw) * sCamD into tCX
   put sBan["z"] - cos(sYaw) * sCamD into tCZ
   put max(tH, MM.H(tCX, tCZ)) + 2 + sCamD * 0.55 into tCY
   put sBan["x"] + sin(sYaw) * 4 into tTX
   put sBan["z"] + cos(sYaw) * 4 into tTZ
   put tH + 0.5 into tTY
   put tTX - tCX into tDX
   put tTY - tCY into tDY
   put tTZ - tCZ into tDZ
   Camera.SetPosition tCX * kM, -tCY * kM, tCZ * kM
   Camera.SetLook atan2(tDX, tDZ), atan2(tDY, sqrt(tDX ^ 2 + tDZ ^ 2))
end MM.Camera

on MM.Say pText, pSeconds
   put pText into sMsg
   put round(pSeconds * 30) into sMsgT
   put empty into sHUDWas
end MM.Say

on MM.ShowHUD
   local tWords, tParty, tFoes, tId, tLine, tY, k
   put MM.Side("party") into tParty
   put MM.Side("foe") into tFoes
   put sName & "|" & the number of lines of tParty & "|" & the number of lines of tFoes & "|" & sScore & "|" & sMode & "|" & sMsg & "|" & sSpeed & "|" & sHelp into tWords
   repeat for each line tId in tParty
      put "|" & round(sE[tId]["hp"] / 5) & "," & round(sE[tId]["mp"] / 5) after tWords
   end repeat
   if tWords is sHUDWas then exit MM.ShowHUD
   put tWords into sHUDWas
   HUD.Clear
   HUD.Set "MM.Top", sName & "   PARTY" && the number of lines of tParty & "   FOES" && the number of lines of tFoes & "   SCORE" && sScore & "   " & sMode & MM.SlowWord(), 20, 30, 14
   if sMsg is not empty then
      put sMsg into tLine
   else
      put "WASD: BANNER  Q E: TURN  CLICK: SEND ONE  RIGHT CLICK: ALL  F H R: FOLLOW HOLD RUSH  I: HELP" into tLine
   end if
   HUD.Set "MM.Msg", tLine, 20, 56, 12
   -- the party, one line each: kind, health, mana (FED while food works)
   put 86 into tY
   put 0 into k
   repeat for each line tId in tParty
      add 1 to k
      put toUpper(sE[tId]["kind"]) && "HP" && max(0, round(sE[tId]["hp"])) into tLine
      if sE[tId]["mpMax"] > 0 then put "  MP" && round(sE[tId]["mp"]) after tLine
      if sE[tId]["fed"] > sNow then put "  FED" after tLine
      HUD.Set "MM.P" & k, tLine, 20, tY, 11
      add 16 to tY
   end repeat
   if sHelp is true then
      HUD.Set "MM.H1", "CLICK A FOE: THE NEAREST FREE ONE ATTACKS. CLICK AGAIN: THE NEXT ONE", 20, tY + 10, 11
      HUD.Set "MM.H2", "CLICK THE GROUND, FOOD, A JEWEL OR A PRISONER: ONE GOES THERE", 20, tY + 26, 11
      HUD.Set "MM.H3", "RIGHT CLICK: EVERYONE. F: FOLLOW  H: HOLD  R: RUSH  Z: SLOW TIME", 20, tY + 42, 11
      HUD.Set "MM.H4", "FOOD: MANA BACK FAST. JEWEL: FULL MANA. UP DOWN: CAMERA NEAR FAR", 20, tY + 58, 11
   end if
end MM.ShowHUD

function MM.SlowWord
   if sSpeed < 1 then return "   SLOW TIME"
   return empty
end MM.SlowWord

-------------------------------------------------------------------- 14. KEYS AND TEST HOOKS

function MM.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end MM.Keys

function MM.Down pCode, pKeys
   return pCode is among the items of pKeys
end MM.Down

function MM.Pressed pCode, pKeys
   return pCode is among the items of pKeys and pCode is not among the items of sKeysWas
end MM.Pressed

on MM.TestKeys pKeys
   put pKeys into sTestKeys
end MM.TestKeys

-- no foes in the camps (tests add their own)
on MM.TestQuiet pFlag
   put pFlag into sQuiet
end MM.TestQuiet

on MM.TestLevel pLevel
   MM.StartLevel pLevel
end MM.TestLevel

function MM.TestAdd pKind, pX, pZ, pCamp
   MM.AddUnit pKind, pX, pZ, pCamp
   return the result
end MM.TestAdd

on MM.TestPick pKind, pX, pZ
   MM.AddPick pKind, pX, pZ
end MM.TestPick

on MM.TestBanner pX, pZ
   put pX into sBan["x"]
   put pZ into sBan["z"]
end MM.TestBanner

-- one fact about one of them: x, z, hp, mp, order, kind, side ... (empty: gone)
function MM.Unit pId, pFact
   if pFact is "at" then return round(sE[pId]["x"], 1) & comma & round(sE[pId]["z"], 1)
   return sE[pId][pFact]
end MM.Unit

on MM.TestSet pId, pFact, pValue
   put pValue into sE[pId][pFact]
end MM.TestSet

-- level|state|party|foes|score|mode|spells on screen|emitters
function MM.State
   local tN
   put 0 into tN
   if sEmit then put item 1 of Emit.Counts() into tN
   return sLevel & "|" & sState & "|" & the number of lines of MM.Side("party") & "|" & the number of lines of MM.Side("foe") & "|" & sScore & "|" & sMode & "|" & tN & "|" & sEmit
end MM.State

function MM.PartyIds
   return MM.Side("party")
end MM.PartyIds

function MM.FoeIds
   return MM.Side("foe")
end MM.FoeIds

function MM.Tools
   return sTools["v3d_buildings"] & "," & sTools["v3d_props"] & "," & sTools["v3d_figures"] & "," & sEmit
end MM.Tools

-- the lines the spells are drawn with this step (all of the pool)
function MM.FxLineCount
   local i, tN, tM
   put 0 into tN
   repeat with i = 1 to kPool
      if sPoolUsed[i] is not true then next repeat
      put Mesh.Get("MM.FxC" & i) into tM
      add the number of lines of tM["lines"] to tN
      put Mesh.Get("MM.FxG" & i) into tM
      add the number of lines of tM["lines"] to tN
   end repeat
   return tN
end MM.FxLineCount

function MM.Height pX, pZ
   return MM.H(pX, pZ)
end MM.Height

-------------------------------------------------------------------- 15. A LITTLE WIRE (Dead Days' helpers)

function MM.Mesh
   local tM
   put 0 into tM["count"]
   put empty into tM["faces"]
   put empty into tM["lines"]
   return tM
end MM.Mesh

-- a line in metres (y up) into a mesh in engine units (y down)
on MM.Line @pM, pX1, pY1, pZ1, pX2, pY2, pZ2
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
end MM.Line

on MM.Box @pM, pX, pY, pZ, pW, pH, pD
   local x1, x2, z1, z2, y2
   put pX - pW / 2 into x1
   put pX + pW / 2 into x2
   put pZ - pD / 2 into z1
   put pZ + pD / 2 into z2
   put pY + pH into y2
   MM.Line pM, x1, pY, z1, x2, pY, z1
   MM.Line pM, x2, pY, z1, x2, pY, z2
   MM.Line pM, x2, pY, z2, x1, pY, z2
   MM.Line pM, x1, pY, z2, x1, pY, z1
   MM.Line pM, x1, y2, z1, x2, y2, z1
   MM.Line pM, x2, y2, z1, x2, y2, z2
   MM.Line pM, x2, y2, z2, x1, y2, z2
   MM.Line pM, x1, y2, z2, x1, y2, z1
   MM.Line pM, x1, pY, z1, x1, y2, z1
   MM.Line pM, x2, pY, z1, x2, y2, z1
   MM.Line pM, x2, pY, z2, x2, y2, z2
   MM.Line pM, x1, pY, z2, x1, y2, z2
end MM.Box
