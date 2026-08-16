@echo off
TITLE Clear Icon Cache and Restart Explorer
COLOR 0A
setlocal

set "SAVEFILE=%temp%\open_explorer_folders.txt"

echo ========================================================
echo Step 1: Saving list of open Explorer folders...
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$paths = @(); (New-Object -ComObject Shell.Application).Windows() | ForEach-Object { try { if ($_.Document -and $_.Document.Folder -and $_.Document.Folder.Self) { $p = $_.Document.Folder.Self.Path; if ($p) { $paths += $p } } } catch {} }; if ($paths.Count -gt 0) { $paths | Out-File -FilePath '%SAVEFILE%' -Encoding Default }"

echo Captured folders:
if exist "%SAVEFILE%" type "%SAVEFILE%"

echo ========================================================
echo Step 2: Stopping Windows Explorer...
echo ========================================================
taskkill /f /im explorer.exe
timeout /t 2 >nul

echo ========================================================
echo Step 3: Clearing Icon and Thumbnail Cache Files...
echo ========================================================
cd /d "%localappdata%"
if exist iconcache*.db (
  attrib -h iconcache*.db
  del /a /f /q iconcache*.db
  echo AppData\Local icon cache removed.
) else (
  echo No icon cache files in AppData\Local ^(may already be clear^).
)

cd /d "%localappdata%\Microsoft\Windows\Explorer"
if exist iconcache_*.db (
  attrib -h iconcache_*.db
  del /a /f /q iconcache_*.db
  echo Icon cache files removed.
) else (
  echo No icon cache files found ^(may already be clear^).
)
if exist thumbcache_*.db (
  attrib -h thumbcache_*.db
  del /a /f /q thumbcache_*.db
  echo Thumbnail cache files removed.
) else (
  echo No thumbnail cache files found ^(may already be clear^).
)

echo Forcing icon cache rebuild...
ie4uinit.exe -show

echo ========================================================
echo Step 4: Restarting Windows Explorer...
echo ========================================================
start explorer.exe

echo Waiting for Explorer to finish starting...
set /a TRIES=0
:WAIT_EXPLORER
timeout /t 1 >nul
set /a TRIES+=1
tasklist /fi "imagename eq explorer.exe" | find /i "explorer.exe" >nul
if not errorlevel 1 goto EXPLORER_READY
if %TRIES% geq 15 (
  echo Explorer did not report ready after 15 seconds, continuing anyway.
  goto EXPLORER_READY
)
goto WAIT_EXPLORER

:EXPLORER_READY
echo Explorer is running. Giving the shell a moment to initialize...
timeout /t 3 >nul

echo ========================================================
echo Step 5: Reopening previously open folders...
echo ========================================================
if exist "%SAVEFILE%" (
  for /f "usebackq tokens=* delims=" %%F in ("%SAVEFILE%") do (
    if exist "%%F\" (
      start "" explorer.exe "%%F"
      timeout /t 2 >nul
    )
  )
  del /q "%SAVEFILE%"
)

echo ========================================================
echo Done! Icon cache cleared and folders restored.
echo ========================================================