@echo off 
setlocal enableextensions disabledelayedexpansion

set "search=E:\Drive\__Spencer's Files\SMBX\SMBX2\data\worlds\Super Mario All-Stars++\"
set "replace="

set "textFile=version-latestfiles.txt"

cd..

dir /b /s /A-D /o:gn>version-latestfiles.txt

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(%%~dpi=%%~ni=%%~xi=%%~zi)
    endlocal
)

cls
echo Done
pause
exit