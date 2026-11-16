function udg_handle_zombie_idle_sounds()
	local i
	for i=1,#gObjects,1 do
		if gObjects[i].team==1 and gObjects[i].alive then
			udg_play_zombie_idle_sound(gObjects[i])
		end
	end

end



function udg_update_object_sounds()
	for i=1,#gObjects,1 do
		local x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
		setSound_emitterInfo(gObjects[i].noiseSndEmt, x,y,z)
		setSound_emitterInfo(gObjects[i].voiceSndEmt, x,y,z)
		udg_play_footsteps_sound(gObjects[i])
	end
end

function udg_set_gender_specific_pitch(obj)
	if isFemale(obj) then 
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 200)
	else
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 100)
	end
end

function udg_play_scared_sound(obj)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 100)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
	local smplname="male_scream"
	if isFemale(obj) then
		smplname="fe"..smplname
	end
	smplname="Data/Sounds/"..smplname..tostring(math.random(1,2))..".ogg"
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, smplname)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
end

function udg_play_get_eaten_sound(obj)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 100)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
	local smplname="male_eaten.ogg"
	if isFemale(obj) then
		smplname="fe"..smplname
	end
	smplname="Data/Sounds/"..smplname
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, smplname)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
end


function udg_play_eat_sound(obj)
	obj.nextIdleSoundTime=time()+8.0+math.random()*5.0
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 100)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, "Data/Sounds/zombie_eating.ogg")
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_LOOP, false)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
end

function udg_play_hit_sound(obj)
	obj.nextIdleSoundTime=time()+8.0+math.random()*5.0
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_PITCH, 100)
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_SAMPLE, "Data/Sounds/bodyhit.ogg")
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_LOOP, false)
	setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)
end



function udg_play_zombie_acknowledge_sound(obj)
	obj.nextIdleSoundTime=time()+1.0+math.random()*5.0
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
	udg_set_gender_specific_pitch(obj)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, "Data/Sounds/zombie_yes.ogg")
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_LOOP, false)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
end

gZombieIdleSamples={"Data/Sounds/zombie_idle1.ogg","Data/Sounds/zombie_idle2.ogg","Data/Sounds/zombie_idle3.ogg","Data/Sounds/zombie_idle4.ogg"}
function udg_play_zombie_idle_sound(obj)
	if not obj.nextIdleSoundTime then
		obj.nextIdleSoundTime=time()+1.0+math.random()*5.0
	end
	
	if time()>obj.nextIdleSoundTime then
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
		udg_set_gender_specific_pitch(obj)
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, gZombieIdleSamples[math.random(1,#gZombieIdleSamples)])
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_LOOP, false)
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
		obj.nextIdleSoundTime=time()+3.0+math.random()*15.0
	end
end


function udg_play_footsteps_sound(obj)
	if obj.health>0 then
	if obj.anim.name=="Walk" and not obj.isWalking then
		obj.isWalking=true
		obj.isRunning=false
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_SAMPLE, "Data/Sounds/footsteps_walk.ogg")
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_LOOP, true)
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)
		--disabled walking sound for now
	end
	
	if obj.anim.name=="Run" and not obj.isRunning then
		obj.isWalking=false
		obj.isRunning=true
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_POSITION, getObjectInfo(obj.cObj, IG3D_POSITION))
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_SAMPLE, "Data/Sounds/footsteps_run.ogg")
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_LOOP, true)
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_START)
	end
	
	if obj.anim.name~="Run" and obj.anim.name~="Walk" then
		obj.isWalking=false
		obj.isRunning=false
		setSound_emitterInfo(obj.noiseSndEmt, IG3D_STOP)
	end
	end
end


function udg_soundEmittersHack()
if gNumSoundEmitters < gNumObjects*3 then
for ii=1,gNumObjects*3,1 do
i = #gSoundEmitterNames+1
table.insert(gSoundEmitterNames,"emt"..i)
gSoundEmitterPositions[i]={}
table.insert(gSoundEmitterPositions[i],{0.0,0.0,0.0})
table.insert(gSoundEmitterSamples,"")
gSoundEmitters[i]=make(ig3d_sound_emitter, gSoundEmitterNames[i])
	gSoundEmitters[i]=make(ig3d_sound_emitter, gSoundEmitterNames[i])
	setSound_emitterInfo(gSoundEmitters[i], IG3D_POSITION, gSoundEmitterPositions[i][1],gSoundEmitterPositions[i][2],gSoundEmitterPositions[i][3])
	setSound_emitterInfo(gSoundEmitters[i], IG3D_SAMPLE, gSoundEmitterSamples[i])
end
gNumSoundEmitters=#gSoundEmitterNames
end
end
soundEmittersHack=udg_soundEmittersHack