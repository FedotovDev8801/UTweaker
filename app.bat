@echo off
title UTweaker
color 0A

set "powershell_path=%SystemDrive%\Program Files\PowerShell\7\pwsh.exe"
powershell -Command "If (-Not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {Start-Process '%powershell_path%' '-ExecutionPolicy Bypass -NoProfile -File \"%~f0\"' -Verb RunAs; exit}"

:menu
cls
echo ========================================
echo         Welcome to UTweaker
echo ========================================
echo WARNING: FedotovDev takes no responsibility
echo for any damage to your PC or OS.
echo Use at your own risk.
echo ========================================
echo Choose an action:
echo 1. Speed up application shutdown
echo 2. Disable system restore
echo 3. Change pagefile size
echo 4. Show hidden files and folders
echo 5. Run PowerShell script for system info (Admin)
echo 6. Show File Tree of HDD (Admin)
echo 7. Clear All Cache
echo 8. Rename Operating System
echo 9. Optimize network settings for speed
echo 10. Exit
echo ========================================
set /p choice=Enter the number of your choice: 

if %choice%==1 goto speedup_apps
if %choice%==2 goto disable_restore
if %choice%==3 goto change_pagefile
if %choice%==4 goto show_hidden
if %choice%==5 goto run_powershell_admin
if %choice%==6 goto show_file_tree
if %choice%==7 goto clear_cache
if %choice%==8 goto rename_os
if %choice%==9 goto optimize_network
if %choice%==10 goto exit
goto error

:speedup_apps
cls
echo Speeding up application shutdown...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 1000 /f >nul 2>&1 || goto error
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f >nul 2>&1 || goto error
echo Applications will shut down faster.
pause
goto menu

:disable_restore
cls
echo Disabling system restore...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f >nul 2>&1 || goto error
echo System restore has been disabled.
pause
goto menu

:change_pagefile
cls
echo Changing pagefile size...
set /p size=Enter the new pagefile size in megabytes: 
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1 || goto error
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%size%,MaximumSize=%size% >nul 2>&1 || goto error
echo Pagefile size changed to %size% MB.
pause
goto menu

:show_hidden
cls
echo Showing hidden files and folders...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >nul 2>&1 || goto error
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSuperHidden /t REG_DWORD /d 1 /f >nul 2>&1 || goto error
echo Hidden files and folders are now visible.
pause
goto menu

:run_powershell_admin
cls
echo Running PowerShell script for system information with admin rights...
start "" "%SystemDrive%\Program Files\PowerShell\7\pwsh.exe" -ExecutionPolicy Bypass -NoProfile -File powersh\sysinfo.ps1 || goto error
pause
goto menu

:show_file_tree
cls
echo Showing file tree of the hard drive...
start "" "%SystemDrive%\Program Files\PowerShell\7\pwsh.exe" -NoProfile -Command "Get-ChildItem C:\ -Recurse | Format-Wide -Property FullName" || goto error
pause
goto menu

:clear_cache
cls
echo Clearing all unnecessary cache...
rd /s /q "%temp%" >nul 2>&1 || goto error
del /s /q "%SystemRoot%\Temp\*" >nul 2>&1 || goto error
echo Cache has been cleared successfully.
pause
goto menu

:rename_os
cls
echo Renaming the operating system...
set /p new_os_name=Enter the new OS name: 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName /t REG_SZ /d "%new_os_name%" /f >nul 2>&1 || goto error
echo OS name changed to %new_os_name%.
pause
goto menu

:optimize_network
cls
echo Optimizing network settings for better speed...
netsh interface tcp set global autotuninglevel=normal >nul 2>&1 || goto error
netsh interface tcp set global rss=enabled >nul 2>&1 || goto error
echo Network settings have been optimized.
pause
goto menu

:error
cls
echo An error occurred
start "" "popups/error.vbs"
pause
goto menu

:exit
cls
echo Thank you for using UTweaker!
pause
exit
