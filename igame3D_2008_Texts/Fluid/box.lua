--function make_window()
do widget= fltk:Fl_Double_Window(0,0,0,0,"")
widget:resize(852,89,100,100)
--widget:show()
do widget= fltk:Fl_Group(0,0,0,0,"")
widget:resize(0,0,100,100)
do widget= fltk:Fl_Box(0,0,0,0,"")
widget:resize(11,12,10,10)
widget:box(fltk.FL_DOWN_FRAME)
end

do widget= fltk:Fl_Box(0,0,0,0,"")
widget:resize(21,22,10,10)
widget:box(fltk.FL_THIN_DOWN_FRAME)
end

do widget= fltk:Fl_Box(0,0,0,0,"")
widget:resize(31,32,10,10)
widget:box(fltk.FL_ENGRAVED_FRAME)
end

do widget= fltk:Fl_Box(0,0,0,0,"")
widget:resize(41,42,10,10)
widget:box(fltk.FL_BORDER_FRAME)
end

do widget= fltk:Fl_Box(0,0,0,0,"")
widget:tooltip("THIS IS TOOLTIP")
widget:resize(51,52,10,10)
widget:box(fltk.FL_BORDER_BOX)
widget:color(8)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
widget:show()

--end
Fl:run()
