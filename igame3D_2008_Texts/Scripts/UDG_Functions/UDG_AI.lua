gDangerFlag=false
-- handle_UDGAI copied from handle_FPSAI in FPS_Functions/FPS_AI.lua

gAISliceSize=#gObjects
gAISliceOffset=0

--we want to do 5 AIs handled in 0.1 seconds which yields to a slide size of 5 and a sensing interval of 0.1 seconds
--or slide size 1 with sensing interval 0.02
--gSensesInterval=0.05

function handle_UDGAI()


	
	
	setSceneInfo(IG3D_LOD_DISTANCE, 5,50,50,50)--5
	--setSceneInfo(IG3D_LOD_DISTANCE, 5,5,5,50)
			
	-- timed senses
	local dosenses=false
	if time()>=gSensesTime then
		-- is it time to handle the senses?
		gSensesTime=time()+gSensesInterval
		dosenses=true
	end
	
	--dosenses=true--danger danger high voltage
	
	
	buildDistancesTable(dosenses)--calculate distance between objects and distances to camera thus determining the relevant objects
	
	
	-- hilite marked objects
	hiliteMarkedObjects() ; -- see RTS_Utilties.lua
	-- position held guns
	rightHandedPistols(); -- see RTS_Weapons.lua
	-- position held melee weapons
	handle_melee_weapons(); -- see RTS_Weapons.lua
	
	-- handle car engines
	play_car_sounds() ; -- see RTS_Vehicles.lua
	-- check health
	for i=1,#gObjects,1 do
		--needs to be here
		handle_health(gObjects[i])-- see RTS_AI.lua
	end	
	
	
	-- object AI
	local i,j
	--for i=1,#gObjects,1 do
	for j=gAISliceOffset,gAISliceOffset+gAISliceSize,1 do
		
		i=(j % #gObjects) + 1
		

		if gObjects[i].alive then
			if gObjects[i].relevant then
				handle_ai(gObjects[i], dosenses)
			else
				handle_ai(gObjects[i], dosenses)
			end
		end		
			-- freezetime
			if gObjects[i].freezeTime then
				if time()>= gObjects[i].freezeTime and not gObjects[i].freeze then
					setObjectInfo(gObjects[i].cObj, IG3D_RAGDOLL, false)
				
					setObjectInfo(gObjects[i].cObj, IG3D_COLL, false)
					setObjectInfo(gObjects[i].cObj, IG3D_GRAVITY_MULTIPLIER, 0) -- ?
					x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
					if gObjects[i].bloodBone then
						local bn=get(ig3d_bone, gObjects[i].cObj, gObjects[i].bloodBone)
						x,y,z=getBoneInfo(bn, IG3D_POSITION)
						gObjects[i].bloodBone=nil
					end
					
					y=0.03
					setParticle_emitterInfo(bloodonfloor, IG3D_POSITION, x,y,z)
					setParticle_emitterInfo(bloodonfloor, IG3D_START)
				
					gObjects[i].freeze=true
					gObjects[i].freezeTime=time()+6.0			
				end
			end
			-- frozen
			if gObjects[i].freeze then
				----IMPORTANT: In the following line dont replace team==1 with a gTeamSelect literal, since this is explicitly concerning zombies only!!
				if time()>= gObjects[i].freezeTime and gObjects[i].team==1 and gObjects[i].deathCount>0 and gObjects[i].behaviour==zombie_behaviour then
					gObjects[i].freeze=false
					gObjects[i].freezeTime=nil
					setObjectInfo(gObjects[i].cObj, IG3D_IGNORE_OBJECT_COLLS, false)
					setObjectInfo(gObjects[i].cObj, IG3D_COLL, true)
					setObjectInfo(gObjects[i].cObj, IG3D_GRAVITY_MULTIPLIER, 1)
					gObjects[i].alive=true
					gObjects[i].health=math.random(500,1000)
					gObjects[i].anim.name="ragdoll"
					gObjects[i].reanimateTime=time()+0.5
					gObjects[i].behaviour=zombie_reanimate_behaviour
					gObjects[i].noise=0.2
					gObjects[i].hitFloor=false
					setObjectInfo(gObjects[i].cObj, IG3D_ROTATION, 0,0,0)--trying stuff
					setObjectInfo(gObjects[i].cObj, IG3D_GRAVITY_MULTIPLIER, 1)
					setObjectInfo(gObjects[i].cObj, IG3D_VECTOR_CONSTRAINT, 0,1,0)
					setObjectInfo(gObjects[i].cObj, IG3D_LINK_MAIN_BONE_TO_VELOCITY, false)
				end	
			end	
		end
		
		gAISliceOffset=(gAISliceOffset+gAISliceSize) % #gObjects--step AI slice forward
		

--seperated task execution from AI handling
for i=1,#gObjects,1 do
	if gObjects[i].alive then
			--if gObjects[i].relevant then
				do_task(gObjects[i])
			--else
			--end
		end		
end

-- keyboard time controls 	
bulletTimeKey("b") ; 
 -- tab key = 314, slows time to .00001
stopTimeKey(314) ; 	
-- 		char,code,name=input(false)
-- 		if char~= nil then RTS_print(code) end;	
	fltk_update()
end









function udg_zombies_in_touch_distance(z1, z2)
	if objdistance(z1, z2) < 2.5 then
		return true
	end
	
	return false
end

function udg_build_zombie_near_values()
	local i,j
	local nearSet={gObjects[playerBox]}
	local growing=true
	
	for i=1,#gObjects,1 do
		gObjects[i].nearPlayer=false
	end
	
	while growing do
		growing=false
		for i=1,#gObjects,1 do
			for j=1,#nearSet,1 do
				if gObjects[i].team==1 and gObjects[i].alive and not gObjects[i].nearPlayer then
				
					local result= udg_zombies_in_touch_distance(gObjects[i], nearSet[j])
					if result then
						gObjects[i].nearPlayer=true
						growing=true
						table.insert(nearSet, gObjects[i])
					end
				end
			end
		end
	end
	
	if key("k","n") then
	for i=1,#gObjects,1 do
		if gObjects[i].team==1 and gObjects[i].alive then
			print(gObjects[i].nearPlayer)
		end
	end
	end
end

function udg_enemy_in_sight(obj)
	if #obj.sensed > 0 then
		if obj.sensed[1].team == 1-obj.team then
			return true
		end
	end
	return false
end

function udg_zombies_follow()
	udg_build_zombie_near_values()
	if gPathsSet then
		gOldPlayerPosX,gOldPlayerPosY,gOldPlayerPosZ=getObjectInfo(playerBox, IG3D_POSITION)
		gPathsSet=false
	end
end

function udg_untangle(obj, target)
	--obj.task.id=object_action_sidestep
	--obj.task.x=obj.order.x
	--obj.task.y=obj.order.y
	--obj.task.z=obj.order.z
	--obj.task.objInQuestion=target
	
	--if time()>obj.order.continueTime then
		obj.order=obj.oldorder
	--end

end


function getupfromfloor(obj)
	obj.freeze=false
	obj.freezeTime=nil
					setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, false)
					setObjectInfo(obj.cObj, IG3D_COLL, true)
					setObjectInfo(obj.cObj, IG3D_GRAVITY_MULTIPLIER, 1)
					obj.alive=true
					obj.health=1
					obj.anim.name="ragdoll"
					obj.reanimateTime=time()+0.5
					obj.team=0
					obj.noise=0
					obj.hitFloor=false
					obj.order={fn=fight_enemy_order, target=obj.killer, x=0, y=0, z=0}
					obj.killer.order=nil
					--if rts_play_zombie_ambient_sound then rts_play_zombie_ambient_sound(gObjects[i])  end

					--
					setObjectInfo(obj.cObj, IG3D_ROTATION, 0,0,0)--trying stuff
					setObjectInfo(obj.cObj, IG3D_GRAVITY_MULTIPLIER, 1)
					setObjectInfo(obj.cObj, IG3D_VECTOR_CONSTRAINT, 0,1,0)
					setObjectInfo(obj.cObj, IG3D_LINK_MAIN_BONE_TO_VELOCITY, false)


end


function coll_obj_mesh_udg(obj, bone, x,y,z)
	if obj.team>1 then return end
	if getObjectInfo(obj.cObj, IG3D_RAGDOLL) and not obj.hitFloor then
			--check if head is near floor
			local hx,hy,hz=getBoneInfo(get(ig3d_bone, obj.cObj, "head"), IG3D_POSITION)
			if hy<0.4 then
				obj.hitFloor=true
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_LOOP, false)
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_VOLUME, 3)
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_SAMPLE, "Data/Sounds/bodyhitfloor.ogg")
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
				setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)
			end
	end


	ox,oy,oz=getObjectInfo(obj.cObj, IG3D_POSITION)
	if y>oy-0.1 then
		
		local dx,dy,dz=normalized(ox-x,0,oz-z)
		
		
		if obj.event==nil then
				if obj.task.id~= object_action_eat and obj.task.id~=object_action_melee then
					obj.event={fn=untangle_event, target=nil, x=dx*2, y=dy*2, z=dz*2, timeOut=time()+0.1}
				end
		end
		
		
	end
	
end

coll_o_m=coll_obj_mesh_udg