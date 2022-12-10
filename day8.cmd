@echo off
setlocal enabledelayedexpansion
set "output="
set "output2=0"
set height=-1
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	set /A height+=1
	set treelist[!height!]=!line!
)
call :strlen width !treelist[1]!
set /A width-=1
for /l %%y in (0,1,%height%) do (
	for /l %%x in (0,1,%width%) do (
		if %%x==0 (
			set /A output+=1
		) else if %%y==0 (
			set /A output+=1
		) else if %%x==%width% (
			set /A output+=1
		) else if %%y==%height% (
			set /A output+=1
		) else (
			call :checkvisible %%x %%y
		)
	)
)
for /l %%y in (0,1,%height%) do (
	for /l %%x in (0,1,%width%) do (
		if %%x==0 (
			rem 
		) else if %%y==0 (
			rem 
		) else if %%x==%width% (
			rem 
		) else if %%y==%height% (
			rem 
		) else (
			call :counttrees %%x %%y
		)
	)
)
echo %output%
echo %output2%
endlocal
exit /b
:counttrees
setlocal
set tree=!treelist[%2]:~%1,1!
set /A y=0
set /A x=0
set upcount=0
set downcount=0
set leftcount=0
set rightcount=0
:downloop
set /A y+=1
	set /A downcount+=1
	set /A tmpY=%2+%y%
	set listcheck=!treelist[%tmpY%]!
	set treecheck=!listcheck:~%1,1!
	if !treecheck! geq !tree! (
		set y=0
		goto uploop
	)
if %tmpY% lss !height! goto downloop
set y=0
:uploop
set /A y-=1
	set /A upcount+=1
	set /A tmpY=%2+%y%
	set listcheck=!treelist[%tmpY%]!
	set treecheck=!listcheck:~%1,1!
	if !treecheck! geq !tree! (
		goto rightloop
	)
if %tmpY% gtr 0 goto uploop
:rightloop
set /A x+=1
	set /A rightcount+=1
	set /A tmpX=%1+%x%
	set listcheck=!treelist[%2]!
	set treecheck=!listcheck:~%tmpX%,1!
	if !treecheck! geq !tree! (
		set x=0
		goto leftloop
	)
if %tmpX% lss !width! goto rightloop
set x=0
:leftloop
set /A x-=1
	set /A leftcount+=1
	set /A tmpX=%1+%x%
	set listcheck=!treelist[%2]!
	set treecheck=!listcheck:~%tmpX%,1!
	if !treecheck! geq !tree! (
		goto loopend
	)
if %tmpX% gtr 0 goto leftloop
:loopend
set /A sightcount=%downcount%*%upcount%*%rightcount%*%leftcount%
(
	endlocal
	if %sightcount% gtr %output2% set output2=%sightcount%
)
exit /b
:checkvisible
setlocal
set tree=!treelist[%2]:~%1,1!
set /A y=-%2-1
set /A x=-%1-1
:yloop
set /A y+=1
	if %y%==0 goto complete
	set /A tmpY=%2+%y%
	set listcheck=!treelist[%tmpY%]!
	set treecheck=!listcheck:~%1,1!
	if !treecheck! geq !tree! (
		if %tmpY% geq %2 (
			goto xloop
		) else (
			set y=0
		)
	)
	if %tmpY%==%height% goto complete
if %tmpY% lss !height! goto yloop
:xloop
set /A x+=1
	if %x%==0 goto complete
	set /A tmpX=%1+%x%
	set listcheck=!treelist[%2]!
	set treecheck=!listcheck:~%tmpX%,1!
	if !treecheck! geq !tree! (
		if %tmpX% gtr %1 (
			goto loopend
		) else (
			set x=0
		)
	)
	if %tmpX%==%width% goto complete
if %tmpX% lss !width! goto xloop
:loopend
endlocal
exit /b
:complete
endlocal & set /A output+=1
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