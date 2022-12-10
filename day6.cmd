@echo off
setlocal enabledelayedexpansion
set line=%~2
if "%1"=="process" call :processline
if "%1"=="process2" call :processline2
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
)
cmd /c "%0 process !line!"
cmd /c "%0 process2 !line!"
exit /b
:processline
setlocal enabledelayedexpansion
for /l %%i in (0,1,2000000) do (
	set string=!line:~%%i,4!
	if [!string!]==[] endlocal & set output=%output% & exit
	set "isdupes="
	for /l %%x in (0,1,3) do (
		if not defined isdupes call :checkdupes !string! %%x
	)
	if not defined isdupes set /A output=%%i+4 & echo !output! & endlocal & exit
)
:processline2
setlocal enabledelayedexpansion
for /l %%i in (0,1,2000000) do (
	set string=!line:~%%i,14!
	if [!string!]==[] endlocal & set output=%output% & exit
	set "isdupes="
	for /l %%x in (0,1,13) do (
		if not defined isdupes call :checkdupes !string! %%x
	)
	if not defined isdupes endlocal & set /A output2=%%i+14 & echo !output2! & endlocal & exit
)
:checkdupes
setlocal enabledelayedexpansion
set string=%~1
set index=%~2
set /A next=%index%+1
echo !string:~0,%index%!!string:~%next%! | find "!string:~%index%,1!" > nul
if %errorlevel%==0 set dupe=true
endlocal & set isdupes=%isdupes%%dupe%