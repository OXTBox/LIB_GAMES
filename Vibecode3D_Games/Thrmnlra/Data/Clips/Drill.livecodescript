script "Thrmnlra_Clip_Drill"
## CLIP Drill (Thrmnlra, the trainer): the sergeant calls out words, you type each one.
## Every typo is passed to the card (Thrm.Typo) and has its real consequence on the map:
## the first wakes an enemy site (ALERT), the next launches from it. The sergeant yells
## about what you just did. Use hold=yes.
##   words      the words to type, in order, commas between (default GO,HOLD,FIRE)
##   say        what the sergeant says before each word (default TYPE:)
##   trap=yes   SIMON SAYS: the last word is a trap. He calls it like the others, but gave
##              no direct order, so you must NOT type it. Hold off for trapwait seconds
##              (default 6) and you pass (trappass); type it whole and it really happens:
##              one of your missiles launches and the enemy is alerted (trapfail).
##   trappass / trapfail   the sergeant's lines (commas between; one at random)
##   alertyell  lines yelled after a typo that alerted a site (commas between; one at random)
##   launchyell lines yelled after a typo that launched a missile
##   good       lines for a word typed right (default GOOD.)
##   var        how many typos, kept as a sequence variable
##   trapfire=no   typing the trap word only gets yelled at (trapfail): the sequence shows
##              what happens next (Thrmnlra's Map: the missiles rise to the pads)
##   prelaunched   not empty (e.g. {launched}): the player typed the trap word before the
##              drill (the Trainer's Hotword): straight to trapfail, no drill
##   trapvar    a sequence variable set to "typed" or "held" (how the trap went)

local sTrap, sTrapWait, sTrapPass, sTrapFail, sTrapAt, sWords, sN, sPos, sSay, sAlertYell, sLaunchYell, sGood, sVar
local sTypedId, sErrors, sDoneAt, sNow, sFlash, sWord, sTrapFire, sTrapVar

constant kSarge = "#FFB000", kBad = "#FF4040"

on Clip.Start pSet, pWhat
   put toUpper(pSet["words"]) into sWords
   if sWords is empty then put "GO,HOLD,FIRE" into sWords
   put pSet["say"] into sSay
   if sSay is empty then put "TYPE:" into sSay
   put pSet["trap"] is "yes" into sTrap
   put pSet["trapwait"] into sTrapWait
   if sTrapWait is not a number then put 6 into sTrapWait
   put pSet["trappass"] into sTrapPass
   if sTrapPass is empty then put "GOOD. NO ORDER, NO LAUNCH." into sTrapPass
   put pSet["trapfail"] into sTrapFail
   if sTrapFail is empty then put "DID I GIVE YOU A DIRECT ORDER?! NO I DID NOT!" into sTrapFail
   put empty into sTrapAt
   put pSet["alertyell"] into sAlertYell
   if sAlertYell is empty then put "YOU SEE THAT? YOU JUST WOKE THEM UP!" into sAlertYell
   put pSet["launchyell"] into sLaunchYell
   if sLaunchYell is empty then put "AND THAT IS A LAUNCH. CONGRATULATIONS." into sLaunchYell
   put pSet["good"] into sGood
   if sGood is empty then put "GOOD." into sGood
   put pSet["var"] into sVar
   put 0 into sN
   put 0 into sErrors
   put empty into sDoneAt
   put 0 into sNow
   put 0 into sFlash
   put pSet["trapfire"] is not "no" into sTrapFire
   put pSet["trapvar"] into sTrapVar
   if pSet["prelaunched"] is not empty and sTrap then
      -- the trap word was typed already, before the drill: no drill, straight to the yelling
      put the number of items of sWords into sN
      add 1 to sErrors
      if sTrapVar is not empty then Seq.SetVar sTrapVar, "typed"
      get Term.Print(any item of sTrapFail, kBad)
      dispatch "Thrm.CloseUp" to this card with 2.5
   end if
   Drill.Next
end Clip.Start

-- the sergeant calls the next word
on Drill.Next
   add 1 to sN
   if sN > the number of items of sWords then
      if sVar is not empty then Seq.SetVar sVar, sErrors
      put sNow + 1 into sDoneAt
      exit Drill.Next
   end if
   put item sN of sWords into sWord
   put 0 into sPos
   get Term.Print(sSay && sWord, kSarge)
   -- the trap is called exactly like the others: only the missing order gives it away
   if sTrap and sN is the number of items of sWords then put sNow + sTrapWait into sTrapAt
   put Term.Print("> _", empty) into sTypedId
   Term.Sticky sTypedId
end Drill.Next

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      put 0 into sFlash
   end if
   if sDoneAt is empty then
      Term.Text sTypedId, "> " & char 1 to sPos of sWord & char 1 to (trunc(pT * 3) mod 2) of "_"
      if sTrapAt is not empty and pT >= sTrapAt then
         -- held off: Simon did not say
         put empty into sTrapAt
         if sTrapVar is not empty then Seq.SetVar sTrapVar, "held"
         get Term.Print(any item of sTrapPass, kSarge)
         Drill.Next
      end if
      exit Clip.Step
   end if
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   local tWhat
   if sDoneAt is not empty then return "taken"
   if the number of chars of pKey is not 1 or pKey is space then return "taken"
   if sTrapAt is not empty then
      -- the trap word: letters of it lead you on; typing it whole makes it happen
      if toUpper(pKey) is char sPos + 1 of sWord then
         add 1 to sPos
         if sPos >= the number of chars of sWord then
            put empty into sTrapAt
            Term.Text sTypedId, "> " & sWord
            add 1 to sErrors
            if sTrapVar is not empty then Seq.SetVar sTrapVar, "typed"
            if sTrapFire then
               dispatch "Thrm.Fire" to this card with "blue", 0     -- it really launches
               dispatch "Thrm.Typo" to this card with 1             -- and they notice
            end if
            get Term.Print(any item of sTrapFail, kBad)
            dispatch "Thrm.CloseUp" to this card with 2.5
            Drill.Next
         end if
      end if
      return "taken"
   end if
   if toUpper(pKey) is char sPos + 1 of sWord then
      add 1 to sPos
      if sPos >= the number of chars of sWord then
         Term.Text sTypedId, "> " & sWord
         get Term.Print(any item of sGood, kSarge)
         Drill.Next
      end if
      return "taken"
   end if
   -- a typo: the world pays for it, and the sergeant tells you so
   add 1 to sErrors
   Term.Color sTypedId, kBad
   put sNow + 0.25 into sFlash
   dispatch "Thrm.Typo" to this card with sErrors, pKey
   put the result into tWhat
   if tWhat is "launch" then
      get Term.Print(any item of sLaunchYell, kBad)
   else if tWhat is "codes" then
      -- the launch codes just filled up: the card takes over (the Strike sequence)
   else
      get Term.Print(any item of sAlertYell, kBad)
   end if
   dispatch "Thrm.CloseUp" to this card with 1.8     -- cut to his face while he yells
   return "taken"
end Clip.Key

on Clip.Stop
   Term.Sticky empty
end Clip.Stop
