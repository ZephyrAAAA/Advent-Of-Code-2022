@echo off
setlocal enabledelayedexpansion
set cycle=0
set signal=1
set "output="
set "output2="
set "screen="
set NL=^&echo.

for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	set /A cycle+=1
	call :drawpixel
	call :checkcycle
	for /f "tokens=1,2" %%x in ("!line!") do (
		if %%x==addx (
			set /A cycle+=1
			call :drawpixel
			call :checkcycle
			set /A signal+=%%y
		)
	)
)
echo %output%
echo %output2:~0,40%
echo %output2:~40,40%
echo %output2:~80,40%
echo %output2:~120,40%
echo %output2:~160,40%
echo %output2:~200,40%
endlocal
exit /b
:checkcycle
set /A "tmp=(!cycle!+20)%%40"
if !tmp!==0 (
	set /A tmp=!signal!*!cycle!
	set /A output+=!tmp!
)
exit /b
:drawpixel
set /A "tmp=(!cycle!-1)%%40"
set /A tmp=!tmp!-!signal!
if !tmp! geq -1 (
	if !tmp! leq 1 (
		set output2=!output2!#
		exit /b
	)
)
set output2=!output2!.
exit /b