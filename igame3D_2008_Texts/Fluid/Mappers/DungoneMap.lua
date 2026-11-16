--function make_window()
Q='"'

grpGrid={}
drpGrid={}
drpColors={}

btnMakeList={}
btnListXY={{}}

GridSize=256
GridSpread=16
nc =  math.random(1,255)
	newcolor = nc
	
btnList={}

dofile("/Applications/dsbtest35/base/dungeonreader.lua")
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

	BtnListBrowser:clear()
	BtnListBrowserIndex={{}}
	tempt={}
	for i =1,#btnListXY,1 do
	tempt=btnListXY[i]
	for ii =1,#tempt,1 do
	if btnListXY[i][ii] == 1 then 
	BtnListBrowser:add(i..","..ii)
	table.insert(BtnListBrowserIndex,{i,ii}) 
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
		
	end
	gLastSelection=w:value()
	
			
end
-- Generate Temporary Grid

function wClose(w)
w:hide()
w=nil
end



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
	x = tonumber(xt)
	n = string.find(tt,"y")
	if n ~= nil  and string.len(tt) > n then 
	y = tonumber(string.sub(tt,n+1,-1))
	--print(x..","..y)
	end
	end
	xys=(x..","..y)
	local s = ""
	for i =1,#btnList,1 do s=s..tostring(btnList[i]).."\n" end
	if string.find(s,xys) == nil then table.insert(btnList,xys) end
	btnListXY[x][y]=1
	w:color(nc)
	w:value(0)
	ulistBtnList()
	Fl:check()
	end
	
	
	
	
	function startGrid()
	--ot = ""
	--local f=io.open("gridout.lua","w")
	--if f~=nil then 
	--f:write("\n")
	--io.close(f)
	--end
	
	--local f=io.open("gridout.lua","a+")
		for i = 1,GridSize,1 do
		btnListXY[i]={}
		for ii = 1,GridSize,1 do
		nc = math.random(1,2)
		fltk.fl_color(nc)
		btnm = "x"..tostring(i).."y"..tostring(ii)
		btnListXY[i][ii]=0
		srun = btnm.."= fltk:Fl_Button("..i*GridSpread..","..ii*GridSpread..","..tostring(GridSpread)..","..tostring(GridSpread)..","..Q..Q..");\n"..btnm..":box(fltk.FL_FLAT_BOX);\n"..btnm..":show()\n"..btnm..":tooltip("..Q..btnm..Q..")\n"..btnm..":callback(gridcb)\n"..btnm..":when(3)\n  keeper:add("..btnm..") \n "
		
		--if f ~= nil then f:write(srun) end
		makeabutton =  loadstring(srun)
		makeabutton()
						
		end
		end
		
--if f ~= nil then io.close(f) end
		
keeper:redraw()	
DWindow:redraw()
	end
	
function stackcb()

if Fl:event_key()==32 then newcolor=fltk.fl_show_colormap(nc) end
Fl:check()
end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Click Grid 256")
DWindow:label(gLabelTable[#gLabelTable])
DWindow:callback(wClose)
DWindow:resize(253,50,258,260)
DWindow:when(1)
Fl_Group:current():resizable(DWindow)
--DWindow:show()
do keeper= fltk:Fl_Scroll(0,0,0,0,"")
keeper:resize(0,0,256,256)
keeper:type(7)
keeper:align(5)
Fl_Group:current():resizable(keeper)
do grp= fltk:Fl_Group(0,0,0,0,"")
grp:resize(0,0,2565,2565)
grp:when(1)
Fl_Group:current(Fl_Group:current():parent())
end
end
end
DWindow:show()

DWindow:show()
startGrid()
timer = murgaLua.createFltkTimer()
timer:callback(stackcb)
timer:do_callback()
-- Mapper MENU FUNCTIONS
MapperMenuIndex={}
MapperMenuText={}
MapperMenuText.Source={"New","Open" ,"Save","Duplicate"}
MapperMenuText.Control={"Run","Stop","Clear"}

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
for  i=1,#MapperMenuText.Control,1 do
	menuLine="Current/"..MapperMenuText.Control[i]
	MapperMenu:add(menuLine);
	table.insert(MapperMenuIndex,menuLine)
	end
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
MapperMenu:add("");
table.insert(MapperMenuIndex,"")
--All
for  i=1,#MapperMenuText.Control,1 do
	menuLine="All/"..MapperMenuText.Control[i]
	MapperMenu:add(menuLine);
	table.insert(MapperMenuIndex,menuLine)
	end
MapperMenu:redraw()
--fltk_update()
end


function MapperCurrentPick(tPick)

		if tPick == "Clear" then
	
		
		end
		
		if tPick == "Run" then		
		
		
		end
		
		if tPick == "Stop" then		
	 
		
		end
end


function MapperBrowsersMenuPick(tPick)
if BtnBrowser == nil then return end;
--CurMapperInfo()	
print(tPick)
if tPick == "New" then

end		
if tPick == "Duplicate" then MakeMapper() end;

if tPick == "Open" then
tFile =  chooseFile(tTitle,"*.lua","/")
if tFile ~= nil then dofile(tFile) end
parseDungeon(1)
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
 		if MappermenuHead == "Current" then MapperCurrentPick(tPick) end;
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
BtnBrowser:resize(11,55,135,248)
--BtnBrowser:show()
do MapperMenu= fltk:Fl_Menu_Bar(0,0,0,0,"")
menudir0=""
MapperMenu:callback(Mapper_menu_callback)
MapperMenu:resize(-5,-2,140,22)
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

BtnBrowser:show()
Mapper_MenuBarFill()
ulistBtnList()
--end
Fl:run()
