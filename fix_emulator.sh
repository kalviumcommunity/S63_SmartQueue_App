#!/bin/bash
# Fix emulator / start Android emulator so it appears in "flutter run"
# Run with: bash fix_emulator.sh   or   ./fix_emulator.sh

SDK="/c/Users/Dell/AppData/Local/Android/sdk"

echo "Restarting ADB..."
"$SDK/platform-tools/adb.exe" kill-server
sleep 2
"$SDK/platform-tools/adb.exe" start-server
sleep 2

echo ""
echo "Closing any running emulator..."
"$SDK/platform-tools/adb.exe" emu kill 2>/dev/null
sleep 3

echo ""
echo "Starting emulator (wait 1-2 min for boot)..."
"$SDK/emulator/emulator.exe" -avd Medium_Phone_API_36.1 -no-snapshot-load &
EMU_PID=$!
echo "Emulator PID: $EMU_PID"
echo ""
echo "Wait until you see the Android home screen, then run: flutter run"
