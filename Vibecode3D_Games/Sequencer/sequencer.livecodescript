script "Sequencer"
######################################################################################
## SEQUENCER for Vibecode3D game cards  (11 12 2026)
## Plays a SEQUENCE: a cue sheet of CLIPS on a timeline, read from a text file
## <game>/Data/Sequences/<Name>.seq. Each clip kind is a script-only stack
## (<game>/Data/Clips/<Kind>.livecodescript, else Sequencer/Clips/<Kind>.livecodescript)
## used as the behaviour of a small invisible button, so clip code reaches the card
## and the engine as if it were written on the card. Format and words: Sequencer/README.md.
##
## This script is the behaviour of the group "Sequencer" on the game card (the card makes it).
## The card calls (dispatch ... to group "Sequencer"):
##   Seq.Setup gameDataFolder, sharedFolder     once, at Game.OnStart
##   Seq.Play name     Seq.Step seconds     Seq.Key key     Seq.Skip     Seq.StopAll
## and gets back:  Seq.Ended name   (dispatched to the card when every clip is done)
## Clips call (they sit inside this group, so these are in their message path):
##   Seq.SetVar / Seq.Var()   Seq.Jump name (play another sequence next: a branch)
##   Term.*  (the vector terminal layer below)
## Settings may hold sequence variables: {name}, or {name:filter} where the card answers
##   function Seq.Filter filterName, value   (e.g. Thrmnlra's "garble": the name misspelled)
##   and LIB_GENERICA labels: {@list:n} = label n of that list (after the game's Gen.Load)
## A clip kind answers:  Clip.Start settingsArray, what   Clip.Step secondsSinceStart
##   (return "done" when finished)   Clip.Key key (return "taken")   Clip.Stop
##   and optionally Clip.Watch key: sees EVERY key first, without taking it (Hotword)
## Any line can have:  background=yes  (the sequence does not wait for it, and it is
##   stopped when everything else is done)   until=<id>  (it ends when clip <id> starts)
######################################################################################

local sPaths, sKinds, sRows, sRowCount, sClock, sName, sRunning, sVars, sSerial, sJump
local sTerm, sTermDirty, sBits, sFade, sCon, sFont, sPath, sHide

-------------------------------------------------------------------- setup

on Seq.Setup pGameData, pShared
   put pGameData into sPaths["game"]
   put pShared into sPaths["shared"]
   put 1 into sFade
   Term.ConsoleSetup 0.04, 0.05, 0.92, 30, 12, "#7CFF7C"
end Seq.Setup

-- forget the loaded clip kinds, so edited .livecodescript files are read again
on Seq.Reload
   local tKind
   Seq.StopAll
   repeat for each key tKind in sKinds
      if exists(sKinds[tKind]) then do "delete" && sKinds[tKind]
   end repeat
   put empty into sKinds
end Seq.Reload

-------------------------------------------------------------------- playing a scene

on Seq.Play pName
   local tFile, tText, tLine, n, tWhen, tHead
   Seq.StopAll
   put sPaths["game"] & "/Sequences/" & pName & ".seq" into tFile
   if there is not a file tFile then
      Term.Set "seq.err", "NO SEQUENCE" && pName, 20, 20, 12, "#FF4040"
      return "no scene"
   end if
   put URL ("file:" & tFile) into tText
   replace numToChar(13) with empty in tText
   put 0 into n
   put 0 into tHead
   set the itemDel to "|"
   repeat for each line tLine in tText
      if word 1 of tLine is empty or char 1 of word 1 of tLine is "#" then next repeat
      if the number of items of tLine < 3 then next repeat
      put Seq.Trim(item 1 of tLine) into tWhen
      if tWhen is "when" then next repeat      -- the column header
      add 1 to n
      put tWhen into sRows[n]["when"]
      put Seq.Trim(item 2 of tLine) into sRows[n]["track"]
      put Seq.Trim(item 3 of tLine) into sRows[n]["clip"]
      put Seq.Settings(item 4 of tLine) into sRows[n]["set"]
      put Seq.Trim(item 5 of tLine) into sRows[n]["what"]
      put sRows[n]["set"]["id"] into sRows[n]["id"]
      put "wait" into sRows[n]["state"]
      -- a beat = a line plus the "with" lines under it; "+" waits for the whole beat above
      if word 1 of tWhen is "with" and n > 1 then
         put tHead into sRows[n]["beat"]
      else
         put n into tHead
         put n into sRows[n]["beat"]
      end if
   end repeat
   set the itemDel to comma
   put n into sRowCount
   put pName into sName
   put 0 into sClock
   put empty into sJump
   put true into sRunning
   return empty
end Seq.Play

-- one fixed step: start the clips whose time has come, step the running ones
on Seq.Step pDT
   local n, tHold, tAllDone, tJump
   if not sRunning then
      Term.Step pDT
      Term.Render
      exit Seq.Step
   end if
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "wait" then
         if Seq.Ready(n) then Seq.StartRow n
      end if
   end repeat
   -- until=<id>: a line ends when that clip starts
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "on" and sRows[n]["set"]["until"] is not empty then
         if Seq.RowById(sRows[n]["set"]["until"]) > 0 then
            if sRows[Seq.RowById(sRows[n]["set"]["until"])]["state"] is not "wait" then Seq.EndRow n
         end if
      end if
   end repeat
   put false into tHold
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is not "on" then next repeat
      add pDT to sRows[n]["t"]
      dispatch "Clip.Step" to sRows[n]["btn"] with sRows[n]["t"]
      if the result is "done" then
         Seq.EndRow n
      else if sRows[n]["set"]["hold"] is "yes" then
         put true into tHold
      end if
   end repeat
   -- a holding clip (the player must act) stops the scene clock, like a pause on the timeline
   if not tHold then add pDT to sClock
   if sVars["_standbyUntil"] is a number then
      if sClock >= sVars["_standbyUntil"] or tHold then
         Term.Remove "seq.standby"
         put empty into sVars["_standbyUntil"]
      end if
   end if
   Term.Step pDT
   Term.Render
   -- a branch asked for by a clip: this sequence stops, the other one starts
   if sJump is not empty then
      put sJump into tJump
      put empty into sJump
      Seq.Play tJump
      exit Seq.Step
   end if
   put true into tAllDone
   repeat with n = 1 to sRowCount
      if sRows[n]["set"]["background"] is "yes" then next repeat
      if sRows[n]["state"] is not "done" then
         put false into tAllDone
         exit repeat
      end if
   end repeat
   if tAllDone then
      repeat with n = 1 to sRowCount
         if sRows[n]["state"] is "on" then Seq.EndRow n
      end repeat
      put false into sRunning
      dispatch "Seq.Ended" to this card with sName
   end if
end Seq.Step

-- a key typed by the player goes to the running clips, newest first, until one takes it
on Seq.Key pKey
   local n
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "on" then
         dispatch "Clip.Watch" to sRows[n]["btn"] with pKey
         if the result is "taken" then
            Seq.LogKey pKey, sRows[n]["clip"]
            exit Seq.Key        -- a watcher heard its word (Hotword): it takes this key
         end if
      end if
   end repeat
   repeat with n = sRowCount down to 1
      if sRows[n]["state"] is not "on" then next repeat
      dispatch "Clip.Key" to sRows[n]["btn"] with pKey
      if the result is "taken" then
         Seq.LogKey pKey, sRows[n]["clip"]
         exit Seq.Key
      end if
   end repeat
   -- nobody is listening right now (a line is still typing, a fade): say so
   Seq.LogKey pKey, "-"
   Term.Set "seq.standby", "STAND BY", Term.CenterX("STAND BY", 10), Term.Y(0.965), 10, "#FF4040"
   put sClock + 0.6 into sVars["_standbyUntil"]
end Seq.Key

-- the last 40 keys: time, sequence, which clip took it ("-" = none). Read with Seq.KeyLog()
on Seq.LogKey pKey, pClip
   put the long time && sName && pClip && pKey & cr after sVars["_keylog"]
   if the number of lines of sVars["_keylog"] > 40 then delete line 1 of sVars["_keylog"]
end Seq.LogKey

function Seq.KeyLog
   return sVars["_keylog"]
end Seq.KeyLog

-- skip ahead: end every running clip that is not holding for the player
on Seq.Skip
   local n
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "on" and sRows[n]["set"]["hold"] is not "yes" then Seq.EndRow n
   end repeat
end Seq.Skip

on Seq.StopAll
   local n
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "on" then Seq.EndRow n
   end repeat
   put empty into sRows
   put 0 into sRowCount
   put false into sRunning
end Seq.StopAll

function Seq.Running
   return sRunning
end Seq.Running

function Seq.Clock
   return sClock
end Seq.Clock

-- "name|Kind,Kind": the sequence playing and the clip kinds running now (tests, debugging)
function Seq.Now
   local n, tKinds
   repeat with n = 1 to sRowCount
      if sRows[n]["state"] is "on" then put sRows[n]["clip"] & comma after tKinds
   end repeat
   delete the last char of tKinds
   return sName & "|" & tKinds
end Seq.Now

-- play another sequence after this step (clips call it; safe while a clip is running)
on Seq.Jump pName
   put pName into sJump
end Seq.Jump

on Seq.SetVar pName, pValue
   put pValue into sVars[pName]
end Seq.SetVar

function Seq.Var pName
   return sVars[pName]
end Seq.Var

-------------------------------------------------------------------- timing

-- when:  0 / 12.5 / 1:05 (scene clock)   +0.5 (after the beat above ends)
--        with / with +0.5 (with the line above starts)   after <id> [+s]   with <id> [+s]
function Seq.Ready n
   local tWhen, tOff, tRef, tBeat, k, tEnd
   put sRows[n]["when"] into tWhen
   if char 1 of tWhen is "+" then
      put Seq.Off(tWhen) into tOff
      if n is 1 then return sClock >= tOff
      put sRows[n - 1]["beat"] into tBeat
      put 0 into tEnd
      repeat with k = tBeat to n - 1
         if sRows[k]["beat"] is not tBeat then next repeat
         if sRows[k]["set"]["background"] is "yes" then next repeat
         if sRows[k]["state"] is not "done" then return false
         put max(tEnd, sRows[k]["doneAt"]) into tEnd
      end repeat
      return sClock >= tEnd + tOff
   end if
   if word 1 of tWhen is "with" then
      if the number of words of tWhen <= 1 or char 1 of word 2 of tWhen is "+" then
         put n - 1 into tRef
         put Seq.Off(word 2 of tWhen) into tOff
      else
         put Seq.RowById(word 2 of tWhen) into tRef
         put Seq.Off(word 3 of tWhen) into tOff
      end if
      if tRef < 1 then return true
      if sRows[tRef]["state"] is "wait" then return false
      return sClock >= sRows[tRef]["startAt"] + tOff
   end if
   if word 1 of tWhen is "after" then
      put Seq.RowById(word 2 of tWhen) into tRef
      put Seq.Off(word 3 of tWhen) into tOff
      if tRef < 1 then return true
      if sRows[tRef]["state"] is not "done" then return false
      return sClock >= sRows[tRef]["doneAt"] + tOff
   end if
   if Seq.Secs(tWhen) is a number then return sClock >= Seq.Secs(tWhen)
   return true
end Seq.Ready

function Seq.Secs pText
   local tText
   put Seq.Trim(pText) into tText
   if tText is a number then return tText
   set the itemDel to ":"
   if the number of items of tText is 2 and item 1 of tText is a number and item 2 of tText is a number then
      return item 1 of tText * 60 + item 2 of tText
   end if
   return empty
end Seq.Secs

function Seq.Off pText
   local tText
   put Seq.Trim(pText) into tText
   if char 1 of tText is "+" then delete char 1 of tText
   if tText is a number then return tText
   return 0
end Seq.Off

function Seq.RowById pId
   local n
   repeat with n = 1 to sRowCount
      if sRows[n]["id"] is pId then return n
   end repeat
   return 0
end Seq.RowById

-------------------------------------------------------------------- clips

on Seq.StartRow n
   local tKind, tGroup, tSet, tKey
   put sClock into sRows[n]["startAt"]
   put 0 into sRows[n]["t"]
   put Seq.Kind(sRows[n]["clip"]) into tKind
   if tKind is empty then
      Term.Print "NO CLIP KIND" && sRows[n]["clip"], "#FF4040"
      put "done" into sRows[n]["state"]
      put sClock into sRows[n]["doneAt"]
      exit Seq.StartRow
   end if
   put the short id of me into tGroup
   add 1 to sSerial
   create invisible button ("Clip" && sSerial && sRows[n]["clip"]) in group id tGroup
   put the long id of it into sRows[n]["btn"]
   put the short id of it into sRows[n]["bid"]
   set the behavior of sRows[n]["btn"] to tKind
   put "on" into sRows[n]["state"]
   put sRows[n]["set"] into tSet
   repeat for each key tKey in tSet
      put Seq.Fill(tSet[tKey]) into tSet[tKey]
   end repeat
   dispatch "Clip.Start" to sRows[n]["btn"] with tSet, sRows[n]["what"]
end Seq.StartRow

on Seq.EndRow n
   if sRows[n]["state"] is not "on" then exit Seq.EndRow
   put "done" into sRows[n]["state"]
   put sClock into sRows[n]["doneAt"]
   if there is a button id sRows[n]["bid"] then
      dispatch "Clip.Stop" to sRows[n]["btn"]
      delete button id sRows[n]["bid"]
   end if
end Seq.EndRow

-- the script-only stack of a clip kind: the game's own Data/Clips first, then the shared ones
function Seq.Kind pKind
   local tPath
   if sKinds[pKind] is not empty then return sKinds[pKind]
   put sPaths["game"] & "/Clips/" & pKind & ".livecodescript" into tPath
   if there is not a file tPath then put sPaths["shared"] & "/Clips/" & pKind & ".livecodescript" into tPath
   if there is not a file tPath then return empty
   put the long id of stack tPath into sKinds[pKind]
   return sKinds[pKind]
end Seq.Kind

-- {name} -> the variable; {name:filter} -> the card's Seq.Filter(filter, value)
-- (not | : that splits the columns of a .seq line)
function Seq.Fill pText
   local tOut, tStart, tEnd, tRef, tVal, tFilter
   put pText into tOut
   repeat 20 times
      put offset("{", tOut) into tStart
      if tStart is 0 then exit repeat
      put offset("}", tOut, tStart) into tEnd
      if tEnd is 0 then exit repeat
      put char tStart + 1 to tStart + tEnd - 1 of tOut into tRef
      put empty into tFilter
      if ":" is in tRef then
         put char offset(":", tRef) + 1 to -1 of tRef into tFilter
         put char 1 to offset(":", tRef) - 1 of tRef into tRef
      end if
      if char 1 of tRef is "@" then
         -- {@list:n}: label n of a LIB_GENERICA list (the game loaded a set with Gen.Load)
         put empty into tVal
         dispatch function "Gen.Label" to me with char 2 to -1 of tRef, tFilter
         if it is "handled" then put the result into tVal
         put empty into tFilter
      else
         put sVars[tRef] into tVal
      end if
      if tFilter is not empty then
         dispatch function "Seq.Filter" to this card with tFilter, tVal
         if it is "handled" then put the result into tVal
      end if
      put tVal into char tStart to tStart + tEnd of tOut
   end repeat
   return tOut
end Seq.Fill

-- "key=value; key=value; flag" -> array (keys lower case)
function Seq.Settings pText
   local tOut, tPair, tKey
   set the itemDel to ";"
   repeat for each item tPair in pText
      put Seq.Trim(tPair) into tPair
      if tPair is empty then next repeat
      if "=" is in tPair then
         put toLower(Seq.Trim(char 1 to offset("=", tPair) - 1 of tPair)) into tKey
         put Seq.Trim(char offset("=", tPair) + 1 to -1 of tPair) into tOut[tKey]
      else
         put "yes" into tOut[toLower(tPair)]
      end if
   end repeat
   set the itemDel to comma
   return tOut
end Seq.Settings

function Seq.Trim pText
   return word 1 to -1 of pText
end Seq.Trim

######################################################################################
## TERM: a vector text layer of its own (the engine HUD is upper case only, one colour).
## Items: Term.Set id,text,x,y,size,colour[,style "bold wide"]   Term.Text id,text   Term.Remove id   Term.Clear
## Console (lines that scroll): Term.ConsoleSetup x,y,w,rows,size,colour (x,y,w as 0..1 of
## the view)   Term.Print(text[,colour]) returns the line's id   Term.ConsoleClear
## Effects: Term.Blast id (laser shots, then the letters fly apart in bits)   Term.SetFade 0..1
## Paths (trails, tracks, borders): Term.Path id, points, colour[, dashes]   Term.Remove id
##   points = "x,y" lines in card pixels; dashes = the graphic's dashes ("2,5,10,20" = 2 on,
##   5 off, 10 on, 20 off), so a few points make a long dotted arc
######################################################################################

-- pStyle (optional): words "bold" (every stroke drawn twice, a pixel apart) and "wide"
-- (letters spread by half a character width): map labels that must read at a glance
on Term.Set pId, pText, pX, pY, pSize, pColor, pStyle
   put pText into sTerm[pId]["text"]
   put pX into sTerm[pId]["x"]
   put pY into sTerm[pId]["y"]
   put pSize into sTerm[pId]["size"]
   if pColor is empty then put sCon["color"] into pColor
   put pColor into sTerm[pId]["color"]
   put pStyle into sTerm[pId]["style"]
   put Term.Points(pText, pX, pY, pSize, pStyle) into sTerm[pId]["pts"]
   put true into sTermDirty
end Term.Set

on Term.Text pId, pText
   if sTerm[pId]["size"] is empty then exit Term.Text
   if sTerm[pId]["text"] is pText then exit Term.Text
   Term.Set pId, pText, sTerm[pId]["x"], sTerm[pId]["y"], sTerm[pId]["size"], sTerm[pId]["color"], sTerm[pId]["style"]
end Term.Text

-- the width in pixels of a text at a size and style (wide: half a character more a letter)
function Term.Width pText, pSize, pStyle
   if "wide" is among the words of pStyle then return round(the number of chars of pText * pSize * 1.5)
   return the number of chars of pText * pSize
end Term.Width

on Term.Color pId, pColor
   if sTerm[pId]["size"] is empty then exit Term.Color
   if pColor is empty then put sCon["color"] into pColor
   put pColor into sTerm[pId]["color"]
   put true into sTermDirty
end Term.Color

on Term.Remove pId
   delete variable sTerm[pId]
   delete variable sPath[pId]
   put true into sTermDirty
end Term.Remove

on Term.Path pId, pPoints, pColor, pDashes
   if pColor is empty then put sCon["color"] into pColor
   put pPoints into sPath[pId]["pts"]
   put pColor into sPath[pId]["color"]
   put pDashes into sPath[pId]["dashes"]
   put true into sTermDirty
end Term.Path

on Term.Clear
   put empty into sTerm
   put empty into sPath
   put empty into sBits
   put empty into sCon["lines"]
   put 0 into sCon["count"]
   put true into sTermDirty
end Term.Clear

-- hide items and paths whose id starts with one of these prefixes (commas between), e.g.
-- "trail.,lbl." while the camera cuts to a close-up; empty shows everything again
on Term.Hide pPrefixes
   put pPrefixes into sHide
   put true into sTermDirty
end Term.Hide

function Term.Hidden pId
   local tP
   repeat for each item tP in sHide
      if tP is not empty and char 1 to the number of chars of tP of pId is tP then return true
   end repeat
   return false
end Term.Hidden

on Term.SetFade pFade
   put max(0, min(1, pFade)) into sFade
   put true into sTermDirty
end Term.SetFade

function Term.Has pId
   return sTerm[pId]["size"] is not empty
end Term.Has

function Term.GetText pId
   return sTerm[pId]["text"]
end Term.GetText

-- the view in card pixels
function Term.View
   global gViewLeft, gViewTop, gViewRight, gViewBottom
   return gViewLeft & comma & gViewTop & comma & gViewRight & comma & gViewBottom
end Term.View

-- x of text centred in the view
function Term.CenterX pText, pSize
   local tV
   put Term.View() into tV
   return round((item 1 of tV + item 3 of tV - the number of chars of pText * pSize) / 2)
end Term.CenterX

-- 0..1 of the view width -> card pixels
function Term.X pFrac
   local tV
   put Term.View() into tV
   return round(item 1 of tV + (item 3 of tV - item 1 of tV) * pFrac)
end Term.X

-- 0..1 of the view height -> card pixels
function Term.Y pFrac
   local tV
   put Term.View() into tV
   return round(item 2 of tV + (item 4 of tV - item 2 of tV) * pFrac)
end Term.Y

-------------------------------------------------------------------- console

on Term.ConsoleSetup pX, pY, pW, pRows, pSize, pColor
   local tV
   put Term.View() into tV
   put round(item 1 of tV + (item 3 of tV - item 1 of tV) * pX) into sCon["x"]
   put round(item 2 of tV + (item 4 of tV - item 2 of tV) * pY) into sCon["y"]
   put max(10, trunc((item 3 of tV - item 1 of tV) * pW / pSize)) into sCon["cols"]
   put pRows into sCon["rows"]
   put pSize into sCon["size"]
   if pColor is not empty then put pColor into sCon["color"]
   if sCon["color"] is empty then put "#7CFF7C" into sCon["color"]
   if sCon["count"] is empty then put 0 into sCon["count"]
end Term.ConsoleSetup

function Term.Cols
   return sCon["cols"]
end Term.Cols

-- a new console line; scrolls the oldest away when the console is full. A sticky line
-- (Term.Sticky: the player's input line) always stays last: new lines go in above it.
function Term.Print pText, pColor
   local tId, tSticky, tLines
   add 1 to sSerial
   put "con" & sSerial into tId
   if pColor is empty then put sCon["color"] into pColor
   put sCon["sticky"] into tSticky
   set the wholeMatches to true
   if tSticky is not empty and lineOffset(tSticky, sCon["lines"]) is 0 then put empty into tSticky
   if tSticky is not empty then
      delete line lineOffset(tSticky, sCon["lines"]) of sCon["lines"]
      put sCon["lines"] into tLines
      if tLines is empty then
         put tId & cr & tSticky into sCon["lines"]
      else
         put tLines & cr & tId & cr & tSticky into sCon["lines"]
      end if
   else if sCon["lines"] is empty then
      put tId into sCon["lines"]
   else
      put cr & tId after sCon["lines"]
   end if
   Term.Set tId, pText, sCon["x"], sCon["y"], sCon["size"], pColor
   repeat while the number of lines of sCon["lines"] > sCon["rows"]
      if line 1 of sCon["lines"] is tSticky then exit repeat
      Term.Remove line 1 of sCon["lines"]
      delete line 1 of sCon["lines"]
   end repeat
   put the number of lines of sCon["lines"] into sCon["count"]
   Term.ConsoleLayout
   return tId
end Term.Print

-- the input line that stays at the bottom of the console (empty: none)
on Term.Sticky pId
   put pId into sCon["sticky"]
end Term.Sticky

-- put every console line on its row, top to bottom
on Term.ConsoleLayout
   local k, tLine
   put 0 into k
   repeat for each line tLine in sCon["lines"]
      if sTerm[tLine]["size"] is not empty and sTerm[tLine]["y"] is not sCon["y"] + k * Term.LineH() then
         Term.Set tLine, sTerm[tLine]["text"], sCon["x"], sCon["y"] + k * Term.LineH(), sCon["size"], sTerm[tLine]["color"], sTerm[tLine]["style"]
      end if
      add 1 to k
   end repeat
end Term.ConsoleLayout

function Term.LineH
   return round(sCon["size"] * 1.6)
end Term.LineH

on Term.ConsoleClear
   local tLine
   repeat for each line tLine in sCon["lines"]
      Term.Remove tLine
   end repeat
   put empty into sCon["lines"]
   put empty into sCon["sticky"]
   put 0 into sCon["count"]
end Term.ConsoleClear

-- word wrap to the console width
function Term.Wrap pText, pCols
   local tOut, tLine, tWord
   repeat for each word tWord in pText
      if tLine is empty then
         put tWord into tLine
      else if the number of chars of tLine + 1 + the number of chars of tWord <= pCols then
         put space & tWord after tLine
      else
         put tLine & cr after tOut
         put tWord into tLine
      end if
   end repeat
   return tOut & tLine
end Term.Wrap

-------------------------------------------------------------------- effects

-- arcade lasers hit the letters, then every stroke flies off as a bit and fades
on Term.Blast pId
   local tPts, tPrev, tLine, tV, cx, cy, tN, k, x1, y1, x2, y2, mx, my, w
   if sTerm[pId]["size"] is empty then exit Term.Blast
   put Term.View() into tV
   put sTerm[pId]["pts"] into tPts
   put sTerm[pId]["x"] + the number of chars of sTerm[pId]["text"] * sTerm[pId]["size"] / 2 into cx
   put sTerm[pId]["y"] + sTerm[pId]["size"] / 2 into cy
   put the number of lines of the keys of sBits into tN
   -- laser lines from the two bottom corners, a quarter second
   repeat with k = 1 to 6
      add 1 to tN
      put item 1 of tV + (k mod 2) * (item 3 of tV - item 1 of tV) into sBits[tN]["x1"]
      put item 4 of tV into sBits[tN]["y1"]
      put max(1, round(the number of chars of sTerm[pId]["text"] * sTerm[pId]["size"])) into w
      put cx + random(w) - w / 2 into sBits[tN]["x2"]
      put cy into sBits[tN]["y2"]
      put 0 into sBits[tN]["vx"]
      put 0 into sBits[tN]["vy"]
      put 0.25 into sBits[tN]["life"]
      put "#FFFFFF" into sBits[tN]["color"]
   end repeat
   put empty into tPrev
   repeat for each line tLine in tPts
      if tLine is empty then
         put empty into tPrev
         next repeat
      end if
      if tPrev is not empty then
         put item 1 of tPrev into x1
         put item 2 of tPrev into y1
         put item 1 of tLine into x2
         put item 2 of tLine into y2
         put (x1 + x2) / 2 into mx
         put (y1 + y2) / 2 into my
         add 1 to tN
         put x1 into sBits[tN]["x1"]
         put y1 into sBits[tN]["y1"]
         put x2 into sBits[tN]["x2"]
         put y2 into sBits[tN]["y2"]
         put (mx - cx) * 3 + random(161) - 81 into sBits[tN]["vx"]
         put (my - cy) * 3 - random(220) into sBits[tN]["vy"]
         put 0.6 + random(60) / 100 into sBits[tN]["life"]
         put sTerm[pId]["color"] into sBits[tN]["color"]
         put 0.2 into sBits[tN]["delay"]
      end if
      put tLine into tPrev
   end repeat
   Term.Remove pId
end Term.Blast

on Term.Step pDT
   local k, tKeep, tN
   if sBits is not an array then exit Term.Step
   put 0 into tN
   repeat for each key k in sBits
      if sBits[k]["delay"] > 0 then
         subtract pDT from sBits[k]["delay"]
         add 1 to tN
         put sBits[k] into tKeep[tN]
         next repeat
      end if
      subtract pDT from sBits[k]["life"]
      if sBits[k]["life"] <= 0 then next repeat
      add sBits[k]["vx"] * pDT to sBits[k]["x1"]
      add sBits[k]["vx"] * pDT to sBits[k]["x2"]
      add sBits[k]["vy"] * pDT to sBits[k]["y1"]
      add sBits[k]["vy"] * pDT to sBits[k]["y2"]
      add 400 * pDT to sBits[k]["vy"]      -- they fall
      add 1 to tN
      put sBits[k] into tKeep[tN]
   end repeat
   put tKeep into sBits
   put true into sTermDirty
end Term.Step

-------------------------------------------------------------------- drawing

-- one line graphic per colour inside this group; strokes separated by empty lines
on Term.Render
   local tBuf, tId, tColor, tName, k, tGroup, tUsed
   if not sTermDirty then exit Term.Render
   put false into sTermDirty
   repeat for each key tId in sTerm
      if sHide is not empty and Term.Hidden(tId) then next repeat
      put sTerm[tId]["color"] into tColor
      put sTerm[tId]["pts"] after tBuf[tColor]
   end repeat
   -- paths: one graphic per colour and dash pattern ("#4C8CFF/2,5,10,20")
   repeat for each key tId in sPath
      if sHide is not empty and Term.Hidden(tId) then next repeat
      put sPath[tId]["color"] & "/" & sPath[tId]["dashes"] into tColor
      put cr & sPath[tId]["pts"] & cr after tBuf[tColor]
   end repeat
   repeat for each key k in sBits
      put sBits[k]["color"] into tColor
      put cr & round(sBits[k]["x1"]) & comma & round(sBits[k]["y1"]) & cr & round(sBits[k]["x2"]) & comma & round(sBits[k]["y2"]) & cr after tBuf[tColor]
   end repeat
   put the short id of me into tGroup
   lock screen
   repeat for each key tColor in tBuf
      put "Term" && tColor into tName
      if there is not a graphic tName of group id tGroup then
         reset the templateGraphic
         create graphic tName in group id tGroup
         set the style of graphic tName of group id tGroup to "line"
         set the lineSize of graphic tName of group id tGroup to 1
         set the opaque of graphic tName of group id tGroup to false
      end if
      if "/" is in tColor then
         set the foregroundColor of graphic tName of group id tGroup to Term.Faded(char 1 to offset("/", tColor) - 1 of tColor)
         set the dashes of graphic tName of group id tGroup to char offset("/", tColor) + 1 to -1 of tColor
      else
         set the foregroundColor of graphic tName of group id tGroup to Term.Faded(tColor)
      end if
      set the points of graphic tName of group id tGroup to tBuf[tColor]
      set the visible of graphic tName of group id tGroup to true
      put tName & cr after tUsed
   end repeat
   -- colours no longer used: empty their graphic
   repeat with k = the number of graphics of group id tGroup down to 1
      put the short name of graphic k of group id tGroup into tName
      if word 1 of tName is "Term" and tName is not among the lines of tUsed then
         set the points of graphic k of group id tGroup to empty
         set the visible of graphic k of group id tGroup to false
      end if
   end repeat
   unlock screen
end Term.Render

function Term.Faded pColor
   local tRGB
   put Term.RGB(pColor) into tRGB
   return round(item 1 of tRGB * sFade) & comma & round(item 2 of tRGB * sFade) & comma & round(item 3 of tRGB * sFade)
end Term.Faded

function Term.RGB pColor
   if char 1 of pColor is "#" and the number of chars of pColor is 7 then
      return baseConvert(char 2 to 3 of pColor, 16, 10) & comma & baseConvert(char 4 to 5 of pColor, 16, 10) & comma & baseConvert(char 6 to 7 of pColor, 16, 10)
   end if
   switch pColor
      case "red"
         return "255,64,64"
      case "green"
         return "124,255,124"
      case "amber"
         return "255,176,0"
      case "blue"
         return "64,128,255"
      case "white"
         return "255,255,255"
   end switch
   if the number of items of pColor is 3 then return pColor
   return "124,255,124"
end Term.RGB

-------------------------------------------------------------------- the vector font

-- the engine's VectorText glyphs (4 x 6 grid, "xy" points, | between strokes) plus
-- the terminal characters it lacks: > < [ ] ? , ' " = _ % # * ( ) \ ;
-- pStyle: "bold" draws each stroke twice, one pixel apart; "wide" spreads the letters by
-- half a character width (the owner, 13 Nov: city names hard to read)
function Term.Points pText, pX, pY, pSize, pStyle
   local k, tCX, tPts, tCh, tGlyph, tStroke, w, tAdvance, tBold, tDX
   if sFont is not an array then Term.Font
   put pSize / 6 into k
   put 6 * k into tAdvance
   if "wide" is among the words of pStyle then put 9 * k into tAdvance
   put "bold" is among the words of pStyle into tBold
   put pX into tCX
   repeat for each char tCh in toUpper(pText)
      put sFont[tCh] into tGlyph
      if tGlyph is not empty then
         replace "|" with cr in tGlyph
         repeat for each line tStroke in tGlyph
            repeat for each item tDX in "0,1"
               if tDX is 1 and not tBold then exit repeat
               put cr after tPts
               repeat for each word w in tStroke
                  put round(tCX + tDX + (char 1 of w) * k) & comma & round(pY + (char 2 of w) * k) & cr after tPts
               end repeat
            end repeat
         end repeat
      end if
      add tAdvance to tCX
   end repeat
   return tPts
end Term.Points

on Term.Font
   put "00 40 46 06 00|06 40" into sFont["0"]
   put "10 20 26|16 36" into sFont["1"]
   put "00 40 43 03 06 46" into sFont["2"]
   put "00 40 46 06|03 43" into sFont["3"]
   put "00 03 43|40 46" into sFont["4"]
   put "40 00 03 33 44 45 36 06" into sFont["5"]
   put "40 00 06 46 43 03" into sFont["6"]
   put "00 40 46" into sFont["7"]
   put "00 40 46 06 00|03 43" into sFont["8"]
   put "43 03 00 40 46 06" into sFont["9"]
   put "06 02 20 42 46|03 43" into sFont["A"]
   put "00 30 41 42 33 03|33 44 45 36 06 00" into sFont["B"]
   put "40 00 06 46" into sFont["C"]
   put "00 30 41 45 36 06 00" into sFont["D"]
   put "40 00 06 46|03 33" into sFont["E"]
   put "40 00 06|03 33" into sFont["F"]
   put "40 00 06 46 43 23" into sFont["G"]
   put "00 06|40 46|03 43" into sFont["H"]
   put "00 40|20 26|06 46" into sFont["I"]
   put "40 45 36 16 05" into sFont["J"]
   put "00 06|40 03 46" into sFont["K"]
   put "00 06 46" into sFont["L"]
   put "06 00 23 40 46" into sFont["M"]
   put "06 00 46 40" into sFont["N"]
   put "00 40 46 06 00" into sFont["O"]
   put "06 00 40 43 03" into sFont["P"]
   put "00 40 46 06 00|24 46" into sFont["Q"]
   put "06 00 40 43 03 46" into sFont["R"]
   put "40 00 03 43 46 06" into sFont["S"]
   put "00 40|20 26" into sFont["T"]
   put "00 06 46 40" into sFont["U"]
   put "00 26 40" into sFont["V"]
   put "00 06 23 46 40" into sFont["W"]
   put "00 46|40 06" into sFont["X"]
   put "00 23 40|23 26" into sFont["Y"]
   put "00 40 06 46" into sFont["Z"]
   put "21 22|24 25" into sFont[":"]
   put "03 43" into sFont["-"]
   put "03 43|21 25" into sFont["+"]
   put "25 26" into sFont["."]
   put "20 24|25 26" into sFont["!"]
   put "06 40" into sFont["/"]
   put "06 20 46 06" into sFont["^"]
   put "11 33 15" into sFont[">"]
   put "31 13 35" into sFont["<"]
   put "30 10 16 36" into sFont["["]
   put "10 30 36 16" into sFont["]"]
   put "01 10 30 41 42 22 23|25 26" into sFont["?"]
   put "25 16" into sFont[","]
   put "21 22|24 15" into sFont[";"]
   put "20 21" into sFont["'"]
   put "10 11|30 31" into sFont[quote]
   put "02 42|04 44" into sFont["="]
   put "06 46" into sFont["_"]
   put "06 40|00 11|35 46" into sFont["%"]
   put "10 16|30 36|02 42|04 44" into sFont["#"]
   put "11 35|31 15|03 43" into sFont["*"]
   put "30 11 15 36" into sFont["("]
   put "10 31 35 16" into sFont[")"]
   put "00 46" into sFont["\"]
end Term.Font
