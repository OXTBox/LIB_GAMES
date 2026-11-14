script "GameNotes"
######################################################################################
## GAME NOTES  (13 11 2026)
## Leave a note about the game you're playing without leaving the window (the owner: "I
## have to go to different windows, it's a mess").
##   `  (the key left of 1)  or  F2   open the note box at the top; the game pauses
##   Return / Enter                  save the note and go back to the game
##   Escape (or F2 again)            close without saving
## Every note is one line appended to LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt (the inbox, where
## Claude reads it): date time | game card | level/state if the game says | the note.
## Works for every game: install with
##   insert script of stack "GameNotes" into front     (LIB_TEST/install_all_games_vibecode3d.sh does it;
##   the xt3d games bench loads it itself when a game starts)
######################################################################################

global bPaused
local sOpen, sWasPaused, sCard, sSaid

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
   set the text of field "GameNoteTip" of sCard to "NOTE ABOUT" && toUpper(Notes.Game()) & ":  type, Return saves, Escape cancels  (game paused)"
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
   replace cr with " / " in tText
   if word 1 to -1 of tText is not empty then
      put Notes.State() into tState
      put the system date && the long time & " | " & Notes.Game() into tLine
      if tState is not empty then put " | " & tState after tLine
      put " | " & tText after tLine
      put Notes.File() into tFile
      put tLine & cr after URL ("file:" & tFile)
      put tFile into sSaid
   end if
   Notes.Close
end Notes.Save

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
   return "//wsl$/Ubuntu/home/igame3d/projects/LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt"
end Notes.File

function Notes.LastFile
   return sSaid
end Notes.LastFile
