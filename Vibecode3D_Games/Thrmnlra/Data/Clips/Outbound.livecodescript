script "Thrmnlra_Clip_Outbound"
## CLIP Outbound (Thrmnlra): your first strike is in the air. Each missile has an asset
## name (M123, MZ98...) shown beside it on the map. Type a name:
##   before any of them crosses midway (the enemy still asleep): it is RECALLED, quietly;
##   after (the enemy knows): it DETONATES in the air and takes enemy missiles near it.
## A letter that fits no name is a typo (Thrm.Typo: alert, then launch). Use hold=yes.
## Ends when none of your missiles is left in the air.
##   peace     the sequence to jump to when every missile was recalled before the enemy
##             woke up (default: none, carry on)
##   var       how it went: "recalled" (peace) or "war"

local sTyped, sListId, sTypedId, sDoneAt, sNow, sFlash, sErrors, sPeace, sVar, sShown

constant kBad = "#FF4040", kList = "#D0E8FF"

on Clip.Start pSet, pWhat
   put pSet["peace"] into sPeace
   put pSet["var"] into sVar
   put empty into sTyped
   put empty into sDoneAt
   put 0 into sNow
   put 0 into sFlash
   put 0 into sErrors
   put empty into sShown
   -- the list is a fixed line under the console (top of the map), so messages never scroll it away
   put "outbound.list" into sListId
   Term.Set sListId, "MISSILES OUTBOUND:", Term.X(0.05), Term.Y(0.30), 12, kList
   get Term.Print("TYPE AN ASSET NAME TO RECALL OR DETONATE", kBad)
   put Term.Print("> _", empty) into sTypedId
   Term.Sticky sTypedId
   Outbound.List
end Clip.Start

-- "MISSILES OUTBOUND: M123  M345  MZ98", kept up to date
on Outbound.List
   local tNames, tLine
   put Thrm.Outbound() into tNames
   if tNames is sShown then exit Outbound.List
   put tNames into sShown
   put tNames into tLine
   replace comma with "  " in tLine
   if tLine is empty then put "(NONE)" into tLine
   Term.Text sListId, "MISSILES OUTBOUND:" && tLine
end Outbound.List

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      put 0 into sFlash
   end if
   Outbound.List
   if sDoneAt is empty then
      Term.Text sTypedId, "> " & sTyped & char 1 to (trunc(pT * 3) mod 2) of "_"
      if sShown is empty then Outbound.Finish
      exit Clip.Step
   end if
   if pT >= sDoneAt then
      if Thrm.EnemyAlerted() is false and sPeace is not empty then Seq.Jump sPeace
      return "done"
   end if
end Clip.Step

on Outbound.Finish
   if Thrm.EnemyAlerted() is false then
      if sVar is not empty then Seq.SetVar sVar, "recalled"
      get Term.Print("ALL ASSETS RECALLED. THE ENEMY NEVER WOKE UP.", kList)
   else
      if sVar is not empty then Seq.SetVar sVar, "war"
   end if
   put sNow + 1.5 into sDoneAt
end Outbound.Finish

on Clip.Key pKey
   local tTry, tName, tFits, tWhat
   if sDoneAt is not empty then return "taken"
   if pKey is "backspace" then
      delete char -1 of sTyped
      return "taken"
   end if
   if pKey is "return" then
      put empty into sTyped
      return "taken"
   end if
   if the number of chars of pKey is not 1 or pKey is space then return "taken"
   put sTyped & toUpper(pKey) into tTry
   put false into tFits
   repeat for each item tName in Thrm.Outbound()
      if char 1 to the number of chars of tTry of tName is tTry then
         put true into tFits
         if tName is tTry then
            dispatch "Thrm.Detonate" to this card with tName
            put empty into sTyped
            return "taken"
         end if
      end if
   end repeat
   if tFits then
      put tTry into sTyped
   else
      add 1 to sErrors
      Term.Color sTypedId, kBad
      put sNow + 0.25 into sFlash
      dispatch "Thrm.Typo" to this card with sErrors
   end if
   return "taken"
end Clip.Key

on Clip.Stop
   Term.Sticky empty
   Term.Remove sListId
end Clip.Stop
