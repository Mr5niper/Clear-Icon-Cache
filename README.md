# Clear Icon Cache

A batch script that clears the Windows icon and thumbnail cache and restarts Explorer. It remembers which folders you had open and reopens them when it's done, so you don't lose your place.

## What it does

1. Saves a list of the File Explorer folders you currently have open.
2. Kills explorer.exe.
3. Deletes the icon cache and thumbnail cache files.
4. Runs ie4uinit.exe to force a rebuild.
5. Starts Explorer back up and waits until it's actually running.
6. Reopens the folders that were open before.

No key press needed at the end. The window closes on its own.

## How to use it

Just double click `clear_icon_cache.bat`. You don't need to run it as admin.

That's it. Explorer will disappear for a few seconds while the cache clears, then everything comes back including your folders.

## Why the folders sometimes matter

The script grabs your open folders through the Shell.Application COM object and writes them to a temp file, then reopens them one at a time with a short pause between each. The pause is there because if you fire them off too fast, Windows drops some of them and shuffles the taskbar order. Two seconds per folder keeps them in order.

The temp file lives in `%temp%\open_explorer_folders.txt` and gets deleted at the end.

## Notes

- It clears the cache in two places: the old `iconcache.db` in `%localappdata%`, and the `iconcache_*.db` and `thumbcache_*.db` files in `%localappdata%\Microsoft\Windows\Explorer`. That covers Windows 10 and 11.
- Some cache files can be locked by other processes even after Explorer is killed, so once in a while one survives a run. The rebuild step handles that case anyway.
- If you're on a locked down work machine that blocks PowerShell in Constrained Language Mode, the folder capture step may come back empty. If that happens, the cache still clears fine, you just won't get the folders reopened. You'll see the captured list print on screen right after step 1, so it's easy to tell.

## Requirements

Windows 10 or 11. PowerShell needs to be allowed for the folder reopen feature to work, but the cache clearing works either way.
