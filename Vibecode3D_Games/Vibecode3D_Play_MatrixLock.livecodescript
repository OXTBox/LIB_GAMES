######################################################################################
## CARD SCRIPT: "Play.MatrixLock"   MATRIX LOCK  (11 13 2026)
## The owner's concept (round two, 7 of 9): a figure stands on a grid floor while 3D
## wireframe shapes made of cubes drop from above, one at a time. Walk out of the way and
## rotate the falling shape. Shapes stay where they land; a filled row of the floor clears.
## Teaches: grids in 3D, rotation, a shadow showing where a thing will land.
## CONTROLS  Arrows or WASD: step   Space: rotate the falling shape   Escape: stop
## RULES     a shape landing on you, or being walled in with no free cell to step to,
##           costs a life. Clear the rows the level asks for. 5 levels.
######################################################################################

global bPaused, bPlaying

local sOcc, sPC, sPR, sPlayer, sShape, sFoot, sFC, sFR, sFallY, sShadow
local sLevel, sLives, sCleared, sNeed, sFall, sKinds, sOver, sWon, sTicks, sTestKeys, sKeysWas
local sHUDWas, sMsg, sMsgUntil, sWait

constant kN = 8                -- the floor is kN x kN cells
constant kS = 50               -- a cell (and a cube), in engine units
constant kStartY = 9           -- shapes start this many cubes up
-- footprints, cells "c,r" relative: I3, O, T, L, S, a pair, a single
constant kShapes = "0,0 1,0 2,0|0,0 1,0 0,1 1,1|0,0 1,0 2,0 1,1|0,0 0,1 0,2 1,2|0,0 1,0 1,1 2,1|0,0 1,0|0,0"

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Camera.Reset
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Camera.SetPosition 0, -470, -380
   Camera.SetLook 0, -atan2(470, 440)
   put 1 into sLevel
   put false into sOver
   put false into sWon
   put 0 into sTicks
   Lock.StartLevel
end Game.OnStart

-- level table: fall speed (cubes a step) | rows to clear | shape kinds | lives
function Lock.Row pLevel
   return line pLevel of ("0.05,2,3,3" & cr & "0.06,3,4,3" & cr & "0.07,4,5,3" & cr & "0.085,5,6,3" & cr & "0.1,6,7,3")
end Lock.Row

on Lock.StartLevel
   local tRow
   put Lock.Row(sLevel) into tRow
   put item 1 of tRow into sFall
   put item 2 of tRow into sNeed
   put item 3 of tRow into sKinds
   if sLevel is 1 or sLives is empty then put item 4 of tRow into sLives
   put 0 into sCleared
   Scene.ClearAll
   put empty into sOcc
   put empty into sShape
   put empty into sShadow
   Mesh.Define "Lock.Floor", Mesh.Grid(kN, kN, kS)
   get Entity.Spawn("Lock.Floor", 0, 0, 0, "#1C4A2A")
   Mesh.Define "Lock.Cube", Mesh.Box(kS - 4, kS - 4, kS - 4)
   Mesh.Define "Lock.Man", Lock.ManMesh()
   put 3 into sPC
   put 6 into sPR
   put Entity.Spawn("Lock.Man", Lock.X(sPC), 0, Lock.Z(sPR), "#40E0FF") into sPlayer
   put 40 into sWait
   Lock.Say "LEVEL" && sLevel & ": CLEAR" && sNeed && "ROWS", 3
   put empty into sHUDWas
end Lock.StartLevel

function Lock.X c
   return (c - (kN - 1) / 2) * kS
end Lock.X

function Lock.Z r
   return ((kN - 1) / 2 - r) * kS
end Lock.Z

function Lock.ManMesh
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, 0, -40, 0
   Mesh.AddVertex tM, 0, -30, 0
   Mesh.AddVertex tM, 0, -16, 0
   Mesh.AddVertex tM, -8, 0, 0
   Mesh.AddVertex tM, 8, 0, 0
   Mesh.AddVertex tM, -10, -20, 0
   Mesh.AddVertex tM, 10, -20, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 4
   Mesh.AddLine tM, 3, 5
   Mesh.AddLine tM, 2, 6
   Mesh.AddLine tM, 2, 7
   return tM
end Lock.ManMesh

-- a footprint as cubes (one mesh), or as flat squares on the floor (the shadow)
function Lock.FootMesh pFoot, pFlat
   local tM, tCell, x, z, h, tB, y1, y2
   put Mesh.New() into tM
   put (kS - 4) / 2 into h
   repeat for each word tCell in pFoot
      put item 1 of tCell * kS into x
      put -item 2 of tCell * kS into z
      put tM["count"] into tB
      if pFlat then
         Mesh.AddVertex tM, x - h, -2, z - h
         Mesh.AddVertex tM, x + h, -2, z - h
         Mesh.AddVertex tM, x + h, -2, z + h
         Mesh.AddVertex tM, x - h, -2, z + h
         Mesh.AddLine tM, tB + 1, tB + 2
         Mesh.AddLine tM, tB + 2, tB + 3
         Mesh.AddLine tM, tB + 3, tB + 4
         Mesh.AddLine tM, tB + 4, tB + 1
         Mesh.AddLine tM, tB + 1, tB + 3
      else
         put -2 into y1
         put -kS + 2 into y2
         Mesh.AddVertex tM, x - h, y1, z - h
         Mesh.AddVertex tM, x + h, y1, z - h
         Mesh.AddVertex tM, x + h, y1, z + h
         Mesh.AddVertex tM, x - h, y1, z + h
         Mesh.AddVertex tM, x - h, y2, z - h
         Mesh.AddVertex tM, x + h, y2, z - h
         Mesh.AddVertex tM, x + h, y2, z + h
         Mesh.AddVertex tM, x - h, y2, z + h
         Mesh.AddLine tM, tB + 1, tB + 2
         Mesh.AddLine tM, tB + 2, tB + 3
         Mesh.AddLine tM, tB + 3, tB + 4
         Mesh.AddLine tM, tB + 4, tB + 1
         Mesh.AddLine tM, tB + 5, tB + 6
         Mesh.AddLine tM, tB + 6, tB + 7
         Mesh.AddLine tM, tB + 7, tB + 8
         Mesh.AddLine tM, tB + 8, tB + 5
         Mesh.AddLine tM, tB + 1, tB + 5
         Mesh.AddLine tM, tB + 2, tB + 6
         Mesh.AddLine tM, tB + 3, tB + 7
         Mesh.AddLine tM, tB + 4, tB + 8
      end if
   end repeat
   return tM
end Lock.FootMesh

-------------------------------------------------------------------- shapes

-- a new shape over the floor: half the time over the figure, so it has to move
on Lock.NewShape
   local tFoot, tW, tH, tCell
   set the itemDel to "|"
   put item random(sKinds) of kShapes into tFoot
   set the itemDel to comma
   put tFoot into sFoot
   repeat random(4) - 1 times
      Lock.RotateFoot
   end repeat
   Lock.FootSize sFoot, tW, tH
   if random(2) is 1 then
      put max(0, min(kN - tW, sPC - random(tW) + 1)) into sFC
      put max(0, min(kN - tH, sPR - random(tH) + 1)) into sFR
   else
      put random(kN - tW + 1) - 1 into sFC
      put random(kN - tH + 1) - 1 into sFR
   end if
   put kStartY into sFallY
   Lock.DrawShape
end Lock.NewShape

on Lock.FootSize pFoot, @pW, @pH
   local tCell
   put 0 into pW
   put 0 into pH
   repeat for each word tCell in pFoot
      put max(pW, item 1 of tCell + 1) into pW
      put max(pH, item 2 of tCell + 1) into pH
   end repeat
end Lock.FootSize

-- a quarter turn: (c,r) -> (r, -c), then moved back to start at 0,0
on Lock.RotateFoot
   local tCell, tOut, tMinC, tMinR, c, r
   put 99 into tMinC
   put 99 into tMinR
   repeat for each word tCell in sFoot
      put item 2 of tCell into c
      put -item 1 of tCell into r
      put c & comma & r & space after tOut
      put min(tMinC, c) into tMinC
      put min(tMinR, r) into tMinR
   end repeat
   put empty into sFoot
   repeat for each word tCell in tOut
      put (item 1 of tCell - tMinC) & comma & (item 2 of tCell - tMinR) & space after sFoot
   end repeat
   delete char -1 of sFoot
end Lock.RotateFoot

on Lock.DrawShape
   local tW, tH
   if sShape is not empty then Entity.Kill sShape
   if sShadow is not empty then Entity.Kill sShadow
   Mesh.Define "Lock.Shape", Lock.FootMesh(sFoot, false)
   Mesh.Define "Lock.Shadow", Lock.FootMesh(sFoot, true)
   put Entity.Spawn("Lock.Shape", Lock.X(sFC), -sFallY * kS, Lock.Z(sFR), "#FF60D0") into sShape
   put Entity.Spawn("Lock.Shadow", Lock.X(sFC), 0, Lock.Z(sFR), "#5A2050") into sShadow
end Lock.DrawShape

-- where the shape will rest: on the highest cube under its footprint
function Lock.RestLevel
   local tCell, tTop, c, r
   put 0 into tTop
   repeat for each word tCell in sFoot
      put sFC + item 1 of tCell into c
      put sFR + item 2 of tCell into r
      put max(tTop, Lock.Height(c, r)) into tTop
   end repeat
   return tTop
end Lock.RestLevel

function Lock.Height c, r
   local l
   -- the highest filled level + 1 (gaps under a shape stay gaps)
   repeat with l = 12 down to 0
      if sOcc[c][r][l] is not empty then return l + 1
   end repeat
   return 0
end Lock.Height

on Lock.Land
   local tL, tCell, c, r, tHit
   put Lock.RestLevel() into tL
   Entity.Kill sShape
   Entity.Kill sShadow
   put empty into sShape
   put empty into sShadow
   put false into tHit
   repeat for each word tCell in sFoot
      put sFC + item 1 of tCell into c
      put sFR + item 2 of tCell into r
      put Entity.Spawn("Lock.Cube", Lock.X(c), -(tL + 0.5) * kS, Lock.Z(r), "#FF60D0") into sOcc[c][r][tL]
      if tL is 0 and c is sPC and r is sPR then put true into tHit
   end repeat
   FX.Sparks Lock.X(sFC), -tL * kS, Lock.Z(sFR), 6, "#FF60D0"
   if tHit then
      Lock.LoseLife "A SHAPE LANDED ON YOU"
      exit Lock.Land
   end if
   Lock.ClearRows
   if Lock.WalledIn() then Lock.LoseLife "WALLED IN"
end Lock.Land

-- a row of the floor with a cube on every cell clears; what stood on it drops a level
on Lock.ClearRows
   local r, c, tFull, l
   repeat with r = 0 to kN - 1
      put true into tFull
      repeat with c = 0 to kN - 1
         if sOcc[c][r][0] is empty then
            put false into tFull
            exit repeat
         end if
      end repeat
      if not tFull then next repeat
      repeat with c = 0 to kN - 1
         Entity.Kill sOcc[c][r][0]
         FX.Sparks Lock.X(c), -kS / 2, Lock.Z(r), 4, "#FFE060"
         repeat with l = 1 to 12
            put sOcc[c][r][l] into sOcc[c][r][l - 1]
            if sOcc[c][r][l - 1] is not empty then Entity.SetPosition sOcc[c][r][l - 1], Lock.X(c), -(l - 0.5) * kS, Lock.Z(r)
         end repeat
         put empty into sOcc[c][r][12]
      end repeat
      add 1 to sCleared
      put empty into sHUDWas
      if sCleared >= sNeed then
         if sLevel >= 5 then
            put true into sOver
            put true into sWon
         else
            add 1 to sLevel
            Lock.StartLevel
         end if
         exit Lock.ClearRows
      end if
   end repeat
end Lock.ClearRows

function Lock.Free c, r
   if c < 0 or r < 0 or c >= kN or r >= kN then return false
   return sOcc[c][r][0] is empty
end Lock.Free

function Lock.WalledIn
   if Lock.Free(sPC + 1, sPR) or Lock.Free(sPC - 1, sPR) or Lock.Free(sPC, sPR + 1) or Lock.Free(sPC, sPR - 1) then return false
   return true
end Lock.WalledIn

on Lock.LoseLife pWhy
   local c, r, l
   FX.Sparks Lock.X(sPC), -20, Lock.Z(sPR), 30, "#40E0FF"
   subtract 1 from sLives
   put empty into sHUDWas
   if sLives <= 0 then
      put true into sOver
      Lock.Say pWhy, 999
      exit Lock.LoseLife
   end if
   -- the floor is wiped; the rows cleared so far count
   repeat for each key c in sOcc
      repeat for each key r in sOcc[c]
         repeat for each key l in sOcc[c][r]
            if sOcc[c][r][l] is not empty then Entity.Kill sOcc[c][r][l]
         end repeat
      end repeat
   end repeat
   put empty into sOcc
   put 40 into sWait
   Lock.Say pWhy & ".  THE FLOOR IS WIPED", 3
end Lock.LoseLife

-------------------------------------------------------------------- the loop

function Lock.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Lock.Keys

on Lock.TestKeys pKeys
   put pKeys into sTestKeys
end Lock.TestKeys

function Lock.Pressed pKey, pKeys
   return pKey is among the items of pKeys and not (pKey is among the items of sKeysWas)
end Lock.Pressed

on Game.OnUpdate
   local tKeys, tW, tH, dc, dr
   add 1 to sTicks
   put Lock.Keys() into tKeys
   if sOver then
      if Lock.Pressed(32, tKeys) then Game.OnStart
      put tKeys into sKeysWas
      exit Game.OnUpdate
   end if
   -- one step a press (held: one every 6 steps)
   put 0 into dc
   put 0 into dr
   if (65361 is among the items of tKeys or 97 is among the items of tKeys) then put -1 into dc
   if (65363 is among the items of tKeys or 100 is among the items of tKeys) then put 1 into dc
   if (65362 is among the items of tKeys or 119 is among the items of tKeys) then put -1 into dr
   if (65364 is among the items of tKeys or 115 is among the items of tKeys) then put 1 into dr
   if (dc is not 0 or dr is not 0) and (Lock.Pressed(65361, tKeys) or Lock.Pressed(97, tKeys) or Lock.Pressed(65363, tKeys) or Lock.Pressed(100, tKeys) or Lock.Pressed(65362, tKeys) or Lock.Pressed(119, tKeys) or Lock.Pressed(65364, tKeys) or Lock.Pressed(115, tKeys) or sTicks mod 6 is 0) then
      if dc is not 0 and Lock.Free(sPC + dc, sPR) then add dc to sPC
      if dr is not 0 and Lock.Free(sPC, sPR + dr) then add dr to sPR
      Entity.SetPosition sPlayer, Lock.X(sPC), 0, Lock.Z(sPR)
      Entity.SetRotation sPlayer, 0, atan2(dc, -dr), 0
   end if
   if Lock.Pressed(32, tKeys) and sShape is not empty then
      Lock.RotateFoot
      Lock.FootSize sFoot, tW, tH
      put min(sFC, kN - tW) into sFC
      put min(sFR, kN - tH) into sFR
      Lock.DrawShape
   end if
   put tKeys into sKeysWas
   if sWait > 0 then
      subtract 1 from sWait
   else if sShape is empty then
      Lock.NewShape
   else
      subtract sFall from sFallY
      if sFallY <= Lock.RestLevel() then
         Lock.Land
      else
         Entity.SetPosition sShape, Lock.X(sFC), -sFallY * kS, Lock.Z(sFR)
      end if
   end if
   Lock.ShowHUD
end Game.OnUpdate

on Lock.Say pText, pSeconds
   put pText into sMsg
   put sTicks + pSeconds * 30 into sMsgUntil
   put empty into sHUDWas
end Lock.Say

on Lock.ShowHUD
   local tWords
   if sMsg is not empty and sTicks > sMsgUntil then put empty into sMsg
   put sLevel & "|" & sLives & "|" & sCleared & "|" & sMsg & "|" & sOver into tWords
   if tWords is sHUDWas then exit Lock.ShowHUD
   put tWords into sHUDWas
   HUD.Set "Lock.Score", "ROWS" && sCleared && "OF" && sNeed && "  LIVES" && sLives && "  LEVEL" && sLevel && "   ARROWS STEP  SPACE ROTATES", 20, 120, 14
   HUD.Remove "Lock.Msg"
   if sOver and sWon then
      HUD.Set "Lock.Msg", "THE MATRIX IS UNLOCKED.  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sOver then
      HUD.Set "Lock.Msg", sMsg & ".  SPACE TO PLAY AGAIN", 20, 142, 14
   else if sMsg is not empty then
      HUD.Set "Lock.Msg", sMsg, 20, 142, 14
   end if
end Lock.ShowHUD

function Lock.State
   return sLevel & "|" & sLives & "|" & sCleared & "/" & sNeed & "|" & sPC & "," & sPR & "|" & (sShape is not empty) & "|" & round(sFallY, 1) & "|" & sOver
end Lock.State

on Game.OnStop
   HUD.Clear
end Game.OnStop

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
