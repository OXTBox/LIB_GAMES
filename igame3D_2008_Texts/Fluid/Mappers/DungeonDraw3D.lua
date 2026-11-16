--function make_window()
Q='"'
loadLevel("Data/Levels/edit/")
ig3d_SetMode_i(1)
baseBtnColor=16
grpGrid={}
drpGrid={}
drpColors={}

btnMakeList={}
btnListXY={{}}

GridSize=52
GridSpread=10
nc =  math.random(1,255)
	newcolor = nc
btnList={}
textmapXY={}
XYSpawned={}
currentLevel=0

dofile("/Applications/dsbtest35/base/dungeonreader.lua")
nTagNumber=0
vgridwidth=4
vgridlength=4
vcubewidth=4
vcubelength=4
vcubeheight=4

gridSize,cubeSize=4,4
gridSize,quadSize=4,4
-- string functions for items

function numberofitems(itemList,itemDelimiter)

if itemDelimiter==nil then itemDelimiter="," end

DelimitedString = itemList

local numofitems =1

for itemN in string.gfind(DelimitedString, itemDelimiter) do

numofitems=numofitems+ 1

end

return numofitems

end



-- item="returns item n of a string"
cr = "\n"

itemDelimiter=","
function item(n,ofwhatString,itemDelimiter)

local itemResults={}

local delimitedString = ofwhatString..itemDelimiter

local counter=1

local numofitems=1

for itemN in string.gfind(delimitedString, itemDelimiter) do

-- subset is shortened string

subset =string.sub(delimitedString, counter, -1) 

-- find delimiter in subset

delimiterstart, delimiterend =string.find(subset, itemN) 

-- char 1 to delimiter-1 of subset

subresult = string.sub(subset, 1, delimiterend-1) 

if subresult ~= nil then

itemResults[numofitems]=subresult

numofitems = numofitems+1

counter = counter + delimiterend

end

end

--handle negative numbers

if n <= 0 and numofitems>=1 then  return itemResults[numofitems+(n)] end

--handle positive numbers

if n <= numofitems then return itemResults[n] end

end
--mesh_drawQuad
function mesh_drawQuad(qx,qy)
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =(math.floor((qy+(vcubelength/2))/vgridlength)*vgridlength)-1
	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag="quad_"..nTagNumber 
	ig3d_CreateMesh_tag_s(quadtag)
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(1) --Line Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	ig3d_PushMeshToUndoCache()
	drawVertex(9999,-9999,9999)
	drawLine(-9999,-9999,9999)
	drawLine(-9999,-9999,-9999)
	drawLine(9999,-9999,-9999)
	drawLine(9999,-9999,9999)
	drawLine(-9999,-9999,-9999)
 	ig3d_SetFacePos_b3f((true),(QX),(-99999),(QY))
  	 ig3d_SelectMesh_tagVertices_ib(nTagNumber,false)
	ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
 	ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(1),(vcubelength))
	ig3d_SetMeshPositionNoUndo_3f((QX),(0.0),(QY))
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
  end
--loadFloors
TheFloor=nil
 function loadTheFloor(f)
  theMesh = gameroot.."Data/WTF/Floors/stone2floor4x4.wtf"
  nTagNumber=nTagNumber+1
	TheFloor=nTagNumber 
	ig3d_CreateMesh_tag_s("THEFLOOR"..nTagNumber )
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	 ig3d_PushMeshToUndoCache()
	 
  if ig3d_LoadMesh_sf_b(theMesh,100) == true then
  ig3d_SelectMesh_tagVertices_ib(nTagNumber,true)
	ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
 	ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(1),(vcubelength))
 	ig3d_SelectMesh_tagVertices_ib(nTagNumber,true)
 	ig3d_SetMeshPositionNoUndo_3f((10000),(0.0),(10000))
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
 	else
 	TheFloor = nil
 end
 	return TheFloor
 end
 
function icopyFloors(qx,qy)
	if TheFloor == nil then return end
	ig3d_SelectMesh_tagVertices_ib(TheFloor,true)

	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag="floor"..nTagNumber 
	ig3d_CreateMesh_tag_s(quadtag)
        
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(2) --select Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	  ig3d_PushMeshToUndoCache()
          ig3d_DuplicateMesh()
          ig3d_RemoveFromMesh_tag_i (TheFloor) 
          ig3d_AddToMesh_tag_i(nTagNumber) 

  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =(math.floor((qy+(vcubelength/2))/vgridlength)*vgridlength)-1
 	 
	ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
 	ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(1),(vcubelength))
 	ig3d_SetMeshPositionNoUndo_3f((QX),(0.0),(QY))
 	
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
 	
  end
  
  function icopyRoofs(qx,qy)
  if TheFloor == nil then return end
	ig3d_SelectMesh_tagVertices_ib(TheFloor,true)

	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag="roof"..nTagNumber 
	ig3d_CreateMesh_tag_s(quadtag)
        
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(2) --select Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	  ig3d_PushMeshToUndoCache()
          ig3d_DuplicateMesh()
          ig3d_RemoveFromMesh_tag_i(TheFloor) 
          ig3d_AddToMesh_tag_i(nTagNumber) 
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =(math.floor((qy+(vcubelength/2))/vgridlength)*vgridlength)-1	 
	
 	ig3d_SetMeshPositionNoUndo_3f((QX),(vcubeheight),(QY))
 	
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
 end
-- idrawWallZ
 function idrawWallZ(qx,qy,face)
wallstring={"north","west","east","south"}
if face == "north" or face == nil then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth)-vcubelength
 end
 
 if face == "south"  then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth) 
 end
 
 if face == "east" then
 QX =qx+(vcubewidth/vgridwidth)
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
 
 if face == "west" then
  QX =qx+(vcubelength/vgridwidth)-vcubelength
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag=face..nTagNumber 
	ig3d_CreateMesh_tag_s(quadtag)
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(1) --Line Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	ig3d_PushMeshToUndoCache()
	
	wallstring["north"]=[[
	drawVertex(9999,9999,-9999)
	drawLine(9999,-9999,-9999)
	drawLine(-9999,-9999,-9999)
	drawLine(-9999,9999,-9999)
	drawLine(9999,9999,-9999)
	drawLine(-9999,-9999,-9999)]]
	
	wallstring["west"]=[[
	drawVertex(-9999,9999,9999)
	drawLine(-9999,-9999,9999)
	drawLine(-9999,-9999,-9999)
	drawLine(-9999,9999,-9999)
	drawLine(-9999,9999,9999)
	drawLine(-9999,-9999,-9999)]]
	
	if face == "west" or face=="east" then	
	local a =loadstring(wallstring["west"])
	a()
	end
	
	if face == "north" or face == "south" then	
	local a =loadstring(wallstring["north"])
	a()
	end
 	ig3d_SetFacePos_b3f((true),(QX),(-99999),(QY))
  	 ig3d_SelectMesh_tagVertices_ib(nTagNumber,false)
	ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
 	ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(vcubeheight),(vcubelength))
	ig3d_SetMeshPositionNoUndo_3f((QX),(vcubeheight/2),(QY))
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
  end
-- loadTheWalls
WEWall = nil
NSWall = nil
 function loadTheWalls(face)
  nTagNumber=nTagNumber+1 
	ig3d_CreateMesh_tag_s(face)
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	 ig3d_PushMeshToUndoCache()	
	 if face == "west" or face=="east" then
	theMesh=gameroot.."Data/Wtf/Walls/EWwall4x4.wtf"
	WEWall = nTagNumber
	end
	if face == "north" or face == "south" then
	theMesh=gameroot.."Data/Wtf/Walls/NSwall4x4.wtf"
	NSWall = nTagNumber
	end 
  if ig3d_LoadMesh_sf_b(theMesh,100) == true then
  ig3d_SelectMesh_tagVertices_ib(nTagNumber,true)
 	ig3d_SetMeshPositionNoUndo_3f((10000),(10000.0),(10000))
 	meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 	ig3d_SetMode_i(savedmode)
 	else
 	if face == "west" or face=="east" then
	WEWall = nil
	end
	
	if face == "north" or face == "south" then
	NSWall = nil
	end	
 end
 if face == "north" or face == "south" then
	return NSWall
	else return WEWall
	end
 	
 end
 
 

  function icopyWalls(qx,qy,face)
	if WEWall == nil then return end
	if NSWall == nil then return end
	 
 if face == "west" or face=="east" then ig3d_SelectMesh_tagVertices_ib(WEWall,true) end
if face == "north" or face == "south" then ig3d_SelectMesh_tagVertices_ib(NSWall,true) end 

	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag=face..nTagNumber 
	ig3d_CreateMesh_tag_s(quadtag)
        
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(2) --select Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	  ig3d_PushMeshToUndoCache()
          ig3d_DuplicateMesh()
           if face == "west" or face=="east" then
          ig3d_RemoveFromMesh_tag_i(WEWall) 
          else
            ig3d_RemoveFromMesh_tag_i(NSWall) 
          end
          
          ig3d_AddToMesh_tag_i(nTagNumber) 
		ig3d_SelectMesh_tagVertices_ib(nTagNumber,true)
if face == "north" or face == nil then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth)-vcubelength
 end
 if face == "south"  then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth) 
 end
 if face == "east" then
 QX =qx+(vcubewidth/vgridwidth)
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
 if face == "west" then
  QX =qx+(vcubelength/vgridwidth)-vcubelength
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
  
	ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
 	if face == "north" or face=="south" then 
ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(vcubeheight),(1))
 end
ig3d_SetMeshPositionNoUndo_3f((QX),(vcubeheight/2),(QY))
 meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 ig3d_SetMode_i(savedmode)
 	
  end
  
  
  -- less efficient load walls
  function iloadWalls(qx,qy,face)
wallstring={"north","west","east","south"}
if face == "north" or face == nil then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth)-vcubelength
 end
 if face == "south"  then
  QX=(math.floor((qx+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 QY =qy+(vcubelength/vgridwidth) 
 end
 if face == "east" then
 QX =qx+(vcubewidth/vgridwidth)
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
 if face == "west" then
  QX =qx+(vcubelength/vgridwidth)-vcubelength
 QY =(math.floor((qy+(vcubewidth/2))/vgridwidth)*vgridwidth)-1
 end
	savedmode=ig3d_GetMode__i()
	nTagNumber=nTagNumber+1
	quadtag=face..nTagNumber
	ig3d_CreateMesh_tag_s(quadtag)
	ig3d_SetMode_i(1) --select object
	ig3d_SetMeshTool_i(1) --Line Tool
	 ig3d_SetDefaultMesh_tag_i(nTagNumber)
	ig3d_PushMeshToUndoCache()
	
	if face == "west" or face=="east" then
	theMesh=gameroot.."Data/Wtf/Walls/EWwall4x4.wtf"
	end
	if face == "north" or face == "south" then
	theMesh=gameroot.."Data/Wtf/Walls/NSwall4x4.wtf"
	end
if ig3d_LoadMesh_sf_b(theMesh,100) == true then
 ig3d_SelectMesh_tagVertices_ib(nTagNumber,true)
ig3d_SetMeshPositionNoUndo_3f(0.0,0.0,0.0)
if face == "west" or face=="east" then 
 --ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(vcubeheight),(1))
 else
 ig3d_ScaleSelectedMeshTo_3f((vcubewidth),(vcubeheight),(1))
 end
ig3d_SetMeshPositionNoUndo_3f((QX),(vcubeheight/2),(QY))
 meshx, meshy, meshz = ig3d_GetMeshCentroid__3f()
 ig3d_SetMode_i(savedmode)
 end
  end
-- uBtnList BROWSER CODE AHEAD 1129
gLastBrowserControlClick=os.time()
gLastSelection=-1
guSelectedBtn=""
BtnListBrowserIndex ={{}}


function ulistBtnList()
BtnBrowser:make_current()
n=BtnListBrowser:value()
if n ~= nil and BtnListBrowserIndex[n] ~=nil then 
ox,oy = BtnListBrowserIndex[n][1],BtnListBrowserIndex[n][2]
else
ox,oy = 0,0
end
local sb = ""
local s =""
	BtnListBrowser:clear()
	BtnListBrowserIndex={{}}
	tempt={}
	for i =1,#btnListXY,1 do
	tempt=btnListXY[i]
	x=tempt[1]
	y=tempt[2]
	
	
	 s = x..","..y
	
		if string.find(sb,s) ==nil then 
		BtnListBrowser:add(s)
		sb=sb.." "..s
		table.insert(BtnListBrowserIndex,{x,y}) 
		if i == ox and ii == oy then gLastSelection = #BtnListBrowserIndex end
		end
	end
	
	
	
	
	BtnBrowser:redraw()
	if gLastSelection ~= nil or gLastSelection > 0 then 
	BtnListBrowser:select(gLastSelection)
		BtnListBrowser:value(gLastSelection)
		BtnListBrowser:selected(gLastSelection,gLastSelection)
		
	end
	DWindow:make_current()
end




function uBtnListBrowserControlDoubleClicked(w)
	
		ulistBtnList()
		
		
end

function uBtnListBrowserControlClicked(w)
	if w:value()==0 then return end
	--print(w:value())
	
	n=w:value()	
	local t=os.time()
	
	if t-gLastBrowserControlClick < 0.4 and w:value()==gLastSelection then
		uBtnListbrowserControlDoubleClicked(w)
		gLastBrowserControlClick=0
	else
		gLastBrowserControlClick=time()
	ox,oy = tonumber(BtnListBrowserIndex[n][1])+1,tonumber(BtnListBrowserIndex[n][2])+1
	--print(ox,oy)
	AttrListBrowser:clear()
		listSpawnXY()
		for i = 1,#XYSpawned[ox][oy],1 do
		AttrListBrowser:add(XYSpawned[ox][oy][i])
		
		end
		
		AttrListBrowser:redraw()
	end
	gLastSelection=w:value()
	
			
end
-- wClose

function wClose(w)
w:hide()
w=nil
end
-- gridcb
function gridcb(w)
	tt=w:tooltip()
	if Fl:event_key()==32 then newcolor=fltk.fl_show_colormap(nc) end

 if newcolor == nil then 
nc = math.random(1,255)
else
nc = newcolor
end

if tt ~= nil then 
	--print(tt)
	xt = string.sub(tt,2,string.find(tt,"y")-1)
	x = tonumber(xt)+1
	n = string.find(tt,"y")
	if n ~= nil  and string.len(tt) > n then 
	y = tonumber(string.sub(tt,n+1,-1))+1
	--print(x..","..y)
	end
	end
	xys=(x..","..y)
	local s = ""
	for i =1,#btnList,1 do s=s..tostring(btnList[i]).."\n" end
	if string.find(s,xys) == nil then table.insert(btnList,xys) end
	btnListXY[x][y]=1
	textmapXY[x][y]=1
	serialXY=x+(GridSize*y)-GridSize
	
	textArray[serialXY]="1"
	w:color(nc)
	w:value(0)
	ulistBtnList()
	Fl:check()
end
-- startGrid
	
	
function startGrid()
	
		for i = 1,GridSize,1 do
		btnListXY[i]={}
		textmapXY[i]={}
		for ii = 1,GridSize,1 do
		nc = math.random(1,2)
		fltk.fl_color(nc)
		btnm = "x"..tostring(i-1).."y"..tostring(ii-1)
		btnListXY[i][ii]=0
		srun = btnm.."= fltk:Fl_Button("..i*GridSpread..","..ii*GridSpread..","..tostring(GridSpread)..","..tostring(GridSpread)..","..Q..Q..");\n"..btnm..":box(fltk.FL_FLAT_BOX);\n"..btnm..":show()\n"..btnm..":tooltip("..Q..btnm..Q..")\n"..btnm..":callback(gridcb)\n"..btnm..":when(3)\n  keeper:add("..btnm..") \n "
		textmapXY[i][ii]="0"
		--if f ~= nil then f:write(srun) end
		makeabutton =  loadstring(srun)
		makeabutton()				
		end
		end
		baseBtnColor=x0y0:color()	
keeper:redraw()	
DWindow:redraw()
	end
	
	
function resestGrid()
		for i = 1,GridSize,1 do
		btnListXY[i]={}
		textmapXY[i]={}
		for ii = 1,GridSize,1 do
		btnListXY[i][ii]=0
		textmapXY[i][ii]="0"			
		end
		end
end
 


function stackcb()

if Fl:event_key()==32 then newcolor=fltk.fl_show_colormap(nc) end
Fl:check()
end
--quadGrid
 function quadGrid()
 ig3d_DeleteMesh_b(true)
 local sb=""
 local s=""
  WEWall = loadTheWalls("east")
NSWall = loadTheWalls("north")
TheFloor = loadTheFloor() 

	
 

		
		
		
 for i =1,#quadwalls,1 do
	tempt=quadwalls[i]
	x=tempt[1]*gridSize
	y=tempt[2]*gridSize
	face=tempt[3]
	-- s = x..","..y
		--if string.find(sb,s) ==nil then 
		--stonecube(x,y)
		
		if  WEWall~= nil and NSWall ~= nil  then
		--iloadwalls(x,y,face)
		icopyWalls(x,y,face)
		else
		idrawWallZ(x,y,face)
		end
		
		--print(face)
		--sb=sb.." "..s
		--end
		render()				
	end
	
	
	
	for i =1,#textmapXY,1 do
		tempt=textmapXY[i]
		x=tempt[1]*gridSize
		y=tempt[2]*gridSize
		if TheFloor ~= nil then
		icopyRoofs(x,y)
		icopyFloors(x,y)
		else
		idrawQuad(x,y)
		end
		render()
					
	end
	
	ig3d_ShowAll()
 ig3d_SelectWholeMesh() 
 ig3d_CombineSelectedMeshOverlaps_f(1)
 polycount =ig3d_GetNumberOfPolys__i()
 ig3d_CombineEqualMeshMaterials() 
 ig3d_SaveMesh_sf_b(gameroot.."Data/WTF/Dungeons/DM"..currentLevel..".wtf",100)
 ig3d_InvertMeshSelection()

 editingModeSwitch("select_entity")
	lookbutton()
 end
-- Reset all buttons
function resetMapper()
local s=""
for i = 0,GridSize-1,1 do
for ii = 0,GridSize-1,1 do
btnm = "x"..tostring(i).."y"..tostring(ii)
s=s..btnm..":color("..baseBtnColor..")\n"
end
end
local a =loadstring(s)
a()
resestGrid()
DWindow:redraw()
textmapXY={}
textArray={}
btnListXY={}
parseDungeon(currentLevel+1)
ButtonSpawnXY()
DWindow:redraw()
saveMapOut()
ulistBtnList()
BtnBrowser:redraw()
end
--saveMapout
function saveMapOut()
local s=""
local sb=""
	tFile = io.open("dungeonmap"..currentLevel..".lua","w")
	if tFile ~= nil then 
		for i=1,#textArray,1 do
		sb=sb..textArray[i]
		if string.len(sb) == 52 then 
		
		s=s..Q..sb..Q..",\n"
		sb=""
		end	
		end
		s="{\n"..string.sub(s,1,-3).."\n}"
		for i=1,#dsbtext2map[currentLevel+1]-1,1 do
		sb=sb..dsbtext2map[currentLevel+1][i]..","
		end
		se="dsb_text2map("..sb..s.."\n)"
		tFile:write(se)
		io.close(tFile)
		
	end	
end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Click Grid 256")
DWindow:label(gLabelTable[#gLabelTable])
DWindow:callback(wClose)
DWindow:resize(6,325,395,393)
DWindow:when(1)
Fl_Group:current():resizable(DWindow)
DWindow:size_range(260,260,873,850)
--DWindow:show()
do keeper= fltk:Fl_Scroll(0,0,0,0,"")
keeper:resize(0,0,390,390)
keeper:type(7)
keeper:align(5)
Fl_Group:current():resizable(keeper)
do grp= fltk:Fl_Group(0,0,0,0,"")
grp:resize(0,0,390,390)
grp:when(1)
Fl_Group:current():resizable(grp)
Fl_Group:current(Fl_Group:current():parent())
end
end
end
DWindow:show()

DWindow:show()
startGrid()
DWindow:redraw()
timer = murgaLua.createFltkTimer()
timer:callback(stackcb)
timer:do_callback()
-- Mapper MENU FUNCTIONS
MapperMenuIndex={}
MapperMenuText={}
MapperMenuText.Source={"New","Open" ,"Save","Duplicate"}
MapperMenuText.Maps={}

function fillMapperSourceMenu()
if BtnBrowser == nil then return end;
	for  i=1,#MapperMenuText.Source,1 do
	menuLine="File/"..MapperMenuText.Source[i]
	MapperMenu:add(menuLine);
	table.insert(MapperMenuIndex,menuLine)
	end
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
MapperMenu:redraw()
end 

function fillMapperControlMenu()
if BtnBrowser == nil then return end;
for  i=0,#dsbtext2map-1,1 do
	menuLine="Maps/"..tostring(i)
	MapperMenu:add(menuLine);
	table.insert(MapperMenuIndex,menuLine)
	end
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
--All
--for  i=1,#MapperMenuText.Control,1 do
--	menuLine="All/"..MapperMenuText.Control[i]
--	MapperMenu:add(menuLine);
--	table.insert(MapperMenuIndex,menuLine)
--	end
MapperMenu:redraw()
--fltk_update()
end


function MapperCurrentPick(tPick)
print(tPick)
currentLevel =tonumber(tPick)

resetMapper()

	quadGrid()
end


function MapperBrowsersMenuPick(tPick)
if BtnBrowser == nil then return end;
--CurMapperInfo()	
print(tPick)
if tPick == "New" then return end

		
if tPick == "Duplicate" then MakeMapper() end;

if tPick == "Open" then
tFile =  chooseFile(tTitle,"*.lua","/")
if tFile ~= nil then dofile(tFile) end
textmapXY={}
resetMapper()
quadGrid()
end

if tPick == "Save" then
local s=""
local sc=0
local sb=""
MapTextFld:clear()
MapTextWindow:show()

	--
	local f =  chooseFile("Save Lua","*.lua",gameroot.."Data/WTF/Dungeons/")
	print(f)
if f == nil then return end
local tFile = io.open(gameroot..f,"w")
--tFile:write(string.char(10))

	if tFile == nil then return end 
		for i=1,#textArray,1 do
		sb=sb..textArray[i]
		if string.len(sb) == 52 then 
		MapTextFld:add(sb)
		MapTextWindow:redraw()
		s=s..Q..sb..Q..",\n"
		sb=""
		end	
		end
		s="{\n"..string.sub(s,1,-3).."\n}"
		tFile:write(s)
		io.close(tFile)	
		
	
end

end




function Mapper_menu_callback(w)
if BtnBrowser == nil then return end;
tMenu = w:label()
tVal = w:value()
tPick = w:text()
tIndex = MapperMenuIndex[tVal]
tIndex1 = MapperMenuIndex[tVal-1]
tIndex2 = MapperMenuIndex[tVal+1]

	if tIndex ~=nil  then 
	MappermenuHead=item(1,tIndex,"/")

 		if MappermenuHead == "File" then MapperBrowsersMenuPick(tPick) end;
 		if MappermenuHead == "Maps" then MapperCurrentPick(tPick) end;
 		if MappermenuHead == "All" 	then  MapperAllMenuPick(tPick) end;
 		
 	 end 
 	 if tIndex1 == "All/Clear" then MapperAllMenuPick("Clear") end
 	 if tIndex1 == "Current/Clear" then MapperCurrentPick("Clear") end
  Fl:check();
   io.flush();
end

function Mapper_MenuBarFill()
if BtnBrowser == nil then return end;
fillMapperSourceMenu()
fillMapperControlMenu()
end
do BtnBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
BtnBrowser:callback(wClose)
BtnBrowser:resize(6,50,136,251)
--BtnBrowser:show()
do MapperMenu= fltk:Fl_Menu_Bar(0,0,0,0,"")
menudir0=""
MapperMenu:callback(Mapper_menu_callback)
MapperMenu:resize(-5,-2,145,22)
MapperMenu:color(38)
MapperMenu:labelsize(10)
MapperMenu:textsize(10)
Fl_Group:current(Fl_Group:current():parent())
end

do BtnListBrowser= fltk:Fl_Browser(0,0,0,0,"")
BtnListBrowser:callback(uBtnListBrowserControlClicked)
BtnListBrowser:resize(0,30,50,210)
BtnListBrowser:type(2)
BtnListBrowser:labelsize(10)
BtnListBrowser:textsize(10)
end

do AttrListBrowser= fltk:Fl_Browser(0,0,0,0,"")
AttrListBrowser:callback(uBtnListBrowserControlClicked)
AttrListBrowser:resize(50,30,85,210)
AttrListBrowser:type(2)
AttrListBrowser:labelsize(10)
AttrListBrowser:textsize(10)
end
end
BtnBrowser:show()

do MapTextWindow= fltk:Fl_Double_Window(0,0,0,0,"")
MapTextWindow:callback(wClose)
MapTextWindow:resize(214,631,329,263)
--unknown attribute: hide
Fl_Group:current():resizable(MapTextWindow)
MapTextWindow:size_range(329,263,331,579)
do MapTextFld= fltk:Fl_Browser(0,0,0,0,"")
MapTextFld:resize(0,0,330,576)
MapTextFld:type(2)
MapTextFld:labelsize(9)
MapTextFld:textsize(10)
Fl_Group:current():resizable(MapTextFld)
end
end
MapTextWindow:show()

BtnBrowser:show()
Mapper_MenuBarFill()

MapTextWindow:hide()

BtnBrowser:redraw()
--end
Fl:run()
