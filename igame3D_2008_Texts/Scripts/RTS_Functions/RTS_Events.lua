-- orders override behaviours!
-- events override orders!!

function stunned_event(obj, target)
	obj.task.id=object_action_lookat
	obj.task.objInQuestion=target
	obj.task.x=0
	obj.task.y=0
	obj.task.z=0
	--print(getObjectInfo(obj.cObj, IG3D_NAME), "stunned")
	if time()>obj.event.timeOut then
		obj.event=nil
	end	
end

function finishhim_event(obj, target)
	obj.task.id=object_action_stab
	obj.task.objInQuestion=target
	obj.task.x=0
	obj.task.y=0
	obj.task.z=0
	--print(getObjectInfo(obj.cObj, IG3D_NAME), "stunned")
	if time()>obj.event.timeOut then
		obj.event=nil
	end	
end

function untangle_event(obj, target)
	obj.task.id=object_action_sidestep
	obj.task.x=obj.event.x
	obj.task.y=obj.event.y
	obj.task.z=obj.event.z
	obj.task.objInQuestion=target
	
	if time()>obj.event.timeOut then
		obj.event=nil
	end
	if getObjectInfo(obj.cObj, IG3D_RAGDOLL) then
		obj.task.x=0
		obj.task.y=0
		obj.task.z=0
	end
end

function kickhead_event(obj, target)
	obj.task.id=object_action_kick
	obj.task.objInQuestion=target
	obj.task.x=0
	obj.task.y=0
	obj.task.z=0
	--print(getObjectInfo(obj.cObj, IG3D_NAME), "stunned")
	if time()>obj.event.timeOut then
		obj.event=nil
	end
	
end


function waitforhitbad_event(obj, target1)
	obj.task.id=object_action_punchair
	obj.task.objInQuestion=target1
	obj.task.x=0
	obj.task.y=0
	obj.task.z=0
	
	--print(getObjectInfo(obj.cObj, IG3D_NAME), "stunned")
	if time()>obj.event.timeOut then
		obj.event=nil
		obj.event={fn=hitbad_event, target=target1, timeOut=time()+2.5}
		if udg_play_hit_sound then udg_play_hit_sound(obj) end
	end

end


function hitbad_event(obj, target)
	obj.task.id=object_action_hit
	obj.task.objInQuestion=target
	obj.task.x=0--obj.event.timeOut-time()
	obj.task.y=0--obj.event.timeOut-time()
	obj.task.z=0--obj.event.timeOut-time()
	if not getObjectInfo(obj.cObj, IG3D_RAGDOLL) then
		setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, true)
		setObjectInfo(obj.cObj, IG3D_RAGDOLL, true)	
	end
	--print(getObjectInfo(obj.cObj, IG3D_NAME), "stunned")
	if time()>obj.event.timeOut then
		
		setObjectInfo(obj.cObj, IG3D_RAGDOLL, false)
		setObjectInfo(obj.cObj, IG3D_IGNORE_OBJECT_COLLS, false)
		setObjectInfo(obj.cObj, IG3D_ROTATION, 0,0,0)
		setObjectInfo(obj.cObj, IG3D_VECTOR_CONSTRAINT, 0,1,0)
		obj.event=nil
	end
end