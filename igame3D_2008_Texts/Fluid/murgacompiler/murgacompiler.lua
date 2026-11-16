--function make_window()
Q = '"';

C = ',' ;
event_constants = {	["0"]="FL_NO_EVENT",
	["1"]="FL_PUSH",
	["2"]="FL_RELEASE",
	["3"]="FL_ENTER",
	["4"]="FL_LEAVE",
	["5"]="FL_DRAG",
	["6"]="FL_FOCUS",
	["7"]="FL_UNFOCUS",
	["8"]="FL_KEY",
	["9"]="FL_KEYUP",
	["10"]="FL_MOVE",
	["11"]="FL_SHORTCUT",
	["12"]="FL_ACTIVATE",
	["13"]="FL_DEACTIVATE",
	["14"]="FL_SHOW",
	["15"]="FL_HIDE",
	["16"]="FL_VIEWCHANGE",
	["17"]="FL_PASTE",
	["18"]="FL_DND_ENTER",
	["19"]="FL_DND_DRAG",
	["20"]="FL_DND_LEAVE",
	["21"]="FL_DND_RELEASE",
	["21"]="FL_DND_RELEASE",
	["22"]="event_constants[22] = ?",
	["23"]="event_constants[23] = ?"
  } --end event_constants table
function commandupdate()
local luafilepath = pathtoluafile:value()
local N,P = 0,0
for i=string.len(luafilepath),1,-1 do
LL=string.sub(luafilepath,i,i)
if LL == "." then P = i end
if LL =="/" then 
N = i
break 
end
end

if N ~=0 and P ~= 0 then 
apppathout = string.sub(luafilepath,1,N)
lfs.chdir(apppathout)
fullappath=lfs.currentdir()..string.sub(luafilepath,N,P)
else
fullappath =  lfs.currentdir().."*"
end

pathtoapplication:value(fullappath)
concat =  murgaLua_ExePath .. " -e murgaLua.compileMurgaLua("  .. Q .. luafilepath .. Q .. C .. Q..  murgaLua_ExePath ..Q..C..Q..fullappath..Q..")";
concatenate:value(concat)


end
function event_callback()

  local tCount = 1

  repeat

    Fl:wait(1)

    evt = Fl:event()
    if evt ~=nil and evt >  0  then

    	out:value(evt .. "   " .. event_constants["" .. evt])

	    --	if (evt == 7) then tCount = os.exit() end

	    tCount = tCount + 1
		commandupdate()
	  	DWindow:redraw()
    else
	   	tCount = 1
    end

  until tCount <= 0

end
do DWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "DWindow")
DWindow:label(gLabelTable[#gLabelTable])
DWindow:resize(629,343,752,250)
DWindow:when(6)
--DWindow:show()
do CompileGroup= fltk:Fl_Group(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Compile")
CompileGroup:label(gLabelTable[#gLabelTable])
CompileGroup:resize(15,14,725,221)
CompileGroup:labelsize(11)
do pathtomurgalua= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "/bin/murgaLua")
pathtomurgalua:label(gLabelTable[#gLabelTable])
pathtomurgalua:resize(150,14,413,19)
pathtomurgalua:labelsize(11)
pathtomurgalua:textsize(11)
end

do comarg= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "commandargument")
comarg:label(gLabelTable[#gLabelTable])
comarg:resize(150,34,413,19)
comarg:labelsize(11)
comarg:textsize(11)
end

do mucompiler= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "murgaLuacompileMurgaLua")
mucompiler:label(gLabelTable[#gLabelTable])
mucompiler:resize(150,54,413,19)
mucompiler:labelsize(11)
mucompiler:textsize(11)
end

do pathtoluafile= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "path to lua file")
pathtoluafile:label(gLabelTable[#gLabelTable])
pathtoluafile:resize(150,74,413,19)
pathtoluafile:labelsize(11)
pathtoluafile:when(1)
pathtoluafile:textsize(11)
end

do pathtoapplication= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "path to application")
pathtoapplication:label(gLabelTable[#gLabelTable])
pathtoapplication:resize(150,116,413,19)
pathtoapplication:labelsize(11)
pathtoapplication:textsize(11)
end

do pathtomurga2= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "path to murgaLua")
pathtomurga2:label(gLabelTable[#gLabelTable])
pathtomurga2:resize(150,94,413,19)
pathtomurga2:labelsize(11)
pathtomurga2:textsize(11)
end

do concatenate= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "concatenated")
concatenate:label(gLabelTable[#gLabelTable])
concatenate:resize(15,151,545,84)
concatenate:labelsize(11)
concatenate:align(133)
concatenate:textsize(11)
end

do out= fltk:Fl_Output(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "output:")
out:label(gLabelTable[#gLabelTable])
out:resize(575,21,155,68)
out:labelsize(11)
out:align(5)
out:textsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
DWindow:show()

terminalArg= " -e "
pathtomurgalua:label( murgaLua_ExePath)
pathtomurgalua:value( murgaLua_ExePath)
pathtomurgalua:redraw()

comarg:value(terminalArg)
mucompiler:value("murgaLua.compileMurgaLua")
pathtoluafile:value("/")
pathtomurga2:value( murgaLua_ExePath)
pathtoapplication:value("/")
DWindow:show();

loop=event_callback()

Fl:wait(0);
Fl:run();
--end
Fl:run()
