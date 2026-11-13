script "Thrmnlra_Clip_RecallKey"
## CLIP RecallKey (Thrmnlra): a very long key to type to recall the missiles. Halfway
## through, the letters you have not typed yet change. Use hold=yes.
##   text     the order shown above the key (default TYPE THE KEY TO RECALL THE MISSILES)
##   key      what must be typed exactly (letters, digits, - and spaces)
##   mutate   0..1 of the key typed when the rest changes (default 0.5; 0 = never)
##   timeout  seconds before it gives up (default 0 = never: the missiles are the pressure,
##            and in clock mode "keys" they only move as you type)
##   var      the result, "recalled" or "failed", kept as a sequence variable
## Every wrong key tells the card:  Thrm.Typo count  (later: one more MIRV warhead)

local sKey, sPos, sMutated, sMutate, sErrors, sTimeout, sVar, sResult, sDoneAt, sNow
local sKeyId, sTypedId, sFlash

constant kKeyColor = "#FFB000", kBad = "#FF4040"

on Clip.Start pSet, pWhat
   local tText
   put toUpper(pSet["key"]) into sKey
   if sKey is empty then put "XQ7-HALT-PAX-9071-RECALL" into sKey
   put pSet["mutate"] into sMutate
   if sMutate is not a number then put 0.5 into sMutate
   put pSet["timeout"] into sTimeout
   if sTimeout is not a number then put 0 into sTimeout
   put pSet["var"] into sVar
   put pSet["text"] into tText
   if tText is empty then put "TYPE THE KEY TO RECALL THE MISSILES" into tText
   get Term.Print(tText, kBad)
   put Term.Print(sKey, kKeyColor) into sKeyId
   put Term.Print("> _", empty) into sTypedId
   Term.Sticky sTypedId
   put 0 into sPos
   put false into sMutated
   put 0 into sErrors
   put empty into sResult
   put 0 into sNow
   put 0 into sFlash
end Clip.Start

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      Term.Color sKeyId, kKeyColor
      put 0 into sFlash
   end if
   if sResult is empty then
      if sTimeout > 0 and pT >= sTimeout then Recall.Finish "failed"
      Term.Text sTypedId, "> " & char 1 to sPos of sKey & char 1 to (trunc(pT * 3) mod 2) of "_"
      exit Clip.Step
   end if
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   if sResult is not empty then return "taken"
   if the number of chars of pKey is not 1 then return "taken"
   if toUpper(pKey) is char sPos + 1 of sKey then
      add 1 to sPos
      if sPos >= the number of chars of sKey then
         Recall.Finish "recalled"
      else if not sMutated and sMutate > 0 and sPos >= sMutate * the number of chars of sKey then
         -- the key changes under your fingers
         put true into sMutated
         put char 1 to sPos of sKey & Thrm.Garble(char sPos + 1 to -1 of sKey, 0.7) into sKey
         Term.Text sKeyId, sKey
         Term.Color sKeyId, "#FFFFFF"
         put sNow + 0.25 into sFlash
      end if
   else
      add 1 to sErrors
      Term.Color sTypedId, kBad
      put sNow + 0.2 into sFlash
      dispatch "Thrm.Typo" to this card with sErrors
   end if
   return "taken"
end Clip.Key

on Recall.Finish pResult
   put pResult into sResult
   Term.Text sTypedId, "> " & char 1 to sPos of sKey
   if sVar is not empty then Seq.SetVar sVar, pResult
   if pResult is "recalled" then
      get Term.Print("RECALL ACCEPTED.", empty)
   else
      get Term.Print("RECALL WINDOW CLOSED.", kBad)
   end if
   put sNow + 1.2 into sDoneAt
end Recall.Finish

on Clip.Stop
   Term.Sticky empty
end Clip.Stop
