script "Thrmnlra_Clip_Assets"
## CLIP Assets (Thrmnlra): type the name of an asset on the map (short plain words: OWL,
## FOX... SUN, MUD...). No Return needed: a whole name typed is done. Use hold=yes.
##   mode=recall    your missiles waiting on the pads over your silos (Thrm.Assets "pad"):
##                  a name typed sinks that missile back (Thrm.Recall)
##   mode=destroy   their missiles in the air, flying right to left (Thrm.Assets "red"):
##                  a name typed bursts it (Thrm.Destroy). [TAB] cycles the focus (Thrm.Focus):
##                  that name turns bold and bright, and the card moves the clock twice
## A letter that starts no name is a typo (Thrm.Typo count, key). The clip ends when no
## name is left (recalled, destroyed, or landed).
##   var     how many typos, kept as a sequence variable

local sMode, sTyped, sTypedId, sDoneAt, sNow, sFlash, sErrors, sVar

constant kBad = "#FF4040", kOk = "#D0E8FF"

on Clip.Start pSet, pWhat
   put pSet["mode"] into sMode
   if sMode is not "destroy" then put "recall" into sMode
   put pSet["var"] into sVar
   put empty into sTyped
   put empty into sDoneAt
   put 0 into sNow
   put 0 into sFlash
   put 0 into sErrors
   put Term.Print("> _", empty) into sTypedId
   Term.Sticky sTypedId
end Clip.Start

function Assets.Names
   if sMode is "destroy" then return Thrm.Assets("red")
   return Thrm.Assets("pad")
end Assets.Names

on Clip.Step pT
   put pT into sNow
   if sFlash > 0 and pT >= sFlash then
      Term.Color sTypedId, empty
      put 0 into sFlash
   end if
   if sDoneAt is empty then
      Term.Text sTypedId, "> " & sTyped & char 1 to (trunc(pT * 3) mod 2) of "_"
      if pT >= 0.3 and Assets.Names() is empty then
         if sVar is not empty then Seq.SetVar sVar, sErrors
         if sMode is "recall" then
            get Term.Print("ALL MISSILES BACK IN THEIR SILOS.", kOk)
         else
            get Term.Print("NOTHING LEFT IN THE AIR.", kOk)
         end if
         put pT + 1 into sDoneAt
      end if
      exit Clip.Step
   end if
   if pT >= sDoneAt then return "done"
end Clip.Step

on Clip.Key pKey
   local tTry, tName, tFits
   if sDoneAt is not empty then return "taken"
   if pKey is "tab" then
      if sMode is "destroy" then dispatch "Thrm.Focus" to this card
      return "taken"
   end if
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
   repeat for each item tName in Assets.Names()
      if char 1 to the number of chars of tTry of tName is tTry then
         put true into tFits
         if tName is tTry then
            if sMode is "destroy" then
               dispatch "Thrm.Destroy" to this card with tName
            else
               dispatch "Thrm.Recall" to this card with tName
            end if
            put empty into sTyped
            return "taken"
         end if
      end if
   end repeat
   if tFits then
      put tTry into sTyped
   else
      add 1 to sErrors
      put empty into sTyped
      Term.Color sTypedId, kBad
      put sNow + 0.25 into sFlash
      dispatch "Thrm.Typo" to this card with sErrors, pKey
   end if
   return "taken"
end Clip.Key

on Clip.Stop
   Term.Sticky empty
end Clip.Stop
