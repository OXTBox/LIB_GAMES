-- RTS_Sounds.lua
setSceneInfo(IG3D_SOUND_DAMPING, 0, 0, 0, 0) -- full damping
setSceneInfo(IG3D_SOUND_DAMPING, 0, 0.006667, 0.106667, 100.0)
setSceneInfo(IG3D_SOUND_DAMPING, 0, 0, 0.05, 100.0)  
gSoundEmittersHighwaterMark=1

function assign_free_sound_emitter()
		local r=gSoundEmitters[gSoundEmittersHighwaterMark]
		gSoundEmittersHighwaterMark=gSoundEmittersHighwaterMark+1
		if gSoundEmittersHighwaterMark>#gSoundEmitters then
			ig3d_SetMode_i(1)
			print("NOT ENOUGH SOUND EMITTERS")
			gSoundEmittersHighwaterMark=1
		end
		return r
end


function rts_play_zombie_ambient_sound(obj)
	
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_STOP)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 100)
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_VOLUME, 3)

	if isFemale(obj) then
		setSound_emitterInfo(obj.voiceSndEmt, IG3D_PITCH, 200)		
	end
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_SAMPLE, "Data/Sounds/zombie.ogg")
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_LOOP, true)	
	setSound_emitterInfo(obj.voiceSndEmt, IG3D_START)
end