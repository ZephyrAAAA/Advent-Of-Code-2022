@echo off
setlocal enabledelayedexpansion
set "chars=0abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
set output=0
set output2=0
set groupnum=0
for /f %%i in ('findstr /N "^" "%~n0.txt"') do (
	set "line=%%i"
	set line=!line:*:=!
	call :processline !line!
	set /A output+=!num!
	call :processline2 !line!
	if defined num set /A output2+=!num!
)
echo %output%
echo %output2%
exit /b
:processline
set num=
set char=
set line=%~1
call :strlen result !line!
set /A half=!result!/2
set firsthalf=!line:~0,%half%!
set secondhalf=!line:~%half%!
for /l %%i in (0,1,%half%) do (
	echo %secondhalf% | find "!firsthalf:~%%i,1!" >nul
	if !errorlevel!==0 set char=!firsthalf:~%%i,1!
	if [!char!]==[!firsthalf:~%%i,1!] (
		for /l %%N in (1,1,52) do (
			if "!chars:~%%N,1!"=="!char!" set num=%%N && exit /b
		)
	)
)
exit /b
:processline2
set num=
set char=
set line=%~1
set group[%groupnum%]=!line!
set /A groupnum+=1
if %groupnum% neq 3 exit /b rem  just return lmao
set groupnum=0
call :strlen result !line!
for /l %%i in (0,1,%result%) do (
	echo %group[0]% | find "!line:~%%i,1!" >nul
	if !errorlevel!==0 (
		echo %group[1]% | find "!line:~%%i,1!" >nul
		if !errorlevel!==0 (
			for /l %%N in (1,1,52) do (
				if "!chars:~%%N,1!"=="!line:~%%i,1!" set num=%%N && exit /b
			)
		)
	)
)
exit /b
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