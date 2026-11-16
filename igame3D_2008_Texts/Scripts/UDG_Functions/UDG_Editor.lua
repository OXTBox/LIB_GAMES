  function UDG_makeDoor() 
  local x,y,z=getCameraInfo(IG3D_POSITION)
  local xa,ya,za=getCameraInfo(IG3D_ROTATION)
  table.insert(gObjectWTFs,"Building_parts/hoteldoor.wtf")
  table.insert(gObjectNames,"door"..#doors+1)
  
 table.insert(gObjectPositions,{x,y,z})
  table.insert(gObjectRotations,{xa,ya,za})
  gObjects[#gObjects+1]={}
  local i = #gObjects
  print(i)
  gObjects[i].cObj = make(ig3d_object,gObjectWTFs[#gObjectWTFs])
  table.insert(doors,gObjects[i])
  	setObjectInfo(gObjects[i].cObj, IG3D_NAME, gObjectNames[i])
	setObjectInfo(gObjects[i].cObj, IG3D_POSITION, {x,y,z})
	setObjectInfo(gObjects[i].cObj, IG3D_ROTATION, {xa,ya,za})
	setObjectInfo(gObjects[i].cObj, IG3D_SIZE, 100,100,100)
	setObjectInfo(gObjects[i].cObj, IG3D_COLL, true)
	setObjectInfo(gObjects[i].cObj, IG3D_HUD, false)
  end 
 
  function UDG_makeScenery() end 
function UDG_makeWoman() end
function UDG_makeMan()  end
  function UDG_makeMan() end
  

function UDG_editor_keys()
char,code,name=input(false)
--if key(311,"-") or key(462,"-") then
  if key("1","-") then UDG_makeDoor()  
  elseif key("2","-") then UDG_makeScenery() 
  elseif key("3","-") then UDG_makeWoman()
  elseif key("4","-") then UDG_makeMan() 
  elseif key("5","-") then UDG_makeMan()  
  end
--end
end

