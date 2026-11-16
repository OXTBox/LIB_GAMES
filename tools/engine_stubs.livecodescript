script "uDeadEngineStubs"
-- Stand-ins for the Vibecode3D engine calls uDead uses, so the game's rules (maps, orders,
-- the dead, the living, winning) can be run and checked with no window and no drawing.
-- Used by tools/headless_play.sh as the stack script under a card holding the game script.
global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch, CenterX, CenterY
global gViewLeft, gViewTop, gViewRight, gViewBottom
local sSerial, sHUD, sSparks

function Engine.Info pKey
   return 33
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
end Engine.ResetCamera

on Engine.SetCam
end Engine.SetCam

on Scene.ClearAll
   put empty into gSceneObjects
   put empty into gObjectTransforms
end Scene.ClearAll

on Particles.Clear
end Particles.Clear

on Collision.ClearRules
end Collision.ClearRules

on HUD.Clear
   put empty into sHUD
end HUD.Clear

on HUD.Set pId, pText
   put pText into sHUD[pId]
end HUD.Set

on HUD.Remove pId
   delete variable sHUD[pId]
end HUD.Remove

function Stub.HUD
   local tOut, tK
   repeat for each key tK in sHUD
      put tK & ": " & sHUD[tK] & cr after tOut
   end repeat
   return tOut
end Stub.HUD

on FX.Sparks
   add 1 to sSparks
end FX.Sparks

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

on Mesh.AddLine @pMesh
   add 1 to pMesh["lineCount"]
end Mesh.AddLine

on Mesh.Define
end Mesh.Define

function MeshBox
   return Mesh.New()
end MeshBox

function Entity.Spawn pMesh
   add 1 to sSerial
   put pMesh into gObjectTransforms[pMesh & "_" & sSerial]["mesh"]
   put pMesh && pMesh & "_" & sSerial & cr after gSceneObjects
   return pMesh & "_" & sSerial
end Entity.Spawn

on Entity.Kill pKey
   delete variable gObjectTransforms[pKey]
end Entity.Kill

on SetObjectPosition
end SetObjectPosition

on SetObjectRotation
end SetObjectRotation

function MeshPyramid
   return Mesh.New()
end MeshPyramid

function MeshPrism
   return Mesh.New()
end MeshPrism

function MeshSphere
   return Mesh.New()
end MeshSphere

function MeshGrid
   return Mesh.New()
end MeshGrid

-- an object's transform: 12 items, the last three its camera-space position (here: in front, centred)
function Xform.Object pKey
   return "1,0,0,0,1,0,0,0,1,0,0,300"
end Xform.Object

function MeshLathe
   return Mesh.New()
end MeshLathe

on SetObjectRotationSpeed
end SetObjectRotationSpeed

on SetObjectVelocity
end SetObjectVelocity

-- the play plane seen straight on (camera at the origin): 1 unit = 1 pixel at z 400
function ProjectVertex pX, pY, pZ
   if pZ <= 0 then return empty
   return (400 + pX * 400 / pZ) && (360 + pY * 400 / pZ)
end ProjectVertex

-- headless runs never read or move a mouse
global gNoMouse
on Stub.NoMouse
   put true into gNoMouse
end Stub.NoMouse
