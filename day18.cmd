@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=0"
set maxx=0
set maxy=0
set maxz=0
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	for /f "tokens=1,2,3 delims=," %%x in ("!line!") do (
		set list[%%x][%%y][%%z]=true
		if %%x gtr !maxx! set maxx=%%x
		if %%y gtr !maxy! set maxy=%%y
		if %%z gtr !maxz! set maxz=%%z
	)
)
for /l %%x in (0,1,%maxx%) do (
	for /l %%y in (0,1,%maxy%) do (
		for /l %%z in (0,1,%maxz%) do (
			if defined list[%%x][%%y][%%z] (
				set /a "a=%%x-1,b=%%x+1,c=%%y-1,d=%%y+1,e=%%z-1,f=%%z+1"
				if not defined list[!a!][%%y][%%z] set /a output+=1
				if not defined list[!b!][%%y][%%z] set /a output+=1
				if not defined list[%%x][!c!][%%z] set /a output+=1
				if not defined list[%%x][!d!][%%z] set /a output+=1
				if not defined list[%%x][%%y][!e!] set /a output+=1
				if not defined list[%%x][%%y][!f!] set /a output+=1
			) else set "bad="&set cumul=0&call :checkair %%x,%%y,%%z,0,0
			if not defined bad set /a "output2+=cumul,bad=0"&echo decreasing by !cumul! at %%x,%%y,%%z|find /v "by 0"
		)
	)
)
set /a output2+=output
echo %output%
echo %output2%
endlocal
exit /b
:checkair
if %5 geq 100 exit /b
if defined list2[%1][%2][%3] set bad=true&exit /b
set list2[%1][%2][%3]=true
set /a "a=%1-1,b=%1+1,c=%2-1,d=%2+1,e=%3-1,f=%3+1,i=%5+1"
rem if not defined list[%a%][%2][%3] if not defined list[%b%][%2][%3] if not defined list[%1][%c%][%3] if not defined list[%1][%d%][%3] if not defined list[%1][%2][%e%] if not defined list[%1][%2][%f%] set bad=true
if %b% gtr %maxx% set bad=true
if %d% gtr %maxy% set bad=true
if %f% gtr %maxz% set bad=true
if %a% lss 0 set bad=true
if %c% lss 0 set bad=true
if %e% lss 0 set bad=true
if defined bad exit /b
if not defined list[%a%][%2][%3] ( if not "%4"=="b" call :checkair %a%,%2,%3,a,%i%&set i=%i% ) else set /a cumul-=1
if not defined list[%b%][%2][%3] ( if not "%4"=="a" call :checkair %b%,%2,%3,b,%i%&set i=%i% ) else set /a cumul-=1
if not defined list[%1][%c%][%3] ( if not "%4"=="d" call :checkair %1,%c%,%3,c,%i%&set i=%i% ) else set /a cumul-=1
if not defined list[%1][%d%][%3] ( if not "%4"=="c" call :checkair %1,%d%,%3,d,%i%&set i=%i% ) else set /a cumul-=1
if not defined list[%1][%2][%e%] ( if not "%4"=="f" call :checkair %1,%2,%e%,e,%i%&set i=%i% ) else set /a cumul-=1
if not defined list[%1][%2][%f%] ( if not "%4"=="e" call :checkair %1,%2,%f%,f,%i%&set i=%i% ) else set /a cumul-=1
exit /b