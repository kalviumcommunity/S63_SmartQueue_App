@echo off
REM Fix "Can't find service: activity/package" - Cold boot emulator after ADB reset
echo Restarting ADB...
"C:\Users\Dell\AppData\Local\Android\sdk\platform-tools\adb.exe" kill-server
timeout /t 2 /nobreak >nul
"C:\Users\Dell\AppData\Local\Android\sdk\platform-tools\adb.exe" start-server
timeout /t 2 /nobreak >nul

echo.
echo Closing any running emulator...
"C:\Users\Dell\AppData\Local\Android\sdk\platform-tools\adb.exe" emu kill 2>nul
timeout /t 3 /nobreak >nul

echo.
echo Starting emulator with COLD BOOT (this may take 1-2 minutes)...
echo Wait until you see the Android home screen, then run: flutter run
echo.
start "" "C:\Users\Dell\AppData\Local\Android\sdk\emulator\emulator.exe" -avd Medium_Phone_API_36.1 -no-snapshot-load

echo.
echo Emulator is starting. Wait for it to fully boot, then run: flutter run
pause
