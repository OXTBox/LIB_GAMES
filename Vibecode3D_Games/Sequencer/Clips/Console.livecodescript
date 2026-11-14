script "Seq_Clip_Console"
## CLIP Console: where the typed terminal lines go (a layout change, like moving a window).
##   x, y, w = 0..1 of the view (defaults 0.04, 0.05, 0.92)   rows (30)   size (12)
##   color (#7CFF7C phosphor green)   clear=yes empties the console first

on Clip.Start pSet, pWhat
   local x, y, w, tRows, tSize
   put pSet["x"] into x
   if x is not a number then put 0.04 into x
   put pSet["y"] into y
   if y is not a number then put 0.05 into y
   put pSet["w"] into w
   if w is not a number then put 0.92 into w
   put pSet["rows"] into tRows
   if tRows is not a number then put 30 into tRows
   put pSet["size"] into tSize
   if tSize is not a number then put 12 into tSize
   if pSet["clear"] is "yes" then Term.ConsoleClear
   Term.ConsoleSetup x, y, w, tRows, tSize, pSet["color"]
end Clip.Start

on Clip.Step pT
   return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
end Clip.Stop
