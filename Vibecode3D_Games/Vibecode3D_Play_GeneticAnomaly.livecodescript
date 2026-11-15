######################################################################################
## CARD SCRIPT: "Play.GeneticAnomaly"   GENETIC ANOMALY  (prototype, 13 11 2026)
## The owner's concept: people with paranormal powers and experiences, real and imagined,
## and escalating levels of super strange and powerful beings, all stick figures, on a
## procedural world. The big map, point plotting (after Ed Zavada's Galactica): towns are
## points; people are produced, sent and fought with in circles.
## Built on GENERIC ARRAY DATA: every word is a label from LIB_GENERICA/sets (theme
## genetic_anomaly over the base generic_array_data).
##   G     swaps every word to the generic base and back
##   Tab   collapses the whole game into a spreadsheet, and back
## TURNS     (owner's game note 11 14, 8:13 PM: "the slow turn based game, where player has to
##           'end turn' to advance", "the advancement economy", "a big map we can scroll around
##           and zoom in and out of") the world waits for you. ENTER ends the turn: one night
##           plays out (people walk, towns grow, the Strangeness acts), then it waits again.
## ECONOMY   (after Galactica's growth / research / building sliders, LIB_GAD) each of your towns
##           has a FOCUS: 1 RECRUIT (more people), 2 RESEARCH (points toward the Bureau's next
##           rank, for every town), 3 TRAIN (this town's own rank). Output = 1 + people / 6.
##           The Strangeness still climbs on its own clock: research to keep up.
## CONTROLS  click one of your towns, then any other town: half its people go there
##           1 2 3: the selected town's focus   ENTER: end turn
##           arrows or W A S D: scroll the map   mouse wheel or + -: zoom   H: home
##           Space: pause   R: a new world   Escape: stop
## RULES     arrive at a town that isn't yours: strength (people x rank) against strength.
##           Hold every town to win. The Strangeness escalates; something else may too.
######################################################################################

global gObjectTransforms, gSceneObjects
global bPaused, bPlaying

local sWords, sTheme, sGenRoot
local sTown, sTownCount, sCircle, sSerial, sSel, sTicks, sNight, sOver, sPaused, sKeysWas
local sSheet, sHero, sHUDWas, sOtherRank, sMyRank, sWorldSeed
local sAdvance       -- frames of the night still to play after ENTER (0 = waiting for the player)
local sResearch      -- the Bureau's research points toward its next rank
local sPanX, sPanY, sZoom, sCamWas   -- the view: centre of the screen in world units, and zoom (1 = as before)
local sTestKeys      -- engine_play: keys held by GA.TestKeys instead of the keyboard

constant kZ = 365
constant kNightTicks = 45        -- frames a night plays for after ENTER
constant kTowns = 64             -- the big map (was 30 on one screen)
constant kMapW = 1100            -- towns lie within -kMapW..kMapW across
constant kMapH = 640             -- and -kMapH..kMapH down
constant kPanStep = 9            -- map units a frame while an arrow is held (at zoom 1)
constant kZoomMin = 0.45
constant kZoomMax = 2.4
constant kSideColor = "#B0B0B0,#40E0FF,#FF60D0"   -- locals, Bureau, Strangeness
constant kCircleSpeed = 4

-------------------------------------------------------------------- words (GENERIC ARRAY DATA)

-- LIB_GENERICA, found above this stack or in WSL
function GA.GenRoot
   local tPath, tTry
   if sGenRoot is not empty then return sGenRoot
   put the effective filename of this stack into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   repeat 8 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      if there is a folder (tPath & "/LIB_GENERICA/sets") then
         put tPath & "/LIB_GENERICA/sets" into sGenRoot
         return sGenRoot
      end if
   end repeat
   put "//wsl$/Ubuntu/home/igame3d/projects/LIB_GENERICA/sets" into tTry
   if there is a folder tTry then put tTry into sGenRoot
   return sGenRoot
end GA.GenRoot

-- load a theme over the base: sWords[list] = its labels, one per line
on GA.LoadWords pTheme
   local tRoot, tT, tCat, tF, tText, tLines, tL
   put empty into sWords
   put pTheme into sTheme
   put GA.GenRoot() into tRoot
   if tRoot is empty then exit GA.LoadWords
   repeat for each item tT in "generic_array_data," & pTheme
      if tT is empty then next repeat
      repeat for each line tCat in folders(tRoot & "/" & tT)
         if tCat is "." or tCat is ".." then next repeat
         repeat for each line tF in files(tRoot & "/" & tT & "/" & tCat)
            if char -4 to -1 of tF is not ".txt" then next repeat
            put URL ("file:" & tRoot & "/" & tT & "/" & tCat & "/" & tF) into tText
            replace numToChar(13) with empty in tText
            put empty into tLines
            repeat for each line tL in tText
               if char 1 of tL is "#" then next repeat
               put tL & cr after tLines
            end repeat
            delete char -1 of tLines
            put tLines into sWords[char 1 to -5 of tF]
         end repeat
      end repeat
   end repeat
end GA.LoadWords

-- label n of a list; the fallback when the word files aren't there
function GA.W pList, pN, pFallback
   local t
   put line pN of sWords[pList] into t
   if t is empty then return pFallback
   return t
end GA.W

function GA.Fill pText, pPct, pHash, pStar
   replace "%" with pPct in pText
   replace "#" with pHash in pText
   replace "*" with pStar in pText
   return pText
end GA.Fill

-------------------------------------------------------------------- the world

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   if sTheme is empty then put "genetic_anomaly" into sTheme
   GA.LoadWords sTheme
   GA.Meshes
   if sWorldSeed is empty then put random(99999) into sWorldSeed
   GA.NewWorld sWorldSeed
   put false into sSheet
   GA.ShowSheet
end Game.OnStart

-- stick figures: one mesh per rank, bigger and odder as the rank climbs
on GA.Meshes
   local r, tM, s, tTall
   repeat with r = 1 to 7
      put 7 + r * 1.6 into s
      -- the Bureau's people: plain stick figures, arms rising with rank
      put Mesh.New() into tM
      GA.Stick tM, s, min(r, 4) * 0.25, 1
      Mesh.Define "GA.Me" & r, tM
      -- the Strangeness: taller, longer arms, more heads as it escalates
      put Mesh.New() into tM
      put 1 + r * 0.12 into tTall
      GA.Stick tM, s * tTall, -0.4, 1 + (r + 1) div 4      -- 1 head, then 2 at rank 3, 3 at rank 7
      Mesh.Define "GA.Other" & r, tM
   end repeat
   -- the late surprise: a caped figure, fists on hips
   put Mesh.New() into tM
   GA.Stick tM, 26, -2, 1
   Mesh.AddVertex tM, -6, -40, 0
   Mesh.AddVertex tM, 6, -40, 0
   Mesh.AddVertex tM, -16, 0, 4
   Mesh.AddVertex tM, 16, 0, 4
   Mesh.AddLine tM, 11, 13
   Mesh.AddLine tM, 12, 14
   Mesh.AddLine tM, 13, 14
   Mesh.Define "GA.Hero", tM
   Mesh.Define "GA.Town", MeshSphere(7, 2, 4)
   Mesh.Define "GA.Ring", MeshPrism(10, 18, 2)
end GA.Meshes

-- a stick figure standing on y=0 (y down): head diamond, body, arms (pArms: -2 hips .. 1 up), legs
on GA.Stick @tM, s, pArms, pHeads
   local h
   Mesh.AddVertex tM, 0, -s * 1.5, 0         -- 1 neck
   Mesh.AddVertex tM, 0, -s * 0.7, 0         -- 2 hip
   Mesh.AddVertex tM, -s * 0.4, 0, 0         -- 3 left foot
   Mesh.AddVertex tM, s * 0.4, 0, 0          -- 4 right foot
   if pArms <= -2 then
      Mesh.AddVertex tM, -s * 0.45, -s * 1.1, 0   -- 5 elbows out
      Mesh.AddVertex tM, s * 0.45, -s * 1.1, 0    -- 6
      Mesh.AddVertex tM, -s * 0.1, -s * 0.75, 0   -- 7 fists on hips
      Mesh.AddVertex tM, s * 0.1, -s * 0.75, 0    -- 8
   else
      Mesh.AddVertex tM, -s * 0.5, -s * (1.2 + pArms * 0.5), 0
      Mesh.AddVertex tM, s * 0.5, -s * (1.2 + pArms * 0.5), 0
      Mesh.AddVertex tM, -s * 0.7, -s * (1.0 + pArms), 0
      Mesh.AddVertex tM, s * 0.7, -s * (1.0 + pArms), 0
   end if
   Mesh.AddVertex tM, 0, -s * 2.1, 0          -- 9 top of head
   Mesh.AddVertex tM, 0, -s * 1.8, 0          -- 10 head centre (for the diamond)
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 2, 4
   Mesh.AddLine tM, 1, 5
   Mesh.AddLine tM, 5, 7
   Mesh.AddLine tM, 1, 6
   Mesh.AddLine tM, 6, 8
   Mesh.AddLine tM, 1, 9
   repeat with h = 2 to pHeads
      -- extra heads for the strangest
      Mesh.AddVertex tM, (h - 1.5) * s * 0.9, -s * 2.0, 0
      Mesh.AddLine tM, 1, tM["count"]
   end repeat
end GA.Stick

on GA.NewWorld pSeed
   local n, tTry, x, y, ok, k, tName, tParts, tP
   set the randomSeed to pSeed
   Scene.ClearAll
   put empty into sTown
   put empty into sCircle
   put 0 into sSerial
   put empty into sSel
   put 0 into sTicks
   put 1 into sNight
   put false into sOver
   put false into sPaused
   put false into sHero
   put 1 into sOtherRank
   put 1 into sMyRank
   put 0 into sResearch
   put 0 into sAdvance
   put empty into sHUDWas
   -- towns: points scattered with some room between them
   put 0 into n
   repeat 2000 times
      if n >= kTowns then exit repeat
      put random(2 * kMapW) - kMapW into x
      put random(2 * kMapH) - kMapH into y
      put true into ok
      repeat with k = 1 to n
         if abs(sTown[k]["x"] - x) < 70 and abs(sTown[k]["y"] - y) < 55 then
            put false into ok
            exit repeat
         end if
      end repeat
      if not ok then next repeat
      add 1 to n
      put x into sTown[n]["x"]
      put y into sTown[n]["y"]
      put 0 into sTown[n]["side"]
      put 2 + random(6) into sTown[n]["people"]
      put 1 into sTown[n]["rank"]
      put 1 + random(3) into sTown[n]["grow"]
      put "recruit" into sTown[n]["focus"]
      put 0 into sTown[n]["train"]
      -- a procedural name from the name parts
      put sWords["game_name_parts"] into tParts
      if tParts is empty then put "Ash" & cr & "Bel" & cr & "ford" & cr & "ton" into tParts
      put line random(the number of lines of tParts) of tParts into tName
      put line random(the number of lines of tParts) of tParts into tP
      put tName & tolower(tP) into sTown[n]["name"]
      put toUpper(char 1 of sTown[n]["name"]) into char 1 of sTown[n]["name"]
      put empty into sTown[n]["rumour"]
   end repeat
   put n into sTownCount
   -- the Bureau starts far left, the Strangeness far right
   put GA.Farthest(-1) into k
   put 1 into sTown[k]["side"]
   put 20 into sTown[k]["people"]
   put 2 into sTown[k]["rank"]
   put GA.Farthest(1) into k
   put 2 into sTown[k]["side"]
   put 20 into sTown[k]["people"]
   put 2 into sTown[k]["rank"]
   set the randomSeed to random(99999) + the milliseconds
   -- the view starts on your home town, a little zoomed out
   GA.Home
   repeat with k = 1 to sTownCount
      GA.DrawTown k
   end repeat
   GA.Say GA.W("game_hud_labels", 6, "CLICK ONE OF YOURS, THEN ANOTHER PLACE") && "- ENTER ENDS THE TURN"
end GA.NewWorld

function GA.Farthest pDir
   local k, tBest, tB
   put -9999 into tBest
   repeat with k = 1 to sTownCount
      if sTown[k]["x"] * pDir > tBest then
         put sTown[k]["x"] * pDir into tBest
         put k into tB
      end if
   end repeat
   return tB
end GA.Farthest

-- a town: a point, a stick figure for its strangest person, a ring when selected, a label
on GA.DrawTown k
   local tSide, tMesh
   put sTown[k]["side"] into tSide
   if sTown[k]["dot"] is not empty then Entity.Kill sTown[k]["dot"]
   if sTown[k]["fig"] is not empty then Entity.Kill sTown[k]["fig"]
   put Entity.Spawn("GA.Town", sTown[k]["x"], sTown[k]["y"], kZ, item tSide + 1 of kSideColor) into sTown[k]["dot"]
   put empty into sTown[k]["fig"]
   if tSide is 1 then put "GA.Me" & sTown[k]["rank"] into tMesh
   if tSide is 2 then put "GA.Other" & sTown[k]["rank"] into tMesh
   if tSide is 0 and sTown[k]["rank"] > 1 then put "GA.Me" & (sTown[k]["rank"] - 1) into tMesh
   if sTown[k]["hero"] then put "GA.Hero" into tMesh
   if tMesh is not empty then
      put Entity.Spawn(tMesh, sTown[k]["x"], sTown[k]["y"] - 8, kZ, item tSide + 1 of kSideColor) into sTown[k]["fig"]
   end if
   GA.LabelTown k
end GA.DrawTown

on GA.LabelTown k
   local tXY
   put GA.Proj(sTown[k]["x"], sTown[k]["y"]) into tXY
   if tXY is empty then exit GA.LabelTown
   if sSheet then
      HUD.Remove "GA.T" & k
   else
      HUD.Set "GA.T" & k, toUpper(sTown[k]["name"]) && sTown[k]["people"] & GA.FocusTag(k), word 1 of tXY - 24, word 2 of tXY + 10, 9
   end if
end GA.LabelTown

-------------------------------------------------------------------- the loop

function GA.Keys
   if sTestKeys is not empty then
      if sTestKeys is "0" then return empty
      return sTestKeys
   end if
   return the keysDown
end GA.Keys

-- engine_play: hold these keys (comma list; "0" = none) instead of the keyboard
on GA.TestKeys pKeys
   put pKeys into sTestKeys
end GA.TestKeys

on Game.OnUpdate
   local tKeys, tNew, k
   put GA.Keys() into tKeys
   -- one press = one action (Tab, G, Space, R)
   repeat for each item k in tKeys
      if k is among the items of sKeysWas then next repeat
      switch k
         case 65289
            put not sSheet into sSheet
            GA.ShowSheet
            break
         case 103
         case 71
            if sTheme is "genetic_anomaly" then
               GA.LoadWords "generic_array_data"
            else
               GA.LoadWords "genetic_anomaly"
            end if
            GA.ShowSheet
            put empty into sHUDWas
            GA.Say "WORDS:" && toUpper(sTheme) && "(" & toUpper(GA.W("game_unit_types", 3, "place")) & ", " & toUpper(GA.Rank(1, 1)) & ", " & toUpper(GA.Rank(2, 1)) & ")"
            break
         case 32
            put not sPaused into sPaused
            if sPaused then GA.Say GA.W("game_hud_labels", 9, "PAUSED")
            break
         case 114
         case 82
            put random(99999) into sWorldSeed
            GA.NewWorld sWorldSeed
            break
         case 65293
         case 65421
            GA.EndTurn
            break
         case 49
         case 50
         case 51
            GA.SetFocus sSel, item (k - 48) of "recruit,research,train"
            break
         case 104
         case 72
            GA.Home
            break
         case 43
         case 61
         case 65451
            GA.ZoomBy 1.15
            break
         case 45
         case 65453
            GA.ZoomBy 1 / 1.15
            break
      end switch
   end repeat
   put tKeys into sKeysWas
   GA.PanKeys tKeys
   GA.ApplyView
   if sPaused or sOver then exit Game.OnUpdate
   -- turn based: the world moves only while a night plays out after ENTER
   if sAdvance > 0 then
      add 1 to sTicks
      GA.MoveCircles
      subtract 1 from sAdvance
      if sAdvance is 0 then GA.Night
   end if
   GA.ShowHUD
end Game.OnUpdate

-------------------------------------------------------------------- turns and the economy

on GA.EndTurn
   if sAdvance > 0 or sOver then exit GA.EndTurn
   put kNightTicks into sAdvance
   GA.Say GA.W("game_hud_labels", 4, "TURN") && sNight && "- THE NIGHT PLAYS OUT"
end GA.EndTurn

-- 1 / 2 / 3 on a selected town of yours: what its spare output goes to
on GA.SetFocus k, pFocus
   if k is empty then
      GA.Say "SELECT ONE OF YOUR TOWNS FIRST, THEN 1 2 3"
      exit GA.SetFocus
   end if
   if sTown[k]["side"] is not 1 then exit GA.SetFocus
   put pFocus into sTown[k]["focus"]
   GA.LabelTown k
   GA.Say toUpper(sTown[k]["name"]) && "FOCUS:" && toUpper(pFocus)
   put empty into sHUDWas
end GA.SetFocus

-- a short mark after a town's label: R S T for your towns' focus (recruit, research = study, train)
function GA.FocusTag k
   if sTown[k]["side"] is not 1 then return empty
   if sTown[k]["focus"] is "research" then return " S"
   if sTown[k]["focus"] is "train" then return " T"
   return " R"
end GA.FocusTag

function GA.Output k
   return 1 + sTown[k]["people"] div 6
end GA.Output

-- research points the Bureau needs for its next rank
function GA.ResearchCost
   return 12 * sMyRank * sMyRank
end GA.ResearchCost

-------------------------------------------------------------------- the view: scroll and zoom

-- a world point on the screen, through the view
function GA.Proj pX, pY
   return ProjectVertex((pX - sPanX) * sZoom, (pY - sPanY) * sZoom, kZ)
end GA.Proj

on GA.Home
   local k
   put GA.FirstOf(1) into k
   if k is empty then
      put 0 into sPanX
      put 0 into sPanY
   else
      put sTown[k]["x"] + 250 into sPanX
      put sTown[k]["y"] into sPanY
   end if
   put 0.8 into sZoom
   put empty into sCamWas
end GA.Home

on GA.ZoomBy pF
   put max(kZoomMin, min(kZoomMax, sZoom * pF)) into sZoom
end GA.ZoomBy

-- arrows and W A S D scroll (faster when zoomed out); keys 65361-65364 left up right down
on GA.PanKeys pKeys
   local tStep
   put kPanStep / sZoom into tStep
   if 65361 is among the items of pKeys or 97 is among the items of pKeys or 65 is among the items of pKeys then subtract tStep from sPanX
   if 65363 is among the items of pKeys or 100 is among the items of pKeys or 68 is among the items of pKeys then add tStep to sPanX
   if 65362 is among the items of pKeys or 119 is among the items of pKeys or 87 is among the items of pKeys then subtract tStep from sPanY
   if 65364 is among the items of pKeys or 115 is among the items of pKeys or 83 is among the items of pKeys then add tStep to sPanY
   put max(-kMapW - 300, min(kMapW + 300, sPanX)) into sPanX
   put max(-kMapH - 300, min(kMapH + 300, sPanY)) into sPanY
end GA.PanKeys

-- the engine draws the scene through its camera: the view moves the scene, not the towns.
-- Pan = camera X/Y; zoom = camera Z (towns at kZ look sZoom times their size at kZ / sZoom).
on GA.ApplyView
   local tNow, k
   put sPanX & "," & sPanY & "," & sZoom into tNow
   if tNow is sCamWas then exit GA.ApplyView
   put tNow into sCamWas
   Engine.SetCam -sPanX, -sPanY, kZ / sZoom - kZ
   repeat with k = 1 to sTownCount
      GA.LabelTown k
   end repeat
end GA.ApplyView

-- the mouse wheel zooms (wheel keys arrive as rawKeyDown 65308 down / 65309 up); others go on
on rawKeyDown pKey
   if pKey is 65309 then
      GA.ZoomBy 1.1
      exit rawKeyDown
   end if
   if pKey is 65308 then
      GA.ZoomBy 1 / 1.1
      exit rawKeyDown
   end if
   pass rawKeyDown
end rawKeyDown

-- every night: towns grow; ranks climb; the Strangeness acts; maybe something else
on GA.Night
   local k, n, tMine, tTheirs
   add 1 to sNight
   -- the Strangeness escalates a rank every 8 nights; the Bureau climbs by research (the economy)
   put min(7, 1 + sNight div 8) into sOtherRank
   put 0 into tMine
   put 0 into tTheirs
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is 0 then
         -- the locals: experiences, real and imagined, now and then
         if random(12) is 1 then add 1 to sTown[k]["people"]
         if random(40) is 1 and sTown[k]["rank"] < 3 then
            add 1 to sTown[k]["rank"]
            put "something seen" into sTown[k]["rumour"]
            GA.DrawTown k
         end if
      else
         add sTown[k]["grow"] to sTown[k]["people"]
         if sTown[k]["side"] is 1 then GA.Produce k
         if sTown[k]["side"] is 1 and sTown[k]["rank"] < sMyRank then
            put sMyRank into sTown[k]["rank"]
            GA.DrawTown k
         end if
         if sTown[k]["side"] is 2 and sTown[k]["rank"] < sOtherRank then
            put sOtherRank into sTown[k]["rank"]
            GA.DrawTown k
         end if
      end if
      if sTown[k]["side"] is 1 then add 1 to tMine
      if sTown[k]["side"] is 2 then add 1 to tTheirs
      GA.LabelTown k
   end repeat
   -- the Strangeness: every few nights its strongest town sends at a weaker town nearby
   if sNight mod 3 is 0 then GA.OtherMoves
   -- the late shock: the Bureau doing well, and something in a cape arrives
   if not sHero and tMine >= sTownCount * 0.5 and sNight > 25 then GA.HeroArrives
   -- research done: the Bureau's next rank, for every town of yours
   if sMyRank < 7 and sResearch >= GA.ResearchCost() then
      subtract GA.ResearchCost() from sResearch
      add 1 to sMyRank
      GA.Say "RESEARCH: THE BUREAU REACHES" && toUpper(GA.Rank(1, sMyRank))
      repeat with k = 1 to sTownCount
         if sTown[k]["side"] is 1 and sTown[k]["rank"] < sMyRank then
            put sMyRank into sTown[k]["rank"]
            GA.DrawTown k
         end if
      end repeat
   end if
   if tTheirs is 0 and not GA.SideMoving(2) then GA.End 1
   if tMine is 0 and not GA.SideMoving(1) then GA.End 2
   if sSheet then GA.ShowSheet
end GA.Night

-- one town of yours at night: its output goes to its focus
on GA.Produce k
   local tOut
   put GA.Output(k) into tOut
   switch sTown[k]["focus"]
      case "research"
         add tOut to sResearch
         break
      case "train"
         add tOut to sTown[k]["train"]
         if sTown[k]["train"] >= sTown[k]["rank"] * 8 and sTown[k]["rank"] < 7 then
            put 0 into sTown[k]["train"]
            add 1 to sTown[k]["rank"]
            GA.DrawTown k
         end if
         break
      default
         add tOut to sTown[k]["people"]
   end switch
end GA.Produce

on GA.OtherMoves
   local k, j, tFrom, tBest, d, tTo, tScore
   put 0 into tBest
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is 2 and sTown[k]["people"] > tBest then
         put sTown[k]["people"] into tBest
         put k into tFrom
      end if
   end repeat
   if tFrom is empty or tBest < 8 then exit GA.OtherMoves
   put 1e9 into tBest
   repeat with j = 1 to sTownCount
      if sTown[j]["side"] is 2 then next repeat
      put sqrt((sTown[j]["x"] - sTown[tFrom]["x"]) ^ 2 + (sTown[j]["y"] - sTown[tFrom]["y"]) ^ 2) into d
      put d + sTown[j]["people"] * sTown[j]["rank"] * 6 into tScore
      if tScore < tBest then
         put tScore into tBest
         put j into tTo
      end if
   end repeat
   if tTo is not empty then GA.Send tFrom, tTo
end GA.OtherMoves

function GA.SideMoving pSide
   local c
   repeat for each key c in sCircle
      if sCircle[c]["side"] is pSide then return true
   end repeat
   return false
end GA.SideMoving

-- half a town's people set off as a circle, walking (one stick figure) to the target
on GA.Send pFrom, pTo
   local n, tMesh
   put sTown[pFrom]["people"] div 2 into n
   if n < 1 or pFrom is pTo then exit GA.Send
   subtract n from sTown[pFrom]["people"]
   add 1 to sSerial
   put pFrom into sCircle[sSerial]["from"]
   put pTo into sCircle[sSerial]["to"]
   put n into sCircle[sSerial]["people"]
   put sTown[pFrom]["rank"] into sCircle[sSerial]["rank"]
   put sTown[pFrom]["side"] into sCircle[sSerial]["side"]
   put sTown[pFrom]["x"] into sCircle[sSerial]["x"]
   put sTown[pFrom]["y"] into sCircle[sSerial]["y"]
   put "GA.Other" & sCircle[sSerial]["rank"] into tMesh
   if sCircle[sSerial]["side"] is 1 then put "GA.Me" & sCircle[sSerial]["rank"] into tMesh
   put Entity.Spawn(tMesh, sCircle[sSerial]["x"], sCircle[sSerial]["y"], kZ - 4, item sCircle[sSerial]["side"] + 1 of kSideColor) into sCircle[sSerial]["key"]
   GA.LabelTown pFrom
end GA.Send

on GA.MoveCircles
   local c, dx, dy, d, k
   repeat for each key c in sCircle
      put sCircle[c]["to"] into k
      put sTown[k]["x"] - sCircle[c]["x"] into dx
      put sTown[k]["y"] - sCircle[c]["y"] into dy
      put sqrt(dx * dx + dy * dy) into d
      if d <= kCircleSpeed then
         Entity.Kill sCircle[c]["key"]
         GA.Arrive c
         delete variable sCircle[c]
         next repeat
      end if
      add dx / d * kCircleSpeed to sCircle[c]["x"]
      add dy / d * kCircleSpeed to sCircle[c]["y"]
      -- a small hop as they walk
      SetObjectPosition sCircle[c]["key"], sCircle[c]["x"], sCircle[c]["y"] - abs(4 * sin(sTicks / 3)), kZ - 4
   end repeat
end GA.MoveCircles

-- strength = people x rank; the stronger side keeps what's left
on GA.Arrive c
   local k, tSide, tMine, tTheirs, tWas, tWho, tFrom
   put sCircle[c]["to"] into k
   put sCircle[c]["side"] into tSide
   if sTown[k]["side"] is tSide then
      add sCircle[c]["people"] to sTown[k]["people"]
      put max(sTown[k]["rank"], sCircle[c]["rank"]) into sTown[k]["rank"]
      GA.DrawTown k
      exit GA.Arrive
   end if
   put sCircle[c]["people"] * sCircle[c]["rank"] into tMine
   put sTown[k]["people"] * sTown[k]["rank"] + 1 into tTheirs
   if sTown[k]["hero"] then multiply tTheirs by 4
   FX.Sparks sTown[k]["x"], sTown[k]["y"], kZ, 12, item tSide + 1 of kSideColor
   if tMine > tTheirs then
      put sTown[k]["side"] into tWas
      put tSide into sTown[k]["side"]
      put max(1, round((tMine - tTheirs) / sCircle[c]["rank"])) into sTown[k]["people"]
      put sCircle[c]["rank"] into sTown[k]["rank"]
      put false into sTown[k]["hero"]
      put GA.W("game_faction_labels", tWas + 1, "Side") into tWho
      if tWas is 0 then put GA.W("game_unit_ownership_labels", 1, "nobody") into tWho
      if tSide is 1 then
         GA.Say GA.Fill(GA.W("game_events_text", 1, "You took % from #!"), sTown[k]["name"], tWho, empty)
      else if tWas is 1 then
         GA.Say GA.Fill(GA.W("game_events_text", 2, "You lost % to *."), sTown[k]["name"], empty, GA.W("game_faction_labels", 2, "Side 2"))
      else
         GA.Say GA.Fill(GA.W("game_events_text", 3, "* took % from #."), sTown[k]["name"], tWho, GA.W("game_faction_labels", 2, "Side 2"))
      end if
   else
      put max(1, round((tTheirs - tMine) / sTown[k]["rank"])) into sTown[k]["people"]
   end if
   GA.DrawTown k
end GA.Arrive

on GA.HeroArrives
   local k, tBest
   put true into sHero
   put 0 into tBest
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is 1 and sTown[k]["people"] > tBest then
         put sTown[k]["people"] into tBest
         put k into sHero["town"]
      end if
   end repeat
   put sHero["town"] into k
   put true into sTown[k]["hero"]
   put "a cape" into sTown[k]["rumour"]
   FX.Sparks sTown[k]["x"], sTown[k]["y"], kZ, 60, "#FFE060"
   GA.DrawTown k
   GA.Say toUpper(GA.Fill(GA.W("game_message_hero", 1, "A thing of level 9 appears at %."), sTown[k]["name"], empty, empty)) && toUpper(GA.W("game_message_hero", 2, empty))
end GA.HeroArrives

on GA.End pWinner
   put true into sOver
   if pWinner is 1 then
      GA.Say toUpper(GA.W("game_message_victory", 1, "You win.") && GA.W("game_message_victory", 3, empty)) && " R: A NEW WORLD"
   else
      GA.Say toUpper(GA.W("game_message_defeat", 1, "You lose.") && GA.W("game_message_defeat", 3, empty)) && " R: A NEW WORLD"
   end if
end GA.End

-------------------------------------------------------------------- clicks: select, then send

on Game.OnClick pX, pY, pButton
   local k
   if sOver or sSheet then exit Game.OnClick
   put GA.TownAt(pX, pY) into k
   if k is empty then
      GA.Select empty
      exit Game.OnClick
   end if
   if sSel is empty then
      if sTown[k]["side"] is 1 then
         GA.Select k
      end if
   else if k is sSel then
      GA.Select empty
   else
      GA.Send sSel, k
      GA.Say GA.W("game_hud_labels", 8, "SENT") && toUpper(sTown[sSel]["name"]) && "->" && toUpper(sTown[k]["name"])
      GA.Select empty
   end if
end Game.OnClick

function GA.TownAt pX, pY
   local k, tXY, d, tBest, tB
   put 28 into tBest
   repeat with k = 1 to sTownCount
      put GA.Proj(sTown[k]["x"], sTown[k]["y"]) into tXY
      if tXY is empty then next repeat
      put abs(word 1 of tXY - pX) + abs(word 2 of tXY - pY) into d
      if d < tBest then
         put d into tBest
         put k into tB
      end if
   end repeat
   return tB
end GA.TownAt

on GA.Select k
   if sSel is not empty and sTown[sSel]["ring"] is not empty then
      Entity.Kill sTown[sSel]["ring"]
      put empty into sTown[sSel]["ring"]
   end if
   put k into sSel
   if k is not empty then
      put Entity.Spawn("GA.Ring", sTown[k]["x"], sTown[k]["y"], kZ, "#FFE060") into sTown[k]["ring"]
      SetObjectRotation sTown[k]["ring"], 1.5708, 0, 0
      GA.Say GA.W("game_hud_labels", 5, "SELECTED") && toUpper(sTown[k]["name"]) & ":" && sTown[k]["people"] && toUpper(GA.Rank(1, sTown[k]["rank"]))
   end if
end GA.Select

function GA.Rank pSide, pRank
   if pSide is 2 then return GA.W("game_rank_labels_other", pRank, "other" && pRank)
   return GA.W("game_rank_labels", pRank, "level" && pRank)
end GA.Rank

-------------------------------------------------------------------- the spreadsheet (Tab)

-- every town as a row; the column names are labels too
on GA.ShowSheet
   local tText, k, tCols, tSide, tGroup, n
   if there is not a field "GASheet" of this card then
      reset the templateField
      create field "GASheet"
      set the lockText of field "GASheet" to true
      set the vScrollbar of field "GASheet" to true
      set the textFont of field "GASheet" to "Courier New"
      set the textSize of field "GASheet" to 12
      set the backgroundColor of field "GASheet" to "#041004"
      set the textColor of field "GASheet" to "#7CFF7C"
      set the tabStops of field "GASheet" to "40,170,330,400,540,600,660"
      set the vGrid of field "GASheet" to true
   end if
   set the rect of field "GASheet" to 8, 112, the width of this card - 8, the height of this card - 40
   set the visible of field "GASheet" to sSheet
   repeat with k = 1 to sTownCount
      GA.LabelTown k
   end repeat
   if not sSheet then exit GA.ShowSheet
   repeat with n = 1 to 8
      put toUpper(GA.W("game_sheet_columns", n, "col" && n)) & tab after tText
   end repeat
   put cr into char -1 of tText
   repeat with k = 1 to sTownCount
      put sTown[k]["side"] into tSide
      put k & tab & sTown[k]["name"] & tab after tText
      if tSide is 0 then
         put GA.W("game_unit_ownership_labels", 1, "nobody") after tText
      else
         put GA.W("game_faction_labels", tSide, "Side" && tSide) after tText
      end if
      put tab & sTown[k]["people"] & tab & GA.Rank(tSide, sTown[k]["rank"]) & tab & sTown[k]["x"] & tab & sTown[k]["y"] & tab & sTown[k]["rumour"] & GA.FocusTag(k) & cr after tText
   end repeat
   put cr & GA.W("game_hud_labels", 4, "TURN") && sNight & tab & GA.W("game_unit_types", 2, "group") & "s moving:" && the number of lines of the keys of sCircle after tText
   set the text of field "GASheet" to tText
end GA.ShowSheet

-------------------------------------------------------------------- the HUD (top of the screen)

on GA.ShowHUD
   local k, tMine, tTheirs, tWords, tP1, tP2
   put 0 into tMine
   put 0 into tTheirs
   put 0 into tP1
   put 0 into tP2
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is 1 then
         add 1 to tMine
         add sTown[k]["people"] to tP1
      end if
      if sTown[k]["side"] is 2 then
         add 1 to tTheirs
         add sTown[k]["people"] to tP2
      end if
   end repeat
   put sNight & "|" & tMine & "|" & tTheirs & "|" & tP1 & "|" & tP2 & "|" & sTheme & "|" & sResearch & "|" & sMyRank & "|" & (sAdvance > 0) into tWords
   if tWords is sHUDWas then exit GA.ShowHUD
   put tWords into sHUDWas
   HUD.Set "GA.Score", GA.W("game_hud_labels", 4, "TURN") && sNight & "    " & GA.W("game_hud_labels", 1, "YOU") && tMine && "(" & tP1 & ", " & toUpper(GA.Rank(1, sMyRank)) & ")    " & \
         GA.W("game_hud_labels", 2, "OTHER") && tTheirs && "(" & tP2 & ", " & toUpper(GA.Rank(2, sOtherRank)) & ")", 10, 118, 12
   if sMyRank < 7 then
      HUD.Set "GA.Econ", "RESEARCH" && sResearch && "OF" && GA.ResearchCost() && "TO" && toUpper(GA.Rank(1, sMyRank + 1)) & "    " & GA.FocusCounts() & "    " & GA.TurnWord(), 10, 136, 11
   else
      HUD.Set "GA.Econ", "RESEARCH COMPLETE    " & GA.FocusCounts() & "    " & GA.TurnWord(), 10, 136, 11
   end if
   HUD.Set "GA.Keys", "ENTER: END TURN   1 2 3: FOCUS   ARROWS WASD: SCROLL   WHEEL + -: ZOOM   H: HOME   " & GA.W("game_hud_labels", 7, "TAB: SHEET   G: WORDS   SPACE: PAUSE") & "   R: NEW WORLD", 10, 172, 9
end GA.ShowHUD

on GA.Say pText
   HUD.Set "GA.Msg", toUpper(pText), 10, 154, 11
end GA.Say

function GA.TurnWord
   if sAdvance > 0 then return "THE NIGHT PLAYS OUT..."
   return "YOUR TURN: ENTER TO END IT"
end GA.TurnWord

-- how many of your towns recruit, study, train
function GA.FocusCounts
   local k, tR, tS, tT
   put 0 into tR
   put 0 into tS
   put 0 into tT
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is not 1 then next repeat
      if sTown[k]["focus"] is "research" then
         add 1 to tS
      else if sTown[k]["focus"] is "train" then
         add 1 to tT
      else
         add 1 to tR
      end if
   end repeat
   return "RECRUIT" && tR && " STUDY" && tS && " TRAIN" && tT
end GA.FocusCounts

-- test helpers: a town of a side, and where it is on screen
function GA.FirstOf pSide
   local k
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is pSide then return k
   end repeat
   return empty
end GA.FirstOf

function GA.ScreenOf k
   return GA.Proj(sTown[k]["x"], sTown[k]["y"])
end GA.ScreenOf

-- test helper: what Tab does
on GA.TestSheet pOn
   put pOn into sSheet
   GA.ShowSheet
end GA.TestSheet

function GA.State
   local k, tMine, tTheirs
   repeat with k = 1 to sTownCount
      if sTown[k]["side"] is 1 then add 1 to tMine
      if sTown[k]["side"] is 2 then add 1 to tTheirs
   end repeat
   return sNight & "|" & sTownCount & "|" & tMine & "|" & tTheirs & "|" & sTheme & "|" & sHero & "|" & sOver & "|res " & sResearch & "|rank " & sMyRank & "|adv " & sAdvance & "|view " & round(sPanX) & "," & round(sPanY) & "," & sZoom
end GA.State

on Game.OnStop
   Engine.SetCam 0, 0, 0
   HUD.Clear
   if there is a field "GASheet" then set the visible of field "GASheet" to false
end Game.OnStop
