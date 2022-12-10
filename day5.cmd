@echo off
setlocal enabledelayedexpansion
set "output="
set "output2="
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	if defined line (
		call :processline
	)
)
for /l %%i in (1,1,10) do (
	if defined stacks[%%i] set output=!output!!stacks[%%i]:~0,1!
	if defined stacks2[%%i] set output2=!output2!!stacks2[%%i]:~0,1!
)
echo %output%
echo %output2%
endlocal
exit /b
:processline
echo !line! | find " 1   2" >nul
if !errorlevel!==0 set initdone=true & exit /b
if not defined initdone (
	for /l %%i in (1,1,20) do (
		call :getstacks %%i
	)
) else (
	set line=!line:move =!
	set line=!line:from =!
	set line=!line:to =!
	for /f "tokens=1,2,3" %%i in ("!line!") do (
		for /l %%x in (1,1,%%i) do (
			set stacks[%%k]=!stacks[%%j]:~0,1!!stacks[%%k]!
			set stacks[%%j]=!stacks[%%j]:~1!
		)
		set stacks2[%%k]=!stacks2[%%j]:~0,%%i!!stacks2[%%k]!
		set stacks2[%%j]=!stacks2[%%j]:~%%i!
	)
)
exit /b
:getstacks
setlocal
set index=%~1
set /A tmp=%index%*4-3
if "!line:~%tmp%,1!"=="" exit /b
if "!line:~%tmp%,1!"==" " exit /b
set lineout=!line:~%tmp%,1!
endlocal & set stacks[%index%]=!stacks[%index%]!%lineout%& set stacks2[%index%]=!stacks2[%index%]!%lineout%
exit /b