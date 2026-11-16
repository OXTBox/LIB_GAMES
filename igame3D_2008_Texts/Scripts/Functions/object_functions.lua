

function makedefaultSquare()

selected_object=make(ig3d_object, "Billboards/square.wtf")
setObjectInfo(selected_object, IG3D_ROTATION, 90,0,0)
setObjectInfo(selected_object, IG3D_POSITION, 0,0,-1.)
setObjectInfo(selected_object, IG3D_SIZE, 40,20,40)
end



function RND_pushObject(selectedobject)
if selectedobject==nil then
selectedobject=gObjects[1].cObj
end
a11,a12,a13,a14, a21,a22,a23,a24, a31,a32,a33,a34, a41,a42,a43,a44=getObjectInfo(selectedobject, IG3D_ROTATION_MATRIX)
dreh=0
krafthoch=0
kraftvorn=0

keyRandom = math.random(1,10)

if keyRandom==1 then
krafthoch=4
dreh=8
end

if keyRandom==2 then
dreh=-4
krafthoch=8
end

if keyRandom==4 then
kraftvorn=13
krafthoch=4
setObjectInfo(selectedobject, IG3D_OMEGA, 0)
dreh=0
end

if keyRandom==5 then
kraftvorn=4
krafthoch=13
setObjectInfo(selectedobject, IG3D_OMEGA, 0)
dreh=0
end

if keyRandom==6 then
krafthoch=-11
kraftvorn=2
setObjectInfo(selectedobject, IG3D_OMEGA, 0)
dreh=0
end
setObjectInfo(selectedobject,IG3D_FORCE, a31*kraftvorn, a32*kraftvorn+krafthoch, a33*kraftvorn)
setObjectInfo(selectedobject,IG3D_TORQUE, a21*dreh, a22*dreh, a23*dreh)
setObjectInfo(selectedobject,IG3D_VECTOR_CONSTRAINT, 0,1,0)
end




arrayObjects={}

function createBlockarray(wtfFile)if wtfFile == nil then wtfFile= "cube.wtf" endi=0--print(wtfFile)-- 1st dimension arrayfor col=1,10 doi=i+1-- 2nd dimension arrayfor row=1,10 doi=i+1gObjects[i]={} arrayObjects[i]={}gObjects[i].cObj=make(ig3d_object,wtfFile) -- create objectpObject=get(ig3d_object,gObjects[i].cObj)arrayObjects[col][row]=pObjectxcol=col*8yplane=0zrow=row*16-- set gObject position x,y,zsetObjectInfo(pObject,IG3D_POSITION,xcol,yplane,zrow)endendend


function meshifyObject(obj)
	local x,y,z=getObjectInfo(obj, IG3D_POSITION)
	local xa,ya,za=getObjectInfo(obj, IG3D_ROTATION)
	local xs,ys,zs=getObjectInfo(obj, IG3D_SIZE)
	local fileToLoad=string.sub(ig3d_GetObjectModelPath_s_s( getObjectInfo(obj, IG3D_NAME)), #gameroot+1, -1)
	
	loadMesh(fileToLoad)
	ig3d_ScaleSelectedMesh_3f(xs,ys,zs)
	ig3d_RotateSelectedMesh_6f(xa,ya,za, 0,0,0)
	ig3d_SetMeshPositionNoUndo_3f(x,y,z)
	delete(ig3d_object, obj)	
end





gFloorWTF = "Floors/snowfloor2x2.wtf"
gEWWallWTF = "Walls/EWwall2x2snow.wtf"
gNSWallWTF = "Walls/NSwall2x2snow.wtf"

 gDropMesh = nil
 function icopyModelFloors(qx,qz,face,gDropMesh)
  if gDropMesh == nil then gDropMesh = gFloorWTF end 
  if face == nil then face = "floor" end
  	local Q='"'
  	local rx,ry,rx=0,0,0
  	local QY =1
  	if face == "floor" then
	QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
	QY=0.0
	QZ =(math.floor((qz+(vcubelength/2))/vgridlength)*vgridlength)
	end
	
	
 		if face == "north"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth)-vcubelength
 		end
 
 		if face == "south"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth) 
 		ry=180
 		end
 
 		if face == "east" then
 		QX =qx+(vcubewidth/vgridwidth)
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		ry=180 
 		end
 
 		if face == "west" then
  		QX =qx+(vcubelength/vgridwidth)-vcubelength
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		end
	 table.insert(gObjectPositions,{QX,QY,QZ})
	 table.insert(gObjectRotations,{0.0,ry,0.0})
	 table.insert(gObjectColls,false)
	 table.insert(gObjectHUDs,false)
 	 table.insert(gObjectSizes,{(100),(100),(100)})
 	 table.insert(gObjectNames,"x"..QX.."z"..QZ.."F")
 	 table.insert(gObjectWTFs,gDropMesh)
 	 i=#gObjectWTFs
  	 gObjects[i]={}
  	 gObjects[i].cObj=make(ig3d_object, gObjectWTFs[i])
setObjectInfo(gObjects[i].cObj, IG3D_NAME, gObjectNames[i])
setObjectInfo(gObjects[i].cObj, IG3D_POSITION, gObjectPositions[i][1],gObjectPositions[i][2],gObjectPositions[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_ROTATION, gObjectRotations[i][1],gObjectRotations[i][2],gObjectRotations[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_SIZE, gObjectSizes[i][1],gObjectSizes[i][2],gObjectSizes[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_COLL, gObjectColls[i])
setObjectInfo(gObjects[i].cObj, IG3D_HUD, gObjectHUDs[i])
  end
  
   function icopyModelWalls(qx,qz,face,gDropModel)
   if face == nil then face = "floor" end
  --if gDropMesh == nil then 
  if face == "east" or face == "west" then gDropModel = gEWWallWTF end
  if face == "north" or face == "south" then gDropModel = gNSWallWTF end
  if face == "floor" then gDropModel = gFloorWTF end 
	--end
  	local Q='"'
  	local rx,ry,rx=0,0,0
  	local QY =1
  	if face == "floor" or face == "floorlive" then
	QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
	QY=0.0
	QZ =(math.floor((qz+(vcubelength/2))/vgridlength)*vgridlength)
	end
 		if face == "north"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth)-vcubelength
 		end
 
 		if face == "south"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth) 
 		ry=180
 		end
 
 		if face == "east" then
 		QX =qx+(vcubewidth/vgridwidth)
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		ry=180 
 		end
 
 		if face == "west" then
  		QX =qx+(vcubelength/vgridwidth)-vcubelength
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		end
 		gDropx,gDropy,gDropz = QX,QY,QZ
	 table.insert(gObjectPositions,{QX,QY,QZ})
	 table.insert(gObjectRotations,{0.0,ry,0.0})
	 table.insert(gObjectColls,false)
	 table.insert(gObjectHUDs,false)
 	 table.insert(gObjectSizes,{(100),(100),(100)})
 	 table.insert(gObjectNames,"x"..QX.."z"..QZ.."F")
 	 table.insert(gObjectWTFs,gDropModel)
 	 i=#gObjectWTFs
  	 gObjects[i]={}
  	 gObjects[i].cObj=make(ig3d_object, gObjectWTFs[i])
setObjectInfo(gObjects[i].cObj, IG3D_NAME, gObjectNames[i])
setObjectInfo(gObjects[i].cObj, IG3D_POSITION, gObjectPositions[i][1],gObjectPositions[i][2],gObjectPositions[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_ROTATION, gObjectRotations[i][1],gObjectRotations[i][2],gObjectRotations[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_SIZE, gObjectSizes[i][1],gObjectSizes[i][2],gObjectSizes[i][3])
setObjectInfo(gObjects[i].cObj, IG3D_COLL, gObjectColls[i])
setObjectInfo(gObjects[i].cObj, IG3D_HUD, gObjectHUDs[i])
  end
 
 
 gMeshObjectWTFs={}
gMeshObjectNames={}
gMeshObjectPositions={}
gMeshObjectRotations={}
gMeshObjectSizes={}
 
 function iBuildMeshObjectTables(qx,qz,face,gDropModel)
   if face == nil then face = "floor" end
  --if gDropMesh == nil then 
  if face == "east" or face == "west" then gDropModel = gEWWallWTF end
  if face == "north" or face == "south" then gDropModel = gNSWallWTF end
  if face == "floor" then gDropModel = gFloorWTF end 
	--end   
  	local Q='"'
  	local rx,ry,rx=0,0,0
  	local QY =1
  	if face == "floor" or face == "floorlive" then
	QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
	QY=0.0
	QZ =(math.floor((qz+(vcubelength/2))/vgridlength)*vgridlength)
	end
 		if face == "north"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth)-vcubelength
 		end
 
 		if face == "south"  then
 		QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		QZ =qz+(vcubelength/vgridwidth) 
 		ry=180
 		end
 
 		if face == "east" then
 		QX =qx+(vcubewidth/vgridwidth)
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		ry=180 
 		end
 
 		if face == "west" then
  		QX =qx+(vcubelength/vgridwidth)-vcubelength
 		QZ =(math.floor((qz+(vcubewidth/2))/vgridwidth)*vgridwidth)
 		end
 		gDropx,gDropy,gDropz = QX,QY,QZ
	 table.insert(gMeshObjectPositions,{QX,QY,QZ})
	 table.insert(gMeshObjectRotations,{0.0,ry,0.0})
 	 table.insert(gMeshObjectSizes,{(100),(100),(100)})
 	 table.insert(gMeshObjectNames,"x"..QX.."z"..QZ.."F")
 	 table.insert(gMeshObjectWTFs,gDropModel)
  end
  

	
 



 
