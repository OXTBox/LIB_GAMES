#!/usr/bin/env bash
# engine_play.sh - play a Vibecode3D game card on the REAL engine (the engine library the
# Game_Player app uses), in LIB_MCP's test standalone (port 8767), and screenshot it.
#   tools/engine_play.sh <Game> <Prefix> "<keys>:<steps> ..." [snap.png]
#   e.g. tools/engine_play.sh WallBreaker Wall "32:2 65363:60 0:90" C:/LIB_MCP/wall.png
# Each key list (LiveCode key codes, comma separated; 0 = none) is held through
# <Prefix>.TestKeys for that many 33 ms steps of real time; <Prefix>.State() is printed after
# each. A step "!Handler:arg" dispatches that test handler instead (e.g. !Coast.TestLives:99).
# Run-time errors stop the game; they are printed from LIB_LLMIN/LIB_DEV/GAME_PLAYER_ERRORS.txt.
# Unlike headless_play.sh (engine stand-ins), this draws with the real engine: look at the snap.
GAME="$1"; PRE="$2"; PLAN="$3"; SNAP="${4:-}"
LCMCP="$(cd "$(dirname "$0")/../.." && pwd)/LIB_MCP/tools/lcmcp"
ERRS="$(cd "$(dirname "$0")/../.." && pwd)/LIB_LLMIN/LIB_DEV/GAME_PLAYER_ERRORS.txt"
for _ in 1 2 3 4 5 6 7 8 9 10; do "$LCMCP" --standalone ping >/dev/null 2>&1 && break; sleep 2; done
BEFORE=0; [[ -f "$ERRS" ]] && BEFORE=$(wc -l < "$ERRS")
{
cat <<LC
put "//wsl\$/Ubuntu/home/igame3d/projects" into tP
if not ("GameLaunch" is among the lines of the stacksInUse) then start using stack (tP & "/LIB_DEV/livecode/game_launch.livecodescript")
if there is a stack "Play $GAME" then close stack "Play $GAME"
put GL.Open(tP, "$GAME", false) into tWhy
if tWhy is not empty then return "OPEN FAILED: " & tWhy
put "Play $GAME" into tS
set the title of stack tS to "127.0.0.1:8767 | CLAUDE | engine_play $GAME"
wait 300 milliseconds with messages
dispatch "$PRE.TestKeys" to card 1 of stack tS with "0"
put "start: " & value("$PRE.State()", card 1 of stack tS) & cr into tLog
LC
for step in $PLAN; do
  K="${step%%:*}"; N="${step##*:}"
  if [[ "$K" == !* ]]; then   # !Handler:arg  dispatches a test handler, e.g. !Coast.TestLives:99
    echo "if there is a stack tS then dispatch \"${K#!}\" to card 1 of stack tS with \"$N\""
    continue
  fi
  cat <<LC
if there is a stack tS then
  dispatch "$PRE.TestKeys" to card 1 of stack tS with "$K"
  wait $N * 33 milliseconds with messages
  put "$K x$N: " & value("$PRE.State()", card 1 of stack tS) & cr after tLog
end if
LC
done
cat <<LC
if there is a stack tS then
  put "fps: " & field "PlayerStatus" of stack tS & cr after tLog
  if there is a field "PlayerMessage" of stack tS then put "message: " & field "PlayerMessage" of stack tS & cr after tLog
LC
[[ -n "$SNAP" ]] && echo "  export snapshot from card 1 of stack tS to file \"$SNAP\" as PNG"
cat <<LC
  close stack tS
end if
return tLog
LC
} | timeout 110 "$LCMCP" --standalone run - | sed 's/^result: //'
AFTER=0; [[ -f "$ERRS" ]] && AFTER=$(wc -l < "$ERRS")
if [[ "$AFTER" -gt "$BEFORE" ]]; then echo "ERRORS:"; tail -n $((AFTER - BEFORE)) "$ERRS" | tr '/' '\n' | head -12; fi
