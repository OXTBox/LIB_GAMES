--function make_window()
dofile(gameroot.."Data/Scripts/Functions/dungeon_functions.lua")
do DungeonMapperWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Click Grid 256")
DungeonMapperWindow:label(gLabelTable[#gLabelTable])
DungeonMapperWindow:callback(wClose)
DungeonMapperWindow:resize(218,377,330,334)
DungeonMapperWindow:when(1)
Fl_Group:current():resizable(DungeonMapperWindow)
DungeonMapperWindow:size_range(260,260,912,854)
--DungeonMapperWindow:show()
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
DungeonMapperWindow:show()

DungeonMapperWindow:show()
startGrid()
resetAllButtons()
resetDSB()

newbsdtext2Map()
DungeonMapperWindow:redraw()
timer = murgaLua.createFltkTimer()
timer:callback(stackcb)
timer:do_callback()
do BtnBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
BtnBrowser:callback(wClose)
BtnBrowser:resize(6,50,137,220)
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
BtnListBrowser:callback(uBtnListBrowserControlClicked)
BtnListBrowser:resize(5,30,45,190)
BtnListBrowser:type(2)
BtnListBrowser:labelsize(10)
BtnListBrowser:textsize(10)
end

do AttrListBrowser= fltk:Fl_Browser(0,0,0,0,"")
AttrListBrowser:resize(50,30,90,190)
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
