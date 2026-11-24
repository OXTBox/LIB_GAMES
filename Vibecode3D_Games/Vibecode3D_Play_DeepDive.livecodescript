######################################################################################
## CARD SCRIPT: "Play.DeepDive"   DEEP DIVE  (11 13 2026)
## A diver brings pearls up from the sea bed. Spark's concept and level numbers
## (LIB_SPARK/arcade/out/12_Deep_Dive), script corrected by Claude.
## CONTROLS  arrows: swim    Space: play again after the end    Escape: pause
##           P: pause / preferences (two sliders: most air, danger speed; P again goes on)
## RULES     air runs down under water and fills up at the surface. Touch a pearl to
##           take it. A fish, or no air, costs a life; three lives. All the pearls:
##           the next level, with more and faster fish and less air. 5 levels.
## PREFERENCES (p1-19, 23 Nov 2026; the tester: "too much oxygen, not enough danger; a demo, so
##           let the player set it"). Paused (P or Escape) a small panel shows two sliders:
##           MOST AIR = seconds of air on level 1 (each level after: 2 less, never under 6)
##           DANGER   = fish speed in percent of Spark's table
##           Old values: air 26 s, danger 100 %. New defaults: air 18 s, danger 130 %.
##           Kept for the session (globals gDiveMostAir, gDiveDanger), not saved to disk.
######################################################################################

global bPaused, bPlaying
global gDiveMostAir, gDiveDanger   -- the preferences (seconds, percent), kept for the session

local sDiver, sX, sY, sFish, sPearl, sPearls, sAir, sAirMax, sSafe
local sLevel, sLives, sScore, sOver, sTestKeys, sHUDWas

constant kZ = 600
constant kLeft = -450
constant kRight = 450
constant kSurface = -240
constant kBed = 260
constant kSwim = 7
constant kAirDefault = 18      -- was 26 (Spark's level 1) before p1-19
constant kDangerDefault = 130  -- was 100
constant kAirLeast = 6
constant kAirMost = 40
constant kDangerLeast = 50
constant kDangerMost = 250

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 3 into sLives
   put 0 into sScore
   put false into sOver
   Dive.PrefsInit
   if bPaused is not true then Dive.HidePrefs
   Dive.StartLevel 1
end Game.OnStart

-- Spark's table: fish | fish speed | pearls | air seconds (air and speed now from the preferences)
-- a level change through the loading screen (LIB_LOADING_SCREEN: burn, green text, the player first,
-- then the level draws in) when the host has it; else at once, as before. p1-13, 23 Nov 2026
on Dive.GoLevel pLevel
   if "LIB_LOADING" is among the lines of the stacksInUse then
      Loading.Go pLevel
   else
      Dive.StartLevel pLevel
   end if
end Dive.GoLevel

on Dive.StartLevel pLevel
   local tRow, tN, tDir
   put pLevel into sLevel
   put line pLevel of ("3,3,4,26" & cr & "4,3.6,5,24" & cr & "5,4.2,6,22" & cr & "6,4.8,7,20" & cr & "7,5.5,8,18") into tRow
   put Dive.LevelAir(pLevel) * 30 into sAirMax
   Scene.ClearAll
   Mesh.Define "Dive.Diver", Mesh.Box(34, 16, 12)
   Mesh.Define "Dive.Fish", Mesh.Pyramid(3, 14, 36)
   Mesh.Define "Dive.Pearl", Mesh.Sphere(8, 4, 6)
   Mesh.Define "Dive.Line", Mesh.Box(kRight - kLeft, 3, 3)
   get Entity.Spawn("Dive.Line", 0, kSurface, kZ, "cyan")
   get Entity.Spawn("Dive.Line", 0, kBed + 14, kZ, "#8A5A2A")
   -- each fish keeps to its own depth and crosses again and again
   put empty into sFish
   repeat with tN = 1 to item 1 of tRow
      put 1 into tDir
      if tN mod 2 = 0 then put -1 into tDir
      put kSurface + 70 + (tN - 1) * ((kBed - kSurface - 130) / item 1 of tRow) into sFish[tN]["y"]
      put kLeft + ((tN * 211 + pLevel * 67) mod 900) into sFish[tN]["x"]
      put item 2 of tRow * tDir * (0.8 + (tN mod 3) * 0.2) into sFish[tN]["v0"]
      put sFish[tN]["v0"] * gDiveDanger / 100 into sFish[tN]["v"]
      put Entity.Spawn("Dive.Fish", sFish[tN]["x"], sFish[tN]["y"], kZ, "orange") into sFish[tN]["key"]
      Entity.SetRotation sFish[tN]["key"], 0, 0, tDir * 1.5708
   end repeat
   put empty into sPearl
   put item 3 of tRow into sPearls
   repeat with tN = 1 to sPearls
      put kLeft + 60 + (tN - 0.5) * (780 / sPearls) + ((tN * 37 + pLevel * 11) mod 40) - 20 into sPearl[tN]["x"]
      put Entity.Spawn("Dive.Pearl", sPearl[tN]["x"], kBed, kZ, "white") into sPearl[tN]["key"]
   end repeat
   put Entity.Spawn("Dive.Diver", 0, kSurface, kZ, "yellow") into sDiver
   Dive.Up
end Dive.StartLevel

-- back at the surface with full air
on Dive.Up
   put 0 into sX
   put kSurface into sY
   put sAirMax into sAir
   put 30 into sSafe
   put empty into sHUDWas
end Dive.Up

function Dive.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Dive.Keys

on Dive.TestKeys pKeys
   put pKeys into sTestKeys
end Dive.TestKeys

on Game.OnUpdate
   local tKeys, tN
   put Dive.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put 3 into sLives
         put 0 into sScore
         put false into sOver
         Dive.GoLevel 1
      end if
      exit Game.OnUpdate
   end if
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then subtract kSwim from sX
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then add kSwim to sX
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then subtract kSwim from sY
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then add kSwim to sY
   put max(kLeft + 20, min(kRight - 20, sX)) into sX
   put max(kSurface, min(kBed, sY)) into sY
   Entity.SetPosition sDiver, sX, sY, kZ
   if sY <= kSurface + 4 then
      put min(sAirMax, sAir + 12) into sAir
   else
      subtract 1 from sAir
   end if
   if sAir mod 30 = 0 then put empty into sHUDWas
   if sSafe > 0 then subtract 1 from sSafe
   repeat for each key tN in sFish
      add sFish[tN]["v"] to sFish[tN]["x"]
      if sFish[tN]["x"] > kRight + 40 then put kLeft - 40 into sFish[tN]["x"]
      if sFish[tN]["x"] < kLeft - 40 then put kRight + 40 into sFish[tN]["x"]
      Entity.SetPosition sFish[tN]["key"], sFish[tN]["x"], sFish[tN]["y"], kZ
      if sSafe = 0 and abs(sFish[tN]["x"] - sX) < 34 and abs(sFish[tN]["y"] - sY) < 20 then
         Dive.Hurt
         exit Game.OnUpdate
      end if
   end repeat
   if sAir <= 0 then
      Dive.Hurt
      exit Game.OnUpdate
   end if
   repeat for each key tN in sPearl
      if abs(sPearl[tN]["x"] - sX) < 26 and sY > kBed - 24 then
         Entity.Kill sPearl[tN]["key"]
         delete variable sPearl[tN]
         subtract 1 from sPearls
         add 50 to sScore
         put empty into sHUDWas
      end if
   end repeat
   if sPearls <= 0 then
      add sAir div 30 * 5 to sScore
      if sLevel >= 5 then
         put true into sOver
         put empty into sHUDWas
      else
         Dive.GoLevel sLevel + 1
      end if
   end if
   Dive.ShowHUD
end Game.OnUpdate

on Dive.Hurt
   subtract 1 from sLives
   FX.Sparks sX, sY, kZ, 12, "red"
   if sLives <= 0 then put true into sOver
   Dive.Up
   Dive.ShowHUD
end Dive.Hurt

on Dive.ShowHUD
   local tWords
   put sLevel & "|" & sLives & "|" & sScore & "|" & sPearls & "|" & sAir div 30 & "|" & sOver into tWords
   if tWords is sHUDWas then exit Dive.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Dive.Hint", "P: PAUSE / PREFERENCES", 20, 144, 11
   HUD.Set "Dive.Score", "SCORE" && sScore && "  LIVES" && sLives && "  LEVEL" && sLevel && "  PEARLS LEFT" && sPearls && "  AIR" && max(0, sAir div 30), 20, 120, 14
   HUD.Remove "Dive.Msg"
   if sOver and sLives > 0 then
      HUD.Set "Dive.Msg", "EVERY PEARL IS UP.  SPACE TO PLAY AGAIN", 210, 300, 16
   else if sOver then
      HUD.Set "Dive.Msg", "GAME OVER.  SPACE TO PLAY AGAIN", 250, 300, 16
   end if
end Dive.ShowHUD

function Dive.State
   return sLevel & "|" & sLives & "|" & sScore & "|pearls " & sPearls & "|at " & round(sX) & "," & round(sY) & "|air " & sAir div 30 & "|" & sOver
end Dive.State

-------------------------------------------------------------------- preferences (p1-19)

-- the defaults, the first time in this session
on Dive.PrefsInit
   if gDiveMostAir is not a number then put kAirDefault into gDiveMostAir
   if gDiveDanger is not a number then put kDangerDefault into gDiveDanger
end Dive.PrefsInit

-- seconds of air on a level: the preference on level 1, 2 less each level after
function Dive.LevelAir pLevel
   Dive.PrefsInit
   return max(kAirLeast, gDiveMostAir - (pLevel - 1) * 2)
end Dive.LevelAir

-- "air seconds,danger percent"
function Dive.Prefs
   Dive.PrefsInit
   return gDiveMostAir & "," & gDiveDanger
end Dive.Prefs

-- the MOST AIR slider calls this: at once, the tank is never fuller than the new most
on Dive.SetMostAir pSeconds
   if pSeconds is not a number then exit Dive.SetMostAir
   put max(kAirLeast, min(kAirMost, round(pSeconds))) into gDiveMostAir
   if sLevel is a number then
      put Dive.LevelAir(sLevel) * 30 into sAirMax
      put min(sAir, sAirMax) into sAir
      put empty into sHUDWas
   end if
   Dive.PrefsLabels
end Dive.SetMostAir

-- the DANGER slider calls this: every fish takes the new speed at once
on Dive.SetDanger pPercent
   local tN
   if pPercent is not a number then exit Dive.SetDanger
   put max(kDangerLeast, min(kDangerMost, round(pPercent))) into gDiveDanger
   repeat for each key tN in sFish
      put sFish[tN]["v0"] * gDiveDanger / 100 into sFish[tN]["v"]
   end repeat
   Dive.PrefsLabels
end Dive.SetDanger

-- P pauses and goes on, through the host: the Game Player (Player.TogglePause) or the
-- Vibecode3D app (Game.Pause / ResumeGame). Either way Game.OnPause / Game.OnResume follow.
on Dive.TogglePause
   dispatch "Player.TogglePause" to me
   if it is "handled" then exit Dive.TogglePause
   if bPaused is true then
      dispatch "ResumeGame" to me
   else
      dispatch "Game.Pause" to me
   end if
end Dive.TogglePause

on keyDown pKey
   if word 1 of the name of the target is "field" or sLevel is empty then pass keyDown
   if pKey is "p" then
      Dive.TogglePause
   else
      pass keyDown
   end if
end keyDown

on Game.OnPause
   Dive.ShowPrefs
end Game.OnPause

on Game.OnResume
   Dive.HidePrefs
   focus on nothing
end Game.OnResume

-- the sliders: their moves come up to the card
on scrollbarDrag pValue
   Dive.PrefsFrom the long id of the target
   pass scrollbarDrag
end scrollbarDrag

on mouseUp pButton
   if the short name of the target begins with "DivePref" then
      Dive.PrefsFrom the long id of the target
      exit mouseUp
   end if
   pass mouseUp
end mouseUp

on Dive.PrefsFrom pObj
   if word 1 of pObj is not "scrollbar" then exit Dive.PrefsFrom
   if the short name of pObj is "DivePrefAir" then Dive.SetMostAir the thumbPosition of pObj
   if the short name of pObj is "DivePrefDanger" then Dive.SetDanger the thumbPosition of pObj
end Dive.PrefsFrom

function Dive.PrefColor pKey, pElse
   local tC
   if "lib_theme" is among the lines of the stacksInUse then
      try
         put Theme.Get(pKey) into tC
      end try
   end if
   if tC is empty then return pElse
   return tC
end Dive.PrefColor

-- the panel: lower middle (the host's PAUSED line is in the middle), made when paused, gone on resume
on Dive.ShowPrefs
   local tL, tT, tW, tPanel, tText, tDim
   Dive.PrefsInit
   Dive.HidePrefs
   put 400 into tW
   put (the width of me - tW) div 2 into tL
   put the height of me div 2 + 40 into tT
   put Dive.PrefColor("panel", "42,42,48") into tPanel
   put Dive.PrefColor("text", "220,220,224") into tText
   put Dive.PrefColor("dim", "150,150,160") into tDim
   lock screen
   -- made on this card: the plain create puts a control on the defaultStack's card
   set the defaultStack to the short name of the owner of me
   lock messages
   reset the templateGraphic
   set the style of the templateGraphic to "rectangle"
   set the opaque of the templateGraphic to true
   set the backgroundColor of the templateGraphic to tPanel
   set the foregroundColor of the templateGraphic to Dive.PrefColor("accent", "64,224,255")
   set the traversalOn of the templateGraphic to false
   create graphic "DivePrefPanel"
   set the rect of graphic "DivePrefPanel" of me to tL, tT, tL + tW, tT + 150
   reset the templateGraphic
   Dive.PrefLabel "DivePrefTitle", "PREFERENCES      P or Escape: go on", tL + 12, tT + 8, tW - 24, tText
   Dive.PrefLabel "DivePrefAirText", empty, tL + 12, tT + 40, tW - 24, tDim
   Dive.PrefSlider "DivePrefAir", kAirLeast, kAirMost, gDiveMostAir, tL + 12, tT + 60, tW - 24, tPanel
   Dive.PrefLabel "DivePrefDangerText", empty, tL + 12, tT + 92, tW - 24, tDim
   Dive.PrefSlider "DivePrefDanger", kDangerLeast, kDangerMost, gDiveDanger, tL + 12, tT + 112, tW - 24, tPanel
   unlock messages
   Dive.PrefsLabels
   unlock screen
end Dive.ShowPrefs

on Dive.PrefLabel pName, pText, pL, pT, pW, pColor
   reset the templateField
   set the opaque of the templateField to false
   set the showBorder of the templateField to false
   set the lockText of the templateField to true
   set the traversalOn of the templateField to false
   set the dontWrap of the templateField to true
   set the textSize of the templateField to 12
   set the foregroundColor of the templateField to pColor
   create field pName
   set the rect of field pName of me to pL, pT, pL + pW, pT + 20
   put pText into field pName of me
   reset the templateField
end Dive.PrefLabel

on Dive.PrefSlider pName, pFrom, pTo, pValue, pL, pT, pW, pColor
   reset the templateScrollbar
   set the style of the templateScrollbar to "scale"
   set the backgroundColor of the templateScrollbar to pColor
   set the traversalOn of the templateScrollbar to false
   set the showValue of the templateScrollbar to false
   create scrollbar pName
   set the rect of scrollbar pName of me to pL, pT, pL + pW, pT + 24
   set the startValue of scrollbar pName of me to pFrom
   set the endValue of scrollbar pName of me to pTo
   set the thumbPosition of scrollbar pName of me to pValue
   reset the templateScrollbar
end Dive.PrefSlider

-- the words over the sliders say the values
on Dive.PrefsLabels
   if there is a field "DivePrefAirText" of me then
      put "MOST AIR:" && gDiveMostAir && "seconds on level 1 (2 less each level)" into field "DivePrefAirText" of me
   end if
   if there is a field "DivePrefDangerText" of me then
      put "DANGER: fish at" && gDiveDanger && "% speed" into field "DivePrefDangerText" of me
   end if
end Dive.PrefsLabels

on Dive.HidePrefs
   local tName
   lock screen
   repeat for each item tName in "DivePrefPanel,DivePrefTitle,DivePrefAirText,DivePrefAir,DivePrefDangerText,DivePrefDanger"
      if there is a control tName of me then delete control tName of me
   end repeat
   unlock screen
end Dive.HidePrefs

-- tests: fish pN's speed now (pixels a step, signed)
function Dive.FishV pN
   return sFish[pN]["v"]
end Dive.FishV

function Dive.PrefsShown
   return there is a scrollbar "DivePrefAir" of me
end Dive.PrefsShown

on Game.OnStop
   Dive.HidePrefs
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
