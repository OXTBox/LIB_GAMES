script "Seq_Clip_Input"
## CLIP Input: the player types an answer (a name, a word) and presses Return. hold=yes.
##   text    the question, printed first (optional)     var   where the answer is kept
##   max     longest answer (default 20)                color console colour if empty
## Later lines use the answer as {var} (or {var:filter}, see Sequencer/README.md).

local sVar, sMax, sTyped, sId, sDoneAt, sNow, sDone

on Clip.Start pSet, pWhat
   put pSet["var"] into sVar
   put pSet["max"] into sMax
   if sMax is not a number then put 20 into sMax
   if pSet["text"] is not empty then get Term.Print(pSet["text"], pSet["color"])
   put Term.Print("> _", pSet["color"]) into sId
   put empty into sTyped
   put false into sDone
   put 0 into sNow
end Clip.Start

on Clip.Step pT
   put pT into sNow
   if not sDone then
      Term.Text sId, "> " & sTyped & char 1 to (trunc(pT * 3) mod 2) of "_"
      exit Clip.Step
   end if
   Term.Text sId, "> " & sTyped
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   if sDone then return "taken"
   if pKey is "return" then
      if word 1 to -1 of sTyped is not empty then
         put word 1 to -1 of sTyped into sTyped
         if sVar is not empty then Seq.SetVar sVar, sTyped
         put true into sDone
         put sNow + 0.4 into sDoneAt
      end if
      return "taken"
   end if
   if pKey is "backspace" then
      delete char -1 of sTyped
      return "taken"
   end if
   if the number of chars of pKey is 1 and the number of chars of sTyped < sMax then put toUpper(pKey) after sTyped
   return "taken"
end Clip.Key

on Clip.Stop
end Clip.Stop
