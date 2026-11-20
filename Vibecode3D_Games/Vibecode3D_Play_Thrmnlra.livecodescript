######################################################################################
## CARD SCRIPT: "Play.Thrmnlra"   GLRBAL THRMNLRA RWA  (working title)  (11 12 2026)
## The owner's typing war game (~/projects/LIB_LLMOUT/Read/LIB_GAMES/games_to_Make_input.txt):
## a terminal that types like a friend in a movie and always spells it mostly wrong,
## a NORAD-style big board, missiles you stop by typing. This card is also the first
## PROTOTYPE of the SEQUENCER: the opening is a cue sheet of clips in a text file,
## Thrmnlra/Data/Sequences/Intro.seq, played by Sequencer/sequencer.livecodescript.
## SCREENS   Intro: login, countdown, big board, launch, the title.
##           Trainer: the Sarge's boot camp (type WHAT / HUH / WTF / HELP at the Intro).
##           Map: the redesign of 13 Nov (Thrmnlra/DESIGN.md): the LAUNCH trap, your
##           missiles on the pads (recall them by name), the bombers, STAND DOWN. Every
##           typo fills a letter of the LAUNCH CODES on the Big Board.
##           Strike: the codes are complete (or a bomber got through): your missiles fly
##           left to right, theirs answer right to left, type their names to destroy them
##           ([TAB] cycles focus, and costs time), IT'S WAR, the direct order, STRANGE GAME.
##           Peace: you stood the command down before the codes filled up.
## CONTROLS  type (letters, space, Return, Backspace, Tab)   click: skip ahead   Escape: Developer
## RULES     On the map the world clock runs by KEYSTROKE (Cue Thrm.Clock mode=keys):
##           missiles only move while you type, so you have a chance. What a typo does
##           depends on the phase (Thrm.Typo).
## NEEDS     Vibecode3D_Games/Sequencer (the player + shared clips) and Thrmnlra/Data.
######################################################################################

global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPaused, bPlaying

constant kCalm = "#0A280A"      -- the world grid at rest: 10,40,10, nearly invisible (the owner)
constant kPace = 0.7             -- everything runs at this speed (1 = full; the owner: "way too fast")
constant kAlert = "#3FCF66"     -- threatened: vibrant
constant kRed = "#FF3030"       -- red alert, pulsing with kRedDim
constant kRedDim = "#6A1414"
constant kBlue = "#4C8CFF"
constant kEnemy = "#FF5050"
constant kLife = "#50FF90"      -- the green resource all life needs
constant kArmed = "#D0E8FF"     -- a battery with a target: lit up
constant kChosen = "#FFB000"    -- a chosen target's label
constant kCamX = 0, kCamY = 420, kCamZ = 260   -- the big-board camera: a bit higher than on 12 Nov (the owner,
                                                -- 13 Nov: "we need more room on the map"), so the
constant kLookZ = 60                            -- world fills the screen under a top console; it looks
                                                -- this far past the centre, so the map sits low
constant kSargeClip = "Animazoo_hands_on_hips"  -- the TRON fists-on-hips idle (LIB_MOCAP library)
constant kSargeM = 120                -- engine units a metre for the Sarge: a giant standing on the back of the map
constant kSargeColor = "#FFB000"
constant kSargeFrames = 240           -- the first 8 seconds of the idle, looped
constant kStudioX = 8000              -- the close-up studio, far off the map
constant kFaceCell = 10, kFaceHeight = 6, kFaceDist = 380   -- the grid face (as on Play.Face)
constant kOverlays = "trail.,lbl.,mlbl.,tag.,codes,strobe"     -- map overlays hidden in a close-up
constant kTrailDashes = "2,5,10,20"   -- trail look: 2 px on, 5 off, 10 on, 20 off
constant kTrailKeep = 3               -- seconds a trail stays after its missile lands
constant kKeyStep = 0.25              -- world seconds one keystroke buys (clock mode "keys")
constant kKeyBank = 1.0               -- most world time that can be banked by fast typing
constant kGuilt = "#C8C8C8"           -- the machine's cold remarks
-- the redesign (the owner's notes of 13 Nov, Thrmnlra/DESIGN.md)
constant kGlobeR = 760, kSag = 0.4    -- the map is the top of a globe this big; its edges fall away
constant kBlueLabel = "#8FB8FF"       -- our city names
constant kGone = "#2A2A2A"            -- a city that is gone: its name, gone dark
constant kCrater = "#3A1212"          -- the dim ring where a missile came down
constant kBlackR = 70                 -- everything this close to a blast is gone (world units)
constant kPadLift = 40                -- a raised missile waits this high over its silo
constant kOurWords = "OWL,ELK,FOX,YAK,EMU,ANT,BEE,COW"                      -- our missiles
constant kTheirWords = "SUN,MUD,FIG,JAM,ICE,OAK,RUG,TEA,PIE,ZIP,KEG,HAT,BOX,CUP"   -- theirs
constant kEnemyDim = "#A04040", kFocus = "#FFE0E0"   -- their names: dim, or focused with Tab
constant kTagDim = "#401010"          -- ALERT / ARMED tags blink to this
constant kCodeLen = 8                 -- letters of the launch code
constant kCodeDim = 0.14              -- how bright the empty code line is (0..1): barely there
constant kStrobeColors = "#FFFF40,#FF9020,#FF3030"   -- yellow, orange, RED
constant kBomberKeys = 34             -- keystrokes until the bombers reach their target
constant kStrikeSecs = 9              -- our strike's flight (world seconds; slow, the owner)
constant kIncomingSecs = 15           -- their missiles' flight, moved only by your keys
constant kCounterMin = 3, kCounterMax = 10   -- missiles in their answer

local sStepMS = 33, sTicks = 0
local sError         -- set when the sequencer or the data cannot be found
local sReady         -- the Sequencer group is set up
local sMood          -- off, calm, alert, red
local sWorld         -- [grid] key, [life] [craters] keys
local sBase          -- [id][key|team|kind|x|z|name|state|alerted]: silos, command posts, cities
local sBaseIds       -- the base ids, a line each (b1, b2...)
local sMissiles      -- [key][team|kind|x0|y0|z0|x1|y1|z1|t0|secs|arc|name|target]; kind missile|pad|bomber|home
local sTrail         -- [missile key][pts|color|until]: dashed screen-space trails
local sPhase         -- recall, standdown, strike, incoming, order (Cue Thrm.Phase); empty in the Trainer
local sAlertCount    -- typos of the first round: their missiles ready for the answer
local sCode, sCodeDone   -- the launch code letters typed by mistake; true once complete
local sTags          -- [base id] colour: blinking ALERT / ARMED / LAUNCH tags
local sStrobe        -- [text|colors|t0|shown]: the strobing order under the console
local sFocus         -- the enemy missile Tab gave the focus to
local sStruck        -- "x z" lines: where missiles came down
local sWar           -- true once the war started (no second start)
local sClockMode     -- "time" (world runs on its own) or "keys" (each keystroke moves it)
local sWorldT        -- world clock, seconds: missiles and trails run on this
local sBank          -- world seconds bought by keystrokes, not yet played out
local sAlert         -- [id]: the Trainer's alerted silo (its next typo launches from it)
local sGarbled       -- [text] its misspelling, kept so the sergeant gets your name wrong the same way
local sSarge         -- [key|frame|frames|fps|loaded]: the drill sergeant on the map
local sClose         -- [until|panel|face|n]: an angry close-up is on screen

-------------------------------------------------------------------- engine hooks

on Game.OnStart
   focus on nothing          -- typing belongs to the game, never to a menu button or a field
   Camera.Reset
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
   put empty into sPhase
   put empty into sTags
   put empty into sStrobe
   put empty into sStruck
   put empty into sCode
   put empty into sCodeDone
   put false into sWar
   put 0 into sWorldT
   put 0 into sBank
   put empty into sAlert
   put empty into sSarge
   put empty into sClose
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
   -- the keyboard belongs to the game while it plays: take it back from any field
   if sTicks mod 15 is 1 and word 1 of the focusedObject is among the words of "field button" then focus on nothing   -- typing belongs to the game (a focused menu button swallowed Return)
   dispatch "Seq.Step" to group "Sequencer" with kPace * sStepMS / 1000
   Thrm.AdvanceWorld
   Thrm.MoveMissiles
   Thrm.TagStep
   Thrm.StrobeStep
   Thrm.SargeStep
   Thrm.CloseUpStep
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

-- when a field has the keyboard (the xt3d bench has fields), Return arrives as returnInField,
-- not returnKey: without these the name prompt never finished (the owner's bug, 2026-11-13)
on returnInField
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "return"
   else
      pass returnInField
   end if
end returnInField

on enterInField
   if sReady and bPlaying then
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "return"
   else
      pass enterInField
   end if
end enterInField

-- Tab cycles the focus among the enemy missiles (their names grow easy to read), and the
-- doom clock moves twice for it: the advantage is a trap (the owner, 13 Nov)
on tabKey
   if sReady and bPlaying then
      Thrm.KeyTick
      Thrm.KeyTick
      dispatch "Seq.Key" to group "Sequencer" with "tab"
   else
      pass tabKey
   end if
end tabKey

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
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/Sequencer/sequencer.livecodescript") into tSeq
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/Thrmnlra/Data/Sequences/Intro.seq") into tData
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
   -- a new game: the LAUNCH typed in the last one's Trainer is forgotten
   if pName is "Intro" then dispatch "Seq.SetVar" to group "Sequencer" with "launched", empty
   dispatch "Seq.Play" to group "Sequencer" with pName
end Thrm.Play

-- a sequence has played to its end: what comes next
on Seq.Ended pName
   switch pName
      case "Intro"
      case "Trainer"
         Thrm.Play "Map"
         break
      case "Map"
         -- STAND DOWN THE COMMAND typed before the launch codes filled up
         Thrm.Play "Peace"
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

-- the map (the owner, 13 Nov): our side on the LEFT, theirs on the RIGHT; tiny bases whose
-- shape says what they are (triangle = missile silo, square = command post, circle = city)
-- so there is room for the arcs. Lines: team kind x z [name]
function Thrm.Layout
   return "blue Silo -520 -140" & cr & "blue Silo -440 160" & cr & "blue Silo -330 -60" & cr \
         & "blue Silo -250 130" & cr & "blue Command -420 20" & cr \
         & "blue City -560 60 LIMA" & cr & "blue City -350 -190 OSLO" & cr \
         & "blue City -300 230 BERN" & cr & "blue City -200 -130 RIGA" & cr \
         & "red Silo 520 130" & cr & "red Silo 450 -150" & cr & "red Silo 320 60" & cr \
         & "red Silo 260 -200" & cr & "red Silo 560 -20" & cr & "red Command 410 10" & cr \
         & "red City 540 -230 ROME" & cr & "red City 370 200 BAKU" & cr \
         & "red City 230 0 LYON" & cr & "red City 470 -80 NICE" & cr & "red City 330 -110 YORK"
end Thrm.Layout

on Thrm.BuildWorld
   local tLine, n, tId, tSpot
   -- above the map, looking down at it like a big board
   Thrm.BoardCamera
   put empty into sBase
   put empty into sBaseIds
   put 0 into sAlertCount
   put 0 into n
   repeat for each line tLine in Thrm.Layout()
      if word 1 of tLine is empty then next repeat
      add 1 to n
      put "b" & n into tId
      put word 1 of tLine into sBase[tId]["team"]
      put word 2 of tLine into sBase[tId]["kind"]
      put word 3 of tLine into sBase[tId]["x"]
      put word 4 of tLine into sBase[tId]["z"]
      put word 5 of tLine into sBase[tId]["name"]
      put "ok" into sBase[tId]["state"]
      put tId & cr after sBaseIds
      Thrm.SpawnBase tId
   end repeat
   -- the green resource all life needs, in between
   repeat for each item tSpot in "-120 -120,0 -170,110 -90,-80 60,60 120,-10 200,150 30"
      put Entity.Spawn("Thrm.Life", word 1 of tSpot, Thrm.Sag(word 1 of tSpot, word 2 of tSpot), word 2 of tSpot, kLife) & cr after sWorld["life"]
   end repeat
   Thrm.LabelSites
end Thrm.BuildWorld

-- one base, drawn in its team's colour (a woken silo of ours is lit); a gone one is not drawn
on Thrm.SpawnBase pId
   local tColor
   if sBase[pId]["key"] is not empty then Entity.Kill sBase[pId]["key"]
   put empty into sBase[pId]["key"]
   if sBase[pId]["state"] is "gone" then exit Thrm.SpawnBase
   if sBase[pId]["team"] is "blue" then
      put kBlue into tColor
      if sBase[pId]["state"] is "awake" then
         put kArmed into tColor
      end if
   else
      put kEnemy into tColor
   end if
   put Entity.Spawn("Thrm." & sBase[pId]["kind"], sBase[pId]["x"], Thrm.Sag(sBase[pId]["x"], sBase[pId]["z"]), sBase[pId]["z"], tColor) into sBase[pId]["key"]
end Thrm.SpawnBase

-- city names under their circles: bold, letters spread by half a character (the owner:
-- "the text of cities is hard to read"); a city that is gone keeps its name, gone dark
on Thrm.LabelSites
   local tId, tXY, tColor, x, w
   repeat for each line tId in sBaseIds
      if sBase[tId]["name"] is empty then next repeat
      put Thrm.Screen(sBase[tId]["x"], Thrm.Sag(sBase[tId]["x"], sBase[tId]["z"]), sBase[tId]["z"]) into tXY
      if tXY is empty then next repeat
      if sBase[tId]["state"] is "gone" then
         put kGone into tColor
      else if sBase[tId]["team"] is "blue" then
         put kBlueLabel into tColor
      else
         put kEnemy into tColor
      end if
      put the number of chars of sBase[tId]["name"] * 15 into w      -- size 10, wide: 1.5 sizes a letter
      put round(word 1 of tXY - w / 2) into x
      put max(gViewLeft + 4, min(x, gViewRight - 4 - w)) into x
      dispatch "Term.Set" to group "Sequencer" with "lbl." & tId, sBase[tId]["name"], x, round(word 2 of tXY + 9), 10, tColor, "bold wide"
   end repeat
end Thrm.LabelSites

-- how far the globe falls away under a map point (positive = down): the map is the top of
-- a big sphere, so the grid lines arc like a globe's (the owner: "make it look global")
function Thrm.Sag pX, pZ
   local d2
   put pX * pX + pZ * pZ into d2
   if d2 >= kGlobeR * kGlobeR then return kSag * kGlobeR
   return kSag * (kGlobeR - sqrt(kGlobeR * kGlobeR - d2))
end Thrm.Sag

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
   put Entity.Spawn("Thrm.Globe", 0, 0, 0, tColor) into sWorld["grid"]
   put tColor into sWorld["gridColor"]
end Thrm.GridColor

on Thrm.ClearWorld
   local tKey, tId
   if sWorld["grid"] is not empty then Entity.Kill sWorld["grid"]
   repeat for each line tId in sBaseIds
      if sBase[tId]["key"] is not empty then Entity.Kill sBase[tId]["key"]
      dispatch "Term.Remove" to group "Sequencer" with "lbl." & tId
      dispatch "Term.Remove" to group "Sequencer" with "tag." & tId
   end repeat
   repeat for each line tKey in sWorld["life"]
      Entity.Kill tKey
   end repeat
   repeat for each line tKey in sWorld["craters"]
      Entity.Kill tKey
   end repeat
   repeat for each key tKey in sMissiles
      dispatch "Term.Remove" to group "Sequencer" with "mlbl." & tKey
      Entity.Kill tKey
   end repeat
   repeat for each key tKey in sTrail
      dispatch "Term.Remove" to group "Sequencer" with "trail." & tKey
   end repeat
   if sSarge["key"] is not empty then Entity.Kill sSarge["key"]
   put empty into sSarge["key"]
   dispatch "Term.Remove" to group "Sequencer" with "codes"
   dispatch "Term.Remove" to group "Sequencer" with "strobe"
   put empty into sAlert
   put empty into sTags
   put empty into sStrobe
   put empty into sBase
   put empty into sBaseIds
   put empty into sFocus
   put empty into sPhase
   put empty into sStruck
   put empty into sCode
   put empty into sCodeDone
   put false into sWar
   put "time" into sClockMode
   put empty into sWorld
   put empty into sMissiles
   put empty into sTrail
end Thrm.ClearWorld

-- Cue: call=Thrm.Phase; name=recall|standdown|strike|incoming|order   what a typo does now
on Thrm.Phase pSet
   if pSet is an array then
      put pSet["name"] into sPhase
   else
      put pSet into sPhase
   end if
end Thrm.Phase

-- a random base of a team (kind: Silo, City, Command or empty = any; state: ok, alert,
-- awake or empty = any not gone)
function Thrm.PickBase pTeam, pKind, pState
   local tId, tList
   repeat for each line tId in sBaseIds
      if sBase[tId]["team"] is not pTeam or sBase[tId]["state"] is "gone" then next repeat
      if pKind is not empty and sBase[tId]["kind"] is not pKind then next repeat
      if pState is not empty and sBase[tId]["state"] is not pState then next repeat
      put tId & cr after tList
   end repeat
   if tList is empty then return empty
   return line random(the number of lines of tList) of tList
end Thrm.PickBase

-------------------------------------------------------------------- missiles

-- Cue: call=Thrm.Launch; n=10   both sides fire (team=blue|red fires one side only): the Intro
on Thrm.Launch pSet
   local n, k, tTeam
   if sWorld["grid"] is empty then exit Thrm.Launch
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

-- one missile from a random silo of a team to a random spot on the other side
on Thrm.Fire pTeam, pDelay
   local tFrom, tDir
   put Thrm.PickBase(pTeam, "Silo", empty) into tFrom
   if tFrom is empty then exit Thrm.Fire
   if pTeam is "blue" then
      put 1 into tDir
   else
      put -1 into tDir
   end if
   Thrm.FlyMissile pTeam, sBase[tFrom]["x"], sBase[tFrom]["z"], tDir * (180 + random(340)), random(440) - 220, pDelay, 2.5 + random(20) / 10
end Thrm.Fire

-- a missile (or a bomber: pMesh) in flight from one map point to another on the world
-- clock; pName shows beside it, pTarget is the base id it is meant for. Returns its key.
command Thrm.FlyMissile pTeam, pX0, pZ0, pX1, pZ1, pDelay, pSecs, pName, pTarget, pMesh
   local tKey, tColor
   if pTeam is "blue" then
      put kBlue into tColor
   else
      put kEnemy into tColor
   end if
   if pMesh is empty then put "Thrm.Missile" into pMesh
   put Entity.Spawn(pMesh, pX0, Thrm.Sag(pX0, pZ0), pZ0, tColor) into tKey
   put pTeam into sMissiles[tKey]["team"]
   put tColor into sMissiles[tKey]["color"]
   put pX0 into sMissiles[tKey]["x0"]
   put Thrm.Sag(pX0, pZ0) into sMissiles[tKey]["y0"]
   put pZ0 into sMissiles[tKey]["z0"]
   put pX1 into sMissiles[tKey]["x1"]
   put Thrm.Sag(pX1, pZ1) into sMissiles[tKey]["y1"]
   put pZ1 into sMissiles[tKey]["z1"]
   put sWorldT + pDelay into sMissiles[tKey]["t0"]
   put pSecs into sMissiles[tKey]["secs"]
   put 140 + random(120) into sMissiles[tKey]["arc"]
   put pName into sMissiles[tKey]["name"]
   put pTarget into sMissiles[tKey]["target"]
   put "missile" into sMissiles[tKey]["kind"]
   return tKey
end Thrm.FlyMissile

-- a short plain word nobody in the air has (the owner: three or four letter words for
-- now; jargon later). Ours are animals, theirs are things: no word starts another one.
function Thrm.WordName pTeam
   local tWords, tWord, tKey, tTaken, tFree
   if pTeam is "blue" then
      put kOurWords into tWords
   else
      put kTheirWords into tWords
   end if
   repeat for each item tWord in tWords
      put false into tTaken
      repeat for each key tKey in sMissiles
         if sMissiles[tKey]["name"] is tWord then put true into tTaken
      end repeat
      if not tTaken then put tWord & comma after tFree
   end repeat
   if tFree is empty then return any item of tWords & random(9)
   delete the last char of tFree
   return any item of tFree
end Thrm.WordName

-- Cue: call=Thrm.Raise   "NOW LOOK WHAT YOU DID!": a missile rises over every silo of ours
-- and waits on its pad, just above the base, its name beside it (OWL, ELK...)
on Thrm.Raise pSet
   local tId, tKey, x, y, z
   if sWorld["grid"] is empty then exit Thrm.Raise
   repeat for each line tId in sBaseIds
      if sBase[tId]["team"] is not "blue" or sBase[tId]["kind"] is not "Silo" or sBase[tId]["state"] is "gone" then next repeat
      put sBase[tId]["x"] into x
      put sBase[tId]["z"] into z
      put Thrm.Sag(x, z) - kPadLift into y
      put Entity.Spawn("Thrm.Missile", x, y, z, kArmed) into tKey
      put "blue" into sMissiles[tKey]["team"]
      put kBlue into sMissiles[tKey]["color"]
      put "pad" into sMissiles[tKey]["kind"]
      put x into sMissiles[tKey]["x"]
      put y into sMissiles[tKey]["y"]
      put z into sMissiles[tKey]["z"]
      put tId into sMissiles[tKey]["from"]
      put Thrm.WordName("blue") into sMissiles[tKey]["name"]
      FX.Sparks x, y, z, 12, kArmed
      Thrm.MissileLabel tKey, x, y, z
   end repeat
end Thrm.Raise

-- the names the Assets clip can take: "pad" = ours waiting on the pads, "red" = theirs in the air
function Thrm.Assets pWhich
   local tKey, tOut
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["name"] is empty then next repeat
      if pWhich is "pad" and sMissiles[tKey]["kind"] is not "pad" then next repeat
      if pWhich is "red" and (sMissiles[tKey]["team"] is not "red" or sMissiles[tKey]["kind"] is "pad") then next repeat
      put sMissiles[tKey]["name"] & comma after tOut
   end repeat
   delete the last char of tOut
   return tOut
end Thrm.Assets

-- missiles still flying (team blue, red or empty = any); the pads do not count
function Thrm.InAir pTeam
   local tKey, n
   put 0 into n
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["kind"] is "pad" then next repeat
      if pTeam is not empty and pTeam is not "all" and sMissiles[tKey]["team"] is not pTeam then next repeat
      add 1 to n
   end repeat
   return n
end Thrm.InAir

function Thrm.KeyByName pName, pKind
   local tKey
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["name"] is not pName then next repeat
      if pKind is "pad" and sMissiles[tKey]["kind"] is not "pad" then next repeat
      if pKind is "red" and (sMissiles[tKey]["team"] is not "red" or sMissiles[tKey]["kind"] is "pad") then next repeat
      return tKey
   end repeat
   return empty
end Thrm.KeyByName

-- a pad missile's name typed whole: it sinks back into its silo
on Thrm.Recall pName
   local tKey
   put Thrm.KeyByName(pName, "pad") into tKey
   if tKey is empty then return empty
   FX.Sparks sMissiles[tKey]["x"], sMissiles[tKey]["y"], sMissiles[tKey]["z"], 10, kBlue
   Thrm.EndMissile tKey
   Thrm.Say pName && "RECALLED."
   return "recalled"
end Thrm.Recall

-- an enemy missile's name typed whole: it bursts in the air
on Thrm.Destroy pName
   local tKey
   put Thrm.KeyByName(pName, "red") into tKey
   if tKey is empty then return empty
   FX.Sparks sMissiles[tKey]["x"], sMissiles[tKey]["y"], sMissiles[tKey]["z"], 50, "#FFFFFF"
   FX.Sparks sMissiles[tKey]["x"], sMissiles[tKey]["y"], sMissiles[tKey]["z"], 20, kEnemy
   Thrm.EndMissile tKey
   Thrm.Say pName && "DESTROYED."
   return "destroyed"
end Thrm.Destroy

-- Tab: the next enemy missile in the air gets the focus: its name bolder, brighter, spread
-- out, easy to read. The trap: Tab moves the doom clock too (twice, see tabKey).
on Thrm.Focus
   local tKeys, tKey, n
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["team"] is "red" and sMissiles[tKey]["name"] is not empty and sMissiles[tKey]["kind"] is not "pad" then put tKey & cr after tKeys
   end repeat
   if tKeys is empty then
      put empty into sFocus
      return empty
   end if
   sort lines of tKeys
   set the wholeMatches to true
   put lineOffset(sFocus, tKeys) into n
   if sFocus is empty or n is 0 or n >= the number of lines of tKeys then
      put line 1 of tKeys into sFocus
   else
      put line n + 1 of tKeys into sFocus
   end if
   return sMissiles[sFocus]["name"]
end Thrm.Focus

-- Cue: call=Thrm.Bombers   the bombers took off with the missiles: two small triangles
-- crawl right from our command post, one step a key, toward the first detonation
on Thrm.Bombers pSet
   local tFrom, x0, z0, k, tTarget, tKey
   if sWorld["grid"] is empty then exit Thrm.Bombers
   put Thrm.PickBase("blue", "Command", empty) into tFrom
   if tFrom is empty then
      put -420 into x0
      put 20 into z0
   else
      put sBase[tFrom]["x"] into x0
      put sBase[tFrom]["z"] into z0
   end if
   repeat with k = 1 to 2
      put Thrm.PickBase("red", "City", empty) into tTarget
      if tTarget is empty then exit repeat
      Thrm.FlyMissile "blue", x0, z0 + (k * 2 - 3) * 30, sBase[tTarget]["x"], sBase[tTarget]["z"], 0, kBomberKeys * kKeyStep, empty, tTarget, "Thrm.Bomber"
      put the result into tKey
      put "bomber" into sMissiles[tKey]["kind"]
      put 30 into sMissiles[tKey]["arc"]
      put kArmed into sMissiles[tKey]["color"]
   end repeat
end Thrm.Bombers

-- RECALL THE BOMBERS! typed: they turn round and fly home (and vanish there, quietly)
on Thrm.BombersHome
   local tKey
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["kind"] is not "bomber" then next repeat
      if sMissiles[tKey]["x"] is not a number then
         put sMissiles[tKey]["x0"] into sMissiles[tKey]["x"]
         put sMissiles[tKey]["z0"] into sMissiles[tKey]["z"]
      end if
      put sMissiles[tKey]["x0"] into sMissiles[tKey]["x1"]
      put sMissiles[tKey]["z0"] into sMissiles[tKey]["z1"]
      put sMissiles[tKey]["y0"] into sMissiles[tKey]["y1"]
      put sMissiles[tKey]["x"] into sMissiles[tKey]["x0"]
      put sMissiles[tKey]["z"] into sMissiles[tKey]["z0"]
      put Thrm.Sag(sMissiles[tKey]["x"], sMissiles[tKey]["z"]) into sMissiles[tKey]["y0"]
      put sWorldT into sMissiles[tKey]["t0"]
      put 3 into sMissiles[tKey]["secs"]
      put 20 into sMissiles[tKey]["arc"]
      put "home" into sMissiles[tKey]["kind"]
   end repeat
   Thrm.Say "BOMBERS TURNING FOR HOME."
end Thrm.BombersHome

-- the war starts (the launch codes are complete, or a bomber got through): the Strike sequence
on Thrm.StartWar pCause
   if sWar then exit Thrm.StartWar
   put true into sWar
   put "strike" into sPhase
   dispatch "Seq.SetVar" to group "Sequencer" with "cause", pCause
   dispatch "Seq.Jump" to group "Sequencer" with "Strike"
end Thrm.StartWar

-- Cue: call=Thrm.SargeTurn   he turns round to the Big Board and reads the launch codes
on Thrm.SargeTurn
   if sSarge["key"] is not empty then Entity.SetRotation sSarge["key"], 0, 0, 0
end Thrm.SargeTurn

-- an enemy city (or silo, or spot) for one of our missiles: "x z id"
function Thrm.StrikeTarget
   local tId
   put Thrm.PickBase("red", "City", empty) into tId
   if tId is empty then put Thrm.PickBase("red", empty, empty) into tId
   if tId is empty then return 200 + random(320) && random(440) - 220
   return sBase[tId]["x"] && sBase[tId]["z"] && tId
end Thrm.StrikeTarget

-- one of ours for an enemy missile, RIGHT TO LEFT: our cities and silos first
function Thrm.EnemyTarget
   local tId
   put Thrm.PickBase("blue", empty, empty) into tId
   if tId is empty then return -200 - random(320) && random(440) - 220
   return sBase[tId]["x"] && sBase[tId]["z"] && tId
end Thrm.EnemyTarget

-- Cue: call=Thrm.Strike   "and the missiles go flying": every missile still on a pad, every
-- silo the stand-down typos woke (and, if that is nobody, the reserve at the command post)
on Thrm.Strike pSet
   local tKey, n, tId, tT, x0, z0
   put 0 into n
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["kind"] is not "pad" then next repeat
      put Thrm.StrikeTarget() into tT
      dispatch "Term.Remove" to group "Sequencer" with "mlbl." & tKey
      put sMissiles[tKey]["x"] into sMissiles[tKey]["x0"]
      put sMissiles[tKey]["y"] into sMissiles[tKey]["y0"]
      put sMissiles[tKey]["z"] into sMissiles[tKey]["z0"]
      put word 1 of tT into sMissiles[tKey]["x1"]
      put word 2 of tT into sMissiles[tKey]["z1"]
      put Thrm.Sag(word 1 of tT, word 2 of tT) into sMissiles[tKey]["y1"]
      put word 3 of tT into sMissiles[tKey]["target"]
      put sWorldT + n * 0.3 into sMissiles[tKey]["t0"]
      put kStrikeSecs + random(20) / 10 into sMissiles[tKey]["secs"]
      put 160 + random(80) into sMissiles[tKey]["arc"]
      put empty into sMissiles[tKey]["name"]
      put "missile" into sMissiles[tKey]["kind"]
      add 1 to n
   end repeat
   repeat for each line tId in sBaseIds
      if sBase[tId]["team"] is "blue" and sBase[tId]["kind"] is "Silo" and sBase[tId]["state"] is "awake" then
         put Thrm.StrikeTarget() into tT
         Thrm.FlyMissile "blue", sBase[tId]["x"], sBase[tId]["z"], word 1 of tT, word 2 of tT, n * 0.3, kStrikeSecs + random(20) / 10, empty, word 3 of tT
         add 1 to n
      end if
   end repeat
   if n is 0 then
      put Thrm.PickBase("blue", "Command", empty) into tId
      put -420 into x0
      put 20 into z0
      if tId is not empty then
         put sBase[tId]["x"] into x0
         put sBase[tId]["z"] into z0
      end if
      repeat 2 times
         put Thrm.StrikeTarget() into tT
         Thrm.FlyMissile "blue", x0, z0, word 1 of tT, word 2 of tT, n * 0.3, kStrikeSecs + random(20) / 10, empty, word 3 of tT
         add 1 to n
      end repeat
   end if
end Thrm.Strike

-- Cue: call=Thrm.Counter   AFTER our strike lands, the enemy answers, RIGHT TO LEFT. Every
-- typo of the first round made one more of their missiles ready (silos that were alerted
-- fire even if struck: they saw it coming). No typos: three, from silos nowhere near the
-- craters (a silo struck while asleep is gone: that is their one-round disadvantage).
on Thrm.Counter pSet
   local tN, tSources, tId, tFar, k, tFrom, tT
   put max(kCounterMin, min(kCounterMax, sAlertCount)) into tN
   repeat for each line tId in sBaseIds
      if sBase[tId]["team"] is "red" and sBase[tId]["kind"] is "Silo" and sBase[tId]["alerted"] is true then put tId & cr after tSources
   end repeat
   if the number of lines of tSources < kCounterMin then
      put Thrm.FarSilos() into tFar
      repeat for each line tId in tFar
         if the number of lines of tSources >= kCounterMin then exit repeat
         if tId is not among the lines of tSources then put tId & cr after tSources
      end repeat
   end if
   repeat with k = 1 to tN
      if tSources is empty then
         -- nothing left on land: submarines at the far edge
         put item (k mod 3) + 1 of "600 -230,620 0,600 230" into tFrom
      else
         put line ((k - 1) mod the number of lines of tSources) + 1 of tSources into tId
         put sBase[tId]["x"] && sBase[tId]["z"] into tFrom
      end if
      put Thrm.EnemyTarget() into tT
      Thrm.FlyMissile "red", word 1 of tFrom, word 2 of tFrom, word 1 of tT, word 2 of tT, (k - 1) * 0.4, kIncomingSecs + random(30) / 10, Thrm.WordName("red"), word 3 of tT
   end repeat
end Thrm.Counter

-- their live silos that were not alerted, the farthest from any crater first
function Thrm.FarSilos
   local tId, tOut, d, tMin, tLine
   repeat for each line tId in sBaseIds
      if sBase[tId]["team"] is not "red" or sBase[tId]["kind"] is not "Silo" or sBase[tId]["state"] is "gone" then next repeat
      put 100000 into tMin
      repeat for each line tLine in sStruck
         put sqrt((sBase[tId]["x"] - word 1 of tLine) ^ 2 + (sBase[tId]["z"] - word 2 of tLine) ^ 2) into d
         put min(tMin, d) into tMin
      end repeat
      put round(tMin) && tId & cr after tOut
   end repeat
   sort lines of tOut descending numeric by word 1 of each
   put empty into tLine
   repeat for each line tId in tOut
      put word 2 of tId & cr after tLine
   end repeat
   return tLine
end Thrm.FarSilos

-- TYPE LAUNCH, THAT IS A DIRECT ORDER: each key the keyboard spoils on purpose is one more
-- enemy round in the air (two missiles)
on Thrm.EnemyRound
   local tId, k, tT, tFrom
   repeat with k = 1 to 2
      put Thrm.PickBase("red", "Silo", empty) into tId
      if tId is empty then
         put item k of "600 -230,620 230" into tFrom
      else
         put sBase[tId]["x"] && sBase[tId]["z"] into tFrom
      end if
      put Thrm.EnemyTarget() into tT
      Thrm.FlyMissile "red", word 1 of tFrom, word 2 of tFrom, word 1 of tT, word 2 of tT, (k - 1) * 0.4, kIncomingSecs + random(30) / 10, Thrm.WordName("red"), word 3 of tT
   end repeat
   Thrm.Say "THE KEYBOARD SLIPPED. TWO MORE INCOMING."
end Thrm.EnemyRound

-- LAUNCH typed at last: your one missile goes
on Thrm.LaunchOne
   local tId, tT, x0, z0
   put Thrm.PickBase("blue", "Silo", empty) into tId
   if tId is empty then put Thrm.PickBase("blue", empty, empty) into tId
   put -420 into x0
   put 20 into z0
   if tId is not empty then
      put sBase[tId]["x"] into x0
      put sBase[tId]["z"] into z0
   end if
   put Thrm.StrikeTarget() into tT
   Thrm.FlyMissile "blue", x0, z0, word 1 of tT, word 2 of tT, 0, kStrikeSecs, empty, word 3 of tT
   Thrm.Say "YOUR MISSILE IS AWAY."
end Thrm.LaunchOne

-- take a missile out of the air: its label goes, its trail fades out later
on Thrm.EndMissile pKey
   put sWorldT + kTrailKeep into sTrail[pKey]["until"]
   dispatch "Term.Remove" to group "Sequencer" with "mlbl." & pKey
   Entity.Kill pKey
   delete variable sMissiles[pKey]
   if pKey is sFocus then put empty into sFocus
end Thrm.EndMissile

-- the machine's cold remarks, on the console
on Thrm.Say pText
   dispatch function "Term.Print" to group "Sequencer" with pText, kGuilt
end Thrm.Say

-- a missile comes down: a big blast, and everything near it goes black (gone: no mesh, its
-- name dark), a dim crater ring marks the place. A bomber that gets through starts the war.
on Thrm.Land pKey
   local x, y, z, tId, d, tKind
   put sMissiles[pKey]["kind"] into tKind
   if tKind is "home" then
      Thrm.EndMissile pKey
      exit Thrm.Land
   end if
   put sMissiles[pKey]["x1"] into x
   put sMissiles[pKey]["z1"] into z
   put Thrm.Sag(x, z) into y
   FX.Sparks x, y, z, 80, sMissiles[pKey]["color"]
   FX.Sparks x, y - 20, z, 40, "#FFFFFF"
   Thrm.TrailPoint pKey, x, y, z, sMissiles[pKey]["color"]
   put x && z & cr after sStruck
   put Entity.Spawn("Thrm.Crater", x, y, z, kCrater) & cr after sWorld["craters"]
   repeat for each line tId in sBaseIds
      if sBase[tId]["state"] is "gone" then next repeat
      put sqrt((sBase[tId]["x"] - x) ^ 2 + (sBase[tId]["z"] - z) ^ 2) into d
      if d <= kBlackR then Thrm.Gone tId
   end repeat
   Thrm.EndMissile pKey
   if tKind is "bomber" and sPhase is among the items of "recall,standdown" then
      Thrm.Say "FIRST DETONATION."
      Thrm.StartWar "bombers"
   end if
end Thrm.Land

-- a base is gone: black (no mesh), its tag off, its name dark
on Thrm.Gone pId
   put "gone" into sBase[pId]["state"]
   if sBase[pId]["key"] is not empty then Entity.Kill sBase[pId]["key"]
   put empty into sBase[pId]["key"]
   dispatch "Term.Remove" to group "Sequencer" with "tag." & pId
   delete variable sTags[pId]
   if sBase[pId]["name"] is not empty then
      dispatch "Term.Color" to group "Sequencer" with "lbl." & pId, kGone
      if sPhase is not empty then Thrm.Say sBase[pId]["name"] && "IS GONE. THERE WERE PEOPLE THERE."
   end if
end Thrm.Gone

-- above the map, looking down at it like a big board
on Thrm.BoardCamera
   Camera.SetPosition -kCamX, -kCamY, -kCamZ
   Camera.SetLook 0, -atan2(kCamY, kCamZ + kLookZ)
end Thrm.BoardCamera

-------------------------------------------------------------------- the Sarge

-- Cue: call=Thrm.Sarge; show=yes|no; x=0; z=-150   the wide shot: a giant stick figure on
-- the map in the TRON fists-on-hips pose (Amazing Couple's PROMPT idle, from LIB_MOCAP)
on Thrm.Sarge pSet
   local x, z
   if pSet["show"] is "no" then
      if sSarge["key"] is not empty then Entity.Kill sSarge["key"]
      put empty into sSarge["key"]
      exit Thrm.Sarge
   end if
   if sSarge["loaded"] is not true then Thrm.LoadSarge
   if sSarge["frames"] is not a number or sSarge["frames"] < 1 then exit Thrm.Sarge
   put pSet["x"] into x
   if x is not a number then put 0 into x
   put pSet["z"] into z
   if z is not a number then put -150 into z
   if sSarge["key"] is empty then put Entity.Spawn("Thrm.Sarge.1", x, Thrm.Sag(x, z), z, kSargeColor) into sSarge["key"]
   Entity.SetPosition sSarge["key"], x, Thrm.Sag(x, z), z
   Entity.SetRotation sSarge["key"], 0, pi, 0       -- facing the camera
   put 1 into sSarge["frame"]
end Thrm.Sarge

-- the stick clip -> one engine mesh per frame (as Couple.LoadClip does)
on Thrm.LoadSarge
   local tFile, tText, tLine, tJoints, tEdges, tFrame, tV, tM, i, tE, tA, tB
   put true into sSarge["loaded"]
   put 0 into sSarge["frames"]
   put Game.FindFile("LIB_MOCAP/library/" & kSargeClip & "/" & kSargeClip & "_stick.txt") into tFile
   if tFile is empty then exit Thrm.LoadSarge
   put URL ("file:" & tFile) into tText
   replace numToChar(13) with empty in tText
   put 30 into sSarge["fps"]
   put 0 into tFrame
   repeat for each line tLine in tText
      if tLine is empty or char 1 of tLine is "#" then next repeat
      set the itemDel to comma
      switch item 1 of tLine
         case "fps"
            put item 2 of tLine into sSarge["fps"]
            break
         case "joints"
            put item 2 of tLine into tJoints
            break
         case "edges"
            put item 2 of tLine into tEdges
            break
         default
            if (char 1 of tLine is "-" or char 1 of tLine is a number) and tFrame < kSargeFrames then
               add 1 to tFrame
               put tLine into tV
               split tV by comma
               put Mesh.New() into tM
               repeat with i = 0 to tJoints - 1
                  Mesh.AddVertex tM, tV[3 * i + 1] * kSargeM, -tV[3 * i + 2] * kSargeM, tV[3 * i + 3] * kSargeM
               end repeat
               repeat for each word tE in tEdges
                  set the itemDel to "-"
                  put item 1 of tE + 1 into tA
                  put item 2 of tE + 1 into tB
                  set the itemDel to comma
                  Mesh.AddLine tM, tA, tB
               end repeat
               Mesh.Define "Thrm.Sarge." & tFrame, tM
            end if
      end switch
   end repeat
   put tFrame into sSarge["frames"]
end Thrm.LoadSarge

on Thrm.SargeStep
   local n
   if sSarge["key"] is empty then exit Thrm.SargeStep
   add sSarge["fps"] * sStepMS / 1000 to sSarge["frame"]
   if sSarge["frame"] >= sSarge["frames"] + 1 then put 1 into sSarge["frame"]
   put trunc(sSarge["frame"]) into n
   Thrm.SetMesh sSarge["key"], "Thrm.Sarge." & n
end Thrm.SargeStep

-- swap the mesh an object is drawn with (as Antack.SetMesh)
on Thrm.SetMesh pKey, pMesh
   local tRadius
   if Entity.Get(pKey, "mesh") is pMesh then exit Thrm.SetMesh
   -- Entity.SetMesh takes the new mesh's radius; this game keeps the old one
   put Entity.Get(pKey, "radius") into tRadius
   Entity.SetMesh pKey, pMesh
   if tRadius is a number then Entity.Set pKey, "radius", tRadius
end Thrm.SetMesh

-- Cue: call=Thrm.CloseUp; dur=2.5 (or called with a number of seconds): cut to the Sarge's
-- angry grid face (the LIB_MCP face style: raised vector blocks on a dim grid panel),
-- mouth flapping while he shouts. The map's overlays hide; the camera comes back after.
on Thrm.CloseUp pSet
   local tDur
   if pSet is an array then
      put pSet["dur"] into tDur
   else
      put pSet into tDur
   end if
   if tDur is not a number then put 2 into tDur
   if not Thrm.MakeFaces() then exit Thrm.CloseUp
   if sClose["until"] is empty then
      put Entity.Spawn("Thrm.FacePanel", kStudioX, 0, kFaceDist, "30,95,105") into sClose["panel"]
      put Entity.Spawn("Thrm.Face1", kStudioX, 0, kFaceDist, kSargeColor) into sClose["face"]
      Camera.SetPosition kStudioX, 0, 0
      Camera.SetLook 0, 0
      dispatch "Term.Hide" to group "Sequencer" with kOverlays
   end if
   put max(sClose["until"], Thrm.Now() + tDur) into sClose["until"]
end Thrm.CloseUp

on Thrm.CloseUpStep
   if sClose["until"] is empty then exit Thrm.CloseUpStep
   if Thrm.Now() >= sClose["until"] then
      Entity.Kill sClose["panel"]
      Entity.Kill sClose["face"]
      put empty into sClose
      dispatch "Term.Hide" to group "Sequencer" with empty
      if sWorld["grid"] is not empty then
         Thrm.BoardCamera
      else
         Camera.Reset
      end if
      exit Thrm.CloseUpStep
   end if
   -- he shouts: the mouth flaps, the head shakes
   if sTicks mod 4 is 0 then
      add 1 to sClose["n"]
      Thrm.SetMesh sClose["face"], "Thrm.Face" & (sClose["n"] mod 2 + 1)
      Entity.SetRotation sClose["face"], 0, (random(9) - 5) / 100, (random(5) - 3) / 100
      Entity.SetRotation sClose["panel"], 0, 0, 0
   end if
end Thrm.CloseUpStep

-- the two shouting faces and the panel, from Data/Faces (48 x 26 one-bit grids, as
-- LIB_MCP's claude_face_bits.txt) through LIB_MAP's Map.BlockEdges
function Thrm.MakeFaces
   global gMeshCache
   local tLib, tA, tB, tBlank
   if gMeshCache["Thrm.Face1"]["count"] is not empty then return true
   put Game.FindFile("LIB_MAP/livecode/lib_map.livecodescript") into tLib
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/Thrmnlra/Data/Faces/sarge_shout1.txt") into tA
   put Game.FindFile("LIB_GAMES/Vibecode3D_Games/Thrmnlra/Data/Faces/sarge_shout2.txt") into tB
   if tLib is empty or tA is empty or tB is empty then return false
   start using stack tLib
   put URL ("file:" & tA) into tA
   put URL ("file:" & tB) into tB
   replace numToChar(13) with empty in tA
   replace numToChar(13) with empty in tB
   put tA into tBlank
   replace "1" with "0" in tBlank
   Mesh.Define "Thrm.Face1", Thrm.FaceMesh(Map.BlockEdges(tA, kFaceCell, kFaceHeight, false))
   Mesh.Define "Thrm.Face2", Thrm.FaceMesh(Map.BlockEdges(tB, kFaceCell, kFaceHeight, false))
   Mesh.Define "Thrm.FacePanel", Thrm.FaceMesh(Map.BlockEdges(tBlank, kFaceCell, kFaceHeight, true))
   return true
end Thrm.MakeFaces

-- LIB_MAP segments (x,y up,z out of the panel) -> wire mesh facing the camera (as Face.SegmentsToMesh)
function Thrm.FaceMesh pSegments
   local tMesh, tSeg, tIndex, tA, tB
   put Mesh.New() into tMesh
   set the itemDel to comma
   repeat for each line tSeg in pSegments
      if the number of items of tSeg < 6 then next repeat
      put Thrm.FaceVertex(tMesh, tIndex, item 1 of tSeg, item 2 of tSeg, item 3 of tSeg) into tA
      put Thrm.FaceVertex(tMesh, tIndex, item 4 of tSeg, item 5 of tSeg, item 6 of tSeg) into tB
      Mesh.AddLine tMesh, tA, tB
   end repeat
   return tMesh
end Thrm.FaceMesh

function Thrm.FaceVertex @pMesh, @pIndex, pX, pY, pZ
   local tKey
   put pX & "," & pY & "," & pZ into tKey
   if pIndex[tKey] is empty then
      Mesh.AddVertex pMesh, pX, -pY, -pZ
      put the result into pIndex[tKey]
   end if
   return pIndex[tKey]
end Thrm.FaceVertex

-- world point -> card pixels "x y" for the big-board camera (empty if behind it)
function Thrm.Screen pX, pY, pZ
   local tP
   put Mat3.Apply(Mat3.Camera(), pX + kCamX, pY + kCamY, pZ + kCamZ) into tP
   return ProjectVertex(word 1 of tP, word 2 of tP, word 3 of tP)
end Thrm.Screen

-- arcs over the globe, a dotted trail behind each, a big blast where they land
on Thrm.MoveMissiles
   local tKey, u, x, y, z, tNow, tLanded
   if sMissiles is not an array then exit Thrm.MoveMissiles
   put sWorldT into tNow
   repeat for each key tKey in sMissiles
      if sMissiles[tKey]["kind"] is "pad" then next repeat
      put (tNow - sMissiles[tKey]["t0"]) / sMissiles[tKey]["secs"] into u
      if u < 0 then next repeat
      if u >= 1 then
         put tKey & cr after tLanded
         next repeat
      end if
      put sMissiles[tKey]["x0"] + (sMissiles[tKey]["x1"] - sMissiles[tKey]["x0"]) * u into x
      put sMissiles[tKey]["z0"] + (sMissiles[tKey]["z1"] - sMissiles[tKey]["z0"]) * u into z
      put sMissiles[tKey]["y0"] + (sMissiles[tKey]["y1"] - sMissiles[tKey]["y0"]) * u - sMissiles[tKey]["arc"] * 4 * u * (1 - u) into y
      Entity.SetPosition tKey, x, y, z
      put x into sMissiles[tKey]["x"]
      put y into sMissiles[tKey]["y"]
      put z into sMissiles[tKey]["z"]
      if sMissiles[tKey]["name"] is not empty then Thrm.MissileLabel tKey, x, y, z
      if sTicks mod 3 is 0 then Thrm.TrailPoint tKey, x, y, z, sMissiles[tKey]["color"]
   end repeat
   -- landings after the walk (a landing can end other missiles and start the war)
   repeat for each line tKey in tLanded
      if sMissiles[tKey] is an array then Thrm.Land tKey
   end repeat
   -- trails of landed missiles stay a moment, then go
   repeat for each key tKey in sTrail
      if sTrail[tKey]["until"] is a number and tNow > sTrail[tKey]["until"] then
         dispatch "Term.Remove" to group "Sequencer" with "trail." & tKey
         delete variable sTrail[tKey]
      end if
   end repeat
end Thrm.MoveMissiles

-- a missile's name rides beside it. Ours: bold and spread out. Theirs: small and dim, unless
-- Tab gave it the focus (bold, bright, spread out: easy to read, and it cost you time)
on Thrm.MissileLabel pKey, pX, pY, pZ
   local tXY, tSize, tColor, tStyle
   put Thrm.Screen(pX, pY, pZ) into tXY
   if tXY is empty then exit Thrm.MissileLabel
   if sMissiles[pKey]["team"] is "red" then
      if pKey is sFocus then
         put 11 into tSize
         put kFocus into tColor
         put "bold wide" into tStyle
      else
         put 9 into tSize
         put kEnemyDim into tColor
         put empty into tStyle
      end if
   else
      put 10 into tSize
      put kArmed into tColor
      put "bold wide" into tStyle
   end if
   dispatch "Term.Set" to group "Sequencer" with "mlbl." & pKey, sMissiles[pKey]["name"], \
         round(word 1 of tXY) + 8, round(word 2 of tXY) - 14, tSize, tColor, tStyle
end Thrm.MissileLabel

-- a missile's trail is a few screen points (the camera holds still) drawn as one dashed
-- line: a point every 3 steps is enough, the dashes make it read as a tracked arc
on Thrm.TrailPoint pKey, pX, pY, pZ, pColor
   local tXY
   put Thrm.Screen(pX, pY, pZ) into tXY
   if tXY is empty then exit Thrm.TrailPoint
   put round(word 1 of tXY) & comma & round(word 2 of tXY) & cr after sTrail[pKey]["pts"]
   dispatch "Term.Path" to group "Sequencer" with "trail." & pKey, sTrail[pKey]["pts"], pColor, kTrailDashes
end Thrm.TrailPoint

-------------------------------------------------------------------- typos and the Big Board

-- a wrong key (clips call it with their typo count and the key). What it does depends on
-- the phase (Cue Thrm.Phase):
--   recall     one more enemy silo ALERTED (they do not fire: but it is your fault now)
--   standdown  one of OUR silos on the left wakes up (ARMED)
--   both       the key fills one more letter of the launch codes on the Big Board
--   later      nothing more: the keys themselves move their missiles
--   none       (the Trainer) the old drill: the first typo alerts a site, the second launches
-- Returns alert / wake / launch / codes (the codes just filled up: the war starts) / empty.
on Thrm.Typo pCount, pKey
   if sWorld["grid"] is empty then return empty
   if sPhase is "recall" then
      get Thrm.AlertSilo()
      Thrm.CodeKey pKey
      if sCodeDone is true then return "codes"
      return "alert"
   end if
   if sPhase is "standdown" then
      Thrm.WakeSilo
      Thrm.CodeKey pKey
      if sCodeDone is true then return "codes"
      return "wake"
   end if
   if sPhase is empty then return Thrm.TrainerTypo()
   return empty
end Thrm.Typo

-- the Trainer's drill: first typo alerts an enemy silo, the next launches from it
function Thrm.TrainerTypo
   local tT
   if sAlert["id"] is empty or sBase[sAlert["id"]]["state"] is "gone" then
      put Thrm.AlertSilo() into sAlert["id"]
      if sAlert["id"] is empty then return empty
      return "alert"
   end if
   put Thrm.EnemyTarget() into tT
   Thrm.FlyMissile "red", sBase[sAlert["id"]]["x"], sBase[sAlert["id"]]["z"], word 1 of tT, word 2 of tT, 0, 3 + random(10) / 10
   Thrm.Tag sAlert["id"], "LAUNCH", kRed
   put empty into sAlert["id"]
   return "launch"
end Thrm.TrainerTypo

-- one more enemy silo hears you (ALERT blinks over it). Returns its id.
function Thrm.AlertSilo
   local tId
   add 1 to sAlertCount
   put Thrm.PickBase("red", "Silo", "ok") into tId
   if tId is empty then put Thrm.PickBase("red", "Silo", empty) into tId
   if tId is empty then return empty
   put "alert" into sBase[tId]["state"]
   put true into sBase[tId]["alerted"]
   FX.Sparks sBase[tId]["x"], Thrm.Sag(sBase[tId]["x"], sBase[tId]["z"]) - 10, sBase[tId]["z"], 20, "#FFFFFF"
   Thrm.Tag tId, "ALERT", kRed
   if sMood is "calm" then Thrm.World "alert"
   return tId
end Thrm.AlertSilo

-- one of OUR silos wakes up (STAND DOWN THE COMMAND, mistyped): it lights up, ARMED
on Thrm.WakeSilo
   local tId
   put Thrm.PickBase("blue", "Silo", "ok") into tId
   if tId is empty then exit Thrm.WakeSilo
   put "awake" into sBase[tId]["state"]
   Thrm.SpawnBase tId
   FX.Sparks sBase[tId]["x"], Thrm.Sag(sBase[tId]["x"], sBase[tId]["z"]) - 10, sBase[tId]["z"], 16, kArmed
   Thrm.Tag tId, "ARMED", kArmed
end Thrm.WakeSilo

-- a little blinking word over a base (ALERT, ARMED, LAUNCH)
on Thrm.Tag pId, pText, pColor
   local tXY
   put Thrm.Screen(sBase[pId]["x"], Thrm.Sag(sBase[pId]["x"], sBase[pId]["z"]) - 30, sBase[pId]["z"]) into tXY
   if tXY is empty then exit Thrm.Tag
   put pColor into sTags[pId]
   dispatch "Term.Set" to group "Sequencer" with "tag." & pId, pText, round(word 1 of tXY) - the number of chars of pText * 5, round(word 2 of tXY) - 16, 10, pColor, "bold"
end Thrm.Tag

on Thrm.TagStep
   local tId
   if sTags is not an array or sTicks mod 4 is not 0 then exit Thrm.TagStep
   repeat for each key tId in sTags
      if sTicks mod 8 is 0 then
         dispatch "Term.Color" to group "Sequencer" with "tag." & tId, kTagDim
      else
         dispatch "Term.Color" to group "Sequencer" with "tag." & tId, sTags[tId]
      end if
   end repeat
end Thrm.TagStep

-- Cue: call=Thrm.Codes   "ENTER LAUNCH CODES: _ _ _ _ _ _ _ _" on the Big Board, upper
-- middle, barely visible. The player is looking at the terminal, not at it.
on Thrm.Codes pSet
   put empty into sCode
   put false into sCodeDone
   Thrm.ShowCodes
end Thrm.Codes

-- every mistyped key, whatever it was, fills in one more letter of the code, by diabolical
-- design, and the line gets a little brighter
on Thrm.CodeKey pKey
   local tCh
   if sCodeDone is not false then exit Thrm.CodeKey
   put toUpper(pKey) into tCh
   if the number of chars of tCh is not 1 or tCh is not in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" then put "*" into tCh
   put tCh after sCode
   Thrm.ShowCodes
   if the number of chars of sCode >= kCodeLen then
      put true into sCodeDone
      Thrm.StartWar "codes"
   end if
end Thrm.CodeKey

on Thrm.ShowCodes
   local tText, k, f, tColor, x
   put "ENTER LAUNCH CODES:" into tText
   repeat with k = 1 to kCodeLen
      if k <= the number of chars of sCode then
         put space & char k of sCode after tText
      else
         put " _" after tText
      end if
   end repeat
   put kCodeDim + (1 - kCodeDim) * min(1, the number of chars of sCode / kCodeLen) into f
   put round(255 * f) & comma & round(48 * f) & comma & round(48 * f) into tColor
   put round((gViewLeft + gViewRight - the number of chars of tText * 12) / 2) into x
   dispatch "Term.Set" to group "Sequencer" with "codes", tText, x, round(gViewTop + (gViewBottom - gViewTop) * 0.07), 12, tColor
end Thrm.ShowCodes

function Thrm.Code
   return sCode
end Thrm.Code

-- for tests and debugging: phase, alerts (first-round typos), awake (our woken silos),
-- gone (bases), war, focus (name), sarge (its rotation), clock
function Thrm.State pKey
   local tId, n
   switch pKey
      case "phase"
         return sPhase
      case "alerts"
         return sAlertCount
      case "war"
         return sWar
      case "focus"
         if sFocus is empty then return empty
         return sMissiles[sFocus]["name"]
      case "sarge"
         if sSarge["key"] is empty then return empty
         return Entity.GetRotation(sSarge["key"])
      case "clock"
         return sClockMode
      case "awake"
      case "gone"
         put 0 into n
         repeat for each line tId in sBaseIds
            if sBase[tId]["state"] is pKey then add 1 to n
         end repeat
         return n
   end switch
   return empty
end Thrm.State

-- Cue: call=Thrm.Strobe; text=TYPE THE NAME OF THE ASSET TO RECALL   strobes three times,
-- yellow, orange, RED, then stays red under the console. text= (empty) takes it away.
on Thrm.Strobe pSet
   local tText
   if pSet is an array then
      put pSet["text"] into tText
   else
      put pSet into tText
   end if
   dispatch "Term.Remove" to group "Sequencer" with "strobe"
   put empty into sStrobe
   if tText is empty then exit Thrm.Strobe
   put tText into sStrobe["text"]
   put kStrobeColors into sStrobe["colors"]
   if pSet is an array and pSet["colors"] is not empty then put pSet["colors"] into sStrobe["colors"]
   put Thrm.Now() into sStrobe["t0"]
   put empty into sStrobe["shown"]
   Thrm.StrobeStep
end Thrm.Strobe

on Thrm.StrobeStep
   local t, k, tState, tSize, x
   if sStrobe["text"] is empty then exit Thrm.StrobeStep
   put Thrm.Now() - sStrobe["t0"] into t
   put trunc(t / 0.46) + 1 into k
   if k > 3 then
      put "3 on" into tState
   else if t - (k - 1) * 0.46 < 0.32 then
      put k && "on" into tState
   else
      put k && "off" into tState
   end if
   if tState is sStrobe["shown"] then exit Thrm.StrobeStep
   put tState into sStrobe["shown"]
   if word 2 of tState is "off" then
      dispatch "Term.Remove" to group "Sequencer" with "strobe"
      exit Thrm.StrobeStep
   end if
   put max(7, min(12, trunc((gViewRight - gViewLeft - 40) / the number of chars of sStrobe["text"]))) into tSize
   put round((gViewLeft + gViewRight - the number of chars of sStrobe["text"] * tSize) / 2) into x
   dispatch "Term.Set" to group "Sequencer" with "strobe", sStrobe["text"], x, round(gViewTop + (gViewBottom - gViewTop) * 0.33), tSize, item (word 1 of tState) of sStrobe["colors"], "bold"
end Thrm.StrobeStep

-------------------------------------------------------------------- the world clock

-- Cue: call=Thrm.Clock; mode=keys|time   (keys: the world moves only as you type)
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

-- tiny bases whose shape tells what they are (meaning, value and risk to be read from
-- them later): triangle = silo, square = command post, circle = city
on Thrm.MakeMeshes
   Mesh.Define "Thrm.Globe", Thrm.GlobeMesh()
   Mesh.Define "Thrm.Silo", Mesh.Pyramid(3, 9, 12)
   Mesh.Define "Thrm.Command", Mesh.Box(14, 6, 14)
   Mesh.Define "Thrm.City", Mesh.Prism(10, 9, 3)
   Mesh.Define "Thrm.Life", Mesh.Box(18, 3, 18)
   Mesh.Define "Thrm.Missile", Mesh.Pyramid(3, 6, 14)
   Mesh.Define "Thrm.Bomber", Mesh.Prism(3, 11, 2)
   Mesh.Define "Thrm.Crater", Mesh.Prism(12, kBlackR * 0.6, 1)
end Thrm.MakeMeshes

-- the map as the top of a globe: meridians every 10 degrees bend in toward the poles,
-- parallels every 10 degrees, and the whole falls away at the edges (Thrm.Sag)
function Thrm.GlobeMesh
   local tM, i, j, tLon, tLat
   put Mesh.New() into tM
   repeat with i = 0 to 12
      put (i * 10 - 60) * pi / 180 into tLon
      repeat with j = 0 to 6
         put (j * 10 - 30) * pi / 180 into tLat
         Mesh.AddVertex tM, kGlobeR * cos(tLat) * sin(tLon), kSag * (kGlobeR - kGlobeR * cos(tLat) * cos(tLon)), kGlobeR * sin(tLat)
      end repeat
   end repeat
   -- vertex (i, j) is number i * 7 + j + 1
   repeat with i = 0 to 12
      repeat with j = 0 to 5
         Mesh.AddLine tM, i * 7 + j + 1, i * 7 + j + 2
      end repeat
   end repeat
   repeat with j = 0 to 6
      repeat with i = 0 to 11
         Mesh.AddLine tM, i * 7 + j + 1, (i + 1) * 7 + j + 1
      end repeat
   end repeat
   return tM
end Thrm.GlobeMesh

function Thrm.Now
   return sTicks * sStepMS / 1000
end Thrm.Now

