@echo off
::
:: Process arguements
::
if "%~1%"=="/?" goto help
if "%~1%"=="" goto help
if "%~2%"=="/?" goto help
if "%~2%"=="" (
    echo !!! Error: ParseFn requires two inputs. !!!
    goto help)

set in=%~1%
set out=%~2%
:: echo "%in:~3,1%"   "%in:~0,1%"
if "%in:~3,1%"=="" (
    if "%in:~0,1%"=="/" (
    set in=%~2%
    set out=%~1%)
)

::
:: Parse filename
::
set "ret="
For %%A in ("%in%") do (
    if "%out%"=="/f" (set ret=%%~fA)
    if "%out%"=="/d" (set ret=%%~dA)
    if "%out%"=="/p" (set ret=%%~pA)
    if "%out%"=="/n" (set ret=%%~nA)
    if "%out%"=="/x" (set ret=%%~xA)
    if "%out%"=="/s" (set ret=%%~sA)
    if "%out%"=="/a" (set ret=%%~aA)
    if "%out%"=="/t" (set ret=%%~tA)
    if "%out%"=="/z" (set ret=%%~zA)
    if "%out%"=="/dp" (set ret=%%~dpA)
    if "%out%"=="/nx" (set ret=%%~nxA)
    if "%out%"=="/fs" (set ret=%%~fsA)
)
echo %ret%
echo.

goto end
:help
@echo off
@echo ::___________________________________________________________________::
@echo ::                                                                   ::
@echo ::                              ParseFn                              ::
@echo ::                                                                   ::
@echo ::                           Chris Advena                            ::
@echo ::___________________________________________________________________::
@echo.
@echo.
@echo ParseFn parses a fully qualified path name (e.g., c:\temp\my.bat)
@echo into the requested component, such as drive, path, filename, 
@echo extenstion, etc.
@echo.
@echo Syntax: /switch filename
@echo where,
@echo   filename is a fully qualified path name including drive, 
@echo   folder(s), file name, and extension
@echo.
@echo   Select only one switch:
@echo       /f - fully qualified path name
@echo       /d - drive letter only
@echo       /p - path only
@echo       /n - file name only
@echo       /x - extension only
@echo       /s - expanded path contains short names only
@echo       /a - attributes of file
@echo       /t - date/time of file
@echo       /z - size of file
@echo      /dp - drive + path
@echo      /nx - file name + extension
@echo      /fs - full path + short name
@echo.

:end