guns={}
local i,ii,shortname,checkName
for i=1,#gObjects,1 do
	checkName=string.sub(getObjectInfo(gObjects[i].cObj, IG3D_NAME),1,3)
	local shortname = string.sub(checkName, 1,3)
	
	if shortname== "glo" or shortname== "gun" or shortname== "rif" then
	table.insert(guns, gObjects[i])
	guns[#guns].alive = false 
	
	resetCollisionToDefault(gObjects[i])
	
	gObjects[i].isGun=true
	gObjects[i].deathCount=0
	if shortname=="rif" then
		guns[#guns].interval=0.1
		guns[#guns].sample="Data/Sounds/rifle.ogg"
		guns[#guns].shots= 32 -- has 8 shots by default
		guns[#guns].recharge={16,32}
	else
		gObjects[i].interval=0.4
		gObjects[i].sample="Data/Sounds/colt45.ogg"
		guns[#guns].shots= 8 -- has 8 shots by default
		guns[#guns].recharge={4,8}
	end
	--print("gun "..#guns.." = "..getObjectInfo(gObjects[i].cObj, IG3D_NAME))
	--print(getObjectInfo(gObjects[i].cObj, IG3D_NAME))
	end
end
	

function HumansWithGuns()
	local n
	--randomly give people guns, if a gun happens to map to an object, which already has a gun, this gun is ignored, ie can be picked up from floor
	for n=1,#guns,1 do
		local obj=humans[math.random(1,#humans)]
		if not obj.gun and not obj.meleeWeapon then
			obj.behaviour = gunned_civilian_behaviour
			obj.gunSndEmt = assign_free_sound_emitter()
			setSound_emitterInfo(obj.gunSndEmt, IG3D_SAMPLE, guns[n].sample)
			obj.gun = guns[n]
			setObjectInfo(guns[n].cObj, IG3D_COLL, false)
			setObjectInfo(guns[n].cObj, IG3D_GRAVITY_MULTIPLIER, 0)
		end
end
end
print("# guns=",#guns)


function AllHumansWithGuns()
	local n,i =1,0
	--randomly give people guns, if a gun happens to map to an object, which already has a gun, this gun is ignored, ie can be picked up from floor
	for n=1,#humans,1 do
		local obj=humans[n]
		if not obj.gun and not obj.meleeWeapon then
		i=i+1
		if i< #guns+1 then
		if math.random(1,2) == 1 then 
			obj.behaviour = gunned_civilian_behaviour
			else
			obj.behaviour = soldier_behaviour
			end
			obj.gunSndEmt = assign_free_sound_emitter()
			setSound_emitterInfo(obj.gunSndEmt, IG3D_SAMPLE, guns[n].sample)
			obj.gun = guns[i]
			guns[i].shots= 8 -- has 8 shots by default
			guns[i].recharge={4,8}
			setObjectInfo(guns[i].cObj, IG3D_COLL, false)
			setObjectInfo(guns[i].cObj, IG3D_GRAVITY_MULTIPLIER, 0)
			end
		end
end
end


function udg_sniper_guns()
local i,ii,shortname,checkName
for i=1,#gObjects,1 do
	checkName=string.sub(getObjectInfo(gObjects[i].cObj, IG3D_NAME),1,3)
	local shortname = string.sub(checkName, 1,3)
	
	if shortname== "glo" or shortname== "gun" or shortname== "rif" then
	table.insert(guns, gObjects[i])
	guns[#guns].alive = false 
	
	resetCollisionToDefault(gObjects[i])
	
	gObjects[i].isGun=true
	gObjects[i].deathCount=0
	if shortname=="rif" then
		guns[#guns].interval=0.8
		guns[#guns].sample="Data/Sounds/rifle.ogg"
		guns[#guns].shots= 999 -- has 8 shots by default
		guns[#guns].recharge={999,999}
	else
		gObjects[i].interval=0.8
		gObjects[i].sample="Data/Sounds/colt45.ogg"
		guns[#guns].shots= 999 -- has 8 shots by default
		guns[#guns].recharge={999,999}
	end
	--print("gun "..#guns.." = "..getObjectInfo(gObjects[i].cObj, IG3D_NAME))
	--print(getObjectInfo(gObjects[i].cObj, IG3D_NAME))
	end
end
end