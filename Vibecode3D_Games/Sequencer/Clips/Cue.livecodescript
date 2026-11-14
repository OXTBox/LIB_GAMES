script "Seq_Clip_Cue"
## CLIP Cue: an instant event for the game itself (theatre: "standby... GO").
## Calls a handler on the game card with all the settings, e.g.
##   call=Thrm.World; mood=alert      -> the card's  on Thrm.World pSet  (pSet["mood"] = "alert")
##   dur=seconds  keeps the clip running that long after the call (default 0)

local sDur

on Clip.Start pSet, pWhat
   put pSet["dur"] into sDur
   if sDur is not a number then put 0 into sDur
   if pSet["call"] is not empty then dispatch pSet["call"] to this card with pSet
end Clip.Start

on Clip.Step pT
   if pT >= sDur then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
end Clip.Stop
