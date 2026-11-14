script "Seq_Clip_Type"
## CLIP Type: a line typed live on the console, like someone texting in a movie.
##   text     what is typed (the author spells it, mistakes included)
##   cps      characters a second (default 20)
##   typos    0..1: chance per letter of a slip that is backspaced and fixed (default 0)
##   linger   seconds to stay running after the last letter (default 0.3)
##   color    console colour if empty      cursor=no hides the block cursor

local sSteps, sCount, sCPS, sLinger, sIds, sColor, sCursor, sShown

on Clip.Start pSet, pWhat
   local tText, tCh, tWrong, n
   put pSet["text"] into tText
   put pSet["cps"] into sCPS
   if sCPS is not a number then put 20 into sCPS
   put pSet["linger"] into sLinger
   if sLinger is not a number then put 0.3 into sLinger
   put pSet["color"] into sColor
   put pSet["cursor"] is not "no" into sCursor
   -- the keystrokes: what the line shows after each one (a slip, its backspace, the fix)
   put 0 into sCount
   put empty into tWrong
   repeat for each char tCh in tText
      if pSet["typos"] is a number and tCh is in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" then
         if random(1000) <= pSet["typos"] * 1000 then
            add 1 to sCount
            put tWrong & char random(26) of "QWERTYUIOPASDFGHJKLZXCVBNM" into sSteps[sCount]
            add 1 to sCount
            put tWrong into sSteps[sCount]
         end if
      end if
      put tCh after tWrong
      add 1 to sCount
      put tWrong into sSteps[sCount]
   end repeat
   put empty into sIds
   put empty into sShown
end Clip.Start

on Clip.Step pT
   local n, tShown
   put min(sCount, trunc(pT * sCPS)) into n
   if n > 0 then put sSteps[n] into tShown
   if sCursor and n < sCount and trunc(pT * 4) mod 2 is 0 then put "_" after tShown
   Type.Show tShown
   if n >= sCount and pT >= sCount / sCPS + sLinger then
      Type.Show sSteps[sCount]
      return "done"
   end if
end Clip.Step

-- the shown text, wrapped over as many console lines as it needs
on Type.Show pText
   local tLines, k
   if pText is sShown then exit Type.Show
   put pText into sShown
   put Term.Wrap(pText, Term.Cols()) into tLines
   if tLines is empty then put space into tLines
   repeat with k = 1 to the number of lines of tLines
      if line k of sIds is empty then put Term.Print(empty, sColor) into line k of sIds
      Term.Text line k of sIds, line k of tLines
   end repeat
end Type.Show

on Clip.Key pKey
end Clip.Key

on Clip.Stop
   -- skipped: show the whole line
   if sCount > 0 then Type.Show sSteps[sCount]
end Clip.Stop
