--function make_window()
CameraBrowser=nil

gCurrentCameraInfo = ig3d_GetCameraInfo__s()
gCurrentCameraPosition = getlineof(gCurrentCameraInfo,1)
gCurrentCameraRotation = getlineof(gCurrentCameraInfo,2)

storedSingleSelect=0
gSelector=nil
CameraFileList={}
gSelectedCamera=0
gAttributePicked = 1
gCameraVals={}
CameraFieldValues={}
gCameraFileValues={}
gCameraFileAttributes={}
gLastBrowserControlClick=time()
gCameraBrowserFiles={}
gCameraBrowserFileList={}
gCameraFilesShortNames={}
gCameraSource = ""
gCameraSourcePath = ""

if gCameraNames == nil then 
	gCameraNames={"Current"}
	gCamerasPositions={{0,0,0}}
	gCamerasRotations={{0,0,0}}
	gCameraMatrix={{}}
	end
	
gNumCameras =#gCameraNames
gCameraValues={} ; -- List of current values
-- gCameraAttributes={} ; --List of current attribute names
gCameraAttributes={"name","position","rotation","matrix","target","goto","keys","source"}
gSelCameraData={}  ; --raw input from getInfo
gBrowserCameraPath = gameroot.."Data/Levels/"
gCameraBrowserPath = gBrowserCameraPath
gCatchCameraPath = ""
gSourceRequest = ""  ;-- mode of selecting Camera source from browser
gCameraNewName=""  ; -- hold short name of Camera or Camera name for new make
gNewCameraValueItems={} ;-- multi item list from field values ie x,y,z etc
gCameraValueItems={};-- multi item list from Camera attriute values ie x,y,z etc
gOldInfo = ""
gLastCameraSourceSelection =0
gLastCameraSourceBrowserControlClick = 0
gCameraBrowserFiles={}
gLastSourceDirectory ="Levels"
gCameraShortPath=""
gCameraNum = 0
gCameraInfoAttributes={}
gCameraDetailsInfo ={}
gNumHelpedAttributes=1
gCameraGetInfoTable={}
gCameraToolTipPicked="translate"
gSelCameraData={}
-- CameraBrowserGroupsHide
function CameraBrowserGroupsHide()
  		if gCameraToolTipPicked ~="source" then  
  		CameraSourceGroup:hide() 
  		ReplaceWTFSourceBtn:hide()
		ReplaceAllWTFSourceBtn:hide()
  		end
  		
	

	CameraTextureGroup:hide() 
	CameraSaveAsGroup:hide()
		
		if gCameraToolTipPicked ~="translate" or gNumCameras < 1 then
		CameraInputGroup:hide() 
		CameraValueGroup:hide()
		CameraValInputA:value()
		CameraValInputB:value()
		CameraValInputC:value()
		CameraValInputD:value()
		CameraValInputA:hide()
		CameraValInputB:hide()
		CameraValInputC:hide()
		CameraValInputD:hide()
		CameraBoolBtn:hide()
		CameraNameInput:hide()
		else
		CameraValueGroup:show()
		end
		
		
		
			
	if gCameraToolTipPicked ~="bones" then	CameraBonesGroup:hide() end
		
		if gCameraToolTipPicked ~="materials" then  
		CameraMaterialsGroup:hide() 	
		CameraMaterialsInputGroup:hide() 
		CameraValueGroup:hide()
		CameraMaterialsValInputA:value()
		CameraMaterialsValInputB:value()
		CameraMaterialsValInputC:value()
		CameraMaterialsValInputD:value()
		CameraMaterialsValInputA:hide()
		CameraMaterialsValInputB:hide()
		CameraMaterialsValInputC:hide()
		CameraMaterialsValInputD:hide()
		CameraMaterialsBoolBtn:hide()
		CameraMaterialsNameInput:hide()
		end
		
	
end
--  CameraBrowserValueCatch
function CameraBrowserValueCatch()
CameraFieldValues[1]=CameraListBrowser:value()
CameraFieldValues[2]=CameraAttListBrowser:value()
CameraFieldValues[3]=CameraAttListBrowser:value()
CameraFieldValues[5]=CameraBoolBtn:value()
CameraFieldValues[6]=CameraValInputA:value()
CameraFieldValues[7]=CameraNameInput:value()



curValBool = gCameraValueItems[1]
	if curValBool ~= "true" and curValBool ~= "false" then 	
	curValBool = nil
	end	
	
gNewCameraValueItems={}	
for i=1,#gCameraValueItems,1 do
  if i == 1 then
	if curValBool == nil then
 	
 	table.insert(gNewCameraValueItems,CameraValInputA:value());
 	else
 	table.insert(gNewCameraValueItems,curValBool);
 	end
 	end
 
	if i == 2 then 
	if curValBool == nil then
 	table.insert(gNewCameraValueItems,CameraValInputB:value());
 	else
 	table.insert(gNewCameraValueItems,CameraValInputA:value());
 	end
 	end
 
	if i == 3 then 
	if curValBool == nil then
 	table.insert(gNewCameraValueItems,CameraValInputC:value());
 	else
 	table.insert(gNewCameraValueItems,CameraValInputB:value());
 	end
 	end
 	
	if i == 4 then 
	if curValBool == nil then
 	table.insert(gNewCameraValueItems,CameraValInputD:value());
	else
 	table.insert(gNewCameraValueItems,CameraValInputC:value());
 	end
 	end		
end

 fltk_update()
end
-- CurCameraInfo
function CurCameraInfo()
gCurrentCameraInfo = ig3d_GetCameraInfo__s()
gCurrentCameraPosition = getlineof(gCurrentCameraInfo,1)
gCurrentCameraRotation = getlineof(gCurrentCameraInfo,2)

	
	gSelCameraData={}
	table.insert(gSelCameraData,gCurrentCameraPosition)
	table.insert(gSelCameraData,gCamerasRotations)
	
return gCurrentCameraInfo
end
-- PickedCameraAttribute
function PickedCameraAttribute(n)
if CameraBrowser == nil then return end;
CameraBrowserValueCatch()
if n == nil then n = CameraFieldValues[2] end
if n == nil then return end

gSelectedCameraInfo = CurCameraInfo()
             
CameraBrowserGroupsHide()		
--CameraNameInput:value(gCameraValues[1]) 

 

if gCameraToolTipPicked =="translate" then 

	CameraValueGroup:show()
	CameraInputGroup:show() 
	CameraNameInput:hide()
	CameraValInputA:hide()
	
	--if n == 1 or CameraFieldValues[2] == 1 then 
	-- Camera NAME
	--CameraInputGroup:show()  
	--CameraNameInput:show()
	--CameraNameInput:value(gSelCameraData[1])
	--CameraValInputA:hide()
	--end



	
--if n > 1 then 

	gCameraValueItems={}
	curVal = gSelCameraData[n]
	curValBool=curVal
	curValF=""
	sstr = nil
	print(curVal)
	-- COMMAS
	if curVal ~= nil then 
	fc=string.find(curVal,",")
		if fc == nil then 
		
		table.insert(gCameraValueItems,curVal)
		else
			for i = 1, numberofitems(curVal,","), 1 do
			local va=item(i,curVal,",")
			
			table.insert(gCameraValueItems,va)
			end
		end
		
	end	


if #gCameraValueItems == 1 then 
		CameraValInputA:hide()
		CameraValInputB:hide()
		CameraValInputC:hide()
		CameraValInputD:hide()
		end
-- BOOLS
curValBool = gCameraValueItems[1]
	if curValBool == "true" or curValBool == "false" then 	
	CameraBoolBtn:show()
	CameraBoolBtn:label(gCameraAttributes[n])
		if string.len(curValF) >1  then 
		CameraValInputA:show()
		CameraValInputA:value(tonumber(curValF))
		else
		CameraValInputA:hide()
		end
	else
	if n ~= 1 then 
	CameraValInputA:value(tonumber(curValBool))
	CameraValInputA:show()
	end
	CameraBoolBtn:hide()
	curValBool = nil
	end	
		
	if curValBool == "true" then
	CameraBoolBtn:value(1)
	else
	CameraBoolBtn:value(0)
	end
	
for i=1,#gCameraValueItems,1 do
cCameraValueItem = tonumber(gCameraValueItems[i])
  if i == 1 then
	if curValBool == nil then
 	CameraValInputA:show()
 	CameraValInputA:value(cCameraValueItem)
 	end
 	end
 
	if i == 2 then 
	if curValBool == nil then
	CameraValInputB:show()
 	CameraValInputB:value(cCameraValueItem)
 	else
 	CameraValInputA:show()
 	CameraValInputA:value(cCameraValueItem)
 	end
 	end
 
	if i == 3 then 
	if curValBool == nil then
	CameraValInputC:show()
 	CameraValInputC:value(cCameraValueItem)
 	else
 	CameraValInputB:show()
 	CameraValInputB:value(cCameraValueItem)
 	end
 	end
 	
	if i == 4 then 
	if curValBool == nil then
	CameraValInputD:show()
 	CameraValInputD:value(cCameraValueItem)
 	else
 	CameraValInputC:show()
 	CameraValInputC:value(cCameraValueItem)
 	end
 	end
 	
		
end  -- <5
--end -- > 1
end

fltk_update()
end

-- end PickedCameraAttribute --
-- CameraBrowserWindowUpdate
function CameraBrowserWindowUpdate(arg)
 if CameraBrowser == nil then return end
 CameraBrowser:make_current()
 CameraBrowserValueCatch()
  
 local i = 1
 local FBn,EBLn,EAn = nil,nil,nil
 EAn= CameraFieldValues[2]
CameraBrowserGroupsHide()
 ---- SourceList 
		if arg == "SourceList" then
	local FBn = wtfFileBrowser:value()
		wtfFileBrowser:clear() 
  			for i=1,#gCameraFilesShortNames,1 do
			wtfFileBrowser:add(gCameraFilesShortNames[i])
			end
		end
---- CurCameraInfo	
		if arg == "CurCameraInfo" then
			if gCameraourcePath ~= nil then  
				local ss,se = string.find(gCameraourcePath,"Data/WTF/")
				if se ~= nil then 
				local curCameraName = string.sub(gCameraourcePath,se+1,-1)
				SourceNameInput:value(curCameraName)
				SourceNameInput:redraw()
				end;	
			end;
			updateCameraAttributesTables()
				
			 if #gSelCameraData > 1 then 
			 EAn = CameraFieldValues[2]
			 EBLn = CameraFieldValues[1]
				
				CameraAttListBrowser:clear()
				CameraValueListBrowser:clear()
				
				
			        local i = 1
				for i = 1,#gCameraAttributes,1 do
				CameraAttListBrowser:add(gCameraAttributes[i])
				CameraAttListBrowser:redraw()
				end
				
				for i = 1,#gSelCameraData,1 do
				CameraValueListBrowser:add(gSelCameraData[i])
				gOldInfo = gSelectedCameraInfo
				end
				
			end
			
	
	
			
				
		end; -- if_curCamerainfo
		
---- updateCameraListBrowser 		
		if arg == "updateCameraListBrowser" then
			CameraListBrowser:clear()
			CameraAttListBrowser:clear()
			CameraValueListBrowser:clear()

			CameraListBrowser:add("current")
			CameraAttListBrowser:add("position")
			CameraAttListBrowser:add("rotation")
			CameraValueListBrowser:add(gCurrentCameraPosition)
			CameraValueListBrowser:add(gCurrentCameraRotation)
		if #gCameraNames > 0  then
		 EBLn = CameraFieldValues[1]
			  CameraListBrowser:clear()
			  for i=1,#gCameraNames,1 do 
			  CameraListBrowser:add(gCameraNames[i])	
			 	 if gSelectedCamera == gCameraNames[i] then EBLn = i end;
			  end
		gSourceRequest = ""
		else
		
		end	
		end;
		  

	
	if arg == "newCamera" then
		CameraAttListBrowser:value(2)
		CameraValueListBrowser:value(2)
		CameraAttListBrowser:select(2)
		CameraValueListBrowser:select(2)
		CameraBrowserValueCatch()
	end
	
	if arg == "updateMaterialsBrowser" then
		

	end



---- SELECT LINE OF BROWSER  
				if FBn ~= nil then
				wtfFileBrowser:selected(FBn,FBn)
				wtfFileBrowser:value(FBn)
				wtfFileBrowser:select(FBn)
				wtfFileBrowser:redraw()
				end
		
				if EBLn ~= nil then
				CameraFieldValues[1] = EBLn
				gSelectedCamera = gCameraNames[EBLn] 
				 CameraListBrowser:select(EBLn,EBLn)
		 		CameraListBrowser:value(EBLn)
		 		CameraListBrowser:selected(EBLn)
				end
			if EAn ~= nil then 		 
			CameraAttListBrowser:select(EAn,EAn)
			CameraAttListBrowser:value(EAn)
			CameraAttListBrowser:selected(EAn)
			CameraValueListBrowser:select(EAn,EAn)
			CameraValueListBrowser:value(EAn)
			CameraValueListBrowser:selected(EAn) 
			
			end
fltk_update()
end
-- CameraValueListCallback
function CameraValueListCallback(w)
if CameraBrowser == nil then return end;
if w:value() == nil then return end
CameraAttListBrowser:value(w:value())
CameraAttListBrowser:select(w:value())
CameraAttListBrowser:selected(w:value(),w:value())
CameraBrowserValueCatch()
--PickedCameraAttribute(CameraFieldValues[2])
end
-- CameraAttPicked
function CameraAttPicked(w)
if CameraBrowser == nil then return end;
if w:value() == nil then return end
CameraValueListBrowser:value(w:value())
CameraValueListBrowser:select(w:value())
CameraValueListBrowser:selected(w:value(),w:value())
CameraBrowserValueCatch()
PickedCameraAttribute(CameraFieldValues[2])
end
-- updateCameraListBrowser
function updateCameraListBrowser()
--CameraBrowserValueCatch()
CurCameraInfo()


	
	
	CameraBrowserWindowUpdate("updateCameraListBrowser")
	
end
-- CameraListBrowserCallback
function CameraListBrowserCallback(w)
if CameraBrowser == nil then return end;
n = w:value()
--CameraBrowserValueCatch()
--resetCameraTables()
gSelectedCamera = w:value()
CurCameraInfo()		
--camera_faceObj(gCameraNum)
--if gCameraToolTipPicked == "translate" then PickedCameraAttribute(CameraFieldValues[2]) end
--if gCameraToolTipPicked == "materials" then updateMaterialsTables() end
updateCameraListBrowser()
CameraValueGroup:show() 			
end
do CameraBrowser= fltk:Fl_Double_Window(0,0,0,0,"")
CameraBrowser:callback(wClose)
CameraBrowser:resize(97,177,369,390)
CameraBrowser:color(40)
CameraBrowser:labelsize(10)
--CameraBrowser:show()
do mainttoolsgroup= fltk:Fl_Group(0,0,0,0,"")
mainttoolsgroup:resize(0,21,645,30)
do cameratool1= fltk:Fl_Button(0,0,0,0,"")
cameratool1:callback(cameraToolBtnCallback)
cameratool1:resize(3,22,26,26)
cameratool1:labelsize(1)
cameratool1:align(16)
end

do cameratool2= fltk:Fl_Button(0,0,0,0,"")
cameratool2:callback(cameraToolBtnCallback)
cameratool2:resize(31,22,26,26)
cameratool2:labelsize(1)
cameratool2:align(16)
end

do cameratool3= fltk:Fl_Button(0,0,0,0,"")
cameratool3:callback(cameraToolBtnCallback)
cameratool3:resize(58,22,26,26)
cameratool3:labelsize(11)
cameratool3:align(50)
end

do cameratool4= fltk:Fl_Button(0,0,0,0,"")
cameratool4:callback(cameraToolBtnCallback)
cameratool4:resize(86,22,26,26)
cameratool4:labelsize(2)
cameratool4:align(16)
end

do cameratool5= fltk:Fl_Button(0,0,0,0,"")
cameratool5:callback(cameraToolBtnCallback)
cameratool5:resize(114,22,26,26)
cameratool5:labelsize(2)
cameratool5:align(16)
end

do cameratool6= fltk:Fl_Button(0,0,0,0,"")
cameratool6:callback(cameraToolBtnCallback)
cameratool6:resize(142,22,26,26)
cameratool6:labelsize(1)
cameratool6:align(16)
end

do cameratool7= fltk:Fl_Button(0,0,0,0,"")
cameratool7:callback(cameraToolBtnCallback)
cameratool7:resize(170,22,26,26)
cameratool7:labelsize(1)
cameratool7:align(16)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraMenu= fltk:Fl_Menu_Bar(0,0,0,0,"")
menudir0=""
CameraMenu:callback(Camera_menu_callback)
CameraMenu:resize(-2,0,371,22)
CameraMenu:color(38)
CameraMenu:labelsize(10)
CameraMenu:textsize(10)
Fl_Group:current(Fl_Group:current():parent())
end

do CameraSaveAsGroup= fltk:Fl_Group(0,0,0,0,"")
CameraSaveAsGroup:resize(370,370,217,50)
do SourceNameInput= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Camera Source File ")
SourceNameInput:label(gLabelTable[#gLabelTable])
SourceNameInput:callback(CameraSaveButtonClick)
SourceNameInput:resize(370,370,217,25)
SourceNameInput:color(50)
SourceNameInput:labelsize(10)
SourceNameInput:align(1)
SourceNameInput:when(8)
SourceNameInput:textsize(10)
end

do PSaveControl= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Save")
PSaveControl:label(gLabelTable[#gLabelTable])
PSaveControl:callback(CameraSaveButtonClick)
PSaveControl:resize(537,400,50,20)
PSaveControl:labelsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraSourceGroup= fltk:Fl_Group(0,0,0,0,"")
CameraSourceGroup:resize(-1,49,361,366)
CameraSourceGroup:labelsize(10)
CameraSourceGroup:align(0)
do ReplaceSourceGroup= fltk:Fl_Group(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Replace")
ReplaceSourceGroup:label(gLabelTable[#gLabelTable])
ReplaceSourceGroup:resize(3,333,355,49)
ReplaceSourceGroup:box(fltk.FL_EMBOSSED_BOX)
ReplaceSourceGroup:color(50)
ReplaceSourceGroup:labelsize(10)
ReplaceSourceGroup:align(21)
do ReplaceWTFSourceBtn= fltk:Fl_Button(0,0,0,0,"")
ReplaceWTFSourceBtn:callback(ReplaceWTFSourceBtnClick)
ReplaceWTFSourceBtn:resize(48,336,140,44)
ReplaceWTFSourceBtn:labelsize(10)
end

do ReplaceAllWTFSourceBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Replace All")
ReplaceAllWTFSourceBtn:label(gLabelTable[#gLabelTable])
ReplaceAllWTFSourceBtn:callback(ReplaceAllWTFSourceBtnClick)
ReplaceAllWTFSourceBtn:resize(195,336,140,44)
ReplaceAllWTFSourceBtn:labelsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do wtfFileBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Camera Source")
wtfFileBrowser:label(gLabelTable[#gLabelTable])
wtfFileBrowser:callback(CameraSourcebrowserControlClicked)
wtfFileBrowser:resize(180,63,180,272)
wtfFileBrowser:type(2)
wtfFileBrowser:labelsize(10)
wtfFileBrowser:align(1)
wtfFileBrowser:when(3)
wtfFileBrowser:textsize(10)
end

do MakeCameraWTFBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "make")
MakeCameraWTFBtn:label(gLabelTable[#gLabelTable])
MakeCameraWTFBtn:callback(CamerawtfAddCameraClicked)
MakeCameraWTFBtn:tooltip("make model")
MakeCameraWTFBtn:resize(80,69,95,22)
MakeCameraWTFBtn:labelsize(10)
end

do MakeCameraWTFBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "replace")
MakeCameraWTFBtn:label(gLabelTable[#gLabelTable])
MakeCameraWTFBtn:callback(ReplaceWTFSourceBtnClick)
MakeCameraWTFBtn:tooltip("make model")
MakeCameraWTFBtn:resize(80,100,95,22)
MakeCameraWTFBtn:labelsize(10)
end

do MakeCameraWTFBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "replace similiar")
MakeCameraWTFBtn:label(gLabelTable[#gLabelTable])
MakeCameraWTFBtn:callback(ReplaceAllWTFSourceBtnClick)
MakeCameraWTFBtn:tooltip("make model")
MakeCameraWTFBtn:resize(80,132,95,22)
MakeCameraWTFBtn:labelsize(10)
end

do MakeCameraWTFBtn= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "replace all")
MakeCameraWTFBtn:label(gLabelTable[#gLabelTable])
MakeCameraWTFBtn:callback(ReplaceAllWTFSourceBtnClick)
MakeCameraWTFBtn:tooltip("make model")
MakeCameraWTFBtn:resize(80,164,95,22)
MakeCameraWTFBtn:labelsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraMaterialsGroup= fltk:Fl_Group(0,0,0,0,"")
CameraMaterialsGroup:resize(8,51,355,331)
CameraMaterialsGroup:labelsize(10)
CameraMaterialsGroup:align(0)
do CameraMaterialsBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Materials")
CameraMaterialsBrowser:label(gLabelTable[#gLabelTable])
CameraMaterialsBrowser:callback(CameraMaterialsBrowserCallback)
CameraMaterialsBrowser:resize(74,61,56,272)
CameraMaterialsBrowser:type(3)
CameraMaterialsBrowser:color(50)
CameraMaterialsBrowser:labelsize(10)
CameraMaterialsBrowser:align(1)
CameraMaterialsBrowser:when(4)
CameraMaterialsBrowser:textsize(10)
end

do CameraMaterialsAttributesBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Attributes:")
CameraMaterialsAttributesBrowser:label(gLabelTable[#gLabelTable])
CameraMaterialsAttributesBrowser:callback(CameraMaterialsAttributesBrowserCallback)
CameraMaterialsAttributesBrowser:resize(128,61,56,272)
CameraMaterialsAttributesBrowser:type(3)
CameraMaterialsAttributesBrowser:color(50)
CameraMaterialsAttributesBrowser:labelsize(10)
CameraMaterialsAttributesBrowser:align(1)
CameraMaterialsAttributesBrowser:when(4)
CameraMaterialsAttributesBrowser:textsize(10)
end

do CameraMaterialsValuesBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Values:")
CameraMaterialsValuesBrowser:label(gLabelTable[#gLabelTable])
CameraMaterialsValuesBrowser:callback(CameraMaterialsAttributesBrowserCallback)
CameraMaterialsValuesBrowser:resize(182,61,177,272)
CameraMaterialsValuesBrowser:type(3)
CameraMaterialsValuesBrowser:color(50)
CameraMaterialsValuesBrowser:labelsize(10)
CameraMaterialsValuesBrowser:align(1)
CameraMaterialsValuesBrowser:when(4)
CameraMaterialsValuesBrowser:textsize(10)
end

do CameraMaterialsInputGroup= fltk:Fl_Group(0,0,0,0,"")
CameraMaterialsInputGroup:resize(8,338,355,44)
CameraMaterialsInputGroup:box(fltk.FL_EMBOSSED_BOX)
CameraMaterialsInputGroup:color(50)
do CameraMaterialsNameInput= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Name:")
CameraMaterialsNameInput:label(gLabelTable[#gLabelTable])
CameraMaterialsNameInput:callback(RenameCameraMaterials)
CameraMaterialsNameInput:resize(153,344,205,22)
CameraMaterialsNameInput:color(50)
CameraMaterialsNameInput:labelsize(10)
CameraMaterialsNameInput:textsize(10)
end

do CameraMaterialsBoolBtn= fltk:Fl_Check_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "button")
CameraMaterialsBoolBtn:label(gLabelTable[#gLabelTable])
CameraMaterialsBoolBtn:callback(changeCameraMaterialsBool)
CameraMaterialsBoolBtn:resize(128,344,19,23)
CameraMaterialsBoolBtn:down_box(fltk.FL_DOWN_BOX)
CameraMaterialsBoolBtn:align(4)
CameraMaterialsBoolBtn:when(1)
end

do CameraMaterialsValInputA= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "x")
CameraMaterialsValInputA:label(gLabelTable[#gLabelTable])
CameraMaterialsValInputA:callback(CameraMaterialsValInput)
CameraMaterialsValInputA:resize(153,344,46,22)
CameraMaterialsValInputA:color(51)
CameraMaterialsValInputA:labelsize(12)
CameraMaterialsValInputA:align(2)
CameraMaterialsValInputA:minimum(0.001)
CameraMaterialsValInputA:step(0.01)
CameraMaterialsValInputA:textsize(10)
end

do CameraMaterialsValInputB= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "y")
CameraMaterialsValInputB:label(gLabelTable[#gLabelTable])
CameraMaterialsValInputB:callback(CameraMaterialsValInput)
CameraMaterialsValInputB:resize(206,344,46,22)
CameraMaterialsValInputB:color(51)
CameraMaterialsValInputB:labelsize(12)
CameraMaterialsValInputB:align(2)
CameraMaterialsValInputB:minimum(0.001)
CameraMaterialsValInputB:step(0.01)
CameraMaterialsValInputB:textsize(10)
end

do CameraMaterialsValInputC= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "z")
CameraMaterialsValInputC:label(gLabelTable[#gLabelTable])
CameraMaterialsValInputC:callback(CameraMaterialsValInput)
CameraMaterialsValInputC:resize(259,344,46,22)
CameraMaterialsValInputC:color(51)
CameraMaterialsValInputC:labelsize(12)
CameraMaterialsValInputC:align(2)
CameraMaterialsValInputC:minimum(0.001)
CameraMaterialsValInputC:step(0.01)
CameraMaterialsValInputC:textsize(10)
end

do CameraMaterialsValInputD= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "a")
CameraMaterialsValInputD:label(gLabelTable[#gLabelTable])
CameraMaterialsValInputD:callback(CameraMaterialsValInput)
CameraMaterialsValInputD:resize(313,344,46,22)
CameraMaterialsValInputD:color(51)
CameraMaterialsValInputD:labelsize(12)
CameraMaterialsValInputD:align(2)
CameraMaterialsValInputD:minimum(0.001)
CameraMaterialsValInputD:step(0.01)
CameraMaterialsValInputD:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraTextureGroup= fltk:Fl_Group(0,0,0,0,"")
CameraTextureGroup:resize(370,67,217,303)
CameraTextureGroup:box(fltk.FL_THIN_DOWN_BOX)
do pngPreviewGroup= fltk:Fl_Group(0,0,0,0,"")
pngPreviewGroup:resize(416,204,128,129)
pngPreviewGroup:align(16)
pngPreviewGroup:when(6)
do pngPreviewBox= fltk:Fl_Box(0,0,0,0,"")
pngPreviewBox:callback(pngLoad)
pngPreviewBox:resize(416,204,128,128)
pngPreviewBox:box(fltk.FL_FLAT_BOX)
pngPreviewBox:color(40)
pngPreviewBox:align(16)
end
Fl_Group:current(Fl_Group:current():parent())
end

do pngFileBrowser= fltk:Fl_Browser(0,0,0,0,"")
pngFileBrowser:callback(browserControlClicked)
pngFileBrowser:resize(370,67,217,132)
pngFileBrowser:type(2)
pngFileBrowser:color(48)
pngFileBrowser:labelsize(10)
pngFileBrowser:align(1)
pngFileBrowser:when(3)
pngFileBrowser:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraInputGroup= fltk:Fl_Group(0,0,0,0,"")
CameraInputGroup:resize(3,333,355,44)
CameraInputGroup:box(fltk.FL_EMBOSSED_BOX)
CameraInputGroup:color(50)
do CameraNameInput= fltk:Fl_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Name:")
CameraNameInput:label(gLabelTable[#gLabelTable])
CameraNameInput:callback(RenameCamera)
CameraNameInput:resize(148,339,205,22)
CameraNameInput:color(50)
CameraNameInput:labelsize(10)
CameraNameInput:textsize(10)
end

do CameraBoolBtn= fltk:Fl_Check_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "button")
CameraBoolBtn:label(gLabelTable[#gLabelTable])
CameraBoolBtn:callback(changeCameraBool)
CameraBoolBtn:resize(123,339,19,23)
CameraBoolBtn:down_box(fltk.FL_DOWN_BOX)
CameraBoolBtn:align(4)
CameraBoolBtn:when(1)
end

do CameraValInputA= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "x")
CameraValInputA:label(gLabelTable[#gLabelTable])
CameraValInputA:callback(CameraValInput)
CameraValInputA:resize(148,339,46,22)
CameraValInputA:color(51)
CameraValInputA:labelsize(12)
CameraValInputA:align(2)
CameraValInputA:minimum(-10000)
CameraValInputA:maximum(10000)
CameraValInputA:step(0.2)
CameraValInputA:textsize(10)
end

do CameraValInputB= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "y")
CameraValInputB:label(gLabelTable[#gLabelTable])
CameraValInputB:callback(CameraValInput)
CameraValInputB:resize(201,339,46,22)
CameraValInputB:color(51)
CameraValInputB:labelsize(12)
CameraValInputB:align(2)
CameraValInputB:minimum(-10000)
CameraValInputB:maximum(10000)
CameraValInputB:step(0.2)
CameraValInputB:textsize(10)
end

do CameraValInputC= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "z")
CameraValInputC:label(gLabelTable[#gLabelTable])
CameraValInputC:callback(CameraValInput)
CameraValInputC:resize(254,339,46,22)
CameraValInputC:color(51)
CameraValInputC:labelsize(12)
CameraValInputC:align(2)
CameraValInputC:minimum(-10000)
CameraValInputC:maximum(10000)
CameraValInputC:step(0.2)
CameraValInputC:textsize(10)
end

do CameraValInputD= fltk:Fl_Value_Input(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "a")
CameraValInputD:label(gLabelTable[#gLabelTable])
CameraValInputD:callback(CameraValInput)
CameraValInputD:resize(308,339,46,22)
CameraValInputD:color(51)
CameraValInputD:labelsize(12)
CameraValInputD:align(2)
CameraValInputD:minimum(-10000)
CameraValInputD:maximum(10000)
CameraValInputD:step(0.2)
CameraValInputD:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraRootGroup= fltk:Fl_Group(0,0,0,0,"")
CameraRootGroup:callback(runButton)
CameraRootGroup:resize(3,61,148,272)
do CameraListBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Camera")
CameraListBrowser:label(gLabelTable[#gLabelTable])
CameraListBrowser:callback(CameraListBrowserCallback)
CameraListBrowser:resize(3,61,74,272)
CameraListBrowser:type(2)
CameraListBrowser:color(48)
CameraListBrowser:labelsize(10)
CameraListBrowser:align(1)
CameraListBrowser:when(4)
CameraListBrowser:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraBonesGroup= fltk:Fl_Group(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Bones")
CameraBonesGroup:label(gLabelTable[#gLabelTable])
CameraBonesGroup:resize(74,61,286,272)
CameraBonesGroup:labelsize(10)
do CameraBonesBrowser= fltk:Fl_Browser(0,0,0,0,"")
CameraBonesBrowser:callback(CameraBonesBrowserCallback)
CameraBonesBrowser:resize(74,61,285,272)
CameraBonesBrowser:type(3)
CameraBonesBrowser:color(50)
CameraBonesBrowser:labelsize(10)
CameraBonesBrowser:when(4)
CameraBonesBrowser:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end

do CameraValueGroup= fltk:Fl_Group(0,0,0,0,"")
CameraValueGroup:resize(75,47,284,289)
do CameraValueListBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Values:")
CameraValueListBrowser:label(gLabelTable[#gLabelTable])
CameraValueListBrowser:callback(CameraValueListCallback)
CameraValueListBrowser:resize(137,61,222,272)
CameraValueListBrowser:type(3)
CameraValueListBrowser:color(50)
CameraValueListBrowser:labelsize(10)
CameraValueListBrowser:align(1)
CameraValueListBrowser:when(4)
CameraValueListBrowser:textsize(10)
end

do CameraAttListBrowser= fltk:Fl_Browser(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Attributes:")
CameraAttListBrowser:label(gLabelTable[#gLabelTable])
CameraAttListBrowser:callback(CameraAttPicked)
CameraAttListBrowser:resize(75,62,64,272)
CameraAttListBrowser:type(1)
CameraAttListBrowser:color(48)
CameraAttListBrowser:labelsize(10)
CameraAttListBrowser:align(1)
CameraAttListBrowser:when(4)
CameraAttListBrowser:textsize(10)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
CameraBrowser:show()

CameraBrowser:label("")
CameraBrowser:show()
CameraBrowser:make_current()
--resetCameraTables()
--updateCameraListBrowser()
--Camera_MenuBarFill()
CameraBrowserGroupsHide()
updateCameraListBrowser()
---- BUTTON ICONS 
fltk.fl_register_images()
local iconPath=gameroot.."Data/Icons/ModelsBrowser/Models_"
gModelsBrowserButtons={"camera","translate","source","bones","anims","views"}
gModelsBrowserIcons ={}
for i = 1, #gModelsBrowserButtons,1 do
table.insert(gModelsBrowserIcons,Fl_Shared_Image.get(iconPath..gModelsBrowserButtons[i]..".png"))
end

mtl1 = Fl_Shared_Image.get(iconPath.."source.png")
mtl2 = Fl_Shared_Image.get(iconPath.."translate.png")
mtl3 = Fl_Shared_Image.get(iconPath.."camera.png")
mtl4 = Fl_Shared_Image.get(iconPath.."materials.png")
mtl5 = Fl_Shared_Image.get(iconPath.."bones.png")
mtl6 = Fl_Shared_Image.get(iconPath.."anims.png")
mtl7 = Fl_Shared_Image.get(iconPath.."views.png")

cameratool1:image(gModelsBrowserIcons[1])
cameratool2:image(gModelsBrowserIcons[2])
cameratool3:image(gModelsBrowserIcons[3])
cameratool4:image(gModelsBrowserIcons[4])
cameratool5:image(gModelsBrowserIcons[5])
cameratool6:image(gModelsBrowserIcons[6])


cameratool1:image(gModelsBrowserIcons[1],22,22)
cameratool2:image(gModelsBrowserIcons[2],22,22)
cameratool3:image(gModelsBrowserIcons[3],22,22)
cameratool4:image(gModelsBrowserIcons[4],22,22)
cameratool5:image(gModelsBrowserIcons[5],22,22)
cameratool6:image(gModelsBrowserIcons[6],22,22)

cameratool1:tooltip(gModelsBrowserButtons[1])
cameratool2:tooltip(gModelsBrowserButtons[2])
cameratool3:tooltip(gModelsBrowserButtons[3])
cameratool4:tooltip(gModelsBrowserButtons[4])
cameratool5:tooltip(gModelsBrowserButtons[5])
cameratool6:tooltip(gModelsBrowserButtons[6])


cameratool1:redraw()
cameratool2:redraw()
cameratool3:redraw()
cameratool4:redraw()
cameratool5:redraw()
cameratool6:redraw()


cameratool1:when(11)
cameratool2:when(11)
cameratool3:when(11)
cameratool4:when(11)
cameratool5:when(11)
cameratool6:when(11)
--end
Fl:run()
