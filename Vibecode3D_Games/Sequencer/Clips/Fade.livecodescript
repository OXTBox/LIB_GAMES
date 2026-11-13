script "Seq_Clip_Fade"
## CLIP Fade: the whole terminal layer fades (film: fade out / fade in).
##   dur      seconds (default 1)
##   to       0 = out to black (default), 1 = back in    from = start level (default the other one)
##   clear=yes  everything on the terminal is removed at the end and the light comes back,
##              ready for the next shot (a cut to a clean screen)

local sDur, sFrom, sTo, sClear

on Clip.Start pSet, pWhat
   put pSet["dur"] into sDur
   if sDur is not a number then put 1 into sDur
   put pSet["to"] into sTo
   if sTo is not a number then put 0 into sTo
   put pSet["from"] into sFrom
   if sFrom is not a number then put 1 - sTo into sFrom
   put pSet["clear"] is "yes" into sClear
end Clip.Start

on Clip.Step pT
   if sDur <= 0 then
      Term.SetFade sTo
      return "done"
   end if
   Term.SetFade sFrom + (sTo - sFrom) * min(1, pT / sDur)
   if pT >= sDur then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
   if sClear then
      Term.Clear
      Term.SetFade 1
   else
      Term.SetFade sTo
   end if
end Clip.Stop
