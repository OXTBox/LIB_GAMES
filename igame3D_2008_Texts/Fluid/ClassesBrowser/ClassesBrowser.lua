--function make_window()
gDefaultEntityClasses={"human","zombie","enemyfighter","mothership","house","wall","gun","cars","plane","explosive","exit","achieavable"}
RTSENTITIES={"Emitters","Human","Zombie","Building","Gun","Car","GUI","BloodPencil"}
gHumanNames={"jacky","masterchief","officer1","officer2","anita","mcTr","true","human","fighter","chick"}
humans={}
cars={}
zombies={}
Characters={}
Characters.name={}
Characters.wif={}
Characters.anims={}
Characters.velocity={}
zombieAnims={}
guns={}
buildings={}
walls={}
-- ClassesBrowserCatch()

function ClassesBrowserCatch()
ClassesBrowser:make_current()
ClassesBrowser:redraw()
fltk_update()
end
-- WTF BROWSER CODE AHEAD 1015
gLastBrowserControlClick=time()
gLastSelection=-1
gDropObject = gameroot.."Data/WTF/Cubes/cube.wtf"
gcWTFBrowserPath=gameroot.."Data/WTF/"
gcWTFBrowserFiles={}
-- (left, top, right, bottom) 
gGLX,gGLY,gGLR,gGLB = ig3d_GetWindowBounds__4i()

function uclistWTFFiles()
gcWTFBrowserFiles={}
    cWTFFileBrowser:clear()
    for file in lfs.dir(gcWTFBrowserPath) do
        if string.sub(file, 1,1)~="." or file==".." then
            local f = gcWTFBrowserPath..'/'..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
             if attr.mode == "file" and string.sub(file, -4,-1)==".wtf" then 
             	local a={file, "file"}
             	table.insert(gcWTFBrowserFiles, a)
             	cWTFFileBrowser:add(file)
             end   
           if attr.mode == "directory" then 
           local a={file, "directory"}
             table.insert(gcWTFBrowserFiles, a)
             cWTFFileBrowser:add(file.."     ->")
	   end  
        end
     end
     
end

function updatecWTFPreviewBox(name)
	fltk.fl_register_images()
	local a=string.gsub(gcWTFBrowserPath, "/WTF/", "/WTFPreviews/")
	print("a= "..a)
	local b=string.sub(name, 1,-5).."_wtf.png"
	local img = Fl_Shared_Image.get(a..b)
	cWTFPreviewBox:color(40)
	if img==nil then
		img=Fl_Shared_Image.get(gameroot.."Data/Images/Colors/white.png")
		cWTFPreviewNote:label("No preview available")
	else
		cWTFPreviewNote:label("")
	end
	
	WPW=cWTFPreviewBox:w()
	WPH=cWTFPreviewBox:h()
	cWTFPreviewBox:image(img,WPW-8,WPH-8)
	--wtfPreviewBox:resize(90,3,WPW-8,WPH-8)
	cWTFPreviewBox:redraw()
end

function cWTFAddObjectClicked(w)
	if cWTFFileBrowser:value()==0 then return end
	local theFile=gcWTFBrowserFiles[tonumber(cWTFFileBrowser:value())]
	if theFile[2]=="directory" then return end
	
	local c=#(gameroot.."Data/WTF/")+1
	local newObj={}
	table.insert(gObjects, newObj)
	local n=#gObjects
	gDropObject = string.sub(gcWTFBrowserPath..theFile[1],c,-1)
	gObjects[n].cObj=make(ig3d_object, gDropObject)
	
end

function cWTFPreviewLoadMesh(w)
	if cWTFFileBrowser:value()==0 then return end
	local theFile=gcWTFBrowserFiles[tonumber(cWTFFileBrowser:value())]
	if theFile[2]=="directory" then return end
	
	local c=#(gameroot)+1
	local newObj={}
	table.insert(gObjects, newObj)
	local n=#gObjects
	loadMesh( string.sub(gcWTFBrowserPath..theFile[1],c,-1))
end

function ucreatePreviewsClicked(w)
	if cWTFFileBrowser:value()==0 then return end
	local theFile=gcWTFBrowserFiles[tonumber(cWTFFileBrowser:value())]
	local a=string.gsub(gcWTFBrowserPath, "/WTF/", "/WTFPreviews/")
	print("a= "..a)
	local b=string.sub(theFile[1], 1,-5).."_wtf.png"
	local c=#gameroot+1
	
	
	if theFile[2]=="file" then
		ig3d_CreateDirectory_s(goDirsUp(a..b,0))
		createWTFPreviewPNG(string.sub(gcWTFBrowserPath..theFile[1], c,-1), a..b)
		updatecWTFPreviewBox(theFile[1])
	end
	
	if theFile[2]=="directory" then
		ig3d_CreateDirectory_s(a..theFile[1])
		batchPreviewsForFolder(string.sub(gcWTFBrowserPath..theFile[1].."/", c,-1), string.sub(a..theFile[1].."/", c,-1))
	end
	ig3d_SetWindowBounds_4i(gGLX,gGLY,gGLR,gGLB)
end


function cWTFbrowserControlDoubleClicked(w)
	--
	local theFile=gcWTFBrowserFiles[tonumber(w:value())]
	if theFile[2]=="directory" then
		if theFile[1]==".." then 
			gcWTFBrowserPath=goDirsUp(gcWTFBrowserPath, 1)
			if string.find(gcWTFBrowserPath,"/WTF/") == nil then
			gcWTFBrowserPath=gameroot.."Data/WTF/"
			end
		else
			gcWTFBrowserPath=gcWTFBrowserPath..theFile[1].."/"
		end
		uclistWTFFiles()
	end
	
end

function cWTFbrowserControlClicked(w)
	if w:value()==0 then return end
	local theFile=gcWTFBrowserFiles[tonumber(w:value())]
	if theFile[2]=="file" then
		updatecWTFPreviewBox(theFile[1])
	end
	
	local t=time()
	
	if t-gLastBrowserControlClick < 0.4 and w:value()==guLastSelection then
		cWTFbrowserControlDoubleClicked(w)
		gLastBrowserControlClick=0
	else
		gLastBrowserControlClick=time()
	end
	guLastSelection=w:value()
	
end
-- ClassListBrowserClicked
function ClassListBrowserClicked(w)
ClassesBrowserCatch()
end
-- ChangeGameType
function ChangeGameType(w)
print(w:value())
makdir = true
for file in lfs.dir(gameroot.."Data/Scripts/") do
        if string.sub(file, 1,1)~="." or file==".." then
        local f = gameroot.."Data/Scripts/"..file
        local attr = lfs.attributes(f)
            assert (type(attr) == "table")  
           	if attr.mode == "directory" then 
          	 local a={file, "directory"}
        	if  file == w:value() then makdir = false end
	   	end  
        end
  end     
        
if makdir == true then lfs.mkdir(gameroot.."Data/Scripts/"..w:value().."_Entities/") end
end
do ClassesBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
ClassesBrowser:resize(489,150,564,310)
--ClassesBrowser:show()
do ClassListBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Class")
ClassListBrowser:label(gLabelTable[#gLabelTable])
ClassListBrowser:callback(ClassListBrowserClicked)
ClassListBrowser:resize(0,40,110,240)
ClassListBrowser:type(2)
ClassListBrowser:labelsize(10)
ClassListBrowser:align(1)
ClassListBrowser:textsize(11)
end

do AddClassInput= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "+")
AddClassInput:label(gLabelTable[#gLabelTable])
AddClassInput:tooltip("add class")
AddClassInput:resize(15,281,95,24)
AddClassInput:labelsize(12)
AddClassInput:textsize(11)
end

do ClassObjectsGroup= fltk:Fl_Group(0,0,0,0,"")
ClassObjectsGroup:resize(111,32,509,288)
do ClassObjectsBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Class Objects")
ClassObjectsBrowser:label(gLabelTable[#gLabelTable])
ClassObjectsBrowser:callback(uWTFbrowserControlClicked)
ClassObjectsBrowser:resize(111,40,110,240)
ClassObjectsBrowser:labelsize(10)
ClassObjectsBrowser:align(1)
ClassObjectsBrowser:textsize(11)
end

do AddObjectBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "<<")
AddObjectBtn:label(gLabelTable[#gLabelTable])
AddObjectBtn:resize(223,40,40,20)
end

do DeleteObjectBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Delete")
DeleteObjectBtn:label(gLabelTable[#gLabelTable])
DeleteObjectBtn:resize(222,75,40,20)
DeleteObjectBtn:labelsize(10)
end

do WTFBrowserGroup= fltk:Fl_Group(0,0,0,0,"")
WTFBrowserGroup:resize(265,32,300,261)
do cWTFFileBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "WTF")
cWTFFileBrowser:label(gLabelTable[#gLabelTable])
cWTFFileBrowser:callback(cWTFbrowserControlClicked)
cWTFFileBrowser:resize(271,45,155,235)
cWTFFileBrowser:type(2)
cWTFFileBrowser:labelsize(10)
cWTFFileBrowser:align(1)
cWTFFileBrowser:textsize(11)
end

do cWTFPreviewBox= fltk:Fl_Box(0,0,0,0,"")
cWTFPreviewBox:resize(430,45,128,128)
cWTFPreviewBox:box(fltk.FL_FLAT_BOX)
cWTFPreviewBox:color(40)
cWTFPreviewBox:labelsize(10)
cWTFPreviewBox:align(16)
end

do cWTFPreviewNote= fltk:Fl_Box(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "NO PREVIEW")
cWTFPreviewNote:label(gLabelTable[#gLabelTable])
cWTFPreviewNote:resize(430,104,130,16)
cWTFPreviewNote:labelsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end
Fl_Group:current(Fl_Group:current():parent())
end

do AddClassInput= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Game Type")
AddClassInput:label(gLabelTable[#gLabelTable])
AddClassInput:callback(ChangeGameType)
AddClassInput:tooltip("add class")
AddClassInput:resize(70,1,150,24)
AddClassInput:labelsize(12)
AddClassInput:when(8)
AddClassInput:textsize(11)
end
end
ClassesBrowser:show()

ClassesBrowser:show()
ClassesBrowser:make_current()
for i=1,#gDefaultEntityClasses,1 do
ClassListBrowser:add(gDefaultEntityClasses[i])
end
uclistWTFFiles()
--end
Fl:run()
