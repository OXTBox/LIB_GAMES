script "Seq_Clip_Hotword"
## CLIP Hotword: listens to every key in the background (a shortcut, a cheat word). When
## the player types one of its words, wherever they are in the sequence, it jumps.
## Use with background=yes (the sequence does not wait for it) and until=<id> to stop
## listening when a clip starts (e.g. before a drill that asks for that very word).
##   words   what to listen for, commas between (LAUNCH)
##   goto    the sequence to jump to
##   say     a line printed first (optional)   color   its colour
##   clear=yes  clears the terminal layer before the jump (titles too)

local sWords, sGoto, sSay, sColor, sClear, sBuf, sJumpAt, sNow

on Clip.Start pSet, pWhat
   put toUpper(pSet["words"]) into sWords
   put pSet["goto"] into sGoto
   put pSet["say"] into sSay
   put pSet["color"] into sColor
   put pSet["clear"] is "yes" into sClear
   put empty into sBuf
   put empty into sJumpAt
   put 0 into sNow
end Clip.Start

on Clip.Watch pKey
   local tWord, tLine
   if sJumpAt is not empty or the number of chars of pKey is not 1 then exit Clip.Watch
   put toUpper(pKey) after sBuf
   put char -24 to -1 of sBuf into sBuf
   repeat for each item tWord in sWords
      if char -(the number of chars of tWord) to -1 of sBuf is tWord then
         if sSay is not empty then
            repeat for each line tLine in Term.Wrap(sSay, Term.Cols())
               get Term.Print(tLine, sColor)
            end repeat
         end if
         put sNow + 1.2 into sJumpAt
         return "taken"     -- heard: no STAND BY for this key
      end if
   end repeat
end Clip.Watch

on Clip.Step pT
   put pT into sNow
   if sJumpAt is not empty and pT >= sJumpAt then
      if sClear then Term.Clear
      if sGoto is not empty then Seq.Jump sGoto
      return "done"
   end if
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
end Clip.Stop
