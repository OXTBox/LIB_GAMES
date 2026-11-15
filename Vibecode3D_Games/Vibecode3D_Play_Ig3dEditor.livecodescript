######################################################################################
## CARD SCRIPT: "Play.Ig3dEditor"   iGAME3D MAIN UI, REMADE  (11 13 2026)
## The 2007/2026 iGame3D main window's toolbar (ig3d_UI_MAIN, harvested by XTJSON), remade
## in the Vibecode3D engine: every tool in its old left-to-right order, a Unicode symbol in
## place of each missing PNG icon (chosen from the icon's name), the old tooltip kept.
## Wired now: the primitives, camera, colours, light, play, GL controller (orbit).
## EDITOR TOOLS (Opus 15 Nov 2026, the owner's accepted A-84 / A-86 / A-87):
##   Window > Inspector          one page per object kind; Animation = BVH clip preview + In/Out
##                               clipper + the game's Animation List (LIB_ig3d/livecode/v3d_inspector)
##   Edit > Replace With Model... a game's placeholder meshes -> models, saved as a Skin
##                               (LIB_ig3d/livecode/v3d_skins; the Game Player plays it)
##   Library > Models            click: load at the centre; DRAG a name onto the 3D view: it lands
##                               on the floor where you let go (a preview follows the mouse)
## Every other tool says what it did in iGame3D (a list to judge: keep / adapt / junk).
## CONTROLS  click a tool    hover: the old tooltip    W A S D / arrows: move the camera
## NEEDS     nothing outside the engine. Map: LIB_ig3d/MAIN_UI_REUSE.md, TOOLBAR_MAP below.
######################################################################################

global gObjectTransforms, gSceneObjects
global gCameraYaw, gCameraPitch
global bPaused, bPlaying

local sLib, sLibRoot, sLibList, sMade, sSelected, sColorN, sOrbit, sTicks, sCamX, sCamY, sCamZ, sMsgUntil, sLight

-- TOOLBAR_MAP: name | Unicode code point | 2007 icon | group | tooltip (iGame3D)
constant kTools = "level|2699|console.png|editing mode|Level settings;snapshot|25D9|snapshot.png|camera tools|Snapshot of the 3D view;colors|25D0|colorball16x16.png|camera tools|Colours;light|2600|lights.png|light|Position lights;objects|263A|32x32zombie3.png|actors and effects|Access view settings (actors);particles|2733|particlesicon24x24.png|actors and effects|Particles;camera|25CE|meshView.png|camera tools|Camera / mesh view;GLController|2725|repositiontoolnew2.png|camera tools|Show/hide the GL controller;pathselect|21E2|pathSelectIcon.png|mesh tools|Path selection;path|270E|pathToolIcon.png|mesh tools|Path editing;select_mesh|25A6|tool6.png|vertex tools|Mesh editing;vertex|2022|tool2.png|vertex tools|Create vertex;line|2571|tool3.png|vertex tools|Connect vertices;disconnect|2702|tool5.png|vertex tools|Disconnect mesh line;split|22D4|tool4.png|vertex tools|Split mesh line;quad|25AD|22x22quadtool.png|primitives|Quad;cube|25A3|cube.png|primitives|Cube;dropMesh|2913|dropMeshicon.png|primitives|Drop mesh;Terrain|25B2|quad.png|primitives|Import image to terrain;Play_Game|25B6|playGameButton.png|editing mode|Play (Escape exits);sounds|266A|soundicon22x22.png|actors and effects|Sounds;cylinder|232D|cylinder.png|primitives|Cylinder;cone|25B3|cone.png|primitives|Cone;sphere|25CF|sphere.png|primitives|Sphere;WindowPickPop|2750|windows.png|windows|Open windows;bones|27DF|bone.png|mesh tools|Bones"

constant kMenus = "File=Level;~New/N;~Save/S;~Reset;-;Mesh;~Save In Level;~Export;~Clear#Edit=Undo/Z;Cut/X;Copy/C;Paste/V;Select All Text/A;-;boom;boom all;-;Replace With Model...#Library=Emitters;Images;Levels;Materials;Models;Scripts;Sounds;Text#Mesh=Focus Mesh/0;Goto Points;Tag Vertices/T;Duplicate Vertices/D;Extrude/E;Select;~All Vertices;~Connected/g;~Invert/i;~Attached To Bone;Face;~Face In/[;~Face Out/];~Invert Faces/*;View;~Hide/h;~Hide Other/f;~Hide All;~Show All/u;Mirror;~X;~Y;~Z;~Double Side;-;Combine Overlaps;Subdivide;-;Delete Vertices#Window=Window Snapping;Mode;~Level;~Model;Layout;~top;~bottom;~main;~free;~playgame;-;Animation Editor;Console;ig3dWTFEDITOR;Inspector;Level Collect;Library;Scene Graph;Snapshot#Dev=SAVE;-;Edit F1Script;Edit SGScript;Edit RLScript;StackScript;-;Xternals;-;stopIdle;-;pointer tool/m;-;FindT3D/3;-;scriptHarvester;OpenStacks;CustomPropLengths;RevFunctions;Harvest;-;resetiGame3D;BackUp#Help=iGame3D Help/?;Referencer;Script Commands"
constant kInk = "#7CFF7C"

on Game.OnStart
   focus on nothing          -- arrow keys belong to the game, never to a menu or a field
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   put 0 into sTicks
   put 0 into sColorN
   put false into sOrbit
   put empty into sMade
   put empty into sSelected
   put 0 into sCamX
   put -160 into sCamY
   put -520 into sCamZ
   Ig.Camera
   Mesh.Define "Ig.Floor", MeshGrid(16, 16, 50)
   get Entity.Spawn("Ig.Floor", 0, 0, 0, "#0A280A")
   Ig.BuildToolbar
   Ig.BuildMenus
   Ig.Say "iGAME3D MAIN UI, REMADE.  CLICK A TOOL.  HOVER FOR THE OLD TOOLTIP."
end Game.OnStart

on Ig.Camera
   Engine.SetCam -sCamX, -sCamY, -sCamZ
   put atan2(-sCamX, -sCamZ) into gCameraYaw
   put -atan2(-sCamY, sqrt(sCamX ^ 2 + sCamZ ^ 2)) into gCameraPitch
end Ig.Camera

-------------------------------------------------------------------- the toolbar

-- one row of real buttons in a card-sized group "Ig3dTools", under the engine's status bars
on Ig.BuildToolbar
   local tTool, n, x, tName, tGroup
   lock screen
   if there is not a group "Ig3dTools" of this card then
      reset the templateGroup
      create group "Ig3dTools"
      set the lockLoc of group "Ig3dTools" to true
      set the rect of group "Ig3dTools" to the rect of this card
   end if
   set the visible of group "Ig3dTools" to true
   put the short id of group "Ig3dTools" into tGroup
   set the itemDel to "|"
   put 0 into n
   repeat for each item tTool in Ig.ToolList()
      add 1 to n
   end repeat
   put 6 into x
   put 0 into n
   repeat for each line tTool in Ig.ToolList()
      add 1 to n
      put item 1 of tTool into tName
      if there is not a button tName of group id tGroup then
         reset the templateButton
         create button tName in group id tGroup
      end if
      set the rect of button tName of group id tGroup to x, 112, x + 27, 140
      set the label of button tName of group id tGroup to numToCodepoint(baseConvert(item 2 of tTool, 16, 10))
      set the textSize of button tName of group id tGroup to 17
      set the textColor of button tName of group id tGroup to Ig.GroupColor(item 4 of tTool)
      set the backgroundColor of button tName of group id tGroup to "#061006"
      set the borderColor of button tName of group id tGroup to "#1C4A2A"
      set the showBorder of button tName of group id tGroup to true
      set the opaque of button tName of group id tGroup to true
      set the toolTip of button tName of group id tGroup to item 5 of tTool & cr & "(iGame3D 2007: " & item 3 of tTool & ", " & item 4 of tTool & ")"
      set the script of button tName of group id tGroup to "on mouseUp" & cr & "   Ig.Tool the short name of me" & cr & "end mouseUp" & cr & \
            "on mouseEnter" & cr & "   Ig.Hover the short name of me" & cr & "end mouseEnter"
      add 28 to x
   end repeat
   set the itemDel to comma
   unlock screen
end Ig.BuildToolbar

-- the old menu bar: File Edit Library Mesh Window Dev Help, their items as in iGame3D
-- (kMenus: menus split by #, items by ;, ~ = a submenu item, /X = its shortcut letter)
on Ig.BuildMenus
   local tMenu, tName, tText, tGroup, x
   put the short id of group "Ig3dTools" into tGroup
   put 6 into x
   set the itemDel to "#"
   repeat for each item tMenu in kMenus
      put char 1 to offset("=", tMenu) - 1 of tMenu into tName
      put char offset("=", tMenu) + 1 to -1 of tMenu into tText
      replace ";" with cr in tText
      replace "~" with tab in tText
      if there is not a button ("menu_" & tName) of group id tGroup then
         reset the templateButton
         create button ("menu_" & tName) in group id tGroup
      end if
      set the style of button ("menu_" & tName) of group id tGroup to "menu"
      set the menuMode of button ("menu_" & tName) of group id tGroup to "pulldown"
      set the label of button ("menu_" & tName) of group id tGroup to tName
      set the text of button ("menu_" & tName) of group id tGroup to tText
      set the textColor of button ("menu_" & tName) of group id tGroup to kInk
      set the rect of button ("menu_" & tName) of group id tGroup to x, 144, x + 62, 162
      set the script of button ("menu_" & tName) of group id tGroup to "on menuPick pItem" & cr & "   Ig.Menu the label of me, pItem" & cr & "end menuPick"
      add 64 to x
   end repeat
   set the itemDel to comma
end Ig.BuildMenus

on Ig.Menu pMenu, pItem
   local tKey
   if char -2 of pItem is "/" then delete char -2 to -1 of pItem      -- "Focus Mesh/0": the shortcut letter
   set the itemDel to "|"
   put pMenu & "/" & item -1 of pItem into tKey
   set the itemDel to comma
   switch tKey
      case "File/New"
      case "File/Reset"
      case "File/Clear"
         repeat for each line tKey in sMade
            Entity.Kill tKey
         end repeat
         put empty into sMade
         put empty into sSelected
         Ig.Say "LEVEL CLEARED"
         break
      case "Edit/Undo"
         if sMade is not empty then
            Entity.Kill line -1 of sMade
            delete line -1 of sMade
            put line -1 of sMade into sSelected
            Ig.Say "UNDONE"
         end if
         break
      case "Edit/boom"
         if sSelected is not empty then
            FX.Sparks GetObjectPosition(sSelected, "x"), GetObjectPosition(sSelected, "y"), GetObjectPosition(sSelected, "z"), 30, "#FFB000"
            Ig.Menu "Edit", "Undo"
            Ig.Say "BOOM"
         end if
         break
      case "Edit/boom all"
         repeat for each line tKey in sMade
            FX.Sparks GetObjectPosition(tKey, "x"), GetObjectPosition(tKey, "y"), GetObjectPosition(tKey, "z"), 20, "#FFB000"
            Entity.Kill tKey
         end repeat
         put empty into sMade
         put empty into sSelected
         Ig.Say "BOOM ALL"
         break
      case "Library/Models"
      case "Library/Levels"
      case "Library/Emitters"
      case "Library/Scripts"
      case "Library/Images"
      case "Library/Sounds"
      case "Library/Materials"
      case "Library/Text"
         Ig.Library char offset("/", tKey) + 1 to -1 of tKey
         break
      case "Window/Inspector"
         Ig.OpenTool "V3D_Inspector", "v3d_inspector.livecodescript", "Insp.Build"
         break
      case "Edit/Replace With Model..."
         Ig.OpenTool "V3D_Skins", "v3d_skins.livecodescript", "Skins.Build"
         break
      case "Mesh/Focus Mesh"
         if sSelected is not empty then
            put GetObjectPosition(sSelected, "x") into sCamX
            put GetObjectPosition(sSelected, "z") - 260 into sCamZ
            put -120 into sCamY
            put false into sOrbit
            Ig.Say "FOCUSED ON THE LAST OBJECT"
         end if
         break
      default
         Ig.Say "NOT WIRED YET:" && toUpper(pMenu) && ">" && toUpper(pItem) && "(AN iGAME3D MENU ITEM)"
   end switch
end Ig.Menu

-------------------------------------------------------------------- the library (filesLibrary, remade)

-- the 2008 iGame3D Data folder (LIB_GAMES/igame3D_2008_Texts), found above this stack or in WSL
function Ig.DataRoot
   local tPath, tTry
   if sLibRoot is not empty then return sLibRoot
   put the effective filename of this stack into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   repeat 8 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      put tPath & "/LIB_GAMES/igame3D_2008_Texts" into tTry
      if there is a folder tTry then
         put tTry into sLibRoot
         return tTry
      end if
   end repeat
   put "//wsl$/Ubuntu/home/igame3d/projects/LIB_GAMES/igame3D_2008_Texts" into tTry
   if there is a folder tTry then put tTry into sLibRoot
   return sLibRoot
end Ig.DataRoot

-- Library > Models / Levels / Emitters / Scripts: the files in a list on the right
on Ig.Library pWhat
   local tRoot, tFolder, tSuffix, tList, tGroup
   put Ig.DataRoot() into tRoot
   if tRoot is empty then
      Ig.Say "NO iGAME3D DATA FOLDER FOUND (LIB_GAMES/igame3D_2008_Texts)"
      exit Ig.Library
   end if
   switch pWhat
      case "Models"
         put "WTF" into tFolder
         put ".wtf" into tSuffix
         break
      case "Levels"
         put "Levels" into tFolder
         put ".txt,.lua" into tSuffix
         break
      case "Emitters"
         put "Emitters" into tFolder
         put ".emt" into tSuffix
         break
      case "Scripts"
         put "Scripts" into tFolder
         put ".lua" into tSuffix
         break
      default
         Ig.Say "LIBRARY >" && toUpper(pWhat) & ": NOT IN THE 2008 DATA (IMAGES AND SOUNDS ARE LEFT OUT)"
         exit Ig.Library
   end switch
   put Ig.ListFiles(tRoot & "/" & tFolder, empty, tSuffix) into sLibList
   put the short id of group "Ig3dTools" into tGroup
   if there is not a field "Ig3dLibrary" of group id tGroup then
      reset the templateField
      create field "Ig3dLibrary" in group id tGroup
      set the listBehavior of field "Ig3dLibrary" of group id tGroup to true
      set the lockText of field "Ig3dLibrary" of group id tGroup to true
      set the vScrollbar of field "Ig3dLibrary" of group id tGroup to true
      set the textSize of field "Ig3dLibrary" of group id tGroup to 11
      set the backgroundColor of field "Ig3dLibrary" of group id tGroup to "#061006"
      set the textColor of field "Ig3dLibrary" of group id tGroup to kInk
      set the script of field "Ig3dLibrary" of group id tGroup to "on mouseUp" & cr & "   Ig.LibraryPick the hilitedLine of me" & cr & "end mouseUp" & cr & \
            "on mouseDown" & cr & "   Ig.LibraryDrag word 2 of the clickLine" & cr & "end mouseDown"
   end if
   set the rect of field "Ig3dLibrary" of group id tGroup to 548, 168, 762, 640
   set the visible of field "Ig3dLibrary" of group id tGroup to true
   put sLibList into field "Ig3dLibrary" of group id tGroup
   Ig.Say "LIBRARY >" && toUpper(pWhat) & ":" && the number of lines of sLibList && "FILES.  CLICK ONE" & (" (A MODEL LOADS AS A WIREFRAME)")
   put tFolder into sLib["folder"]
end Ig.Library

function Ig.ListFiles pFolder, pRel, pSuffix
   local tOut, tF, tSub, tSuf
   repeat for each line tF in files(pFolder)
      repeat for each item tSuf in pSuffix
         if char -(the number of chars of tSuf) to -1 of tF is tSuf then
            put pRel & tF & cr after tOut
            exit repeat
         end if
      end repeat
   end repeat
   repeat for each line tSub in folders(pFolder)
      if tSub is "." or tSub is ".." or tSub begins with "_" then next repeat
      put Ig.ListFiles(pFolder & "/" & tSub, pRel & tSub & "/", pSuffix) after tOut
   end repeat
   return tOut
end Ig.ListFiles

-------------------------------------------------------------------- editor tools (A-84, A-86, A-87)

-- the projects folder (the 2008 Data folder is projects/LIB_GAMES/igame3D_2008_Texts)
function Ig.Projects
   local tRoot
   put Ig.DataRoot() into tRoot
   if tRoot is empty then return "//wsl$/Ubuntu/home/igame3d/projects"
   set the itemDel to "/"
   return item 1 to -3 of tRoot
end Ig.Projects

-- a tool window built by code on a brand-new stack each time (its script: LIB_ig3d/livecode/<pFile>)
on Ig.OpenTool pStack, pFile, pBuild
   local tFile
   if there is a stack pStack then
      go stack pStack
      exit Ig.OpenTool
   end if
   put Ig.Projects() & "/LIB_ig3d/livecode/" & pFile into tFile
   if there is not a file tFile then
      Ig.Say "NOT FOUND:" && tFile
      exit Ig.OpenTool
   end if
   lock messages
   create invisible stack pStack
   unlock messages
   set the script of stack pStack to textDecode(URL ("binfile:" & tFile), "UTF-8")
   if the result is not empty then
      Ig.Say "THE TOOL'S SCRIPT DOES NOT COMPILE:" && line 1 of the result
      delete stack pStack
      exit Ig.OpenTool
   end if
   send pBuild && quote & Ig.Projects() & quote to stack pStack
end Ig.OpenTool

-- A-87: press on a model in the Library and drag: a small window with the model's wire follows the
-- mouse; let go over the 3D view and the model lands on the floor there. A plain click still loads it.
on Ig.LibraryDrag pLine
   local tStart, tMoved, tPrev, tPath, tWhere, tX, tY, tXZ
   if pLine is not a number or sLib["folder"] is not "WTF" then exit Ig.LibraryDrag
   put Ig.DataRoot() & "/WTF/" & line pLine of sLibList into tPath
   put the screenMouseLoc into tStart
   put false into tMoved
   put "V3D_DragPreview" into tPrev
   repeat while the mouse is down
      if not tMoved and abs(item 1 of the screenMouseLoc - item 1 of tStart) + abs(item 2 of the screenMouseLoc - item 2 of tStart) > 8 then
         put true into tMoved
         Ig.MakeDragPreview tPrev, tPath
      end if
      if tMoved and there is a stack tPrev then set the topLeft of stack tPrev to (item 1 of the screenMouseLoc + 14) & comma & (item 2 of the screenMouseLoc + 14)
      wait 15 milliseconds with messages
   end repeat
   if not tMoved then exit Ig.LibraryDrag
   if there is a stack tPrev then delete stack tPrev
   -- where it was let go, in this card's coordinates
   put item 1 of the screenMouseLoc - the left of this stack into tX
   put item 2 of the screenMouseLoc - the top of this stack into tY
   if tX < 0 or tY < 0 or tX > the width of this stack or tY > the height of this stack then
      Ig.Say "DROPPED OUTSIDE THE 3D VIEW: NOTHING ADDED"
      exit Ig.LibraryDrag
   end if
   if (tX & comma & tY) is within the rect of field "Ig3dLibrary" of group "Ig3dTools" then exit Ig.LibraryDrag
   try
      put Engine.ScreenToFloor(tX, tY, 0) into tXZ
   catch tWhere
      put empty into tXZ      -- an engine without the editor hooks: the centre
   end try
   if tXZ is empty then put "0 0" into tXZ
   Ig.SpawnModel pLine, word 1 of tXZ, word 2 of tXZ, false
end Ig.LibraryDrag

-- the drag preview: a small borderless window with the model's wire (LIB_ig3d v3d_models)
on Ig.MakeDragPreview pStack, pPath
   local tLib
   put Ig.Projects() & "/LIB_ig3d/livecode/v3d_models.livecodescript" into tLib
   if not ("v3d_models" is among the lines of the stacksInUse) and there is a file tLib then start using stack tLib
   lock messages
   create invisible stack pStack
   set the decorations of stack pStack to empty
   set the width of stack pStack to 110
   set the height of stack pStack to 110
   set the backgroundColor of stack pStack to "#061006"
   set the blendLevel of stack pStack to 15
   set the defaultStack to pStack
   create graphic "Wire"
   set the style of graphic "Wire" to "line"
   set the foregroundColor of graphic "Wire" to kInk
   try
      set the points of graphic "Wire" to Model.PreviewPoints(pPath, 0, 0, 110)
   catch tLib
      -- no preview library: an empty window still shows where the drop goes
   end try
   set the defaultStack to the short name of this stack
   unlock messages
   set the topLeft of stack pStack to (item 1 of the screenMouseLoc + 14) & comma & (item 2 of the screenMouseLoc + 14)
   show stack pStack
end Ig.MakeDragPreview

on Ig.LibraryPick pLine
   local tRel, tPath, tName
   if pLine is not a number then exit Ig.LibraryPick
   put line pLine of sLibList into tRel
   put Ig.DataRoot() & "/" & sLib["folder"] & "/" & tRel into tPath
   if char -4 to -1 of tRel is ".wtf" then
      Ig.SpawnModel pLine, 0, 0, true
   else
      Ig.Say toUpper(tRel) && "(" & the number of lines of URL ("file:" & tPath) && "LINES; OPENING THESE IS NEXT)"
   end if
end Ig.LibraryPick

-- a Library model into the scene, standing on the floor at x, z; pReplace: a click swaps the last
-- loaded model, a drop adds one more
on Ig.SpawnModel pLine, pX, pZ, pReplace
   local tRel, tPath, tName
   put line pLine of sLibList into tRel
   put Ig.DataRoot() & "/" & sLib["folder"] & "/" & tRel into tPath
   put "Ig.WTF" & pLine into tName
   Mesh.Define tName, Ig.WTFMesh(tPath)
   if pReplace and sSelected is not empty and gObjectTransforms[sSelected]["mesh"] begins with "Ig.WTF" then Entity.Kill sSelected
   put Entity.Spawn(tName, pX, -90, pZ, Ig.NextColor()) into sSelected
   put sSelected & cr after sMade
   Ig.Say "MODEL:" && toUpper(tRel) && "(" & sLib["v"] && "VERTICES," && sLib["e"] && "EDGES)" && "AT" && round(pX) && round(pZ)
end Ig.SpawnModel

-- an iGame3D .wtf model -> a wire mesh: its #Vertices (x,y,z,bone) and #Edges (a,b, from 0),
-- centred and scaled to about 180 units; iGame3D's y is up, Vibecode3D's is down
function Ig.WTFMesh pPath
   local tText, n, tCount, i, tV, tM, minX, maxX, minY, maxY, minZ, maxZ, k, cx, cy, cz, tLine
   put URL ("file:" & pPath) into tText
   replace numToChar(13) with empty in tText
   put Mesh.New() into tM
   put lineOffset("#Vertices:", tText) into n
   if n is 0 then return tM
   put line n + 1 of tText into tCount
   put 1e9 into minX
   put -1e9 into maxX
   put 1e9 into minY
   put -1e9 into maxY
   put 1e9 into minZ
   put -1e9 into maxZ
   repeat with i = 1 to tCount
      put line n + 1 + i of tText into tLine
      put item 1 of tLine into tV[i]["x"]
      put item 2 of tLine into tV[i]["y"]
      put item 3 of tLine into tV[i]["z"]
      put min(minX, tV[i]["x"]) into minX
      put max(maxX, tV[i]["x"]) into maxX
      put min(minY, tV[i]["y"]) into minY
      put max(maxY, tV[i]["y"]) into maxY
      put min(minZ, tV[i]["z"]) into minZ
      put max(maxZ, tV[i]["z"]) into maxZ
   end repeat
   put 180 / max(0.001, max(maxX - minX, max(maxY - minY, maxZ - minZ))) into k
   put (minX + maxX) / 2 into cx
   put (minY + maxY) / 2 into cy
   put (minZ + maxZ) / 2 into cz
   repeat with i = 1 to tCount
      Mesh.AddVertex tM, (tV[i]["x"] - cx) * k, -(tV[i]["y"] - cy) * k, (tV[i]["z"] - cz) * k
   end repeat
   put tCount into sLib["v"]
   put lineOffset("#Edges:", tText) into n
   put 0 into sLib["e"]
   if n > 0 then
      put line n + 1 of tText into tCount
      put tCount into sLib["e"]
      repeat with i = 1 to tCount
         put line n + 1 + i of tText into tLine
         Mesh.AddLine tM, item 1 of tLine + 1, item 2 of tLine + 1
      end repeat
   end if
   return tM
end Ig.WTFMesh

function Ig.ToolList
   local t
   put kTools into t
   replace ";" with cr in t
   return t
end Ig.ToolList

function Ig.GroupColor pGroup
   switch pGroup
      case "primitives"
         return "#40E0FF"
      case "camera tools"
         return "#FFB000"
      case "light"
         return "#FFE060"
      case "actors and effects"
         return "#FF60D0"
      case "editing mode"
         return "#FF5050"
      default
         return kInk
   end switch
end Ig.GroupColor

function Ig.ToolInfo pName
   local tTool
   set the itemDel to "|"
   repeat for each line tTool in Ig.ToolList()
      if item 1 of tTool is pName then return tTool
   end repeat
   return empty
end Ig.ToolInfo

on Ig.Hover pName
   local tTool
   put Ig.ToolInfo(pName) into tTool
   set the itemDel to "|"
   if tTool is not empty then Ig.Say toUpper(item 5 of tTool) & "   (" & toUpper(item 4 of tTool) & ")"
end Ig.Hover

-------------------------------------------------------------------- what the tools do

on Ig.Tool pName
   local tTool, tKey, x, z
   put Ig.ToolInfo(pName) into tTool
   put (random(9) - 5) * 50 into x
   put (random(7) - 4) * 50 into z
   switch pName
      case "sphere"
         Ig.Make "Ig.Sphere", MeshSphere(30, 4, 8), x, z
         break
      case "cone"
         Ig.Make "Ig.Cone", MeshPyramid(8, 30, 60), x, z
         break
      case "cylinder"
         Ig.Make "Ig.Cylinder", MeshPrism(8, 28, 60), x, z
         break
      case "cube"
         Ig.Make "Ig.Cube", MeshBox(50, 50, 50), x, z
         break
      case "quad"
         Ig.Make "Ig.Quad", MeshBox(80, 2, 80), x, z
         break
      case "Terrain"
         Ig.Make "Ig.Terrain", MeshGrid(6, 6, 30), x, z
         break
      case "dropMesh"
         if sSelected is not empty then
            SetObjectPosition sSelected, GetObjectPosition(sSelected, "x"), -15, GetObjectPosition(sSelected, "z")
            Ig.Say "DROPPED THE LAST OBJECT TO THE FLOOR"
         end if
         break
      case "colors"
         if sSelected is not empty then Ig.Recolor
         break
      case "camera"
         put 0 into sCamX
         put -160 into sCamY
         put -520 into sCamZ
         Ig.Camera
         Ig.Say "CAMERA RESET"
         break
      case "GLController"
         put not sOrbit into sOrbit
         Ig.Say "ORBIT" && (sOrbit is true)
         break
      case "Play_Game"
         put not sOrbit into sOrbit
         Ig.Say "PLAY" && (sOrbit is true) && " (THE OLD PLAY BUTTON RAN THE LEVEL'S LUA GAME LOOP)"
         break
      case "light"
         if sLight is not empty then Entity.Kill sLight
         Mesh.Define "Ig.Light", MeshPyramid(4, 10, 20)
         put Entity.Spawn("Ig.Light", x, -200, z, "#FFE060") into sLight
         Ig.Say "A LIGHT MARKER PLACED (VIBECODE3D DRAWS LINES: NO LIGHTING YET)"
         break
      default
         set the itemDel to "|"
         Ig.Say "NOT WIRED YET:" && toUpper(item 5 of tTool) && "- IN iGAME3D:" && toUpper(item 4 of tTool)
   end switch
end Ig.Tool

on Ig.Make pMesh, pGeo, pX, pZ
   Mesh.Define pMesh, pGeo
   put Entity.Spawn(pMesh, pX, -30, pZ, Ig.NextColor()) into sSelected
   put sSelected & cr after sMade
   Ig.Say "MADE" && toUpper(char 4 to -1 of pMesh) && "(" & the number of lines of sMade && "OBJECTS)"
end Ig.Make

function Ig.NextColor
   add 1 to sColorN
   return item (sColorN mod 6) + 1 of "#40E0FF,#FF60D0,#FFB000,#7CFF7C,#FF5050,#D0E8FF"
end Ig.NextColor

-- an object's colour is its graphic: respawn it with the next colour
on Ig.Recolor
   local tMesh, x, y, z
   put gObjectTransforms[sSelected]["mesh"] into tMesh
   put GetObjectPosition(sSelected, "x") into x
   put GetObjectPosition(sSelected, "y") into y
   put GetObjectPosition(sSelected, "z") into z
   Entity.Kill sSelected
   put Entity.Spawn(tMesh, x, y, z, Ig.NextColor()) into sSelected
   put sSelected & cr after sMade
   Ig.Say "RECOLOURED"
end Ig.Recolor

on Ig.Say pText
   HUD.Set "Ig.Msg", pText, 10, 660, 11
   put sTicks + 150 into sMsgUntil
end Ig.Say

-------------------------------------------------------------------- the loop

on Game.OnUpdate
   local tKeys
   global gV3DSelected
   put sSelected into gV3DSelected     -- the Inspector's Object page shows it
   add 1 to sTicks
   put the keysDown into tKeys
   if 119 is among the items of tKeys or 65362 is among the items of tKeys then add 8 to sCamZ
   if 115 is among the items of tKeys or 65364 is among the items of tKeys then subtract 8 from sCamZ
   if 97 is among the items of tKeys or 65361 is among the items of tKeys then subtract 8 from sCamX
   if 100 is among the items of tKeys or 65363 is among the items of tKeys then add 8 to sCamX
   if sOrbit then
      put 520 * sin(sTicks / 90) into sCamX
      put -520 * cos(sTicks / 90) into sCamZ
   end if
   Ig.Camera
   if sMsgUntil is a number and sTicks > sMsgUntil then
      HUD.Remove "Ig.Msg"
      put empty into sMsgUntil
   end if
end Game.OnUpdate

on Game.OnClick pX, pY, pButton
end Game.OnClick

on Game.OnKill pKey, pX, pY, pZ
end Game.OnKill

on Game.OnPause
end Game.OnPause

on Game.OnResume
end Game.OnResume

on Game.OnStop
   HUD.Clear
   if there is a group "Ig3dTools" then set the visible of group "Ig3dTools" to false
end Game.OnStop

on Collision.Hit pA, pB
end Collision.Hit

-- the arrows move you; a focused menu or field must never get them
on arrowKey pKey
end arrowKey
