script "EngineContractStubs"
-- Stand-ins for the engine, so a game's rules can be run and checked with no window and no
-- drawing. Line 1 is dropped by the tests; the rest becomes the stack script under a card
-- that holds the game script (tools/headless_play.sh, OXT-BEYOND/tests).
--
-- The CONTRACT part holds one stand-in for every call in LIB_ig3d/ENGINE_CONTRACT.md that the
-- XT engine has today, and nothing else: a game that passes here calls only the contract.
-- A call the contract plans but XT lacks has no stand-in on purpose: a test must stop where
-- the real engine would.
-- Check it:  python3 -I LIB_ig3d/tools/contract_check.py --stubs
--
-- What the stand-ins keep true: an object exists from Entity.Spawn to Entity.Kill; a position,
-- rotation or speed that is set can be read back; HUD lines can be read (Stub.HUD).
-- What they do not do: move anything, detect collisions, build real shapes (the Mesh... makers
-- return a mesh with no points) or draw.
global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch, CenterX, CenterY
global gViewLeft, gViewTop, gViewRight, gViewBottom
global bPlaying, bPaused, gNoMouse
local sSerial, sHUD, sSparks, sMeshes, sRules, sCam, sParticles, sPreset

-- == CONTRACT ==

------------------------------------------------------------------ engine and camera

function Engine.Info pKey
   switch pKey
      case "stepMS"
         return 33
      case "simTick"
         return 0
      case "projection"
         return "400,400,300"
      case "fps"
         return 30
      case "edges"
         return 0
      case "playing"
         return true
      case "paused"
         return (bPaused is true)
      case "edition"
         return "XT"
   end switch
   return empty
end Engine.Info

on Engine.ResetCamera
   put 0 into gCameraYaw
   put 0 into gCameraPitch
   put 400 into CenterX
   put 300 into CenterY
   put 0 into gViewLeft
   put 0 into gViewTop
   put 800 into gViewRight
   put 600 into gViewBottom
   put "0,0,0" into sCam
end Engine.ResetCamera

on Engine.SetCam pX, pY, pZ
   if pX is a number then put pX into item 1 of sCam
   if pY is a number then put pY into item 2 of sCam
   if pZ is a number then put pZ into item 3 of sCam
end Engine.SetCam

-- a point on the screen dropped onto the floor: here the floor seen from straight above,
-- one unit a pixel, the view's centre over the origin
function Engine.ScreenToFloor pX, pY, pFloorY
   if pX is not a number or pY is not a number then return empty
   return (pX - 400) && (300 - pY)
end Engine.ScreenToFloor

on View.UsePreset pName
   put pName into sPreset
end View.UsePreset

function View.NextPreset
   return "1983"
end View.NextPreset

on Game.Exit
   dispatch "Game.OnStop" to this card
   put false into bPlaying
end Game.Exit

------------------------------------------------------------------ scene

on Scene.ClearAll
   put empty into gSceneObjects
   put empty into gObjectTransforms
end Scene.ClearAll

function Scene.Has pKey
   local tLine
   repeat for each line tLine in gSceneObjects
      if word 2 of tLine is pKey then return true
   end repeat
   return false
end Scene.Has

on Scene.SetBob pObj, pAmp, pRoll, pSpeed
end Scene.SetBob

on Scene.SetBounds pKey, pBounds
end Scene.SetBounds

------------------------------------------------------------------ meshes

function Mesh.New
   local tM
   put 0 into tM["count"]
   put 0 into tM["lineCount"]
   return tM
end Mesh.New

on Mesh.AddVertex @pMesh
   add 1 to pMesh["count"]
   return pMesh["count"]
end Mesh.AddVertex

on Mesh.AddFace @pMesh
   add 1 to pMesh["faceCount"]
end Mesh.AddFace

on Mesh.AddLine @pMesh
   add 1 to pMesh["lineCount"]
end Mesh.AddLine

on Mesh.Define pName, pMesh
   put pMesh into sMeshes[pName]
end Mesh.Define

function Mesh.Get pName
   return sMeshes[pName]
end Mesh.Get

function Mesh.Transform pMesh
   return pMesh
end Mesh.Transform

function Mesh.Merge pA, pB
   add pB["count"] to pA["count"]
   add pB["lineCount"] to pA["lineCount"]
   add pB["faceCount"] to pA["faceCount"]
   return pA
end Mesh.Merge

function MeshBox
   return Mesh.New()
end MeshBox

function MeshPrism
   return Mesh.New()
end MeshPrism

function MeshPyramid
   return Mesh.New()
end MeshPyramid

function MeshLathe
   return Mesh.New()
end MeshLathe

function MeshSphere
   return Mesh.New()
end MeshSphere

function MeshLoft
   return Mesh.New()
end MeshLoft

function MeshExtrude
   return Mesh.New()
end MeshExtrude

function MeshGrid
   return Mesh.New()
end MeshGrid

------------------------------------------------------------------ entities

function Entity.Spawn pMesh, pX, pY, pZ, pColor
   local tId
   add 1 to sSerial
   put pMesh & "_" & sSerial into tId
   SetObjectPosition tId, pX, pY, pZ
   put pMesh into gObjectTransforms[tId]["mesh"]
   if pColor is empty then put "white" into pColor
   put pColor into gObjectTransforms[tId]["color"]
   if gSceneObjects is empty then
      put pMesh && tId into gSceneObjects
   else
      put cr & pMesh && tId after gSceneObjects
   end if
   return tId
end Entity.Spawn

on Entity.Kill pId
   local tLine, tKeep
   if pId is empty then exit Entity.Kill
   repeat for each line tLine in gSceneObjects
      if word 2 of tLine is not pId then put tLine & cr after tKeep
   end repeat
   delete the last char of tKeep
   put tKeep into gSceneObjects
   delete variable gObjectTransforms[pId]
end Entity.Kill

function Entity.Count pMesh
   local tLine, tN
   put 0 into tN
   repeat for each line tLine in gSceneObjects
      if word 1 of tLine is pMesh then add 1 to tN
   end repeat
   return tN
end Entity.Count

on SetObjectPosition pObj, pX, pY, pZ
   if pObj is empty then exit SetObjectPosition
   if pX is empty then put 0 into pX
   if pY is empty then put 0 into pY
   if pZ is empty then put 0 into pZ
   put pX into gObjectTransforms[pObj]["x"]
   put pY into gObjectTransforms[pObj]["y"]
   put pZ into gObjectTransforms[pObj]["z"]
end SetObjectPosition

function GetObjectPosition pObj, pAxis
   if pAxis is not empty then return gObjectTransforms[pObj][pAxis]
   return gObjectTransforms[pObj]["x"], gObjectTransforms[pObj]["y"], gObjectTransforms[pObj]["z"]
end GetObjectPosition

on SetObjectRotation pObj, pX, pY, pZ
   if pObj is empty then exit SetObjectRotation
   put pX into gObjectTransforms[pObj]["rotX"]
   put pY into gObjectTransforms[pObj]["rotY"]
   put pZ into gObjectTransforms[pObj]["rotZ"]
end SetObjectRotation

function GetObjectRotation pObj
   return Stub.Three(gObjectTransforms[pObj]["rotX"], gObjectTransforms[pObj]["rotY"], gObjectTransforms[pObj]["rotZ"])
end GetObjectRotation

on SetObjectRotationSpeed pObj, pX, pY, pZ
   if pObj is empty then exit SetObjectRotationSpeed
   put pX into gObjectTransforms[pObj]["rotSpeedX"]
   put pY into gObjectTransforms[pObj]["rotSpeedY"]
   put pZ into gObjectTransforms[pObj]["rotSpeedZ"]
end SetObjectRotationSpeed

function GetObjectRotationSpeed pObj
   return Stub.Three(gObjectTransforms[pObj]["rotSpeedX"], gObjectTransforms[pObj]["rotSpeedY"], gObjectTransforms[pObj]["rotSpeedZ"])
end GetObjectRotationSpeed

on SetObjectVelocity pObj, pX, pY, pZ
   if pObj is empty then exit SetObjectVelocity
   if pX is empty then put 0 into pX
   if pY is empty then put 0 into pY
   if pZ is empty then put 0 into pZ
   put pX into gObjectTransforms[pObj]["vx"]
   put pY into gObjectTransforms[pObj]["vy"]
   put pZ into gObjectTransforms[pObj]["vz"]
end SetObjectVelocity

function GetObjectVelocity pObj, pAxis
   if pAxis is not empty then return gObjectTransforms[pObj][pAxis]
   return gObjectTransforms[pObj]["vx"], gObjectTransforms[pObj]["vy"], gObjectTransforms[pObj]["vz"]
end GetObjectVelocity

------------------------------------------------------------------ HUD

on HUD.Clear
   put empty into sHUD
end HUD.Clear

on HUD.Set pId, pText
   put pText into sHUD[pId]
end HUD.Set

on HUD.Remove pId
   delete variable sHUD[pId]
end HUD.Remove

------------------------------------------------------------------ particles and effects

on Particles.Clear
   put 0 into sParticles
end Particles.Clear

on Particles.Add
   add 1 to sParticles
end Particles.Add

function Particles.Count
   return sParticles + 0
end Particles.Count

on FX.Sparks
   add 1 to sSparks
end FX.Sparks

-- the object bursts and is gone
on FX.Explode pKey
   Entity.Kill pKey
end FX.Explode

on FX.Destroy pKey
   Entity.Kill pKey
end FX.Destroy

------------------------------------------------------------------ collisions, weapon, sound

on Collision.SetGroup pKey, pGroup, pRadius
   put pGroup into gObjectTransforms[pKey]["group"]
   if pRadius is a number then put pRadius into gObjectTransforms[pKey]["radius"]
end Collision.SetGroup

on Collision.AddRule pGroupA, pGroupB
   put pGroupA && pGroupB & cr after sRules
end Collision.AddRule

on Collision.ClearRules
   put empty into sRules
end Collision.ClearRules

-- the laser hits nothing here
on Weapon.FireAt pScreenX, pScreenY
   return empty
end Weapon.FireAt

on Sound.Play pType
end Sound.Play

------------------------------------------------------------------ added 18 Nov (A-93, A-96)
-- The contract's calls written under their final names (LIB_ig3d/livecode/contract_calls).

on Camera.SetLook pYaw, pPitch, pRoll
   global gCameraRoll
   if pYaw is a number then put pYaw into gCameraYaw
   if pPitch is a number then put pPitch into gCameraPitch
   if pRoll is a number then put pRoll into gCameraRoll
end Camera.SetLook

-- an unturned camera at the origin, as Engine.Info("projection") says: k 400, centre 400,300
function Camera.WorldToScreen pX, pY, pZ
   if pX is not a number or pY is not a number or pZ is not a number then return empty
   if pZ < 1 then return empty
   return (400 + pX * 400 / pZ) & comma & (300 + pY * 400 / pZ)
end Camera.WorldToScreen

function Scene.Objects pMesh
   local tLine, tOut
   repeat for each line tLine in gSceneObjects
      if pMesh is empty or word 1 of tLine is pMesh then put word 2 of tLine & cr after tOut
   end repeat
   delete the last char of tOut
   return tOut
end Scene.Objects

on Entity.SetMesh pId, pMesh
   local tLine, tOut, tFound
   if not Mesh.Has(pMesh) then return "Entity.SetMesh: no mesh" && pMesh
   put false into tFound
   repeat for each line tLine in gSceneObjects
      if word 2 of tLine is pId and pId is not empty then
         put pMesh into word 1 of tLine
         put true into tFound
      end if
      put tLine & cr after tOut
   end repeat
   if not tFound then return "Entity.SetMesh: no object" && pId
   delete the last char of tOut
   put tOut into gSceneObjects
   put pMesh into gObjectTransforms[pId]["mesh"]
   return empty
end Entity.SetMesh

on Entity.SetColor pId, pColor
   if pColor is empty then return "Entity.SetColor: no colour"
   if not Scene.Has(pId) then return "Entity.SetColor: no object" && pId
   put pColor into gObjectTransforms[pId]["color"]
   return empty
end Entity.SetColor

on Entity.Set pId, pProp, pValue
   if not Scene.Has(pId) then return "Entity.Set: no object" && pId
   if pProp is not among the items of "hp,ttl,radius" then return "Entity.Set: not a property:" && pProp & " (hp, ttl, radius)"
   if pValue is empty and pProp is not "radius" then
      delete variable gObjectTransforms[pId][pProp]
      return empty
   end if
   if pValue is not a number then return "Entity.Set:" && pProp && "takes a number"
   put pValue into gObjectTransforms[pId][pProp]
   return empty
end Entity.Set

function Entity.Get pId, pProp
   if not Scene.Has(pId) then return empty
   if pProp is not among the items of "hp,ttl,radius,mesh,group,color" then return empty
   return gObjectTransforms[pId][pProp]
end Entity.Get

function Mesh.Has pName
   if pName is empty then return false
   return pName is among the keys of sMeshes
end Mesh.Has

-- no optional parts in a headless run
function Engine.Has pFeature
   return false
end Engine.Has

-- the mouse resting in the middle of the view, button up; empty under Stub.NoMouse
function Engine.Mouse
   if gNoMouse is true then return empty
   return "400,300,false"
end Engine.Mouse

-- the projects folder only (a test runs from WSL)
function Game.FindFile pPath
   local tTry
   if pPath is empty then return empty
   put "/home/igame3d/projects/" & pPath into tTry
   if there is a file tTry then return tTry
   return empty
end Game.FindFile

-- == DEBTS ==
-- Engine internals that games under test still reach into (ENGINE_CONTRACT.md, "Debts").
-- Delete each one when its games are fixed; add none.

-- an object's transform: 12 items, the last three its camera-space position (here: in front, centred)
-- (Antack, AntackFresh)
function Xform.Object pKey
   return "1,0,0,0,1,0,0,0,1,0,0,300"
end Xform.Object

-- the play plane seen straight on (camera at the origin): 1 unit = 1 pixel at z 400
-- (ProbeVsCone, Thrmnlra, GeneticAnomaly)
function ProjectVertex pX, pY, pZ
   if pZ <= 0 then return empty
   return (400 + pX * 400 / pZ) && (360 + pY * 400 / pZ)
end ProjectVertex

-- == TEST HOOKS ==

-- the HUD as text, one "id: text" a line
function Stub.HUD
   local tOut, tK
   repeat for each key tK in sHUD
      put tK & ": " & sHUD[tK] & cr after tOut
   end repeat
   return tOut
end Stub.HUD

-- headless runs never read or move a mouse
on Stub.NoMouse
   put true into gNoMouse
end Stub.NoMouse

-- three numbers, empty read as 0 (as the engine's Get... calls answer)
function Stub.Three pA, pB, pC
   if pA is not a number then put 0 into pA
   if pB is not a number then put 0 into pB
   if pC is not a number then put 0 into pC
   return pA, pB, pC
end Stub.Three
