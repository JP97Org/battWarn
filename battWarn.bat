@Echo off
:: Localize variables
SETLOCAL ENABLEDELAYEDEXPANSION
:start
:: Variables to translate the returned BatteryStatus integer to a descriptive text
SET BatteryStatus.1=discharging
SET BatteryStatus.2=The system has access to AC so no battery is being discharged. However, the battery is not necessarily charging.
SET BatteryStatus.3=fully charged
SET BatteryStatus.4=low
SET BatteryStatus.5=critical
SET BatteryStatus.6=charging
SET BatteryStatus.7=charging and high
SET BatteryStatus.8=charging and low
SET BatteryStatus.9=charging and critical
SET BatteryStatus.10=UNDEFINED
SET BatteryStatus.11=partially charged
Goto get-battery

:Next
::@echo "%BatteryStatus%"
if "%BatteryStatus%"=="2" Goto OkCharging
if "%BatteryStatus%"=="6" Goto OkCharging
if "%BatteryStatus%"=="7" Goto OkCharging
if "%BatteryStatus%"=="8" Goto OkCharging
if "%BatteryStatus%"=="9" Goto OkCharging
if "%BatteryStatus%"=="3" Goto OkCharged
if "%Ba%" GEQ "35" Goto Ok

:Warn
@echo 
Echo Your battery is low, please connect the laptop to the mains voltage if possible
if "%Ba%" GEQ "20" Goto Wait
:MegaWarn
> "%~dpn0.vbs" ECHO MsgBox vbLf ^& "The battery is very low." ^& vbLf ^& vbLf ^& "The battery is charged %Ba% percents." ^& vbLf ^& vbLf ^& "Connect the laptop to the mains voltage if possible." ^& vbLf ^& " "^, vbWarning^, "Battery Warning"
    CSCRIPT //NoLogo "%~dpn0.vbs"
    DEL "%~dpn0.vbs"
Goto start

:Ok
Echo Your battery has yet enough charge available, so no need to connect the laptop to the mains voltage
Goto Wait
:OkCharging
Echo Your battery is already charging
Goto Wait
:OkCharged
Echo Your battery is fully charged

:Wait
timeout /t 30 /nobreak > NUL
Goto start

:get-battery
:: Read the battery status
FOR /F "tokens=*" %%A IN ('WMIC Path Win32_Battery Get BatteryStatus /Format:List ^| FIND "="') DO SET %%A

for /f "tokens=2 delims==" %%E in ('wmic path Win32_Battery get EstimatedChargeRemaining /value') do (set "Ba=%%E")
Goto Next

:end