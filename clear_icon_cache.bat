@echo off
TITLE Clear Icon Cache and Restart Explorer
COLOR 0A

echo ========================================================
echo Step 1: Stopping Windows Explorer...
echo ========================================================
taskkill /f /im explorer.exe
timeout /t 2 >nul

echo ========================================================
echo Step 2: Clearing Icon Cache Database Files...
echo ========================================================
cd /d %localappdata%
attrib -h iconcache_*.db
del /a /q iconcache_*.db

cd /d %localappdata%\Microsoft\Windows\Explorer
attrib -h iconcache_*.db
del /a /q iconcache_*.db
del /a /q thumbcache_*.db

echo ========================================================
echo Step 3: Restarting Windows Explorer...
echo ========================================================
start explorer.exe

echo ========================================================
echo Done! Icon cache has been cleared and Explorer restarted.
echo ========================================================
pause