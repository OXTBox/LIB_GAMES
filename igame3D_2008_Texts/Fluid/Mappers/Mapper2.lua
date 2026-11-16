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
tempGrid={}

function dragGridLong()
	if Fl:event()==1 or Fl:event()==5 then
	DWindow:make_current();
	
	mx,my=Fl:event_x(),Fl:event_y()
   

	tempGrid={}
	for i = 1,384-mx,mx do
		for ii = 1,384-my,my do
		table.insert(tempGrid,{i,ii})
		
		fltk.fl_color(math.random(1,255))
		fltk.fl_rectf(i, ii, mx,my)  
		
		
		end
	end
	end
	
	

end

function idleDrag()
DWindow:make_current();
end

function dragGrid(w)
 
	if Fl:event()==1 or Fl:event()==5 then
	DWindow:make_current();
	mx,my=Fl:event_x(),Fl:event_y()
	if w:label() ~= "DragGrid" then
        rx,ry=w:x()-mx, w:y()-my
        else
        rx,ry=mx/6,my/6
        end
        

	tempGrid={}
	for i = 1,384-mx,mx do
		for ii = 1,384-my,my do
		table.insert(tempGrid,{i,ii})
		
		fltk.fl_color(math.random(1,255))
		fltk.fl_rectf(i, ii, rx,ry)  
		
		
		end
	end
	end

	

end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "DragGrid")
DWindow:label(gLabelTable[#gLabelTable])
DWindow:callback(dragGrid)
DWindow:resize(196,123,430,452)
DWindow:when(6)
--DWindow:show()
do grp= fltk:Fl_Group(0,0,0,0,"")
grp:callback(dragGrid)
grp:resize(-1,-1,386,385)
grp:when(1)
do x1y1= fltk:Fl_Box(0,0,0,0,"")
x1y1:callback(dragGrid)
x1y1:resize(0,0,64,64)
x1y1:box(fltk.FL_BORDER_FRAME)
x1y1:labelsize(11)
end

do x2y1= fltk:Fl_Box(0,0,0,0,"")
x2y1:callback(dragGrid)
x2y1:resize(64,0,64,64)
x2y1:box(fltk.FL_BORDER_FRAME)
x2y1:labelsize(11)
end

do x3y1= fltk:Fl_Box(0,0,0,0,"")
x3y1:callback(dragGrid)
x3y1:resize(128,0,64,64)
x3y1:box(fltk.FL_BORDER_FRAME)
x3y1:labelsize(11)
end

do x4y1= fltk:Fl_Box(0,0,0,0,"")
x4y1:callback(dragGrid)
x4y1:resize(192,0,64,64)
x4y1:box(fltk.FL_BORDER_FRAME)
x4y1:labelsize(11)
end

do x5y1= fltk:Fl_Box(0,0,0,0,"")
x5y1:callback(dragGrid)
x5y1:resize(256,0,64,64)
x5y1:box(fltk.FL_BORDER_FRAME)
x5y1:labelsize(11)
end

do x6y1= fltk:Fl_Box(0,0,0,0,"")
x6y1:callback(dragGrid)
x6y1:resize(320,0,64,64)
x6y1:box(fltk.FL_BORDER_FRAME)
x6y1:labelsize(11)
end

do x1y1= fltk:Fl_Box(0,0,0,0,"")
x1y1:callback(dragGrid)
x1y1:resize(0,64,64,64)
x1y1:box(fltk.FL_BORDER_FRAME)
x1y1:labelsize(11)
end

do x2y2= fltk:Fl_Box(0,0,0,0,"")
x2y2:callback(dragGrid)
x2y2:resize(64,64,64,64)
x2y2:box(fltk.FL_BORDER_FRAME)
x2y2:labelsize(11)
end

do x3y2= fltk:Fl_Box(0,0,0,0,"")
x3y2:callback(dragGrid)
x3y2:resize(128,64,64,64)
x3y2:box(fltk.FL_BORDER_FRAME)
x3y2:labelsize(11)
end

do x4y2= fltk:Fl_Box(0,0,0,0,"")
x4y2:callback(dragGrid)
x4y2:resize(192,64,64,64)
x4y2:box(fltk.FL_BORDER_FRAME)
x4y2:labelsize(11)
end

do x5y2= fltk:Fl_Box(0,0,0,0,"")
x5y2:callback(dragGrid)
x5y2:resize(256,64,64,64)
x5y2:box(fltk.FL_BORDER_FRAME)
x5y2:labelsize(11)
end

do x6y2= fltk:Fl_Box(0,0,0,0,"")
x6y2:callback(dragGrid)
x6y2:resize(320,64,64,64)
x6y2:box(fltk.FL_BORDER_FRAME)
x6y2:labelsize(11)
end

do x1y3= fltk:Fl_Box(0,0,0,0,"")
x1y3:callback(dragGrid)
x1y3:resize(0,128,64,64)
x1y3:box(fltk.FL_BORDER_FRAME)
x1y3:labelsize(11)
end

do x2y3= fltk:Fl_Box(0,0,0,0,"")
x2y3:callback(dragGrid)
x2y3:resize(64,128,64,64)
x2y3:box(fltk.FL_BORDER_FRAME)
x2y3:labelsize(11)
end

do x3y3= fltk:Fl_Box(0,0,0,0,"")
x3y3:callback(dragGrid)
x3y3:resize(128,128,64,64)
x3y3:box(fltk.FL_BORDER_FRAME)
x3y3:labelsize(11)
end

do x4y3= fltk:Fl_Box(0,0,0,0,"")
x4y3:callback(dragGrid)
x4y3:resize(192,128,64,64)
x4y3:box(fltk.FL_BORDER_FRAME)
x4y3:labelsize(11)
end

do x5y3= fltk:Fl_Box(0,0,0,0,"")
x5y3:callback(dragGrid)
x5y3:resize(256,128,64,64)
x5y3:box(fltk.FL_BORDER_FRAME)
x5y3:labelsize(11)
end

do x6y3= fltk:Fl_Box(0,0,0,0,"")
x6y3:callback(dragGrid)
x6y3:resize(320,128,64,64)
x6y3:box(fltk.FL_BORDER_FRAME)
x6y3:labelsize(11)
end

do x1y4= fltk:Fl_Box(0,0,0,0,"")
x1y4:callback(dragGrid)
x1y4:resize(0,192,64,64)
x1y4:box(fltk.FL_BORDER_FRAME)
x1y4:labelsize(11)
end

do x2y4= fltk:Fl_Box(0,0,0,0,"")
x2y4:callback(dragGrid)
x2y4:resize(64,192,64,64)
x2y4:box(fltk.FL_BORDER_FRAME)
x2y4:labelsize(11)
end

do x3y4= fltk:Fl_Box(0,0,0,0,"")
x3y4:callback(dragGrid)
x3y4:resize(128,192,64,64)
x3y4:box(fltk.FL_BORDER_FRAME)
x3y4:labelsize(11)
end

do x4y4= fltk:Fl_Box(0,0,0,0,"")
x4y4:callback(dragGrid)
x4y4:resize(192,192,64,64)
x4y4:box(fltk.FL_BORDER_FRAME)
x4y4:labelsize(11)
end

do x5y4= fltk:Fl_Box(0,0,0,0,"")
x5y4:callback(dragGrid)
x5y4:resize(256,192,64,64)
x5y4:box(fltk.FL_BORDER_FRAME)
x5y4:labelsize(11)
end

do x6y4= fltk:Fl_Box(0,0,0,0,"")
x6y4:callback(dragGrid)
x6y4:resize(320,192,64,64)
x6y4:box(fltk.FL_BORDER_FRAME)
x6y4:labelsize(11)
end

do x1y5= fltk:Fl_Box(0,0,0,0,"")
x1y5:callback(dragGrid)
x1y5:resize(0,256,64,64)
x1y5:box(fltk.FL_BORDER_FRAME)
x1y5:labelsize(11)
end

do x2y5= fltk:Fl_Box(0,0,0,0,"")
x2y5:callback(dragGrid)
x2y5:resize(64,256,64,64)
x2y5:box(fltk.FL_BORDER_FRAME)
x2y5:labelsize(11)
end

do x3y5= fltk:Fl_Box(0,0,0,0,"")
x3y5:callback(dragGrid)
x3y5:resize(128,256,64,64)
x3y5:box(fltk.FL_BORDER_FRAME)
x3y5:labelsize(11)
end

do x4y5= fltk:Fl_Box(0,0,0,0,"")
x4y5:callback(dragGrid)
x4y5:resize(192,256,64,64)
x4y5:box(fltk.FL_BORDER_FRAME)
x4y5:labelsize(11)
end

do x5y5= fltk:Fl_Box(0,0,0,0,"")
x5y5:callback(dragGrid)
x5y5:resize(256,256,64,64)
x5y5:box(fltk.FL_BORDER_FRAME)
x5y5:labelsize(11)
end

do x6y5= fltk:Fl_Box(0,0,0,0,"")
x6y5:callback(dragGrid)
x6y5:resize(320,256,64,64)
x6y5:box(fltk.FL_BORDER_FRAME)
x6y5:labelsize(11)
end

do x1y6= fltk:Fl_Box(0,0,0,0,"")
x1y6:callback(dragGrid)
x1y6:resize(0,320,64,64)
x1y6:box(fltk.FL_BORDER_FRAME)
x1y6:labelsize(11)
end

do x2y6= fltk:Fl_Box(0,0,0,0,"")
x2y6:callback(dragGrid)
x2y6:resize(64,320,64,64)
x2y6:box(fltk.FL_BORDER_FRAME)
x2y6:labelsize(11)
end

do x3y6= fltk:Fl_Box(0,0,0,0,"")
x3y6:callback(dragGrid)
x3y6:resize(128,320,64,64)
x3y6:box(fltk.FL_BORDER_FRAME)
x3y6:labelsize(11)
end

do x4y6= fltk:Fl_Box(0,0,0,0,"")
x4y6:callback(dragGrid)
x4y6:resize(192,320,64,64)
x4y6:box(fltk.FL_BORDER_FRAME)
x4y6:labelsize(11)
end

do x5y6= fltk:Fl_Box(0,0,0,0,"")
x5y6:callback(dragGrid)
x5y6:resize(256,320,64,64)
x5y6:box(fltk.FL_BORDER_FRAME)
x5y6:labelsize(11)
end

do x6y6= fltk:Fl_Box(0,0,0,0,"")
x6y6:callback(dragGrid)
x6y6:resize(320,320,64,64)
x6y6:box(fltk.FL_BORDER_FRAME)
x6y6:labelsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end

do HumansBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Humans")
HumansBtn:label(gLabelTable[#gLabelTable])
HumansBtn:callback(entityBtnClick)
HumansBtn:resize(5,390,52,20)
HumansBtn:labelsize(10)
end

do GunsBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Guns")
GunsBtn:label(gLabelTable[#gLabelTable])
GunsBtn:callback(entityBtnClick)
GunsBtn:resize(65,390,52,20)
GunsBtn:labelsize(10)
end

do BuildingsBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Buildings")
BuildingsBtn:label(gLabelTable[#gLabelTable])
BuildingsBtn:callback(entityBtnClick)
BuildingsBtn:resize(125,390,52,20)
BuildingsBtn:labelsize(10)
end

do CarsBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Cars")
CarsBtn:label(gLabelTable[#gLabelTable])
CarsBtn:callback(entityBtnClick)
CarsBtn:resize(185,390,52,20)
CarsBtn:labelsize(10)
end

do ZombiesBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Zombies")
ZombiesBtn:label(gLabelTable[#gLabelTable])
ZombiesBtn:callback(entityBtnClick)
ZombiesBtn:resize(245,390,52,20)
ZombiesBtn:labelsize(10)
end
end
DWindow:show()

DWindow:show();
DWindow:make_current();


while (Fl:event_key() ~= fltk.FL_Escape) do
Fl:check()
DWindow:do_callback()
end
--end
Fl:run()
