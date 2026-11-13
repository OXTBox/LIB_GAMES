script "Thrmnlra_Clip_Targets"
## CLIP Targets (Thrmnlra): "SYSTEM ONLINE. CHOOSE YOUR TARGETS". A two-column list like
## an arcade high-score table, bait names you want to type. Type a whole name: it is
## chosen (no Return needed) and one of your batteries lights up (the card's Thrm.Target).
## A letter that starts no name on the list is a typo: the enemy fires (Thrm.Typo).
## Use hold=yes.
##   names   the list, commas between (default the owner's bait names)
##   pick    how many targets to choose (default 3)
##   var     the chosen names, kept as a sequence variable (commas between)

local sNames, sPick, sVar, sChosen, sTyped, sRowIds, sTypedId, sDoneAt, sNow, sFlash, sErrors

constant kChosenColor = "#FFB000", kBad = "#FF4040"

on Clip.Start pSet, pWhat
   local tHalf, k, tLine, tName
   put toUpper(pSet["names"]) into sNames
   if sNames is empty then put "BITMON,HELIX,DELTA9ER,FOXTROZERO,8O08S,SQUAREPANTS,LUKE,FRE3PISZA" into sNames
   put pSet["pick"] into sPick
   if sPick is not a number then put 3 into sPick
   put pSet["var"] into sVar
   dispatch "Thrm.ShowTargets" to this card with sNames     -- their names on the map too
   get Term.Print("CHOOSE" && sPick && "TARGETS: TYPE A NAME", kBad)
   -- two columns, like the high-score table of an arcade cabinet
   put (the number of items of sNames + 1) div 2 into tHalf
   put empty into sRowIds
   repeat with k = 1 to tHalf
      put Targets.Row(k, tHalf) into tLine
      put Term.Print(tLine, empty) & cr after sRowIds
   end repeat
   put Term.Print("> _", empty) into sTypedId
   put empty into sChosen
   put empty into sTyped
   put empty into sDoneAt
   put 0 into sNow
   put 0 into sFlash
   put 0 into sErrors
end Clip.Start

-- one row of the table: name k and name k + half, chosen ones marked with *
function Targets.Row k, pHalf
   local tLeft, tRight
   put Targets.Cell(k) into tLeft
   if k + pHalf <= the number of items of sNames then put Targets.Cell(k + pHalf) into tRight
   return tLeft & char 1 to max(1, 20 - the number of chars of tLeft) of "                    " & tRight
end Targets.Row

function Targets.Cell n
   local tName
   put item n of sNames into tName
   -- no numbers: they would look like menu keys; you type the name
   if tName is among the items of sChosen then return "*" & tName
   return space & tName
end Targets.Cell

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      put 0 into sFlash
   end if
   if sDoneAt is empty then
      Term.Text sTypedId, "> " & sTyped & char 1 to (trunc(pT * 3) mod 2) of "_"
      exit Clip.Step
   end if
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   local tTry, tName, tFits
   if sDoneAt is not empty then return "taken"
   if pKey is "backspace" then
      delete char -1 of sTyped
      return "taken"
   end if
   if the number of chars of pKey is not 1 or pKey is space then return "taken"
   put sTyped & toUpper(pKey) into tTry
   put false into tFits
   repeat for each item tName in sNames
      if tName is among the items of sChosen then next repeat
      if char 1 to the number of chars of tTry of tName is tTry then
         put true into tFits
         if tName is tTry then
            Targets.Choose tName
            return "taken"
         end if
      end if
   end repeat
   if tFits then
      put tTry into sTyped
   else
      -- a typo: the enemy (or an ally, for no good reason) fires
      add 1 to sErrors
      Term.Color sTypedId, kBad
      put sNow + 0.2 into sFlash
      dispatch "Thrm.Typo" to this card with sErrors
   end if
   return "taken"
end Clip.Key

on Targets.Choose pName
   local tHalf, k
   if sChosen is empty then
      put pName into sChosen
   else
      put comma & pName after sChosen
   end if
   put empty into sTyped
   put (the number of items of sNames + 1) div 2 into tHalf
   repeat with k = 1 to tHalf
      Term.Text line k of sRowIds, Targets.Row(k, tHalf)
   end repeat
   dispatch "Thrm.Target" to this card with pName, the number of items of sChosen
   if the number of items of sChosen >= sPick then
      if sVar is not empty then Seq.SetVar sVar, sChosen
      Term.Text sTypedId, "> TARGETS LOCKED:" && sChosen
      Term.Color sTypedId, kChosenColor
      put sNow + 1.2 into sDoneAt
   end if
end Targets.Choose

on Clip.Stop
end Clip.Stop
