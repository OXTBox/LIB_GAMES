script "Seq_Clip_Wait"
## CLIP Wait: nothing happens for a while (a pause, a held black screen).
##   dur=seconds (default 1)

local sDur

on Clip.Start pSet, pWhat
   put pSet["dur"] into sDur
   if sDur is not a number then put 1 into sDur
end Clip.Start

on Clip.Step pT
   if pT >= sDur then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
end Clip.Stop
