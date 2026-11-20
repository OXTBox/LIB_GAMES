script "PGStamina"
######################################################################################
## STAMINA of the PROMPT & GLAZE heroes  (Opus 19 Nov 2026)
## Stamina belongs to the CHARACTER, not to a game: every PROMPT & GLAZE game reads and
## writes the same numbers, so what PROMPT spends in Vector Toss he still lacks in the next
## game. 0..100 each; a hero never seen before starts at 100. Tenths are kept (a throw
## costs -1.0 to -2.0 in tenths).
## WHERE  one plain text file, a line a hero: NAME <tab> stamina
##          <Data folder>/Games/PROMPT_GLAZE/stamina.txt   (Documents/Data by default)
##        through LIB_DATA's Data.Path when the game has LIB_DATA in use; without it the
##        same place under Documents/Data. Stamina.UseFile picks another file (tests).
## USE    start using stack ".../PromptGlaze/stamina.livecodescript"   (the game finds it
##        with Game.FindFile; start LIB_DATA first so the Data folder is used)
##          put Stamina.Get("PROMPT") into tS          -- 0..100
##          Stamina.Set "GLAZE", 80                    -- kept in 0..100, saved at once
##          put Stamina.Add("PROMPT", -1.5) into tS    -- add (or take), returns the new value
######################################################################################

constant kMax = 100
constant kFolder = "PROMPT_GLAZE"
constant kName = "stamina.txt"

local sFile          -- the stamina file in use (empty: found on first use)
local sStamina       -- [NAME] stamina, as loaded
local sLoaded        -- true once the file was read
local sError         -- why the last save failed, or empty

-- a hero's stamina, 0..100 (100 for a hero never seen)
function Stamina.Get pChar
   pgStaminaLoad
   put toUpper(pChar) into pChar
   if sStamina[pChar] is not a number then return kMax
   return sStamina[pChar]
end Stamina.Get

-- set a hero's stamina (kept in 0..100, tenths) and save it
command Stamina.Set pChar, pValue
   pgStaminaLoad
   if pValue is not a number then exit Stamina.Set
   put toUpper(pChar) into pChar
   put max(0, min(kMax, round(pValue, 1))) into sStamina[pChar]
   pgStaminaSave
end Stamina.Set

-- add pDelta (minus takes) to a hero's stamina; returns the new value
function Stamina.Add pChar, pDelta
   if pDelta is not a number then return Stamina.Get(pChar)
   Stamina.Set pChar, Stamina.Get(pChar) + pDelta
   return Stamina.Get(pChar)
end Stamina.Add

function Stamina.Max
   return kMax
end Stamina.Max

-- the file in use
function Stamina.File
   if sFile is empty then put pgStaminaFindFile() into sFile
   return sFile
end Stamina.File

-- use this file from now on (tests: a throw-away file); empty: the Data folder again
command Stamina.UseFile pPath
   put pPath into sFile
   put false into sLoaded
   put empty into sStamina
end Stamina.UseFile

-- why the last save failed (empty: it worked)
function Stamina.Error
   return sError
end Stamina.Error

-------------------------------------------------------------------- inside

private function pgStaminaFindFile
   local tPath, tDocs
   if "LIB_DATA" is among the lines of the stacksInUse then
      try
         put Data.Path("Games", kFolder & "/" & kName) into tPath
      catch tErr
         put empty into tPath
      end try
      if tPath is not empty then return tPath
   end if
   put specialFolderPath("documents") into tDocs
   if tDocs is empty then return empty
   if there is not a folder (tDocs & "/Data") then create folder (tDocs & "/Data")
   if there is not a folder (tDocs & "/Data/Games") then create folder (tDocs & "/Data/Games")
   if there is not a folder (tDocs & "/Data/Games/" & kFolder) then create folder (tDocs & "/Data/Games/" & kFolder)
   return tDocs & "/Data/Games/" & kFolder & "/" & kName
end pgStaminaFindFile

private command pgStaminaLoad
   local tFile, tText, tLine
   if sLoaded is true then exit pgStaminaLoad
   put true into sLoaded
   put empty into sStamina
   put Stamina.File() into tFile
   if tFile is empty or there is not a file tFile then exit pgStaminaLoad
   put textDecode(url ("binfile:" & tFile), "UTF-8") into tText
   set the itemDelimiter to tab
   repeat for each line tLine in tText
      if char 1 of tLine is "#" or item 2 of tLine is not a number then next repeat
      put max(0, min(kMax, item 2 of tLine)) into sStamina[toUpper(item 1 of tLine)]
   end repeat
end pgStaminaLoad

private command pgStaminaSave
   local tFile, tText, tChar, tKeys
   put empty into sError
   put Stamina.File() into tFile
   if tFile is empty then
      put "no Data folder to save in" into sError
      exit pgStaminaSave
   end if
   put "# PROMPT & GLAZE stamina (0..100), a line a hero: NAME <tab> stamina" into tText
   put the keys of sStamina into tKeys
   sort lines of tKeys
   repeat for each line tChar in tKeys
      put return & tChar & tab & sStamina[tChar] after tText
   end repeat
   put textEncode(tText & return, "UTF-8") into url ("binfile:" & tFile)
   if the result is not empty then put the result into sError
end pgStaminaSave
