cCommentsStart="/".."*"
cCommentsEnd="*".."/"
Q='"'
SPC=" "
XPMEndOfFile="};"

aCol,aRow=1,1
XPMreadText=""

-- These values are temporary from Aquarius ScreenShot
XPMimageName="XPMFile.xpm"
XPMImageWidth,XPMImageHeight,XPMNumberOfImageColors,XPMCharsPerPixel = 352,232,16,1
XPMPixelData={}
XPMLines={}
XPMCodesHexOffset = 4 ;-- thats where the xpm hex colors are in the AquariusXPMColorCodes table
math.randomseed(os.time())
-- XPMColorCodes HEX and color names sourced from an Mattel Aquarius 16 color Screenshot
XPMColorCodes={
{"A","Black","0","A c #101010101010"},
{"B","Red","1","B c #F0F010101010"},
{"C","Green","2","C c #1010F0F01010"},
{"D","Yellow","3","D c #F0F0E8E81010"},
{"E","Blue","4", "E c #20202020D8D8"},
{"F","Violet","5", "F c #F0F01010F0F0"},
{"G","Light Blue-Green","6", "G c #3030C0C0C0C0"},
{"H","White","7", "H c #F0F0F0F0F0F0"},
{"I","Light Gray","8", "I c #C0C0C0C0C0C0"},
{"J","Blue Green","9", "J c #2828A8A8A8A8"},
{"K","Magenta","10", "K c #C0C02020C0C0"},
{"L","Dark Blue","11", "L c #404010108888"},
{"M","Light Yellow","12", "M c #F0F0F0F07070"},
{"N","Light Green","13", "N c #2020C8C84040"},
{"O","Orange","14", "O c #A8A820202020"},
{"P","Dark Grey","15", "P c #303030303030"}
}

XPMReadColorLines=""
--
function init_AquaXPMHeaderLines()
XPMLines={}
local XPMHexColorsHeader=""
XPMLines[1]= cCommentsStart.." XPM ".. cCommentsEnd.."\n";
XPMLines[2]="static char *"..XPMimageName.."[] = {\n";
XPMLines[3]=cCommentsStart.." width height ncolors chars_per_pixel ".. cCommentsEnd.."\n";
XPMLines[4]=Q..XPMImageWidth..SPC..XPMImageHeight..SPC..#XPMColorCodes..SPC..XPMCharsPerPixel..Q..",\n";
XPMLines[5]=cCommentsStart..SPC.."colors"..SPC..cCommentsEnd.."\n";

for i =1,#XPMColorCodes,1 do
XPMHexColorsHeader=XPMHexColorsHeader..Q..XPMColorCodes[i][XPMCodesHexOffset]..Q..",\n"
end
XPMLines[6]=XPMHexColorsHeader
XPMLines[7]= cCommentsStart..SPC.."pixels" ..SPC .. cCommentsEnd.. "\n" ;
-- OK now you are ready to write hundreds the XPMStrings that look like this
--  "AABBCCDDEEFFGGHHIIJJKKLLMMNNOOPP"
end

function init_XPMHeaderLines()
XPMLines={}
local XPMHexColorsHeader=""
XPMLines[1]= cCommentsStart.." XPM ".. cCommentsEnd.."\n";
XPMLines[2]="static char *"..XPMimageName.."[] = {\n";
XPMLines[3]=cCommentsStart.." width height ncolors chars_per_pixel ".. cCommentsEnd.."\n";
XPMLines[4]=Q..XPMImageWidth..SPC..XPMImageHeight..SPC..#XPMColorCodes..SPC..XPMCharsPerPixel..Q..",\n";
XPMLines[5]=cCommentsStart..SPC.."colors"..SPC..cCommentsEnd.."\n";

for i =1,#XPMColorCodes,1 do
XPMHexColorsHeader=XPMHexColorsHeader..Q..XPMColorCodes[i][XPMCodesHexOffset]..Q..",\n"
end
XPMLines[6]=XPMReadColorLines
XPMLines[7]= cCommentsStart..SPC.."pixels" ..SPC .. cCommentsEnd.. "\n" ;
-- OK now you are ready to write hundreds the XPMStrings that look like this
--  "AABBCCDDEEFFGGHHIIJJKKLLMMNNOOPP"
end

function init_RandomXPM(w,h)
init_XPMHeaderLines()
local s=""
local sb=""
for i = 1,w,1 do
s=s..string.char(math.random(65,64+#XPMColorCodes))
end
for i =1,h,1 do
sb=sb..Q..s..Q..",\n"
end
XPMLines[#XPMLines+1]=string.sub(sb,1,-3)..XPMEndOfFile
end

function save_XPM(name)
local n = 0
local shortname=""
for i=string.len(name),1,-1 do
	if string.sub(name,i,i) == "/" then 
	if string.sub(name,-4,-4) == "." then
	shortname = string.sub(name,i+1,-5)
	else
	shortname = string.sub(name,i+1,-1)
	end
	end
	if shortname~="" then break end

end
XPMimageName=shortname
--init_RandomXPM(XPMImageWidth,XPMImageHeight)
local XPMDataOut=""
for i = 1,#XPMLines,1 do
		XPMDataOut= XPMDataOut..XPMLines[i]
	end

	f=io.open(name,"w")
	f:write(XPMDataOut)
	io.close(f)
end


function read_XPMImage(name)
local f=io.open(name,"r")
XPMreadText=""
if f==nil then return end
XPMreadText = f:read("*a")
io.close(f)
if XPMreadText== nil then return end
local s,e=string.find(XPMreadText,Q.."A")
colorsText=string.sub(XPMreadText,s,string.find(XPMreadText,"pixels"))
XPMReadColorLines  = string.sub(colorsText,1,-5).."\n"



local s,e=string.find(XPMreadText,"pixels")
XPMreadText=string.sub(XPMreadText,s,-1)
local s,e=string.find(XPMreadText,Q)
XPMreadText=string.sub(XPMreadText,s,-1)
if e== nil then return end
XPMPixelStrings=string.sub(XPMreadText,e,-1)
createpixelTable = "XPMPixelData={"..Q..XPMPixelStrings.."\n"
local a = loadstring(createpixelTable)
a()
return XPMPixelData
end


function dorandomImage()
xpm_file="/test"..math.random(1,4)..".xpm"
save_XPM(xpm_file)
xpm_data=fltk:Fl_XPM_Image(xpm_file)
xpm_box:image(xpm_data)
xpm_box:redraw()
testWindow:redraw()
end

function doImage()
XPMPixelData = read_XPMImage("/aquapacman.xpm")
aCol=aCol+8
local n=aRow+1
if aCol+8 > string.len(XPMPixelData[n]) then 
aCol=1
aRow=aRow+8
end
XPMbitsChar=""

for i = aRow,aRow+7,1 do

getXPMbitsLine=string.sub(XPMPixelData[i],aCol,aCol+7)

XPMbitsChar=XPMbitsChar..Q..getXPMbitsLine..Q..",\n"
end
print(aCol,aRow.."\n"..XPMbitsChar)
XPMImageWidth,XPMImageHeight=8,8
XPMimageName="test"..math.random(1,4)
init_XPMHeaderLines()
XPMLines[#XPMLines+1] = string.sub(XPMbitsChar,1,-3)..XPMEndOfFile
XPMLines[6] = XPMReadColorLines
xpm_file="/"..XPMimageName..".xpm"
local XPMDataOut=""
for i = 1,#XPMLines,1 do
		XPMDataOut= XPMDataOut..XPMLines[i]
	end

	f=io.open(xpm_file,"w")
	f:write(XPMDataOut)
	io.close(f)
	
xpm_data=fltk:Fl_XPM_Image(xpm_file)
xpm_box:image(xpm_data)
xpm_box:redraw()
testWindow:redraw()

end


testWindow=fltk:Fl_Double_Window(500,400,"image-xpm.lua")
xpm_box=fltk:Fl_Box(30,30,300,236)
xpm_box_label=fltk:Fl_Box(30,0,300,30)
DoitButton=fltk:Fl_Button(30,296,300,30,"Do Image")
DoitButton:callback(doImage)





testWindow:show()
Fl:run()
--
