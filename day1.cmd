@echo off
setlocal enabledelayedexpansion
set output=0
set output2=0
for /l %%i in (1,1,4) do (
	set list[%%i]=0
	set list[%%i][1]=0
)
set index=0
for /f %%i in ('findstr /N "^" "%~n0.txt"') do (
	set "line=%%i"
	set line=!line:*:=!
	call :evaluate
)
for /l %%i in (1,1,%index%) do (
	if !array[%%i]! GTR !output! set output=!array[%%i]!
	for /l %%x in (1,1,3) do (
		call :part2 %%x %%i
	)
)
for /l %%i in (1,1,3) do set /A output2=!output2!+!list[%%i]!
echo %output%
echo %output2%
exit /b 0
:part2
for /l %%i in (1,1,3) do (
	if !list[%%i][1]!==%2 exit /b 0
)
if !list[%1]! lss !array[%2]! (
	call :checknext %1
	set list[%1]=!array[%2]!
	set list[%1][1]=%2
)
exit /b 0
:checknext
set /A next=%1+1
if !list[%1]! gtr !list[%next%]! (
	call :checknext %next%
	set list[%next%]=!list[%1]!
	set list[%next%][1]=!list[%1][1]!
)
exit /b 0
:evaluate
if not "!line!"=="" (
	set /A "array[!index!]=!array[%index%]!+!line!"
) else set /A index+=1 & rem echo increase index
exit /b 0