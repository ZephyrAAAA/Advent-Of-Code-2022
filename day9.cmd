@echo off
setlocal enabledelayedexpansion
set taillist[0~0]=true
set taillist9[0~0]=true
set "output=1"
set "output2=1"
for /l %%i in (0,1,9) do (
	set x[%%i]=0
	set y[%%i]=0
)
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	for /f "tokens=1,2" %%i in ("!line!") do (
		if %%i==R (
			for /l %%x in (1,1,%%j) do (
				set /A x[0]+=1
				call :looptail
			)
		) else if %%i==L (
			for /l %%x in (1,1,%%j) do (
				set /A x[0]-=1
				call :looptail
			)
		) else if %%i==U (
			for /l %%x in (1,1,%%j) do (
				set /A y[0]+=1
				call :looptail
			)
		) else if %%i==D (
			for /l %%x in (1,1,%%j) do (
				set /A y[0]-=1
				call :looptail
			)
		)
	)
)
echo %output%
echo %output2%
endlocal
exit /b
:looptail
for /l %%i in (1,1,9) do (
	call :movetail %%i
)
if not defined taillist[%x[1]%~%y[1]%] (
	set taillist[%x[1]%~%y[1]%]=true
	set /A output+=1
)
if not defined taillist9[%x[9]%~%y[9]%] (
	set taillist9[%x[9]%~%y[9]%]=true
	set /A output2+=1
)
exit /b
:movetail
setlocal
set /A prev=%1-1
set /A tmpx=!x[%prev%]!-!x[%1]!
set absx=!tmpx:-=!
if !tmpx! neq 0 (
	set /A tmpx=!tmpx!/!absx!
) else (
	set tmpx=0
)
set /A tmpy=!y[%prev%]!-!y[%1]!
set absy=!tmpy:-=!
if !tmpy! neq 0 (
	set /A tmpy=!tmpy!/!absy!
) else (
	set tmpy=0
)
if !absx! leq 1 (
	if !absy! leq 1 (
		exit /b
	)
)
endlocal & set /A x[%1]+=%tmpx% & set /A y[%1]+=%tmpy%
exit /b