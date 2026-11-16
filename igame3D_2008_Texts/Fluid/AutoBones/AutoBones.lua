--function make_window()
-- globals_and_functions_codeblock
--prepMeshForBones
function prepMeshForBones()
ig3d_ScaleSelectedMeshTo_3f(0,1,0)
ig3d_SetMeshPositionNoUndo_3f (0.0,0.0,0.0) 
ig3d_MakeInvisible() 
loadMesh("Data/WTF/Characters/human_bones.wtf")
end

function boneMeshCluster()
ig3d_ShowAll() 
ig3d_ClusterMeshBones()
end
do BoningWindow= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Auto Boning")
BoningWindow:label(gLabelTable[#gLabelTable])
BoningWindow:resize(95,185,211,74)
BoningWindow:when(6)
--BoningWindow:show()
do widget= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Set 1x1x1 and 0,0,0 and Load Bones")
widget:label(gLabelTable[#gLabelTable])
widget:callback(prepMeshForBones)
widget:resize(5,5,195,30)
widget:labelsize(11)
end

do widget= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Set Auto Bones")
widget:label(gLabelTable[#gLabelTable])
widget:callback(boneMeshCluster)
widget:resize(5,40,195,25)
widget:labelsize(11)
end
end
BoningWindow:show()

BoningWindow:show();
--end
Fl:run()
