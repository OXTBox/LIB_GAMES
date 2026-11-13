######################################################################################
## CARD SCRIPT: "Play.Thrmnlra"   GLRBAL THRMNLRA RWA  (working title)  (11 12 2026)
## The owner's typing war game (LIB_GAMES/input/clauderead/games_to_Make_input.txt):
## a terminal that types like a friend in a movie and always spells it mostly wrong,
## a NORAD-style big board, missiles you stop by typing. This card is also the first
## PROTOTYPE of the SEQUENCER: the opening is a cue sheet of clips in a text file,
## Thrmnlra/Data/Sequences/Intro.seq, played by Sequencer/sequencer.livecodescript.
## SCREENS   Intro: login, countdown, big board, launch, the recall key, the title.
##           Map: the tactical world, "standby for final orders" (the typing war is next).
## CONTROLS  type (letters, Return, Backspace)   click: skip ahead   Escape: Developer
## RULES     On the map the world clock can run by KEYSTROKE (Cue Thrm.Clock mode=keys):
##           missiles only move while you type, so you have a chance. Typos escalate:
##           the first alerts an enemy site, the second launches from it.
## NEEDS     Vibecode3D_Games/Sequencer (the player + shared clips) and Thrmnlra/Data.
######################################################################################

global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch
global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPaused, bPlaying

constant kCalm = "#1C4A2A"      -- the world grid at rest: subdued
constant kAlert = "#3FCF66"     -- threatened: vibrant
constant kRed = "#FF3030"       -- red alert, pulsing with kRedDim
constant kRedDim = "#6A1414"
constant kBlue = "#4C8CFF"
constant kEnemy = "#FF5050"
constant kLife = "#50FF90"      -- the green resource all life needs
constant kArmed = "#D0E8FF"     -- a battery with a target: lit up
constant kChosen = "#FFB000"    -- a chosen target's label
constant kCamX = 0, kCamY = 500, kCamZ = 360   -- the big-board camera (Engine.SetCam)
constant kTrailDashes = "2,5,10,20"   -- trail look: 2 px on, 5 off, 10 on, 20 off
constant kTrailKeep = 3               -- seconds a trail stays after its missile lands
constant kKeyStep = 0.3               -- world seconds one keystroke buys (clock mode "keys")
constant kKeyBank = 1.0               -- most world time that can be banked by fast typing
constant kOutboundSecs = 8            -- your first strike's flight: midway (the enemy wakes) at half
constant kBlast = 90                  -- a detonation takes out enemy missiles this close (world units)
constant kGuilt = "#C8C8C8"           -- the machine's cold remarks

local sStepMS = 33, sTicks = 0
local sError         -- set when the sequencer or the data cannot be found
local sReady         -- the Sequencer group is set up
local sMood          -- off, calm, alert, red
local sWorld         -- [grid] key, [bases] lines "key team x z", [life] keys
local sMissiles      -- [key][team|x0|z0|x1|z1|t0|secs|arc]
local sTrail         -- [missile key][pts|color|until]: dashed screen-space trails
local sSites         -- [name] "x z key": the targets on the map, labelled by name
local sClockMode     -- "time" (world runs on its own) or "keys" (each keystroke moves it)
local sWorldT        -- world clock, seconds: missiles and trails run on this
local sBank          -- world seconds bought by keystrokes, not yet played out
local sAlert         -- the alerted enemy base line, and when its tag goes: [line|until]
local sGarbled       -- [text] its misspelling, kept so the sergeant gets your name wrong the same way
local sEnemyAlerted  -- true once a missile of yours crossed midway (or a typo woke them)

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   Engine.ResetCamera
   put Engine.Info("stepMS") into sStepMS
   if sStepMS is not a number then put 33 into sStepMS
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sTicks
   put "off" into sMood
   put empty into sWorld
   put empty into sMissiles
   put empty into sTrail
   put "time" into sClockMode
   put false into sEnemyAlerted
   put 0 into sWorldT
   put 0 into sBank
   put empty into sAlert
   Thrm.MakeMeshes
   Thrm.Stage
   if sError is not empty then
      HUD.Set "Thrm.Err", sError, gViewLeft + 20, gViewTop + 40, 12
      exit Game.OnStart
   end if
   Thrm.Play "Intro"
end Game.OnStart

on Game.OnUpdate
   add 1 to sTicks
   if not sReady then exit Game.OnUpdate
   dispatch "Seq.Step" to group "Sequencer" with sStepMS / 1000
   Thrm.AdvanceWorld
   Thrm.MoveMissiles
   Thrm.AlertStep
   if sMood is "red" and sTicks mod 12 is 0 then Thrm.GridColor
end Game.OnUpdate

on Game.OnClick pX, pY, pButton
   if sReady then dispatch "Seq.Skip" to group "Sequencer"
end Game.OnClick

on Game.OnKill pKey, pX, pY, pZ
end Game.OnKill

on Game.OnPause
end Game.OnPause

on Game.OnResume
end Game.OnResume

on Game.OnStop
   if there is a group "Sequencer" then
      dispatch "Seq.StopAll" to group "Sequencer"
      dispatch "Term.Clear" to group "Sequencer"
      dispatch "Term.Render" to group "Sequencer"
      set the visible of group "Sequencer" to false
   end if
   put false into sReady
end Game.OnStop

on Collision.Hit pA, pB
end Collision.Hit

-------------------------------------------------------------------- typing

-- typed keys go to the running clips (the engine only listens for Escape and CapsLock)
on keyDown pKey
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with pKey
   else
      pass keyDown
   end if
end keyDown

on returnKey
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "return"
   else
      pass returnKey
   end if
end returnKey

on enterKey
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "return"
   else
      pass enterKey
   end if
end enterKey

on backspaceKey
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "backspace"
   else
      pass backspaceKey
   end if
end backspaceKey

-------------------------------------------------------------------- sequences

-- the group "Sequencer" on this card: its behaviour is the shared sequencer script, and
-- every running clip is a small invisible button inside it
on Thrm.Stage
   local tSeq, tData, tShared, tDataDir, n
   put empty into sError
   put false into sReady
   put Thrm.FindFile("LIB_GAMES/Vibecode3D_Games/Sequencer/sequencer.livecodescript") into tSeq
   put Thrm.FindFile("LIB_GAMES/Vibecode3D_Games/Thrmnlra/Data/Sequences/Intro.seq") into tData
   if tSeq is empty or tData is empty then
      put "THRMNLRA: SEQUENCER OR DATA NOT FOUND" into sError
      exit Thrm.Stage
   end if
   set the itemDel to "/"
   put item 1 to -2 of tSeq into tShared
   put item 1 to -3 of tData into tDataDir
   set the itemDel to comma
   lock screen
   if there is not a group "Sequencer" of this card then
      reset the templateGroup
      create group "Sequencer"
      set the lockLoc of group "Sequencer" to true
   end if
   -- a locked group clips what it holds to its rect: card-sized, set while it is empty
   -- (setting the rect of a group that holds objects moves them)
   if the rect of group "Sequencer" is not the rect of this card then
      repeat with n = the number of controls of group "Sequencer" down to 1
         delete control n of group "Sequencer"
      end repeat
      set the rect of group "Sequencer" to the rect of this card
   end if
   set the behavior of group "Sequencer" to the long id of stack tSeq
   set the visible of group "Sequencer" to true
   unlock screen
   dispatch "Seq.Setup" to group "Sequencer" with tDataDir, tShared
   put true into sReady
end Thrm.Stage

on Thrm.Play pName
   dispatch "Seq.Play" to group "Sequencer" with pName
end Thrm.Play

-- a sequence has played to its end: what comes next
on Seq.Ended pName
   switch pName
      case "Intro"
      case "Trainer"
         Thrm.Play "Map"
         break
      case "Peace"
         Thrm.World "off"
         dispatch "Term.Clear" to group "Sequencer"
         Thrm.Play "Intro"
         break
      default
         Thrm.World "off"
         dispatch "Term.Clear" to group "Sequencer"
         Thrm.Play "Intro"
   end switch
end Seq.Ended

-- {var:garble} in a sequence: the text misspelled, always the same way (and never right)
function Seq.Filter pFilter, pValue
   local tOut
   if pFilter is not "garble" then return pValue
   if sGarbled[pValue] is not empty then return sGarbled[pValue]
   repeat 10 times
      put Thrm.Garble(toUpper(pValue), 0.35) into tOut
      if tOut is not toUpper(pValue) and tOut is not empty then exit repeat
   end repeat
   if tOut is toUpper(pValue) or tOut is empty then put toUpper(pValue) & "O" into tOut
   put tOut into sGarbled[pValue]
   return tOut
end Seq.Filter

-- while writing clips: forget the loaded clip and sequencer scripts, read them again
on Thrm.Reload
   if there is a group "Sequencer" then
      dispatch "Seq.Reload" to group "Sequencer"
      set the behavior of group "Sequencer" to empty
   end if
   if there is a stack "Sequencer" then delete stack "Sequencer"
   Thrm.Stage
end Thrm.Reload

-------------------------------------------------------------------- the world (cues)

-- Cue: call=Thrm.World; mood=calm|alert|red|off   (also called with a plain mood word)
on Thrm.World pSet
   local tMood
   if pSet is an array then
      put pSet["mood"] into tMood
   else
      put pSet into tMood
   end if
   if tMood is empty then put "calm" into tMood
   if tMood is "off" then
      Thrm.ClearWorld
      put "off" into sMood
      exit Thrm.World
   end if
   if sWorld["grid"] is empty then Thrm.BuildWorld
   put tMood into sMood
   Thrm.GridColor
end Thrm.World

on Thrm.BuildWorld
   local tSpots, tSpot, tKey
   -- above the map, looking down at it like a big board
   Engine.SetCam kCamX, kCamY, kCamZ
   put 0 into gCameraYaw
   put -atan2(kCamY, kCamZ) into gCameraPitch
   put empty into sWorld["bases"]
   put "-420,-150|-380,40|-300,-60|-430,170|-260,150" into tSpots
   set the itemDel to "|"
   repeat for each item tSpot in tSpots
      set the itemDel to comma
      put Entity.Spawn("Thrm.Base", item 1 of tSpot, 0, item 2 of tSpot, kBlue) into tKey
      put tKey && "blue" && item 1 of tSpot && item 2 of tSpot & cr after sWorld["bases"]
      set the itemDel to "|"
   end repeat
   put "420,140|380,-40|300,60|430,-170|260,-150" into tSpots
   repeat for each item tSpot in tSpots
      set the itemDel to comma
      put Entity.Spawn("Thrm.Base", item 1 of tSpot, 0, item 2 of tSpot, kEnemy) into tKey
      put tKey && "red" && item 1 of tSpot && item 2 of tSpot & cr after sWorld["bases"]
      set the itemDel to "|"
   end repeat
   put "-120,-120|0,-170|110,-90|-80,60|60,120|-10,200|150,30" into tSpots
   repeat for each item tSpot in tSpots
      set the itemDel to comma
      put Entity.Spawn("Thrm.Life", item 1 of tSpot, 0, item 2 of tSpot, kLife) & cr after sWorld["life"]
      set the itemDel to "|"
   end repeat
   set the itemDel to comma
end Thrm.BuildWorld

-- the grid takes the mood's colour (an object's colour is its graphic: kill and respawn)
on Thrm.GridColor
   local tColor
   switch sMood
      case "alert"
         put kAlert into tColor
         break
      case "red"
         if (sTicks div 12) mod 2 is 0 then
            put kRed into tColor
         else
            put kRedDim into tColor
         end if
         break
      default
         put kCalm into tColor
   end switch
   if sWorld["gridColor"] is tColor and sWorld["grid"] is not empty then exit Thrm.GridColor
   if sWorld["grid"] is not empty then Entity.Kill sWorld["grid"]
   put Entity.Spawn("Thrm.Grid", 0, 2, 0, tColor) into sWorld["grid"]
   put tColor into sWorld["gridColor"]
end Thrm.GridColor

on Thrm.ClearWorld
   local tKey, tLine
   if sWorld["grid"] is not empty then Entity.Kill sWorld["grid"]
   repeat for each line tLine in sWorld["bases"]
      Entity.Kill word 1 of tLine
   end repeat
   repeat for each line tKey in sWorld["life"]
      Entity.Kill tKey
   end repeat
   repeat for each key tKey in sMissiles
      dispatch "Term.Remove" to group "Sequencer" with "mlbl." & tKey
      Entity.Kill tKey
   end repeat
   repeat for each key tKey in sTrail
      dispatch "Term.Remove" to group "Sequencer" with "trail." & tKey
   end repeat
   repeat for each key tKey in sSites
      if word 3 of sSites[tKey] is not empty then Entity.Kill word 3 of sSites[tKey]
      dispatch "Term.Remove" to group "Sequencer" with "lbl." & tKey
   end repeat
   put empty into sSites
   dispatch "Term.Remove" to group "Sequencer" with "alert"
   put empty into sAlert
   put "time" into sClockMode
   put false into sEnemyAlerted
   put empty into sWorld
   put empty into sMissiles
   put empty into sTrail
end Thrm.ClearWorld

-------------------------------------------------------------------- missiles

-- Cue: call=Thrm.Launch; n=10   both sides fire (team=blue|red fires one side only)
--      call=Thrm.Launch; from=armed   every battery you gave a target fires at it
on Thrm.Launch pSet
   local n, k, tTeam, tLine
   if sWorld["grid"] is empty then exit Thrm.Launch
   if pSet["from"] is "armed" then
      put 0 into k
      repeat for each line tLine in sWorld["bases"]
         if word 5 of tLine is "armed" then
            Thrm.FireFrom tLine, k * 0.3
            add 1 to k
         end if
      end repeat
      exit Thrm.Launch
   end if
   put pSet["n"] into n
   if n is not a number then put 6 into n
   repeat with k = 1 to n
      put pSet["team"] into tTeam
      if tTeam is empty then
         if k mod 2 is 0 then
            put "blue" into tTeam
         else
            put "red" into tTeam
         end if
      end if
      Thrm.Fire tTeam, (k - 1) * 0.15
   end repeat
end Thrm.Launch

-- one missile from a random base of a team to a random spot on the other side
on Thrm.Fire pTeam, pDelay
   local tFrom, tLines
   repeat for each line tFrom in sWorld["bases"]
      if word 2 of tFrom is pTeam then put tFrom & cr after tLines
   end repeat
   if tLines is empty then exit Thrm.Fire
   Thrm.FireFrom line random(the number of lines of tLines) of tLines, pDelay
end Thrm.Fire

-- one missile from a base line "key team x z [armed target]" to a random spot across the map
on Thrm.FireFrom pFrom, pDelay
   local tKey, tColor, tDir, tTeam, tSite
   put word 2 of pFrom into tTeam
   if tTeam is "blue" then
      put kBlue into tColor
      put 1 into tDir
   else
      put kEnemy into tColor
      put -1 into tDir
   end if
   put Entity.Spawn("Thrm.Missile", word 3 of pFrom, 0, word 4 of pFrom, tColor) into tKey
   put tTeam into sMissiles[tKey]["team"]
   put tColor into sMissiles[tKey]["color"]
   put word 3 of pFrom into sMissiles[tKey]["x0"]
   put word 4 of pFrom into sMissiles[tKey]["z0"]
   put sSites[word 6 of pFrom] into tSite
   if word 5 of pFrom is "armed" and tSite is not empty then
      -- an armed battery flies to its chosen target
      put word 1 of tSite into sMissiles[tKey]["x1"]
      put word 2 of tSite into sMissiles[tKey]["z1"]
   else
      put tDir * (180 + random(260)) into sMissiles[tKey]["x1"]
      put random(440) - 220 into sMissiles[tKey]["z1"]
   end if
   put sWorldT + pDelay into sMissiles[tKey]["t0"]
   put 2.5 + random(20) / 10 into sMissiles[tKey]["secs"]
   put 140 + random(120) into sMissiles[tKey]["arc"]
   if word 5 of pFrom is "armed" then
      -- your first strike: slow enough to recall, and named so you can type it
      put kOutboundSecs + random(10) / 10 into sMissiles[tKey]["secs"]
      put Thrm.AssetName() into sMissiles[tKey]["name"]
      put word 6 of pFrom into sMissiles[tKey]["site"]
   end if
end Thrm.FireFrom

-- M123, M345, MZ98: short, typeable, never the same twice in the air
function Thrm.AssetName
   local tName, tKey, tTaken
   repeat 50 times
      put "M" & random(9) & random(10) - 1 & random(10) - 1 into tName
      if random(3) is 1 then put char random(26) of "ABCDEFGHJKLMNPQRSTUVWXYZ" into char 2 of tName
      put false into tTaken
      repeat for each key tKey in sMissiles
         if sMissiles[tKey]["name"] is tName then put true into tTaken
      end repeat
      if not tTaken then return tName
   end repeat
   return tName
end Thrm.AssetName

-- the Outbound clip asks: the names of your missiles still in the air
function Thrm.Outbound
   local tKey, tOut
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["name"] is not empty then put sMissiles[tKey]["name"] & comma after tOut
   end repeat
   delete the last char of tOut
   return tOut
end Thrm.Outbound

function Thrm.EnemyAlerted
   return sEnemyAlerted
end Thrm.EnemyAlerted

-- a name typed in the Outbound clip: before the enemy knows, the missile is RECALLED
-- (it turns into nothing, quietly); after, it DETONATES in the air and takes enemy
-- missiles near it with it (Missile Command). Returns recalled / detonated / empty.
on Thrm.Detonate pName
   local tKey, tMine, x, y, z, tOther, d, tHits
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["name"] is pName then put tKey into tMine
   end repeat
   if tMine is empty then return empty
   put sMissiles[tMine]["x"] into x
   put sMissiles[tMine]["y"] into y
   put sMissiles[tMine]["z"] into z
   if not sEnemyAlerted then
      FX.Sparks x, y, z, 10, kBlue
      Thrm.EndMissile tMine
      Thrm.Say pName && "RECALLED."
      return "recalled"
   end if
   FX.Sparks x, y, z, 50, "#FFFFFF"
   put 0 into tHits
   repeat for each key tOther in sMissiles
      if sMissiles[tOther]["team"] is not "red" or sMissiles[tOther]["x"] is empty then next repeat
      put sqrt((sMissiles[tOther]["x"] - x) ^ 2 + (sMissiles[tOther]["y"] - y) ^ 2 + (sMissiles[tOther]["z"] - z) ^ 2) into d
      if d < kBlast then
         FX.Sparks sMissiles[tOther]["x"], sMissiles[tOther]["y"], sMissiles[tOther]["z"], 30, kEnemy
         Thrm.EndMissile tOther
         add 1 to tHits
      end if
   end repeat
   Thrm.EndMissile tMine
   if tHits > 0 then
      Thrm.Say pName && "DETONATED." && tHits && "INCOMING DESTROYED."
   else
      Thrm.Say pName && "DETONATED. NOTHING IN RANGE."
   end if
   return "detonated"
end Thrm.Detonate

-- take a missile out of the air: its label goes, its trail fades out later
on Thrm.EndMissile pKey
   put sWorldT + kTrailKeep into sTrail[pKey]["until"]
   dispatch "Term.Remove" to group "Sequencer" with "mlbl." & pKey
   Entity.Kill pKey
   delete variable sMissiles[pKey]
end Thrm.EndMissile

-- the machine's cold remarks, on the console
on Thrm.Say pText
   dispatch function "Term.Print" to group "Sequencer" with pText, kGuilt
end Thrm.Say

-- one of your missiles crossed midway: they know. The guilt, and their answer.
on Thrm.WakeEnemy
   local k
   if sEnemyAlerted then exit Thrm.WakeEnemy
   put true into sEnemyAlerted
   Thrm.Say "ENEMY ALERTED. YOU DID THIS."
   Thrm.Say "NOW YOU HAVE TO SEE IT THROUGH."
   Thrm.World "red"
   repeat with k = 1 to 4
      Thrm.Fire "red", 0.3 + k * 0.4
   end repeat
end Thrm.WakeEnemy

-- the Targets clip: a name typed right lights up battery n on your side
on Thrm.Target pName, pN
   local tOut, tLine, k, tKey
   if sWorld["grid"] is empty then exit Thrm.Target
   put 0 into k
   repeat for each line tLine in sWorld["bases"]
      if word 2 of tLine is "blue" then
         add 1 to k
         if k is pN then
            Entity.Kill word 1 of tLine
            put Entity.Spawn("Thrm.Base", word 3 of tLine, 0, word 4 of tLine, kArmed) into tKey
            FX.Sparks word 3 of tLine, -10, word 4 of tLine, 16, kArmed
            put tKey && "blue" && word 3 to 4 of tLine && "armed" && pName into tLine
         end if
      end if
      put tLine & cr after tOut
   end repeat
   put tOut into sWorld["bases"]
   if sSites[pName] is not empty then dispatch "Term.Color" to group "Sequencer" with "lbl." & pName, kChosen
end Thrm.Target

-- the Targets clip starts: every name gets a place on the enemy side, labelled on the map
-- (the red bases first, then extra sites: command centres, cult ritual grounds)
on Thrm.ShowTargets pNames
   local k, tName, tBases, tLine, tExtra, x, z, tKey, tXY
   if sWorld["grid"] is empty then exit Thrm.ShowTargets
   repeat for each line tLine in sWorld["bases"]
      if word 2 of tLine is "red" then put word 3 to 4 of tLine & cr after tBases
   end repeat
   put "200,10|330,200|180,-200|470,0|250,-60" into tExtra
   put 0 into k
   repeat for each item tName in pNames
      add 1 to k
      if k <= the number of lines of tBases then
         put word 1 of line k of tBases into x
         put word 2 of line k of tBases into z
         put empty into tKey
      else
         set the itemDel to "|"
         put item (k - the number of lines of tBases) of tExtra into tXY
         set the itemDel to comma
         if tXY is empty then exit repeat
         put item 1 of tXY into x
         put item 2 of tXY into z
         put Entity.Spawn("Thrm.Site", x, 0, z, kEnemy) into tKey
      end if
      put x && z && tKey into sSites[tName]
      put Thrm.Screen(x, -6, z) into tXY
      if tXY is not empty then
         dispatch "Term.Set" to group "Sequencer" with "lbl." & tName, tName, \
               round(word 1 of tXY - the number of chars of tName * 5), round(word 2 of tXY + 10), 10, kEnemy
      end if
   end repeat
end Thrm.ShowTargets

-- world point -> card pixels "x y" for the big-board camera (empty if behind it)
function Thrm.Screen pX, pY, pZ
   local tP
   put Mat3.Apply(Mat3.Camera(), pX + kCamX, pY + kCamY, pZ + kCamZ) into tP
   return ProjectVertex(word 1 of tP, word 2 of tP, word 3 of tP)
end Thrm.Screen

-- arcs over the map, a dotted trail behind each, sparks where they land
on Thrm.MoveMissiles
   local tKey, u, x, y, z, tNow, tXY
   if sMissiles is not an array then exit Thrm.MoveMissiles
   put sWorldT into tNow
   repeat for each key tKey in sMissiles
      put (tNow - sMissiles[tKey]["t0"]) / sMissiles[tKey]["secs"] into u
      if u < 0 then next repeat
      put sMissiles[tKey]["x0"] + (sMissiles[tKey]["x1"] - sMissiles[tKey]["x0"]) * min(u, 1) into x
      put sMissiles[tKey]["z0"] + (sMissiles[tKey]["z1"] - sMissiles[tKey]["z0"]) * min(u, 1) into z
      if u >= 1 then
         FX.Sparks x, 0, z, 24, sMissiles[tKey]["color"]
         Thrm.TrailPoint tKey, x, 0, z, sMissiles[tKey]["color"]
         if sMissiles[tKey]["site"] is not empty then
            Thrm.Say sMissiles[tKey]["site"] && "IS GONE. THERE WERE PEOPLE THERE."
         end if
         Thrm.EndMissile tKey
         next repeat
      end if
      put -sMissiles[tKey]["arc"] * 4 * u * (1 - u) into y
      SetObjectPosition tKey, x, y, z
      put x into sMissiles[tKey]["x"]
      put y into sMissiles[tKey]["y"]
      put z into sMissiles[tKey]["z"]
      if sMissiles[tKey]["name"] is not empty then
         -- your missile's name rides beside it; past midway the enemy knows
         if u >= 0.5 then Thrm.WakeEnemy
         put Thrm.Screen(x, y, z) into tXY
         if tXY is not empty then
            dispatch "Term.Set" to group "Sequencer" with "mlbl." & tKey, sMissiles[tKey]["name"], \
                  round(word 1 of tXY) + 8, round(word 2 of tXY) - 14, 9, kArmed
         end if
      end if
      if sTicks mod 3 is 0 then Thrm.TrailPoint tKey, x, y, z, sMissiles[tKey]["color"]
   end repeat
   -- trails of landed missiles stay a moment, then go
   repeat for each key tKey in sTrail
      if sTrail[tKey]["until"] is a number and tNow > sTrail[tKey]["until"] then
         dispatch "Term.Remove" to group "Sequencer" with "trail." & tKey
         delete variable sTrail[tKey]
      end if
   end repeat
end Thrm.MoveMissiles

-- a missile's trail is a few screen points (the camera holds still) drawn as one dashed
-- line: a point every 3 steps is enough, the dashes make it read as a tracked arc
on Thrm.TrailPoint pKey, pX, pY, pZ, pColor
   local tXY
   put Thrm.Screen(pX, pY, pZ) into tXY
   if tXY is empty then exit Thrm.TrailPoint
   put round(word 1 of tXY) & comma & round(word 2 of tXY) & cr after sTrail[pKey]["pts"]
   dispatch "Term.Path" to group "Sequencer" with "trail." & pKey, sTrail[pKey]["pts"], pColor, kTrailDashes
end Thrm.TrailPoint

-- a wrong key while recalling: the enemy (or an ally, for no good reason) fires again
-- a typo: the first alerts an enemy site (it flashes, an ALERT tag over it), the second
-- launches from that same site, so the player sees which mistake did it. Then again.
on Thrm.Typo pCount
   local tLines, tLine, tXY
   if sWorld["grid"] is empty then exit Thrm.Typo
   if sAlert["line"] is empty then
      repeat for each line tLine in sWorld["bases"]
         if word 2 of tLine is "red" then put tLine & cr after tLines
      end repeat
      if tLines is empty then exit Thrm.Typo
      put line random(the number of lines of tLines) of tLines into sAlert["line"]
      FX.Sparks word 3 of sAlert["line"], -10, word 4 of sAlert["line"], 20, "#FFFFFF"
      put Thrm.Screen(word 3 of sAlert["line"], -30, word 4 of sAlert["line"]) into tXY
      if tXY is not empty then
         put round(word 1 of tXY) - 25 && round(word 2 of tXY) - 16 into sAlert["xy"]
         dispatch "Term.Set" to group "Sequencer" with "alert", "ALERT", word 1 of sAlert["xy"], word 2 of sAlert["xy"], 10, kRed
      end if
      if sMood is "calm" then Thrm.World "alert"
      put Thrm.Now() + 30 into sAlert["until"]
      put true into sEnemyAlerted     -- they heard you: recalling is over, detonating starts
      return "alert"
   else
      Thrm.FireFrom sAlert["line"], 0
      if sAlert["xy"] is not empty then
         dispatch "Term.Set" to group "Sequencer" with "alert", "LAUNCH", word 1 of sAlert["xy"] - 5, word 2 of sAlert["xy"], 10, kRed
      end if
      put empty into sAlert["line"]
      put Thrm.Now() + 0.8 into sAlert["until"]
      return "launch"
   end if
end Thrm.Typo

-- the ALERT tag blinks while the site waits; LAUNCH shows a moment, then goes
on Thrm.AlertStep
   if sAlert["until"] is empty then exit Thrm.AlertStep
   if Thrm.Now() > sAlert["until"] then
      dispatch "Term.Remove" to group "Sequencer" with "alert"
      put empty into sAlert
      exit Thrm.AlertStep
   end if
   if sAlert["line"] is not empty then
      if sTicks mod 8 is 0 then dispatch "Term.Color" to group "Sequencer" with "alert", kRedDim
      if sTicks mod 8 is 4 then dispatch "Term.Color" to group "Sequencer" with "alert", kRed
   end if
end Thrm.AlertStep

-------------------------------------------------------------------- the world clock

-- Cue: call=Thrm.Clock; mode=keys|time; step=0.3   (keys: the world moves only as you type)
on Thrm.Clock pSet
   put pSet["mode"] into sClockMode
   if sClockMode is not "keys" then put "time" into sClockMode
   put 0 into sBank
end Thrm.Clock

on Thrm.KeyTick
   if sClockMode is "keys" then put min(kKeyBank, sBank + kKeyStep) into sBank
end Thrm.KeyTick

-- time mode: a frame's worth; keys mode: play out what the keystrokes bought, smoothly
on Thrm.AdvanceWorld
   local tDT
   put sStepMS / 1000 into tDT
   if sClockMode is "keys" then
      put min(sBank, tDT) into tDT
      subtract tDT from sBank
   end if
   add tDT to sWorldT
end Thrm.AdvanceWorld

-------------------------------------------------------------------- words

-- the machine always spells it mostly wrong: neighbour keys, doubled and dropped letters
function Thrm.Garble pText, pRate
   local tOut, tCh, tRow, p
   if pRate is not a number then put 0.2 into pRate
   repeat for each char tCh in pText
      if tCh is not in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" or random(1000) > pRate * 1000 then
         put tCh after tOut
         next repeat
      end if
      switch random(5)
         case 1
            put tCh & tCh after tOut           -- doubled
            break
         case 2
            break                              -- dropped
         case 3
            if tCh is a number then
               put char random(26) of "QWERTYUIOPASDFGHJKLZXCVBNM" after tOut
            else
               put random(10) - 1 after tOut
            end if
            break
         default
            -- a neighbour on the keyboard
            repeat for each item tRow in "1234567890,QWERTYUIOP,ASDFGHJKL,ZXCVBNM"
               put offset(tCh, tRow) into p
               if p > 0 then exit repeat
            end repeat
            if p > 1 and (random(2) is 1 or p is the number of chars of tRow) then
               put char p - 1 of tRow after tOut
            else if p > 0 and p < the number of chars of tRow then
               put char p + 1 of tRow after tOut
            else
               put tCh after tOut
            end if
      end switch
   end repeat
   return tOut
end Thrm.Garble

-------------------------------------------------------------------- meshes and files

on Thrm.MakeMeshes
   Mesh.Define "Thrm.Grid", MeshGrid(24, 12, 40)
   Mesh.Define "Thrm.Base", MeshPyramid(4, 16, 24)
   Mesh.Define "Thrm.Life", MeshBox(30, 4, 30)
   Mesh.Define "Thrm.Missile", MeshPyramid(3, 6, 14)
   Mesh.Define "Thrm.Site", MeshPrism(6, 12, 4)
end Thrm.MakeMeshes

function Thrm.Now
   return sTicks * sStepMS / 1000
end Thrm.Now

-- a file beside this stack (or up from it), else in the WSL projects folder
function Thrm.FindFile pRelPath
   local tPath, tTry
   put the effective filename of this stack into tPath
   set the itemDel to "/"
   repeat 8 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      put tPath & "/" & pRelPath into tTry
      if there is a file tTry then return tTry
   end repeat
   put "//wsl$/Ubuntu/home/igame3d/projects/" & pRelPath into tTry
   if there is a file tTry then return tTry
   return empty
end Thrm.FindFile
