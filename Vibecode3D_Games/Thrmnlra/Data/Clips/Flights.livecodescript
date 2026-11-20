script "Thrmnlra_Clip_Flights"
## CLIP Flights (Thrmnlra): waits until the missiles in the air have all come down (or been
## destroyed): "let them fly". Keys typed meanwhile still move a keystroke clock.
##   team   blue, red or all (default all)
##   max    seconds it waits at most (default 30)

local sTeam, sMax

on Clip.Start pSet, pWhat
   put pSet["team"] into sTeam
   if sTeam is empty then put "all" into sTeam
   put pSet["max"] into sMax
   if sMax is not a number then put 30 into sMax
end Clip.Start

on Clip.Step pT
   if pT >= 0.2 and Thrm.InAir(sTeam) is 0 then return "done"
   if pT >= sMax then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
end Clip.Stop
