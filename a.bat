@echo off
title Windows 11 FULL Optimizer
color 0a

:menu
cls
echo ==========================================
echo       WINDOWS 11 - TOI UU + DEFENDER
echo ==========================================
echo.
echo  [1] Toi uu Windows 11 (giu hieu ung giao dien)
echo  [2] Disable Windows Defender (tat hoan toan)
echo  [3] Enable Windows Defender (bat lai nhu cu)
echo  [4] Thoat
echo.
set /p choice= Chon 1 lua chon (1-4): 

if "%choice%"=="1" goto optimize
if "%choice%"=="2" goto disable
if "%choice%"=="3" goto enable
if "%choice%"=="4" exit
goto menu

:optimize
echo ------------------------------------------
echo  DANG TOI UU WINDOWS 11...
echo ------------------------------------------

:: Tat service khong can thiet (nhung GIU lai hieu ung giao dien)
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1

sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1

sc stop Fax >nul 2>&1
sc config Fax start=disabled >nul 2>&1

:: Khong tat Windows Search de GIU animation + hieu ung
:: sc stop WSearch >nul 2>&1
:: sc config WSearch start=disabled >nul 2>&1

:: Don dep RAM Cache, Temp
del /s /q /f %systemroot%\Prefetch\*.*
del /s /q /f %temp%\*.*
del /s /q /f C:\Windows\Temp\*.*

:: Toi uu network
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled

:: Khong tat Visual Effects -> giu hieu ung man hinh dep
:: Neu muon tat -> thay /d 2 thanh /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f

:: Tat background apps khong can thiet
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f

:: Tat quang cao
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f

echo.
echo *** TOI UU HOAN TAT! VUI LONG RESTART MAY ***
pause
goto menu

:disable
echo ------------------------------------------
echo  DANG TAT WINDOWS DEFENDER...
echo ------------------------------------------
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $true"
sc stop WinDefend >nul 2>&1
sc config WinDefend start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
echo.
echo *** WINDOWS DEFENDER DA DUOC TAT HOAN TOAN ***
echo *** VUI LONG RESTART DE CO HIEU LUC ***
pause
goto menu

:enable
echo ------------------------------------------
echo  DANG BAT WINDOWS DEFENDER TRO LAI...
echo ------------------------------------------
sc config WinDefend start=auto >nul 2>&1
sc start WinDefend >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f >nul 2>&1
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false"
echo.
echo *** WINDOWS DEFENDER DA DUOC BAT LAI ***
pause
goto menu
