@echo off
title Spark - iGame3D 2008 analysis (close this window to stop)
rem Double-click to start or resume Spark on the iGame3D 2008 Data folder.
rem Needs LM Studio running with spark-x2.6-4b loaded (server on port 1234).
rem Close this window to stop; the next double-click carries on where it left off.
cd /d %USERPROFILE%
wsl.exe -d Ubuntu -- bash /home/igame3d/projects/LIB_GAMES/igame3D_2008_Texts/_manifest/tools/run_spark.sh
echo.
pause
