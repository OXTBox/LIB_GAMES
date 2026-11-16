--function make_window()
do widget= fltk:Fl_Double_Window(0,0,0,0,"")
widget:resize(511,205,195,482)
Fl_Group:current():resizable(widget)
--widget:show()
do widget= fltk:Fl_Group(0,0,0,0,"")
widget:resize(5,10,180,457)
Fl_Group:current():resizable(widget)
do widget= fltk:Fl_Check_Browser(0,0,0,0,"")
widget:resize(10,35,175,185)
widget:labelsize(10)
widget:textsize(10)
end

do widget= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Copies")
widget:label(gLabelTable[#gLabelTable])
widget:resize(125,226,55,19)
widget:labelsize(11)
widget:textsize(11)
end

do widget= fltk:Fl_Menu_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Choose Directory")
widget:label(gLabelTable[#gLabelTable])
widget:resize(5,10,180,20)
widget:labelsize(11)
widget:textsize(10)
end

do widget= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Level Models")
widget:label(gLabelTable[#gLabelTable])
widget:resize(10,268,175,199)
widget:labelsize(12)
widget:align(1)
widget:textfont(4)
widget:textsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
widget:show()

--end
Fl:run()
