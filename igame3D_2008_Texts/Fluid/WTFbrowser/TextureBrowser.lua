--function make_window()
gLastBrowserControlClick=time()
gLastSelection=-1

gBrowserPath=gameroot.."Data/Images/"
gBrowserFiles={}

function listPNGFiles()
gBrowserFiles={}
    pngFileBrowser:clear()
    for file in lfs.dir(gBrowserPath) do
        if string.sub(file, 1,1)~="." or file==".." then
            local f = gBrowserPath..'/'..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
             if attr.mode == "file" and string.sub(file, -4,-1)==".png" then 
             	local a={file, "file"}
             	table.insert(gBrowserFiles, a)
             	pngFileBrowser:add(file)
             end   
           if attr.mode == "directory" then 
           local a={file, "directory"}
             table.insert(gBrowserFiles, a)
             pngFileBrowser:add(file.."     ->")
	   end  
        end
     end
     
end

function updatePNGPreviewBox(name)
	fltk.fl_register_images()
	local a=gBrowserPath 
	local b=string.sub(name, 1,-5)..".png"
	local img = Fl_Shared_Image.get(a..b)
	pngPreviewBox:color(40)
	if img==nil then
		img=Fl_Shared_Image.get(gameroot.."Data/Images/Colors/white.png")
		pngPreviewNote:label("No preview available")
	else
		pngPreviewNote:label("")
	end
	
	pngPreviewBox:image(img)
	pngPreviewBox:redraw()
end

function pngAddObjectClicked(w)
	if pngFileBrowser:value()==0 then return end
	local theFile=gBrowserFiles[tonumber(pngFileBrowser:value())]
	if theFile[2]=="directory" then return end
	
	local c=#(gameroot.."Data/PNG/")+1
	local newObj={}
	table.insert(gObjects, newObj)
	local n=#gObjects
	gObjects[n].cObj=make(ig3d_object, string.sub(gBrowserPath..theFile[1],c,-1))
end

function pngLoad(w)
	if pngFileBrowser:value()==0 then return end
	local theFile=gBrowserFiles[tonumber(pngFileBrowser:value())]
	if theFile[2]=="directory" then return end
	
	local c=#(gameroot)+1
	local newObj={}
	table.insert(gObjects, newObj)
	local n=#gObjects
	loadTexture( string.sub(gBrowserPath..theFile[1],c,-1))
end

function createPreviewsClicked(w)
	if pngFileBrowser:value()==0 then return end
	local theFile=gBrowserFiles[tonumber(pngFileBrowser:value())]
	local a=gBrowserPath
	local b=string.sub(theFile[1], 1,-5)..".png"
	local c=#gameroot+1
	
	
	if theFile[2]=="file" then
		ig3d_CreateDirectory_s(goDirsUp(a..b,0))
		createPNGPreviewPNG(string.sub(gBrowserPath..theFile[1], c,-1), a..b)
		updatePNGPreviewBox(theFile[1])
	end
	
	if theFile[2]=="directory" then
		ig3d_CreateDirectory_s(a..theFile[1])
		batchPreviewsForFolder(string.sub(gBrowserPath..theFile[1].."/", c,-1), string.sub(a..theFile[1].."/", c,-1))
	end
end


function browserControlDoubleClicked(w)
	--
	local theFile=gBrowserFiles[tonumber(w:value())]
	if theFile[2]=="directory" then
		if theFile[1]==".." then 
			gBrowserPath=goDirsUp(gBrowserPath, 1)
		else
			gBrowserPath=gBrowserPath..theFile[1].."/"
		end
		listPNGFiles()
	end
	
end

function browserControlClicked(w)
	if w:value()==0 then return end
	local theFile=gBrowserFiles[tonumber(w:value())]
	if theFile[2]=="file" then
		updatePNGPreviewBox(theFile[1])
	end
	
	local t=time()
	
	if t-gLastBrowserControlClick < 0.4 and w:value()==gLastSelection then
		browserControlDoubleClicked(w)
		gLastBrowserControlClick=0
	else
		gLastBrowserControlClick=time()
	end
	gLastSelection=w:value()
	
end
do PNGBrowserNew= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "PNG Catalog")
PNGBrowserNew:label(gLabelTable[#gLabelTable])
PNGBrowserNew:resize(401,182,458,296)
--PNGBrowserNew:show()
do pngPreviewBox= fltk:Fl_Box(0,0,0,0,"")
pngPreviewBox:resize(200,0,256,256)
pngPreviewBox:box(fltk.FL_FLAT_BOX)
pngPreviewBox:color(40)
pngPreviewBox:align(16)
end

do pngFileBrowser= fltk:Fl_Browser(0,0,0,0,"")
pngFileBrowser:callback(browserControlClicked)
pngFileBrowser:resize(0,0,200,255)
pngFileBrowser:type(2)
pngFileBrowser:labelsize(10)
pngFileBrowser:when(3)
pngFileBrowser:textsize(10)
end

do pngPreviewNote= fltk:Fl_Box(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "No preview available")
pngPreviewNote:label(gLabelTable[#gLabelTable])
pngPreviewNote:resize(200,255,245,25)
end

do widget= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Load Image")
widget:label(gLabelTable[#gLabelTable])
widget:callback(pngLoad)
widget:resize(5,260,175,25)
end
end
PNGBrowserNew:show()

PNGBrowserNew:show()



listPNGFiles()
--end
Fl:run()
