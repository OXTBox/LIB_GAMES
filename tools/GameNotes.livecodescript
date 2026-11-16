script "GameNotes"
######################################################################################
## GAME NOTES  (13 11 2026)
## Leave a note about the game you're playing without leaving the window (the owner: "I
## have to go to different windows, it's a mess").
##   `  (the key left of 1)  or  F2   open the note box at the top; the game pauses
##   Return / Enter                  save the note and go back to the game
##   Escape (or F2 again)            close without saving
## Commands (the note box is the in-game command line): a line starting with / is a command
##   /next  /back       the next / previous game card (alphabetical, wrapping), via Game.Select,
##                      so gCurrentGame follows    /play <name>   that game    /games   list them
## Every note is a TELL for the AI (the owner, 15 Nov 2026: "it's the whole vibe"): its own file in
## the player's Data folder, Data/Games/<Game>/LIB_LLM/tell_<YYYY-MM-DD_HHMMSS>.txt, so any player's
## AI can read what they asked for. On the owner's PC it is also one line in the inbox,
## LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt: date time | game card | level/state if the game says | the note.
## The Data folder: LIB_DATA's Data.Root() when loaded, else <AppData>/Vibecode3D/data_root.txt,
## else Documents/Data (LIB_DATA's rule).
## Works for every game: install with
##   insert script of stack "GameNotes" into front     (LIB_TEST/install_all_games_vibecode3d.sh does it;
##   the xt3d games bench loads it itself when a game starts)
######################################################################################

global bPaused, gCurrentGame
local sOpen, sWasPaused, sCard, sSaid, sTold, sTestRoot

on rawKeyDown pKey
   if sOpen is true and pKey is 65471 then
      Notes.Close                         -- F2 again: close
      exit rawKeyDown
   end if
   if sOpen is not true and (pKey is 96 or pKey is 65471) then
      if Notes.InGame() then
         Notes.Open
         exit rawKeyDown
      end if
   end if
   if sOpen is true and pKey is 65307 then
      Notes.Close
      exit rawKeyDown                     -- the engine never sees this Escape
   end if
   pass rawKeyDown
end rawKeyDown

on returnInField
   if sOpen is true and the short name of the target is "GameNote" then
      Notes.Save
      exit returnInField
   end if
   pass returnInField
end returnInField

on enterInField
   if sOpen is true and the short name of the target is "GameNote" then
      Notes.Save
      exit enterInField
   end if
   pass enterInField
end enterInField

-- the note box: across the top of the window, where important text goes
on Notes.Open
   local tArea
   put Notes.Card() into sCard
   put bPaused into sWasPaused
   put true into bPaused
   lock screen
   if there is not a field "GameNote" of sCard then
      reset the templateField
      create field "GameNote"
      set the textSize of field "GameNote" of sCard to 16
      set the textFont of field "GameNote" of sCard to "Arial"
      set the backgroundColor of field "GameNote" of sCard to "#061A06"
      set the textColor of field "GameNote" of sCard to "#FFE060"
      set the borderColor of field "GameNote" of sCard to "#FFE060"
      set the showBorder of field "GameNote" of sCard to true
      set the opaque of field "GameNote" of sCard to true
      set the dontWrap of field "GameNote" of sCard to true
   end if
   if there is not a field "GameNoteTip" of sCard then
      reset the templateField
      create field "GameNoteTip"
      set the lockText of field "GameNoteTip" of sCard to true
      set the opaque of field "GameNoteTip" of sCard to true      -- hides the game's HUD under it
      set the backgroundColor of field "GameNoteTip" of sCard to "#000000"
      set the showBorder of field "GameNoteTip" of sCard to false
      set the textColor of field "GameNoteTip" of sCard to "#FFE060"
      set the textSize of field "GameNoteTip" of sCard to 12
   end if
   put Notes.Area() into tArea
   set the rect of field "GameNoteTip" of sCard to item 1 of tArea, item 2 of tArea, item 3 of tArea, item 2 of tArea + 20
   set the text of field "GameNoteTip" of sCard to "TELL THE AI ABOUT" && toUpper(Notes.Game()) & ":  type, Return saves, Escape cancels   /next /back /play name /games"
   set the rect of field "GameNote" of sCard to item 1 of tArea, item 2 of tArea + 22, item 3 of tArea, item 2 of tArea + 52
   put empty into field "GameNote" of sCard
   set the visible of field "GameNoteTip" of sCard to true
   set the visible of field "GameNote" of sCard to true
   try                                    -- newest controls are on top already
      set the layer of field "GameNoteTip" of sCard to top
      set the layer of field "GameNote" of sCard to top
   end try
   unlock screen
   put true into sOpen
   focus on field "GameNote" of sCard
end Notes.Open

on Notes.Close
   put false into sOpen
   if sCard is not empty and there is a field "GameNote" of sCard then
      set the visible of field "GameNote" of sCard to false
      set the visible of field "GameNoteTip" of sCard to false
   end if
   focus on nothing
   put sWasPaused is true into bPaused
end Notes.Close

on Notes.Save
   local tText, tLine, tFile, tState
   put the text of field "GameNote" of sCard into tText
   if char 1 of word 1 of tText is "/" then
      Notes.Close
      Notes.Command word 1 to -1 of tText      -- direct: a send would make this stack the default
      exit Notes.Save
   end if
   replace cr with " / " in tText
   if word 1 to -1 of tText is not empty then
      put Notes.State() into tState
      put the system date && the long time & " | " & Notes.Game() into tLine
      if tState is not empty then put " | " & tState after tLine
      put " | " & tText after tLine
      put Notes.Tell(tText, tState) into sTold         -- the player's own Data folder, always
      put Notes.File() into tFile                       -- the owner's inbox, when there is one
      if tFile is not empty then
         try
            put tLine & cr after URL ("file:" & tFile)
            put tFile into sSaid
         end try
      end if
   end if
   Notes.Close
end Notes.Save

-------------------------------------------------------------------- commands

on Notes.Command pLine
   local tCmd, tArg, tGames, tNow, n, tTo
   put toLower(word 1 of pLine) into tCmd
   put word 2 to -1 of pLine into tArg
   put Notes.Games() into tGames
   put Notes.Game() into tNow
   put lineOffset(tNow, tGames) into n
   if n > 0 and line n of tGames is not tNow then put 0 into n     -- lineOffset found a part
   switch tCmd
      case "/next"
         put line (n mod the number of lines of tGames) + 1 of tGames into tTo
         break
      case "/back"
      case "/prev"
         if n <= 1 then
            put line -1 of tGames into tTo
         else
            put line n - 1 of tGames into tTo
         end if
         break
      case "/play"
         repeat for each line tTo in tGames
            if tTo is tArg then exit repeat
         end repeat
         if tTo is not tArg then
            -- the first game whose name starts with what was typed
            put empty into tTo
            repeat for each line n in tGames
               if n begins with tArg then
                  put n into tTo
                  exit repeat
               end if
            end repeat
         end if
         break
      case "/games"
         answer "Games (" & the number of lines of tGames & "):" & cr & tGames
         exit Notes.Command
      default
         answer "Commands: /next  /back  /play <name>  /games" & cr & "Anything else is saved as a note."
         exit Notes.Command
   end switch
   if tTo is empty then exit Notes.Command
   Notes.SwitchTo tTo
end Notes.Command

-- every game: the Vibecode3D Play.* cards, or (in the xt3d bench) the game scripts in LIB_GAMES
function Notes.Games
   local tStack, tOut, c, tName, tFolder, tF
   put the short name of the defaultStack into tStack
   if there is an image "view" of Notes.Card() then
      put the effective filename of stack "GameNotes" into tFolder
      replace "\" with "/" in tFolder
      set the itemDel to "/"
      put item 1 to -3 of tFolder & "/Vibecode3D_Games" into tFolder
      repeat for each line tF in files(tFolder)
         if tF begins with "Vibecode3D_Play_" and tF ends with ".livecodescript" then put char 17 to -16 of tF & cr after tOut
      end repeat
   else
      repeat with c = 1 to the number of cards of stack tStack
         put the short name of card c of stack tStack into tName
         if tName begins with "Play." then put char 6 to -1 of tName & cr after tOut
      end repeat
   end if
   delete char -1 of tOut
   sort lines of tOut
   return tOut
end Notes.Games

-- switch: the engine's own Game.Select + Game.Play (gCurrentGame follows), or the bench's
on Notes.SwitchTo pGame
   local tStack
   put the short name of the defaultStack into tStack
   put pGame into gCurrentGame
   if there is an image "view" of Notes.Card() then
      send "xbPlayGame" && quote & pGame & quote to stack tStack
   else
      send "Game.Select" && quote & pGame & quote to stack tStack
      send "Game.Play" to stack tStack
   end if
end Notes.SwitchTo

-- the game's card: the card of the stack getting the keys (the default stack)
function Notes.Card
   return the long id of this card of stack (the short name of the defaultStack)
end Notes.Card

-- is a game on screen? A Vibecode3D Play card, its Developer card, or any card running a
-- game script (the xt3d games bench puts the game's script on its own card)
function Notes.InGame
   local tCard
   put Notes.Card() into tCard
   if the short name of tCard begins with "Play." or the short name of tCard is "Developer" then return true
   return "on Game.OnUpdate" is in the script of tCard
end Notes.InGame

-- where the box goes: over the xt3d bench's 3D view, else across the top under the status bars
function Notes.Area
   local tCard, tR
   put Notes.Card() into tCard
   if there is an image "view" of tCard then
      put the rect of image "view" of tCard into tR
      return item 1 of tR + 10 & comma & item 2 of tR + 10 & comma & item 3 of tR - 10
   end if
   return "10,112," & the width of tCard - 10
end Notes.Area

-- the game: the card's name without "Play.", or (in the bench) the CARD SCRIPT header's name
function Notes.Game
   local tName, tLine, tAt
   put the short name of Notes.Card() into tName
   if tName begins with "Play." then return char 6 to -1 of tName
   repeat for each line tLine in line 1 to 6 of the script of Notes.Card()
      put offset(quote & "Play.", tLine) into tAt
      if tAt > 0 then
         put char tAt + 6 to -1 of tLine into tName
         return char 1 to offset(quote, tName) - 1 of tName
      end if
   end repeat
   return tName
end Notes.Game

-- the game's own state line, when it has one (Prefix.State, the same one the tests use)
function Notes.State
   local tScript, tLine, tFn
   put the script of Notes.Card() into tScript
   repeat for each line tLine in tScript
      if word 1 of tLine is "function" and word 2 of tLine ends with ".State" then
         put word 2 of tLine into tFn
         exit repeat
      end if
   end repeat
   if tFn is empty then return empty
   try
      return value(tFn & "()", Notes.Card())
   catch tErr
      return empty
   end try
end Notes.State

-- LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt: above this stack, else the owner's projects in WSL
function Notes.File
   local tPath, tTry
   put the effective filename of stack "GameNotes" into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   repeat 8 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      if there is a folder (tPath & "/LIB_LLMIN") then
         put tPath & "/LIB_LLMIN/LIB_GAMES" into tTry
         if there is not a folder tTry then create folder tTry
         return tTry & "/GAME_NOTES.txt"
      end if
   end repeat
   if sTestRoot is not empty then return empty          -- tests never write the owner's inbox
   if there is a folder "//wsl$/Ubuntu/home/igame3d/projects/LIB_LLMIN/LIB_GAMES" then
      return "//wsl$/Ubuntu/home/igame3d/projects/LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt"
   end if
   return empty                                         -- a player's PC: no inbox, the tell file is enough
end Notes.File

-------------------------------------------------------------------- tells

-- write Data/Games/<Game>/LIB_LLM/tell_<YYYY-MM-DD_HHMMSS>.txt; returns its path (empty if it failed)
function Notes.Tell pText, pState
   local tDir, tFile, tN, tBody, tErr
   put Notes.TellFolder(Notes.Game()) into tDir
   if tDir is empty then return empty
   put tDir & "/tell_" & Notes.Stamp() into tFile
   put empty into tN
   repeat while there is a file (tFile & tN & ".txt")      -- two in one second: _2, _3 ...
      if tN is empty then
         put "_2" into tN
      else
         put "_" & (char 2 to -1 of tN + 1) into tN
      end if
   end repeat
   put tFile & tN & ".txt" into tFile
   put "game" & tab & Notes.Game() & cr & "when" & tab & the system date && the long time & cr into tBody
   if pState is not empty then put "state" & tab & pState & cr after tBody
   put "tell" & tab & pText & cr after tBody
   try
      put textEncode(tBody, "UTF-8") into URL ("binfile:" & tFile)
   catch tErr
      return empty
   end try
   if the result is not empty then return empty
   return tFile
end Notes.Tell

-- the game's LIB_LLM folder in the Data folder, made if missing
function Notes.TellFolder pGame
   local tRoot, tDir, tPart, tErr
   put Notes.DataRoot() into tRoot
   if tRoot is empty then return empty
   put tRoot into tDir
   try
      repeat for each item tPart in "Games," & pGame & ",LIB_LLM"
         put "/" & tPart after tDir
         if there is not a folder tDir then create folder tDir
      end repeat
   catch tErr
      return empty
   end try
   if there is not a folder tDir then return empty
   return tDir
end Notes.TellFolder

-- LIB_DATA's rule: Data.Root() if that library is in use, else a data_root.txt in the install
-- (up to five folders above this script: a portable install, or the simulated PC on V:), else
-- the saved choice in <AppData>/Vibecode3D/data_root.txt, else Documents/Data
function Notes.DataRoot
   local tRoot, tFile, tErr
   if sTestRoot is not empty then return sTestRoot
   try
      put value("Data.Root()") into tRoot
   catch tErr
      put empty into tRoot
   end try
   if tRoot is not empty and there is a folder tRoot then return tRoot
   put Notes.InstallDataRoot() into tRoot              -- data_root.txt in the install (portable, or V:)
   if tRoot is not empty then return tRoot
   put specialFolderPath("support") & "/Vibecode3D/data_root.txt" into tFile
   if there is a file tFile then
      put line 1 of textDecode(URL ("binfile:" & tFile), "UTF-8") into tRoot
      replace "\" with "/" in tRoot
      if tRoot is not empty and there is a folder tRoot then return tRoot
   end if
   put specialFolderPath("documents") into tRoot
   if tRoot is empty then return empty
   replace "\" with "/" in tRoot
   return tRoot & "/Data"
end Notes.DataRoot

function Notes.InstallDataRoot
   local tPath, tRoot
   put the effective filename of stack "GameNotes" into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   repeat 5 times
      delete item -1 of tPath
      if tPath is empty then exit repeat
      if there is a file (tPath & "/data_root.txt") then
         put line 1 of textDecode(URL ("binfile:" & tPath & "/data_root.txt"), "UTF-8") into tRoot
         replace "\" with "/" in tRoot
         if tRoot is not empty and there is a folder tRoot then return tRoot
      end if
   end repeat
   return empty
end Notes.InstallDataRoot

-- 2026-11-15_211503: sorts by time
function Notes.Stamp
   local tD
   put the seconds into tD
   convert tD to dateItems
   return item 1 of tD & "-" & Notes.Two(item 2 of tD) & "-" & Notes.Two(item 3 of tD) & "_" & \
         Notes.Two(item 4 of tD) & Notes.Two(item 5 of tD) & Notes.Two(item 6 of tD)
end Notes.Stamp

function Notes.Two pN
   if pN < 10 then return "0" & pN
   return pN
end Notes.Two

function Notes.LastTell
   return sTold
end Notes.LastTell

-- tests: tells go under pFolder, and the owner's inbox is left alone
command Notes.TestRoot pFolder
   put pFolder into sTestRoot
end Notes.TestRoot

function Notes.LastFile
   return sSaid
end Notes.LastFile
