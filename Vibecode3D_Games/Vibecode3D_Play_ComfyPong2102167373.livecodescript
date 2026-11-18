######################################################################################
## CARD SCRIPT: "Play.ComfyPong2102167373"   COMFY PONG  (made in ComfyUI, seed 2102167373)
## Put together by the Vibecode3D nodes from LIB_COMFY/parts/cpong: core, court_rings, ball_square, control_keys, control_cpu.
## Paddles: B arrows home, R cpu away, T cpu away. Court rings, ball square x1.
## CONTROLS  Arrows Move  Space Serves   Escape: stop
## RULES     a ball past a goal mouth is a point for the other team. First to 5 wins the
##           level; 3 levels, each one faster.
######################################################################################

## PART core (CPONG): the court, serve, ball flight, paddle faces, points, levels, HUD.
## Always used. The builder adds the config handler (Cpong.Config) and the parts the
## nodes ask for: one court style (Cpong.Decor), one ball shape (Cpong.BallMesh),
## player keys (Cpong.PlayerMove) and/or the computer (Cpong.CpuMove).

global bPaused, bPlaying

local sCfg, sPad, sPadN, sBall, sGoal
local sLevel, sHome, sAway, sOver, sWonAll, sServeT, sTestKeys, sHUDWas, sSpeedNow, sSkillAdd

constant kZ = 300          -- screen scale 300/z: 1 unit = 1 pixel
constant kT = 5            -- half thickness of a paddle

on Game.OnStart
   focus on nothing
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Cpong.Config
   put false into sOver
   Cpong.StartLevel 1
end Game.OnStart

-- the level: ball speed and computer skill grow with it
on Cpong.StartLevel pLevel
   local tM, i, tN
   put pLevel into sLevel
   put 0 into sHome
   put 0 into sAway
   put sCfg["ballSpeed"] * (1 + sCfg["levelGain"] * (pLevel - 1)) into sSpeedNow
   put 0.08 * (pLevel - 1) into sSkillAdd
   Scene.ClearAll
   -- the floor decoration (dim), the walls, the goal mouths: one mesh each
   put Mesh.New() into tM
   Cpong.Decor tM
   if tM["count"] > 0 then
      Mesh.Define "Cpong.Decor", tM
      get Entity.Spawn("Cpong.Decor", 0, sCfg["cy"], kZ + 1, sCfg["decoColor"])
   end if
   put Mesh.New() into tM
   Cpong.Walls tM, false
   Mesh.Define "Cpong.Court", tM
   get Entity.Spawn("Cpong.Court", 0, sCfg["cy"], kZ, sCfg["wallColor"])
   put Mesh.New() into tM
   Cpong.Walls tM, true
   Mesh.Define "Cpong.Goals", tM
   get Entity.Spawn("Cpong.Goals", 0, sCfg["cy"], kZ, sCfg["goalColor"])
   repeat with i = 1 to sPadN
      if sPad[i]["side"] is "L" or sPad[i]["side"] is "R" then
         Mesh.Define "Cpong.Pad" & i, MeshBox(kT * 2, sPad[i]["half"] * 2, 6)
      else
         Mesh.Define "Cpong.Pad" & i, MeshBox(sPad[i]["half"] * 2, kT * 2, 6)
      end if
      put 0 into sPad[i]["pos"]
      put Entity.Spawn("Cpong.Pad" & i, 0, 0, kZ, sPad[i]["color"]) into sPad[i]["key"]
      Cpong.PlacePad i
   end repeat
   Mesh.Define "Cpong.Ball", Cpong.BallMesh(sCfg["ballSize"])
   repeat with tN = 1 to sCfg["ballCount"]
      put Entity.Spawn("Cpong.Ball", 0, sCfg["cy"], kZ, sCfg["ballColor"]) into sBall[tN]["key"]
   end repeat
   Cpong.Serve
end Cpong.StartLevel

-- one edge of the court: walls (pGoals false) or goal mouths (pGoals true)
on Cpong.Walls @pM, pGoals
   local tW, tH
   put sCfg["hw"] into tW
   put sCfg["hh"] into tH
   if (sGoal["T"] is not empty) is pGoals then Cpong.Line pM, -tW, -tH, tW, -tH
   if (sGoal["B"] is not empty) is pGoals then Cpong.Line pM, -tW, tH, tW, tH
   if (sGoal["L"] is not empty) is pGoals then Cpong.Line pM, -tW, -tH, -tW, tH
   if (sGoal["R"] is not empty) is pGoals then Cpong.Line pM, tW, -tH, tW, tH
end Cpong.Walls

-- a wire line in a mesh, flat on the court
on Cpong.Line @pM, pX1, pY1, pX2, pY2
   local tA
   Mesh.AddVertex pM, pX1, pY1, 0
   put the result into tA
   Mesh.AddVertex pM, pX2, pY2, 0
   Mesh.AddLine pM, tA, the result
end Cpong.Line

-- a wire circle of pN sides
on Cpong.Ring @pM, pX, pY, pR, pN
   local i, tA
   repeat with i = 0 to pN - 1
      put i * 2 * pi / pN into tA
      Cpong.Line pM, pX + pR * cos(tA), pY + pR * sin(tA), pX + pR * cos(tA + 2 * pi / pN), pY + pR * sin(tA + 2 * pi / pN)
   end repeat
end Cpong.Ring

-- every ball back to the middle; play starts after a short wait (Space starts it at once)
on Cpong.Serve
   local tN, tSpread, tSign
   put 45 into sServeT
   put empty into sHUDWas
   repeat with tN = 1 to sCfg["ballCount"]
      put 0 into sBall[tN]["x"]
      put (tN - (sCfg["ballCount"] + 1) / 2) * sCfg["ballSize"] * 3 into sBall[tN]["y"]
      put (random(1001) - 501) / 500 * 0.6 into tSpread
      if random(2) = 1 then
         put 1 into tSign
      else
         put -1 into tSign
      end if
      if sCfg["axis"] is "x" then
         put tSign * sSpeedNow into sBall[tN]["dx"]
         put tSpread * sSpeedNow into sBall[tN]["dy"]
      else
         put tSpread * sSpeedNow into sBall[tN]["dx"]
         put tSign * sSpeedNow into sBall[tN]["dy"]
      end if
      Cpong.PlaceBall tN
   end repeat
   repeat with tN = 1 to sPadN
      put (random(2001) - 1001) / 1000 into sPad[tN]["err"]
   end repeat
end Cpong.Serve

function Cpong.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Cpong.Keys

on Cpong.TestKeys pKeys
   put pKeys into sTestKeys
end Cpong.TestKeys

function Cpong.AnyKey pList, pKeys
   local tK
   repeat for each item tK in pList
      if tK is among the items of pKeys then return true
   end repeat
   return false
end Cpong.AnyKey

on Game.OnUpdate
   local tKeys, i
   put Cpong.Keys() into tKeys
   if sOver then
      if 32 is among the items of tKeys then
         put false into sOver
         Cpong.StartLevel 1
      end if
      Cpong.ShowHUD
      exit Game.OnUpdate
   end if
   repeat with i = 1 to sPadN
      if sPad[i]["ctrl"] is "cpu" then
         Cpong.CpuMove i
      else
         Cpong.PlayerMove i, tKeys
      end if
      Cpong.PlacePad i
   end repeat
   if sServeT > 0 then
      subtract 1 from sServeT
      if 32 is among the items of tKeys then put 0 into sServeT
      Cpong.ShowHUD
      exit Game.OnUpdate
   end if
   repeat with i = 1 to sCfg["ballCount"]
      Cpong.MoveBall i
      if sServeT > 0 or sOver then exit repeat
   end repeat
   Cpong.ShowHUD
end Game.OnUpdate

-- keep a paddle on its track and show it there
on Cpong.PlacePad pJ
   local tRoom
   if sPad[pJ]["side"] is "L" or sPad[pJ]["side"] is "R" then
      put sCfg["hh"] - sPad[pJ]["half"] into tRoom
      put max(-tRoom, min(tRoom, sPad[pJ]["pos"])) into sPad[pJ]["pos"]
      SetObjectPosition sPad[pJ]["key"], sPad[pJ]["fx"], sCfg["cy"] + sPad[pJ]["pos"], kZ
   else
      put sCfg["hw"] - sPad[pJ]["half"] into tRoom
      put max(-tRoom, min(tRoom, sPad[pJ]["pos"])) into sPad[pJ]["pos"]
      SetObjectPosition sPad[pJ]["key"], sPad[pJ]["pos"], sCfg["cy"] + sPad[pJ]["fx"], kZ
   end if
end Cpong.PlacePad

on Cpong.PlaceBall pB
   SetObjectPosition sBall[pB]["key"], sBall[pB]["x"], sCfg["cy"] + sBall[pB]["y"], kZ
end Cpong.PlaceBall

on Cpong.MoveBall pB
   local tR, j
   put sCfg["ballSize"] / 2 into tR
   add sBall[pB]["dx"] to sBall[pB]["x"]
   add sBall[pB]["dy"] to sBall[pB]["y"]
   repeat with j = 1 to sPadN
      Cpong.HitPad j, pB, tR
   end repeat
   Cpong.Edges pB, tR
   if sServeT > 0 or sOver then exit Cpong.MoveBall
   Cpong.PlaceBall pB
end Cpong.MoveBall

-- a paddle only meets a ball coming at its face; where it lands sets the angle
on Cpong.HitPad pJ, pB, pR
   local tS, tDir, tN, tAlong, tV, tFace, tSp, tTan
   put sPad[pJ]["side"] into tS
   if tS is "L" or tS is "T" then
      put 1 into tDir
   else
      put -1 into tDir
   end if
   if tS is "L" or tS is "R" then
      put sBall[pB]["x"] into tN
      put sBall[pB]["y"] into tAlong
      put sBall[pB]["dx"] into tV
   else
      put sBall[pB]["y"] into tN
      put sBall[pB]["x"] into tAlong
      put sBall[pB]["dy"] into tV
   end if
   if tV * tDir >= 0 then exit Cpong.HitPad
   put sPad[pJ]["fx"] + tDir * kT into tFace
   -- the ball's leading edge reached the face this step, and not from behind
   if (tN - tDir * pR - tFace) * tDir > 0 then exit Cpong.HitPad
   if (tN - tV - tDir * pR - tFace) * tDir < -2 then exit Cpong.HitPad
   if abs(tAlong - sPad[pJ]["pos"]) > sPad[pJ]["half"] + pR then exit Cpong.HitPad
   put min(sCfg["ballMax"], abs(tV) * sCfg["ballGain"]) into tSp
   put (tAlong - sPad[pJ]["pos"]) / sPad[pJ]["half"] * tSp * 0.8 into tTan
   if tS is "L" or tS is "R" then
      put tFace + tDir * pR into sBall[pB]["x"]
      put tDir * tSp into sBall[pB]["dx"]
      put tTan into sBall[pB]["dy"]
   else
      put tFace + tDir * pR into sBall[pB]["y"]
      put tDir * tSp into sBall[pB]["dy"]
      put tTan into sBall[pB]["dx"]
   end if
   FX.Sparks sBall[pB]["x"], sCfg["cy"] + sBall[pB]["y"], kZ, 5, sPad[pJ]["color"]
end Cpong.HitPad

-- walls bounce the ball; past a goal mouth it is a point
on Cpong.Edges pB, pR
   local tW, tH
   put sCfg["hw"] into tW
   put sCfg["hh"] into tH
   if sBall[pB]["x"] < -tW + pR then
      if sGoal["L"] is empty then
         put -tW + pR into sBall[pB]["x"]
         put abs(sBall[pB]["dx"]) into sBall[pB]["dx"]
      else if sBall[pB]["x"] < -tW - 30 then
         Cpong.Point "L"
         exit Cpong.Edges
      end if
   end if
   if sBall[pB]["x"] > tW - pR then
      if sGoal["R"] is empty then
         put tW - pR into sBall[pB]["x"]
         put -abs(sBall[pB]["dx"]) into sBall[pB]["dx"]
      else if sBall[pB]["x"] > tW + 30 then
         Cpong.Point "R"
         exit Cpong.Edges
      end if
   end if
   if sBall[pB]["y"] < -tH + pR then
      if sGoal["T"] is empty then
         put -tH + pR into sBall[pB]["y"]
         put abs(sBall[pB]["dy"]) into sBall[pB]["dy"]
      else if sBall[pB]["y"] < -tH - 30 then
         Cpong.Point "T"
         exit Cpong.Edges
      end if
   end if
   if sBall[pB]["y"] > tH - pR then
      if sGoal["B"] is empty then
         put tH - pR into sBall[pB]["y"]
         put -abs(sBall[pB]["dy"]) into sBall[pB]["dy"]
      else if sBall[pB]["y"] > tH + 30 then
         Cpong.Point "B"
         exit Cpong.Edges
      end if
   end if
end Cpong.Edges

on Cpong.Point pSide
   if sGoal[pSide] is "home" then
      add 1 to sAway
   else
      add 1 to sHome
   end if
   put empty into sHUDWas
   if sHome >= sCfg["win"] then
      if sLevel >= sCfg["levels"] then
         put true into sOver
         put true into sWonAll
      else
         Cpong.StartLevel sLevel + 1
      end if
      exit Cpong.Point
   end if
   if sAway >= sCfg["win"] then
      put true into sOver
      put false into sWonAll
      exit Cpong.Point
   end if
   Cpong.Serve
end Cpong.Point

on Cpong.ShowHUD
   local tWords
   put sLevel & "|" & sHome & "|" & sAway & "|" & (sServeT > 0) & "|" & sOver into tWords
   if tWords is sHUDWas then exit Cpong.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Cpong.Score", sCfg["title"] & "   HOME" && sHome && "  AWAY" && sAway && "  FIRST TO" && sCfg["win"] && "  LEVEL" && sLevel & "/" & sCfg["levels"], 20, 30, 14
   HUD.Remove "Cpong.Msg"
   if sOver and sWonAll then
      HUD.Set "Cpong.Msg", "ALL LEVELS WON.  SPACE TO PLAY AGAIN", 20, 56, 12
   else if sOver then
      HUD.Set "Cpong.Msg", "MATCH LOST.  SPACE TO PLAY AGAIN", 20, 56, 12
   else if sServeT > 0 then
      HUD.Set "Cpong.Msg", sCfg["help"], 20, 56, 12
   end if
end Cpong.ShowHUD

function Cpong.State
   return sLevel & "|" & sHome & "|" & sAway & "|" & round(sBall[1]["x"]) & "," & round(sBall[1]["y"]) & "|" & (sServeT > 0) & "|" & sOver
end Cpong.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey

## PART court_rings: rings round the centre, out to the nearest wall.
on Cpong.Decor @pM
   local tR, tG
   put max(20, sCfg["grid"]) into tG
   put tG into tR
   repeat while tR < min(sCfg["hw"], sCfg["hh"])
      Cpong.Ring pM, 0, 0, tR, 28
      add tG to tR
   end repeat
end Cpong.Decor

## PART ball_square: the arcade block.
function Cpong.BallMesh pS
   return MeshBox(pS, pS, pS)
end Cpong.BallMesh

## PART control_keys: a player paddle. "arrows": up/down (side paddles) or left/right
## (top and bottom paddles). "wasd": W/S or A/D the same way, for a second player.

on Cpong.PlayerMove pJ, pKeys
   local tLess, tMore, tSide
   put sPad[pJ]["side"] is "L" or sPad[pJ]["side"] is "R" into tSide
   if sPad[pJ]["ctrl"] is "arrows" then
      if tSide then
         put "65362" into tLess
         put "65364" into tMore
      else
         put "65361" into tLess
         put "65363" into tMore
      end if
   else
      if tSide then
         put "119,87" into tLess
         put "115,83" into tMore
      else
         put "97,65" into tLess
         put "100,68" into tMore
      end if
   end if
   if Cpong.AnyKey(tLess, pKeys) then subtract sPad[pJ]["speed"] from sPad[pJ]["pos"]
   if Cpong.AnyKey(tMore, pKeys) then add sPad[pJ]["speed"] to sPad[pJ]["pos"]
end Cpong.PlayerMove

## PART control_cpu: a computer paddle. It watches the ball coming at its face soonest,
## guesses where it will land (walls folded in), and moves there no faster than its speed.
## skill 0..1: how far ahead it looks and how close its guess is; levels add to it.

on Cpong.CpuMove pJ
   local tS, tDir, tB, tN, tV, tAlong, tVA, tT, tBestT, tWant, tLen, tSkill, tSp
   put sPad[pJ]["side"] into tS
   if tS is "L" or tS is "T" then
      put 1 into tDir
   else
      put -1 into tDir
   end if
   if tS is "L" or tS is "R" then
      put sCfg["hh"] into tLen
   else
      put sCfg["hw"] into tLen
   end if
   put min(1, sPad[pJ]["skill"] + sSkillAdd) into tSkill
   put 0 into tWant
   put 999999 into tBestT
   repeat with tB = 1 to sCfg["ballCount"]
      if tS is "L" or tS is "R" then
         put sBall[tB]["x"] into tN
         put sBall[tB]["dx"] into tV
         put sBall[tB]["y"] into tAlong
         put sBall[tB]["dy"] into tVA
      else
         put sBall[tB]["y"] into tN
         put sBall[tB]["dy"] into tV
         put sBall[tB]["x"] into tAlong
         put sBall[tB]["dx"] into tVA
      end if
      if tV * tDir < 0 and (tN - sPad[pJ]["fx"]) * tDir > 0 then
         put abs(tN - sPad[pJ]["fx"]) / abs(tV) into tT
         if tT < tBestT then
            put tT into tBestT
            put tAlong + (Cpong.Fold(tAlong + tVA * tT, tLen) - tAlong) * tSkill into tWant
            add sPad[pJ]["err"] * sPad[pJ]["half"] * (1 - tSkill) to tWant
         end if
      end if
   end repeat
   put sPad[pJ]["speed"] * (0.55 + 0.45 * tSkill) into tSp
   add max(-tSp, min(tSp, tWant - sPad[pJ]["pos"])) to sPad[pJ]["pos"]
end Cpong.CpuMove

-- a straight path folded back between two walls at -pL and pL
function Cpong.Fold pX, pL
   local tP
   put pX + pL into tP
   put tP - 4 * pL * trunc(tP / (4 * pL)) into tP
   if tP < 0 then add 4 * pL to tP
   if tP > 2 * pL then put 4 * pL - tP into tP
   return tP - pL
end Cpong.Fold

## PART config (generated by the Build node)
on Cpong.Config
   put empty into sCfg
   put empty into sPad
   put empty into sGoal
   put "COMFY PONG" into sCfg["title"]
   put "ARROWS MOVE  SPACE SERVES" into sCfg["help"]
   put 413 into sCfg["hw"]
   put 220 into sCfg["hh"]
   put 40 into sCfg["cy"]
   put 77 into sCfg["grid"]
   put "114,225,229" into sCfg["wallColor"]
   put "35,87,89" into sCfg["goalColor"]
   put "45,90,91" into sCfg["decoColor"]
   put "x" into sCfg["axis"]
   put 12 into sCfg["ballSize"]
   put 8.976 into sCfg["ballSpeed"]
   put 1.133 into sCfg["ballGain"]
   put 19.462 into sCfg["ballMax"]
   put 1 into sCfg["ballCount"]
   put "255,255,255" into sCfg["ballColor"]
   put 5 into sCfg["win"]
   put 3 into sCfg["levels"]
   put 0.151 into sCfg["levelGain"]
   put 3 into sPadN
   put "B" into sPad[1]["side"]
   put "arrows" into sPad[1]["ctrl"]
   put "home" into sPad[1]["team"]
   put 35 into sPad[1]["half"]
   put 6.889 into sPad[1]["speed"]
   put 193 into sPad[1]["fx"]
   put 0.481 into sPad[1]["skill"]
   put "204,253,255" into sPad[1]["color"]
   put "R" into sPad[2]["side"]
   put "cpu" into sPad[2]["ctrl"]
   put "away" into sPad[2]["team"]
   put 41 into sPad[2]["half"]
   put 7.791 into sPad[2]["speed"]
   put 388 into sPad[2]["fx"]
   put 0.629 into sPad[2]["skill"]
   put "20,197,204" into sPad[2]["color"]
   put "T" into sPad[3]["side"]
   put "cpu" into sPad[3]["ctrl"]
   put "away" into sPad[3]["team"]
   put 56 into sPad[3]["half"]
   put 7.439 into sPad[3]["speed"]
   put -198 into sPad[3]["fx"]
   put 0.707 into sPad[3]["skill"]
   put "20,197,204" into sPad[3]["color"]
   put "away" into sGoal["R"]
   put "away" into sGoal["T"]
   put "home" into sGoal["B"]
end Cpong.Config
