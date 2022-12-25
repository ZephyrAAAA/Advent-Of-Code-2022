@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=0"
set /a minx=0xffffff
set maxx=0
set /a miny=0xffffff
set maxy=0
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	set line=!line:,=.!
	set line=!line: -^> =,!
	for %%j in (!line!) do (
		for /f "tokens=1,2 delims=." %%x in ("%%j") do (
			if defined prev[x] (
				for /l %%a in (!prev[x]!,1,%%x) do (
					for /l %%b in (!prev[y]!,1,%%y) do (
						set area[%%a][%%b]=X
					)
					for /l %%b in (!prev[y]!,-1,%%y) do (
						set area[%%a][%%b]=X
					)
				)
				for /l %%a in (!prev[x]!,-1,%%x) do (
					for /l %%b in (!prev[y]!,1,%%y) do (
						set area[%%a][%%b]=X
					)
					for /l %%b in (!prev[y]!,-1,%%y) do (
						set area[%%a][%%b]=X
					)
				)
			)
			if %%x lss !minx! (
				set minx=%%x
			) else if %%x gtr !maxx! (
				set maxx=%%x
			)
			if %%y lss !miny! (
				set miny=%%y
			) else if %%y gtr !maxy! (
				set maxy=%%y
			)
			set prev[x]=%%x
			set prev[y]=%%y
		)
	)
	set "prev[x]="
	set "prev[y]="
)
set /a floor=%maxy%+2
:sandloop
	set x=500
	set y=0
	set area[%x%][%y%]=O
	:fallloop
		set /a "tmpy=%y%+1,left=%x%-1,right=%x%+1"
		if !tmpy! lss %floor% (
			if not defined area[%x%][%tmpy%] (
				set "area[%x%][%y%]="
				set "area[%x%][%tmpy%]=O"
				set /a "x=%x%,y=%tmpy%"
			) else (
				if not defined area[%left%][%tmpy%] (
					set "area[%x%][%y%]="
					set "area[%left%][%tmpy%]=O"
					set /a "x=%left%,y=%tmpy%"
				) else (
					if not defined area[%right%][%tmpy%] (
						set "area[%x%][%y%]="
						set "area[%right%][%tmpy%]=O"
						set /a "x=%right%,y=%tmpy%"
					) else (
						echo found ground: %x%,%y%
						if not defined 1done (
							set /a output+=1
						) else (
							set /a output2+=1
							if "%x%,%y%"=="500,0" goto endloop
						)
						goto sandloop
					)
				)
			)
		) else (
			echo found ground: %x%,%y%
			set /a output2+=1
			goto sandloop
		)
		if not defined 1done (
			if %tmpy% geq %maxy% (
				set 1done=true
				set output2=%output%
				echo first complete: %output%
			)
		)
	goto fallloop
:endloop
echo %output%
echo %output2%
endlocal
exit /b