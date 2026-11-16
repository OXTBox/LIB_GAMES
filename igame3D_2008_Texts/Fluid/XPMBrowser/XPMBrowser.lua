--function make_window()
function getXPM(w)
imagename=w:value()
xpmbrowser:clear()
fltk.fl_register_images()
 my_image=Fl_Shared_Image.get(imagename)
my_image_data=my_image:data()
for i,v in pairs(my_image_data) do
	if i == 1 then 
 someinfo:label(string.find(v,"%d+%s",3))
 end
 xpmbrowser:add(v)
 end
end
do XPMBrowserWindow= fltk:Fl_Double_Window(0,0,0,0,"")
XPMBrowserWindow:resize(427,110,412,530)
--XPMBrowserWindow:show()
do xpmbrowser= fltk:Fl_Browser(0,0,0,0,"")
xpmbrowser:resize(0,5,395,445)
xpmbrowser:textsize(8)
end

do widget= fltk:Fl_File_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "file:")
widget:label(gLabelTable[#gLabelTable])
widget:callback(getXPM)
widget:resize(30,461,355,34)
widget:labelsize(11)
widget:textsize(11)
end

do someinfo= fltk:Fl_Button(0,0,0,0,"")
someinfo:resize(20,505,365,20)
end
end
XPMBrowserWindow:show()

--end
Fl:run()
