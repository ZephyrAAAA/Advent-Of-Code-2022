@echo off
setlocal enabledelayedexpansion
set "output=0"
set "output2=0"
set "first="
set index=0
set listsize=2
set "list[1]=[[2]]
set "list[2]=[[6]]
set div1=1
set div2=2
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	if not defined line (
		set "first="
	) else if not defined first (
		set /a index+=1
		set first=!line!
	) else (
		call :compare "!first!" "!line!"
		if defined complete (
			set /a output+=!index!
			set /a listsize+=1
			set list[!listsize!]=!first!
			set /a listsize+=1
			set list[!listsize!]=!line!
		) else (
			set /a listsize+=1
			set list[!listsize!]=!line!
			set /a listsize+=1
			set list[!listsize!]=!first!
		)
	)
)
set listind=2
:sortloop
	set /a "prev=%listind%-1"
	call :compare "!list[%prev%]!" "!list[%listind%]!"
	if not defined complete (
		echo swapping positions %prev%/%listind%: !list[%prev%]!/!list[%listind%]!
		set prevlist=!list[%prev%]!
		set list[%prev%]=!list[%listind%]!
		set list[%listind%]=!prevlist!
		if "!list[%listind%]!"=="[[2]]" (
			set div1=%listind%
		) else if "!list[%prev%]!"=="[[2]]" (
			set div1=%prev%
		)
		if "!list[%listind%]!"=="[[6]]" (
			set div2=%listind%
		) else if "!list[%prev%]!"=="[[6]]" (
			set div2=%prev%
		)
		set changed=true
	)
	set /a listind+=1
	echo if %listind% gtr %listsize%
	if %listind% gtr %listsize% (
		if defined changed (
			set "changed="
			set listind=2
			goto sortloop
		)
	) else (
		goto sortloop
	)
echo set /a output2=%div1%*%div2%
set /a output2=%div1%*%div2%
echo %output%
echo %output2%
endlocal
exit /b
:compare <first> <second>
setlocal
set first=%~1
set first=%first:~1,-1%
set second=%~2
set second=%second:~1,-1%
rem echo %first% vs %second%
:compareloop
	if "%first%"=="" (
		if "%second%"=="" (
			endlocal
			set complete=pass
			exit /b
		) else (
			goto goodcompare
		)
	)
	if "%second%"=="" (
		goto badcompare
	)
	set firstnum=%first:~0,2%
	set firstnum=%firstnum:,=%
	set secondnum=%second:~0,2%
	set secondnum=%secondnum:,=%
	if not "%firstnum:[=%"=="%firstnum%" (
		if not "%secondnum:[=%"=="%secondnum%" (
			call :findbrackets "%first%" recursfirst
			call :findbrackets "%second%" recurssecond
			set first= !first!
			call set first=%%first: !recursfirst!,=%%
			if "!first!"==" %first%" (
				call set first=%%first: !recursfirst!=%%
			)
			set second= !second!
			call set second=%%second: !recurssecond!,=%%
			if "!second!"==" %second%" (
				call set second=%%second: !recurssecond!=%%
			)
			call :compare "!recursfirst!" "!recurssecond!" R
			if defined complete (
				if "!complete!"=="pass" (
					goto compareloop
				) else goto goodcompare
			) 
			if not defined complete goto badcompare
			goto compareloop
		) else (
			call :findbrackets "%first%" recursfirst
			set first= !first!
			call set first=%%first: !recursfirst!,=%%
			if "!first!"==" %first%" (
				call set first=%%first: !recursfirst!=%%
			)
			set recurssecond=[%secondnum%]
			call set second=%%second:!recurssecond!,=%%
			if "%second:~2,1%"=="," (
				set second=%second:~3%
			) else (
				set second=%second:~2%
			)
			call :compare "!recursfirst!" "!recurssecond!"
			if defined complete (
				if "!complete!"=="pass" (
					goto compareloop
				) else goto goodcompare
			) 
			if not defined complete goto badcompare
			goto compareloop
		)
	) else if not "%secondnum:[=%"=="%secondnum%" (
		set recursfirst=[%firstnum%]
		call :findbrackets "%second%" recurssecond
		if "%first:~2,1%"=="," (
			set first=%first:~3%
		) else (
			set first=%first:~2%
		)
		set second= !second!
		call set second=%%second: !recurssecond!,=%%
		if "!second!"==" %second%" (
			call set second=%%second: !recurssecond!=%%
		)
		call :compare "!recursfirst!" "!recurssecond!"
		if defined complete (
			if "!complete!"=="pass" (
				goto compareloop
			) else goto goodcompare
		) 
		if not defined complete goto badcompare
		goto compareloop
	)
	if %firstnum% lss %secondnum% (
		goto goodcompare
	) else if %firstnum% gtr %secondnum% (
		goto badcompare
	)
	if "%first:~2,1%"=="," (
		set first=%first:~3%
	) else (
		set first=%first:~2%
	)
	if "%second:~2,1%"=="," (
		set second=%second:~3%
	) else (
		set second=%second:~2%
	)
goto :compareloop
:badcompare
endlocal
set "complete="
exit /b
:goodcompare
endlocal
set complete=true
exit /b
:findbrackets <in> <out>
setlocal
set string=%~1
set string=%string: =%
set inc=1
set bracketcount=1
:bracketloop
	if "!string:~%inc%,1!"=="" ( pause&start cmd&exit rem close prompt
	) else if "!string:~%inc%,1!"=="[" ( set /a bracketcount+=1
	) else if "!string:~%inc%,1!"=="]" ( set /a bracketcount-=1
	)
	set /a inc+=1
if %bracketcount% gtr 0 goto bracketloop
set string=!string:~0,%inc%!
endlocal & set %2=%string%
exit /b