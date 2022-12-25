@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=0"
set max=30
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	for /f "tokens=1* delims==" %%a in ("!line!") do ( set line=%%a`%%b )
	set line=!line: =!
	set line=!line:Valve=!
	set line=!line:hasflowrate=!
	set line=!line:tunnelleadsto=!
	set line=!line:tunnelsleadtos=!
	for /f "tokens=1,2 delims=;" %%a in ("!line!") do (
		for /f "tokens=1,2 delims=`" %%x in ("%%a") do (
			set valve[%%x][p]=%%y
			set valve[%%x][to]=%%b
		)
	)
)
call :findpath AA,-1,0,0
echo %output%
echo %output2%
endlocal
exit /b
:findpath <to> <count> <distance> <tick> <done> <last>
set /a "dist=%3+%4,count=%2+1,dist1=dist,count1=count"
rem if not defined valve[%1][%count%] ( set valve[%1][%count%]=%4
rem ) else if %4 gtr !valve[%1][%count%]! ( set valve[%1][%count%]=%4
rem ) else exit /b
if %count% geq %max% (
	if %dist% gtr %output% set output=%dist%&set output2=%5
	echo complete: %5: %dist%
	exit /b
)
set done=%5
if !valve[%1][p]! leq 0 goto noturn
if defined done if not "!done:%1=!"=="!done!" goto noturn
set /a "dist+=%4,count+=1,tick=%4+!valve[%1][p]!"
if %count% geq %max% (
	if %dist% gtr %output% set output=%dist%
	echo complete: %5: %dist%
	exit /b
)
set done=!done!`%1%count%
for %%i in (!valve[%1][to]!) do (
	call :findpath %%i,%count%,%dist%,%tick%,%done%,%1
)
:noturn
for %%i in (!valve[%1][to]!) do (
	if not "%%i"=="%6" call :findpath %%i,%count1%,%dist1%,%4,%5,%1
)
exit /b