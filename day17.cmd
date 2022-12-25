@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=0"
powershell -command "$file=Get-Content -Path .\%~n0.txt;foreach($line in $file){if($line.Length -ne 0){$line=$line.Replace('<','L').Replace('>','R');for(($i=0);$i -lt $line.Length;$i++){$line.Substring($i,1)}}}">tmp.txt
for /f "delims=" %%i in ('findstr /N "^" "tmp.txt"') do (
	for /f "tokens=1,2 delims=:" %%x in ("%%i") do (
		set /a int=%%x-1
		set line[!int!]=%%y
		set length=%%x
	)
)
del /s /q tmp.txt>nul 2>nul
echo !length!
set highest=0
set index=-1
set loopcount=0
REM for /l %%i in (0,1,2021) do echo %%i&call :rock %%i
REM goto loopend
set i=0
:loop
	call :rock %i%
	echo %i%
	set /a i+=1
	if not defined loopsize goto loop
set /a "target=(loopsize*2)+loopstart"
:loop2
	call :rock %i%
	echo %i%
	set /a i+=1
	if %i% leq %target% goto loop2
set /a "i-=1,height2=!highest!"
powershell -command "(999999999999-!loopstart!)%%!loopsize!+!i!">tmp.txt
set /p target=<tmp.txt
del /s /q tmp.txt>nul 2>nul
:loop3
	set /a i+=1
	call :rock %i%
	echo %i%
	if %i% lss %target% goto loop3
set output=%highest%
REM for /l %%i in (%highest%,-1,1) do echo %%i:	!stack[%%i]:9=!
echo.
echo %output%
powershell -command "(!height2!-!height1!-1);(999999999999-%i%)/!loopsize!;((!height2!-!height1!-1)*(999999999999-%i%)/!loopsize!)+!highest!"
endlocal
exit /b
:loopcheck
set /a "cur=%2/5,prevp=%1-1,prevc=cur-1"
REM echo checking for loop: "!list[%prevp%][4]!"=="!list[%prevc%][4]!", "!list[%1][1]!"=="!list[%cur%][1]!"
if "!list[%prevp%][4]!"=="!list[%prevc%][4]!" if "!list[%1][1]!"=="!list[%cur%][1]!" set /a "loopstart=(%1*5),loopsize=%2-2-loopstart"&echo found loop: !loopstart!+!loopsize!
set "checkloop="
exit /b
:rock
set /a "rock=%1%%5"
if not defined loopsize (
	if defined checkloop if %rock%==2 call :loopcheck %checkloop%,%1
	if %rock%==0 if %1 neq 0 (
		for /l %%i in (0,1,%loopcount%) do (
			REM echo if "!list[%%i][0]!"=="!wind!" call :loopcheck %%i,%1
			if "!list[%%i][0]!"=="!wind!" set checkloop=%%i&set height1=%highest%
		)
		set /a loopcount+=1
	)
	set /a "wind=index%%length"
	set list[!loopcount!][%rock%]=!wind!
)
set /a position[y]=highest+7
for /l %%i in (%highest%,1,%position[y]%) do if not defined stack[%%i] set stack[%%i]=9
set /a position[y]-=3
if %rock%==0 (
	set rock[3]=
	set rock[2]=
	set rock[1]=
	set rock[0]=2345
) else if %rock%==1 (
	set rock[3]=
	set rock[2]=3
	set rock[1]=234
	set rock[0]=3
) else if %rock%==2 (
	set rock[3]=
	set rock[2]=4
	set rock[1]=4
	set rock[0]=234
) else if %rock%==3 (
	set rock[3]=2
	set rock[2]=2
	set rock[1]=2
	set rock[0]=2
) else if %rock%==4 (
	set rock[3]=
	set rock[2]=
	set rock[1]=23
	set rock[0]=23
) else echo rock broke
:moverock
set /a index+=1
set /a "wind=index%%length"
if "!line[%wind%]!"=="L" goto left
if "!line[%wind%]!"=="R" goto right
:leftloop
set /a "int=!rock[%1]:~0,1!-1,pos=position[y]+%1"
if !int! lss 0 set "good="
set check=!stack[%pos%]:%int%=!
if not "!check!"=="!stack[%pos%]!" set "good="
exit /b
:left
set good=true
for /l %%i in (0,1,3) do ( if defined rock[%%i] ( call :leftloop %%i ) )
if not "%good%"=="" (
	for /l %%i in (0,1,3) do (
		if defined rock[%%i] (
			set /a int=!rock[%%i]:~0,1!-1
			rem echo shifting left !rock[%%i]! to !int!!rock[%%i]:~0,-1!
			set rock[%%i]=!int!!rock[%%i]:~0,-1!
		)
	)
)
goto down
:rightloop
set /a "int=!rock[%1]:~-1!+1,pos=position[y]+%1"
if !int! gtr 6 set "good="
set check=!stack[%pos%]:%int%=!
if not "!check!"=="!stack[%pos%]!" set "good="
exit /b
:right
set good=true
for /l %%i in (0,1,3) do ( if defined rock[%%i] ( call :rightloop %%i ) )
if not "%good%"=="" (
	for /l %%i in (0,1,3) do (
		if defined rock[%%i] (
			set /a int=!rock[%%i]:~-1!+1
			rem echo shifting right !rock[%%i]! to !rock[%%i]:~1!!int! using !int!
			set rock[%%i]=!rock[%%i]:~1!!int!
		)
	)
)
:down
set good=true
set /a newpos=%position[y]%-1
if !newpos! gtr 0 (
	for /l %%i in (0,1,3) do (
		set int=!rock[0]:~%%i,1!
		if not "!int!"=="" (
			call set check=%%stack[!newpos!]:!int!=%%
			if not "!check!"=="!stack[%newpos%]!" set "good="
		)
		if %rock%==1 (
			set int=!rock[1]:~%%i,1!
			if not "!int!"=="" (
				call set check=%%stack[!position[y]!]:!int!=%%
				if not "!check!"=="!stack[%position[y]%]!" set "good="
			)
		)
	)
) else set "good="
if "%good%"=="" (
	for /l %%i in (0,1,3) do (
		set /a offset=position[y]+%%i
		if defined rock[%%i] (
			rem echo adding !rock[%%i]! to stack[!offset!]
			call set stack[!offset!]=%%stack[!offset!]%%!rock[%%i]!
			if !offset! gtr !highest! set highest=!offset!
		)
	)
	exit /b
) else set /a position[y]-=1
goto moverock
:strlen <resultVar> <stringVar>
(
    setlocal EnableDelayedExpansion
    (set^ tmp=%~2)
    if defined tmp (
        set "len=1"
        for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            if "!tmp:~%%P,1!" NEQ "" (
                set /a "len+=%%P"
                set "tmp=!tmp:~%%P!"
            )
        )
    ) ELSE set len=0
)
(
    endlocal
    set "%~1=%len%"
    exit /b
)