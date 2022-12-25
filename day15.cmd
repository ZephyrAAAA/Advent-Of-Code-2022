@echo off
setlocal enabledelayedexpansion
if "%1"=="process2" goto :part2
set "output=0"
set "output2=0"
set targ=2000000
set index=-1
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	set line=!line: =!&set line=!line:Sensorat=!&set line=!line:closestbeaconisat=!&set line=!line:x=!&set line=!line:y=!
	for /f "tokens=1* delims==" %%a in ("!line!") do ( set line=%%a%%b )
	for /f "tokens=1* delims==" %%a in ("!line!") do ( set line=%%a%%b )
	for /f "tokens=1* delims==" %%a in ("!line!") do ( set line=%%a%%b )
	set /a index+=1
	for /f "tokens=1,2 delims=:" %%a in ("!line!") do (
		for /f "tokens=1,2 delims=," %%x in ("%%a") do (
			set sensor[!index!][x]=%%x
			set sensor[!index!][y]=%%y
		)
		for /f "tokens=1,2 delims=," %%x in ("%%b") do (
			set /a "distx=sensor[!index!][x]-%%x,disty=sensor[!index!][y]-%%y"
			set /a "distx=sensor[!index!][x]-%%x,disty=sensor[!index!][y]-%%y"
			set distx=!distx:-=!
			set disty=!disty:-=!
			set /a "sensor[!index!][dist]=!distx!+!disty!"
		)
	)
)
set "list="
for /l %%i in (0,1,%index%) do (
	set /a "dist=sensor[%%i][y]-targ"
	set dist=!dist:-=!
	set /a "sensor[%%i][width]=sensor[%%i][dist]-dist"
	if !sensor[%%i][width]! geq 0 (
		call :checklist !sensor[%%i][x]!,!sensor[%%i][width]!
	)
)
for %%i in (%list%) do (
	for /f "tokens=1,2 delims=`" %%x in ("%%i") do (
		set /a output+=%%y-%%x
	)
)
echo %output%
set /a targ*=2
for /l %%x in (2500000,1,%targ%) do (
	start /min cmd /c "%0 process2,%%x"
	ping ::1 -n 1>nul
	set /a "n=%%x%%2000" & if "!n!"=="0" echo %%x
)
rem powershell -command "[console]::beep(1000,1000)"
endlocal
exit /b
:checklist
set /a "min=%1-%2,max=%1+%2,left=min-1,right=max+1"
:dupecheck
for %%i in (%list%) do (
	for /f "tokens=1,2 delims=`" %%x in ("%%i") do (
		if %min% lss %%x ( if %right% geq %%x ( set list=!list:%%x`=%min%`!&set leave=true ) )
		if %max% gtr %%y ( if %left% leq %%y ( set list=!list:`%%y=`%max%!&set leave=true ) )
		if %min% geq %%x ( if %max% leq %%y ( set leave=true ) )
	)
	if defined leave goto checkdupes
)
if not defined list ( set list=%min%`%max%
) else set list=!list!,%min%`%max%
exit /b
:checkdupes
set "leave="
for %%i in (%list%) do (
	set list=!list:%%i=!
	if "!list:~0,1!"=="," set list=!list:~1!
	for /f "tokens=1,2 delims=`" %%x in ("%%i") do ( set /a "min=%%x,max=%%y,left=min-1,right=max+1" )
	call :dupecheck
)
exit /b
:part2
set "list="
for /l %%i in (0,1,%index%) do (
	set /a "dist=sensor[%%i][y]-%2"
	set dist=!dist:-=!
	set /a "sensor[%%i][width]=sensor[%%i][dist]-dist"
	if !sensor[%%i][width]! geq 0 ( call :checklist !sensor[%%i][x]!,!sensor[%%i][width]! )
)
if not "!list:,=!"=="!list!" (
	set list=!list:*,=!
	for /f "tokens=1,2 delims=`" %%i in ("!list!") do (
		powershell -command "((%%i-1)*%targ%)+%2;[console]::beep(1000,1000)"
		echo ((%%i-1)*%targ%)+%2
	)
	endlocal
	pause
	exit
)
endlocal
exit