#!/usr/bin/env bash
# Start (or resume) Spark's manifest run of the iGame3D 2008 Data folder.
# Started by START_SPARK.bat (double-click in Windows) or: bash _manifest/tools/run_spark.sh
# Order: Scripts first (the code the glossary and procedures need), then everything else.
# Finished files are skipped, so stopping (close the window / Ctrl+C) and starting again is safe.
# Progress is also written to _manifest/spark/_run.log.

MAN="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(dirname "$MAN")"
LOG="$MAN/spark/_run.log"
LOCK="$MAN/spark/.running"
mkdir -p "$MAN/spark"
cd "$ROOT" || exit 1

if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK")" 2>/dev/null; then
    echo "Spark is already running (process $(cat "$LOCK")). Close its window to stop it."
    exit 0
fi
echo $$ > "$LOCK"
trap 'rm -f "$LOCK"' EXIT

# LM Studio does the thinking; this window only sends it questions. Its window can stay
# closed: lms (LM Studio's command-line tool) starts the server and loads Spark without it.
LMS="$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/.cache/lm-studio/bin/lms.exe"
MODEL=spark-x2.6-4b
lms() { (cd /mnt/c && timeout 300 "$LMS" "$@" 2>&1 | sed 's/\x1b\[[0-9;]*m//g'); }

echo "Checking LM Studio on port 1234..."
if ! curl.exe -s -m 8 http://127.0.0.1:1234/v1/models >/dev/null 2>&1; then
    if [ -x "$LMS" ]; then
        echo "Starting LM Studio's server in the background (no window needed)..."
        lms server start --port 1234 | tail -2
    fi
fi
# One slot (the runner asks one question at a time; 4 slots used ~9.5 GB of RAM instead of ~4),
# and unload after 10 idle minutes so closing this window gives the memory back.
if [ -x "$LMS" ]; then
    slots=$(lms ps | awk -v m="$MODEL" '$1==m {print $7}')
    if [ -n "$slots" ] && [ "$slots" != "1" ]; then
        echo "Reloading $MODEL with 1 slot to save memory..."
        lms unload "$MODEL" | tail -1
        slots=""
    fi
    if [ -z "$slots" ]; then
        echo "Loading $MODEL (about 3.5 GB, takes a moment)..."
        lms load "$MODEL" --identifier "$MODEL" --context-length 8192 --parallel 1 --ttl 600 --yes | tail -2
    fi
fi
if ! curl.exe -s -m 8 http://127.0.0.1:1234/v1/models | grep -q "\"$MODEL\""; then
    echo
    echo "LM Studio is not answering, or $MODEL is not in it."
    echo "Open LM Studio once, turn on its server (Developer tab, port 1234) and load $MODEL,"
    echo "then double-click START_SPARK.bat again. After that its window can be closed."
    exit 1
fi

before=$(find "$MAN/spark" -name '*.md' | wc -l)
echo "Spark has $before drafts so far. Starting at $(date '+%H:%M'). Close this window to stop."
echo "=== start $(date '+%Y-%m-%d %H:%M')  ($before drafts)" >> "$LOG"

for target in Scripts ALL; do
    if [ "$target" = ALL ]; then
        echo; echo "--- everything else (Levels, Fluid, Shaders, Emitters, WTF folders...)"
        python3 -u -I "$MAN/tools/spark_manifest.py" --pause "${SPARK_PAUSE:-20}" --work-minutes "${SPARK_WORK:-20}" --rest-minutes "${SPARK_REST:-15}" 2>&1 | tee -a "$LOG"
    else
        echo; echo "--- $target"
        python3 -u -I "$MAN/tools/spark_manifest.py" --folder "$target" --pause "${SPARK_PAUSE:-20}" --work-minutes "${SPARK_WORK:-20}" --rest-minutes "${SPARK_REST:-15}" 2>&1 | tee -a "$LOG"
    fi
    status=${PIPESTATUS[0]}
    if [ "$status" -ne 0 ]; then
        echo "Stopped (status $status). Double-click START_SPARK.bat to resume." | tee -a "$LOG"
        exit "$status"
    fi
done

after=$(find "$MAN/spark" -name '*.md' | wc -l)
echo "=== done $(date '+%Y-%m-%d %H:%M')  ($after drafts)" | tee -a "$LOG"
echo "Spark finished every folder. Drafts are in _manifest/spark/ for Claude to review."
