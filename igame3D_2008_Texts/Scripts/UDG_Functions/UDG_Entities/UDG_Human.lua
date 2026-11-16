-- RTS_Human.lua

gHumanNames={"jacky","masterchief","officer1","officer2","anita","mcTr","true","human","fighter","chick","tomd","soldier"}
humans={}
gTrackingLights={}
gTrackingLight= 2
local i,ii,shortCheckName,checkName
for i=1,#gObjects,1 do
	checkName = string.sub(getObjectInfo(gObjects[i].cObj, IG3D_NAME),1,4)
	sourceWTF =gObjectWTFs[i]
if 	string.find(sourceWTF,"slimed")==nil and string.find(sourceWTF,"snowed") ==nil then
	for ii=1,#gHumanNames,1 do

	local shortCheckName = string.sub(gHumanNames[ii], 1,4)
		if checkName == shortCheckName  then
		
		--additional repositioning, a house could have been placed above a human...
		putObjectOnGround(gObjects[i])
		
		table.insert(humans, gObjects[i])
		
		if gTrackingLight < 9 then
		table.insert(gTrackingLights,{gTrackingLight,gObjects[i]})
		gTrackingLight = gTrackingLight + 1
		end
		
		end
	end
end
end
gTrackingLight= 2
print("# humans=",#humans)


function udg_gauntlet_humans()
for i=1,#humans,1 do
obj=humans[i]
obj.followPlayer=false
	obj.hearingDistance=10.0
	obj.scareDistance=2
	obj.farDistance=6.0
	if math.random(1,2) == 1 then 
			obj.behaviour = gunned_civilian_behaviour
			else
			obj.behaviour = soldier_behaviour
			end
end
end


function udg_sniper_humans()
	for i=1,#humans,1 do
	obj=humans[i]
	local x,y,z=getObjectInfo(obj.cObj, IG3D_POSITION)
		if y > 1 then
		obj.followPlayer=false
		obj.isSniper=true
		obj.hearingDistance=100.0
		obj.scareDistance=0
		obj.farDistance=100.0
		obj.behaviour = sniper_behaviour
		end
			end
end