script "Thrmnlra_Clip_Order"
## CLIP Order (Thrmnlra): the Sarge shouts an order and you type it, letter for letter,
## spaces and ! too (STOP RECALL ALL MISSILES!, RECALL THE BOMBERS!, STAND DOWN THE
## COMMAND, LAUNCH). Every wrong key goes to the card, Thrm.Typo count, key: what it does
## depends on the phase (an enemy silo alerted, one of ours woken, a launch code letter
## filled in). Use hold=yes.
##   text      the order to type
##   say       printed before it (default TYPE:)      color   its colour (the Sarge's amber)
##   good      a line printed when it is typed right (optional)
##   yell      lines for a typo, commas between, one at random (optional)
##   call      a card handler called when it is typed right (Thrm.BombersHome)
##   sabotage  n: the keyboard itself spoils n of your RIGHT keys on purpose, never at the
##             same letter twice and never with the same wrong letter (TYPE LAUNCH, THAT IS
##             A DIRECT ORDER). Type the letter again and it takes.
##   sabcall   a card handler called for every spoiled key (Thrm.EnemyRound)
##   var       how many typos (yours and the keyboard's), kept as a sequence variable

local sText, sPos, sCall, sGood, sYell, sSab, sSabUsed, sSabCall, sWrongUsed, sWrong
local sVar, sErrors, sTypedId, sDoneAt, sNow, sFlash

constant kSarge = "#FFB000", kBad = "#FF4040", kOk = "#D0E8FF"

on Clip.Start pSet, pWhat
   local tSay, tColor, tLine
   put toUpper(pSet["text"]) into sText
   if sText is empty then put "STAND DOWN" into sText
   put pSet["say"] into tSay
   if tSay is empty then put "TYPE:" into tSay
   put pSet["color"] into tColor
   if tColor is empty then put kSarge into tColor
   put pSet["good"] into sGood
   put pSet["yell"] into sYell
   put pSet["call"] into sCall
   put pSet["sabcall"] into sSabCall
   put pSet["var"] into sVar
   put 0 into sPos
   put 0 into sErrors
   put empty into sDoneAt
   put 0 into sNow
   put 0 into sFlash
   put empty into sSabUsed
   put empty into sWrongUsed
   put empty into sWrong
   repeat for each line tLine in Term.Wrap(tSay && sText, Term.Cols())
      get Term.Print(tLine, tColor)
   end repeat
   put Order.PickSabotage(pSet["sabotage"]) into sSab
   put Term.Print("> _", empty) into sTypedId
   Term.Sticky sTypedId
end Clip.Start

-- n letter positions the keyboard will spoil: letters only, never the first one, never the
-- same letter twice
function Order.PickSabotage n
   local tOut, tChars, k
   if n is not a number or n < 1 then return empty
   repeat 300 times
      if the number of items of tOut >= n then exit repeat
      put random(the number of chars of sText) into k
      if k is 1 and the number of chars of sText > 2 then next repeat
      if char k of sText is not in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" then next repeat
      if k is among the items of tOut or char k of sText is among the items of tChars then next repeat
      if tOut is empty then
         put k into tOut
         put char k of sText into tChars
      else
         put comma & k after tOut
         put comma & char k of sText after tChars
      end if
   end repeat
   return tOut
end Order.PickSabotage

-- a wrong letter for a spoiled key: not the right one, not one used before
function Order.WrongFor pCh
   local tCh
   repeat 100 times
      put any char of "QWERTYUIOPASDFGHJKLZXCVBNM" into tCh
      if tCh is not pCh and tCh is not among the items of sWrongUsed then exit repeat
   end repeat
   put tCh & comma after sWrongUsed
   return tCh
end Order.WrongFor

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      put 0 into sFlash
      put empty into sWrong
   end if
   if sDoneAt is empty then
      if sWrong is empty then
         Term.Text sTypedId, "> " & char 1 to sPos of sText & char 1 to (trunc(pT * 3) mod 2) of "_"
      end if
      exit Clip.Step
   end if
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   local tWhat
   if sDoneAt is not empty then return "taken"
   if the number of chars of pKey is not 1 then return "taken"
   if toUpper(pKey) is char sPos + 1 of sText then
      if (sPos + 1) is among the items of sSab and (sPos + 1) is not among the items of sSabUsed then
         -- the keyboard spoils it, on purpose: a wrong letter shows, the enemy gets a round
         put (sPos + 1) & comma after sSabUsed
         put Order.WrongFor(char sPos + 1 of sText) into sWrong
         Term.Text sTypedId, "> " & char 1 to sPos of sText & sWrong
         Term.Color sTypedId, kBad
         put sNow + 0.6 into sFlash
         add 1 to sErrors
         if sSabCall is not empty then dispatch sSabCall to this card
         return "taken"
      end if
      add 1 to sPos
      if sPos >= the number of chars of sText then Order.Finish
      return "taken"
   end if
   -- the player's own typo: the world pays for it
   add 1 to sErrors
   Term.Color sTypedId, kBad
   put sNow + 0.25 into sFlash
   dispatch "Thrm.Typo" to this card with sErrors, pKey
   put the result into tWhat
   if sYell is not empty and tWhat is not "codes" then get Term.Print(any item of sYell, kBad)
   return "taken"
end Clip.Key

on Order.Finish
   Term.Text sTypedId, "> " & sText
   Term.Color sTypedId, kOk
   put 0 into sFlash
   if sVar is not empty then Seq.SetVar sVar, sErrors
   if sGood is not empty then get Term.Print(sGood, kSarge)
   if sCall is not empty then dispatch sCall to this card
   put sNow + 0.8 into sDoneAt
end Order.Finish

on Clip.Stop
   Term.Sticky empty
end Clip.Stop
