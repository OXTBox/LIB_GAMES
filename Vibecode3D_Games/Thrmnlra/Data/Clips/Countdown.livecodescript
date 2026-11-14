script "Thrmnlra_Clip_Countdown"
## CLIP Countdown (Thrmnlra): "YOU HRVE 42153261 MINUTES." scrolling fast down the
## console, a tease upward first, then racing to zero, typos everywhere (Thrm.Garble).
##   from     the first number (default 42153261)     lines (default 18)
##   rate     lines a second (default 14)              tease  lines that go UP first (3)
##   garble   0..1 typo rate (default 0.2)             linger (default 0.6)
##   words    what is counted, picked at random, first one most often
##            (default MINUTES,MONKEYS,MUTANTS)
##   color    console colour if empty

local sLines, sCount, sRate, sLinger, sPrinted, sColor

on Clip.Start pSet, pWhat
   local tFrom, tTease, tGarble, tWords, k, v, u, tWord, tText
   put pSet["from"] into tFrom
   if tFrom is not a number then put 42153261 into tFrom
   put pSet["lines"] into sCount
   if sCount is not a number then put 18 into sCount
   put pSet["rate"] into sRate
   if sRate is not a number then put 14 into sRate
   put pSet["tease"] into tTease
   if tTease is not a number then put 3 into tTease
   put pSet["garble"] into tGarble
   if tGarble is not a number then put 0.2 into tGarble
   put pSet["linger"] into sLinger
   if sLinger is not a number then put 0.6 into sLinger
   put pSet["words"] into tWords
   if tWords is empty then put "MINUTES,MONKEYS,MUTANTS" into tWords
   put pSet["color"] into sColor
   repeat with k = 1 to sCount
      if k <= tTease then
         put tFrom + k * random(9) into v
      else
         put (k - tTease) / max(1, sCount - tTease) into u
         put round(tFrom * (1 - u) ^ 3) into v
      end if
      if random(100) <= 85 then
         put item 1 of tWords into tWord
      else
         put item random(the number of items of tWords) of tWords into tWord
      end if
      put "YOU HAVE" && v && tWord & "." into tText
      put (char 1 to (random(5) - 1) of "    ") & Thrm.Garble(tText, tGarble) into sLines[k]
   end repeat
   put 0 into sPrinted
end Clip.Start

on Clip.Step pT
   local n
   put min(sCount, trunc(pT * sRate) + 1) into n
   repeat while sPrinted < n
      add 1 to sPrinted
      get Term.Print(sLines[sPrinted], sColor)
   end repeat
   if sPrinted >= sCount and pT >= sCount / sRate + sLinger then return "done"
end Clip.Step

on Clip.Key pKey
end Clip.Key

on Clip.Stop
   repeat while sPrinted < sCount
      add 1 to sPrinted
      get Term.Print(sLines[sPrinted], sColor)
   end repeat
end Clip.Stop
