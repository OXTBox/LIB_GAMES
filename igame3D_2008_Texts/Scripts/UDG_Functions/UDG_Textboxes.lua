gFontFiles={{"Data/FontPngs/default32_1.png","Data/FontPngs/default32_2.png"},{"Data/FontPngs/Shlop32_1.png","Data/FontPngs/Shlop32_2.png"},{"Data/FontPngs/CRAMPS32_1.png","Data/FontPngs/CRAMPS32_2.png"}}
for i=1,#gFontFiles,1 do
	loadFont(gFontFiles[i][1],gFontFiles[i][2])
end

gTextboxFonts={"Data/FontPngs/default32_1.png","Data/FontPngs/default32_1.png","Data/FontPngs/default32_1.png","Data/FontPngs/default32_1.png"}
gTextboxPositions={}
gTextboxSizes={}
gTextboxColors={}

for i =1,5,1 do 
table.insert(gTextboxFonts,"Data/FontPngs/Shlop32_1.png")
table.insert(gTextboxFonts,"Data/FontPngs/CRAMPS32_1.png")
table.insert(gTextboxPositions,{50,12*i})
table.insert(gTextboxPositions,{50,24*i})
table.insert(gTextboxPositions,{50,36*i})
table.insert(gTextboxSizes,12)
table.insert(gTextboxSizes,12)
table.insert(gTextboxSizes,12)
table.insert(gTextboxColors, {math.random(0,1), math.random(0,1), math.random(0,1)})
table.insert(gTextboxColors, {math.random(0,1), math.random(0,1), math.random(0,1)})
table.insert(gTextboxColors, {math.random(0,1), math.random(0,1), math.random(0,1)})
end
gTextboxes={}

for i=1,#gTextboxFonts,1 do
	gTextboxes[i]=make(ig3d_text_box, gTextboxFonts[i])
	setText_boxInfo(gTextboxes[i], IG3D_POSITION, gTextboxPositions[i][1],gTextboxPositions[i][2])
	setText_boxInfo(gTextboxes[i], IG3D_SIZE, gTextboxSizes[i])
	setText_boxInfo(gTextboxes[i], IG3D_COLOR, gTextboxColors[i][1],gTextboxColors[i][2],gTextboxColors[i][3], gTextboxColors[i][4])
end
gNumTextboxes=#gTextboxFonts


function showLevelLoading(tLevel,state)
setText_boxInfo(gTextboxes[1], IG3D_TEXT, tLevel.."\nLoading\n"..state) 
setText_boxInfo(gTextboxes[1], IG3D_SIZE, 24) 
setText_boxInfo(gTextboxes[1], IG3D_FONT, gTextboxFonts[3]) 
setText_boxInfo(gTextboxes[1], IG3D_POSITION, 40) 
setText_boxInfo(gTextboxes[1], IG3D_COLOR, 1,0,0) 
render()
end