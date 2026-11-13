script "Seq_Clip_Ask"
## CLIP Ask: the player answers. Use hold=yes so the scene waits for the answer.
##   text      the question, shown first (optional; often the Type line above asks it)
##   options   YES,NO: shown as [Y]ES / [N]O; a key picks the option it starts with,
##             or the whole word typed + Return
##   anykey=yes   any key counts as the first option
##   var       the answer is kept as a scene variable (Seq.Var(name)) for later clips
##   blast=yes the question and the options are shot into bits by arcade lasers
##   color     console colour if empty
##   words     extra answers typed in full, "?" at the end optional (WHAT,HUH,WTF,HELP);
##   goto      ...and the sequence they jump to (a branch: the rest of this one is skipped)

local sOptions, sVar, sBlast, sIds, sTyped, sChosen, sDoneAt, sAny, sColor, sOptId, sNow, sWords, sGoto, sBranch

on Clip.Start pSet, pWhat
   local tLine, tOpt
   put pSet["options"] into sOptions
   if sOptions is empty then put "YES,NO" into sOptions
   put pSet["var"] into sVar
   put pSet["blast"] is "yes" into sBlast
   put pSet["anykey"] is "yes" into sAny
   put pSet["color"] into sColor
   put toUpper(pSet["words"]) into sWords
   put pSet["goto"] into sGoto
   put false into sBranch
   put empty into sIds
   if pSet["text"] is not empty then put Term.Print(pSet["text"], sColor) into sIds
   repeat for each item tOpt in sOptions
      if tLine is not empty then put " / " after tLine
      put "[" & char 1 of tOpt & "]" & char 2 to -1 of tOpt after tLine
   end repeat
   put Term.Print(tLine && "> _", sColor) into sOptId
   Term.Sticky sOptId
   put sOptId & cr after sIds
   put empty into sTyped
   put empty into sChosen
   put 0 into sNow
end Clip.Start

on Clip.Step pT
   local tLine
   put pT into sNow
   if sChosen is empty then
      -- blinking prompt with what has been typed so far
      put Term.GetText(sOptId) into tLine
      put char 1 to offset(">", tLine) of tLine && sTyped into tLine
      if trunc(pT * 3) mod 2 is 0 then put "_" after tLine
      Term.Text sOptId, tLine
      exit Clip.Step
   end if
   if pT >= sDoneAt then
      if sBranch and sGoto is not empty then Seq.Jump sGoto
      return "done"
   end if
end Clip.Step

on Clip.Key pKey
   local tOpt
   if sChosen is not empty then return "taken"
   if pKey is "return" then
      repeat for each item tOpt in sOptions
         if toUpper(sTyped) is toUpper(tOpt) then Ask.Choose tOpt
      end repeat
      put empty into sTyped
      return "taken"
   end if
   if pKey is "backspace" then
      delete char -1 of sTyped
      return "taken"
   end if
   if the number of chars of pKey is not 1 then return "taken"
   if sAny then
      Ask.Choose item 1 of sOptions
      return "taken"
   end if
   put toUpper(pKey) after sTyped
   -- a branch word typed whole (WHAT, WHAT?): chosen at once
   if Ask.Word() is not empty then
      put true into sBranch
      Ask.Choose Ask.Word()
      return "taken"
   end if
   -- not on the way to a branch word: start over from this key, so a stray letter
   -- never blocks Y / N (it used to pile up in front of them)
   if not Ask.Prefix(sTyped) then put toUpper(pKey) into sTyped
   if the number of chars of sTyped is 1 and not Ask.Prefix(sTyped) then
      repeat for each item tOpt in sOptions
         if char 1 of toUpper(tOpt) is toUpper(pKey) then
            Ask.Choose tOpt
            exit repeat
         end if
      end repeat
   end if
   return "taken"
end Clip.Key

-- the typed text without trailing ?, if it is one of the branch words
function Ask.Word
   local tText
   put sTyped into tText
   repeat while char -1 of tText is "?"
      delete char -1 of tText
   end repeat
   if tText is not empty and tText is among the items of sWords then return tText
   return empty
end Ask.Word

-- does a branch word start with what was typed (then a first letter does not pick an option)
function Ask.Prefix pText
   local tWord
   repeat for each item tWord in sWords
      if char 1 to the number of chars of pText of tWord is pText then return true
   end repeat
   return false
end Ask.Prefix

on Ask.Choose pOpt
   local tId
   put pOpt into sChosen
   if sVar is not empty then Seq.SetVar sVar, pOpt
   Term.Text sOptId, char 1 to offset(">", Term.GetText(sOptId)) of Term.GetText(sOptId) && toUpper(pOpt)
   if sBlast then
      repeat for each line tId in sIds
         Term.Blast tId
      end repeat
      put sNow + 1.4 into sDoneAt     -- lasers, then the bits fall
   else
      put sNow + 0.3 into sDoneAt
   end if
end Ask.Choose

on Clip.Stop
   Term.Sticky empty
end Clip.Stop
