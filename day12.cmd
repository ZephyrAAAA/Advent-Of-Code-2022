@echo off
setlocal enabledelayedexpansion
set "chars=0abcdefghijklmnopqrstuvwxyz"
set "output="
set height=-1
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	set /A height+=1
	set map[!height!]=!line!
	echo !line! | find "S" >nul
	if not !errorlevel!==1 (
		set start=!height!
	)
)
set width=-1
:findloop
set /A width+=1
	if not "!map[%start%]:~%width%,1!"=="" if not "!map[%start%]:~%width%,1!"=="S" goto findloop
set "stack=%width% %start% -1 0,"
:INFINITY
	set remaining=%stack:*,=%
	set command=!stack:,%remaining%=!
	call :findpath %command%
	set stack= !stack!
	set stack=!stack: %command%,=!
if not "%stack%"=="" goto INFINITY
set output=!%enddist%!
echo %output%
endlocal
exit /b
:findpath <x> <y> <distance> <from>
set /a dist=%3+1
if not defined mapdist[%1][%2] ( set mapdist[%1][%2]=%dist%
) else if %dist% lss !mapdist[%1][%2]! ( set mapdist[%1][%2]=%dist%
) else exit /b
if "!map[%2]:~%1,1!"=="E" set enddist=mapdist[%1][%2]&exit /b
if defined enddist (
	if %dist% geq !%enddist%! exit /b
)
set /a "tmpx=%1-1,tmpy=%2,dist=%3+1"
if not "!map[%tmpy%]:~%tmpx%,1!"=="" (
	if not %4==L (
		call :cango %tmpx% %tmpy% !map[%2]:~%1,1!
		if defined go (
			echo going left from %1,%2 '!map[%2]:~%1,1!' to %tmpx%,%tmpy% '!map[%tmpy%]:~%tmpx%,1!'
			set "stack=%stack%%tmpx% %tmpy% %dist% R,"
		)
	)
)
set /a "tmpx=%1+1,tmpy=%2,dist=%3+1"
if not "!map[%tmpy%]:~%tmpx%,1!"=="" (
	if not %4==R (
		call :cango %tmpx% %tmpy% !map[%2]:~%1,1!
		if defined go (
			echo going right from %1,%2 '!map[%2]:~%1,1!' to %tmpx%,%tmpy% '!map[%tmpy%]:~%tmpx%,1!'
			set "stack=%stack%%tmpx% %tmpy% %dist% L,"
		)
	)
)
set /a "tmpx=%1,tmpy=%2-1,dist=%3+1"
if defined map[%tmpy%] (
	if not %4==U (
		call :cango %tmpx% %tmpy% !map[%2]:~%1,1!
		if defined go (
			echo going up from %1,%2 '!map[%2]:~%1,1!' to %tmpx%,%tmpy% '!map[%tmpy%]:~%tmpx%,1!'
			set "stack=%stack%%tmpx% %tmpy% %dist% D,"
		)
	)
)
set /a "tmpx=%1,tmpy=%2+1,dist=%3+1"
if defined map[%tmpy%] (
	if not %4==D (
		call :cango %tmpx% %tmpy% !map[%2]:~%1,1!
		if defined go (
			echo going down from %1,%2 '!map[%2]:~%1,1!' to %tmpx%,%tmpy% '!map[%tmpy%]:~%tmpx%,1!'
			set "stack=%stack%%tmpx% %tmpy% %dist% U,"
		)
	)
)
exit /b
:cango
setlocal
set char=%3
for /l %%N in (1,1,26) do (
	if "!chars:~%%N,1!"=="!char!" set /a num=%%N+1
)
if "!char!"=="S" set num=2
if "!char!"=="E" set num=27
set char=!map[%2]:~%1,1!
for /l %%N in (1,1,26) do (
	if "!chars:~%%N,1!"=="!char!" set num2=%%N
)
if "!char!"=="S" set num2=1
if "!char!"=="E" set num2=26
if %num2% leq %num% (
	set go=true
) else (
	set "go="
)
endlocal & set "go=%go%"
exit /b