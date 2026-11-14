script "Seq_Clip_Title"
## CLIP Title: big centred text, or a list of them one after another (a big board, a
## title card, DEFCON counting down).
##   items    one or more texts separated by commas: DEFCON 4,DEFCON 3
##   every    seconds per item (default 1)        size (default 36)
##   y        0..1 of the view height (default 0.4)  color (default the console colour)
##   blink=yes  the last item blinks               keep=yes  it stays after the clip ends
##   dur      seconds the last item stays (default = every)

local sItems, sEvery, sSize, sY, sColor, sBlink, sKeep, sDur, sId, sShown

on Clip.Start pSet, pWhat
   put pSet["items"] into sItems
   if sItems is empty then put pSet["text"] into sItems
   put pSet["every"] into sEvery
   if sEvery is not a number then put 1 into sEvery
   put pSet["size"] into sSize
   if sSize is not a number then put 36 into sSize
   put pSet["y"] into sY
   if sY is not a number then put 0.4 into sY
   put pSet["color"] into sColor
   put pSet["blink"] is "yes" into sBlink
   put pSet["keep"] is "yes" into sKeep
   put pSet["dur"] into sDur
   if sDur is not a number then put sEvery into sDur
   put pSet["id"] into sId
   if sId is empty then put "title" & the short id of me into sId
   put 0 into sShown
end Clip.Start

on Clip.Step pT
   local n, tCount, tText
   put the number of items of sItems into tCount
   put min(tCount, trunc(pT / sEvery) + 1) into n
   put item n of sItems into tText
   if sBlink and n is tCount and trunc(pT * 3) mod 2 is 1 then put empty into tText
   if tText is empty then
      Term.Remove sId
   else
      Term.Set sId, tText, Term.CenterX(tText, sSize), Term.Y(sY), sSize, sColor
   end if
   if pT >= (tCount - 1) * sEvery + sDur then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
   if sKeep then
      Term.Set sId, item -1 of sItems, Term.CenterX(item -1 of sItems, sSize), Term.Y(sY), sSize, sColor
   else
      Term.Remove sId
   end if
end Clip.Stop
