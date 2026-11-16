  -- globals_and_functions_codeblock
  do DWindow = fltk:Fl_Double_Window(752, 250, "DWindow");
    DWindow:when(fltk.FL_WHEN_RELEASE_ALWAYS);
    do CompileGroup = fltk:Fl_Group(25, 14, 413, 19, "Compile");
      CompileGroup:labelsize(11);
      do pathtomurgalua = fltk:Fl_Output(150, 14, 413, 19, "/bin/murgaLua");
        pathtomurgalua:labelsize(11);
        pathtomurgalua:textsize(11);
      end -- Fl_Output* pathtomurgalua
      do comarg = fltk:Fl_Output(150, 34, 413, 19, "comarg");
        comarg:labelsize(11);
        comarg:textsize(11);
      end -- Fl_Output* comarg
      do murgaLuacompileMurgaLua = fltk:Fl_Output(150, 54, 413, 19, "murgaLuacompileMurgaLua");
        murgaLuacompileMurgaLua:labelsize(11);
        murgaLuacompileMurgaLua:textsize(11);
      end -- Fl_Output* murgaLuacompileMurgaLua
      do pathtoluafile = fltk:Fl_Output(150, 74, 413, 19);
        pathtoluafile:labelsize(11);
        pathtoluafile:textsize(11);
      end -- Fl_Output* pathtoluafile
      do pathtoapplication = fltk:Fl_Output(150, 116, 413, 19);
        pathtoapplication:labelsize(11);
        pathtoapplication:textsize(11);
      end -- Fl_Output* pathtoapplication
      do pathtomurgalua = fltk:Fl_Output(150, 94, 413, 19);
        pathtomurgalua:labelsize(11);
        pathtomurgalua:textsize(11);
      end -- Fl_Output* pathtomurgalua
      do concatenate = fltk:Fl_Output(150, 139, 413, 19);
        concatenate:labelsize(11);
        concatenate:textsize(11);
      end -- Fl_Output* concatenate
      Fl_Group:current(Fl_Group:current():parent());
    end -- Fl_Group* CompileGroup
    Fl_Group:current(Fl_Group:current():parent());
  end

  
 
  ptm = pathtomurgalua:label()
pathtomurgalua:value(ptm)

  
 DWindow:show();
 -- ig3d_RebuildMacMenubar();
  if game_func==nil then
  	function runner()
      	fltk_update();
  	end
  	game_func=runner;
  end
  Fl:scheme("plastic")
Fl:run();
