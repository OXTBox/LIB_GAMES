-- UDG_Init with copies from RTS Init 01 03 09
gLevelPath = gameroot.."Data/Levels/"
gDoShadows=true
gMasterAnimSource = "mcTrueBones.wtf"
gSelectionRectModel = "selectionRect.wtf"
gTrackingLight = 3
gObjCycle = 2
gTeamSelect = 0
gLastClick=0
gDoubleClickInterval=0.4
gStatusString=""
gCameraSpeed=5
gVelocityClamp=1.16
levelislit = false
-- Preload Scripts
dofile(gameroot.."Data/Scripts/Functions/math_functions.lua")


-- USING RTS SCRIPTS?!? ARGH Lets move what we can to UDG specifics!
	RTSFUNCTIONS={"Attributes","Utilities","Sounds","Tasks","Behaviours","Senses","Vehicles","Weapons","Orders","Events","AI","Collisions","Keyboard","astar","Game"}
		for i=1,#RTSFUNCTIONS,1 do
		tfile=gameroot.."Data/Scripts/RTS_Functions/RTS_"..RTSFUNCTIONS[i]..".lua"
		dofile(tfile)
		end
--initialize game object variables from init script and function
init_all_objects() -- see RTS_Attributes.lua

	-- assign UDG entities behavior Now in its own UDG Folder
UDGENTITIES={"Teams","Emitters","Human","Zombie","Building","Gun","Car","GUI","Window","Door","Scenery","BloodPencil","MeleeWeapons","LevelExits"}
		for i=1,#UDGENTITIES,1 do
		local tfile = gameroot.."Data/Scripts/UDG_Functions/UDG_Entities/UDG_"..UDGENTITIES[i]..".lua"
		dofile(tfile)
		end


-------------------
function udg_init()
	setObjectInfo(playerBox, IG3D_CAST_SHADOW, false)
	gObjects[playerBox].alive=false
	gObjects[playerBox].team=12
	-- further initialization
	randomWalking= walk_between_safe_places --replace the random walking
	default_behaviour = default_behaviour2 --replace the default behaviour
	standard_flee= flee_to_safe_place --replace flee
	zombie_behaviour = follow_player

	
	playerGunSound = assign_free_sound_emitter()
	setSound_emitterInfo(playerGunSound, IG3D_SAMPLE, "Data/Sounds/rifle.ogg")
	setSound_emitterInfo(playerGunSound, IG3D_LOOP, true)
	
	local i
	for i=1,#gObjects,1 do
		setObjectInfo(gObjects[i].cObj, IG3D_BONE_COLL, false)--no bone colls for heavens sake!
		setObjectInfo(gObjects[i].cObj, IG3D_SHAPE, ig3d_sphere)
		setObjectInfo(gObjects[i].cObj, IG3D_COLLBOX_MULTIPLICATORS, 0.5,1,1)--brave new world!
		
		if gObjects[i].team==1 and gObjects[i].alive then
			gObjects[i].behaviour=follow_player
			gObjects[i].noise=0.2
			--gObjects[i].meleeDistance=2
		end
		
		if gObjects[i].team==0 then
			--dead on a papercut
			gObjects[i].behaviour= idle_until_zombie_in_sight
			if isFemale(gObjects[i]) then
				--gObjects[i].health=1
			end
			gObjects[i].health=1
			gObjects[i].voiceSndEmt=assign_free_sound_emitter()--people need to scream etc.
			
		end
		setSound_emitterInfo(gObjects[i].voiceSndEmt, IG3D_VOLUME, 3)
		setSound_emitterInfo(gObjects[i].noiseSndEmt, IG3D_VOLUME, 3)
	end
	
	setObjectInfo(playerBox, IG3D_COLLBOX_MULTIPLICATORS, 1,1,1)--brave new world!
	setObjectInfo(playerBox, IG3D_SHAPE, ig3d_sphere)--sphere
	
	xa,ya,za=getCameraInfo(IG3D_ROTATION)
	setLightInfo(2, IG3D_POSITION, 0,5,7,1)
	setCameraInfo(IG3D_POSITION, 0,15,0)
	setObjectInfo(playerBox, IG3D_POSITION, getCameraInfo(IG3D_POSITION))

	--ignore reset
	for i=1,#gObjects,1 do
		setObjectInfo(gObjects[i].cObj, IG3D_POSITION, gObjectPositions[i][1],gObjectPositions[i][2],gObjectPositions[i][3])
		--setObjectInfo(gObjects[i].cObj, IG3D_BONE_COLL, false)--uh oh
	end
	setObjectInfo(playerBox, IG3D_IGNORE_OBJECT_COLLS, true)
	crosshair=gObjects[get(ig3d_object, "crosshair1")]
	crosshair.alive=false
	setObjectInfo(crosshair.cObj, IG3D_GRAVITY_MULTIPLIER, 0)
	crosshair.team=12
	bloodonfloor=get(ig3d_particle_emitter, "bloodonfloor")
end

-----------------------------------------------------------

	
HumansWithGuns()
HumansWithMeleeWeapons()
--set hit sound and level of depth
allEntitySoundCollLOD() -- see RTS_Attributes.lua


setupAStarGrid()


-------------------------------------------------------------
-- Copied from FPS Init 
FPSgun = get(ig3d_particle_emitter,"fpsgun")
playerBox = get(ig3d_object, "playerbox")
setObjectInfo(playerBox,IG3D_POSITION,0.0,1,0.0)
setObjectInfo(playerBox,IG3D_SIZE,50,50,50)
looker=get(ig3d_bone, playerBox, "None")
setBoneInfo(looker, IG3D_ENABLED, false)
first=true
if FPSgun ==nil then print("Missing \"fpsgun\" emitter\n") end
if playerBox ==nil then print("Missing \"playerbox\" object\n") end
setSceneInfo(IG3D_MOUSE_VIEW, true, 1)
setObjectInfo(playerBox, IG3D_VECTOR_CONSTRAINT, 0,1,0)
setObjectInfo(playerBox, IG3D_GRAVITY_MULTIPLIER, 0.1)
setObjectInfo(playerBox, IG3D_IGNORE_COLL, true, ig3d_particle_emitter, FPSgun)
setParticle_emitterInfo(FPSgun, IG3D_IGNORE_COLL, true, ig3d_particle_emitter, FPSgun)--dont collide bullets with bullets
setObjectInfo(playerBox, IG3D_SHAPE, ig3d_sphere)
xa,ya,za=getCameraInfo(IG3D_ROTATION)
setLightInfo(2, IG3D_POSITION, 0,5,7,1)

-------------------------------------------------------------		




UDGFUNCTIONS = {"Editor","AI","Lights","Game","Utilities","Sounds"}
	for i=1,#UDGFUNCTIONS,1 do
			tfile=gameroot.."Data/Scripts/UDG_Functions/UDG_"..UDGFUNCTIONS[i]..".lua"
			dofile(tfile)
		end

--init phase
udg_init()
udg_place_objects_randomly()--haha!
udg_create_safe_places_randomly()--ho ho ho

checkGameEndCondition()