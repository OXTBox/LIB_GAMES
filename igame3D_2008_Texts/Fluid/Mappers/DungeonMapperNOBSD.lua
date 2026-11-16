--function make_window()
Q='"'
--loadLevel("Data/Levels/edit/")
ig3d_SetMode_i(1)
baseBtnColor=16
grpGrid={}
drpGrid={}
drpColors={}

btnMakeList={}
btnListXY={{}}
btnList={}
textmapXY={}
XYSpawned={}

GridSize=52
GridSpread=8
nc =  math.random(1,255)
	newcolor = nc

currentLevel=0


nTagNumber=0
vgridwidth=4
vgridlength=4
vcubewidth=4
vcubelength=4
vcubeheight=4
gridSize,cubeSize=4,4
gridSize,quadSize=4,4

WEWall = nil
NSWall = nil
TheFloor=nil

gMapFile=""
gMapOutFile=""
gBSDDungeonOutFile=""

dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")
-- uBtnList BROWSER CODE AHEAD 1129
gLastBrowserControlClick=os.time()
gLastSelection=-1
guSelectedBtn=""
BtnListBrowserIndex ={{}}


function ulistBtnList()
--broken?
if God == nil then return end
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
	if #btnListXY > 1 then return end 
	for i =1,#btnListXY,1 do
	if type(btnListXY[i]) ~= nil then 
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
	textArray={}
		for i = 1,GridSize,1 do
		btnListXY[i]={}
		textmapXY[i]={}
		for ii = 1,GridSize,1 do
		table.insert(textArray,0)
		nc = math.random(1,2)
		fltk.fl_color(nc)
		btnm = "x"..tostring(i-1).."y"..tostring(ii-1)
		btnListXY[i][ii]=0
		srun = btnm.."= fltk:Fl_Button("..(i-1)*GridSpread..","..(ii-1)*GridSpread..","..tostring(GridSpread)..","..tostring(GridSpread)..","..Q..Q..");\n"..btnm..":box(fltk.FL_FLAT_BOX);\n"..btnm..":show()\n"..btnm..":tooltip("..Q..btnm..Q..")\n"..btnm..":callback(gridcb)\n"..btnm..":when(3)\n  keeper:add("..btnm..") \n "
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
	


function stackcb()

if Fl:event_key()==32 then newcolor=fltk.fl_show_colormap(nc) end
fltk_update()
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
		if  WEWall~= nil and NSWall ~= nil  then
		icopyWalls(x,y,face)
		else
		idrawWallZ(x,y,face)
		end
		render()				
	end
	
	-- textmapXY[n][1] or textmapXY[n][2] is the x,y value of the grid input
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
 --ig3d_CombineEqualMeshMaterials() 
 ig3d_SaveMesh_sf_b(gameroot.."Data/WTF/Dungeons/DM"..currentLevel..".wtf",100)
 ig3d_InvertMeshSelection()

 editingModeSwitch("select_entity")
	lookbutton()
 end
-- Reset all buttons

function resetAllButtons()
local s=""
for i = 0,GridSize-1,1 do
for ii = 0,GridSize-1,1 do
btnm = "x"..tostring(i).."y"..tostring(ii)
s=s..btnm..":color("..baseBtnColor..")\n"
end
end
ClearAllButtons =loadstring(s)
end
-- resetGrid
function resetGrid()
btnListXY={}
textmapXY={}
--textArray={}
		for i = 1,GridSize,1 do
		btnListXY[i]={}
		textmapXY[i]={}	
		for ii = 1,GridSize,1 do
		
		textArray[i*ii]="0"
		btnListXY[i][ii]=0
		textmapXY[i][ii]=0			
		end
		end
end
-- resetDSB
function resetDSB()
listSpawnxy = {}
spawnXY={}
XYSpawned={}
for i=1,GridSize,1 do
XYSpawned[i]={}
for ii=1,GridSize,1 do
XYSpawned[i][ii]={}
end
end
dsbspawn ={}
spawninpack={}
exvar={}
dsbaddchampion={}
dsbtext2map={}
wallset={}
spawngrid={{}}
spawnindex={}
spawntext=""
spawnXY={}
spawnindex={}
foundindex={}
level=nil
which=nil
dofile(gameroot.."Data/Scripts/Convert/DSB_Dungeons.lua")
dofile(gameroot.."Data/Scripts/Convert/DSB_global.lua")
end
-- resetMapper

function resetMapper()
GridSize=52
GridSpread=8
--nTagNumber=0
vgridwidth=4
vgridlength,vcubewidth=4,4
vcubelength,vcubeheight=4,4
gridSize,cubeSize=4,4
gridSize,quadSize=4,4
WEWall = nil
NSWall = nil
TheFloor=nil
grpGrid={}
drpGrid={}
drpColors={}
btnMakeList={}
btnListXY={}
btnList={}
cubewalls={}
quadwalls={}

ClearAllButtons()
resetGrid()
DWindow:redraw()
resetDSB()
end
--saveMapout
function saveMapOut()
local s=""
local sb=""
if currentLevel == 0 then currentLevel = 1 end
	gMapOutFile = gameroot.."Data/WTF/Dungeons/"..fileShortNameFromPath(gMapFile)..currentLevel.."_dungeonout.lua"
	
	tFile = io.open(gMapOutFile,"w")
	if tFile ~= nil then 
		for i=1,#textArray,1 do
		sb=sb..textArray[i]
		if string.len(sb) == 52 then 
		
		s=s..Q..sb..Q..",\n"
		sb=""
		end	
		end
		s="{\n"..string.sub(s,1,-3).."\n}"
		
		for i=1,#dsbtext2map[currentLevel]-1,1 do
		sb=sb..dsbtext2map[currentLevel][i]..","
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
DWindow:resize(6,153,330,334)
DWindow:when(1)
Fl_Group:current():resizable(DWindow)
DWindow:size_range(260,260,912,854)
--DWindow:show()
do keeper= fltk:Fl_Scroll(0,0,0,0,"")
keeper:resize(0,0,328,328)
keeper:type(7)
keeper:align(5)
Fl_Group:current():resizable(keeper)
do grp= fltk:Fl_Group(0,0,0,0,"")
grp:resize(0,0,325,320)
grp:when(1)
Fl_Group:current():resizable(grp)
Fl_Group:current(Fl_Group:current():parent())
end
end
end
DWindow:show()

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


menuLine="Convert/".."to 3D"
MapperMenu:add(menuLine);
table.insert(MapperMenuIndex,menuLine)
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
MapperMenu:redraw()
fltk_update()
end


function MapperCurrentPick(tPick)
print(tPick)
if tPick == nil or tPick == 0 then tPick = 1 end
print(gMapFile)
resetMapper()
dofile(gMapFile)

dungeonout()
dofile(gameroot.."Data/WTF/Dungeons/"..fileShortNameFromPath(gMapFile).."_dungeonout.lua")


if currentLevel == nil or currentLevel == 0 then currentLevel = 1 end
parseDungeon(currentLevel)
		ButtonSpawnXY()
		--ulistBtnList()
		Mapper_MenuBarFill()
		MapperMenu:redraw()
		BtnBrowser:redraw()
		fltk_update()		
		quadGrid()	
end


function MapperBrowsersMenuPick(tPick)
if BtnBrowser == nil then return end;
--CurMapperInfo()	
print(tPick)
if tPick == "New" then resetMapper() end		
--if tPick == "Duplicate" then MakeMapper() end;

if tPick == "Open" then
gMapFile =  chooseFile(tTitle,"*.lua",gameroot.."Data/WTF/Dungeons/")
	if tFile ~= nil then 
	gMapFile = gameroot..tFile
	resetMapper()
	dofile(gMapFile)
	currentLevel=1
		if #dsbtext2map > 0 then 
		parseDungeon(currentLevel)
		ButtonSpawnXY()
		--ulistBtnList()
		Mapper_MenuBarFill()
		BtnBrowser:redraw()
		
		--quadGrid()
		end
	end
--

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
	gMapFile = gameroot..f
		for i=1,#textArray,1 do
		sb=sb..textArray[i]
		if sb==nil then return end
		if string.len(sb) == 52 then 
		MapTextFld:add(sb)
		MapTextWindow:redraw()
		s=s..Q..sb..Q..",\n"
		sb=""
		end	
		end
		s="dsb_text2map(0, 52, 52, 100, 0, {\n"..string.sub(s,1,-3).."\n})"
		tFile:write(s)
		io.close(tFile)	
	saveMapOut()
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
print(tMenu,tVal,tPick)
print(tIndex,tIndex1,tIndex2)
	if tIndex ~=nil  then 
	MappermenuHead=item(1,tIndex,"/")
	
print(MappermenuHead)
 		if MappermenuHead == "File" then MapperBrowsersMenuPick(tPick) end;
 		if MappermenuHead == "Maps" then MapperCurrentPick(tPick) end;
 		   
 	 end 	
 	 if tIndex1 == "Maps/0" or tIndex1 == "0" then MapperCurrentPick(0) end
  Fl:check();
   io.flush();
end

function Mapper_MenuBarFill()
if BtnBrowser == nil then return end;
fillMapperSourceMenu()
fillMapperControlMenu()
end
DWindow:show()
startGrid()
resetAllButtons()
DWindow:redraw()
timer = murgaLua.createFltkTimer()
timer:callback(stackcb)
timer:do_callback()
do BtnBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
BtnBrowser:callback(wClose)
BtnBrowser:resize(6,50,143,78)
--BtnBrowser:show()
do MapperMenu= fltk:Fl_Menu_Bar(0,0,0,0,"")
menudir0=""
MapperMenu:callback(Mapper_menu_callback)
MapperMenu:resize(-5,-2,150,22)
MapperMenu:color(38)
MapperMenu:labelsize(10)
MapperMenu:textsize(10)
Fl_Group:current(Fl_Group:current():parent())
end

do BtnListBrowser= fltk:Fl_Browser(0,0,0,0,"")
BtnListBrowser:resize(0,30,50,25)
BtnListBrowser:type(2)
BtnListBrowser:labelsize(10)
BtnListBrowser:textsize(10)
--unknown attribute: hide
end

do AttrListBrowser= fltk:Fl_Browser(0,0,0,0,"")
AttrListBrowser:resize(50,30,85,25)
AttrListBrowser:type(2)
AttrListBrowser:labelsize(10)
AttrListBrowser:textsize(10)
--unknown attribute: hide
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
