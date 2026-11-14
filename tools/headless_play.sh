#!/usr/bin/env bash
# headless_play.sh - run a Vibecode3D game card's rules with no window and no drawing.
#   tools/headless_play.sh <Game> <Prefix> "<keys>:<steps> <keys>:<steps> ..."
#   e.g. tools/headless_play.sh WallBreaker Wall "32:2 65363:60 0:300"
# Loads Vibecode3D_Games/Vibecode3D_Play_<Game>.livecodescript onto a card of a hidden stack
# whose stack script is tools/engine_stubs.livecodescript (stand-ins for the engine calls),
# starts the game, then holds each key list (LiveCode key codes, comma separated; 0 = none)
# for that many 33 ms steps through <Prefix>.TestKeys, printing <Prefix>.State() after each.
# Uses LIB_MCP's own standalone (port 8767), so it needs no Vibecode3D running.
# It checks rules and catches run-time errors; it does not show what the game looks like.
HERE="$(cd "$(dirname "$0")" && pwd)"
GAME="$1"; PRE="$2"; PLAN="$3"
W="//wsl\$/Ubuntu$HERE"
{
cat <<LC
if there is a stack "HeadlessPlay" then delete stack "HeadlessPlay"
create invisible stack "HeadlessPlay"
put URL "file:$W/engine_stubs.livecodescript" into tStub
delete line 1 of tStub
set the script of stack "HeadlessPlay" to tStub
set the script of card 1 of stack "HeadlessPlay" to URL "file:$W/../Vibecode3D_Games/Vibecode3D_Play_$GAME.livecodescript"
put the result into tCompile
dispatch "$PRE.TestKeys" to card 1 of stack "HeadlessPlay" with "0"
dispatch "Game.OnStart" to card 1 of stack "HeadlessPlay"
dispatch function "$PRE.State" to card 1 of stack "HeadlessPlay"
put "start: " & the result & cr into tLog
put 0 into tWorst
put the milliseconds into tT0
put 0 into tSteps
LC
for part in $PLAN; do
  keys="${part%%:*}"; steps="${part##*:}"
  cat <<LC
dispatch "$PRE.TestKeys" to card 1 of stack "HeadlessPlay" with "$keys"
repeat $steps times
put the milliseconds into tT1
dispatch "Game.OnUpdate" to card 1 of stack "HeadlessPlay"
put max(tWorst, the milliseconds - tT1) into tWorst
add 1 to tSteps
end repeat
dispatch function "$PRE.State" to card 1 of stack "HeadlessPlay"
put "$keys x$steps: " & the result & cr after tLog
LC
done
cat <<LC
dispatch function "Stub.HUD" to stack "HeadlessPlay"
return "compile: " & tCompile & cr & tLog & "avg ms a step " & round((the milliseconds - tT0) / max(1, tSteps), 2) & ", worst " & tWorst & cr & the result
LC
} | "$HERE/../../LIB_MCP/tools/lcmcp" --standalone run -
