function makeTextBox(n)
i =  #gTextboxes+1
if n == nil then n=i end

	gTextboxes[n]=make(ig3d_text_box, gTextboxFonts[#gTextboxFonts])
	setText_boxInfo(gTextboxes[n], IG3D_POSITION, 20,20)
	setText_boxInfo(gTextboxes[n], IG3D_SIZE, 10)
	setText_boxInfo(gTextboxes[n], IG3D_COLOR, 1,1,1, 1)

gNumTextboxes=n
end
 makeTextBox(2) 
function RTS_print(txt)
	setText_boxInfo(RTS_console, IG3D_TEXT, getText_boxInfo(RTS_console, IG3D_TEXT).."\n"..txt)
	setText_boxInfo(2,IG3D_SIZE,12)
	setText_boxInfo(2,IG3D_TEXT,ig3d_GetLevelName__s())
	
end

function drawGridDebug()
	local i=1
	local j=1
	

	for i=1,#gObjects,1 do
		if gObjects[i].alive and gObjects[i].team==1 then
			setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, 1)
			if gObjects[i].pth then
				local pthstepper=gObjects[i].pth
				while true do
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, pthstepper.x, pthstepper.y, pthstepper.z)
					--if pthstepper.next==nil then setParticle_emitterInfo(unitMarkerEnemy, IG3D_START) end
                                                        setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
					pthstepper=pthstepper.next
					if pthstepper==nil then break end
				end
					
			end
		end
	end
--[[
	
	for i=1,gNumRowVertices,1 do
		for j=1,gNumColumnVertices,1 do
			for k=1,#grid[i][j],1 do
				if grid[i][j][k].inside then
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, 3)
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, grid[i][j][k].x, grid[i][j][k].y, grid[i][j][k].z)
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
				else
					setParticle_emitterInfo(unitMarkerFriendly, IG3D_SIZE, 3)
					setParticle_emitterInfo(unitMarkerFriendly, IG3D_POSITION, grid[i][j][k].x, grid[i][j][k].y, grid[i][j][k].z)
					--setParticle_emitterInfo(unitMarkerFriendly, IG3D_START)
				end
			end
		end
	end

	
	--]]
	
	
	--[[
	nds=nds3
	if nds then
		for i=1,4,1 do
			if nds[i]==gende then esiz=3 else esiz=1 end
			if nds[i].insideE then
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, esiz)
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, nds[i].x, nds[i].y, nds[i].z)
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
			else
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_SIZE, esiz)
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_POSITION, nds[i].x, nds[i].y, nds[i].z)
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_START)
			end
			
		end
	end
	
	

	nds=nds2
	if nds then
		for i=1,4,1 do
			if nds[i]==ganfang then esiz=3 else esiz=1 end
			if nds[i].insideE then
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, esiz)
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, nds[i].x, nds[i].y, nds[i].z)
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
			else
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_SIZE, esiz)
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_POSITION, nds[i].x, nds[i].y, nds[i].z)
				setParticle_emitterInfo(unitMarkerFriendly, IG3D_START)
			end
			
		end
	end
	--]]
end


function hiliteMarkedObjects()
	--hilite marked objects
	for i=#gObjects,1,-1 do
		local j=1
		m=get(ig3d_material, gObjects[i].cObj, j)
		while (m) do
			if gObjects[i].blinkingRed then
				setMaterialInfo(m, IG3D_EMISSION, gObjects[i].blinkingRed,0,0,1)
				gObjects[i].blinkingRed=gObjects[i].blinkingRed-passed()
				if gObjects[i].blinkingRed<=0 then gObjects[i].blinkingRed=nil end
			else
				setMaterialInfo(m, IG3D_EMISSION, 0,0,0,1)
			end
			j=j+1
			m=get(ig3d_material, gObjects[i].cObj, j)
		end
	
		if gObjects[i].selected then
			local x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
			local xlow,xhigh, ylow,yhigh, zlow,zhigh= getObjectInfo(gObjects[i].cObj, IG3D_BOUNDS)
			local h=yhigh-ylow
			setParticle_emitterInfo(unitMarkerFriendly, IG3D_POSITION, x,y-0.5*h+0.04,z)
			setParticle_emitterInfo(unitMarkerFriendly, IG3D_SIZE, math.max(xhigh-xlow,zhigh-zlow)*2)
			setParticle_emitterInfo(unitMarkerFriendly, IG3D_START)
			if gObjects[i].order then
				if gObjects[i].order.target==nil then
					
					
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, 2)
					if gObjects[i].pth then
						local pthstepper=gObjects[i].pth
						while true do
							setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, pthstepper.x, pthstepper.y-0.4, pthstepper.z)
							--if pthstepper.next==nil then setParticle_emitterInfo(unitMarkerEnemy, IG3D_START) end
                                                        setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
							pthstepper=pthstepper.next
							if pthstepper==nil then break end
						end
					
					end
					--setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, 2)
					--setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, gObjects[i].order.x, gObjects[i].order.y+0.04, gObjects[i].order.z)
					
				else		
					x,y,z=getObjectInfo(gObjects[i].order.target.cObj, IG3D_POSITION)
					xlow,xhigh, ylow,yhigh, zlow,zhigh= getObjectInfo(gObjects[i].order.target.cObj, IG3D_BOUNDS)
					h=yhigh-ylow
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_POSITION, x,y-0.5*h+0.04,z)
					setParticle_emitterInfo(unitMarkerEnemy, IG3D_SIZE, math.max(xhigh-xlow,zhigh-zlow)*2)
				end
				setParticle_emitterInfo(unitMarkerEnemy, IG3D_START)
			end
		end
	end
	
	--if key("k","-") then
		drawGridDebug()
	--end
end




kSelectionBoxDist=0.1
-- unselectAllObjects
function unselectAllObjects()
	for i=1,#gObjects,1 do
		gObjects[i].selected=false
	end
end

-- somethingSelected
function somethingSelected()
	local incr
	for incr=1,#gObjects,1 do
		if gObjects[incr].selected then return true end
	end
	return false
end

---some long utility functions outsourced to this file
-- setSelectionRect
function setSelectionRect(left,top,right,bottom)
	local upperleft=get(ig3d_bone, selectionRect.cObj, "one")
	local upperright=get(ig3d_bone, selectionRect.cObj, "three")
	local lowerright=get(ig3d_bone, selectionRect.cObj, "five")
	local lowerleft=get(ig3d_bone, selectionRect.cObj, "seven")
	
	local cx,cy,cz=getCameraInfo(IG3D_POSITION)
	setObjectInfo(selectionRect.cObj, IG3D_POSITION, cx,cy,cz)
	setObjectInfo(selectionRect.cObj, IG3D_ROTATION, 0,0,0)
	
	local a,b,c,d=ig3d_GetWindowBounds__4i()
	left=left+a
	right=right+a
	top=top+b
	bottom=bottom+b
	
	ig3d_FoolMousePosition_2i(left,top)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(upperleft, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(right,top)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(upperright, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(right,bottom)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(lowerright, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(left,bottom)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(lowerleft, IG3D_POSITION, x-cx,y-cy,z-cz)
	
	local upperleft=get(ig3d_bone, selectionRect.cObj, "two")
	local upperright=get(ig3d_bone, selectionRect.cObj, "four")
	local lowerright=get(ig3d_bone, selectionRect.cObj, "six")
	local lowerleft=get(ig3d_bone, selectionRect.cObj, "eight")
	
	left=left-1
	right=right+1
	top=top-1
	bottom=bottom+1
	
	ig3d_FoolMousePosition_2i(left,top)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(upperleft, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(right,top)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(upperright, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(right,bottom)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(lowerright, IG3D_POSITION, x-cx,y-cy,z-cz)
	ig3d_FoolMousePosition_2i(left,bottom)
	local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
	dx=x2-x
	dy=y2-y
	dz=z2-z
	dx,dy,dz=normalized(dx,dy,dz)
	x=x+dx*kSelectionBoxDist
	y=y+dy*kSelectionBoxDist
	z=z+dz*kSelectionBoxDist
	setBoneInfo(lowerleft, IG3D_POSITION, x-cx,y-cy,z-cz)
end


function handle_selection_box()
	if click("n") then
		local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
		local winx,winy,winz=getSceneInfo(IG3D_WINDOW_COORDS, x2,y2,z2)
		
		gDraggingSelRect=true
		gSelectionRect.left=winx
		gSelectionRect.top=winy
		gSelectionRect.right=winx
		gSelectionRect.bottom=winy
		gSelectionRect.clickleft=winx
		gSelectionRect.clicktop=winy
		for i=1,#gObjects,1 do
			gObjects[i].oldSelected=gObjects[i].selected
		end
	end
	
	if click("-") and gDraggingSelRect then
		local x,y,z,x2,y2,z2=getSceneInfo(IG3D_MOUSE_LINE)
		local winx,winy,winz=getSceneInfo(IG3D_WINDOW_COORDS, x2,y2,z2)
		if winx<gSelectionRect.clickleft then
			gSelectionRect.left=winx
			gSelectionRect.right=gSelectionRect.clickleft
		else
			gSelectionRect.left=gSelectionRect.clickleft
			gSelectionRect.right=winx
		end
		if winy<gSelectionRect.clicktop then
			gSelectionRect.top=winy
			gSelectionRect.bottom=gSelectionRect.clicktop			
		else
			gSelectionRect.top=gSelectionRect.clicktop
			gSelectionRect.bottom=winy
		end
		
		
		for i=1,#gObjects,1 do
			gObjects[i].selected=gObjects[i].oldSelected
			local x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
			winx,winy,winz=getSceneInfo(IG3D_WINDOW_COORDS, x,y,z)
			if winz>=0 and gObjects[i].team==gTeamSelect and gObjects[i].alive==true then
				if winx>=gSelectionRect.left then
					if winx<=gSelectionRect.right then
						if winy>=gSelectionRect.top then
							if winy<=gSelectionRect.bottom then
								if key(310,"-") then
									gObjects[i].selected=not gObjects[i].oldSelected
								else
									gObjects[i].selected=true
								end
							end
						end
					end
				end
			end
		end		
	end	
end


function destroyHouse(obj)
	obj.alive=false
	obj.house=false
	setObjectInfo(obj.cObj, IG3D_OMEGA, 0,10,0)
	setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, true)
	setObjectInfo(obj.cObj, IG3D_MASS, 1,1,1,1)
	
	for i=1,100,1 do --probably there are 
		bn=get(ig3d_bone, obj.cObj, i)
		setBoneInfo(bn, IG3D_RAGDOLL, false)
	end
	
	setObjectInfo(obj.cObj, IG3D_RAGDOLL, true)
		--[[
	setObjectInfo(obj.cObj, IG3D_MASS, 5,5,5,5)
	setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, true)
	setObjectInfo(obj.cObj, IG3D_GRAVITY_MULTIPLIER, 1)
	a11,a12,a13,a14, a21,a22,a23,a24, a31,a32,a33,a34, a41,a42,a43,a44=getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)
	--local dp=dot(a31,a32,a33,obj.dx,obj.dy,obj.dz)
	setObjectInfo(obj.cObj, IG3D_VELOCITY, 0,0,0)
	setObjectInfo(obj.cObj, IG3D_OMEGA, 0,0,0)	
	--setObjectInfo(obj.cObj, IG3D_FORCE, a11*4, a12*4, a13*4)
	

	local i=1
	while true do
		b=get(ig3d_bone, obj.cObj, i)
		setBoneInfo(b, IG3D_RAGDOLL, false)
		if getBoneInfo(b, IG3D_NAME)=="None" then break end
		i=i+1
	end
					
	setObjectInfo(obj.cObj, IG3D_RAGDOLL, true)
	--]]
end


function checkGameEndCondition()
	local nh=0
	local nz=0
	for i=1,#gObjects,1 do
		if gObjects[i].team==0 and gObjects[i].deathCount>0 then nh=nh+1 end
		--print(getObjectInfo(gObjects[i].cObj, IG3D_NAME)) end
	end
	
	for i=1,#gObjects,1 do
		if gObjects[i].team==1 and gObjects[i].deathCount>0 then nz=nz+1 end
	end
	
	if nh>0 and nz>0 then
		gStatusString="\n"..nh.." humans and "..nz.." zombies are around!"
	end	

	if nh==0 and nz>0 then
		gStatusString="\nThe zombies won!!!"
	end
	
	if nh==0 and nz==0 then
		gStatusString="\nEverybody is dead!!"
	end
	
	if nz==0 and nh>0 then
		gStatusString="\nThe humans won!!"
	end
	
end



function isFemale(obj)
	local pth=ig3d_GetObjectModelPath_s_s(getObjectInfo(obj.cObj, IG3D_NAME))
	local mdl=string.sub(pth, #gameroot+21,-1)
	if mdl=="chick.wtf" then return true end
	if mdl=="zombiechick.wtf" then return true end
	if mdl=="zombiechick_alt.wtf" then return true end
	if mdl=="zombiechick_alt2.wtf" then return true end
	if mdl=="jackytruebones.wtf" then return true end
	if mdl=="tomdrinwoman1_3k.wtf" then return true end
	if mdl=="tomdrinwoman2_3k.wtf" then return true end
	if mdl=="tomdrinwoman3_3k.wtf" then return true end
	if mdl=="tomdrinwoman4_3k.wtf" then return true end
	if mdl=="tomdrinwoman5_3k.wtf" then return true end
	if mdl=="ponchocorpgirl.wtf" then return true end
	return false
end

function resetCollisionToDefault(obj)
	local c=getObjectInfo(obj.cObj, IG3D_COLL)
		setObjectInfo(obj.cObj, IG3D_VECTOR_CONSTRAINT, 0,0,0)
		setObjectInfo(obj.cObj, IG3D_BONE_COLL, false)
		setObjectInfo(obj.cObj, IG3D_COLLBOX_MULTIPLICATORS, 1,1,1)
		setObjectInfo(obj.cObj, IG3D_SHAPE, ig3d_box)
		setObjectInfo(obj.cObj, IG3D_COLL, false)
		setObjectInfo(obj.cObj, IG3D_COLL, true)
		setObjectInfo(obj.cObj, IG3D_COLL, c)
end