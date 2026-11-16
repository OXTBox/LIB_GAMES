function udg_place_objects_randomly()
if dontPlaceRandomly == true then return end
	if levelmapXY then
		for i=1,#gObjects,1 do
			if gObjects[i]~=crosshair then
				local rndPos = levelmapXY[ math.random(1,#levelmapXY)]
				local xlow,xhigh,ylow,yhigh,zlow,zhigh=getObjectInfo(gObjects[i].cObj, IG3D_BOUNDS)
				
				setObjectInfo(gObjects[i].cObj, IG3D_POSITION, rndPos[1]*2,-ylow,rndPos[2]*2)
			end
		end
		setObjectInfo(playerBox, IG3D_POSITION, getObjectInfo(zombies[1].cObj, IG3D_POSITION))
		setCameraInfo(IG3D_POSITION, getObjectInfo(zombies[1].cObj, IG3D_POSITION))
	end
end

function udg_create_safe_places_randomly()
	gSafePlaces={}
	
	if levelmapXY then
		
		local c=0
		while c<20 do
			local rndx=math.random(1, gNumRowVertices)
			local rndz=math.random(1, gNumColumnVertices)
			local y=grid[rndx][rndz][#grid[rndx][rndz]].y
			--only outside floor spots are actually safe
			if y<0.2 then
				table.insert(gSafePlaces, {grid[rndx][rndz][#grid[rndx][rndz]].x, grid[rndx][rndz][#grid[rndx][rndz]].y, grid[rndx][rndz][#grid[rndx][rndz]].z})
				c=c+1
			end
		end
	end
end

lastTexti = 0
currentText = 0
function udg_display_levelText(boxn,fontn,texti)
if currentText < 1 then return end
if lastTexti == texti then 
textalpha = textalpha -.01
else
lastTexti = texti
textalpha=1
end

if textalpha <= 0 then
lastTexti = 0
currentText = 0 
return 
end

local x,y = 50,350
local r,g,b = 1,1,1
local font = gTextboxFonts[fontn]
local tText = levelText[texti][2]
local size = 24
gSelectedTextBoxNum = boxn
ig3d_SetTextboxInfo_4i4f2s(gSelectedTextBoxNum,size,x,y,r,g,b,textalpha,font,tText)
end


function udg_display_FPS()
setText_boxInfo(RTS_console, IG3D_SIZE, 12)
setText_boxInfo(RTS_console, IG3D_TEXT, "")	
	local fps=getSceneInfo(IG3D_FPS)
	RTS_print(fps)
	RTS_print(getSceneInfo(IG3D_DRAWN_FACES))
	RTS_print(gStatusString)
	
end

function udg_listLevels()
UDG_LevelsTable={}
udgPath=gameroot.."Data/Levels/UDG/"
folderList=ListFolder(udgPath,"t")
local levelslist=""
	for i,v in pairs(folderList) do 
	listedFiles=listFiles(udgPath ..v)
		for ii,vv in pairs(listedFiles) do
		print(ii,vv)
		if vv ~= nil then 
			if string.find(vv,"load script.lua") ~= nil then
			local levelshortname = string.sub(v,string.find(v,"UDG_")+4,-1)
			table.insert(UDG_LevelsTable,{"UDG/"..v, levelshortname})
			levelslist=levelslist..levelshortname.."\n"
			break
			end
			end
		end
	end
	return levelslist
end

function udg_object_may_astar(obj)
	if not obj.nextAStarTime or time()>=obj.nextAStarTime then
		obj.nextAStarTime=time()+1
		return true
	end

	return false
end

