@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=4294967296"
set "dir="
set index=-1
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	call :processline
)
for /l %%i in (%index%,-1,0) do (
	set dir=!dirlist[%%i]!
	set tmp=!dir:*\=!
	call :uploop
	if not "%tmp%"=="=" (
		set dir=!dir!;
		set tmp=!tmp!;
		call set dir=%%dir:\!tmp!=%%
		if not "!dir!"=="!dirlist[%%i]!" (
			call set /A dirsize[!dir!]+=%%dirsize[!dirlist[%%i]!]%%
		)
	)
)
set mainsize=!dirsize[\\]!
for /l %%i in (0,1,%index%) do (
	call call set tmpsize=%%%%dirsize[%%dirlist[%%i]%%]%%%%
	if !tmpsize! leq 100000 (
		set /A output+=!tmpsize!
	)
	if %%i leq %output2% (
		set /A delsize=!mainsize!-!tmpsize!
		if !delsize! leq 40000000 set output2=!tmpsize!
	)
)
echo %output%
echo %output2%
endlocal
exit /b
:processline
if "!line:~0,1!"=="$" (
	echo !line:~2! | find "cd" > nul
	if !errorlevel!==0 (
		if "!line:~5!"==".." (
			set tmp=!dir:*\=!
			call :uploop
			set dir=!dir!;
			set tmp=!tmp!;
			call set dir=%%dir:\!tmp!=%%
		) else (
			set dir=!dir!\!line:~5!
			set dir=!dir:/=\!
			set /A index+=1
			set dirlist[!index!]=!dir!
			if not defined dirsize[!dir!] set dirsize[!dir!]=0
		)
	)
) else (
	for /f "tokens=1,2" %%i in ("!line!") do (
		if not %%i==dir (
			set /A "dirsize[!dir!]+=%%i"
		)
	)
)
exit /b
:uploop
if not "!tmp:*\=!"=="!tmp!" if not "!tmp:*\=!"=="" set tmp=!tmp:*\=!& goto uploop
exit /b