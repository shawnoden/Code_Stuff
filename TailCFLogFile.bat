@echo off
setlocal
:begin
cls

echo Which log would you like to tail?
echo.
echo 1) ColdFusion Console Log
echo 2) ColdFusion Error Log
echo 3) ColdFusion Exception Log
echo 4) ColdFusion Application Log
echo.

choice /c 12345 /n /t 30 /d 1 /m "Pick a log file:"
set pick=%errorlevel%

set goto=0

if %pick% == 4 (
title ColdFusion Application Log
set goto=4
)
if %pick% == 3 (
title ColdFusion Exception Log
set goto=3
)
if %pick% == 2 (
title ColdFusion Error Log
set goto=2
)
if %pick% == 1 (
title ColdFusion Console Log
set goto=1
)
goto %goto%

:::::::::::::::::::::::::::::::::::::::::::::::
:0
goto :eof

:1
:: ColdFusion Console Log
powershell.exe -Command "Get-Content -Path 'C:\\CF2016Exp\cfusion\logs\coldfusion-out.log' -Wait"
:: -Tail 20"
goto :eof

:2
:: ColdFusion Error Log
powershell.exe -Command "Get-Content -Path 'C:\\CF2016Exp\cfusion\logs\coldfusion-error.log' -Wait"
goto :eof

:3
:: ColdFusion Exception Log
powershell.exe -Command "Get-Content -Path 'C:\\CF2016Exp\cfusion\logs\exception.log' -Wait"
goto :eof

:4
:: ColdFusion Application Log
powershell.exe -Command "Get-Content -Path 'C:\\CF2016Exp\cfusion\logs\application.log' -Wait"
goto :eof

::NOTES
::CHOICE doesn't work in some versions of Windows, like NT4, 200 and XP.
::ERRORLEVEL is the offset value of the index of the key that was selected
::ERRORLEVEL 255 == error in the CHOICE itself ; ERRORLEVEL 0 == CTRL+BREAK and CTRL+C
::Use Decreasing Order to pick the appropriate value. ERRORLEVEL will check TRUE for all previous values.