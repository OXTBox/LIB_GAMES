function pick_highest_ranked_zombie(x,y,z)
	--first version
	local zomb=nil
	local dist=10000
	local i
	for i=1,#gObjects,1 do
					if gObjects[i].team==1 and gObjects[i].alive and gObjects[i].order==nil then
						--found a zombie to do this task
						local cx,cy,cz=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
						local thisdist=vecLength(cx-x,cy-y,cz-z)
						if thisdist<dist or zomb==nil then
							dist=thisdist
							zomb=gObjects[i]
						end						
					end
				end

	if zomb then return zomb end

	
		for i=1,#gObjects,1 do
					if gObjects[i].team==1 and gObjects[i].alive then
						--found a zombie to do this task
						local cx,cy,cz=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
						local thisdist=vecLength(cx-x,cy-y,cz-z)
						if thisdist<dist or zomb==nil then
							dist=thisdist
							zomb=gObjects[i]
						end	
						
					end
				end
	return zomb
end

function udg_handle_target_click_selection()
	if click("n") then
		local ax,ay,az, bx,by,bz=getSceneInfo(IG3D_MOUSE_LINE)
		local c,lx,ly,lz,o=lineCollision(ax,ay,az, bx,by,bz)
		
		
		if c==2 then
			if o.team==0 and o.alive or (o.team == doorTeam and o.house) or (o.team == windowTeam and o.house) then
				o.blinkingRed=1
				-- hit an enemy
				
				local zomb= pick_highest_ranked_zombie(lx,ly,lz)
				if zomb then
					zomb.order={fn=fight_enemy_order, target=o, x=lx, y=ly, z=lz}
					udg_play_zombie_acknowledge_sound(zomb)
				end
				
			else
				if o.team==sceneryTeam then
					
				
					local zomb= pick_highest_ranked_zombie(lx,ly,lz)
					if zomb then
						local cx,cy,cz=getObjectInfo(zomb.cObj, IG3D_POSITION)
						local dx,dy,dz=normalized(ax-lx,ay-ly,az-lz)
						zomb.pth=generateAStarPathBetweenPositions(nil, cx, cy, cz, lx+0.05*dx,ly+0.05*dy,lz+0.05*dz)
						zomb.order={fn= run_on_path, target=nil, x=lx, y=ly, z=lz}
						udg_play_zombie_acknowledge_sound(zomb)
					end
				
				end
				
			end
		end
		
		if c==1 then
			local zomb= pick_highest_ranked_zombie(lx,ly,lz)
					if zomb then
						local cx,cy,cz=getObjectInfo(zomb.cObj, IG3D_POSITION)
						local dx,dy,dz=normalized(ax-lx,ay-ly,az-lz)
						zomb.pth=generateAStarPathBetweenPositions(nil, cx, cy, cz, lx+0.05*dx,ly+0.05*dy,lz+0.05*dz)
						zomb.order={fn= run_on_path, target=nil, x=lx, y=ly, z=lz}
						udg_play_zombie_acknowledge_sound(zomb)
					end
		
		end
		
	end
	
end

function deDollObjects()

end

gDoVelocityClamp=true
function handle_udg()
		
		
		
	if not first then
		local dx,dy=getSceneInfo(IG3D_MOUSE_DELTA)
		xa=xa+dy
		ya=ya-dx
		setCameraInfo(IG3D_ROTATION, xa,ya,za)
	end
	
	for i=1,#gObjects,1 do
		if gObjects[i].becomeDoll then
			setObjectInfo(gObjects[i].cObj, IG3D_RAGDOLL,true)	
			gObjects[i].becomeDoll=false
			gObjects[i].dedoll=time()+6
			
		end
		if gObjects[i].hit and gObjects[i].dedoll<= time() then
		end
	end	
	a11,a12,a13,a14,a21,a22,a23,a24,a31,a32,a33,a34,a41,a42,a43,a44=getCameraInfo(IG3D_ROTATION_MATRIX)	
	x=0
	y=0
	z=0
	forw={a31,a32,a33}
	forw[2]=0
	forw[1],forw[2],forw[3]=normalized(forw[1],forw[2],forw[3])
	
	--
--	if key("y","-") then UDG_makeDoor()   end
--if key("u","-") then UDG_makeScenery()  end
--if key("i","-") then UDG_makeWoman() end
--  if key("o","-") then UDG_makeMan() end
 -- if key("k","-") then UDG_makeGun()   end
  
	
	--
	if key(" ","n") then
		--loadLevel("Data/Levels/FPS")
	end
	
	if key("w","-") then
		x=x+forw[1]
		y=y+forw[2]
		z=z+forw[3]
	end
	
	if key("s","-") then
		x=x-forw[1]
		y=y-forw[2]
		z=z-forw[3]
	end
	
	if key("a","-") then
		x=x+a11
		y=y+a12
		z=z+a13
	end
	
	if key("d","-") then
		x=x-a11
		y=y-a12
		z=z-a13
	end
	
	
		
		if key("l","n") then
		if levelislit == true then 
		dark()
		else
		lit()
		end
	end
	
	if key("t","n") then
		gDoVelocityClamp=not gDoVelocityClamp
	end


	dx,dy,dz=getObjectInfo(playerBox, IG3D_VELOCITY)
	if vecLength(dx,dy,dz)>gVelocityClamp and gDoVelocityClamp then
		x=0
		y=0
		z=0
	end
	setObjectInfo(playerBox, IG3D_FORCE, x*gCameraSpeed-0.2*gCameraSpeed*dx, y*gCameraSpeed-0.2*gCameraSpeed*dy, z*gCameraSpeed-0.2*gCameraSpeed*dz)
	
	
	
	x,y,z=getObjectInfo(playerBox, IG3D_POSITION)
	y=y+0.65
	setCameraInfo(IG3D_POSITION, x,y,z)	
	udg_handle_target_click_selection()	

	setSceneInfo(IG3D_MOUSE_VIEW, true, 1)
	default_escapekey()
	
	first=false
	
	for i=1,#gObjects,1 do
		gObjects[i].blood=false
	end
	
	setLightInfo(1, IG3D_POSITION, x,y+2,z,1)
	setLightInfo(1, IG3D_CONSTANT_ATTENUATION, 1)
	setLightInfo(1, IG3D_LINEAR_ATTENUATION, 0)
	setLightInfo(1, IG3D_QUADRATIC_ATTENUATION, 0.000816326)
	setLightInfo(2, IG3D_POSITION, 150,150,150,0)--for the shadows

	

	handle_UDGAI() ;-- see UDG_AI.lua

	udg_zombies_follow()
	gActivateStartSounds=false
	udg_handle_zombie_idle_sounds()
	udg_update_object_sounds()
	udg_display_FPS() ; -- see UDG_Utilties.lua
	udg_display_levelText(3,3,currentText)
	--handle_UDG_Doors()
	setLightInfo(2, IG3D_POSITION, 50,50,50, 0)
	
	
end


