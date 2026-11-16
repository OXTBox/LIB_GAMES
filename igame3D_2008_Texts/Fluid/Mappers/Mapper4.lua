--function make_window()
-- globals_and_functions_codeblock
counter=95 
houseGrid={{32,32}}

objectGrid={}
col,row = 1,1
entityColor=5
esize=2
ep=0

function mapDrop(mx,my)
	nx,ny=mx,my

	for i=1,6,1 do
			
		if i*64 > mx then 
				nx=(i*64)-32
				col=i
				break
			 end
			end

			for i=1,6,1 do
			
			 if i*64 > my then 
				ny=(i*64)-32
				row=i
				break
			 end
			end
	put=0
	fltk.fl_rectf(nx,ny,esize,esize)
	
	for i = 1,#houseGrid,1 do
	co=houseGrid[i][1]..","..houseGrid[i][2]
	cn=nx..","..ny
		if co==cn then
		print("notempty"..houseGrid[i][1],houseGrid[i][2])
		put=1
		break
		end
	end
	
	if put == 0 then table.insert(houseGrid,{nx,ny}) end	
	
end


function drawBox(w)
DWindow:make_current();
fltk.fl_color(entityColor)
	if Fl:event()==1  then
	mx,my=Fl:event_x(),Fl:event_y()
		if esize ~= 8 then 
		fltk.fl_rectf(mx,my,esize,esize)  
		else
		mapDrop(mx,my)
		end
	
	end
end
	






function drawrectF(qx,qy,qs)
color_cycle(1,255,5)
quadHalf=math.floor(qs/2)
l,t =qx-quadHalf,qy-quadHalf
fltk.fl_rectf(l,t,qs,qs)
end
-- Generate Temporary Grid



grpGrid={}
drpGrid={}
drpColors={}
btnList={}
	function startGrid()
		for i = 0,grid:w(),10 do
		for ii = 0,grid:h(),10 do
		table.insert(grpGrid,{i,ii})
		table.insert(drpGrid,{0,0})
		table.insert(btnList,"")
		end
		end
	end


function idleDrag()
local Q = '"'
fe=Fl:event()
if fe == 1 or fe == 5 then 
mx,my=Fl:event_x(),Fl:event_y()
      rx,ry=10,10    
xi,yi = 0,0
ia,ib = 0,0
if mx > DWindow:w()-32 and my > DWindow:h()-32 then return end

		for i = 1,#grpGrid-1,1 do
		
			if mx ~= nil and grpGrid[i][1] ~= nil then 		
		
				if mx >= grpGrid[i][1] and mx <= grpGrid[i][1]+9 and my >= grpGrid[i][2] and my <= grpGrid[i][2]+9 then
				 xi=grpGrid[i][1]
				 ia  = i
			
		 		yi =grpGrid[i][2] 
		 		if drpGrid[ia][1] == 0 then
		 		 nc = math.random(1,255)
		 		drpColors[ia] = nc
				fltk.fl_color(nc) 
			
			
			--fltk.fl_rectf(xi, yi, 10,10)
			btnm = "x"..xi.."y"..yi
				srun = "if "..btnm.." == nil then ".. btnm.."= fltk:Fl_Button("..xi..","..yi..","..tostring(10)..","..tostring(10)..","..Q..Q..");\n"..btnm..":box(fltk.FL_FLAT_BOX);\n"..btnm..":color("..nc..")\n keeper:add("..btnm..") \n "..btnm..":show()\n  end\n;"
				print(btnm)
			a =  loadstring(srun)

				a()

				drpGrid[ia][1] = xi
				drpGrid[ia][2] = yi 
				btnList[ia]=btnm
				end
		 		end
		
			end
		end
		
		
		
		
			

else
	grid:hide()
	
end

if Fl:event() == 2 then 
BtnBrowser:make_current()
	BtnListBrowser:clear()
	for i =1,#btnList,1 do
	if string.len(btnList[i]) > 2 then BtnListBrowser:add(btnList[i]) end
	end
	BtnBrowser:redraw()
	end
DWindow:redraw()	


DWindow:make_current()
Fl:check()
end

function gridCB()
 idleDrag() 


end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "DragGrid")
DWindow:label(gLabelTable[#gLabelTable])
DWindow:resize(6,50,258,260)
DWindow:when(1)
Fl_Group:current():resizable(DWindow)
--DWindow:show()
do keeper= fltk:Fl_Scroll(0,0,0,0,"")
keeper:resize(0,0,256,256)
keeper:type(7)
keeper:align(5)
Fl_Group:current():resizable(keeper)
do grp= fltk:Fl_Group(0,0,0,0,"")
grp:callback(gridCB)
grp:resize(0,0,2565,2565)
grp:when(1)
Fl_Group:current(Fl_Group:current():parent())
end

do grid= fltk:Fl_Button(0,0,0,0,"")
grid:callback(gridCB)
grid:resize(0,0,2560,2560)
grid:box(fltk.FL_UP_FRAME)
grid:down_box(fltk.FL_BORDER_FRAME)
grid:labelsize(11)
end
end
end
DWindow:show()

do BtnBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
BtnBrowser:resize(996,122,159,171)
--BtnBrowser:show()
do BtnListBrowser= fltk:Fl_Browser(0,0,0,0,"")
BtnListBrowser:resize(0,0,160,170)
BtnListBrowser:labelsize(10)
BtnListBrowser:textsize(10)
end
end
BtnBrowser:show()

DWindow:show();
DWindow:make_current();
grid:when(1)
grp:when(1)
grid:hide()


DWindow:show()
startGrid()

timer = murgaLua.createFltkTimer()
timer:callback(idleDrag)
timer:do_callback()

while DWindow  ~= nil do
DWindow:make_current()
idleDrag()
Fl:check()
end
BtnBrowser:show()
--end
Fl:run()
