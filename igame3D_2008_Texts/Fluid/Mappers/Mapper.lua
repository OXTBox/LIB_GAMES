--function make_window()
-- globals_and_functions_codeblock
counter=95 

function color_cycle(baseColor,counterLimit,counterStep)
counter=counter+counterStep
if counter > counterLimit then counter=counterStep end
fltk.fl_color(baseColor+counter)
end ---color_cycle

function drawBox(w)



mx,my=Fl:event_x(),Fl:event_y()
DWindow:make_current();
print( mx.. " - " ..my )
bx,by= -192+w:x(),-192+w:y()
print(bx+mx,by+my)
color_cycle(1,255,5)
fltk.fl_rectf(mx-12,my-12,mx+12,my+12)
--DWindow:redraw()
end

function drawrectF(qx,qy,qs)
color_cycle(1,255,5)
quadHalf=math.floor(qs/2)
l,t =qx-quadHalf,qy-quadHalf
fltk.fl_rectf(l,t,qs,qs)
end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
DWindow:callback(drawBox)
DWindow:resize(196,123,430,452)
DWindow:when(6)
--DWindow:show()
do widget= fltk:Fl_Group(0,0,0,0,"")
widget:resize(-1,-1,386,381)
do x1y1= fltk:Fl_Button(0,0,0,0,"")
x1y1:callback(drawBox)
x1y1:resize(0,0,64,64)
x1y1:box(fltk.FL_NO_BOX)
x1y1:labelsize(11)
end

do x2y1= fltk:Fl_Button(0,0,0,0,"")
x2y1:callback(drawBox)
x2y1:resize(64,0,64,64)
x2y1:box(fltk.FL_NO_BOX)
x2y1:labelsize(11)
end

do x3y1= fltk:Fl_Button(0,0,0,0,"")
x3y1:callback(drawBox)
x3y1:resize(128,0,64,64)
x3y1:box(fltk.FL_NO_BOX)
x3y1:labelsize(11)
end

do x4y1= fltk:Fl_Button(0,0,0,0,"")
x4y1:callback(drawBox)
x4y1:resize(192,0,64,64)
x4y1:box(fltk.FL_NO_BOX)
x4y1:labelsize(11)
end

do x5y1= fltk:Fl_Button(0,0,0,0,"")
x5y1:callback(drawBox)
x5y1:resize(256,0,64,64)
x5y1:box(fltk.FL_NO_BOX)
x5y1:labelsize(11)
end

do x6y1= fltk:Fl_Button(0,0,0,0,"")
x6y1:callback(drawBox)
x6y1:resize(320,0,64,64)
x6y1:box(fltk.FL_NO_BOX)
x6y1:labelsize(11)
end

do x1y1= fltk:Fl_Button(0,0,0,0,"")
x1y1:callback(drawBox)
x1y1:resize(0,64,64,64)
x1y1:box(fltk.FL_NO_BOX)
x1y1:labelsize(11)
end

do x2y2= fltk:Fl_Button(0,0,0,0,"")
x2y2:callback(drawBox)
x2y2:resize(64,64,64,64)
x2y2:box(fltk.FL_NO_BOX)
x2y2:labelsize(11)
end

do x3y2= fltk:Fl_Button(0,0,0,0,"")
x3y2:callback(drawBox)
x3y2:resize(128,64,64,64)
x3y2:box(fltk.FL_NO_BOX)
x3y2:labelsize(11)
end

do x4y2= fltk:Fl_Button(0,0,0,0,"")
x4y2:callback(drawBox)
x4y2:resize(192,64,64,64)
x4y2:box(fltk.FL_NO_BOX)
x4y2:labelsize(11)
end

do x5y2= fltk:Fl_Button(0,0,0,0,"")
x5y2:callback(drawBox)
x5y2:resize(256,64,64,64)
x5y2:box(fltk.FL_NO_BOX)
x5y2:labelsize(11)
end

do x6y2= fltk:Fl_Button(0,0,0,0,"")
x6y2:callback(drawBox)
x6y2:resize(320,64,64,64)
x6y2:box(fltk.FL_NO_BOX)
x6y2:labelsize(11)
end

do x1y3= fltk:Fl_Button(0,0,0,0,"")
x1y3:callback(drawBox)
x1y3:resize(0,128,64,64)
x1y3:box(fltk.FL_NO_BOX)
x1y3:labelsize(11)
end

do x2y3= fltk:Fl_Button(0,0,0,0,"")
x2y3:callback(drawBox)
x2y3:resize(64,128,64,64)
x2y3:box(fltk.FL_NO_BOX)
x2y3:labelsize(11)
end

do x3y3= fltk:Fl_Button(0,0,0,0,"")
x3y3:callback(drawBox)
x3y3:resize(128,128,64,64)
x3y3:box(fltk.FL_NO_BOX)
x3y3:labelsize(11)
end

do x4y3= fltk:Fl_Button(0,0,0,0,"")
x4y3:callback(drawBox)
x4y3:resize(192,128,64,64)
x4y3:box(fltk.FL_NO_BOX)
x4y3:labelsize(11)
end

do x5y3= fltk:Fl_Button(0,0,0,0,"")
x5y3:callback(drawBox)
x5y3:resize(256,128,64,64)
x5y3:box(fltk.FL_NO_BOX)
x5y3:labelsize(11)
end

do x6y3= fltk:Fl_Button(0,0,0,0,"")
x6y3:callback(drawBox)
x6y3:resize(320,128,64,64)
x6y3:box(fltk.FL_NO_BOX)
x6y3:labelsize(11)
end

do x1y4= fltk:Fl_Button(0,0,0,0,"")
x1y4:callback(drawBox)
x1y4:resize(0,192,64,64)
x1y4:box(fltk.FL_NO_BOX)
x1y4:labelsize(11)
end

do x2y4= fltk:Fl_Button(0,0,0,0,"")
x2y4:callback(drawBox)
x2y4:resize(64,192,64,64)
x2y4:box(fltk.FL_NO_BOX)
x2y4:labelsize(11)
end

do x3y4= fltk:Fl_Button(0,0,0,0,"")
x3y4:callback(drawBox)
x3y4:resize(128,192,64,64)
x3y4:box(fltk.FL_NO_BOX)
x3y4:labelsize(11)
end

do x4y4= fltk:Fl_Button(0,0,0,0,"")
x4y4:callback(drawBox)
x4y4:resize(192,192,64,64)
x4y4:box(fltk.FL_NO_BOX)
x4y4:labelsize(11)
end

do x5y4= fltk:Fl_Button(0,0,0,0,"")
x5y4:callback(drawBox)
x5y4:resize(256,192,64,64)
x5y4:box(fltk.FL_NO_BOX)
x5y4:labelsize(11)
end

do x6y4= fltk:Fl_Button(0,0,0,0,"")
x6y4:callback(drawBox)
x6y4:resize(320,192,64,64)
x6y4:box(fltk.FL_NO_BOX)
x6y4:labelsize(11)
end

do x1y5= fltk:Fl_Button(0,0,0,0,"")
x1y5:callback(drawBox)
x1y5:resize(0,256,64,64)
x1y5:box(fltk.FL_NO_BOX)
x1y5:labelsize(11)
end

do x2y5= fltk:Fl_Button(0,0,0,0,"")
x2y5:callback(drawBox)
x2y5:resize(64,256,64,64)
x2y5:box(fltk.FL_NO_BOX)
x2y5:labelsize(11)
end

do x3y5= fltk:Fl_Button(0,0,0,0,"")
x3y5:callback(drawBox)
x3y5:resize(128,256,64,64)
x3y5:box(fltk.FL_NO_BOX)
x3y5:labelsize(11)
end

do x4y5= fltk:Fl_Button(0,0,0,0,"")
x4y5:callback(drawBox)
x4y5:resize(192,256,64,64)
x4y5:box(fltk.FL_NO_BOX)
x4y5:labelsize(11)
end

do x5y5= fltk:Fl_Button(0,0,0,0,"")
x5y5:callback(drawBox)
x5y5:resize(256,256,64,64)
x5y5:box(fltk.FL_NO_BOX)
x5y5:labelsize(11)
end

do x6y5= fltk:Fl_Button(0,0,0,0,"")
x6y5:callback(drawBox)
x6y5:resize(320,256,64,64)
x6y5:box(fltk.FL_NO_BOX)
x6y5:labelsize(11)
end

do x1y6= fltk:Fl_Button(0,0,0,0,"")
x1y6:callback(drawBox)
x1y6:resize(0,320,64,64)
x1y6:box(fltk.FL_NO_BOX)
x1y6:labelsize(11)
end

do x2y6= fltk:Fl_Button(0,0,0,0,"")
x2y6:callback(drawBox)
x2y6:resize(64,320,64,64)
x2y6:box(fltk.FL_NO_BOX)
x2y6:labelsize(11)
end

do x3y6= fltk:Fl_Button(0,0,0,0,"")
x3y6:callback(drawBox)
x3y6:resize(128,320,64,64)
x3y6:box(fltk.FL_NO_BOX)
x3y6:labelsize(11)
end

do x4y6= fltk:Fl_Button(0,0,0,0,"")
x4y6:callback(drawBox)
x4y6:resize(192,320,64,64)
x4y6:box(fltk.FL_NO_BOX)
x4y6:labelsize(11)
end

do x5y6= fltk:Fl_Button(0,0,0,0,"")
x5y6:callback(drawBox)
x5y6:resize(256,320,64,64)
x5y6:box(fltk.FL_NO_BOX)
x5y6:labelsize(11)
end

do x6y6= fltk:Fl_Button(0,0,0,0,"")
x6y6:callback(drawBox)
x6y6:resize(320,320,64,64)
x6y6:box(fltk.FL_NO_BOX)
x6y6:labelsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
DWindow:show()

DWindow:show();
DWindow:make_current();
DWindow:do_callback();
--end
Fl:run()
