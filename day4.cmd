@echo off
setlocal enabledelayedexpansion
set output=0
set output2=0
for /f %%i in ('findstr /N "^" "%~n0.txt"') do (
	set "line=%%i"
	set line=!line:*:=!
	call :processline "!line!"
	if defined overlap set /A output+=1
	if defined overlap2 set /A output2+=1
)
echo %output%
echo %output2%
exit /b
:processline
setlocal
set "tmp="
set "tmp2="
set "line=%~1"
for /f "tokens=1,2 delims=," %%i in ("!line!") do (
	for /f "tokens=1,2 delims=-" %%x in ("%%i") do (
		set "elf1num1=%%x"
		set "elf1num2=%%y"
	)
	for /f "tokens=1,2 delims=-" %%x in ("%%j") do (
		set "elf2num1=%%x"
		set "elf2num2=%%y"
	)
	if !elf1num1! leq !elf2num1! ( if !elf1num2! geq !elf2num2! ( set tmp=true ) )
	if !elf2num1! leq !elf1num1! ( if !elf2num2! geq !elf1num2! ( set tmp=true ) )
	if !elf1num1! geq !elf2num1! ( if !elf1num1! leq !elf2num2! ( set tmp2=true ) )
	if !elf1num2! geq !elf2num1! ( if !elf1num2! leq !elf2num2! ( set tmp2=true ) )
	if !elf2num1! geq !elf1num1! ( if !elf2num1! leq !elf1num2! ( set tmp2=true ) )
	if !elf2num2! geq !elf1num1! ( if !elf2num2! leq !elf1num2! ( set tmp2=true ) )
)
endlocal & set "overlap=%tmp%" & set "overlap2=%tmp2%"
exit /b