-- RTS_Collisions
function objectAgainstParticles(obj, bone, emt, x,y,z)
	if obj.team>1 then return end
	if (emt=="Bullets" or emt=="fpsgun") then --and obj.alive then
	
		local bn=get(ig3d_bone, obj.cObj, bone)
		local bnname=getBoneInfo(bn, IG3D_NAME)
		obj.health=obj.health - (100+math.random(20))
		
		if obj.blood==false then --and obj.alive then
			--if math.random(4)==1 then bnname="head" end--remove
			if bnname=="head" then --or bname=="neck" or bname=="neckDummy" then
				
				obj.health=-10
				
				--obj.headshot=true
				if math.random(5)==1 then
					bn=get(ig3d_bone, obj.cObj, "head")
					setBoneInfo(bn, IG3D_RAGDOLL, false)
					setParticle_emitterInfo(bloodParticles2, IG3D_POSITION, getBoneInfo(bn, IG3D_POSITION))
					setParticle_emitterInfo(bloodParticles2, IG3D_ROTATION, -90,0,0)
					setParticle_emitterInfo(bloodParticles2, IG3D_START)
				end
				
			end
		
		
			setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, x,y,z)
			setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)
			setParticle_emitterInfo(bloodParticles, IG3D_POSITION, x,y,z)
			setParticle_emitterInfo(bloodParticles, IG3D_ROTATION, 0,0,0)
			setParticle_emitterInfo(bloodParticles, IG3D_START)
			
			
			--shot is targeting inside
			
			local ox,oy,oz=getObjectInfo(obj.cObj, IG3D_POSITION)
			--local ox,oy,oz=getBoneInfo(bn, IG3D_POSITION)
			--dy=y
			local dx,dy,dz
			dx=ox-x
			dy=oy-y
			dz=oz-z
			dx,dy,dz=normalized(dx,dy,dz)
			
			local sx=x-dx
			local sy=y-dy
			local sz=z-dz
			local fx=ox+dx
			local fy=oy+dy
			local fz=oz+dz
			
			
			result,x,y,z,u,v,m=getObjectInfo(obj.cObj, IG3D_EXACT_COLLISION_DATA, sx,sy,sz,fx,fy,fz)
			if result then
				drawToTexture( getMaterialInfo(m, IG3D_TEXTURE, 3), "Data/Images/Decals/bloodpencil"..(math.random(1,3))..".png",u,v, IG3D_ADD, IG3D_REPEAT)
				--obj.blood=true
			end
			obj.blood=true
		
		end
		
		
	end
end

function objectAgainstObject(obj1, bone1, obj2, bone2, x,y,z)
	if obj1.isGun or obj2.isGun then return end --collision with gun object???? weird...
	
	local damage=vecLength(getObjectInfo(obj1.cObj, IG3D_VELOCITY))+vecLength(getObjectInfo(obj2.cObj, IG3D_VELOCITY))*5
	if obj1.isVehicle and obj2.isVehicle then
		 --a crash!! kazoom
		 
		if obj1.health>0 and obj2.health>0 then
			obj1.health=obj1.health-damage
			obj2.health=obj2.health-damage
		end
		return
	end
	
	if obj1.isVehicle then
		if obj1.driver~= nil and not obj2.alive then
			obj1.driver.curDrivingFrame=1
			obj1.driver.startDriving=time()-1
			--local rnd=math.random(#gCrazyDrives)
			--obj1.crazyDrive=gCrazyDrives[rnd]
			obj1.health=obj1.health-damage
			
		end
		if obj2.alive and obj2 ~= obj1.driver and obj1.driver~= nil then
			obj1.health=obj1.health-damage*0.3
			obj2.health=obj2.health-damage
			
			setSound_emitterInfo(obj2.noiseSndEmt, IG3D_POSITION, x,y,z)
			setSound_emitterInfo(obj2.noiseSndEmt, IG3D_START)
		end
		if obj2.house then obj2.health=obj2.health-damage end
	else
		if obj2.isVehicle then
			if obj2.driver~= nil and not obj1.alive then
				obj2.driver.curDrivingFrame=1
				obj2.driver.startDriving=time()-1
				--local rnd=math.random(#gCrazyDrives)
				--obj2.crazyDrive=gCrazyDrives[rnd]
				obj2.health=obj2.health-damage
				
			end
			if obj1.alive and obj1 ~= obj2.driver and obj2.driver~= nil then
				obj2.health=obj2.health-damage*0.3
				obj1.health=obj1.health-damage
				setSound_emitterInfo(obj1.noiseSndEmt, IG3D_POSITION, x,y,z)
				setSound_emitterInfo(obj1.noiseSndEmt, IG3D_START)
			end
			if obj1.house then obj1.health=obj1.health-damage end
		end
	end
	
	--handle doors
	if obj1.team==doorTeam and obj2.team==0 then
		opendoor(obj1)
	end
	if obj2.team==doorTeam and obj1.team==0 then
		opendoor(obj2)
	end
	
	if obj1.alive and obj2.team>1 then
		if obj2.house and obj1.team==1 and objdistance(obj1,obj2)<0.5 then
			obj1.order={fn=fight_enemy_order, target=obj2, x=0, y=0, z=0}
			
		end
	end
	
	if obj2.alive and obj1.team>1 then
		if obj1.house and obj2.team==1 and objdistance(obj1,obj2)<0.5  then
			obj2.order={fn=fight_enemy_order, target=obj1, x=0, y=0, z=0}
		
		end
	end
	
	if obj1.alive and obj2.alive and obj1.team~=obj2.team then
	--when enemies collide -> fight
		if obj1.team==1 and obj1.task.id~=object_action_eat then--and obj1.order==nil then
			if not obj1.order or obj1.order.fn~=eat_dead_human then
				obj1.order={fn=fight_enemy_order, target=obj2, x=0, y=0, z=0}
			end
		end
		if obj2.team==1 and obj2.task.id~=object_action_eat then--and obj2.order==nil then
			if not obj2.order or obj2.order.fn~=eat_dead_human then

				obj2.order={fn=fight_enemy_order, target=obj1, x=0, y=0, z=0}
			end
		end
	end
	
	if obj1.alive and obj2.alive and obj1.team==obj2.team then
		a11,a12,a13,a14, a21,a22,a23,a24, a31,a32,a33,a34, a41,a42,a43,a44=getObjectInfo(obj1.cObj, IG3D_ROTATION_MATRIX)
		local x1,y1,z1=getObjectInfo(obj1.cObj, IG3D_POSITION)
		local x2,y2,z2=getObjectInfo(obj2.cObj, IG3D_POSITION)
		local dx,dy,dz=normalized(x2-x1,y2-y1,z2-z1)
		
		local v1=vecLength(getObjectInfo(obj1.cObj, IG3D_VELOCITY))
		local v2=vecLength(getObjectInfo(obj2.cObj, IG3D_VELOCITY))
		
		
		if obj1.event==nil and v2>v1 then--or obj1.order.fn~=untangle then
			
				if obj1.task.id~= object_action_eat and obj1.task.id~=object_action_melee then
					--obj1.event={fn=untangle_event, target=nil, x=-dx, y=-dy, z=-dz, timeOut=time()+0.25}
				end
				
		
		end
		if obj2.event==nil and v1>v2 then--or obj2.order.fn~=untangle then
			if obj2.task.id~= object_action_eat and obj2.task.id~=object_action_melee then
		
				--obj2.event={fn=untangle_event, target=nil, x=dx, y=dy, z=dz, timeOut=time()+0.25}
			end
					
	
		end
	end
	
end



coll_o_p=objectAgainstParticles
coll_o_o=objectAgainstObject
